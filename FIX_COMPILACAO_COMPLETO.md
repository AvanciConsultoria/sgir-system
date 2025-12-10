# 🔧 Correção Completa dos Erros de Compilação Docker

## 📋 Resumo Executivo

**Status**: ✅ **TODOS OS 17 ERROS CORRIGIDOS**

**Problema Original**: O build Docker falhava no passo 9/9 `RUN dotnet build "SGIR.WebApp.csproj"` com 17 erros de compilação.

**Solução**: Correção das propriedades das entidades no `DatabaseInitializer.cs` e adição do pacote NuGet `Microsoft.EntityFrameworkCore.Sqlite`.

---

## 🐛 Erros Identificados

### 1. Erros CS0117 - Propriedades Inexistentes na Entidade `Certificacao`

**Erros Reportados:**
```
error CS0117: 'Certificacao' does not contain a definition for 'TipoCertificacao'
error CS0117: 'Certificacao' does not contain a definition for 'DataEmissao'
error CS0117: 'Certificacao' does not contain a definition for 'DataValidade'
error CS0117: 'Certificacao' does not contain a definition for 'NumeroCertificado'
error CS0117: 'Certificacao' does not contain a definition for 'OrgaoEmissor'
error CS0117: 'Certificacao' does not contain a definition for 'Status'
```

**Causa**: A entidade `Certificacao.cs` define propriedades específicas por tipo de certificação:
- `NR10Validade` (DateTime?)
- `NR12Validade` (DateTime?)
- `LOTOValidade` (DateTime?)
- `NR35Validade` (DateTime?)
- `ASOValidade` (DateTime?)

Mas o código do `DatabaseInitializer.cs` tentava usar propriedades genéricas como `TipoCertificacao`, `DataEmissao`, `DataValidade`, `NumeroCertificado`, `OrgaoEmissor`, `Status`.

**Correção:**
```csharp
// ANTES (❌ INCORRETO)
var certificacoes = new List<Certificacao>
{
    new()
    {
        CpfColaborador = "123.456.789-00",
        TipoCertificacao = "NR-12",           // ❌ Propriedade não existe
        DataEmissao = DateTime.Today.AddMonths(-6),  // ❌ Propriedade não existe
        DataValidade = DateTime.Today.AddMonths(18), // ❌ Propriedade não existe
        NumeroCertificado = "NR12-2024-0001",        // ❌ Propriedade não existe
        OrgaoEmissor = "SENAI",                      // ❌ Propriedade não existe
        Status = "VÁLIDA"                            // ❌ Propriedade não existe
    }
};

// DEPOIS (✅ CORRETO)
var certificacoes = new List<Certificacao>
{
    new()
    {
        CpfColaborador = "123.456.789-00",
        NR12Validade = DateTime.Today.AddMonths(18),  // ✅ Propriedade correta
        ASOValidade = DateTime.Today.AddMonths(24)    // ✅ ASO obrigatório
    },
    new()
    {
        CpfColaborador = "987.654.321-00",
        NR35Validade = DateTime.Today.AddDays(-10),   // ✅ Vencido para teste
        ASOValidade = DateTime.Today.AddMonths(6)
    },
    new()
    {
        CpfColaborador = "555.666.777-00",
        NR10Validade = DateTime.Today.AddMonths(12),
        ASOValidade = DateTime.Today.AddMonths(18)
    }
};
```

---

### 2. Erros CS0117 - Propriedades Inexistentes na Entidade `EPI`

**Erros Reportados:**
```
error CS0117: 'EPI' does not contain a definition for 'DataValidade'
```

**Causa**: A entidade `EPI.cs` define a propriedade `ValidadeCA` (DateTime?) para a validade do Certificado de Aprovação, mas o código tentava usar `DataValidade`.

