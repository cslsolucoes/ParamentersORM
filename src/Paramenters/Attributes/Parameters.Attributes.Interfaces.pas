unit Parameters.Attributes.Interfaces;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ ===============================================================================
  Parameters.Attributes.Interfaces - Interfaces para Sistema de Attributes
  
  Descrição:
  Define interfaces para parsing e mapeamento de atributos via RTTI.
  
  Hierarquia:
  Attributes (Runtime) → IAttributeParser → IAttributeMapper → IParameters
  
  Interfaces:
  - IAttributeParser: Parsing de classes com atributos para TParameter/TParameterList
  - IAttributeMapper: Mapeamento bidirecional Classe ↔ TParameter
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 03/01/2026
  =============================================================================== }

interface

{$I ../../Paramenters.Defines.inc}

uses
  Parameters.Interfaces,
  Parameters.Types,
{$IF DEFINED(FPC)}
  TypInfo, Variants;
{$ELSE}
  System.TypInfo, System.Variants;
{$ENDIF}

type
  { Array de strings para retorno de métodos }
  {$IF DEFINED(FPC)}
    TStringArray = array of string;
  {$ELSE}
    TStringArray = System.TArray<string>;
  {$ENDIF}

type
  { =============================================================================
    IAttributeParser - Interface para parsing de atributos via RTTI
    =============================================================================
    Responsável por converter classes Pascal com atributos em estruturas
    TParameter e TParameterList do Parameters ORM. Usa RTTI para ler atributos em runtime.
    
    Funcionalidades:
    - Parsing de classes com atributos para TParameter/TParameterList
    - Extração de informações de classe (título, ContratoID, ProdutoID)
    - Identificação de propriedades com [ParameterKey]
    - Validação de atributos
    ============================================================================= }
  
  IAttributeParser = interface
    ['{B1C2D3E4-F5A6-7890-ABCD-EF1234567890}']

    // ========== PARSING DE CLASSE ==========
    { Converte classe com atributos em TParameterList completa
      Parâmetros:
        AClassType: Tipo da classe (TClass) a ser parseada
      Retorno: TParameterList com todos os parâmetros mapeados
      Exceção: EParametersAttributeException se classe não tiver [Parameter] ou RTTI
      Exemplo:
        var ParamList: TParameterList;
        ParamList := Parser.ParseClass(TConfigERP); }
    function ParseClass(const AClassType: TClass): TParameterList; overload;
    
    { Converte instância de classe com atributos em TParameterList completa (com valores)
      Parâmetros:
        AInstance: Instância da classe a ser parseada
      Retorno: TParameterList com estrutura e valores da instância
      Nota: Preenche valores dos parâmetros a partir das propriedades da instância }
    function ParseClass(const AInstance: TObject): TParameterList; overload;
    
    // ========== INFORMAÇÕES DE CLASSE ==========
    { Obtém título da classe (do atributo [Parameter])
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: Título ou string vazia se não encontrado
      Exceção: EParametersAttributeException se não tiver [Parameter] }
    function GetClassTitle(const AClassType: TClass): string; overload;
    
    { Obtém título da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: Título }
    function GetClassTitle(const AInstance: TObject): string; overload;
    
    { Obtém ContratoID da classe (do atributo [ContratoID])
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: ContratoID ou DEFAULT_CONTRATO_ID se não encontrado }
    function GetClassContratoID(const AClassType: TClass): Integer; overload;
    
    { Obtém ContratoID da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: ContratoID }
    function GetClassContratoID(const AInstance: TObject): Integer; overload;
    
    { Obtém ProdutoID da classe (do atributo [ProdutoID])
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: ProdutoID ou DEFAULT_PRODUTO_ID se não encontrado }
    function GetClassProdutoID(const AClassType: TClass): Integer; overload;
    
    { Obtém ProdutoID da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: ProdutoID }
    function GetClassProdutoID(const AInstance: TObject): Integer; overload;
    
    { Obtém fonte de dados da classe (do atributo [ParameterSource])
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: Fonte de dados ou DEFAULT_PARAMETER_SOURCE se não encontrado }
    function GetClassSource(const AClassType: TClass): TParameterSource; overload;
    
    { Obtém fonte de dados da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: Fonte de dados }
    function GetClassSource(const AInstance: TObject): TParameterSource; overload;
    
    // ========== INFORMAÇÕES DE PROPRIEDADES ==========
    { Obtém lista de todas as propriedades com [ParameterKey] da classe
      Parâmetros:
        AClassType: Tipo da classe
      Retorno: Array de strings com nomes das propriedades mapeadas }
    function GetParameterProperties(const AClassType: TClass): TStringArray; overload;
    
    { Obtém lista de todas as propriedades com [ParameterKey] da instância
      Parâmetros:
        AInstance: Instância da classe
      Retorno: Array de strings com nomes das propriedades mapeadas }
    function GetParameterProperties(const AInstance: TObject): TStringArray; overload;
    
    { Obtém chave do parâmetro da propriedade (do atributo [ParameterKey])
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Chave do parâmetro ou string vazia se não encontrado }
    function GetPropertyKey(const AInstance: TObject; const APropertyName: string): string;
    
    { Obtém valor padrão da propriedade (do atributo [ParameterValue])
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Valor padrão (Variant) ou Null se não encontrado }
    function GetPropertyDefaultValue(const AInstance: TObject; const APropertyName: string): Variant;
    
    { Obtém descrição da propriedade (do atributo [ParameterDescription])
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Descrição ou string vazia se não encontrado }
    function GetPropertyDescription(const AInstance: TObject; const APropertyName: string): string;
    
    { Obtém tipo do valor da propriedade (do atributo [ParameterType] ou inferido)
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Tipo do valor ou pvtString se não encontrado }
    function GetPropertyValueType(const AInstance: TObject; const APropertyName: string): TParameterValueType;
    
    { Obtém ordem da propriedade (do atributo [ParameterOrder])
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: Ordem ou DEFAULT_PARAMETER_ORDER se não encontrado }
    function GetPropertyOrder(const AInstance: TObject; const APropertyName: string): Integer;
    
    { Verifica se propriedade é obrigatória (tem [ParameterRequired])
      Parâmetros:
        AInstance: Instância da classe
        APropertyName: Nome da propriedade
      Retorno: True se obrigatória, False caso contrário }
    function IsPropertyRequired(const AInstance: TObject; const APropertyName: string): Boolean;
    
    // ========== VALIDAÇÃO ==========
    { Valida se classe tem atributos corretos (pelo menos [Parameter])
      Parâmetros:
        AClassType: Tipo da classe a validar
      Retorno: True se classe tem [Parameter] e RTTI disponível, False caso contrário }
    function ValidateClass(const AClassType: TClass): Boolean; overload;
    
    { Valida se instância tem atributos corretos
      Parâmetros:
        AInstance: Instância da classe a validar
      Retorno: True se válida, False caso contrário }
    function ValidateClass(const AInstance: TObject): Boolean; overload;
  end;

  { =============================================================================
    IAttributeMapper - Interface para mapeamento bidirecional Classe ↔ TParameter
    =============================================================================
    Responsável por mapear valores entre classes Pascal e estruturas TParameter.
    Permite conversão bidirecional: Classe → TParameter e TParameter → Classe.
    
    Funcionalidades:
    - Conversão Classe → TParameterList (com valores)
    - Conversão TParameterList → Classe (preenche propriedades)
    - Acesso individual a valores de parâmetros
    ============================================================================= }
  
  IAttributeMapper = interface
    ['{C2D3E4F5-A6B7-8901-CDEF-123456789012}']

    // ========== CLASSE → TParameterList ==========
    { Converte classe em TParameterList completa (sem valores)
      Parâmetros:
        AClassType: Tipo da classe (TClass) a ser mapeada
      Retorno: TParameterList com estrutura completa da classe
      Nota: Usa IAttributeParser internamente para parsing }
    function MapClassToParameters(const AClassType: TClass): TParameterList; overload;
    
    { Converte instância de classe em TParameterList completa (com valores)
      Parâmetros:
        AInstance: Instância da classe a ser mapeada
      Retorno: TParameterList com estrutura e valores da instância
      Exemplo:
        var Config: TConfigERP;
        var ParamList: TParameterList;
        Config := TConfigERP.Create;
        Config.DatabaseHost := 'localhost';
        ParamList := Mapper.MapClassToParameters(Config); }
    function MapClassToParameters(const AInstance: TObject): TParameterList; overload;
    
    // ========== TParameterList → CLASSE ==========
    { Preenche instância da classe com dados de TParameterList
      Parâmetros:
        AParameters: TParameterList com dados a serem mapeados
        AInstance: Instância da classe a ser preenchida
      Retorno: Self (para Fluent API)
      Nota: Mapeia valores de TParameterList para propriedades da instância usando RTTI
      Exemplo:
        var Config: TConfigERP;
        var ParamList: TParameterList;
        Config := TConfigERP.Create;
        Mapper.MapParametersToClass(ParamList, Config);
        // Agora Config.DatabaseHost, Config.DatabasePort, etc. estão preenchidos }
    function MapParametersToClass(AParameters: TParameterList; AInstance: TObject): IAttributeMapper; overload;
    
    // ========== VALORES ==========
    { Define valor de parâmetro na classe usando chave do parâmetro
      Parâmetros:
        AInstance: Instância da classe
        AParameterKey: Chave do parâmetro (não nome da propriedade)
        AValue: Valor a ser definido (Variant)
      Retorno: Self (para Fluent API)
      Nota: Busca propriedade pelo atributo [ParameterKey] correspondente
      Exemplo:
        Mapper.SetParameterValue(Config, 'database_host', 'localhost');
        // Define Config.DatabaseHost se [ParameterKey('database_host')] estiver na propriedade }
    function SetParameterValue(AInstance: TObject; const AParameterKey: string; const AValue: Variant): IAttributeMapper; overload;
    
    { Obtém valor de parâmetro da classe usando chave do parâmetro
      Parâmetros:
        AInstance: Instância da classe
        AParameterKey: Chave do parâmetro (não nome da propriedade)
      Retorno: Valor da propriedade (Variant) ou Null se não encontrado
      Nota: Busca propriedade pelo atributo [ParameterKey] correspondente
      Exemplo:
        var Host: Variant;
        Host := Mapper.GetParameterValue(Config, 'database_host');
        // Retorna Config.DatabaseHost se [ParameterKey('database_host')] estiver na propriedade }
    function GetParameterValue(const AInstance: TObject; const AParameterKey: string): Variant; overload;
  end;

implementation

end.
