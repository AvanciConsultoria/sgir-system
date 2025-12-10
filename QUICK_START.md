# ⚡ Quick Start - SGIR

## 🚀 Começar em 15 Minutos

### **Pré-requisitos Rápidos**

```bash
# 1. Instalar .NET 8 SDK
https://dotnet.microsoft.com/download/dotnet/8.0

# 2. Instalar SQL Server Express (grátis)
https://go.microsoft.com/fwlink/p/?linkid=2216019

# 3. Instalar SQL Server Management Studio
https://aka.ms/ssmsfullsetup
```

---

## 📋 Passo a Passo

### **1. Clonar Repositório** (2 min)

```bash
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system
```

### **2. Criar Banco de Dados** (5 min)

**Opção A: Via SSMS (Recomendado)**

1. Abrir SQL Server Management Studio
2. Conectar: `(localdb)\MSSQLLocalDB` ou `localhost`
3. Abrir arquivo: `database/scripts/01_CreateDatabase.sql`
4. Executar (F5)
5. Abrir arquivo: `database/scripts/02_CreateTables.sql`
6. Executar (F5)

**Opção B: Via Command Line**

```bash
# Windows PowerShell
sqlcmd -S "(localdb)\MSSQLLocalDB" -i database/scripts/01_CreateDatabase.sql
sqlcmd -S "(localdb)\MSSQLLocalDB" -d SGIR -i database/scripts/02_CreateTables.sql
```

### **3. Verificar Instalação** (2 min)

```sql
-- No SSMS, executar:
USE SGIR;
GO

SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME) AS Colunas
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Deve retornar 15 tabelas
```

### **4. Próximos Passos** (Desenvolvimento)

```bash
# Criar projeto C#
cd src
dotnet new sln -n SGIR

# Adicionar projetos
dotnet new classlib -n SGIR.Core
dotnet new classlib -n SGIR.Infrastructure
dotnet new classlib -n SGIR.Application
dotnet new webapi -n SGIR.WebAPI

# Adicionar à solution
dotnet sln add SGIR.Core/SGIR.Core.csproj
dotnet sln add SGIR.Infrastructure/SGIR.Infrastructure.csproj
dotnet sln add SGIR.Application/SGIR.Application.csproj
dotnet sln add SGIR.WebAPI/SGIR.WebAPI.csproj
```

---

## 🎯 Estrutura Criada

```
SGIR Database
├── 📊 Projetos (OS)
├── 📋 Atividades
├── 🎯 Demanda_Funcoes
├── 👤 Colaboradores
├── 🎓 Certificacoes
├── 🦺 EPIs_Colaborador
├── 👥 Alocacao_Pessoal
├── 📦 Categorias_Item
├── 🔧 Inventario
├── 📋 Demanda_Ferramental
├── 📤 Movimentacao_Inventario
├── 🛒 Pedidos_Compra
├── 📝 Itens_Pedido
├── 📊 Analise_Deficit
└── 💰 Custos_Atividade
```

---

## ✅ Teste Rápido

```sql
-- Inserir projeto de teste
USE SGIR;
GO

INSERT INTO Projetos (OS_ID, Nome_Projeto, Cliente, Local, Gestor_Projeto)
VALUES ('OS-2024-001', 'Teste SGIR', 'COMAU', 'Renault SJP - PR', 'Leonardo Cominese');
GO

-- Verificar
SELECT * FROM Projetos WHERE OS_ID = 'OS-2024-001';
GO
```

---

## 📞 Problemas?

- 📧 favanci@hotmail.com
- 💬 (41) 98831-8672
- 📖 README.md (documentação completa)

---

**⏱️ Tempo total: 15 minutos**
**✅ Fase 1: Banco de Dados Pronto!**
**🔄 Próximo: Desenvolver código C#**

---

## 🎨 Rodar o WebApp atualizado

1. Abra `src/SGIR.WebApp/appsettings.json` e ajuste `DefaultConnection` para o seu SQL Server.
2. Restaure dependências e suba a UI:

```bash
dotnet restore
dotnet run --project src/SGIR.WebApp/SGIR.WebApp.csproj --urls "https://localhost:5001;http://localhost:5000"
```

3. Acesse `https://localhost:5001` no navegador. O menu lateral agora tem páginas reais para Projetos, Recursos, Pessoas, Estoque, Compras e Gap Analysis.
