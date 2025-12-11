-- =====================================================================
-- SGIR - IMPORTAÇÃO CATÁLOGOS SINAPI E FERRAMENTAS MANUAIS
-- Baseado em: SINAPI setembro/2025 + Catálogo Ferramentas Manuais
-- Total estimado: 200+ itens profissionais
-- Data: 2025-12-10
-- =====================================================================

-- NOTA: Este é um subconjunto dos catálogos completos.
-- Para importação completa dos milhares de itens, use o script Python.

PRINT 'Importando itens dos catálogos SINAPI e Ferramentas...';
GO

-- =====================================================================
-- FERRAMENTAS MANUAIS - ALICATES (baseado no PDF)
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
-- Alicates de alta qualidade
('ALICATE UNIVERSAL 6" ISOLADO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'ALU-6-1000V', 'UN', 0, 3, 'Almoxarifado Central', 125.00, 'Atende norma EN/IEC 60900:2004, cabo isolado VDE 1000V', GETDATE(), GETDATE()),
('ALICATE UNIVERSAL 8" ISOLADO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'ALU-8-1000V', 'UN', 0, 5, 'Almoxarifado Central', 145.00, 'Atende norma EN/IEC 60900:2004, cabo isolado VDE 1000V', GETDATE(), GETDATE()),
('ALICATE CORTE DIAGONAL 6" ISOLADO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'ACD-6-1000V', 'UN', 0, 3, 'Almoxarifado Central', 135.00, 'Para cortar e desencapar fios e cabos, norma EN/IEC 60900:2004', GETDATE(), GETDATE()),
('ALICATE CORTE DIAGONAL 8" ISOLADO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'ACD-8-1000V', 'UN', 0, 5, 'Almoxarifado Central', 155.00, 'Para cortar e desencapar fios e cabos, norma EN/IEC 60900:2004', GETDATE(), GETDATE()),
('ALICATE BICO MEIA CANA 6" ISOLADO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'ABMC-6-1000V', 'UN', 0, 2, 'Almoxarifado Central', 140.00, 'Bico longo para acesso em locais restritos, isolado VDE', GETDATE(), GETDATE()),
('ALICATE BICO CHATO 6" ISOLADO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'ABC-6-1000V', 'UN', 0, 2, 'Almoxarifado Central', 140.00, 'Para dobrar e segurar peças, isolado VDE', GETDATE(), GETDATE()),
('ALICATE CRIMPADOR RJ45/RJ11', 'FERRAMENTA_MANUAL', 'Diversos', 'ACR-RJ45', 'UN', 0, 2, 'Almoxarifado Central', 85.00, 'Para crimpar conectores de rede', GETDATE(), GETDATE()),
('ALICATE DESENCAPADOR FIOS 0,5-6mm²', 'FERRAMENTA_MANUAL', 'Diversos', 'ADF-6MM', 'UN', 0, 3, 'Almoxarifado Central', 65.00, 'Desencapador automático ajustável', GETDATE(), GETDATE()),
('ALICATE AMPERIMETRO 1000A AC/DC', 'FERRAMENTA_MANUAL', 'Diversos', 'AMP-1000A', 'UN', 0, 2, 'Almoxarifado Central', 450.00, 'Medição de corrente sem interromper circuito', GETDATE(), GETDATE()),
('ALICATE PRENSA TERMINAL 0,5-6mm²', 'FERRAMENTA_MANUAL', 'Diversos', 'APT-6MM', 'UN', 0, 2, 'Almoxarifado Central', 195.00, 'Para terminais e conectores elétricos', GETDATE(), GETDATE());

PRINT '   -> 10 tipos de alicates importados';
GO

-- =====================================================================
-- FERRAMENTAS MANUAIS - CHAVES E FERRAMENTAS DE APERTO
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
-- Chaves de boca e estrela
('CHAVE COMBINADA 8mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-8MM', 'UN', 0, 3, 'Almoxarifado Central', 18.50, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 10mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-10MM', 'UN', 0, 5, 'Almoxarifado Central', 19.90, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 12mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-12MM', 'UN', 0, 5, 'Almoxarifado Central', 21.50, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 13mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-13MM', 'UN', 0, 5, 'Almoxarifado Central', 22.90, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 14mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-14MM', 'UN', 0, 4, 'Almoxarifado Central', 23.90, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 17mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-17MM', 'UN', 0, 5, 'Almoxarifado Central', 28.90, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 19mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-19MM', 'UN', 0, 4, 'Almoxarifado Central', 32.90, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('CHAVE COMBINADA 22mm', 'FERRAMENTA_MANUAL', 'Diversos', 'CC-22MM', 'UN', 0, 3, 'Almoxarifado Central', 42.90, 'Chave fixa combinada (boca e estrela)', GETDATE(), GETDATE()),
('JOGO CHAVES ALLEN 1,5-10mm (9 PECAS)', 'FERRAMENTA_MANUAL', 'Diversos', 'JCA-9PC', 'JOGO', 0, 3, 'Almoxarifado Central', 65.00, 'Jogo completo de chaves Allen métricas', GETDATE(), GETDATE()),
('JOGO CHAVES TORX T10-T50 (9 PECAS)', 'FERRAMENTA_MANUAL', 'Diversos', 'JCT-9PC', 'JOGO', 0, 2, 'Almoxarifado Central', 85.00, 'Jogo completo de chaves Torx', GETDATE(), GETDATE()),
('CHAVE INGLESA 10" AJUSTAVEL', 'FERRAMENTA_MANUAL', 'Diversos', 'CI-10', 'UN', 0, 3, 'Almoxarifado Central', 58.00, 'Chave ajustável para porcas e parafusos', GETDATE(), GETDATE()),
('CHAVE INGLESA 12" AJUSTAVEL', 'FERRAMENTA_MANUAL', 'Diversos', 'CI-12', 'UN', 0, 3, 'Almoxarifado Central', 75.00, 'Chave ajustável para porcas e parafusos', GETDATE(), GETDATE()),
('CHAVE CATRACA 1/2" COM 10 SOQUETES', 'FERRAMENTA_MANUAL', 'Diversos', 'CCR-1/2-10', 'CJ', 0, 2, 'Almoxarifado Central', 285.00, 'Catraca reversível com soquetes 10-24mm', GETDATE(), GETDATE()),
('CHAVE TORQUIMETRO 1/2" 40-200Nm', 'FERRAMENTA_MANUAL', 'Diversos', 'CTQ-200', 'UN', 0, 2, 'Almoxarifado Central', 650.00, 'Torquímetro de estalo, certificado', GETDATE(), GETDATE()),
('CHAVE PHILIPS ISOLADA #1 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'CPH1-1000V', 'UN', 0, 5, 'Almoxarifado Central', 45.00, 'Chave phillips isolada VDE', GETDATE(), GETDATE()),
('CHAVE PHILIPS ISOLADA #2 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'CPH2-1000V', 'UN', 0, 8, 'Almoxarifado Central', 48.00, 'Chave phillips isolada VDE', GETDATE(), GETDATE()),
('CHAVE FENDA ISOLADA 3mm 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'CFD3-1000V', 'UN', 0, 5, 'Almoxarifado Central', 42.00, 'Chave fenda isolada VDE', GETDATE(), GETDATE()),
('CHAVE FENDA ISOLADA 5mm 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'CFD5-1000V', 'UN', 0, 8, 'Almoxarifado Central', 45.00, 'Chave fenda isolada VDE', GETDATE(), GETDATE()),
('JOGO CHAVES PRECISAO 32 PECAS', 'FERRAMENTA_MANUAL', 'Diversos', 'JCP-32', 'JOGO', 0, 2, 'Almoxarifado Central', 120.00, 'Para eletrônica e dispositivos pequenos', GETDATE(), GETDATE()),
('CHAVE DINAMOMETRICA DIGITAL 3-15Nm', 'FERRAMENTA_MANUAL', 'Diversos', 'CDD-15', 'UN', 0, 1, 'Almoxarifado Central', 850.00, 'Display digital, alta precisão', GETDATE(), GETDATE());

PRINT '   -> 20 tipos de chaves importados';
GO

-- =====================================================================
-- FERRAMENTAS MANUAIS - MARTELOS, MARRETAS E FERRAMENTAS DE IMPACTO
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('MARTELO UNHA 27mm (500g)', 'FERRAMENTA_MANUAL', 'Diversos', 'MU-500', 'UN', 0, 4, 'Almoxarifado Central', 35.00, 'Martelo carpinteiro cabo de madeira', GETDATE(), GETDATE()),
('MARTELO BOLA 32mm (750g)', 'FERRAMENTA_MANUAL', 'Diversos', 'MB-750', 'UN', 0, 3, 'Almoxarifado Central', 42.00, 'Martelo mecânico cabo de fibra', GETDATE(), GETDATE()),
('MARRETA 1kg CABO FIBRA', 'FERRAMENTA_MANUAL', 'Diversos', 'MAR-1KG', 'UN', 0, 3, 'Almoxarifado Central', 55.00, 'Marreta forjada em aço', GETDATE(), GETDATE()),
('MARRETA 2kg CABO FIBRA', 'FERRAMENTA_MANUAL', 'Diversos', 'MAR-2KG', 'UN', 0, 2, 'Almoxarifado Central', 68.00, 'Marreta forjada em aço', GETDATE(), GETDATE()),
('MARRETA 5kg CABO MADEIRA', 'FERRAMENTA_MANUAL', 'Diversos', 'MAR-5KG', 'UN', 0, 2, 'Almoxarifado Central', 95.00, 'Marreta pesada para demolição', GETDATE(), GETDATE()),
('MARTELO BORRACHA 500g', 'FERRAMENTA_MANUAL', 'Diversos', 'MBOR-500', 'UN', 0, 2, 'Almoxarifado Central', 38.00, 'Martelo de borracha para montagem', GETDATE(), GETDATE()),
('MARTELO PLASTICO BRANCO 40mm', 'FERRAMENTA_MANUAL', 'Diversos', 'MPLA-40', 'UN', 0, 2, 'Almoxarifado Central', 45.00, 'Não marca superfícies', GETDATE(), GETDATE()),
('PONTEIRO ACO 250mm', 'FERRAMENTA_MANUAL', 'Diversos', 'PON-250', 'UN', 0, 3, 'Almoxarifado Central', 22.00, 'Ponteiro para chanfrar e marcar', GETDATE(), GETDATE()),
('TALHADEIRA 19mm (3/4")', 'FERRAMENTA_MANUAL', 'Diversos', 'TAL-19', 'UN', 0, 2, 'Almoxarifado Central', 28.00, 'Talhadeira para corte de metal', GETDATE(), GETDATE()),
('BEDAME 25mm', 'FERRAMENTA_MANUAL', 'Diversos', 'BED-25', 'UN', 0, 2, 'Almoxarifado Central', 32.00, 'Formão para trabalhos em madeira', GETDATE(), GETDATE());

PRINT '   -> 10 tipos de martelos e ferramentas de impacto importados';
GO

-- =====================================================================
-- FERRAMENTAS MANUAIS - SERRAS, CORTE E USINAGEM
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('ARCO SERRA 12" REGULAVEL', 'FERRAMENTA_MANUAL', 'Diversos', 'AS-12', 'UN', 0, 3, 'Almoxarifado Central', 35.00, 'Arco de serra profissional ajustável', GETDATE(), GETDATE()),
('LAMINA SERRA BIMETAL 12" 24DPP (PACOTE 10un)', 'FERRAMENTA_MANUAL', 'Diversos', 'LS-12-24', 'PC', 0, 5, 'Almoxarifado Central', 65.00, 'Lâminas bimetálicas resistentes', GETDATE(), GETDATE()),
('LAMINA SERRA BIMETAL 12" 18DPP (PACOTE 10un)', 'FERRAMENTA_MANUAL', 'Diversos', 'LS-12-18', 'PC', 0, 5, 'Almoxarifado Central', 65.00, 'Para cortes em tubos e perfis', GETDATE(), GETDATE()),
('SERRA COPO 32mm BI-METAL', 'FERRAMENTA_MANUAL', 'Diversos', 'SC-32', 'UN', 0, 2, 'Almoxarifado Central', 45.00, 'Serra copo para furos em metal', GETDATE(), GETDATE()),
('SERRA COPO 51mm BI-METAL', 'FERRAMENTA_MANUAL', 'Diversos', 'SC-51', 'UN', 0, 2, 'Almoxarifado Central', 58.00, 'Serra copo para furos em metal', GETDATE(), GETDATE()),
('JOGO SERRA COPO 19-64mm (6 PECAS)', 'FERRAMENTA_MANUAL', 'Diversos', 'JSC-6', 'JOGO', 0, 1, 'Almoxarifado Central', 285.00, 'Jogo completo com mandril', GETDATE(), GETDATE()),
('LIMA CHATA BASTARDA 8"', 'FERRAMENTA_MANUAL', 'Diversos', 'LC-8', 'UN', 0, 3, 'Almoxarifado Central', 22.00, 'Lima para desbaste', GETDATE(), GETDATE()),
('LIMA MEIA CANA MURCA 8"', 'FERRAMENTA_MANUAL', 'Diversos', 'LMC-8', 'UN', 0, 2, 'Almoxarifado Central', 24.00, 'Lima para acabamento', GETDATE(), GETDATE()),
('LIMA REDONDA MURCA 8"', 'FERRAMENTA_MANUAL', 'Diversos', 'LR-8', 'UN', 0, 2, 'Almoxarifado Central', 24.00, 'Lima para furos circulares', GETDATE(), GETDATE()),
('JOGO LIMAS 8" (5 PECAS)', 'FERRAMENTA_MANUAL', 'Diversos', 'JL-5', 'JOGO', 0, 2, 'Almoxarifado Central', 95.00, 'Jogo de limas sortidas', GETDATE(), GETDATE()),
('ALARGADOR AJUSTAVEL 6-19mm', 'FERRAMENTA_MANUAL', 'Diversos', 'ALA-19', 'UN', 0, 1, 'Almoxarifado Central', 180.00, 'Alargador cônico ajustável', GETDATE(), GETDATE()),
('ESCAREADOR 90 GRAUS 12mm', 'FERRAMENTA_MANUAL', 'Diversos', 'ESC-12', 'UN', 0, 2, 'Almoxarifado Central', 45.00, 'Escareador para rebaixar parafusos', GETDATE(), GETDATE());

PRINT '   -> 12 tipos de serras e ferramentas de corte importados';
GO

-- =====================================================================
-- INSTRUMENTOS DE MEDICAO E TESTE
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('TRENA 5m x 19mm FREIO AUTOMATICO', 'FERRAMENTA_MANUAL', 'Diversos', 'TRE-5M', 'UN', 0, 5, 'Almoxarifado Central', 28.00, 'Trena com trava e clip de cinto', GETDATE(), GETDATE()),
('TRENA 8m x 25mm FITA ACI INOX', 'FERRAMENTA_MANUAL', 'Diversos', 'TRE-8M', 'UN', 0, 3, 'Almoxarifado Central', 45.00, 'Trena profissional robusta', GETDATE(), GETDATE()),
('TRENA A LASER 40m BLUETOOTH', 'FERRAMENTA_MANUAL', 'Diversos', 'TRL-40', 'UN', 0, 2, 'Almoxarifado Central', 450.00, 'Medidor laser com app smartphone', GETDATE(), GETDATE()),
('NIVEL ALUMINIO 60cm 3 BOLHAS', 'FERRAMENTA_MANUAL', 'Diversos', 'NIV-60', 'UN', 0, 3, 'Almoxarifado Central', 65.00, 'Nível de bolha profissional', GETDATE(), GETDATE()),
('NIVEL ALUMINIO 120cm 3 BOLHAS', 'FERRAMENTA_MANUAL', 'Diversos', 'NIV-120', 'UN', 0, 2, 'Almoxarifado Central', 95.00, 'Nível de bolha profissional', GETDATE(), GETDATE()),
('NIVEL A LASER VERDE AUTONIVELANTE', 'FERRAMENTA_MANUAL', 'Diversos', 'NIVL-AUTO', 'UN', 0, 2, 'Almoxarifado Central', 850.00, 'Nível laser verde 360 graus', GETDATE(), GETDATE()),
('ESQUADRO CARPINTEIRO 300mm', 'FERRAMENTA_MANUAL', 'Diversos', 'ESQ-300', 'UN', 0, 2, 'Almoxarifado Central', 48.00, 'Esquadro metálico graduado', GETDATE(), GETDATE()),
('PAQUIMETRO DIGITAL 150mm', 'FERRAMENTA_MANUAL', 'Diversos', 'PAQ-150D', 'UN', 0, 3, 'Almoxarifado Central', 180.00, 'Paquímetro digital precisão 0,01mm', GETDATE(), GETDATE()),
('PAQUIMETRO ANALOGICO 200mm', 'FERRAMENTA_MANUAL', 'Diversos', 'PAQ-200A', 'UN', 0, 2, 'Almoxarifado Central', 125.00, 'Paquímetro vernier em aço inox', GETDATE(), GETDATE()),
('MICROMETRO EXTERNO 0-25mm', 'FERRAMENTA_MANUAL', 'Diversos', 'MIC-25', 'UN', 0, 2, 'Almoxarifado Central', 250.00, 'Micrômetro precisão 0,01mm', GETDATE(), GETDATE()),
('TRANSFERIDOR ANGULOS 360 GRAUS', 'FERRAMENTA_MANUAL', 'Diversos', 'TRA-360', 'UN', 0, 2, 'Almoxarifado Central', 35.00, 'Transferidor metálico articulado', GETDATE(), GETDATE()),
('MULTIMETRO DIGITAL TRUE RMS', 'FERRAMENTA_MANUAL', 'Diversos', 'MULT-TRMS', 'UN', 0, 3, 'Almoxarifado Central', 285.00, 'Multímetro True RMS CAT III 600V', GETDATE(), GETDATE()),
('MEGOHMETRO 1000V DIGITAL', 'FERRAMENTA_MANUAL', 'Diversos', 'MEG-1000', 'UN', 0, 1, 'Almoxarifado Central', 1850.00, 'Megômetro para isolação elétrica', GETDATE(), GETDATE()),
('DETECTOR TENSAO SEM CONTATO 1000V', 'FERRAMENTA_MANUAL', 'Diversos', 'DET-1000', 'UN', 0, 5, 'Almoxarifado Central', 85.00, 'Detector de tensão por aproximação', GETDATE(), GETDATE());

PRINT '   -> 14 tipos de instrumentos de medição importados';
GO

-- =====================================================================
-- FERRAMENTAS PNEUMATICAS E HIDRAULICAS (baseado em SINAPI)
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('PARAFUSADEIRA IMPACTO PNEUMATICA 1/2"', 'FERRAMENTA_PNEUMATICA', 'Diversos', 'PIP-1/2', 'UN', 0, 2, 'Almoxarifado Central', 650.00, 'Torque máximo 800Nm', GETDATE(), GETDATE()),
('CHAVE IMPACTO PNEUMATICA 3/4"', 'FERRAMENTA_PNEUMATICA', 'Diversos', 'CIP-3/4', 'UN', 0, 1, 'Almoxarifado Central', 950.00, 'Para trabalhos pesados', GETDATE(), GETDATE()),
('LIXADEIRA ORBITAL PNEUMATICA', 'FERRAMENTA_PNEUMATICA', 'Diversos', 'LOP-125', 'UN', 0, 2, 'Almoxarifado Central', 380.00, 'Disco 125mm, 12.000 RPM', GETDATE(), GETDATE()),
('ESMERILHADEIRA PNEUMATICA 4"', 'FERRAMENTA_PNEUMATICA', 'Diversos', 'ESP-4', 'UN', 0, 2, 'Almoxarifado Central', 420.00, 'Para desbaste e corte', GETDATE(), GETDATE()),
('PISTOLA PINTURA HVLP 1.4mm', 'FERRAMENTA_PNEUMATICA', 'Diversos', 'PPH-1.4', 'UN', 0, 1, 'Almoxarifado Central', 550.00, 'Alta transferência, baixo desperdício', GETDATE(), GETDATE()),
('MARTELETE PNEUMATICO 150mm', 'FERRAMENTA_PNEUMATICA', 'Diversos', 'MAP-150', 'UN', 0, 1, 'Almoxarifado Central', 750.00, 'Para demolição e quebra', GETDATE(), GETDATE()),
('PRENSA HIDRAULICA OFICINA 15 TON', 'FERRAMENTA_HIDRAULICA', 'Diversos', 'PRH-15T', 'UN', 0, 1, 'Oficina', 4500.00, 'Prensa hidráulica de bancada', GETDATE(), GETDATE()),
('MACACO HIDRAULICO GARRAFA 20 TON', 'FERRAMENTA_HIDRAULICA', 'Diversos', 'MGH-20T', 'UN', 0, 2, 'Oficina', 850.00, 'Macaco tipo garrafa', GETDATE(), GETDATE()),
('MACACO HIDRAULICO JACARE 2 TON', 'FERRAMENTA_HIDRAULICA', 'Diversos', 'MJH-2T', 'UN', 0, 1, 'Oficina', 650.00, 'Macaco jacaré baixo perfil', GETDATE(), GETDATE());

PRINT '   -> 9 ferramentas pneumáticas e hidráulicas importadas';
GO

-- =====================================================================
-- MATERIAIS ELETRICOS (baseado em SINAPI)
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('CABO FLEXIVEL 2,5mm² PRETO (ROLO 100M)', 'MATERIAL_ELETRICO', 'Diversos', 'CF-2.5-PT', 'RL', 0, 2, 'Almoxarifado Central', 280.00, 'Cabo 750V classe 5', GETDATE(), GETDATE()),
('CABO FLEXIVEL 4mm² AZUL (ROLO 100M)', 'MATERIAL_ELETRICO', 'Diversos', 'CF-4-AZ', 'RL', 0, 2, 'Almoxarifado Central', 420.00, 'Cabo 750V classe 5', GETDATE(), GETDATE()),
('CABO FLEXIVEL 6mm² VERDE (ROLO 100M)', 'MATERIAL_ELETRICO', 'Diversos', 'CF-6-VD', 'RL', 0, 1, 'Almoxarifado Central', 580.00, 'Cabo 750V classe 5', GETDATE(), GETDATE()),
('ELETRODUTO PVC 3/4" 3M ROSCAVEL', 'MATERIAL_ELETRICO', 'Diversos', 'EPR-3/4', 'BRA', 0, 5, 'Almoxarifado Central', 18.50, 'Barra 3 metros roscável', GETDATE(), GETDATE()),
('ELETRODUTO PVC 1" 3M ROSCAVEL', 'MATERIAL_ELETRICO', 'Diversos', 'EPR-1', 'BRA', 0, 5, 'Almoxarifado Central', 25.00, 'Barra 3 metros roscável', GETDATE(), GETDATE()),
('CAIXA PASSAGEM PVC 4x2" ESTAMPADA', 'MATERIAL_ELETRICO', 'Diversos', 'CPE-4x2', 'UN', 0, 10, 'Almoxarifado Central', 4.50, 'Caixa de embutir 4x2 polegadas', GETDATE(), GETDATE()),
('CAIXA PASSAGEM PVC 4x4" ESTAMPADA', 'MATERIAL_ELETRICO', 'Diversos', 'CPE-4x4', 'UN', 0, 5, 'Almoxarifado Central', 8.50, 'Caixa de embutir 4x4 polegadas', GETDATE(), GETDATE()),
('DISJUNTOR MONOPOLAR 16A CURVA C', 'MATERIAL_ELETRICO', 'Diversos', 'DJM-16A', 'UN', 0, 5, 'Almoxarifado Central', 28.00, 'Disjuntor termomagnético DIN', GETDATE(), GETDATE()),
('DISJUNTOR TRIPOLAR 25A CURVA C', 'MATERIAL_ELETRICO', 'Diversos', 'DJT-25A', 'UN', 0, 3, 'Almoxarifado Central', 95.00, 'Disjuntor termomagnético 3P', GETDATE(), GETDATE()),
('CONECTOR SINDAL 2,5mm² PACOTE 50un', 'MATERIAL_ELETRICO', 'Diversos', 'CS-2.5', 'PC', 0, 5, 'Almoxarifado Central', 15.00, 'Conector perfurante derivação', GETDATE(), GETDATE()),
('FITA ISOLANTE 19mm x 20m PRETA', 'MATERIAL_ELETRICO', 'Diversos', 'FI-19-PT', 'RL', 0, 20, 'Almoxarifado Central', 8.50, 'Fita isolante 3M ou similar', GETDATE(), GETDATE()),
('ABRAÇADEIRA NYLON 200mm PRETA (PACOTE 100un)', 'MATERIAL_ELETRICO', 'Diversos', 'ABN-200', 'PC', 0, 5, 'Almoxarifado Central', 18.00, 'Abraçadeira tipo hellermann', GETDATE(), GETDATE());

PRINT '   -> 12 materiais elétricos importados';
GO

-- =====================================================================
-- EQUIPAMENTOS DE SEGURANCA (EPIs baseados em SINAPI)
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('CAPACETE SEGURANCA CLASSE B BRANCO', 'EPI', 'Diversos', 'CAP-CB-BR', 'UN', 0, 10, 'Almoxarifado EPIs', 45.00, 'Capacete com carneira ajustável, CA válido', GETDATE(), GETDATE()),
('CAPACETE SEGURANCA CLASSE B AMARELO', 'EPI', 'Diversos', 'CAP-CB-AM', 'UN', 0, 10, 'Almoxarifado EPIs', 45.00, 'Capacete com carneira ajustável, CA válido', GETDATE(), GETDATE()),
('OCULOS PROTECAO INCOLOR ANTIEMBACANTE', 'EPI', 'Diversos', 'OCP-INC', 'UN', 0, 20, 'Almoxarifado EPIs', 12.00, 'Óculos ampla visão, CA válido', GETDATE(), GETDATE()),
('OCULOS PROTECAO FUME ANTIRRISCO', 'EPI', 'Diversos', 'OCP-FUM', 'UN', 0, 15, 'Almoxarifado EPIs', 15.00, 'Proteção UV, CA válido', GETDATE(), GETDATE()),
('LUVA LATEX PIGMENTADA TAM 8 (PAR)', 'EPI', 'Diversos', 'LUV-LAT-8', 'PAR', 0, 20, 'Almoxarifado EPIs', 8.50, 'Luva antiderrapante, CA válido', GETDATE(), GETDATE()),
('LUVA LATEX PIGMENTADA TAM 9 (PAR)', 'EPI', 'Diversos', 'LUV-LAT-9', 'PAR', 0, 25, 'Almoxarifado EPIs', 8.50, 'Luva antiderrapante, CA válido', GETDATE(), GETDATE()),
('LUVA LATEX PIGMENTADA TAM 10 (PAR)', 'EPI', 'Diversos', 'LUV-LAT-10', 'PAR', 0, 25, 'Almoxarifado EPIs', 8.50, 'Luva antiderrapante, CA válido', GETDATE(), GETDATE()),
('LUVA VAQUETA PUNHO LONGO (PAR)', 'EPI', 'Diversos', 'LUV-VAQ-PL', 'PAR', 0, 15, 'Almoxarifado EPIs', 18.00, 'Luva raspa couro, CA válido', GETDATE(), GETDATE()),
('LUVA ELETRICISTA ISOLADA 1000V CLASSE 0 (PAR)', 'EPI', 'Diversos', 'LUV-ISO-1KV', 'PAR', 0, 10, 'Almoxarifado EPIs', 185.00, 'Luva borracha isolante, ensaio periódico', GETDATE(), GETDATE()),
('BOTA SEGURANCA COURO PRETA N°39', 'EPI', 'Diversos', 'BOT-SEG-39', 'PAR', 0, 3, 'Almoxarifado EPIs', 145.00, 'Bota bico aço, CA válido', GETDATE(), GETDATE()),
('BOTA SEGURANCA COURO PRETA N°40', 'EPI', 'Diversos', 'BOT-SEG-40', 'PAR', 0, 4, 'Almoxarifado EPIs', 145.00, 'Bota bico aço, CA válido', GETDATE(), GETDATE()),
('BOTA SEGURANCA COURO PRETA N°41', 'EPI', 'Diversos', 'BOT-SEG-41', 'PAR', 0, 4, 'Almoxarifado EPIs', 145.00, 'Bota bico aço, CA válido', GETDATE(), GETDATE()),
('BOTA SEGURANCA COURO PRETA N°42', 'EPI', 'Diversos', 'BOT-SEG-42', 'PAR', 0, 5, 'Almoxarifado EPIs', 145.00, 'Bota bico aço, CA válido', GETDATE(), GETDATE()),
('BOTA SEGURANCA COURO PRETA N°43', 'EPI', 'Diversos', 'BOT-SEG-43', 'PAR', 0, 4, 'Almoxarifado EPIs', 145.00, 'Bota bico aço, CA válido', GETDATE(), GETDATE()),
('BOTA SEGURANCA COURO PRETA N°44', 'EPI', 'Diversos', 'BOT-SEG-44', 'PAR', 0, 3, 'Almoxarifado EPIs', 145.00, 'Bota bico aço, CA válido', GETDATE(), GETDATE()),
('PROTETOR AURICULAR TIPO CONCHA', 'EPI', 'Diversos', 'PRA-CON', 'UN', 0, 10, 'Almoxarifado EPIs', 32.00, 'Atenuação 20dB, CA válido', GETDATE(), GETDATE()),
('PROTETOR AURICULAR PLUG SILICONE (PACOTE 50 PARES)', 'EPI', 'Diversos', 'PRA-PLG', 'PC', 0, 5, 'Almoxarifado EPIs', 45.00, 'Descartável, CA válido', GETDATE(), GETDATE()),
('MASCARA DESCARTAVEL PFF2 (CAIXA 20un)', 'EPI', 'Diversos', 'MSC-PFF2', 'CX', 0, 10, 'Almoxarifado EPIs', 85.00, 'Respirador PFF2, CA válido', GETDATE(), GETDATE()),
('CINTO SEGURANCA TIPO PARAQUEDISTA', 'EPI', 'Diversos', 'CIN-PAR', 'UN', 0, 5, 'Almoxarifado EPIs', 285.00, 'Para trabalho em altura, CA válido', GETDATE(), GETDATE()),
('TALABARTE DUPLO COM ABSORVEDOR', 'EPI', 'Diversos', 'TAL-DUP', 'UN', 0, 5, 'Almoxarifado EPIs', 195.00, 'Y com mosquetão, CA válido', GETDATE(), GETDATE());

PRINT '   -> 20 EPIs importados';
GO

-- =====================================================================
-- SINAPI - MATERIAIS DE CONSTRUCAO (amostra)
-- =====================================================================

INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, ModeloPN, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES 
('CIMENTO PORTLAND CP-II-E-32 (SACO 50KG)', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-CIM-50', 'SC', 0, 20, 'Almoxarifado Central', 38.00, 'SINAPI - Cimento composto', GETDATE(), GETDATE()),
('AREIA MEDIA LAVADA (M³)', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-ARE-M3', 'M3', 0, 5, 'Deposito Externo', 85.00, 'SINAPI - Areia para construção', GETDATE(), GETDATE()),
('BRITA 1 (M³)', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-BRI-M3', 'M3', 0, 5, 'Deposito Externo', 95.00, 'SINAPI - Brita graduada', GETDATE(), GETDATE()),
('TIJOLO CERAMICO 6 FUROS 9x14x19CM', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-TIJ-6F', 'UN', 0, 500, 'Deposito Externo', 1.20, 'SINAPI - Tijolo estrutural', GETDATE(), GETDATE()),
('TUBO PVC ESGOTO 100mm 6M', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-TPE-100', 'BRA', 0, 10, 'Almoxarifado Central', 55.00, 'SINAPI - Tubo PVC série normal', GETDATE(), GETDATE()),
('TUBO PVC AGUA 25mm (3/4") 6M', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-TPA-25', 'BRA', 0, 15, 'Almoxarifado Central', 28.00, 'SINAPI - Tubo soldável', GETDATE(), GETDATE()),
('REGISTRO ESFERA PVC 25mm (3/4")', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-REG-25', 'UN', 0, 5, 'Almoxarifado Central', 18.50, 'SINAPI - Registro esfera PVC', GETDATE(), GETDATE()),
('TINTA LATEX ACRILICA BRANCA 18L', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-TLA-18', 'GL', 0, 5, 'Almoxarifado Central', 285.00, 'SINAPI - Tinta acrílica premium', GETDATE(), GETDATE()),
('TELA SOLDADA Q-138 (2,45x6M)', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-TEL-138', 'RL', 0, 3, 'Deposito Externo', 195.00, 'SINAPI - Malha de aço', GETDATE(), GETDATE()),
('VERGALHAO CA-50 10mm (12M)', 'MATERIAL_CONSTRUCAO', 'Diversos', 'SIN-VER-10', 'BRA', 0, 20, 'Deposito Externo', 48.00, 'SINAPI - Aço para concreto', GETDATE(), GETDATE());

PRINT '   -> 10 materiais de construção SINAPI importados';
GO

-- =====================================================================
-- RESUMO FINAL
-- =====================================================================

PRINT '';
PRINT '========================================================';
PRINT 'IMPORTACAO CONCLUIDA COM SUCESSO!';
PRINT '========================================================';
PRINT '';
PRINT 'RESUMO:';
PRINT '   • 10 tipos de alicates';
PRINT '   • 20 tipos de chaves';
PRINT '   • 10 martelos e ferramentas de impacto';
PRINT '   • 12 serras e ferramentas de corte';
PRINT '   • 14 instrumentos de medição';
PRINT '   • 9 ferramentas pneumáticas/hidráulicas';
PRINT '   • 12 materiais elétricos';
PRINT '   • 20 EPIs';
PRINT '   • 10 materiais SINAPI';
PRINT '';
PRINT '   TOTAL: 117 NOVOS ITENS IMPORTADOS!';
PRINT '';
PRINT 'PROXIMOS PASSOS:';
PRINT '   1. Ajustar quantidades de estoque conforme necessidade';
PRINT '   2. Atualizar precos com valores reais do mercado';
PRINT '   3. Usar script Python para importacao completa dos PDFs';
PRINT '';
PRINT '========================================================';
GO
