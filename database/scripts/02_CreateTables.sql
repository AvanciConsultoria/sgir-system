/*
 * Script 02: Criação das Tabelas do Sistema SGIR
 * Sistema de Gestão Integrada de Recursos
 * Data: 2024-12-09
 */

USE SGIR;
GO

-- ============================================
-- MÓDULO 1: PLANEJAMENTO E DEMANDA
-- ============================================

-- Tabela: Projetos (Ordens de Serviço)
CREATE TABLE Projetos (
    OS_ID VARCHAR(20) PRIMARY KEY,
    Nome_Projeto NVARCHAR(200) NOT NULL,
    Cliente NVARCHAR(100) NOT NULL,
    Local NVARCHAR(200) NOT NULL,
    Gestor_Projeto NVARCHAR(100) NOT NULL,
    Data_Inicio DATE,
    Data_Termino DATE,
    Status NVARCHAR(50) DEFAULT 'PLANEJAMENTO',
    Custo_Total_Estimado DECIMAL(15,2),
    Observacoes NVARCHAR(MAX),
    Created_At DATETIME2 DEFAULT GETDATE(),
    Updated_At DATETIME2 DEFAULT GETDATE()
);
GO

-- Tabela: Atividades
CREATE TABLE Atividades (
    ID_Atividade INT IDENTITY(1,1) PRIMARY KEY,
    OS_ID VARCHAR(20) NOT NULL,
    Nome_Atividade NVARCHAR(200) NOT NULL,
    Descricao NVARCHAR(MAX),
    Prazo_Dias INT NOT NULL,
    Status NVARCHAR(50) DEFAULT 'PENDENTE',
    Data_Inicio_Prevista DATE,
    Data_Termino_Prevista DATE,
    Created_At DATETIME2 DEFAULT GETDATE(),
    Updated_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (OS_ID) REFERENCES Projetos(OS_ID)
);
GO

-- Tabela: Demanda de Funcoes por Atividade
CREATE TABLE Demanda_Funcoes (
    ID_Demanda INT IDENTITY(1,1) PRIMARY KEY,
    ID_Atividade INT NOT NULL,
    Funcao NVARCHAR(50) NOT NULL, -- MECÂNICO, SOLDADOR, ELETRICISTA, FERRAMENTEIRO
    Quantidade_Necessaria INT NOT NULL,
    Quantidade_Alocada INT DEFAULT 0,
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Atividade) REFERENCES Atividades(ID_Atividade)
);
GO

-- ============================================
-- MÓDULO 2: GESTÃO DE PESSOAS
-- ============================================

-- Tabela: Colaboradores
CREATE TABLE Colaboradores (
    CPF VARCHAR(14) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Funcao NVARCHAR(50) NOT NULL,
    Status_Geral NVARCHAR(50) DEFAULT 'SAT', -- SAT, INTEGRANDO, CONTRATAÇÃO, DESISTÊNCIA
    Frente_Trabalho NVARCHAR(100),
    Email NVARCHAR(100),
    Telefone VARCHAR(20),
    Data_Admissao DATE,
    Created_At DATETIME2 DEFAULT GETDATE(),
    Updated_At DATETIME2 DEFAULT GETDATE()
);
GO

-- Tabela: Certificacoes
CREATE TABLE Certificacoes (
    ID_Certificacao INT IDENTITY(1,1) PRIMARY KEY,
    CPF VARCHAR(14) NOT NULL,
    Tipo_Certificacao NVARCHAR(50) NOT NULL, -- NR-10, NR-11, NR-12, LOTO, NR-35, ASO
    Data_Emissao DATE NOT NULL,
    Data_Validade DATE NOT NULL,
    Numero_Certificado NVARCHAR(100),
    Orgao_Emissor NVARCHAR(100),
    Status NVARCHAR(20) DEFAULT 'VÁLIDA', -- VÁLIDA, VENCIDA, EM_RENOVAÇÃO
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CPF) REFERENCES Colaboradores(CPF),
    -- Constraint para garantir certificação única por tipo e pessoa
    CONSTRAINT UQ_Certificacao_CPF_Tipo UNIQUE (CPF, Tipo_Certificacao)
);
GO

-- Tabela: EPIs (Equipamentos de Proteção Individual)
CREATE TABLE EPIs_Colaborador (
    ID_EPI INT IDENTITY(1,1) PRIMARY KEY,
    CPF VARCHAR(14) NOT NULL,
    Tipo_EPI NVARCHAR(50) NOT NULL, -- UNIFORM, BOTA, ÓCULOS, CAPACETE, LUVAS, CINTO, CADEADO
    Possui BIT DEFAULT 0,
    Data_Entrega DATE,
    Data_Validade DATE,
    Tamanho NVARCHAR(10),
    Observacoes NVARCHAR(500),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CPF) REFERENCES Colaboradores(CPF)
);
GO

