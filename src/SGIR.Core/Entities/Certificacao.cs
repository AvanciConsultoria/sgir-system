using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa as certificações obrigatórias de um colaborador
/// </summary>
[Table("Certificacoes")]
public class Certificacao : BaseEntity
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(14)]
    [Column("CPF_Colaborador")]
    public string CpfColaborador { get; set; } = string.Empty;
    
    [Column("NR10_Validade")]
    public DateTime? NR10Validade { get; set; }
    
    [Column("NR12_Validade")]
    public DateTime? NR12Validade { get; set; }
    
    [Column("LOTO_Validade")]
    public DateTime? LOTOValidade { get; set; }
    
    [Column("NR35_Validade")]
    public DateTime? NR35Validade { get; set; }
    
    [Column("ASO_Validade")]
    public DateTime? ASOValidade { get; set; }
    
    /// <summary>
    /// Colaborador associado
    /// </summary>
    [ForeignKey("CpfColaborador")]
    public virtual Colaborador? Colaborador { get; set; }
    
    /// <summary>
    /// Verifica se todas as certificações obrigatórias estão válidas
    /// </summary>
    /// <returns>True se todas as certificações estão dentro da validade</returns>
    public bool EstaValido()
    {
        var hoje = DateTime.Today;
        
        // ASO é obrigatório para todos
        if (ASOValidade == null || ASOValidade.Value < hoje)
            return false;
        
        // Verifica outras certificações se existem
        if (NR10Validade.HasValue && NR10Validade.Value < hoje)
            return false;
        
        if (NR12Validade.HasValue && NR12Validade.Value < hoje)
            return false;
        
        if (LOTOValidade.HasValue && LOTOValidade.Value < hoje)
            return false;
        
        if (NR35Validade.HasValue && NR35Validade.Value < hoje)
            return false;
        
        return true;
    }
    
    /// <summary>
    /// Verifica se alguma certificação está próxima do vencimento
    /// </summary>
    /// <param name="diasAntecedencia">Dias de antecedência para alerta</param>
    /// <returns>True se alguma certificação vence nos próximos X dias</returns>
    public bool TemCertificacaoProximaVencimento(int diasAntecedencia)
    {
        var dataLimite = DateTime.Today.AddDays(diasAntecedencia);
        
        return (ASOValidade.HasValue && ASOValidade.Value <= dataLimite) ||
               (NR10Validade.HasValue && NR10Validade.Value <= dataLimite) ||
               (NR12Validade.HasValue && NR12Validade.Value <= dataLimite) ||
               (LOTOValidade.HasValue && LOTOValidade.Value <= dataLimite) ||
               (NR35Validade.HasValue && NR35Validade.Value <= dataLimite);
    }
    
    /// <summary>
    /// Retorna lista de certificações vencidas
    /// </summary>
    public List<string> ObterCertificacoesVencidas()
    {
        var vencidas = new List<string>();
        var hoje = DateTime.Today;
        
        if (ASOValidade == null || ASOValidade.Value < hoje)
            vencidas.Add("ASO");
        
        if (NR10Validade.HasValue && NR10Validade.Value < hoje)
            vencidas.Add("NR-10");
        
        if (NR12Validade.HasValue && NR12Validade.Value < hoje)
            vencidas.Add("NR-12");
        
        if (LOTOValidade.HasValue && LOTOValidade.Value < hoje)
            vencidas.Add("LOTO");
        
        if (NR35Validade.HasValue && NR35Validade.Value < hoje)
            vencidas.Add("NR-35");
        
        return vencidas;
    }
}
