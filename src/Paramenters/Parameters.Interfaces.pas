unit Parameters.Interfaces;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters.Intefaces - Interfaces do Sistema de Parâmetros
  
  Descrição:
  Define a interface IParametersDatabase para acesso a parâmetros em banco de dados.
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I ../Paramenters.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils, Classes, DB, fpjson, jsonparser,
{$ELSE}
  System.SysUtils, System.Classes, Data.DB, System.JSON,
{$ENDIF}
  // =============================================================================
  // RE-EXPORTAÇÃO DE TIPOS, EXCEÇÕES E CONSTANTES
  // =============================================================================
  // Todas as unidades internas são incluídas aqui para re-exportação.
  // O código externo não precisa conhecer essas unidades diretamente - apenas
  // Parameters.Intefaces é necessário. Isso garante o encapsulamento.
  // =============================================================================
  Parameters.Types,      // Expõe: TParameter, TParameterList, TParameterValueType,
                                 //        TParameterSource, TParameterDatabaseEngine, 
                                 //        TParameterDatabaseTypes, TParameterConfig, TParameterConfigOption
  Parameters.Exceptions,  // Expõe: EParametersException, EParametersConnectionException,
                                 //        EParametersSQLException, EParametersValidationException,
                                 //        EParametersNotFoundException, EParametersConfigurationException,
                                 //        ERR_*, MSG_*
  Parameters.Consts;      // Expõe: TDatabaseTypeNames, DEFAULT_PARAMETER_*, etc.

