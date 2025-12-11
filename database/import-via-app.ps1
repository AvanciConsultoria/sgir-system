# ================================================================
# SGIR - IMPORTAÇÃO via Aplicativo .NET (MÉTODO MAIS SIMPLES)
# ================================================================
# Usa o próprio DbContext do aplicativo para importar
# NÃO REQUER sqlite3.exe instalado!
# ================================================================

param(
    [string]$SqlFilePath = "./imported-sinapi-ferramentas.sql"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "SGIR - IMPORTAÇÃO via Aplicativo .NET" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Verifica se o arquivo SQL existe
if (-not (Test-Path $SqlFilePath)) {
    Write-Host "ERRO: Arquivo SQL não encontrado: $SqlFilePath" -ForegroundColor Red
    exit 1
}

Write-Host "1. Lendo arquivo SQL..." -ForegroundColor Yellow
$sqlContent = Get-Content $SqlFilePath -Raw -Encoding UTF8

# Converte SQL Server para SQLite
Write-Host "2. Convertendo sintaxe SQL Server -> SQLite..." -ForegroundColor Yellow
$sqliteContent = $sqlContent `
    -replace 'GETDATE\(\)', "datetime('now')" `
    -replace 'PRINT ''(.+?)'';', '-- $1' `
    -replace '\r?\nGO\r?\n', "`n" `
    -replace 'GO$', ''

# Salva SQL convertido
$convertedSqlPath = "../src/SGIR.WebApp/Data/import-data.sql"
$sqliteContent | Out-File -FilePath $convertedSqlPath -Encoding UTF8 -NoNewline

Write-Host "3. SQL convertido salvo em: $convertedSqlPath" -ForegroundColor Green
Write-Host ""

Write-Host "4. Agora execute o aplicativo:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   cd ..\src\SGIR.WebApp" -ForegroundColor Cyan
Write-Host "   dotnet run" -ForegroundColor Cyan
Write-Host ""
Write-Host "5. O aplicativo irá:" -ForegroundColor Yellow
Write-Host "   - Criar o banco de dados SQLite automaticamente" -ForegroundColor White
Write-Host "   - Aplicar migrations" -ForegroundColor White
Write-Host "   - Executar seed data básico" -ForegroundColor White
Write-Host ""
Write-Host "6. Para importar os 117 itens manualmente:" -ForegroundColor Yellow
Write-Host "   - Abra o SQL salvo: $convertedSqlPath" -ForegroundColor White
Write-Host "   - Copie os comandos INSERT" -ForegroundColor White
Write-Host "   - Execute via interface web (Ferramentas -> Importar)" -ForegroundColor White
Write-Host ""

Write-Host "OU use este comando direto no PowerShell:" -ForegroundColor Green
Write-Host ""
Write-Host 'Get-Content "' + $convertedSqlPath + '" | ForEach-Object { Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database "SGIR_DB" -Query $_ }' -ForegroundColor Cyan
Write-Host ""