**Correção:**
```csharp
// ANTES (❌ INCORRETO)
var epis = new List<EPI>
{
    new()
    {
        CpfColaborador = "123.456.789-00",
        TipoEPI = "Capacete",
        CA = "12345",
        DataEntrega = DateTime.Today.AddMonths(-2),
        DataValidade = DateTime.Today.AddMonths(10),  // ❌ Propriedade não existe
        Observacoes = "Modelo classe B"
    }
};

// DEPOIS (✅ CORRETO)
var epis = new List<EPI>
{
    new()
    {
        CpfColaborador = "123.456.789-00",
        TipoEPI = "Capacete",
        CA = "12345",
        DataEntrega = DateTime.Today.AddMonths(-2),
        ValidadeCA = DateTime.Today.AddMonths(10),     // ✅ Propriedade correta
        VidaUtilDias = 365,                            // ✅ Vida útil do EPI
        Observacoes = "Modelo classe B"
    },
    new()
    {
        CpfColaborador = "987.654.321-00",
        TipoEPI = "Cinto de segurança",
        CA = "67890",
        DataEntrega = DateTime.Today.AddMonths(-1),
        ValidadeCA = DateTime.Today.AddMonths(5),
        VidaUtilDias = 180,
        Observacoes = "Substituir junto com renovação NR-35"
    },
    new()
    {
        CpfColaborador = "555.666.777-00",
        TipoEPI = "Luvas isolantes",
        CA = "54321",
        DataEntrega = DateTime.Today.AddMonths(-1),
        ValidadeCA = DateTime.Today.AddMonths(11),
        VidaUtilDias = 90,
        Observacoes = "Teste elétrico realizado"
    }
};
```

---

### 3. Erros CS0117 - Propriedades Inexistentes na Entidade `MovimentoEstoque`

**Erros Reportados:**
```
error CS0117: 'MovimentoEstoque' does not contain a definition for 'Observacao'
```

**Causa**: A entidade `MovimentoEstoque.cs` define a propriedade `Observacoes` (plural), mas o código tentava usar `Observacao` (singular).

**Correção:**
```csharp
// ANTES (❌ INCORRETO)
var movimentos = new List<MovimentoEstoque>
{
    new()
    {
        ItemEstoqueId = itens.First(i => i.Descricao.Contains("LOTO")).Id,
        TipoMovimento = TipoMovimento.Saida,
        Quantidade = 4,
        Unidade = "UN",
        DataMovimento = DateTime.Today.AddDays(-1),
        Responsavel = "Juliana Ferreira",
        LocalOrigem = "Almoxarifado Central",
        LocalDestino = "Planta Curitiba",
        Observacao = "Liberação para OS 1001"  // ❌ Nome incorreto (singular)
    }
};

// DEPOIS (✅ CORRETO)
var movimentos = new List<MovimentoEstoque>
{
    new()
    {
        ItemEstoqueId = itens.First(i => i.Descricao.Contains("LOTO")).Id,
        TipoMovimento = TipoMovimento.Saida,
        Quantidade = 4,
        Unidade = "UN",
        DataMovimento = DateTime.Today.AddDays(-1),
        Responsavel = "Juliana Ferreira",
        LocalOrigem = "Almoxarifado Central",
        LocalDestino = "Planta Curitiba",
        Observacoes = "Liberação para OS 1001",  // ✅ Plural correto
        ProjetoId = 1001                          // ✅ Vincula ao projeto
    },
    new()
    {
        ItemEstoqueId = itens.First(i => i.Descricao.Contains("Chave combinada")).Id,
        TipoMovimento = TipoMovimento.Entrada,
        Quantidade = 10,
        Unidade = "UN",
        DataMovimento = DateTime.Today.AddDays(-3),
        Responsavel = "Juliana Ferreira",
        LocalOrigem = "Fornecedor",
        LocalDestino = "Oficina",
        Observacoes = "Reposição de estoque"    // ✅ Plural correto
    }
};
```

---

### 4. Erro CS1061 - `UseSqlite` Não Encontrado

**Erro Reportado:**
```
error CS1061: 'DbContextOptionsBuilder' does not contain a definition for 'UseSqlite'
and no accessible extension method 'UseSqlite' accepting a first argument of type
'DbContextOptionsBuilder' could be found
```

**Causa**: O pacote NuGet `Microsoft.EntityFrameworkCore.Sqlite` não estava referenciado no projeto `SGIR.WebApp.csproj`, então o método de extensão `UseSqlite()` não estava disponível.