type
  { =============================================================================
    FORWARD DECLARATIONS
    ============================================================================= }
  TParameterSource    = Parameters.Types.TParameterSource;
  IParametersDatabase = interface;
  IParametersInifiles = interface;
  IParametersJsonObject = interface;
  
  { =============================================================================
    IParametersDatabase - Interface para acesso a parâmetros em banco de dados
    ============================================================================= }
  
  IParametersDatabase = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    
    // ========== CONFIGURAÇÃO (Fluent Interface) ==========
    function TableName(const AValue: string): IParametersDatabase; overload;
    function TableName: string; overload;
    function Schema(const AValue: string): IParametersDatabase; overload;
    function Schema: string; overload;
    function AutoCreateTable(const AValue: Boolean): IParametersDatabase; overload;
    function AutoCreateTable: Boolean; overload;
    
    // ========== CONFIGURAÇÃO DE CONEXÃO (Fluent Interface) ==========
    function Engine(const AValue: string): IParametersDatabase; overload;
    function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase; overload;
    function Engine: string; overload;
    function DatabaseType(const AValue: string): IParametersDatabase; overload;
    function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase; overload;
    function DatabaseType: string; overload;
    function Host(const AValue: string): IParametersDatabase; overload;
    function Host: string; overload;
    function Port(const AValue: Integer): IParametersDatabase; overload;
    function Port: Integer; overload;
    function Username(const AValue: string): IParametersDatabase; overload;
    function Username: string; overload;
    function Password(const AValue: string): IParametersDatabase; overload;
    function Password: string; overload;
    function Database(const AValue: string): IParametersDatabase; overload;
    function Database: string; overload;
    function ContratoID(const AValue: Integer): IParametersDatabase; overload;
    function ContratoID: Integer; overload;
    function ProdutoID(const AValue: Integer): IParametersDatabase; overload;
    function ProdutoID: Integer; overload;
    function Title(const AValue: string): IParametersDatabase; overload;
    function Title: string; overload;
    
    // ========== CRUD ==========
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParametersDatabase; overload;
    function Getter(const AName: string): TParameter; overload;
    function Getter(const AName: string; out AParameter: TParameter): IParametersDatabase; overload;
    function Insert(const AParameter: TParameter): IParametersDatabase; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;
    function Setter(const AParameter: TParameter): IParametersDatabase; overload;
    function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;
    function Delete(const AName: string): IParametersDatabase; overload;
    function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase; overload;
    function Exists(const AName: string): Boolean; overload;
    function Exists(const AName: string; out AExists: Boolean): IParametersDatabase; overload;
    
    // ========== UTILITÁRIOS ==========
    function Count: Integer; overload;
    function Count(out ACount: Integer): IParametersDatabase; overload;
    function IsConnected: Boolean; overload;
    function IsConnected(out AConnected: Boolean): IParametersDatabase; overload;
    function Connect: IParametersDatabase; overload;
    function Connect(out ASuccess: Boolean): IParametersDatabase; overload;
    function Disconnect: IParametersDatabase;
    function Refresh: IParametersDatabase;
    
    // ========== GERENCIAMENTO DE TABELA ==========
    function TableExists: Boolean; overload;
    function TableExists(out AExists: Boolean): IParametersDatabase; overload;
    function CreateTable: IParametersDatabase; overload;
    function CreateTable(out ASuccess: Boolean): IParametersDatabase; overload;
    function DropTable: IParametersDatabase; overload;
    function DropTable(out ASuccess: Boolean): IParametersDatabase; overload;
    function MigrateTable: IParametersDatabase; overload;
    function MigrateTable(out ASuccess: Boolean): IParametersDatabase; overload;
    
    // ========== LISTAGEM DE BANCOS DISPONÍVEIS ==========
    function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase; overload;
    function ListAvailableDatabases: TStringList; overload;
    
    // ========== LISTAGEM DE TABELAS DISPONÍVEIS ==========
    function ListAvailableTables(out ATables: TStringList): IParametersDatabase; overload;
    function ListAvailableTables: TStringList; overload;
    
    // ========== CONFIGURAÇÃO DE CONEXÃO (Independente) ==========
    function Connection(AConnection: TObject): IParametersDatabase; overload;
    function Query(AQuery: TDataSet): IParametersDatabase; overload;
    function ExecQuery(AExecQuery: TDataSet): IParametersDatabase; overload;
  end;
  
  { =============================================================================
    IParametersInifiles - Interface para acesso a parâmetros em arquivos INI
    ============================================================================= }
  
  IParametersInifiles = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
    
    // ========== CONFIGURAÇÃO (Fluent Interface) ==========
    function FilePath(const AValue: string): IParametersInifiles; overload;
    function FilePath: string; overload;
    function Section(const AValue: string): IParametersInifiles; overload;
    function Section: string; overload;
    function AutoCreateFile(const AValue: Boolean): IParametersInifiles; overload;
    function AutoCreateFile: Boolean; overload;
    function ContratoID(const AValue: Integer): IParametersInifiles; overload;
    function ContratoID: Integer; overload;
    function ProdutoID(const AValue: Integer): IParametersInifiles; overload;
    function ProdutoID: Integer; overload;
    function Title(const AValue: string): IParametersInifiles; overload;
    function Title: string; overload;
    
    // ========== CRUD ==========
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParametersInifiles; overload;
    function Getter(const AName: string): TParameter; overload;
    function Getter(const AName: string; out AParameter: TParameter): IParametersInifiles; overload;
    function Insert(const AParameter: TParameter): IParametersInifiles; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles; overload;
    function Setter(const AParameter: TParameter): IParametersInifiles; overload;
    function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles; overload;
    function Delete(const AName: string): IParametersInifiles; overload;
    function Delete(const AName: string; out ASuccess: Boolean): IParametersInifiles; overload;
    function Exists(const AName: string): Boolean; overload;
    function Exists(const AName: string; out AExists: Boolean): IParametersInifiles; overload;
    
    // ========== UTILITÁRIOS ==========
    function Count: Integer; overload;
    function Count(out ACount: Integer): IParametersInifiles; overload;
    function FileExists: Boolean; overload;
    function FileExists(out AExists: Boolean): IParametersInifiles; overload;
    function Refresh: IParametersInifiles;
    
    // ========== IMPORTAÇÃO/EXPORTAÇÃO ==========
    function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;
    function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;
    function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;
    function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;
    
    // ========== NAVEGAÇÃO ==========
    function EndInifiles: IInterface;
  end;
  
  { =============================================================================
    IParametersJsonObject - Interface para acesso a parâmetros em objetos JSON
    ============================================================================= }
  
  IParametersJsonObject = interface
    ['{C3D4E5F6-A7B8-9012-CDEF-234567890123}']
    
    // ========== CONFIGURAÇÃO (Fluent Interface) ==========
    function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject; overload;
    function JsonObject: TJSONObject; overload;
    function ObjectName(const AValue: string): IParametersJsonObject; overload;
    function ObjectName: string; overload;
    function FilePath(const AValue: string): IParametersJsonObject; overload;
    function FilePath: string; overload;
    function AutoCreateFile(const AValue: Boolean): IParametersJsonObject; overload;
    function AutoCreateFile: Boolean; overload;
    function ContratoID(const AValue: Integer): IParametersJsonObject; overload;
    function ContratoID: Integer; overload;
    function ProdutoID(const AValue: Integer): IParametersJsonObject; overload;
    function ProdutoID: Integer; overload;
    function Title(const AValue: string): IParametersJsonObject; overload;
    function Title: string; overload;
    
    // ========== CRUD ==========
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParametersJsonObject; overload;
    function Getter(const AName: string): TParameter; overload;
    function Getter(const AName: string; out AParameter: TParameter): IParametersJsonObject; overload;
    function Insert(const AParameter: TParameter): IParametersJsonObject; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject; overload;
    function Setter(const AParameter: TParameter): IParametersJsonObject; overload;
    function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject; overload;
    function Delete(const AName: string): IParametersJsonObject; overload;
    function Delete(const AName: string; out ASuccess: Boolean): IParametersJsonObject; overload;
    function Exists(const AName: string): Boolean; overload;
    function Exists(const AName: string; out AExists: Boolean): IParametersJsonObject; overload;
    
    // ========== UTILITÁRIOS ==========
    function Count: Integer; overload;
    function Count(out ACount: Integer): IParametersJsonObject; overload;
    function FileExists: Boolean; overload;
    function FileExists(out AExists: Boolean): IParametersJsonObject; overload;
    function Refresh: IParametersJsonObject;
    function ToJSON: TJSONObject; overload;
    function ToJSONString: string; overload;
    function SaveToFile(const AFilePath: string = ''): IParametersJsonObject; overload;
    function SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject; overload;
    function LoadFromString(const AJsonString: string): IParametersJsonObject;
    function LoadFromFile(const AFilePath: string = ''): IParametersJsonObject; overload;
    function LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject; overload;
    
    // ========== IMPORTAÇÃO/EXPORTAÇÃO ==========
    function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject; overload;
    function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject; overload;
    function ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject; overload;
    function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject; overload;
    function ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject; overload;
    function ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject; overload;
    function ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject; overload;
    function ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject; overload;
    
    // ========== NAVEGAÇÃO ==========
    function EndJsonObject: IInterface;
  end;
  
  { =============================================================================
    IParameters - Interface Principal de Convergência
    =============================================================================
    Interface unificada que gerencia múltiplas fontes de dados (Database, INI, JSON)
    com suporte a fallback automático para contingência.
    
    Exemplo de uso:
      var Parameters: IParameters;
      Parameters := TParameters.New([pcfDataBase, pcfInifile]);
      Parameters.Database.Host('localhost').Connect;
      Parameters.Inifiles.FilePath('config.ini');
      Param := Parameters.Get('database_host'); // Busca em cascata: Database → INI
    ============================================================================= }
  
  IParameters = interface
    ['{D1E2F3A4-B5C6-7890-DEF1-234567890ABC}']
    
    // ========== GERENCIAMENTO DE FONTES ==========
    function Source(ASource: TParameterSource): IParameters; overload;
    function Source: TParameterSource; overload;
    function AddSource(ASource: TParameterSource): IParameters;
    function RemoveSource(ASource: TParameterSource): IParameters;
    function HasSource(ASource: TParameterSource): Boolean;
    function Priority(ASources: TParameterSourceArray): IParameters;
    
    // ========== OPERAÇÕES UNIFICADAS (com fallback) ==========
    function Getter(const AName: string): TParameter; overload;
    function Getter(const AName: string; ASource: TParameterSource): TParameter; overload;
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParameters; overload;
    function Insert(const AParameter: TParameter): IParameters; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;
    function Setter(const AParameter: TParameter): IParameters; overload;
    function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;
    function Delete(const AName: string): IParameters; overload;
    function Delete(const AName: string; out ASuccess: Boolean): IParameters; overload;
    function Exists(const AName: string): Boolean; overload;
    function Exists(const AName: string; out AExists: Boolean): IParameters; overload;
    function Count: Integer; overload;
    function Count(out ACount: Integer): IParameters; overload;
    function Refresh: IParameters;
    
    // ========== CONFIGURAÇÃO UNIFICADA ==========
    function ContratoID(const AValue: Integer): IParameters; overload;
    function ContratoID: Integer; overload;
    function ProdutoID(const AValue: Integer): IParameters; overload;
    function ProdutoID: Integer; overload;
    
    // ========== ACESSO DIRETO A FONTES ==========
    // Permite acesso a métodos exclusivos de cada fonte
    function Database: IParametersDatabase;
    function Inifiles: IParametersInifiles;
    function JsonObject: IParametersJsonObject;
    
    // ========== NAVEGAÇÃO ==========
    function EndParameters: IInterface;
  end;

implementation

end.
