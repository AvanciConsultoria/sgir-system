/*
 * Script 01: Criação do Banco de Dados SGIR
 * Sistema de Gestão Integrada de Recursos
 * Data: 2024-12-09
 */

-- Verificar se o banco existe e criar
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SGIR')
BEGIN
    CREATE DATABASE SGIR
    COLLATE Latin1_General_CI_AS;
    PRINT 'Banco de dados SGIR criado com sucesso!';
END
ELSE
BEGIN
    PRINT 'Banco de dados SGIR já existe.';
END
GO

USE SGIR;
GO

-- Configurações do banco
ALTER DATABASE SGIR SET RECOVERY SIMPLE;
GO

PRINT 'Configuração do banco de dados concluída!';
GO
