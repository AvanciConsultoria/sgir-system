-- =====================================================================
-- SGIR - SEED DATA DEMONSTRACAO
-- Sistema de Gestao Integrada de Recursos
-- Data: Dezembro 2025
-- Versao: 1.0
-- =====================================================================

USE SGIR_DB;
GO

PRINT 'Iniciando carga de dados de demonstracao...';
GO

-- =====================================================================
-- 1. PROJETOS DE EXEMPLO
-- =====================================================================
PRINT '1. Inserindo projetos de exemplo...';

INSERT INTO Projetos (OsId, NomeProjeto, Cliente, Local, GestorProjeto, DataInicio, Descricao, DataCriacao, DataAtualizacao)
VALUES 
('PRJ-001', 'Alteracao Layout - Linha Montagem', 'COMAU', 'Renault SJP - PR', 'Leonardo Cominese', '2024-01-15', 'Modificacao do layout da linha de montagem com instalacao de novos equipamentos', GETDATE(), GETDATE()),
('PRJ-002', 'Manutencao Preventiva - Prensa Hidraulica', 'FIAT', 'FIAT Betim - MG', 'Carlos Silva', '2024-02-01', 'Manutencao completa da prensa hidraulica 500 toneladas', GETDATE(), GETDATE()),
('PRJ-003', 'Instalacao Eletrica Nova Celula', 'Renault', 'Renault Curitiba - PR', 'Ana Santos', '2024-02-15', 'Instalacao eletrica completa para nova celula robotizada', GETDATE(), GETDATE()),
('PRJ-004', 'Retrofit Maquina Solda', 'GM', 'GM Sao Caetano - SP', 'Roberto Lima', '2024-03-01', 'Modernizacao de equipamento de solda automatica', GETDATE(), GETDATE()),
('PRJ-005', 'Expancao Linha Producao', 'FORD', 'FORD Camacari - BA', 'Juliana Costa', '2024-03-10', 'Expansao da capacidade produtiva com nova linha', GETDATE(), GETDATE());

PRINT '   -> 5 projetos inseridos';
GO

-- =====================================================================
-- 2. COLABORADORES COM DIFERENTES STATUS
-- =====================================================================
PRINT '2. Inserindo colaboradores...';

INSERT INTO Colaboradores (CPF, Nome, Funcao, DataAdmissao, Telefone, Email, DataCriacao, DataAtualizacao)
VALUES 
('12345678900', 'Leonardo Cominese', 'Engenheiro Eletricista', '2020-01-10', '(41) 99999-0001', 'leonardo@avanci.com.br', GETDATE(), GETDATE()),
('23456789011', 'Carlos Alberto Silva', 'Tecnico Mecanico Senior', '2019-03-15', '(41) 99999-0002', 'carlos.silva@avanci.com.br', GETDATE(), GETDATE()),
('34567890122', 'Ana Paula Santos', 'Eletricista Predial', '2021-06-20', '(41) 99999-0003', 'ana.santos@avanci.com.br', GETDATE(), GETDATE()),
('45678901233', 'Roberto Lima Junior', 'Tecnico Eletronico', '2020-08-05', '(41) 99999-0004', 'roberto.lima@avanci.com.br', GETDATE(), GETDATE()),
('56789012344', 'Juliana Costa Souza', 'Engenheira Mecanica', '2022-01-12', '(41) 99999-0005', 'juliana.costa@avanci.com.br', GETDATE(), GETDATE()),
('67890123455', 'Pedro Henrique Alves', 'Tecnico Seguranca Trabalho', '2021-04-18', '(41) 99999-0006', 'pedro.alves@avanci.com.br', GETDATE(), GETDATE()),
('78901234566', 'Fernanda Oliveira', 'Eletricista Industrial', '2020-09-22', '(41) 99999-0007', 'fernanda.oliveira@avanci.com.br', GETDATE(), GETDATE()),
('89012345677', 'Marcos Paulo Dias', 'Mecanico Montador', '2019-11-30', '(41) 99999-0008', 'marcos.dias@avanci.com.br', GETDATE(), GETDATE()),
('90123456788', 'Claudia Regina Martins', 'Tecnico Instrumentacao', '2021-07-14', '(41) 99999-0009', 'claudia.martins@avanci.com.br', GETDATE(), GETDATE()),
('01234567899', 'Ricardo Fernandes', 'Supervisor Manutencao', '2018-05-08', '(41) 99999-0010', 'ricardo.fernandes@avanci.com.br', GETDATE(), GETDATE());

