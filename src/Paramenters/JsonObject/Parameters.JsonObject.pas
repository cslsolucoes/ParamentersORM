unit Parameters.JsonObject;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Parameters.JsonObject - Implementação de Acesso a Parâmetros em Objetos JSON
  
  Descrição:
  Implementa IParametersJsonObject para acesso a parâmetros em objetos JSON.
  Suporta importação/exportação bidirecional com Database.
  
  Formato JSON:
  - Título = Nome do objeto JSON (seção)
  - Chave e valor = propriedades dentro do objeto
  - Contrato e produto = objeto separado "Contrato"
  - Ordem = sequência de colocação (mantida pela ordem das chaves)
  
  Estrutura JSON:
  - Objeto "Contrato" contém Contrato_ID e Produto_ID
  - Cada título (ex: "ERP") é um objeto JSON
  - Cada chave dentro do título é um objeto com: valor, descricao, ativo, ordem
  
  Encoding:
  - Leitura: Suporta UTF-8 (com/sem BOM) e ANSI (fallback)
  - Escrita: Sempre UTF-8 sem BOM
  - Simplificado para facilitar manutenção e compatibilidade
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I E:\CSL\ORM\src\Paramenters\src\Paramenters.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils, Classes, fpjson, jsonparser, SyncObjs, StrUtils,
{$ELSE}
  System.SysUtils, System.Classes, System.JSON,
  System.IOUtils,System.SyncObjs, System.StrUtils,
{$ENDIF}
  Parameters.Interfaces, Parameters.Types, Parameters.Consts,
  Parameters.Exceptions;

type
  { =============================================================================
    Tipos condicionais para compatibilidade FPC/Delphi
    ============================================================================= }
  {$IF DEFINED(FPC)}
  TJSONValue = TJSONData;  // No FPC, TJSONData é o tipo base
  TJSONNumber = TJSONIntegerNumber;  // No FPC, TJSONNumber é abstrata, usar TJSONIntegerNumber
  TJSONBool = TJSONBoolean;  // No FPC, TJSONBool não existe, usar TJSONBoolean
  {$ENDIF}

  { =============================================================================
    TParametersJsonObject - Implementação de IParametersJsonObject
    ============================================================================= }
  
  TParametersJsonObject = class(TInterfacedObject, IParametersJsonObject)
  private
    FJsonObject: TJSONObject;
    FObjectName: string;
    FFilePath: string;
    FAutoCreateFile: Boolean;
    FContratoID: Integer;
    FProdutoID: Integer;
    FLock: TCriticalSection;
    FOwnJsonObject: Boolean;
    
    // Métodos auxiliares privados
    function EnsureJsonObject: Boolean;
    function EnsureFile: Boolean;
    function GetObjectName(const ATitulo: string): string;
    function GetTituloFromObjectName(const AObjectName: string): string;
    function ExistsInObject(const AName, AObjectName: string): Boolean; // Verifica se chave existe no objeto específico
    function ReadParameterFromJson(const AObjectName, AKey: string): TParameter;
    procedure WriteParameterToJson(const AParameter: TParameter);
    function GetAllObjectNames: TStringList;
    function GetKeysInObject(AJsonObj: TJSONObject): TStringList;
    function GetKeysCountInObject(AJsonObj: TJSONObject): Integer;
    function GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer;
    procedure AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer);
    procedure AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID: Integer; const AChave: string; AOldOrder, ANewOrder: Integer);
    procedure WriteContratoObject(AContratoID, AProdutoID: Integer);
    procedure ReadContratoObject(out AContratoID, AProdutoID: Integer);
    function ParameterToJsonValue(const AParameter: TParameter): TJSONObject;
    function JsonValueToParameter(AJsonValue: TJSONObject; const ATitulo, AKey: string): TParameter;
    function FormatJSONString(const AJsonString: string; AIndent: Integer = 2): string; // Formata JSON com indentação
    function GetValueCaseInsensitive(AJsonObj: TJSONObject; const AKey: string): TJSONValue; // Busca valor case-insensitive
    function GetJsonValue(AJsonObj: TJSONObject; const AKey: string): TJSONValue; // Função auxiliar para compatibilidade FPC/Delphi
    procedure AddJsonPair(AJsonObj: TJSONObject; const AKey: string; AValue: TJSONValue); overload; // Função auxiliar para AddPair (FPC/Delphi)
    procedure AddJsonPair(AJsonObj: TJSONObject; const AKey: string; const AValue: string); overload; // Função auxiliar para AddPair com string (FPC/Delphi)
    procedure RemoveJsonPair(AJsonObj: TJSONObject; const AKey: string); // Função auxiliar para RemovePair (FPC/Delphi)
    
  public
    constructor Create; overload;
    constructor Create(AJsonObject: TJSONObject); overload;
    constructor CreateFromString(const AJsonString: string); overload;
    constructor CreateFromFile(const AFilePath: string); overload;
    destructor Destroy; override;
    
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
    
    // ========== CRUD ==========
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParametersJsonObject; overload;
    function Get(const AName: string): TParameter; overload;
    function Get(const AName: string; out AParameter: TParameter): IParametersJsonObject; overload;
    function Insert(const AParameter: TParameter): IParametersJsonObject; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject; overload;
    function Update(const AParameter: TParameter): IParametersJsonObject; overload;
    function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject; overload;
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

implementation

{ TParametersJsonObject }

constructor TParametersJsonObject.Create;
begin
  inherited;
  FJsonObject := TJSONObject.Create;
  FOwnJsonObject := True;
  FObjectName := '';
  FFilePath := DEFAULT_PARAMETER_JSON_FILENAME;
  FAutoCreateFile := True;
  FContratoID := 0;
  FProdutoID := 0;
  FLock := TCriticalSection.Create;
end;

constructor TParametersJsonObject.Create(AJsonObject: TJSONObject);
begin
  inherited Create;
  FJsonObject := AJsonObject;
  FOwnJsonObject := False; // Não libera se foi passado externamente
  FObjectName := '';
  FFilePath := '';
  FAutoCreateFile := False;
  FContratoID := 0;
  FProdutoID := 0;
  FLock := TCriticalSection.Create;
end;

constructor TParametersJsonObject.CreateFromString(const AJsonString: string);
begin
  inherited Create;
  FJsonObject := nil;
  FOwnJsonObject := True;
  FObjectName := '';
  FFilePath := '';
  FAutoCreateFile := False;
  FContratoID := 0;
  FProdutoID := 0;
  FLock := TCriticalSection.Create;
  LoadFromString(AJsonString);
end;

