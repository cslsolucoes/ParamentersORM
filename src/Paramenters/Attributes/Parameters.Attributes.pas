unit Parameters.Attributes;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ ===============================================================================
  Parameters.Attributes - Implementação do Sistema de Attributes
  
  Descrição:
  Implementa IAttributeParser e IAttributeMapper para parsing e mapeamento
  de classes Pascal com atributos para estruturas TParameter e TParameterList.
  
  Hierarquia:
  Attributes (Runtime) → IAttributeParser → IAttributeMapper → IParameters
  
  Funcionalidades:
  - Parsing de classes com atributos via RTTI
  - Conversão Classe → TParameter/TParameterList
  - Mapeamento bidirecional Classe ↔ TParameter
  - Validação de atributos
  
  Compatibilidade:
  - Delphi XE7+: Suporte completo
  - FPC 3.2.2+: Suporte com limitações conhecidas
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 03/01/2026
  =============================================================================== }

interface

{$I ../../Paramenters.Defines.inc}

uses
  Parameters.Attributes.Interfaces,
  Parameters.Attributes.Types,
  Parameters.Attributes.Consts,
  Parameters.Attributes.Exceptions,
  Parameters.Types,
  Parameters.Interfaces,
{$IF DEFINED(FPC)}
  TypInfo, Rtti, Math;
{$ELSE}
  System.TypInfo, System.RTTI, System.Math,
{$ENDIF}
{$IF DEFINED(FPC)}
  SysUtils, Classes, Variants;
{$ELSE}
  System.SysUtils, System.Classes, System.Variants;
{$ENDIF}

