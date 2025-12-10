# 🚀 COMO INSTALAR O SGIR AGORA (VERSÃO CORRIGIDA)

## ⚠️ **ATENÇÃO: USE ESTE MÉTODO PARA EVITAR PROBLEMAS**

Se você já tentou instalar antes e deu erro, **siga este guia**.

---

## 🪟 **WINDOWS - INSTALAÇÃO DEFINITIVA**

### **Método 1: Script Automático (RECOMENDADO)** ⭐

```powershell
# 1. Abra PowerShell (não precisa ser Admin)
cd C:\Users\Admin

# 2. Se já existe, remova a pasta antiga
Remove-Item -Path "sgir-system" -Recurse -Force -ErrorAction SilentlyContinue

# 3. Clone novamente (versão corrigida)
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system

# 4. Execute o instalador LIMPO
.\install-docker-clean.ps1
```

**O que este script faz:**
- ✅ Remove cache antigo do Docker
- ✅ Baixa código mais recente do GitHub
- ✅ Build completo do zero (sem cache)
- ✅ Inicia containers
- ✅ Testa conexão
- ✅ Abre navegador automaticamente

**Tempo:** 5-15 minutos

---

### **Método 2: Manual (Se o script não funcionar)**

```powershell
# 1. Limpe tudo primeiro
cd C:\Users\Admin
Remove-Item -Path "sgir-system" -Recurse -Force -ErrorAction SilentlyContinue
docker system prune -a -f

# 2. Clone NOVAMENTE (versão corrigida está no GitHub)
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system

# 3. Verifique se pegou a versão correta
git log -1 --oneline
# Deve mostrar: "FIX CRÍTICO: Adiciona _Imports.razor"

# 4. Build SEM CACHE (importante!)
docker-compose build --no-cache

# 5. Inicie
docker-compose up -d

# 6. Aguarde 30 segundos
Start-Sleep -Seconds 30

# 7. Acesse
Start-Process "http://localhost:5000"
```

---

## 🔍 **COMO SABER SE FUNCIONOU**

### **Verifique os logs:**
```powershell
docker-compose logs -f
```

**Deve mostrar:**
```
sqlserver    | SQL Server is now ready for client connections
webapp       | === SGIR System - Starting ===
webapp       | SQL Server is ready!
webapp       | Starting SGIR WebApp...
webapp       | Now listening on: http://[::]:80
```

### **Verifique o status:**
```powershell
docker-compose ps
```

**Deve mostrar:**
```
NAME              STATUS
sgir-sqlserver    Up (healthy)
sgir-webapp       Up
```

### **Acesse no navegador:**
```
http://localhost:5000
```

**Deve aparecer:**
- ✅ Dashboard do SGIR
- ✅ Cards de resumo
- ✅ Menu lateral
- ✅ Interface Blazor funcionando

---

## 🐛 **O QUE FOI CORRIGIDO**

### **Versão Anterior (COM ERROS):**
- ❌ Atributos `[Column]` duplicados
- ❌ Arquivo `_Imports.razor` faltando
- ❌ Build falhava com CS0579, CS0103, RZ10012

### **Versão Atual (CORRIGIDA):**
- ✅ Atributos `[Column]` combinados corretamente
- ✅ Arquivo `_Imports.razor` criado
- ✅ Build passa 100%
- ✅ Blazor compila sem erros

---

## 💡 **POR QUE PRECISO LIMPAR O CACHE?**

**Docker usa cache de builds anteriores.**

Se você tentou instalar antes:
- ❌ Docker guardou a versão **COM ERRO** no cache
- ❌ Mesmo baixando código novo, Docker usa cache velho
- ❌ Build continua falhando

**Solução:**
- ✅ `docker-compose build --no-cache` força build do zero
- ✅ `docker system prune -a -f` limpa cache antigo
- ✅ `git reset --hard origin/main` garante código mais recente

---

## 🆘 **AINDA ESTÁ DANDO ERRO?**

### **1. Verifique se pegou a versão mais recente:**
```powershell
cd C:\Users\Admin\sgir-system
git log -1 --pretty=format:"%h - %s"
```

**Deve mostrar:**
```
c4bed22 - 🐛 FIX CRÍTICO: Adiciona _Imports.razor faltante
```

Se não mostrar, faça:
```powershell
git fetch origin main
git reset --hard origin/main
```

### **2. Verifique se o arquivo _Imports.razor existe:**
```powershell
Test-Path "src\SGIR.WebApp\_Imports.razor"
```

**Deve retornar:** `True`

### **3. Limpe TUDO e tente novamente:**
```powershell
# Remove containers
docker-compose down -v

# Remove imagens
docker rmi $(docker images -q sgir*)

# Remove cache
docker system prune -a -f

# Reinstale
docker-compose build --no-cache
docker-compose up -d
```

### **4. Copie e cole o erro completo aqui:**
Se ainda não funcionar:
1. Execute: `docker-compose logs > erro.txt`
2. Abra `erro.txt`
3. Copie e cole o conteúdo completo

---

## 📊 **RESUMO DO PROCESSO**

```
1. LIMPAR   → Remove cache antigo
2. CLONAR   → Pega código corrigido
3. BUILD    → Compila sem cache
4. UP       → Inicia containers
5. TESTAR   → Acessa localhost:5000
```

**IMPORTANTE:** Não pule o passo de **LIMPAR**!

---

## ✅ **GARANTIA**

Esta versão foi testada e **FUNCIONA**.

Erros corrigidos:
- ✅ CS0579 (Duplicate Column)
- ✅ CS0103 (routeData not found)
- ✅ CS0246 (MainLayout not found)
- ✅ RZ10012 (Component not recognized)

**Se seguir este guia, VAI FUNCIONAR! 🎉**

---

## 📞 **SUPORTE**

**Documentação:**
- [INSTALACAO_FACIL.md](INSTALACAO_FACIL.md)
- [TROUBLESHOOTING_WINDOWS.md](TROUBLESHOOTING_WINDOWS.md)

**Contato:** favanci@hotmail.com

**Repositório:** https://github.com/AvanciConsultoria/sgir-system

---

**Última atualização:** 2025-12-10  
**Versão:** 1.0.2 (COM CORREÇÕES)
