@echo off
REM Script para verificar e dropar tabela CONFIG no Firebird
REM Banco: D:\Dados\DEXION.FDB
REM Host: 10.100.2.30

echo ========================================
echo Verificando tabela CONFIG no Firebird
echo ========================================
echo.

REM Verifica se a tabela existe
echo Verificando se a tabela CONFIG existe...
"C:\Program Files\Firebird\Firebird_2_5\bin\isql.exe" -user SYSDBA -password masterkey 10.100.2.30:D:\Dados\DEXION.FDB -i check_table.sql

echo.
echo ========================================
echo Listando todas as tabelas
echo ========================================
echo.

REM Lista todas as tabelas
"C:\Program Files\Firebird\Firebird_2_5\bin\isql.exe" -user SYSDBA -password masterkey 10.100.2.30:D:\Dados\DEXION.FDB -i list_tables.sql

echo.
echo ========================================
echo Para dropar a tabela, execute:
echo isql.exe -user SYSDBA -password masterkey 10.100.2.30:D:\Dados\DEXION.FDB -i drop_table.sql
echo ========================================
echo.

pause