type
  { =============================================================================
    TAttributeParser - Implementação de IAttributeParser
    =============================================================================
    Implementa parsing de classes Pascal com atributos para estruturas TParameter/TParameterList.
    Usa RTTI para ler atributos em runtime e converter para estrutura do Parameters ORM.
    ============================================================================= }
  
  TAttributeParser = class(TInterfacedObject, IAttributeParser)
  private
    FRttiContext: TRttiContext;
    
    // Métodos auxiliares privados
    { Obtém TRttiType da classe usando RTTI
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: TRttiType ou nil se RTTI não disponível
      Exceção: EParametersAttributeException se RTTI não disponível }
    function GetRttiType(const AClassType: TClass): TRttiType;
    
    { Obtém atributo [Parameter] do tipo RTTI
      Parâmetros:
        ARttiType: Tipo RTTI da classe
      Retorno: ParameterAttribute ou nil se não encontrado }
    function GetParameterAttribute(const ARttiType: TRttiType): ParameterAttribute;
    
    { Obtém atributo [ContratoID] do tipo RTTI
      Parâmetros:
        ARttiType: Tipo RTTI da classe
      Retorno: ContratoIDAttribute ou nil se não encontrado }
    function GetContratoIDAttribute(const ARttiType: TRttiType): ContratoIDAttribute;
    
    { Obtém atributo [ProdutoID] do tipo RTTI
      Parâmetros:
        ARttiType: Tipo RTTI da classe
      Retorno: ProdutoIDAttribute ou nil se não encontrado }
    function GetProdutoIDAttribute(const ARttiType: TRttiType): ProdutoIDAttribute;
    
    { Obtém atributo [ParameterSource] do tipo RTTI
      Parâmetros:
        ARttiType: Tipo RTTI da classe
      Retorno: ParameterSourceAttribute ou nil se não encontrado }
    function GetParameterSourceAttribute(const ARttiType: TRttiType): ParameterSourceAttribute;
    
    { Verifica se propriedade tem atributo específico
      Parâmetros:
        ARttiProperty: Propriedade RTTI a verificar
      Retorno: True se tem o atributo, False caso contrário
      Nota: Método genérico - T deve ser TCustomAttribute }
    function HasAttribute<T: TCustomAttribute>(const ARttiProperty: TRttiProperty): Boolean;
    
    { Obtém atributo específico da propriedade
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: Instância do atributo ou nil se não encontrado
      Nota: Método genérico - T deve ser TCustomAttribute }
    function GetAttribute<T: TCustomAttribute>(const ARttiProperty: TRttiProperty): T;
    
    { Converte tipo RTTI para TParameterValueType
      Parâmetros:
        ARttiType: Tipo RTTI da propriedade
      Retorno: TParameterValueType correspondente }
    function ConvertRttiTypeToValueType(const ARttiType: TRttiType): TParameterValueType;
    
    { Obtém chave do parâmetro da propriedade (do atributo [ParameterKey])
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: Chave do parâmetro ou string vazia }
    function GetParameterKey(const ARttiProperty: TRttiProperty): string;
    
    { Obtém valor padrão da propriedade (do atributo [ParameterValue])
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: Valor padrão como Variant ou Null }
    function GetParameterValue(const ARttiProperty: TRttiProperty): Variant;
    
    { Obtém descrição da propriedade (do atributo [ParameterDescription])
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: Descrição ou string vazia }
    function GetParameterDescription(const ARttiProperty: TRttiProperty): string;
    
    { Obtém tipo do valor da propriedade (do atributo [ParameterType] ou inferido)
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: Tipo do valor }
    function GetParameterValueType(const ARttiProperty: TRttiProperty): TParameterValueType;
    
    { Obtém ordem da propriedade (do atributo [ParameterOrder])
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: Ordem ou DEFAULT_PARAMETER_ORDER }
    function GetParameterOrder(const ARttiProperty: TRttiProperty): Integer;
    
    { Verifica se propriedade é obrigatória (tem [ParameterRequired])
      Parâmetros:
        ARttiProperty: Propriedade RTTI
      Retorno: True se obrigatória, False caso contrário }
    function IsParameterRequired(const ARttiProperty: TRttiProperty): Boolean;
    
    { Converte Variant para string conforme TParameterValueType
      Parâmetros:
        AValue: Valor (Variant)
        AValueType: Tipo do valor
      Retorno: String formatada }
    function VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;
    
    { Converte propriedade RTTI em TParameter
      Parâmetros:
        ARttiProperty: Propriedade RTTI a converter
        AInstance: Instância opcional (para obter valores)
        ATitulo: Título do parâmetro (da classe)
        AContratoID: ContratoID (da classe)
        AProdutoID: ProdutoID (da classe)
      Retorno: TParameter criado ou nil se propriedade não tem [ParameterKey] }
    function ParsePropertyToParameter(const ARttiProperty: TRttiProperty; const AInstance: TObject; 
      const ATitulo: string; const AContratoID, AProdutoID: Integer): TParameter;
    
    { Cria exceção quando [Parameter] não encontrado
      Parâmetros:
        AClassName: Nome da classe
        AOperation: Nome da operação
      Retorno: EParametersAttributeException }
    function CreateParameterNotFoundException(const AClassName, AOperation: string): EParametersAttributeException;
    
    { Cria exceção quando RTTI não disponível
      Parâmetros:
        AClassName: Nome da classe
        AOperation: Nome da operação
      Retorno: EParametersAttributeException }
    function CreateRTTINotAvailableException(const AClassName, AOperation: string): EParametersAttributeException;
  public
    { Cria instância de TAttributeParser
      Inicializa contexto RTTI }
    constructor Create;
    
    { Destrói instância e libera contexto RTTI }
    destructor Destroy; override;
    
    // Factory
    { Cria nova instância de IAttributeParser
      Retorno: Interface IAttributeParser }
    class function New: IAttributeParser;
    
    // IAttributeParser implementation
    { Converte classe em TParameterList (sem valores)
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: TParameterList com estrutura completa
      Exceção: EParametersAttributeException se não tiver [Parameter] }
    function ParseClass(const AClassType: TClass): TParameterList; overload;
    
    { Converte instância em TParameterList (com valores)
      Parâmetros:
        AInstance: Instância da classe
      Retorno: TParameterList com estrutura e valores }
    function ParseClass(const AInstance: TObject): TParameterList; overload;
    
    { Obtém título da classe
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: Título ou string vazia
      Exceção: EParametersAttributeException se não tiver [Parameter] }
    function GetClassTitle(const AClassType: TClass): string; overload;
    
    { Obtém título da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: Título }
    function GetClassTitle(const AInstance: TObject): string; overload;
    
    { Obtém ContratoID da classe
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: ContratoID ou DEFAULT_CONTRATO_ID }
    function GetClassContratoID(const AClassType: TClass): Integer; overload;
    
    { Obtém ContratoID da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: ContratoID }
    function GetClassContratoID(const AInstance: TObject): Integer; overload;
    
    { Obtém ProdutoID da classe
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: ProdutoID ou DEFAULT_PRODUTO_ID }
    function GetClassProdutoID(const AClassType: TClass): Integer; overload;
    
    { Obtém ProdutoID da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: ProdutoID }
    function GetClassProdutoID(const AInstance: TObject): Integer; overload;
    
    { Obtém fonte de dados da classe
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: Fonte de dados ou DEFAULT_PARAMETER_SOURCE }
    function GetClassSource(const AClassType: TClass): TParameterSource; overload;
    
    { Obtém fonte de dados da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: Fonte de dados }
    function GetClassSource(const AInstance: TObject): TParameterSource; overload;
    
    { Obtém lista de propriedades com [ParameterKey]
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: Array com nomes das propriedades }
    function GetParameterProperties(const AClassType: TClass): TStringArray; overload;
    
    { Obtém lista de propriedades com [ParameterKey]
      Parâmetros:
        AInstance: Instância da classe
      Retorno: Array com nomes das propriedades }
    function GetParameterProperties(const AInstance: TObject): TStringArray; overload;
    
    { Obtém chave do parâmetro da propriedade
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Chave do parâmetro ou string vazia }
    function GetPropertyKey(const AInstance: TObject; const APropertyName: string): string;
    
    { Obtém valor padrão da propriedade
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Valor padrão ou Null }
    function GetPropertyDefaultValue(const AInstance: TObject; const APropertyName: string): Variant;
    
    { Obtém descrição da propriedade
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Descrição ou string vazia }
    function GetPropertyDescription(const AInstance: TObject; const APropertyName: string): string;
    
    { Obtém tipo do valor da propriedade
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Tipo do valor }
    function GetPropertyValueType(const AInstance: TObject; const APropertyName: string): TParameterValueType;
    
    { Obtém ordem da propriedade
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Ordem ou DEFAULT_PARAMETER_ORDER }
    function GetPropertyOrder(const AInstance: TObject; const APropertyName: string): Integer;
    
    { Verifica se propriedade é obrigatória
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: True se obrigatória, False caso contrário }
    function IsPropertyRequired(const AInstance: TObject; const APropertyName: string): Boolean;
    
    { Valida se classe tem atributos corretos
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: True se válida, False caso contrário }
    function ValidateClass(const AClassType: TClass): Boolean; overload;
    
    { Valida se instância tem atributos corretos
      Parâmetros:
        AInstance: Instância da classe
      Retorno: True se válida, False caso contrário }
    function ValidateClass(const AInstance: TObject): Boolean; overload;
  end;

  { =============================================================================
    TAttributeMapper - Implementação de IAttributeMapper
    =============================================================================
    Implementa mapeamento bidirecional entre classes Pascal e estruturas TParameter.
    Permite converter Classe → TParameterList e TParameterList → Classe, além de
    acesso individual a valores de parâmetros usando chaves.
    ============================================================================= }
  
  TAttributeMapper = class(TInterfacedObject, IAttributeMapper)
  private
    FRttiContext: TRttiContext;
    FParser: TAttributeParser;
    
    // Métodos auxiliares privados
    { Obtém TRttiType da classe
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: TRttiType ou nil se RTTI não disponível
      Exceção: EParametersAttributeException se RTTI não disponível }
    function GetRttiType(const AClassType: TClass): TRttiType;
    
    { Obtém propriedade RTTI pela chave do parâmetro
      Parâmetros:
        ARttiType: Tipo RTTI da classe
        AParameterKey: Chave do parâmetro (não nome da propriedade)
      Retorno: TRttiProperty ou nil se não encontrado
      Nota: Busca propriedade que tem [ParameterKey] com chave correspondente }
    function GetRttiPropertyByKey(const ARttiType: TRttiType; const AParameterKey: string): TRttiProperty;
    
    { Define valor de propriedade usando RTTI
      Parâmetros:
        AInstance: Instância da classe
        AProperty: Propriedade RTTI
        AValue: Valor a ser definido (Variant)
      Retorno: True se sucesso, False se erro }
    function SetPropertyValue(const AInstance: TObject; const AProperty: TRttiProperty; const AValue: Variant): Boolean;
    
    { Obtém valor de propriedade usando RTTI
      Parâmetros:
        AInstance: Instância da classe
        AProperty: Propriedade RTTI
      Retorno: Valor da propriedade (Variant) ou Null se erro }
    function GetPropertyValue(const AInstance: TObject; const AProperty: TRttiProperty): Variant;
    
    { Converte Variant para string conforme TParameterValueType
      Parâmetros:
        AValue: Valor (Variant)
        AValueType: Tipo do valor
      Retorno: String formatada }
    function VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;
  public
    { Cria instância de TAttributeMapper
      Inicializa contexto RTTI e parser de atributos }
    constructor Create;
    
    { Destrói instância e libera recursos }
    destructor Destroy; override;
    
    // Factory
    { Cria nova instância de IAttributeMapper
      Retorno: Interface IAttributeMapper }
    class function New: IAttributeMapper;
    
    // IAttributeMapper implementation
    { Converte classe em TParameterList (sem valores)
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: TParameterList com estrutura completa
      Nota: Delega para TAttributeParser.ParseClass }
    function MapClassToParameters(const AClassType: TClass): TParameterList; overload;
    
    { Converte instância em TParameterList (com valores)
      Parâmetros:
        AInstance: Instância da classe
      Retorno: TParameterList com estrutura e valores
      Nota: Delega para TAttributeParser.ParseClass }
    function MapClassToParameters(const AInstance: TObject): TParameterList; overload;
    
    { Preenche instância da classe com dados de TParameterList
      Parâmetros:
        AParameters: TParameterList com dados
        AInstance: Instância a ser preenchida
      Retorno: Self (para Fluent API)
      Nota: Mapeia valores de TParameterList para propriedades usando RTTI e [ParameterKey] }
    function MapParametersToClass(AParameters: TParameterList; AInstance: TObject): IAttributeMapper; overload;
    
    { Define valor de parâmetro na classe usando chave do parâmetro
      Parâmetros:
        AInstance: Instância da classe
        AParameterKey: Chave do parâmetro (não nome da propriedade)
        AValue: Valor a ser definido (Variant)
      Retorno: Self (para Fluent API)
      Nota: Busca propriedade pelo atributo [ParameterKey] correspondente }
    function SetParameterValue(AInstance: TObject; const AParameterKey: string; const AValue: Variant): IAttributeMapper; overload;
    
    { Obtém valor de parâmetro da classe usando chave do parâmetro
      Parâmetros:
        AInstance: Instância da classe
        AParameterKey: Chave do parâmetro (não nome da propriedade)
      Retorno: Valor da propriedade (Variant) ou Null se não encontrado
      Nota: Busca propriedade pelo atributo [ParameterKey] correspondente }
    function GetParameterValue(const AInstance: TObject; const AParameterKey: string): Variant; overload;
  end;

