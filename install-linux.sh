#!/bin/bash
set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# Banner
clear
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🏗️  SGIR - Sistema de Gestão Integrada de Recursos      ║
║                                                              ║
║              Instalador Automático v1.0                     ║
║              Avanci Consultoria - 2025                       ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF

echo ""
print_info "Iniciando instalação..."
echo ""

# Verificar sudo
if [ "$EUID" -eq 0 ]; then 
    print_error "Não execute este script como root/sudo!"
    print_info "Execute: ./install-linux.sh"
    exit 1
fi

# Detectar sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    print_info "Sistema operacional: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    print_info "Sistema operacional: macOS"
else
    print_error "Sistema operacional não suportado: $OSTYPE"
    exit 1
fi

# Diretórios
INSTALL_DIR="$HOME/.local/share/sgir"
BIN_DIR="$HOME/.local/bin"

print_info "Diretório de instalação: $INSTALL_DIR"
echo ""

# ==============================================================================
# ETAPA 1: Verificar/Instalar .NET 8 SDK
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "ETAPA 1/4: Verificando .NET 8 SDK..."
echo ""

if command -v dotnet &> /dev/null; then
    DOTNET_VERSION=$(dotnet --version)
    if [[ "$DOTNET_VERSION" == 8.* ]]; then
        print_success ".NET 8 SDK já instalado (versão $DOTNET_VERSION)"
    else
        print_warning ".NET $DOTNET_VERSION encontrado, mas precisa da versão 8.x"
        print_info "Instalando .NET 8 SDK..."
        
        wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
        chmod +x /tmp/dotnet-install.sh
        /tmp/dotnet-install.sh --channel 8.0 --install-dir $HOME/.dotnet
        
        # Adicionar ao PATH
        export PATH="$HOME/.dotnet:$PATH"
        export DOTNET_ROOT=$HOME/.dotnet
        
        # Adicionar permanentemente ao .bashrc ou .zshrc
        if [ -f "$HOME/.bashrc" ]; then
            echo 'export PATH="$HOME/.dotnet:$PATH"' >> $HOME/.bashrc
            echo 'export DOTNET_ROOT=$HOME/.dotnet' >> $HOME/.bashrc
        fi
        
        if [ -f "$HOME/.zshrc" ]; then
            echo 'export PATH="$HOME/.dotnet:$PATH"' >> $HOME/.zshrc
            echo 'export DOTNET_ROOT=$HOME/.dotnet' >> $HOME/.zshrc
        fi
        
        rm /tmp/dotnet-install.sh
        print_success ".NET 8 SDK instalado!"
    fi
