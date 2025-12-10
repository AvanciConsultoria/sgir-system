# 📝 Changelog - SGIR Sistema

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-12-10

### 🎉 **RELEASE INICIAL - Sistema Pronto para Teste**

---

### ✅ **Added (Adicionado)**

#### **Infraestrutura e Deploy**
- 🐋 **Docker completo com docker-compose.yml**
  - SQL Server 2022 containerizado
  - WebApp .NET 8 containerizado
  - Network isolada (sgir-network)
  - Volumes persistentes
  - Health checks automáticos
  - Auto-restart em falhas

- 🚀 **Instaladores Automatizados**
  - `install-windows.ps1` - PowerShell para Windows
  - `install-linux.sh` - Bash para Linux/Mac
  - Instalação em 3 cliques
  - Detecção automática de dependências
  - Download e configuração automática

- 🧪 **Scripts de Validação**
  - `test-docker.ps1` (Windows)
  - `test-docker.sh` (Linux/Mac)
  - Verificação de pré-requisitos
  - Teste de build completo
  - Health check HTTP
  - Interface colorida com feedback visual

#### **Documentação**
- 📖 **INSTALACAO_FACIL.md** - Guia visual de instalação (3 métodos)
- 🛠️ **TROUBLESHOOTING_WINDOWS.md** - Solução de 4+ problemas comuns
- 🧪 **COMO_TESTAR.md** - Guia completo de testes
- 📝 **README.md** - Atualizado com novos métodos de instalação
- 📋 **ANALISE_PLANILHA_REAL.md** - Documentação do formato de importação Excel

#### **Backend (.NET 8 + C#)**
- ✅ **Domain Layer (SGIR.Core)**
  - 12 Entidades (Projeto, Colaborador, Ferramenta, EPI, etc.)
  - 4 Enums (Funcao, StatusGeral, TipoMovimentacao, AcaoCompra)
  - 5 Interfaces de serviço
  - Validações automáticas de negócio

- ✅ **Infrastructure Layer (SGIR.Infrastructure)**
  - Entity Framework Core 8
  - SGIRDbContext com mapeamentos completos
  - Repository Pattern genérico
  - UnitOfWork
  - Suporte a SQL Server

- ✅ **Application Layer (SGIR.WebApp)**
  - Blazor Server
  - Program.cs com Dependency Injection completo
  - Swagger UI (/api/docs)
  - Auto-migration em DEV
  - Dashboard interativo

#### **Frontend (Blazor Server)**
- 🎨 **Dashboard Principal**
  - Cards de resumo (Projetos, Colaboradores, Ferramentas, Alertas)
  - Alertas visuais coloridos
  - Ações rápidas
  - Carregamento assíncrono
  - Responsivo (Bootstrap 5)

- 🧭 **Layout e Navegação**
  - MainLayout responsivo
  - NavMenu com ícones (Open Iconic)
  - Menu colapsável
  - Sidebar fixed

#### **Database (SQL Server)**
- 📊 **Scripts SQL**
  - `01_CreateDatabase.sql` - Criação do banco SGIR_DB
  - Estrutura completa de tabelas
  - Relacionamentos e constraints
  - Índices otimizados

#### **Business Logic**
- 🧠 **Serviços Implementados**
  - `AlocacaoService` - Validação automática de colaboradores
    - Verifica certificações válidas
    - Bloqueia colaboradores inaptos
    - Valida disponibilidade
  
  - `GapAnalysisService` - Análise de déficit inteligente
    - Cálculo de demanda consolidada
    - Detecção de estoque em outros locais
    - Sugestão de ação (Comprar/Alugar/Transferir)
  
  - `CompraAutomacaoService` - Automação de pedidos
    - Decisão rent vs buy
    - Geração automática de pedidos
    - Cálculo de valores

---

### 🐛 **Fixed (Corrigido)**

#### **Docker Build**
- ✅ **Erro "No .NET SDKs were found"**
  - Problema: `dotnet-ef` era instalado na imagem runtime (aspnet)
  - Solução: Movido para stage de build (SDK disponível)
  - Resultado: Build funciona 100%

- ✅ **Warning "version is obsolete"**
  - Removido `version: '3.8'` do docker-compose.yml
  - Compatível com Docker Compose v2+

#### **PowerShell Execution**
- ✅ **Erro "running scripts is disabled"**
  - Documentado 3 soluções em TROUBLESHOOTING_WINDOWS.md
  - Comando de bypass adicionado
  - Instruções de execução como Admin

#### **SQL Server Connection**
- ✅ **Entrypoint com health check inteligente**
  - Wait loop 30x com timeout de 2s
  - Testa conexão TCP antes de iniciar app
  - Mensagens de progresso claras

---

### 🔄 **Changed (Modificado)**

