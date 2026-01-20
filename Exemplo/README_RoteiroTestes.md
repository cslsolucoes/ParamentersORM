# Roteiro de Testes - Módulo Parameters

Este documento descreve o roteiro completo de testes para o módulo Parameters.

## 📋 Arquivo

- **Arquivo:** `RoteiroTestesParameters.pas`
- **Tipo:** Programa Console (Delphi/FreePascal)

## 🎯 Objetivo

Testar todas as funcionalidades do módulo Parameters de forma sistemática e organizada.

## 🧪 Testes Incluídos

### TESTE 1: Configuração e Conexão
- ✅ Configuração do banco SQLite
- ✅ Conexão com o banco
- ✅ Verificação de conexão

### TESTE 2: Count - Contar Parâmetros
- ✅ Contagem de parâmetros no banco
- ✅ Validação do retorno

### TESTE 3: CREATE - Inserir Parâmetros
- ✅ 3.1: Inserir parâmetro simples
- ✅ 3.2: Inserir parâmetro com título específico
- ✅ 3.3: Inserir parâmetro Integer

### TESTE 4: READ - Buscar Parâmetros
- ✅ 4.1: Buscar por chave simples
- ✅ 4.2: Buscar com filtro de título
- ✅ 4.3: Verificar se existe (Exists)
- ✅ 4.4: Listar todos os parâmetros

### TESTE 5: UPDATE - Atualizar Parâmetros
- ✅ 5.1: Atualizar com Setter (Insert ou Update automático)
- ✅ 5.2: Atualizar com Update direto
- ✅ Verificação de atualização no banco

### TESTE 6: DELETE - Deletar Parâmetros
- ✅ Deletar parâmetro
- ✅ Verificar se foi deletado

### TESTE 7: Filtros (ContratoID e ProdutoID)
- ✅ 7.1: Buscar com filtro de ContratoID
- ✅ 7.2: Buscar com filtro de ProdutoID

### TESTE 8: Limpeza
- ✅ Deletar parâmetros de teste criados

## 🚀 Como Executar

### 1. Compilar o Programa

```bash
# No Delphi/FreePascal, compile o arquivo:
RoteiroTestesParameters.pas
```

### 2. Executar

Execute o programa compilado. O console mostrará:
- Progresso de cada teste
- Resultado de cada teste (✓ PASSOU ou ✗ FALHOU)
- Resumo final com estatísticas

### 3. Verificar Resultados

No final, você verá:
```
╔════════════════════════════════════════╗
║  RESUMO DOS TESTES                    ║
╚════════════════════════════════════════╝

Total de testes: X
✓ Testes passaram: Y
✗ Testes falharam: Z
```

## 📊 Exemplo de Saída

```
╔════════════════════════════════════════╗
║  ROTEIRO DE TESTES - MÓDULO PARAMETERS ║
╚════════════════════════════════════════╝

========================================
  TESTE 1: Configuração e Conexão
========================================

Arquivo do banco: E:\Pacote\ORM\Data\Config.db

Conectando ao banco...
✓ PASSOU: Conexão estabelecida com sucesso

========================================
  TESTE 2: Count - Contar Parâmetros
========================================

Total de parâmetros no banco: 15
✓ PASSOU: Count retornou valor válido

...

========================================
  RESUMO DOS TESTES
========================================

Total de testes: 12
✓ Testes passaram: 12
✗ Testes falharam: 0

╔════════════════════════════════════════╗
║  ✓ TODOS OS TESTES PASSARAM!           ║
╚════════════════════════════════════════╝
```

## ⚙️ Configuração

### Alterar Caminho do Banco

Edite a linha 47 do arquivo:

```pascal
LDatabasePath := 'E:\Pacote\ORM\Data\Config.db';
```

### Alterar Nome da Tabela

Edite a linha 50:

```pascal
.TableName('config')  // Altere para o nome da sua tabela
```

## 🔍 O que Cada Teste Verifica

### CREATE
- ✅ Criação de parâmetros com diferentes tipos
- ✅ Criação com diferentes títulos
- ✅ Validação de sucesso da inserção

### READ
- ✅ Busca por chave simples
- ✅ Busca com filtro de título
- ✅ Verificação de existência
- ✅ Listagem completa

### UPDATE
- ✅ Atualização de valores
- ✅ Atualização de descrição
- ✅ Verificação de persistência no banco

### DELETE
- ✅ Deleção de parâmetros
- ✅ Verificação de remoção

### FILTROS
- ✅ Filtro por ContratoID
- ✅ Filtro por ProdutoID
- ✅ Combinação de filtros

## ⚠️ Observações

1. **Parâmetros de Teste**: O programa cria parâmetros com nomes:
   - `teste_simples`
   - `teste_titulo`
   - `teste_integer`

2. **Limpeza Automática**: O TESTE 8 deleta automaticamente os parâmetros de teste criados.

3. **Banco de Dados**: Certifique-se de que o banco existe e está acessível antes de executar.

4. **Tabela**: A tabela será criada automaticamente se `AutoCreateTable(True)` estiver configurado.

## 🐛 Troubleshooting

### Erro: "Não foi possível conectar ao banco"
- Verifique se o caminho do banco está correto
- Verifique se o arquivo existe
- Verifique permissões de acesso

### Erro: "Tabela não existe"
- Configure `AutoCreateTable(True)` na linha 49
- Ou crie a tabela manualmente antes de executar

### Testes Falhando
- Verifique os logs de erro no console
- Verifique se o banco está acessível
- Verifique se há parâmetros duplicados

## 📚 Próximos Passos

Após executar o roteiro:
1. Analise os resultados
2. Corrija problemas identificados
3. Execute novamente para validar correções
4. Use como base para testes adicionais

---

**Autor:** Claiton de Souza Linhares  
**Data:** 02/01/2026
