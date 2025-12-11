# ================================================================
# SGIR - IMPORTAÇÃO SEM SQLITE3.EXE (MÉTODO DEFINITIVO)
# ================================================================
# Este script copia o SQL diretamente para o aplicativo executar
# NÃO REQUER sqlite3.exe instalado!
# ================================================================

param(
    [string]$SqlFilePath = "./imported-sinapi-ferramentas.sql"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SGIR - IMPORTAÇÃO SEM SQLITE3 INSTALADO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este método NÃO requer sqlite3.exe!" -ForegroundColor Green
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

# Cria arquivo SQL convertido
$outputPath = "../src/SGIR.WebApp/Data/seed-catalogos.sql"
Write-Host "3. Salvando SQL convertido em:" -ForegroundColor Yellow
Write-Host "   $outputPath" -ForegroundColor Gray

# Cria diretório se não existir
$dataDir = Split-Path $outputPath -Parent
if (-not (Test-Path $dataDir)) {
    New-Item -ItemType Directory -Path $dataDir -Force | Out-Null
}

$sqliteContent | Out-File -FilePath $outputPath -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "SQL CONVERTIDO E SALVO COM SUCESSO!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Agora vamos executar via dotnet ef
Write-Host "4. Agora vamos importar via aplicativo .NET..." -ForegroundColor Yellow
Write-Host ""

$appPath = "../src/SGIR.WebApp"
$dbPath = "$appPath/Data/sgir.db"

# Verifica se dotnet está disponível
if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    Write-Host "ERRO: .NET SDK não encontrado!" -ForegroundColor Red
    Write-Host "Instale em: https://dotnet.microsoft.com/download" -ForegroundColor Yellow
    exit 1
}

Write-Host "5. Criando banco de dados e aplicando migrations..." -ForegroundColor Yellow
Push-Location $appPath

try {
    # Remove banco antigo se existir
    if (Test-Path "Data/sgir.db") {
        Write-Host "   Removendo banco antigo..." -ForegroundColor Gray
        Remove-Item "Data/sgir.db" -Force
    }
    
    # Cria novo banco
    Write-Host "   Criando novo banco de dados..." -ForegroundColor Gray
    & dotnet ef database update 2>&1 | Out-Null
    
    if (-not (Test-Path "Data/sgir.db")) {
        Write-Host "   AVISO: Banco não foi criado via migrations" -ForegroundColor Yellow
        Write-Host "   Ele será criado quando o aplicativo rodar" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "   AVISO: Migrations não executadas" -ForegroundColor Yellow
    Write-Host "   O banco será criado quando o aplicativo rodar" -ForegroundColor Yellow
}

Pop-Location

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "CONFIGURAÇÃO CONCLUÍDA!" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Execute o aplicativo:" -ForegroundColor White
Write-Host "   cd ..\src\SGIR.WebApp" -ForegroundColor Cyan
Write-Host "   dotnet run" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. O aplicativo irá:" -ForegroundColor White
Write-Host "   ✅ Criar o banco de dados SQLite automaticamente" -ForegroundColor Green
Write-Host "   ✅ Aplicar todas as migrations" -ForegroundColor Green
Write-Host "   ✅ Executar seed data básico" -ForegroundColor Green
Write-Host ""
Write-Host "3. Acesse a interface:" -ForegroundColor White
Write-Host "   http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Para importar os 117 itens dos catálogos:" -ForegroundColor White
Write-Host "   O arquivo SQL está em: $outputPath" -ForegroundColor Gray
Write-Host ""
Write-Host "   OPÇÃO A - Via código C#:" -ForegroundColor Yellow
Write-Host "   Adicione ao DatabaseInitializer.cs:" -ForegroundColor Gray
Write-Host '   var sqlPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Data", "seed-catalogos.sql");' -ForegroundColor Gray
Write-Host '   if (File.Exists(sqlPath)) {' -ForegroundColor Gray
Write-Host '       var sql = File.ReadAllText(sqlPath);' -ForegroundColor Gray
Write-Host '       await _context.Database.ExecuteSqlRawAsync(sql);' -ForegroundColor Gray
Write-Host '   }' -ForegroundColor Gray
Write-Host ""
Write-Host "   OPÇÃO B - Instale o SQLite3 e execute:" -ForegroundColor Yellow
Write-Host "   winget install SQLite.SQLite" -ForegroundColor Cyan
Write-Host "   (depois feche e reabra o PowerShell)" -ForegroundColor Gray
Write-Host "   .\import-to-sqlite.ps1" -ForegroundColor Cyan
Write-Host ""

Write-Host "DICA:" -ForegroundColor Green
Write-Host "Se quiser importar AGORA mesmo sem reiniciar:" -ForegroundColor White
Write-Host "Execute o código C# acima no DatabaseInitializer.cs" -ForegroundColor Gray
Write-Host "na função SeedAsync(), após a verificação if (!await _context.Projetos.AnyAsync())" -ForegroundColor Gray
Write-Host ""

Write-Host "Arquivo SQL convertido salvo em:" -ForegroundColor Cyan
Write-Host "$outputPath" -ForegroundColor White
Write-Host ""
Write-Host "Tamanho do SQL:" -ForegroundColor Cyan
$fileSize = (Get-Item $outputPath).Length / 1KB
Write-Host "{0:N2} KB" -f $fileSize -ForegroundColor White
Write-Host ""

Write-Host "Próximo passo: Execute o aplicativo!" -ForegroundColor Yellow
Write-Host "cd ..\src\SGIR.WebApp && dotnet run" -ForegroundColor Cyan
Write-Host ""