else
    print_warning ".NET 8 SDK não encontrado. Instalando..."
    
    wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
    chmod +x /tmp/dotnet-install.sh
    /tmp/dotnet-install.sh --channel 8.0 --install-dir $HOME/.dotnet
    
    export PATH="$HOME/.dotnet:$PATH"
    export DOTNET_ROOT=$HOME/.dotnet
    
    if [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/.dotnet:$PATH"' >> $HOME/.bashrc
        echo 'export DOTNET_ROOT=$HOME/.dotnet' >> $HOME/.bashrc
    fi
    
    if [ -f "$HOME/.zshrc" ]; then
        echo 'export PATH="$HOME/.dotnet:$PATH"' >> $HOME/.zshrc
        echo 'export DOTNET_ROOT=$HOME/.dotnet' >> $HOME/.zshrc
    fi
    
    rm /tmp/dotnet-install.sh
    print_success ".NET 8 SDK instalado!"
fi

echo ""

# ==============================================================================
# ETAPA 2: Verificar Docker (para SQL Server no Linux/Mac)
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "ETAPA 2/4: Verificando Docker..."
echo ""

if command -v docker &> /dev/null; then
    print_success "Docker já instalado"
    
    # Verificar se SQL Server container já existe
    if docker ps -a | grep -q sgir-sqlserver; then
        print_info "Container SQL Server já existe. Reiniciando..."
        docker start sgir-sqlserver
    else
        print_info "Criando container SQL Server..."
        docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=SGIR_Pass123!" \
          -p 1433:1433 --name sgir-sqlserver \
          -d mcr.microsoft.com/mssql/server:2022-latest
        
        print_success "SQL Server rodando no Docker (porta 1433)"
        print_warning "Senha do SA: SGIR_Pass123!"
    fi
else
    print_warning "Docker não encontrado!"
    print_info "Por favor, instale o Docker:"
    
    if [[ "$OS" == "linux" ]]; then
        echo "   Ubuntu/Debian: sudo apt install docker.io"
        echo "   Fedora/RHEL: sudo dnf install docker"
    else
        echo "   macOS: brew install --cask docker"
        echo "   OU baixe em: https://www.docker.com/products/docker-desktop"
    fi
    
    echo ""
    read -p "Deseja continuar sem SQL Server? (O sistema usará SQLite temporariamente) [s/N]: " continue_without_sql
    
    if [[ ! "$continue_without_sql" =~ ^[Ss]$ ]]; then
        print_error "Instalação cancelada. Instale o Docker e execute novamente."
        exit 1
    fi
    
    print_warning "Continuando com SQLite (apenas para testes)..."
fi

echo ""

# ==============================================================================
# ETAPA 3: Clonar/Baixar código do SGIR
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "ETAPA 3/4: Baixando código do SGIR..."
echo ""

if [ -d "$INSTALL_DIR" ]; then
    print_warning "Diretório já existe. Removendo versão anterior..."
    rm -rf "$INSTALL_DIR"
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

if command -v git &> /dev/null; then
    print_info "Clonando repositório..."
    git clone https://github.com/AvanciConsultoria/sgir-system.git "$INSTALL_DIR"
    print_success "Código clonado com sucesso!"
else
    print_info "Git não encontrado. Baixando ZIP..."
    wget https://github.com/AvanciConsultoria/sgir-system/archive/refs/heads/main.zip -O /tmp/sgir-main.zip
    unzip -q /tmp/sgir-main.zip -d /tmp/
    mv /tmp/sgir-system-main/* "$INSTALL_DIR/"
    rm -rf /tmp/sgir-main.zip /tmp/sgir-system-main
    print_success "Código baixado e extraído!"
fi

echo ""

# ==============================================================================
# ETAPA 4: Configurar e compilar aplicação
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "ETAPA 4/4: Configurando e compilando aplicação..."
echo ""

cd "$INSTALL_DIR/src/SGIR.WebApp"

# Ajustar connection string para Docker
if command -v docker &> /dev/null && docker ps | grep -q sgir-sqlserver; then
    print_info "Configurando conexão com SQL Server (Docker)..."
    sed -i.bak 's|Server=(localdb).*|Server=localhost,1433;Database=SGIR_DB;User Id=sa;Password=SGIR_Pass123!;TrustServerCertificate=true;MultipleActiveResultSets=true"|' appsettings.json
fi

# Restaurar dependências
print_info "Restaurando pacotes NuGet..."
dotnet restore --verbosity quiet

# Compilar
print_info "Compilando aplicação..."
dotnet build --configuration Release --verbosity quiet --no-restore

# Criar banco de dados
if command -v docker &> /dev/null && docker ps | grep -q sgir-sqlserver; then
    print_info "Criando banco de dados..."
    sleep 5  # Aguardar SQL Server iniciar
    dotnet ef database update --project ../SGIR.Infrastructure --no-build 2>/dev/null || print_warning "Banco será criado na primeira execução"
fi

# Publicar
print_info "Publicando aplicação..."
dotnet publish --configuration Release --output "$INSTALL_DIR/app" --verbosity quiet --no-build

print_success "Aplicação compilada e publicada!"
echo ""

# Criar script de inicialização
cat > "$BIN_DIR/sgir" << 'EOFSCRIPT'
#!/bin/bash

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          SGIR - Sistema de Gestão Integrada de Recursos      ║"
echo "║                     Iniciando sistema...                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se SQL Server está rodando
if command -v docker &> /dev/null; then
    if ! docker ps | grep -q sgir-sqlserver; then
        echo "⚠️  Iniciando SQL Server..."
        docker start sgir-sqlserver
        sleep 3
    fi
fi

cd "$HOME/.local/share/sgir/app"

# Abrir navegador (se disponível)
if command -v xdg-open &> /dev/null; then
    sleep 2 && xdg-open "https://localhost:7001" &
elif command -v open &> /dev/null; then
    sleep 2 && open "https://localhost:7001" &
fi

# Iniciar aplicação
dotnet SGIR.WebApp.dll
EOFSCRIPT

chmod +x "$BIN_DIR/sgir"

# Adicionar BIN_DIR ao PATH se necessário
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    if [ -f "$HOME/.bashrc" ]; then
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> $HOME/.bashrc
    fi
    if [ -f "$HOME/.zshrc" ]; then
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> $HOME/.zshrc
    fi
    export PATH="$BIN_DIR:$PATH"
fi

# Criar atalho desktop (Linux)
if [[ "$OS" == "linux" ]] && [ -d "$HOME/.local/share/applications" ]; then
    cat > "$HOME/.local/share/applications/sgir.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=SGIR - Sistema
Comment=Sistema de Gestão Integrada de Recursos
Exec=$BIN_DIR/sgir
Icon=applications-engineering
Terminal=true
Categories=Office;ProjectManagement;
EOF
    
    print_success "Atalho criado no menu de aplicativos"
fi

# ==============================================================================
# CONCLUSÃO
# ==============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║              ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

print_success "SGIR instalado em: $INSTALL_DIR"
echo ""

print_info "Para iniciar o sistema:"
echo -e "   ${YELLOW}sgir${NC}"
echo ""
echo "   OU execute:"
echo -e "   ${YELLOW}$BIN_DIR/sgir${NC}"
echo ""

if [[ "$OS" == "linux" ]]; then
    echo "   OU procure por 'SGIR' no menu de aplicativos"
    echo ""
fi

print_info "O navegador abrirá automaticamente em https://localhost:7001"
echo ""

print_info "Desinstalar:"
echo "   rm -rf $INSTALL_DIR"
echo "   rm -f $BIN_DIR/sgir"
if command -v docker &> /dev/null; then
    echo "   docker stop sgir-sqlserver && docker rm sgir-sqlserver"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Deseja iniciar o SGIR agora? [s/N]: " start_now

if [[ "$start_now" =~ ^[Ss]$ ]]; then
    print_info "Iniciando SGIR..."
    exec "$BIN_DIR/sgir"
else
    print_info "Execute 'sgir' no terminal quando quiser iniciar."
fi

echo ""
print_success "Instalação finalizada!"
echo ""
