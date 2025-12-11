@echo off
REM ================================================================
REM SGIR - IMPORTAÇÃO PARA SQLite (WINDOWS CMD/BAT)
REM ================================================================
REM Script CMD simples para importação sem PowerShell
REM Requer sqlite3.exe no PATH ou na pasta atual
REM ================================================================

setlocal enabledelayedexpansion

echo ======================================
echo SGIR - IMPORTAÇÃO CATALOGOS PARA SQLite
echo ======================================
echo.

set SQLITE_DB=..\src\SGIR.WebApp\Data\sgir.db
set SQL_FILE=imported-sinapi-ferramentas.sql

REM Verifica se arquivo SQL existe
if not exist "%SQL_FILE%" (
    echo ERRO: Arquivo SQL não encontrado: %SQL_FILE%
    exit /b 1
)

REM Verifica se SQLite está disponível
where sqlite3 >nul 2>&1
if %errorlevel% neq 0 (
    if not exist "sqlite3.exe" (
        echo ERRO: SQLite3 não encontrado!
        echo.
        echo Baixe em: https://www.sqlite.org/download.html
        echo Ou instale via: winget install SQLite.SQLite
        exit /b 1
    )
    set SQLITE_EXE=sqlite3.exe
) else (
    set SQLITE_EXE=sqlite3
)

echo 1. Convertendo SQL Server para SQLite...
powershell -NoProfile -Command "(Get-Content '%SQL_FILE%' -Raw) -replace 'GETDATE\(\)', \"datetime('now')\" -replace 'PRINT ''(.+?)'';', '-- $1' -replace '\r?\nGO\r?\n', \"`n\" | Out-File -FilePath '%TEMP%\sgir-import.sql' -Encoding UTF8 -NoNewline"

if not exist "%TEMP%\sgir-import.sql" (
    echo ERRO: Falha ao converter SQL!
    exit /b 1
)

echo 2. Criando diretorio do banco se necessario...
if not exist "..\src\SGIR.WebApp\Data\" mkdir "..\src\SGIR.WebApp\Data\"

echo 3. Executando importação...
echo    Banco: %SQLITE_DB%
echo.

%SQLITE_EXE% "%SQLITE_DB%" ".read %TEMP%\sgir-import.sql"

if %errorlevel% equ 0 (
    echo.
    echo ===================================
    echo IMPORTAÇÃO CONCLUÍDA COM SUCESSO!
    echo ===================================
    echo.
    
    REM Conta itens
    for /f %%i in ('%SQLITE_EXE% "%SQLITE_DB%" "SELECT COUNT(*) FROM Itens_Estoque WHERE Categoria = 'FERRAMENTA_MANUAL';"') do set COUNT=%%i
    echo Total de ferramentas no banco: !COUNT!
    echo.
    
) else (
    echo.
    echo ERRO ao importar dados!
    del /q "%TEMP%\sgir-import.sql" 2>nul
    exit /b 1
)

REM Limpa temporário
del /q "%TEMP%\sgir-import.sql" 2>nul

echo Próximos passos:
echo 1. Execute: cd ..\src\SGIR.WebApp ^&^& dotnet run
echo 2. Acesse: http://localhost:5000
echo 3. Vá em: Estoque -^> Ferramentas
echo.
pause