PRINT '   -> 10 colaboradores inseridos';
GO

-- =====================================================================
-- 3. CERTIFICACOES (Mix de VALIDAS e VENCIDAS)
-- =====================================================================
PRINT '3. Inserindo certificacoes...';

DECLARE @Hoje DATE = GETDATE();

-- Leonardo Cominese - TODAS VALIDAS (APTO)
INSERT INTO Certificacoes (CPF, TipoCertificacao, DataEmissao, DataValidade, Status, Observacoes, DataCriacao, DataAtualizacao)
VALUES 
('12345678900', 'NR-10', DATEADD(MONTH, -6, @Hoje), DATEADD(MONTH, 18, @Hoje), 'VALIDA', 'Basico + SEP', GETDATE(), GETDATE()),
('12345678900', 'NR-35', DATEADD(MONTH, -4, @Hoje), DATEADD(MONTH, 20, @Hoje), 'VALIDA', 'Trabalho em altura', GETDATE(), GETDATE()),
('12345678900', 'NR-12', DATEADD(MONTH, -3, @Hoje), DATEADD(MONTH, 21, @Hoje), 'VALIDA', 'Seguranca maquinas', GETDATE(), GETDATE());

-- Carlos Silva - 1 VENCIDA (INAPTO)
INSERT INTO Certificacoes (CPF, TipoCertificacao, DataEmissao, DataValidade, Status, Observacoes, DataCriacao, DataAtualizacao)
VALUES 
('23456789011', 'NR-12', DATEADD(MONTH, -30, @Hoje), DATEADD(MONTH, -6, @Hoje), 'VENCIDA', 'Precisa renovar', GETDATE(), GETDATE()),
('23456789011', 'NR-35', DATEADD(MONTH, -5, @Hoje), DATEADD(MONTH, 19, @Hoje), 'VALIDA', 'Altura', GETDATE(), GETDATE());

-- Ana Santos - TODAS VALIDAS (APTO)
INSERT INTO Certificacoes (CPF, TipoCertificacao, DataEmissao, DataValidade, Status, Observacoes, DataCriacao, DataAtualizacao)
VALUES 
('34567890122', 'NR-10', DATEADD(MONTH, -8, @Hoje), DATEADD(MONTH, 16, @Hoje), 'VALIDA', 'Basico', GETDATE(), GETDATE()),
('34567890122', 'NR-35', DATEADD(MONTH, -2, @Hoje), DATEADD(MONTH, 22, @Hoje), 'VALIDA', 'Altura', GETDATE(), GETDATE());

-- Roberto Lima - VENCENDO EM 20 DIAS (ALERTA)
INSERT INTO Certificacoes (CPF, TipoCertificacao, DataEmissao, DataValidade, Status, Observacoes, DataCriacao, DataAtualizacao)
VALUES 
('45678901233', 'NR-10', DATEADD(MONTH, -23, @Hoje), DATEADD(DAY, 20, @Hoje), 'VENCENDO', 'Renovar urgente', GETDATE(), GETDATE()),
('45678901233', 'NR-12', DATEADD(MONTH, -5, @Hoje), DATEADD(MONTH, 19, @Hoje), 'VALIDA', 'OK', GETDATE(), GETDATE());

