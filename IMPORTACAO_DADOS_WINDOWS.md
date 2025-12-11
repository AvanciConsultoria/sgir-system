# 🚀 SGIR - GUIA DE IMPORTAÇÃO DE DADOS (WINDOWS)

## 📋 Visão Geral

Este guia explica como importar os **117 itens profissionais** dos catálogos SINAPI e Ferramentas Manuais no banco de dados SGIR, tanto para **SQLite** (desenvolvimento) quanto para **SQL Server** (produção).

---

## ⚠️ PROBLEMA IDENTIFICADO

### Erro Original do Usuário

```powershell
PS> sqlite3 ../src/SGIR.WebApp/Data/sgir.db < database/imported-sinapi-ferramentas.sql
ParserError: RedirectionNotSupported: The '<' operator is reserved for future use.
```

### Causa
PowerShell **não suporta** o operador de redirecionamento `<` (stdin redirect) usado no Unix/Linux. Esse é um comportamento padrão do PowerShell 5.x e 7.x no Windows.

### Solução
Usamos **3 scripts alternativos** que funcionam perfeitamente no Windows:
1. **import-to-sqlite.ps1** (PowerShell robusto)
2. **import-to-sqlite.bat** (CMD simples)
3. **import-to-sqlserver.ps1** (SQL Server com certificado SSL)

---

## 🎯 OPÇÃO 1: IMPORTAR PARA SQLite (Desenvolvimento)

### Método A: PowerShell (RECOMENDADO)

```powershell
# Navegue até a pasta database
cd sgir-system\database

# Execute o script PowerShell
.\import-to-sqlite.ps1
```

**Saída esperada:**
```
======================================
SGIR - IMPORTAÇÃO CATÁLOGOS PARA SQLite
======================================

1. Lendo arquivo SQL...
2. Convertendo sintaxe SQL Server -> SQLite...
3. Conectando ao banco de dados...
4. Executando importação...

===================================
IMPORTAÇÃO CONCLUÍDA COM SUCESSO!
===================================

Total de ferramentas no banco: 117

Últimas 5 ferramentas importadas:
┌──────────────────────────────────────┬──────────┬──────────────┐
│ Descricao                            │ Fabricante │ ValorUnitario│
├──────────────────────────────────────┼──────────┼──────────────┤
│ ALICATE UNIVERSAL 6" ISOLADO 1000V   │ Diversos │ 125.00       │
│ CHAVE COMBINADA 10mm                 │ Diversos │ 19.90        │
│ MARTELO UNHA 27mm (500g)             │ Diversos │ 35.00        │
└──────────────────────────────────────┴──────────┴──────────────┘
```

### Método B: CMD/Batch (Alternativa simples)

```cmd
cd sgir-system\database
import-to-sqlite.bat
```

### Método C: Manual com sqlite3.exe

Se os scripts acima falharem, você pode usar o método manual:

```powershell
# 1. Baixe sqlite3.exe
winget install SQLite.SQLite
# OU baixe de: https://www.sqlite.org/download.html

# 2. Converta o SQL manualmente
$sql = Get-Content imported-sinapi-ferramentas.sql -Raw
$sql = $sql -replace 'GETDATE\(\)', "datetime('now')"
$sql = $sql -replace 'PRINT ''(.+?)'';', '-- $1'
$sql = $sql -replace 'GO', ''
$sql | Out-File temp-import.sql -Encoding UTF8

# 3. Execute com .read (SEM redirecionamento '<')
sqlite3.exe ..\src\SGIR.WebApp\Data\sgir.db ".read temp-import.sql"

# 4. Limpe
Remove-Item temp-import.sql
```

---

## 🎯 OPÇÃO 2: IMPORTAR PARA SQL SERVER (Produção)

### Problema Original do Usuário

```powershell
PS> sqlcmd -S localhost -d SGIR_DB -i imported-sinapi-ferramentas.sql
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : 
SSL Provider: A cadeia de certificação foi emitida por uma autoridade que não é de confiança.
```

### Causa
O SQL Server 2019+ exige certificados SSL válidos por padrão. Em ambientes de desenvolvimento local, o certificado autoassinado não é confiável.

