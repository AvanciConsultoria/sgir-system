-- Script de criacao de todas as tabelas do SGIR
-- Execute este script no SQL Server

USE master;
GO

-- Criar database se nao existir
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SGIR_DB')
BEGIN
    CREATE DATABASE SGIR_DB;
END
GO

USE SGIR_DB;
GO

-- Tabela: Itens_Estoque
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Itens_Estoque]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Itens_Estoque] (
        [ID_Item] INT IDENTITY(1,1) PRIMARY KEY,
        [Descricao] NVARCHAR(300) NOT NULL,
        [Categoria] NVARCHAR(100) NULL,
        [Fabricante] NVARCHAR(100) NULL,
        [Modelo_PN] NVARCHAR(100) NULL,
        [Unidade] NVARCHAR(50) NULL DEFAULT 'UN',
        [Estoque_Atual] DECIMAL(18,3) NOT NULL DEFAULT 0,
        [Estoque_Minimo] DECIMAL(18,3) NULL,
        [Local_Posse] NVARCHAR(200) NULL,
        [Valor_Unitario] DECIMAL(18,2) NULL,
        [OBS] NVARCHAR(MAX) NULL,
        [DataCriacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [DataAtualizacao] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    
    CREATE INDEX IX_Itens_Descricao ON [dbo].[Itens_Estoque]([Descricao]);
    CREATE INDEX IX_Itens_Categoria ON [dbo].[Itens_Estoque]([Categoria]);
END
GO

-- Tabela: Caixas_Ferramentas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Caixas_Ferramentas]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Caixas_Ferramentas] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Codigo] NVARCHAR(100) NOT NULL UNIQUE,
        [Descricao] NVARCHAR(200) NOT NULL,
        [Tipo] NVARCHAR(50) NOT NULL DEFAULT 'MECANICA',
        [Local_Atual] NVARCHAR(200) NULL,
        [Ativo] BIT NOT NULL DEFAULT 1,
        [Observacoes] NVARCHAR(500) NULL,
        [DataCriacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [DataAtualizacao] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Tabela: Caixas_Itens
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Caixas_Itens]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Caixas_Itens] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [ID_Caixa] INT NOT NULL,
        [ID_Item] INT NOT NULL,
        [Quantidade] DECIMAL(18,3) NOT NULL,
        [Observacoes] NVARCHAR(500) NULL,
        [DataCriacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [DataAtualizacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_CaixasItens_Caixa FOREIGN KEY ([ID_Caixa]) REFERENCES [dbo].[Caixas_Ferramentas]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_CaixasItens_Item FOREIGN KEY ([ID_Item]) REFERENCES [dbo].[Itens_Estoque]([ID_Item]) ON DELETE CASCADE,
        CONSTRAINT UQ_CaixaItem UNIQUE ([ID_Caixa], [ID_Item])
    );
END
GO

-- Tabela: Carrinhos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrinhos]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Carrinhos] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Codigo] NVARCHAR(100) NOT NULL UNIQUE,
        [Descricao] NVARCHAR(200) NOT NULL,
        [Local_Atual] NVARCHAR(200) NULL,
        [ID_Projeto] INT NULL,
        [Ativo] BIT NOT NULL DEFAULT 1,
        [Observacoes] NVARCHAR(500) NULL,
        [DataCriacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [DataAtualizacao] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Tabela: Carrinhos_Itens
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrinhos_Itens]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Carrinhos_Itens] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [ID_Carrinho] INT NOT NULL,
        [Tipo_Item] NVARCHAR(50) NOT NULL DEFAULT 'ITEM',
        [ID_Item] INT NULL,
        [ID_Caixa] INT NULL,
        [Quantidade] DECIMAL(18,3) NULL,
        [Observacoes] NVARCHAR(500) NULL,
        [DataCriacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [DataAtualizacao] DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_CarrinhosItens_Carrinho FOREIGN KEY ([ID_Carrinho]) REFERENCES [dbo].[Carrinhos]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_CarrinhosItens_Item FOREIGN KEY ([ID_Item]) REFERENCES [dbo].[Itens_Estoque]([ID_Item]),
        CONSTRAINT FK_CarrinhosItens_Caixa FOREIGN KEY ([ID_Caixa]) REFERENCES [dbo].[Caixas_Ferramentas]([Id])
    );
    
    CREATE INDEX IX_CarrinhosItens_Tipo ON [dbo].[Carrinhos_Itens]([ID_Carrinho], [Tipo_Item]);
END
GO

-- Dados iniciais - Ferramentas baseadas na planilha
INSERT INTO [dbo].[Itens_Estoque] ([Descricao], [Categoria], [Unidade], [Estoque_Atual], [Estoque_Minimo])
VALUES 
    -- Ferramentas Manuais
    ('Alicate Universal 8"', 'FERRAMENTAS MANUAIS', 'UN', 20, 5),
    ('Chave de Fenda 1/4"', 'FERRAMENTAS MANUAIS', 'UN', 30, 10),
    ('Chave Phillips 1/4"', 'FERRAMENTAS MANUAIS', 'UN', 30, 10),
    ('Chave Allen Jogo', 'FERRAMENTAS MANUAIS', 'UN', 15, 5),
    ('Martelo 500g', 'FERRAMENTAS MANUAIS', 'UN', 10, 3),
    ('Trena 5m', 'FERRAMENTAS MANUAIS', 'UN', 25, 8),
    ('Nivel de Bolha 60cm', 'FERRAMENTAS MANUAIS', 'UN', 12, 4),
    ('Serra Manual', 'FERRAMENTAS MANUAIS', 'UN', 8, 2),
    
    -- Ferramentas Eletricas
    ('Furadeira Impacto 1/2"', 'FERRAMENTAS ELETRICAS', 'UN', 15, 5),
    ('Parafusadeira Bateria', 'FERRAMENTAS ELETRICAS', 'UN', 20, 8),
    ('Esmerilhadeira 4.1/2"', 'FERRAMENTAS ELETRICAS', 'UN', 10, 3),
    ('Lixadeira Orbital', 'FERRAMENTAS ELETRICAS', 'UN', 8, 2),
    ('Serra Tico-Tico', 'FERRAMENTAS ELETRICAS', 'UN', 6, 2),
    
    -- Medicao
    ('Multimetro Digital', 'MEDICAO', 'UN', 12, 4),
    ('Paquimetro Digital 150mm', 'MEDICAO', 'UN', 8, 3),
    ('Termometro Infravermelho', 'MEDICAO', 'UN', 5, 2),
    
    -- Equipamentos Seguranca
    ('Capacete Classe A', 'EPI', 'UN', 50, 20),
    ('Oculos de Protecao', 'EPI', 'UN', 100, 30),
    ('Luva de Raspa', 'PAR', 50, 20),
    ('Protetor Auricular', 'EPI', 'UN', 80, 25),
    
    -- Consumiveis
    ('Disco de Corte 4.1/2"', 'CONSUMIVEL', 'UN', 200, 50),
    ('Disco de Desbaste 4.1/2"', 'CONSUMIVEL', 'UN', 150, 40),
    ('Broca Aco Rapido Jogo', 'CONSUMIVEL', 'JOGO', 20, 5),
    ('Lixa Ferro 80', 'CONSUMIVEL', 'UN', 100, 30),
    ('Fita Isolante', 'CONSUMIVEL', 'ROLO', 50, 15);
GO

PRINT 'Tabelas criadas com sucesso!';
PRINT 'Dados iniciais inseridos!';
GO