-- Juliana Costa - TODAS VALIDAS (APTO)
INSERT INTO Certificacoes (CPF, TipoCertificacao, DataEmissao, DataValidade, Status, Observacoes, DataCriacao, DataAtualizacao)
VALUES 
('56789012344', 'NR-12', DATEADD(MONTH, -4, @Hoje), DATEADD(MONTH, 20, @Hoje), 'VALIDA', 'Maquinas', GETDATE(), GETDATE()),
('56789012344', 'NR-35', DATEADD(MONTH, -3, @Hoje), DATEADD(MONTH, 21, @Hoje), 'VALIDA', 'Altura', GETDATE(), GETDATE());

PRINT '   -> Certificacoes inseridas (mix de validas/vencidas)';
GO

-- =====================================================================
-- 4. FERRAMENTAS E EQUIPAMENTOS (50 ITENS)
-- =====================================================================
PRINT '4. Inserindo ferramentas e equipamentos...';

-- FERRAMENTAS MANUAIS (15 itens)
INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('Alicate Universal 8 polegadas', 'FERRAMENTA_MANUAL', 'KNIPEX', '0201200', 'UN', 15, 5, 'Almoxarifado Central', 89.90, '', GETDATE(), GETDATE()),
('Chave Philips PH2', 'FERRAMENTA_MANUAL', 'TRAMONTINA', 'PHD-02', 'UN', 20, 10, 'Almoxarifado Central', 12.50, '', GETDATE(), GETDATE()),
('Chave Fenda 1/4', 'FERRAMENTA_MANUAL', 'TRAMONTINA', 'SLT-14', 'UN', 18, 10, 'Almoxarifado Central', 10.90, '', GETDATE(), GETDATE()),
('Jogo Chaves Allen', 'FERRAMENTA_MANUAL', 'GEDORE', 'SET-HEX-9', 'JG', 8, 3, 'Almoxarifado Central', 145.00, '', GETDATE(), GETDATE()),
('Martelo Borracha', 'FERRAMENTA_MANUAL', 'STANLEY', 'RH-500', 'UN', 10, 4, 'Almoxarifado Central', 45.90, '', GETDATE(), GETDATE()),
('Torquimetro 10-60Nm', 'FERRAMENTA_MANUAL', 'GEDORE', 'DREMOMETER-60', 'UN', 5, 2, 'Almoxarifado Central', 890.00, '', GETDATE(), GETDATE()),
('Chave Inglesa 12', 'FERRAMENTA_MANUAL', 'TRAMONTINA', 'ADJ-12', 'UN', 12, 5, 'Almoxarifado Central', 67.50, '', GETDATE(), GETDATE()),
('Alicate Corte Diagonal', 'FERRAMENTA_MANUAL', 'KNIPEX', '7402180', 'UN', 10, 4, 'Almoxarifado Central', 125.00, '', GETDATE(), GETDATE()),
('Alicate Pressao 10', 'FERRAMENTA_MANUAL', 'IRWIN', 'VP10R', 'UN', 8, 3, 'Almoxarifado Central', 78.90, '', GETDATE(), GETDATE()),
('Jogo Chaves Combinadas', 'FERRAMENTA_MANUAL', 'GEDORE', 'SET-COMB-12', 'JG', 6, 2, 'Almoxarifado Central', 345.00, '', GETDATE(), GETDATE()),
('Nivel Bolha Aluminio', 'FERRAMENTA_MANUAL', 'STANLEY', 'LEV-40CM', 'UN', 8, 3, 'Almoxarifado Central', 89.00, '', GETDATE(), GETDATE()),
('Trena 5 metros', 'FERRAMENTA_MANUAL', 'STANLEY', 'TAPE-5M', 'UN', 15, 8, 'Almoxarifado Central', 34.90, '', GETDATE(), GETDATE()),
('Serra Manual', 'FERRAMENTA_MANUAL', 'STARRETT', 'HS-12', 'UN', 6, 2, 'Almoxarifado Central', 125.00, '', GETDATE(), GETDATE()),
('Lima Chata Murca', 'FERRAMENTA_MANUAL', 'PFERD', 'FLAT-200', 'UN', 20, 10, 'Almoxarifado Central', 18.50, '', GETDATE(), GETDATE()),
('Esquadro Metalico 90', 'FERRAMENTA_MANUAL', 'STARRETT', 'SQ-100', 'UN', 5, 2, 'Almoxarifado Central', 189.00, '', GETDATE(), GETDATE());

