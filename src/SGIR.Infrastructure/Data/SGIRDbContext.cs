using Microsoft.EntityFrameworkCore;
using SGIR.Core.Entities;
using SGIR.Core.Enums;

namespace SGIR.Infrastructure.Data;

/// <summary>
/// Contexto do banco de dados do SGIR
/// </summary>
public class SGIRDbContext : DbContext
{
    public SGIRDbContext(DbContextOptions<SGIRDbContext> options) : base(options)
    {
    }

    // DbSets (Tabelas)
    public DbSet<Projeto> Projetos { get; set; }
    public DbSet<Colaborador> Colaboradores { get; set; }
    public DbSet<Certificacao> Certificacoes { get; set; }
    public DbSet<EPI> EPIs { get; set; }
    public DbSet<ItemEstoque> ItensEstoque { get; set; }
    public DbSet<RecursoNecessario> RecursosNecessarios { get; set; }
    public DbSet<MovimentoEstoque> MovimentosEstoque { get; set; }
    public DbSet<AlocacaoPessoa> AlocacoesPessoas { get; set; }
    public DbSet<AnaliseDeficit> AnalisesDeficit { get; set; }
    public DbSet<CompraAutomatica> ComprasAutomaticas { get; set; }
    public DbSet<CustoOperacional> CustosOperacionais { get; set; }
    public DbSet<CaixaFerramentas> CaixasFerramentas { get; set; }
    public DbSet<CaixaItem> CaixasItens { get; set; }
    public DbSet<Carrinho> Carrinhos { get; set; }
    public DbSet<CarrinhoItem> CarrinhosItens { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configuração de Projeto
        modelBuilder.Entity<Projeto>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NomeAtividade).IsRequired().HasMaxLength(200);
            entity.Property(e => e.Local).IsRequired().HasMaxLength(200);
            entity.Property(e => e.Status).HasMaxLength(50).HasDefaultValue("Planejamento");
            
            entity.HasMany(e => e.RecursosNecessarios)
                .WithOne(r => r.Projeto)
                .HasForeignKey(r => r.ProjetoId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasMany(e => e.Alocacoes)
                .WithOne(a => a.Projeto)
                .HasForeignKey(a => a.ProjetoId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasMany(e => e.Custos)
                .WithOne(c => c.Projeto)
                .HasForeignKey(c => c.ProjetoId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Configuração de Colaborador
        modelBuilder.Entity<Colaborador>(entity =>
        {
            entity.HasKey(e => e.Cpf);
            entity.Property(e => e.Cpf).HasMaxLength(14);
            entity.Property(e => e.Nome).IsRequired().HasMaxLength(200);
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.Telefone).HasMaxLength(20);
            
            entity.Property(e => e.Funcao)
                .HasConversion<int>()
                .IsRequired();
            
            entity.Property(e => e.StatusGeral)
                .HasConversion<int>()
                .HasDefaultValue(StatusGeral.Inapto);
            
            entity.HasOne(e => e.Certificacao)
                .WithOne(c => c.Colaborador)
                .HasForeignKey<Certificacao>(c => c.CpfColaborador)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasMany(e => e.EPIs)
                .WithOne(epi => epi.Colaborador)
                .HasForeignKey(epi => epi.CpfColaborador)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasMany(e => e.Alocacoes)
                .WithOne(a => a.Colaborador)
                .HasForeignKey(a => a.CpfColaborador)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // Configuração de Certificacao
        modelBuilder.Entity<Certificacao>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.CpfColaborador).IsRequired().HasMaxLength(14);
            
            entity.HasIndex(e => e.CpfColaborador).IsUnique();
        });

        // Configuração de EPI
        modelBuilder.Entity<EPI>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.CpfColaborador).IsRequired().HasMaxLength(14);
            entity.Property(e => e.TipoEPI).IsRequired().HasMaxLength(200);
            entity.Property(e => e.CA).IsRequired().HasMaxLength(100);
            
