# 🔧 INSTALAÇÃO DO SQLite3 NO WINDOWS

---

## ⚠️ ERRO ENCONTRADO

```
ERRO: SQLite3 não encontrado!
Baixe em: https://www.sqlite.org/download.html
Ou instale via: winget install SQLite.SQLite
```

**Causa:** O executável `sqlite3.exe` não está instalado ou não está no PATH do Windows.

---

## ✅ SOLUÇÃO RÁPIDA (3 MÉTODOS)

### 🎯 MÉTODO 1: Winget (MAIS FÁCIL - 30 segundos) ⭐

**Requisitos:** Windows 10/11 com App Installer

```powershell
# 1. Abra PowerShell (não precisa ser Admin)
winget install SQLite.SQLite

# 2. FECHE e REABRA o PowerShell (importante!)

# 3. Teste a instalação
sqlite3 --version

# 4. Execute o script novamente
cd sgir-system\database
.\import-to-sqlite.ps1
```

**Vantagens:**
- ✅ Instalação automática
- ✅ Adiciona ao PATH automaticamente
- ✅ Não requer privilégios de Admin
- ✅ Atualizações automáticas

---

### 🎯 MÉTODO 2: Download Manual (5 minutos)

**Se o winget não funcionar ou não estiver disponível:**

#### Passo 1: Baixe o SQLite

1. Acesse: **https://www.sqlite.org/download.html**
2. Procure a seção: **"Precompiled Binaries for Windows"**
3. Baixe o arquivo:
   - Para 64-bit: `sqlite-tools-win-x64-*.zip`
   - Para 32-bit: `sqlite-tools-win32-x86-*.zip`

**Link direto (versão atual):**
https://www.sqlite.org/2024/sqlite-tools-win-x64-3450100.zip

#### Passo 2: Extraia os Arquivos

```powershell
# Exemplo: extrair para C:\sqlite
# 1. Crie a pasta
New-Item -ItemType Directory -Path "C:\sqlite" -Force

# 2. Extraia o ZIP baixado para C:\sqlite
# Você terá: C:\sqlite\sqlite3.exe
```

#### Passo 3: Adicione ao PATH (OPÇÃO A - Permanente)

```powershell
# Execute como Administrador
[Environment]::SetEnvironmentVariable(
    "Path",
    $env:Path + ";C:\sqlite",
    [EnvironmentVariableTarget]::Machine
)

# FECHE e REABRA o PowerShell

# Teste
sqlite3 --version
```

#### Passo 3: OU Copie para System32 (OPÇÃO B - Simples)

```powershell
# Execute como Administrador
Copy-Item "C:\sqlite\sqlite3.exe" "C:\Windows\System32\"

# Teste
sqlite3 --version
```

#### Passo 4: Execute o Script

```powershell
cd sgir-system\database
.\import-to-sqlite.ps1
```

---

### 🎯 MÉTODO 3: Sem Instalar SQLite (Alternativa .NET)

**Se NÃO PUDER instalar o sqlite3.exe**, use este método alternativo:

```powershell
cd sgir-system\database
.\import-via-dotnet-direct.ps1
```

Este script usa o próprio aplicativo .NET para importar (veja abaixo).

---

## 🚀 MÉTODO ALTERNATIVO: Importação via Aplicativo .NET

**Se você não conseguir instalar o SQLite3, use este método:**

### Passo 1: Execute o Aplicativo

```powershell
cd sgir-system\src\SGIR.WebApp
dotnet run
```

O aplicativo irá:
- ✅ Criar o banco de dados `sgir.db` automaticamente
- ✅ Aplicar migrations
- ✅ Executar seed data básico (50 itens)

### Passo 2: Acesse a Interface Web

```
http://localhost:5000
```

### Passo 3: Importe via Interface (Futuro)

Navegue para: **Ferramentas → Importar Excel**

(Funcionalidade de importação SQL via web será adicionada em breve)

---

## 🔧 VALIDAÇÃO DA INSTALAÇÃO

### Teste 1: Versão

```powershell
sqlite3 --version
```

**Saída esperada:**
```
3.45.1 2024-01-30 16:01:20 e876e51a0ed5c5b3126f52e532044363a014bc594cfefa87ffb5b82257cc467a
```

### Teste 2: Conexão ao Banco

```powershell
sqlite3 ..\src\SGIR.WebApp\Data\sgir.db "SELECT sqlite_version();"
```

**Saída esperada:**
```
3.45.1
```

### Teste 3: Contar Tabelas

```powershell
sqlite3 ..\src\SGIR.WebApp\Data\sgir.db ".tables"
```

**Saída esperada:**
```
Alocacoes_Pessoas    Colaboradores       EPIs               Projetos
Analises_Deficit     Compras_Automaticas Itens_Estoque      Recursos_Necessarios
Caixas_Ferramentas   Custos_Operacionais Movimentos_Estoque
Caixas_Itens         Carrinhos           Certificacoes
Carrinhos_Itens      
```

