# 🛠️ Guia de Solução de Problemas - Windows

## 📋 Sumário
- [Problema: PowerShell não executa scripts](#problema-powershell-não-executa-scripts)
- [Problema: Docker build falha](#problema-docker-build-falha)
- [Problema: SQL Server não conecta](#problema-sql-server-não-conecta)
- [Problema: Porta 5000 já em uso](#problema-porta-5000-já-em-uso)

---

## 🚫 Problema: PowerShell não executa scripts

### Erro comum:
```
install-windows.ps1 cannot be loaded because running scripts is disabled on this system
```

### ✅ Solução 1: Executar como Administrador (RECOMENDADO)

1. **Abra PowerShell como Administrador:**
   - Pressione `Win + X`
   - Clique em "Windows PowerShell (Admin)" ou "Terminal (Admin)"

2. **Libere a execução temporariamente:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

3. **Execute o instalador:**
```powershell
cd C:\caminho\para\sgir-system
.\install-windows.ps1
```

### ✅ Solução 2: Executar com bypass direto

```powershell
powershell -ExecutionPolicy Bypass -File .\install-windows.ps1
```

### ✅ Solução 3: Alterar política permanentemente (menos seguro)

```powershell
# Como Administrador
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🐋 Problema: Docker build falha

### Erro: "No .NET SDKs were found"

**Status:** ✅ **CORRIGIDO** na versão mais recente!

Se você ainda encontrar este erro:

1. **Atualize o repositório:**
```bash
cd sgir-system
git pull origin main
```

2. **Limpe cache do Docker:**
```bash
docker-compose down -v
docker system prune -a -f
```

3. **Rebuilde do zero:**
```bash
docker-compose up -d --build --force-recreate
```

### Erro: "Cannot connect to the Docker daemon"

**Causa:** Docker Desktop não está rodando

**Solução:**
1. Abra o Docker Desktop
2. Aguarde o ícone da baleia ficar verde
3. Execute novamente: `docker-compose up -d`

### Erro: Build muito lento

**Causa:** Primeira build baixa muitas imagens

**Solução:**
- É normal! Pode levar 10-15 minutos na primeira vez
- Builds subsequentes serão muito mais rápidas (1-2 min)

---

## 🗄️ Problema: SQL Server não conecta

### Erro: "A connection was successfully established..."

**Causa:** SQL Server ainda está inicializando

**Solução:**
```bash
# Verifique logs do SQL Server
docker-compose logs sqlserver

# Aguarde aparecer: "SQL Server is now ready for client connections"
```

### Erro: "Login failed for user 'sa'"

**Causa:** Senha incorreta ou SQL Server não aceitou a senha

**Solução:**

1. **Recrie o container:**
```bash
docker-compose down -v
docker-compose up -d
```

2. **Verifique a senha no docker-compose.yml:**
```yaml
MSSQL_SA_PASSWORD=SGIR_Pass123!
```

3. **Teste a conexão manualmente:**
```bash
docker exec -it sgir-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'SGIR_Pass123!' -Q "SELECT 1"
```

---

## 🔌 Problema: Porta 5000 já em uso

### Erro: "bind: address already in use"

**Causa:** Outro processo está usando a porta 5000

### ✅ Solução 1: Mudar a porta no docker-compose.yml

```yaml
services:
  webapp:
    ports:
      - "8080:80"  # Mudou de 5000 para 8080
      - "8443:443"
```

Depois acesse: `http://localhost:8080`

### ✅ Solução 2: Descobrir e matar o processo

**PowerShell (Administrador):**
```powershell
# Encontre o processo
netstat -ano | findstr :5000

# Mate o processo (substitua PID pelo número encontrado)
taskkill /PID 1234 /F
```

---

## 🔧 Comandos Úteis de Diagnóstico

### Verificar status dos containers
```bash
docker-compose ps
```

### Ver logs em tempo real
```bash
# Todos os serviços
docker-compose logs -f

# Apenas WebApp
docker-compose logs -f webapp

# Apenas SQL Server
docker-compose logs -f sqlserver
```

### Reiniciar serviços
```bash
# Reiniciar tudo
docker-compose restart

# Reiniciar apenas WebApp
docker-compose restart webapp
```

### Reconstruir do zero (solução definitiva)
```bash
# ATENÇÃO: Apaga TODOS os dados!
docker-compose down -v
docker system prune -a -f
git pull origin main
docker-compose up -d --build
```

---

## 📞 Suporte Adicional

Se nenhuma solução funcionou:

1. **Verifique requisitos:**
   - Windows 10 build 19041+ ou Windows 11
   - WSL2 instalado (`wsl --install`)
   - Docker Desktop 4.0+
   - 8GB RAM disponível

2. **Colete informações:**
```bash
# Versões
docker --version
docker-compose --version
wsl --version

# Logs completos
docker-compose logs > sgir-logs.txt
```

3. **Crie uma issue no GitHub:**
   - Repositório: https://github.com/AvanciConsultoria/sgir-system
   - Anexe `sgir-logs.txt`
   - Descreva o erro e passos tentados

---

## ✅ Instalação Funcionou?

Acesse: **http://localhost:5000**

Você deve ver o Dashboard do SGIR com:
- 📊 Cards de resumo
- 🚨 Alertas visuais
- ⚡ Ações rápidas
- 📈 Gráficos interativos

**Próximos passos:**
1. [Importar planilha Excel](docs/COMO_IMPORTAR_EXCEL.md)
2. [Cadastrar colaboradores](docs/CADASTRO_COLABORADORES.md)
3. [Configurar projetos](docs/GESTAO_PROJETOS.md)

---

**Atualizado:** 2025-12-10  
**Versão:** 1.0.1  
**Sistema:** SGIR - Sistema de Gestão Integrada de Recursos