### Solução: Script PowerShell com TrustServerCertificate

```powershell
cd sgir-system\database

# Para SQL Server padrão (localhost)
.\import-to-sqlserver.ps1

# Para SQL Express
.\import-to-sqlserver.ps1 -ServerInstance "localhost\SQLEXPRESS"

# Para SQL com autenticação
.\import-to-sqlserver.ps1 -ServerInstance "localhost" -Username "sa" -Password "SuaSenha123"

# Para SQL remoto
.\import-to-sqlserver.ps1 -ServerInstance "192.168.1.100" -Database "SGIR_PROD" -Username "sgir_user" -Password "Senha123"
```

### Método Alternativo: sqlcmd com parâmetros de confiança

```cmd
sqlcmd -S localhost -d SGIR_DB -i imported-sinapi-ferramentas.sql -C -N
```

**Flags importantes:**
- `-C`: Trust server certificate (ignora validação SSL)
- `-N`: Encrypt=no (desabilita criptografia)

---

## 📊 O QUE SERÁ IMPORTADO

### Estatísticas dos Dados

| Categoria                      | Quantidade | Valor Total    |
|--------------------------------|------------|----------------|
| **Alicates**                   | 10 tipos   | R$ 1.835,00    |
| **Chaves e Ferramentas**       | 20 tipos   | R$ 3.510,00    |
| **Martelos e Marretas**        | 10 tipos   | R$ 465,00      |
| **Serras e Corte**             | 15 tipos   | R$ 890,00      |
| **Medição**                    | 12 tipos   | R$ 1.450,00    |
| **EPIs**                       | 20 tipos   | R$ 2.800,00    |
| **Materiais SINAPI**           | 30 tipos   | R$ 5.500,00    |
| **TOTAL**                      | **117 itens** | **R$ 16.450,00** |

### Exemplos de Itens Profissionais

#### Ferramentas Elétricas (Isoladas 1000V VDE)
- ALICATE UNIVERSAL 6" ISOLADO 1000V - R$ 125,00
- ALICATE CORTE DIAGONAL 8" ISOLADO 1000V - R$ 155,00
- CHAVE PHILIPS ISOLADA #2 1000V - R$ 48,00

#### Equipamentos de Medição
- ALICATE AMPERIMETRO 1000A AC/DC - R$ 450,00
- MULTÍMETRO DIGITAL TRUE RMS - R$ 380,00
- DETECTOR TENSÃO SEM CONTATO 1000V - R$ 125,00

#### EPIs Profissionais
- LUVA ISOLANTE CLASSE 2 20KV - R$ 850,00
- CAPACETE ELETRICISTA CLASSE B - R$ 145,00
- BOTA ELETRICISTA 20KV - R$ 380,00

#### Materiais SINAPI (Engenharia Civil)
- CABO COBRE 2,5mm² (metro) - R$ 8,50
- DISJUNTOR TRIPOLAR 32A - R$ 125,00
- ELETRODUTO PVC 3/4" (barra 3m) - R$ 18,50

---

## 🔧 SOLUÇÃO DE PROBLEMAS

### Erro: "sqlite3: command not found"

**Windows:**
```powershell
# Instale via winget
winget install SQLite.SQLite

# OU baixe manualmente
# 1. Acesse: https://www.sqlite.org/download.html
# 2. Baixe: sqlite-tools-win32-x86-*.zip
# 3. Extraia sqlite3.exe para: C:\Windows\System32\
```

### Erro: "SQL Server não encontrado"

```powershell
# Verifique se o serviço está rodando
services.msc
# Procure: SQL Server (MSSQLSERVER) ou SQL Server (SQLEXPRESS)
# Status deve ser: "Em execução"

# Reinicie o serviço se necessário
net stop MSSQLSERVER
net start MSSQLSERVER
```

### Erro: "Módulo SqlServer não encontrado"

```powershell
# Instale o módulo PowerShell do SQL Server
Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber
Import-Module SqlServer
```

### Erro: "Firewall bloqueando conexão SQL Server"

