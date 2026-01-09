# 📚 Manual de Utilização - Módulo Parameters v1.0.0

**Versão:** 1.0.0  
**Data:** 02/01/2026  
**Autor:** Claiton de Souza Linhares  
**Status:** ✅ Completo e Pronto para Uso

---

## 📋 Índice

1. [Introdução](#introdução)
2. [Instalação e Configuração](#instalação-e-configuração)
3. [Conceitos Fundamentais](#conceitos-fundamentais)
4. [Factory Methods - TParameters](#factory-methods---tparameters)
5. [Interface IParameters (Convergência)](#interface-iparameters-convergência)
6. [Interface IParametersDatabase](#interface-iparametersdatabase)
7. [Interface IParametersInifiles](#interface-iparametersinifiles)
8. [Interface IParametersJsonObject](#interface-iparametersjsonobject)
9. [Tipos e Estruturas](#tipos-e-estruturas)
10. [Exemplos Práticos Completos](#exemplos-práticos-completos)
11. [Tratamento de Erros](#tratamento-de-erros)
12. [Boas Práticas](#boas-práticas)

---

## 🎯 Introdução

O **Módulo Parameters** é um sistema unificado de gerenciamento de parâmetros de configuração com suporte a múltiplas fontes de dados (Banco de Dados, Arquivos INI, Objetos JSON) e fallback automático para contingência.

### Características Principais

- ✅ **Multi-fonte:** Suporte a Database, INI Files e JSON Objects
- ✅ **Fallback Automático:** Busca em cascata quando uma fonte falha
- ✅ **Multi-engine Database:** UNIDAC, FireDAC, Zeos
- ✅ **Multi-database:** PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC
- ✅ **Thread-safe:** Todas as operações protegidas com TCriticalSection
- ✅ **Fluent Interface:** Métodos encadeáveis para código mais legível
- ✅ **Importação/Exportação:** Bidirecional entre todas as fontes
- ✅ **Encapsulamento Total:** Apenas 2 arquivos públicos

### Quando Usar

- **Aplicações que precisam de configuração flexível:** Permite alternar entre Database, INI e JSON sem mudar o código
- **Sistemas com requisito de contingência:** Fallback automático garante disponibilidade mesmo se uma fonte falhar
- **Aplicações multi-tenant:** Suporte nativo a ContratoID e ProdutoID para isolamento de dados
- **Migração de configurações:** Importação/Exportação facilita migração entre fontes

---

## 🔧 Instalação e Configuração

### Requisitos

- Delphi 10.1 ou superior OU Free Pascal (FPC) 3.0 ou superior
- Uma das seguintes bibliotecas de acesso a banco de dados:
  - **UniDAC** (Devart)
  - **FireDAC** (Embarcadero)
  - **Zeos** (Open Source)

### Configuração de Diretivas de Compilação

No arquivo `ParamentersORM.Defines.inc`, defina qual engine será usado:

```pascal
// Para usar UniDAC
{$DEFINE USE_UNIDAC}

// Para usar FireDAC
{$DEFINE USE_FIREDAC}

// Para usar Zeos
{$DEFINE USE_ZEOS}
```

**Nota:** Apenas uma diretiva deve estar ativa por vez.

### Uso Básico

```pascal
uses Parameters;

var Parameters: IParameters;
begin
  // Cria instância com configuração padrão (apenas Database)
  Parameters := TParameters.New;
  
  // Configura e usa
  Parameters.Database
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('pass')
    .Connect;
end;
```

---

## 📖 Conceitos Fundamentais

### TParameter

Classe que representa um parâmetro de configuração:

```pascal
TParameter = class
public
  ID: Integer;                    // ID único (Database)
  Name: string;                   // Nome/chave do parâmetro
  Value: string;                  // Valor do parâmetro
  ValueType: TParameterValueType; // Tipo do valor
  Description: string;            // Descrição/comentário
  ContratoID: Integer;            // Filtro de contrato
  ProdutoID: Integer;            // Filtro de produto
  Ordem: Integer;                // Ordem de exibição
  Titulo: string;                 // Título/seção/objeto
  Ativo: Boolean;                // Status ativo/inativo
  CreatedAt: TDateTime;           // Data de criação
  UpdatedAt: TDateTime;          // Data de atualização
end;
```

### TParameterList

Lista gerenciada de parâmetros:

```pascal
TParameterList = class(TList<TParameter>)
public
  procedure ClearAll; // Libera todos os objetos e limpa lista
end;
```

### Fontes de Dados

O módulo suporta três fontes de dados:

1. **Database (psDatabase):** Banco de dados relacional
2. **Inifiles (psInifiles):** Arquivos INI
3. **JsonObject (psJsonObject):** Objetos JSON

### Fallback Automático

Quando múltiplas fontes estão configuradas, o sistema busca em cascata:

```
Database → INI → JSON
```

Se uma fonte falhar ou não encontrar o parâmetro, tenta a próxima automaticamente.

---

## 🏭 Factory Methods - TParameters

A classe `TParameters` fornece métodos estáticos (Factory Methods) para criar instâncias das interfaces.

### TParameters.New

Cria uma nova instância da interface unificada `IParameters`.

#### Overload 1: Sem parâmetros

```pascal
class function New: IParameters;
```

**Descrição:**  
Cria instância com configuração padrão (apenas Database).

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New;
Parameters.Database.Host('localhost').Connect;
```

#### Overload 2: Com configuração

```pascal
class function New(AConfig: TParameterConfig): IParameters;
```

**Parâmetros:**
- `AConfig: TParameterConfig` - Set de opções de configuração

**Valores possíveis:**
- `[pcfDataBase]` - Habilita apenas Database
- `[pcfInifile]` - Habilita apenas INI Files
- `[pcfJsonObject]` - Habilita apenas JSON Objects
- `[pcfDataBase, pcfInifile]` - Database com fallback para INI
- `[pcfDataBase, pcfInifile, pcfJsonObject]` - Todas as fontes

**Exemplo:**
```pascal
var Parameters: IParameters;
// Database com fallback para INI
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Database.Host('localhost').Connect;
Parameters.Inifiles.FilePath('C:\Config\params.ini');

// Busca em cascata: Database → INI
var Param: TParameter;
Param := Parameters.Get('database_host');
```

### TParameters.NewDatabase

Cria uma nova instância de `IParametersDatabase`.

#### Overload 1: Sem parâmetros

```pascal
class function NewDatabase: IParametersDatabase;
```

**Descrição:**  
Cria instância com conexão interna (automática).

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Engine('UniDAC')
  .DatabaseType('PostgreSQL')
  .Host('localhost')
  .Port(5432)
  .Database('mydb')
  .Username('postgres')
  .Password('pass')
  .TableName('config')
  .Schema('public')
  .Connect;
```

#### Overload 2: Com conexão existente

```pascal
class function NewDatabase(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil): IParametersDatabase;
```

**Parâmetros:**
- `AConnection: TObject` - Conexão existente (TUniConnection, TFDConnection ou TZConnection)
- `AQuery: TDataSet` (opcional) - Query para SELECT
- `AExecQuery: TDataSet` (opcional) - Query para INSERT/UPDATE/DELETE

**Exemplo:**
```pascal
var MyConnection: TUniConnection;
var MyQuery: TUniQuery;
var DB: IParametersDatabase;

// ... inicializa MyConnection e MyQuery ...

DB := TParameters.NewDatabase(MyConnection, MyQuery);
DB.TableName('config').Schema('public');
```

### TParameters.NewInifiles

Cria uma nova instância de `IParametersInifiles`.

#### Overload 1: Sem parâmetros

```pascal
class function NewInifiles: IParametersInifiles;
```

**Descrição:**  
Cria instância com valores padrão.

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini')
   .Section('Parameters');
```

#### Overload 2: Com caminho do arquivo

```pascal
class function NewInifiles(const AFilePath: string): IParametersInifiles;
```

**Parâmetros:**
- `AFilePath: string` - Caminho completo do arquivo INI

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles('C:\Config\params.ini');
// Arquivo já está configurado, pode usar diretamente
var Param: TParameter;
Param := Ini.Get('host');
```

### TParameters.NewJsonObject

Cria uma nova instância de `IParametersJsonObject`.

#### Overload 1: Sem parâmetros

```pascal
class function NewJsonObject: IParametersJsonObject;
```

**Descrição:**  
Cria instância com objeto JSON vazio.

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObject;
Json.FilePath('C:\Config\params.json')
    .ObjectName('Parameters');
```

#### Overload 2: Com objeto JSON existente

```pascal
class function NewJsonObject(AJsonObject: TJSONObject): IParametersJsonObject;
```

**Parâmetros:**
- `AJsonObject: TJSONObject` - Objeto JSON existente

**Exemplo:**
```pascal
var MyJson: TJSONObject;
var Json: IParametersJsonObject;

MyJson := TJSONObject.ParseJSONValue('{"ERP":{"host":"localhost"}}') as TJSONObject;
Json := TParameters.NewJsonObject(MyJson);
```

#### Overload 3: Com string JSON

```pascal
class function NewJsonObject(const AJsonString: string): IParametersJsonObject;
```

**Parâmetros:**
- `AJsonString: string` - String contendo JSON válido

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObject('{"ERP":{"host":"localhost","port":5432}}');
var Param: TParameter;
Param := Json.Get('host');
```

### TParameters.NewJsonObjectFromFile

Cria instância carregando JSON de um arquivo.

```pascal
class function NewJsonObjectFromFile(const AFilePath: string): IParametersJsonObject;
```

**Parâmetros:**
- `AFilePath: string` - Caminho completo do arquivo JSON

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObjectFromFile('C:\Config\params.json');
// JSON já está carregado, pode usar diretamente
var List: TParameterList;
List := Json.List;
```

### TParameters.DetectEngine

Detecta automaticamente qual engine está disponível.

```pascal
class function DetectEngine: TParameterDatabaseEngine;
```

**Retorno:**
- `pteUnidac` - Se USE_UNIDAC definido
- `pteFireDAC` - Se USE_FIREDAC definido
- `pteZeos` - Se USE_ZEOS definido
- `pteNone` - Se nenhum estiver definido

**Exemplo:**
```pascal
var Engine: TParameterDatabaseEngine;
Engine := TParameters.DetectEngine;
case Engine of
  pteUnidac: ShowMessage('UNIDAC detectado');
  pteFireDAC: ShowMessage('FireDAC detectado');
  pteZeos: ShowMessage('Zeos detectado');
  pteNone: ShowMessage('Nenhum engine disponível');
end;
```

### TParameters.DetectEngineName

Retorna o nome do engine detectado como string.

```pascal
class function DetectEngineName: string;
```

**Retorno:**  
String com o nome do engine ('UniDAC', 'FireDAC', 'Zeos' ou 'None').

**Exemplo:**
```pascal
var EngineName: string;
EngineName := TParameters.DetectEngineName;
ShowMessage('Engine: ' + EngineName);
```

---

## 🔄 Interface IParameters (Convergência)

A interface `IParameters` é a interface unificada que gerencia múltiplas fontes de dados com suporte a fallback automático.

### Gerenciamento de Fontes

#### Source - Define fonte ativa

```pascal
function Source(ASource: TParameterSource): IParameters; overload;
function Source: TParameterSource; overload;
```

**Parâmetros:**
- `ASource: TParameterSource` - Fonte a ser definida como ativa (psDatabase, psInifiles, psJsonObject)

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);

// Define INI como fonte ativa para inserções
Parameters.Source(psInifiles);

// Verifica fonte ativa
var ActiveSource: TParameterSource;
ActiveSource := Parameters.Source; // Retorna psInifiles
```

#### AddSource - Adiciona fonte à lista

```pascal
function AddSource(ASource: TParameterSource): IParameters;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase]);
// Adiciona INI como fallback
Parameters.AddSource(psInifiles);
```

#### RemoveSource - Remove fonte da lista

```pascal
function RemoveSource(ASource: TParameterSource): IParameters;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
// Remove INI da lista
Parameters.RemoveSource(psInifiles);
```

#### HasSource - Verifica se fonte está ativa

```pascal
function HasSource(ASource: TParameterSource): Boolean;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);

if Parameters.HasSource(psInifiles) then
  ShowMessage('INI está configurado');
```

#### Priority - Define ordem de prioridade

```pascal
function Priority(ASources: TParameterSourceArray): IParameters;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);

// Define ordem: Database → INI → JSON
Parameters.Priority([psDatabase, psInifiles, psJsonObject]);

// Define ordem: JSON → INI → Database
Parameters.Priority([psJsonObject, psInifiles, psDatabase]);
```

### Operações Unificadas (com Fallback)

#### Get - Busca parâmetro em cascata

```pascal
function Get(const AName: string): TParameter; overload;
function Get(const AName: string; ASource: TParameterSource): TParameter; overload;
```

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro
- `ASource: TParameterSource` (opcional) - Fonte específica para buscar

**Retorno:**  
`TParameter` se encontrado, `nil` se não encontrado.

**Exemplo 1: Busca em cascata**
```pascal
var Parameters: IParameters;
var Param: TParameter;

Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Database.Host('localhost').Connect;
Parameters.Inifiles.FilePath('C:\Config\params.ini');

// Busca em cascata: Database → INI
Param := Parameters.Get('database_host');
try
  if Assigned(Param) then
    ShowMessage('Valor: ' + Param.Value)
  else
    ShowMessage('Não encontrado');
finally
  if Assigned(Param) then
    Param.Free;
end;
```

**Exemplo 2: Busca em fonte específica**
```pascal
// Busca apenas no INI
Param := Parameters.Get('database_host', psInifiles);
```

#### List - Lista todos os parâmetros (merge de fontes)

```pascal
function List: TParameterList; overload;
function List(out AList: TParameterList): IParameters; overload;
```

**Retorno:**  
`TParameterList` com todos os parâmetros únicos de todas as fontes (remove duplicatas por Name).

**Exemplo:**
```pascal
var Parameters: IParameters;
var List: TParameterList;
var I: Integer;

Parameters := TParameters.New([pcfDataBase, pcfInifile]);
List := Parameters.List;
try
  for I := 0 to List.Count - 1 do
  begin
    ShowMessage(Format('%s = %s', [List[I].Name, List[I].Value]));
  end;
finally
  List.ClearAll;
  List.Free;
end;
```

#### Insert - Insere parâmetro na fonte ativa

```pascal
function Insert(const AParameter: TParameter): IParameters; overload;
function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
var Param: TParameter;
var Success: Boolean;

Parameters := TParameters.New([pcfDataBase]);
Parameters.Database.Host('localhost').Connect;

Param := TParameter.Create;
try
  Param.Name := 'api_timeout';
  Param.Value := '30';
  Param.ValueType := pvtInteger;
  Param.Description := 'Timeout da API em segundos';
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Ativo := True;
  
  Parameters.Insert(Param, Success);
  if Success then
    ShowMessage('Inserido com sucesso!');
finally
  Param.Free;
end;
```

#### Update - Atualiza parâmetro na fonte onde existe

```pascal
function Update(const AParameter: TParameter): IParameters; overload;
function Update(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
var Param: TParameter;
var Success: Boolean;

Parameters := TParameters.New([pcfDataBase, pcfInifile]);

// Busca o parâmetro
Param := Parameters.Get('api_timeout');
try
  if Assigned(Param) then
  begin
    Param.Value := '60'; // Atualiza valor
    Parameters.Update(Param, Success);
    if Success then
      ShowMessage('Atualizado com sucesso!');
  end;
finally
  if Assigned(Param) then
    Param.Free;
end;
```

#### Delete - Deleta parâmetro de todas as fontes onde existe

```pascal
function Delete(const AName: string): IParameters; overload;
function Delete(const AName: string; out ASuccess: Boolean): IParameters; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
var Success: Boolean;

Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Delete('api_timeout', Success);
if Success then
  ShowMessage('Deletado com sucesso!');
```

#### Exists - Verifica se parâmetro existe (OR lógico)

```pascal
function Exists(const AName: string): Boolean; overload;
function Exists(const AName: string; out AExists: Boolean): IParameters; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
var Exists: Boolean;

Parameters := TParameters.New([pcfDataBase, pcfInifile]);

if Parameters.Exists('api_timeout') then
  ShowMessage('Parâmetro existe em alguma fonte');

// Com out parameter
Parameters.Exists('api_timeout', Exists);
if Exists then
  ShowMessage('Parâmetro encontrado!');
```

#### Count - Conta parâmetros únicos de todas as fontes

```pascal
function Count: Integer; overload;
function Count(out ACount: Integer): IParameters; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
var Count: Integer;

Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Count(Count);
ShowMessage(Format('Total de parâmetros únicos: %d', [Count]));
```

#### Refresh - Renova dados de todas as fontes

```pascal
function Refresh: IParameters;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
// Renova dados de todas as fontes
Parameters.Refresh;
```

### Configuração Unificada

#### ContratoID - Define/obtém ContratoID

```pascal
function ContratoID(const AValue: Integer): IParameters; overload;
function ContratoID: Integer; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
// Aplica em todas as fontes
Parameters.ContratoID(1);
// Obtém valor
var ContratoID: Integer;
ContratoID := Parameters.ContratoID; // Retorna 1
```

#### ProdutoID - Define/obtém ProdutoID

```pascal
function ProdutoID(const AValue: Integer): IParameters; overload;
function ProdutoID: Integer; overload;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.ProdutoID(2);
var ProdutoID: Integer;
ProdutoID := Parameters.ProdutoID; // Retorna 2
```

### Acesso Direto a Fontes

#### Database - Retorna interface Database

```pascal
function Database: IParametersDatabase;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase]);
// Acesso direto a métodos exclusivos do Database
Parameters.Database
  .Host('localhost')
  .Port(5432)
  .Connect;
```

#### Inifiles - Retorna interface Inifiles

```pascal
function Inifiles: IParametersInifiles;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfInifile]);
Parameters.Inifiles
  .FilePath('C:\Config\params.ini')
  .Section('Parameters');
```

#### JsonObject - Retorna interface JsonObject

```pascal
function JsonObject: IParametersJsonObject;
```

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfJsonObject]);
Parameters.JsonObject
  .FilePath('C:\Config\params.json')
  .ObjectName('Parameters');
```

---

## 💾 Interface IParametersDatabase

Interface para acesso a parâmetros em banco de dados.

### Configuração de Tabela

#### TableName - Define/obtém nome da tabela

```pascal
function TableName(const AValue: string): IParametersDatabase; overload;
function TableName: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.TableName('config');
var TableName: string;
TableName := DB.TableName; // Retorna 'config'
```

#### Schema - Define/obtém schema

```pascal
function Schema(const AValue: string): IParametersDatabase; overload;
function Schema: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Schema('public');
```

#### AutoCreateTable - Define/obtém auto-criação de tabela

```pascal
function AutoCreateTable(const AValue: Boolean): IParametersDatabase; overload;
function AutoCreateTable: Boolean; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.AutoCreateTable(True); // Cria tabela automaticamente se não existir
```

### Configuração de Conexão

#### Engine - Define/obtém engine

```pascal
function Engine(const AValue: string): IParametersDatabase; overload;
function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase; overload;
function Engine: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
// Por string
DB.Engine('UniDAC');
// Por enum
DB.Engine(pteUnidac);
```

#### DatabaseType - Define/obtém tipo de banco

```pascal
function DatabaseType(const AValue: string): IParametersDatabase; overload;
function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase; overload;
function DatabaseType: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
// Por string
DB.DatabaseType('PostgreSQL');
// Por enum
DB.DatabaseType(pdtPostgreSQL);
```

#### Host - Define/obtém host

```pascal
function Host(const AValue: string): IParametersDatabase; overload;
function Host: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Host('localhost');
```

#### Port - Define/obtém porta

```pascal
function Port(const AValue: Integer): IParametersDatabase; overload;
function Port: Integer; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Port(5432);
```

#### Username - Define/obtém usuário

```pascal
function Username(const AValue: string): IParametersDatabase; overload;
function Username: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Username('postgres');
```

#### Password - Define/obtém senha

```pascal
function Password(const AValue: string): IParametersDatabase; overload;
function Password: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Password('mypassword');
```

#### Database - Define/obtém nome do banco

```pascal
function Database(const AValue: string): IParametersDatabase; overload;
function Database: string; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
DB.Database('mydb');
```

### Configuração Completa de Conexão

**Exemplo completo:**
```pascal
var DB: IParametersDatabase;
var Success: Boolean;

DB := TParameters.NewDatabase;
DB.Engine('UniDAC')
  .DatabaseType('PostgreSQL')
  .Host('localhost')
  .Port(5432)
  .Database('mydb')
  .Username('postgres')
  .Password('mypassword')
  .TableName('config')
  .Schema('public')
  .AutoCreateTable(True)
  .Connect(Success);

if Success then
  ShowMessage('Conectado com sucesso!')
else
  ShowMessage('Erro ao conectar');
```

### Operações CRUD

#### List - Lista todos os parâmetros ativos

```pascal
function List: TParameterList; overload;
function List(out AList: TParameterList): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var List: TParameterList;
var I: Integer;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

List := DB.List;
try
  for I := 0 to List.Count - 1 do
  begin
    ShowMessage(Format('%s = %s', [List[I].Name, List[I].Value]));
  end;
finally
  List.ClearAll;
  List.Free;
end;
```

#### Get - Busca parâmetro por chave

```pascal
function Get(const AName: string): TParameter; overload;
function Get(const AName: string; out AParameter: TParameter): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Param: TParameter;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Param := DB.Get('database_host');
try
  if Assigned(Param) and (Param.Name <> '') then
    ShowMessage('Valor: ' + Param.Value)
  else
    ShowMessage('Não encontrado');
finally
  if Assigned(Param) then
    Param.Free;
end;
```

#### Insert - Insere novo parâmetro

```pascal
function Insert(const AParameter: TParameter): IParametersDatabase; overload;
function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Param: TParameter;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Param := TParameter.Create;
try
  Param.Name := 'api_timeout';
  Param.Value := '30';
  Param.ValueType := pvtInteger;
  Param.Description := 'Timeout da API';
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Ativo := True;
  
  DB.Insert(Param, Success);
  if Success then
    ShowMessage('Inserido!');
finally
  Param.Free;
end;
```

#### Update - Atualiza parâmetro existente

```pascal
function Update(const AParameter: TParameter): IParametersDatabase; overload;
function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Param: TParameter;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Param := DB.Get('api_timeout');
try
  if Assigned(Param) then
  begin
    Param.Value := '60';
    DB.Update(Param, Success);
    if Success then
      ShowMessage('Atualizado!');
  end;
finally
  if Assigned(Param) then
    Param.Free;
end;
```

#### Delete - Soft delete (marca como inativo)

```pascal
function Delete(const AName: string): IParametersDatabase; overload;
function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

DB.Delete('api_timeout', Success);
if Success then
  ShowMessage('Deletado!');
```

#### Exists - Verifica se parâmetro existe

```pascal
function Exists(const AName: string): Boolean; overload;
function Exists(const AName: string; out AExists: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Exists: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

if DB.Exists('api_timeout') then
  ShowMessage('Parâmetro existe');
```

### Utilitários

#### Count - Conta parâmetros ativos

```pascal
function Count: Integer; overload;
function Count(out ACount: Integer): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Count: Integer;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

DB.Count(Count);
ShowMessage(Format('Total: %d parâmetros', [Count]));
```

#### IsConnected - Verifica se está conectado

```pascal
function IsConnected: Boolean; overload;
function IsConnected(out AConnected: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Connected: Boolean;

DB := TParameters.NewDatabase;
// ... configuração ...

DB.IsConnected(Connected);
if Connected then
  ShowMessage('Conectado');
```

#### Connect - Conecta ao banco

```pascal
function Connect: IParametersDatabase; overload;
function Connect(out ASuccess: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Success: Boolean;

DB := TParameters.NewDatabase;
DB.Host('localhost')
  .Port(5432)
  .Database('mydb')
  .Username('postgres')
  .Password('pass')
  .Connect(Success);

if Success then
  ShowMessage('Conectado!');
```

#### Disconnect - Desconecta do banco

```pascal
function Disconnect: IParametersDatabase;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
// ... conexão e uso ...
DB.Disconnect;
```

#### Refresh - Renova dados do banco

```pascal
function Refresh: IParametersDatabase;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase;
// ... conexão ...
DB.Refresh; // Renova cache interno
```

### Gerenciamento de Tabela

#### TableExists - Verifica se tabela existe

```pascal
function TableExists: Boolean; overload;
function TableExists(out AExists: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Exists: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

DB.TableExists(Exists);
if Exists then
  ShowMessage('Tabela existe');
```

#### CreateTable - Cria tabela com estrutura padrão

```pascal
function CreateTable: IParametersDatabase; overload;
function CreateTable(out ASuccess: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

DB.CreateTable(Success);
if Success then
  ShowMessage('Tabela criada!');
```

#### DropTable - Remove tabela

```pascal
function DropTable: IParametersDatabase; overload;
function DropTable(out ASuccess: Boolean): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

DB.DropTable(Success);
if Success then
  ShowMessage('Tabela removida!');
```

### Listagem de Bancos e Tabelas

#### ListAvailableDatabases - Lista bancos disponíveis

```pascal
function ListAvailableDatabases: TStringList; overload;
function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Databases: TStringList;
var I: Integer;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Databases := DB.ListAvailableDatabases;
try
  for I := 0 to Databases.Count - 1 do
    ShowMessage(Databases[I]);
finally
  Databases.Free;
end;
```

#### ListAvailableTables - Lista tabelas disponíveis

```pascal
function ListAvailableTables: TStringList; overload;
function ListAvailableTables(out ATables: TStringList): IParametersDatabase; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Tables: TStringList;
var I: Integer;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Tables := DB.ListAvailableTables;
try
  for I := 0 to Tables.Count - 1 do
    ShowMessage(Tables[I]);
finally
  Tables.Free;
end;
```

### Configuração de Conexão Independente

#### Connection - Define conexão externa

```pascal
function Connection(AConnection: TObject): IParametersDatabase;
```

**Exemplo:**
```pascal
var MyConnection: TUniConnection;
var DB: IParametersDatabase;

// ... inicializa MyConnection ...
DB := TParameters.NewDatabase;
DB.Connection(MyConnection)
  .TableName('config');
```

#### Query - Define query para SELECT

```pascal
function Query(AQuery: TDataSet): IParametersDatabase;
```

**Exemplo:**
```pascal
var MyQuery: TUniQuery;
var DB: IParametersDatabase;

// ... inicializa MyQuery ...
DB := TParameters.NewDatabase;
DB.Query(MyQuery);
```

#### ExecQuery - Define query para INSERT/UPDATE/DELETE

```pascal
function ExecQuery(AExecQuery: TDataSet): IParametersDatabase;
```

**Exemplo:**
```pascal
var MyExecQuery: TUniQuery;
var DB: IParametersDatabase;

// ... inicializa MyExecQuery ...
DB := TParameters.NewDatabase;
DB.ExecQuery(MyExecQuery);
```

---

## 📄 Interface IParametersInifiles

Interface para acesso a parâmetros em arquivos INI.

### Configuração

#### FilePath - Define/obtém caminho do arquivo

```pascal
function FilePath(const AValue: string): IParametersInifiles; overload;
function FilePath: string; overload;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');
var FilePath: string;
FilePath := Ini.FilePath; // Retorna 'C:\Config\params.ini'
```

#### Section - Define/obtém seção

```pascal
function Section(const AValue: string): IParametersInifiles; overload;
function Section: string; overload;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles;
Ini.Section('Parameters');
```

#### AutoCreateFile - Define/obtém auto-criação de arquivo

```pascal
function AutoCreateFile(const AValue: Boolean): IParametersInifiles; overload;
function AutoCreateFile: Boolean; overload;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles;
Ini.AutoCreateFile(True); // Cria arquivo automaticamente se não existir
```

### Operações CRUD

Todas as operações CRUD são idênticas às do `IParametersDatabase`. Veja exemplos na seção anterior.

### Utilitários

#### FileExists - Verifica se arquivo existe

```pascal
function FileExists: Boolean; overload;
function FileExists(out AExists: Boolean): IParametersInifiles; overload;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
var Exists: Boolean;

Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');
Ini.FileExists(Exists);
if Exists then
  ShowMessage('Arquivo existe');
```

#### Refresh - Recarrega arquivo

```pascal
function Refresh: IParametersInifiles;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');
// ... uso ...
Ini.Refresh; // Recarrega do disco
```

### Importação/Exportação

#### ImportFromDatabase - Importa de Database

```pascal
function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;
function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Ini: IParametersInifiles;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');
Ini.ImportFromDatabase(DB, Success);
if Success then
  ShowMessage('Importado com sucesso!');
```

#### ExportToDatabase - Exporta para Database

```pascal
function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;
function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Ini: IParametersInifiles;
var Success: Boolean;

Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Ini.ExportToDatabase(DB, Success);
if Success then
  ShowMessage('Exportado com sucesso!');
```

---

## 📋 Interface IParametersJsonObject

Interface para acesso a parâmetros em objetos JSON.

### Configuração

#### JsonObject - Define/obtém objeto JSON

```pascal
function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject; overload;
function JsonObject: TJSONObject; overload;
```

**Exemplo:**
```pascal
var MyJson: TJSONObject;
var Json: IParametersJsonObject;

MyJson := TJSONObject.ParseJSONValue('{"ERP":{"host":"localhost"}}') as TJSONObject;
Json := TParameters.NewJsonObject;
Json.JsonObject(MyJson);
```

#### ObjectName - Define/obtém nome do objeto

```pascal
function ObjectName(const AValue: string): IParametersJsonObject; overload;
function ObjectName: string; overload;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObject;
Json.ObjectName('Parameters');
```

#### FilePath - Define/obtém caminho do arquivo

```pascal
function FilePath(const AValue: string): IParametersJsonObject; overload;
function FilePath: string; overload;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObject;
Json.FilePath('C:\Config\params.json');
```

### Operações CRUD

Todas as operações CRUD são idênticas às do `IParametersDatabase`. Veja exemplos na seção anterior.

### Utilitários Especiais

#### ToJSON - Retorna objeto JSON completo

```pascal
function ToJSON: TJSONObject;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
var JsonObj: TJSONObject;

Json := TParameters.NewJsonObject;
// ... uso ...
JsonObj := Json.ToJSON;
try
  ShowMessage(JsonObj.ToString);
finally
  JsonObj.Free;
end;
```

#### ToJSONString - Retorna JSON como string formatada

```pascal
function ToJSONString: string;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
var JsonString: string;

Json := TParameters.NewJsonObject;
// ... uso ...
JsonString := Json.ToJSONString;
ShowMessage(JsonString);
```

#### SaveToFile - Salva JSON em arquivo

```pascal
function SaveToFile(const AFilePath: string = ''): IParametersJsonObject; overload;
function SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject; overload;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
var Success: Boolean;

Json := TParameters.NewJsonObject;
// ... uso ...
Json.SaveToFile('C:\Config\params.json', Success);
if Success then
  ShowMessage('Salvo com sucesso!');
```

#### LoadFromFile - Carrega JSON de arquivo

```pascal
function LoadFromFile(const AFilePath: string = ''): IParametersJsonObject; overload;
function LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject; overload;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
var Success: Boolean;

Json := TParameters.NewJsonObject;
Json.LoadFromFile('C:\Config\params.json', Success);
if Success then
  ShowMessage('Carregado com sucesso!');
```

#### LoadFromString - Carrega JSON de string

```pascal
function LoadFromString(const AJsonString: string): IParametersJsonObject;
```

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
var JsonString: string;

JsonString := '{"ERP":{"host":"localhost","port":5432}}';
Json := TParameters.NewJsonObject;
Json.LoadFromString(JsonString);
```

### Importação/Exportação

#### ImportFromDatabase - Importa de Database

```pascal
function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject; overload;
function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Json: IParametersJsonObject;
var Success: Boolean;

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Json := TParameters.NewJsonObject;
Json.ImportFromDatabase(DB, Success);
if Success then
  ShowMessage('Importado com sucesso!');
```

#### ExportToDatabase - Exporta para Database

```pascal
function ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject; overload;
function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject; overload;
```

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Json: IParametersJsonObject;
var Success: Boolean;

Json := TParameters.NewJsonObject;
// ... uso ...

DB := TParameters.NewDatabase;
// ... configuração e conexão ...

Json.ExportToDatabase(DB, Success);
if Success then
  ShowMessage('Exportado com sucesso!');
```

#### ImportFromInifiles - Importa de INI

```pascal
function ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject; overload;
function ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject; overload;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
var Json: IParametersJsonObject;
var Success: Boolean;

Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');

Json := TParameters.NewJsonObject;
Json.ImportFromInifiles(Ini, Success);
if Success then
  ShowMessage('Importado com sucesso!');
```

#### ExportToInifiles - Exporta para INI

```pascal
function ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject; overload;
function ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject; overload;
```

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
var Json: IParametersJsonObject;
var Success: Boolean;

Json := TParameters.NewJsonObject;
// ... uso ...

Ini := TParameters.NewInifiles;
Ini.FilePath('C:\Config\params.ini');

Json.ExportToInifiles(Ini, Success);
if Success then
  ShowMessage('Exportado com sucesso!');
```

---

## 📊 Tipos e Estruturas

### TParameterValueType

Enum para tipos de valor:

```pascal
TParameterValueType = (
  pvtString,    // String
  pvtInteger,   // Integer
  pvtFloat,     // Float/Double
  pvtBoolean,   // Boolean
  pvtDateTime,  // DateTime
  pvtJSON       // JSON Object
);
```

### TParameterSource

Enum para fontes de dados:

```pascal
TParameterSource = (
  psDatabase,   // Banco de dados
  psInifiles,   // Arquivos INI
  psJsonObject  // Objetos JSON
);
```

### TParameterDatabaseEngine

Enum para engines de banco de dados:

```pascal
TParameterDatabaseEngine = (
  pteUnidac,    // UniDAC
  pteFireDAC,   // FireDAC
  pteZeos       // Zeos
);
```

### TParameterDatabaseTypes

Enum para tipos de banco de dados:

```pascal
TParameterDatabaseTypes = (
  pdtPostgreSQL,  // PostgreSQL
  pdtMySQL,       // MySQL
  pdtSQLServer,   // SQL Server
  pdtSQLite,      // SQLite
  pdtFireBird,    // FireBird
  pdtAccess,      // Microsoft Access
  pdtODBC         // ODBC
);
```

---

## 💡 Exemplos Práticos Completos

### Exemplo 1: Configuração Básica com Database

```pascal
uses Parameters;

procedure ConfigurarParametros;
var
  DB: IParametersDatabase;
  Param: TParameter;
  Success: Boolean;
begin
  // Cria instância
  DB := TParameters.NewDatabase;
  
  // Configura conexão
  DB.Engine('UniDAC')
    .DatabaseType('PostgreSQL')
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('mypassword')
    .TableName('config')
    .Schema('public')
    .AutoCreateTable(True)
    .Connect(Success);
  
  if not Success then
  begin
    ShowMessage('Erro ao conectar');
    Exit;
  end;
  
  // Insere parâmetro
  Param := TParameter.Create;
  try
    Param.Name := 'api_timeout';
    Param.Value := '30';
    Param.ValueType := pvtInteger;
    Param.Description := 'Timeout da API em segundos';
    Param.ContratoID := 1;
    Param.ProdutoID := 1;
    Param.Ativo := True;
    
    DB.Insert(Param, Success);
    if Success then
      ShowMessage('Parâmetro inserido!');
  finally
    Param.Free;
  end;
end;
```

### Exemplo 2: Múltiplas Fontes com Fallback

```pascal
uses Parameters;

procedure ConfigurarComFallback;
var
  Parameters: IParameters;
  Param: TParameter;
begin
  // Cria instância com Database e INI
  Parameters := TParameters.New([pcfDataBase, pcfInifile]);
  
  // Configura Database
  Parameters.Database
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('pass')
    .TableName('config')
    .Schema('public')
    .Connect;
  
  // Configura INI (fallback)
  Parameters.Inifiles
    .FilePath('C:\Config\params.ini')
    .Section('Parameters');
  
  // Define ordem de prioridade
  Parameters.Priority([psDatabase, psInifiles]);
  
  // Busca em cascata: Database → INI
  Param := Parameters.Get('database_host');
  try
    if Assigned(Param) then
      ShowMessage('Encontrado: ' + Param.Value)
    else
      ShowMessage('Não encontrado em nenhuma fonte');
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;
```

### Exemplo 3: Importação/Exportação

```pascal
uses Parameters;

procedure ImportarExportar;
var
  DB: IParametersDatabase;
  Ini: IParametersInifiles;
  Json: IParametersJsonObject;
  Success: Boolean;
begin
  // Cria instâncias
  DB := TParameters.NewDatabase;
  // ... configuração e conexão ...
  
  Ini := TParameters.NewInifiles;
  Ini.FilePath('C:\Config\params.ini');
  
  Json := TParameters.NewJsonObject;
  Json.FilePath('C:\Config\params.json');
  
  // Exporta Database → INI
  Ini.ExportToDatabase(DB, Success);
  if Success then
    ShowMessage('Exportado para INI!');
  
  // Importa INI → JSON
  Json.ImportFromInifiles(Ini, Success);
  if Success then
    ShowMessage('Importado para JSON!');
end;
```

### Exemplo 4: Sistema Multi-tenant

```pascal
uses Parameters;

procedure SistemaMultiTenant;
var
  Parameters: IParameters;
  Param: TParameter;
begin
  Parameters := TParameters.New([pcfDataBase]);
  Parameters.Database
    .Host('localhost')
    .Connect;
  
  // Define ContratoID e ProdutoID
  Parameters.ContratoID(1);
  Parameters.ProdutoID(2);
  
  // Todos os parâmetros serão filtrados por ContratoID=1 e ProdutoID=2
  Param := Parameters.Get('api_timeout');
  try
    if Assigned(Param) then
      ShowMessage(Format('Contrato %d, Produto %d: %s = %s', 
        [Param.ContratoID, Param.ProdutoID, Param.Name, Param.Value]));
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;
```

---

## ⚠️ Tratamento de Erros

O módulo lança exceções específicas para diferentes tipos de erro:

### EParametersException

Exceção base para todos os erros do módulo.

```pascal
try
  DB.Connect;
except
  on E: EParametersException do
    ShowMessage('Erro: ' + E.Message);
end;
```

### EParametersConnectionException

Erro de conexão com banco de dados.

```pascal
try
  DB.Connect;
except
  on E: EParametersConnectionException do
    ShowMessage('Erro de conexão: ' + E.Message);
end;
```

### EParametersSQLException

Erro em operação SQL.

```pascal
try
  DB.Insert(Param);
except
  on E: EParametersSQLException do
    ShowMessage('Erro SQL: ' + E.Message);
end;
```

### EParametersNotFoundException

Parâmetro não encontrado.

```pascal
var Param: TParameter;
try
  Param := DB.Get('inexistente');
  if not Assigned(Param) then
    raise EParametersNotFoundException.Create('Parâmetro não encontrado');
except
  on E: EParametersNotFoundException do
    ShowMessage('Não encontrado: ' + E.Message);
end;
```

---

## ✅ Boas Práticas

### 1. Sempre Libere Objetos TParameter

```pascal
var Param: TParameter;
Param := DB.Get('host');
try
  // Use Param
finally
  if Assigned(Param) then
    Param.Free;
end;
```

### 2. Sempre Libere TParameterList

```pascal
var List: TParameterList;
List := DB.List;
try
  // Use List
finally
  List.ClearAll;
  List.Free;
end;
```

### 3. Use Try-Except para Operações Críticas

```pascal
var Success: Boolean;
try
  DB.Connect(Success);
  if not Success then
    ShowMessage('Falha na conexão');
except
  on E: Exception do
    ShowMessage('Erro: ' + E.Message);
end;
```

### 4. Configure Fallback para Contingência

```pascal
// Sempre configure fallback para garantir disponibilidade
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Priority([psDatabase, psInifiles]);
```

### 5. Use Fluent Interface para Código Legível

```pascal
// Bom
DB.Host('localhost').Port(5432).Database('mydb').Connect;

// Evite
DB.Host('localhost');
DB.Port(5432);
DB.Database('mydb');
DB.Connect;
```

### 6. Valide Parâmetros Antes de Usar

```pascal
var Param: TParameter;
Param := DB.Get('host');
try
  if Assigned(Param) and (Param.Name <> '') then
  begin
    // Use Param
  end
  else
    ShowMessage('Parâmetro inválido');
finally
  if Assigned(Param) then
    Param.Free;
end;
```

---

## 📝 Conclusão

O **Módulo Parameters v1.0.0** oferece uma solução completa e flexível para gerenciamento de parâmetros de configuração, com suporte a múltiplas fontes de dados e fallback automático.

### Características Principais

- ✅ **Multi-fonte:** Database, INI, JSON
- ✅ **Fallback Automático:** Busca em cascata
- ✅ **Thread-safe:** Operações protegidas
- ✅ **Fluent Interface:** Código legível
- ✅ **Importação/Exportação:** Bidirecional

### Próximos Passos

1. Configure o módulo conforme suas necessidades
2. Teste com suas fontes de dados
3. Implemente fallback para contingência
4. Use os exemplos como referência

---

**Autor:** Claiton de Souza Linhares  
**Versão:** 1.0.0  
**Data:** 02/01/2026  
**Status:** ✅ Completo e Pronto para Uso