            entity.HasIndex(e => new { e.CpfColaborador, e.TipoEPI });
        });

        // Configuração de ItemEstoque
        modelBuilder.Entity<ItemEstoque>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Descricao).IsRequired().HasMaxLength(300);
            entity.Property(e => e.Categoria).HasMaxLength(100);
            entity.Property(e => e.Fabricante).HasMaxLength(100);
            entity.Property(e => e.ModeloPN).HasMaxLength(100);
            entity.Property(e => e.Unidade).HasMaxLength(50).HasDefaultValue("UN");
            entity.Property(e => e.LocalPosse).HasMaxLength(200);
            entity.Property(e => e.ValorUnitario).HasColumnType("decimal(18,2)");
            entity.Property(e => e.EstoqueAtual).HasColumnType("decimal(18,3)").HasDefaultValue(0);
            entity.Property(e => e.EstoqueMinimo).HasColumnType("decimal(18,3)");
            
            entity.HasIndex(e => e.Descricao);
            entity.HasIndex(e => e.Categoria);
            
            entity.HasMany(e => e.Movimentos)
                .WithOne(m => m.ItemEstoque)
                .HasForeignKey(m => m.ItemEstoqueId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasMany(e => e.RecursosNecessarios)
                .WithOne(r => r.ItemEstoque)
                .HasForeignKey(r => r.ItemEstoqueId)
                .OnDelete(DeleteBehavior.SetNull);
        });

        // Configuração de RecursoNecessario
        modelBuilder.Entity<RecursoNecessario>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.DescricaoRecurso).IsRequired().HasMaxLength(300);
            entity.Property(e => e.Unidade).HasMaxLength(50).HasDefaultValue("UN");
            entity.Property(e => e.QuantidadeNecessaria).HasColumnType("decimal(18,3)");
            entity.Property(e => e.QuantidadeAlocada).HasColumnType("decimal(18,3)").HasDefaultValue(0);
            
            entity.HasIndex(e => new { e.ProjetoId, e.ItemEstoqueId });
        });

        // Configuração de MovimentoEstoque
        modelBuilder.Entity<MovimentoEstoque>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Quantidade).HasColumnType("decimal(18,3)");
            entity.Property(e => e.Unidade).HasMaxLength(50).HasDefaultValue("UN");
            entity.Property(e => e.LocalOrigem).HasMaxLength(200);
            entity.Property(e => e.LocalDestino).HasMaxLength(200);
            entity.Property(e => e.Responsavel).HasMaxLength(100);
            
            entity.Property(e => e.TipoMovimento).HasConversion<int>();
            
            entity.HasIndex(e => e.DataMovimento);
            entity.HasIndex(e => new { e.ItemEstoqueId, e.DataMovimento });
        });

        // Configuração de AlocacaoPessoa
        modelBuilder.Entity<AlocacaoPessoa>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.CpfColaborador).IsRequired().HasMaxLength(14);
            entity.Property(e => e.Status).HasMaxLength(50).HasDefaultValue("Ativo");
            
            entity.HasIndex(e => new { e.ProjetoId, e.CpfColaborador });
            entity.HasIndex(e => e.DataAlocacao);
        });

        // Configuração de AnaliseDeficit
        modelBuilder.Entity<AnaliseDeficit>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.DescricaoItem).IsRequired().HasMaxLength(300);
            entity.Property(e => e.Unidade).HasMaxLength(50).HasDefaultValue("UN");
            entity.Property(e => e.DemandaTotal).HasColumnType("decimal(18,3)");
            entity.Property(e => e.EstoqueDisponivel).HasColumnType("decimal(18,3)");
            entity.Property(e => e.Deficit).HasColumnType("decimal(18,3)");
            entity.Property(e => e.CustoEstimado).HasColumnType("decimal(18,2)");
            entity.Property(e => e.Recomendacao).HasMaxLength(50);
            
            entity.HasIndex(e => e.DataAnalise);
            entity.HasIndex(e => new { e.ItemEstoqueId, e.DataAnalise });
        });

        // Configuração de CompraAutomatica
        modelBuilder.Entity<CompraAutomatica>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.DescricaoItem).IsRequired().HasMaxLength(300);
            entity.Property(e => e.Quantidade).HasColumnType("decimal(18,3)");
            entity.Property(e => e.Unidade).HasMaxLength(50).HasDefaultValue("UN");
            entity.Property(e => e.TipoAquisicao).HasMaxLength(50).HasDefaultValue("Compra");
            entity.Property(e => e.ValorEstimado).HasColumnType("decimal(18,2)");
            entity.Property(e => e.Fornecedor).HasMaxLength(200);
            entity.Property(e => e.NumeroPedido).HasMaxLength(100);
            
            entity.Property(e => e.Status)
                .HasConversion<int>()
                .HasDefaultValue(StatusCompra.Pendente);
            
            entity.HasIndex(e => e.Status);
            entity.HasIndex(e => e.DataGeracao);
            
            entity.HasOne(e => e.AnaliseDeficit)
                .WithMany()
                .HasForeignKey(e => e.AnaliseDeficitId)
                .OnDelete(DeleteBehavior.SetNull);
        });

        // Configuração de CustoOperacional
        modelBuilder.Entity<CustoOperacional>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.TipoCusto).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Descricao).IsRequired().HasMaxLength(300);
            entity.Property(e => e.ValorUnitario).HasColumnType("decimal(18,2)");
            entity.Property(e => e.Quantidade).HasColumnType("decimal(18,3)").HasDefaultValue(1);
            entity.Property(e => e.ValorTotal).HasColumnType("decimal(18,2)");
            entity.Property(e => e.Unidade).HasMaxLength(50).HasDefaultValue("UN");
            
            entity.HasIndex(e => new { e.ProjetoId, e.TipoCusto });
            entity.HasIndex(e => e.DataLancamento);
        });

        // Configuração de CaixaFerramentas
        modelBuilder.Entity<CaixaFerramentas>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Codigo).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Descricao).IsRequired().HasMaxLength(200);
            entity.Property(e => e.Tipo).IsRequired().HasMaxLength(50).HasDefaultValue("MECANICA");
            entity.Property(e => e.LocalAtual).HasMaxLength(200);
            
            entity.HasIndex(e => e.Codigo).IsUnique();
            
            entity.HasMany(e => e.Itens)
                .WithOne(i => i.Caixa)
                .HasForeignKey(i => i.CaixaId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Configuração de CaixaItem
        modelBuilder.Entity<CaixaItem>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Quantidade).HasColumnType("decimal(18,3)");
            
            entity.HasIndex(e => new { e.CaixaId, e.ItemEstoqueId }).IsUnique();
        });

        // Configuração de Carrinho
        modelBuilder.Entity<Carrinho>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Codigo).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Descricao).IsRequired().HasMaxLength(200);
            entity.Property(e => e.LocalAtual).HasMaxLength(200);
            
            entity.HasIndex(e => e.Codigo).IsUnique();
            
            entity.HasMany(e => e.Itens)
                .WithOne(i => i.Carrinho)
                .HasForeignKey(i => i.CarrinhoId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Configuração de CarrinhoItem
        modelBuilder.Entity<CarrinhoItem>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.TipoItem).IsRequired().HasMaxLength(50).HasDefaultValue("ITEM");
            entity.Property(e => e.Quantidade).HasColumnType("decimal(18,3)");
            
            entity.HasIndex(e => new { e.CarrinhoId, e.TipoItem, e.ItemEstoqueId });
        });

        // Seed Data (dados iniciais para teste)
        SeedData(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        // Seed de funções básicas será feito via migrations
        // Aqui podemos adicionar dados de teste se necessário
    }
}
