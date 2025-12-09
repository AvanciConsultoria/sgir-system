using SGIR.Core.Entities;
using SGIR.Core.Enums;
using SGIR.Core.Interfaces;

namespace SGIR.Core.Services;

/// <summary>
/// Serviço para gerenciamento de alocação de colaboradores em projetos
/// </summary>
public class AlocacaoService : IAlocacaoService
{
    private readonly IUnitOfWork _unitOfWork;

    public AlocacaoService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<AlocacaoPessoa> AlocarColaboradorAsync(int projetoId, string cpfColaborador, string? observacoes = null)
    {
        // Valida se o projeto existe
        var projeto = await _unitOfWork.Projetos.GetByIdAsync(projetoId);
        if (projeto == null)
            throw new ArgumentException($"Projeto com ID {projetoId} não encontrado");

        // Valida se o colaborador existe
        var colaborador = await _unitOfWork.Colaboradores.GetByIdAsync(cpfColaborador);
        if (colaborador == null)
            throw new ArgumentException($"Colaborador com CPF {cpfColaborador} não encontrado");

        // Verifica se o colaborador está apto
        var (podeAlocar, motivos) = await VerificarAptoParaAlocacaoAsync(cpfColaborador);
        if (!podeAlocar)
            throw new InvalidOperationException($"Colaborador não pode ser alocado. Motivos: {string.Join(", ", motivos)}");

        // Cria a alocação
        var alocacao = new AlocacaoPessoa
        {
            ProjetoId = projetoId,
            CpfColaborador = cpfColaborador,
            DataAlocacao = DateTime.Today,
            Observacoes = observacoes,
            Status = "Ativo"
        };

        await _unitOfWork.AlocacoesPessoas.AddAsync(alocacao);
        await _unitOfWork.SaveChangesAsync();

        return alocacao;
    }

    public async Task LiberarColaboradorAsync(int alocacaoId)
    {
        var alocacao = await _unitOfWork.AlocacoesPessoas.GetByIdAsync(alocacaoId);
        if (alocacao == null)
            throw new ArgumentException($"Alocação com ID {alocacaoId} não encontrada");

        alocacao.DataLiberacao = DateTime.Today;
        alocacao.Status = "Liberado";

        await _unitOfWork.AlocacoesPessoas.UpdateAsync(alocacao);
        await _unitOfWork.SaveChangesAsync();
    }

    public async Task<(bool PodeAlocar, List<string> Motivos)> VerificarAptoParaAlocacaoAsync(string cpfColaborador)
    {
        var colaborador = await _unitOfWork.Colaboradores.GetByIdAsync(cpfColaborador);
        if (colaborador == null)
            return (false, new List<string> { "Colaborador não encontrado" });

        var motivos = new List<string>();

        // Verifica status geral
        if (colaborador.StatusGeral == StatusGeral.Inapto)
        {
            motivos.Add("Status geral: Inapto");
        }

        // Verifica certificações
        var certificacao = await _unitOfWork.Certificacoes
            .FirstOrDefaultAsync(c => c.CpfColaborador == cpfColaborador);

        if (certificacao == null)
        {
            motivos.Add("Certificações não cadastradas");
            return (false, motivos);
        }

        if (!certificacao.EstaValido())
        {
            var certVencidas = certificacao.ObterCertificacoesVencidas();
            motivos.Add($"Certificações vencidas: {string.Join(", ", certVencidas)}");
        }

        return (motivos.Count == 0, motivos);
    }

    public async Task<List<Colaborador>> ListarColaboradoresAptosAsync(Funcao? funcao = null)
    {
        var colaboradores = await _unitOfWork.Colaboradores.GetAllAsync();
        
        var aptos = colaboradores
            .Where(c => c.StatusGeral == StatusGeral.Apto);

        if (funcao.HasValue)
            aptos = aptos.Where(c => c.Funcao == funcao.Value);

        return aptos.ToList();
    }

    public async Task<Dictionary<Colaborador, List<string>>> ListarColaboradoresInaptosAsync()
    {
        var colaboradores = await _unitOfWork.Colaboradores.GetAllAsync();
        var inaptos = new Dictionary<Colaborador, List<string>>();

        foreach (var colaborador in colaboradores.Where(c => c.StatusGeral != StatusGeral.Apto))
        {
            var (_, motivos) = await VerificarAptoParaAlocacaoAsync(colaborador.Cpf);
            inaptos[colaborador] = motivos;
        }

        return inaptos;
    }

    public async Task<List<AlocacaoPessoa>> ObterAlocacoesPorProjetoAsync(int projetoId)
    {
        var alocacoes = await _unitOfWork.AlocacoesPessoas
            .FindAsync(a => a.ProjetoId == projetoId && a.Status == "Ativo");
        
        return alocacoes.ToList();
    }

    public async Task AtualizarStatusColaboradoresAsync()
    {
        var colaboradores = await _unitOfWork.Colaboradores.GetAllAsync();

        foreach (var colaborador in colaboradores)
        {
            colaborador.AtualizarStatusGeral();
            await _unitOfWork.Colaboradores.UpdateAsync(colaborador);
        }

        await _unitOfWork.SaveChangesAsync();
    }
}