implementation

{ ===============================================================================
  TAttributeParser - Implementation
  =============================================================================== }

constructor TAttributeParser.Create;
begin
  inherited Create;
  FRttiContext := TRttiContext.Create;
end;

destructor TAttributeParser.Destroy;
begin
  FRttiContext.Free;
  inherited Destroy;
end;

class function TAttributeParser.New: IAttributeParser;
begin
  Result := TAttributeParser.Create;
end;

function TAttributeParser.GetRttiType(const AClassType: TClass): TRttiType;
begin
  Result := FRttiContext.GetType(AClassType);
  if Result = nil then
    raise CreateRTTINotAvailableException(AClassType.ClassName, 'GetRttiType');
end;

function TAttributeParser.GetParameterAttribute(const ARttiType: TRttiType): ParameterAttribute;
var
  LAttr: TCustomAttribute;
begin
  Result := nil;
  for LAttr in ARttiType.GetAttributes do
  begin
    if LAttr is ParameterAttribute then
    begin
      Result := ParameterAttribute(LAttr);
      Exit;
    end;
  end;
end;

function TAttributeParser.GetContratoIDAttribute(const ARttiType: TRttiType): ContratoIDAttribute;
var
  LAttr: TCustomAttribute;
begin
  Result := nil;
  for LAttr in ARttiType.GetAttributes do
  begin
    if LAttr is ContratoIDAttribute then
    begin
      Result := ContratoIDAttribute(LAttr);
      Exit;
    end;
  end;