-- Tabela: Alocacao de Pessoal (Ligação Colaborador -> Atividade)
CREATE TABLE Alocacao_Pessoal (
    ID_Alocacao INT IDENTITY(1,1) PRIMARY KEY,
    ID_Atividade INT NOT NULL,
    CPF VARCHAR(14) NOT NULL,
    Equipe NVARCHAR(50), -- EQUIPE 1 - LD, EQUIPE 2 - LE
    Data_Alocacao DATETIME2 DEFAULT GETDATE(),
    Data_Desalocacao DATETIME2,
    Status_Alocacao NVARCHAR(50) DEFAULT 'ATIVO', -- ATIVO, CONCLUÍDO, REMOVIDO
    Observacoes NVARCHAR(500),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Atividade) REFERENCES Atividades(ID_Atividade),
    FOREIGN KEY (CPF) REFERENCES Colaboradores(CPF)
);
GO

-- ============================================
-- MÓDULO 3: INVENTÁRIO E FERRAMENTAL
-- ============================================

-- Tabela: Categorias de Itens
CREATE TABLE Categorias_Item (
    ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    Nome_Categoria NVARCHAR(100) NOT NULL UNIQUE,
    Descricao NVARCHAR(500),
    Created_At DATETIME2 DEFAULT GETDATE()
);
GO

-- Tabela: Inventario (Catálogo de Equipamentos e Ferramentas)
CREATE TABLE Inventario (
    ID_Item INT IDENTITY(1,1) PRIMARY KEY,
    Codigo_Item NVARCHAR(50) UNIQUE,
    Descricao NVARCHAR(200) NOT NULL,
    ID_Categoria INT,
    Estoque_Atual INT DEFAULT 0,
    Estoque_Minimo INT DEFAULT 0,
    Unidade_Medida NVARCHAR(20) DEFAULT 'UN', -- UN, KG, M, L, etc
    Custo_Unitario DECIMAL(10,2),
    Custo_Aluguel_Dia DECIMAL(10,2),
    Local_Posse NVARCHAR(200), -- Ex: "Renault SJP", "Almoxarifado Central"
    Status_Item NVARCHAR(50) DEFAULT 'DISPONÍVEL', -- DISPONÍVEL, EM_USO, MANUTENÇÃO, INDISPONÍVEL
    Observacoes NVARCHAR(MAX), -- Ex: "Temos na Renault (3 confirmar)", "Aguardando visita fábrica"
    Created_At DATETIME2 DEFAULT GETDATE(),
    Updated_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Categoria) REFERENCES Categorias_Item(ID_Categoria)
);
GO

-- Tabela: Demanda de Ferramental por Atividade/Equipe
CREATE TABLE Demanda_Ferramental (
    ID_Demanda_Ferramental INT IDENTITY(1,1) PRIMARY KEY,
    ID_Atividade INT NOT NULL,
    Equipe NVARCHAR(50), -- EQUIPE 1 MECÂNICO, EQUIPE 2 ELÉTRICA, etc
    ID_Item INT NOT NULL,
    Quantidade_Necessaria INT NOT NULL,
    Quantidade_Alocada INT DEFAULT 0,
    Data_Necessidade DATE,
    Observacoes NVARCHAR(500),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Atividade) REFERENCES Atividades(ID_Atividade),
    FOREIGN KEY (ID_Item) REFERENCES Inventario(ID_Item)
);
GO

-- Tabela: Movimentacao de Inventario (Controle de Entrada/Saída)
CREATE TABLE Movimentacao_Inventario (
    ID_Movimentacao INT IDENTITY(1,1) PRIMARY KEY,
    ID_Item INT NOT NULL,
    Tipo_Movimentacao NVARCHAR(50) NOT NULL, -- ENTRADA, SAÍDA, TRANSFERÊNCIA, DEVOLUÇÃO
    Quantidade INT NOT NULL,
    ID_Atividade INT, -- Se aplicável
    CPF_Responsavel VARCHAR(14),
    Local_Origem NVARCHAR(200),
    Local_Destino NVARCHAR(200),
    Data_Movimentacao DATETIME2 DEFAULT GETDATE(),
    Motivo NVARCHAR(500),
    Observacoes NVARCHAR(MAX),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Item) REFERENCES Inventario(ID_Item),
    FOREIGN KEY (ID_Atividade) REFERENCES Atividades(ID_Atividade),
    FOREIGN KEY (CPF_Responsavel) REFERENCES Colaboradores(CPF)
);
GO

-- ============================================
-- MÓDULO 4: COMPRAS E SUPRIMENTOS
-- ============================================

