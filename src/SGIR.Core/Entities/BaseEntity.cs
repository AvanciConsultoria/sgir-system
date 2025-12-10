using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Classe base para todas as entidades do sistema
/// </summary>
public abstract class BaseEntity
{
    /// <summary>
    /// Data de criação do registro
    /// </summary>
    [Column("DataCriacao")]
    public DateTime DataCriacao { get; set; } = DateTime.Now;
    
    /// <summary>
    /// Data da última atualização do registro
    /// </summary>
    [Column("DataAtualizacao")]
    public DateTime DataAtualizacao { get; set; } = DateTime.Now;
}