end;

function TAttributeParser.GetProdutoIDAttribute(const ARttiType: TRttiType): ProdutoIDAttribute;
var
  LAttr: TCustomAttribute;
begin
  Result := nil;
  for LAttr in ARttiType.GetAttributes do
  begin
    if LAttr is ProdutoIDAttribute then
    begin
      Result := ProdutoIDAttribute(LAttr);
      Exit;
    end;
  end;
end;

function TAttributeParser.GetParameterSourceAttribute(const ARttiType: TRttiType): ParameterSourceAttribute;
var
  LAttr: TCustomAttribute;
begin
  Result := nil;
  for LAttr in ARttiType.GetAttributes do
  begin
    if LAttr is ParameterSourceAttribute then
    begin
      Result := ParameterSourceAttribute(LAttr);
      Exit;
    end;
  end;
end;

function TAttributeParser.HasAttribute<T>(const ARttiProperty: TRttiProperty): Boolean;
var
  LAttr: TCustomAttribute;
begin
  Result := False;
  for LAttr in ARttiProperty.GetAttributes do
  begin
    if LAttr is T then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TAttributeParser.GetAttribute<T>(const ARttiProperty: TRttiProperty): T;
var
  LAttr: TCustomAttribute;
begin
  Result := nil;
  for LAttr in ARttiProperty.GetAttributes do
  begin
    if LAttr is T then
    begin
      Result := T(LAttr);
      Exit;
    end;
  end;
end;

function TAttributeParser.ConvertRttiTypeToValueType(const ARttiType: TRttiType): TParameterValueType;
var
  LTypeName: string;
begin
  // Mapeamento básico de tipos RTTI para TParameterValueType
  case ARttiType.TypeKind of
    tkInteger, tkInt64:
      Result := pvtInteger;
    tkFloat:
    begin
      // Verifica se é TDateTime
      LTypeName := ARttiType.Name;
      if (SameText(LTypeName, 'TDateTime')) or (SameText(LTypeName, 'TDate')) or (SameText(LTypeName, 'TTime')) then
        Result := pvtDateTime
      else
        Result := pvtFloat;
    end;
    tkEnumeration:
    begin
      // Verifica se é Boolean
      LTypeName := ARttiType.Name;
      if SameText(LTypeName, 'Boolean') then
        Result := pvtBoolean
      else
        Result := pvtInteger; // Enum como Integer
    end;
    tkString, tkLString, tkWString, tkUString:
      Result := pvtString;
    tkChar, tkWChar:
      Result := pvtString;
    else
      Result := pvtString; // Default
  end;
end;

function TAttributeParser.GetParameterKey(const ARttiProperty: TRttiProperty): string;
var
  LKeyAttr: ParameterKeyAttribute;
begin
  Result := '';
  LKeyAttr := GetAttribute<ParameterKeyAttribute>(ARttiProperty);
  if LKeyAttr <> nil then
    Result := LKeyAttr.Key;
end;

function TAttributeParser.GetParameterValue(const ARttiProperty: TRttiProperty): Variant;
var
  LValueAttr: ParameterValueAttribute;
begin
  Result := Null;
  LValueAttr := GetAttribute<ParameterValueAttribute>(ARttiProperty);
  if LValueAttr <> nil then
    Result := LValueAttr.Value;
end;

function TAttributeParser.GetParameterDescription(const ARttiProperty: TRttiProperty): string;
var
  LDescAttr: ParameterDescriptionAttribute;
begin
  Result := '';
  LDescAttr := GetAttribute<ParameterDescriptionAttribute>(ARttiProperty);
  if LDescAttr <> nil then
    Result := LDescAttr.Description;
