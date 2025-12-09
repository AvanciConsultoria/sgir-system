namespace SGIR.Core.Enums;

/// <summary>
/// Status geral de conformidade do colaborador
/// </summary>
public enum StatusGeral
{
    /// <summary>
    /// Todas as certificações válidas e apto para trabalho
    /// </summary>
    Apto = 1,
    
    /// <summary>
    /// Uma ou mais certificações vencidas ou documentos pendentes
    /// </summary>
    Inapto = 2,
    
    /// <summary>
    /// Certificações próximas do vencimento (alerta)
    /// </summary>
    Alerta = 3
}
