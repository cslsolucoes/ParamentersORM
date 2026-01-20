# 📚 Parameters versão 1.0.2 - Documentação Completa

**Versão:** 1.0.2  
**Data de Criação:** 01/01/2026  
**Data de Atualização:** 02/01/2026  
**Status Geral:** ✅ **~99% COMPLETO** - Pronto para uso em produção (multithread)  
**Compatibilidade:** ✅ Delphi 10.3+ | ✅ FPC 3.2.2+ / Lazarus 4.4+

### 🔄 Mudanças na Versão 1.0.2

- ✅ **Nomenclatura:** `Get()` → `Getter()`, `Update()` → `Setter()` (métodos antigos mantidos como deprecated)
- ✅ **Hierarquia Completa:** Todos os métodos CRUD respeitam `ContratoID`, `ProdutoID`, `Title`, `Name` (constraint UNIQUE)
- ✅ **Compatibilidade:** Busca ampla quando hierarquia não está configurada (código legado)

---

## 📋 ÍNDICE

1. [Descrição Geral](#descrição-geral)
2. [Arquitetura](#arquitetura)
3. [Instalação e Configuração](#instalação-e-configuração)
4. [Documentação por Unit](#documentação-por-unit)
   - [Parameters.pas](#moduloparameterspas)
   - [Parameters.Intefaces.pas](#moduloparametersintefacespas)
   - [Parameters.Types.pas](#moduloparameterstypespas)
   - [Parameters.Consts.pas](#moduloparametersconstspas)
   - [Parameters.Exceptions.pas](#moduloparametersexceptionspas)
   - [Parameters.Database.pas](#moduloparametersdatabasepas)
   - [Parameters.Inifiles.pas](#moduloparametersinifilespas)
   - [Parameters.JsonObject.pas](#moduloparametersjsonobjectpas)
5. [Exemplos de Uso](#exemplos-de-uso)
6. [Tratamento de Erros](#tratamento-de-erros)
7. [FAQ](#faq)
8. [Compatibilidade FPC/Lazarus](#-compatibilidade-fpclazarus)
9. [Castle Engine (Opcional)](#-castle-engine-opcional)
10. [Estatísticas do Projeto](#-estatísticas-do-projeto)
11. [Documentação Adicional](#-documentação-adicional)

---

## 📋 DESCRIÇÃO GERAL

O **Parameters versão 1.0.1** é um sistema unificado de gerenciamento de parâmetros de configuração com suporte a múltiplas fontes de dados (Banco de Dados, Arquivos INI, Objetos JSON) e fallback automático para contingência.

### 🎯 Objetivo Principal

Centralizar o acesso a parâmetros de configuração do sistema, permitindo que o programa busque configurações de múltiplas fontes de forma transparente e unificada, com suporte a fallback automático quando uma fonte falha.

### ✨ Características Principais

- ✅ **Multi-fonte:** Suporte a Database, INI Files e JSON Objects
- ✅ **Fallback Automático:** Busca em cascata quando uma fonte falha
- ✅ **Multi-engine Database:** UNIDAC, FireDAC, Zeos
- ✅ **Multi-database:** PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC
- ✅ **Thread-safe:** Todas as operações protegidas com TCriticalSection
- ✅ **Fluent Interface:** Métodos encadeáveis para código mais legível
- ✅ **Importação/Exportação:** Bidirecional entre todas as fontes
- ✅ **Encapsulamento Total:** Apenas 2 arquivos públicos
- ✅ **Compatibilidade FPC/Lazarus:** Totalmente adaptado para Free Pascal Compiler e Lazarus IDE
- ✅ **Multi-plataforma:** Windows, Linux, macOS (com limitações específicas do Windows)

---

## 🏗️ ARQUITETURA

### Estrutura de Arquivos

```
📁 src/Modulo/

✅ ARQUIVOS PÚBLICOS (2 - Acessíveis externamente):
├── Parameters.pas              → Ponto de Entrada (Factory methods + TParametersImpl) [✅ 1.271 linhas]
└── Parameters.Intefaces.pas    → Interfaces Públicas [✅ 306 linhas]
    └──→ IParameters (interface principal de convergência)
    └──→ IParametersDatabase
    └──→ IParametersInifiles
    └──→ IParametersJsonObject
    └──→ Re-exporta tipos públicos (TParameter, TParameterList, etc.)

🔒 ARQUIVOS INTERNOS (6 - Apenas na seção implementation):
├── Parameters.Database.pas    → TParametersDatabase [✅ 4.912 linhas]
├── Parameters.Inifiles.pas    → TParametersInifiles [✅ 1.476 linhas]
├── Parameters.JsonObject.pas  → TParametersJsonObject [✅ 2.264 linhas]
├── Parameters.Types.pas        → Tipos (re-exportados via Interfaces) [✅ 374 linhas]
├── Parameters.Consts.pas       → Constantes [✅ 497 linhas]
└── Parameters.Exceptions.pas   → Exceções customizadas [✅ 567 linhas]
```

### Fluxo de Dados

```
Aplicação
    ↓
Parameters (IParameters)
    ↓
    ├──→ IParametersDatabase (Banco de Dados)
    ├──→ IParametersInifiles (Arquivos INI)
    └──→ IParametersJsonObject (JSON Objects)
```

### Princípios de Design

- **Encapsulamento:** Apenas `Parameters.pas` e `Parameters.Intefaces.pas` são públicos
- **Independência:** Não depende de `ProvidersORM.DataModule` ou `Common.Types`
- **Factory Pattern:** Factory class `TParameters` cria instâncias
- **Fluent Interface:** Métodos encadeáveis para código mais legível

---

## 🔧 INSTALAÇÃO E CONFIGURAÇÃO

### Requisitos

#### Para Delphi
- Delphi 10.3+ (RAD Studio)
- Um dos engines de banco de dados: UNIDAC, FireDAC ou Zeos
- Units do projeto no path de busca

#### Para FPC/Lazarus
- Free Pascal Compiler (FPC) 3.2.2 ou superior
- Lazarus IDE 2.0+ (recomendado)
- Zeos Library (recomendado) ou UniDAC (se tiver licença)
- **Nota:** FireDAC não está disponível no FPC

### Configuração Inicial

1. **Adicione ao uses:**
```pascal
uses Parameters;
```

2. **Configure o engine de banco de dados** em `ParamentersORM.Defines.inc`:
```pascal
{$DEFINE USE_UNIDAC}  // ou USE_FIREDAC ou USE_ZEOS
```

3. **Configure constantes de conexão** em `ParamentersORM.Database.inc`:
```pascal
DEFAULT_PARAMETERS_HOST = 'localhost';
DEFAULT_PARAMETERS_PORT = 5432;
DEFAULT_PARAMETERS_DATABASE = 'mydb';
// ... outras constantes
```

---

## 📦 DOCUMENTAÇÃO POR UNIT

### Parameters.pas

**Tipo:** Público (Ponto de Entrada)  
**Linhas:** 1.271  
**Responsabilidade:** Factory methods e implementação de IParameters

#### Factory Class: TParameters

##### Métodos Estáticos

###### `class function New: IParameters; overload;`
Cria nova instância de IParameters com configuração padrão (apenas Database).

**Retorno:** `IParameters` - Interface unificada configurada

**Exemplo:**
```pascal
var Parameters: IParameters;
Parameters := TParameters.New;
Parameters.Database.Host('localhost').Connect;
```

---

###### `class function New(AConfig: TParameterConfig): IParameters; overload;`
Cria nova instância de IParameters com configuração de fontes especificada.

**Parâmetros:**
- `AConfig: TParameterConfig` - Set de opções: `[pcfDataBase, pcfInifile, pcfJsonObject]`

**Retorno:** `IParameters` - Interface unificada configurada

**Exemplo:**
```pascal
var Parameters: IParameters;
// Database com fallback para INI
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Database.Host('localhost').Connect;
Parameters.Inifiles.FilePath('config.ini');
```

---

###### `class function NewDatabase: IParametersDatabase; overload;`
Cria nova instância de IParametersDatabase (conexão interna automática).

**Retorno:** `IParametersDatabase` - Interface de acesso a banco de dados

**Exemplo:**
```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase
  .Host('localhost')
  .Database('mydb')
  .Connect;
```

---

###### `class function NewDatabase(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil): IParametersDatabase; overload;`
Cria instância usando conexão e queries existentes.

**Parâmetros:**
- `AConnection: TObject` - Conexão existente (TUniConnection, TFDConnection ou TZConnection)
- `AQuery: TDataSet` (opcional) - Query para SELECT
- `AExecQuery: TDataSet` (opcional) - Query para INSERT/UPDATE/DELETE

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
var MyConnection: TUniConnection;
var MyQuery: TUniQuery;
// ... inicializa MyConnection e MyQuery ...
DB := TParameters.NewDatabase(MyConnection, MyQuery);
```

---

###### `class function NewInifiles: IParametersInifiles; overload;`
Cria nova instância de IParametersInifiles com valores padrão.

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles
  .FilePath('C:\Config\params.ini')
  .Section('Parameters');
```

---

###### `class function NewInifiles(const AFilePath: string): IParametersInifiles; overload;`
Cria instância já configurada com caminho do arquivo.

**Parâmetros:**
- `AFilePath: string` - Caminho completo do arquivo INI

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
Ini := TParameters.NewInifiles('C:\Config\params.ini');
```

---

###### `class function NewJsonObject: IParametersJsonObject; overload;`
Cria nova instância com objeto JSON vazio.

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObject
  .FilePath('C:\Config\params.json');
```

---

###### `class function NewJsonObject(AJsonObject: TJSONObject): IParametersJsonObject; overload;`
Cria instância usando objeto JSON existente.

**Parâmetros:**
- `AJsonObject: TJSONObject` - Objeto JSON existente

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
var MyJson: TJSONObject;
MyJson := TJSONObject.ParseJSONValue('{"ERP":{"host":"localhost"}}') as TJSONObject;
Json := TParameters.NewJsonObject(MyJson);
```

---

###### `class function NewJsonObject(const AJsonString: string): IParametersJsonObject; overload;`
Cria instância parseando uma string JSON.

**Parâmetros:**
- `AJsonString: string` - String contendo JSON válido

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json := TParameters.NewJsonObject('{"ERP":{"host":"localhost","port":5432}}');
```

---

###### `class function NewJsonObjectFromFile(const AFilePath: string): IParametersJsonObject;`
Cria instância carregando JSON de um arquivo.

**Parâmetros:**
- `AFilePath: string` - Caminho completo do arquivo JSON

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json := TParameters.NewJsonObjectFromFile('C:\Config\params.json');
List := Json.List; // JSON já está carregado
```

---

###### `class function DetectEngine: TParameterDatabaseEngine;`
Detecta automaticamente qual engine está disponível baseado nas diretivas de compilação.

**Retorno:** `TParameterDatabaseEngine` (pteUnidac, pteFireDAC, pteZeos ou pteNone)

**Exemplo:**
```pascal
var Engine: TParameterDatabaseEngine;
Engine := TParameters.DetectEngine;
case Engine of
  pteUnidac: ShowMessage('UNIDAC detectado');
  pteFireDAC: ShowMessage('FireDAC detectado');
  pteZeos: ShowMessage('Zeos detectado');
end;
```

---

###### `class function DetectEngineName: string;`
Retorna o nome do engine detectado como string.

**Retorno:** `string` - Nome do engine ('UniDAC', 'FireDAC', 'Zeos' ou 'None')

**Exemplo:**
```pascal
var EngineName: string;
EngineName := TParameters.DetectEngineName;
ShowMessage('Engine: ' + EngineName);
```

---

#### Implementação: TParametersImpl

Classe encapsulada na seção `implementation` que implementa `IParameters`. Não é acessível externamente.

**Campos Privados:**
- `FDatabase: IParametersDatabase`
- `FInifiles: IParametersInifiles`
- `FJsonObject: IParametersJsonObject`
- `FActiveSource: TParameterSource`
- `FPriority: TParameterSourceArray`
- `FConfig: TParameterConfig`
- `FContratoID: Integer`
- `FProdutoID: Integer`
- `FLock: TCriticalSection`

---

### Parameters.Intefaces.pas

**Tipo:** Público (Interfaces e Tipos)  
**Linhas:** 306  
**Responsabilidade:** Define todas as interfaces públicas e re-exporta tipos

#### Interface: IParameters

Interface principal de convergência que gerencia múltiplas fontes de dados com fallback automático.

##### Gerenciamento de Fontes

###### `function Source(ASource: TParameterSource): IParameters; overload;`
Define a fonte ativa para operações de escrita.

**Parâmetros:**
- `ASource: TParameterSource` - Fonte a ser ativada (psDatabase, psInifiles, psJsonObject)

**Retorno:** `IParameters` (fluent interface)

**Exemplo:**
```pascal
Parameters.Source(psDatabase); // Define Database como fonte ativa
```

---

###### `function Source: TParameterSource; overload;`
Retorna a fonte ativa atual.

**Retorno:** `TParameterSource`

**Exemplo:**
```pascal
var CurrentSource: TParameterSource;
CurrentSource := Parameters.Source;
```

---

###### `function AddSource(ASource: TParameterSource): IParameters;`
Adiciona uma fonte à lista de fontes ativas.

**Parâmetros:**
- `ASource: TParameterSource` - Fonte a ser adicionada

**Retorno:** `IParameters`

**Exemplo:**
```pascal
Parameters.AddSource(psInifiles); // Adiciona INI como fonte adicional
```

---

###### `function RemoveSource(ASource: TParameterSource): IParameters;`
Remove uma fonte da lista de fontes ativas.

**Parâmetros:**
- `ASource: TParameterSource` - Fonte a ser removida

**Retorno:** `IParameters`

**Exemplo:**
```pascal
Parameters.RemoveSource(psDatabase); // Remove Database das fontes ativas
```

---

###### `function HasSource(ASource: TParameterSource): Boolean;`
Verifica se uma fonte está ativa.

**Parâmetros:**
- `ASource: TParameterSource` - Fonte a verificar

**Retorno:** `Boolean`

**Exemplo:**
```pascal
if Parameters.HasSource(psDatabase) then
  ShowMessage('Database está ativo');
```

---

###### `function Priority(ASources: TParameterSourceArray): IParameters;`
Define a ordem de prioridade para fallback automático.

**Parâmetros:**
- `ASources: TParameterSourceArray` - Array com ordem de prioridade

**Retorno:** `IParameters`

**Exemplo:**
```pascal
Parameters.Priority([psDatabase, psInifiles, psJsonObject]);
// Busca primeiro no Database, depois INI, depois JSON
```

---

##### Operações Unificadas (com Fallback)

###### `function Getter(const AName: string): TParameter; overload;`
Busca parâmetro em cascata (Database → INI → JSON) até encontrar.

**IMPORTANTE:** Respeita a hierarquia completa da constraint UNIQUE: `ContratoID`, `ProdutoID`, `Title`, `Name`. Se esses campos estiverem configurados, faz busca específica; caso contrário, faz busca ampla (compatibilidade com código legado).

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro

**Retorno:** `TParameter` ou `nil` se não encontrado

**Exemplo com hierarquia completa:**
```pascal
var Param: TParameter;
Parameters
  .ContratoID(1)
  .ProdutoID(1)
  .Database.Title('ERP')
  .Getter('database_host', Param);
if Assigned(Param) then
  ShowMessage(Param.Value)
else
  ShowMessage('Não encontrado em nenhuma fonte');
Param.Free;
```

**Exemplo sem hierarquia (busca ampla - compatibilidade):**
```pascal
var Param: TParameter;
Param := Parameters.Getter('database_host');
if Assigned(Param) then
  ShowMessage(Param.Value);
Param.Free;
```

**Nota:** O método `Get()` está deprecated. Use `Getter()`.

---

###### `function Getter(const AName: string; ASource: TParameterSource): TParameter; overload;`
Busca parâmetro em fonte específica.

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro
- `ASource: TParameterSource` - Fonte específica para buscar

**Retorno:** `TParameter` ou `nil`

**Exemplo:**
```pascal
Param := Parameters.Getter('database_host', psDatabase); // Busca apenas no Database
```

---

###### `function List: TParameterList; overload;`
Lista todos os parâmetros de todas as fontes ativas (merge, remove duplicatas).

**Retorno:** `TParameterList`

**Exemplo:**
```pascal
var List: TParameterList;
List := Parameters.List;
try
  for var I := 0 to List.Count - 1 do
    ShowMessage(List[I].Name + ' = ' + List[I].Value);
finally
  List.Free;
end;
```

---

###### `function List(out AList: TParameterList): IParameters; overload;`
Versão com parâmetro `out` para fluent interface.

**Parâmetros:**
- `out AList: TParameterList` - Lista preenchida com parâmetros

**Retorno:** `IParameters`

**Exemplo:**
```pascal
var List: TParameterList;
Parameters.List(List);
try
  // Usa List...
finally
  List.Free;
end;
```

---

###### `function Insert(const AParameter: TParameter): IParameters; overload;`
Insere parâmetro na fonte ativa (default: Database, fallback para primeira disponível).

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a ser inserido

**Retorno:** `IParameters`

**Exemplo:**
```pascal
var Param: TParameter;
Param := TParameter.Create;
Param.Name := 'teste_key';
Param.Value := 'teste_value';
Param.ValueType := pvtString;
Parameters.Insert(Param);
Param.Free;
```

---

###### `function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a ser inserido
- `out ASuccess: Boolean` - True se inserido com sucesso

**Retorno:** `IParameters`

**Exemplo:**
```pascal
var Success: Boolean;
Parameters.Insert(Param, Success);
if Success then
  ShowMessage('Inserido com sucesso!');
```

---

###### `function Update(const AParameter: TParameter): IParameters; overload;`
Atualiza parâmetro na fonte onde ele existe.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a ser atualizado

**Retorno:** `IParameters`

**Exemplo (deprecated - usar Setter):**
```pascal
Param := Parameters.Getter('database_host');
if Assigned(Param) then
begin
  Param.Value := 'new_host';
  Parameters.Setter(Param); // Insere se não existir, atualiza se existir
end;
Param.Free;
```

---

###### `function Update(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a ser atualizado
- `out ASuccess: Boolean` - True se atualizado com sucesso

**Retorno:** `IParameters`

---

###### `function Delete(const AName: string): IParameters; overload;`
Deleta parâmetro de todas as fontes onde existe.

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro

**Retorno:** `IParameters`

**Exemplo:**
```pascal
Parameters.Delete('database_host'); // Deleta de Database, INI e JSON se existir
```

---

###### `function Delete(const AName: string; out ASuccess: Boolean): IParameters; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro
- `out ASuccess: Boolean` - True se deletado de pelo menos uma fonte

**Retorno:** `IParameters`

---

###### `function Exists(const AName: string): Boolean; overload;`
Verifica se parâmetro existe em qualquer fonte (OR lógico).

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro

**Retorno:** `Boolean` - True se existe em qualquer fonte

**Exemplo:**
```pascal
if Parameters.Exists('database_host') then
  ShowMessage('Parâmetro existe!');
```

---

###### `function Exists(const AName: string; out AExists: Boolean): IParameters; overload;`
Versão com parâmetro `out` para fluent interface.

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro
- `out AExists: Boolean` - True se existe

**Retorno:** `IParameters`

---

###### `function Count: Integer; overload;`
Conta parâmetros únicos de todas as fontes (remove duplicatas por Name).

**Retorno:** `Integer` - Número de parâmetros únicos

**Exemplo:**
```pascal
var Total: Integer;
Total := Parameters.Count;
ShowMessage(Format('Total de parâmetros: %d', [Total]));
```

---

###### `function Count(out ACount: Integer): IParameters; overload;`
Versão com parâmetro `out` para fluent interface.

**Parâmetros:**
- `out ACount: Integer` - Contagem de parâmetros únicos

**Retorno:** `IParameters`

---

###### `function Refresh: IParameters;`
Recarrega dados de todas as fontes ativas.

**Retorno:** `IParameters`

**Exemplo:**
```pascal
Parameters.Refresh; // Recarrega Database, INI e JSON
```

---

##### Configuração Unificada

###### `function ContratoID(const AValue: Integer): IParameters; overload;`
Aplica ContratoID em todas as fontes ativas.

**Parâmetros:**
- `AValue: Integer` - ID do contrato

**Retorno:** `IParameters`

**Exemplo:**
```pascal
Parameters.ContratoID(1); // Aplica em Database, INI e JSON
```

---

###### `function ContratoID: Integer; overload;`
Retorna ContratoID atual.

**Retorno:** `Integer`

---

###### `function ProdutoID(const AValue: Integer): IParameters; overload;`
Aplica ProdutoID em todas as fontes ativas.

**Parâmetros:**
- `AValue: Integer` - ID do produto

**Retorno:** `IParameters`

---

###### `function ProdutoID: Integer; overload;`
Retorna ProdutoID atual.

**Retorno:** `Integer`

---

##### Acesso Direto a Fontes

###### `function Database: IParametersDatabase;`
Retorna interface Database para métodos exclusivos.

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
Parameters.Database
  .Host('localhost')
  .Port(5432)
  .Connect; // Métodos exclusivos do Database
```

---

###### `function Inifiles: IParametersInifiles;`
Retorna interface Inifiles para métodos exclusivos.

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
Parameters.Inifiles
  .FilePath('config.ini')
  .Section('Database'); // Métodos exclusivos do INI
```

---

###### `function JsonObject: IParametersJsonObject;`
Retorna interface JsonObject para métodos exclusivos.

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Parameters.JsonObject
  .FilePath('config.json')
  .ObjectName('Database'); // Métodos exclusivos do JSON
```

---

#### Interface: IParametersDatabase

Interface para acesso a parâmetros em banco de dados.

##### Configuração (Fluent Interface)

###### `function TableName(const AValue: string): IParametersDatabase; overload;`
Define nome da tabela.

**Parâmetros:**
- `AValue: string` - Nome da tabela

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.TableName('config');
```

---

###### `function TableName: string; overload;`
Retorna nome da tabela atual.

**Retorno:** `string`

---

###### `function Schema(const AValue: string): IParametersDatabase; overload;`
Define schema do banco.

**Parâmetros:**
- `AValue: string` - Nome do schema

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Schema('public');
```

---

###### `function Schema: string; overload;`
Retorna schema atual.

**Retorno:** `string`

---

###### `function AutoCreateTable(const AValue: Boolean): IParametersDatabase; overload;`
Define se deve criar tabela automaticamente se não existir.

**Parâmetros:**
- `AValue: Boolean` - True para criar automaticamente

**Retorno:** `IParametersDatabase`

---

###### `function AutoCreateTable: Boolean; overload;`
Retorna se auto-criação está ativa.

**Retorno:** `Boolean`

---

##### Configuração de Conexão

###### `function Engine(const AValue: string): IParametersDatabase; overload;`
Define engine por string ('UniDAC', 'FireDAC', 'Zeos').

**Parâmetros:**
- `AValue: string` - Nome do engine

**Retorno:** `IParametersDatabase`

---

###### `function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase; overload;`
Define engine por enum.

**Parâmetros:**
- `AValue: TParameterDatabaseEngine` - Enum do engine

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Engine(pteUnidac);
```

---

###### `function Engine: string; overload;`
Retorna nome do engine atual.

**Retorno:** `string`

---

###### `function DatabaseType(const AValue: string): IParametersDatabase; overload;`
Define tipo de banco por string ('PostgreSQL', 'MySQL', etc.).

**Parâmetros:**
- `AValue: string` - Nome do tipo de banco

**Retorno:** `IParametersDatabase`

---

###### `function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase; overload;`
Define tipo de banco por enum.

**Parâmetros:**
- `AValue: TParameterDatabaseTypes` - Enum do tipo de banco

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.DatabaseType(pdtPostgreSQL);
```

---

###### `function DatabaseType: string; overload;`
Retorna tipo de banco atual.

**Retorno:** `string`

---

###### `function Host(const AValue: string): IParametersDatabase; overload;`
Define host do servidor.

**Parâmetros:**
- `AValue: string` - Endereço do host

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Host('localhost');
```

---

###### `function Host: string; overload;`
Retorna host atual.

**Retorno:** `string`

---

###### `function Port(const AValue: Integer): IParametersDatabase; overload;`
Define porta do servidor.

**Parâmetros:**
- `AValue: Integer` - Número da porta

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Port(5432);
```

---

###### `function Port: Integer; overload;`
Retorna porta atual.

**Retorno:** `Integer`

---

###### `function Username(const AValue: string): IParametersDatabase; overload;`
Define usuário do banco.

**Parâmetros:**
- `AValue: string` - Nome do usuário

**Retorno:** `IParametersDatabase`

---

###### `function Username: string; overload;`
Retorna usuário atual.

**Retorno:** `string`

---

###### `function Password(const AValue: string): IParametersDatabase; overload;`
Define senha do banco.

**Parâmetros:**
- `AValue: string` - Senha

**Retorno:** `IParametersDatabase`

---

###### `function Password: string; overload;`
Retorna senha atual (⚠️ apenas para leitura, não armazena em texto plano).

**Retorno:** `string`

---

###### `function Database(const AValue: string): IParametersDatabase; overload;`
Define nome do banco de dados.

**Parâmetros:**
- `AValue: string` - Nome do banco

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Database('mydb');
```

---

###### `function Database: string; overload;`
Retorna nome do banco atual.

**Retorno:** `string`

---

###### `function ContratoID(const AValue: Integer): IParametersDatabase; overload;`
Define filtro de ContratoID.

**Parâmetros:**
- `AValue: Integer` - ID do contrato

**Retorno:** `IParametersDatabase`

---

###### `function ContratoID: Integer; overload;`
Retorna ContratoID atual.

**Retorno:** `Integer`

---

###### `function ProdutoID(const AValue: Integer): IParametersDatabase; overload;`
Define filtro de ProdutoID.

**Parâmetros:**
- `AValue: Integer` - ID do produto

**Retorno:** `IParametersDatabase`

---

###### `function ProdutoID: Integer; overload;`
Retorna ProdutoID atual.

**Retorno:** `Integer`

---

##### CRUD

###### `function List: TParameterList; overload;`
Lista todos os parâmetros ativos da tabela.

**Retorno:** `TParameterList`

**Exemplo:**
```pascal
var List: TParameterList;
List := DB.List;
try
  for var I := 0 to List.Count - 1 do
    ShowMessage(List[I].Name + ' = ' + List[I].Value);
finally
  List.Free;
end;
```

---

###### `function List(out AList: TParameterList): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `out AList: TParameterList` - Lista preenchida

**Retorno:** `IParametersDatabase`

---

###### `function Getter(const AName: string): TParameter; overload;`
Busca parâmetro por chave respeitando a hierarquia completa: `ContratoID`, `ProdutoID`, `Title`, `Name`.

**IMPORTANTE:** Se `ContratoID`, `ProdutoID` e `Title` estiverem configurados, faz busca específica usando a hierarquia completa. Caso contrário, faz busca ampla apenas por chave (compatibilidade com código legado).

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro

**Retorno:** `TParameter` ou `nil`

**Exemplo com hierarquia completa:**
```pascal
var Param: TParameter;
DB.ContratoID(1).ProdutoID(1).Title('ERP').Getter('database_host', Param);
if Assigned(Param) then
  ShowMessage(Param.Value);
Param.Free;
```

**Exemplo sem hierarquia (busca ampla - compatibilidade):**
```pascal
var Param: TParameter;
Param := DB.Getter('database_host');
if Assigned(Param) then
  ShowMessage(Param.Value);
Param.Free;
```

**Nota:** O método `Get()` está deprecated. Use `Getter()`.

---

###### `function Getter(const AName: string; out AParameter: TParameter): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `AName: string` - Nome/chave
- `out AParameter: TParameter` - Parâmetro encontrado

**Retorno:** `IParametersDatabase`

---

###### `function Insert(const AParameter: TParameter): IParametersDatabase; overload;`
Insere novo parâmetro na tabela.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a inserir

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
var Param: TParameter;
Param := TParameter.Create;
Param.Name := 'teste_key';
Param.Value := 'teste_value';
Param.ValueType := pvtString;
Param.ContratoID := 1;
Param.ProdutoID := 1;
DB.Insert(Param);
Param.Free;
```

---

###### `function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a inserir
- `out ASuccess: Boolean` - True se inserido

**Retorno:** `IParametersDatabase`

---

###### `function Setter(const AParameter: TParameter): IParametersDatabase; overload;`
Insere ou atualiza um parâmetro (INSERT se não existir, UPDATE se existir).

**IMPORTANTE:** Sempre respeita a hierarquia completa da constraint UNIQUE: `ContratoID`, `ProdutoID`, `Title`, `Name`. O parâmetro deve ter todos esses campos preenchidos.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a ser inserido/atualizado (deve ter ContratoID, ProdutoID, Titulo e Name preenchidos)

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
var Param: TParameter;
Param := TParameter.Create;
try
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Titulo := 'ERP';
  Param.Name := 'database_host';
  Param.Value := 'new_host';
  Param.ValueType := pvtString;
  DB.Setter(Param); // Insere se não existir, atualiza se existir
finally
  Param.Free;
end;
```

---

###### `function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AParameter: TParameter` - Parâmetro a ser inserido/atualizado
- `out ASuccess: Boolean` - True se operação foi bem-sucedida

**Retorno:** `IParametersDatabase`

**Nota:** O método `Update()` está deprecated. Use `Setter()`.

---

###### `function Delete(const AName: string): IParametersDatabase; overload;`
Soft delete (marca como inativo).

**Parâmetros:**
- `AName: string` - Nome/chave do parâmetro

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Delete('database_host'); // Marca como inativo
```

---

###### `function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AName: string` - Nome/chave
- `out ASuccess: Boolean` - True se deletado

**Retorno:** `IParametersDatabase`

---

###### `function Exists(const AName: string): Boolean; overload;`
Verifica se parâmetro existe na tabela.

**Parâmetros:**
- `AName: string` - Nome/chave

**Retorno:** `Boolean`

**Exemplo:**
```pascal
if DB.Exists('database_host') then
  ShowMessage('Parâmetro existe!');
```

---

###### `function Exists(const AName: string; out AExists: Boolean): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `AName: string` - Nome/chave
- `out AExists: Boolean` - True se existe

**Retorno:** `IParametersDatabase`

---

##### Utilitários

###### `function Count: Integer; overload;`
Conta parâmetros ativos na tabela.

**Retorno:** `Integer`

**Exemplo:**
```pascal
var Total: Integer;
Total := DB.Count;
ShowMessage(Format('Total: %d parâmetros', [Total]));
```

---

###### `function Count(out ACount: Integer): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `out ACount: Integer` - Contagem

**Retorno:** `IParametersDatabase`

---

###### `function IsConnected: Boolean; overload;`
Verifica se está conectado ao banco.

**Retorno:** `Boolean`

**Exemplo:**
```pascal
if DB.IsConnected then
  ShowMessage('Conectado!');
```

---

###### `function IsConnected(out AConnected: Boolean): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `out AConnected: Boolean` - True se conectado

**Retorno:** `IParametersDatabase`

---

###### `function Connect: IParametersDatabase; overload;`
Conecta ao banco de dados.

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Connect; // Lança exceção se falhar
```

---

###### `function Connect(out ASuccess: Boolean): IParametersDatabase; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `out ASuccess: Boolean` - True se conectado

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
var Success: Boolean;
DB.Connect(Success);
if not Success then
  ShowMessage('Falha ao conectar');
```

---

###### `function Disconnect: IParametersDatabase;`
Desconecta do banco de dados.

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.Disconnect;
```

---

###### `function Refresh: IParametersDatabase;`
Recarrega dados da tabela.

**Retorno:** `IParametersDatabase`

---

##### Gerenciamento de Tabela

###### `function TableExists: Boolean; overload;`
Verifica se a tabela existe.

**Retorno:** `Boolean`

**Exemplo:**
```pascal
if not DB.TableExists then
  DB.CreateTable;
```

---

###### `function TableExists(out AExists: Boolean): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `out AExists: Boolean` - True se existe

**Retorno:** `IParametersDatabase`

---

###### `function CreateTable: IParametersDatabase; overload;`
Cria a tabela com estrutura padrão.

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.CreateTable; // Cria tabela se não existir
```

---

###### `function CreateTable(out ASuccess: Boolean): IParametersDatabase; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `out ASuccess: Boolean` - True se criada

**Retorno:** `IParametersDatabase`

---

###### `function DropTable: IParametersDatabase; overload;`
Remove a tabela do banco.

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
DB.DropTable; // ⚠️ CUIDADO: Remove todos os dados!
```

---

###### `function DropTable(out ASuccess: Boolean): IParametersDatabase; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `out ASuccess: Boolean` - True se removida

**Retorno:** `IParametersDatabase`

---

##### Listagem

###### `function ListAvailableDatabases: TStringList; overload;`
Lista bancos de dados disponíveis no servidor.

**Retorno:** `TStringList` - Lista de nomes de bancos

**Exemplo:**
```pascal
var Databases: TStringList;
Databases := DB.ListAvailableDatabases;
try
  for var I := 0 to Databases.Count - 1 do
    ShowMessage(Databases[I]);
finally
  Databases.Free;
end;
```

---

###### `function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `out ADatabases: TStringList` - Lista preenchida

**Retorno:** `IParametersDatabase`

---

###### `function ListAvailableTables: TStringList; overload;`
Lista tabelas disponíveis no banco/schema.

**Retorno:** `TStringList` - Lista de nomes de tabelas

**Exemplo:**
```pascal
var Tables: TStringList;
Tables := DB.ListAvailableTables;
try
  for var I := 0 to Tables.Count - 1 do
    ShowMessage(Tables[I]);
finally
  Tables.Free;
end;
```

---

###### `function ListAvailableTables(out ATables: TStringList): IParametersDatabase; overload;`
Versão com parâmetro `out`.

**Parâmetros:**
- `out ATables: TStringList` - Lista preenchida

**Retorno:** `IParametersDatabase`

---

##### Configuração de Conexão (Independente)

###### `function Connection(AConnection: TObject): IParametersDatabase; overload;`
Define conexão externa existente.

**Parâmetros:**
- `AConnection: TObject` - Conexão (TUniConnection, TFDConnection ou TZConnection)

**Retorno:** `IParametersDatabase`

**Exemplo:**
```pascal
var MyConnection: TUniConnection;
// ... inicializa MyConnection ...
DB.Connection(MyConnection);
```

---

###### `function Query(AQuery: TDataSet): IParametersDatabase; overload;`
Define query externa para operações SELECT.

**Parâmetros:**
- `AQuery: TDataSet` - Query (TUniQuery, TFDQuery ou TZQuery)

**Retorno:** `IParametersDatabase`

---

###### `function ExecQuery(AExecQuery: TDataSet): IParametersDatabase; overload;`
Define query externa para operações INSERT/UPDATE/DELETE.

**Parâmetros:**
- `AExecQuery: TDataSet` - Query para execução

**Retorno:** `IParametersDatabase`

---

#### Interface: IParametersInifiles

Interface para acesso a parâmetros em arquivos INI.

##### Configuração (Fluent Interface)

###### `function FilePath(const AValue: string): IParametersInifiles; overload;`
Define caminho do arquivo INI.

**Parâmetros:**
- `AValue: string` - Caminho completo do arquivo

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
Ini.FilePath('C:\Config\params.ini');
```

---

###### `function FilePath: string; overload;`
Retorna caminho atual.

**Retorno:** `string`

---

###### `function Section(const AValue: string): IParametersInifiles; overload;`
Define seção (título) do INI.

**Parâmetros:**
- `AValue: string` - Nome da seção

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
Ini.Section('Database');
```

---

###### `function Section: string; overload;`
Retorna seção atual.

**Retorno:** `string`

---

###### `function AutoCreateFile(const AValue: Boolean): IParametersInifiles; overload;`
Define se deve criar arquivo automaticamente.

**Parâmetros:**
- `AValue: Boolean` - True para criar automaticamente

**Retorno:** `IParametersInifiles`

---

###### `function AutoCreateFile: Boolean; overload;`
Retorna se auto-criação está ativa.

**Retorno:** `Boolean`

---

###### `function ContratoID(const AValue: Integer): IParametersInifiles; overload;`
Define filtro de ContratoID.

**Parâmetros:**
- `AValue: Integer` - ID do contrato

**Retorno:** `IParametersInifiles`

---

###### `function ContratoID: Integer; overload;`
Retorna ContratoID atual.

**Retorno:** `Integer`

---

###### `function ProdutoID(const AValue: Integer): IParametersInifiles; overload;`
Define filtro de ProdutoID.

**Parâmetros:**
- `AValue: Integer` - ID do produto

**Retorno:** `IParametersInifiles`

---

###### `function ProdutoID: Integer; overload;`
Retorna ProdutoID atual.

**Retorno:** `Integer`

---

##### CRUD

Todos os métodos CRUD seguem o mesmo padrão de `IParametersDatabase`:

- `List()` / `List(out AList)`
- `Get(AName)` / `Get(AName, out AParameter)`
- `Insert(AParameter)` / `Insert(AParameter, out ASuccess)`
- `Update(AParameter)` / `Update(AParameter, out ASuccess)`
- `Delete(AName)` / `Delete(AName, out ASuccess)`
- `Exists(AName)` / `Exists(AName, out AExists)`

**Exemplo:**
```pascal
var Ini: IParametersInifiles;
Ini := TParameters.NewInifiles('C:\Config\params.ini')
  .ContratoID(1)
  .ProdutoID(1)
  .Title('ERP');
var Param: TParameter;
Ini.Getter('database_host', Param);
if Assigned(Param) then
  ShowMessage(Param.Value);
Param.Free;
```

---

##### Utilitários

###### `function Count: Integer; overload;`
Conta parâmetros no arquivo INI.

**Retorno:** `Integer`

---

###### `function Count(out ACount: Integer): IParametersInifiles; overload;`
Versão com parâmetro `out`.

---

###### `function FileExists: Boolean; overload;`
Verifica se o arquivo INI existe.

**Retorno:** `Boolean`

**Exemplo:**
```pascal
if Ini.FileExists then
  ShowMessage('Arquivo existe!');
```

---

###### `function FileExists(out AExists: Boolean): IParametersInifiles; overload;`
Versão com parâmetro `out`.

---

###### `function Refresh: IParametersInifiles;`
Recarrega arquivo INI do disco.

**Retorno:** `IParametersInifiles`

---

##### Importação/Exportação

###### `function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;`
Importa parâmetros do Database para o arquivo INI.

**Parâmetros:**
- `ADatabase: IParametersDatabase` - Interface Database de origem

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
var DB: IParametersDatabase;
var Ini: IParametersInifiles;
DB := TParameters.NewDatabase.Connect;
Ini := TParameters.NewInifiles('config.ini');
Ini.ImportFromDatabase(DB); // Importa todos os parâmetros
```

---

###### `function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `ADatabase: IParametersDatabase` - Interface Database
- `out ASuccess: Boolean` - True se importado com sucesso

**Retorno:** `IParametersInifiles`

---

###### `function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;`
Exporta parâmetros do arquivo INI para o Database.

**Parâmetros:**
- `ADatabase: IParametersDatabase` - Interface Database de destino

**Retorno:** `IParametersInifiles`

**Exemplo:**
```pascal
Ini.ExportToDatabase(DB); // Exporta todos os parâmetros
```

---

###### `function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;`
Versão com retorno de sucesso.

---

##### Navegação

###### `function EndInifiles: IInterface;`
Método de navegação (retorna IInterface para compatibilidade).

**Retorno:** `IInterface`

---

#### Interface: IParametersJsonObject

Interface para acesso a parâmetros em objetos JSON.

##### Configuração (Fluent Interface)

###### `function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject; overload;`
Define objeto JSON existente.

**Parâmetros:**
- `AJsonObject: TJSONObject` - Objeto JSON

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
var MyJson: TJSONObject;
MyJson := TJSONObject.ParseJSONValue('{"ERP":{"host":"localhost"}}') as TJSONObject;
Json.JsonObject(MyJson);
```

---

###### `function JsonObject: TJSONObject; overload;`
Retorna objeto JSON atual.

**Retorno:** `TJSONObject`

---

###### `function ObjectName(const AValue: string): IParametersJsonObject; overload;`
Define nome do objeto JSON (título).

**Parâmetros:**
- `AValue: string` - Nome do objeto

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.ObjectName('ERP');
```

---

###### `function ObjectName: string; overload;`
Retorna nome do objeto atual.

**Retorno:** `string`

---

###### `function FilePath(const AValue: string): IParametersJsonObject; overload;`
Define caminho do arquivo JSON.

**Parâmetros:**
- `AValue: string` - Caminho completo do arquivo

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.FilePath('C:\Config\params.json');
```

---

###### `function FilePath: string; overload;`
Retorna caminho atual.

**Retorno:** `string`

---

###### `function AutoCreateFile(const AValue: Boolean): IParametersJsonObject; overload;`
Define se deve criar arquivo automaticamente.

**Parâmetros:**
- `AValue: Boolean` - True para criar automaticamente

**Retorno:** `IParametersJsonObject`

---

###### `function AutoCreateFile: Boolean; overload;`
Retorna se auto-criação está ativa.

**Retorno:** `Boolean`

---

###### `function ContratoID(const AValue: Integer): IParametersJsonObject; overload;`
Define filtro de ContratoID.

**Parâmetros:**
- `AValue: Integer` - ID do contrato

**Retorno:** `IParametersJsonObject`

---

###### `function ContratoID: Integer; overload;`
Retorna ContratoID atual.

**Retorno:** `Integer`

---

###### `function ProdutoID(const AValue: Integer): IParametersJsonObject; overload;`
Define filtro de ProdutoID.

**Parâmetros:**
- `AValue: Integer` - ID do produto

**Retorno:** `IParametersJsonObject`

---

###### `function ProdutoID: Integer; overload;`
Retorna ProdutoID atual.

**Retorno:** `Integer`

---

##### CRUD

Todos os métodos CRUD seguem o mesmo padrão das outras interfaces.

**Exemplo:**
```pascal
var Json: IParametersJsonObject;
Json := TParameters.NewJsonObjectFromFile('C:\Config\params.json')
  .ContratoID(1)
  .ProdutoID(1)
  .Title('ERP');
var Param: TParameter;
Json.Getter('database_host', Param);
if Assigned(Param) then
  ShowMessage(Param.Value);
Param.Free;
```

---

##### Utilitários

###### `function Count: Integer; overload;`
Conta parâmetros no objeto JSON.

**Retorno:** `Integer`

---

###### `function Count(out ACount: Integer): IParametersJsonObject; overload;`
Versão com parâmetro `out`.

---

###### `function FileExists: Boolean; overload;`
Verifica se o arquivo JSON existe.

**Retorno:** `Boolean`

---

###### `function FileExists(out AExists: Boolean): IParametersJsonObject; overload;`
Versão com parâmetro `out`.

---

###### `function Refresh: IParametersJsonObject;`
Recarrega arquivo JSON do disco.

**Retorno:** `IParametersJsonObject`

---

###### `function ToJSON: TJSONObject; overload;`
Retorna objeto JSON completo.

**Retorno:** `TJSONObject`

**Exemplo:**
```pascal
var JsonObj: TJSONObject;
JsonObj := Json.ToJSON;
try
  ShowMessage(JsonObj.ToString);
finally
  JsonObj.Free;
end;
```

---

###### `function ToJSONString: string; overload;`
Retorna JSON como string formatada.

**Retorno:** `string`

**Exemplo:**
```pascal
var JsonString: string;
JsonString := Json.ToJSONString;
ShowMessage(JsonString);
```

---

###### `function SaveToFile(const AFilePath: string = ''): IParametersJsonObject; overload;`
Salva JSON em arquivo.

**Parâmetros:**
- `AFilePath: string` (opcional) - Caminho do arquivo (usa FilePath se vazio)

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.SaveToFile('C:\Config\params.json');
```

---

###### `function SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AFilePath: string` - Caminho do arquivo
- `out ASuccess: Boolean` - True se salvo

**Retorno:** `IParametersJsonObject`

---

###### `function LoadFromString(const AJsonString: string): IParametersJsonObject;`
Carrega JSON de uma string.

**Parâmetros:**
- `AJsonString: string` - String contendo JSON válido

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.LoadFromString('{"ERP":{"host":"localhost"}}');
```

---

###### `function LoadFromFile(const AFilePath: string = ''): IParametersJsonObject; overload;`
Carrega JSON de um arquivo.

**Parâmetros:**
- `AFilePath: string` (opcional) - Caminho do arquivo (usa FilePath se vazio)

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.LoadFromFile('C:\Config\params.json');
```

---

###### `function LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject; overload;`
Versão com retorno de sucesso.

**Parâmetros:**
- `AFilePath: string` - Caminho do arquivo
- `out ASuccess: Boolean` - True se carregado

**Retorno:** `IParametersJsonObject`

---

##### Importação/Exportação

###### `function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject; overload;`
Importa parâmetros do Database para JSON.

**Parâmetros:**
- `ADatabase: IParametersDatabase` - Interface Database de origem

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.ImportFromDatabase(DB);
```

---

###### `function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject; overload;`
Versão com retorno de sucesso.

---

###### `function ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject; overload;`
Exporta parâmetros do JSON para Database.

**Parâmetros:**
- `ADatabase: IParametersDatabase` - Interface Database de destino

**Retorno:** `IParametersJsonObject`

---

###### `function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject; overload;`
Versão com retorno de sucesso.

---

###### `function ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject; overload;`
Importa parâmetros do INI para JSON.

**Parâmetros:**
- `AInifiles: IParametersInifiles` - Interface INI de origem

**Retorno:** `IParametersJsonObject`

**Exemplo:**
```pascal
Json.ImportFromInifiles(Ini);
```

---

###### `function ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject; overload;`
Versão com retorno de sucesso.

---

###### `function ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject; overload;`
Exporta parâmetros do JSON para INI.

**Parâmetros:**
- `AInifiles: IParametersInifiles` - Interface INI de destino

**Retorno:** `IParametersJsonObject`

---

###### `function ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject; overload;`
Versão com retorno de sucesso.

---

##### Navegação

###### `function EndJsonObject: IInterface;`
Método de navegação (retorna IInterface para compatibilidade).

**Retorno:** `IInterface`

---

### Parameters.Types.pas

**Tipo:** Interno (re-exportado via Interfaces)  
**Linhas:** 374  
**Responsabilidade:** Define todos os tipos utilizados pelo sistema

#### Tipos Principais

##### `TParameterConfigOption`
Enum para opções de configuração:
- `pcfNone` - Nenhuma fonte
- `pcfDataBase` - Habilita Database
- `pcfInifile` - Habilita INI Files
- `pcfJsonObject` - Habilita JSON Objects

##### `TParameterConfig`
Set de opções de configuração:
```pascal
TParameterConfig = set of TParameterConfigOption;
```

**Exemplo:**
```pascal
var Config: TParameterConfig;
Config := [pcfDataBase, pcfInifile]; // Database com fallback para INI
```

---

##### `TParameterDatabaseEngine`
Enum para engines de banco de dados:
- `pteNone` - Nenhum engine
- `pteUnidac` - UniDAC
- `pteFireDAC` - FireDAC
- `pteZeos` - Zeos
- `pteLDAP` - LDAP

##### `TParameterDatabaseTypes`
Enum para tipos de banco de dados:
- `pdtNone` - Nenhum
- `pdtFireBird` - FireBird
- `pdtMySQL` - MySQL
- `pdtPostgreSQL` - PostgreSQL
- `pdtSQLite` - SQLite
- `pdtSQLServer` - SQL Server
- `pdtAccess` - Microsoft Access
- `pdtODBC` - ODBC
- `pdtLDAP` - LDAP

##### `TParameterValueType`
Enum para tipos de valor:
- `pvtString` - String/Texto
- `pvtInteger` - Inteiro
- `pvtFloat` - Float/Double
- `pvtBoolean` - Boolean
- `pvtDateTime` - Data/Hora
- `pvtJSON` - JSON Object

##### `TParameterSource`
Enum para fontes de dados:
- `psDatabase` - Banco de dados
- `psInifiles` - Arquivo INI
- `psJsonObject` - Objeto JSON

##### `TParameterSourceArray`
Array dinâmico de fontes:
```pascal
TParameterSourceArray = array of TParameterSource;
```

---

##### `TParameter`
Classe que representa um parâmetro de configuração.

**Propriedades:**
- `ID: Integer` - Identificador único (Database)
- `Name: string` - Nome/chave do parâmetro
- `Value: string` - Valor do parâmetro
- `ValueType: TParameterValueType` - Tipo do valor
- `Description: string` - Descrição/comentário
- `ContratoID: Integer` - Filtro de contrato
- `ProdutoID: Integer` - Filtro de produto
- `Ordem: Integer` - Ordem de exibição
- `Titulo: string` - Título/seção/objeto
- `Ativo: Boolean` - Status ativo/inativo
- `CreatedAt: TDateTime` - Data de criação
- `UpdatedAt: TDateTime` - Data de atualização

**Exemplo:**
```pascal
var Param: TParameter;
Param := TParameter.Create;
try
  Param.Name := 'database_host';
  Param.Value := 'localhost';
  Param.ValueType := pvtString;
  Param.Description := 'Host do banco de dados';
  Param.Titulo := 'ERP';
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Ordem := 1;
  Param.Ativo := True;
  
  Parameters.Insert(Param);
finally
  Param.Free;
end;
```

---

##### `TParameterList`
Lista gerenciada de parâmetros que herda de `TList<TParameter>`.

**Métodos:**
- `ClearAll` - Libera todos os objetos e limpa a lista

**Exemplo:**
```pascal
var List: TParameterList;
List := Parameters.List;
try
  for var I := 0 to List.Count - 1 do
    ShowMessage(List[I].Name + ' = ' + List[I].Value);
finally
  List.Free; // Libera automaticamente todos os objetos TParameter
end;
```

---

### Parameters.Consts.pas

**Tipo:** Interno (re-exportado via Interfaces)  
**Linhas:** 497  
**Responsabilidade:** Define todas as constantes utilizadas pelo sistema

#### Constantes Principais

##### Configurações Padrão

```pascal
DEFAULT_PARAMETER_CONFIG: TParameterConfig = [pcfDataBase, pcfInifile];
DEFAULT_PARAMETER_CONFIG_DATABASE_ONLY: TParameterConfig = [pcfDataBase];
DEFAULT_PARAMETER_CONFIG_INIFILE_ONLY: TParameterConfig = [pcfInifile];
DEFAULT_PARAMETER_CONFIG_JSON_ONLY: TParameterConfig = [pcfJsonObject];
DEFAULT_PARAMETER_CONFIG_ALL: TParameterConfig = [pcfDataBase, pcfInifile, pcfJsonObject];
```

##### Arquivos

```pascal
DEFAULT_PARAMETER_INI_FILENAME = 'parameters.ini';
DEFAULT_PARAMETER_INI_SECTION = 'Parameters';
DEFAULT_PARAMETER_JSON_FILENAME = 'D:\Dados\config.json';
DEFAULT_PARAMETER_JSON_OBJECT_NAME_ROOT = 'parameters';
```

##### Validação e Limites

```pascal
MAX_PARAMETER_NAME_LENGTH = 255;
MAX_PARAMETER_VALUE_LENGTH = 65535; // 64KB
MAX_PARAMETER_DESCRIPTION_LENGTH = 1000;
```

##### Reordenação Automática

```pascal
DEFAULT_PARAMETER_AUTO_REORDER_ON_INSERT = True;
DEFAULT_PARAMETER_AUTO_RENUMBER_ZERO_ORDER = True;
DEFAULT_PARAMETER_AUTO_REORDER_ON_UPDATE = True;
```

##### Mapeamentos

```pascal
TDatabaseTypeNames: Array [TParameterDatabaseTypes] of string = (
  'None', 'Firebird', 'MySQL', 'PostgreSQL', 'SQLite', 'SQL Server', 'Access', 'ODBC', 'LDAP'
);

TEngineDatabase: Array [TParameterDatabaseEngine] of string = (
  'None', 'Unidac', 'FireDac', 'Zeos', 'LDAP'
);
```

##### SQL Templates

Constantes SQL para criação de tabelas em diferentes bancos:
- `SQL_CREATE_TABLE_POSTGRESQL`
- `SQL_CREATE_TABLE_MYSQL`
- `SQL_CREATE_TABLE_SQLSERVER`
- `SQL_CREATE_TABLE_SQLITE`
- `SQL_CREATE_TABLE_FIREBIRD`
- `SQL_CREATE_TABLE_ACCESS`

---

### Parameters.Exceptions.pas

**Tipo:** Interno (re-exportado via Interfaces)  
**Linhas:** 567  
**Responsabilidade:** Sistema completo de exceções e mensagens de erro

#### Hierarquia de Exceções

```
EParametersException (Base)
├── EParametersConnectionException (Erros de Conexão)
├── EParametersSQLException (Erros de SQL)
├── EParametersValidationException (Erros de Validação)
├── EParametersNotFoundException (Parâmetro Não Encontrado)
├── EParametersConfigurationException (Erros de Configuração)
├── EParametersFileException (Erros de Arquivo)
├── EParametersInifilesException (Erros de INI)
└── EParametersJsonObjectException (Erros de JSON)
```

#### Propriedades das Exceções

```pascal
EParametersException = class(Exception)
  property ErrorCode: Integer;  // Código numérico do erro
  property Operation: string;  // Operação que gerou o erro
end;
```

#### Códigos de Erro (Organizados por Faixa)

- **Conexão (1000-1099):** 10 códigos
- **SQL (1100-1199):** 16 códigos
- **Validação (1200-1299):** 12 códigos
- **Operação (1300-1399):** 11 códigos
- **Configuração (1400-1499):** 9 códigos
- **Arquivo (1500-1599):** 13 códigos
- **INI (1600-1699):** 8 códigos
- **JSON (1700-1799):** 12 códigos
- **Importação/Exportação (1800-1899):** 9 códigos

**Total:** 90+ códigos de erro

#### Funções Auxiliares

##### `function CreateConnectionException(...): EParametersConnectionException;`
Cria exceção de conexão.

##### `function CreateSQLException(...): EParametersSQLException;`
Cria exceção de SQL.

##### `function CreateValidationException(...): EParametersValidationException;`
Cria exceção de validação.

##### `function CreateNotFoundException(...): EParametersNotFoundException;`
Cria exceção de não encontrado.

##### `function CreateConfigurationException(...): EParametersConfigurationException;`
Cria exceção de configuração.

##### `function CreateFileException(...): EParametersFileException;`
Cria exceção de arquivo.

##### `function CreateInifilesException(...): EParametersInifilesException;`
Cria exceção de INI.

##### `function CreateJsonObjectException(...): EParametersJsonObjectException;`
Cria exceção de JSON.

##### `function ConvertToParametersException(...): EParametersException;`
Converte exceção genérica para exceção do Parameters.

##### `function IsParametersException(...): Boolean;`
Verifica se uma exceção é do tipo Parameters.

##### `function GetExceptionErrorCode(...): Integer;`
Obtém código de erro de uma exceção.

##### `function GetExceptionOperation(...): string;`
Obtém operação de uma exceção.

---

### Parameters.Database.pas

**Tipo:** Interno (Implementação)  
**Linhas:** 4.912  
**Responsabilidade:** Implementação completa de acesso a parâmetros em banco de dados

#### Classe: TParametersDatabase

Implementa `IParametersDatabase` com suporte a múltiplos engines e bancos de dados.

**Características:**
- ✅ Suporte multi-engine: UNIDAC, FireDAC, Zeos
- ✅ Suporte multi-database: PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC
- ✅ Conexão interna automática ou conexão externa
- ✅ **Thread-safe com TCriticalSection** - 14 métodos principais protegidos
- ✅ Lógica de ordem automática
- ✅ Criação automática de tabela
- ✅ Validação de estrutura de tabela

**Thread-Safety:**
- Campo `FLock: TCriticalSection` implementado
- 14 métodos principais protegidos: `List`, `Get`, `Insert`, `Update`, `Delete`, `Exists`, `Count`, `Connect`, `Disconnect`, `Refresh`, `CreateTable`, `DropTable`, `Database`, `Connection`
- Todos os métodos CRUD protegidos contra acesso concorrente
- Pronto para uso em ambientes multithread

**Métodos principais já documentados na interface `IParametersDatabase` acima.**

---

### Parameters.Inifiles.pas

**Tipo:** Interno (Implementação)  
**Linhas:** 1.476  
**Responsabilidade:** Implementação completa de acesso a parâmetros em arquivos INI

#### Classe: TParametersInifiles

Implementa `IParametersInifiles` com preservação de comentários e formatação.

**Características:**
- ✅ Preservação de comentários e formatação
- ✅ Suporte a múltiplas seções
- ✅ Suporte a itens inativos (prefixo "#")
- ✅ Thread-safe com TCriticalSection
- ✅ Lógica de ordem automática
- ✅ Criação automática de arquivo

**Métodos principais já documentados na interface `IParametersInifiles` acima.**

---

### Parameters.JsonObject.pas

**Tipo:** Interno (Implementação)  
**Linhas:** 2.264  
**Responsabilidade:** Implementação completa de acesso a parâmetros em objetos JSON

#### Classe: TParametersJsonObject

Implementa `IParametersJsonObject` com formatação JSON e detecção de encoding.

**Características:**
- ✅ Formatação JSON com indentação
- ✅ Detecção e conversão de encoding (UTF-8, UTF-16, ANSI)
- ✅ Suporte a múltiplos objetos
- ✅ Thread-safe com TCriticalSection
- ✅ Lógica de ordem automática
- ✅ Criação automática de arquivo

**Métodos principais já documentados na interface `IParametersJsonObject` acima.**

---

## 🎯 EXEMPLOS DE USO

### Exemplo 1: Uso Básico com Database

```pascal
uses Parameters;

var Parameters: IParametersDatabase;
var ParamList: TParameterList;
var Param: TParameter;

// Cria instância (conexão automática)
Parameters := TParameters.NewDatabase
  .TableName('config')
  .Schema('dbcsl')
  .ContratoID(1)
  .ProdutoID(1);

// Lista todos
ParamList := Parameters.List;
try
  for var I := 0 to ParamList.Count - 1 do
    ShowMessage(ParamList[I].Name + ' = ' + ParamList[I].Value);
finally
  ParamList.Free;
end;

// Busca um (com hierarquia completa)
Parameters
  .ContratoID(1)
  .ProdutoID(1)
  .Database.Title('ERP')
  .Getter('erp_host', Param);
try
  if Assigned(Param) then
    ShowMessage(Param.Value);
finally
  if Assigned(Param) then
    Param.Free;
end;

// Insere novo (ou atualiza se existir usando Setter)
Param := TParameter.Create;
try
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Titulo := 'ERP';
  Param.Name := 'teste_key';
  Param.Value := 'teste_value';
  Param.ValueType := pvtString;
  Parameters.Setter(Param); // Insere se não existir, atualiza se existir
finally
  Param.Free;
end;
```

---

### Exemplo 2: Múltiplas Fontes com Fallback

```pascal
uses Parameters;

var Parameters: IParameters;
var Param: TParameter;

// Cria instância com múltiplas fontes
Parameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);

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

// Configura JSON (fallback)
Parameters.JsonObject
  .FilePath('C:\Config\params.json')
  .ObjectName('Parameters');

// Define ordem de prioridade
Parameters.Priority([psDatabase, psInifiles, psJsonObject]);

// Busca em cascata: Database → INI → JSON (com hierarquia completa)
Parameters
  .ContratoID(1)
  .ProdutoID(1)
  .Database.Title('ERP')
  .Inifiles.Title('ERP')
  .JsonObject.Title('ERP');
Param := Parameters.Getter('database_host');
try
  if Assigned(Param) then
    ShowMessage('Encontrado: ' + Param.Value)
  else
    ShowMessage('Não encontrado em nenhuma fonte');
finally
  if Assigned(Param) then
    Param.Free;
end;
```

---

### Exemplo 3: Importação/Exportação

```pascal
uses Parameters;

var DB: IParametersDatabase;
var Ini: IParametersInifiles;
var Json: IParametersJsonObject;
var Success: Boolean;

// Cria instâncias
DB := TParameters.NewDatabase
  .TableName('config')
  .Schema('public')
  .Connect;

Ini := TParameters.NewInifiles
  .FilePath('C:\Config\params.ini');

Json := TParameters.NewJsonObject
  .FilePath('C:\Config\params.json');

// Exporta Database → INI
Ini.ExportToDatabase(DB, Success);
if Success then
  ShowMessage('Exportado com sucesso!');

// Importa INI → JSON
Json.ImportFromInifiles(Ini, Success);
if Success then
  ShowMessage('Importado com sucesso!');
```

---

### Exemplo 4: Tratamento de Erros

```pascal
uses Parameters, Parameters.Intefaces;

var Parameters: IParametersDatabase;
begin
  try
    Parameters := TParameters.NewDatabase
      .Host('localhost')
      .Database('mydb')
      .Connect;
      
    ShowMessage('Conectado com sucesso!');
  except
    on E: EParametersConnectionException do
    begin
      ShowMessage(Format('ERRO DE CONEXÃO: %s'#13#10'Código: %d'#13#10'Operação: %s',
        [E.Message, E.ErrorCode, E.Operation]));
    end;
    on E: EParametersException do
    begin
      ShowMessage(Format('ERRO: %s'#13#10'Código: %d', [E.Message, E.ErrorCode]));
    end;
    on E: Exception do
    begin
      ShowMessage('Erro inesperado: ' + E.Message);
    end;
  end;
end;
```

---

## 🛡️ TRATAMENTO DE ERROS

O módulo Parameters possui um sistema completo de tratamento de erros com:

- ✅ **8 tipos de exceções específicas**
- ✅ **90+ códigos de erro organizados por faixa**
- ✅ **Mensagens padronizadas e formatáveis**
- ✅ **Propriedades ErrorCode e Operation** para rastreabilidade

### Exemplo de Tratamento Completo

```pascal
try
  Parameters := TParameters.NewDatabase.Connect;
except
  on E: EParametersConnectionException do
    // Tratamento específico de conexão
  on E: EParametersSQLException do
    // Tratamento específico de SQL
  on E: EParametersValidationException do
    // Tratamento específico de validação
  on E: EParametersException do
    // Tratamento genérico do Parameters
  on E: Exception do
    // Tratamento de exceções genéricas
end;
```

---

## ❓ FAQ

### Como usar apenas Database?

```pascal
var DB: IParametersDatabase;
DB := TParameters.NewDatabase
  .Host('localhost')
  .Database('mydb')
  .Connect;
```

### Como usar Database com fallback para INI?

```pascal
var Parameters: IParameters;
Parameters := TParameters.New([pcfDataBase, pcfInifile]);
Parameters.Database.Host('localhost').Connect;
Parameters.Inifiles.FilePath('config.ini');
// Get() busca primeiro no Database, depois no INI
```

### Como importar dados do Database para JSON?

```pascal
var DB: IParametersDatabase;
var Json: IParametersJsonObject;
DB := TParameters.NewDatabase.Connect;
Json := TParameters.NewJsonObject;
Json.ImportFromDatabase(DB);
Json.SaveToFile('export.json');
```

### Como tratar erros de conexão?

```pascal
try
  DB.Connect;
except
  on E: EParametersConnectionException do
    ShowMessage('Erro: ' + E.Message + #13#10'Código: ' + IntToStr(E.ErrorCode));
end;
```

### Como usar no FPC/Lazarus?

O código é idêntico ao Delphi. Apenas certifique-se de:

1. **Instalar Zeos Library** (recomendado para FPC)
2. **Configurar diretivas** em `ParamentersORM.Defines.inc` (já configurado automaticamente)
3. **Usar arquivo `.lpr`** ou `.lpi` no Lazarus

```pascal
// Exemplo no FPC/Lazarus (idêntico ao Delphi)
var Parameters: IParameters;
Parameters := TParameters.NewDatabase
  .Host('localhost')
  .Database('mydb')
  .Connect;
```

**Nota:** FireDAC não está disponível no FPC. Use Zeos ou UniDAC.

### Posso ter chaves com o mesmo nome em títulos diferentes?

**Sim!** A partir da versão 1.0.1, é possível ter chaves com o mesmo nome em títulos diferentes. A validação considera `ContratoID + ProdutoID + Título + Nome` como chave única (hierarquia completa da constraint UNIQUE).

**IMPORTANTE:** Todos os métodos CRUD (`Getter`, `Setter`, `Delete`, `Exists`) respeitam essa hierarquia completa. Use `Getter()` e `Setter()` em vez de `Get()` e `Update()` (deprecated).

```pascal
// Exemplo: Mesma chave em títulos diferentes
var Param1, Param2: TParameter;
Param1 := TParameter.Create;
Param1.Name := 'host';
Param1.Titulo := 'ERP';
Param1.Value := 'erp.example.com';

Param2 := TParameter.Create;
Param2.Name := 'host';  // Mesmo nome!
Param2.Titulo := 'CRM'; // Título diferente
Param2.Value := 'crm.example.com';

// Ambos podem ser inseridos com sucesso
Parameters.Insert(Param1, Success1);
Parameters.Insert(Param2, Success2);
```

### O que acontece quando deleto a última chave de um título?

A partir da versão 1.0.1, a seção (INI) ou objeto (JSON) é **removida automaticamente** quando você deleta a última chave. Isso mantém os arquivos limpos e organizados.

```pascal
// Se você deletar a última chave de um título:
Parameters.Delete('ultima_chave');

// A seção [Titulo] no INI será removida automaticamente
// O objeto "Titulo" no JSON será removido automaticamente
// Nota: Seções/objetos especiais como [Contrato] são preservados
```

---

## 📊 ESTATÍSTICAS DO PROJETO

| Métrica | Valor |
|---------|-------|
| **Arquivos Implementados** | 8 units |
| **Linhas de Código** | ~11.000 linhas |
| **Fases Concluídas** | 5 de 7 (71%) |
| **Progresso Geral** | ~99% |
| **Status** | ✅ Pronto para uso |
| **O Que Falta para 100%** | Ver `docs/O_QUE_FALTA_100_PORCENTO.md` |
| **Compatibilidade Delphi** | ✅ 100% |
| **Compatibilidade FPC/Lazarus** | ✅ 100% |
| **Plataformas Suportadas** | Windows, Linux, macOS |

---

## 🦎 COMPATIBILIDADE FPC/LAZARUS

O módulo Parameters foi **totalmente adaptado** para funcionar com **Free Pascal Compiler (FPC)** e **Lazarus IDE**, mantendo compatibilidade total com Delphi.

### ✅ Status de Compatibilidade

- ✅ **100% Adaptado** para FPC/Lazarus
- ✅ **Multi-plataforma:** Windows, Linux, macOS
- ✅ **Compatibilidade retroativa** com Delphi mantida
- ✅ **Thread-safe** em ambas as plataformas

### 🔧 Características FPC/Lazarus

#### Engines de Banco de Dados Suportados

| Engine | Delphi | FPC/Lazarus | Observações |
|--------|--------|-------------|-------------|
| **Zeos** | ✅ | ✅ | **Recomendado para FPC** (open-source) |
| **UniDAC** | ✅ | ✅ | Requer licença |
| **FireDAC** | ✅ | ❌ | Não disponível no FPC |

#### Plataformas Suportadas

| Plataforma | Status | Observações |
|------------|--------|-------------|
| **Windows** | ✅ | Funcionalidades completas |
| **Linux** | ✅ | Sem Access Database |
| **macOS** | ✅ | Sem Access Database |

### 📋 Requisitos para FPC/Lazarus

1. **Free Pascal Compiler (FPC)** 3.2.2 ou superior
2. **Lazarus IDE** 4.4+ (recomendado) - Versão detectada: 4.4
3. **Zeos Library** (recomendado) ou UniDAC
4. **Diretivas de compilação:** `USE_ZEOS` e `FPC`

### 🚀 Configuração Rápida

#### 1. Instalar Zeos Library

```bash
# Via Online Package Manager no Lazarus
Package → Online Package Manager → Buscar "Zeos" → Instalar
```

#### 2. Abrir Projeto no Lazarus

```bash
# Abrir arquivo .lpi ou .lpr
File → Open → ParamentersCSL.lpi
```

#### 3. Configurar Diretivas

O arquivo `src/ParamentersORM.Defines.inc` já está configurado automaticamente para FPC:

```pascal
{$IFDEF FPC}
  {$DEFINE USE_ZEOS}  // Ativado automaticamente
  {$UNDEF USE_FIREDAC} // Desativado (não disponível)
{$ENDIF}
```

### 📝 Exemplo de Uso no FPC/Lazarus

```pascal
program ParamentersCSL;

{$IFDEF FPC}
  {$MODE DELPHI}
  {$IFDEF WINDOWS}
    {$APPTYPE GUI}
  {$ENDIF}
{$ENDIF}

uses
{$IFDEF FPC}
  Interfaces, Forms, LResources,
{$ELSE}
  Vcl.Forms,
{$ENDIF}
  Parameters;

var
  Parameters: IParameters;
begin
  Application.Initialize;
  
  // Uso idêntico ao Delphi
  Parameters := TParameters.NewDatabase
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('pass')
    .TableName('config')
    .Schema('public')
    .Connect;
    
  // Resto do código...
end.
```

### 🔄 Mapeamento de Units

| Delphi | FPC/Lazarus |
|--------|-------------|
| `Vcl.Forms` | `Forms` |
| `System.SysUtils` | `SysUtils` |
| `System.Classes` | `Classes` |
| `System.JSON` | `fpjson` |
| `System.IniFiles` | `IniFiles` |
| `System.SyncObjs` | `SyncObjs` |
| `Data.DB` | `DB` |
| `Winapi.Windows` | `Windows` (apenas Windows) |
| `System.Win.Registry` | `Registry` (apenas Windows) |

### ⚠️ Limitações no FPC/Lazarus

#### Funcionalidades Apenas Windows

1. **Access Database (.mdb)**
   - Requer ADOX (ActiveX Data Objects Extensions)
   - Código protegido com `{$IFDEF WINDOWS}`

2. **Registry**
   - Windows Registry API
   - Condicionado com `{$IFDEF WINDOWS}`

3. **SetEnvironmentVariable**
   - Windows API
   - Condicionado com `{$IFDEF WINDOWS}`

#### Units Não Disponíveis

- `System.IOUtils` → Usa `SysUtils` no FPC
- `System.Win.*` → Usa unidades específicas do Windows no FPC

### 📁 Estrutura de Diretórios (FPC/Lazarus)

#### Estrutura de Compilação do Projeto

```
Compiled\
├── EXE\
│   ├── Debug\
│   │   ├── win32\          # $(BuildMode)\$(TargetOS)
│   │   └── win64\
│   └── Release\
│       ├── win32\
│       └── win64\
└── DCU\
    ├── Debug\
    │   ├── win32\
    │   └── win64\
    └── Release\
        ├── win32\
        └── win64\
```

#### Estrutura de Instalação do FPC/Lazarus (Detectada)

```
D:\fpc\
├── fpc\                      # Free Pascal Compiler 3.2.2
│   ├── bin\
│   │   └── x86_64-win64\     # Binários 64-bit
│   │       ├── fpc.exe       # Compilador principal
│   │       └── ...
│   ├── units\                # Units compiladas
│   │   ├── i386-win32\       # Units 32-bit
│   │   ├── x86_64-win64\     # Units 64-bit
│   │   └── x86_64-linux\     # Units Linux (cross-compilation)
│   └── ...
├── fpcsrc\                   # Código-fonte do FPC
├── lazarus\                  # IDE Lazarus
│   ├── lazarus.exe           # Executável principal
│   └── ...
├── config_lazarus\          # Configurações do Lazarus
│   └── onlinepackagemanager\ # Pacotes OPM
├── ccr\                      # Componentes e bibliotecas
├── cross\                    # Ferramentas de cross-compilation
└── projects\                # Projetos de exemplo
```

**Caminhos Principais:**
- **Lazarus IDE:** `D:\fpc\lazarus\lazarus.exe`
- **FPC Compiler:** `D:\fpc\fpc\bin\x86_64-win64\fpc.exe`
- **Versão FPC:** 3.2.2

### 🔧 Variáveis do Projeto

| Delphi | Lazarus | Exemplo |
|--------|---------|---------|
| `$(Config)` | `$(BuildMode)` | `Debug`, `Release` |
| `$(Platform)` | `$(TargetOS)` | `win32`, `win64` |
| `$(Platform)` | `$(TargetCPU)-$(TargetOS)` | `i386-win32`, `x86_64-win64` |

### 📚 Documentação Específica FPC/Lazarus

- 📄 [`docs/CONFIGURACAO_FPC_LAZARUS.md`](docs/CONFIGURACAO_FPC_LAZARUS.md) - Guia completo de configuração
- 📄 [`docs/ANALISE_COMPATIBILIDADE_FPC.md`](docs/ANALISE_COMPATIBILIDADE_FPC.md) - Análise detalhada de compatibilidade
- 📄 [`docs/RESUMO_ADAPTACAO_FPC.md`](docs/RESUMO_ADAPTACAO_FPC.md) - Resumo das adaptações realizadas
- 📄 [`docs/RESUMO_FINAL_FPC.md`](docs/RESUMO_FINAL_FPC.md) - Resumo final da adaptação
- 📄 [`docs/VARIAVEIS_LAZARUS_DELPHI.md`](docs/VARIAVEIS_LAZARUS_DELPHI.md) - Mapeamento de variáveis
- 📄 [`docs/CHECKLIST_FPC.md`](docs/CHECKLIST_FPC.md) - Checklist de verificação
- 📄 [`docs/CORRECOES_COMPATIBILIDADE_FPC_DELPHI.md`](docs/CORRECOES_COMPATIBILIDADE_FPC_DELPHI.md) - Correções aplicadas

### 🧪 Testes de Compatibilidade

- ✅ Compilação no FPC 3.2.2
- ✅ Compilação no Lazarus 4.4 (detectado)
- ✅ Testes de unidades condicionais
- ✅ Testes de thread-safety
- ✅ Testes de importação/exportação

---

## 🏰 CASTLE ENGINE (OPCIONAL)

O **Castle Game Engine** é um framework de desenvolvimento de jogos 3D para Pascal/Object Pascal, compatível com Free Pascal e Delphi. Ele foi configurado no ambiente de desenvolvimento para permitir a criação de projetos de jogos separados.

### ✅ Status de Configuração

- ✅ **Castle Engine instalado:** `D:\castle-engine`
- ✅ **Versão:** 7.0-alpha.3.snapshot
- ✅ **Variável de ambiente:** `CASTLE_ENGINE_PATH` configurada
- ✅ **Build-tool:** Adicionado ao PATH
- ✅ **Configurações VSCode/Cursor:** Aplicadas
- ✅ **Tasks de build:** Configuradas

### 📋 O que é o Castle Engine?

O Castle Game Engine fornece:

- ✅ Renderização 3D (OpenGL, Vulkan)
- ✅ Física (usando Physics Integration)
- ✅ Áudio (OpenAL)
- ✅ Input (teclado, mouse, joystick, touch)
- ✅ Multi-plataforma (Windows, Linux, macOS, Android, iOS)
- ✅ Editor visual integrado

### 🔧 Configuração

A configuração completa está documentada em:

- 📄 [`.vscode/CASTLE_ENGINE_SETUP.md`](.vscode/CASTLE_ENGINE_SETUP.md) - Guia completo de configuração

### 🚀 Uso Rápido

#### Verificar Instalação

```powershell
# Verificar versão
castle-engine --version

# Verificar variável de ambiente
echo $env:CASTLE_ENGINE_PATH
```

#### Compilar um Projeto Castle Engine

```powershell
# Compilar em modo debug
castle-engine compile --mode=debug

# Compilar em modo release
castle-engine compile --mode=release

# Compilar para plataforma específica
castle-engine compile --os=win64
castle-engine compile --os=linux
castle-engine compile --os=android
```

#### Via Build Tasks no Cursor/VSCode

- `Ctrl+Shift+B` → Selecionar task:
  - **Castle Engine: Verificar Versão**
  - **Castle Engine: Compilar (Debug)**
  - **Castle Engine: Compilar (Release)**
  - **Castle Engine: Limpar Projeto**

### 🎮 Integração com Parameters

O Castle Engine pode usar o módulo Parameters para gerenciar configurações de jogos:

```pascal
uses
  Parameters,  // Módulo Parameters
  CastleWindow;

var
  Window: TCastleWindowBase;
  Params: IParameters;
begin
  // Carregar parâmetros do jogo
  Params := TParameters.NewInifiles
    .FilePath('game_config.ini')
    .Section('Game');
  
  // Usar parâmetros
  Window.Width := StrToInt(Params.Getter('window_width').Value);
  Window.Height := StrToInt(Params.Getter('window_height').Value);
  
  Window.Open;
  Application.Run;
end.
```

### ⚠️ Nota Importante

O Castle Engine é **opcional** e não é necessário para o projeto ParametersORM atual. Ele foi configurado caso você queira criar projetos de jogos separados usando o mesmo ambiente de desenvolvimento.

Para habilitar o Castle Engine no projeto:
1. Configure `CASTLE_ENGINE_PATH` (já configurado)
2. Defina `"castleEngine.enabled": true` no `.vscode/settings.json` (se necessário)
3. Recarregue o Cursor: `Ctrl+Shift+P` → "Reload Window"

---

## 📚 DOCUMENTAÇÃO ADICIONAL

### Documentação HTML

- `Analises/ROADMAP_MODULO_PARAMETERS.html` - Roadmap completo
- `Analises/ARQUITETURA_MODULO_PARAMETERS.html` - Arquitetura detalhada
- `Analises/HISTORICO_COMPLETO_MODULO_PARAMETERS.html` - Histórico de desenvolvimento
- `Analises/ANALISE_ARQUITETURA_CONVERGENCIA_PARAMETERS.html` - Análise de convergência
- `Analises/IMPLEMENTACAO_FASE5_CONVERGENCIA.html` - Implementação da Fase 5

### Documentação Markdown

- `docs/MANUAL_UTILIZACAO_PARAMETERS.md` - Manual completo de utilização
- `docs/MANUAL_UTILIZACAO_PARAMETERS.html` - Versão HTML do manual

---

## 🔗 REPOSITÓRIO GIT

### GitHub

**Repositório:** [https://github.com/cslsolucoes/ParamentersORM.git](https://github.com/cslsolucoes/ParamentersORM.git)

**Organização:** [cslsolucoes](https://github.com/cslsolucoes)

**Projeto:** ParamentersORM

### Clonar o Repositório

```bash
git clone https://github.com/cslsolucoes/ParamentersORM.git
cd ParamentersORM
```

### Contribuindo

Contribuições são bem-vindas! Por favor:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Licença

Este projeto está licenciado sob a **GPL-3.0 License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

**Autor:** Claiton de Souza Linhares  
**Data de Criação:** 01/01/2026  
**Última Atualização:** 02/01/2026  
**Versão:** 1.0.2  
**Compatibilidade:** ✅ Delphi 10.3+ | ✅ FPC 3.2.2+ / Lazarus 4.4+  
**Castle Engine:** ✅ Configurado (Opcional)

---

## 🔄 MUDANÇAS NA VERSÃO 1.0.2

### Nomenclatura de Métodos
- ✅ `Get()` → `Getter()` (método `Get()` mantido como deprecated)
- ✅ `Update()` → `Setter()` (método `Update()` mantido como deprecated)

### Hierarquia Completa de Identificação
- ✅ Todos os métodos CRUD respeitam a hierarquia: `ContratoID`, `ProdutoID`, `Title`, `Name`
- ✅ Constraint UNIQUE: `(contrato_id, produto_id, titulo, chave)`
- ✅ `Getter()`: Busca específica quando hierarquia configurada, busca ampla quando não configurada (compatibilidade)
- ✅ `Setter()`: Sempre requer hierarquia completa no `TParameter` recebido (INSERT se não existir, UPDATE se existir)