end;

function TAttributeParser.GetParameterValueType(const ARttiProperty: TRttiProperty): TParameterValueType;
var
  LTypeAttr: ParameterTypeAttribute;
begin
  // Verifica se tem atributo [ParameterType]
  LTypeAttr := GetAttribute<ParameterTypeAttribute>(ARttiProperty);
  if LTypeAttr <> nil then
    Result := LTypeAttr.ValueType
  else
    // Infere do tipo da propriedade
    Result := ConvertRttiTypeToValueType(ARttiProperty.PropertyType);
end;

function TAttributeParser.GetParameterOrder(const ARttiProperty: TRttiProperty): Integer;
var
  LOrderAttr: ParameterOrderAttribute;
begin
  Result := DEFAULT_PARAMETER_ORDER;
  LOrderAttr := GetAttribute<ParameterOrderAttribute>(ARttiProperty);
  if LOrderAttr <> nil then
    Result := LOrderAttr.Order;
end;

function TAttributeParser.IsParameterRequired(const ARttiProperty: TRttiProperty): Boolean;
begin
  Result := HasAttribute<ParameterRequiredAttribute>(ARttiProperty);
end;

function TAttributeParser.ParsePropertyToParameter(const ARttiProperty: TRttiProperty; const AInstance: TObject; 
  const ATitulo: string; const AContratoID, AProdutoID: Integer): TParameter;
var
  LKey: string;
  LValue: string;
  LValueVariant: Variant;
  LValueType: TParameterValueType;
  LDescription: string;
  LOrder: Integer;
begin
  Result := nil;
  
  // Verifica se propriedade tem [ParameterKey]
  LKey := GetParameterKey(ARttiProperty);
  if LKey = '' then
    Exit; // Propriedade não mapeada
  
  // Cria TParameter
  Result := TParameter.Create;
  try
    Result.Titulo := ATitulo;
    Result.Name := LKey;
    Result.ContratoID := AContratoID;
    Result.ProdutoID := AProdutoID;
    Result.Ordem := GetParameterOrder(ARttiProperty);
    Result.Description := GetParameterDescription(ARttiProperty);
    Result.ValueType := GetParameterValueType(ARttiProperty);
    Result.Ativo := True;
    Result.CreatedAt := Now;
    Result.UpdatedAt := Now;
    
    // Obtém valor
    if AInstance <> nil then
    begin
      try
        LValueVariant := ARttiProperty.GetValue(AInstance).AsVariant;
        LValueType := Result.ValueType;
        LValue := VariantToString(LValueVariant, LValueType);
        Result.Value := LValue;
      except
        // Se não conseguir obter valor, usa valor padrão
        LValueVariant := GetParameterValue(ARttiProperty);
        if not VarIsNull(LValueVariant) then
        begin
          LValueType := Result.ValueType;
          LValue := VariantToString(LValueVariant, LValueType);
          Result.Value := LValue;
        end;
      end;
    end
    else
    begin
      // Sem instância, usa valor padrão
      LValueVariant := GetParameterValue(ARttiProperty);
      if not VarIsNull(LValueVariant) then
      begin
        LValueType := Result.ValueType;
        LValue := VariantToString(LValueVariant, LValueType);
        Result.Value := LValue;
      end;
    end;
  except
    Result.Free;
    Result := nil;
    raise;
  end;
end;

function TAttributeParser.VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;
var
  LIntValue: Int64;
  LFloatValue: Double;
  LBoolValue: Boolean;
begin
  if VarIsNull(AValue) or VarIsEmpty(AValue) then
  begin
    Result := '';
    Exit;
  end;
  
  case AValueType of
    pvtString:
      Result := VarToStr(AValue);
    pvtInteger:
    begin
      try
        LIntValue := VarAsType(AValue, varInt64);
        Result := IntToStr(LIntValue);
      except
        Result := IntToStr(Integer(AValue));
      end;
    end;
    pvtFloat:
    begin
      try
        LFloatValue := VarAsType(AValue, varDouble);
        Result := FloatToStr(LFloatValue);
      except
        Result := FloatToStr(Double(AValue));
      end;
    end;
    pvtBoolean:
    begin
      try
        LBoolValue := VarAsType(AValue, varBoolean);
        if LBoolValue then
          Result := 'True'
        else
          Result := 'False';
      except
        if Boolean(AValue) then
          Result := 'True'
        else
          Result := 'False';
      end;
    end;
    pvtDateTime:
      Result := DateTimeToStr(VarToDateTime(AValue));
    pvtJSON:
      Result := VarToStr(AValue);
    else
      Result := VarToStr(AValue);
  end;
end;

function TAttributeParser.CreateParameterNotFoundException(const AClassName, AOperation: string): EParametersAttributeException;
begin
  Result := EParametersAttributeException.Create(
    Format(MSG_ATTRIBUTE_PARAMETER_NOT_FOUND, [AClassName]),
    ERR_ATTRIBUTE_PARAMETER_NOT_FOUND_CODE,
    AOperation
  );
end;

