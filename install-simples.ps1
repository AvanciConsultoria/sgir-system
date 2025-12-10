# SGIR - Instalacao Simples
# Script minimalista sem caracteres especiais

Write-Host "================================================"
Write-Host "SGIR - Instalacao Docker"
Write-Host "================================================"
Write-Host ""

# Limpar cache
Write-Host "1/5 Limpando cache do Docker..."
docker-compose down -v 2>$null
docker system prune -a -f 2>$null

# Atualizar codigo
Write-Host ""
Write-Host "2/5 Atualizando codigo do GitHub..."
git fetch origin main 2>$null
git reset --hard origin/main 2>$null

# Build
Write-Host ""
Write-Host "3/5 Compilando (5-15 minutos, aguarde)..."
docker-compose build --no-cache

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERRO: Build falhou!"
    Write-Host "Verifique os logs acima"
    exit 1
}

# Iniciar
Write-Host ""
Write-Host "4/5 Iniciando containers..."
docker-compose up -d

# Aguardar
Write-Host ""
Write-Host "5/5 Aguardando inicializacao (30 segundos)..."
Start-Sleep -Seconds 30

# Status
Write-Host ""
Write-Host "Status dos containers:"
docker-compose ps

# Teste
Write-Host ""
Write-Host "Testando conexao..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 10 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host ""
        Write-Host "================================================"
        Write-Host "SUCESSO! SGIR esta rodando!"
        Write-Host "================================================"
        Write-Host ""
        Write-Host "Acesse: http://localhost:5000"
        Write-Host ""
        
        $open = Read-Host "Abrir navegador agora? (S/n)"
        if ($open -ne "n") {
            Start-Process "http://localhost:5000"
        }
    }
} catch {
    Write-Host ""
    Write-Host "Servidor iniciando..."
    Write-Host "Aguarde 1 minuto e acesse: http://localhost:5000"
}

Write-Host ""
Write-Host "Instalacao concluida!"
