using Microsoft.EntityFrameworkCore.Storage;
using SGIR.Core.Entities;
using SGIR.Core.Interfaces;
using SGIR.Infrastructure.Data;

namespace SGIR.Infrastructure.Repositories;

/// <summary>
/// Implementação do Unit of Work para controle de transações
/// </summary>
public class UnitOfWork : IUnitOfWork
{
    private readonly SGIRDbContext _context;
    private IDbContextTransaction? _transaction;

    // Repositories
    private IRepository<Projeto>? _projetos;
    private IRepository<Colaborador>? _colaboradores;
    private IRepository<Certificacao>? _certificacoes;
    private IRepository<EPI>? _epis;
    private IRepository<ItemEstoque>? _itensEstoque;
    private IRepository<RecursoNecessario>? _recursosNecessarios;
    private IRepository<MovimentoEstoque>? _movimentosEstoque;
    private IRepository<AlocacaoPessoa>? _alocacoesPessoas;
    private IRepository<AnaliseDeficit>? _analisesDeficit;
    private IRepository<CompraAutomatica>? _comprasAutomaticas;
    private IRepository<CustoOperacional>? _custosOperacionais;

    public UnitOfWork(SGIRDbContext context)
    {
        _context = context;
    }

    // Propriedades dos Repositories (lazy initialization)
    public IRepository<Projeto> Projetos =>
        _projetos ??= new Repository<Projeto>(_context);

    public IRepository<Colaborador> Colaboradores =>
        _colaboradores ??= new Repository<Colaborador>(_context);

    public IRepository<Certificacao> Certificacoes =>
        _certificacoes ??= new Repository<Certificacao>(_context);

    public IRepository<EPI> EPIs =>
        _epis ??= new Repository<EPI>(_context);

    public IRepository<ItemEstoque> ItensEstoque =>
        _itensEstoque ??= new Repository<ItemEstoque>(_context);

    public IRepository<RecursoNecessario> RecursosNecessarios =>
        _recursosNecessarios ??= new Repository<RecursoNecessario>(_context);

    public IRepository<MovimentoEstoque> MovimentosEstoque =>
        _movimentosEstoque ??= new Repository<MovimentoEstoque>(_context);

    public IRepository<AlocacaoPessoa> AlocacoesPessoas =>
        _alocacoesPessoas ??= new Repository<AlocacaoPessoa>(_context);

    public IRepository<AnaliseDeficit> AnalisesDeficit =>
        _analisesDeficit ??= new Repository<AnaliseDeficit>(_context);

    public IRepository<CompraAutomatica> ComprasAutomaticas =>
        _comprasAutomaticas ??= new Repository<CompraAutomatica>(_context);

    public IRepository<CustoOperacional> CustosOperacionais =>
        _custosOperacionais ??= new Repository<CustoOperacional>(_context);

    // Métodos do UnitOfWork
    public async Task<int> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync();
    }

    public async Task BeginTransactionAsync()
    {
        _transaction = await _context.Database.BeginTransactionAsync();
    }

    public async Task CommitAsync()
    {
        try
        {
            await SaveChangesAsync();
            
            if (_transaction != null)
            {
                await _transaction.CommitAsync();
                await _transaction.DisposeAsync();
                _transaction = null;
            }
        }
        catch
        {
            await RollbackAsync();
            throw;
        }
    }

    public async Task RollbackAsync()
    {
        if (_transaction != null)
        {
            await _transaction.RollbackAsync();
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public void Dispose()
    {
        _transaction?.Dispose();
        _context.Dispose();
    }
}
