using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um EPI (Equipamento de Proteção Individual) de um colaborador
/// </summary>
[Table("EPIs")]
public class EPI : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(14)]
    [Column("CPF_Colaborador")]
    public string CpfColaborador { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(200)]
    [Column("Tipo_EPI")]
    public string TipoEPI { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(100)]
    public string CA { get; set; } = string.Empty;
    
    [Column("Data_Entrega")]
    public DateTime DataEntrega { get; set; } = DateTime.Today;
    
    [Column("Validade_CA")]
    public DateTime? ValidadeCA { get; set; }
    
    [Column("Vida_Util_Dias")]
    public int? VidaUtilDias { get; set; }
    
    [MaxLength(500)]
    public string? Observacoes { get; set; }
    
    /// <summary>
    /// Colaborador que possui este EPI
    /// </summary>
    [ForeignKey("CpfColaborador")]
    public virtual Colaborador? Colaborador { get; set; }
    
    /// <summary>
    /// Verifica se o EPI está dentro da validade
    /// </summary>
    public bool EstaValido()
    {
        var hoje = DateTime.Today;
        
        // Verifica validade do CA
        if (ValidadeCA.HasValue && ValidadeCA.Value < hoje)
            return false;
        
        // Verifica vida útil
        if (VidaUtilDias.HasValue)
        {
            var dataVencimento = DataEntrega.AddDays(VidaUtilDias.Value);
            if (dataVencimento < hoje)
                return false;
        }
        
        return true;
    }
    
    /// <summary>
    /// Calcula dias restantes até o vencimento
    /// </summary>
    public int DiasRestantes()
    {
        var hoje = DateTime.Today;
        DateTime? dataVencimento = null;
        
        if (ValidadeCA.HasValue)
            dataVencimento = ValidadeCA.Value;
        
        if (VidaUtilDias.HasValue)
        {
            var vencimentoVidaUtil = DataEntrega.AddDays(VidaUtilDias.Value);
            if (dataVencimento == null || vencimentoVidaUtil < dataVencimento)
                dataVencimento = vencimentoVidaUtil;
        }
        
        if (dataVencimento == null)
            return int.MaxValue;
        
        return (dataVencimento.Value - hoje).Days;
    }
}
