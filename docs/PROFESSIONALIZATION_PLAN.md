# 🎯 PLANO DE PROFISSIONALIZAÇÃO DO SGIR

## 📊 **DIAGNÓSTICO RÁPIDO - SITUAÇÃO ATUAL**

### ✅ **O QUE JÁ FUNCIONA**
- ✅ Docker + SQL Server configurado
- ✅ Blazor Server rodando (porta 5000)
- ✅ Estrutura Clean Architecture implementada
- ✅ Entity Framework Core + DbContext completo
- ✅ Entidades do domínio criadas
- ✅ Páginas Ferramentas e Caixas funcionais
- ✅ Sistema de navegação (NavMenu)
- ✅ Scripts de instalação (Windows/Linux/Docker)

### ❌ **O QUE AINDA NÃO FUNCIONA (Links 404)**
```
❌ /dashboard          → Erro 404
❌ /usuarios           → Erro 404  
❌ /permissoes         → Erro 404
❌ /residuos           → Erro 404
❌ /disposicoes        → Erro 404
❌ /embalagens         → Erro 404
❌ /processos          → Erro 404
❌ /certificacoes      → Erro 404
❌ /projetos           → Erro 404
❌ /recursos           → Erro 404
❌ /colaboradores      → Erro 404
❌ /epis               → Erro 404
❌ /alocacoes          → Erro 404
❌ /movimentacoes      → Erro 404
❌ /compras            → Erro 404
❌ /analises           → Erro 404
❌ /custos             → Erro 404
❌ /importar-excel     → Erro 404
```

**MOTIVO:** Arquivos `.razor` não existem

---

## 🚀 **ESTRATÉGIA DE PROFISSIONALIZAÇÃO**

### **FASE 1: Interface Intuitiva e Dados de Demonstração**

#### **Objetivo:** Sistema utilizável imediatamente após instalação

#### **1.1 Seed Data Inteligente** 🌱
**Arquivo:** `database/seed-demo-data.sql`

**Dados a serem pré-cadastrados:**
```sql
-- 5 Projetos de Exemplo
INSERT INTO Projetos VALUES ('PRJ-001', 'Alteração Layout - Linha Montagem', 'COMAU', ...)
INSERT INTO Projetos VALUES ('PRJ-002', 'Manutenção Preventiva - Prensa Hidráulica', 'FIAT', ...)
INSERT INTO Projetos VALUES ('PRJ-003', 'Instalação Elétrica Nova Célula', 'Renault SJP', ...)

-- 10 Colaboradores com Certificações
INSERT INTO Colaboradores VALUES ('12345678900', 'Leonardo Cominese', 'Engenheiro Eletricista', ...)
INSERT INTO Certificacoes VALUES ('12345678900', 'NR-10', '2024-01-15', '2026-01-15', 'VÁLIDA')
INSERT INTO Certificacoes VALUES ('12345678900', 'NR-35', '2024-02-10', '2026-02-10', 'VÁLIDA')

-- 50 Ferramentas e Equipamentos (do Excel fornecido)
INSERT INTO Itens_Estoque VALUES ('Alicate Universal', 'FERRAMENTA_MANUAL', 'KNIPEX', ...)
INSERT INTO Itens_Estoque VALUES ('Parafusadeira Elétrica', 'FERRAMENTA_ELETRICA', 'BOSCH', ...)
INSERT INTO Itens_Estoque VALUES ('Multímetro Digital', 'INSTRUMENTO_MEDICAO', 'FLUKE', ...)

-- 5 Caixas de Ferramentas Pré-Montadas
INSERT INTO Caixas_Ferramentas VALUES ('CX-MEC-001', 'Caixa Mecânica Básica', 'MECANICA', ...)
INSERT INTO Caixas_Itens VALUES ('CX-MEC-001', 'Alicate Universal', 2)
INSERT INTO Caixas_Itens VALUES ('CX-MEC-001', 'Chave Philips', 3)

-- 3 Carrinhos Completos
INSERT INTO Carrinhos VALUES ('CARR-001', 'Carrinho Elétrica Completo', 'ELETRONICA', ...)
INSERT INTO Carrinhos_Itens VALUES ('CARR-001', 'CX-ELE-001', 'CAIXA', 1)
```

