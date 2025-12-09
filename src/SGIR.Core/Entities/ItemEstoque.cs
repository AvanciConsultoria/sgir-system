using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SGIR.Core.Entities;

/// <summary>
/// Representa um item no estoque/inventário
/// </summary>
[Table("Itens_Estoque")]
public class ItemEstoque : BaseEntity
{
    [Key]
    [Column("ID_Item")]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(300)]
    public string Descricao { get; set; } = string.Empty;
    
    [MaxLength(100)]
    public string? Categoria { get; set; }
    
    [MaxLength(100)]
    public string? Fabricante { get; set; }
    
    [MaxLength(100)]
    [Column("Modelo_PN")]
    public string? ModeloPN { get; set; }
    
    [MaxLength(50)]
    public string? Unidade { get; set; } = "UN";
    
    [Column("Estoque_Atual")]
    public decimal EstoqueAtual { get; set; } = 0;
    
    [Column("Estoque_Minimo")]
    public decimal? EstoqueMinimo { get; set; }
    
    [Column("Local_Posse")]
    [MaxLength(200)]
    public string? LocalPosse { get; set; }
    
    [Column("Valor_Unitario")]
    [Column(TypeName = "decimal(18,2)")]
    public decimal? ValorUnitario { get; set; }
    
    [Column(TypeName = "text")]
    [MaxLength(2000)]
    public string? OBS { get; set; }
    
    /// <summary>
    /// Indica se o item pode ser alugado
    /// </summary>
    [NotMapped]
    public bool PodeAlugar => OBS != null && 
        (OBS.Contains("aluguel", StringComparison.OrdinalIgnoreCase) ||
         OBS.Contains("alugar", StringComparison.OrdinalIgnoreCase));
    
    /// <summary>
    /// Indica se há intenção de compra deste item
    /// </summary>
    [NotMapped]
    public bool IntencaoCompra => OBS != null && 
        OBS.Contains("intenção compra", StringComparison.OrdinalIgnoreCase);
    
    /// <summary>
    /// Extrai quantidade disponível em outros locais da observação
    /// Exemplo: "Temos na Renault (3 confirmar)" -> retorna 3
    /// </summary>
    [NotMapped]
    public int QuantidadeOutrosLocais
    {
        get
        {
            if (string.IsNullOrEmpty(OBS))
                return 0;
            
            var match = System.Text.RegularExpressions.Regex.Match(OBS, @"\((\d+)\s*confirmar\)");
            if (match.Success && int.TryParse(match.Groups[1].Value, out int qtd))
                return qtd;
            
            return 0;
        }
    }
    
    /// <summary>
    /// Verifica se o estoque está abaixo do mínimo
    /// </summary>
    public bool EstoqueAbaixoMinimo()
    {
        return EstoqueMinimo.HasValue && EstoqueAtual < EstoqueMinimo.Value;
    }
    
    /// <summary>
    /// Movimentações deste item
    /// </summary>
    public virtual ICollection<MovimentoEstoque> Movimentos { get; set; } = new List<MovimentoEstoque>();
    
    /// <summary>
    /// Recursos necessários que referenciam este item
    /// </summary>
    public virtual ICollection<RecursoNecessario> RecursosNecessarios { get; set; } = new List<RecursoNecessario>();
}
