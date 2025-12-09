using SGIR.Core.Entities;

namespace SGIR.Core.Interfaces;

/// <summary>
/// Interface para serviço de automação de compras
/// </summary>
public interface ICompraAutomacaoService
{
    /// <summary>
    /// Gera sugestões de compra automáticas baseadas na análise de déficit
    /// </summary>
    Task<List<CompraAutomatica>> GerarSugestoesCompraAsync();
    
    /// <summary>
    /// Processa uma análise de déficit e cria compra automática se necessário
    /// </summary>
    Task<CompraAutomatica?> ProcessarAnaliseDeficitAsync(AnaliseDeficit analise);
    
    /// <summary>
    /// Determina o tipo de aquisição (compra ou aluguel) baseado nas observações
    /// </summary>
    string DeterminarTipoAquisicao(ItemEstoque item);
    
    /// <summary>
    /// Gera checklist de EPIs para "CAIXA DE FERRAMENTA COMPLETA"
    /// </summary>
    Task<List<string>> GerarChecklistEPIsAsync();
    
    /// <summary>
    /// Aprova uma compra automática
    /// </summary>
    Task AprovarCompraAsync(int compraId);
    
    /// <summary>
    /// Registra compra realizada
    /// </summary>
    Task RegistrarCompraRealizadaAsync(int compraId, string fornecedor, string numeroPedido);
    
    /// <summary>
    /// Registra recebimento de compra
    /// </summary>
    Task RegistrarRecebimentoAsync(int compraId);
    
    /// <summary>
    /// Lista compras pendentes de aprovação
    /// </summary>
    Task<List<CompraAutomatica>> ListarComprasPendentesAsync();
}
