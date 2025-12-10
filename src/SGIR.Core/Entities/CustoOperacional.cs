using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um custo operacional de um projeto
/// </summary>
[Table("Custos_Operacionais")]
public class CustoOperacional : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [Column("OS_ID")]
    public int ProjetoId { get; set; }
    
    [Required]
    [MaxLength(100)]
    [Column("Tipo_Custo")]
    public string TipoCusto { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(300)]
    public string Descricao { get; set; } = string.Empty;
    
    [Required]
    [Column("Valor_Unitario", TypeName = "decimal(18,2)")]
    public decimal ValorUnitario { get; set; }
    
    public decimal Quantidade { get; set; } = 1;
    
    [MaxLength(50)]
    public string? Unidade { get; set; } = "UN";
    
    [Column("Valor_Total", TypeName = "decimal(18,2)")]
    public decimal ValorTotal { get; set; }
    
    [Column("Data_Lancamento")]
    public DateTime DataLancamento { get; set; } = DateTime.Today;
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Projeto associado a este custo
    /// </summary>
    [ForeignKey("ProjetoId")]
    public virtual Projeto? Projeto { get; set; }
    
    /// <summary>
    /// Calcula o valor total baseado em quantidade * valor unitário
    /// </summary>
    public void CalcularValorTotal()
    {
        ValorTotal = ValorUnitario * Quantidade;
    }
}