PRINT '   -> 15 ferramentas manuais inseridas';

-- FERRAMENTAS ELETRICAS (10 itens)
INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('Parafusadeira Eletrica 12V', 'FERRAMENTA_ELETRICA', 'BOSCH', 'GSR-120LI', 'UN', 8, 3, 'Almoxarifado Central', 450.00, '', GETDATE(), GETDATE()),
('Furadeira Impacto 1/2', 'FERRAMENTA_ELETRICA', 'MAKITA', 'HP1640', 'UN', 6, 2, 'Almoxarifado Central', 589.00, '', GETDATE(), GETDATE()),
('Esmerilhadeira Angular 4.1/2', 'FERRAMENTA_ELETRICA', 'DEWALT', 'DWE4120', 'UN', 5, 2, 'Almoxarifado Central', 378.90, '', GETDATE(), GETDATE()),
('Serra Circular 7.1/4', 'FERRAMENTA_ELETRICA', 'MAKITA', '5007MG', 'UN', 4, 2, 'Almoxarifado Central', 689.00, '', GETDATE(), GETDATE()),
('Retifica Reta', 'FERRAMENTA_ELETRICA', 'BOSCH', 'GGS-28L', 'UN', 3, 1, 'Almoxarifado Central', 1250.00, '', GETDATE(), GETDATE()),
('Politriz Rotativa', 'FERRAMENTA_ELETRICA', 'BOSCH', 'GPO-14CE', 'UN', 3, 1, 'Almoxarifado Central', 890.00, '', GETDATE(), GETDATE()),
('Lixadeira Orbital', 'FERRAMENTA_ELETRICA', 'MAKITA', 'BO4556', 'UN', 4, 2, 'Almoxarifado Central', 345.00, '', GETDATE(), GETDATE()),
('Martelete Perfurador SDS', 'FERRAMENTA_ELETRICA', 'DEWALT', 'D25133K', 'UN', 3, 1, 'Almoxarifado Central', 1890.00, '', GETDATE(), GETDATE()),
('Soprador Termico', 'FERRAMENTA_ELETRICA', 'BOSCH', 'GHG-630DCE', 'UN', 4, 2, 'Almoxarifado Central', 456.90, '', GETDATE(), GETDATE()),
('Parafusadeira Impacto 18V', 'FERRAMENTA_ELETRICA', 'DEWALT', 'DCF887', 'UN', 5, 2, 'Almoxarifado Central', 1234.00, '', GETDATE(), GETDATE());

PRINT '   -> 10 ferramentas eletricas inseridas';

