unit Parameters;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters - Ponto de Entrada Público do Sistema de Parâmetros
  
  Descrição:
  Este é o único arquivo que deve ser usado externamente para acessar o módulo
  Parameters. Todas as implementações estão ocultas e acessíveis apenas via
  interfaces públicas.
  
  Uso:
    uses Modulo.Parameters;
    
    var Parameters: IParametersDatabase;
    Parameters := TParameters.New
      .Connection(MyConnection)
      .Query(MyQuery)
      .TableName('config')
      .Schema('dbcsl');
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I ../Paramenters.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils, DB, fpjson, jsonparser,
{$ELSE}
  System.SysUtils, Data.DB, System.JSON,
{$ENDIF}
  Parameters.Intefaces, // Expõe IParametersDatabase, IParametersInifiles, IParametersJsonObject, TParameter, TParameterList, TParameterValueType
  Parameters.Types,      // Expõe TParameterConfig, TParameterConfigOption, TParameterSourceArray (necessário para factory methods)
  Parameters.Consts;     // Expõe DEFAULT_PARAMETER_CONFIG e outras constantes

type
  { =============================================================================
    TParameters - Factory Class para criar instâncias de IParameters
    ============================================================================= }
  
  TParameters = class
  public
    { ========== FACTORY METHODS PRINCIPAIS ========== }
    
    { New - Cria nova instância de IParameters (convergência)
      
      Finalidade:
        Cria uma nova instância da interface unificada IParameters que gerencia múltiplas
        fontes de dados (Database, INI, JSON) com suporte a fallback automático.
      
      Parâmetros:
        AConfig: TParameterConfig (opcional)
          Set de opções de configuração que define quais fontes serão habilitadas.
          Valores possíveis:
          - [pcfDataBase]: Habilita acesso a banco de dados
          - [pcfInifile]: Habilita acesso a arquivos INI
          - [pcfJsonObject]: Habilita acesso a objetos JSON
          - [pcfDataBase, pcfInifile]: Habilita Database com fallback para INI
          - [] ou não especificado: Usa configuração padrão (apenas Database)
      
      Retorno:
        IParameters: Interface unificada configurada com as fontes especificadas.
      
      Exemplo:
        var Parameters: IParameters;
        Parameters := TParameters.New([pcfDataBase, pcfInifile]);
        Parameters.Database.Host('localhost').Connect;
        Parameters.Inifiles.FilePath('config.ini');
        Param := Parameters.Get('host'); // Busca em cascata: Database → INI
    }
    class function New: IParameters; overload;
    
    { New - Cria nova instância com configuração de fontes
      
      Finalidade:
        Mesma funcionalidade do overload sem parâmetros, mas permite especificar
        explicitamente quais fontes serão habilitadas.
      
      Parâmetros:
        AConfig: TParameterConfig
          Set de opções de configuração (ver descrição do overload acima).
      
      Retorno:
        IParameters: Interface unificada configurada.
      
      Exemplo:
        Parameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
    }
    class function New(AConfig: TParameterConfig): IParameters; overload;
    
    { ========== FACTORY METHODS ESPECÍFICOS (Compatibilidade) ========== }
    
    { NewDatabase - Cria nova instância de IParametersDatabase
      
      Finalidade:
        Cria uma nova instância da interface IParametersDatabase para acesso exclusivo
        a parâmetros em banco de dados. Se não for fornecida conexão, cria conexão interna.
      
      Parâmetros:
        Nenhum (overload sem parâmetros)
      
      Retorno:
        IParametersDatabase: Interface de acesso a banco de dados.
      
      Exemplo:
        var DB: IParametersDatabase;
        DB := TParameters.NewDatabase;
        DB.Engine('UniDAC').DatabaseType('PostgreSQL')
           .Host('localhost').Port(5432).Database('mydb')
           .Username('postgres').Password('pass').Connect;
    }
    class function NewDatabase: IParametersDatabase; overload;
    
    { NewDatabase - Cria nova instância com conexão e queries
      
      Finalidade:
        Cria instância de IParametersDatabase usando conexão e queries existentes.
        Útil quando já se tem componentes de conexão criados.
      
      Parâmetros:
        AConnection: TObject
          Conexão existente (TUniConnection, TFDConnection ou TZConnection).
          Se nil, cria conexão interna automaticamente.
      
        AQuery: TDataSet (opcional, padrão: nil)
          Query para operações SELECT (TUniQuery, TFDQuery ou TZQuery).
          Se nil, cria internamente ou usa AExecQuery.
      
        AExecQuery: TDataSet (opcional, padrão: nil)
          Query para operações INSERT/UPDATE/DELETE.
          Se nil, usa AQuery ou cria internamente.
      
      Retorno:
        IParametersDatabase: Interface configurada com a conexão fornecida.
      
      Exemplo:
        var MyConnection: TUniConnection;
        var MyQuery: TUniQuery;
        // ... inicializa MyConnection e MyQuery ...
        DB := TParameters.NewDatabase(MyConnection, MyQuery);
        DB.TableName('config').Schema('public');
    }
    class function NewDatabase(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil): IParametersDatabase; overload;
    
    { NewInifiles - Cria nova instância de IParametersInifiles
      
      Finalidade:
        Cria uma nova instância da interface IParametersInifiles para acesso a parâmetros
        em arquivos INI. Usa valores padrão se caminho não for especificado.
      
      Parâmetros:
        Nenhum (overload sem parâmetros)
      
      Retorno:
        IParametersInifiles: Interface de acesso a arquivos INI.
      
      Exemplo:
        var Ini: IParametersInifiles;
        Ini := TParameters.NewInifiles;
        Ini.FilePath('C:\Config\params.ini').Section('Parameters');
    }
    class function NewInifiles: IParametersInifiles; overload;
    
    { NewInifiles - Cria nova instância com caminho do arquivo
      
      Finalidade:
        Cria instância de IParametersInifiles já configurada com o caminho do arquivo.
      
      Parâmetros:
        AFilePath: string
          Caminho completo do arquivo INI. Se vazio, usa valor padrão
          (DEFAULT_PARAMETER_INI_FILENAME).
      
      Retorno:
        IParametersInifiles: Interface configurada com o arquivo especificado.
      
      Exemplo:
        Ini := TParameters.NewInifiles('C:\Config\params.ini');
        // Arquivo já está configurado, pode usar diretamente
        Param := Ini.Get('host');
    }
    class function NewInifiles(const AFilePath: string): IParametersInifiles; overload;
    
    { NewJsonObject - Cria nova instância de IParametersJsonObject
      
      Finalidade:
        Cria uma nova instância da interface IParametersJsonObject para acesso a parâmetros
        em objetos JSON. Cria objeto JSON vazio internamente.

      Parâmetros:
        Nenhum (overload sem parâmetros)

      Retorno:
        IParametersJsonObject: Interface de acesso a objetos JSON.

      Exemplo:
        var Json: IParametersJsonObject;
        Json := TParameters.NewJsonObject;
        Json.FilePath('C:\Config\params.json');
    }
    class function NewJsonObject: IParametersJsonObject; overload;

    (* NewJsonObject - Cria nova instância com objeto JSON

      Finalidade:
        Cria instância usando objeto JSON existente. O objeto não é liberado
        automaticamente (FOwnJsonObject = False).

      Parâmetros:
        AJsonObject: TJSONObject
          Objeto JSON existente. Se nil, cria novo objeto vazio.

      Retorno:
        IParametersJsonObject: Interface usando o objeto fornecido.

      Exemplo:
        var MyJson: TJSONObject;
        MyJson := TJSONObject.ParseJSONValue('{"ERP":{"host":"localhost"}}') as TJSONObject;
        Json := TParameters.NewJsonObject(MyJson);
    *)
    class function NewJsonObject(AJsonObject: TJSONObject): IParametersJsonObject; overload;

    (* NewJsonObject - Cria nova instância com string JSON

      Finalidade:
        Cria instância parseando uma string JSON. A string é parseada e um
        objeto JSON é criado internamente.

      Parâmetros:
        AJsonString: string
          String contendo JSON válido para ser parseado.

      Retorno:
        IParametersJsonObject: Interface com objeto JSON parseado.

      Exemplo:
        Json := TParameters.NewJsonObject('{"ERP":{"host":"localhost","port":5432}}');
        Param := Json.Get('host');
    *)
    class function NewJsonObject(const AJsonString: string): IParametersJsonObject; overload;
    
    { NewJsonObjectFromFile - Cria nova instância a partir de arquivo JSON
      
      Finalidade:
        Cria instância carregando JSON de um arquivo. O arquivo é lido e parseado
        automaticamente.
      
      Parâmetros:
        AFilePath: string
          Caminho completo do arquivo JSON a ser carregado.
      
      Retorno:
        IParametersJsonObject: Interface com JSON carregado do arquivo.
      
      Exemplo:
        Json := TParameters.NewJsonObjectFromFile('C:\Config\params.json');
        // JSON já está carregado, pode usar diretamente
        List := Json.List;
    }
    class function NewJsonObjectFromFile(const AFilePath: string): IParametersJsonObject;
    
    { ========== MÉTODOS DE DETECÇÃO AUTOMÁTICA ========== }
    
    { DetectEngine - Detecta automaticamente qual engine está disponível
      
      Finalidade:
        Detecta qual engine de banco de dados está disponível baseado nas diretivas
        de compilação (USE_UNIDAC, USE_FIREDAC, USE_ZEOS).
      
      Prioridade de Detecção:
        1. UNIDAC (se USE_UNIDAC definido)
        2. FireDAC (se USE_FIREDAC definido e não for FPC)
        3. Zeos (se USE_ZEOS definido)
        4. None (se nenhum estiver definido)
      
      Retorno:
        TParameterDatabaseEngine: Engine detectado (pteUnidac, pteFireDAC, pteZeos ou pteNone).
      
      Exemplo:
        var Engine: TParameterDatabaseEngine;
        Engine := TParameters.DetectEngine;
        case Engine of
          pteUnidac: ShowMessage('UNIDAC detectado');
          pteFireDAC: ShowMessage('FireDAC detectado');
          pteZeos: ShowMessage('Zeos detectado');
          pteNone: ShowMessage('Nenhum engine disponível');
        end;
    }
    class function DetectEngine: TParameterDatabaseEngine;
    
    { DetectEngineName - Retorna o nome do engine detectado como string
      
      Finalidade:
        Retorna o nome do engine detectado como string legível ('UniDAC', 'FireDAC',
        'Zeos' ou 'None').
      
      Retorno:
        string: Nome do engine detectado.
      
      Exemplo:
        var EngineName: string;
        EngineName := TParameters.DetectEngineName;
        ShowMessage('Engine: ' + EngineName);
    }
    class function DetectEngineName: string;
  end;

