using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SGIR.Core.Enums;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa uma movimentação de estoque (entrada, saída, transferência)
/// </summary>
[Table("Movimentos_Estoque")]
public class MovimentoEstoque : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [Column("ID_Item")]
    public int ItemEstoqueId { get; set; }
    
    [Required]
    [Column("Tipo_Movimento")]
    public TipoMovimento TipoMovimento { get; set; }
    
    [Required]
    public decimal Quantidade { get; set; }
    
    [MaxLength(50)]
    public string? Unidade { get; set; } = "UN";
    
    [Column("Data_Movimento")]
    public DateTime DataMovimento { get; set; } = DateTime.Now;
    
    [Column("OS_ID")]
    public int? ProjetoId { get; set; }
    
    [MaxLength(200)]
    [Column("Local_Origem")]
    public string? LocalOrigem { get; set; }
    
    [MaxLength(200)]
    [Column("Local_Destino")]
    public string? LocalDestino { get; set; }
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    [MaxLength(100)]
    [Column("Responsavel")]
    public string? Responsavel { get; set; }
    
    /// <summary>
    /// Item do estoque movimentado
    /// </summary>
    [ForeignKey("ItemEstoqueId")]
    public virtual ItemEstoque? ItemEstoque { get; set; }
    
    /// <summary>
    /// Projeto associado (se movimento for para alocação em OS)
    /// </summary>
    [ForeignKey("ProjetoId")]
    public virtual Projeto? Projeto { get; set; }
}
