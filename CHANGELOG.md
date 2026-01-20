# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [1.0.2] - 2026-01-02

### 🔄 Alterado

#### Nomenclatura de Métodos CRUD
- **Mudança:** Renomeado `Get()` → `Getter()` e `Update()` → `Setter()`
- **Motivo:** Melhor clareza semântica e alinhamento com padrões modernos
- **Compatibilidade:** Métodos `Get()` e `Update()` mantidos como deprecated (chamam `Getter()` e `Setter()`)
- **Arquivos afetados:**
  - `src/Paramenters/Parameters.Interfaces.pas` - Interfaces atualizadas
  - `src/Paramenters/Parameters.pas` - Implementação atualizada
  - `src/Paramenters/Database/Parameters.Database.pas` - Implementação atualizada
  - `src/Paramenters/IniFiles/Parameters.Inifiles.pas` - Implementação atualizada
  - `src/Paramenters/JsonObject/Parameters.JsonObject.pas` - Implementação atualizada
  - `src/View/ufrmParamenters.pas` - Interface gráfica atualizada

#### Hierarquia Completa de Identificação
- **Mudança:** Todos os métodos CRUD agora respeitam a hierarquia completa: `ContratoID`, `ProdutoID`, `Title`, `Name`
- **Comportamento:**
  - **Com hierarquia configurada:** Busca/atualização específica usando todos os campos da constraint UNIQUE
  - **Sem hierarquia configurada:** Busca ampla (compatibilidade com código legado)
- **Arquivos afetados:**
  - `Getter()`: Valida e usa hierarquia quando disponível, busca ampla quando não disponível
  - `Setter()`: Sempre requer hierarquia completa no `TParameter` recebido
  - `Delete()`: Respeita hierarquia completa
  - `Exists()`: Respeita hierarquia completa

### 📝 Detalhes Técnicos

#### Métodos Getter
- **Database:** `WHERE contrato_id = ? AND produto_id = ? AND titulo = ? AND chave = ?` (quando hierarquia configurada)
- **Inifiles:** Busca na seção específica (Title) quando configurado
- **JsonObject:** Busca no objeto específico (Title) quando configurado
- **Fallback:** Busca ampla quando hierarquia não está configurada (compatibilidade)

#### Métodos Setter
- **Comportamento:** INSERT se não existir, UPDATE se existir
- **Validação:** Requer `ContratoID`, `ProdutoID`, `Titulo` e `Name` preenchidos no `TParameter`
- **Identificação:** Usa hierarquia completa para identificar registro existente

---

## [1.0.1] - 2026-01-02

### 🔧 Corrigido

#### Validação de Chaves Duplicadas
- **Correção:** Agora permite inserir chaves com o mesmo nome em títulos diferentes
- **Antes:** O sistema bloqueava qualquer chave duplicada, mesmo em títulos diferentes
- **Agora:** A validação considera `Nome + Título + ContratoID + ProdutoID` como chave única
- **Arquivos afetados:**
  - `src/Paramenters/Database/Parameters.Database.pas`
    - Criada função `ExistsWithTitulo` para verificar duplicatas considerando título
    - Atualizado método `Insert` para usar validação completa
  - `src/Paramenters/IniFiles/Parameters.Inifiles.pas`
    - Criada função `ExistsInSection` para verificar duplicatas na seção específica
    - Atualizado método `Insert` para validar apenas na mesma seção
  - `src/Paramenters/JsonObject/Parameters.JsonObject.pas`
    - Criada função `ExistsInObject` para verificar duplicatas no objeto específico
    - Atualizado método `Insert` para validar apenas no mesmo objeto

#### Remoção de Seções/Objetos Vazios
- **Correção:** Seções e objetos vazios são removidos automaticamente ao deletar a última chave
- **Antes:** Ao deletar a última chave de um título, a seção/objeto permanecia vazio no arquivo
- **Agora:** Seções e objetos vazios são removidos automaticamente após deletar a última chave
- **Arquivos afetados:**
  - `src/Paramenters/IniFiles/Parameters.Inifiles.pas`
    - Criada função `RemoveEmptySection` para remover seções vazias
    - Atualizado método `Delete` para verificar e remover seções vazias
    - Preserva seções especiais como `[Contrato]`
  - `src/Paramenters/JsonObject/Parameters.JsonObject.pas`
    - Atualizado método `Delete` para verificar e remover objetos vazios
    - Preserva objetos especiais como `"Contrato"`

### 📝 Detalhes Técnicos

#### Validação de Duplicatas
- **Database:** Validação agora usa `chave + titulo + contrato_id + produto_id` como chave única
- **Inifiles:** Validação considera apenas a seção (título) específica
- **JsonObject:** Validação considera apenas o objeto (título) específico

#### Limpeza Automática
- **Inifiles:** Remove seção `[Titulo]` quando não há mais chaves válidas
- **JsonObject:** Remove objeto `"Titulo"` quando não há mais chaves
- **Exceções:** Seções/objetos especiais (`[Contrato]` e `"Contrato"`) são preservados

---

## [1.0.0] - 2026-01-01

### ✨ Adicionado

#### Funcionalidades Principais
- Sistema unificado de gerenciamento de parâmetros
- Suporte a múltiplas fontes de dados (Database, INI Files, JSON Objects)
- Fallback automático entre fontes
- Suporte multi-engine (UNIDAC, FireDAC, Zeos)
- Suporte multi-database (PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC)
- Thread-safe com TCriticalSection
- Fluent Interface para código mais legível
- Importação/Exportação bidirecional entre fontes
- Encapsulamento total (apenas 2 arquivos públicos)

#### Compatibilidade
- Suporte completo para Delphi 10.3+
- Suporte completo para FPC 3.2.2+ / Lazarus 2.0+
- Diretivas de compilação adaptadas para FPC
- Compatibilidade com múltiplos engines de banco de dados

#### Documentação
- README.md completo com exemplos
- Documentação HTML na pasta `Analises`
- Exemplos de uso práticos
- Guias de configuração para FPC/Lazarus

---

## Tipos de Mudanças

- **✨ Adicionado** - para novas funcionalidades
- **🔄 Alterado** - para mudanças em funcionalidades existentes
- **🗑️ Removido** - para funcionalidades removidas
- **🔧 Corrigido** - para correções de bugs
- **🔒 Segurança** - para vulnerabilidades corrigidas

---

**Legenda:**
- Versão segue o padrão [MAJOR.MINOR.PATCH](https://semver.org/lang/pt-BR/)
- MAJOR: Mudanças incompatíveis na API
- MINOR: Novas funcionalidades compatíveis com versões anteriores
- PATCH: Correções de bugs compatíveis com versões anteriores
