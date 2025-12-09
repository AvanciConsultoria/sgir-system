using SGIR.Core.Entities;
using SGIR.Core.Enums;
using SGIR.Core.Interfaces;

namespace SGIR.Core.Services;

/// <summary>
/// Serviço para automação de compras baseado na análise de déficit
/// </summary>
public class CompraAutomacaoService : ICompraAutomacaoService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IGapAnalysisService _gapAnalysisService;

    public CompraAutomacaoService(IUnitOfWork unitOfWork, IGapAnalysisService gapAnalysisService)
    {
        _unitOfWork = unitOfWork;
        _gapAnalysisService = gapAnalysisService;
    }

    public async Task<List<CompraAutomatica>> GerarSugestoesCompraAsync()
    {
        // Realiza análise completa de déficit
        var analises = await _gapAnalysisService.RealizarAnaliseCompletaAsync();
        
        var compras = new List<CompraAutomatica>();

        foreach (var analise in analises.Where(a => a.TemDeficit()))
        {
            var compra = await ProcessarAnaliseDeficitAsync(analise);
            if (compra != null)
            {
                compras.Add(compra);
            }
        }

        return compras;
    }

    public async Task<CompraAutomatica?> ProcessarAnaliseDeficitAsync(AnaliseDeficit analise)
    {
        if (!analise.TemDeficit())
            return null;

        var item = analise.ItemEstoqueId.HasValue
            ? await _unitOfWork.ItensEstoque.GetByIdAsync(analise.ItemEstoqueId.Value)
            : null;

        var compra = new CompraAutomatica
        {
            AnaliseDeficitId = analise.Id,
            ItemEstoqueId = analise.ItemEstoqueId,
            DescricaoItem = analise.DescricaoItem,
            Quantidade = analise.Deficit,
            Unidade = analise.Unidade,
            ValorEstimado = analise.CustoEstimado,
            Status = StatusCompra.Pendente,
            DataGeracao = DateTime.Now
        };

        // Determina tipo de aquisição
        if (item != null)
        {
            compra.TipoAquisicao = DeterminarTipoAquisicao(item);
            
            // Adiciona observações relevantes
            var observacoes = new List<string>();
            
            if (item.PodeAlugar)
                observacoes.Add("Item disponível para aluguel");
            
            if (item.IntencaoCompra)
                observacoes.Add("Há intenção de compra deste item");
            
            if (item.QuantidadeOutrosLocais > 0)
                observacoes.Add($"Verificar {item.QuantidadeOutrosLocais} unidades em outros locais antes de comprar");
            
            if (item.OBS != null)
                observacoes.Add($"OBS Original: {item.OBS}");
            
            compra.Observacoes = string.Join("; ", observacoes);
        }

        // Se for "CAIXA DE FERRAMENTA COMPLETA", anexa checklist de EPIs
        if (analise.DescricaoItem.Contains("CAIXA DE FERRAMENTA COMPLETA", StringComparison.OrdinalIgnoreCase) ||
            analise.DescricaoItem.Contains("KIT FERRAMENTAS", StringComparison.OrdinalIgnoreCase))
        {
            var checklist = await GerarChecklistEPIsAsync();
            var checklistTexto = "CHECKLIST EPIs:\n" + string.Join("\n", checklist.Select(c => $"- {c}"));
            compra.Observacoes = (compra.Observacoes ?? "") + "\n\n" + checklistTexto;
        }

        await _unitOfWork.ComprasAutomaticas.AddAsync(compra);
        await _unitOfWork.SaveChangesAsync();

        return compra;
    }

    public string DeterminarTipoAquisicao(ItemEstoque item)
    {
        // Prioriza aluguel se mencionado nas observações
        if (item.PodeAlugar)
            return "Aluguel";

        // Verifica intenção de compra
        if (item.IntencaoCompra)
            return "Compra (Planejada)";

        // Padrão é compra
        return "Compra";
    }

    public async Task<List<string>> GerarChecklistEPIsAsync()
    {
        // Checklist padrão de EPIs para caixa de ferramentas completa
        return await Task.FromResult(new List<string>
        {
            "Capacete de segurança com jugular",
            "Óculos de proteção (incolor e escuro)",
            "Luvas de segurança (couro e isolante)",
            "Luvas de raspa para soldagem",
            "Protetor auricular (tipo concha ou plug)",
            "Máscara de proteção respiratória PFF2/N95",
            "Cinto de segurança tipo paraquedista com talabarte",
            "Trava-quedas",
            "Calçado de segurança (botina com bico de aço)",
            "Uniforme completo (calça e camisa manga longa)",
            "Protetor solar FPS 50+",
            "Mangote de proteção",
            "Perneira de segurança",
            "Avental de raspa para soldagem",
            "Máscara de solda com lente de proteção",
            "Luva isolante de borracha classe 2 (para trabalhos em alta tensão)",
            "Detector de tensão",
            "Kit primeiros socorros",
            "Cones de sinalização",
            "Fita zebrada de isolamento"
        });
    }

    public async Task AprovarCompraAsync(int compraId)
    {
        var compra = await _unitOfWork.ComprasAutomaticas.GetByIdAsync(compraId);
        if (compra == null)
            throw new ArgumentException($"Compra com ID {compraId} não encontrada");

        compra.Aprovar();
        await _unitOfWork.ComprasAutomaticas.UpdateAsync(compra);
        await _unitOfWork.SaveChangesAsync();
    }

    public async Task RegistrarCompraRealizadaAsync(int compraId, string fornecedor, string numeroPedido)
    {
        var compra = await _unitOfWork.ComprasAutomaticas.GetByIdAsync(compraId);
        if (compra == null)
            throw new ArgumentException($"Compra com ID {compraId} não encontrada");

        compra.RegistrarCompra(fornecedor, numeroPedido);
        await _unitOfWork.ComprasAutomaticas.UpdateAsync(compra);
        await _unitOfWork.SaveChangesAsync();
    }

    public async Task RegistrarRecebimentoAsync(int compraId)
    {
        var compra = await _unitOfWork.ComprasAutomaticas.GetByIdAsync(compraId);
        if (compra == null)
            throw new ArgumentException($"Compra com ID {compraId} não encontrada");

        compra.RegistrarRecebimento();
        await _unitOfWork.ComprasAutomaticas.UpdateAsync(compra);

        // Atualiza estoque se item estiver vinculado
        if (compra.ItemEstoqueId.HasValue)
        {
            var item = await _unitOfWork.ItensEstoque.GetByIdAsync(compra.ItemEstoqueId.Value);
            if (item != null)
            {
                item.EstoqueAtual += compra.Quantidade;
                await _unitOfWork.ItensEstoque.UpdateAsync(item);

                // Registra movimento de entrada
                var movimento = new MovimentoEstoque
                {
                    ItemEstoqueId = item.Id,
                    TipoMovimento = TipoMovimento.Entrada,
                    Quantidade = compra.Quantidade,
                    Unidade = compra.Unidade,
                    DataMovimento = DateTime.Now,
                    Observacoes = $"Recebimento de compra #{compra.Id} - {compra.NumeroPedido}",
                    Responsavel = "Sistema"
                };

                await _unitOfWork.MovimentosEstoque.AddAsync(movimento);
            }
        }

        await _unitOfWork.SaveChangesAsync();
    }

    public async Task<List<CompraAutomatica>> ListarComprasPendentesAsync()
    {
        var compras = await _unitOfWork.ComprasAutomaticas
            .FindAsync(c => c.Status == StatusCompra.Pendente);
        
        return compras
            .OrderByDescending(c => c.DataGeracao)
            .ToList();
    }
}
