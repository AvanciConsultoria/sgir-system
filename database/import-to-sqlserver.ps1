# ================================================================
# SGIR - IMPORTAÇÃO PARA SQL SERVER (WINDOWS POWERSHELL)
# ================================================================
# Script PowerShell para importar dados no SQL Server
# Contorna problemas de certificado SSL
# ================================================================

param(
    [string]$ServerInstance = "localhost",
    [string]$Database = "SGIR_DB",
    [string]$SqlFilePath = "./imported-sinapi-ferramentas.sql",
    [string]$Username = "",
    [string]$Password = ""
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "SGIR - IMPORTAÇÃO CATÁLOGOS PARA SQL SERVER" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Verifica se o arquivo SQL existe
if (-not (Test-Path $SqlFilePath)) {
    Write-Host "ERRO: Arquivo SQL não encontrado: $SqlFilePath" -ForegroundColor Red
    exit 1
}

Write-Host "1. Verificando módulo SqlServer..." -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
    Write-Host "   Instalando módulo SqlServer..." -ForegroundColor Yellow
    Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber
}
Import-Module SqlServer -ErrorAction SilentlyContinue

Write-Host "2. Lendo arquivo SQL..." -ForegroundColor Yellow
$sqlContent = Get-Content $SqlFilePath -Raw -Encoding UTF8

Write-Host "3. Conectando ao SQL Server..." -ForegroundColor Yellow
Write-Host "   Servidor: $ServerInstance" -ForegroundColor Gray
Write-Host "   Banco: $Database" -ForegroundColor Gray

# Monta connection string com TrustServerCertificate para contornar erro SSL
$connectionString = if ($Username -and $Password) {
    "Server=$ServerInstance;Database=$Database;User Id=$Username;Password=$Password;TrustServerCertificate=True;Encrypt=False;"
} else {
    "Server=$ServerInstance;Database=$Database;Integrated Security=True;TrustServerCertificate=True;Encrypt=False;"
}

try {
    Write-Host "4. Executando importação..." -ForegroundColor Yellow
    
    # Usa Invoke-Sqlcmd com tratamento de erros
    Invoke-Sqlcmd -ConnectionString $connectionString -Query $sqlContent -Verbose -ErrorAction Stop
    
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "IMPORTAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host ""
    
    # Conta itens importados
    $countQuery = "SELECT COUNT(*) AS Total FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL';"
    $countResult = Invoke-Sqlcmd -ConnectionString $connectionString -Query $countQuery
    Write-Host "Total de ferramentas no banco: $($countResult.Total)" -ForegroundColor Cyan
    
    # Mostra amostra
    Write-Host ""
    Write-Host "Últimas 5 ferramentas importadas:" -ForegroundColor Cyan
    $sampleQuery = "SELECT TOP 5 Descricao, Fabricante, ValorUnitario FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL' ORDER BY DataCriacao DESC;"
    $sampleResult = Invoke-Sqlcmd -ConnectionString $connectionString -Query $sampleQuery
    $sampleResult | Format-Table -AutoSize
    
} catch {
    Write-Host ""
    Write-Host "ERRO ao importar dados!" -ForegroundColor Red
    Write-Host "Detalhes:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message
    Write-Host ""
    Write-Host "SOLUÇÕES COMUNS:" -ForegroundColor Yellow
    Write-Host "1. Verifique se o SQL Server está rodando:" -ForegroundColor White
    Write-Host "   services.msc -> SQL Server (MSSQLSERVER)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Para SQL Express, use:" -ForegroundColor White
    Write-Host "   .\import-to-sqlserver.ps1 -ServerInstance 'localhost\SQLEXPRESS'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Para SQL com autenticação, use:" -ForegroundColor White
    Write-Host "   .\import-to-sqlserver.ps1 -Username 'sa' -Password 'SuaSenha'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Verifique o firewall do Windows (porta 1433)" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Atualize appsettings.json com a connection string:" -ForegroundColor White
Write-Host "   `"DefaultConnection`": `"$connectionString`"" -ForegroundColor Gray
Write-Host "2. Execute o aplicativo: cd ../src/SGIR.WebApp && dotnet run" -ForegroundColor White
Write-Host "3. Acesse: http://localhost:5000" -ForegroundColor White
Write-Host ""
