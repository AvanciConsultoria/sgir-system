using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um recurso necessário para um projeto
/// </summary>
[Table("Recursos_Necessarios")]
public class RecursoNecessario : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [Column("OS_ID")]
    public int ProjetoId { get; set; }
    
    [Column("ID_Item")]
    public int? ItemEstoqueId { get; set; }
    
    [Required]
    [MaxLength(300)]
    [Column("Descricao_Recurso")]
    public string DescricaoRecurso { get; set; } = string.Empty;
    
    [Required]
    [Column("Quantidade_Necessaria")]
    public decimal QuantidadeNecessaria { get; set; }
    
    [Column("Quantidade_Alocada")]
    public decimal QuantidadeAlocada { get; set; } = 0;
    
    [MaxLength(50)]
    public string? Unidade { get; set; } = "UN";
    
    [Column("Data_Necessidade")]
    public DateTime? DataNecessidade { get; set; }
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Projeto que necessita deste recurso
    /// </summary>
    [ForeignKey("ProjetoId")]
    public virtual Projeto? Projeto { get; set; }
    
    /// <summary>
    /// Item do estoque associado
    /// </summary>
    [ForeignKey("ItemEstoqueId")]
    public virtual ItemEstoque? ItemEstoque { get; set; }
    
    /// <summary>
    /// Calcula a quantidade pendente de alocação
    /// </summary>
    [NotMapped]
    public decimal QuantidadePendente => QuantidadeNecessaria - QuantidadeAlocada;
    
    /// <summary>
    /// Verifica se o recurso está totalmente alocado
    /// </summary>
    public bool EstaTotalmenteAlocado()
    {
        return QuantidadeAlocada >= QuantidadeNecessaria;
    }
}