---

## 🛠️ TROUBLESHOOTING

### Erro: "winget: command not found"

**Causa:** Windows 10 antigo ou App Installer não instalado.

**Solução:**
1. Atualize o Windows 10 para a última versão
2. Ou instale: **Microsoft App Installer** da Windows Store
3. Ou use o Método 2 (Download Manual)

---

### Erro: "sqlite3: command not found" (após instalação)

**Causa:** PowerShell não recarregou as variáveis de ambiente.

**Solução:**
```powershell
# Feche TODAS as janelas do PowerShell
# Reabra uma nova janela
# Teste novamente
sqlite3 --version
```

---

### Erro: "Access Denied" ao copiar para System32

**Causa:** Sem permissões de Administrador.

**Solução:**
```powershell
# Clique com botão direito no PowerShell
# Selecione: "Executar como Administrador"
# Execute o comando novamente
Copy-Item "C:\sqlite\sqlite3.exe" "C:\Windows\System32\"
```

---

### Erro: PATH não atualiza

**Solução manual:**

1. Pressione `Win + Pause` (ou `Win + X` → Sistema)
2. Clique em: **Configurações avançadas do sistema**
3. Clique em: **Variáveis de Ambiente**
4. Em **Variáveis do sistema**, encontre `Path`
5. Clique em **Editar**
6. Clique em **Novo**
7. Adicione: `C:\sqlite`
8. Clique em **OK** em todas as janelas
9. **REINICIE o PowerShell**

---

## 📋 COMPARAÇÃO DOS MÉTODOS

| Método | Tempo | Dificuldade | Admin? | Permanente? |
|--------|-------|-------------|--------|-------------|
| **1. Winget** | 30s | Fácil | ❌ Não | ✅ Sim |
| **2. Download + PATH** | 5min | Média | ✅ Sim | ✅ Sim |
| **2. Download + System32** | 3min | Média | ✅ Sim | ✅ Sim |
| **3. Via .NET** | 1min | Fácil | ❌ Não | ❌ Não |

**Recomendação:** Use o **Método 1 (winget)** se possível.

---

## 🎯 PRÓXIMOS PASSOS APÓS INSTALAÇÃO

### 1. Verifique a Instalação

```powershell
sqlite3 --version
```

### 2. Execute o Script de Importação

```powershell
cd sgir-system\database
.\import-to-sqlite.ps1
```

### 3. Aguarde o Sucesso

```
===================================
IMPORTAÇÃO CONCLUÍDA COM SUCESSO!
===================================

Total de ferramentas no banco: 117
```

### 4. Execute o Aplicativo

```powershell
cd ..\src\SGIR.WebApp
dotnet run
```

### 5. Acesse a Interface

```
http://localhost:5000
```

### 6. Navegue para Ferramentas

**Estoque → Ferramentas**

Você verá os **117 itens profissionais** importados!

---

## 📖 LINKS ÚTEIS

### Downloads
- **SQLite Download:** https://www.sqlite.org/download.html
- **SQLite Windows:** https://www.sqlite.org/2024/sqlite-tools-win-x64-3450100.zip
- **App Installer:** https://apps.microsoft.com/store/detail/9NBLGGH4NNS1

### Documentação
- **SQLite Docs:** https://www.sqlite.org/docs.html
- **Winget Docs:** https://learn.microsoft.com/en-us/windows/package-manager/winget/

### Repositório SGIR
- **GitHub:** https://github.com/AvanciConsultoria/sgir-system
- **Branch:** main
- **Docs:** `IMPORTACAO_DADOS_WINDOWS.md`

---

## 🆘 AINDA COM PROBLEMAS?

### Opção 1: Use o Aplicativo Diretamente

```powershell
cd sgir-system\src\SGIR.WebApp
dotnet run
```

O banco de dados será criado automaticamente com seed data básico.

### Opção 2: Peça Ajuda

Abra uma **Issue** no GitHub:
https://github.com/AvanciConsultoria/sgir-system/issues

Inclua:
- Versão do Windows (`winver`)
- Erro completo
- Comando executado
- Print da tela

---

## ✅ CHECKLIST FINAL

Após seguir este guia:

- [ ] SQLite3 instalado
- [ ] `sqlite3 --version` funciona
- [ ] PATH configurado (se necessário)
- [ ] Script `import-to-sqlite.ps1` executado com sucesso
- [ ] Banco de dados contém 117 itens
- [ ] Aplicativo .NET rodando
- [ ] Interface acessível em http://localhost:5000
- [ ] Página Ferramentas mostrando os itens

---

## 🎉 SUCESSO!

Após seguir este guia, você terá:

- ✅ SQLite3 instalado no Windows
- ✅ 117 itens profissionais no banco de dados
- ✅ Sistema SGIR funcionando perfeitamente
- ✅ Interface visual moderna acessível

**Tempo total:** 2-5 minutos (dependendo do método)

**🚀 Aproveite o sistema!**
