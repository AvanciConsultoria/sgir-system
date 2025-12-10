# 🧪 Script de teste rápido - SGIR Docker (Windows)
# Valida se a instalação Docker está funcionando corretamente

$ErrorActionPreference = "Stop"

Write-Host "🧪 ==================================================" -ForegroundColor Cyan
Write-Host "   SGIR - Teste de Instalação Docker" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Funções auxiliares
function Success {
    param($Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Error {
    param($Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Warning {
    param($Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Info {
    param($Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Gray
}

# 1. Verificar Docker
Info "Verificando Docker..."
try {
    $dockerVersion = docker --version
    Success "Docker encontrado: $dockerVersion"
} catch {
    Error "Docker não encontrado! Instale Docker Desktop primeiro."
    Write-Host "   Download: https://www.docker.com/products/docker-desktop"
    exit 1
}

# 2. Verificar Docker Compose
Info "Verificando Docker Compose..."
try {
    $composeVersion = docker-compose --version
    Success "Docker Compose encontrado: $composeVersion"
} catch {
    Error "Docker Compose não encontrado!"
    exit 1
}

# 3. Verificar se Docker está rodando
Info "Verificando se Docker está rodando..."
try {
    docker info | Out-Null
    Success "Docker está rodando"
} catch {
    Error "Docker não está rodando! Inicie Docker Desktop."
    Write-Host "   1. Abra o Docker Desktop"
    Write-Host "   2. Aguarde o ícone da baleia ficar verde"
    Write-Host "   3. Execute este script novamente"
    exit 1
}

# 4. Verificar arquivos necessários
Info "Verificando arquivos necessários..."
if (-not (Test-Path "docker-compose.yml")) {
    Error "docker-compose.yml não encontrado!"
    Write-Host "   Certifique-se de estar no diretório correto: sgir-system"
    exit 1
}
Success "docker-compose.yml encontrado"

if (-not (Test-Path "Dockerfile")) {
    Error "Dockerfile não encontrado!"
    exit 1
}
Success "Dockerfile encontrado"

# 5. Verificar estrutura do projeto
Info "Verificando estrutura do projeto..."
if (-not (Test-Path "src")) {
    Error "Diretório 'src' não encontrado!"
    exit 1
}
Success "Estrutura do projeto OK"

# 6. Verificar portas disponíveis
Info "Verificando disponibilidade de portas..."

$port5000 = Get-NetTCPConnection -LocalPort 5000 -State Listen -ErrorAction SilentlyContinue
if ($port5000) {
    Warning "Porta 5000 já está em uso!"
    Write-Host "   Solução 1: Mude a porta no docker-compose.yml"
    Write-Host "   Solução 2: Mate o processo com: taskkill /PID $($port5000.OwningProcess) /F"
} else {
    Success "Porta 5000 disponível"
}

$port1433 = Get-NetTCPConnection -LocalPort 1433 -State Listen -ErrorAction SilentlyContinue
if ($port1433) {
    Warning "Porta 1433 já está em uso!"
    Write-Host "   SQL Server local pode estar rodando"
    Write-Host "   Solução: Mude a porta no docker-compose.yml para 1434:1433"
} else {
    Success "Porta 1433 disponível"
}

# 7. Verificar memória disponível
Info "Verificando recursos do sistema..."
$computerInfo = Get-ComputerInfo
$totalRAM = [math]::Round($computerInfo.CsTotalPhysicalMemory / 1GB, 2)
$freeRAM = [math]::Round($computerInfo.CsPhysFreePhysicalMemory / 1MB, 2)

Write-Host "   RAM Total: $totalRAM GB"
Write-Host "   RAM Livre: $freeRAM MB"

if ($totalRAM -lt 8) {
    Warning "Recomendado: 8GB+ de RAM (você tem $totalRAM GB)"
} else {
    Success "RAM suficiente: $totalRAM GB"
}

# 8. Teste de build (opcional)
Write-Host ""
$response = Read-Host "🔨 Deseja testar o build agora? (s/N)"
if ($response -eq "s" -or $response -eq "S") {
    Info "Iniciando build de teste (pode demorar 5-15 min na primeira vez)..."
    Write-Host ""
    
    # Limpar containers antigos
    Info "Limpando containers antigos..."
    docker-compose down -v 2>$null
    
    # Build
    Info "Building imagens..."
    Write-Host "   (Isto pode demorar... aguarde)" -ForegroundColor Yellow
    try {
        docker-compose build --no-cache
        Success "Build concluído com sucesso!"
    } catch {
        Error "Build falhou! Veja os logs acima."
        Write-Host ""
        Write-Host "📖 Consulte: TROUBLESHOOTING_WINDOWS.md"
        exit 1
    }
    
    # Start
    Info "Iniciando containers..."
    try {
        docker-compose up -d
        Success "Containers iniciados!"
    } catch {
        Error "Falha ao iniciar containers!"
        exit 1
    }
    
    # Aguardar inicialização
    Info "Aguardando inicialização..."
    for ($i = 30; $i -gt 0; $i--) {
        Write-Host "`r   ⏳ $i segundos restantes..." -NoNewline
        Start-Sleep -Seconds 1
    }
    Write-Host ""
    
    # Verificar containers
    Info "Verificando status dos containers..."
    docker-compose ps
    
    # Verificar logs
    Write-Host ""
    Info "Últimas linhas dos logs:"
    docker-compose logs --tail=20
    
    # Teste de conexão
    Write-Host ""
    Info "Testando conexão HTTP..."
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Success "SGIR está respondendo em http://localhost:5000"
            Write-Host ""
            Write-Host "🎉 ==================================================" -ForegroundColor Green
            Write-Host "   INSTALAÇÃO BEM-SUCEDIDA!" -ForegroundColor Green
            Write-Host "==================================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "📊 Acesse o Dashboard:" -ForegroundColor Cyan
            Write-Host "   👉 http://localhost:5000" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "📝 Comandos úteis:" -ForegroundColor Cyan
            Write-Host "   Ver logs:      docker-compose logs -f"
            Write-Host "   Parar:         docker-compose down"
            Write-Host "   Reiniciar:     docker-compose restart"
            Write-Host ""
            
            # Abrir navegador
            $openBrowser = Read-Host "Deseja abrir o navegador agora? (S/n)"
            if ($openBrowser -ne "n" -and $openBrowser -ne "N") {
                Start-Process "http://localhost:5000"
            }
        }
    } catch {
        Warning "SGIR não está respondendo ainda"
        Write-Host "   Aguarde mais alguns segundos e acesse: http://localhost:5000"
        Write-Host "   Ou verifique os logs: docker-compose logs -f webapp"
    }
} else {
    Write-Host ""
    Success "Pré-requisitos verificados!"
    Write-Host ""
    Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
    Write-Host "   1. Execute: docker-compose up -d --build"
    Write-Host "   2. Aguarde 2-5 minutos"
    Write-Host "   3. Acesse: http://localhost:5000"
    Write-Host ""
    Write-Host "📖 Problemas? Veja: TROUBLESHOOTING_WINDOWS.md"
}

Write-Host ""
Write-Host "✨ Teste concluído!" -ForegroundColor Green