constructor TParametersJsonObject.CreateFromFile(const AFilePath: string);
begin
  inherited Create;
  FJsonObject := TJSONObject.Create;
  FOwnJsonObject := True;
  FObjectName := '';
  FFilePath := AFilePath;
  FAutoCreateFile := False;
  FContratoID := 0;
  FProdutoID := 0;
  FLock := TCriticalSection.Create;
  if (AFilePath <> '') and {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(AFilePath) then
    LoadFromFile(AFilePath);
end;

destructor TParametersJsonObject.Destroy;
begin
  FLock.Free;
  if FOwnJsonObject and Assigned(FJsonObject) then
    FJsonObject.Free;
  inherited;
end;

function TParametersJsonObject.EnsureJsonObject: Boolean;
begin
  Result := Assigned(FJsonObject);
  if not Result then
  begin
    FJsonObject := TJSONObject.Create;
    FOwnJsonObject := True;
    Result := True;
  end;
end;

function TParametersJsonObject.EnsureFile: Boolean;
var
  LFileStream: TFileStream;
  LDir: string;
  LBytes: TBytes;
begin
  Result := True;
  
  if FFilePath = '' then
    Exit;
  
  if {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(FFilePath) then
    Exit;
  
  if not FAutoCreateFile then
  begin
    raise CreateJsonObjectException(
      Format(MSG_JSON_FILE_NOT_FOUND, [FFilePath]),
      ERR_JSON_FILE_NOT_FOUND,
      'EnsureFile'
    );
  end;
  
  // Cria diretório se não existir
  LDir := ExtractFilePath(FFilePath);
  if (LDir <> '') and not DirectoryExists(LDir) then
    ForceDirectories(LDir);
  
  // Cria arquivo vazio com JSON básico em UTF-8 (sem BOM)
  LFileStream := TFileStream.Create(FFilePath, fmCreate);
  try
    // Cria JSON vazio: {} em UTF-8
    LBytes := TEncoding.UTF8.GetBytes('{}');
    LFileStream.Write(LBytes[0], Length(LBytes));
  finally
    LFileStream.Free;
  end;
  
  // Carrega o arquivo criado
  LoadFromFile(FFilePath);
end;

function TParametersJsonObject.GetObjectName(const ATitulo: string): string;
begin
  // Nome do objeto JSON é o título
  Result := Trim(ATitulo);
  if Result = '' then
    Result := FObjectName;
  if Result = '' then
    Result := 'Default';
end;

function TParametersJsonObject.GetTituloFromObjectName(const AObjectName: string): string;
begin
  // Título é o nome do objeto JSON
  Result := Trim(AObjectName);
end;

function TParametersJsonObject.ExistsInObject(const AName, AObjectName: string): Boolean;
{ Verifica se a chave existe no objeto específico.
  Permite chaves com mesmo nome em objetos (títulos) diferentes. }
var
  LJsonValue: TJSONValue;
  LJsonObj: TJSONObject;
begin
  Result := False;
  
  if not EnsureJsonObject then
    Exit;
  
  LJsonValue := GetJsonValue(FJsonObject, AObjectName);
  if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    Exit; // Objeto não existe
  
  LJsonObj := TJSONObject(LJsonValue);
  Result := (GetJsonValue(LJsonObj, AName) <> nil);
end;

function TParametersJsonObject.ReadParameterFromJson(const AObjectName, AKey: string): TParameter;
var
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  Result := TParameter.Create;
  try
    Result.Titulo := GetTituloFromObjectName(AObjectName);
    Result.Name := AKey;
    
    // Lê ContratoID e ProdutoID do objeto "Contrato"
    ReadContratoObject(LContratoID, LProdutoID);
    Result.ContratoID := LContratoID;
    Result.ProdutoID := LProdutoID;
    
    if not EnsureJsonObject then
      Exit;
    
    // Busca o objeto pelo nome (título)
    LJsonValue := GetJsonValue(FJsonObject, AObjectName);
    if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
      Exit;
    
    LJsonObj := TJSONObject(LJsonValue);
    
    // Busca a chave dentro do objeto
    LJsonValue := GetJsonValue(LJsonObj, AKey);
    if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
      Exit;
    
    // Converte JSON para Parameter
    Result := JsonValueToParameter(TJSONObject(LJsonValue), Result.Titulo, AKey);
  except
    Result.Free;
    raise;
  end;
end;

procedure TParametersJsonObject.WriteParameterToJson(const AParameter: TParameter);
var
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONObject;
  {$IF DEFINED(FPC)}
  LOrderValue: TJSONValue;
  {$ENDIF}
  LOrder: Integer;
  LKeys: TStringList;
  I: Integer;
  LInsertIndex: Integer;
  LKeyName: string;
begin
  if not EnsureJsonObject then
    Exit;
  
  LObjectName := GetObjectName(AParameter.Titulo);
  
  // Garante que o objeto existe
  if not Assigned(GetJsonValue(FJsonObject, LObjectName)) then
    AddJsonPair(FJsonObject, LObjectName, TJSONObject.Create);
  
  LJsonObj := TJSONObject(GetJsonValue(FJsonObject, LObjectName));
  
  // Calcula ordem se necessário
  LOrder := AParameter.Ordem;
  if LOrder <= 0 then
    LOrder := GetNextOrder(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID)
  else
    AdjustOrdersForInsert(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, LOrder);
  
  // Atualiza ordem no parâmetro
  AParameter.Ordem := LOrder;
  
  // Converte Parameter para JSON
  LJsonValue := ParameterToJsonValue(AParameter);
  
  // Remove chave existente se houver
  RemoveJsonPair(LJsonObj, AParameter.Name);
  
  // Adiciona chave na posição correta (baseada na ordem)
  LKeys := GetKeysInObject(LJsonObj);
  try
    LInsertIndex := -1;
    for I := 0 to LKeys.Count - 1 do
    begin
      LKeyName := LKeys[I];
      LJsonValue := TJSONObject(GetJsonValue(LJsonObj, LKeyName));
      {$IF DEFINED(FPC)}
      LOrderValue := GetJsonValue(TJSONObject(LJsonValue), 'ordem');
      if Assigned(LJsonValue) and Assigned(LOrderValue) and (LOrderValue is TJSONNumber) and (TJSONNumber(LOrderValue).AsInteger >= LOrder) then
      {$ELSE}
      if Assigned(LJsonValue) and (LJsonValue.GetValue<Integer>('ordem', 0) >= LOrder) then
      {$ENDIF}
      begin
        LInsertIndex := I;
        Break;
      end;
    end;
    
    // Se não encontrou posição, adiciona no final
    if LInsertIndex < 0 then
      AddJsonPair(LJsonObj, AParameter.Name, ParameterToJsonValue(AParameter))
    else
    begin
      // Remove todas as chaves a partir de LInsertIndex
      for I := LKeys.Count - 1 downto LInsertIndex do
      begin
        LKeyName := LKeys[I];
        LJsonValue := TJSONObject(GetJsonValue(LJsonObj, LKeyName));
        RemoveJsonPair(LJsonObj, LKeyName);
        AddJsonPair(LJsonObj, LKeyName, LJsonValue);
      end;
      // Adiciona a nova chave na posição correta
      // Nota: TJSONObject não suporta inserção em posição específica,
      // então removemos e re-adicionamos todas as chaves na ordem correta
      // Por simplicidade, adicionamos no final e depois ordenamos
      AddJsonPair(LJsonObj, AParameter.Name, ParameterToJsonValue(AParameter));
    end;
  finally
    LKeys.Free;
  end;
  
  // Atualiza objeto Contrato
  WriteContratoObject(AParameter.ContratoID, AParameter.ProdutoID);
end;

function TParametersJsonObject.GetAllObjectNames: TStringList;
var
  I: Integer;
  {$IF DEFINED(FPC)}
  LObjectName: string;
  {$ELSE}
  LPair: TJSONPair;
  LObjectName: string;
  {$ENDIF}
begin
  Result := TStringList.Create;
  try
    if not EnsureJsonObject then
      Exit;
    
    for I := 0 to FJsonObject.Count - 1 do
    begin
      {$IF DEFINED(FPC)}
      LObjectName := FJsonObject.Names[I];
      {$ELSE}
      LPair := FJsonObject.Pairs[I];
      LObjectName := LPair.JsonString.Value;
      {$ENDIF}
      
      // Ignora objeto "Contrato"
      if SameText(LObjectName, 'Contrato') then
        Continue;
      
      Result.Add(LObjectName);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TParametersJsonObject.GetKeysInObject(AJsonObj: TJSONObject): TStringList;
var
  I: Integer;
  {$IF DEFINED(FPC)}
  // No FPC, não precisa de LPair
  {$ELSE}
  LPair: TJSONPair;
  {$ENDIF}
begin
  Result := TStringList.Create;
  try
    if not Assigned(AJsonObj) then
      Exit;
    
    for I := 0 to AJsonObj.Count - 1 do
    begin
      {$IF DEFINED(FPC)}
      Result.Add(AJsonObj.Names[I]);
      {$ELSE}
      LPair := AJsonObj.Pairs[I];
      Result.Add(LPair.JsonString.Value);
      {$ENDIF}
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TParametersJsonObject.GetKeysCountInObject(AJsonObj: TJSONObject): Integer;
begin
  Result := 0;
  if Assigned(AJsonObj) then
    Result := AJsonObj.Count;
end;

function TParametersJsonObject.GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer;
var
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  LKeys: TStringList;
  I: Integer;
  LMaxOrder: Integer;
  LOrder: Integer;
  {$IF DEFINED(FPC)}
  LOrderValue: TJSONValue;
  {$ENDIF}
begin
  Result := 1;
  
  if not EnsureJsonObject then
    Exit;
  
  LObjectName := GetObjectName(ATitulo);
  LJsonValue := GetJsonValue(FJsonObject, LObjectName);
  if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    Exit;
  
  LJsonObj := TJSONObject(LJsonValue);
  LKeys := GetKeysInObject(LJsonObj);
  try
    LMaxOrder := 0;
    for I := 0 to LKeys.Count - 1 do
    begin
      LJsonValue := GetJsonValue(LJsonObj, LKeys[I]);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
      begin
        {$IF DEFINED(FPC)}
        LOrderValue := GetJsonValue(TJSONObject(LJsonValue), 'ordem');
        if Assigned(LOrderValue) and (LOrderValue is TJSONNumber) then
          LOrder := TJSONNumber(LOrderValue).AsInteger
        else
          LOrder := 0;
        {$ELSE}
        LOrder := TJSONObject(LJsonValue).GetValue<Integer>('ordem', 0);
        {$ENDIF}
        if LOrder > LMaxOrder then
          LMaxOrder := LOrder;
      end;
    end;
    Result := LMaxOrder + 1;
  finally
    LKeys.Free;
  end;
end;

procedure TParametersJsonObject.AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer);
var
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  LKeys: TStringList;
  I: Integer;
  LKeyName: string;
  LParamObj: TJSONObject;
  LCurrentOrder: Integer;
  {$IF DEFINED(FPC)}
  LOrderValue: TJSONValue;
  {$ENDIF}
begin
  if not EnsureJsonObject then
    Exit;
  
  LObjectName := GetObjectName(ATitulo);
  LJsonValue := GetJsonValue(FJsonObject, LObjectName);
  if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    Exit;
  
  LJsonObj := TJSONObject(LJsonValue);
  LKeys := GetKeysInObject(LJsonObj);
  try
    for I := 0 to LKeys.Count - 1 do
    begin
      LKeyName := LKeys[I];
      LJsonValue := GetJsonValue(LJsonObj, LKeyName);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
      begin
        LParamObj := TJSONObject(LJsonValue);
        {$IF DEFINED(FPC)}
        LOrderValue := GetJsonValue(LParamObj, 'ordem');
        if Assigned(LOrderValue) and (LOrderValue is TJSONNumber) then
          LCurrentOrder := TJSONNumber(LOrderValue).AsInteger
        else
          LCurrentOrder := 0;
        {$ELSE}
        LCurrentOrder := LParamObj.GetValue<Integer>('ordem', 0);
        {$ENDIF}
        if LCurrentOrder >= AOrder then
        begin
          // Incrementa ordem
          RemoveJsonPair(LParamObj, 'ordem');
          AddJsonPair(LParamObj, 'ordem', TJSONNumber.Create(LCurrentOrder + 1));
        end;
      end;
    end;
  finally
    LKeys.Free;
  end;
end;

procedure TParametersJsonObject.AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID: Integer; const AChave: string; AOldOrder, ANewOrder: Integer);
var
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  LKeys: TStringList;
  I: Integer;
  LKeyName: string;
  LParamObj: TJSONObject;
  LCurrentOrder: Integer;
  {$IF DEFINED(FPC)}
  LOrderValue: TJSONValue;
  {$ENDIF}
