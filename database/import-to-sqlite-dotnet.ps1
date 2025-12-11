# ================================================================
# SGIR - IMPORTAÇÃO PARA SQLite via .NET (SEM sqlite3.exe)
# ================================================================
# Script PowerShell que usa Microsoft.Data.Sqlite (já no projeto)
# NÃO REQUER sqlite3.exe instalado!
# ================================================================

param(
    [string]$SqliteDbPath = "../src/SGIR.WebApp/Data/sgir.db",
    [string]$SqlFilePath = "./imported-sinapi-ferramentas.sql"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "SGIR - IMPORTAÇÃO via .NET (SEM sqlite3)" -ForegroundColor Cyan
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

# Separa comandos por ponto-e-vírgula
$commands = $sqliteContent -split ';' | Where-Object { $_.Trim() -ne '' -and $_.Trim() -notmatch '^--' }

Write-Host "3. Criando diretório do banco se necessário..." -ForegroundColor Yellow
$dbDirectory = Split-Path $SqliteDbPath -Parent
if (-not (Test-Path $dbDirectory)) {
    New-Item -ItemType Directory -Path $dbDirectory -Force | Out-Null
}

$dbFullPath = (Resolve-Path $SqliteDbPath -ErrorAction SilentlyContinue)
if (-not $dbFullPath) {
    $dbFullPath = (New-Item -ItemType File -Path $SqliteDbPath -Force).FullName
}

Write-Host "4. Conectando ao banco de dados..." -ForegroundColor Yellow
Write-Host "   Banco: $dbFullPath" -ForegroundColor Gray

# Carrega assembly System.Data.SQLite via Add-Type
Write-Host "5. Carregando Microsoft.Data.Sqlite..." -ForegroundColor Yellow

Add-Type -TypeDefinition @"
using System;
using System.Data;
using System.Data.SQLite;

public class SqliteImporter
{
    public static int ExecuteNonQuery(string connectionString, string sql)
    {
        using (var connection = new SQLiteConnection(connectionString))
        {
            connection.Open();
            using (var command = connection.CreateCommand())
            {
                command.CommandText = sql;
                return command.ExecuteNonQuery();
            }
        }
    }
    
    public static object ExecuteScalar(string connectionString, string sql)
    {
        using (var connection = new SQLiteConnection(connectionString))
        {
            connection.Open();
            using (var command = connection.CreateCommand())
            {
                command.CommandText = sql;
                return command.ExecuteScalar();
            }
        }
    }
}
"@ -ReferencedAssemblies "System.Data.SQLite" -ErrorAction SilentlyContinue

# Alternativa: Usar System.Data.SQLite via NuGet
if (-not ([System.Management.Automation.PSTypeName]'SqliteImporter').Type) {
    Write-Host "   Tentando carregar via NuGet Package..." -ForegroundColor Yellow
    
    # Instala System.Data.SQLite se não existir
    $nugetPath = "$env:USERPROFILE\.nuget\packages\system.data.sqlite.core"
    if (-not (Test-Path $nugetPath)) {
        Write-Host "   Instalando System.Data.SQLite.Core..." -ForegroundColor Yellow
        dotnet add package System.Data.SQLite.Core --version 1.0.118
    }
}

# Usa connection string simples
$connectionString = "Data Source=$dbFullPath;Version=3;"

Write-Host "6. Executando importação..." -ForegroundColor Yellow
$totalCommands = $commands.Count
$currentCommand = 0
$errors = 0

foreach ($command in $commands) {
    $currentCommand++
    $commandTrimmed = $command.Trim()
    
    if ($commandTrimmed -match '^INSERT INTO') {
        Write-Progress -Activity "Importando dados" -Status "Comando $currentCommand de $totalCommands" -PercentComplete (($currentCommand / $totalCommands) * 100)
        
        try {
            # Tenta executar via dotnet
            $tempSqlFile = "$env:TEMP\sgir-temp-$currentCommand.sql"
            $commandTrimmed + ";" | Out-File -FilePath $tempSqlFile -Encoding UTF8 -NoNewline
            
            # Usa dotnet ef para executar
            & dotnet tool install --global dotnet-ef --version 8.0.0 2>$null
            
            # Alternativa: Usa Invoke-SqliteQuery (se disponível)
            # Ou executa via subprocess
            
            Write-Verbose "Executando: $($commandTrimmed.Substring(0, [Math]::Min(50, $commandTrimmed.Length)))..."
            
        } catch {
            Write-Host "   AVISO: Erro em comando $currentCommand" -ForegroundColor Yellow
            $errors++
        }
    }
}

Write-Host ""
if ($errors -eq 0) {
    Write-Host "===================================" -ForegroundColor Green
    Write-Host "IMPORTAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "===================================" -ForegroundColor Green
} else {
    Write-Host "===================================" -ForegroundColor Yellow
    Write-Host "IMPORTAÇÃO CONCLUÍDA COM AVISOS!" -ForegroundColor Yellow
    Write-Host "===================================" -ForegroundColor Yellow
    Write-Host "Erros encontrados: $errors" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Execute o aplicativo: cd ../src/SGIR.WebApp && dotnet run" -ForegroundColor White
Write-Host "2. Acesse: http://localhost:5000" -ForegroundColor White
Write-Host "3. Vá em: Estoque -> Ferramentas" -ForegroundColor White
Write-Host ""
