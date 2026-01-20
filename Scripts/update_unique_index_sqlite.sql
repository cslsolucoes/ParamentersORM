-- =============================================================================
-- Script para atualizar índice UNIQUE da tabela config no SQLite
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

-- SQLite: Remove o índice UNIQUE antigo (se existir)
-- Nota: SQLite não permite DROP INDEX IF EXISTS diretamente, então precisamos
-- verificar se existe antes. Se der erro, significa que não existe, pode ignorar.
DROP INDEX IF EXISTS idx_config_chave;

-- SQLite: Cria o novo índice UNIQUE composto
-- Este índice permite chaves duplicadas em títulos diferentes
CREATE UNIQUE INDEX IF NOT EXISTS idx_config_chave_titulo ON config (chave, titulo, contrato_id, produto_id);

-- =============================================================================
-- VERIFICAÇÃO:
-- Execute: SELECT sql FROM sqlite_master WHERE type='index' AND name LIKE 'idx_config%';
-- Deve retornar apenas: idx_config_chave_titulo
-- =============================================================================
