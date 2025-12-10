# 🔧 Correção: SQLite Error "no such table: Itens_Estoque"

## 🐛 Problema

Ao executar a aplicação com SQLite, ocorria o erro:

```
SqliteException: SQLite Error 1: 'no such table: Itens_Estoque'
```

Este erro acontece na página `Ferramentas.razor` ao tentar carregar dados de `ItensEstoque`.

---

## 🔍 Causa Raiz

O problema ocorre quando:

1. **O banco de dados SQLite não foi criado corretamente** na primeira execução
2. **O arquivo `sgir.db` existe mas está vazio ou incompleto** (sem as tabelas)
3. **O `EnsureCreatedAsync()` não recria tabelas** se o arquivo já existe

### Por que isso acontece?

O método `context.Database.EnsureCreatedAsync()`:
- ✅ Cria o banco se ele **não existe**
- ❌ **NÃO** cria tabelas se o arquivo do banco já existe (mesmo que vazio)
- ❌ **NÃO** verifica se as tabelas estão corretas

Então se o arquivo `./Data/sgir.db` foi criado mas está vazio/corrompido, as tabelas não são criadas.

---

## ✅ Solução Implementada

### 1. Verificação Robusta de Tabelas

Adicionamos um bloco `try-catch` que:

```csharp
try
{
    // Tenta verificar se há dados
    if (await context.Projetos.AnyAsync())
    {
        return; // Dados existem, não precisa seed
    }
}
catch (Exception ex)
{
    // Se falhar (ex: tabela não existe)
    if (isSqlite)
    {
        // Para SQLite: deletar e recriar do zero
        await context.Database.EnsureDeletedAsync();
        await context.Database.EnsureCreatedAsync();
    }
    else
    {
        // Para SQL Server: propagar erro
        throw;
    }
}
```

**Resultado**: Se as tabelas não existirem, o banco SQLite é recriado automaticamente.

### 2. Logging Detalhado

Adicionamos logs para debug:

```csharp
Console.WriteLine($"🔧 DatabaseInitializer: Provider = {context.Database.ProviderName}");
Console.WriteLine($"🔧 DatabaseInitializer: IsSqlite = {isSqlite}");
Console.WriteLine("🔧 Calling EnsureCreatedAsync...");
var created = await context.Database.EnsureCreatedAsync();
Console.WriteLine($"🔧 EnsureCreatedAsync returned: {created}");
Console.WriteLine("🔧 Checking if data already exists...");
```

**Resultado**: Você pode ver exatamente o que está acontecendo no console.

---

## 🚀 Como Testar

### Opção 1: Deletar o banco existente (mais rápido)

```bash
# Deletar o banco SQLite corrompido
rm ./Data/sgir.db
rm ./Data/sgir.db-shm
rm ./Data/sgir.db-wal

# Reiniciar a aplicação
dotnet run
```

### Opção 2: Deixar a aplicação recriar automaticamente

```bash
# A aplicação agora detecta e recria o banco automaticamente
dotnet run
```

### Opção 3: Docker (limpar volume)

```bash
# Parar e remover containers/volumes
docker-compose -f docker-compose-simple.yml down -v

# Recriar tudo
docker-compose -f docker-compose-simple.yml up -d --build
```

---

## 📊 Resultado Esperado

Após a correção, você verá no console:

```
🔧 DatabaseInitializer: Provider = Microsoft.EntityFrameworkCore.Sqlite
🔧 DatabaseInitializer: IsSqlite = True
🔧 Calling EnsureCreatedAsync...
🔧 EnsureCreatedAsync returned: True (true = created, false = already existed)
🔧 Checking if data already exists...
📦 No data found, proceeding with seed...
✅ Database migrated and seeded successfully!
```

E a aplicação funcionará sem erros de "table not found".

---

## 🔄 Fluxo de Inicialização (Atualizado)

