using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa uma caixa de ferramentas (agrupamento de itens)
/// </summary>
[Table("Caixas_Ferramentas")]
public class CaixaFerramentas : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string Codigo { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(200)]
    public string Descricao { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(50)]
    public string Tipo { get; set; } = "MECANICA"; // MECANICA, ELETRICA, GERAL
    
    [MaxLength(200)]
    [Column("Local_Atual")]
    public string? LocalAtual { get; set; }
    
    public bool Ativo { get; set; } = true;
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Itens contidos nesta caixa
    /// </summary>
    public virtual ICollection<CaixaItem> Itens { get; set; } = new List<CaixaItem>();
    
    /// <summary>
    /// Carrinhos que contêm esta caixa
    /// </summary>
    public virtual ICollection<CarrinhoItem> CarrinhosQueContem { get; set; } = new List<CarrinhoItem>();
}

/// <summary>
/// Relação entre Caixa e Item (com quantidade)
/// </summary>
[Table("Caixas_Itens")]
public class CaixaItem : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [Column("ID_Caixa")]
    public int CaixaId { get; set; }
    
    [Required]
    [Column("ID_Item")]
    public int ItemEstoqueId { get; set; }
    
    [Required]
    public decimal Quantidade { get; set; }
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    [ForeignKey("CaixaId")]
    public virtual CaixaFerramentas? Caixa { get; set; }
    
    [ForeignKey("ItemEstoqueId")]
    public virtual ItemEstoque? Item { get; set; }
}