**Script PowerShell:** `seed-demo-data.ps1`
```powershell
# Executar automaticamente no primeiro start
if (-not (Test-Path "$AppDataDir\.seeded")) {
    Write-Info "Carregando dados de demonstração..."
    sqlcmd -S "(localdb)\MSSQLLocalDB" -d SGIR_DB -i "$InstallDir\database\seed-demo-data.sql"
    New-Item -ItemType File -Path "$AppDataDir\.seeded" -Force
}
```

---

#### **1.2 Dashboard Funcional e Intuitivo** 📊
**Arquivo:** `src/SGIR.WebApp/Pages/Dashboard.razor`

**Conteúdo:**
```razor
@page "/"
@page "/dashboard"

<PageTitle>Dashboard - SGIR</PageTitle>

<h2>📊 Painel de Controle</h2>

<div class="row">
    <!-- Cards de Estatísticas -->
    <div class="col-md-3">
        <div class="card bg-primary text-white mb-3">
            <div class="card-body">
                <h5>Projetos Ativos</h5>
                <h2>@TotalProjetos</h2>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-success text-white mb-3">
            <div class="card-body">
                <h5>Colaboradores Aptos</h5>
                <h2>@ColaboradoresAptos / @TotalColaboradores</h2>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-warning text-white mb-3">
            <div class="card-body">
                <h5>Itens Abaixo do Mínimo</h5>
                <h2>@ItensAbaixoMinimo</h2>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-danger text-white mb-3">
            <div class="card-body">
                <h5>Compras Pendentes</h5>
                <h2>@ComprasPendentes</h2>
            </div>
        </div>
    </div>
</div>

<!-- Tabelas de Resumo -->
<div class="row mt-4">
    <div class="col-md-6">
        <h4>⚠️ Certificações Vencendo (30 dias)</h4>
        <table class="table table-sm">
            <thead>
                <tr>
                    <th>Colaborador</th>
                    <th>Certificação</th>
                    <th>Validade</th>
                </tr>
            </thead>
            <tbody>
                @foreach (var cert in CertificacoesVencendo)
                {
                    <tr>
                        <td>@cert.NomeColaborador</td>
                        <td><span class="badge bg-warning">@cert.TipoCertificacao</span></td>
                        <td>@cert.DataValidade.ToString("dd/MM/yyyy")</td>
                    </tr>
                }
            </tbody>
        </table>
    </div>
    
    <div class="col-md-6">
        <h4>📦 Itens Críticos no Estoque</h4>
        <table class="table table-sm">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Atual</th>
                    <th>Mínimo</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                @foreach (var item in ItensCriticos)
                {
                    <tr>
                        <td>@item.Descricao</td>
                        <td>@item.EstoqueAtual</td>
                        <td>@item.EstoqueMinimo</td>
                        <td><span class="badge bg-danger">CRÍTICO</span></td>
                    </tr>
                }
            </tbody>
        </table>
    </div>
</div>

@code {
    private int TotalProjetos = 0;
    private int TotalColaboradores = 0;
    private int ColaboradoresAptos = 0;
    private int ItensAbaixoMinimo = 0;
    private int ComprasPendentes = 0;
    
    private List<CertificacaoVencendoDto> CertificacoesVencendo = new();
    private List<ItemEstoque> ItensCriticos = new();
    
    protected override async Task OnInitializedAsync()
    {
        // Carregar dados do banco
        await CarregarEstatisticas();
    }
}
```

---

### **FASE 2: Páginas CRUD Completas (Step-by-Step)**

#### **2.1 Módulo GERAL (1h)**
1. ✅ `Dashboard.razor` (já descrito acima)
2. ⏳ `Usuarios.razor` → CRUD simples
3. ⏳ `Permissoes.razor` → Matriz de permissões