function TAttributeParser.CreateRTTINotAvailableException(const AClassName, AOperation: string): EParametersAttributeException;
var
  LMsg: string;
begin
  if AClassName = '' then
    LMsg := ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE
  else
    LMsg := Format(MSG_ATTRIBUTE_RTTI_NOT_AVAILABLE, [AClassName]);
  
  Result := EParametersAttributeException.Create(
    LMsg,
    ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE_CODE,
    AOperation
  );
end;

function TAttributeParser.ParseClass(const AInstance: TObject): TParameterList;
var
  LClassType: TClass;
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
  LParam: TParameter;
  LParamAttr: ParameterAttribute;
  LContratoIDAttr: ContratoIDAttribute;
  LProdutoIDAttr: ProdutoIDAttribute;
  LTitulo: string;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'ParseClass');
  
  LClassType := AInstance.ClassType;
  Result := ParseClass(LClassType);
  
  // Preenche valores dos parâmetros a partir da instância
  LRttiType := GetRttiType(LClassType);
  LParamAttr := GetParameterAttribute(LRttiType);
  if LParamAttr = nil then
    raise CreateParameterNotFoundException(LClassType.ClassName, 'ParseClass');
  
  LTitulo := LParamAttr.Title;
  LContratoIDAttr := GetContratoIDAttribute(LRttiType);
  if LContratoIDAttr <> nil then
    LContratoID := LContratoIDAttr.ContratoID
  else
    LContratoID := DEFAULT_CONTRATO_ID;
  
  LProdutoIDAttr := GetProdutoIDAttribute(LRttiType);
  if LProdutoIDAttr <> nil then
    LProdutoID := LProdutoIDAttr.ProdutoID
  else
    LProdutoID := DEFAULT_PRODUTO_ID;
  
  // Atualiza valores dos parâmetros existentes
  for LProperty in LRttiType.GetProperties do
  begin
    LParam := ParsePropertyToParameter(LProperty, AInstance, LTitulo, LContratoID, LProdutoID);
    if LParam <> nil then
    begin
      // Busca parâmetro existente na lista e atualiza valor
      var I: Integer;
      for I := 0 to Result.Count - 1 do
      begin
        if SameText(Result[I].Name, LParam.Name) then
        begin
          Result[I].Value := LParam.Value;
          LParam.Free;
          Break;
        end;
      end;
    end;
  end;
end;

function TAttributeParser.ParseClass(const AClassType: TClass): TParameterList;
var
  LRttiType: TRttiType;
  LParamAttr: ParameterAttribute;
  LContratoIDAttr: ContratoIDAttribute;
  LProdutoIDAttr: ProdutoIDAttribute;
  LProperty: TRttiProperty;
  LParam: TParameter;
  LTitulo: string;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  // Obtém RTTI da classe
  LRttiType := GetRttiType(AClassType);
  
  // Obtém atributo [Parameter]
  LParamAttr := GetParameterAttribute(LRttiType);
  if LParamAttr = nil then
    raise CreateParameterNotFoundException(AClassType.ClassName, 'ParseClass');
  
  LTitulo := LParamAttr.Title;
  
  // Obtém atributo [ContratoID] (opcional)
  LContratoIDAttr := GetContratoIDAttribute(LRttiType);
  if LContratoIDAttr <> nil then
    LContratoID := LContratoIDAttr.ContratoID
  else
    LContratoID := DEFAULT_CONTRATO_ID;
  
  // Obtém atributo [ProdutoID] (opcional)
  LProdutoIDAttr := GetProdutoIDAttribute(LRttiType);
  if LProdutoIDAttr <> nil then
    LProdutoID := LProdutoIDAttr.ProdutoID
  else
    LProdutoID := DEFAULT_PRODUTO_ID;
  
  // Cria TParameterList
  Result := TParameterList.Create;
  
  // Itera sobre propriedades
  for LProperty in LRttiType.GetProperties do
  begin
    LParam := ParsePropertyToParameter(LProperty, nil, LTitulo, LContratoID, LProdutoID);
    if LParam <> nil then
      Result.Add(LParam);
  end;
end;

function TAttributeParser.GetClassTitle(const AInstance: TObject): string;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'GetClassTitle');
  Result := GetClassTitle(AInstance.ClassType);
end;

function TAttributeParser.GetClassTitle(const AClassType: TClass): string;
var
  LRttiType: TRttiType;
  LParamAttr: ParameterAttribute;
begin
  LRttiType := GetRttiType(AClassType);
  LParamAttr := GetParameterAttribute(LRttiType);
  if LParamAttr = nil then
    raise CreateParameterNotFoundException(AClassType.ClassName, 'GetClassTitle');
  Result := LParamAttr.Title;
end;

function TAttributeParser.GetClassContratoID(const AInstance: TObject): Integer;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'GetClassContratoID');
  Result := GetClassContratoID(AInstance.ClassType);
end;

function TAttributeParser.GetClassContratoID(const AClassType: TClass): Integer;
var
  LRttiType: TRttiType;
  LContratoIDAttr: ContratoIDAttribute;
