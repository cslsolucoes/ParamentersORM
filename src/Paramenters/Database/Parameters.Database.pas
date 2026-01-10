unit Parameters.Database;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters.Database - Implementação de Acesso a Parâmetros em Banco de Dados
  
  Descrição:
  Implementa IParametersDatabase para acesso a parâmetros na tabela config
  do banco de dados. Módulo independente que aceita conexão genérica.
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I ../../ParamentersORM.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils, Classes, DB, fpjson, jsonparser, Math, TypInfo, SyncObjs,
  {$IF DEFINED(WINDOWS)}
  ComObj, ActiveX, Windows, // Para criar arquivo Access via ADOX (apenas Windows)
  {$ENDIF}
{$ELSE}
  System.SysUtils, System.Classes, System.Variants, Data.DB,
  System.JSON, System.DateUtils, System.StrUtils, System.Math, System.TypInfo,
  System.IOUtils, // Para TPath e operações de arquivo (não existe no FPC)
  System.SyncObjs, // Para TCriticalSection (thread-safety)
  ComObj, ActiveX, // Para criar arquivo Access via ADOX
  Winapi.Windows, // Para SetEnvironmentVariable
{$ENDIF}
  Parameters.Intefaces, Parameters.Types, Parameters.Consts,
  Parameters.Exceptions,
  // Engines de banco de dados (independente)
{$IF DEFINED(USE_UNIDAC)}
  Uni, UniProvider, PostgreSQLUniProvider, SQLServerUniProvider, MySQLUniProvider,
  InterBaseUniProvider, SQLiteUniProvider, ODBCUniProvider, AccessUniProvider,
{$ELSE}
  {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
    // FireDAC - Units essenciais para registro de factories e drivers
    FireDAC.Stan.Def,        // Registra todas as factories do FireDAC (OBRIGATÓRIO)
    FireDAC.DApt,            // Data Access Pattern - necessário para TFDQuery (OBRIGATÓRIO)

    // FireDAC - Core
    FireDAC.Stan.Intf,       // Interfaces padrão
    FireDAC.Stan.Option,     // Opções de configuração
    FireDAC.Stan.Error,      // Tratamento de erros
    FireDAC.Stan.Param,      // Parâmetros SQL
    FireDAC.Stan.Pool,       // Pool de conexões
    FireDAC.Stan.Async,      // Operações assíncronas
    FireDAC.Stan.ExprFuncs,  // Funções de expressão

    // FireDAC - Data Access
    FireDAC.DatS,            // Data Structures
    FireDAC.DApt.Intf,       // Interfaces do Data Access Pattern

    // FireDAC - Physical Layer (Drivers)
    FireDAC.Phys.Intf,       // Interfaces físicas
    FireDAC.Phys,            // Implementação física base

    // FireDAC - Driver Definitions (registram os drivers)
    FireDAC.Phys.PGDef,      // PostgreSQL driver definition
    FireDAC.Phys.MSSQLDef,   // SQL Server driver definition
    FireDAC.Phys.MySQLDef,   // MySQL driver definition
    FireDAC.Phys.FBDef,      // FireBird driver definition
    FireDAC.Phys.SQLiteDef,  // SQLite driver definition
    FireDAC.Phys.ODBCDef,    // ODBC driver definition
    FireDAC.Phys.MSAccDef,   // Access driver definition

    // FireDAC - Driver Implementations (implementações dos drivers)
    FireDAC.Phys.PG,         // PostgreSQL implementation
    FireDAC.Phys.MSSQL,      // SQL Server implementation
    FireDAC.Phys.MySQL,      // MySQL implementation
    FireDAC.Phys.FB,         // FireBird implementation
    FireDAC.Phys.SQLite,     // SQLite implementation
    FireDAC.Phys.ODBC,       // ODBC implementation
    FireDAC.Phys.MSAcc,      // Access implementation

    // FireDAC - Componentes
    FireDAC.Comp.Client,     // TFDConnection
    FireDAC.Comp.DataSet,    // TFDQuery, TFDStoredProc, etc.

    // FireDAC - UI (opcional, mas recomendado)
    FireDAC.UI.Intf,         // Interfaces de UI
    FireDAC.VCLUI.Wait,      // Wait cursor para VCL
    FireDAC.Comp.UI,         // Componentes de UI (TFDGUIxWaitCursor)

    // FireDAC - SQLite Wrapper (para SQLite)
    FireDAC.Phys.SQLiteWrapper.Stat,

    // FireDAC - IBBase (base para InterBase/FireBird)
    FireDAC.Phys.IBBase,

    // FireDAC - ODBC Base (base para ODBC)
    FireDAC.Phys.ODBCBase,
  {$ELSE}
    {$IF DEFINED(USE_ZEOS)}
      ZConnection, ZDataset,
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  DataSet.Serialize;

type
  { =============================================================================
    TParametersDatabase - Implementação de IParametersDatabase (Independente)
    ============================================================================= }

  TParametersDatabase = class(TInterfacedObject, IParametersDatabase)
  private
    FConnection: {$IF DEFINED(USE_UNIDAC)}            TUniConnection
                 {$ELSE}
                   {$IF DEFINED(USE_FIREDAC)}  TFDConnection
                   {$ELSE}
                     {$IF DEFINED(USE_ZEOS)}     TZConnection
                     {$ELSE}                         TObject
                     {$ENDIF}
                   {$ENDIF}
                 {$ENDIF};
    FQuery: {$IF DEFINED(USE_UNIDAC)}            TUniQuery
            {$ELSE}
              {$IF DEFINED(USE_FIREDAC)} TFDQuery
              {$ELSE}
                {$IF DEFINED(USE_ZEOS)}    TZQuery
                {$ELSE}                         TDataSet
                {$ENDIF}
              {$ENDIF}
            {$ENDIF};
    FExecQuery: {$IF DEFINED(USE_UNIDAC)}            TUniQuery
                {$ELSE}
                  {$IF DEFINED(USE_FIREDAC)} TFDQuery
                  {$ELSE}
                    {$IF DEFINED(USE_ZEOS)}    TZQuery
                    {$ELSE}                         TDataSet
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF};
    FTableName: string;
    FSchema: string;
    FAutoCreateTable: Boolean;
    FOwnConnection: Boolean;   // Se True, cria e gerencia a conexão internamente
    FEngine: string;
    FDatabaseType: string;
    FHost: string;
    FPort: Integer;
    FUsername: string;
    FPassword: string;
    FDatabase: string;
    FContratoID: Integer;  // Filtro de ContratoID para List
    FProdutoID: Integer;   // Filtro de ProdutoID para List
    {$IF DEFINED(FPC)}
    FLock: SyncObjs.TCriticalSection;  // Thread-safety
    {$ELSE}
    FLock: TCriticalSection;  // Thread-safety
    {$ENDIF}

    // Configurações de reordenação automática
    FAutoReorderOnInsert: Boolean;  // Reordenar automaticamente ao inserir
    FAutoRenumberZeroOrder: Boolean; // Renumerar quando ordem = 0
    FAutoReorderOnUpdate: Boolean;  // Reordenar automaticamente ao atualizar

    // Configurações de importação
    FImportOverwriteExisting: Boolean; // Sobrepor automaticamente na importação
    FImportOverwriteCallback: TParameterImportOverwriteCallback; // Callback para perguntar sobre sobreposição
    {$IF DEFINED(USE_UNIDAC)}
      // UniDAC requer criação manual de providers
      FPostgresProvider: TPostgreSQLUniProvider;
      FMySQLProvider: TMySQLUniProvider;
      FSQLServerProvider: TSQLServerUniProvider;
      FSQLiteProvider: TSQLiteUniProvider;
      FInterBaseProvider: TInterBaseUniProvider;
      FAccessProvider: TAccessUniProvider;
      FODBCProvider: TODBCUniProvider;
    {$ELSE} {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
              // FireDAC NÃO precisa de providers manuais
              // Os drivers são registrados automaticamente quando as units FireDAC.Phys.*Def são incluídas
              // Apenas mantemos uma referência opcional para TFDGUIxWaitCursor (UI)
              FGUIxWait: TFDGUIxWaitCursor;
            {$ENDIF}
    {$ENDIF}

    function GetFullTableName: string;
    function GetFullTableNameForSQL: string; // Nome formatado para SQL (específico por banco)
    function InternalTableExists: Boolean; // Verifica se a tabela existe (método privado)
    function EnsureTableExists: Boolean; // Garante que a tabela existe (lança exceção se não existir)
    function ValidateSQLiteTableStructure: Boolean; // Valida estrutura da tabela SQLite antes de salvar
    function CreateAccessDatabase(const AFilePath: string): Boolean; // Cria arquivo Access .mdb usando ADOX
    function GetDefaultHost: string; // Retorna host padrão baseado no tipo de banco
    function GetDefaultPort: Integer; // Retorna porta padrão baseado no tipo de banco
    function GetDefaultUsername: string; // Retorna username padrão baseado no tipo de banco
    function GetDefaultPassword: string; // Retorna password padrão baseado no tipo de banco
    function GetDefaultDatabase: string; // Retorna database padrão baseado no tipo de banco
    function EscapeSQL(const AValue: string): string;
    function BooleanToSQL(const AValue: Boolean): string; // Converte boolean para formato SQL específico do banco
    function BooleanToSQLCondition(const AValue: Boolean): string; // Converte boolean para condição WHERE
    function BooleanFromDataSet(ADataSet: TDataSet; const AFieldName: string): Boolean; // Converte campo do DataSet para Boolean (considera tipo de banco)
    function ValueTypeToString(const AValueType: TParameterValueType): string;
    function StringToValueType(const AValue: string): TParameterValueType;
    function DataSetToParameter(ADataSet: TDataSet): TParameter;
    function ExecuteSQL(const ASQL: string): Boolean;
    function QuerySQL(const ASQL: string): TDataSet;
    function BuildSelectFieldsSQL: string; // Constrói SQL de SELECT com campos que existem na tabela
    function GetTableColumns: TStringList; // Obtém lista de colunas reais da tabela
    function ValidateTableStructure: Boolean; // Valida se a estrutura da tabela corresponde à esperada
    function GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer; // Obtém próxima ordem disponível
    function TituloExistsForContratoProduto(const ATitulo: string; AContratoID, AProdutoID: Integer; const AExcludeChave: string = ''): Boolean; // Verifica se título existe para Contrato/Produto (excluindo chave específica)
    function ExistsWithTitulo(const AName, ATitulo: string; AContratoID, AProdutoID: Integer): Boolean; // Verifica se chave existe com mesmo nome, título, contrato e produto
    procedure AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer); // Ajusta ordens existentes ao inserir
    procedure AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID, AOldOrder, ANewOrder: Integer; const AChave: string); // Ajusta ordens existentes ao atualizar
    function ListAvailableDatabasesInternal: TStringList; // Lista bancos disponíveis (método privado)
    function ListAvailableTablesInternal: TStringList; // Lista tabelas disponíveis (método privado)

    // Funções auxiliares para conversão de DatabaseType
    function StringToDatabaseType(const AValue: string): TParameterDatabaseTypes;
    function GetDatabaseTypeForEngine(const ADatabaseType: TParameterDatabaseTypes; const AEngine: TParameterDatabaseEngine): string;
    function GetCurrentEngine: TParameterDatabaseEngine;

    // Métodos auxiliares para conexão genérica (usando RTTI)
    function GetConnectionProperty(const APropName: string): Variant;
    procedure SetConnectionProperty(const APropName: string; const AValue: Variant);
    function IsConnectionConnected: Boolean;
    procedure ConnectConnection;
    procedure DisconnectConnection;
    procedure CreateInternalConnection;
    procedure DestroyInternalConnection;
    procedure CreateProviderForDatabaseType(const ADatabaseType: TParameterDatabaseTypes);
    procedure DestroyAllProviders;
    procedure ConfigureFireDACDLLPaths; // Configura caminhos das DLLs do FireDAC
    {$IF DEFINED(USE_ZEOS)}
    procedure ConfigureZeosLibraryLocation(AConnection: TZConnection; ADatabaseType: TParameterDatabaseTypes); // Configura LibraryLocation do Zeos
    {$ENDIF}
  public
    constructor Create; overload;
    constructor Create(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil); overload;
    destructor Destroy; override;

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

    // ========== CONFIGURAÇÃO DE CONEXÃO (Independente) ==========
    function Connection(AConnection: TObject): IParametersDatabase; overload;
    function Query(AQuery: TDataSet): IParametersDatabase; overload;
    function ExecQuery(AExecQuery: TDataSet): IParametersDatabase; overload;

    // ========== CRUD ==========
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParametersDatabase; overload;
    function Get(const AName: string): TParameter; overload;
    function Get(const AName: string; out AParameter: TParameter): IParametersDatabase; overload;
    function Insert(const AParameter: TParameter): IParametersDatabase; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;
    function Update(const AParameter: TParameter): IParametersDatabase; overload;
    function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase; overload;
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

    // ========== LISTAGEM DE BANCOS DISPONÍVEIS ==========
    function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase; overload;
    function ListAvailableDatabases: TStringList; overload;

    // ========== LISTAGEM DE TABELAS DISPONÍVEIS ==========
    function ListAvailableTables(out ATables: TStringList): IParametersDatabase; overload;
    function ListAvailableTables: TStringList; overload;
  end;

implementation

{ =============================================================================
  FUNÇÕES AUXILIARES - DETECÇÃO AUTOMÁTICA DE ENGINE
  ============================================================================= }

function DetectAvailableEngine: TParameterDatabaseEngine;
{ Detecta automaticamente qual engine de banco de dados está disponível
  baseado nas diretivas de compilação USE_UNIDAC, USE_FIREDAC, USE_ZEOS.

  Prioridade: UNIDAC > FireDAC > Zeos

  Retorna:
    - pteUnidac se USE_UNIDAC estiver definido
    - pteFireDAC se USE_FIREDAC estiver definido (e UNIDAC não)
    - pteZeos se USE_ZEOS estiver definido (e UNIDAC/FireDAC não)
    - pteNone se nenhum estiver definido }
begin
  {$IF DEFINED(USE_UNIDAC)}
    Result := pteUnidac;
  {$ELSE}
    {$IF DEFINED(USE_FIREDAC)}
      Result := pteFireDAC;
    {$ELSE}
      {$IF DEFINED(USE_ZEOS)}
        Result := pteZeos;
      {$ELSE}
        Result := pteNone;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

{ TParametersDatabase }

constructor TParametersDatabase.Create;
var
  LDetectedEngine: TParameterDatabaseEngine;
begin
  inherited Create;
  {$IF DEFINED(FPC)}
  FLock := SyncObjs.TCriticalSection.Create;  // Thread-safety
  {$ELSE}
  FLock := TCriticalSection.Create;  // Thread-safety
  {$ENDIF}
  FConnection := nil;
  FQuery := nil;
  FExecQuery := nil;
  FTableName := DEFAULT_PARAMETERS_TABLE;
  FSchema := DEFAULT_PARAMETERS_SCHEMA;
  FAutoCreateTable := False;
  FOwnConnection := True;
  FContratoID := 0;
  FProdutoID := 0;

  // Inicializa configurações de reordenação com valores padrão das constantes
  FAutoReorderOnInsert := DEFAULT_PARAMETER_AUTO_REORDER_ON_INSERT;
  FAutoRenumberZeroOrder := DEFAULT_PARAMETER_AUTO_RENUMBER_ZERO_ORDER;
  FAutoReorderOnUpdate := DEFAULT_PARAMETER_AUTO_REORDER_ON_UPDATE;
  
  // Inicializa configurações de importação com valores padrão das constantes
  FImportOverwriteExisting := DEFAULT_PARAMETER_IMPORT_OVERWRITE_EXISTING;
  FImportOverwriteCallback := nil;
  
  // Inicializa providers como nil
  {$IF DEFINED(USE_UNIDAC)}
  FPostgresProvider := nil;
  FSQLServerProvider := nil;
  FMySQLProvider := nil;
  FInterBaseProvider := nil;
  FSQLiteProvider := nil;
  FODBCProvider := nil;
  FAccessProvider := nil;
  {$ELSE}
    {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
      // FireDAC não precisa inicializar providers - os drivers são registrados automaticamente
      // quando as units FireDAC.Phys.*Def são incluídas no uses
      // Inicializa apenas componentes de UI opcionais
      FGUIxWait := nil; // Pode ser criado sob demanda se necessário
    {$ENDIF}
  {$ENDIF}
  
  // DETECÇÃO AUTOMÁTICA DE ENGINE
  // Detecta automaticamente qual engine está disponível baseado nas diretivas de compilação
  LDetectedEngine := DetectAvailableEngine;

  // Configura o engine automaticamente se foi detectado
  if LDetectedEngine <> pteNone then
  begin
    // Configura FEngine usando o enum detectado
    FEngine := TEngineDatabase[LDetectedEngine];
  end
  else
  begin
    // Se nenhum engine foi detectado, usa o valor padrão (pode ser 'None' ou string vazia)
    FEngine := DEFAULT_PARAMETERS_ENGINE;
  end;
  
  // Inicializa configurações de conexão com valores padrão
  FDatabaseType := DEFAULT_PARAMETERS_DATABASE_TYPE;
  FHost := DEFAULT_PARAMETERS_HOST;
  FPort := DEFAULT_PARAMETERS_PORT;
  FUsername := DEFAULT_PARAMETERS_USERNAME;
  FPassword := DEFAULT_PARAMETERS_PASSWORD;
  FDatabase := DEFAULT_PARAMETERS_DATABASE;
  
  // Configura caminhos das DLLs do FireDAC (se aplicável)
  {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
  ConfigureFireDACDLLPaths;
  {$ENDIF}
  
  // Cria conexão interna usando constantes
  CreateInternalConnection;
  
  // Conecta automaticamente (já que constantes estão definidas)
  if Assigned(FConnection) then
    ConnectConnection;
end;

constructor TParametersDatabase.Create(AConnection: TObject; AQuery: TDataSet; AExecQuery: TDataSet);
var
  LDetectedEngine: TParameterDatabaseEngine;
begin
  inherited Create;
  {$IF DEFINED(FPC)}
  FLock := SyncObjs.TCriticalSection.Create;  // Thread-safety
  {$ELSE}
  FLock := TCriticalSection.Create;  // Thread-safety
  {$ENDIF}
  FConnection := nil;
  FQuery := nil;
  FExecQuery := nil;
  
  // Converte TObject para o tipo específico do engine (cast seguro)
  if Assigned(AConnection) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
    if AConnection is TUniConnection then
      FConnection := TUniConnection(AConnection);
    {$ELSE}
      {$IF DEFINED(USE_FIREDAC)}
        if AConnection is TFDConnection then
          FConnection := TFDConnection(AConnection);
      {$ELSE}
        {$IF DEFINED(USE_ZEOS)}
          if AConnection is TZConnection then
            FConnection := TZConnection(AConnection);
        {$ELSE}
          FConnection := AConnection;
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  end;

  // Converte TDataSet para o tipo específico do engine (cast seguro)
  if Assigned(AQuery) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
    if AQuery is TUniQuery then
      FQuery := TUniQuery(AQuery);
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
               if AQuery is TFDQuery then
               FQuery := TFDQuery(AQuery);
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                       if AQuery is TZQuery then
                       FQuery := TZQuery(AQuery);
                    {$ELSE}
                       FQuery := AQuery;
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}
  end;

  if Assigned(AExecQuery) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
      FExecQuery := TUniQuery(AExecQuery);
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              FExecQuery := TFDQuery(AExecQuery);
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      FExecQuery := TZQuery(AExecQuery);
                    {$ELSE}
                      FExecQuery := AExecQuery;
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}
  end;

  FTableName := DEFAULT_PARAMETERS_TABLE;
  FSchema := DEFAULT_PARAMETERS_SCHEMA;
  FAutoCreateTable := False;
  FOwnConnection := False; // Não gerencia a conexão externa
  FContratoID := 0;
  FProdutoID := 0;

  // Inicializa configurações de reordenação com valores padrão das constantes
  FAutoReorderOnInsert := DEFAULT_PARAMETER_AUTO_REORDER_ON_INSERT;
  FAutoRenumberZeroOrder := DEFAULT_PARAMETER_AUTO_RENUMBER_ZERO_ORDER;
  FAutoReorderOnUpdate := DEFAULT_PARAMETER_AUTO_REORDER_ON_UPDATE;

  // Inicializa configurações de importação com valores padrão das constantes
  FImportOverwriteExisting := DEFAULT_PARAMETER_IMPORT_OVERWRITE_EXISTING;
  FImportOverwriteCallback := nil;

  // DETECÇÃO AUTOMÁTICA DE ENGINE
  // Detecta automaticamente qual engine está disponível baseado nas diretivas de compilação
  LDetectedEngine := DetectAvailableEngine;

  // Configura o engine automaticamente se foi detectado
  if LDetectedEngine <> pteNone then
  begin
    // Configura FEngine usando o enum detectado
    FEngine := TEngineDatabase[LDetectedEngine];
  end
  else
  begin
    // Se nenhum engine foi detectado, usa o valor padrão (pode ser 'None' ou string vazia)
    FEngine := DEFAULT_PARAMETERS_ENGINE;
  end;

  // Inicializa outras configurações de conexão com valores padrão
  FDatabaseType := DEFAULT_PARAMETERS_DATABASE_TYPE;
  FHost := DEFAULT_PARAMETERS_HOST;
  FPort := DEFAULT_PARAMETERS_PORT;
  FUsername := DEFAULT_PARAMETERS_USERNAME;
  FPassword := DEFAULT_PARAMETERS_PASSWORD;
  FDatabase := DEFAULT_PARAMETERS_DATABASE;
end;

destructor TParametersDatabase.Destroy;
begin
  FLock.Enter;
  try
    Disconnect;
    if FOwnConnection then
      DestroyInternalConnection;
  finally
    FLock.Leave;
  end;
  FreeAndNil(FLock);  // Thread-safety
  inherited;
end;

procedure TParametersDatabase.CreateInternalConnection;
var
  LDatabaseType: TParameterDatabaseTypes;
  LEngine: TParameterDatabaseEngine;
  LDriverName: string;
