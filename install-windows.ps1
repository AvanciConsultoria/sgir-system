#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Instalador automático do SGIR - Sistema de Gestão Integrada de Recursos
.DESCRIPTION
    Este script instala automaticamente:
    - .NET 8 SDK
    - SQL Server LocalDB
    - SGIR WebApp
    - Configura banco de dados
    - Inicia o sistema
.NOTES
    Autor: Avanci Consultoria
    Requer: Windows 10/11, PowerShell 5.1+, Privilégios de Administrador
#>

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Cores para output
function Write-Success { param($Message) Write-Host "✅ $Message" -ForegroundColor Green }
function Write-Info { param($Message) Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host "⚠️  $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "❌ $Message" -ForegroundColor Red }

# Banner
Clear-Host
Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🏗️  SGIR - Sistema de Gestão Integrada de Recursos      ║
║                                                              ║
║              Instalador Automático v1.0                     ║
║              Avanci Consultoria - 2025                       ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
Write-Info "Iniciando instalação..."
Write-Host ""

# Verificar se está rodando como Administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Este script precisa ser executado como Administrador!"
    Write-Info "Clique com botão direito no arquivo e selecione 'Executar como Administrador'"
    pause
    exit 1
}

# Diretório de instalação
$InstallDir = "$env:ProgramFiles\SGIR"
$AppDataDir = "$env:LOCALAPPDATA\SGIR"

Write-Info "Diretório de instalação: $InstallDir"
Write-Host ""

# ==============================================================================
# ETAPA 1: Verificar/Instalar .NET 8 SDK
# ==============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Info "ETAPA 1/5: Verificando .NET 8 SDK..."
Write-Host ""

try {
    $dotnetVersion = & dotnet --version 2>$null
    if ($dotnetVersion -like "8.*") {
        Write-Success ".NET 8 SDK já instalado (versão $dotnetVersion)"
    } else {
        throw "Versão incorreta"
    }
} catch {
    Write-Warning ".NET 8 SDK não encontrado. Instalando..."
    
    $dotnetInstallerUrl = "https://download.visualstudio.microsoft.com/download/pr/3a2e3a03-4c3b-472e-bc02-0e2c2d65b7d2/07b1ce5be62b8d7c6fdeaf22db1c39d4/dotnet-sdk-8.0.403-win-x64.exe"
    $dotnetInstaller = "$env:TEMP\dotnet-sdk-8-installer.exe"
    
    Write-Info "Baixando .NET 8 SDK..."
    Invoke-WebRequest -Uri $dotnetInstallerUrl -OutFile $dotnetInstaller -UseBasicParsing
    
    Write-Info "Instalando .NET 8 SDK (pode demorar alguns minutos)..."
    Start-Process -FilePath $dotnetInstaller -ArgumentList "/quiet", "/norestart" -Wait
    
    Remove-Item $dotnetInstaller -Force
    
    # Atualizar PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Success ".NET 8 SDK instalado com sucesso!"
}

Write-Host ""

# ==============================================================================
# ETAPA 2: Verificar/Instalar SQL Server LocalDB
# ==============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Info "ETAPA 2/5: Verificando SQL Server LocalDB..."
Write-Host ""

try {
    $sqlLocalDB = & sqllocaldb info MSSQLLocalDB 2>$null
    Write-Success "SQL Server LocalDB já instalado"
} catch {
    Write-Warning "SQL Server LocalDB não encontrado. Instalando..."
    
    $sqlLocalDBUrl = "https://download.microsoft.com/download/8/6/8/868f5fc4-7bfe-494d-8f9d-115cbcee2f0a/SqlLocalDB.msi"
    $sqlLocalDBInstaller = "$env:TEMP\SqlLocalDB.msi"
    
    Write-Info "Baixando SQL Server LocalDB..."
    Invoke-WebRequest -Uri $sqlLocalDBUrl -OutFile $sqlLocalDBInstaller -UseBasicParsing
    
    Write-Info "Instalando SQL Server LocalDB..."
    Start-Process msiexec.exe -ArgumentList "/i", $sqlLocalDBInstaller, "/quiet", "/norestart", "IACCEPTSQLLOCALDBLICENSETERMS=YES" -Wait
    
    Remove-Item $sqlLocalDBInstaller -Force
    
    Write-Success "SQL Server LocalDB instalado com sucesso!"
    
    # Iniciar instância
    Write-Info "Iniciando instância LocalDB..."
    & sqllocaldb start MSSQLLocalDB
}

Write-Host ""

# ==============================================================================
# ETAPA 3: Clonar/Baixar código do SGIR
# ==============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Info "ETAPA 3/5: Baixando código do SGIR..."
Write-Host ""

if (Test-Path $InstallDir) {
    Write-Warning "Diretório já existe. Removendo versão anterior..."
    Remove-Item $InstallDir -Recurse -Force
}

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
New-Item -ItemType Directory -Path $AppDataDir -Force | Out-Null

# Verificar se Git está instalado
try {
    $gitVersion = & git --version 2>$null
    Write-Info "Git encontrado. Clonando repositório..."
    
    Set-Location $InstallDir
    & git clone https://github.com/AvanciConsultoria/sgir-system.git . 2>&1 | Out-Null
    
    Write-Success "Código baixado com sucesso!"
} catch {
    Write-Warning "Git não encontrado. Baixando ZIP do repositório..."
    
    $zipUrl = "https://github.com/AvanciConsultoria/sgir-system/archive/refs/heads/main.zip"
    $zipFile = "$env:TEMP\sgir-main.zip"
    
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing
    
    Write-Info "Extraindo arquivos..."
    Expand-Archive -Path $zipFile -DestinationPath $InstallDir -Force
    
    # Mover arquivos da subpasta
    $extractedFolder = Get-ChildItem -Path $InstallDir -Directory | Select-Object -First 1
    Get-ChildItem -Path $extractedFolder.FullName -Recurse | Move-Item -Destination $InstallDir -Force
    Remove-Item $extractedFolder.FullName -Recurse -Force
    Remove-Item $zipFile -Force
    
    Write-Success "Código baixado e extraído!"
}

