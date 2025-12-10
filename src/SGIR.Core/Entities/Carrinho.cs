using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um carrinho (agrupamento de caixas e máquinas)
/// </summary>
[Table("Carrinhos")]
public class Carrinho : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string Codigo { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(200)]
    public string Descricao { get; set; } = string.Empty;
    
    [MaxLength(200)]
    [Column("Local_Atual")]
    public string? LocalAtual { get; set; }
    
    [Column("ID_Projeto")]
    public int? ProjetoId { get; set; }
    
    public bool Ativo { get; set; } = true;
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Projeto ao qual o carrinho está alocado
    /// </summary>
    [ForeignKey("ProjetoId")]
    public virtual Projeto? Projeto { get; set; }
    
    /// <summary>
    /// Itens contidos no carrinho (caixas, máquinas, etc)
    /// </summary>
    public virtual ICollection<CarrinhoItem> Itens { get; set; } = new List<CarrinhoItem>();
}

/// <summary>
/// Item de um carrinho (pode ser caixa, máquina ou item avulso)
/// </summary>
[Table("Carrinhos_Itens")]
public class CarrinhoItem : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [Column("ID_Carrinho")]
    public int CarrinhoId { get; set; }
    
    [Required]
    [MaxLength(50)]
    [Column("Tipo_Item")]
    public string TipoItem { get; set; } = "ITEM"; // ITEM, CAIXA, MAQUINA
    
    [Column("ID_Item")]
    public int? ItemEstoqueId { get; set; }
    
    [Column("ID_Caixa")]
    public int? CaixaId { get; set; }
    
    public decimal? Quantidade { get; set; }
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    [ForeignKey("CarrinhoId")]
    public virtual Carrinho? Carrinho { get; set; }
    
    [ForeignKey("ItemEstoqueId")]
    public virtual ItemEstoque? Item { get; set; }
    
    [ForeignKey("CaixaId")]
    public virtual CaixaFerramentas? Caixa { get; set; }
}
