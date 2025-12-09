using SGIR.Core.Entities;
using SGIR.Core.Interfaces;

namespace SGIR.Core.Services;

/// <summary>
/// Serviço para análise de déficit (gap analysis) de recursos
/// </summary>
public class GapAnalysisService : IGapAnalysisService
{
    private readonly IUnitOfWork _unitOfWork;

    public GapAnalysisService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<List<AnaliseDeficit>> RealizarAnaliseCompletaAsync()
    {
        var projetos = await _unitOfWork.Projetos.FindAsync(p => p.Status != "Concluído" && p.Status != "Cancelado");
        var analises = new List<AnaliseDeficit>();

        // Calcula demanda consolidada
        var demandaConsolidada = await CalcularDemandaConsolidadaAsync();

        foreach (var demanda in demandaConsolidada)
        {
            var descricaoItem = demanda.Key;
            var quantidadeTotal = demanda.Value;

            // Busca item no estoque
            var item = await _unitOfWork.ItensEstoque
                .FirstOrDefaultAsync(i => i.Descricao.ToLower() == descricaoItem.ToLower());

            decimal estoqueDisponivel = 0;
            if (item != null)
            {
                estoqueDisponivel = await CalcularEstoqueDisponivelAsync(item.Id);
            }

            var deficit = Math.Max(0, quantidadeTotal - estoqueDisponivel);

            var analise = new AnaliseDeficit
            {
                DataAnalise = DateTime.Now,
                ItemEstoqueId = item?.Id,
                DescricaoItem = descricaoItem,
                DemandaTotal = quantidadeTotal,
                EstoqueDisponivel = estoqueDisponivel,
                Deficit = deficit,
                Unidade = item?.Unidade ?? "UN"
            };

            // Gera recomendações
            var recomendacoes = await GerarRecomendacoesAsync(analise);
            analise.Recomendacao = string.Join("; ", recomendacoes);

            // Estima custo
            if (item != null && item.ValorUnitario.HasValue && deficit > 0)
            {
                analise.CustoEstimado = deficit * item.ValorUnitario.Value;
            }

            analises.Add(analise);
            await _unitOfWork.AnalisesDeficit.AddAsync(analise);
        }

        await _unitOfWork.SaveChangesAsync();
        return analises;
    }

    public async Task<List<AnaliseDeficit>> AnalisarProjetoAsync(int projetoId)
    {
        var recursos = await _unitOfWork.RecursosNecessarios
            .FindAsync(r => r.ProjetoId == projetoId);

        var analises = new List<AnaliseDeficit>();

        foreach (var recurso in recursos)
        {
            var estoqueDisponivel = recurso.ItemEstoqueId.HasValue
                ? await CalcularEstoqueDisponivelAsync(recurso.ItemEstoqueId.Value)
                : 0;

            var deficit = Math.Max(0, recurso.QuantidadePendente - estoqueDisponivel);

            var analise = new AnaliseDeficit
            {
                DataAnalise = DateTime.Now,
                ItemEstoqueId = recurso.ItemEstoqueId,
                DescricaoItem = recurso.DescricaoRecurso,
                DemandaTotal = recurso.QuantidadePendente,
                EstoqueDisponivel = estoqueDisponivel,
                Deficit = deficit,
                Unidade = recurso.Unidade ?? "UN"
            };

            analises.Add(analise);
        }

        return analises;
    }

    public async Task<Dictionary<string, decimal>> CalcularDemandaConsolidadaAsync()
    {
        // Busca todos os recursos necessários de projetos ativos
        var recursos = await _unitOfWork.RecursosNecessarios.GetAllAsync();
        
        var projetosAtivos = await _unitOfWork.Projetos
            .FindAsync(p => p.Status != "Concluído" && p.Status != "Cancelado");
        
        var projetosAtivosIds = projetosAtivos.Select(p => p.Id).ToHashSet();

        // Agrupa por descrição e soma as quantidades
        var demandaConsolidada = recursos
            .Where(r => projetosAtivosIds.Contains(r.ProjetoId))
            .GroupBy(r => r.DescricaoRecurso.ToLower())
            .ToDictionary(
                g => g.Key,
                g => g.Sum(r => r.QuantidadePendente)
            );

        return demandaConsolidada;
    }

    public async Task<decimal> CalcularEstoqueDisponivelAsync(int itemEstoqueId)
    {
        var item = await _unitOfWork.ItensEstoque.GetByIdAsync(itemEstoqueId);
        if (item == null)
            return 0;

        var estoqueDisponivel = item.EstoqueAtual;

        // Considera quantidade em outros locais mencionada nas observações
        // Exemplo: "Temos na Renault (3 confirmar)"
        estoqueDisponivel += item.QuantidadeOutrosLocais;

        return estoqueDisponivel;
    }

    public async Task<List<string>> GerarRecomendacoesAsync(AnaliseDeficit analise)
    {
        var recomendacoes = new List<string>();

        if (analise.Deficit == 0)
        {
            recomendacoes.Add("Estoque suficiente");
            return recomendacoes;
        }

        var item = analise.ItemEstoqueId.HasValue
            ? await _unitOfWork.ItensEstoque.GetByIdAsync(analise.ItemEstoqueId.Value)
            : null;

        if (item != null)
        {
            // Verifica se pode alugar
            if (item.PodeAlugar)
            {
                recomendacoes.Add($"Alugar {analise.Deficit} {analise.Unidade}");
            }

            // Verifica intenção de compra
            if (item.IntencaoCompra)
            {
                recomendacoes.Add($"Comprar {analise.Deficit} {analise.Unidade} (intenção de compra registrada)");
            }
            else
            {
                recomendacoes.Add($"Comprar {analise.Deficit} {analise.Unidade}");
            }

            // Verifica se há quantidade a confirmar em outros locais
            if (item.QuantidadeOutrosLocais > 0)
            {
                recomendacoes.Add($"Confirmar disponibilidade de {item.QuantidadeOutrosLocais} unidades em outros locais");
            }
        }
        else
        {
            recomendacoes.Add($"Adquirir {analise.Deficit} {analise.Unidade}");
        }

        return recomendacoes;
    }

    public async Task<List<ItemEstoque>> ObterItensCriticosAsync()
    {
        var itens = await _unitOfWork.ItensEstoque.GetAllAsync();
        
        return itens
            .Where(i => i.EstoqueAbaixoMinimo())
            .OrderBy(i => i.EstoqueAtual)
            .ToList();
    }
}