```powershell
# Abra a porta 1433 no firewall
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

---

## ✅ VALIDAÇÃO DA IMPORTAÇÃO

### SQLite

```powershell
# Conte os itens importados
sqlite3 ..\src\SGIR.WebApp\Data\sgir.db "SELECT COUNT(*) FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL';"

# Liste os primeiros 10
sqlite3 ..\src\SGIR.WebApp\Data\sgir.db "SELECT Descricao, ValorUnitario FROM Itens_Estoque LIMIT 10;"

# Verifique categorias
sqlite3 ..\src\SGIR.WebApp\Data\sgir.db "SELECT Categoria, COUNT(*) as Total FROM Itens_Estoque GROUP BY Categoria;"
```

### SQL Server

```powershell
# Usando SqlCmd
sqlcmd -S localhost -d SGIR_DB -Q "SELECT COUNT(*) FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL';" -C -N

# Usando PowerShell
Invoke-Sqlcmd -ServerInstance "localhost" -Database "SGIR_DB" -Query "SELECT COUNT(*) FROM Itens_Estoque" -TrustServerCertificate
```

---

## 🚀 PRÓXIMOS PASSOS

### 1. Execute o aplicativo

```powershell
cd sgir-system\src\SGIR.WebApp
dotnet run
```

### 2. Acesse a interface

```
http://localhost:5000
```

### 3. Navegue para Estoque → Ferramentas

Você verá os **117 itens profissionais** listados com:
- ✅ Filtros por categoria
- ✅ Busca em tempo real
- ✅ Estatísticas de estoque
- ✅ Valores formatados em R$
- ✅ Badges coloridos de status

---

## 📖 REFERÊNCIAS

### Arquivos do Sistema

```
sgir-system/
├── database/
│   ├── imported-sinapi-ferramentas.sql    # SQL com 117 itens
│   ├── import-to-sqlite.ps1               # Script PowerShell SQLite
│   ├── import-to-sqlite.bat               # Script CMD SQLite
│   └── import-to-sqlserver.ps1            # Script PowerShell SQL Server
├── scripts/
│   └── extract_sinapi_data.py             # Extração completa (5000+ itens)
└── src/SGIR.WebApp/Data/
    └── sgir.db                             # Banco SQLite
```

### Commits Relevantes

- **423c292** - Adicionado scripts de importação e 117 itens SINAPI
- **a6e3adc** - Layout corrigido + dropdowns dinâmicos
- **510487c** - Correção de 17 erros de compilação Docker

---

## 💡 DICAS PROFISSIONAIS

### Performance

Para importar milhares de itens, use:
```powershell
cd scripts
python3 extract_sinapi_data.py
# Aguarde processamento dos PDFs (5-10 minutos)
# Gera SQL com 5000+ itens
```

### Backup antes de Importar

```powershell
# SQLite
Copy-Item ..\src\SGIR.WebApp\Data\sgir.db ..\src\SGIR.WebApp\Data\sgir.db.backup

# SQL Server
sqlcmd -S localhost -Q "BACKUP DATABASE SGIR_DB TO DISK='C:\Backup\SGIR_DB.bak'" -C
```

### Verificar Integridade

```sql
-- SQLite
PRAGMA integrity_check;

-- SQL Server
DBCC CHECKDB('SGIR_DB');
```

---

## 🆘 SUPORTE

Se encontrar problemas:

1. **Verifique os logs**: `src/SGIR.WebApp/Logs/`
2. **Consulte**: `TROUBLESHOOTING_WINDOWS.md`
3. **Issues GitHub**: https://github.com/AvanciConsultoria/sgir-system/issues
4. **Documentação**: Todas as mensagens de erro estão documentadas

---

## 🎉 RESULTADO FINAL

Após a importação, o sistema terá:

- ✅ **117 ferramentas profissionais** catalogadas
- ✅ **10 categorias** organizadas (Alicates, Chaves, Martelos, etc.)
- ✅ **EPIs certificados** com normas (NR10, NR35, etc.)
- ✅ **Materiais SINAPI** com especificações técnicas
- ✅ **Valores reais** de mercado (R$ 16.450,00 total)
- ✅ **Interface visual** moderna com filtros e busca

**O banco de dados agora está pronto para uso profissional!** 🚀
