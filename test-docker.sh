#!/bin/bash
# 🧪 Script de teste rápido - SGIR Docker
# Valida se a instalação Docker está funcionando corretamente

set -e

echo "🧪 =================================================="
echo "   SGIR - Teste de Instalação Docker"
echo "=================================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funções auxiliares
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

info() {
    echo "ℹ️  $1"
}

# 1. Verificar Docker
info "Verificando Docker..."
if ! command -v docker &> /dev/null; then
    error "Docker não encontrado! Instale Docker Desktop primeiro."
    echo "   Download: https://www.docker.com/products/docker-desktop"
    exit 1
fi
success "Docker encontrado: $(docker --version)"

# 2. Verificar Docker Compose
info "Verificando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    error "Docker Compose não encontrado!"
    exit 1
fi
success "Docker Compose encontrado: $(docker-compose --version)"

# 3. Verificar se Docker está rodando
info "Verificando se Docker está rodando..."
if ! docker info &> /dev/null; then
    error "Docker não está rodando! Inicie Docker Desktop."
    exit 1
fi
success "Docker está rodando"

# 4. Verificar arquivos necessários
info "Verificando arquivos necessários..."
if [ ! -f "docker-compose.yml" ]; then
    error "docker-compose.yml não encontrado!"
    exit 1
fi
success "docker-compose.yml encontrado"

if [ ! -f "Dockerfile" ]; then
    error "Dockerfile não encontrado!"
    exit 1
fi
success "Dockerfile encontrado"

# 5. Verificar estrutura do projeto
info "Verificando estrutura do projeto..."
if [ ! -d "src" ]; then
    error "Diretório 'src' não encontrado!"
    exit 1
fi
success "Estrutura do projeto OK"

# 6. Verificar portas disponíveis
info "Verificando disponibilidade de portas..."
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 || netstat -ano | grep ":5000" >/dev/null 2>&1; then
    warning "Porta 5000 já está em uso!"
    echo "   Solução: Mude a porta no docker-compose.yml ou mate o processo"
else
    success "Porta 5000 disponível"
fi

if lsof -Pi :1433 -sTCP:LISTEN -t >/dev/null 2>&1 || netstat -ano | grep ":1433" >/dev/null 2>&1; then
    warning "Porta 1433 já está em uso!"
    echo "   Solução: Mude a porta do SQL Server no docker-compose.yml"
else
    success "Porta 1433 disponível"
fi

# 7. Teste de build (opcional)
echo ""
read -p "🔨 Deseja testar o build agora? (s/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    info "Iniciando build de teste (pode demorar 5-15 min na primeira vez)..."
    
    # Limpar containers antigos
    info "Limpando containers antigos..."
    docker-compose down -v 2>/dev/null || true
    
    # Build
    info "Building imagens..."
    if docker-compose build --no-cache; then
        success "Build concluído com sucesso!"
    else
        error "Build falhou! Veja os logs acima."
        exit 1
    fi
    
    # Start
    info "Iniciando containers..."
    if docker-compose up -d; then
        success "Containers iniciados!"
    else
        error "Falha ao iniciar containers!"
        exit 1
    fi
    
    # Aguardar inicialização
    info "Aguardando inicialização (30 segundos)..."
    sleep 30
    
    # Verificar containers
    info "Verificando status dos containers..."
    docker-compose ps
    
    # Verificar logs
    echo ""
    info "Últimas linhas dos logs:"
    docker-compose logs --tail=20
    
    # Teste de conexão
    echo ""
    info "Testando conexão HTTP..."
    if curl -f http://localhost:5000 >/dev/null 2>&1; then
        success "SGIR está respondendo em http://localhost:5000"
        echo ""
        echo "🎉 =================================================="
        echo "   INSTALAÇÃO BEM-SUCEDIDA!"
        echo "=================================================="
        echo ""
        echo "📊 Acesse o Dashboard:"
        echo "   👉 http://localhost:5000"
        echo ""
        echo "📝 Comandos úteis:"
        echo "   Ver logs:      docker-compose logs -f"
        echo "   Parar:         docker-compose down"
        echo "   Reiniciar:     docker-compose restart"
        echo ""
    else
        warning "SGIR não está respondendo ainda"
        echo "   Aguarde mais alguns segundos e tente: http://localhost:5000"
        echo "   Ou verifique os logs: docker-compose logs -f webapp"
    fi
else
    echo ""
    success "Pré-requisitos verificados!"
    echo ""
    echo "📋 Próximos passos:"
    echo "   1. Execute: docker-compose up -d --build"
    echo "   2. Aguarde 2-5 minutos"
    echo "   3. Acesse: http://localhost:5000"
    echo ""
    echo "📖 Problemas? Veja: TROUBLESHOOTING_WINDOWS.md"
fi

echo ""
echo "✨ Teste concluído!"