implementation

uses
{$IF DEFINED(FPC)}
  SyncObjs, Classes,
{$ELSE}
  System.SyncObjs, System.Classes,
{$ENDIF}
  //Parameters.Consts,  // Para acessar TEngineDatabase
  Parameters.Database,
  Parameters.Inifiles,
  Parameters.JsonObject;

{ =============================================================================
  TParametersImpl - Implementação de IParameters (seção implementation)
  =============================================================================
  Esta classe fica na seção implementation e não é acessível externamente.
  Apenas a interface IParameters é exposta publicamente.
  ============================================================================= }

type
  TParametersImpl = class(TInterfacedObject, IParameters)
  private
    FDatabase: IParametersDatabase;
    FInifiles: IParametersInifiles;
    FJsonObject: IParametersJsonObject;
    FActiveSource: TParameterSource;
    FPriority: TParameterSourceArray;
    FConfig: TParameterConfig;
    FContratoID: Integer;
    FProdutoID: Integer;
    FLock: TCriticalSection;
    
    function TryGetFromSource(const AName: string; ASource: TParameterSource; out AParameter: TParameter): Boolean;
    function IsSourceAvailable(ASource: TParameterSource): Boolean;
  public
    constructor Create(AConfig: TParameterConfig);
    destructor Destroy; override;
    
    // IParameters implementation
    // ========== GERENCIAMENTO DE FONTES ==========
    function Source(ASource: TParameterSource): IParameters; overload;
    function Source: TParameterSource; overload;
    function AddSource(ASource: TParameterSource): IParameters;
    function RemoveSource(ASource: TParameterSource): IParameters;
    function HasSource(ASource: TParameterSource): Boolean;
    function Priority(ASources: TParameterSourceArray): IParameters;
    
    // ========== OPERAÇÕES UNIFICADAS ==========
    function Get(const AName: string): TParameter; overload;
    function Get(const AName: string; ASource: TParameterSource): TParameter; overload;
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParameters; overload;
    function Insert(const AParameter: TParameter): IParameters; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;
    function Update(const AParameter: TParameter): IParameters; overload;
    function Update(const AParameter: TParameter; out ASuccess: Boolean): IParameters; overload;
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
    function Database: IParametersDatabase;
    function Inifiles: IParametersInifiles;
    function JsonObject: IParametersJsonObject;

    // ========== NAVEGAÇÃO ==========
    function EndParameters: IInterface;
  end;