-- INSTRUMENTOS DE MEDICAO (10 itens)
INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('Multimetro Digital', 'INSTRUMENTO_MEDICAO', 'FLUKE', '117', 'UN', 8, 3, 'Almoxarifado Central', 890.00, '', GETDATE(), GETDATE()),
('Alicate Amperimetro', 'INSTRUMENTO_MEDICAO', 'FLUKE', '376FC', 'UN', 5, 2, 'Almoxarifado Central', 2890.00, '', GETDATE(), GETDATE()),
('Trena Laser', 'INSTRUMENTO_MEDICAO', 'BOSCH', 'GLM-50C', 'UN', 6, 2, 'Almoxarifado Central', 567.00, '', GETDATE(), GETDATE()),
('Nivel Laser', 'INSTRUMENTO_MEDICAO', 'BOSCH', 'GLL-3-80', 'UN', 4, 1, 'Almoxarifado Central', 1890.00, '', GETDATE(), GETDATE()),
('Paquimetro Digital 150mm', 'INSTRUMENTO_MEDICAO', 'MITUTOYO', '500-196-30', 'UN', 10, 5, 'Almoxarifado Central', 678.00, '', GETDATE(), GETDATE()),
('Micrometro Externo 0-25mm', 'INSTRUMENTO_MEDICAO', 'MITUTOYO', '103-137', 'UN', 8, 3, 'Almoxarifado Central', 456.90, '', GETDATE(), GETDATE()),
('Termometro Infravermelho', 'INSTRUMENTO_MEDICAO', 'FLUKE', '62MAX', 'UN', 5, 2, 'Almoxarifado Central', 345.00, '', GETDATE(), GETDATE()),
('Tacometro Digital', 'INSTRUMENTO_MEDICAO', 'INSTRUTHERM', 'TD-200', 'UN', 4, 2, 'Almoxarifado Central', 289.00, '', GETDATE(), GETDATE()),
('Decibelimetro', 'INSTRUMENTO_MEDICAO', 'INSTRUTHERM', 'DEC-490', 'UN', 3, 1, 'Almoxarifado Central', 567.00, '', GETDATE(), GETDATE()),
('Terrometro Digital', 'INSTRUMENTO_MEDICAO', 'MEGABRAS', 'MTR-1522', 'UN', 3, 1, 'Almoxarifado Central', 1234.00, '', GETDATE(), GETDATE());

PRINT '   -> 10 instrumentos de medicao inseridos';

-- EQUIPAMENTOS DE PROTECAO (10 itens)
INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('Capacete Seguranca Branco', 'EPI', '3M', 'H-700', 'UN', 25, 10, 'Almoxarifado Central', 45.90, '', GETDATE(), GETDATE()),
('Oculos Protecao Incolor', 'EPI', '3M', 'SS1101', 'UN', 40, 20, 'Almoxarifado Central', 12.50, '', GETDATE(), GETDATE()),
('Luva Latex Amarela', 'EPI', 'DANNY', 'LUV-LAT-G', 'PR', 50, 30, 'Almoxarifado Central', 8.90, '', GETDATE(), GETDATE()),
('Bota Seguranca PU', 'EPI', 'MARLUVAS', 'BOOT-50S29', 'PR', 20, 10, 'Almoxarifado Central', 89.00, '', GETDATE(), GETDATE()),
('Protetor Auricular Tipo Concha', 'EPI', '3M', 'PELTOR-H10A', 'UN', 30, 15, 'Almoxarifado Central', 67.50, '', GETDATE(), GETDATE()),
('Mascara PFF2 com Valvula', 'EPI', '3M', '8822', 'UN', 100, 50, 'Almoxarifado Central', 18.90, '', GETDATE(), GETDATE()),
('Cinto Seguranca Paraquedista', 'EPI', 'CARBOGRAFITE', 'CG-700', 'UN', 15, 5, 'Almoxarifado Central', 234.00, '', GETDATE(), GETDATE()),
('Talabarte Duplo Y', 'EPI', 'CARBOGRAFITE', 'TB-517', 'UN', 15, 5, 'Almoxarifado Central', 189.00, '', GETDATE(), GETDATE()),
('Luva Vaqueta', 'EPI', 'KALIPSO', 'VAQ-805', 'PR', 40, 20, 'Almoxarifado Central', 23.50, '', GETDATE(), GETDATE()),
('Uniforme NR-10 Classe 2', 'EPI', 'VONDER', 'UNI-NR10-G', 'CJ', 20, 10, 'Almoxarifado Central', 456.00, '', GETDATE(), GETDATE());

PRINT '   -> 10 EPIs inseridos';

