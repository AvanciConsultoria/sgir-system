# 🚀 SGIR - Instalação em 3 Cliques

## 📌 **ESCOLHA SEU MÉTODO**

---

## 🪟 **WINDOWS (Recomendado)**

### **Método 1: Instalador Automático PowerShell** ⭐ MAIS FÁCIL

**1. Baixar o instalador:**
```
https://github.com/AvanciConsultoria/sgir-system/raw/main/install-windows.ps1
```

**2. Executar:**
- Clique com botão direito no arquivo `install-windows.ps1`
- Selecione: **"Executar com PowerShell"**
- Se aparecer aviso de segurança, clique em **"Sim"** ou **"Executar mesmo assim"**

⚠️ **Erro "scripts desabilitados"?** → Veja [TROUBLESHOOTING_WINDOWS.md](TROUBLESHOOTING_WINDOWS.md)

**3. O que o instalador faz automaticamente:** 🔄

**ETAPA 1/5:** Verificar e instalar .NET 8 SDK
- ✅ Detecta se .NET 8 já está instalado
- ✅ Baixa instalador oficial (se necessário)
- ✅ Instala silenciosamente

**ETAPA 2/5:** Verificar e instalar SQL Server LocalDB
- ✅ Detecta se LocalDB já está instalado
- ✅ Baixa instalador oficial (se necessário)
- ✅ Instala e inicializa automaticamente

**ETAPA 3/5:** Baixar código do SGIR
- ✅ Clona repositório Git (se Git instalado)
- ✅ OU baixa ZIP direto do GitHub
- ✅ Instala em `C:\Program Files\SGIR`

**ETAPA 4/5:** Compilar aplicação
- ✅ Restaura pacotes NuGet
- ✅ Compila em modo Release
- ✅ **Cria executável SELF-CONTAINED (SGIR.WebApp.exe)**
  - 🎯 **Single-file executable** (80-120 MB)
  - 🎯 **Não precisa de .NET instalado para rodar**
  - 🎯 **Inclui todas as dependências nativas**
- ✅ Cria banco de dados automaticamente

**ETAPA 5/5:** Criar atalhos e configurar sistema
- ✅ Cria atalho na Área de Trabalho
- ✅ Cria atalho no Menu Iniciar
- ✅ Cria script de desinstalação
- ✅ **Abre sistema automaticamente no navegador**

**4. Resultado Final:** 🎉
- ✅ Sistema totalmente instalado e configurado
- ✅ Atalho "SGIR - Sistema" na área de trabalho
- ✅ Executável único: `SGIR.WebApp.exe` (não precisa de .NET)
- ✅ Banco de dados criado e pronto
- ✅ Acesso via: `http://localhost:5000`

**5. Iniciar depois:**
- Clique no atalho **"SGIR - Sistema"** na área de trabalho
- OU execute: `C:\Program Files\SGIR\app\SGIR.WebApp.exe`

---

### **Método 2: Docker** (Se você já tem Docker Desktop)

**1. Baixar repositório:**
```powershell
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system
```

**2. Rodar:**
```powershell
docker-compose up -d
```

**3. Acessar:**
```
http://localhost:5000
```

---

## 🐧 **LINUX / 🍎 MAC**

### **Método 1: Instalador Automático Bash** ⭐ MAIS FÁCIL

**1. Baixar e executar:**
```bash
curl -fsSL https://raw.githubusercontent.com/AvanciConsultoria/sgir-system/main/install-linux.sh -o install-linux.sh
chmod +x install-linux.sh
./install-linux.sh
```

**2. Pronto!** ✅
- O instalador vai:
  - ✅ Instalar .NET 8
  - ✅ Criar container SQL Server (Docker)
  - ✅ Baixar o código do SGIR
  - ✅ Compilar e configurar tudo
  - ✅ Criar comando `sgir` no terminal

**3. Iniciar:**
```bash
sgir
```

---

### **Método 2: Docker** (Qualquer Sistema Operacional)