begin
  // Cria conexão interna usando configurações (valores padrão ou setados)
  if not Assigned(FConnection) then
  begin
    FConnection := {$IF DEFINED(USE_UNIDAC)}
                      TUniConnection.Create(nil)
                   {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                             TFDConnection.Create(nil)
                           {$ELSE} {$IF DEFINED(USE_ZEOS)}
                                     TZConnection.Create(nil)
                                   {$ELSE}
                                     nil
                                   {$ENDIF}
                           {$ENDIF}
                   {$ENDIF};

    if Assigned(FConnection) then
    begin
      // Converte FDatabaseType (string) para enum e obtém engine atual
      LDatabaseType := StringToDatabaseType(FDatabaseType);
      LEngine := GetCurrentEngine;

      // IMPORTANTE: Para FireDAC, configura VendorLib IMEDIATAMENTE após criar a conexão
      // Isso deve ser feito ANTES de qualquer outra configuração, incluindo DriverName
      // O FireDAC tenta carregar a DLL quando DriverName é definido, então VendorLib
      // deve estar configurado antes disso
      // Além disso, adiciona o diretório das DLLs ao PATH do processo para garantir
      // que dependências (como LIBEAY32.dll, SSLEAY32.dll para PostgreSQL) sejam encontradas
      {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
      case LDatabaseType of
        pdtMySQL:
        begin
          // MySQL: configura VendorLib IMEDIATAMENTE
          {$IF DEFINED(WIN64)}
          if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql\libmysql.dll') then
          begin
            TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql\libmysql.dll';
            // Adiciona diretório ao PATH para dependências
            {$IF DEFINED(WINDOWS)}
              {$IF DEFINED(FPC)}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql'));
              {$ELSE}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql'));
              {$ENDIF}
            {$ENDIF}
          end;
          {$ELSE}
          if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql\libmysql.dll') then
          begin
            TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql\libmysql.dll';
            // Adiciona diretório ao PATH para dependências
            {$IF DEFINED(WINDOWS)}
              {$IF DEFINED(FPC)}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql'));
              {$ELSE}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql'));
              {$ENDIF}
            {$ENDIF}
          end;
          {$ENDIF}
        end;
        pdtPostgreSQL:
        begin
          // PostgreSQL: configura VendorLib IMEDIATAMENTE
          {$IF DEFINED(WIN64)}
          if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib\libpq.dll') then
          begin
            TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib\libpq.dll';
            // Adiciona diretório ao PATH para dependências (LIBEAY32.dll, SSLEAY32.dll, etc.)
            {$IF DEFINED(WINDOWS)}
              {$IF DEFINED(FPC)}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib'));
              {$ELSE}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib'));
              {$ENDIF}
            {$ENDIF}
          end;
          {$ELSE}
          if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib\libpq.dll') then
          begin
            TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib\libpq.dll';
            // Adiciona diretório ao PATH para dependências (LIBEAY32.dll, SSLEAY32.dll, etc.)
            {$IF DEFINED(WINDOWS)}
              {$IF DEFINED(FPC)}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib'));
              {$ELSE}
              SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib'));
              {$ENDIF}
            {$ENDIF}
          end;
          {$ENDIF}
        end;
      end;
      {$ENDIF}

      // IMPORTANTE: Cria provider ANTES de configurar a conexão (UNIDAC requer isso)
      {$IF DEFINED(USE_UNIDAC)}
        CreateProviderForDatabaseType(LDatabaseType);
      {$ELSE} {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
                CreateProviderForDatabaseType(LDatabaseType);
              {$ENDIF}
      {$ENDIF}

      // Configura conexão usando valores configurados (ou padrão)
      {$IF DEFINED(USE_UNIDAC)}
        // Para UNIDAC, usa TDatabaseUnidac que já retorna o nome correto do provider
        LDriverName := GetDatabaseTypeForEngine(LDatabaseType, LEngine);
        if (LDriverName <> '') and (LDriverName <> 'None') then
          TUniConnection(FConnection).ProviderName := LDriverName
        else if FDatabaseType <> '' then
          TUniConnection(FConnection).ProviderName := FDatabaseType // Fallback para nome genérico
        else
          TUniConnection(FConnection).ProviderName := 'PostgreSQL'; // Fallback padrão

        // Para SQLite e Access, configura propriedades específicas
        if (LDatabaseType = pdtSQLite) or (LDatabaseType = pdtAccess) then
        begin
          // SQLite e Access não usam Server, Port, Username, Password
          TUniConnection(FConnection).Server := '';
          TUniConnection(FConnection).Port := 0;
          TUniConnection(FConnection).Username := '';
          TUniConnection(FConnection).Password := '';
          // Database deve conter o caminho completo do arquivo
          // IMPORTANTE: Para Access, o caminho deve estar atualizado ANTES de conectar
          // (já atualizado em ConnectConnection se necessário)
          TUniConnection(FConnection).Database := FDatabase;
          // SQLite e Access criam o arquivo automaticamente se não existir
          // Mas o diretório precisa existir (já tratado em ConnectConnection)
        end
        else
        begin
          // Para outros bancos, configura normalmente
        TUniConnection(FConnection).Server := FHost;
        TUniConnection(FConnection).Port := FPort;
        TUniConnection(FConnection).Username := FUsername;
        TUniConnection(FConnection).Password := FPassword;
        TUniConnection(FConnection).Database := FDatabase;
        end;
      {$ELSE} {$IF DEFINED(USE_FIREDAC)}
        // IMPORTANTE: VendorLib já foi configurado acima (linhas 389-413) ANTES de qualquer outra propriedade
        // Agora define o DriverName (VendorLib já está configurado e será usado quando DriverName for definido)
        LDriverName := GetDatabaseTypeForEngine(LDatabaseType, LEngine);
        if (LDriverName <> '') and (LDriverName <> 'None') then
          TFDConnection(FConnection).DriverName := LDriverName
        else
          TFDConnection(FConnection).DriverName := 'PG'; // Fallback padrão

        // Para SQLite e Access, configura propriedades específicas
        if (LDatabaseType = pdtSQLite) or (LDatabaseType = pdtAccess) then
        begin
          // SQLite e Access não usam Server, Port, Username, Password
          // FireDAC Access (MSAcc) usa Database com caminho completo do arquivo
          TFDConnection(FConnection).Params.Values['Database'] := FDatabase;
          // Remove parâmetros não usados
          TFDConnection(FConnection).Params.Values['Server'] := '';
          TFDConnection(FConnection).Params.Values['Port'] := '';
          TFDConnection(FConnection).Params.Values['User_Name'] := '';
          TFDConnection(FConnection).Params.Values['Password'] := '';
        end
        else
        begin
          // Para outros bancos, configura normalmente
        TFDConnection(FConnection).Params.Values['Server'] := FHost;
        TFDConnection(FConnection).Params.Values['Port'] := IntToStr(FPort);
        TFDConnection(FConnection).Params.Values['User_Name'] := FUsername;
        TFDConnection(FConnection).Params.Values['Password'] := FPassword;
        TFDConnection(FConnection).Params.Values['Database'] := FDatabase;
        end;
      {$ELSE} {$IF DEFINED(USE_ZEOS)}
        // Para Zeos, configura LibraryLocation ANTES de definir o protocolo
        // Isso é importante para SQL Server com FreeTDS
        if (LDatabaseType = pdtPostgreSQL) or (LDatabaseType = pdtMySQL) or (LDatabaseType = pdtSQLServer) then
          ConfigureZeosLibraryLocation(TZConnection(FConnection), LDatabaseType);

        // Para Zeos, usa TDatabaseZeus que retorna o protocolo correto (postgresql, mysql, etc.)
        LDriverName := GetDatabaseTypeForEngine(LDatabaseType, LEngine);
        if (LDriverName <> '') and (LDriverName <> 'None') then
        begin
          // SQL Server: usa mssql (protocolo padrão) com LibraryLocation configurado para FreeTDS
          // O Zeos usará a DLL do FreeTDS (libsybdb-5.dll) configurada em LibraryLocation
          if LDatabaseType = pdtSQLServer then
            TZConnection(FConnection).Protocol := 'mssql'
          else
            // ODBC e Access: usa protocolos diretamente (odbc_a e OleDB)
            // Não requer unidades ZDbcODBC ou ZDbcOleDB - funcionam nativamente
            TZConnection(FConnection).Protocol := LDriverName;
        end
        else
          TZConnection(FConnection).Protocol := 'postgresql'; // Fallback padrão

        // Configura propriedades básicas da conexão
        TZConnection(FConnection).HostName := FHost;
        TZConnection(FConnection).Port := FPort;
        TZConnection(FConnection).User := FUsername;
        TZConnection(FConnection).Password := FPassword;

        // Para ODBC: Database contém o DSN (Data Source Name)
        // Para Access: Database contém o caminho completo do arquivo .mdb
        // Para outros: Database contém o nome do banco de dados
        TZConnection(FConnection).Database := FDatabase;
      {$ENDIF}
      {$ENDIF}
      {$ENDIF}
    end;

    // Cria queries
    if not Assigned(FQuery) then
      FQuery := {$IF DEFINED(USE_UNIDAC)}
                   TUniQuery.Create(nil)
                {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                          TFDQuery.Create(nil)
                        {$ELSE} {$IF DEFINED(USE_ZEOS)}
                                  TZQuery.Create(nil)
                                {$ELSE}
                                  nil
                                {$ENDIF}
                        {$ENDIF}
                {$ENDIF};

    if not Assigned(FExecQuery) then
      FExecQuery := {$IF DEFINED(USE_UNIDAC)}
                      TUniQuery.Create(nil)
                    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                              TFDQuery.Create(nil)
                            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                                      TZQuery.Create(nil)
                                    {$ELSE}
                                      nil
                                    {$ENDIF}
                            {$ENDIF}
                    {$ENDIF};

    // Associa queries à conexão
    if Assigned(FQuery) and Assigned(FConnection) then
    begin
      {$IF DEFINED(USE_UNIDAC)}
        TUniQuery(FQuery).Connection := TUniConnection(FConnection);
      {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                TFDQuery(FQuery).Connection := TFDConnection(FConnection);
              {$ELSE} {$IF DEFINED(USE_ZEOS)}
                        TZQuery(FQuery).Connection := TZConnection(FConnection);
                      {$ENDIF}
              {$ENDIF}
     {$ENDIF}
    end;

    if Assigned(FExecQuery) and Assigned(FConnection) then
    begin
      {$IF DEFINED(USE_UNIDAC)}
        TUniQuery(FExecQuery).Connection := TUniConnection(FConnection);
      {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                TFDQuery(FExecQuery).Connection := TFDConnection(FConnection);
              {$ELSE} {$IF DEFINED(USE_ZEOS)}
                        TZQuery(FExecQuery).Connection := TZConnection(FConnection);
                      {$ENDIF}
              {$ENDIF}
      {$ENDIF}
    end;
  end;
end;

procedure TParametersDatabase.DestroyInternalConnection;
begin
  // Libera queries primeiro
  if Assigned(FExecQuery) and FOwnConnection then
  begin
    try
      if FExecQuery.Active then
        FExecQuery.Close;
    except
      // Ignorar erros
    end;
    FExecQuery.Free;
    FExecQuery := nil;
  end;

  if Assigned(FQuery) and FOwnConnection then
  begin
    try
      if FQuery.Active then
        FQuery.Close;
    except
      // Ignorar erros
    end;
    FQuery.Free;
    FQuery := nil;
  end;

  // Libera conexão interna se foi criada
  if Assigned(FConnection) and FOwnConnection then
  begin
    try
      DisconnectConnection;
    except
      // Ignorar erros
    end;
    FConnection.Free;
    FConnection := nil;
  end;

  // Libera todos os providers
  {$IF DEFINED(USE_UNIDAC) OR DEFINED(USE_FIREDAC)}
    if FOwnConnection then
      DestroyAllProviders;
  {$ENDIF}
end;

procedure TParametersDatabase.CreateProviderForDatabaseType(const ADatabaseType: TParameterDatabaseTypes);
begin
  {$IF DEFINED(USE_UNIDAC)}
  case ADatabaseType of
    pdtPostgreSQL:
      if not Assigned(FPostgresProvider) then
        FPostgresProvider := TPostgreSQLUniProvider.Create(nil);
    pdtSQLServer:
      if not Assigned(FSQLServerProvider) then
        FSQLServerProvider := TSQLServerUniProvider.Create(nil);
    pdtMySQL:
      if not Assigned(FMySQLProvider) then
        FMySQLProvider := TMySQLUniProvider.Create(nil);
    pdtFireBird:
      if not Assigned(FInterBaseProvider) then
        FInterBaseProvider := TInterBaseUniProvider.Create(nil);
    pdtSQLite:
      if not Assigned(FSQLiteProvider) then
        FSQLiteProvider := TSQLiteUniProvider.Create(nil);
    pdtODBC:
      if not Assigned(FODBCProvider) then
        FODBCProvider := TODBCUniProvider.Create(nil);
    pdtAccess:
      if not Assigned(FAccessProvider) then
        FAccessProvider := TAccessUniProvider.Create(nil);
  else
    // Para tipos não suportados ou None, não cria provider
  end;
  {$ELSE}
      {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
      // FireDAC não precisa criar providers manualmente
      // Os drivers são registrados automaticamente quando as units FireDAC.Phys.*Def são incluídas
      // Apenas configuramos o DriverName na conexão, que já está sendo feito em CreateInternalConnection
      {$ENDIF}
  {$ENDIF}
end;

procedure TParametersDatabase.DestroyAllProviders;
begin
  {$IF DEFINED(USE_UNIDAC)}
    if Assigned(FPostgresProvider) then
    begin
      FPostgresProvider.Free;
      FPostgresProvider := nil;
    end;
    if Assigned(FSQLServerProvider) then
    begin
      FSQLServerProvider.Free;
      FSQLServerProvider := nil;
    end;
    if Assigned(FMySQLProvider) then
    begin
      FMySQLProvider.Free;
      FMySQLProvider := nil;
    end;
    if Assigned(FInterBaseProvider) then
    begin
      FInterBaseProvider.Free;
      FInterBaseProvider := nil;
    end;
    if Assigned(FSQLiteProvider) then
    begin
      FSQLiteProvider.Free;
      FSQLiteProvider := nil;
    end;
    if Assigned(FODBCProvider) then
    begin
      FODBCProvider.Free;
      FODBCProvider := nil;
    end;
    if Assigned(FAccessProvider) then
    begin
      FAccessProvider.Free;
      FAccessProvider := nil;
    end;
  {$ELSE}
      {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
        // FireDAC não precisa destruir providers - os drivers são gerenciados automaticamente
      {$ENDIF}
  {$ENDIF}
end;

procedure TParametersDatabase.ConfigureFireDACDLLPaths;
{$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
  begin
    // A configuração das DLLs é feita diretamente na conexão em CreateInternalConnection
    // e ConnectConnection através de TFDConnection(FConnection).Params.Values['VendorLib']
    //
    // IMPORTANTE: O FireDAC não possui uma API global simples para configurar VendorLib
    // via FDManager antes de criar conexões. A configuração deve ser feita diretamente
    // na conexão antes de definir o DriverName e antes de conectar.
    //
    // Esta função é mantida para compatibilidade futura, mas a configuração real
    // acontece em:
    // 1. CreateInternalConnection - configura VendorLib ANTES de definir DriverName
    // 2. ConnectConnection - garante VendorLib configurado ANTES de conectar
    //
    // Isso garante que o FireDAC encontre as DLLs no caminho correto.
  end;
{$ELSE}
  begin
    // Não é FireDAC, não faz nada
  end;
{$ENDIF}

function TParametersDatabase.GetConnectionProperty(const APropName: string): Variant;
var
  LPropInfo: PPropInfo;
begin
  Result := Null;
  if not Assigned(FConnection) then
    Exit;

  LPropInfo := GetPropInfo(FConnection.ClassInfo, APropName);
  if Assigned(LPropInfo) then
    Result := GetPropValue(FConnection, APropName);
end;

procedure TParametersDatabase.SetConnectionProperty(const APropName: string; const AValue: Variant);
var
  LPropInfo: PPropInfo;
begin
  if not Assigned(FConnection) then
    Exit;

  LPropInfo := GetPropInfo(FConnection.ClassInfo, APropName);
  if Assigned(LPropInfo) then
    SetPropValue(FConnection, APropName, AValue);
end;

function TParametersDatabase.IsConnectionConnected: Boolean;
begin
  Result := False;
  if not Assigned(FConnection) then
    Exit;

  {$IF DEFINED(USE_UNIDAC)}
  Result := TUniConnection(FConnection).Connected;
  {$ELSE} {$IF DEFINED(USE_FIREDAC)}
            Result := TFDConnection(FConnection).Connected;
          {$ELSE} {$IF DEFINED(USE_ZEOS)}
                    Result := TZConnection(FConnection).Connected;
                  {$ELSE}
                    Result := GetConnectionProperty('Connected');
                  {$ENDIF}
          {$ENDIF}
  {$ENDIF}
end;

procedure TParametersDatabase.ConnectConnection;
var
  LDatabaseType: TParameterDatabaseTypes;
  LDatabasePath: string;
  LDirectory: string;
  LDrive: string;
  {$IF DEFINED(USE_UNIDAC)}
    LFileStream: TFileStream;
  {$ELSE} {$IF DEFINED(USE_ZEOS)}
            LFileStream: TFileStream;
          {$ENDIF}
  {$ENDIF}
begin
  if not Assigned(FConnection) then
    raise CreateConnectionException(MSG_CONNECTION_NOT_ASSIGNED, ERR_CONNECTION_NOT_ASSIGNED, 'ConnectConnection');

  // Para SQLite, Access e FireBird (arquivo local), garante que o diretório do arquivo existe antes de conectar
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  if (LDatabaseType = pdtSQLite) or (LDatabaseType = pdtAccess) or (LDatabaseType = pdtFireBird) then
  begin
    LDatabasePath := Trim(FDatabase);
    if LDatabasePath <> '' then
    begin
      // Para SQLite e Access, verifica se o caminho é um diretório (pasta) ou arquivo
      // Se for uma pasta, cria um arquivo dentro dela usando o nome da tabela
      // IMPORTANTE: FTableName já deve estar definido antes de chamar ConnectConnection
      if DirectoryExists(LDatabasePath) or
         ((not FileExists(LDatabasePath)) and (ExtractFileName(LDatabasePath) = '')) then
      begin
        // Se for uma pasta (ou caminho sem nome de arquivo), cria um arquivo dentro dela
        // Usa o nome da tabela como nome do arquivo, ou 'config' como padrão
        if FTableName <> '' then
        begin
          if LDatabaseType = pdtSQLite then
            LDatabasePath := IncludeTrailingPathDelimiter(LDatabasePath) + FTableName + '.db'
          else if LDatabaseType = pdtAccess then
            LDatabasePath := IncludeTrailingPathDelimiter(LDatabasePath) + FTableName + '.mdb';
        end
        else
        begin
          if LDatabaseType = pdtSQLite then
            LDatabasePath := IncludeTrailingPathDelimiter(LDatabasePath) + 'config.db'
          else if LDatabaseType = pdtAccess then
            LDatabasePath := IncludeTrailingPathDelimiter(LDatabasePath) + 'config.mdb';
        end;

        // Atualiza FDatabase com o caminho completo do arquivo
        FDatabase := LDatabasePath;
        // IMPORTANTE: Atualiza a propriedade Database da conexão ANTES de conectar
        // Para Access, garante que o provider está configurado corretamente
        {$IF DEFINED(USE_UNIDAC)}
          if Assigned(FConnection) then
          begin
            // Para Access, garante que o provider está configurado ANTES de definir Database
            if LDatabaseType = pdtAccess then
            begin
              // Access via UniDAC usa provider "Access"
              // IMPORTANTE: Provider deve estar configurado ANTES de definir Database
              if TUniConnection(FConnection).ProviderName <> 'Access' then
                TUniConnection(FConnection).ProviderName := 'Access';

              // Access via ODBC pode precisar de configurações específicas
              // Define Database com caminho completo do arquivo .mdb
              // O Access via UniDAC usa o caminho do arquivo diretamente
              TUniConnection(FConnection).Database := FDatabase;

              // Access não usa Server, Port, Username, Password
              TUniConnection(FConnection).Server := '';
              TUniConnection(FConnection).Port := 0;
              TUniConnection(FConnection).Username := '';
              TUniConnection(FConnection).Password := '';
            end
            else
            begin
              // Define Database normalmente para outros bancos
              TUniConnection(FConnection).Database := FDatabase;
            end;
          end;
        {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                  if Assigned(FConnection) then
                  begin
                    // Para Access, garante que o driver está configurado corretamente
                    if LDatabaseType = pdtAccess then
                    begin
                      // FireDAC Access usa driver "MSAcc"
                      if TFDConnection(FConnection).DriverName <> 'MSAcc' then
                        TFDConnection(FConnection).DriverName := 'MSAcc';

                      // FireDAC Access usa Database com caminho completo do arquivo
                      TFDConnection(FConnection).Params.Values['Database'] := FDatabase;

                      // Access não usa Server, Port, Username, Password
                      TFDConnection(FConnection).Params.Values['Server'] := '';
                      TFDConnection(FConnection).Params.Values['Port'] := '';
                      TFDConnection(FConnection).Params.Values['User_Name'] := '';
                      TFDConnection(FConnection).Params.Values['Password'] := '';
                    end
                    else
                    begin
                      // Define Database normalmente para outros bancos
                      TFDConnection(FConnection).Params.Values['Database'] := FDatabase;
                    end;
                  end;
                {$ELSE} {$IF DEFINED(USE_ZEOS)}
                          if Assigned(FConnection) then
                            TZConnection(FConnection).Database := FDatabase;
                        {$ENDIF}
                {$ENDIF}
        {$ENDIF}
      end;

      // Extrai o diretório do caminho do arquivo (funciona tanto para pasta quanto arquivo)
      LDirectory := ExtractFilePath(LDatabasePath);

      // Remove a barra final se houver (exceto para drives como C:\)
      if (LDirectory <> '') and (Length(LDirectory) > 1) then
      begin
        // Se for um drive (C:\), mantém a barra
        if (Length(LDirectory) = 3) and (LDirectory[2] = ':') then
          // É um drive (C:\), mantém a barra - não faz nada
        else if LDirectory[Length(LDirectory)] = PathDelim then
          LDirectory := Copy(LDirectory, 1, Length(LDirectory) - 1);
      end;

      // Se o diretório não existe, cria
      if (LDirectory <> '') and not DirectoryExists(LDirectory) then
      begin
        try
          ForceDirectories(LDirectory);
        except
          // Se falhar ao criar diretório, lança exceção mais clara
          raise CreateConnectionException(
            Format('Nao foi possivel criar o diretorio do arquivo SQLite: %s' + sLineBreak +
                   'Verifique as permissoes do diretorio.', [LDirectory]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          );
        end;
      end;

      // Verifica novamente se o diretório existe após tentar criar
      if (LDirectory <> '') and not DirectoryExists(LDirectory) then
      begin
        {$IF DEFINED(FPC)}
        if LDatabaseType = pdtSQLite then
          raise CreateConnectionException(
            Format('Diretorio do arquivo SQLite nao existe e nao pode ser criado: %s' + sLineBreak +
                   'Caminho completo: %s',
                   [LDirectory, LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          )
        else
          raise CreateConnectionException(
            Format('Diretorio do arquivo Access nao existe e nao pode ser criado: %s' + sLineBreak +
                   'Caminho completo: %s',
                   [LDirectory, LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          );
        {$ELSE}
        var LDBTypeName: string := IfThen(LDatabaseType = pdtSQLite, 'SQLite', 'Access');
        raise CreateConnectionException(
          Format('Diretorio do arquivo %s nao existe e nao pode ser criado: %s' + sLineBreak +
                 'Caminho completo: %s',
                 [LDBTypeName, LDirectory, LDatabasePath]),
          ERR_CONNECTION_FAILED,
          'ConnectConnection'
        );
        {$ENDIF}
      end;

      // Para SQLite, Access e FireBird (arquivo local), verifica se o caminho do arquivo é válido
      if ExtractFileName(LDatabasePath) = '' then
      begin
        {$IF DEFINED(FPC)}
        if LDatabaseType = pdtSQLite then
          raise CreateConnectionException(
            Format('Caminho do arquivo SQLite invalido: %s' + sLineBreak +
                   'O caminho deve apontar para um arquivo, nao apenas um diretorio.',
                   [LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          )
        else if LDatabaseType = pdtAccess then
          raise CreateConnectionException(
            Format('Caminho do arquivo Access invalido: %s' + sLineBreak +
                   'O caminho deve apontar para um arquivo, nao apenas um diretorio.',
                   [LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          )
        else
          raise CreateConnectionException(
            Format('Caminho do arquivo FireBird invalido: %s' + sLineBreak +
                   'O caminho deve apontar para um arquivo, nao apenas um diretorio.',
                   [LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          );
        {$ELSE}
        var LDBTypeName2: string := IfThen(LDatabaseType = pdtSQLite, 'SQLite',
                                           IfThen(LDatabaseType = pdtAccess, 'Access', 'FireBird'));
        raise CreateConnectionException(
          Format('Caminho do arquivo %s invalido: %s' + sLineBreak +
                 'O caminho deve apontar para um arquivo, nao apenas um diretorio.',
                 [LDBTypeName2, LDatabasePath]),
          ERR_CONNECTION_FAILED,
          'ConnectConnection'
        );
        {$ENDIF}
      end;

      // Para FireBird, valida se o drive está acessível e o diretório existe
      if LDatabaseType = pdtFireBird then
      begin
        // Extrai o drive do caminho (ex: D:)
        LDrive := ExtractFileDrive(LDatabasePath);
        if LDrive <> '' then
        begin
          // Verifica se o drive existe e está acessível
          if not DirectoryExists(LDrive + PathDelim) then
          begin
            raise CreateConnectionException(
              Format('Drive %s nao esta acessivel ou nao existe.' + sLineBreak +
                     'Caminho do arquivo: %s' + sLineBreak +
                     'Verifique se o drive esta conectado e acessivel.',
                     [LDrive, LDatabasePath]),
              ERR_CONNECTION_FAILED,
              'ConnectConnection'
            );
          end;
        end;

        // Verifica se o diretório do arquivo existe
        LDirectory := ExtractFilePath(LDatabasePath);
        if (LDirectory <> '') and not DirectoryExists(LDirectory) then
        begin
          raise CreateConnectionException(
            Format('Diretorio do arquivo FireBird nao existe: %s' + sLineBreak +
                   'Caminho completo: %s' + sLineBreak +
                   'Verifique se o diretorio existe e esta acessivel.',
                   [LDirectory, LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          );
        end;

        // Verifica se o arquivo existe (FireBird não cria automaticamente)
        if not FileExists(LDatabasePath) then
        begin
          raise CreateConnectionException(
            Format('Arquivo FireBird nao encontrado: %s' + sLineBreak +
                   'O arquivo deve existir antes de conectar.' + sLineBreak +
                   'Verifique se o caminho esta correto e o arquivo existe.',
                   [LDatabasePath]),
            ERR_CONNECTION_FAILED,
            'ConnectConnection'
          );
        end;
      end;

      // Para UniDAC SQLite, cria o arquivo manualmente se não existir
      // O UniDAC pode não criar automaticamente em alguns casos
      // Cria um arquivo vazio - o SQLite irá inicializá-lo ao conectar
      {$IF DEFINED(USE_UNIDAC)}
      if (LDatabaseType = pdtSQLite) and (not FileExists(LDatabasePath)) then
      begin
        try
          // Cria um arquivo vazio usando TFileStream
          // O SQLite irá inicializar o arquivo com o formato correto ao conectar
          LFileStream := TFileStream.Create(LDatabasePath, fmCreate);
          try
            // Arquivo vazio criado - SQLite irá inicializar ao conectar
          finally
            LFileStream.Free;
          end;
        except
          // Se falhar ao criar arquivo, continua (pode ser problema de permissão)
          // O UniDAC pode criar ao conectar, mas é melhor garantir que existe
        end;
      end;

      // Para Access, precisa criar o arquivo manualmente usando ADOX
      // Tanto UniDAC quanto FireDAC Access NÃO criam o arquivo automaticamente como o SQLite
      // Usa ADOX (ActiveX Data Objects Extensions) para criar o arquivo .mdb
      if (LDatabaseType = pdtAccess) and (not FileExists(LDatabasePath)) then
      begin
        try
          // Cria o arquivo Access usando ADOX
          if not CreateAccessDatabase(LDatabasePath) then
          begin
            raise CreateConnectionException(
              Format('Nao foi possivel criar o arquivo Access: %s' + sLineBreak +
                     'Verifique se o Microsoft Access Database Engine esta instalado.', [LDatabasePath]),
              ERR_CONNECTION_FAILED,
              'ConnectConnection'
            );
          end;
        except
          on E: EParametersException do
            raise; // Re-lança exceção do Parameters
          on E: Exception do
          begin
            // Converte exceção genérica para exceção do Parameters
            raise ConvertToParametersException(E, 'ConnectConnection');
          end;
        end;
      end;
      {$ELSE} {$IF DEFINED(USE_ZEOS)}
      // Para Zeos SQLite, cria o arquivo manualmente se não existir
      // O Zeos pode não criar automaticamente em alguns casos
      if (LDatabaseType = pdtSQLite) and (not FileExists(LDatabasePath)) then
      begin
        try
          // Cria um arquivo vazio usando TFileStream
          // O SQLite irá inicializar o arquivo com o formato correto ao conectar
          LFileStream := TFileStream.Create(LDatabasePath, fmCreate);
          try
            // Arquivo vazio criado - SQLite irá inicializar ao conectar
          finally
            LFileStream.Free;
          end;
        except
          // Se falhar ao criar arquivo, continua (pode ser problema de permissão)
          // O Zeos pode criar ao conectar, mas é melhor garantir que existe
        end;
      end;

      // Para Access com Zeos, precisa criar o arquivo manualmente usando ADOX
      // O Zeos Access NÃO cria o arquivo automaticamente
      // Usa ADOX (ActiveX Data Objects Extensions) para criar o arquivo .mdb
      if (LDatabaseType = pdtAccess) and (not FileExists(LDatabasePath)) then
      begin
        try
          // Cria o arquivo Access usando ADOX
          if not CreateAccessDatabase(LDatabasePath) then
          begin
            raise CreateConnectionException(
              Format('Nao foi possivel criar o arquivo Access: %s' + sLineBreak +
                     'Verifique se o Microsoft Access Database Engine esta instalado.', [LDatabasePath]),
              ERR_CONNECTION_FAILED,
              'ConnectConnection'
            );
          end;
        except
          on E: EParametersException do
            raise; // Re-lança exceção do Parameters
          on E: Exception do
          begin
            // Converte exceção genérica para exceção do Parameters
            raise ConvertToParametersException(E, 'ConnectConnection');
          end;
        end;
      end;
      {$ENDIF}
    {$ENDIF}
    end;
  end;

  // Para FireDAC, garante que VendorLib está configurado ANTES de conectar
  // IMPORTANTE: Isso deve ser feito ANTES de qualquer tentativa de conexão
  {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  case LDatabaseType of
    pdtMySQL:
    begin
      // MySQL: garante que VendorLib está configurado
      {$IF DEFINED(WIN64)}
      if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql\libmysql.dll') then
        TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql\libmysql.dll';
      {$ELSE}
      if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql\libmysql.dll') then
        TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql\libmysql.dll';
      {$ENDIF}
    end;
    pdtPostgreSQL:
    begin
      // PostgreSQL: garante que VendorLib está configurado
      {$IF DEFINED(WIN64)}
      if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib\libpq.dll') then
        TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib\libpq.dll';
      {$ELSE}
      if FileExists('E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib\libpq.dll') then
        TFDConnection(FConnection).Params.Values['VendorLib'] := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib\libpq.dll';
      {$ENDIF}
    end;
  end;
  {$ENDIF}

  try
    {$IF DEFINED(USE_UNIDAC)}
      if not TUniConnection(FConnection).Connected then
        TUniConnection(FConnection).Connect;
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              if not TFDConnection(FConnection).Connected then
                TFDConnection(FConnection).Connected := True;
            {$ELSE} {$IF DEFINED(USE_ZEOS)}

                      // Configura LibraryLocation para Zeos ANTES de conectar (PostgreSQL, MySQL e SQL Server)
                      // IMPORTANTE: LibraryLocation deve ser configurado ANTES de definir o protocolo
                      if Assigned(FConnection) then
                      begin
                        LDatabaseType := StringToDatabaseType(FDatabaseType);

                        // Configura LibraryLocation primeiro (especialmente importante para FreeTDS)
                        if (LDatabaseType = pdtPostgreSQL) or (LDatabaseType = pdtMySQL) or (LDatabaseType = pdtSQLServer) then
                          ConfigureZeosLibraryLocation(TZConnection(FConnection), LDatabaseType);

                        // SQL Server: usa mssql com LibraryLocation configurado para FreeTDS
                        // O Zeos detectará automaticamente a DLL do FreeTDS via LibraryLocation
                        if LDatabaseType = pdtSQLServer then
                          TZConnection(FConnection).Protocol := 'mssql';
                      end;

                      if not TZConnection(FConnection).Connected then
                        TZConnection(FConnection).Connect;
                   {$ELSE}
                      SetConnectionProperty('Connected', True);
                   {$ENDIF}
           {$ENDIF}
   {$ENDIF}
  except
    on E: EParametersException do
      raise; // Re-lança exceção do Parameters
    on E: Exception do
    begin
      // Melhora mensagem de erro para FireBird com problemas de I/O
      LDatabaseType := StringToDatabaseType(FDatabaseType);
      if (LDatabaseType = pdtFireBird) and
         ((Pos('I/O error', E.Message) > 0) or
          (Pos('dispositivo', LowerCase(E.Message)) > 0) or
          (Pos('device', LowerCase(E.Message)) > 0) or
          (Pos('not ready', LowerCase(E.Message)) > 0)) then
      begin
        raise CreateConnectionException(
          Format('Erro de I/O ao acessar arquivo FireBird: %s' + sLineBreak +
                 'Caminho: %s' + sLineBreak +
                 'Detalhes: %s' + sLineBreak +
                 'Possiveis causas:' + sLineBreak +
                 '- Drive nao esta acessivel ou nao existe' + sLineBreak +
                 '- Arquivo esta sendo usado por outro processo' + sLineBreak +
                 '- Permissoes insuficientes para acessar o arquivo' + sLineBreak +
                 '- Caminho do arquivo esta incorreto',
                 [FDatabase, FDatabase, E.Message]),
          ERR_CONNECTION_DRIVE_NOT_READY,
          'ConnectConnection'
        );
      end
      else
      begin
        // Converte exceção genérica para exceção do Parameters
        raise ConvertToParametersException(E, 'ConnectConnection');
      end;
    end;
  end;
end;

procedure TParametersDatabase.DisconnectConnection;
begin
  if not Assigned(FConnection) then
    Exit;

  try
    {$IF DEFINED(USE_UNIDAC)}
    if TUniConnection(FConnection).Connected then
      TUniConnection(FConnection).Disconnect;
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              if TFDConnection(FConnection).Connected then
                TFDConnection(FConnection).Connected := False;
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      if TZConnection(FConnection).Connected then
                        TZConnection(FConnection).Disconnect;
                    {$ELSE}
                      SetConnectionProperty('Connected', False);
                    {$ENDIF}
            {$ENDIF}
   {$ENDIF}
  except
    // Ignorar erros
  end;
end;

function TParametersDatabase.GetFullTableName: string;
begin
  // Mantém compatibilidade com código existente
  Result := GetFullTableNameForSQL;
end;

function TParametersDatabase.GetFullTableNameForSQL: string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  LDatabaseType := StringToDatabaseType(FDatabaseType);

  case LDatabaseType of
    pdtSQLServer:
    begin
      // SQL Server usa [schema].[table] ou schema.table
      if FSchema <> '' then
        Result := Format('[%s].[%s]', [FSchema, FTableName])
      else
        Result := Format('[%s]', [FTableName]);
    end;
    pdtMySQL:
    begin
      // MySQL usa `schema`.`table`
      if FSchema <> '' then
        Result := Format('`%s`.`%s`', [FSchema, FTableName])
      else
        Result := Format('`%s`', [FTableName]);
    end;
    pdtPostgreSQL, pdtSQLite:
    begin
      // PostgreSQL, SQLite usam "schema"."table"
  if FSchema <> '' then
    Result := Format('"%s"."%s"', [FSchema, FTableName])
  else
    Result := Format('"%s"', [FTableName]);
    end;
    pdtAccess:
    begin
      // Access não suporta schemas, usa apenas o nome da tabela
      // Access aceita [table] ou table (sem aspas)
      Result := Format('[%s]', [FTableName]);
    end;
    pdtFireBird:
    begin
      // FireBird não suporta schemas da mesma forma
      // Usa exatamente o nome da tabela como foi informado (pode já conter schema como prefixo)
      Result := Format('"%s"', [FTableName]);
    end;
    else
    begin
      // Padrão: sem aspas (para ODBC, Access, etc)
      if FSchema <> '' then
        Result := Format('%s.%s', [FSchema, FTableName])
      else
        Result := FTableName;
    end;
  end;
end;

function TParametersDatabase.InternalTableExists: Boolean;
var
  LSQL: string;
  LDataSet: TDataSet;
  LDatabaseType: TParameterDatabaseTypes;
  LTableName: string;
begin
  Result := False;

  if not IsConnected then
    Exit;

  try
    LDatabaseType := StringToDatabaseType(FDatabaseType);
    LTableName := GetFullTableNameForSQL;

    case LDatabaseType of
      pdtSQLServer:
      begin
        // SQL Server: verifica em sys.objects (case-insensitive por padrão, mas usa LOWER para garantir)
        LTableName := LowerCase(Trim(FTableName));
        if FSchema <> '' then
          LSQL := Format(
            'SELECT COUNT(*) as cnt FROM sys.objects o ' +
            'INNER JOIN sys.schemas s ON o.schema_id = s.schema_id ' +
            'WHERE LOWER(s.name) = LOWER(''%s'') AND LOWER(o.name) = LOWER(''%s'') AND o.type = ''U''',
            [EscapeSQL(FSchema), EscapeSQL(LTableName)]
          )
        else
          LSQL := Format(
            'SELECT COUNT(*) as cnt FROM sys.objects ' +
            'WHERE LOWER(name) = LOWER(''%s'') AND type = ''U''',
            [EscapeSQL(LTableName)]
          );
      end;
      pdtPostgreSQL:
      begin
        // PostgreSQL: verifica em information_schema (case-insensitive)
        // PostgreSQL converte nomes para lowercase se não estiverem entre aspas
        LTableName := LowerCase(Trim(FTableName));
        if FSchema <> '' then
          LSQL := Format(
            'SELECT COUNT(*) as cnt FROM information_schema.tables ' +
            'WHERE LOWER(table_schema) = LOWER(''%s'') AND LOWER(table_name) = LOWER(''%s'')',
            [EscapeSQL(FSchema), EscapeSQL(LTableName)]
          )
        else
          LSQL := Format(
            'SELECT COUNT(*) as cnt FROM information_schema.tables ' +
            'WHERE table_schema = ''public'' AND LOWER(table_name) = LOWER(''%s'')',
            [EscapeSQL(LTableName)]
          );
      end;
      pdtMySQL:
      begin
        // MySQL: verifica em information_schema (case-insensitive)
        // MySQL é case-insensitive no Windows, mas case-sensitive no Linux
        // Usa LOWER() para garantir busca case-insensitive
        LTableName := LowerCase(Trim(FTableName));
        if FSchema <> '' then
          LSQL := Format(
            'SELECT COUNT(*) as cnt FROM information_schema.tables ' +
            'WHERE LOWER(table_schema) = LOWER(''%s'') AND LOWER(table_name) = LOWER(''%s'')',
            [EscapeSQL(FSchema), EscapeSQL(LTableName)]
          )
        else
          LSQL := Format(
            'SELECT COUNT(*) as cnt FROM information_schema.tables ' +
            'WHERE LOWER(table_schema) = LOWER(DATABASE()) AND LOWER(table_name) = LOWER(''%s'')',
            [EscapeSQL(LTableName)]
          );
      end;
      pdtSQLite:
      begin
        // SQLite: verifica em sqlite_master (case-insensitive por padrão, mas usa LOWER para garantir)
        LTableName := LowerCase(Trim(FTableName));
        LSQL := Format(
          'SELECT COUNT(*) as cnt FROM sqlite_master ' +
          'WHERE type = ''table'' AND LOWER(name) = LOWER(''%s'')',
          [EscapeSQL(LTableName)]
        );
      end;
      pdtAccess:
      begin
        // Access: tenta verificar se a tabela existe usando SELECT direto
        // MSysObjects pode não ter permissão de leitura em bancos criados via ADOX
        // Usa uma abordagem mais segura: tenta SELECT direto na tabela
        // IMPORTANTE: Access via ODBC pode ter problemas com [table], tenta sem colchetes também
        try
          // Tenta primeiro com colchetes (formato padrão)
          LSQL := Format('SELECT TOP 1 * FROM %s', [GetFullTableNameForSQL]);
          LDataSet := QuerySQL(LSQL);
          if Assigned(LDataSet) then
          begin
            try
              Result := True; // Se não deu erro, tabela existe
            finally
              LDataSet.Close;
            end;
            Exit; // Sai aqui se conseguiu verificar
          end;
        except
          // Se falhar com colchetes, tenta sem colchetes
          try
            LSQL := Format('SELECT TOP 1 * FROM %s', [FTableName]);
            LDataSet := QuerySQL(LSQL);
            if Assigned(LDataSet) then
            begin
              try
                Result := True; // Se não deu erro, tabela existe
              finally
                LDataSet.Close;
              end;
              Exit; // Sai aqui se conseguiu verificar
            end;
          except
            // Se ambos falharem, assume que a tabela não existe
            Result := False;
            Exit;
          end;
        end;
      end;
      pdtFireBird:
      begin
        // FireBird: verifica em RDB$RELATIONS
        // IMPORTANTE: FireBird armazena nomes de tabelas em UPPERCASE no RDB$RELATIONS
        // Remove aspas duplas do nome da tabela e converte para UPPERCASE
        LTableName := FTableName;
        // Remove aspas duplas se houver
        if (Length(LTableName) >= 2) and (LTableName[1] = '"') and (LTableName[Length(LTableName)] = '"') then
          LTableName := Copy(LTableName, 2, Length(LTableName) - 2);
        // Converte para UPPERCASE para comparar com RDB$RELATION_NAME
        LTableName := UpperCase(Trim(LTableName));
        // RDB$SYSTEM_FLAG = 0 para excluir tabelas do sistema
        LSQL := Format(
          'SELECT COUNT(*) as cnt FROM RDB$RELATIONS ' +
          'WHERE UPPER(RDB$RELATION_NAME) = ''%s'' AND RDB$SYSTEM_FLAG = 0',
          [EscapeSQL(LTableName)]
        );
      end;
      else
      begin
        // Padrão: tenta SELECT COUNT(*) (pode falhar se tabela não existir)
        try
          LSQL := Format('SELECT COUNT(*) as cnt FROM %s', [LTableName]);
          LDataSet := QuerySQL(LSQL);
          if Assigned(LDataSet) then
          begin
            try
              Result := True; // Se não deu erro, tabela existe
            finally
              LDataSet.Close;
            end;
          end;
        except
          Result := False;
        end;
        Exit;
      end;
    end;

    // Executa a query de verificação
    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
          Result := LDataSet.FieldByName('cnt').AsInteger > 0;
      finally
        LDataSet.Close;
      end;
    end;
  except
    Result := False;
  end;
end;

function TParametersDatabase.EnsureTableExists: Boolean;
begin
  Result := True;

  // Apenas verifica se a tabela existe, não cria automaticamente
  if not InternalTableExists then
    raise CreateSQLException(
      Format('Tabela %s nao existe. Use CreateTable() para criar a tabela.', [GetFullTableNameForSQL]),
      ERR_SQL_TABLE_NOT_EXISTS,
      'EnsureTableExists'
    );
end;

function TParametersDatabase.ValidateSQLiteTableStructure: Boolean;
var
  LSQL: string;
  LDataSet: TDataSet;
  LRequiredColumns: TStringList;
  LFoundColumns: TStringList;
  I: Integer;
  LColumnName: string;
  LColumnType: string;
  LDatabaseType: TParameterDatabaseTypes;
  LIsPrimaryKey: Boolean;
begin
  Result := True;

  // Apenas valida para SQLite
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  if LDatabaseType <> pdtSQLite then
    Exit; // Não precisa validar para outros bancos

  // Lista de colunas obrigatórias esperadas
  LRequiredColumns := TStringList.Create;
  LFoundColumns := TStringList.Create;
  try
    LRequiredColumns.Sorted := True;
    LRequiredColumns.Duplicates := dupIgnore;
    LRequiredColumns.CaseSensitive := False;

    LFoundColumns.Sorted := True;
    LFoundColumns.Duplicates := dupIgnore;
    LFoundColumns.CaseSensitive := False;

    // Define colunas obrigatórias esperadas
    LRequiredColumns.Add('config_id');
    LRequiredColumns.Add('contrato_id');
    LRequiredColumns.Add('produto_id');
    LRequiredColumns.Add('ordem');
    LRequiredColumns.Add('titulo');
    LRequiredColumns.Add('chave');
    LRequiredColumns.Add('valor');
    LRequiredColumns.Add('descricao');
    LRequiredColumns.Add('ativo');
    LRequiredColumns.Add('data_cadastro');
    LRequiredColumns.Add('data_alteracao');

    // Usa PRAGMA table_info para obter estrutura da tabela SQLite
    LSQL := Format('PRAGMA table_info(%s)', [FTableName]);

    LDataSet := QuerySQL(LSQL);
    if not Assigned(LDataSet) then
    begin
      Result := False;
      raise CreateSQLException(
        Format('Nao foi possivel verificar a estrutura da tabela %s.', [FTableName]),
        ERR_SQL_TABLE_CREATE_FAILED,
        'ValidateSQLiteTableStructure'
      );
    end;

    try
      LIsPrimaryKey := False;
      LDataSet.First;
      while not LDataSet.Eof do
      begin
        // PRAGMA table_info retorna: cid, name, type, notnull, dflt_value, pk
        LColumnName := LDataSet.FieldByName('name').AsString;
        LColumnType := UpperCase(Trim(LDataSet.FieldByName('type').AsString));

        LFoundColumns.Add(LColumnName);

        // Verifica se o tipo está correto para colunas críticas
        if SameText(LColumnName, 'ativo') then
        begin
          // ativo deve ser INTEGER no SQLite
          if (LColumnType <> 'INTEGER') and (LColumnType <> 'INT') then
          begin
            Result := False;
            raise CreateSQLException(
              Format('Coluna "ativo" deve ser INTEGER, mas encontrado: %s', [LColumnType]),
              ERR_SQL_TABLE_CREATE_FAILED,
              'ValidateSQLiteTableStructure'
            );
          end;
        end
        else if SameText(LColumnName, 'config_id') then
        begin
          // config_id deve ser INTEGER PRIMARY KEY
          if (LColumnType <> 'INTEGER') and (LColumnType <> 'INT') then
          begin
            Result := False;
            raise CreateSQLException(
              Format('Coluna "config_id" deve ser INTEGER, mas encontrado: %s', [LColumnType]),
              ERR_SQL_TABLE_CREATE_FAILED,
              'ValidateSQLiteTableStructure'
            );
          end;

          // Verifica se config_id é PRIMARY KEY (pk = 1 no PRAGMA table_info)
          LIsPrimaryKey := LDataSet.FieldByName('pk').AsInteger = 1;
          if not LIsPrimaryKey then
          begin
            Result := False;
            raise CreateSQLException(
              Format('Coluna "config_id" deve ser PRIMARY KEY. ' +
                     'A tabela precisa ser recriada com a estrutura correta.', []),
              ERR_SQL_TABLE_CREATE_FAILED,
              'ValidateSQLiteTableStructure'
            );
          end;
        end;

        LDataSet.Next;
      end;

      // Validação de PRIMARY KEY concluída

      // Verifica se todas as colunas obrigatórias existem
      for I := 0 to LRequiredColumns.Count - 1 do
      begin
        if LFoundColumns.IndexOf(LRequiredColumns[I]) = -1 then
        begin
          Result := False;
          raise CreateSQLException(
            Format('Coluna obrigatoria "%s" nao encontrada na tabela %s.', [LRequiredColumns[I], FTableName]),
            ERR_SQL_TABLE_CREATE_FAILED,
            'ValidateSQLiteTableStructure'
          );
        end;
      end;

    finally
      LDataSet.Close;
    end;

  finally
    LRequiredColumns.Free;
    LFoundColumns.Free;
  end;
end;

function TParametersDatabase.TableExists: Boolean;
begin
  Result := InternalTableExists; // Usa o método privado diretamente
end;

function TParametersDatabase.TableExists(out AExists: Boolean): IParametersDatabase;
begin
  Result := Self;
  AExists := InternalTableExists; // Usa o método privado
end;

function TParametersDatabase.ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase;
begin
  Result := Self;
  ADatabases := ListAvailableDatabasesInternal;
end;

function TParametersDatabase.ListAvailableDatabases: TStringList;
var
  LList: TStringList;
begin
  ListAvailableDatabases(LList);
  Result := LList;
end;

function TParametersDatabase.ListAvailableTables(out ATables: TStringList): IParametersDatabase;
begin
  Result := Self;
  ATables := ListAvailableTablesInternal;
end;

function TParametersDatabase.ListAvailableTables: TStringList;
var
  LList: TStringList;
begin
  ListAvailableTables(LList);
  Result := LList;
end;

function TParametersDatabase.ListAvailableTablesInternal: TStringList;
var
  LSQL: string;
  LDataSet: TDataSet;
  LDatabaseType: TParameterDatabaseTypes;
  LTableName: string;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;

  try
    if not IsConnected then
      Exit;

    LDatabaseType := StringToDatabaseType(FDatabaseType);

    case LDatabaseType of
      pdtPostgreSQL:
      begin
        // PostgreSQL: information_schema.tables
        if FSchema <> '' then
          LSQL := Format(
            'SELECT table_name FROM information_schema.tables ' +
            'WHERE table_schema = ''%s'' AND table_type = ''BASE TABLE'' ORDER BY table_name',
            [EscapeSQL(FSchema)]
          )
        else
          LSQL := 'SELECT table_name FROM information_schema.tables ' +
                  'WHERE table_schema = ''public'' AND table_type = ''BASE TABLE'' ORDER BY table_name';
      end;
      pdtMySQL:
      begin
        // MySQL: information_schema.tables
        if FSchema <> '' then
          LSQL := Format(
            'SELECT table_name FROM information_schema.tables ' +
            'WHERE table_schema = ''%s'' AND table_type = ''BASE TABLE'' ORDER BY table_name',
            [EscapeSQL(FSchema)]
          )
        else
          LSQL := 'SELECT table_name FROM information_schema.tables ' +
                  'WHERE table_schema = DATABASE() AND table_type = ''BASE TABLE'' ORDER BY table_name';
      end;
      pdtSQLServer:
      begin
        // SQL Server: sys.objects
        if FSchema <> '' then
          LSQL := Format(
            'SELECT o.name as table_name FROM sys.objects o ' +
            'INNER JOIN sys.schemas s ON o.schema_id = s.schema_id ' +
            'WHERE s.name = ''%s'' AND o.type = ''U'' ORDER BY o.name',
            [EscapeSQL(FSchema)]
          )
        else
          LSQL := 'SELECT name as table_name FROM sys.objects WHERE type = ''U'' ORDER BY name';
      end;
      pdtSQLite:
      begin
        // SQLite: sqlite_master
        LSQL := 'SELECT name as table_name FROM sqlite_master WHERE type = ''table'' ORDER BY name';
      end;
      pdtFireBird:
      begin
        // FireBird: RDB$RELATIONS (nomes em UPPERCASE)
        LSQL := 'SELECT TRIM(RDB$RELATION_NAME) as table_name FROM RDB$RELATIONS ' +
                'WHERE RDB$SYSTEM_FLAG = 0 ORDER BY RDB$RELATION_NAME';
      end;
      pdtAccess:
      begin
        // Access: MSysObjects (pode não ter permissão)
        LSQL := 'SELECT Name as table_name FROM MSysObjects WHERE Type = 1 AND Flags = 0 ORDER BY Name';
      end;
    else
      Exit; // Tipo não suportado
    end;

    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        LDataSet.First;
        while not LDataSet.Eof do
        begin
          LTableName := Trim(LDataSet.FieldByName('table_name').AsString);
          if LTableName <> '' then
            Result.Add(LTableName);
          LDataSet.Next;
        end;
      finally
        LDataSet.Close;
      end;
    end;
  except
    // Em caso de erro, retorna lista vazia
    Result.Clear;
  end;
end;

function TParametersDatabase.ListAvailableDatabasesInternal: TStringList;
var
  LSQL: string;
  LDataSet: TDataSet;
  LDatabaseType: TParameterDatabaseTypes;
  LTempDatabase: string;
  LOriginalDatabase: string;
  LIsConnected: Boolean;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;

  try
    LDatabaseType := StringToDatabaseType(FDatabaseType);

    // Para bancos baseados em arquivo, não lista (usa diálogo de arquivo)
    if LDatabaseType in [pdtSQLite, pdtAccess, pdtFireBird] then
      Exit;

    // Salva o banco atual
    LOriginalDatabase := FDatabase;
    LIsConnected := IsConnectionConnected;

    // Se já estiver conectado, desconecta primeiro para reconfigurar
    if LIsConnected then
    begin
      try
        DisconnectConnection;
      except
        // Ignora erros de desconexão
      end;
    end;

    try
      // Para listar bancos, precisa conectar sem especificar database
      // MySQL: conecta sem database ou usa 'information_schema'
      // PostgreSQL: conecta ao 'postgres' (banco padrão)
      // SQL Server: conecta ao 'master' (banco padrão)

      case LDatabaseType of
        pdtMySQL:
        begin
          // MySQL: tenta conectar sem especificar database primeiro (mais compatível)
          // Se falhar, tenta com 'information_schema'
          LTempDatabase := ''; // Tenta sem database primeiro
        end;
        pdtPostgreSQL:
        begin
          // PostgreSQL: conecta ao 'postgres' (banco padrão do sistema)
          LTempDatabase := 'postgres';
        end;
        pdtSQLServer:
        begin
          // SQL Server: conecta ao 'master' (banco padrão do sistema)
          LTempDatabase := 'master';
        end;
      else
        Exit; // Outros tipos não suportam listagem
      end;

      // IMPORTANTE: Limpa o database antes de configurar o temporário
      // Isso garante que não use valores antigos
      FDatabase := '';

      // Configura database temporário e conecta
      FDatabase := LTempDatabase;
      try
        ConnectConnection;
      except
        on E: Exception do
        begin
          // Se falhar ao conectar sem database (MySQL), tenta com 'information_schema'
          if (LDatabaseType = pdtMySQL) and (LTempDatabase = '') then
          begin
            try
              FDatabase := 'information_schema'; // Tenta com information_schema
              ConnectConnection;
            except
              // Se ainda falhar, converte o erro original
              raise ConvertToParametersException(E, 'ListAvailableDatabasesInternal');
            end;
          end
          else
            // Converte exceção genérica para exceção do Parameters
            raise ConvertToParametersException(E, 'ListAvailableDatabasesInternal');
        end;
      end;

      // Monta SQL para listar bancos conforme o tipo
      case LDatabaseType of
        pdtMySQL:
        begin
          // MySQL: tenta SHOW DATABASES primeiro (mais simples, não requer database específico)
          // Se falhar, tenta information_schema
          try
            LSQL := 'SHOW DATABASES';
            LDataSet := QuerySQL(LSQL);
            if Assigned(LDataSet) then
            begin
              try
                LDataSet.First;
                while not LDataSet.Eof do
                begin
                  // SHOW DATABASES retorna coluna 'Database' (com D maiúsculo)
                  // Tenta 'Database' primeiro, se não existir tenta 'database_name'
                  if LDataSet.FindField('Database') <> nil then
                    Result.Add(LDataSet.FieldByName('Database').AsString)
                  else if LDataSet.FindField('database_name') <> nil then
                    Result.Add(LDataSet.FieldByName('database_name').AsString)
                  else if LDataSet.Fields.Count > 0 then
                    Result.Add(LDataSet.Fields[0].AsString); // Usa primeira coluna como fallback
                  LDataSet.Next;
                end;
              finally
                LDataSet.Close;
              end;
            end;
          except
            // Se SHOW DATABASES falhar, tenta information_schema
            try
              LSQL := 'SELECT SCHEMA_NAME as database_name FROM information_schema.SCHEMATA ORDER BY SCHEMA_NAME';
              LDataSet := QuerySQL(LSQL);
              if Assigned(LDataSet) then
              begin
                try
                  LDataSet.First;
                  while not LDataSet.Eof do
                  begin
                    Result.Add(LDataSet.FieldByName('database_name').AsString);
                    LDataSet.Next;
                  end;
                finally
                  LDataSet.Close;
                end;
              end;
            except
              // Se ambos falharem, retorna lista vazia
            end;
          end;
        end;
        pdtPostgreSQL:
        begin
          LSQL := 'SELECT datname as database_name FROM pg_database WHERE datistemplate = false ORDER BY datname';
          LDataSet := QuerySQL(LSQL);
          if Assigned(LDataSet) then
          begin
            try
              LDataSet.First;
              while not LDataSet.Eof do
              begin
                Result.Add(LDataSet.FieldByName('database_name').AsString);
                LDataSet.Next;
              end;
            finally
              LDataSet.Close;
            end;
          end;
        end;
        pdtSQLServer:
        begin
          LSQL := 'SELECT name as database_name FROM sys.databases WHERE database_id > 4 ORDER BY name'; // Exclui bancos do sistema
          LDataSet := QuerySQL(LSQL);
          if Assigned(LDataSet) then
          begin
            try
              LDataSet.First;
              while not LDataSet.Eof do
              begin
                Result.Add(LDataSet.FieldByName('database_name').AsString);
                LDataSet.Next;
              end;
            finally
              LDataSet.Close;
            end;
          end;
        end;
      else
        Exit; // Outros tipos não suportam listagem
      end;

      // Restaura conexão original
      DisconnectConnection;
      FDatabase := LOriginalDatabase;

      // Se estava conectado, reconecta com o banco original
      if LIsConnected and (LOriginalDatabase <> '') then
      begin
        ConnectConnection;
      end;
    except
      // Em caso de erro, restaura estado original
      try
        DisconnectConnection;
        FDatabase := LOriginalDatabase;
        if LIsConnected and (LOriginalDatabase <> '') then
          ConnectConnection;
      except
        // Ignora erros na restauração
      end;
    end;
  except
    // Em caso de erro, retorna lista vazia
    Result.Clear;
  end;
end;

function TParametersDatabase.CreateTable: IParametersDatabase;
var
  LSuccess: Boolean;
begin
  Result := CreateTable(LSuccess); // Chama o overload com parâmetro out
end;

function TParametersDatabase.DropTable: IParametersDatabase;
var
  LSuccess: Boolean;
begin
  Result := DropTable(LSuccess); // Chama o overload com parâmetro out
end;

function TParametersDatabase.DropTable(out ASuccess: Boolean): IParametersDatabase;
var
  LSQL: string;
  LDatabaseType: TParameterDatabaseTypes;
  LTableName: string;
  LTableNameOnly: string;
  LDataSet: TDataSet;
begin
  Result := Self;
  FLock.Enter;
  try
    ASuccess := False;

    // Verifica conexão
    if not IsConnectionConnected then
      raise CreateConnectionException(
        MSG_CONNECTION_NOT_CONNECTED,
        ERR_CONNECTION_NOT_CONNECTED,
        'DropTable'
      );

    // Verifica se a tabela existe
    if not InternalTableExists then
  begin
    ASuccess := True; // Tabela não existe, considera sucesso (já está droppada)
    Exit;
  end;

  try
    LDatabaseType := StringToDatabaseType(FDatabaseType);
    LTableName := GetFullTableNameForSQL;
    LTableNameOnly := FTableName;

    // Remove aspas duplas do nome da tabela para usar em generators/triggers
    if (Length(LTableNameOnly) >= 2) and (LTableNameOnly[1] = '"') and (LTableNameOnly[Length(LTableNameOnly)] = '"') then
      LTableNameOnly := Copy(LTableNameOnly, 2, Length(LTableNameOnly) - 2);
    LTableNameOnly := UpperCase(Trim(LTableNameOnly));

    // FireBird: precisa dropar trigger e generator antes de dropar a tabela
    if LDatabaseType = pdtFireBird then
    begin
      // IMPORTANTE: Verifica se trigger/generator existe antes de dropar para evitar exceção
      // Firebird armazena nomes em UPPERCASE no RDB$TRIGGERS e RDB$GENERATORS

      // 1. Dropar trigger (se existir)
      LSQL := Format(
        'SELECT COUNT(*) as cnt FROM RDB$TRIGGERS ' +
        'WHERE UPPER(TRIM(RDB$TRIGGER_NAME)) = ''TRG_%s_CONFIG_ID'' AND RDB$SYSTEM_FLAG = 0',
        [LTableNameOnly]
      );
      try
        LDataSet := QuerySQL(LSQL);
        if Assigned(LDataSet) then
        begin
          try
            LDataSet.First;
            if not LDataSet.Eof and (LDataSet.FieldByName('cnt').AsInteger > 0) then
            begin
              // Trigger existe, pode dropar (usa maiúsculas para consistência)
              LSQL := Format('DROP TRIGGER TRG_%s_CONFIG_ID', [LTableNameOnly]);
              try
                ExecuteSQL(LSQL);
              except
                // Ignora erro ao dropar
              end;
            end;
          finally
            LDataSet.Close;
          end;
        end;
      except
        // Ignora erro se não conseguir verificar (trigger pode não existir)
      end;

      // 2. Dropar generator (se existir)
      LSQL := Format(
        'SELECT COUNT(*) as cnt FROM RDB$GENERATORS ' +
        'WHERE UPPER(TRIM(RDB$GENERATOR_NAME)) = ''GEN_%s_CONFIG_ID''',
        [LTableNameOnly]
      );
      try
        LDataSet := QuerySQL(LSQL);
        if Assigned(LDataSet) then
        begin
          try
            LDataSet.First;
            if not LDataSet.Eof and (LDataSet.FieldByName('cnt').AsInteger > 0) then
            begin
              // Generator existe, pode dropar (usa maiúsculas para consistência)
              LSQL := Format('DROP GENERATOR GEN_%s_CONFIG_ID', [LTableNameOnly]);
              try
                ExecuteSQL(LSQL);
              except
                // Ignora erro ao dropar
              end;
            end;
          finally
            LDataSet.Close;
          end;
        end;
      except
        // Ignora erro se não conseguir verificar (generator pode não existir)
      end;
    end;

    // 3. Dropar a tabela
    LSQL := Format('DROP TABLE %s', [LTableName]);
    ASuccess := ExecuteSQL(LSQL);

    if not ASuccess then
      raise CreateSQLException(
        Format('Falha ao dropar tabela %s.', [LTableName]),
        ERR_SQL_TABLE_CREATE_FAILED,
        'DropTable'
      );
  except
    on E: EParametersException do
    begin
      ASuccess := False;
      raise; // Re-lança exceção do Parameters
    end;
    on E: Exception do
    begin
      ASuccess := False;
      // Converte exceção genérica para exceção do Parameters
      raise ConvertToParametersException(E, 'DropTable');
    end;
    end; // Fecha o try interno (linha 2115)
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.CreateTable(out ASuccess: Boolean): IParametersDatabase;
var
  LSQL: string;
  LDatabaseType: TParameterDatabaseTypes;
  LTableName: string;
  LTableNameForCheck: string;
  LTableNameOnly: string;
  LDataSet: TDataSet;
begin
  Result := Self;
  FLock.Enter;
  try
    ASuccess := False;

    // Verifica se já existe
    if InternalTableExists then
    begin
      ASuccess := True; // Já existe, considera sucesso
      Exit;
    end;

    // Verifica conexão
    if not IsConnected then
      raise CreateConnectionException(
        MSG_CONNECTION_NOT_CONNECTED,
        ERR_CONNECTION_NOT_CONNECTED,
        'CreateTable'
      );

    try
    LDatabaseType := StringToDatabaseType(FDatabaseType);
    LTableName := GetFullTableNameForSQL;

    case LDatabaseType of
      pdtPostgreSQL:
      begin
        LSQL := Format(SQL_CREATE_TABLE_POSTGRESQL, [LTableName]);
      end;
      pdtMySQL:
      begin
        LSQL := Format(SQL_CREATE_TABLE_MYSQL, [LTableName]);
      end;
      pdtSQLServer:
      begin
        // SQL Server precisa do nome sem colchetes para OBJECT_ID
        if FSchema <> '' then
          LTableNameForCheck := Format('%s.%s', [FSchema, FTableName])
        else
          LTableNameForCheck := FTableName;
        LSQL := Format(SQL_CREATE_TABLE_SQLSERVER, [LTableNameForCheck, LTableName]);
      end;
      pdtSQLite:
      begin
        LSQL := Format(SQL_CREATE_TABLE_SQLITE, [LTableName]);
      end;
      pdtAccess:
      begin
        // Access: cria a tabela primeiro
        // IMPORTANTE: Access via ODBC pode ter problemas com sintaxe
        // Tenta criar a tabela com tratamento de erro detalhado
        try
          LSQL := Format(SQL_CREATE_TABLE_ACCESS, [LTableName]);
          ASuccess := ExecuteSQL(LSQL);
          if not ASuccess then
            raise CreateSQLException(
              Format('Falha ao executar CREATE TABLE para %s. SQL: %s', [LTableName, LSQL]),
              ERR_SQL_TABLE_CREATE_FAILED,
              'CreateTable'
            );

          // Verifica se a tabela foi realmente criada
          // Não precisa de Sleep - o Access processa imediatamente

          // Tenta verificar se a tabela existe agora
          if not InternalTableExists then
          begin
            // Se não existe, pode ser problema de sintaxe ou permissão
            raise CreateSQLException(
              Format('Tabela %s nao foi criada. Verifique a sintaxe SQL e permissoes. SQL executado: %s', [LTableName, LSQL]),
              ERR_SQL_TABLE_CREATE_FAILED,
              'CreateTable'
            );
          end;

          // Access: cria índice UNIQUE separadamente (não pode estar no CREATE TABLE)
          try
            LSQL := Format(SQL_CREATE_INDEX_ACCESS, [FTableName, LTableName]);
            ExecuteSQL(LSQL);
            // Se falhar ao criar índice, não bloqueia (pode já existir)
          except
            // Ignora erro ao criar índice (pode já existir ou não ser crítico)
            // A tabela foi criada, isso é o mais importante
          end;

          // Se chegou aqui, tudo foi criado com sucesso
          ASuccess := True;
          Exit; // Sai antes do ExecuteSQL geral abaixo
        except
          on E: EParametersException do
          begin
            ASuccess := False;
            raise; // Re-lança exceção do Parameters
          end;
          on E: Exception do
          begin
            ASuccess := False;
            // Converte exceção genérica para exceção do Parameters
            raise ConvertToParametersException(E, 'CreateTable');
          end;
        end;
      end;
      pdtFireBird:
      begin
        // FireBird não permite executar múltiplos comandos DDL em uma única execução
        // Precisa executar cada comando separadamente: CREATE TABLE, CREATE GENERATOR, CREATE TRIGGER
        LTableNameOnly := FTableName; // Nome sem aspas para GENERATOR e TRIGGER

        // IMPORTANTE: Remove aspas duplas do nome da tabela para usar no generator/trigger
        if (Length(LTableNameOnly) >= 2) and (LTableNameOnly[1] = '"') and (LTableNameOnly[Length(LTableNameOnly)] = '"') then
          LTableNameOnly := Copy(LTableNameOnly, 2, Length(LTableNameOnly) - 2);

        // Converte para UPPERCASE para nomes de generator/trigger (padrão Firebird)
        LTableNameOnly := UpperCase(Trim(LTableNameOnly));

        // 0. Remove generator e trigger existentes (se houver) antes de criar
        // Isso evita erro "Generator already exists" ou "Trigger already exists"
        // IMPORTANTE: Firebird lança exceção mesmo quando o objeto não existe
        // Por isso, verificamos se existe antes de dropar usando RDB$TRIGGERS e RDB$GENERATORS

        // Tenta dropar o trigger primeiro (se existir)
        // Firebird: verifica se trigger existe antes de dropar para evitar exceção
        // Firebird armazena nomes de triggers em UPPERCASE no RDB$TRIGGERS
        LSQL := Format(
          'SELECT COUNT(*) as cnt FROM RDB$TRIGGERS ' +
          'WHERE UPPER(TRIM(RDB$TRIGGER_NAME)) = ''TRG_%s_CONFIG_ID'' AND RDB$SYSTEM_FLAG = 0',
          [LTableNameOnly]
        );
        try
          LDataSet := QuerySQL(LSQL);
          if Assigned(LDataSet) then
          begin
            try
              LDataSet.First;
              if not LDataSet.Eof and (LDataSet.FieldByName('cnt').AsInteger > 0) then
              begin
                // Trigger existe, pode dropar
                // IMPORTANTE: No Firebird, o nome do trigger no DROP deve ser exatamente como foi criado
                // Se foi criado como "trg_CONFIG_config_id", deve ser droppado como "trg_CONFIG_config_id"
                // Mas no RDB$TRIGGERS está em UPPERCASE, então usamos o nome em UPPERCASE
                LSQL := Format('DROP TRIGGER TRG_%s_CONFIG_ID', [LTableNameOnly]);
                try
                  ExecuteSQL(LSQL);
                except
                  // Ignora erro ao dropar (pode ter sido droppado por outro processo ou nome diferente)
                end;
              end;
            finally
              LDataSet.Close;
            end;
          end;
        except
          // Ignora erro se não conseguir verificar (trigger pode não existir)
        end;

        // Tenta dropar o generator (se existir)
        // Firebird: verifica se generator existe antes de dropar para evitar exceção
        // Firebird armazena nomes de generators em UPPERCASE no RDB$GENERATORS
        LSQL := Format(
          'SELECT COUNT(*) as cnt FROM RDB$GENERATORS ' +
          'WHERE UPPER(TRIM(RDB$GENERATOR_NAME)) = ''GEN_%s_CONFIG_ID''',
          [LTableNameOnly]
        );
        try
          LDataSet := QuerySQL(LSQL);
          if Assigned(LDataSet) then
          begin
            try
              LDataSet.First;
              if not LDataSet.Eof and (LDataSet.FieldByName('cnt').AsInteger > 0) then
              begin
                // Generator existe, pode dropar
                // IMPORTANTE: No Firebird, o nome do generator no DROP deve ser exatamente como foi criado
                // Se foi criado como "gen_CONFIG_config_id", deve ser droppado como "gen_CONFIG_config_id"
                // Mas no RDB$GENERATORS está em UPPERCASE, então usamos o nome em UPPERCASE
                LSQL := Format('DROP GENERATOR GEN_%s_CONFIG_ID', [LTableNameOnly]);
                try
                  ExecuteSQL(LSQL);
                except
                  // Ignora erro ao dropar (pode ter sido droppado por outro processo ou nome diferente)
                end;
              end;
            finally
              LDataSet.Close;
            end;
          end;
        except
          // Ignora erro se não conseguir verificar (generator pode não existir)
        end;

        // 1. Cria a tabela
        LSQL := Format(SQL_CREATE_TABLE_FIREBIRD, [LTableName]);
        ASuccess := ExecuteSQL(LSQL);
        if not ASuccess then
          raise CreateSQLException(
            Format('Falha ao criar tabela %s.', [LTableName]),
            ERR_SQL_TABLE_CREATE_FAILED,
            'CreateTable'
          );

        // 2. Cria o generator
        LSQL := Format(SQL_CREATE_GENERATOR_FIREBIRD, [LTableNameOnly]);
        ASuccess := ExecuteSQL(LSQL);
        if not ASuccess then
          raise CreateSQLException(
            Format('Falha ao criar generator gen_%s_config_id.', [LTableNameOnly]),
            ERR_SQL_TABLE_CREATE_FAILED,
            'CreateTable'
          );

        // 3. Cria o trigger
        LSQL := Format(SQL_CREATE_TRIGGER_FIREBIRD, [
          LTableNameOnly,       // %s - nome da tabela para TRIGGER (sem aspas, UPPERCASE)
          LTableName,           // %s - nome da tabela para FOR (com aspas)
          LTableNameOnly        // %s - nome da tabela para GEN_ID (sem aspas, UPPERCASE)
        ]);
        ASuccess := ExecuteSQL(LSQL);
        if not ASuccess then
          raise CreateSQLException(
            Format('Falha ao criar trigger trg_%s_config_id.', [LTableNameOnly]),
            ERR_SQL_TABLE_CREATE_FAILED,
            'CreateTable'
          );

        // Se chegou aqui, tudo foi criado com sucesso
        ASuccess := True;
        Exit; // Sai antes do ExecuteSQL geral abaixo
      end;
      else
      begin
        // Para outros tipos, usa SQL genérico com tipo de boolean compatível
        // Usa GetBooleanSQLType para obter o tipo correto conforme o banco
        LSQL := Format(
          'CREATE TABLE %s (' +
          'config_id BIGINT PRIMARY KEY, ' +
          'contrato_id INTEGER DEFAULT 0, ' +
          'produto_id INTEGER DEFAULT 0, ' +
          'ordem INTEGER DEFAULT 0, ' +
          'titulo VARCHAR(255), ' +
          'chave VARCHAR(255) NOT NULL UNIQUE, ' +
          'valor TEXT, ' +
          'descricao TEXT, ' +
          'ativo %s DEFAULT %s, ' +
          'data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ' +
          'data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP' +
          ')',
          [LTableName, GetBooleanSQLType(LDatabaseType), GetBooleanSQLDefault(LDatabaseType, True)]
        );
      end;
    end;

    // Executa o SQL de criação
    ASuccess := ExecuteSQL(LSQL);

    if not ASuccess then
      raise CreateSQLException(
        Format('Falha ao criar tabela %s.', [LTableName]),
        ERR_SQL_TABLE_CREATE_FAILED,
        'CreateTable'
      );
  except
    on E: EParametersException do
    begin
      ASuccess := False;
      raise; // Re-lança exceção do Parameters
    end;
    on E: Exception do
    begin
      ASuccess := False;
      // Converte exceção genérica para exceção do Parameters
      raise ConvertToParametersException(E, 'CreateTable');
    end;
    end; // Fecha o try interno (linha 2248)
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.CreateAccessDatabase(const AFilePath: string): Boolean;
{$IF NOT DEFINED(FPC)}
var
  LCatalog: OleVariant;
  LConnectionString: string;
begin
  Result := False;

  try
    // Cria string de conexão para ADOX
    // Provider=Microsoft.Jet.OLEDB.4.0 para .mdb (Access 2003 e anteriores)
    // Provider=Microsoft.ACE.OLEDB.12.0 para .mdb/.accdb (Access 2007+)
    // Tenta primeiro ACE (mais recente), depois Jet (mais antigo)
    LConnectionString := Format('Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s;', [AFilePath]);

    try
      // Tenta criar usando ACE (Access 2007+)
      LCatalog := CreateOleObject('ADOX.Catalog');
      LCatalog.Create(LConnectionString);
      Result := True;
    except
      // Se falhar com ACE, tenta com Jet (Access 2003)
      try
        LConnectionString := Format('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;', [AFilePath]);
        LCatalog := CreateOleObject('ADOX.Catalog');
        LCatalog.Create(LConnectionString);
        Result := True;
      except
        // Se ambos falharem, retorna False
        Result := False;
      end;
    end;

    // Libera o objeto COM
    if VarType(LCatalog) <> varEmpty then
      LCatalog := Unassigned;

  except
    Result := False;
  end;
end;
{$ELSE}
begin
  // FPC não suporta COM/ADOX diretamente
  // Retorna False para indicar que não foi possível criar
  Result := False;
end;
{$ENDIF}

function TParametersDatabase.EscapeSQL(const AValue: string): string;
begin
  Result := StringReplace(AValue, '''', '''''', [rfReplaceAll]);
end;

function TParametersDatabase.BooleanToSQL(const AValue: Boolean): string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  // Converte boolean para formato SQL específico do banco
  // IMPORTANTE: Se FDatabaseType estiver vazio, usa SQLite como padrão (mais seguro)
  if Trim(FDatabaseType) = '' then
    LDatabaseType := pdtSQLite
  else
    LDatabaseType := StringToDatabaseType(FDatabaseType);

  case LDatabaseType of
    pdtSQLite:
      // SQLite usa INTEGER: 1 = true, 0 = false
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtSQLServer:
      // SQL Server usa BIT: 1 = true, 0 = false
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtFireBird:
      // FireBird usa SMALLINT: 1 = true, 0 = false
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtMySQL:
      // MySQL/MariaDB aceita BOOLEAN, mas usa 1/0 internamente
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtAccess:
      // Access via ODBC usa BIT: -1 = True, 0 = False
      {$IF DEFINED(FPC)}
      if AValue then Result := '-1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '-1', '0');
      {$ENDIF}
    pdtPostgreSQL:
      // PostgreSQL aceita true/false diretamente
      {$IF DEFINED(FPC)}
      if AValue then Result := 'true' else Result := 'false';
      {$ELSE}
      Result := IfThen(AValue, 'true', 'false');
      {$ENDIF}
    else
      // Para outros bancos ou tipo desconhecido, usa 1/0 como padrão (seguro para SQLite)
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
  end;
end;

function TParametersDatabase.BooleanToSQLCondition(const AValue: Boolean): string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  // Converte boolean para condição WHERE específica do banco
  // IMPORTANTE: Se FDatabaseType estiver vazio, usa SQLite como padrão (mais seguro)
  if Trim(FDatabaseType) = '' then
    LDatabaseType := pdtSQLite
  else
    LDatabaseType := StringToDatabaseType(FDatabaseType);

  case LDatabaseType of
    pdtSQLite:
      // SQLite: ativo = 1 ou ativo = 0
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtSQLServer:
      // SQL Server: ativo = 1 ou ativo = 0
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtFireBird:
      // FireBird: ativo = 1 ou ativo = 0
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtMySQL:
      // MySQL/MariaDB: ativo = 1 ou ativo = 0
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
    pdtAccess:
      // Access: ativo = -1 (True) ou ativo = 0 (False)
      {$IF DEFINED(FPC)}
      if AValue then Result := '-1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '-1', '0');
      {$ENDIF}
    pdtPostgreSQL:
      // PostgreSQL: ativo = true ou ativo = false
      {$IF DEFINED(FPC)}
      if AValue then Result := 'true' else Result := 'false';
      {$ELSE}
      Result := IfThen(AValue, 'true', 'false');
      {$ENDIF}
    else
      // Para outros bancos ou tipo desconhecido, usa 1/0 como padrão (seguro para SQLite)
      {$IF DEFINED(FPC)}
      if AValue then Result := '1' else Result := '0';
      {$ELSE}
      Result := IfThen(AValue, '1', '0');
      {$ENDIF}
  end;
end;

function TParametersDatabase.BooleanFromDataSet(ADataSet: TDataSet; const AFieldName: string): Boolean;
var
  LDatabaseType: TParameterDatabaseTypes;
  LField: TField;
  LFieldDataType: TFieldType;
begin
  Result := False;

  if not Assigned(ADataSet) then
    Exit;

  LField := ADataSet.FindField(AFieldName);
  if not Assigned(LField) or LField.IsNull then
    Exit;

  // Obtém o tipo de dados do campo
  LFieldDataType := LField.DataType;

  // Determina o tipo de banco para saber como ler o campo
  if Trim(FDatabaseType) = '' then
    LDatabaseType := pdtSQLite
  else
    LDatabaseType := StringToDatabaseType(FDatabaseType);

  // Se o campo é do tipo Boolean nativo, usa diretamente
  if LFieldDataType = ftBoolean then
  begin
    try
      Result := LField.AsBoolean;
      Exit; // Sucesso, sai da função
    except
      // Se falhar mesmo sendo ftBoolean, tenta como Integer
      Result := LField.AsInteger <> 0;
      Exit;
    end;
  end;

  // Para campos numéricos (TINYINT, SMALLINT, INTEGER, BIT), lê como Integer
  // Isso funciona para MySQL (TINYINT(1)), SQLite (INTEGER), FireBird (SMALLINT), etc.
  case LDatabaseType of
    pdtSQLite:
      // SQLite armazena como INTEGER (1 ou 0)
      Result := LField.AsInteger <> 0;
    pdtSQLServer:
      // SQL Server armazena como BIT (pode ser ftBoolean ou ftSmallint)
      if LFieldDataType = ftBoolean then
        Result := LField.AsBoolean
      else
        Result := LField.AsInteger <> 0;
    pdtFireBird:
      // FireBird armazena como SMALLINT (1 ou 0)
      Result := LField.AsInteger <> 0;
    pdtMySQL:
      // MySQL pode armazenar como BOOLEAN (TINYINT(1)) - pode ser ftBoolean ou ftSmallint
      // IMPORTANTE: TINYINT(1) no MySQL pode ser retornado como ftSmallint pelo driver
      // Por isso, sempre tenta como Integer primeiro (mais seguro)
      Result := LField.AsInteger <> 0;
    pdtAccess:
      // Access armazena como YESNO (pode ser ftBoolean ou ftSmallint)
      if LFieldDataType = ftBoolean then
        Result := LField.AsBoolean
      else
        Result := LField.AsInteger <> 0;
    pdtPostgreSQL:
      // PostgreSQL armazena como BOOLEAN (true/false) - geralmente é ftBoolean
      if LFieldDataType = ftBoolean then
        Result := LField.AsBoolean
      else
        // Alguns drivers podem retornar como Integer
        Result := LField.AsInteger <> 0;
    else
      // Para outros bancos ou tipo desconhecido, usa Integer (mais seguro)
      Result := LField.AsInteger <> 0;
  end;
end;

function TParametersDatabase.ValueTypeToString(const AValueType: TParameterValueType): string;
begin
  // Usa constante de Modulo.Parameters.Consts.pas
  Result := ParameterValueTypeNames[AValueType];
end;

function TParametersDatabase.StringToValueType(const AValue: string): TParameterValueType;
var
  I: TParameterValueType;
begin
  // Usa constante de Modulo.Parameters.Consts.pas para busca
  Result := pvtString; // Valor padrão
  for I := Low(TParameterValueType) to High(TParameterValueType) do
  begin
    if SameText(AValue, ParameterValueTypeNames[I]) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TParametersDatabase.StringToDatabaseType(const AValue: string): TParameterDatabaseTypes;
var
  I: TParameterDatabaseTypes;
begin
  // Usa constante de Modulo.Parameters.Consts.pas para busca
  Result := pdtNone; // Valor padrão
  for I := Low(TParameterDatabaseTypes) to High(TParameterDatabaseTypes) do
  begin
    if SameText(AValue, TDatabaseTypeNames[I]) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TParametersDatabase.GetDefaultHost: string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  case LDatabaseType of
    pdtFireBird: Result := DEFAULT_DATABASE_HOST_FIREBIRD;
    pdtMySQL: Result := DEFAULT_DATABASE_HOST_MYSQL;
    pdtPostgreSQL: Result := DEFAULT_DATABASE_HOST_POSTGRESQL;
    pdtSQLServer: Result := DEFAULT_DATABASE_HOST_SQLSERVER;
    pdtSQLite: Result := DEFAULT_DATABASE_HOST_SQLITE;
    pdtAccess: Result := DEFAULT_DATABASE_HOST_ACCESS;
    pdtODBC: Result := DEFAULT_DATABASE_HOST_ODBC;
    pdtLDAP: Result := DEFAULT_DATABASE_HOST_LDAP;
  else
    Result := '';
  end;
end;

function TParametersDatabase.GetDefaultPort: Integer;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  case LDatabaseType of
    pdtFireBird: Result := DEFAULT_DATABASE_PORT_FIREBIRD;
    pdtMySQL: Result := DEFAULT_DATABASE_PORT_MYSQL;
    pdtPostgreSQL: Result := DEFAULT_DATABASE_PORT_POSTGRESQL;
    pdtSQLServer: Result := DEFAULT_DATABASE_PORT_SQLSERVER;
    pdtSQLite: Result := DEFAULT_DATABASE_PORT_SQLITE;
    pdtAccess: Result := DEFAULT_DATABASE_PORT_ACCESS;
    pdtODBC: Result := DEFAULT_DATABASE_PORT_ODBC;
    pdtLDAP: Result := DEFAULT_DATABASE_PORT_LDAP;
  else
    Result := 0;
  end;
end;

function TParametersDatabase.GetDefaultUsername: string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  case LDatabaseType of
    pdtFireBird: Result := DEFAULT_DATABASE_USERNAME_FIREBIRD;
    pdtMySQL: Result := DEFAULT_DATABASE_USERNAME_MYSQL;
    pdtPostgreSQL: Result := DEFAULT_DATABASE_USERNAME_POSTGRESQL;
    pdtSQLServer: Result := DEFAULT_DATABASE_USERNAME_SQLSERVER;
    pdtSQLite: Result := DEFAULT_DATABASE_USERNAME_SQLITE;
    pdtAccess: Result := DEFAULT_DATABASE_USERNAME_ACCESS;
    pdtODBC: Result := DEFAULT_DATABASE_USERNAME_ODBC;
    pdtLDAP: Result := DEFAULT_DATABASE_USERNAME_LDAP;
  else
    Result := '';
  end;
end;

function TParametersDatabase.GetDefaultPassword: string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  case LDatabaseType of
    pdtFireBird: Result := DEFAULT_DATABASE_PASSWORD_FIREBIRD;
    pdtMySQL: Result := DEFAULT_DATABASE_PASSWORD_MYSQL;
    pdtPostgreSQL: Result := DEFAULT_DATABASE_PASSWORD_POSTGRESQL;
    pdtSQLServer: Result := DEFAULT_DATABASE_PASSWORD_SQLSERVER;
    pdtSQLite: Result := DEFAULT_DATABASE_PASSWORD_SQLITE;
    pdtAccess: Result := DEFAULT_DATABASE_PASSWORD_ACCESS;
    pdtODBC: Result := DEFAULT_DATABASE_PASSWORD_ODBC;
    pdtLDAP: Result := DEFAULT_DATABASE_PASSWORD_LDAP;
  else
    Result := '';
  end;
end;

function TParametersDatabase.GetDefaultDatabase: string;
var
  LDatabaseType: TParameterDatabaseTypes;
begin
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  case LDatabaseType of
    pdtFireBird: Result := DEFAULT_DATABASE_NAME_FIREBIRD;
    pdtMySQL: Result := DEFAULT_DATABASE_NAME_MYSQL;
    pdtPostgreSQL: Result := DEFAULT_DATABASE_NAME_POSTGRESQL;
    pdtSQLServer: Result := DEFAULT_DATABASE_NAME_SQLSERVER;
    pdtSQLite: Result := DEFAULT_DATABASE_NAME_SQLITE;
    pdtAccess: Result := DEFAULT_DATABASE_NAME_ACCESS;
    pdtODBC: Result := DEFAULT_DATABASE_NAME_ODBC;
    pdtLDAP: Result := DEFAULT_DATABASE_NAME_LDAP;
  else
    Result := '';
  end;
end;

function TParametersDatabase.GetCurrentEngine: TParameterDatabaseEngine;
var
  I: TParameterDatabaseEngine;
begin
  // Converte FEngine (string) para TParameterDatabaseEngine
  Result := pteNone; // Valor padrão
  for I := Low(TParameterDatabaseEngine) to High(TParameterDatabaseEngine) do
  begin
    if SameText(FEngine, TEngineDatabase[I]) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TParametersDatabase.GetDatabaseTypeForEngine(const ADatabaseType: TParameterDatabaseTypes; const AEngine: TParameterDatabaseEngine): string;
begin
  // Usa constante TDatabaseConfig para obter o valor correto do engine específico
  Result := TDatabaseConfig[ADatabaseType, AEngine];
  if Result = 'None' then
    Result := ''; // Retorna string vazia se não configurado
end;

function TParametersDatabase.GetTableColumns: TStringList;
var
  LSQL: string;
  LDataSet: TDataSet;
  LDatabaseType: TParameterDatabaseTypes;
  LColumnName: string;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;
  Result.CaseSensitive := False;

  try
    // Verifica se a tabela existe primeiro
    if not InternalTableExists then
      Exit;

    LDatabaseType := StringToDatabaseType(FDatabaseType);

    // Monta SQL para listar colunas conforme o tipo de banco
    case LDatabaseType of
      pdtSQLite:
      begin
        // SQLite: PRAGMA table_info
        LSQL := Format('PRAGMA table_info(%s)', [FTableName]);
      end;
      pdtPostgreSQL:
      begin
        // PostgreSQL: information_schema.columns
        if FSchema <> '' then
          LSQL := Format('SELECT column_name FROM information_schema.columns WHERE table_schema = ''%s'' AND table_name = ''%s'' ORDER BY ordinal_position',
            [EscapeSQL(FSchema), EscapeSQL(FTableName)])
        else
          LSQL := Format('SELECT column_name FROM information_schema.columns WHERE table_schema = ''public'' AND table_name = ''%s'' ORDER BY ordinal_position',
            [EscapeSQL(FTableName)]);
      end;
      pdtMySQL:
      begin
        // MySQL: information_schema.columns ou SHOW COLUMNS
        if FSchema <> '' then
          LSQL := Format('SELECT column_name FROM information_schema.columns WHERE table_schema = ''%s'' AND table_name = ''%s'' ORDER BY ordinal_position',
            [EscapeSQL(FSchema), EscapeSQL(FTableName)])
        else
          LSQL := Format('SELECT column_name FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ''%s'' ORDER BY ordinal_position',
            [EscapeSQL(FTableName)]);
      end;
      pdtSQLServer:
      begin
        // SQL Server: INFORMATION_SCHEMA.COLUMNS
        if FSchema <> '' then
          LSQL := Format('SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = ''%s'' AND TABLE_NAME = ''%s'' ORDER BY ORDINAL_POSITION',
            [EscapeSQL(FSchema), EscapeSQL(FTableName)])
        else
          LSQL := Format('SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''%s'' ORDER BY ORDINAL_POSITION',
            [EscapeSQL(FTableName)]);
      end;
      pdtFireBird:
      begin
        // FireBird: RDB$RELATION_FIELDS
        LSQL := Format('SELECT RDB$FIELD_NAME FROM RDB$RELATION_FIELDS WHERE RDB$RELATION_NAME = ''%s'' ORDER BY RDB$FIELD_POSITION',
          [UpperCase(FTableName)]);
      end;
      pdtAccess:
      begin
        // Access: INFORMATION_SCHEMA.COLUMNS (via ODBC)
        LSQL := Format('SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''%s'' ORDER BY ORDINAL_POSITION',
          [EscapeSQL(FTableName)]);
      end;
    else
      Exit; // Tipo de banco não suportado
    end;

    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        LDataSet.First;
        while not LDataSet.Eof do
        begin
          // Obtém nome da coluna conforme o tipo de banco
          case LDatabaseType of
            pdtSQLite:
              LColumnName := LDataSet.FieldByName('name').AsString;
            pdtPostgreSQL, pdtMySQL, pdtSQLServer, pdtAccess:
              LColumnName := LDataSet.FieldByName('column_name').AsString;
            pdtFireBird:
            begin
              // FireBird retorna com espaços, precisa trim
              LColumnName := Trim(LDataSet.FieldByName('RDB$FIELD_NAME').AsString);
            end;
          else
            LColumnName := '';
          end;

          if LColumnName <> '' then
            Result.Add(LColumnName);

          LDataSet.Next;
        end;
      finally
        LDataSet.Close;
      end;
    end;
  except
    // Em caso de erro, retorna lista vazia
    Result.Clear;
  end;
end;

function TParametersDatabase.ValidateTableStructure: Boolean;
var
  LActualColumns: TStringList;
  LRequiredColumns: TStringList;
  LMissingColumns: TStringList;
  I: Integer;
  LColumnName: string;
  LSuccess: Boolean;
  LAvailableTables: TStringList;
  LTablesInfo: string;
  LSimilarTables: string;
  LSimilarList: TStringList;
  LSearchName: string;
  LTableName: string;
begin
  Result := False;

  // Verifica se a tabela existe
  if not InternalTableExists then
  begin
    // Se AutoCreateTable está ativo, tenta criar a tabela automaticamente
    if FAutoCreateTable then
    begin
      try
        CreateTable(LSuccess);
        if not LSuccess then
        begin
          raise CreateSQLException(
            Format('Tabela %s nao existe e nao foi possivel criar automaticamente.', [GetFullTableName]),
            ERR_SQL_TABLE_NOT_EXISTS,
            'ValidateTableStructure'
          );
        end;
        // Tabela criada com sucesso, continua validação
      except
        on E: EParametersSQLException do
        begin
          // Se falhar ao criar, lança exceção mais clara
          raise CreateSQLException(
            Format('Tabela %s nao existe e nao foi possivel criar automaticamente: %s', [GetFullTableName, E.Message]),
            ERR_SQL_TABLE_NOT_EXISTS,
            'ValidateTableStructure'
          );
        end;
      end;
    end
    else
    begin
      // AutoCreateTable desativado: lista tabelas disponíveis e lança exceção informativa
      LAvailableTables := nil;
      LTablesInfo := '';
      try
        // Tenta listar tabelas disponíveis
        try
          if IsConnected then
          begin
            LAvailableTables := ListAvailableTablesInternal;
            if (LAvailableTables <> nil) and (LAvailableTables.Count > 0) then
            begin
              LTablesInfo := Format(' Tabelas disponiveis no banco: %s. ', [LAvailableTables.CommaText]);
            end
            else
            begin
              LTablesInfo := ' Nenhuma tabela encontrada no banco. ';
            end;
          end;
        except
          // Se falhar ao listar tabelas, continua sem essa informação
          LTablesInfo := ' ';
        end;

        // Lança exceção informando que precisa criar manualmente, incluindo lista de tabelas
        raise CreateSQLException(
          Format('Tabela %s nao existe.%sUse CreateTable() para criar a tabela ou ative AutoCreateTable. ' +
                 'Use Table() para selecionar uma tabela existente ou ListAvailableTables() para ver todas as tabelas disponiveis.',
                 [GetFullTableName, LTablesInfo]),
          ERR_SQL_TABLE_NOT_EXISTS,
          'ValidateTableStructure'
        );
      finally
        if Assigned(LAvailableTables) then
          LAvailableTables.Free;
      end;
    end;
  end;

  // Obtém colunas reais da tabela
  LActualColumns := GetTableColumns;
  try
    // Define colunas obrigatórias mínimas (sem config_id, pois pode não existir em tabelas antigas)
    LRequiredColumns := TStringList.Create;
    try
      LRequiredColumns.Sorted := True;
      LRequiredColumns.CaseSensitive := False;

      // Colunas obrigatórias mínimas (sem config_id)
      LRequiredColumns.Add('chave');
      LRequiredColumns.Add('valor');

      // Colunas opcionais mas importantes
      LRequiredColumns.Add('contrato_id');
      LRequiredColumns.Add('produto_id');
      LRequiredColumns.Add('ordem');
      LRequiredColumns.Add('titulo');
      LRequiredColumns.Add('descricao');
      LRequiredColumns.Add('ativo');

      // Verifica quais colunas obrigatórias estão faltando
      LMissingColumns := TStringList.Create;
      try
        for I := 0 to LRequiredColumns.Count - 1 do
        begin
          LColumnName := LRequiredColumns[I];
          if LActualColumns.IndexOf(LColumnName) < 0 then
            LMissingColumns.Add(LColumnName);
        end;

        // Se faltar a coluna 'chave', a estrutura é incompatível
        if LMissingColumns.IndexOf('chave') >= 0 then
        begin
          raise CreateSQLException(
            Format(MSG_SQL_TABLE_STRUCTURE_INVALID,
                   [GetFullTableName, 'Coluna obrigatoria "chave" nao encontrada. Por favor, selecione outra tabela ou crie uma nova tabela com a estrutura correta.']),
            ERR_SQL_TABLE_STRUCTURE_INVALID,
            'ValidateTableStructure'
          );
        end;

        // Se faltar outras colunas importantes, avisa mas permite continuar
        if LMissingColumns.Count > 0 then
        begin
          // Estrutura parcialmente compatível - permite continuar mas avisa
          Result := True; // Estrutura aceitável (tem pelo menos 'chave' e 'valor')
        end
        else
        begin
          // Todas as colunas obrigatórias estão presentes
          Result := True;
        end;
      finally
        LMissingColumns.Free;
      end;
    finally
      LRequiredColumns.Free;
    end;
  finally
    LActualColumns.Free;
  end;
end;

function TParametersDatabase.BuildSelectFieldsSQL: string;
var
  LFields: TStringList;
  LActualColumns: TStringList;
  LExpectedColumns: TStringList;
  I: Integer;
  LColumnName: string;
begin
  LFields := TStringList.Create;
  LActualColumns := nil;
  LExpectedColumns := TStringList.Create;
  try
    // Define ordem esperada das colunas (importante para compatibilidade)
    LExpectedColumns.Add('config_id');      // Opcional (pode não existir)
    LExpectedColumns.Add('contrato_id');
    LExpectedColumns.Add('produto_id');
    LExpectedColumns.Add('ordem');
    LExpectedColumns.Add('titulo');
    LExpectedColumns.Add('chave');          // Obrigatória
    LExpectedColumns.Add('valor');          // Obrigatória
    LExpectedColumns.Add('descricao');
    LExpectedColumns.Add('ativo');
    LExpectedColumns.Add('data_cadastro');   // Opcional
    LExpectedColumns.Add('data_alteracao'); // Opcional

    // Obtém colunas reais da tabela
    LActualColumns := GetTableColumns;

    // Adiciona apenas colunas que realmente existem, na ordem esperada
    for I := 0 to LExpectedColumns.Count - 1 do
    begin
      LColumnName := LExpectedColumns[I];
      if LActualColumns.IndexOf(LColumnName) >= 0 then
        LFields.Add(LColumnName);
    end;

    // Se não encontrou nenhuma coluna, usa fallback mínimo
    if LFields.Count = 0 then
    begin
      // Fallback: tenta pelo menos 'chave' e 'valor'
      if LActualColumns.IndexOf('chave') >= 0 then
        LFields.Add('chave');
      if LActualColumns.IndexOf('valor') >= 0 then
        LFields.Add('valor');
    end;

    // Retorna como string separada por vírgula
    Result := LFields.CommaText;
    // CommaText adiciona aspas, então precisamos remover
    Result := StringReplace(Result, '"', '', [rfReplaceAll]);
  finally
    LFields.Free;
    if Assigned(LActualColumns) then
      LActualColumns.Free;
    LExpectedColumns.Free;
  end;
end;

function TParametersDatabase.GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  Result := 1; // Ordem padrão se não houver registros

  try
    // Busca a maior ordem existente para o título/contrato/produto específico
    LSQL := Format(
      'SELECT MAX(ordem) as max_ordem ' +
      'FROM %s ' +
      'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d',
      [
        GetFullTableName,
        EscapeSQL(ATitulo),
        AContratoID,
        AProdutoID
      ]
    );

    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
        begin
          if not LDataSet.FieldByName('max_ordem').IsNull then
            Result := LDataSet.FieldByName('max_ordem').AsInteger + 1;
        end;
      finally
        LDataSet.Close;
      end;
    end;
  except
    // Em caso de erro, retorna 1
    Result := 1;
  end;
end;

function TParametersDatabase.TituloExistsForContratoProduto(const ATitulo: string; AContratoID, AProdutoID: Integer; const AExcludeChave: string = ''): Boolean;
{ Verifica se existe pelo menos um registro com o título especificado
  para o Contrato/Produto informado, excluindo a chave especificada (se fornecida).
  Usado para verificar se um título já existe ao renomear. }
var
  LSQL: string;
  LDataSet: TDataSet;
  LCount: Integer;
begin
  Result := False;

  try
    // Monta SQL para contar registros com o título/contrato/produto
    LSQL := Format(
      'SELECT COUNT(*) as cnt FROM %s ' +
      'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d AND ativo = %s',
      [
        GetFullTableName,
        EscapeSQL(ATitulo),
        AContratoID,
        AProdutoID,
        BooleanToSQLCondition(True)
      ]
    );

    // Se foi fornecida uma chave para excluir, adiciona à cláusula WHERE
    if Trim(AExcludeChave) <> '' then
      LSQL := LSQL + Format(' AND chave <> ''%s''', [EscapeSQL(AExcludeChave)]);

    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
        begin
          LCount := LDataSet.FieldByName('cnt').AsInteger;
          Result := LCount > 0;
        end;
      finally
        LDataSet.Close;
      end;
    end;
  except
    // Em caso de erro, retorna False (assume que não existe)
    Result := False;
  end;
end;

function TParametersDatabase.ExistsWithTitulo(const AName, ATitulo: string; AContratoID, AProdutoID: Integer): Boolean;
{ Verifica se existe um registro com a mesma chave, título, contrato e produto.
  Usado para permitir chaves duplicadas em títulos diferentes. }
var
  LSQL: string;
  LDataSet: TDataSet;
  LCount: Integer;
begin
  Result := False;

  try
    // Garante que a tabela existe antes de fazer SELECT
    EnsureTableExists;
    
    // Monta SQL para contar registros com chave + título + contrato + produto
    // IMPORTANTE: Não filtra por ativo - verifica TODOS os registros (ativos e inativos)
    LSQL := Format(
      'SELECT COUNT(*) as cnt FROM %s ' +
      'WHERE chave = ''%s'' AND titulo = ''%s'' AND contrato_id = %d AND produto_id = %d',
      [
        GetFullTableName,
        EscapeSQL(AName),
        EscapeSQL(ATitulo),
        AContratoID,
        AProdutoID
      ]
    );
    
    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
        begin
          LCount := LDataSet.FieldByName('cnt').AsInteger;
          Result := LCount > 0;
        end;
      finally
        LDataSet.Close;
      end;
    end;
  except
    // Em caso de erro, retorna False (assume que não existe)
    Result := False;
  end;
end;

procedure TParametersDatabase.AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer);
var
  LSQL: string;
  LDatabaseType: TParameterDatabaseTypes;
begin
  // Se ordem <= 0, não precisa ajustar
  if AOrder <= 0 then
    Exit;

  LDatabaseType := StringToDatabaseType(FDatabaseType);

  try
    // Incrementa todas as ordens >= AOrder para dar espaço à nova ordem
    // Isso garante que a nova ordem seja inserida na posição desejada
    if LDatabaseType = pdtAccess then
    begin
      // Access: usa NOW() para data_alteracao
      LSQL := Format(
        'UPDATE %s SET ' +
        'ordem = ordem + 1, ' +
        'data_alteracao = NOW() ' +
        'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d AND ordem >= %d',
        [
          GetFullTableName,
          EscapeSQL(ATitulo),
          AContratoID,
          AProdutoID,
          AOrder
        ]
      );
    end
    else if LDatabaseType = pdtSQLServer then
    begin
      // SQL Server: usa GETDATE() que é mais compatível que CURRENT_TIMESTAMP
      LSQL := Format(
        'UPDATE %s SET ' +
        'ordem = ordem + 1, ' +
        'data_alteracao = GETDATE() ' +
        'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d AND ordem >= %d',
        [
          GetFullTableName,
          EscapeSQL(ATitulo),
          AContratoID,
          AProdutoID,
          AOrder
        ]
      );
    end
    else
    begin
      // Outros bancos: usa CURRENT_TIMESTAMP
      LSQL := Format(
        'UPDATE %s SET ' +
        'ordem = ordem + 1, ' +
        'data_alteracao = CURRENT_TIMESTAMP ' +
        'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d AND ordem >= %d',
        [
          GetFullTableName,
          EscapeSQL(ATitulo),
          AContratoID,
          AProdutoID,
          AOrder
        ]
      );
    end;

    ExecuteSQL(LSQL);
  except
    // Em caso de erro, apenas ignora (não bloqueia a inserção)
  end;
end;

procedure TParametersDatabase.AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID, AOldOrder, ANewOrder: Integer; const AChave: string);
var
  LSQL: string;
  LDatabaseType: TParameterDatabaseTypes;
begin
  // Se as ordens são iguais, não precisa ajustar
  if AOldOrder = ANewOrder then
    Exit;

  // Se nova ordem <= 0, não precisa ajustar (será calculada automaticamente)
  if ANewOrder <= 0 then
    Exit;

  LDatabaseType := StringToDatabaseType(FDatabaseType);

  try
    if ANewOrder > AOldOrder then
    begin
      // Movendo para uma ordem maior: decrementa ordens entre AOldOrder+1 e ANewOrder
      if LDatabaseType = pdtAccess then
      begin
        LSQL := Format(
          'UPDATE %s SET ' +
          'ordem = ordem - 1, ' +
          'data_alteracao = NOW() ' +
          'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d ' +
          'AND ordem > %d AND ordem <= %d AND chave <> ''%s''',
          [
            GetFullTableName,
            EscapeSQL(ATitulo),
            AContratoID,
            AProdutoID,
            AOldOrder,
            ANewOrder,
            EscapeSQL(AChave)
          ]
        );
      end
      else if LDatabaseType = pdtSQLServer then
      begin
        // SQL Server: usa GETDATE() que é mais compatível que CURRENT_TIMESTAMP
        LSQL := Format(
          'UPDATE %s SET ' +
          'ordem = ordem - 1, ' +
          'data_alteracao = GETDATE() ' +
          'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d ' +
          'AND ordem > %d AND ordem <= %d AND chave <> ''%s''',
          [
            GetFullTableName,
            EscapeSQL(ATitulo),
            AContratoID,
            AProdutoID,
            AOldOrder,
            ANewOrder,
            EscapeSQL(AChave)
          ]
        );
      end
      else
      begin
        LSQL := Format(
          'UPDATE %s SET ' +
          'ordem = ordem - 1, ' +
          'data_alteracao = CURRENT_TIMESTAMP ' +
          'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d ' +
          'AND ordem > %d AND ordem <= %d AND chave <> ''%s''',
          [
            GetFullTableName,
            EscapeSQL(ATitulo),
            AContratoID,
            AProdutoID,
            AOldOrder,
            ANewOrder,
            EscapeSQL(AChave)
          ]
        );
      end;
    end
    else
    begin
      // Movendo para uma ordem menor: incrementa ordens entre ANewOrder e AOldOrder-1
      if LDatabaseType = pdtAccess then
      begin
        LSQL := Format(
          'UPDATE %s SET ' +
          'ordem = ordem + 1, ' +
          'data_alteracao = NOW() ' +
          'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d ' +
          'AND ordem >= %d AND ordem < %d AND chave <> ''%s''',
          [
            GetFullTableName,
            EscapeSQL(ATitulo),
            AContratoID,
            AProdutoID,
            ANewOrder,
            AOldOrder,
            EscapeSQL(AChave)
          ]
        );
      end
      else if LDatabaseType = pdtSQLServer then
      begin
        // SQL Server: usa GETDATE() que é mais compatível que CURRENT_TIMESTAMP
        LSQL := Format(
          'UPDATE %s SET ' +
          'ordem = ordem + 1, ' +
          'data_alteracao = GETDATE() ' +
          'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d ' +
          'AND ordem >= %d AND ordem < %d AND chave <> ''%s''',
          [
            GetFullTableName,
            EscapeSQL(ATitulo),
            AContratoID,
            AProdutoID,
            ANewOrder,
            AOldOrder,
            EscapeSQL(AChave)
          ]
        );
      end
      else
      begin
        LSQL := Format(
          'UPDATE %s SET ' +
          'ordem = ordem + 1, ' +
          'data_alteracao = CURRENT_TIMESTAMP ' +
          'WHERE titulo = ''%s'' AND contrato_id = %d AND produto_id = %d ' +
          'AND ordem >= %d AND ordem < %d AND chave <> ''%s''',
          [
            GetFullTableName,
            EscapeSQL(ATitulo),
            AContratoID,
            AProdutoID,
            ANewOrder,
            AOldOrder,
            EscapeSQL(AChave)
          ]
        );
      end;
    end;

    ExecuteSQL(LSQL);
  except
    // Em caso de erro, apenas ignora (não bloqueia a atualização)
  end;
end;

function TParametersDatabase.DataSetToParameter(ADataSet: TDataSet): TParameter;
var
  LField: TField;
begin
  Result := TParameter.Create;
  try
    if not Assigned(ADataSet) then
      Exit;

    if ADataSet.Eof then
      Exit;

    // Verifica e acessa campos com proteção contra nulos (especialmente importante para Access)
    LField := ADataSet.FindField('config_id');
    if Assigned(LField) and not LField.IsNull then
      Result.ID := LField.AsInteger;

    LField := ADataSet.FindField('contrato_id');
    if Assigned(LField) and not LField.IsNull then
      Result.ContratoID := LField.AsInteger;

    LField := ADataSet.FindField('produto_id');
    if Assigned(LField) and not LField.IsNull then
      Result.ProdutoID := LField.AsInteger;

    LField := ADataSet.FindField('ordem');
    if Assigned(LField) and not LField.IsNull then
      Result.Ordem := LField.AsInteger;

    LField := ADataSet.FindField('titulo');
    if Assigned(LField) then
      Result.Titulo := LField.AsString;

    LField := ADataSet.FindField('chave');
    if Assigned(LField) then
      Result.Name := LField.AsString;

    LField := ADataSet.FindField('valor');
    if Assigned(LField) then
      Result.Value := LField.AsString;

    LField := ADataSet.FindField('descricao');
    if Assigned(LField) then
      Result.Description := LField.AsString;

    // Campo ativo precisa de tratamento especial (BooleanFromDataSet já faz isso)
    Result.Ativo := BooleanFromDataSet(ADataSet, 'ativo');

    // Verifica se os campos de data existem antes de acessá-los
    // Isso evita erros quando a tabela foi criada sem esses campos
    LField := ADataSet.FindField('data_cadastro');
    if Assigned(LField) and not LField.IsNull then
      Result.CreatedAt := LField.AsDateTime;

    LField := ADataSet.FindField('data_alteracao');
    if Assigned(LField) and not LField.IsNull then
      Result.UpdatedAt := LField.AsDateTime;
  except
    Result.Free;
    raise;
  end;
end;

function TParametersDatabase.ExecuteSQL(const ASQL: string): Boolean;
begin
  Result := False;

  // Validações
  if Trim(ASQL) = '' then
    raise CreateSQLException('SQL vazio nao pode ser executado.', ERR_SQL_INVALID, 'ExecuteSQL');

  if not IsConnected then
    raise CreateConnectionException(MSG_CONNECTION_NOT_CONNECTED, ERR_CONNECTION_NOT_CONNECTED, 'ExecuteSQL');

  try
    if Assigned(FExecQuery) then
    begin
      {$IF DEFINED(USE_UNIDAC)}
        TUniQuery(FExecQuery).SQL.Text := ASQL;
        TUniQuery(FExecQuery).ExecSQL;
      {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                TFDQuery(FExecQuery).SQL.Text := ASQL;
                TFDQuery(FExecQuery).ExecSQL;
              {$ELSE} {$IF DEFINED(USE_ZEOS)}
                        TZQuery(FExecQuery).SQL.Text := ASQL;
                        TZQuery(FExecQuery).ExecSQL;
                      {$ELSE}
                        raise CreateSQLException(MSG_ENGINE_NOT_DEFINED, ERR_ENGINE_NOT_DEFINED, 'ExecuteSQL');
                      {$ENDIF}
              {$ENDIF}
      {$ENDIF}
      Result := True;
    end
    else if Assigned(FQuery) then
    begin
      {$IF DEFINED(USE_UNIDAC)}
        TUniQuery(FQuery).SQL.Text := ASQL;
        TUniQuery(FQuery).ExecSQL;
      {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                TFDQuery(FQuery).SQL.Text := ASQL;
                TFDQuery(FQuery).ExecSQL;
              {$ELSE} {$IF DEFINED(USE_ZEOS)}
                        TZQuery(FQuery).SQL.Text := ASQL;
                        TZQuery(FQuery).ExecSQL;
                      {$ELSE}
                        raise CreateSQLException(MSG_ENGINE_NOT_DEFINED, ERR_ENGINE_NOT_DEFINED, 'ExecuteSQL');
                      {$ENDIF}
             {$ENDIF}
      {$ENDIF}
      Result := True;
    end
    else
      raise CreateSQLException('Query nao foi inicializada.', ERR_SQL_EXECUTION_FAILED, 'ExecuteSQL');
  except
    on E: EParametersException do
      raise; // Re-lanca excecao do Parameters
    on E: Exception do
      // Converte exceção genérica para exceção do Parameters
      raise ConvertToParametersException(E, 'ExecuteSQL');
  end;
end;

function TParametersDatabase.QuerySQL(const ASQL: string): TDataSet;
begin
  Result := nil;

  // Validações
  if Trim(ASQL) = '' then
    raise CreateSQLException('SQL vazio nao pode ser executado.', ERR_SQL_INVALID, 'QuerySQL');

  if not IsConnected then
    raise CreateConnectionException(MSG_CONNECTION_NOT_CONNECTED, ERR_CONNECTION_NOT_CONNECTED, 'QuerySQL');

  try
    if not Assigned(FQuery) then
      raise CreateSQLException('Query nao foi inicializada.', ERR_SQL_QUERY_FAILED, 'QuerySQL');

{$IF (DEFINED(USE_UNIDAC) AND DEFINED(USE_FIREDAC))} {$FATAL Somente um motor pode estar ativo! } {$ENDIF}

    // Execução
    {$IF DEFINED(USE_UNIDAC)}
      TUniQuery(FQuery).SQL.Text := ASQL;
      TUniQuery(FQuery).Open;
    {$ELSE} {$IF DEFINED(USE_FIREDAC) AND NOT DEFINED(FPC)}
              TFDQuery(FQuery).SQL.Text := ASQL;
              TFDQuery(FQuery).Open;
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      TZQuery(FQuery).SQL.Text := ASQL;
                      TZQuery(FQuery).Open;
                    {$ELSE}
                      raise CreateSQLException(MSG_ENGINE_NOT_DEFINED, ERR_ENGINE_NOT_DEFINED, 'QuerySQL');
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}
    Result := FQuery;
  except
    on E: EParametersException do
      raise; // Re-lanca excecao do Parameters
    on E: Exception do
      // Converte exceção genérica para exceção do Parameters
      raise ConvertToParametersException(E, 'QuerySQL');
  end;
end;

function TParametersDatabase.TableName(const AValue: string): IParametersDatabase;
begin
  FTableName := AValue;
  Result := Self;
end;

function TParametersDatabase.TableName: string;
begin
  Result := FTableName;
end;

function TParametersDatabase.Schema(const AValue: string): IParametersDatabase;
begin
  FSchema := AValue;
  Result := Self;
end;

function TParametersDatabase.Schema: string;
begin
  Result := FSchema;
end;

function TParametersDatabase.AutoCreateTable(const AValue: Boolean): IParametersDatabase;
begin
  FAutoCreateTable := AValue;
  Result := Self;
end;

function TParametersDatabase.AutoCreateTable: Boolean;
begin
  Result := FAutoCreateTable;
end;

{ ============================================================================= }
{ CONFIGURAÇÃO DE CONEXÃO (Fluent Interface)                                   }
{ ============================================================================= }

function TParametersDatabase.Engine(const AValue: string): IParametersDatabase;
begin
  FEngine := AValue;
  Result := Self;
end;

function TParametersDatabase.Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase;
begin
  // Usa constante de Modulo.Parameters.Consts.pas
  if AValue = pteNone then
    FEngine := ''
  else
    FEngine := TEngineDatabase[AValue];
  Result := Self;
end;

function TParametersDatabase.Engine: string;
begin
  Result := FEngine;
end;

function TParametersDatabase.DatabaseType(const AValue: string): IParametersDatabase;
var
  LWasConnected: Boolean;
  LDatabaseType: TParameterDatabaseTypes;
  LTypeChanged: Boolean;
  LDefaultPassword: string;
begin
  // Verifica se o tipo realmente mudou
  LTypeChanged := (FDatabaseType <> AValue);

  // Se o tipo mudou e a conexão já existe, precisa recriar completamente
  LWasConnected := False;
  if LTypeChanged and FOwnConnection and Assigned(FConnection) then
  begin
    LWasConnected := IsConnectionConnected;
    if LWasConnected then
      DisconnectConnection;
    DestroyInternalConnection; // Destrói conexão e todos os providers
  end;

  FDatabaseType := AValue;

  // Se o tipo mudou, preenche automaticamente os campos vazios com valores default do novo tipo
  if LTypeChanged then
  begin
    LDatabaseType := StringToDatabaseType(FDatabaseType);

    // Preenche Host se estiver vazio
    if Trim(FHost) = '' then
      FHost := GetDefaultHost;

    // Preenche Port se for 0 ou negativo
    if FPort <= 0 then
      FPort := GetDefaultPort;

    // Preenche Username se estiver vazio
    if Trim(FUsername) = '' then
      FUsername := GetDefaultUsername;

    // Preenche Password se estiver vazio e houver default definido
    // Nota: Alguns bancos têm password padrão (ex: Firebird = 'masterkey')
    // Outros podem ter password vazio, mas ainda assim verificamos o default
    if Trim(FPassword) = '' then
    begin
      LDefaultPassword := GetDefaultPassword;
      // Só aplica default se realmente houver um default definido (não vazio)
      if LDefaultPassword <> '' then
        FPassword := LDefaultPassword;
    end;

    // Preenche Database se estiver vazio
    if Trim(FDatabase) = '' then
      FDatabase := GetDefaultDatabase;
  end;

  // Sempre recria conexão se não existe ou se foi destruída acima
  if FOwnConnection and not Assigned(FConnection) then
  begin
    CreateInternalConnection; // Cria conexão e provider apropriado
    if LWasConnected then
      ConnectConnection;
  end
  else if FOwnConnection and Assigned(FConnection) then
  begin
    // Se a conexão já existe mas o tipo não mudou, apenas garante que o provider existe
    LDatabaseType := StringToDatabaseType(FDatabaseType);
    {$IF (DEFINED(USE_UNIDAC) OR DEFINED(USE_FIREDAC)) AND NOT DEFINED(FPC)}
    // Garante que o provider correto existe (pode não ter sido criado ainda)
    CreateProviderForDatabaseType(LDatabaseType);
    {$ENDIF}
  end;

  Result := Self;
end;

function TParametersDatabase.DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase;
var
  LNewDatabaseType: string;
begin
  // Usa constante de Modulo.Parameters.Consts.pas
  if AValue = pdtNone then
    LNewDatabaseType := ''
  else
    LNewDatabaseType := TDatabaseTypeNames[AValue];

  // Chama a versão string que já trata recriação de conexão
  DatabaseType(LNewDatabaseType);
  Result := Self;
end;

function TParametersDatabase.DatabaseType: string;
begin
  Result := FDatabaseType;
end;

function TParametersDatabase.Host(const AValue: string): IParametersDatabase;
begin
  // Se não informado, usa valor padrão baseado no tipo de banco
  if Trim(AValue) = '' then
    FHost := GetDefaultHost
  else
    FHost := AValue;

  // Se já tem conexão interna criada, atualiza
  if FOwnConnection and Assigned(FConnection) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
      TUniConnection(FConnection).Server := FHost;
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              TFDConnection(FConnection).Params.Values['Server'] := FHost;
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      TZConnection(FConnection).HostName := FHost;
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}
  end;
  Result := Self;
end;

function TParametersDatabase.Host: string;
begin
  Result := FHost;
end;

function TParametersDatabase.Port(const AValue: Integer): IParametersDatabase;
begin
  // Se não informado (0 ou negativo), usa valor padrão baseado no tipo de banco
  if AValue <= 0 then
    FPort := GetDefaultPort
  else
    FPort := AValue;

  // Se já tem conexão interna criada, atualiza
  if FOwnConnection and Assigned(FConnection) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
      TUniConnection(FConnection).Port := FPort;
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              TFDConnection(FConnection).Params.Values['Port'] := IntToStr(FPort);
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      TZConnection(FConnection).Port := FPort;
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}
  end;
  Result := Self;
end;

function TParametersDatabase.Port: Integer;
begin
  Result := FPort;
end;

function TParametersDatabase.Username(const AValue: string): IParametersDatabase;
begin
  // Se não informado, usa valor padrão baseado no tipo de banco
  if Trim(AValue) = '' then
    FUsername := GetDefaultUsername
  else
    FUsername := AValue;

  // Se já tem conexão interna criada, atualiza
  if FOwnConnection and Assigned(FConnection) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
      TUniConnection(FConnection).Username := FUsername;
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              TFDConnection(FConnection).Params.Values['User_Name'] := FUsername;
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      TZConnection(FConnection).User := FUsername;
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}

  end;
  Result := Self;
end;

function TParametersDatabase.Username: string;
begin
  Result := FUsername;
end;

function TParametersDatabase.Password(const AValue: string): IParametersDatabase;
var
  LDefaultPassword: string;
begin
  // Se não informado (string vazia), usa valor padrão baseado no tipo de banco
  // Nota: Alguns bancos têm password padrão (ex: Firebird = 'masterkey')
  // Outros podem ter password vazio, mas ainda assim usamos o default definido
  if Trim(AValue) = '' then
  begin
    LDefaultPassword := GetDefaultPassword;
    // Só aplica default se realmente houver um default definido (não vazio)
    // Isso permite que bancos sem password padrão mantenham vazio
    if LDefaultPassword <> '' then
      FPassword := LDefaultPassword
    else
      FPassword := '';
  end
  else
    FPassword := AValue;

  // Se já tem conexão interna criada, atualiza
  if FOwnConnection and Assigned(FConnection) then
  begin
    {$IF DEFINED(USE_UNIDAC)}
      TUniConnection(FConnection).Password := FPassword;
    {$ELSE} {$IF DEFINED(USE_FIREDAC)}
              TFDConnection(FConnection).Params.Values['Password'] := FPassword;
            {$ELSE} {$IF DEFINED(USE_ZEOS)}
                      TZConnection(FConnection).Password := FPassword;
                    {$ENDIF}
            {$ENDIF}
    {$ENDIF}
  end;
  Result := Self;
end;

function TParametersDatabase.Password: string;
begin
  Result := FPassword;
end;

function TParametersDatabase.ContratoID(const AValue: Integer): IParametersDatabase;
begin
  FContratoID := AValue;
  Result := Self;
end;

function TParametersDatabase.ContratoID: Integer;
begin
  Result := FContratoID;
end;

function TParametersDatabase.ProdutoID(const AValue: Integer): IParametersDatabase;
begin
  FProdutoID := AValue;
  Result := Self;
end;

function TParametersDatabase.ProdutoID: Integer;
begin
  Result := FProdutoID;
end;

function TParametersDatabase.Database(const AValue: string): IParametersDatabase;
begin
  FLock.Enter;
  try
    // Se não informado, usa valor padrão baseado no tipo de banco
    if Trim(AValue) = '' then
      FDatabase := GetDefaultDatabase
    else
      FDatabase := AValue;

    // Se já tem conexão interna criada, atualiza
    if FOwnConnection and Assigned(FConnection) then
    begin
      {$IF DEFINED(USE_UNIDAC)}
        TUniConnection(FConnection).Database := FDatabase;
      {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                TFDConnection(FConnection).Params.Values['Database'] := FDatabase;
              {$ELSE} {$IF DEFINED(USE_ZEOS)}
                        TZConnection(FConnection).Database := FDatabase;
                      {$ENDIF}
              {$ENDIF}
      {$ENDIF}
    end;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Database: string;
begin
  Result := FDatabase;
end;

{ ============================================================================= }
{ CONFIGURAÇÃO DE CONEXÃO (Independente)                                       }
{ ============================================================================= }

function TParametersDatabase.Connection(AConnection: TObject): IParametersDatabase;
begin
  FLock.Enter;
  try
    // Se já tinha conexão própria, libera
    if FOwnConnection then
      DestroyInternalConnection;

    FConnection := {$IF DEFINED(USE_UNIDAC)}
                     TUniConnection(AConnection)
                   {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                             TFDConnection(AConnection)
                           {$ELSE} {$IF DEFINED(USE_ZEOS)}
                                     TZConnection(AConnection)
                                     {$ENDIF}
                           {$ENDIF}
                   {$ENDIF};
    FOwnConnection := False; // Conexão externa, não gerencia
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Query(AQuery: TDataSet): IParametersDatabase;
begin
  // Se já tinha query própria, libera
  if FOwnConnection and Assigned(FQuery) then
  begin
    try
      if FQuery.Active then
        FQuery.Close;
    except
      // Ignorar
    end;
    FQuery.Free;
  end;

  FQuery := {$IF DEFINED(USE_UNIDAC)}
              TUniQuery(AQuery)
            {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                      TFDQuery(AQuery)
                    {$ELSE} {$IF DEFINED(USE_ZEOS)}
                              TZQuery(AQuery)
                            {$ENDIF}
                    {$ENDIF}
            {$ENDIF};
  Result := Self;
end;

function TParametersDatabase.ExecQuery(AExecQuery: TDataSet): IParametersDatabase;
begin
  // Se já tinha query própria, libera
  if FOwnConnection and Assigned(FExecQuery) then
  begin
    try
      if FExecQuery.Active then
        FExecQuery.Close;
    except
      // Ignorar
    end;
    FExecQuery.Free;
  end;

  FExecQuery :=
            {$IF DEFINED(USE_UNIDAC)}
              TUniQuery(AExecQuery)
            {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                      TFDQuery(AExecQuery)
                    {$ELSE} {$IF DEFINED(USE_ZEOS)}
                              TZQuery(AExecQuery)
                            {$ENDIF}
                    {$ENDIF}
            {$ENDIF};
  Result := Self;
end;

function TParametersDatabase.List: TParameterList;
var
  LList: TParameterList;
begin
  List(LList);
  Result := LList;
end;

{ =============================================================================
  List - Lista todos os parâmetros ativos do banco de dados

  Descrição:
  Retorna uma lista de todos os parâmetros ativos (ativo = true) que correspondem
  aos filtros de ContratoID e ProdutoID configurados. A lista é ordenada por
  ordem, titulo e chave.
  
  Comportamento:
  - Filtra apenas parâmetros ativos (ativo = true)
  - Aplica filtros de ContratoID e ProdutoID se configurados
  - Ordena por: ordem ASC, titulo ASC, chave ASC
  - Garante que a tabela existe antes de executar a consulta
  - Valida estrutura da tabela antes de fazer SELECT
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AList: Lista de parâmetros retornada (deve ser liberada pelo chamador)
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersConnectionException: Se não estiver conectado
  - EParametersSQLException: Se a tabela não existir ou houver erro na consulta SQL
  - EParametersException: Outras exceções do sistema de parâmetros
  
  Exemplo:
  var
    DB: IParametersDatabase;
    ParamList: TParameterList;
  begin
    DB := TParameters.NewDatabase
      .TableName('config')
      .ContratoID(1)
      .ProdutoID(1)
      .Connect;
    
    ParamList := DB.List;
    try
      // Usar ParamList...
    finally
      ParamList.Free;
    end;
  end;
  ============================================================================= }
function TParametersDatabase.List(out AList: TParameterList): IParametersDatabase;
var
  LSQL: string;
  LDataSet: TDataSet;
  LParameter: TParameter;
  LAvailableTables: TStringList;
  LTablesInfo: string;
begin
  Result := Self;
  FLock.Enter;
  try
    // Verifica se a tabela existe
    if not InternalTableExists then
  begin
    // Lista tabelas disponíveis antes de lançar exceção
    LAvailableTables := nil;
    LTablesInfo := '';
    try
      // Tenta listar tabelas disponíveis
      try
        if IsConnected then
        begin
          LAvailableTables := ListAvailableTablesInternal;
          if (LAvailableTables <> nil) and (LAvailableTables.Count > 0) then
          begin
            LTablesInfo := Format(' Tabelas disponiveis no banco: %s. ', [LAvailableTables.CommaText]);
          end
          else
          begin
            LTablesInfo := ' Nenhuma tabela encontrada no banco. ';
          end;
        end;
      except
        // Se falhar ao listar tabelas, continua sem essa informação
        LTablesInfo := ' ';
      end;
      
      // Lança exceção informativa incluindo lista de tabelas
      raise CreateSQLException(
        Format('Tabela %s nao existe.%sUse CreateTable() para criar a tabela ou Table() para selecionar uma tabela existente. ' +
               'Use ListAvailableTables() para ver todas as tabelas disponiveis.',
               [GetFullTableName, LTablesInfo]),
        ERR_SQL_TABLE_NOT_EXISTS,
        'List'
      );
    finally
      if Assigned(LAvailableTables) then
        LAvailableTables.Free;
    end;
  end;
  
  // Valida estrutura da tabela antes de fazer SELECT
  ValidateTableStructure;
  
  AList := TParameterList.Create;
  try
    // Usa BuildSelectFieldsSQL para incluir apenas campos que existem na tabela
    // Adiciona filtros de ContratoID e ProdutoID na cláusula WHERE se configurados
    // IMPORTANTE: Não filtra por ativo - lista TODOS os registros (ativos e inativos)
    // Se precisar filtrar apenas ativos, use um método específico ou adicione filtro opcional
    LSQL := BuildSelectFieldsSQL;
    
    // Valida se BuildSelectFieldsSQL retornou campos válidos
    if Trim(LSQL) = '' then
      raise CreateSQLException(
        Format('Nenhum campo valido encontrado na tabela %s. Verifique se a tabela foi criada corretamente.', [GetFullTableName]),
        ERR_SQL_TABLE_NOT_EXISTS,
        'List'
      );
    
    LSQL := 'SELECT ' + LSQL + ' ' +
            'FROM ' + GetFullTableName;
    
    // Constrói a cláusula WHERE dinamicamente
    // Adiciona filtros de ContratoID e ProdutoID se configurados (> 0)
    if (FContratoID > 0) or (FProdutoID > 0) then
    begin
      LSQL := LSQL + ' WHERE';
      
      if FContratoID > 0 then
        LSQL := LSQL + ' contrato_id = ' + IntToStr(FContratoID);
      
      if FProdutoID > 0 then
      begin
        if FContratoID > 0 then
          LSQL := LSQL + ' AND';
        LSQL := LSQL + ' produto_id = ' + IntToStr(FProdutoID);
      end;
    end;
    
    // Aplica ordenação padrão: Contrato → Produto → Título → Ordem
    LSQL := LSQL + ' ORDER BY ' + DEFAULT_PARAMETER_ORDER_BY;
    
    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        // Verifica se o DataSet está ativo e tem dados
        if LDataSet.Active then
        begin
          try
            LDataSet.First;
            while not LDataSet.Eof do
            begin
              try
                LParameter := DataSetToParameter(LDataSet);
                if Assigned(LParameter) then
                  AList.Add(LParameter)
                else
                  // Se DataSetToParameter retornar nil, continua para próximo registro
                  Break;
              except
                // Se houver erro ao converter um registro, continua para o próximo
                // Isso evita que um registro inválido pare todo o processo
                on E: Exception do
                begin
                  // Log do erro seria ideal aqui, mas por enquanto apenas continua
                  // Pode adicionar logging se necessário
                end;
              end;
              
              // Move para próximo registro com proteção
              try
                LDataSet.Next;
              except
                // Se falhar ao mover, sai do loop
                Break;
              end;
            end;
          except
            // Se houver erro ao processar DataSet, lança exceção
            raise;
          end;
        end;
      finally
        // Sempre fecha o DataSet, mesmo se houver erro
        try
          if LDataSet.Active then
            LDataSet.Close;
        except
          // Ignora erros ao fechar
        end;
      end;
    end;
  except
    AList.Free;
    raise;
  end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Get(const AName: string): TParameter;
var
  LParameter: TParameter;
begin
  Get(AName, LParameter);
  Result := LParameter;
end;

{ =============================================================================
  Get - Busca um parâmetro específico por chave (nome)
  
  Descrição:
  Busca um parâmetro específico no banco de dados pelo nome (chave). Diferente
  do método List(), este método retorna TODOS os registros (ativos e inativos),
  permitindo carregar e reativar parâmetros que foram marcados como inativos.
  
  Comportamento:
  - Busca por chave exata (case-sensitive)
  - Retorna parâmetros ativos E inativos (não filtra por ativo)
  - Retorna nil se não encontrar o parâmetro
  - Garante que a tabela existe antes de executar a consulta
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AName: Nome/chave do parâmetro a ser buscado
  - AParameter: Parâmetro retornado (deve ser liberado pelo chamador se não for nil)
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersConnectionException: Se não estiver conectado
  - EParametersSQLException: Se houver erro na consulta SQL
  - EParametersException: Outras exceções do sistema de parâmetros
  
  Nota:
  - O parâmetro retornado deve ser liberado pelo chamador usando AParameter.Free
  - Se não encontrar, AParameter será nil
  
  Exemplo:
  var
    DB: IParametersDatabase;
    Param: TParameter;
  begin
    DB := TParameters.NewDatabase
      .TableName('config')
      .Connect;
    
    Param := DB.Get('erp_host');
    try
      if Assigned(Param) then
        ShowMessage(Param.Value)
      else
        ShowMessage('Parâmetro não encontrado');
    finally
      if Assigned(Param) then
        Param.Free;
    end;
  end;
  ============================================================================= }
function TParametersDatabase.Get(const AName: string; out AParameter: TParameter): IParametersDatabase;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  Result := Self;
  FLock.Enter;
  try
    // Garante que a tabela existe antes de fazer SELECT
    EnsureTableExists;
  
  AParameter := TParameter.Create;
  try
    // Usa BuildSelectFieldsSQL para incluir apenas campos que existem na tabela
    // IMPORTANTE: Não filtra por ativo - busca TODOS os registros (ativos e inativos)
    // Isso permite carregar e reativar registros inativos
    LSQL := Format(
      'SELECT %s ' +
      'FROM %s ' +
      'WHERE chave = ''%s''',
      [BuildSelectFieldsSQL, GetFullTableName, EscapeSQL(AName)]
    );
    
    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
        begin
          AParameter.Free;
          AParameter := DataSetToParameter(LDataSet);
        end;
      finally
        LDataSet.Close;
      end;
    end;
  except
    AParameter.Free;
    raise;
  end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Insert(const AParameter: TParameter): IParametersDatabase;
var
  LSuccess: Boolean;
begin
  Insert(AParameter, LSuccess);
  Result := Self;
end;

{ =============================================================================
  Insert - Insere um novo parâmetro no banco de dados
  
  Descrição:
  Insere um novo parâmetro na tabela config. Se o parâmetro já existir (mesma
  chave), a operação falha silenciosamente (ASuccess = False). O método gerencia
  automaticamente a ordem dos parâmetros conforme as configurações de
  reordenação automática.
  
  Comportamento:
  - Verifica se o parâmetro já existe antes de inserir
  - Se já existir, retorna ASuccess = False sem inserir
  - Gerencia ordem automaticamente conforme configurações:
    * FAutoRenumberZeroOrder: Se ordem <= 0, calcula automaticamente
    * FAutoReorderOnInsert: Se ordem especificada, ajusta ordens existentes
  - Garante que a tabela existe antes de executar o INSERT
  - Valida estrutura da tabela para SQLite
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AParameter: Parâmetro a ser inserido (não é liberado pelo método)
  - ASuccess: Indica se a inserção foi bem-sucedida
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersConnectionException: Se não estiver conectado
  - EParametersSQLException: Se houver erro na execução SQL
  - EParametersException: Outras exceções do sistema de parâmetros
  
  Nota:
  - O parâmetro não é liberado pelo método (responsabilidade do chamador)
  - Se o parâmetro já existir, ASuccess será False mas não lança exceção
  
  Exemplo:
  var
    DB: IParametersDatabase;
    Param: TParameter;
    Success: Boolean;
  begin
    DB := TParameters.NewDatabase
      .TableName('config')
      .Connect;
    
    Param := TParameter.Create;
    Param.Name := 'erp_host';
    Param.Value := 'localhost';
    Param.Titulo := 'ERP';
    Param.ContratoID := 1;
    Param.ProdutoID := 1;
    
    DB.Insert(Param, Success);
    if Success then
      ShowMessage('Inserido com sucesso!')
    else
      ShowMessage('Parâmetro já existe ou falha na inserção');
    
    Param.Free;
  end;
  ============================================================================= }
function TParametersDatabase.Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;
var
  LSQL: string;
  LDatabaseType: TParameterDatabaseTypes;
  LOrder: Integer;
begin
  Result := Self;
  FLock.Enter;
  try
    // Garante que a tabela existe antes de fazer INSERT
    EnsureTableExists;
  
  // Valida a estrutura da tabela antes de salvar
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  if LDatabaseType = pdtSQLite then
    ValidateSQLiteTableStructure;
  
  ASuccess := False;
  try
    // Verifica se já existe com mesmo nome, título, contrato e produto
    // Permite chaves com mesmo nome em títulos diferentes
    if ExistsWithTitulo(AParameter.Name, AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID) then
      Exit;
    
    // Determina a ordem desejada
    LOrder := AParameter.Ordem;
    
    // Se ordem vazia (<= 0) e renumerar zero está habilitado, calcula automaticamente
    if (LOrder <= 0) and FAutoRenumberZeroOrder then
    begin
      LOrder := GetNextOrder(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID);
    end
    else if (LOrder <= 0) and not FAutoRenumberZeroOrder then
    begin
      // Mantém ordem 0 se renumerar zero estiver desabilitado
      LOrder := 0;
    end
    else if (LOrder > 0) and FAutoReorderOnInsert then
    begin
      // Se ordem especificada e reordenação está habilitada, ajusta as ordens existentes
      AdjustOrdersForInsert(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, LOrder);
    end;
    // Se FAutoReorderOnInsert = False, não ajusta (pode causar duplicação de ordens)
    
    // Access via ODBC não suporta CURRENT_TIMESTAMP, usa NOW() ou valores explícitos
    LDatabaseType := StringToDatabaseType(FDatabaseType);
    if LDatabaseType = pdtAccess then
    begin
      // Access: usa NOW() para timestamps
      LSQL := Format(
        'INSERT INTO %s (contrato_id, produto_id, ordem, titulo, chave, valor, descricao, ativo, data_cadastro, data_alteracao) ' +
        'VALUES (%d, %d, %d, ''%s'', ''%s'', ''%s'', ''%s'', %s, NOW(), NOW())',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Name),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo)
        ]
      );
    end
    else if LDatabaseType = pdtFireBird then
    begin
      // FireBird: NÃO inclui config_id no INSERT - o trigger BEFORE INSERT preenche automaticamente
      // O trigger verifica se NEW.config_id IS NULL e preenche usando GEN_ID(gen_config_config_id, 1)
      // Se incluirmos config_id explicitamente (mesmo como NULL), o Firebird valida a constraint NOT NULL antes do trigger
      LSQL := Format(
        'INSERT INTO %s (contrato_id, produto_id, ordem, titulo, chave, valor, descricao, ativo, data_cadastro, data_alteracao) ' +
        'VALUES (%d, %d, %d, ''%s'', ''%s'', ''%s'', ''%s'', %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Name),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo)
        ]
      );
    end
    else if LDatabaseType = pdtSQLServer then
    begin
      // SQL Server: usa GETDATE() que é mais compatível que CURRENT_TIMESTAMP
      // CONFIG_ID é auto-incremento (IDENTITY) e não precisa ser incluído
      LSQL := Format(
        'INSERT INTO %s (contrato_id, produto_id, ordem, titulo, chave, valor, descricao, ativo, data_cadastro, data_alteracao) ' +
        'VALUES (%d, %d, %d, ''%s'', ''%s'', ''%s'', ''%s'', %s, GETDATE(), GETDATE())',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Name),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo)
        ]
      );
    end
    else
    begin
      // Outros bancos: usa CURRENT_TIMESTAMP
      // PostgreSQL, MySQL, SQLite: CONFIG_ID é auto-incremento e não precisa ser incluído
      LSQL := Format(
        'INSERT INTO %s (contrato_id, produto_id, ordem, titulo, chave, valor, descricao, ativo, data_cadastro, data_alteracao) ' +
        'VALUES (%d, %d, %d, ''%s'', ''%s'', ''%s'', ''%s'', %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Name),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo)
        ]
      );
    end;
    
    ASuccess := ExecuteSQL(LSQL);
  except
    ASuccess := False;
  end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Update(const AParameter: TParameter): IParametersDatabase;
var
  LSuccess: Boolean;
begin
  Update(AParameter, LSuccess);
  Result := Self;
end;

{ =============================================================================
  Update - Atualiza um parâmetro existente no banco de dados
  
  Descrição:
  Atualiza um parâmetro existente na tabela config. Se o parâmetro não existir,
  a operação falha silenciosamente (ASuccess = False). O método gerencia
  automaticamente a ordem dos parâmetros conforme as configurações de
  reordenação automática, incluindo tratamento especial quando o título muda.
  
  Comportamento:
  - Verifica se o parâmetro existe antes de atualizar
  - Se não existir, retorna ASuccess = False sem atualizar
  - Gerencia ordem automaticamente conforme configurações:
    * FAutoRenumberZeroOrder: Se ordem <= 0, calcula automaticamente
    * FAutoReorderOnUpdate: Se ordem mudou, ajusta ordens existentes
  - Trata mudança de título: se título mudou, recalcula ordem no novo título
  - Garante que a tabela existe antes de executar o UPDATE
  - Valida estrutura da tabela para SQLite
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AParameter: Parâmetro a ser atualizado (não é liberado pelo método)
  - ASuccess: Indica se a atualização foi bem-sucedida
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersConnectionException: Se não estiver conectado
  - EParametersSQLException: Se houver erro na execução SQL
  - EParametersException: Outras exceções do sistema de parâmetros
  
  Nota:
  - O parâmetro não é liberado pelo método (responsabilidade do chamador)
  - Se o parâmetro não existir, ASuccess será False mas não lança exceção
  
  Exemplo:
  var
    DB: IParametersDatabase;
    Param: TParameter;
    Success: Boolean;
  begin
    DB := TParameters.NewDatabase
      .TableName('config')
      .Connect;
    
    Param := DB.Get('erp_host');
    try
      if Assigned(Param) then
      begin
        Param.Value := '192.168.1.100';
        DB.Update(Param, Success);
        if Success then
          ShowMessage('Atualizado com sucesso!');
      end;
    finally
      if Assigned(Param) then
        Param.Free;
    end;
  end;
  ============================================================================= }
function TParametersDatabase.Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;
var
  LSQL: string;
  LDatabaseType: TParameterDatabaseTypes;
  LOrder: Integer;
  LOldOrder: Integer;
  LOldParameter: TParameter;
begin
  Result := Self;
  FLock.Enter;
  try
    // Garante que a tabela existe antes de fazer UPDATE
    EnsureTableExists;
  
  // Para SQLite, valida a estrutura da tabela antes de salvar
  LDatabaseType := StringToDatabaseType(FDatabaseType);
  if LDatabaseType = pdtSQLite then
    ValidateSQLiteTableStructure;
  
  ASuccess := False;
  try
    // Verifica se existe
    if not Exists(AParameter.Name) then
      Exit;
    
    // Obtém o parâmetro atual para comparar título e ordem antiga
    LOldParameter := Get(AParameter.Name);
    try
      LOldOrder := LOldParameter.Ordem;
      
      // Verifica se o título mudou
      // Se o título mudou, precisa verificar se o novo título já existe
      // e ajustar a ordem conforme necessário
      if not SameText(LOldParameter.Titulo, AParameter.Titulo) then
      begin
        // Título mudou - verifica se o novo título já existe para o mesmo Contrato/Produto
        if not TituloExistsForContratoProduto(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, AParameter.Name) then
        begin
          // Novo título não existe - inicia ordem do 1
          LOrder := 1;
          // Ajusta ordens existentes no novo título para dar espaço (se necessário)
          if FAutoReorderOnUpdate then
            AdjustOrdersForInsert(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, LOrder);
        end
        else
        begin
          // Novo título já existe - segue critérios de reordenação
          // Determina a ordem desejada
          LOrder := AParameter.Ordem;
          
          // Se ordem vazia (<= 0) e renumerar zero está habilitado, calcula automaticamente
          if (LOrder <= 0) and FAutoRenumberZeroOrder then
          begin
            LOrder := GetNextOrder(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID);
          end
          else if (LOrder <= 0) and not FAutoRenumberZeroOrder then
          begin
            // Mantém ordem 0 se renumerar zero estiver desabilitado
            LOrder := 0;
          end;
          
          // Se ordem especificada e reordenação está habilitada, ajusta as ordens existentes
          if (LOrder > 0) and FAutoReorderOnUpdate then
          begin
            AdjustOrdersForInsert(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, LOrder);
          end;
        end;
      end
      else
      begin
        // Título não mudou - segue lógica normal de atualização de ordem
        // Determina a ordem desejada
        LOrder := AParameter.Ordem;
        
        // Se ordem vazia (<= 0) e renumerar zero está habilitado, calcula automaticamente
        if (LOrder <= 0) and FAutoRenumberZeroOrder then
        begin
          LOrder := GetNextOrder(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID);
        end
        else if (LOrder <= 0) and not FAutoRenumberZeroOrder then
        begin
          // Mantém ordem 0 se renumerar zero estiver desabilitado
          LOrder := 0;
        end;
        
        // Se a ordem mudou e reordenação está habilitada, ajusta as ordens existentes
        if (LOrder <> LOldOrder) and FAutoReorderOnUpdate then
        begin
          AdjustOrdersForUpdate(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, LOldOrder, LOrder, AParameter.Name);
        end;
        // Se FAutoReorderOnUpdate = False, não ajusta (pode causar duplicação de ordens)
      end;
    finally
      LOldParameter.Free;
    end;
    
    // Tratamento específico por tipo de banco para timestamps
    if LDatabaseType = pdtAccess then
    begin
      // Access: usa NOW() para timestamps
      LSQL := Format(
        'UPDATE %s SET ' +
        'contrato_id = %d, ' +
        'produto_id = %d, ' +
        'ordem = %d, ' +
        'titulo = ''%s'', ' +
        'valor = ''%s'', ' +
        'descricao = ''%s'', ' +
        'ativo = %s, ' +
        'data_alteracao = NOW() ' +
        'WHERE chave = ''%s''',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo),
          EscapeSQL(AParameter.Name)
        ]
      );
    end
    else if LDatabaseType = pdtSQLServer then
    begin
      // SQL Server: usa GETDATE() que é mais compatível que CURRENT_TIMESTAMP
      LSQL := Format(
        'UPDATE %s SET ' +
        'contrato_id = %d, ' +
        'produto_id = %d, ' +
        'ordem = %d, ' +
        'titulo = ''%s'', ' +
        'valor = ''%s'', ' +
        'descricao = ''%s'', ' +
        'ativo = %s, ' +
        'data_alteracao = GETDATE() ' +
        'WHERE chave = ''%s''',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo),
          EscapeSQL(AParameter.Name)
        ]
      );
    end
    else
    begin
      // Outros bancos: usa CURRENT_TIMESTAMP
      LSQL := Format(
        'UPDATE %s SET ' +
        'contrato_id = %d, ' +
        'produto_id = %d, ' +
        'ordem = %d, ' +
        'titulo = ''%s'', ' +
        'valor = ''%s'', ' +
        'descricao = ''%s'', ' +
        'ativo = %s, ' +
        'data_alteracao = CURRENT_TIMESTAMP ' +
        'WHERE chave = ''%s''',
        [
          GetFullTableName,
          AParameter.ContratoID,
          AParameter.ProdutoID,
          LOrder,  // Usa a ordem calculada/ajustada
          EscapeSQL(AParameter.Titulo),
          EscapeSQL(AParameter.Value),
          EscapeSQL(AParameter.Description),
          BooleanToSQL(AParameter.Ativo),
          EscapeSQL(AParameter.Name)
        ]
      );
    end;
    
    ASuccess := ExecuteSQL(LSQL);
  except
    ASuccess := False;
  end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Delete(const AName: string): IParametersDatabase;
var
  LSuccess: Boolean;
begin
  Delete(AName, LSuccess);
  Result := Self;
end;

{ =============================================================================
  Delete - Remove (DELETE físico) um parâmetro do banco de dados
  
  Descrição:
  Remove permanentemente um parâmetro da tabela config usando DELETE físico.
  Se o parâmetro não existir, a operação falha silenciosamente (ASuccess = False).
  
  Comportamento:
  - Verifica se o parâmetro existe antes de deletar
  - Se não existir, retorna ASuccess = False sem deletar
  - Usa DELETE físico: remove o registro permanentemente da tabela
  - NÃO preserva histórico (diferente de soft delete)
  - Garante que a tabela existe antes de executar o DELETE
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AName: Nome/chave do parâmetro a ser removido
  - ASuccess: Indica se a remoção foi bem-sucedida
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersConnectionException: Se não estiver conectado
  - EParametersSQLException: Se houver erro na execução SQL
  - EParametersException: Outras exceções do sistema de parâmetros
  
  Nota:
  - O parâmetro é deletado permanentemente (não pode ser recuperado)
  - Se o parâmetro não existir, ASuccess será False mas não lança exceção
  
  Exemplo:
  var
    DB: IParametersDatabase;
    Success: Boolean;
  begin
    DB := TParameters.NewDatabase
      .TableName('config')
      .Connect;
    
    DB.Delete('erp_host', Success);
    if Success then
      ShowMessage('Parâmetro removido permanentemente!');
  end;
  ============================================================================= }
function TParametersDatabase.Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase;
var
  LSQL: string;
begin
  Result := Self;
  FLock.Enter;
  try
    // Garante que a tabela existe antes de fazer DELETE
    EnsureTableExists;
    
    ASuccess := False;
    try
    // DELETE físico no banco de dados
    // Remove o registro permanentemente da tabela
    LSQL := Format(
      'DELETE FROM %s WHERE chave = ''%s''',
      [GetFullTableName, EscapeSQL(AName)]
    );
    
      // Executa o DELETE físico
      // Se não lançar exceção, considera sucesso
      ExecuteSQL(LSQL);
      ASuccess := True;
    except
      on E: EParametersException do
      begin
        ASuccess := False;
        // Re-lança exceção do Parameters para permitir tratamento adequado
        raise;
      end;
      on E: Exception do
      begin
        ASuccess := False;
        // Converte exceção genérica para exceção do Parameters
        raise ConvertToParametersException(E, 'Delete');
      end;
    end; // Fecha o try interno (linha 4871)
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Exists(const AName: string): Boolean;
var
  LExists: Boolean;
begin
  Exists(AName, LExists);
  Result := LExists;
end;

function TParametersDatabase.Exists(const AName: string; out AExists: Boolean): IParametersDatabase;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  Result := Self;
  FLock.Enter;
  try
    // Garante que a tabela existe antes de fazer SELECT
    EnsureTableExists;
    
    AExists := False;
    try
    // IMPORTANTE: Não filtra por ativo - verifica TODOS os registros (ativos e inativos)
    // Isso permite detectar registros inativos e fazer UPDATE ao invés de INSERT
    LSQL := Format(
      'SELECT COUNT(*) as cnt FROM %s WHERE chave = ''%s''',
      [GetFullTableName, EscapeSQL(AName)]
    );
    
    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
          AExists := LDataSet.FieldByName('cnt').AsInteger > 0;
      finally
        LDataSet.Close;
      end;
    end;
    except
      AExists := False;
    end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Count: Integer;
var
  LCount: Integer;
begin
  Count(LCount);
  Result := LCount;
end;

function TParametersDatabase.Count(out ACount: Integer): IParametersDatabase;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  Result := Self;
  FLock.Enter;
  try
    // Garante que a tabela existe antes de fazer SELECT
    EnsureTableExists;
    
    ACount := 0;
    try
    LSQL := Format(
      'SELECT COUNT(*) as cnt FROM %s WHERE ativo = %s',
      [GetFullTableName, BooleanToSQLCondition(True)]
    );
    
    LDataSet := QuerySQL(LSQL);
    if Assigned(LDataSet) then
    begin
      try
        if not LDataSet.Eof then
          ACount := LDataSet.FieldByName('cnt').AsInteger;
      finally
        LDataSet.Close;
      end;
    end;
  except
    ACount := 0;
  end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.IsConnected: Boolean;
var
  LConnected: Boolean;
begin
  IsConnected(LConnected);
  Result := LConnected;
end;

function TParametersDatabase.IsConnected(out AConnected: Boolean): IParametersDatabase;
begin
  Result := Self;
  AConnected := IsConnectionConnected;
end;

function TParametersDatabase.Connect: IParametersDatabase;
begin
  try
    // Se não tem conexão, cria uma
    if not Assigned(FConnection) and FOwnConnection then
      CreateInternalConnection;
    
    if not Assigned(FConnection) then
    begin
      raise CreateConnectionException(MSG_CONNECTION_NOT_ASSIGNED, ERR_CONNECTION_NOT_ASSIGNED, 'Connect');
      Halt(ERR_CONNECTION_NOT_ASSIGNED); // Encerra aplicacao com codigo de erro
    end;
      
    ConnectConnection;
    Result := Self;
  except
    on E: EParametersConnectionException do
    begin
      // Loga o erro e encerra a aplicacao
      Writeln('ERRO FATAL DE CONEXAO: ', E.Message);
      Writeln('Codigo: ', E.ErrorCode);
      Writeln('Operacao: ', E.Operation);
      Halt(E.ErrorCode); // Encerra aplicacao com codigo de erro
    end;
    on E: EParametersException do
    begin
      Writeln('ERRO FATAL: ', E.Message);
      Halt(E.ErrorCode); // Encerra aplicacao com codigo de erro
    end;
    on E: Exception do
    begin
      Writeln('ERRO FATAL INESPERADO: ', E.Message);
      Halt(ERR_CONNECTION_FAILED); // Encerra aplicacao
    end;
  end;
end;

function TParametersDatabase.Connect(out ASuccess: Boolean): IParametersDatabase;
begin
  Result := Self;
  FLock.Enter;
  try
    ASuccess := False;
    try
      // Se não tem conexão, cria uma
      if not Assigned(FConnection) and FOwnConnection then
        CreateInternalConnection;
      
      if Assigned(FConnection) then
    begin
      try
        ConnectConnection;
        ASuccess := IsConnectionConnected;
      except
        on E: Exception do
        begin
          ASuccess := False;
          // Converte exceção genérica para exceção do Parameters
          raise ConvertToParametersException(E, 'Connect');
          // Não lança exceção nesta versão, apenas retorna False em ASuccess
        end;
      end;
    end;
  except
    ASuccess := False;
  end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Disconnect: IParametersDatabase;
begin
  Result := Self;
  FLock.Enter;
  try
    try
      if Assigned(FConnection) then
        DisconnectConnection;
    except
      // Ignorar erros ao desconectar
    end;
  finally
    FLock.Leave;
  end;
end;

function TParametersDatabase.Refresh: IParametersDatabase;
begin
  Result := Self;
  FLock.Enter;
  try
    try
      // Fecha queries abertas para forçar recarregamento
      if Assigned(FQuery) then
      begin
      try
        if FQuery.Active then
        begin
          {$IF DEFINED(USE_UNIDAC)}
            TUniQuery(FQuery).Close;
          {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                    TFDQuery(FQuery).Close;
                  {$ELSE} {$IF DEFINED(USE_ZEOS)}
                            TZQuery(FQuery).Close;
                          {$ELSE}
                            FQuery.Close;
                          {$ENDIF}
                  {$ENDIF}
          {$ENDIF}
        end;
      except
        // Ignorar erros ao fechar
      end;
    end;

    if Assigned(FExecQuery) then
    begin
      try
        if FExecQuery.Active then
        begin
          {$IF DEFINED(USE_UNIDAC)}
            TUniQuery(FExecQuery).Close;
          {$ELSE} {$IF DEFINED(USE_FIREDAC)}
                    TFDQuery(FExecQuery).Close;
                  {$ELSE} {$IF DEFINED(USE_ZEOS)}
                            TZQuery(FExecQuery).Close;
                          {$ELSE}
                            FQuery.Close;
                          {$ENDIF}
                  {$ENDIF}
          {$ENDIF}
        end;
      except
        // Ignorar erros ao fechar
      end;
    end;
    
    // Reconecta se necessário para garantir dados atualizados
    if Assigned(FConnection) then
    begin
      try
        // Se está desconectado, reconecta
        if not IsConnectionConnected then
          ConnectConnection
        else
        begin
          // Se está conectado, faz um "ping" reconectando
          // Isso força a atualização da conexão e garante dados frescos
          DisconnectConnection;
          ConnectConnection;
        end;
      except
        // Se falhar, tenta apenas conectar
        try
          ConnectConnection;
        except
          // Ignorar erros
        end;
      end;
    end;
    except
      // Ignorar erros no refresh
    end;
  finally
    FLock.Leave;
  end;
end;

{$IF DEFINED(FPC) AND DEFINED(WINDOWS)}
{ =============================================================================
  GetEnvironmentVariableValue - Função auxiliar para FPC
  =============================================================================
  No FPC, GetEnvironmentVariable da Windows API requer um buffer.
  Esta função wrapper simplifica o uso.
  ============================================================================= }

function GetEnvironmentVariableValue(const AName: string): string;
var
  LBuffer: array[0..32767] of Char;
  LSize: DWORD;
begin
  Result := '';
  LSize := Windows.GetEnvironmentVariable(PChar(AName), LBuffer, SizeOf(LBuffer));
  if LSize > 0 then
    Result := string(LBuffer);
end;
{$ENDIF}

{$IF DEFINED(USE_ZEOS)}
{ =============================================================================
  ConfigureZeosLibraryLocation - Configura LibraryLocation do Zeos
  ============================================================================= }

procedure TParametersDatabase.ConfigureZeosLibraryLocation(AConnection: TZConnection; ADatabaseType: TParameterDatabaseTypes);
var
  LDLLPath: string;
  LDLLDirectory: string;
begin
  if not Assigned(AConnection) then
    Exit;
  
  case ADatabaseType of
    pdtPostgreSQL:
    begin
      // PostgreSQL: configura LibraryLocation para libpq.dll
      {$IF DEFINED(WIN64)}
      LDLLPath := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib\libpq.dll';
      LDLLDirectory := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\PostgreSQL\lib';
      {$ELSE}
      LDLLPath := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib\libpq.dll';
      LDLLDirectory := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\PostgreSQL\lib';
      {$ENDIF}
      
      if FileExists(LDLLPath) then
      begin
        // Configura LibraryLocation com o caminho completo da DLL
        AConnection.LibraryLocation := LDLLPath;
        // Adiciona diretório ao PATH para dependências (LIBEAY32.dll, SSLEAY32.dll, etc.)
        {$IF DEFINED(WINDOWS)}
          {$IF DEFINED(FPC)}
          SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';' + LDLLDirectory));
          {$ELSE}
          SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';' + LDLLDirectory));
          {$ENDIF}
        {$ENDIF}
      end;
    end;
    pdtMySQL:
    begin
      // MySQL: configura LibraryLocation para libmysql.dll
      {$IF DEFINED(WIN64)}
      LDLLPath := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql\libmysql.dll';
      LDLLDirectory := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\MySql';
      {$ELSE}
      LDLLPath := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql\libmysql.dll';
      LDLLDirectory := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\MySql';
      {$ENDIF}
      
      if FileExists(LDLLPath) then
      begin
        // Configura LibraryLocation com o caminho completo da DLL
        AConnection.LibraryLocation := LDLLPath;
        // Adiciona diretório ao PATH para dependências
        {$IF DEFINED(WINDOWS)}
          {$IF DEFINED(FPC)}
          SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';' + LDLLDirectory));
          {$ELSE}
          SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';' + LDLLDirectory));
          {$ENDIF}
        {$ENDIF}
      end;
    end;
    pdtSQLServer:
    begin
      // SQL Server: configura LibraryLocation para libsybdb-5.dll (FreeTDS)
      {$IF DEFINED(WIN64)}
      LDLLPath := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\FreeTDS\libsybdb-5.dll';
      LDLLDirectory := 'E:\CSL\ProvidersORM.2.0.0\dll\win64\FreeTDS';
      {$ELSE}
      LDLLPath := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\FreeTDS\libsybdb-5.dll';
      LDLLDirectory := 'E:\CSL\ProvidersORM.2.0.0\dll\win32\FreeTDS';
      {$ENDIF}
      
      if FileExists(LDLLPath) then
      begin
        // Configura LibraryLocation com o caminho completo da DLL do FreeTDS
        AConnection.LibraryLocation := LDLLPath;
        // Adiciona diretório ao PATH para dependências (libssl-3.dll, libcrypto-3.dll, libiconv-2.dll)
        {$IF DEFINED(WINDOWS)}
          {$IF DEFINED(FPC)}
          SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariableValue('PATH') + ';' + LDLLDirectory));
          {$ELSE}
          SetEnvironmentVariable('PATH', PChar(GetEnvironmentVariable('PATH') + ';' + LDLLDirectory));
          {$ENDIF}
        {$ENDIF}
      end;
    end;
  end;
end;
{$ENDIF}

end.
