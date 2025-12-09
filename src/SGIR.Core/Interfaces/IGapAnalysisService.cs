using SGIR.Core.Entities;

namespace SGIR.Core.Interfaces;

/// <summary>
/// Interface para serviço de análise de gap (déficit) de recursos
/// </summary>
public interface IGapAnalysisService
{
    /// <summary>
    /// Realiza análise completa de déficit para todos os projetos ativos
    /// </summary>
    Task<List<AnaliseDeficit>> RealizarAnaliseCompletaAsync();
    
    /// <summary>
    /// Analisa déficit para um projeto específico
    /// </summary>
    Task<List<AnaliseDeficit>> AnalisarProjetoAsync(int projetoId);
    
    /// <summary>
    /// Calcula demanda consolidada de todos os projetos
    /// </summary>
    Task<Dictionary<string, decimal>> CalcularDemandaConsolidadaAsync();
    
    /// <summary>
    /// Verifica estoque disponível considerando observações (ex: "Temos na Renault")
    /// </summary>
    Task<decimal> CalcularEstoqueDisponivelAsync(int itemEstoqueId);
    
    /// <summary>
    /// Gera recomendações de compra baseadas no déficit
    /// </summary>
    Task<List<string>> GerarRecomendacoesAsync(AnaliseDeficit analise);
    
    /// <summary>
    /// Obtém itens críticos (estoque abaixo do mínimo)
    /// </summary>
    Task<List<ItemEstoque>> ObterItensCriticosAsync();
}