begin
  Result := DEFAULT_CONTRATO_ID;
  LRttiType := GetRttiType(AClassType);
  LContratoIDAttr := GetContratoIDAttribute(LRttiType);
  if LContratoIDAttr <> nil then
    Result := LContratoIDAttr.ContratoID;
end;

function TAttributeParser.GetClassProdutoID(const AInstance: TObject): Integer;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'GetClassProdutoID');
  Result := GetClassProdutoID(AInstance.ClassType);
end;

function TAttributeParser.GetClassProdutoID(const AClassType: TClass): Integer;
var
  LRttiType: TRttiType;
  LProdutoIDAttr: ProdutoIDAttribute;
begin
  Result := DEFAULT_PRODUTO_ID;
  LRttiType := GetRttiType(AClassType);
  LProdutoIDAttr := GetProdutoIDAttribute(LRttiType);
  if LProdutoIDAttr <> nil then
    Result := LProdutoIDAttr.ProdutoID;
end;

function TAttributeParser.GetClassSource(const AInstance: TObject): TParameterSource;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'GetClassSource');
  Result := GetClassSource(AInstance.ClassType);
end;

function TAttributeParser.GetClassSource(const AClassType: TClass): TParameterSource;
var
  LRttiType: TRttiType;
  LSourceAttr: ParameterSourceAttribute;
begin
  Result := TParameterSource(DEFAULT_PARAMETER_SOURCE);
  LRttiType := GetRttiType(AClassType);
  LSourceAttr := GetParameterSourceAttribute(LRttiType);
  if LSourceAttr <> nil then
    Result := LSourceAttr.Source;
end;

function TAttributeParser.GetParameterProperties(const AInstance: TObject): TStringArray;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'GetParameterProperties');
  Result := GetParameterProperties(AInstance.ClassType);
end;

function TAttributeParser.GetParameterProperties(const AClassType: TClass): TStringArray;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
  LKey: string;
  LCount: Integer;
begin
  SetLength(Result, 0);
  LRttiType := GetRttiType(AClassType);
  LCount := 0;
  
  for LProperty in LRttiType.GetProperties do
  begin
    LKey := GetParameterKey(LProperty);
    if LKey <> '' then
    begin
      SetLength(Result, LCount + 1);
      Result[LCount] := LProperty.Name;
      Inc(LCount);
    end;
  end;
end;

function TAttributeParser.GetPropertyKey(const AInstance: TObject; const APropertyName: string): string;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := '';
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := LRttiType.GetProperty(APropertyName);
  if LProperty <> nil then
    Result := GetParameterKey(LProperty);
end;

function TAttributeParser.GetPropertyDefaultValue(const AInstance: TObject; const APropertyName: string): Variant;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := Null;
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := LRttiType.GetProperty(APropertyName);
  if LProperty <> nil then
    Result := GetParameterValue(LProperty);
end;

function TAttributeParser.GetPropertyDescription(const AInstance: TObject; const APropertyName: string): string;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := '';
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := LRttiType.GetProperty(APropertyName);
  if LProperty <> nil then
    Result := GetParameterDescription(LProperty);
end;

function TAttributeParser.GetPropertyValueType(const AInstance: TObject; const APropertyName: string): TParameterValueType;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := pvtString;
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := LRttiType.GetProperty(APropertyName);
  if LProperty <> nil then
    Result := GetParameterValueType(LProperty);
end;

function TAttributeParser.GetPropertyOrder(const AInstance: TObject; const APropertyName: string): Integer;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := DEFAULT_PARAMETER_ORDER;
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := LRttiType.GetProperty(APropertyName);
  if LProperty <> nil then
    Result := GetParameterOrder(LProperty);
end;

function TAttributeParser.IsPropertyRequired(const AInstance: TObject; const APropertyName: string): Boolean;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := False;
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := LRttiType.GetProperty(APropertyName);
  if LProperty <> nil then
    Result := IsParameterRequired(LProperty);
end;

function TAttributeParser.ValidateClass(const AInstance: TObject): Boolean;
begin
  if AInstance = nil then
    raise CreateRTTINotAvailableException('', 'ValidateClass');
  Result := ValidateClass(AInstance.ClassType);
end;

function TAttributeParser.ValidateClass(const AClassType: TClass): Boolean;
var
  LRttiType: TRttiType;
  LParamAttr: ParameterAttribute;
begin
  Result := False;
  try
    LRttiType := GetRttiType(AClassType);
    LParamAttr := GetParameterAttribute(LRttiType);
    Result := (LParamAttr <> nil);
  except
    Result := False;
  end;
end;

{ ===============================================================================
  TAttributeMapper - Implementation
  =============================================================================== }

constructor TAttributeMapper.Create;
begin
  inherited Create;
  FRttiContext := TRttiContext.Create;
  FParser := TAttributeParser.Create;
end;

destructor TAttributeMapper.Destroy;
begin
  FRttiContext.Free;
  inherited Destroy;
end;

class function TAttributeMapper.New: IAttributeMapper;
begin
  Result := TAttributeMapper.Create;
end;

function TAttributeMapper.GetRttiType(const AClassType: TClass): TRttiType;
begin
  Result := FRttiContext.GetType(AClassType);
  if Result = nil then
    raise EParametersAttributeException.Create(
      Format(MSG_ATTRIBUTE_RTTI_NOT_AVAILABLE, [AClassType.ClassName]),
      ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE_CODE,
      'GetRttiType'
    );
