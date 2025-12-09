using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SGIR.Core.Enums;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um colaborador da empresa
/// </summary>
[Table("Colaboradores")]
public class Colaborador : BaseEntity
{
    [Key]
    [MaxLength(14)]
    [Column("CPF")]
    public string Cpf { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(200)]
    public string Nome { get; set; } = string.Empty;
    
    [Required]
    [Column("Funcao")]
    public Funcao Funcao { get; set; }
    
    [MaxLength(200)]
    public string? Email { get; set; }
    
    [MaxLength(20)]
    public string? Telefone { get; set; }
    
    [Column("Data_Admissao")]
    public DateTime? DataAdmissao { get; set; }
    
    [Column("Status_Geral")]
    public StatusGeral StatusGeral { get; set; } = StatusGeral.Inapto;
    
    /// <summary>
    /// Certificações do colaborador
    /// </summary>
    public virtual Certificacao? Certificacao { get; set; }
    
    /// <summary>
    /// EPIs do colaborador
    /// </summary>
    public virtual ICollection<EPI> EPIs { get; set; } = new List<EPI>();
    
    /// <summary>
    /// Alocações em projetos
    /// </summary>
    public virtual ICollection<AlocacaoPessoa> Alocacoes { get; set; } = new List<AlocacaoPessoa>();
    
    /// <summary>
    /// Verifica se o colaborador está apto para trabalhar
    /// </summary>
    /// <returns>True se todas as certificações estão válidas</returns>
    public bool EstaApto()
    {
        return StatusGeral == StatusGeral.Apto && 
               Certificacao != null && 
               Certificacao.EstaValido();
    }
    
    /// <summary>
    /// Atualiza o status geral do colaborador baseado nas certificações
    /// </summary>
    public void AtualizarStatusGeral()
    {
        if (Certificacao == null || !Certificacao.EstaValido())
        {
            StatusGeral = StatusGeral.Inapto;
            return;
        }
        
        if (Certificacao.TemCertificacaoProximaVencimento(30))
        {
            StatusGeral = StatusGeral.Alerta;
            return;
        }
        
        StatusGeral = StatusGeral.Apto;
    }
}