#### **2.2 Módulo CADASTROS (2h)**
1. ⏳ `Projetos.razor` → CRUD completo
   - Formulário: OS, Nome, Cliente, Local, Gestor, Data Início
   - Listagem com filtros
   - Edição inline
   
2. ⏳ `Colaboradores.razor` → CRUD completo
   - Formulário: CPF, Nome, Função, Admissão
   - Listagem com status de certificações (🟢 APTO / 🔴 INAPTO)
   - Botão "Gerenciar Certificações"
   
3. ⏳ `Certificacoes.razor` → Sub-página de Colaboradores
   - Listagem por colaborador
   - Adicionar/Remover certificações
   - Alerta visual (vencendo em 30 dias)
   
4. ⏳ `EPIs.razor` → CRUD simples
   - Listagem de EPIs por colaborador
   - Controle de entrega/devolução

#### **2.3 Módulo RECURSOS (1,5h)**
1. ⏳ `RecursosNecessarios.razor` → Página de planejamento
   - Por Projeto
   - Adicionar recursos necessários (Ferramentas/Equipamentos/Pessoas)
   - Quantidade, Data Início, Data Fim
   
2. ⏳ `Alocacoes.razor` → Página de alocação
   - Selecionar Projeto
   - Alocar Colaboradores (com validação automática de certificações)
   - Alocar Ferramentas/Equipamentos (com validação de estoque)
   - Mensagens de erro: "Colaborador INAPTO - NR-10 vencida"

#### **2.4 Módulo ESTOQUE (Já Implementado)**
1. ✅ `Ferramentas.razor` → CRUD completo
2. ✅ `CaixasFerramentas.razor` → Gerenciamento de agrupamento
3. ⏳ `Carrinhos.razor` → Agrupamento de caixas + máquinas
4. ⏳ `Movimentacoes.razor` → Histórico de movimentações

#### **2.5 Módulo COMPRAS (2h)**
1. ⏳ `AnaliseDeficit.razor` → Análise GAP
   - Botão: "Analisar Déficit para Projeto X"
   - Lógica: `Demanda - Estoque = Déficit`
   - Tabela de resultados:
     ```
     Item              | Demanda | Estoque | Déficit | Recomendação
     Alicate Universal |   10    |    3    |    7    | [COMPRAR 7]
     Parafusadeira     |    5    |    2    |    3    | [ALUGAR 3]
     ```
   - Botão: "Gerar Pedidos de Compra Automáticos"
   
2. ⏳ `ComprasAutomaticas.razor` → Lista de pedidos
   - Status: PENDENTE / APROVADO / COMPRADO / RECEBIDO
   - Ações: Aprovar, Marcar como Comprado, Marcar como Recebido
   - Filtros por status

#### **2.6 Módulo CUSTOS (1h)**
1. ⏳ `CustosOperacionais.razor` → CRUD simples
   - Por Projeto
   - Tipo: MÃO_DE_OBRA, MATERIAL, EQUIPAMENTO, TRANSPORTE, OUTROS
   - Valor Unitário × Quantidade = Valor Total
   - Somatório por projeto

#### **2.7 Módulo FERRAMENTAS (1h)**
1. ⏳ `ImportarExcel.razor` → Upload de planilha
   - Componente: `<InputFile accept=".xlsx,.xls">`
   - Processar com `EPPlus` ou `NPOI`
   - Mapeamento inteligente:
     ```
     Coluna "Descrição" → ItemEstoque.Descricao
     Coluna "Quantidade" → ItemEstoque.EstoqueAtual
     Coluna "Categoria" → ItemEstoque.Categoria
     ```
   - Preview antes de importar
   - Botão: "Confirmar Importação"

---

### **FASE 3: UX e Consistência (1h)**

#### **3.1 Componentes Reutilizáveis**
**Arquivo:** `src/SGIR.WebApp/Shared/Components/`

1. **CardEstatistica.razor**
   ```razor
   <div class="card bg-@Cor text-white mb-3">
       <div class="card-body">
           <h5>@Titulo</h5>
           <h2>@Valor</h2>
       </div>
   </div>
   ```

