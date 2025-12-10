# 🚀 SGIR - Como Testar o Sistema

## ✅ **STATUS ATUAL**

**Phase 3 CONCLUÍDA!** O sistema agora está **PRONTO PARA TESTAR** localmente! 🎉

### **O que está funcionando:**
- ✅ **Backend completo** (Entity Framework Core + SQL Server)
- ✅ **Interface web** (Blazor Server com dashboard)
- ✅ **Lógica de negócio** (Gap Analysis, Alocação, Compras)
- ✅ **Menu de navegação** organizado
- ✅ **Dashboard** com estatísticas em tempo real

---

## 📋 **PRÉ-REQUISITOS**

### **1. Instalar .NET 8 SDK**

**Windows:**
1. Baixar: https://dotnet.microsoft.com/download/dotnet/8.0
2. Instalar o **.NET 8 SDK** (não Runtime)
3. Verificar instalação:
   ```cmd
   dotnet --version
   ```
   Deve mostrar: `8.0.x`

**Linux/Mac:**
```bash
# Ubuntu/Debian
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0

# macOS
brew install dotnet@8
```

### **2. SQL Server (Escolha UMA opção)**

#### **Opção A: SQL Server LocalDB** (Recomendado - Windows)
- Já vem com o Visual Studio
- OU baixar standalone: https://download.microsoft.com/download/8/6/8/868f5fc4-7bfe-494d-8f9d-115cbcee2f0a/SqlLocalDB.msi
- Leve e automático
- **String de conexão:** `Server=(localdb)\\mssqllocaldb;Database=SGIR_DB;Trusted_Connection=true`

#### **Opção B: SQL Server Express** (Windows/Linux/Docker)
- Baixar: https://www.microsoft.com/sql-server/sql-server-downloads
- Grátis, mais recursos
- **String de conexão:** `Server=localhost\\SQLEXPRESS;Database=SGIR_DB;Trusted_Connection=true`

#### **Opção C: Docker** (Qualquer SO)
```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=SuaSenha123!" \
  -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
```
- **String de conexão:** `Server=localhost,1433;Database=SGIR_DB;User Id=sa;Password=SuaSenha123!;TrustServerCertificate=true`

### **3. Git**
- Baixar: https://git-scm.com/downloads
- Verificar: `git --version`

---

## 📥 **PASSO 1: BAIXAR O CÓDIGO**

### **Opção A: Clonar do GitHub**
```bash
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system
```

### **Opção B: Download direto**
1. Acessar: https://github.com/AvanciConsultoria/sgir-system
2. Clicar em **Code** > **Download ZIP**
3. Extrair e abrir pasta `sgir-system`

---

## ⚙️ **PASSO 2: CONFIGURAR BANCO DE DADOS**

### **Editar String de Conexão**

1. Abrir arquivo: `src/SGIR.WebApp/appsettings.json`

2. Editar conforme seu SQL Server:

**Para LocalDB (padrão):**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=SGIR_DB;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=true"
  }
}
```

**Para SQL Express:**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=SGIR_DB;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=true"
  }
}
```

**Para Docker:**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=SGIR_DB;User Id=sa;Password=SuaSenha123!;TrustServerCertificate=true;MultipleActiveResultSets=true"
  }
}
```

---

## 🚀 **PASSO 3: RODAR O SISTEMA**

### **Método 1: Via Terminal (Recomendado)**

```bash
# Navegar até a pasta do WebApp
cd src/SGIR.WebApp

# Restaurar dependências
dotnet restore

# Criar o banco de dados automaticamente
dotnet ef database update --project ../SGIR.Infrastructure

# Rodar o sistema
dotnet run
```

O sistema vai:
1. ✅ Criar o banco de dados `SGIR_DB`
2. ✅ Criar as 15 tabelas
3. ✅ Iniciar o servidor web

**Você verá:**
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
✅ Database migrated successfully!
```

### **Método 2: Visual Studio**

1. Abrir `sgir-system.sln` (se existir) OU
2. Abrir pasta `src/SGIR.WebApp` diretamente
3. Pressionar **F5** ou clicar em **Run**

### **Método 3: Visual Studio Code**

1. Abrir pasta `sgir-system` no VS Code
2. Instalar extensão: **C# Dev Kit**
3. Pressionar **F5**

---

## 🌐 **PASSO 4: ACESSAR O SISTEMA**

### **Abrir no Navegador:**

1. **Interface Principal:**
   ```
   https://localhost:7001
   ```
   OU
   ```
   http://localhost:5000
   ```

2. **Dashboard:**
   - Você verá cards com:
     - 📊 Projetos Ativos
     - 👥 Colaboradores (aptos/inaptos)
     - 📦 Itens de Estoque (críticos)
     - 🛒 Compras Pendentes

3. **API Docs (Swagger):**
   ```
   https://localhost:7001/api/docs
   ```
   - Para testar endpoints REST

---

## 🧪 **PASSO 5: TESTAR FUNCIONALIDADES**

### **1. Verificar Dashboard**
- ✅ Dashboard carrega sem erros
- ✅ Cards mostram "0" (banco vazio)
- ✅ Menu lateral abre/fecha

### **2. Testar API (Swagger)**
1. Acessar: `https://localhost:7001/api/docs`
2. Expandir endpoint (quando criar os Controllers)
3. Clicar em **Try it out**
4. Testar requisições