```
┌─────────────────────────────────────┐
│  1. Aplicação inicia                │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  2. EnsureCreatedAsync()            │
│     - Cria arquivo sgir.db          │
│     - Cria todas as tabelas         │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  3. Try: Verificar se há dados      │
│     - context.Projetos.AnyAsync()   │
└────────────┬────────────────────────┘
             │
        ┌────┴────┐
        │         │
        ▼         ▼
  ✅ Sucesso   ❌ Erro
        │         │
        │         ▼
        │    ┌───────────────────────┐
        │    │ Catch: Banco quebrado │
        │    └────────┬──────────────┘
        │             │
        │             ▼
        │    ┌───────────────────────┐
        │    │ EnsureDeletedAsync()  │
        │    │ EnsureCreatedAsync()  │
        │    └────────┬──────────────┘
        │             │
        └────┬────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  4. Seed: Inserir dados de exemplo  │
│     - 3 Projetos                    │
│     - 3 Colaboradores               │
│     - 3 Certificações               │
│     - 4 Itens Estoque               │
│     - etc.                          │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  5. ✅ Aplicação pronta!            │
│     http://localhost:5000           │
└─────────────────────────────────────┘
```

---

## 🎯 Diferenças: SQLite vs SQL Server

| Aspecto | SQLite | SQL Server |
|---------|--------|------------|
| **Arquivo físico** | `./Data/sgir.db` | Banco no servidor |
| **Migrations** | ❌ Não recomendado | ✅ Recomendado |
| **EnsureCreated** | ✅ Funciona bem | ⚠️ Só para dev |
| **Recreação automática** | ✅ Implementado | ❌ Lançar erro |
| **Performance** | 🐢 Mais lento | 🚀 Mais rápido |
| **Uso recomendado** | Testes, dev local | Produção |

---

## 📝 Arquivos Modificados

### `src/SGIR.WebApp/Data/DatabaseInitializer.cs`

**Mudanças:**
1. ✅ Adicionado `try-catch` para detectar tabelas ausentes
2. ✅ Adicionada lógica de recreação automática para SQLite
3. ✅ Adicionados logs detalhados para debugging
4. ✅ Diferenciação de comportamento SQLite vs SQL Server

**Linhas modificadas:** 13-40

---

## 🐞 Outros Erros Relacionados

Se você ainda vir erros de "table not found" após essa correção, verifique:

### 1. Permissões de Arquivo
```bash
# Verificar se a pasta Data existe e tem permissões corretas
ls -la ./Data/
chmod 755 ./Data/
chmod 644 ./Data/sgir.db
```

### 2. Connection String Errada
```json
// appsettings.json - verificar caminho correto
{
  "ConnectionStrings": {
    "SqliteConnection": "Data Source=./Data/sgir.db"
  }
}
```

### 3. Múltiplas Instâncias
```bash
# Parar todas as instâncias em execução
pkill -f dotnet
# Ou no Windows:
taskkill /F /IM dotnet.exe
```

### 4. Arquivo Bloqueado
```bash
# Linux/Mac
lsof ./Data/sgir.db

# Windows (PowerShell)
Get-Process | Where-Object {$_.Path -like "*sgir.db*"}
```

---

## 🎓 Lições Aprendidas

### 1. **EnsureCreated vs Migrations**
- `EnsureCreated()`: Bom para testes e desenvolvimento rápido
- `Migrations`: Necessário para produção e controle de versão

### 2. **SQLite é Delicado**
- Arquivo pode existir mas estar vazio/corrompido
- Sempre verificar se as tabelas realmente existem
- Usar logs para debug

### 3. **Diferenças entre Providers**
- SQLite: mais permissivo, pode recriar facilmente
- SQL Server: mais rígido, erros devem ser tratados adequadamente

---

## 🚀 Próximos Passos (Recomendações)

### Para Desenvolvimento Local
✅ **Atual**: SQLite com `EnsureCreated()` + auto-recreação  
👍 **Funciona perfeitamente para testes**

### Para Produção
⏳ **Recomendado**: Migrar para SQL Server + Migrations

```bash
# Criar primeira migration
dotnet ef migrations add InitialCreate --project src/SGIR.Infrastructure

# Aplicar migration
dotnet ef database update --project src/SGIR.WebApp
```

---

## 📚 Referências

- **Entity Framework Core**: https://docs.microsoft.com/ef/core/
- **SQLite Provider**: https://docs.microsoft.com/ef/core/providers/sqlite/
- **Migrations**: https://docs.microsoft.com/ef/core/managing-schemas/migrations/

---

**Data**: 2025-12-10  
**Versão**: 1.0  
**Status**: ✅ **CORRIGIDO**  
**Commit**: Próximo commit
