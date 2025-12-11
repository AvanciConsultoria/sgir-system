# ================================================================
# SGIR - IMPORTAÇÃO PARA SQLite (WINDOWS POWERSHELL)
# ================================================================
# Script PowerShell que funciona sem redirecionamento '<'
# Compatível com Windows 7/10/11 e PowerShell 5.1+
# ================================================================

param(
    [string]$SqliteDbPath = "../src/SGIR.WebApp/Data/sgir.db",
    [string]$SqlFilePath = "./imported-sinapi-ferramentas.sql"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "SGIR - IMPORTAÇÃO CATÁLOGOS PARA SQLite" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Verifica se o arquivo SQL existe
if (-not (Test-Path $SqlFilePath)) {
    Write-Host "ERRO: Arquivo SQL não encontrado: $SqlFilePath" -ForegroundColor Red
    exit 1
}

# Verifica se SQLite está disponível
$sqliteExe = $null
if (Get-Command sqlite3 -ErrorAction SilentlyContinue) {
    $sqliteExe = "sqlite3"
} elseif (Test-Path "./sqlite3.exe") {
    $sqliteExe = "./sqlite3.exe"
} else {
    Write-Host "ERRO: SQLite3 não encontrado!" -ForegroundColor Red
    Write-Host "Baixe em: https://www.sqlite.org/download.html" -ForegroundColor Yellow
    Write-Host "Ou instale via: winget install SQLite.SQLite" -ForegroundColor Yellow
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

# Remove linhas vazias
$sqliteContent = $sqliteContent -replace '(?m)^\s*$', ''

# Salva SQL convertido temporariamente
$tempSqlFile = "$env:TEMP\sgir-import-sqlite.sql"
$sqliteContent | Out-File -FilePath $tempSqlFile -Encoding UTF8 -NoNewline

Write-Host "3. Conectando ao banco de dados..." -ForegroundColor Yellow
$dbFullPath = Resolve-Path $SqliteDbPath -ErrorAction SilentlyContinue
if (-not $dbFullPath) {
    Write-Host "   AVISO: Banco de dados não existe. Será criado." -ForegroundColor Yellow
    $dbDirectory = Split-Path $SqliteDbPath -Parent
    if (-not (Test-Path $dbDirectory)) {
        New-Item -ItemType Directory -Path $dbDirectory -Force | Out-Null
    }
    $dbFullPath = (New-Item -ItemType File -Path $SqliteDbPath -Force).FullName
}

Write-Host "4. Executando importação..." -ForegroundColor Yellow
Write-Host "   Banco: $dbFullPath" -ForegroundColor Gray

# Executa com .read ao invés de redirecionamento
$importCommand = ".read `"$tempSqlFile`""
$result = & $sqliteExe $dbFullPath $importCommand 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===================================" -ForegroundColor Green
    Write-Host "IMPORTAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "===================================" -ForegroundColor Green
    Write-Host ""
    
    # Conta itens importados
    $countResult = & $sqliteExe $dbFullPath "SELECT COUNT(*) FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL';"
    Write-Host "Total de ferramentas no banco: $countResult" -ForegroundColor Cyan
    
    # Mostra amostra
    Write-Host ""
    Write-Host "Últimas 5 ferramentas importadas:" -ForegroundColor Cyan
    & $sqliteExe $dbFullPath ".mode table" ".width 50 20 15" "SELECT Descricao, Fabricante, ValorUnitario FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL' ORDER BY DataCriacao DESC LIMIT 5;"
    
} else {
    Write-Host ""
    Write-Host "ERRO ao importar dados!" -ForegroundColor Red
    Write-Host "Detalhes:" -ForegroundColor Yellow
    Write-Host $result
    exit 1
}

# Limpa arquivo temporário
Remove-Item $tempSqlFile -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Execute o aplicativo: cd ../src/SGIR.WebApp && dotnet run" -ForegroundColor White
Write-Host "2. Acesse: http://localhost:5000" -ForegroundColor White
Write-Host "3. Vá em: Estoque -> Ferramentas" -ForegroundColor White
Write-Host ""
