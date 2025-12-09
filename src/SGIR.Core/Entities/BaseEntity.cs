namespace SGIR.Core.Entities;

/// <summary>
/// Classe base para todas as entidades do sistema
/// </summary>
public abstract class BaseEntity
{
    /// <summary>
    /// Data de criação do registro
    /// </summary>
    public DateTime DataCriacao { get; set; } = DateTime.Now;
    
    /// <summary>
    /// Data da última atualização do registro
    /// </summary>
    public DateTime? DataAtualizacao { get; set; }
    
    /// <summary>
    /// Usuário que criou o registro
    /// </summary>
    public string? CriadoPor { get; set; }
    
    /// <summary>
    /// Usuário que realizou a última atualização
    /// </summary>
    public string? AtualizadoPor { get; set; }
}