begin
  if not EnsureJsonObject then
    Exit;
  
  if AOldOrder = ANewOrder then
    Exit;
  
  LObjectName := GetObjectName(ATitulo);
  LJsonValue := GetJsonValue(FJsonObject, LObjectName);
  if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    Exit;
  
  LJsonObj := TJSONObject(LJsonValue);
  LKeys := GetKeysInObject(LJsonObj);
  try
    for I := 0 to LKeys.Count - 1 do
    begin
      LKeyName := LKeys[I];
      if SameText(LKeyName, AChave) then
        Continue; // Pula a chave que está sendo atualizada
      
      LJsonValue := GetJsonValue(LJsonObj, LKeyName);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
      begin
        LParamObj := TJSONObject(LJsonValue);
        {$IF DEFINED(FPC)}
        LOrderValue := GetJsonValue(LParamObj, 'ordem');
        if Assigned(LOrderValue) and (LOrderValue is TJSONNumber) then
          LCurrentOrder := TJSONNumber(LOrderValue).AsInteger
        else
          LCurrentOrder := 0;
        {$ELSE}
        LCurrentOrder := LParamObj.GetValue<Integer>('ordem', 0);
        {$ENDIF}
        
        if ANewOrder > AOldOrder then
        begin
          // Movendo para frente: decrementa ordens entre OldOrder e NewOrder
          if (LCurrentOrder > AOldOrder) and (LCurrentOrder <= ANewOrder) then
          begin
            RemoveJsonPair(LParamObj, 'ordem');
            AddJsonPair(LParamObj, 'ordem', TJSONNumber.Create(LCurrentOrder - 1));
          end;
        end
        else
        begin
          // Movendo para trás: incrementa ordens entre NewOrder e OldOrder
          if (LCurrentOrder >= ANewOrder) and (LCurrentOrder < AOldOrder) then
          begin
            RemoveJsonPair(LParamObj, 'ordem');
            AddJsonPair(LParamObj, 'ordem', TJSONNumber.Create(LCurrentOrder + 1));
          end;
        end;
      end;
    end;
  finally
    LKeys.Free;
  end;
end;

procedure TParametersJsonObject.WriteContratoObject(AContratoID, AProdutoID: Integer);
var
  LContratoObj: TJSONObject;
begin
  if not EnsureJsonObject then
    Exit;
  
  // Remove objeto Contrato existente
  RemoveJsonPair(FJsonObject, 'Contrato');
  
  // Cria novo objeto Contrato
  LContratoObj := TJSONObject.Create;
  AddJsonPair(LContratoObj, 'Contrato_ID', TJSONNumber.Create(AContratoID));
  AddJsonPair(LContratoObj, 'Produto_ID', TJSONNumber.Create(AProdutoID));
  
  // Adiciona como primeiro par (para manter ordem)
  // Nota: TJSONObject não suporta inserção em posição específica,
  // então adicionamos no final e depois movemos para o início se necessário
  AddJsonPair(FJsonObject, 'Contrato', LContratoObj);
end;

procedure TParametersJsonObject.ReadContratoObject(out AContratoID, AProdutoID: Integer);
var
  LJsonValue: TJSONValue;
  LContratoObj: TJSONObject;
begin
  AContratoID := 0;
  AProdutoID := 0;
  
  if not EnsureJsonObject then
    Exit;
  
  // Busca objeto "Contrato" case-insensitive
  LJsonValue := GetValueCaseInsensitive(FJsonObject, 'Contrato');
  if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    Exit;
  
  LContratoObj := TJSONObject(LJsonValue);
  
  // Busca Contrato_ID case-insensitive
  LJsonValue := GetValueCaseInsensitive(LContratoObj, 'Contrato_ID');
  if Assigned(LJsonValue) then
  begin
    if LJsonValue is TJSONNumber then
      {$IF DEFINED(FPC)}
      AContratoID := TJSONNumber(LJsonValue).AsInteger
      {$ELSE}
      AContratoID := TJSONNumber(LJsonValue).AsInt
      {$ENDIF}
    else if LJsonValue is TJSONString then
      AContratoID := StrToIntDef(TJSONString(LJsonValue).Value, 0);
  end;
  
  // Busca Produto_ID case-insensitive
  LJsonValue := GetValueCaseInsensitive(LContratoObj, 'Produto_ID');
  if Assigned(LJsonValue) then
  begin
    if LJsonValue is TJSONNumber then
      {$IF DEFINED(FPC)}
      AProdutoID := TJSONNumber(LJsonValue).AsInteger
      {$ELSE}
      AProdutoID := TJSONNumber(LJsonValue).AsInt
      {$ENDIF}
    else if LJsonValue is TJSONString then
      AProdutoID := StrToIntDef(TJSONString(LJsonValue).Value, 0);
  end;
end;

function TParametersJsonObject.ParameterToJsonValue(const AParameter: TParameter): TJSONObject;
begin
  Result := TJSONObject.Create;
  AddJsonPair(Result, 'valor', AParameter.Value);
  AddJsonPair(Result, 'descricao', AParameter.Description);
  AddJsonPair(Result, 'ativo', TJSONBool.Create(AParameter.Ativo));
  AddJsonPair(Result, 'ordem', TJSONNumber.Create(AParameter.Ordem));
end;

function TParametersJsonObject.JsonValueToParameter(AJsonValue: TJSONObject; const ATitulo, AKey: string): TParameter;
var
  LContratoID: Integer;
  LProdutoID: Integer;
  LJsonValue: TJSONValue;
