using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa uma análise de déficit de recursos consolidada
/// </summary>
[Table("Analise_Deficit")]
public class AnaliseDeficit : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Column("Data_Analise")]
    public DateTime DataAnalise { get; set; } = DateTime.Now;
    
    [Column("ID_Item")]
    public int? ItemEstoqueId { get; set; }
    
    [Required]
    [MaxLength(300)]
    [Column("Descricao_Item")]
    public string DescricaoItem { get; set; } = string.Empty;
    
    [Column("Demanda_Total")]
    public decimal DemandaTotal { get; set; }
    
    [Column("Estoque_Disponivel")]
    public decimal EstoqueDisponivel { get; set; }
    
    [Column("Deficit")]
    public decimal Deficit { get; set; }
    
    [MaxLength(50)]
    public string? Unidade { get; set; } = "UN";
    
    [Column("Recomendacao")]
    [MaxLength(50)]
    public string? Recomendacao { get; set; }
    
    [Column("Custo_Estimado", TypeName = "decimal(18,2)")]
    public decimal? CustoEstimado { get; set; }
    
    [MaxLength(1000)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Item do estoque analisado
    /// </summary>
    [ForeignKey("ItemEstoqueId")]
    public virtual ItemEstoque? ItemEstoque { get; set; }
    
    /// <summary>
    /// Verifica se há déficit
    /// </summary>
    public bool TemDeficit()
    {
        return Deficit > 0;
    }
    
    /// <summary>
    /// Calcula percentual de atendimento
    /// </summary>
    public decimal PercentualAtendimento()
    {
        if (DemandaTotal == 0)
            return 100m;
        
        return (EstoqueDisponivel / DemandaTotal) * 100m;
    }
}
