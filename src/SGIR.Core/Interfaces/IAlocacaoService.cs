using SGIR.Core.Entities;

namespace SGIR.Core.Interfaces;

/// <summary>
/// Interface para serviço de alocação de colaboradores
/// </summary>
public interface IAlocacaoService
{
    /// <summary>
    /// Aloca um colaborador em um projeto
    /// </summary>
    Task<AlocacaoPessoa> AlocarColaboradorAsync(int projetoId, string cpfColaborador, string? observacoes = null);
    
    /// <summary>
    /// Libera um colaborador de um projeto
    /// </summary>
    Task LiberarColaboradorAsync(int alocacaoId);
    
    /// <summary>
    /// Verifica se um colaborador pode ser alocado (está apto)
    /// </summary>
    Task<(bool PodeAlocar, List<string> Motivos)> VerificarAptoParaAlocacaoAsync(string cpfColaborador);
    
    /// <summary>
    /// Lista colaboradores aptos para uma função específica
    /// </summary>
    Task<List<Colaborador>> ListarColaboradoresAptosAsync(Enums.Funcao? funcao = null);
    
    /// <summary>
    /// Lista colaboradores inaptos e os motivos
    /// </summary>
    Task<Dictionary<Colaborador, List<string>>> ListarColaboradoresInaptosAsync();
    
    /// <summary>
    /// Obtém colaboradores alocados em um projeto
    /// </summary>
    Task<List<AlocacaoPessoa>> ObterAlocacoesPorProjetoAsync(int projetoId);
    
    /// <summary>
    /// Atualiza status geral de todos os colaboradores
    /// </summary>
    Task AtualizarStatusColaboradoresAsync();
}