-- Tabela: Pedidos de Compra/Aluguel
CREATE TABLE Pedidos_Compra (
    ID_Pedido INT IDENTITY(1,1) PRIMARY KEY,
    Numero_Pedido NVARCHAR(50) UNIQUE,
    OS_ID VARCHAR(20),
    Tipo_Pedido NVARCHAR(50) NOT NULL, -- COMPRA, ALUGUEL
    Fornecedor NVARCHAR(200),
    Data_Pedido DATETIME2 DEFAULT GETDATE(),
    Data_Previsao_Entrega DATE,
    Data_Entrega_Efetiva DATE,
    Status_Pedido NVARCHAR(50) DEFAULT 'PENDENTE', -- PENDENTE, APROVADO, EM_COTAÇÃO, AGUARDANDO_ENTREGA, CONCLUÍDO, CANCELADO
    Valor_Total DECIMAL(15,2),
    Forma_Pagamento NVARCHAR(50),
    Observacoes NVARCHAR(MAX),
    Created_At DATETIME2 DEFAULT GETDATE(),
    Updated_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (OS_ID) REFERENCES Projetos(OS_ID)
);
GO

-- Tabela: Itens do Pedido
CREATE TABLE Itens_Pedido (
    ID_Item_Pedido INT IDENTITY(1,1) PRIMARY KEY,
    ID_Pedido INT NOT NULL,
    ID_Item INT NOT NULL,
    Quantidade INT NOT NULL,
    Valor_Unitario DECIMAL(10,2),
    Valor_Total DECIMAL(15,2),
    Data_Necessidade DATE,
    Observacoes NVARCHAR(500),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos_Compra(ID_Pedido),
    FOREIGN KEY (ID_Item) REFERENCES Inventario(ID_Item)
);
GO

-- Tabela: Deficit Analysis (Resultado do Gap Analysis)
CREATE TABLE Analise_Deficit (
    ID_Analise INT IDENTITY(1,1) PRIMARY KEY,
    OS_ID VARCHAR(20) NOT NULL,
    ID_Item INT NOT NULL,
    Demanda_Total INT NOT NULL,
    Estoque_Disponivel INT NOT NULL,
    Deficit INT NOT NULL, -- Demanda - Estoque
    Acao_Sugerida NVARCHAR(50), -- COMPRAR, ALUGAR, TRANSFERIR, OK
    Prioridade NVARCHAR(20), -- ALTA, MÉDIA, BAIXA
    Status_Resolucao NVARCHAR(50) DEFAULT 'PENDENTE', -- PENDENTE, EM_PROCESSO, RESOLVIDO
    ID_Pedido INT, -- Se gerou pedido
    Data_Analise DATETIME2 DEFAULT GETDATE(),
    Observacoes NVARCHAR(MAX),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (OS_ID) REFERENCES Projetos(OS_ID),
    FOREIGN KEY (ID_Item) REFERENCES Inventario(ID_Item),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos_Compra(ID_Pedido)
);
GO

-- ============================================
-- MÓDULO 5: CUSTOS OPERACIONAIS
-- ============================================

-- Tabela: Custos por Atividade
CREATE TABLE Custos_Atividade (
    ID_Custo INT IDENTITY(1,1) PRIMARY KEY,
    ID_Atividade INT NOT NULL,
    Tipo_Custo NVARCHAR(50) NOT NULL, -- MÃO_DE_OBRA, EQUIPAMENTO, MATERIAL, LOGÍSTICA
    Valor_Hora DECIMAL(10,2),
    Horas_Previstas INT,
    Quantidade INT,
    Valor_Total DECIMAL(15,2),
    Descricao NVARCHAR(500),
    Created_At DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ID_Atividade) REFERENCES Atividades(ID_Atividade)
);
GO

-- ============================================
-- ÍNDICES PARA PERFORMANCE
-- ============================================

-- Índices em Colaboradores
CREATE INDEX IX_Colaboradores_Funcao ON Colaboradores(Funcao);
CREATE INDEX IX_Colaboradores_Status ON Colaboradores(Status_Geral);
GO

-- Índices em Certificacoes
CREATE INDEX IX_Certificacoes_CPF ON Certificacoes(CPF);
CREATE INDEX IX_Certificacoes_Validade ON Certificacoes(Data_Validade);
CREATE INDEX IX_Certificacoes_Status ON Certificacoes(Status);
GO

-- Índices em Inventario
CREATE INDEX IX_Inventario_Codigo ON Inventario(Codigo_Item);
CREATE INDEX IX_Inventario_Categoria ON Inventario(ID_Categoria);
CREATE INDEX IX_Inventario_Status ON Inventario(Status_Item);
GO

-- Índices em Atividades
CREATE INDEX IX_Atividades_OS ON Atividades(OS_ID);
CREATE INDEX IX_Atividades_Status ON Atividades(Status);
GO

-- Índices em Alocacao_Pessoal
CREATE INDEX IX_Alocacao_CPF ON Alocacao_Pessoal(CPF);
CREATE INDEX IX_Alocacao_Atividade ON Alocacao_Pessoal(ID_Atividade);
GO

PRINT 'Tabelas e índices criados com sucesso!';
GO
