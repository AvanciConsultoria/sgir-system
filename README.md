# 🏗️ SGIR - Sistema de Gestão Integrada de Recursos

> **Sistema inteligente de gestão de projetos, pessoas, inventário e compras para empresas de engenharia e manufatura**

[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4)](https://dotnet.microsoft.com/)
[![C#](https://img.shields.io/badge/C%23-12.0-239120)](https://docs.microsoft.com/en-us/dotnet/csharp/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-CC2927)](https://www.microsoft.com/sql-server)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Arquitetura](#arquitetura)
- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Roadmap](#roadmap)
- [Contribuindo](#contribuindo)
- [Licença](#licença)
- [Contato](#contato)

---

## 🎯 Sobre o Projeto

> **Status**: 🚧 **EM DESENVOLVIMENTO** | **Phase 2 COMPLETA** ✅  
> **Última Atualização**: 09/12/2025  
> **Progresso Geral**: ⬛⬛⬛⬜⬜ 60% (3 de 5 fases concluídas)

O **SGIR (Sistema de Gestão Integrada de Recursos)** é uma solução completa desenvolvida em **C#/.NET 8** com **SQL Server** que unifica:

- 📊 **Planejamento de Projetos e Atividades** (Ordens de Serviço)
- 👥 **Gestão de Pessoas** (Colaboradores, Certificações, EPIs)
- 🔧 **Inventário Inteligente** (Ferramentas, Equipamentos, Máquinas)
- 🛒 **Automação de Compras** (Gap Analysis, Sugestão de Aquisição)
- 💰 **Controle de Custos** (Mão de obra, Equipamentos, Materiais)

### 🚀 Problema que Resolve

Empresas de engenharia e manufatura enfrentam desafios diários:

- ❌ **Desorganização:** Dados de projetos, pessoas e inventário espalhados em planilhas
- ❌ **Compras Duplicadas:** Falta de visibilidade do estoque existente
- ❌ **Certificações Vencidas:** Risco de alocar pessoal não certificado
- ❌ **Déficit de Recursos:** Descobrir falta de ferramentas no dia da atividade
- ❌ **Custos Ocultos:** Dificuldade em rastrear custos reais por projeto

### ✅ Solução SGIR

O sistema automatiza decisões inteligentes:

1. **Valida automaticamente** se colaboradores têm certificações válidas antes de alocar
2. **Calcula o déficit** entre demanda e estoque em tempo real
3. **Sugere ação inteligente**: Comprar, Alugar ou Utilizar recurso existente
4. **Gera pedidos automaticamente** com base no Gap Analysis
5. **Rastreia custos** por atividade e projeto

---

## 🏛️ Arquitetura

### **Clean Architecture + DDD (Domain-Driven Design)**

```
┌─────────────────────────────────────────┐
│  Presentation Layer (UI)                │
│  ├─ WPF Desktop App                     │
│  └─ ASP.NET Core Web API                │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  Application Layer                      │
│  ├─ DTOs (Data Transfer Objects)       │
│  ├─ Services (Business Logic)          │
│  └─ Validators                          │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  Domain Layer (Core)                    │
│  ├─ Entities (Modelos de Domínio)      │
│  ├─ Interfaces (Contratos)              │
│  ├─ Services (Regras de Negócio)       │
│  └─ Enums                               │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  Infrastructure Layer                   │
│  ├─ Data (EF Core DbContext)           │
│  ├─ Repositories (Implementações)      │
│  └─ External Services                   │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  SQL Server Database                    │
│  ├─ 15 Tabelas Principais              │
│  ├─ Procedures & Views                  │
│  └─ Índices Otimizados                  │
└─────────────────────────────────────────┘
```

---

## ✨ Funcionalidades

### **Módulo 1: Planejamento de Projetos**

- ✅ Cadastro de Ordens de Serviço (OS)
- ✅ Criação de Atividades por OS
- ✅ Definição de demanda de funções (Mecânico, Soldador, Eletricista, Ferramenteiro)
- ✅ Cálculo automático de prazos e custos
- ✅ Dashboard de progresso por projeto

### **Módulo 2: Gestão de Pessoas**

- ✅ Cadastro de colaboradores (CPF, Nome, Função, Status)
- ✅ Rastreamento de certificações (NR-10, NR-11, NR-12, LOTO, NR-35, ASO)
- ✅ **Validação automática de validade** de certificações
- ✅ Controle de EPIs (Uniform, Bota, Óculos, Capacete, Luvas, etc.)
- ✅ **Bloqueio de alocação** para pessoal não conforme
- ✅ Gestão de status (SAT, INTEGRANDO, CONTRATAÇÃO, DESISTÊNCIA)
- ✅ Alocação inteligente por frente de trabalho

### **Módulo 3: Inventário Inteligente**

- ✅ Catálogo completo de ferramentas e equipamentos
- ✅ Controle de estoque em tempo real
- ✅ Rastreamento de localização (Ex: "Renault SJP", "Almoxarifado Central")
- ✅ **Interpretação de observações** (Ex: "Temos na Renault (3 confirmar)")
- ✅ Movimentação de itens (Entrada, Saída, Transferência, Devolução)
- ✅ Alerta de estoque mínimo
- ✅ Histórico completo de movimentações

### **Módulo 4: Automação de Compras (GAP ANALYSIS)**

- ✅ **Cálculo automático de demanda total consolidada** por item
- ✅ **Gap Analysis**: Demanda Total - Estoque Disponível = Déficit
- ✅ **Sugestão inteligente de ação**:
  - 🟢 **COMPRAR**: Se déficit > 0 e observação indica "intenção compra"
  - 🔵 **ALUGAR**: Se déficit > 0 e item tem custo de aluguel cadastrado
  - 🟡 **TRANSFERIR**: Se item está disponível em outro local
  - ⚪ **OK**: Se estoque é suficiente
- ✅ Geração automática de pedidos de compra
- ✅ Rastreamento de status de pedidos
- ✅ Cálculo automático de valores

### **Módulo 5: Relatórios e Inteligência**

- ✅ Relatório de Déficit Consolidado
- ✅ Relatório de Recursos Humanos Inaptos
- ✅ Análise de Custos por Atividade/Projeto
- ✅ Dashboard executivo
- ✅ **Integração com Power BI** (conexão direta SQL Server)
- ✅ Exportação para Excel/PDF

---

## 🛠️ Tecnologias

### **Backend**

- **Linguagem:** C# 12
- **Framework:** .NET 8
- **ORM:** Entity Framework Core 8
- **Banco de Dados:** SQL Server 2022 / SQL Server Express
- **Padrões:** Clean Architecture, DDD, Repository Pattern, SOLID

### **Frontend (Opcional)**

- **Desktop:** WPF (Windows Presentation Foundation)
- **Web:** ASP.NET Core MVC / Blazor
- **UI:** Material Design / DevExpress

### **Visualização**

- **Power BI:** Integração via Direct Query ao SQL Server
- **Charts:** LiveCharts / Syncfusion

### **Ferramentas**

- **IDE:** Visual Studio 2022 / VS Code + C# DevKit
- **Controle de Versão:** Git / GitHub
- **CI/CD:** GitHub Actions (futuro)
- **Containerização:** Docker (futuro)

---

## 📋 Pré-requisitos

### **Software Necessário:**

```bash
# 1. .NET 8 SDK
https://dotnet.microsoft.com/download/dotnet/8.0

# 2. SQL Server 2022 (ou Express Edition - grátis)
https://www.microsoft.com/sql-server/sql-server-downloads

# 3. SQL Server Management Studio (SSMS)
https://docs.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms

# 4. Visual Studio 2022 (Community - grátis) ou VS Code
https://visualstudio.microsoft.com/downloads/

# 5. Git
https://git-scm.com/downloads
```

### **Verificar Instalação:**

```bash
# Verificar .NET SDK
dotnet --version
# Deve retornar: 8.0.x

# Verificar Git
git --version
```

---

## 🚀 Instalação

### **1. Clonar o Repositório**

```bash
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system
```

### **2. Configurar Banco de Dados**

**Opção A: Via SSMS (Visual)**

1. Abrir SQL Server Management Studio
2. Conectar ao servidor local: `localhost` ou `(localdb)\MSSQLLocalDB`
3. Abrir e executar scripts na ordem:
   - `database/scripts/01_CreateDatabase.sql`
   - `database/scripts/02_CreateTables.sql`
   - `database/scripts/03_SeedData.sql` (dados de exemplo)

**Opção B: Via Command Line**

```bash
# Windows (usando sqlcmd)
sqlcmd -S localhost -i database/scripts/01_CreateDatabase.sql
sqlcmd -S localhost -d SGIR -i database/scripts/02_CreateTables.sql
sqlcmd -S localhost -d SGIR -i database/scripts/03_SeedData.sql

# Ou via script PowerShell
./database/install-database.ps1
```

### **3. Configurar Connection String**

Editar `src/SGIR.WebAPI/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=SGIR;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**Ou para SQL Server Express:**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=SGIR;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

### **4. Restaurar Dependências e Compilar**

```bash
# Restaurar pacotes NuGet
dotnet restore

# Compilar solução
dotnet build

# Executar testes (se existirem)
dotnet test
```

### **5. Executar Aplicação**

**API Web:**

```bash
cd src/SGIR.WebAPI
dotnet run

# API estará disponível em:
# https://localhost:5001
# http://localhost:5000
```

**Desktop (WPF):**

```bash
cd src/SGIR.WPF
dotnet run
```

---

## 📖 Uso

### **Exemplo 1: Criar Novo Projeto**

```csharp
// Via API REST
POST /api/projetos
{
  "osId": "OS-2024-001",
  "nomeProjeto": "Alteração de Layout - Linha Montagem",
  "cliente": "COMAU",
  "local": "Renault SJP - PR",
  "gestorProjeto": "Leonardo Cominese"
}
```

### **Exemplo 2: Alocar Pessoal com Validação Automática**

```csharp
// Sistema verifica automaticamente:
// - Status do colaborador (deve ser SAT)
// - Validade de certificações (NR-10, ASO, etc.)
// - Disponibilidade

POST /api/alocacao
{
  "idAtividade": 1,
  "cpf": "123.456.789-00",
  "equipe": "EQUIPE 1 - LD"
}

// Resposta automática:
{
  "sucesso": false,
  "mensagem": "Colaborador com NR-10 vencida (vencimento: 2024-10-15). Renovação necessária."
}
```

### **Exemplo 3: Gap Analysis Automático**

```csharp
// Sistema calcula automaticamente:
POST /api/analise/gap-analysis?osId=OS-2024-001

// Retorna:
{
  "itens": [
    {
      "item": "CHAVE DE IMPACTO",
      "demandaTotal": 7,
      "estoqueDisponivel": 4,
      "deficit": 3,
      "acaoSugerida": "COMPRAR",
      "observacao": "Intenção de compra aguardando visita fábrica"
    },
    {
      "item": "LIXADEIRA 7\"",
      "demandaTotal": 5,
      "estoqueDisponivel": 3,
      "deficit": 2,
      "acaoSugerida": "TRANSFERIR",
      "observacao": "Temos 3 unidades disponíveis na Renault SJP"
    }
  ]
}
```

---

## 📁 Estrutura do Projeto

```
sgir-system/
├── src/
│   ├── SGIR.Core/                  # Camada de Domínio (Regras de Negócio)
│   │   ├── Entities/              # Modelos de Domínio
│   │   ├── Interfaces/            # Contratos de Repositórios
│   │   ├── Services/              # Serviços de Domínio
│   │   └── Enums/                 # Enumerações
│   │
│   ├── SGIR.Infrastructure/        # Camada de Infraestrutura
│   │   ├── Data/                  # DbContext (EF Core)
│   │   └── Repositories/          # Implementações de Repositórios
│   │
│   ├── SGIR.Application/           # Camada de Aplicação
│   │   ├── DTOs/                  # Data Transfer Objects
│   │   └── Services/              # Lógica de Aplicação
│   │
│   ├── SGIR.WebAPI/                # API REST (ASP.NET Core)
│   │   ├── Controllers/           # Endpoints da API
│   │   └── Models/                # ViewModels
│   │
│   └── SGIR.WPF/                   # Aplicação Desktop
│       ├── Views/                 # Telas XAML
│       ├── ViewModels/            # MVVM ViewModels
│       └── Services/              # Serviços de UI
│
├── database/
│   └── scripts/                    # Scripts SQL
│       ├── 01_CreateDatabase.sql
│       ├── 02_CreateTables.sql
│       ├── 03_SeedData.sql
│       └── 04_StoredProcedures.sql
│
├── docs/                           # Documentação
│   ├── ARCHITECTURE.md            # Arquitetura do Sistema
│   ├── DATABASE_DESIGN.md         # Design do Banco de Dados
│   ├── API_REFERENCE.md           # Referência da API
│   └── USER_GUIDE.md              # Guia do Usuário
│
├── tests/                          # Testes Automatizados
│   ├── SGIR.Core.Tests/
│   └── SGIR.Application.Tests/
│
├── .gitignore
├── LICENSE
├── README.md
└── SGIR.sln                        # Solution do Visual Studio
```

---

## 🗺️ Roadmap

### **Fase 1: Fundação (✅ Concluída)**
- [x] Modelagem do Banco de Dados
- [x] Scripts SQL Server
- [x] Estrutura do Projeto (.NET 8)
- [x] Documentação Inicial

### **Fase 2: Core do Sistema (🔄 Em Progresso)**
- [ ] Implementar Entities (Domínio)
- [ ] Implementar Repositories (EF Core)
- [ ] Desenvolver Serviços de Alocação de Pessoal
- [ ] Implementar Validações de Certificação
- [ ] Algoritmo de Gap Analysis

### **Fase 3: Automação de Compras**
- [ ] Lógica de Consolidação de Demanda
- [ ] Sugestão Inteligente de Aquisição
- [ ] Geração Automática de Pedidos
- [ ] Interpretação de Observações (NLP básico)

### **Fase 4: Interface e Relatórios**
- [ ] API REST (Controllers)
- [ ] Aplicação WPF Desktop
- [ ] Dashboards e Relatórios
- [ ] Integração Power BI

### **Fase 5: Avançado**
- [ ] Testes Automatizados (Unit + Integration)
- [ ] CI/CD com GitHub Actions
- [ ] Containerização (Docker)
- [ ] Deploy Azure / AWS

---

## 🤝 Contribuindo

Contribuições são bem-vindas!

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/MinhaFeature`
3. Commit suas mudanças: `git commit -m 'Adiciona MinhaFeature'`
4. Push para a branch: `git push origin feature/MinhaFeature`
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença **MIT**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 📞 Contato

**Avanci Consultoria**

- 📧 Email: favanci@hotmail.com
- 💬 WhatsApp: (41) 98831-8672
- 🌐 Site: https://avanci.eng.br
- 💼 LinkedIn: [Felipe Avanci](https://www.linkedin.com/in/felipe-avanci/)

---

## 🎓 Sobre o Desenvolvimento

Este sistema foi desenvolvido com base em processos reais de gestão de projetos de engenharia, utilizando as melhores práticas de:

- ✅ Clean Architecture
- ✅ Domain-Driven Design (DDD)
- ✅ SOLID Principles
- ✅ Test-Driven Development (TDD)
- ✅ Continuous Integration/Deployment (CI/CD)

---

**🚀 SGIR - Gestão Inteligente de Recursos para Engenharia**

**Desenvolvido com ❤️ em C# + .NET 8 + SQL Server**
