using SGIR.Core.Entities;

namespace SGIR.Core.Interfaces;

/// <summary>
/// Interface para Unit of Work (controle de transações)
/// </summary>
public interface IUnitOfWork : IDisposable
{
    IRepository<Projeto> Projetos { get; }
    IRepository<Colaborador> Colaboradores { get; }
    IRepository<Certificacao> Certificacoes { get; }
    IRepository<EPI> EPIs { get; }
    IRepository<ItemEstoque> ItensEstoque { get; }
    IRepository<RecursoNecessario> RecursosNecessarios { get; }
    IRepository<MovimentoEstoque> MovimentosEstoque { get; }
    IRepository<AlocacaoPessoa> AlocacoesPessoas { get; }
    IRepository<AnaliseDeficit> AnalisesDeficit { get; }
    IRepository<CompraAutomatica> ComprasAutomaticas { get; }
    IRepository<CustoOperacional> CustosOperacionais { get; }
    
    Task<int> SaveChangesAsync();
    Task BeginTransactionAsync();
    Task CommitAsync();
    Task RollbackAsync();
}
