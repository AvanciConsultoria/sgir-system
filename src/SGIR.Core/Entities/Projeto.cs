using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um projeto/ordem de serviço no sistema
/// </summary>
[Table("Projetos")]
public class Projeto : BaseEntity
{
    [Key]
    [Column("OS_ID")]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(200)]
    [Column("Nome_Atividade")]
    public string NomeAtividade { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(200)]
    public string Local { get; set; } = string.Empty;
    
    [Column("Prazo_Dias")]
    public int PrazoDias { get; set; }
    
    [Column("Data_Inicio")]
    public DateTime? DataInicio { get; set; }
    
    [Column("Data_Fim_Prevista")]
    public DateTime? DataFimPrevista { get; set; }
    
    [Column("Data_Fim_Real")]
    public DateTime? DataFimReal { get; set; }
    
    [MaxLength(50)]
    public string Status { get; set; } = "Planejamento";
    
    /// <summary>
    /// Recursos necessários para este projeto
    /// </summary>
    public virtual ICollection<RecursoNecessario> RecursosNecessarios { get; set; } = new List<RecursoNecessario>();
    
    /// <summary>
    /// Colaboradores alocados neste projeto
    /// </summary>
    public virtual ICollection<AlocacaoPessoa> Alocacoes { get; set; } = new List<AlocacaoPessoa>();
    
    /// <summary>
    /// Custos associados a este projeto
    /// </summary>
    public virtual ICollection<CustoOperacional> Custos { get; set; } = new List<CustoOperacional>();
}
