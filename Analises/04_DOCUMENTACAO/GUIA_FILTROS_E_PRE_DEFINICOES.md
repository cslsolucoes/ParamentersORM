# 🎯 Guia Completo: Filtros e Pré-Definições - Módulo Parameters

**Versão:** 1.0.0  
**Data:** 02/01/2026  
**Autor:** Claiton de Souza Linhares  
**Status:** ✅ Completo

---

## 📋 Índice

1. [Introdução](#introdução)
2. [Hierarquia de Busca](#hierarquia-de-busca)
3. [Pré-Definição de ContratoID e ProdutoID](#pré-definição-de-contratoid-e-produtoid)
4. [Filtro por Title (Título)](#filtro-por-title-título)
5. [Comportamento da Busca](#comportamento-da-busca)
6. [Exemplos Práticos Completos](#exemplos-práticos-completos)
7. [Padrões de Uso Recomendados](#padrões-de-uso-recomendados)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Introdução

O Módulo Parameters suporta uma **hierarquia completa de busca** que permite filtrar parâmetros por:
- **ContratoID** - Identificador do contrato
- **ProdutoID** - Identificador do produto
- **Title** - Título/seção do parâmetro
- **Name** - Nome/chave do parâmetro

Esta hierarquia garante que você possa ter parâmetros com o mesmo nome em diferentes contextos (contratos, produtos, títulos diferentes) sem conflitos.

### Constraint UNIQUE no Banco de Dados

A constraint UNIQUE no banco de dados é: `(contrato_id, produto_id, titulo, chave)`

Isso significa que:
- ✅ Pode ter a mesma chave em títulos diferentes
- ✅ Pode ter a mesma chave em contratos diferentes
- ✅ Pode ter a mesma chave em produtos diferentes
- ❌ Não pode ter a mesma chave no mesmo contrato + produto + título

---

## 🔍 Hierarquia de Busca

### Níveis de Especificidade

1. **Busca Específica Completa** (Mais Específica)
   - ContratoID + ProdutoID + Title + Name
   - Retorna exatamente 1 resultado ou `nil`

2. **Busca com Title + Name** (Específica por Título)
   - Title + Name (usa ContratoID/ProdutoID pré-definidos se disponíveis)
   - Retorna 1 resultado ou `nil`

3. **Busca Apenas por Name** (Ampla - Compatibilidade)
   - Apenas Name
   - Retorna o primeiro resultado encontrado (pode haver múltiplos)

---

## ⚙️ Pré-Definição de ContratoID e ProdutoID

### Conceito

Você pode **definir uma vez** os valores de `ContratoID` e `ProdutoID` e eles serão **usados automaticamente** em todas as buscas subsequentes, mesmo quando você especificar apenas o `Title`.

### Vantagens

- ✅ **Código mais limpo:** Define uma vez, usa várias vezes
- ✅ **Menos repetição:** Não precisa especificar ContratoID e ProdutoID em cada busca
- ✅ **Flexibilidade:** Pode sobrescrever quando necessário
- ✅ **Compatibilidade:** Código antigo continua funcionando

### Como Funciona

Os valores de `ContratoID` e `ProdutoID` são **armazenados na instância** e **persistem** entre chamadas. Quando você faz uma busca apenas com `Title`, o sistema verifica se há valores pré-definidos e os usa automaticamente.

---

## 📝 Filtro por Title (Título)

### Comportamento

O filtro `Title` é **temporário** - ele é limpo após cada operação de busca. Isso permite que você especifique diferentes títulos em buscas consecutivas sem precisar "limpar" o filtro.

### Uso Básico

```pascal
var Param: TParameter;

// Busca apenas por título + chave (sem ContratoID/ProdutoID)
Param := DB.Title('evolution').Getter('key');
```

### Uso com Valores Pré-Definidos

```pascal
// Define valores padrão
DB.ContratoID(1).ProdutoID(1);

// Agora usa os valores pré-definidos automaticamente
Param := DB.Title('evolution').Getter('key');
// SQL gerado: WHERE contrato_id = 1 AND produto_id = 1 AND titulo = 'evolution' AND chave = 'key'
```

---

## 🎯 Comportamento da Busca

### Cenário 1: Hierarquia Completa Especificada

```pascal
Param := DB.ContratoID(1).ProdutoID(1).Title('evolution').Getter('key');
```

**SQL Gerado:**
```sql
SELECT ... 
FROM tabela 
WHERE contrato_id = 1 
  AND produto_id = 1 
  AND titulo = 'evolution' 
  AND chave = 'key'
```

**Comportamento:**
- ✅ Busca específica e exata
- ✅ Retorna `nil` se não encontrar
- ✅ Não busca em outros contratos/produtos/títulos

### Cenário 2: Apenas Title (com Valores Pré-Definidos)

```pascal
// Define valores padrão
DB.ContratoID(1).ProdutoID(1);

// Busca apenas com Title
Param := DB.Title('evolution').Getter('key');
```

**SQL Gerado:**
```sql
SELECT ... 
FROM tabela 
WHERE contrato_id = 1 
  AND produto_id = 1 
  AND titulo = 'evolution' 
  AND chave = 'key'
```

**Comportamento:**
- ✅ Usa valores pré-definidos automaticamente
- ✅ Busca específica e exata
- ✅ Retorna `nil` se não encontrar

### Cenário 3: Apenas Title (sem Valores Pré-Definidos)

```pascal
// Não define ContratoID/ProdutoID
Param := DB.Title('evolution').Getter('key');
```

**SQL Gerado:**
```sql
SELECT ... 
FROM tabela 
WHERE titulo = 'evolution' 
  AND chave = 'key'
ORDER BY contrato_id, produto_id, ordem 
LIMIT 1
```

**Comportamento:**
- ⚠️ Busca em todos os contratos/produtos com esse título
- ⚠️ Retorna o primeiro resultado encontrado
- ⚠️ Pode retornar resultado de outro contrato/produto

### Cenário 4: Busca Ampla (Apenas Name)

```pascal
Param := DB.Getter('key');
```

**SQL Gerado:**
```sql
SELECT ... 
FROM tabela 
WHERE chave = 'key'
ORDER BY contrato_id, produto_id, titulo, ordem 
LIMIT 1
```

**Comportamento:**
- ⚠️ Busca em todos os contratos/produtos/títulos
- ⚠️ Retorna o primeiro resultado encontrado
- ⚠️ Usado apenas para compatibilidade com código legado

---

## 💡 Exemplos Práticos Completos

### Exemplo 1: Definir Valores Padrão no Início da Aplicação

```pascal
unit uConfigParameters;

interface

uses
  Parameters;

var
  // Instância global com valores padrão pré-configurados
  DB: IParametersDatabase;

implementation

initialization
  // Define valores padrão uma vez no início da aplicação
  DB := TParameters.NewDatabase
    .TableName('config')
    .Schema('dbcsl')
    .ContratoID(1)      // Define ContratoID padrão
    .ProdutoID(1)       // Define ProdutoID padrão
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('pass')
    .Connect;

finalization
  DB := nil;

end.
```

**Uso em qualquer lugar do código:**
```pascal
uses uConfigParameters;

var Param: TParameter;

// Usa valores padrão automaticamente (ContratoID=1, ProdutoID=1)
Param := DB.Title('evolution').Getter('key');
if Assigned(Param) then
begin
  WriteLn(Param.Value);
  Param.Free;
end
else
begin
  WriteLn('Parâmetro não encontrado!');
end;
```

### Exemplo 2: Classe/Singleton para Gerenciamento

```pascal
unit uParametersManager;

interface

uses
  Parameters;

type
  TParametersManager = class
  private
    class var FDB: IParametersDatabase;
    class var FContratoID: Integer;
    class var FProdutoID: Integer;
  public
    // Inicializa com valores padrão
    class procedure Initialize(AContratoID, AProdutoID: Integer);
    
    // Retorna instância configurada
    class function GetDB: IParametersDatabase;
    
    // Métodos de conveniência
    class function Get(const ATitle, AKey: string): TParameter;
    class function Exists(const ATitle, AKey: string): Boolean;
    class function SetValue(const ATitle, AKey, AValue: string): Boolean;
  end;

implementation

class procedure TParametersManager.Initialize(AContratoID, AProdutoID: Integer);
begin
  FContratoID := AContratoID;
  FProdutoID := AProdutoID;
  
  FDB := TParameters.NewDatabase
    .TableName('config')
    .Schema('dbcsl')
    .ContratoID(AContratoID)
    .ProdutoID(AProdutoID)
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('pass')
    .Connect;
end;

class function TParametersManager.GetDB: IParametersDatabase;
begin
  Result := FDB;
end;

class function TParametersManager.Get(const ATitle, AKey: string): TParameter;
begin
  Result := FDB.Title(ATitle).Getter(AKey);
end;

class function TParametersManager.Exists(const ATitle, AKey: string): Boolean;
begin
  Result := FDB.Title(ATitle).Exists(AKey);
end;

class function TParametersManager.SetValue(const ATitle, AKey, AValue: string): Boolean;
var
  Param: TParameter;
  Success: Boolean;
begin
  Result := False;
  Param := TParameter.Create;
  try
    Param.ContratoID := FContratoID;
    Param.ProdutoID := FProdutoID;
    Param.Titulo := ATitle;
    Param.Name := AKey;
    Param.Value := AValue;
    Param.ValueType := pvtString;
    
    FDB.Setter(Param, Success);
    Result := Success;
  finally
    Param.Free;
  end;
end;

end.
```

**Uso:**
```pascal
// No início da aplicação
TParametersManager.Initialize(1, 1); // Define ContratoID=1, ProdutoID=1

// Em qualquer lugar do código
var Param: TParameter;
Param := TParametersManager.Get('evolution', 'key');
if Assigned(Param) then
begin
  WriteLn(Param.Value);
  Param.Free;
end;

// Verificar existência
if TParametersManager.Exists('evolution', 'key') then
  WriteLn('Parâmetro existe!');

// Definir valor
if TParametersManager.SetValue('evolution', 'key', 'novo_valor') then
  WriteLn('Valor definido com sucesso!');
```

### Exemplo 3: Definir por Contexto/Sessão

```pascal
// No início de uma operação/sessão
var DB: IParametersDatabase;
var Param: TParameter;

// Define valores padrão para esta sessão
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .ContratoID(GetCurrentContratoID)  // Pega do contexto atual
  .ProdutoID(GetCurrentProdutoID)    // Pega do contexto atual
  .Host('localhost')
  .Port(5432)
  .Database('mydb')
  .Username('postgres')
  .Password('pass')
  .Connect;

// Agora todas as buscas usam esses valores automaticamente
Param := DB.Title('evolution').Getter('key');
if Assigned(Param) then
  WriteLn('Evolution Key: ' + Param.Value);
Param.Free;

Param := DB.Title('chat').Getter('url');
if Assigned(Param) then
  WriteLn('Chat URL: ' + Param.Value);
Param.Free;

Param := DB.Title('dashboard').Getter('theme');
if Assigned(Param) then
  WriteLn('Dashboard Theme: ' + Param.Value);
Param.Free;
```

### Exemplo 4: Mudar Valores Padrão Dinamicamente

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

// Cria instância
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .Host('localhost')
  .Port(5432)
  .Database('mydb')
  .Username('postgres')
  .Password('pass')
  .Connect;

// Define valores padrão iniciais
DB.ContratoID(1).ProdutoID(1);

// Busca usando valores padrão
Param := DB.Title('evolution').Getter('key');
// SQL: WHERE contrato_id = 1 AND produto_id = 1 AND titulo = 'evolution' AND chave = 'key'
if Assigned(Param) then
  WriteLn('Contrato 1: ' + Param.Value);
Param.Free;

// Muda valores padrão para outro contrato/produto
DB.ContratoID(2).ProdutoID(2);

// Agora todas as buscas usam os novos valores
Param := DB.Title('evolution').Getter('key');
// SQL: WHERE contrato_id = 2 AND produto_id = 2 AND titulo = 'evolution' AND chave = 'key'
if Assigned(Param) then
  WriteLn('Contrato 2: ' + Param.Value);
Param.Free;
```

### Exemplo 5: Múltiplas Buscas com Mesmos Valores Padrão

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

// Define valores padrão uma vez
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .ContratoID(1)
  .ProdutoID(1)
  .Connect;

// Múltiplas buscas usando os mesmos valores padrão
Param := DB.Title('evolution').Getter('apikey');
if Assigned(Param) then
  WriteLn('Evolution API Key: ' + Param.Value);
Param.Free;

Param := DB.Title('evolution').Getter('webhook');
if Assigned(Param) then
  WriteLn('Evolution Webhook: ' + Param.Value);
Param.Free;

Param := DB.Title('chat').Getter('url');
if Assigned(Param) then
  WriteLn('Chat URL: ' + Param.Value);
Param.Free;

Param := DB.Title('chat').Getter('key');
if Assigned(Param) then
  WriteLn('Chat Key: ' + Param.Value);
Param.Free;
```

### Exemplo 6: Sobrescrever Valores Padrão Quando Necessário

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

// Define valores padrão
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .ContratoID(1)
  .ProdutoID(1)
  .Connect;

// Busca usando valores padrão
Param := DB.Title('evolution').Getter('key');
// SQL: WHERE contrato_id = 1 AND produto_id = 1 AND titulo = 'evolution' AND chave = 'key'
Param.Free;

// Sobrescreve valores padrão para esta busca específica
Param := DB.ContratoID(2).ProdutoID(2).Title('evolution').Getter('key');
// SQL: WHERE contrato_id = 2 AND produto_id = 2 AND titulo = 'evolution' AND chave = 'key'
Param.Free;

// Próxima busca volta a usar valores padrão (ContratoID=1, ProdutoID=1)
Param := DB.Title('chat').Getter('url');
// SQL: WHERE contrato_id = 1 AND produto_id = 1 AND titulo = 'chat' AND chave = 'url'
Param.Free;
```

### Exemplo 7: Verificação de Existência com Filtros

```pascal
var DB: IParametersDatabase;

// Define valores padrão
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .ContratoID(1)
  .ProdutoID(1)
  .Connect;

// Verifica existência usando valores padrão
if DB.Title('evolution').Exists('key') then
  WriteLn('Parâmetro existe!')
else
  WriteLn('Parâmetro não existe!');

// Verifica existência com valores específicos
if DB.ContratoID(2).ProdutoID(2).Title('evolution').Exists('key') then
  WriteLn('Parâmetro existe no Contrato 2!');
```

### Exemplo 8: Listagem com Filtros

```pascal
var DB: IParametersDatabase;
var ParamList: TParameterList;
var I: Integer;

// Define valores padrão
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .ContratoID(1)
  .ProdutoID(1)
  .Connect;

// Lista todos os parâmetros do título 'evolution' (usando valores padrão)
ParamList := DB.Title('evolution').List;
try
  for I := 0 to ParamList.Count - 1 do
  begin
    WriteLn(Format('%s = %s', [ParamList[I].Name, ParamList[I].Value]));
  end;
finally
  ParamList.Free;
end;
```

---

## 🏆 Padrões de Uso Recomendados

### Padrão 1: Instância Global com Valores Padrão (Recomendado)

**Quando usar:**
- Aplicação com um único contrato/produto ativo por vez
- Valores de ContratoID/ProdutoID não mudam frequentemente

**Vantagens:**
- Código mais limpo
- Menos repetição
- Fácil de manter

**Exemplo:**
```pascal
// Em unit de configuração
var DB: IParametersDatabase;

initialization
  DB := TParameters.NewDatabase
    .ContratoID(1)
    .ProdutoID(1)
    .Connect;
```

### Padrão 2: Classe Singleton (Recomendado para Aplicações Complexas)

**Quando usar:**
- Aplicação com múltiplos contextos
- Necessidade de mudar ContratoID/ProdutoID dinamicamente
- Múltiplos módulos usando parâmetros

**Vantagens:**
- Centralizado
- Fácil de testar
- Permite mudança de contexto

**Exemplo:**
```pascal
TParametersManager.Initialize(1, 1);
Param := TParametersManager.Get('evolution', 'key');
```

### Padrão 3: Instância por Sessão/Contexto

**Quando usar:**
- Aplicação multi-tenant
- Cada sessão/usuário tem seu próprio ContratoID/ProdutoID
- Valores mudam frequentemente

**Vantagens:**
- Isolamento completo
- Flexibilidade máxima
- Sem efeitos colaterais

**Exemplo:**
```pascal
DB := TParameters.NewDatabase
  .ContratoID(GetCurrentContratoID)
  .ProdutoID(GetCurrentProdutoID)
  .Connect;
```

---

## 🔧 Troubleshooting

### Problema: Busca retorna resultado de outro contrato/produto

**Causa:** Não está usando valores pré-definidos ou não está especificando ContratoID/ProdutoID.

**Solução:**
```pascal
// ❌ ERRADO - Busca em todos os contratos/produtos
Param := DB.Title('evolution').Getter('key');

// ✅ CORRETO - Define valores padrão primeiro
DB.ContratoID(1).ProdutoID(1);
Param := DB.Title('evolution').Getter('key');

// ✅ CORRETO - Especifica todos os valores
Param := DB.ContratoID(1).ProdutoID(1).Title('evolution').Getter('key');
```

### Problema: Parâmetro não encontrado quando deveria existir

**Causa:** Valores de ContratoID/ProdutoID/Title não correspondem aos do banco.

**Solução:**
```pascal
// Verifica se os valores estão corretos
WriteLn('ContratoID: ' + IntToStr(DB.ContratoID));
WriteLn('ProdutoID: ' + IntToStr(DB.ProdutoID));
WriteLn('Title: ' + DB.Title);

// Verifica se existe sem filtros (busca ampla)
Param := DB.Getter('key');
if Assigned(Param) then
begin
  WriteLn('Encontrado em:');
  WriteLn('  ContratoID: ' + IntToStr(Param.ContratoID));
  WriteLn('  ProdutoID: ' + IntToStr(Param.ProdutoID));
  WriteLn('  Title: ' + Param.Titulo);
  Param.Free;
end;
```

### Problema: Filtro de Title não está funcionando

**Causa:** O filtro de Title é temporário e é limpo após cada operação.

**Solução:**
```pascal
// ❌ ERRADO - Title é limpo após Getter
DB.Title('evolution');
Param := DB.Getter('key'); // Title já foi limpo!

// ✅ CORRETO - Especifica Title na mesma cadeia
Param := DB.Title('evolution').Getter('key');
```

### Problema: Valores pré-definidos não estão sendo usados

**Causa:** Valores não foram definidos ou foram resetados.

**Solução:**
```pascal
// Verifica se os valores estão definidos
if DB.ContratoID > 0 then
  WriteLn('ContratoID definido: ' + IntToStr(DB.ContratoID))
else
  WriteLn('ContratoID NÃO definido!');

if DB.ProdutoID > 0 then
  WriteLn('ProdutoID definido: ' + IntToStr(DB.ProdutoID))
else
  WriteLn('ProdutoID NÃO definido!');

// Define valores se necessário
if DB.ContratoID = 0 then
  DB.ContratoID(1);
if DB.ProdutoID = 0 then
  DB.ProdutoID(1);
```

---

## 📚 Resumo

### Regras de Ouro

1. **Sempre defina ContratoID e ProdutoID** quando o banco tem múltiplos contratos/produtos
2. **Use valores pré-definidos** para código mais limpo
3. **Especifique Title na mesma cadeia** de chamadas (é temporário)
4. **Verifique se Assigned(Param)** antes de usar o resultado
5. **Use busca específica completa** quando possível (mais seguro)

### Hierarquia de Especificidade

1. **Mais Específica (Recomendado):** `ContratoID + ProdutoID + Title + Name`
2. **Específica com Pré-Definição:** `Title + Name` (usa ContratoID/ProdutoID pré-definidos)
3. **Ampla (Evitar):** Apenas `Name` (compatibilidade com código legado)

---

**Última Atualização:** 02/01/2026  
**Versão do Documento:** 1.0.0
