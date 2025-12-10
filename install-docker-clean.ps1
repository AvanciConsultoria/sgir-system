# 🚀 SGIR - Instalação Docker LIMPA (Sem Cache)
# Remove tudo e instala do zero para garantir que funcione

Write-Host "🧹 ================================================" -ForegroundColor Cyan
Write-Host "   SGIR - Instalação Limpa Docker" -ForegroundColor Cyan
Write-Host "   (Remove cache e reinstala do zero)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# 1. Parar e remover containers antigos
Write-Host "🛑 Parando containers antigos..." -ForegroundColor Yellow
docker-compose down -v 2>$null

# 2. Limpar cache do Docker
Write-Host "🧹 Limpando cache do Docker..." -ForegroundColor Yellow
Write-Host "   (Isto pode remover imagens não usadas)" -ForegroundColor Gray
docker system prune -a -f 2>$null

# 3. Verificar se está no diretório correto
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ Erro: docker-compose.yml não encontrado!" -ForegroundColor Red
    Write-Host "   Execute este script no diretório sgir-system" -ForegroundColor Yellow
    exit 1
}

# 4. Puxar versão mais recente do GitHub
Write-Host ""
Write-Host "📥 Baixando código mais recente do GitHub..." -ForegroundColor Yellow
git fetch origin main
git reset --hard origin/main

Write-Host "✅ Código atualizado!" -ForegroundColor Green
Write-Host ""

# 5. Build do zero (sem cache)
Write-Host "🔨 Iniciando build COMPLETO (sem cache)..." -ForegroundColor Yellow
Write-Host "   ⏱️  Isto vai demorar 5-15 minutos na primeira vez" -ForegroundColor Gray
Write-Host "   ☕ Pegue um café enquanto aguarda..." -ForegroundColor Gray
Write-Host ""

try {
    docker-compose build --no-cache --progress=plain
    Write-Host ""
    Write-Host "✅ Build concluído com sucesso!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "❌ Build falhou!" -ForegroundColor Red
    Write-Host "   Verifique os logs acima" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📖 Consulte: TROUBLESHOOTING_WINDOWS.md" -ForegroundColor Cyan
    exit 1
}

# 6. Iniciar containers
Write-Host ""
Write-Host "🚀 Iniciando containers..." -ForegroundColor Yellow
docker-compose up -d

# 7. Aguardar inicialização
Write-Host ""
Write-Host "⏳ Aguardando inicialização..." -ForegroundColor Yellow
for ($i = 30; $i -gt 0; $i--) {
    Write-Host "`r   🕐 $i segundos restantes..." -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
}
Write-Host ""

# 8. Verificar status
Write-Host ""
Write-Host "📊 Status dos containers:" -ForegroundColor Yellow
docker-compose ps

# 9. Verificar logs
Write-Host ""
Write-Host "📜 Últimas linhas dos logs:" -ForegroundColor Yellow
docker-compose logs --tail=15

# 10. Teste de conexão
Write-Host ""
Write-Host "🌐 Testando conexão..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 10 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host ""
        Write-Host "🎉 ================================================" -ForegroundColor Green
        Write-Host "   INSTALAÇÃO BEM-SUCEDIDA!" -ForegroundColor Green
        Write-Host "   SGIR está rodando!" -ForegroundColor Green
        Write-Host "==================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Acesse o Dashboard:" -ForegroundColor Cyan
        Write-Host "   👉 http://localhost:5000" -ForegroundColor Yellow -BackgroundColor DarkBlue
        Write-Host ""
        Write-Host "📝 Comandos úteis:" -ForegroundColor Cyan
        Write-Host "   Ver logs:      docker-compose logs -f" -ForegroundColor Gray
        Write-Host "   Parar:         docker-compose down" -ForegroundColor Gray
        Write-Host "   Reiniciar:     docker-compose restart" -ForegroundColor Gray
        Write-Host ""
        
        # Perguntar se quer abrir navegador
        $open = Read-Host "Deseja abrir o navegador agora? (S/n)"
        if ($open -ne "n" -and $open -ne "N") {
            Start-Process "http://localhost:5000"
        }
    }
} catch {
    Write-Host ""
    Write-Host "⚠️  Servidor ainda não está respondendo" -ForegroundColor Yellow
    Write-Host "   Aguarde mais alguns segundos e acesse:" -ForegroundColor Gray
    Write-Host "   http://localhost:5000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Ou verifique os logs:" -ForegroundColor Gray
    Write-Host "   docker-compose logs -f webapp" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✨ Script concluído!" -ForegroundColor Green
Write-Host ""
