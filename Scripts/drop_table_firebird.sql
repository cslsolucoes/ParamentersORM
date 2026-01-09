-- Script para verificar e dropar tabela CONFIG no Firebird
-- Banco: D:\Dados\DEXION.FDB
-- Host: 10.100.2.30
-- Usuário: SYSDBA
-- Senha: masterkey

-- Conectar ao banco:
-- isql.exe -user SYSDBA -password masterkey 10.100.2.30:D:\Dados\DEXION.FDB

-- Verificar se a tabela existe (retorna 1 se existir, 0 se não existir)
SELECT COUNT(*) as TABLE_EXISTS
FROM RDB$RELATIONS 
WHERE UPPER(RDB$RELATION_NAME) = 'CONFIG' 
AND RDB$SYSTEM_FLAG = 0;

-- Listar todas as tabelas para verificar o nome exato
SELECT TRIM(RDB$RELATION_NAME) as TABLE_NAME 
FROM RDB$RELATIONS 
WHERE RDB$SYSTEM_FLAG = 0 
ORDER BY RDB$RELATION_NAME;

-- Se a tabela existir, executar o DROP abaixo:
-- IMPORTANTE: Descomente a linha abaixo apenas se tiver certeza que deseja dropar a tabela
-- DROP TABLE "CONFIG";

-- Verificar novamente se foi droppada
SELECT COUNT(*) as TABLE_EXISTS_AFTER_DROP
FROM RDB$RELATIONS 
WHERE UPPER(RDB$RELATION_NAME) = 'CONFIG' 
AND RDB$SYSTEM_FLAG = 0;

COMMIT;



