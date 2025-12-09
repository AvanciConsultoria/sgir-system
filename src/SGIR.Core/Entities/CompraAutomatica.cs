using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SGIR.Core.Enums;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa uma sugestão/solicitação de compra automática gerada pelo sistema
/// </summary>
[Table("Compras_Automaticas")]
public class CompraAutomatica : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Column("ID_Analise")]
    public int? AnaliseDeficitId { get; set; }
    
    [Column("ID_Item")]
    public int? ItemEstoqueId { get; set; }
    
    [Required]
    [MaxLength(300)]
    [Column("Descricao_Item")]
    public string DescricaoItem { get; set; } = string.Empty;
    
    [Required]
    [Column("Quantidade")]
    public decimal Quantidade { get; set; }
    
    [MaxLength(50)]
    public string? Unidade { get; set; } = "UN";
    
    [MaxLength(50)]
    [Column("Tipo_Aquisicao")]
    public string TipoAquisicao { get; set; } = "Compra";
    
    [Column(TypeName = "decimal(18,2)")]
    [Column("Valor_Estimado")]
    public decimal? ValorEstimado { get; set; }
    
    [Required]
    [Column("Status")]
    public StatusCompra Status { get; set; } = StatusCompra.Pendente;
    
    [Column("Data_Geracao")]
    public DateTime DataGeracao { get; set; } = DateTime.Now;
    
    [Column("Data_Aprovacao")]
    public DateTime? DataAprovacao { get; set; }
    
    [Column("Data_Compra")]
    public DateTime? DataCompra { get; set; }
    
    [Column("Data_Recebimento")]
    public DateTime? DataRecebimento { get; set; }
    
    [MaxLength(200)]
    public string? Fornecedor { get; set; }
    
    [MaxLength(100)]
    [Column("Numero_Pedido")]
    public string? NumeroPedido { get; set; }
    
    [MaxLength(1000)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Análise de déficit que originou esta compra
    /// </summary>
    [ForeignKey("AnaliseDeficitId")]
    public virtual AnaliseDeficit? AnaliseDeficit { get; set; }
    
    /// <summary>
    /// Item do estoque a ser comprado
    /// </summary>
    [ForeignKey("ItemEstoqueId")]
    public virtual ItemEstoque? ItemEstoque { get; set; }
    
    /// <summary>
    /// Verifica se a compra está pendente de aprovação
    /// </summary>
    public bool EstaPendente()
    {
        return Status == StatusCompra.Pendente;
    }
    
    /// <summary>
    /// Aprova a compra
    /// </summary>
    public void Aprovar()
    {
        Status = StatusCompra.Aprovada;
        DataAprovacao = DateTime.Now;
    }
    
    /// <summary>
    /// Registra a compra realizada
    /// </summary>
    public void RegistrarCompra(string fornecedor, string numeroPedido)
    {
        Status = StatusCompra.Comprado;
        DataCompra = DateTime.Now;
        Fornecedor = fornecedor;
        NumeroPedido = numeroPedido;
    }
    
    /// <summary>
    /// Registra recebimento do item
    /// </summary>
    public void RegistrarRecebimento()
    {
        Status = StatusCompra.Recebido;
        DataRecebimento = DateTime.Now;
    }
}