#### **Dockerfile**
- Usa `mcr.microsoft.com/dotnet/sdk:8.0` no final (em vez de aspnet)
- Install `dotnet-ef` na stage de publish
- Entrypoint simplificado e resiliente
- Migrations bundle opcional

#### **docker-compose.yml**
- Removido `version` field (obsoleto)
- Health check do SQL Server aprimorado
- Connection string atualizada com `TrustServerCertificate=true`
- Environment variables melhor organizadas

#### **Estrutura de Documentação**
- README.md agora prioriza Docker
- Instalação manual movida para `<details>` (devs)
- Tabela de documentação adicionada
- Links entre documentos

---

### 🛠️ **Technical Specs**

#### **Stack Tecnológico**
- **Backend:** .NET 8, C# 12
- **ORM:** Entity Framework Core 8.0.0
- **Database:** SQL Server 2022
- **Frontend:** Blazor Server
- **UI Framework:** Bootstrap 5, Open Iconic
- **API Docs:** Swashbuckle.AspNetCore 6.5.0
- **Excel:** EPPlus 7.0.0
- **Containerização:** Docker + Docker Compose

#### **Arquitetura**
- **Pattern:** Clean Architecture + DDD
- **Layers:**
  - SGIR.Core (Domain)
  - SGIR.Infrastructure (Data Access)
  - SGIR.WebApp (Presentation)

#### **Requisitos de Sistema**
- **Docker:** 8GB RAM, 10GB disk
- **Manual:** .NET 8 SDK, SQL Server, 4GB RAM

---

### 📦 **Deployment**

#### **Métodos Suportados**
1. **Docker Compose** (recomendado) - 2-5 minutos
2. **PowerShell Installer** (Windows) - 5-10 minutos
3. **Bash Installer** (Linux/Mac) - 5-10 minutos

#### **URLs de Acesso**
- **Dashboard:** http://localhost:5000
- **Swagger API:** http://localhost:5000/api/docs
- **SQL Server:** localhost:1433 (sa / SGIR_Pass123!)

---

### 🧪 **Testing**

#### **Scripts de Validação**
- Verificação de pré-requisitos
- Build de teste completo
- Health checks automatizados
- Feedback visual colorido

#### **Comandos Úteis**
```bash
# Status dos containers
docker-compose ps

# Logs em tempo real
docker-compose logs -f

# Reiniciar serviços
docker-compose restart

# Rebuild completo
docker-compose down -v && docker-compose up -d --build
```

---

### 📚 **Documentation**

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| README.md | Documentação principal | ~15KB |
| INSTALACAO_FACIL.md | Guia visual de instalação | ~8KB |
| TROUBLESHOOTING_WINDOWS.md | Solução de problemas | ~5KB |
| COMO_TESTAR.md | Guia de testes | ~14KB |
| ANALISE_PLANILHA_REAL.md | Importação Excel | ~13KB |
| test-docker.ps1 | Validação Windows | ~7KB |
| test-docker.sh | Validação Linux/Mac | ~5KB |

---

### 🎯 **Status do Projeto**

#### **Completo (80%)**
- ✅ Phase 1: Database design
- ✅ Phase 2: Domain models + services
- ✅ Phase 3: Infrastructure + WebApp
- ✅ Docker + Installers
- ✅ Documentação completa

#### **Em Progresso (15%)**
- 🔄 CRUD pages (Colaboradores, Ferramentas, etc.)
- 🔄 Importador Excel
- 🔄 Power BI integration

#### **Pendente (5%)**
- ⏳ Autenticação/Autorização
- ⏳ Deploy em nuvem (Railway/Azure)
- ⏳ CI/CD pipeline

---

### 👥 **Contributors**

- **Leonardo Cominese** - Gestor do Projeto
- **Equipe Avanci Consultoria** - Requisitos e validação
- **Claude AI** - Desenvolvimento e documentação

---

### 📞 **Suporte**

**Problemas?**
1. Consulte [TROUBLESHOOTING_WINDOWS.md](TROUBLESHOOTING_WINDOWS.md)
2. Execute scripts de teste: `test-docker.ps1` ou `test-docker.sh`
3. Veja logs: `docker-compose logs -f`
4. Contato: favanci@hotmail.com

**Repositório:** https://github.com/AvanciConsultoria/sgir-system

---

## [Unreleased]

### 🚀 **Próximas Funcionalidades**
- CRUD completo de todas as entidades
- Importador automático de planilhas Excel
- Dashboard Power BI
- Autenticação JWT
- Deploy Railway/Azure
- App mobile (Xamarin/MAUI)

---

**Formato:** [Tipo] - Data

**Tipos:**
- `Added` - Novas funcionalidades
- `Changed` - Mudanças em funcionalidades existentes
- `Deprecated` - Funcionalidades que serão removidas
- `Removed` - Funcionalidades removidas
- `Fixed` - Correções de bugs
- `Security` - Correções de segurança