end;

function TAttributeMapper.GetRttiPropertyByKey(const ARttiType: TRttiType; const AParameterKey: string): TRttiProperty;
var
  LProperty: TRttiProperty;
  LKeyAttr: ParameterKeyAttribute;
begin
  Result := nil;
  for LProperty in ARttiType.GetProperties do
  begin
    LKeyAttr := FParser.GetAttribute<ParameterKeyAttribute>(LProperty);
    if (LKeyAttr <> nil) and (SameText(LKeyAttr.Key, AParameterKey)) then
    begin
      Result := LProperty;
      Exit;
    end;
  end;
end;

function TAttributeMapper.SetPropertyValue(const AInstance: TObject; const AProperty: TRttiProperty; const AValue: Variant): Boolean;
begin
  Result := False;
  try
    AProperty.SetValue(AInstance, TValue.FromVariant(AValue));
    Result := True;
  except
    Result := False;
  end;
end;

function TAttributeMapper.GetPropertyValue(const AInstance: TObject; const AProperty: TRttiProperty): Variant;
begin
  try
    Result := AProperty.GetValue(AInstance).AsVariant;
  except
    Result := Null;
  end;
end;

function TAttributeMapper.VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;
var
  LIntValue: Int64;
  LFloatValue: Double;
  LBoolValue: Boolean;
begin
  if VarIsNull(AValue) or VarIsEmpty(AValue) then
  begin
    Result := '';
    Exit;
  end;
  
  case AValueType of
    pvtString:
      Result := VarToStr(AValue);
    pvtInteger:
    begin
      try
        LIntValue := VarAsType(AValue, varInt64);
        Result := IntToStr(LIntValue);
      except
        Result := IntToStr(Integer(AValue));
      end;
    end;
    pvtFloat:
    begin
      try
        LFloatValue := VarAsType(AValue, varDouble);
        Result := FloatToStr(LFloatValue);
      except
        Result := FloatToStr(Double(AValue));
      end;
    end;
    pvtBoolean:
    begin
      try
        LBoolValue := VarAsType(AValue, varBoolean);
        if LBoolValue then
          Result := 'True'
        else
          Result := 'False';
      except
        if Boolean(AValue) then
          Result := 'True'
        else
          Result := 'False';
      end;
    end;
    pvtDateTime:
      Result := DateTimeToStr(VarToDateTime(AValue));
    pvtJSON:
      Result := VarToStr(AValue);
    else
      Result := VarToStr(AValue);
  end;
end;

function TAttributeMapper.MapClassToParameters(const AInstance: TObject): TParameterList;
begin
  Result := FParser.ParseClass(AInstance);
end;

function TAttributeMapper.MapClassToParameters(const AClassType: TClass): TParameterList;
begin
  Result := FParser.ParseClass(AClassType);
end;

function TAttributeMapper.MapParametersToClass(AParameters: TParameterList; AInstance: TObject): IAttributeMapper;
var
  LRttiType: TRttiType;
  LParam: TParameter;
  LProperty: TRttiProperty;
  LValue: Variant;
  I: Integer;
begin
  Result := Self;
  
  if (AParameters = nil) or (AInstance = nil) then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  
  // Itera sobre parâmetros
  for I := 0 to AParameters.Count - 1 do
  begin
    LParam := AParameters[I];
    if LParam <> nil then
    begin
      LProperty := GetRttiPropertyByKey(LRttiType, LParam.Name);
      if LProperty <> nil then
      begin
        // Converte string para Variant conforme ValueType
        case LParam.ValueType of
          pvtString:
            LValue := LParam.Value;
          pvtInteger:
            LValue := StrToIntDef(LParam.Value, 0);
          pvtFloat:
            LValue := StrToFloatDef(LParam.Value, 0.0);
          pvtBoolean:
            LValue := SameText(LParam.Value, 'True') or SameText(LParam.Value, '1');
          pvtDateTime:
            LValue := StrToDateTimeDef(LParam.Value, Now);
          pvtJSON:
            LValue := LParam.Value;
          else
            LValue := LParam.Value;
        end;
        
        SetPropertyValue(AInstance, LProperty, LValue);
      end;
    end;
  end;
end;

function TAttributeMapper.SetParameterValue(AInstance: TObject; const AParameterKey: string; const AValue: Variant): IAttributeMapper;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := Self;
  
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := GetRttiPropertyByKey(LRttiType, AParameterKey);
  
  if LProperty <> nil then
    SetPropertyValue(AInstance, LProperty, AValue);
end;

function TAttributeMapper.GetParameterValue(const AInstance: TObject; const AParameterKey: string): Variant;
var
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
begin
  Result := Null;
  
  if AInstance = nil then
    Exit;
  
  LRttiType := GetRttiType(AInstance.ClassType);
  LProperty := GetRttiPropertyByKey(LRttiType, AParameterKey);
  
  if LProperty <> nil then
    Result := GetPropertyValue(AInstance, LProperty);
end;

end.