begin
  Result := TParameter.Create;
  try
    Result.Titulo := ATitulo;
    Result.Name := AKey;
    
    // Usa GetValueCaseInsensitive para buscar valores (mais robusto)
    LJsonValue := GetValueCaseInsensitive(AJsonValue, 'valor');
    if Assigned(LJsonValue) then
    begin
      if LJsonValue is TJSONString then
        Result.Value := TJSONString(LJsonValue).Value
      else
        Result.Value := LJsonValue.Value;
    end;
    
    LJsonValue := GetValueCaseInsensitive(AJsonValue, 'descricao');
    if Assigned(LJsonValue) then
    begin
      if LJsonValue is TJSONString then
        Result.Description := TJSONString(LJsonValue).Value
      else
        Result.Description := LJsonValue.Value;
    end;
    
    LJsonValue := GetValueCaseInsensitive(AJsonValue, 'ativo');
    if Assigned(LJsonValue) then
    begin
      if LJsonValue is TJSONBool then
        Result.Ativo := TJSONBool(LJsonValue).AsBoolean
      {$IF NOT DEFINED(FPC)}
      else if LJsonValue is TJSONTrue then
        Result.Ativo := True
      else if LJsonValue is TJSONFalse then
        Result.Ativo := False
      {$ENDIF}
      else if LJsonValue is TJSONNumber then
      begin
        // Aceita número: 1 = true, 0 = false, qualquer outro = true
        {$IF DEFINED(FPC)}
        Result.Ativo := TJSONNumber(LJsonValue).AsInteger <> 0;
        {$ELSE}
        Result.Ativo := TJSONNumber(LJsonValue).AsInt <> 0;
        {$ENDIF}
      end
      else if LJsonValue is TJSONString then
      begin
        // Aceita string: "true", "1", "yes", "on" = true, outros = false
        // Case-insensitive
        case IndexStr(LowerCase(Trim(TJSONString(LJsonValue).Value)), 
                      ['true', '1', 'yes', 'on', 'sim', 's']) of
          0..5: Result.Ativo := True;
        else
          Result.Ativo := False;
        end;
      end
      else
        Result.Ativo := True; // Padrão
    end
    else
      Result.Ativo := True; // Padrão se não encontrado
    
    LJsonValue := GetValueCaseInsensitive(AJsonValue, 'ordem');
    if Assigned(LJsonValue) then
    begin
      if LJsonValue is TJSONNumber then
        {$IF DEFINED(FPC)}
        Result.Ordem := TJSONNumber(LJsonValue).AsInteger
        {$ELSE}
        Result.Ordem := TJSONNumber(LJsonValue).AsInt
        {$ENDIF}
      else if LJsonValue is TJSONString then
        Result.Ordem := StrToIntDef(TJSONString(LJsonValue).Value, 0)
      else
        Result.Ordem := 0;
    end
    else
      Result.Ordem := 0; // Padrão se não encontrado
    
    // Lê ContratoID e ProdutoID do objeto "Contrato"
    ReadContratoObject(LContratoID, LProdutoID);
    Result.ContratoID := LContratoID;
    Result.ProdutoID := LProdutoID;
  except
    Result.Free;
    raise;
  end;
end;

// ========== CONFIGURAÇÃO (Fluent Interface) ==========

function TParametersJsonObject.JsonObject(AJsonObject: TJSONObject): IParametersJsonObject;
begin
  FLock.Enter;
  try
    if FOwnJsonObject and Assigned(FJsonObject) then
      FJsonObject.Free;
    FJsonObject := AJsonObject;
    FOwnJsonObject := False;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.JsonObject: TJSONObject;
begin
  FLock.Enter;
  try
    EnsureJsonObject;
    Result := FJsonObject;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ObjectName(const AValue: string): IParametersJsonObject;
begin
  FLock.Enter;
  try
    FObjectName := Trim(AValue);
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ObjectName: string;
begin
  FLock.Enter;
  try
    Result := FObjectName;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.FilePath(const AValue: string): IParametersJsonObject;
begin
  FLock.Enter;
  try
    FFilePath := Trim(AValue);
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.FilePath: string;
begin
  FLock.Enter;
  try
    Result := FFilePath;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.AutoCreateFile(const AValue: Boolean): IParametersJsonObject;
begin
  FLock.Enter;
  try
    FAutoCreateFile := AValue;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.AutoCreateFile: Boolean;
begin
  FLock.Enter;
  try
    Result := FAutoCreateFile;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ContratoID(const AValue: Integer): IParametersJsonObject;
begin
  FLock.Enter;
  try
    FContratoID := AValue;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ContratoID: Integer;
begin
  FLock.Enter;
  try
    Result := FContratoID;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ProdutoID(const AValue: Integer): IParametersJsonObject;
begin
  FLock.Enter;
  try
    FProdutoID := AValue;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ProdutoID: Integer;
begin
  FLock.Enter;
  try
    Result := FProdutoID;
  finally
    FLock.Leave;
  end;
end;

// ========== CRUD ==========

function TParametersJsonObject.List: TParameterList;
var
  LList: TParameterList;
begin
  List(LList);
  Result := LList;
end;

{ =============================================================================
  List - Lista todos os parâmetros do objeto JSON
  
  Descrição:
  Retorna uma lista de todos os parâmetros do objeto JSON que correspondem
  aos filtros de ContratoID e ProdutoID configurados. A lista preserva a
  ordem dos parâmetros conforme aparecem no JSON.
  
  Comportamento:
  - Lê todos os objetos do JSON (exceto "Contrato")
  - Filtra por ContratoID e ProdutoID se configurados
  - Preserva estrutura e formatação do JSON
  - Parâmetros inativos (ativo = false) são incluídos
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AList: Lista de parâmetros retornada (deve ser liberada pelo chamador)
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersJsonObjectException: Se houver erro ao ler o JSON
  
  Exemplo:
  var
    Json: IParametersJsonObject;
    ParamList: TParameterList;
  begin
    Json := TParameters.NewJsonObject
      .FilePath('C:\Config\params.json')
      .ContratoID(1)
      .ProdutoID(1);
    
    ParamList := Json.List;
    try
      // Usar ParamList...
    finally
      ParamList.Free;
    end;
  end;
  ============================================================================= }
function TParametersJsonObject.List(out AList: TParameterList): IParametersJsonObject;
var
  LObjectNames: TStringList;
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  LKeys: TStringList;
  I, J: Integer;
  LKeyName: string;
  LParameter: TParameter;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  FLock.Enter;
  try
    AList := TParameterList.Create;
    try
      if not EnsureJsonObject then
      begin
        Result := Self;
        Exit;
      end;
      
      // Verifica se FJsonObject está válido
      if not Assigned(FJsonObject) then
      begin
        Result := Self;
        Exit;
      end;
      
      // Lê ContratoID e ProdutoID do objeto "Contrato"
      ReadContratoObject(LContratoID, LProdutoID);
      
      // Se ContratoID e ProdutoID não foram encontrados no JSON, usa os valores configurados
      // IMPORTANTE: Se ambos forem 0 (não configurados), permite todos os parâmetros
      if (LContratoID = 0) and (LProdutoID = 0) then
      begin
        // Se não há filtros configurados, usa os valores do JSON ou permite todos
        if (FContratoID = 0) and (FProdutoID = 0) then
        begin
          // Sem filtros: permite todos os parâmetros (não filtra)
          LContratoID := 0;
          LProdutoID := 0;
        end
        else
        begin
          // Usa filtros configurados
          LContratoID := FContratoID;
          LProdutoID := FProdutoID;
        end;
      end;
      
      // Lista todos os objetos (exceto "Contrato")
      LObjectNames := GetAllObjectNames;
      try
        // Se não encontrou nenhum objeto, retorna lista vazia
        if LObjectNames.Count = 0 then
        begin
          Result := Self;
          Exit;
        end;
        
        for I := 0 to LObjectNames.Count - 1 do
        begin
          LObjectName := LObjectNames[I];
          
          // Usa GetValueCaseInsensitive para buscar o objeto (mais robusto)
          LJsonValue := GetValueCaseInsensitive(FJsonObject, LObjectName);
          if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
            Continue;
          
          LJsonObj := TJSONObject(LJsonValue);
          LKeys := GetKeysInObject(LJsonObj);
          try
            for J := 0 to LKeys.Count - 1 do
            begin
              LKeyName := LKeys[J];
              
              // Usa GetValueCaseInsensitive para buscar a chave (mais robusto)
              LJsonValue := GetValueCaseInsensitive(LJsonObj, LKeyName);
              if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
                Continue;
              
              try
                LParameter := JsonValueToParameter(TJSONObject(LJsonValue), LObjectName, LKeyName);
                LParameter.Ordem := J + 1; // Ordem baseada na posição dentro do objeto
                // Usa ContratoID e ProdutoID do JSON ou dos valores configurados
                if LParameter.ContratoID = 0 then
                  LParameter.ContratoID := LContratoID;
                if LParameter.ProdutoID = 0 then
                  LParameter.ProdutoID := LProdutoID;
                AList.Add(LParameter);
              except
                on E: Exception do
                begin
                  // Se houver erro ao converter um parâmetro, continua com os próximos
                  // Não interrompe o processo de listagem
                  // Log do erro pode ser adicionado aqui se necessário
                  Continue;
                end;
              end;
            end;
          finally
            LKeys.Free;
          end;
        end;
      finally
        LObjectNames.Free;
      end;
    except
      AList.ClearAll;
      AList.Free;
      raise;
    end;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.Get(const AName: string): TParameter;
var
  LParameter: TParameter;
begin
  Get(AName, LParameter);
  Result := LParameter;
end;

function TParametersJsonObject.Get(const AName: string; out AParameter: TParameter): IParametersJsonObject;
var
  LObjectNames: TStringList;
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  I: Integer;
  LKeys: TStringList;
  J: Integer;
  LKeyName: string;