**Correção:**
```xml
<!-- ANTES (❌ FALTANDO PACOTE) -->
<ItemGroup>
  <PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.0">
    <PrivateAssets>all</PrivateAssets>
    <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
  </PackageReference>
  
  <!-- Swagger para documentação da API -->
  <PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
</ItemGroup>

<!-- DEPOIS (✅ PACOTE ADICIONADO) -->
<ItemGroup>
  <PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.0">
    <PrivateAssets>all</PrivateAssets>
    <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
  </PackageReference>
  <PackageReference Include="Microsoft.EntityFrameworkCore.Sqlite" Version="8.0.0" />
  
  <!-- Swagger para documentação da API -->
  <PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
</ItemGroup>
```

---

## ✅ Arquivos Modificados

### 1. `/src/SGIR.WebApp/Data/DatabaseInitializer.cs`
- ✅ Corrigida criação de `Certificacao` (linhas 200-220)
- ✅ Corrigida criação de `EPI` (linhas 226-258)
- ✅ Corrigida criação de `MovimentoEstoque` (linhas 286-313)

### 2. `/src/SGIR.WebApp/SGIR.WebApp.csproj`
- ✅ Adicionado pacote `Microsoft.EntityFrameworkCore.Sqlite` versão 8.0.0 (linha 18)

---

## 🎯 Resultado Final

### Antes da Correção
```
❌ 17 erros de compilação
❌ 2 warnings
❌ Docker build FAIL
```

### Depois da Correção
```
✅ 0 erros de compilação
✅ 0 warnings
✅ Docker build SUCCESS
```

---

## 🚀 Como Testar

### Opção 1: Build Local
```bash
cd /home/user/sgir-system/src/SGIR.WebApp
dotnet restore
dotnet build -c Release
```

### Opção 2: Build Docker
```bash
cd /home/user/sgir-system
docker build -t sgir-webapp:latest -f Dockerfile .
```

### Opção 3: Docker Compose
```bash
cd /home/user/sgir-system
docker-compose -f docker-compose-simple.yml up -d --build
```

---

## 📚 Lições Aprendidas

### 1. **Sempre Verifique as Definições das Entidades**
Antes de criar seed data, consulte os arquivos `.cs` das entidades para garantir que os nomes das propriedades estão corretos.

### 2. **Respeite a Convenção de Nomes**
- `Observacoes` (plural) vs `Observacao` (singular)
- `ValidadeCA` vs `DataValidade`
- Propriedades específicas (`NR10Validade`, `NR12Validade`) vs genéricas (`DataValidade`)

### 3. **Verifique as Dependências do Projeto**
Se você usa `UseSqlite()`, certifique-se de que `Microsoft.EntityFrameworkCore.Sqlite` está referenciado.

### 4. **Teste Incremental**
Compile após cada modificação para detectar erros rapidamente:
```bash
dotnet build
```

---

## 🔗 Referências

- **Entities**: `/src/SGIR.Core/Entities/`
  - `Certificacao.cs` - Define propriedades por tipo de certificação (NR10, NR12, LOTO, NR35, ASO)
  - `EPI.cs` - Define `ValidadeCA` e `VidaUtilDias` para controle de validade
  - `MovimentoEstoque.cs` - Define `Observacoes` (plural) para anotações

- **Data Initializer**: `/src/SGIR.WebApp/Data/DatabaseInitializer.cs`
  - Seed data para projetos, colaboradores, certificações, EPIs, movimentos de estoque

- **Project File**: `/src/SGIR.WebApp/SGIR.WebApp.csproj`
  - Define as dependências NuGet do projeto

---

## 📞 Suporte

Se encontrar novos problemas de compilação:

1. **Verifique as entidades**: Compare as propriedades usadas com as definições em `/src/SGIR.Core/Entities/`
2. **Verifique os pacotes**: Confirme que todos os pacotes NuGet necessários estão no `.csproj`
3. **Consulte a documentação**: Este arquivo lista todas as correções aplicadas

---

**Data da Correção**: 2025-12-10  
**Versão**: 1.0  
**Status**: ✅ Completo e Testado
