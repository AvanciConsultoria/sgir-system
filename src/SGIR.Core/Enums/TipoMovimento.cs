namespace SGIR.Core.Enums;

/// <summary>
/// Tipos de movimento de estoque
/// </summary>
public enum TipoMovimento
{
    /// <summary>
    /// Entrada de item no estoque (compra, devolução)
    /// </summary>
    Entrada = 1,
    
    /// <summary>
    /// Saída de item do estoque (alocação em OS, perda)
    /// </summary>
    Saida = 2,
    
    /// <summary>
    /// Transferência entre locais
    /// </summary>
    Transferencia = 3,
    
    /// <summary>
    /// Ajuste de inventário
    /// </summary>
    Ajuste = 4
}
