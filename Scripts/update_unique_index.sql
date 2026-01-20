-- =============================================================================
-- Script para atualizar índice UNIQUE da tabela config
-- 
-- PROBLEMA: O índice UNIQUE antigo estava apenas na coluna 'chave', 
--           impedindo chaves duplicadas em títulos diferentes.
-- 
-- SOLUÇÃO: Remover o índice UNIQUE antigo e criar um índice UNIQUE composto
--          que permite chaves duplicadas em títulos diferentes.
-- 
-- IMPORTANTE: Execute este script APENAS UMA VEZ após atualizar o código.
--             O novo código já cria o índice correto automaticamente.
-- =============================================================================

-- PostgreSQL
-- DROP INDEX IF EXISTS idx_config_chave;
-- CREATE UNIQUE INDEX IF NOT EXISTS idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- MySQL
-- DROP INDEX idx_config_chave ON config;
-- CREATE UNIQUE INDEX idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- SQL Server
-- DROP INDEX IF EXISTS idx_config_chave ON config;
-- CREATE UNIQUE INDEX idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- SQLite
-- DROP INDEX IF EXISTS idx_config_chave;
-- CREATE UNIQUE INDEX IF NOT EXISTS idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- FireBird
-- DROP INDEX idx_config_chave;
-- CREATE UNIQUE INDEX idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- Access (via ODBC)
-- DROP INDEX idx_config_chave ON config;
-- CREATE UNIQUE INDEX idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- =============================================================================
-- INSTRUÇÕES:
-- 1. Descomente as linhas do seu banco de dados
-- 2. Execute o script
-- 3. Verifique se o índice foi criado corretamente
-- =============================================================================