2. **TabelaCrud.razor**
   - Grid padrão com paginação
   - Botões: Novo, Editar, Excluir
   - Filtro de busca

3. **ModalFormulario.razor**
   - Modal Bootstrap
   - Botões: Salvar, Cancelar
   - Validação de campos

#### **3.2 Layout Consistente**
**Arquivo:** `src/SGIR.WebApp/Shared/MainLayout.razor`

```razor
<div class="page">
    <div class="sidebar">
        <NavMenu />
    </div>

    <main>
        <div class="top-row px-4">
            <a href="/perfil">👤 Leonardo Cominese</a>
            <a href="/logout">Sair</a>
        </div>

        <article class="content px-4">
            @Body
        </article>
    </main>
</div>
```

#### **3.3 CSS Customizado**
**Arquivo:** `src/SGIR.WebApp/wwwroot/css/app.css`

```css
:root {
    --color-primary: #0066cc;
    --color-success: #28a745;
    --color-warning: #ffc107;
    --color-danger: #dc3545;
}

.badge-apto { background-color: var(--color-success); }
.badge-inapto { background-color: var(--color-danger); }
.badge-vencendo { background-color: var(--color-warning); }
```

---

### **FASE 4: Qualidade e Observabilidade (1h)**

#### **4.1 Logging Estruturado**
**Arquivo:** `src/SGIR.WebApp/Program.cs`

```csharp
builder.Logging.AddConsole();
builder.Logging.AddDebug();

// Log de operações críticas
builder.Services.AddScoped<IAuditService, AuditService>();
```

**Logs importantes:**
- ✅ Alocação de colaborador (com validação)
- ✅ Criação de pedido de compra automático
- ✅ Importação de Excel (quantos itens, erros)
- ✅ Análise de déficit (resultado da análise)

#### **4.2 Tratamento de Erros**
**Arquivo:** `src/SGIR.WebApp/Pages/Error.cshtml`

```html
<h1>Ops! Algo deu errado</h1>
<p>Por favor, tire um print desta tela e envie para o suporte:</p>
<pre>@Model.Error</pre>
<a href="/">Voltar ao Dashboard</a>
```

#### **4.3 Healthchecks**
**Arquivo:** `src/SGIR.WebApp/Program.cs`

```csharp
builder.Services.AddHealthChecks()
    .AddSqlServer(connectionString, name: "database")
    .AddCheck("self", () => HealthCheckResult.Healthy());

app.MapHealthChecks("/health");
```

**Usar em:** `docker-compose.yml` → `healthcheck: /health`

---

### **FASE 5: Empacotamento Windows PRO (1h)**

#### **5.1 Self-Contained Single File** (JÁ IMPLEMENTADO)
```powershell
dotnet publish --configuration Release `
    --runtime win-x64 `
    --self-contained true `
    -p:PublishSingleFile=true `
    -p:IncludeNativeLibrariesForSelfExtract=true `
    -p:EnableCompressionInSingleFile=true
```

**Resultado:** `SGIR.WebApp.exe` (80-120 MB)

#### **5.2 Instalador .EXE com Inno Setup** (FUTURO)
**Arquivo:** `installer/sgir-setup.iss`

```iss
[Setup]
AppName=SGIR - Sistema de Gestão Integrada de Recursos
AppVersion=1.0
DefaultDirName={pf}\SGIR
DefaultGroupName=SGIR
OutputBaseFilename=SGIR-Setup-v1.0
Compression=lzma2
SolidCompression=yes

[Files]
Source: "..\publish\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\SGIR"; Filename: "{app}\SGIR.WebApp.exe"
Name: "{commondesktop}\SGIR"; Filename: "{app}\SGIR.WebApp.exe"

