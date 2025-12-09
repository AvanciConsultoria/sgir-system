namespace SGIR.Core.Enums;

/// <summary>
/// Status do processo de compra
/// </summary>
public enum StatusCompra
{
    /// <summary>
    /// Compra pendente de aprovação
    /// </summary>
    Pendente = 1,
    
    /// <summary>
    /// Compra aprovada, aguardando cotação
    /// </summary>
    Aprovada = 2,
    
    /// <summary>
    /// Pedido realizado ao fornecedor
    /// </summary>
    Comprado = 3,
    
    /// <summary>
    /// Item recebido no almoxarifado
    /// </summary>
    Recebido = 4,
    
    /// <summary>
    /// Compra cancelada
    /// </summary>
    Cancelada = 5
}