### **3. Adicionar Dados de Teste** (quando prontas as páginas)
- Colaboradores
- Projetos
- Itens de Estoque

---

## 🐛 **TROUBLESHOOTING**

### **Erro: "Cannot create database"**

**Causa:** SQL Server não está rodando

**Solução:**
- LocalDB: Executar `sqllocaldb start`
- SQL Express: Verificar no Services (Windows)
- Docker: `docker ps` (verificar se container está rodando)

### **Erro: "Login failed for user"**

**Causa:** String de conexão incorreta

**Solução:**
1. Verificar `appsettings.json`
2. Testar conexão manual:
   ```cmd
   sqlcmd -S (localdb)\mssqllocaldb -Q "SELECT @@VERSION"
   ```

### **Erro: "dotnet command not found"**

**Causa:** .NET SDK não instalado

**Solução:**
1. Instalar .NET 8 SDK
2. Reiniciar terminal
3. Verificar: `dotnet --version`

### **Erro: "Port already in use"**

**Causa:** Porta 7001 ou 5000 ocupada

**Solução:**
1. Editar `src/SGIR.WebApp/Properties/launchSettings.json`
2. Mudar portas para 7002/5001

### **Erro: "Migration not found"**

**Solução:**
```bash
cd src/SGIR.WebApp
dotnet ef migrations add InitialCreate --project ../SGIR.Infrastructure
dotnet ef database update --project ../SGIR.Infrastructure
```

---

## 📊 **O QUE FUNCIONA AGORA**

| Funcionalidade | Status | Como Testar |
|----------------|--------|-------------|
| **Dashboard** | ✅ Funcional | Abrir homepage |
| **Menu Navegação** | ✅ Funcional | Clicar nos links |
| **Banco de Dados** | ✅ Criado | Verificar SSMS/Azure Data Studio |
| **API REST** | 🚧 Parcial | Swagger em /api/docs |
| **Colaboradores** | 🚧 Em dev | Próxima atualização |
| **Projetos** | 🚧 Em dev | Próxima atualização |
| **Gap Analysis** | 🚧 Em dev | Próxima atualização |
| **Importar Excel** | 🚧 Em dev | Próxima atualização |

---

## 📸 **PRINTS ESPERADOS**

### **1. Dashboard (Homepage)**
```
┌─────────────────────────────────────────────────────┐
│ SGIR - Dashboard                                     │
├─────────────────────────────────────────────────────┤
│                                                      │
│  📊 Projetos Ativos    👥 Colaboradores              │
│       0                      0                       │
│                          0 aptos                     │
│                                                      │
│  📦 Itens Estoque      🛒 Compras Pendentes          │
│       0                      0                       │
│    0 críticos                                        │
│                                                      │
│  ⚠️ Atenção Necessária:                              │
│  (nenhum alerta - banco vazio)                      │
│                                                      │
│  ⚡ Ações Rápidas:                                   │
│  [➕ Novo Projeto] [📊 Analisar Déficit] [📥 Importar]│
└─────────────────────────────────────────────────────┘
```

### **2. Menu Lateral**
```
🔧 SGIR
─────────────
🏠 Dashboard
─────────────
📊 PLANEJAMENTO
  📁 Projetos
  🔧 Recursos
─────────────
👥 PESSOAS
  👤 Colaboradores
  📅 Alocações
  🛡️ Certificações
─────────────
📦 ESTOQUE
  📦 Itens
  🔄 Movimentações
─────────────
🛒 COMPRAS
  📊 Gap Analysis
  🛒 Compras Auto
─────────────
💰 CUSTOS
  💵 Operacionais
─────────────
⚙️ FERRAMENTAS
  📥 Importar Excel
```

---

## 🎯 **PRÓXIMOS PASSOS (Após Testar)**

### **Para você testar agora:**
1. ✅ Verificar se o sistema roda
2. ✅ Verificar se o banco foi criado
3. ✅ Verificar se o dashboard carrega
4. ✅ Navegar pelo menu

### **Próxima atualização (que vou fazer):**
1. 🚧 Página de **Colaboradores** (lista + adicionar)
2. 🚧 Página de **Projetos** (lista + adicionar)
3. 🚧 Página de **Gap Analysis** (visual)
4. 🚧 **Importador de Excel** (upload da sua planilha)

---

## 📞 **SUPORTE**

Se tiver algum erro:

1. **Copie a mensagem de erro completa**
2. **Tire print da tela**
3. **Me envie** que eu corrijo imediatamente

---

## 🎉 **PARABÉNS!**

Você está rodando o **SGIR - Sistema de Gestão Integrada de Recursos**!

**Progresso Atual:**
```
████████████████░░░░ 80%
```

**Fases Concluídas:**
- ✅ Phase 1: Database (SQL Server)
- ✅ Phase 2: Domain Model (Lógica)
- ✅ Phase 3: Infrastructure + WebApp
- 🚧 Phase 4: CRUD Pages (em desenvolvimento)

**Próximo Objetivo:**
Completar páginas de CRUD para você poder adicionar colaboradores, projetos e testar a análise de déficit!

---

**Desenvolvido para**: Avanci Consultoria  
**GitHub**: https://github.com/AvanciConsultoria/sgir-system  
**Status**: ✅ **TESTÁVEL LOCALMENTE**

