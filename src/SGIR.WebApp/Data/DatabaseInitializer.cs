using Microsoft.EntityFrameworkCore;
using SGIR.Core.Entities;
using SGIR.Core.Enums;
using SGIR.Infrastructure.Data;

namespace SGIR.WebApp.Data;

/// <summary>
/// Povoa o banco com dados de exemplo para que a interface fique utilizável logo após o primeiro run.
/// </summary>
public static class DatabaseInitializer
{
    public static async Task SeedAsync(SGIRDbContext context)
    {
        await context.Database.EnsureCreatedAsync();

        if (await context.Projetos.AnyAsync())
        {
            return; // já existe dado real ou seed anterior
        }

        // Itens de estoque
        var itens = new List<ItemEstoque>
        {
            new()
            {
                Descricao = "Kit de bloqueio LOTO",
                Categoria = "Segurança",
                Fabricante = "3M",
                ModeloPN = "LOTO-123",
                Unidade = "UN",
                EstoqueAtual = 8,
                EstoqueMinimo = 10,
                LocalPosse = "Almoxarifado Central",
                ValorUnitario = 350.00m,
                OBS = "Temos na Renault (3 confirmar); intenção compra",
            },
            new()
            {
                Descricao = "Chave combinada 17mm",
                Categoria = "Ferramentas",
                EstoqueAtual = 24,
                EstoqueMinimo = 15,
                LocalPosse = "Oficina",
                ValorUnitario = 35.90m,
                Unidade = "UN",
                OBS = "estoque equilibrado",
            },
            new()
            {
                Descricao = "Bota de segurança (numeração variada)",
                Categoria = "EPI",
                EstoqueAtual = 12,
                EstoqueMinimo = 20,
                LocalPosse = "Almoxarifado - EPIs",
                ValorUnitario = 189.90m,
                Unidade = "PAR",
                OBS = "necessita reforço para turno extra",
            },
            new()
            {
                Descricao = "Kit de chave Allen",
                Categoria = "Ferramentas",
                EstoqueAtual = 5,
                EstoqueMinimo = 8,
                LocalPosse = "Oficina",
                ValorUnitario = 120.00m,
                Unidade = "JOGO",
                OBS = "aluguel possível com fornecedor local",
            }
        };

        context.ItensEstoque.AddRange(itens);
        await context.SaveChangesAsync();

        // Projetos
        var projetos = new List<Projeto>
        {
            new()
            {
                Id = 1001,
                NomeAtividade = "Retrofit de prensa hidráulica",
                Local = "Planta Curitiba",
                PrazoDias = 30,
                DataInicio = DateTime.Today.AddDays(-5),
                DataFimPrevista = DateTime.Today.AddDays(25),
                Status = "Em andamento"
            },
            new()
            {
                Id = 1002,
                NomeAtividade = "Linha de montagem - nova célula",
                Local = "Planta São José",
                PrazoDias = 45,
                DataInicio = DateTime.Today.AddDays(-15),
                DataFimPrevista = DateTime.Today.AddDays(30),
                Status = "Planejamento"
            },
            new()
            {
                Id = 1003,
                NomeAtividade = "Inspeção NR-12",
                Local = "Planta Curitiba",
                PrazoDias = 10,
                DataInicio = DateTime.Today.AddDays(-2),
                DataFimPrevista = DateTime.Today.AddDays(8),
                Status = "Em andamento"
            }
        };

        context.Projetos.AddRange(projetos);
        await context.SaveChangesAsync();

        // Recursos necessários vinculando a itens de estoque
        var recursos = new List<RecursoNecessario>
        {
            new()
            {
                ProjetoId = 1001,
                ItemEstoqueId = itens.First(i => i.Descricao.Contains("LOTO")).Id,
                DescricaoRecurso = "Kit de bloqueio LOTO",
                QuantidadeNecessaria = 12,
                QuantidadeAlocada = 5,
                Unidade = "UN",
                DataNecessidade = DateTime.Today.AddDays(7)
            },
            new()
            {
                ProjetoId = 1001,
                ItemEstoqueId = itens.First(i => i.Descricao.Contains("Allen")).Id,
                DescricaoRecurso = "Kit de chave Allen",
                QuantidadeNecessaria = 6,
                QuantidadeAlocada = 3,
                Unidade = "JOGO",
                DataNecessidade = DateTime.Today.AddDays(3)
            },
            new()
            {
                ProjetoId = 1002,
                DescricaoRecurso = "Banco giratório com rodízio",
                QuantidadeNecessaria = 10,
                QuantidadeAlocada = 0,
                Unidade = "UN",
                DataNecessidade = DateTime.Today.AddDays(15),
                Observacoes = "Será comprado - sem estoque"
            },
            new()
            {
                ProjetoId = 1003,
                ItemEstoqueId = itens.First(i => i.Descricao.Contains("Bota")).Id,
                DescricaoRecurso = "Bota de segurança",
                QuantidadeNecessaria = 18,
                QuantidadeAlocada = 10,
                Unidade = "PAR",
                DataNecessidade = DateTime.Today.AddDays(2)
            }
        };

        context.RecursosNecessarios.AddRange(recursos);
        await context.SaveChangesAsync();

        // Colaboradores e certificações
        var colaboradores = new List<Colaborador>
        {
            new()
            {
                Cpf = "123.456.789-00",
                Nome = "Ana Paula Souza",
                Funcao = Funcao.Engenheiro,
                Email = "ana.souza@empresa.com",
                Telefone = "+55 41 99999-0001",
                DataAdmissao = DateTime.Today.AddYears(-3),
                StatusGeral = StatusGeral.Apto
            },
            new()
            {
                Cpf = "987.654.321-00",
                Nome = "Carlos Lima",
                Funcao = Funcao.Mecânico,
                Email = "carlos.lima@empresa.com",
                Telefone = "+55 41 98888-0002",
                DataAdmissao = DateTime.Today.AddYears(-1),
                StatusGeral = StatusGeral.Alerta
            },
            new()
            {
                Cpf = "555.666.777-00",
                Nome = "Juliana Ferreira",
                Funcao = Funcao.Almoxarife,
                Email = "juliana.ferreira@empresa.com",
                Telefone = "+55 41 97777-0003",
                DataAdmissao = DateTime.Today.AddYears(-5),
                StatusGeral = StatusGeral.Apto
            }
        };

        context.Colaboradores.AddRange(colaboradores);
        await context.SaveChangesAsync();

        var certificacoes = new List<Certificacao>
        {
            new()
            {
                CpfColaborador = "123.456.789-00",
                NR12Validade = DateTime.Today.AddMonths(18),
                ASOValidade = DateTime.Today.AddMonths(24)
            },
            new()
            {
                CpfColaborador = "987.654.321-00",
                NR35Validade = DateTime.Today.AddDays(-10),
                ASOValidade = DateTime.Today.AddMonths(6)
            },
            new()
            {
                CpfColaborador = "555.666.777-00",
                NR10Validade = DateTime.Today.AddMonths(12),
                ASOValidade = DateTime.Today.AddMonths(18)
            }
        };

        context.Certificacoes.AddRange(certificacoes);
        await context.SaveChangesAsync();

        // EPIs entregues
        var epis = new List<EPI>
        {
            new()
            {
                CpfColaborador = "123.456.789-00",
                TipoEPI = "Capacete",
                CA = "12345",
                DataEntrega = DateTime.Today.AddMonths(-2),
                ValidadeCA = DateTime.Today.AddMonths(10),
                VidaUtilDias = 365,
                Observacoes = "Modelo classe B"
            },
            new()
            {
                CpfColaborador = "987.654.321-00",
                TipoEPI = "Cinto de segurança",
                CA = "67890",
                DataEntrega = DateTime.Today.AddMonths(-1),
                ValidadeCA = DateTime.Today.AddMonths(5),
                VidaUtilDias = 180,
                Observacoes = "Substituir junto com renovação NR-35"
            },
            new()
            {
                CpfColaborador = "555.666.777-00",
                TipoEPI = "Luvas isolantes",
                CA = "54321",
                DataEntrega = DateTime.Today.AddMonths(-1),
                ValidadeCA = DateTime.Today.AddMonths(11),
                VidaUtilDias = 90,
                Observacoes = "Teste elétrico realizado"
            }
        };

        context.EPIs.AddRange(epis);
        await context.SaveChangesAsync();

        // Alocações
        var alocacoes = new List<AlocacaoPessoa>
        {
            new()
            {
                ProjetoId = 1001,
                CpfColaborador = "123.456.789-00",
                DataAlocacao = DateTime.Today.AddDays(-4),
                Status = "Ativo"
            },
            new()
            {
                ProjetoId = 1003,
                CpfColaborador = "987.654.321-00",
                DataAlocacao = DateTime.Today.AddDays(-2),
                Status = "Ativo"
            }
        };

        context.AlocacoesPessoas.AddRange(alocacoes);
        await context.SaveChangesAsync();

        // Movimentações de estoque
        var movimentos = new List<MovimentoEstoque>
        {
            new()
            {
                ItemEstoqueId = itens.First(i => i.Descricao.Contains("LOTO")).Id,
                TipoMovimento = TipoMovimento.Saida,
                Quantidade = 4,
                Unidade = "UN",
                DataMovimento = DateTime.Today.AddDays(-1),
                Responsavel = "Juliana Ferreira",
                LocalOrigem = "Almoxarifado Central",
                LocalDestino = "Planta Curitiba",
                Observacoes = "Liberação para OS 1001",
                ProjetoId = 1001
            },
            new()
            {
                ItemEstoqueId = itens.First(i => i.Descricao.Contains("Chave combinada")).Id,
                TipoMovimento = TipoMovimento.Entrada,
                Quantidade = 10,
                Unidade = "UN",
                DataMovimento = DateTime.Today.AddDays(-3),
                Responsavel = "Juliana Ferreira",
                LocalOrigem = "Fornecedor",
                LocalDestino = "Oficina",
                Observacoes = "Reposição de estoque"
            }
        };

        context.MovimentosEstoque.AddRange(movimentos);
        await context.SaveChangesAsync();

        // Custos operacionais
        var custos = new List<CustoOperacional>
        {
            new()
            {
                ProjetoId = 1001,
                TipoCusto = "Mão de obra terceirizada",
                Descricao = "Equipe de eletricistas para adequação",
                Quantidade = 80,
                Unidade = "HORA",
                ValorUnitario = 95.50m,
                ValorTotal = 7640.00m,
                DataLancamento = DateTime.Today.AddDays(-3)
            },
            new()
            {
                ProjetoId = 1002,
                TipoCusto = "Viagem",
                Descricao = "Visita técnica fornecedores",
                Quantidade = 1,
                Unidade = "UN",
                ValorUnitario = 2800.00m,
                ValorTotal = 2800.00m,
                DataLancamento = DateTime.Today.AddDays(-7)
            }
        };

        context.CustosOperacionais.AddRange(custos);
        await context.SaveChangesAsync();

        // Compras automáticas sugeridas
        var compras = new List<CompraAutomatica>
        {
            new()
            {
                DescricaoItem = "Kit de bloqueio LOTO",
                Quantidade = 7,
                Unidade = "UN",
                TipoAquisicao = "Compra",
                ValorEstimado = 2450.00m,
                Fornecedor = "Fornecedor Segurança LTDA",
                DataGeracao = DateTime.Today,
                Status = StatusCompra.Pendente
            },
            new()
            {
                DescricaoItem = "Bota de segurança",
                Quantidade = 12,
                Unidade = "PAR",
                TipoAquisicao = "Compra",
                ValorEstimado = 2278.80m,
                Fornecedor = "Protege EPI",
                DataGeracao = DateTime.Today.AddDays(-1),
                Status = StatusCompra.Aprovada
            }
        };

        context.ComprasAutomaticas.AddRange(compras);
        await context.SaveChangesAsync();
    }
}
