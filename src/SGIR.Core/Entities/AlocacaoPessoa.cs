using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa a alocação de um colaborador em um projeto
/// </summary>
[Table("Alocacao_Pessoas")]
public class AlocacaoPessoa : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [Column("OS_ID")]
    public int ProjetoId { get; set; }
    
    [Required]
    [MaxLength(14)]
    [Column("CPF_Colaborador")]
    public string CpfColaborador { get; set; } = string.Empty;
    
    [Column("Data_Alocacao")]
    public DateTime DataAlocacao { get; set; } = DateTime.Today;
    
    [Column("Data_Liberacao")]
    public DateTime? DataLiberacao { get; set; }
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    [MaxLength(50)]
    public string Status { get; set; } = "Ativo";
    
    /// <summary>
    /// Projeto onde o colaborador está alocado
    /// </summary>
    [ForeignKey("ProjetoId")]
    public virtual Projeto? Projeto { get; set; }
    
    /// <summary>
    /// Colaborador alocado
    /// </summary>
    [ForeignKey("CpfColaborador")]
    public virtual Colaborador? Colaborador { get; set; }
    
    /// <summary>
    /// Verifica se a alocação está ativa
    /// </summary>
    public bool EstaAtivo()
    {
        return Status == "Ativo" && DataLiberacao == null;
    }
    
    /// <summary>
    /// Calcula dias de alocação
    /// </summary>
    public int DiasAlocacao()
    {
        var dataFim = DataLiberacao ?? DateTime.Today;
        return (dataFim - DataAlocacao).Days;
    }
}