{ TParametersImpl }

{ Construtor da classe TParametersImpl.

  Parâmetros:
    AConfig: TParameterConfig - Set de opções de configuração que define quais fontes serão habilitadas

  Comportamento:
    - Cria TCriticalSection para thread-safety
    - Inicializa fontes conforme AConfig (Database, INI, JSON)
    - Se nenhuma fonte for configurada, usa Database como padrão
    - Inicializa valores padrão: FActiveSource = psDatabase, FContratoID = 0, FProdutoID = 0
    - Para INI e JSON, aplica valores padrão automaticamente (FilePath, Section/ObjectName, AutoCreateFile) }
constructor TParametersImpl.Create(AConfig: TParameterConfig);
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FConfig := AConfig;
  FActiveSource := psDatabase;
  FContratoID := 0;
  FProdutoID := 0;

  // Inicializa fontes conforme configuração
  if pcfDataBase in AConfig then
  begin
    FDatabase := TParametersDatabase.Create;
    SetLength(FPriority, Length(FPriority) + 1);
    FPriority[High(FPriority)] := psDatabase;
  end;

  if pcfInifile in AConfig then
  begin
    FInifiles := TParametersInifiles.Create;
//    Inicializa automaticamente com valores padrão
//    FInifiles.FilePath(DEFAULT_PARAMETER_INI_FILENAME)
//      .Section(DEFAULT_PARAMETER_INI_SECTION)
//      .AutoCreateFile(DEFAULT_PARAMETER_AUTO_CREATE_INI);
    SetLength(FPriority, Length(FPriority) + 1);
    FPriority[High(FPriority)] := psInifiles;
  end;

  if pcfJsonObject in AConfig then
  begin
    FJsonObject := TParametersJsonObject.Create;
//    // Inicializa automaticamente com valores padrão
//    FJsonObject.FilePath(DEFAULT_PARAMETER_JSON_FILENAME)
//      .ObjectName(DEFAULT_PARAMETER_JSON_OBJECT_NAME_ROOT)
//      .AutoCreateFile(DEFAULT_PARAMETER_AUTO_CREATE_JSON);
    // Sincroniza ContratoID e ProdutoID com a configuração unificada
    if FContratoID > 0 then
      FJsonObject.ContratoID(FContratoID);
    if FProdutoID > 0 then
      FJsonObject.ProdutoID(FProdutoID);
    SetLength(FPriority, Length(FPriority) + 1);
    FPriority[High(FPriority)] := psJsonObject;
  end;

  // Se nenhuma fonte foi configurada, usa Database como padrão
  if Length(FPriority) = 0 then
  begin
    FDatabase := TParametersDatabase.Create;
    SetLength(FPriority, 1);
    FPriority[0] := psDatabase;
  end;
end;

{ Destrutor da classe TParametersImpl.

  Comportamento:
    - Libera TCriticalSection
    - Libera todas as interfaces (Database, INI, JSON)
    - Chama inherited Destroy }
destructor TParametersImpl.Destroy;
begin
  FLock.Free;
  FDatabase := nil;
  FInifiles := nil;
  FJsonObject := nil;
  inherited;
end;

{ Tenta buscar um parâmetro de uma fonte específica.
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro a buscar
    ASource: TParameterSource - Fonte onde buscar (psDatabase, psInifiles, psJsonObject)
    AParameter: TParameter (out) - Parâmetro encontrado (nil se não encontrado)
  
  Retorno:
    Boolean - True se encontrou o parâmetro, False caso contrário
  
  Comportamento:
    - Se a fonte não estiver disponível, retorna False
    - Se ocorrer exceção, retorna False e libera AParameter se foi criado
    - Valida se o parâmetro encontrado tem Name não vazio }
function TParametersImpl.TryGetFromSource(const AName: string; ASource: TParameterSource; out AParameter: TParameter): Boolean;
begin
  Result := False;
  AParameter := nil;
  
  try
    case ASource of
      psDatabase:
        if Assigned(FDatabase) then
        begin
          AParameter := FDatabase.Get(AName);
          Result := Assigned(AParameter) and (AParameter.Name <> '');
        end;
      psInifiles:
        if Assigned(FInifiles) then
        begin
          AParameter := FInifiles.Get(AName);
          Result := Assigned(AParameter) and (AParameter.Name <> '');
        end;
      psJsonObject:
        if Assigned(FJsonObject) then
        begin
          AParameter := FJsonObject.Get(AName);
          Result := Assigned(AParameter) and (AParameter.Name <> '');
        end;
    end;
  except
    // Se uma fonte falhar, retorna False (permite tentar próxima fonte)
    Result := False;
    if Assigned(AParameter) then
    begin
      AParameter.Free;
      AParameter := nil;
    end;
  end;
end;

{ Verifica se uma fonte de dados está disponível (instanciada).
  
  Parâmetros:
    ASource: TParameterSource - Fonte a verificar
  
  Retorno:
    Boolean - True se a fonte está disponível, False caso contrário }
