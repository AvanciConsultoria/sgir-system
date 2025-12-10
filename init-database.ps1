# Script para inicializar o banco de dados SGIR
# Executa o SQL de criacao de tabelas no container Docker

Write-Host "Inicializando banco de dados SGIR..." -ForegroundColor Cyan
Write-Host ""

# Verificar se container esta rodando
Write-Host "1. Verificando container SQL Server..." -ForegroundColor Yellow
$container = docker ps --filter "name=sgir-sqlserver" --format "{{.Names}}"

if (-not $container) {
    Write-Host "[X] Container sgir-sqlserver nao esta rodando!" -ForegroundColor Red
    Write-Host "    Execute: docker-compose -f docker-compose-simple.yml up -d" -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Container encontrado: $container" -ForegroundColor Green
Write-Host ""

# Aguardar SQL Server ficar pronto
Write-Host "2. Aguardando SQL Server inicializar..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Copiar script SQL para container
Write-Host "3. Copiando script SQL para container..." -ForegroundColor Yellow
docker cp "database/create-tables.sql" sgir-sqlserver:/tmp/create-tables.sql

if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] Erro ao copiar arquivo!" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Script copiado" -ForegroundColor Green
Write-Host ""

# Executar script SQL
Write-Host "4. Executando script SQL..." -ForegroundColor Yellow
Write-Host "   (Isto pode demorar alguns segundos)" -ForegroundColor Gray
Write-Host ""

$result = docker exec sgir-sqlserver /opt/mssql-tools18/bin/sqlcmd `
    -S localhost `
    -U sa `
    -P "SGIR_Pass123!" `
    -C `
    -i /tmp/create-tables.sql

Write-Host $result
Write-Host ""

if ($LASTEXITCODE -eq 0) {
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "BANCO DE DADOS INICIALIZADO COM SUCESSO!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tabelas criadas:" -ForegroundColor Cyan
    Write-Host "  - Itens_Estoque (25 itens iniciais)" -ForegroundColor Gray
    Write-Host "  - Caixas_Ferramentas" -ForegroundColor Gray
    Write-Host "  - Caixas_Itens" -ForegroundColor Gray
    Write-Host "  - Carrinhos" -ForegroundColor Gray
    Write-Host "  - Carrinhos_Itens" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Acesse o sistema:" -ForegroundColor Cyan
    Write-Host "  http://localhost:5000/ferramentas" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "[X] Erro ao executar script!" -ForegroundColor Red
    Write-Host "    Verifique os logs acima" -ForegroundColor Yellow
    exit 1
}

# Limpar arquivo temporario
docker exec sgir-sqlserver rm /tmp/create-tables.sql 2>$null

Write-Host "Script concluido!" -ForegroundColor Green