-- CONSUMIVEIS (5 itens)
INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('Fita Isolante Preta', 'CONSUMIVEL', '3M', 'ISO-20M', 'UN', 50, 30, 'Almoxarifado Central', 4.50, '', GETDATE(), GETDATE()),
('Graxa Multiuso 500g', 'CONSUMIVEL', 'TAPMATIC', 'GRX-500', 'UN', 30, 15, 'Almoxarifado Central', 18.90, '', GETDATE(), GETDATE()),
('Spray Desengripante WD-40', 'CONSUMIVEL', 'WD-40', 'WD40-300ML', 'UN', 40, 20, 'Almoxarifado Central', 23.50, '', GETDATE(), GETDATE()),
('Disco Corte 4.1/2', 'CONSUMIVEL', 'NORTON', 'BDA-115', 'UN', 100, 50, 'Almoxarifado Central', 3.90, '', GETDATE(), GETDATE()),
('Lixa Ferro Grao 80', 'CONSUMIVEL', 'NORTON', 'LIX-80-FERRO', 'UN', 200, 100, 'Almoxarifado Central', 1.20, '', GETDATE(), GETDATE());

PRINT '   -> 5 consumiveis inseridos';
PRINT '   -> TOTAL: 50 ferramentas/equipamentos inseridos';
GO

-- =====================================================================
-- 5. CAIXAS DE FERRAMENTAS PRE-MONTADAS
-- =====================================================================
PRINT '5. Criando caixas de ferramentas pre-montadas...';

INSERT INTO Caixas_Ferramentas (Codigo, Descricao, Tipo, LocalAtual, DataCriacao, DataAtualizacao)
VALUES 
('CX-MEC-001', 'Caixa Mecanica Basica', 'MECANICA', 'Almoxarifado Central', GETDATE(), GETDATE()),
('CX-MEC-002', 'Caixa Mecanica Completa', 'MECANICA', 'Almoxarifado Central', GETDATE(), GETDATE()),
('CX-ELE-001', 'Caixa Eletrica Basica', 'ELETRICA', 'Almoxarifado Central', GETDATE(), GETDATE()),
('CX-ELE-002', 'Caixa Eletrica Instrumentacao', 'ELETRICA', 'Almoxarifado Central', GETDATE(), GETDATE()),
('CX-MED-001', 'Caixa Instrumentos Medicao', 'INSTRUMENTACAO', 'Almoxarifado Central', GETDATE(), GETDATE());

PRINT '   -> 5 caixas criadas';

-- Adicionar itens nas caixas (reduzindo estoque automaticamente via trigger)
PRINT '   -> Adicionando itens nas caixas...';

-- CX-MEC-001
INSERT INTO Caixas_Itens (CaixaId, ItemEstoqueId, Quantidade, DataCriacao, DataAtualizacao)
SELECT 
    (SELECT Id FROM Caixas_Ferramentas WHERE Codigo = 'CX-MEC-001'),
    Id,
    3
FROM Itens_Estoque
WHERE Descricao IN ('Alicate Universal 8 polegadas', 'Chave Philips PH2', 'Chave Fenda 1/4', 'Martelo Borracha');

-- CX-ELE-001
INSERT INTO Caixas_Itens (CaixaId, ItemEstoqueId, Quantidade, DataCriacao, DataAtualizacao)
SELECT 
    (SELECT Id FROM Caixas_Ferramentas WHERE Codigo = 'CX-ELE-001'),
    Id,
    2
FROM Itens_Estoque
WHERE Descricao IN ('Parafusadeira Eletrica 12V', 'Alicate Corte Diagonal', 'Multimetro Digital', 'Fita Isolante Preta');

PRINT '   -> Itens adicionados nas caixas';
GO

-- =====================================================================
-- RESUMO FINAL
-- =====================================================================
PRINT '';
PRINT '============================================================';
PRINT 'CARGA DE DADOS CONCLUIDA COM SUCESSO!';
PRINT '============================================================';
PRINT '';
PRINT 'RESUMO:';
PRINT '  - 5 Projetos';
PRINT '  - 10 Colaboradores';
PRINT '  - 13 Certificacoes (mix validas/vencidas)';
PRINT '  - 50 Ferramentas/Equipamentos';
PRINT '  - 5 Caixas de Ferramentas pre-montadas';
PRINT '';
PRINT 'O sistema esta pronto para uso com dados de demonstracao!';
PRINT 'Acesse: http://localhost:5000';
PRINT '';
GO