**Pré-requisito:** Docker instalado
- Windows: https://www.docker.com/products/docker-desktop
- Mac: `brew install --cask docker`
- Linux: `sudo apt install docker.io docker-compose`

**1. Baixar repositório:**
```bash
git clone https://github.com/AvanciConsultoria/sgir-system.git
cd sgir-system
```

**2. Rodar:**
```bash
docker-compose up -d
```

**3. Acessar:**
```
http://localhost:5000
```

**Parar:**
```bash
docker-compose down
```

---

## 📦 **MÉTODO 3: Instalador .EXE (WINDOWS - EM BREVE)**

🚧 **Em desenvolvimento!**

Será um instalador clássico `.exe` que você só precisa:
1. Baixar
2. Clicar duas vezes
3. Clicar em "Avançar, Avançar, Concluir"

---

## 🆘 **PROBLEMAS?**

### **Windows PowerShell: "Execução de scripts desabilitada"**

**Solução:**
1. Abrir PowerShell **como Administrador**
2. Executar:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
   ```
3. Executar o instalador novamente

---

### **Docker: "Cannot connect to Docker daemon"**

**Windows:**
- Abrir **Docker Desktop**
- Aguardar inicialização completa

**Linux:**
```bash
sudo systemctl start docker
sudo usermod -aG docker $USER
# Fazer logout e login novamente
```

**Mac:**
- Abrir aplicativo **Docker**
- Aguardar inicialização

---

### **Porta já em uso (5000 ou 1433)**

**Verificar o que está usando:**
- Windows: `netstat -ano | findstr :5000`
- Linux/Mac: `lsof -i :5000`

**Mudar porta do SGIR:**

Editar `docker-compose.yml`:
```yaml
ports:
  - "8080:80"  # Mudar 5000 para 8080
```

---

## 📊 **COMPARAÇÃO DOS MÉTODOS**

| Método | Facilidade | Tempo | Requisitos |
|--------|-----------|-------|------------|
| **PowerShell (Win)** | ⭐⭐⭐⭐⭐ | 5-10 min | Windows 10/11 |
| **Bash (Linux/Mac)** | ⭐⭐⭐⭐⭐ | 5-10 min | Docker |
| **Docker** | ⭐⭐⭐⭐ | 2-5 min | Docker instalado |
| **Manual** | ⭐⭐ | 15-30 min | .NET 8 + SQL Server |

---

## ✅ **VERIFICAR SE FUNCIONOU**

**1. Abrir navegador:**
```
http://localhost:5000
```

**2. Você deve ver:**
- Dashboard do SGIR
- Cards com estatísticas (todos em 0 - banco vazio)
- Menu lateral com opções

**3. Se ver isso:** ✅ **FUNCIONOU!**

---

## 🎯 **PRÓXIMOS PASSOS (Após Instalar)**

1. ✅ Cadastrar colaboradores
2. ✅ Cadastrar projetos
3. ✅ Importar planilha Excel
4. ✅ Rodar análise de déficit
5. ✅ Gerar pedidos de compra

---

## 📞 **SUPORTE**

**Problemas durante instalação?**

1. 📖 **Consulte os guias de troubleshooting:**
   - Windows: [TROUBLESHOOTING_WINDOWS.md](TROUBLESHOOTING_WINDOWS.md)
   - Docker: Veja logs com `docker-compose logs -f`

2. 💬 **Problemas comuns resolvidos:**
   - ✅ PowerShell não executa scripts
   - ✅ Docker build falha com "No .NET SDKs"
   - ✅ SQL Server não conecta
   - ✅ Porta 5000 já em uso

3. 📧 **Suporte direto:**
   - Tire print da tela do erro
   - Copie a mensagem completa
   - Entre em contato: favanci@hotmail.com

**Repositório:** https://github.com/AvanciConsultoria/sgir-system

---

## 🎉 **PARABÉNS!**

Você instalou o **SGIR - Sistema de Gestão Integrada de Recursos**!

**Desenvolvido para**: Avanci Consultoria  
**Versão**: 1.0  
**Data**: Dezembro 2025