[Run]
Filename: "{app}\SGIR.WebApp.exe"; Description: "Executar SGIR"; Flags: postinstall nowait
```

**Compilar com:** `iscc sgir-setup.iss`

---

## 📅 **CRONOGRAMA DE IMPLEMENTAÇÃO**

| Fase | Tempo Estimado | Prioridade |
|------|----------------|------------|
| **FASE 1: Seed Data + Dashboard** | 2h | 🔴 CRÍTICA |
| **FASE 2.1: Módulo GERAL** | 1h | 🔴 CRÍTICA |
| **FASE 2.2: Módulo CADASTROS** | 2h | 🔴 CRÍTICA |
| **FASE 2.3: Módulo RECURSOS** | 1,5h | 🟠 ALTA |
| **FASE 2.4: Módulo ESTOQUE** | ✅ CONCLUÍDO | ✅ |
| **FASE 2.5: Módulo COMPRAS** | 2h | 🟠 ALTA |
| **FASE 2.6: Módulo CUSTOS** | 1h | 🟡 MÉDIA |
| **FASE 2.7: Importar Excel** | 1h | 🟠 ALTA |
| **FASE 3: UX e Consistência** | 1h | 🟡 MÉDIA |
| **FASE 4: Qualidade** | 1h | 🟡 MÉDIA |
| **FASE 5: Empacotamento** | 1h | 🟢 BAIXA |
| **TOTAL** | **13,5 horas** | |

---

## 🎯 **RESULTADO FINAL ESPERADO**

### **Após Instalação (3 cliques):**
1. ✅ Sistema abre automaticamente no navegador
2. ✅ Dashboard com dados de demonstração visível
3. ✅ 5 projetos de exemplo cadastrados
4. ✅ 10 colaboradores com certificações
5. ✅ 50 ferramentas/equipamentos no estoque
6. ✅ 5 caixas de ferramentas pré-montadas
7. ✅ 3 carrinhos completos
8. ✅ Todos os links do menu funcionando (0 erros 404)

### **Experiência do Usuário:**
```
ANTES (situação atual):
❌ Usuário clica em "Projetos" → Erro 404
❌ Usuário clica em "Colaboradores" → Erro 404
❌ Banco de dados vazio → Nada para testar

DEPOIS (após profissionalização):
✅ Usuário clica em "Projetos" → Vê 5 projetos de exemplo
✅ Usuário clica em "Colaboradores" → Vê 10 pessoas cadastradas
✅ Usuário clica em "Alocar" → Sistema valida certificações automaticamente
✅ Usuário clica em "Análise Déficit" → Vê recomendações de compra
✅ Sistema completo e intuitivo desde o primeiro uso
```

---

## 📊 **MÉTRICAS DE SUCESSO**

| Métrica | Antes | Depois |
|---------|-------|--------|
| **Links funcionais** | 3/20 (15%) | 20/20 (100%) |
| **Tempo até primeiro uso** | Manual (30min+) | Automático (3min) |
| **Dados de demonstração** | 0 registros | 70+ registros |
| **Experiência inicial** | Frustrante | Intuitiva |
| **Instalação Windows** | Complexa | 3 cliques |

---

## 🚀 **PRÓXIMOS PASSOS IMEDIATOS**

### **✅ Passo 1: Criar Seed Data SQL**
- Arquivo: `database/seed-demo-data.sql`
- Executar automaticamente no `install-windows.ps1`

### **✅ Passo 2: Criar Dashboard.razor**
- Arquivo: `src/SGIR.WebApp/Pages/Dashboard.razor`
- Estatísticas e alertas visuais

### **✅ Passo 3: Criar Páginas CRUD (uma por vez)**
- Começar por: Projetos, Colaboradores, Certificações
- Seguir template padrão (listagem + formulário)

### **✅ Passo 4: Testar Instalação End-to-End**
- Executar `install-windows.ps1`
- Verificar todos os links
- Validar dados de demonstração

---

## 📞 **SUPORTE E DÚVIDAS**

**Desenvolvido por:** Avanci Consultoria  
**Versão do Plano:** 1.0  
**Data:** Dezembro 2025  
**Status:** 🟡 EM ANDAMENTO

---

**🎉 Resultado final:** Sistema profissional, intuitivo e pronto para uso em produção!