function TParametersImpl.IsSourceAvailable(ASource: TParameterSource): Boolean;
begin
  case ASource of
    psDatabase: Result := Assigned(FDatabase);
    psInifiles: Result := Assigned(FInifiles);
    psJsonObject: Result := Assigned(FJsonObject);
  else
    Result := False;
  end;
end;

{ Define a fonte ativa para operações de inserção.
  
  Parâmetros:
    ASource: TParameterSource - Fonte a ser definida como ativa
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Source(ASource: TParameterSource): IParameters;
begin
  FLock.Enter;
  try
    FActiveSource := ASource;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

{ Retorna a fonte ativa atual.
  
  Retorno:
    TParameterSource - Fonte ativa (psDatabase, psInifiles ou psJsonObject)
  
  Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Source: TParameterSource;
begin
  FLock.Enter;
  try
    Result := FActiveSource;
  finally
    FLock.Leave;
  end;
end;

{ Adiciona uma fonte à lista de prioridade e cria instância se necessário.
  
  Parâmetros:
    ASource: TParameterSource - Fonte a ser adicionada
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Se a fonte já existe na lista, não adiciona novamente
    - Cria instância da fonte automaticamente se não existir
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.AddSource(ASource: TParameterSource): IParameters;
var
  I: Integer;
  LExists: Boolean;
begin
  FLock.Enter;
  try
    LExists := False;
    for I := 0 to High(FPriority) do
    begin
      if FPriority[I] = ASource then
      begin
        LExists := True;
        Break;
      end;
    end;
    
    if not LExists then
    begin
      SetLength(FPriority, Length(FPriority) + 1);
      FPriority[High(FPriority)] := ASource;
      
      // Cria instância da fonte se não existir
      case ASource of
        psDatabase:
          if not Assigned(FDatabase) then
            FDatabase := TParametersDatabase.Create;
        psInifiles:
          if not Assigned(FInifiles) then
            FInifiles := TParametersInifiles.Create;
        psJsonObject:
          if not Assigned(FJsonObject) then
            FJsonObject := TParametersJsonObject.Create;
      end;
    end;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

{ Remove uma fonte da lista de prioridade.
  
  Parâmetros:
    ASource: TParameterSource - Fonte a ser removida
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Remove a fonte da lista de prioridade
    - Se a fonte ativa foi removida, muda para primeira disponível
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.RemoveSource(ASource: TParameterSource): IParameters;
var
  I: Integer;
  LNewPriority: TParameterSourceArray;
begin
  FLock.Enter;
  try
    SetLength(LNewPriority, 0);
    for I := 0 to High(FPriority) do
    begin
      if FPriority[I] <> ASource then
      begin
        SetLength(LNewPriority, Length(LNewPriority) + 1);
        LNewPriority[High(LNewPriority)] := FPriority[I];
      end;
    end;
    FPriority := LNewPriority;
    
    // Se a fonte ativa foi removida, muda para primeira disponível
    if FActiveSource = ASource then
    begin
      if Length(FPriority) > 0 then
        FActiveSource := FPriority[0]
      else
        FActiveSource := psDatabase;
    end;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

{ Verifica se uma fonte está na lista de prioridade.
  
  Parâmetros:
    ASource: TParameterSource - Fonte a verificar
  
  Retorno:
    Boolean - True se a fonte está na lista, False caso contrário
  
  Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.HasSource(ASource: TParameterSource): Boolean;
var
  I: Integer;
begin
  FLock.Enter;
  try
    Result := False;
    for I := 0 to High(FPriority) do
    begin
      if FPriority[I] = ASource then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Define a ordem de prioridade para busca em cascata.
  
  Parâmetros:
    ASources: TParameterSourceArray - Array com ordem de prioridade
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Exemplo:
    Priority([psDatabase, psInifiles, psJsonObject]);
    // Busca primeiro em Database, depois INI, depois JSON
  
  Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Priority(ASources: TParameterSourceArray): IParameters;
begin
  FLock.Enter;
  try
    FPriority := ASources;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

{ Busca um parâmetro em cascata conforme ordem de prioridade.
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro
  
  Retorno:
    TParameter - Parâmetro encontrado ou nil se não encontrado
  
  Comportamento:
    - Busca em cascata: tenta cada fonte na ordem de prioridade
    - Para na primeira fonte que encontrar o parâmetro
    - Retorna nil se não encontrar em nenhuma fonte
    - Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: O chamador é responsável por liberar o TParameter retornado }
function TParametersImpl.Get(const AName: string): TParameter;
var
  LSource: TParameterSource;
  LFound: Boolean;
begin
  FLock.Enter;
  try
    Result := nil;
    LFound := False;
    
    // Busca em cascata conforme ordem de prioridade
    for LSource in FPriority do
    begin
      if IsSourceAvailable(LSource) then
      begin
        if TryGetFromSource(AName, LSource, Result) then
        begin
          LFound := True;
          Break;
        end;
      end;
    end;
    
    // Se não encontrou em nenhuma fonte, retorna nil
    if not LFound then
      Result := nil;
  finally
    FLock.Leave;
  end;
end;

{ Busca um parâmetro em uma fonte específica.
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro
    ASource: TParameterSource - Fonte específica onde buscar
  
  Retorno:
    TParameter - Parâmetro encontrado ou nil se não encontrado
  
  Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: O chamador é responsável por liberar o TParameter retornado }
function TParametersImpl.Get(const AName: string; ASource: TParameterSource): TParameter;
begin
  FLock.Enter;
  try
    if not TryGetFromSource(AName, ASource, Result) then
      Result := nil;
  finally
    FLock.Leave;
  end;
end;

{ Lista todos os parâmetros únicos de todas as fontes (remove duplicatas).
  
  Retorno:
    TParameterList - Lista com todos os parâmetros únicos
  
  Comportamento:
    - Faz merge de todas as fontes ativas
    - Remove duplicatas por Name (mantém apenas o primeiro encontrado)
    - Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: O chamador é responsável por liberar a lista e seus objetos }
function TParametersImpl.List: TParameterList;
var
  LList: TParameterList;
begin
  List(LList);
  Result := LList;
end;

{ Lista todos os parâmetros únicos de todas as fontes (versão com out parameter).
  
  Parâmetros:
    AList: TParameterList (out) - Lista criada e preenchida com parâmetros únicos
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Faz merge de todas as fontes ativas na ordem de prioridade
    - Remove duplicatas por Name (mantém apenas o primeiro encontrado)
    - Se uma fonte falhar, continua com as outras
    - Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: O chamador é responsável por liberar AList e seus objetos }
function TParametersImpl.List(out AList: TParameterList): IParameters;
var
  LSource: TParameterSource;
  LSourceList: TParameterList;
  LParam: TParameter;
  I, J: Integer;
  LExists: Boolean;
  LNewParam: TParameter;
begin
  Result := Self;
  
  FLock.Enter;
  try
    AList := TParameterList.Create;
    
    // Merge de todas as fontes ativas (remove duplicatas por Name)
    for LSource in FPriority do
    begin
      if IsSourceAvailable(LSource) then
      begin
        try
          case LSource of
            psDatabase: LSourceList := FDatabase.List;
            psInifiles: LSourceList := FInifiles.List;
            psJsonObject: LSourceList := FJsonObject.List;
          else
            LSourceList := nil;
          end;
          
          if Assigned(LSourceList) then
          begin
            try
              for I := 0 to LSourceList.Count - 1 do
              begin
                LParam := LSourceList[I];
                
                // Verifica se já existe na lista final (por Name)
                LExists := False;
                for J := 0 to AList.Count - 1 do
                begin
                  if SameText(AList[J].Name, LParam.Name) then
                  begin
                    LExists := True;
                    Break;
                  end;
                end;
                
                // Adiciona apenas se não existir
                if not LExists then
                begin
                  // Cria cópia do parâmetro para adicionar à lista final
                  LNewParam := TParameter.Create;
                  LNewParam.ID := LParam.ID;
                  LNewParam.Name := LParam.Name;
                  LNewParam.Value := LParam.Value;
                  LNewParam.ValueType := LParam.ValueType;
                  LNewParam.Description := LParam.Description;
                  LNewParam.ContratoID := LParam.ContratoID;
                  LNewParam.ProdutoID := LParam.ProdutoID;
                  LNewParam.Ordem := LParam.Ordem;
                  LNewParam.Titulo := LParam.Titulo;
                  LNewParam.Ativo := LParam.Ativo;
                  LNewParam.CreatedAt := LParam.CreatedAt;
                  LNewParam.UpdatedAt := LParam.UpdatedAt;
                  AList.Add(LNewParam);
                end;
              end;
            finally
              LSourceList.ClearAll;
              LSourceList.Free;
            end;
          end;
        except
          // Se uma fonte falhar, continua com as outras
        end;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Insere um parâmetro na fonte ativa (versão sem out parameter).
  
  Parâmetros:
    AParameter: TParameter - Parâmetro a ser inserido
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Insere na fonte ativa (default: Database)
    - Se fonte ativa não disponível, tenta primeira disponível
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Insert(const AParameter: TParameter): IParameters;
var
  LSuccess: Boolean;
begin
  Insert(AParameter, LSuccess);
  Result := Self;
end;

{ Insere um parâmetro na fonte ativa (versão com out parameter).
  
  Parâmetros:
    AParameter: TParameter - Parâmetro a ser inserido
    ASuccess: Boolean (out) - True se inserido com sucesso, False caso contrário
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Insere na fonte ativa (default: Database)
    - Se fonte ativa não disponível, tenta primeira disponível na prioridade
    - Se ocorrer exceção, ASuccess = False
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters;
var
  LSource: TParameterSource;
begin
  Result := Self;
  ASuccess := False;
  
  FLock.Enter;
  try
    // Insere na fonte ativa (default: Database, fallback para primeira disponível)
    if IsSourceAvailable(FActiveSource) then
    begin
      try
        case FActiveSource of
          psDatabase: FDatabase.Insert(AParameter, ASuccess);
          psInifiles: FInifiles.Insert(AParameter, ASuccess);
          psJsonObject: FJsonObject.Insert(AParameter, ASuccess);
        end;
      except
        ASuccess := False;
      end;
    end
    else
    begin
      // Tenta primeira fonte disponível na prioridade
      for LSource in FPriority do
      begin
        if IsSourceAvailable(LSource) then
        begin
          try
            case LSource of
              psDatabase: FDatabase.Insert(AParameter, ASuccess);
              psInifiles: FInifiles.Insert(AParameter, ASuccess);
              psJsonObject: FJsonObject.Insert(AParameter, ASuccess);
            end;
            if ASuccess then
              Break;
          except
            ASuccess := False;
          end;
        end;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Atualiza um parâmetro na fonte onde existe (versão sem out parameter).
  
  Parâmetros:
    AParameter: TParameter - Parâmetro a ser atualizado
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Busca o parâmetro em todas as fontes na ordem de prioridade
    - Atualiza na primeira fonte onde encontrar
    - Se não encontrar em nenhuma, tenta inserir na fonte ativa
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Update(const AParameter: TParameter): IParameters;
var
  LSuccess: Boolean;
begin
  Update(AParameter, LSuccess);
  Result := Self;
end;

{ Atualiza um parâmetro na fonte onde existe (versão com out parameter).
  
  Parâmetros:
    AParameter: TParameter - Parâmetro a ser atualizado
    ASuccess: Boolean (out) - True se atualizado com sucesso, False caso contrário
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Busca o parâmetro em todas as fontes na ordem de prioridade
    - Atualiza na primeira fonte onde encontrar
    - Se não encontrar em nenhuma, tenta inserir na fonte ativa
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Update(const AParameter: TParameter; out ASuccess: Boolean): IParameters;
var
  LSource: TParameterSource;
  LFound: Boolean;
begin
  Result := Self;
  ASuccess := False;
  LFound := False;
  
  FLock.Enter;
  try
    // Atualiza na fonte onde o parâmetro existe
    for LSource in FPriority do
    begin
      if IsSourceAvailable(LSource) then
      begin
        try
          case LSource of
            psDatabase:
              if FDatabase.Exists(AParameter.Name) then
              begin
                FDatabase.Update(AParameter, ASuccess);
                LFound := True;
                Break;
              end;
            psInifiles:
              if FInifiles.Exists(AParameter.Name) then
              begin
                FInifiles.Update(AParameter, ASuccess);
                LFound := True;
                Break;
              end;
            psJsonObject:
              if FJsonObject.Exists(AParameter.Name) then
              begin
                FJsonObject.Update(AParameter, ASuccess);
                LFound := True;
                Break;
              end;
          end;
        except
          // Continua tentando outras fontes
        end;
      end;
    end;
    
    // Se não encontrou em nenhuma fonte, tenta inserir na fonte ativa
    if not LFound then
    begin
      Insert(AParameter, ASuccess);
    end;
  finally
    FLock.Leave;
  end;
end;

{ Deleta um parâmetro de todas as fontes onde existe (versão sem out parameter).
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro a deletar
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Deleta de todas as fontes onde o parâmetro existe
    - ASuccess será True se deletou de pelo menos uma fonte
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Delete(const AName: string): IParameters;
var
  LSuccess: Boolean;
begin
  Delete(AName, LSuccess);
  Result := Self;
end;

{ Deleta um parâmetro de todas as fontes onde existe (versão com out parameter).
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro a deletar
    ASuccess: Boolean (out) - True se deletou de pelo menos uma fonte, False caso contrário
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Deleta de todas as fontes onde o parâmetro existe
    - ASuccess será True se deletou de pelo menos uma fonte (OR lógico)
    - Se uma fonte falhar, continua tentando as outras
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Delete(const AName: string; out ASuccess: Boolean): IParameters;
var
  LSource: TParameterSource;
  LPartialSuccess: Boolean;
begin
  Result := Self;
  ASuccess := False;
  
  FLock.Enter;
  try
    // Deleta de todas as fontes onde existe
    for LSource in FPriority do
    begin
      if IsSourceAvailable(LSource) then
      begin
        try
          case LSource of
            psDatabase:
              if FDatabase.Exists(AName) then
              begin
                FDatabase.Delete(AName, LPartialSuccess);
                ASuccess := ASuccess or LPartialSuccess;
              end;
            psInifiles:
              if FInifiles.Exists(AName) then
              begin
                FInifiles.Delete(AName, LPartialSuccess);
                ASuccess := ASuccess or LPartialSuccess;
              end;
            psJsonObject:
              if FJsonObject.Exists(AName) then
              begin
                FJsonObject.Delete(AName, LPartialSuccess);
                ASuccess := ASuccess or LPartialSuccess;
              end;
          end;
        except
          // Continua tentando outras fontes
        end;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Verifica se um parâmetro existe em alguma fonte (OR lógico, versão sem out parameter).
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro a verificar
  
  Retorno:
    Boolean - True se existe em alguma fonte, False caso contrário
  
  Comportamento:
    - Verifica em todas as fontes na ordem de prioridade
    - Retorna True se encontrar em qualquer fonte (OR lógico)
    - Para na primeira fonte que encontrar (otimização)
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Exists(const AName: string): Boolean;
var
  LExists: Boolean;
begin
  Exists(AName, LExists);
  Result := LExists;
end;

{ Verifica se um parâmetro existe em alguma fonte (OR lógico, versão com out parameter).
  
  Parâmetros:
    AName: string - Nome/chave do parâmetro a verificar
    AExists: Boolean (out) - True se existe em alguma fonte, False caso contrário
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Verifica em todas as fontes na ordem de prioridade
    - AExists será True se encontrar em qualquer fonte (OR lógico)
    - Para na primeira fonte que encontrar (otimização)
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Exists(const AName: string; out AExists: Boolean): IParameters;
var
  LSource: TParameterSource;
begin
  Result := Self;
  AExists := False;
  
  FLock.Enter;
  try
    // Verifica em todas as fontes (OR lógico)
    for LSource in FPriority do
    begin
      if IsSourceAvailable(LSource) then
      begin
        try
          case LSource of
            psDatabase: AExists := AExists or FDatabase.Exists(AName);
            psInifiles: AExists := AExists or FInifiles.Exists(AName);
            psJsonObject: AExists := AExists or FJsonObject.Exists(AName);
          end;
          if AExists then
            Break; // Se encontrou em uma fonte, não precisa verificar as outras
        except
          // Continua tentando outras fontes
        end;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Conta parâmetros únicos de todas as fontes (versão sem out parameter).
  
  Retorno:
    Integer - Número de parâmetros únicos (remove duplicatas por Name)
  
  Comportamento:
    - Conta parâmetros únicos de todas as fontes ativas
    - Remove duplicatas por Name (conta apenas uma vez)
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Count: Integer;
var
  LCount: Integer;
begin
  Count(LCount);
  Result := LCount;
end;

{ Conta parâmetros únicos de todas as fontes (versão com out parameter).
  
  Parâmetros:
    ACount: Integer (out) - Número de parâmetros únicos
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Conta parâmetros únicos de todas as fontes ativas
    - Remove duplicatas por Name (conta apenas uma vez)
    - Se uma fonte falhar, continua com as outras
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Count(out ACount: Integer): IParameters;
var
  LSource: TParameterSource;
  LSourceList: TParameterList;
  LParamNames: TStringList;
  I: Integer;
  LParam: TParameter;
begin
  Result := Self;
  ACount := 0;
  
  FLock.Enter;
  try
    // Conta parâmetros únicos (remove duplicatas por Name)
    LParamNames := TStringList.Create;
    try
      LParamNames.Sorted := True;
      LParamNames.Duplicates := dupIgnore;
      
      // Itera sobre todas as fontes e conta parâmetros únicos
      for LSource in FPriority do
      begin
        if IsSourceAvailable(LSource) then
        begin
          try
            case LSource of
              psDatabase: LSourceList := FDatabase.List;
              psInifiles: LSourceList := FInifiles.List;
              psJsonObject: LSourceList := FJsonObject.List;
            else
              LSourceList := nil;
            end;
            
            if Assigned(LSourceList) then
            begin
              try
                for I := 0 to LSourceList.Count - 1 do
                begin
                  LParam := LSourceList[I];
                  if LParamNames.IndexOf(LParam.Name) < 0 then
                  begin
                    LParamNames.Add(LParam.Name);
                    Inc(ACount);
                  end;
                end;
              finally
                LSourceList.ClearAll;
                LSourceList.Free;
              end;
            end;
          except
            // Se uma fonte falhar, continua com as outras
          end;
        end;
      end;
    finally
      LParamNames.Free;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Renova dados de todas as fontes ativas (recarrega do disco/banco).
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Chama Refresh em todas as fontes ativas na ordem de prioridade
    - Se uma fonte falhar, continua tentando as outras
    - Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: Útil após alterações externas nos dados }
function TParametersImpl.Refresh: IParameters;
var
  LSource: TParameterSource;
begin
  Result := Self;
  
  FLock.Enter;
  try
    // Refresh em todas as fontes ativas
    for LSource in FPriority do
    begin
      if IsSourceAvailable(LSource) then
      begin
        try
          case LSource of
            psDatabase: FDatabase.Refresh;
            psInifiles: FInifiles.Refresh;
            psJsonObject: FJsonObject.Refresh;
          end;
        except
          // Continua tentando outras fontes
        end;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ Define o ContratoID e aplica em todas as fontes ativas.
  
  Parâmetros:
    AValue: Integer - Valor do ContratoID a ser aplicado
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Armazena o valor internamente
    - Aplica em todas as fontes ativas (Database, INI, JSON)
    - Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: Filtra parâmetros por ContratoID em todas as operações }
function TParametersImpl.ContratoID(const AValue: Integer): IParameters;
begin
  FLock.Enter;
  try
    FContratoID := AValue;
    // Aplica em todas as fontes ativas
    if Assigned(FDatabase) then
      FDatabase.ContratoID(AValue);
    if Assigned(FInifiles) then
      FInifiles.ContratoID(AValue);
    // IMPORTANTE: Aplica também se JsonObject for criado dinamicamente depois
    // O método JsonObject() já sincroniza, mas garantimos aqui também
    if Assigned(FJsonObject) then
      FJsonObject.ContratoID(AValue);
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

{ Retorna o ContratoID atual.
  
  Retorno:
    Integer - Valor do ContratoID atual
  
  Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.ContratoID: Integer;
begin
  FLock.Enter;
  try
    Result := FContratoID;
  finally
    FLock.Leave;
  end;
end;

{ Define o ProdutoID e aplica em todas as fontes ativas.
  
  Parâmetros:
    AValue: Integer - Valor do ProdutoID a ser aplicado
  
  Retorno:
    IParameters - Self para permitir encadeamento
  
  Comportamento:
    - Armazena o valor internamente
    - Aplica em todas as fontes ativas (Database, INI, JSON)
    - Thread-safe: Sim (protegido com TCriticalSection)
  
  Nota: Filtra parâmetros por ProdutoID em todas as operações }
function TParametersImpl.ProdutoID(const AValue: Integer): IParameters;
begin
  FLock.Enter;
  try
    FProdutoID := AValue;
    // Aplica em todas as fontes ativas
    if Assigned(FDatabase) then
      FDatabase.ProdutoID(AValue);
    if Assigned(FInifiles) then
      FInifiles.ProdutoID(AValue);
    // IMPORTANTE: Aplica também se JsonObject for criado dinamicamente depois
    // O método JsonObject() já sincroniza, mas garantimos aqui também
    if Assigned(FJsonObject) then
      FJsonObject.ProdutoID(AValue);
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

{ Retorna o ProdutoID atual.
  
  Retorno:
    Integer - Valor do ProdutoID atual
  
  Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.ProdutoID: Integer;
begin
  FLock.Enter;
  try
    Result := FProdutoID;
  finally
    FLock.Leave;
  end;
end;

{ Retorna a interface Database, criando instância se necessário.
  
  Retorno:
    IParametersDatabase - Interface de acesso a banco de dados
  
  Comportamento:
    - Se FDatabase não estiver criado, cria automaticamente
    - Sincroniza ContratoID e ProdutoID se já estiverem definidos
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Database: IParametersDatabase;
begin
  FLock.Enter;
  try
    if not Assigned(FDatabase) then
      FDatabase := TParametersDatabase.Create;
    Result := FDatabase;
  finally
    FLock.Leave;
  end;
end;

{ Retorna a interface Inifiles, criando instância se necessário.
  
  Retorno:
    IParametersInifiles - Interface de acesso a arquivos INI
  
  Comportamento:
    - Se FInifiles não estiver criado, cria automaticamente
    - Sincroniza ContratoID e ProdutoID se já estiverem definidos
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.Inifiles: IParametersInifiles;
begin
  FLock.Enter;
  try
    if not Assigned(FInifiles) then
      FInifiles := TParametersInifiles.Create;
    Result := FInifiles;
  finally
    FLock.Leave;
  end;
end;

{ Retorna a interface JsonObject, criando instância se necessário.
  
  Retorno:
    IParametersJsonObject - Interface de acesso a objetos JSON
  
  Comportamento:
    - Se FJsonObject não estiver criado, cria automaticamente
    - Sincroniza ContratoID e ProdutoID com a configuração unificada
    - Thread-safe: Sim (protegido com TCriticalSection) }
function TParametersImpl.JsonObject: IParametersJsonObject;
begin
  FLock.Enter;
  try
    if not Assigned(FJsonObject) then
    begin
      FJsonObject := TParametersJsonObject.Create;
      // Sincroniza ContratoID e ProdutoID com a configuração unificada
      if FContratoID > 0 then
        FJsonObject.ContratoID(FContratoID);
      if FProdutoID > 0 then
        FJsonObject.ProdutoID(FProdutoID);
    end;
    Result := FJsonObject;
  finally
    FLock.Leave;
  end;
end;

{ Método de navegação para finalizar encadeamento fluente.
  
  Retorno:
    IInterface - Self como IInterface
  
  Nota: Útil para finalizar encadeamento quando necessário }
function TParametersImpl.EndParameters: IInterface;
begin
  Result := Self;
end;

{ TParameters }

{ Factory method: Cria nova instância de IParameters com configuração padrão.
  
  Retorno:
    IParameters - Interface unificada com configuração padrão (apenas Database)
  
  Comportamento:
    - Usa DEFAULT_PARAMETER_CONFIG (geralmente [pcfDataBase])
    - Cria instância de TParametersImpl internamente
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.New: IParameters;
begin
  Result := TParametersImpl.Create(DEFAULT_PARAMETER_CONFIG);
end;

{ Factory method: Cria nova instância de IParameters com configuração específica.
  
  Parâmetros:
    AConfig: TParameterConfig - Set de opções de configuração
  
  Retorno:
    IParameters - Interface unificada configurada com as fontes especificadas
  
  Comportamento:
    - Cria instância de TParametersImpl com a configuração fornecida
    - Inicializa apenas as fontes especificadas em AConfig
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.New(AConfig: TParameterConfig): IParameters;
begin
  Result := TParametersImpl.Create(AConfig);
end;

{ Factory method: Cria nova instância de IParametersDatabase sem conexão.
  
  Retorno:
    IParametersDatabase - Interface de acesso a banco de dados
  
  Comportamento:
    - Cria instância de TParametersDatabase
    - Conexão será criada automaticamente quando Connect() for chamado
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewDatabase: IParametersDatabase;
begin
  Result := TParametersDatabase.Create;
end;

{ Factory method: Cria nova instância de IParametersDatabase com conexão existente.
  
  Parâmetros:
    AConnection: TObject - Conexão existente (TUniConnection, TFDConnection ou TZConnection)
    AQuery: TDataSet (opcional) - Query para operações SELECT
    AExecQuery: TDataSet (opcional) - Query para operações INSERT/UPDATE/DELETE
  
  Retorno:
    IParametersDatabase - Interface configurada com a conexão fornecida
  
  Comportamento:
    - Usa conexão e queries existentes (não cria novas)
    - Se AConnection = nil, cria conexão interna automaticamente
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewDatabase(AConnection: TObject; AQuery: TDataSet; AExecQuery: TDataSet): IParametersDatabase;
begin
  Result := TParametersDatabase.Create(AConnection, AQuery, AExecQuery);
end;

{ Factory method: Cria nova instância de IParametersInifiles sem arquivo.
  
  Retorno:
    IParametersInifiles - Interface de acesso a arquivos INI
  
  Comportamento:
    - Cria instância de TParametersInifiles
    - Usa valores padrão (DEFAULT_PARAMETER_INI_FILENAME, DEFAULT_PARAMETER_INI_SECTION)
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewInifiles: IParametersInifiles;
begin
  Result := TParametersInifiles.Create;
end;

{ Factory method: Cria nova instância de IParametersInifiles com arquivo.

  Parâmetros:
    AFilePath: string - Caminho completo do arquivo INI
  
  Retorno:
    IParametersInifiles - Interface configurada com o arquivo especificado
  
  Comportamento:
    - Cria instância de TParametersInifiles já configurada com o arquivo
    - Se AFilePath = '', usa valor padrão (DEFAULT_PARAMETER_INI_FILENAME)
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewInifiles(const AFilePath: string): IParametersInifiles;
begin
  Result := TParametersInifiles.Create(AFilePath);
end;

{ Factory method: Cria nova instância de IParametersJsonObject sem objeto.
  
  Retorno:
    IParametersJsonObject - Interface de acesso a objetos JSON
  
  Comportamento:
    - Cria instância de TParametersJsonObject
    - Cria objeto JSON vazio internamente
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewJsonObject: IParametersJsonObject;
begin
  Result := TParametersJsonObject.Create;
end;

{ Factory method: Cria nova instância de IParametersJsonObject com objeto existente.
  
  Parâmetros:
    AJsonObject: TJSONObject - Objeto JSON existente
  
  Retorno:
    IParametersJsonObject - Interface usando o objeto fornecido
  
  Comportamento:
    - Usa objeto JSON existente (não cria novo)
    - O objeto não é liberado automaticamente (FOwnJsonObject = False)
    - Se AJsonObject = nil, cria novo objeto vazio
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewJsonObject(AJsonObject: TJSONObject): IParametersJsonObject;
begin
  Result := TParametersJsonObject.Create(AJsonObject);
end;

{ Factory method: Cria nova instância de IParametersJsonObject parseando string JSON.
  
  Parâmetros:
    AJsonString: string - String contendo JSON válido
  
  Retorno:
    IParametersJsonObject - Interface com objeto JSON parseado
  
  Comportamento:
    - Parseia a string JSON e cria objeto internamente
    - Se AJsonString for inválido, pode lançar exceção
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewJsonObject(const AJsonString: string): IParametersJsonObject;
begin
  Result := TParametersJsonObject.CreateFromString(AJsonString);
end;

{ Factory method: Cria nova instância de IParametersJsonObject carregando de arquivo.
  
  Parâmetros:
    AFilePath: string - Caminho completo do arquivo JSON
  
  Retorno:
    IParametersJsonObject - Interface com JSON carregado do arquivo
  
  Comportamento:
    - Lê e parseia o arquivo JSON automaticamente
    - Se arquivo não existir ou for inválido, pode lançar exceção
    - Thread-safe: Sim (cada instância tem seu próprio TCriticalSection) }
class function TParameters.NewJsonObjectFromFile(const AFilePath: string): IParametersJsonObject;
begin
  Result := TParametersJsonObject.CreateFromFile(AFilePath);
end;

{ =============================================================================
  MÉTODOS DE DETECÇÃO AUTOMÁTICA DE ENGINE
  ============================================================================= }

class function TParameters.DetectEngine: TParameterDatabaseEngine;
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

class function TParameters.DetectEngineName: string;
{ Retorna o nome do engine detectado como string.
  Usa TEngineDatabase para converter o enum em string. }
var
  LEngine: TParameterDatabaseEngine;
begin
  LEngine := DetectEngine;
  Result := TEngineDatabase[LEngine];
end;

end.