begin
  FLock.Enter;
  try
    AParameter := nil;
    
    if not EnsureJsonObject then
    begin
      Result := Self;
      Exit;
    end;
    
    // Busca em todos os objetos (exceto "Contrato")
    LObjectNames := GetAllObjectNames;
    try
      for I := 0 to LObjectNames.Count - 1 do
      begin
        LObjectName := LObjectNames[I];
        LJsonValue := GetJsonValue(FJsonObject, LObjectName);
        if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
          Continue;
        
        LJsonObj := TJSONObject(LJsonValue);
        LKeys := GetKeysInObject(LJsonObj);
        try
          for J := 0 to LKeys.Count - 1 do
          begin
            LKeyName := LKeys[J];
            if SameText(LKeyName, AName) then
            begin
              LJsonValue := GetJsonValue(LJsonObj, LKeyName);
              if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
              begin
                AParameter := JsonValueToParameter(TJSONObject(LJsonValue), LObjectName, LKeyName);
                AParameter.Ordem := J + 1; // Ordem baseada na posição dentro do objeto
                Result := Self;
                Exit;
              end;
            end;
          end;
        finally
          LKeys.Free;
        end;
      end;
    finally
      LObjectNames.Free;
    end;
    
    // Se não encontrou, busca no objeto específico (se configurado)
    if (FObjectName <> '') and (AParameter = nil) then
    begin
      LJsonValue := GetJsonValue(FJsonObject, FObjectName);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
      begin
        LJsonObj := TJSONObject(LJsonValue);
        LJsonValue := GetJsonValue(LJsonObj, AName);
        if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
        begin
          AParameter := JsonValueToParameter(TJSONObject(LJsonValue), FObjectName, AName);
          // Calcula ordem baseada na posição
          LKeys := GetKeysInObject(LJsonObj);
          try
            for J := 0 to LKeys.Count - 1 do
            begin
              if SameText(LKeys[J], AName) then
              begin
                AParameter.Ordem := J + 1;
                Break;
              end;
            end;
          finally
            LKeys.Free;
          end;
        end;
      end;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.Insert(const AParameter: TParameter): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  Insert(AParameter, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;
var
  LObjectName: string;
  LExists: Boolean;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not EnsureJsonObject then
    begin
      Result := Self;
      Exit;
    end;
    
    if FFilePath <> '' then
      EnsureFile;
    
    // Determina objeto baseado no título
    LObjectName := GetObjectName(AParameter.Titulo);
    
    // Verifica se a chave já existe no mesmo objeto (título)
    // Permite chaves com mesmo nome em objetos (títulos) diferentes
    LExists := ExistsInObject(AParameter.Name, LObjectName);
    
    if LExists then
    begin
      ASuccess := False;
      Result := Self;
      Exit;
    end;
    
    try
      WriteParameterToJson(AParameter);
      ASuccess := True;
    except
      ASuccess := False;
      raise;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.Update(const AParameter: TParameter): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  Update(AParameter, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;
var
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  LOldOrder: Integer;
  LNewOrder: Integer;
  {$IF DEFINED(FPC)}
  LOrderValue: TJSONValue;
  {$ENDIF}
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not EnsureJsonObject then
    begin
      Result := Self;
      Exit;
    end;
    
    LObjectName := GetObjectName(AParameter.Titulo);
    LJsonValue := GetJsonValue(FJsonObject, LObjectName);
    if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    begin
      Result := Self;
      Exit;
    end;
    
    LJsonObj := TJSONObject(LJsonValue);
    LJsonValue := GetJsonValue(LJsonObj, AParameter.Name);
    if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    begin
      Result := Self;
      Exit;
    end;
    
    // Obtém ordem antiga
    {$IF DEFINED(FPC)}
    LOrderValue := GetJsonValue(TJSONObject(LJsonValue), 'ordem');
    if Assigned(LOrderValue) and (LOrderValue is TJSONNumber) then
      LOldOrder := TJSONNumber(LOrderValue).AsInteger
    else
      LOldOrder := 0;
    {$ELSE}
    LOldOrder := TJSONObject(LJsonValue).GetValue<Integer>('ordem', 0);
    {$ENDIF}
    
    // Calcula nova ordem se necessário
    LNewOrder := AParameter.Ordem;
    if LNewOrder <= 0 then
      LNewOrder := GetNextOrder(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID);
    
    // Ajusta ordens se necessário
    if LNewOrder <> LOldOrder then
      AdjustOrdersForUpdate(AParameter.Titulo, AParameter.ContratoID, AParameter.ProdutoID, AParameter.Name, LOldOrder, LNewOrder);
    
    AParameter.Ordem := LNewOrder;
    
    // Atualiza o parâmetro
    WriteParameterToJson(AParameter);
    ASuccess := True;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.Delete(const AName: string): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  Delete(AName, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.Delete(const AName: string; out ASuccess: Boolean): IParametersJsonObject;
var
  LObjectNames: TStringList;
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  I: Integer;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not EnsureJsonObject then
    begin
      Result := Self;
      Exit;
    end;
    
    // Busca em todos os objetos (exceto "Contrato")
    LObjectNames := GetAllObjectNames;
    try
      for I := 0 to LObjectNames.Count - 1 do
      begin
        LObjectName := LObjectNames[I];
        LJsonValue := GetJsonValue(FJsonObject, LObjectName);
        if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
          Continue;
        
        LJsonObj := TJSONObject(LJsonValue);
        if GetJsonValue(LJsonObj, AName) <> nil then
        begin
          RemoveJsonPair(LJsonObj, AName);
          ASuccess := True;
          
          // Verifica se o objeto ficou vazio e remove se necessário
          // Ignora objeto "Contrato" que é especial
          if (GetKeysCountInObject(LJsonObj) = 0) and 
             (not SameText(LObjectName, 'Contrato')) then
          begin
            RemoveJsonPair(FJsonObject, LObjectName);
          end;
          
          Break;
        end;
      end;
    finally
      LObjectNames.Free;
    end;
    
    // Se não encontrou, busca no objeto específico (se configurado)
    if not ASuccess and (FObjectName <> '') then
    begin
      LJsonValue := GetJsonValue(FJsonObject, FObjectName);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
      begin
        LJsonObj := TJSONObject(LJsonValue);
        if GetJsonValue(LJsonObj, AName) <> nil then
        begin
          RemoveJsonPair(LJsonObj, AName);
          ASuccess := True;
          
          // Verifica se o objeto ficou vazio e remove se necessário
          // Ignora objeto "Contrato" que é especial
          if (GetKeysCountInObject(LJsonObj) = 0) and 
             (not SameText(FObjectName, 'Contrato')) then
          begin
            RemoveJsonPair(FJsonObject, FObjectName);
          end;
        end;
      end;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.Exists(const AName: string): Boolean;
var
  LExists: Boolean;
begin
  Exists(AName, LExists);
  Result := LExists;
end;

function TParametersJsonObject.Exists(const AName: string; out AExists: Boolean): IParametersJsonObject;
var
  LObjectNames: TStringList;
  LObjectName: string;
  LJsonObj: TJSONObject;
  LJsonValue: TJSONValue;
  I: Integer;
begin
  FLock.Enter;
  try
    AExists := False;
    
    if not EnsureJsonObject then
    begin
      Result := Self;
      Exit;
    end;
    
    // Busca em todos os objetos (exceto "Contrato")
    LObjectNames := GetAllObjectNames;
    try
      for I := 0 to LObjectNames.Count - 1 do
      begin
        LObjectName := LObjectNames[I];
        LJsonValue := GetJsonValue(FJsonObject, LObjectName);
        if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
          Continue;
        
        LJsonObj := TJSONObject(LJsonValue);
        if GetJsonValue(LJsonObj, AName) <> nil then
        begin
          AExists := True;
          Break;
        end;
      end;
    finally
      LObjectNames.Free;
    end;
    
    // Se não encontrou, busca no objeto específico (se configurado)
    if not AExists and (FObjectName <> '') then
    begin
      LJsonValue := GetJsonValue(FJsonObject, FObjectName);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
      begin
        LJsonObj := TJSONObject(LJsonValue);
        AExists := (GetJsonValue(LJsonObj, AName) <> nil);
      end;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

// ========== UTILITÁRIOS ==========

function TParametersJsonObject.Count: Integer;
var
  LCount: Integer;
begin
  Count(LCount);
  Result := LCount;
end;

function TParametersJsonObject.Count(out ACount: Integer): IParametersJsonObject;
var
  LList: TParameterList;
begin
  FLock.Enter;
  try
    List(LList);
    try
      ACount := LList.Count;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.FileExists: Boolean;
var
  LExists: Boolean;
begin
  FileExists(LExists);
  Result := LExists;
end;

function TParametersJsonObject.FileExists(out AExists: Boolean): IParametersJsonObject;
begin
  FLock.Enter;
  try
    AExists := (FFilePath <> '') and {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(FFilePath);
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.Refresh: IParametersJsonObject;
begin
  FLock.Enter;
  try
    if FFilePath <> '' then
      LoadFromFile(FFilePath);
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ToJSON: TJSONObject;
begin
  FLock.Enter;
  try
    EnsureJsonObject;
    Result := FJsonObject;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ToJSONString: string;
begin
  FLock.Enter;
  try
    EnsureJsonObject;
    Result := FormatJSONString(FJsonObject.ToString, 2);
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.SaveToFile(const AFilePath: string = ''): IParametersJsonObject;
var
  LSuccess: Boolean;
  LPath: string;
begin
  LPath := AFilePath;
  if LPath = '' then
    LPath := FFilePath;
  SaveToFile(LPath, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;
var
  LFileStream: TFileStream;
  LJsonString: string;
  LDir: string;
  LBytes: TBytes;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if AFilePath = '' then
    begin
      if FFilePath = '' then
      begin
        raise CreateJsonObjectException(
          MSG_FILE_PATH_EMPTY,
          ERR_FILE_PATH_EMPTY,
          'SaveToFile'
        );
      end;
    end;
    
    LDir := ExtractFilePath(AFilePath);
    if (LDir <> '') and not DirectoryExists(LDir) then
      ForceDirectories(LDir);
    
    // SIMPLIFICADO: Sempre salva em UTF-8 sem BOM
    // Converte a string JSON para bytes UTF-8
    LJsonString := ToJSONString;
    LBytes := TEncoding.UTF8.GetBytes(LJsonString);
    
    LFileStream := TFileStream.Create(AFilePath, fmCreate);
    try
      // Escreve os bytes UTF-8 (sem BOM)
      LFileStream.Write(LBytes[0], Length(LBytes));
      ASuccess := True;
      FFilePath := AFilePath;
    finally
      LFileStream.Free;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.LoadFromString(const AJsonString: string): IParametersJsonObject;
var
  LJsonValue: TJSONValue;
begin
  FLock.Enter;
  try
    if FOwnJsonObject and Assigned(FJsonObject) then
      FJsonObject.Free;
    
    {$IF DEFINED(FPC)}
    // No FPC, usa GetJSON do unit jsonparser
    try
      LJsonValue := GetJSON(AJsonString);
      if Assigned(LJsonValue) and (LJsonValue is TJSONObject) then
        FJsonObject := TJSONObject(LJsonValue)
      else
      begin
        if Assigned(LJsonValue) then
          LJsonValue.Free;
        FJsonObject := TJSONObject.Create;
      end;
    except
      // Se houver erro no parse, cria objeto vazio
      if Assigned(LJsonValue) then
        LJsonValue.Free;
      FJsonObject := TJSONObject.Create;
    end;
    {$ELSE}
    // No Delphi, usa ParseJSONValue
    LJsonValue := TJSONObject.ParseJSONValue(AJsonString);
    if not Assigned(LJsonValue) or not (LJsonValue is TJSONObject) then
    begin
      if Assigned(LJsonValue) then
        LJsonValue.Free;
      FJsonObject := TJSONObject.Create;
    end
    else
      FJsonObject := TJSONObject(LJsonValue);
    {$ENDIF}
    
    FOwnJsonObject := True;
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.LoadFromFile(const AFilePath: string = ''): IParametersJsonObject;
var
  LSuccess: Boolean;
  LPath: string;
begin
  LPath := AFilePath;
  if LPath = '' then
    LPath := FFilePath;
  LoadFromFile(LPath, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;
var
  LJsonString: string;
  LFileStream: TFileStream;
  LBytes: TBytes;
  LEncoding: TEncoding;
  LIsUTF8: Boolean;
  LIsUTF16: Boolean;
  LUTF16String: string;
  LUTF8Bytes: TBytes;
  I: Integer;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(AFilePath) then
    begin
      Result := Self;
      Exit;
    end;
    
    // Lê o arquivo como bytes para detectar encoding
    LFileStream := TFileStream.Create(AFilePath, fmOpenRead or fmShareDenyWrite);
    try
      SetLength(LBytes, LFileStream.Size);
      LFileStream.Read(LBytes[0], Length(LBytes));
    finally
      LFileStream.Free;
    end;
    
    // Detecta encoding: UTF-16 (LE/BE com/sem BOM), UTF-8 (com/sem BOM) ou ANSI
    LEncoding := nil;
    LIsUTF8 := False;
    LIsUTF16 := False;
    
    // Verifica BOM UTF-16 LE (FF FE)
    if (Length(LBytes) >= 2) and (LBytes[0] = $FF) and (LBytes[1] = $FE) then
    begin
      // UTF-16 Little Endian com BOM
      LIsUTF16 := True;
      try
        // Remove BOM e converte para string UTF-16
        LUTF16String := TEncoding.Unicode.GetString(LBytes, 2, Length(LBytes) - 2);
        // Converte UTF-16 para UTF-8
        LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
        LBytes := LUTF8Bytes;
        LIsUTF8 := True;
        LEncoding := TEncoding.UTF8;
      except
        on E: EEncodingError do
        begin
          // Se falhar, tenta sem BOM
          LIsUTF16 := False;
        end;
      end;
    end
    // Verifica BOM UTF-16 BE (FE FF)
    else if (Length(LBytes) >= 2) and (LBytes[0] = $FE) and (LBytes[1] = $FF) then
    begin
      // UTF-16 Big Endian com BOM
      LIsUTF16 := True;
      try
        // Remove BOM e converte para string UTF-16
        LUTF16String := TEncoding.BigEndianUnicode.GetString(LBytes, 2, Length(LBytes) - 2);
        // Converte UTF-16 para UTF-8
        LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
        LBytes := LUTF8Bytes;
        LIsUTF8 := True;
        LEncoding := TEncoding.UTF8;
      except
        on E: EEncodingError do
        begin
          // Se falhar, tenta sem BOM
          LIsUTF16 := False;
        end;
      end;
    end
    // Verifica BOM UTF-8 (EF BB BF)
    else if (Length(LBytes) >= 3) and (LBytes[0] = $EF) and (LBytes[1] = $BB) and (LBytes[2] = $BF) then
    begin
      // UTF-8 com BOM
      LEncoding := TEncoding.UTF8;
      LIsUTF8 := True;
      // Remove BOM
      LBytes := Copy(LBytes, 3, Length(LBytes) - 3);
    end
    // Detecta UTF-16 sem BOM: tamanho par e tenta ler como UTF-16
    // Se o arquivo tem tamanho par, pode ser UTF-16 sem BOM
    else if (Length(LBytes) >= 4) and ((Length(LBytes) mod 2) = 0) then
    begin
      // Tenta ler como UTF-16 LE primeiro (mais comum no Windows)
      try
        LUTF16String := TEncoding.Unicode.GetString(LBytes);
        // Verifica se é JSON válido (começa com '{' ou '[' ou espaço em branco)
        if (Length(LUTF16String) > 0) then
        begin
          // Remove espaços em branco no início para verificar
          LUTF16String := TrimLeft(LUTF16String);
          if (Length(LUTF16String) > 0) and 
             ((LUTF16String[1] = '{') or (LUTF16String[1] = '[')) then
          begin
            // É UTF-16 válido com JSON
            LIsUTF16 := True;
            // Converte UTF-16 para UTF-8
            LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
            LBytes := LUTF8Bytes;
            LIsUTF8 := True;
            LEncoding := TEncoding.UTF8;
          end;
        end;
      except
        on E: EEncodingError do
        begin
          // Se falhar, tenta UTF-16 BE
          try
            LUTF16String := TEncoding.BigEndianUnicode.GetString(LBytes);
            if (Length(LUTF16String) > 0) then
            begin
              LUTF16String := TrimLeft(LUTF16String);
              if (Length(LUTF16String) > 0) and 
                 ((LUTF16String[1] = '{') or (LUTF16String[1] = '[')) then
              begin
                LIsUTF16 := True;
                LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
                LBytes := LUTF8Bytes;
                LIsUTF8 := True;
                LEncoding := TEncoding.UTF8;
              end;
            end;
          except
            // Se ambos falharem, não é UTF-16
            LIsUTF16 := False;
          end;
        end;
      end;
    end;
    
    // Se não detectou UTF-16, tenta UTF-8 ou ANSI
    if not LIsUTF16 then
    begin
      // Tenta detectar UTF-8 sem BOM verificando se é válido UTF-8
      // Verifica se os primeiros bytes formam uma sequência UTF-8 válida
      LIsUTF8 := True;
      I := 0;
      while (I < Length(LBytes)) and (I < 100) do // Verifica até 100 bytes
      begin
        // Verifica padrões UTF-8:
        // 0xxxxxxx (ASCII) - OK
        // 110xxxxx 10xxxxxx (2 bytes)
        // 1110xxxx 10xxxxxx 10xxxxxx (3 bytes)
        // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx (4 bytes)
        if LBytes[I] < $80 then
        begin
          // ASCII válido
          Inc(I);
        end
        else if (LBytes[I] and $E0) = $C0 then
        begin
          // 2 bytes UTF-8
          if (I + 1 >= Length(LBytes)) or ((LBytes[I + 1] and $C0) <> $80) then
          begin
            LIsUTF8 := False;
            Break;
          end;
          Inc(I, 2);
        end
        else if (LBytes[I] and $F0) = $E0 then
        begin
          // 3 bytes UTF-8
          if (I + 2 >= Length(LBytes)) or 
             ((LBytes[I + 1] and $C0) <> $80) or 
             ((LBytes[I + 2] and $C0) <> $80) then
          begin
            LIsUTF8 := False;
            Break;
          end;
          Inc(I, 3);
        end
        else if (LBytes[I] and $F8) = $F0 then
        begin
          // 4 bytes UTF-8
          if (I + 3 >= Length(LBytes)) or 
             ((LBytes[I + 1] and $C0) <> $80) or 
             ((LBytes[I + 2] and $C0) <> $80) or 
             ((LBytes[I + 3] and $C0) <> $80) then
          begin
            LIsUTF8 := False;
            Break;
          end;
          Inc(I, 4);
        end
        else
        begin
          // Byte inválido para UTF-8
          LIsUTF8 := False;
          Break;
        end;
      end;
      
      if LIsUTF8 then
        LEncoding := TEncoding.UTF8
      else
      begin
        // Se não é UTF-8 válido e tem tamanho par, pode ser UTF-16 sem BOM
        if (Length(LBytes) >= 2) and ((Length(LBytes) mod 2) = 0) then
        begin
          // Tenta UTF-16 LE como último recurso antes de ANSI
          try
            LUTF16String := TEncoding.Unicode.GetString(LBytes);
            // Se conseguiu ler, verifica se parece JSON
            if (Length(LUTF16String) > 0) then
            begin
              LUTF16String := TrimLeft(LUTF16String);
              // Se começa com '{' ou '[', provavelmente é UTF-16
              if (Length(LUTF16String) > 0) and 
                 ((LUTF16String[1] = '{') or (LUTF16String[1] = '[') or
                  (Pos('{', LUTF16String) > 0) or (Pos('[', LUTF16String) > 0)) then
              begin
                // É UTF-16, converte para UTF-8
                LIsUTF16 := True;
                LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
                LBytes := LUTF8Bytes;
                LIsUTF8 := True;
                LEncoding := TEncoding.UTF8;
              end
              else
                LEncoding := TEncoding.ANSI;
            end
            else
              LEncoding := TEncoding.ANSI;
          except
            // Se falhar, usa ANSI como fallback
            LEncoding := TEncoding.ANSI;
          end;
        end
        else
        begin
          // Último recurso: tenta UTF-8 mesmo assim (pode ter caracteres especiais)
          try
            LEncoding := TEncoding.UTF8;
          except
            // Se falhar, usa ANSI como fallback
            LEncoding := TEncoding.ANSI;
          end;
        end;
      end;
    end;
    
    // Converte bytes para string usando encoding detectado
    // Se já foi convertido de UTF-16, LBytes já está em UTF-8
    try
      if LIsUTF16 then
        LJsonString := TEncoding.UTF8.GetString(LBytes)
      else
        LJsonString := LEncoding.GetString(LBytes);
    except
      on E: EEncodingError do
      begin
        // Se falhar a conversão, tenta UTF-16 como último recurso
        if not LIsUTF16 and (Length(LBytes) >= 2) and ((Length(LBytes) mod 2) = 0) then
        begin
          try
            // Tenta como UTF-16 LE
            LUTF16String := TEncoding.Unicode.GetString(LBytes);
            LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
            LBytes := LUTF8Bytes;
            LJsonString := TEncoding.UTF8.GetString(LBytes);
          except
            // Se ainda falhar, tenta UTF-16 BE
            try
              LUTF16String := TEncoding.BigEndianUnicode.GetString(LBytes);
              LUTF8Bytes := TEncoding.UTF8.GetBytes(LUTF16String);
              LBytes := LUTF8Bytes;
              LJsonString := TEncoding.UTF8.GetString(LBytes);
            except
              // Se tudo falhar, re-lança a exceção original
              raise;
            end;
          end;
        end
        else
          raise;
      end;
    end;
    
    // Remove espaços em branco no início e fim
    LJsonString := Trim(LJsonString);
    
    // Verifica se o JSON não está vazio
    if LJsonString = '' then
    begin
      Result := Self;
      Exit;
    end;
    
    // Carrega o JSON da string
    try
      LoadFromString(LJsonString);
      FFilePath := AFilePath;
      ASuccess := True;
    except
      on E: Exception do
      begin
        // Se houver erro ao parsear o JSON, mantém ASuccess = False
        ASuccess := False;
        // Re-lança a exceção convertida para exceção do Parameters
        raise ConvertToParametersException(E, 'LoadFromFile');
      end;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

// ========== IMPORTAÇÃO/EXPORTAÇÃO ==========

function TParametersJsonObject.ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  ImportFromDatabase(ADatabase, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;
var
  LList: TParameterList;
  LParameter: TParameter;
  I: Integer;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not Assigned(ADatabase) then
    begin
      raise EParametersConnectionException.Create(
        'Database não especificado',
        ERR_CONNECTION_FAILED
      );
    end;
    
    // Usa os filtros de ContratoID e ProdutoID configurados pelo usuário
    LContratoID := FContratoID;
    LProdutoID := FProdutoID;
    
    // Configura os filtros no Database antes de listar
    if (LContratoID > 0) or (LProdutoID > 0) then
    begin
      ADatabase.ContratoID(LContratoID).ProdutoID(LProdutoID);
    end;
    
    // Obtém todos os parâmetros do Database (agora filtrados se ContratoID/ProdutoID > 0)
    LList := ADatabase.List;
    try
      // Limpa objeto JSON atual (exceto objeto Contrato se já existir)
      if Assigned(FJsonObject) and FOwnJsonObject then
        FJsonObject.Free;
      FJsonObject := TJSONObject.Create;
      FOwnJsonObject := True;
      
      // Escreve objeto Contrato com os filtros
      WriteContratoObject(LContratoID, LProdutoID);
      
      // Importa todos os parâmetros
      for I := 0 to LList.Count - 1 do
      begin
        LParameter := LList[I];
        WriteParameterToJson(LParameter);
      end;
      
      ASuccess := True;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  ExportToDatabase(ADatabase, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;
var
  LList: TParameterList;
  LParameter: TParameter;
  I: Integer;
  LParamSuccess: Boolean;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not Assigned(ADatabase) then
    begin
      raise EParametersConnectionException.Create(
        'Database não especificado',
        ERR_CONNECTION_FAILED
      );
    end;
    
    // Lista todos os parâmetros do JSON
    LList := List;
    try
      // Exporta todos os parâmetros para o Database
      for I := 0 to LList.Count - 1 do
      begin
        LParameter := LList[I];
        ADatabase.Insert(LParameter, LParamSuccess);
        if not LParamSuccess then
        begin
          // Tenta atualizar se inserção falhou
          ADatabase.Update(LParameter, LParamSuccess);
        end;
      end;
      
      ASuccess := True;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

// ========== IMPORTAÇÃO/EXPORTAÇÃO INIFILES ==========

function TParametersJsonObject.ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  ImportFromInifiles(AInifiles, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;
var
  LList: TParameterList;
  LParameter: TParameter;
  I: Integer;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not Assigned(AInifiles) then
    begin
      raise CreateJsonObjectException(
        MSG_IMPORT_SOURCE_NOT_FOUND,
        ERR_IMPORT_SOURCE_NOT_FOUND,
        'ImportFromInifiles'
      );
    end;
    
    // Usa os filtros de ContratoID e ProdutoID configurados pelo usuário
    LContratoID := FContratoID;
    LProdutoID := FProdutoID;
    
    // Configura os filtros no Inifiles antes de listar
    if (LContratoID > 0) or (LProdutoID > 0) then
    begin
      AInifiles.ContratoID(LContratoID).ProdutoID(LProdutoID);
    end;
    
    // Obtém todos os parâmetros do Inifiles (agora filtrados se ContratoID/ProdutoID > 0)
    LList := AInifiles.List;
    try
      // Limpa objeto JSON atual (exceto objeto Contrato se já existir)
      if Assigned(FJsonObject) and FOwnJsonObject then
        FJsonObject.Free;
      FJsonObject := TJSONObject.Create;
      FOwnJsonObject := True;
      
      // Escreve objeto Contrato com ContratoID e ProdutoID
      if (LContratoID > 0) or (LProdutoID > 0) then
      begin
        WriteContratoObject(LContratoID, LProdutoID);
      end;
      
      // Importa todos os parâmetros do Inifiles para o JSON
      for I := 0 to LList.Count - 1 do
      begin
        LParameter := LList[I];
        WriteParameterToJson(LParameter);
      end;
      
      ASuccess := True;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

function TParametersJsonObject.ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;
var
  LSuccess: Boolean;
begin
  ExportToInifiles(AInifiles, LSuccess);
  Result := Self;
end;

function TParametersJsonObject.ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;
var
  LList: TParameterList;
  LParameter: TParameter;
  I: Integer;
  LParamSuccess: Boolean;
begin
  FLock.Enter;
  try
    ASuccess := False;
    
    if not Assigned(AInifiles) then
    begin
      raise CreateJsonObjectException(
        MSG_IMPORT_SOURCE_NOT_FOUND,
        ERR_IMPORT_SOURCE_NOT_FOUND,
        'ImportFromInifiles'
      );
    end;
    
    // Lista todos os parâmetros do JSON
    LList := List;
    try
      // Exporta todos os parâmetros para o Inifiles
      for I := 0 to LList.Count - 1 do
      begin
        LParameter := LList[I];
        AInifiles.Insert(LParameter, LParamSuccess);
        if not LParamSuccess then
        begin
          // Tenta atualizar se inserção falhou
          AInifiles.Update(LParameter, LParamSuccess);
        end;
      end;
      
      ASuccess := True;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    Result := Self;
  finally
    FLock.Leave;
  end;
end;

// ========== NAVEGAÇÃO ==========

function TParametersJsonObject.EndJsonObject: IInterface;
begin
  Result := Self;
end;

// ========== MÉTODOS AUXILIARES PRIVADOS ==========

function TParametersJsonObject.GetJsonValue(AJsonObj: TJSONObject; const AKey: string): TJSONValue;
begin
  {$IF DEFINED(FPC)}
  // No FPC, usa Find() que retorna TJSONData (que é TJSONValue via alias)
  Result := AJsonObj.Find(AKey);
  {$ELSE}
  // No Delphi, usa GetValue() diretamente
  Result := AJsonObj.GetValue(AKey);
  {$ENDIF}
end;

procedure TParametersJsonObject.AddJsonPair(AJsonObj: TJSONObject; const AKey: string; AValue: TJSONValue);
begin
  {$IF DEFINED(FPC)}
  // No FPC, TJSONObject.Add() adiciona um par chave-valor
  // Remove o par existente se houver
  RemoveJsonPair(AJsonObj, AKey);
  AJsonObj.Add(AKey, AValue);
  {$ELSE}
  // No Delphi, usa AddPair() diretamente
  AJsonObj.AddPair(AKey, AValue);
  {$ENDIF}
end;

procedure TParametersJsonObject.AddJsonPair(AJsonObj: TJSONObject; const AKey: string; const AValue: string);
begin
  {$IF DEFINED(FPC)}
  // No FPC, TJSONObject.Add() aceita string diretamente
  RemoveJsonPair(AJsonObj, AKey);
  AJsonObj.Add(AKey, AValue);
  {$ELSE}
  // No Delphi, usa AddPair() diretamente
  AJsonObj.AddPair(AKey, AValue);
  {$ENDIF}
end;

procedure TParametersJsonObject.RemoveJsonPair(AJsonObj: TJSONObject; const AKey: string);
var
  {$IF DEFINED(FPC)}
  I: Integer;
  {$ELSE}
  LPair: TJSONPair;
  {$ENDIF}
begin
  {$IF DEFINED(FPC)}
  // No FPC, precisa encontrar e remover manualmente
  I := AJsonObj.IndexOfName(AKey);
  if I >= 0 then
    AJsonObj.Delete(I);
  {$ELSE}
  // No Delphi, usa RemovePair()
  LPair := AJsonObj.RemovePair(AKey);
  if Assigned(LPair) then
    LPair.Free;
  {$ENDIF}
end;

function TParametersJsonObject.GetValueCaseInsensitive(AJsonObj: TJSONObject; const AKey: string): TJSONValue;
var
  I: Integer;
  {$IF DEFINED(FPC)}
  LPairName: string;
  {$ELSE}
  LPair: TJSONPair;
  {$ENDIF}
begin
  Result := nil;
  if not Assigned(AJsonObj) then
    Exit;
  
  // Busca case-insensitive percorrendo todos os pares
  {$IF DEFINED(FPC)}
  // No FPC, TJSONObject tem método Find() ou podemos iterar pelos nomes
  for I := 0 to AJsonObj.Count - 1 do
  begin
    LPairName := AJsonObj.Names[I];
    if SameText(LPairName, AKey) then
    begin
      Result := AJsonObj.Items[I];
      Break;
    end;
  end;
  {$ELSE}
  // No Delphi, usa TJSONPair
  for I := 0 to AJsonObj.Count - 1 do
  begin
    LPair := AJsonObj.Pairs[I];
    if SameText(LPair.JsonString.Value, AKey) then
    begin
      Result := LPair.JsonValue;
      Break;
    end;
  end;
  {$ENDIF}
end;

function TParametersJsonObject.FormatJSONString(const AJsonString: string; AIndent: Integer = 2): string;
var
  LResult: TStringList;
  LCurrentIndent: Integer;
  I: Integer;
  LChar: Char;
  LInString: Boolean;
  LEscapeNext: Boolean;
  LIndentStr: string;
begin
  LResult := TStringList.Create;
  try
    LCurrentIndent := 0;
    LInString := False;
    LEscapeNext := False;
    LIndentStr := StringOfChar(' ', AIndent);
    
    I := 1;
    while I <= Length(AJsonString) do
    begin
      LChar := AJsonString[I];
      
      if LEscapeNext then
      begin
        if LResult.Count = 0 then
          LResult.Add('');
        LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
        LEscapeNext := False;
        Inc(I);
        Continue;
      end;
      
      if LChar = '\' then
      begin
        LEscapeNext := True;
        if LResult.Count = 0 then
          LResult.Add('');
        LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
        Inc(I);
        Continue;
      end;
      
      if LChar = '"' then
      begin
        LInString := not LInString;
        if LResult.Count = 0 then
          LResult.Add('');
        LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
        Inc(I);
        Continue;
      end;
      
      if LInString then
      begin
        if LResult.Count = 0 then
          LResult.Add('');
        LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
        Inc(I);
        Continue;
      end;
      
      case LChar of
        '{', '[':
        begin
          if LResult.Count = 0 then
            LResult.Add('');
          LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
          Inc(LCurrentIndent);
          LResult.Add(StringOfChar(' ', LCurrentIndent * AIndent));
          Inc(I);
        end;
        '}', ']':
        begin
          Dec(LCurrentIndent);
          if LCurrentIndent < 0 then
            LCurrentIndent := 0;
          if (LResult.Count > 0) and (Trim(LResult[LResult.Count - 1]) = '') then
            LResult[LResult.Count - 1] := StringOfChar(' ', LCurrentIndent * AIndent) + LChar
          else
          begin
            LResult.Add(StringOfChar(' ', LCurrentIndent * AIndent) + LChar);
          end;
          Inc(I);
        end;
        ',':
        begin
          if LResult.Count = 0 then
            LResult.Add('');
          LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
          LResult.Add(StringOfChar(' ', LCurrentIndent * AIndent));
          Inc(I);
        end;
        ':':
        begin
          if LResult.Count = 0 then
            LResult.Add('');
          LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar + ' ';
          Inc(I);
        end;
        ' ', #9, #10, #13:
        begin
          // Ignora espaços, tabs e quebras de linha fora de strings
          Inc(I);
        end;
        else
        begin
          if LResult.Count = 0 then
            LResult.Add('');
          LResult[LResult.Count - 1] := LResult[LResult.Count - 1] + LChar;
          Inc(I);
        end;
      end;
    end;
    
    // Remove linhas vazias no final
    while (LResult.Count > 0) and (Trim(LResult[LResult.Count - 1]) = '') do
      LResult.Delete(LResult.Count - 1);
    
    Result := LResult.Text;
    // Remove última quebra de linha extra
    if (Length(Result) > 0) and (Result[Length(Result)] = #13) then
      Result := Copy(Result, 1, Length(Result) - 1);
    if (Length(Result) > 0) and (Result[Length(Result)] = #10) then
      Result := Copy(Result, 1, Length(Result) - 1);
  finally
    LResult.Free;
  end;
end;

end.