Write-Host ""

# ==============================================================================
# ETAPA 4: Configurar e compilar aplicação
# ==============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Info "ETAPA 4/5: Configurando e compilando aplicação..."
Write-Host ""

Set-Location "$InstallDir\src\SGIR.WebApp"

# Restaurar dependências
Write-Info "Restaurando pacotes NuGet..."
& dotnet restore --verbosity quiet

# Compilar aplicação
Write-Info "Compilando aplicação..."
& dotnet build --configuration Release --verbosity quiet --no-restore

# Criar banco de dados
Write-Info "Criando banco de dados..."
try {
    & dotnet ef database update --project ..\SGIR.Infrastructure --no-build 2>&1 | Out-Null
    Write-Success "Banco de dados criado com sucesso!"
} catch {
    Write-Warning "Erro ao criar banco. Será criado automaticamente na primeira execução."
}

# Publicar aplicação (SELF-CONTAINED SINGLE FILE)
Write-Info "Publicando aplicação (single-file executable)..."
& dotnet publish --configuration Release `
    --runtime win-x64 `
    --self-contained true `
    -p:PublishSingleFile=true `
    -p:IncludeNativeLibrariesForSelfExtract=true `
    -p:EnableCompressionInSingleFile=true `
    --output "$InstallDir\app" `
    --verbosity quiet `
    --no-build

Write-Success "Aplicação compilada e publicada como executável único!"
Write-Host ""

# ==============================================================================
# ETAPA 5: Criar atalhos e configurações
# ==============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Info "ETAPA 5/5: Criando atalhos e configurações..."
Write-Host ""

# Criar script de inicialização
$startScript = @"
@echo off
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║          SGIR - Sistema de Gestão Integrada de Recursos      ║
echo ║                     Iniciando sistema...                     ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

cd /d "$InstallDir\app"
start "" "http://localhost:5000"
SGIR.WebApp.exe

pause
"@

$startScriptPath = "$InstallDir\Iniciar-SGIR.bat"
$startScript | Out-File -FilePath $startScriptPath -Encoding ASCII -Force

# Criar atalho no Desktop
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\SGIR - Sistema.lnk")
$Shortcut.TargetPath = $startScriptPath
$Shortcut.WorkingDirectory = "$InstallDir\app"
$Shortcut.IconLocation = "imageres.dll,3"
$Shortcut.Description = "SGIR - Sistema de Gestão Integrada de Recursos"
$Shortcut.Save()

# Criar atalho no Menu Iniciar
$startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\SGIR"
New-Item -ItemType Directory -Path $startMenuPath -Force | Out-Null
$Shortcut = $WshShell.CreateShortcut("$startMenuPath\SGIR - Sistema.lnk")
$Shortcut.TargetPath = $startScriptPath
$Shortcut.WorkingDirectory = "$InstallDir\app"
$Shortcut.IconLocation = "imageres.dll,3"
$Shortcut.Description = "SGIR - Sistema de Gestão Integrada de Recursos"
$Shortcut.Save()

Write-Success "Atalhos criados:"
Write-Host "   • Desktop: SGIR - Sistema" -ForegroundColor Gray
Write-Host "   • Menu Iniciar: SGIR" -ForegroundColor Gray
Write-Host ""

# Criar script de desinstalação
$uninstallScript = @"
@echo off
echo Desinstalando SGIR...
echo.

taskkill /F /IM SGIR.WebApp.exe 2>nul

rd /s /q "$InstallDir"
rd /s /q "$AppDataDir"
del "%USERPROFILE%\Desktop\SGIR - Sistema.lnk"
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\SGIR"

echo.
echo ✅ SGIR desinstalado com sucesso!
echo.
pause
"@

$uninstallScript | Out-File -FilePath "$InstallDir\Desinstalar.bat" -Encoding ASCII -Force

# ==============================================================================
# CONCLUSÃO
# ==============================================================================
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                              ║" -ForegroundColor Green
Write-Host "║              ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!             ║" -ForegroundColor Green
Write-Host "║                                                              ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Success "SGIR instalado em: $InstallDir"
Write-Host ""

Write-Info "Para iniciar o sistema:"
Write-Host "   1️⃣  Clique no atalho 'SGIR - Sistema' na área de trabalho" -ForegroundColor Yellow
Write-Host "   2️⃣  OU procure por 'SGIR' no Menu Iniciar" -ForegroundColor Yellow
Write-Host "   3️⃣  O navegador abrirá automaticamente em https://localhost:7001" -ForegroundColor Yellow
Write-Host ""

Write-Info "Desinstalar:"
Write-Host "   Execute: $InstallDir\Desinstalar.bat" -ForegroundColor Gray
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$start = Read-Host "Deseja iniciar o SGIR agora? (S/N)"
if ($start -eq "S" -or $start -eq "s") {
    Write-Info "Iniciando SGIR..."
    Start-Process $startScriptPath
} else {
    Write-Info "Execute o atalho 'SGIR - Sistema' quando quiser iniciar."
}

Write-Host ""
Write-Success "Instalação finalizada!"
Write-Host ""
pause
