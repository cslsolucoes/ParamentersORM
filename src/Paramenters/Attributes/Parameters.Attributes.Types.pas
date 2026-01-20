unit Parameters.Attributes.Types;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ ===============================================================================
  Parameters.Attributes.Types - Definição de Atributos para Mapeamento Runtime
  
  Descrição:
  Define todos os atributos (Custom Attributes) usados para mapeamento
  declarativo de classes Pascal para parâmetros de configuração.
  
  Hierarquia:
  Attributes (Runtime) → IAttributeParser → IAttributeMapper → IParameters
  
  Atributos Suportados:
  - Classe: Parameter, ContratoID, ProdutoID, ParameterSource
  - Propriedade: ParameterKey, ParameterValue, ParameterDescription, 
                 ParameterType, ParameterOrder, ParameterRequired
  
  Compatibilidade:
  - Delphi XE7+: Suporte completo a RTTI e Attributes
  - FPC 3.2.2+: Suporte a RTTI via TypInfo e Rtti, Custom Attributes estável
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 03/01/2026
  =============================================================================== }

interface

{$I ../../Paramenters.Defines.inc}

uses
  Parameters.Types,
{$IF DEFINED(FPC)}
  TypInfo, Variants;
{$ELSE}
  System.TypInfo, System.Variants;
{$ENDIF}

type
  { =============================================================================
    Atributos de Classe
    =============================================================================
    Atributos usados na declaração da classe para mapear para parâmetros.
    ============================================================================= }
  
  { Atributo para definir título/seção do parâmetro
    Obrigatório: Toda classe que usa Attributes DEVE ter [Parameter]
    
    Parâmetros:
      ATitle: Título/seção do parâmetro (ex: 'ERP', 'CRM', 'Database')
    
    Uso:
      [Parameter('ERP')]
      TConfigERP = class
        // ...
      end;
    
    Mapeamento:
    - Database: Campo 'titulo' na tabela
    - INI: Nome da seção [ERP]
    - JSON: Nome do objeto "ERP" }
  ParameterAttribute = class(TCustomAttribute)
  private
    FTitle: string;
  public
    { Cria atributo [Parameter] com título
      Parâmetros:
        ATitle: Título/seção do parâmetro }
    constructor Create(const ATitle: string);
    
    { Título/seção do parâmetro }
    property Title: string read FTitle;
  end;

  { Atributo para definir ContratoID
    Opcional: Se não especificado, usa valor padrão ou configuração do IParameters
    
    Parâmetros:
      AContratoID: ID do contrato
    
    Uso:
      [Parameter('ERP')]
      [ContratoID(1)]
      TConfigERP = class
        // ...
      end;
    
    Mapeamento:
    - Database: Campo 'contrato_id' na tabela
    - INI: Seção [ERP_1] (formato: [Titulo_ContratoID])
    - JSON: Objeto "ERP_1" }
  ContratoIDAttribute = class(TCustomAttribute)
  private
    FContratoID: Integer;
  public
    { Cria atributo [ContratoID] com ID do contrato
      Parâmetros:
        AContratoID: ID do contrato }
    constructor Create(const AContratoID: Integer);
    
    { ID do contrato }
    property ContratoID: Integer read FContratoID;
  end;

  { Atributo para definir ProdutoID
    Opcional: Se não especificado, usa valor padrão ou configuração do IParameters
    
    Parâmetros:
      AProdutoID: ID do produto
    
    Uso:
      [Parameter('ERP')]
      [ContratoID(1)]
      [ProdutoID(1)]
      TConfigERP = class
        // ...
      end;
    
    Mapeamento:
    - Database: Campo 'produto_id' na tabela
    - INI: Seção [ERP_1_1] (formato: [Titulo_ContratoID_ProdutoID])
    - JSON: Objeto "ERP_1_1" }
  ProdutoIDAttribute = class(TCustomAttribute)
  private
    FProdutoID: Integer;
  public
    { Cria atributo [ProdutoID] com ID do produto
      Parâmetros:
        AProdutoID: ID do produto }
    constructor Create(const AProdutoID: Integer);
    
    { ID do produto }
    property ProdutoID: Integer read FProdutoID;
  end;

  { Atributo para definir fonte de dados preferencial
    Opcional: Se não especificado, usa fonte padrão do IParameters
    
    Parâmetros:
      ASource: Fonte de dados (psDatabase, psInifiles, psJsonObject)
    
    Uso:
      [Parameter('ERP')]
      [ParameterSource(psDatabase)]
      TConfigERP = class
        // ...
      end; }
  ParameterSourceAttribute = class(TCustomAttribute)
  private
    FSource: TParameterSource;
  public
    { Cria atributo [ParameterSource] com fonte de dados
      Parâmetros:
        ASource: Fonte de dados preferencial }
    constructor Create(const ASource: TParameterSource);
    
    { Fonte de dados preferencial }
    property Source: TParameterSource read FSource;
  end;

  { =============================================================================
    Atributos de Propriedade
    =============================================================================
    Atributos usados nas propriedades da classe para mapear para parâmetros.
    ============================================================================= }
  
  { Atributo para mapear propriedade para chave do parâmetro
    Obrigatório: Toda propriedade mapeada DEVE ter [ParameterKey]
    
    Parâmetros:
      AKey: Nome da chave do parâmetro (campo 'chave' no banco, chave no INI/JSON)
    
    Uso:
      [ParameterKey('database_host')]
      property DatabaseHost: string;
    
    Nota: Pode ser combinado com outros atributos: [ParameterKey('host'), ParameterValue('localhost')] }
  ParameterKeyAttribute = class(TCustomAttribute)
  private
    FKey: string;
  public
    { Cria atributo [ParameterKey] com chave do parâmetro
      Parâmetros:
        AKey: Nome da chave do parâmetro }
    constructor Create(const AKey: string);
    
    { Nome da chave do parâmetro }
    property Key: string read FKey;
  end;

  { Atributo para definir valor padrão do parâmetro
    Opcional: Use quando parâmetro tem valor padrão (usado se não existir no banco/INI/JSON)
    
    Parâmetros:
      AValue: Valor padrão (Variant - suporta string, Integer, Float, Boolean, etc.)
    
    Uso:
      [ParameterKey('database_host')]
      [ParameterValue('localhost')]
      property DatabaseHost: string;
    
    Nota: Valor é usado ao carregar se parâmetro não existir no banco/INI/JSON }
  ParameterValueAttribute = class(TCustomAttribute)
  private
    FValue: Variant;
  public
    { Cria atributo [ParameterValue] com valor padrão
      Parâmetros:
        AValue: Valor padrão (Variant) }
    constructor Create(const AValue: Variant);
    
    { Valor padrão do parâmetro }
    property Value: Variant read FValue;
  end;

  { Atributo para definir descrição/comentário do parâmetro
    Opcional: Use quando quer documentar o parâmetro
    
    Parâmetros:
      ADescription: Descrição/comentário do parâmetro
    
    Uso:
      [ParameterKey('database_host')]
      [ParameterDescription('Host do banco de dados ERP')]
      property DatabaseHost: string;
    
    Mapeamento:
    - Database: Campo 'descricao' na tabela
    - INI: Comentário na linha do parâmetro
    - JSON: Campo 'description' no objeto do parâmetro }
  ParameterDescriptionAttribute = class(TCustomAttribute)
  private
    FDescription: string;
  public
    { Cria atributo [ParameterDescription] com descrição
      Parâmetros:
        ADescription: Descrição/comentário do parâmetro }
    constructor Create(const ADescription: string);
    
    { Descrição/comentário do parâmetro }
    property Description: string read FDescription;
  end;

  { Atributo para definir tipo do valor do parâmetro
    Opcional: Se não especificado, é inferido automaticamente do tipo da propriedade
    
    Parâmetros:
      AValueType: Tipo do valor (pvtString, pvtInteger, pvtFloat, pvtBoolean, pvtDateTime, pvtJSON)
    
    Uso:
      [ParameterKey('database_port')]
      [ParameterType(pvtInteger)]
      property DatabasePort: Integer;
    
    Nota: Geralmente não é necessário - tipo é inferido automaticamente }
  ParameterTypeAttribute = class(TCustomAttribute)
  private
    FValueType: TParameterValueType;
  public
    { Cria atributo [ParameterType] com tipo do valor
      Parâmetros:
        AValueType: Tipo do valor do parâmetro }
    constructor Create(const AValueType: TParameterValueType);
    
    { Tipo do valor do parâmetro }
    property ValueType: TParameterValueType read FValueType;
  end;

  { Atributo para definir ordem de exibição do parâmetro
    Opcional: Se não especificado, ordem é automática
    
    Parâmetros:
      AOrder: Ordem de exibição (1, 2, 3, ...)
    
    Uso:
      [ParameterKey('database_host')]
      [ParameterOrder(1)]
      property DatabaseHost: string;
    
    Mapeamento:
    - Database: Campo 'ordem' na tabela
    - INI: Ordem das linhas na seção
    - JSON: Ordem dos campos no objeto }
  ParameterOrderAttribute = class(TCustomAttribute)
  private
    FOrder: Integer;
  public
    { Cria atributo [ParameterOrder] com ordem
      Parâmetros:
        AOrder: Ordem de exibição }
    constructor Create(const AOrder: Integer);
    
    { Ordem de exibição do parâmetro }
    property Order: Integer read FOrder;
  end;

  { Atributo para marcar parâmetro como obrigatório
    Opcional: Use quando parâmetro é obrigatório (gera exceção se não existir)
    
    Uso:
      [ParameterKey('database_host')]
      [ParameterRequired]
      property DatabaseHost: string;
    
    Nota: Ao carregar, se parâmetro não existir, gera EParametersNotFoundException }
  ParameterRequiredAttribute = class(TCustomAttribute)
  end;

  { =============================================================================
    Aliases para Compatibilidade (opcional)
    =============================================================================
    Aliases em português para facilitar uso e compatibilidade.
    ============================================================================= }
  
  { Alias em português para ParameterAttribute }
  Parametro = ParameterAttribute;
  
  { Alias em português para ParameterKeyAttribute }
  ChaveParametro = ParameterKeyAttribute;
  
  { Alias em português para ParameterValueAttribute }
  ValorParametro = ParameterValueAttribute;
  
  { Alias em português para ParameterDescriptionAttribute }
  DescricaoParametro = ParameterDescriptionAttribute;
  
  { Alias em português para ParameterTypeAttribute }
  TipoParametro = ParameterTypeAttribute;
  
  { Alias em português para ParameterOrderAttribute }
  OrdemParametro = ParameterOrderAttribute;
  
  { Alias em português para ParameterRequiredAttribute }
  ParametroObrigatorio = ParameterRequiredAttribute;

implementation

{ ===============================================================================
  ParameterAttribute
  =============================================================================== }

constructor ParameterAttribute.Create(const ATitle: string);
begin
  inherited Create;
  FTitle := ATitle;
end;

{ ===============================================================================
  ContratoIDAttribute
  =============================================================================== }

constructor ContratoIDAttribute.Create(const AContratoID: Integer);
begin
  inherited Create;
  FContratoID := AContratoID;
end;

{ ===============================================================================
  ProdutoIDAttribute
  =============================================================================== }

constructor ProdutoIDAttribute.Create(const AProdutoID: Integer);
begin
  inherited Create;
  FProdutoID := AProdutoID;
end;

{ ===============================================================================
  ParameterSourceAttribute
  =============================================================================== }

constructor ParameterSourceAttribute.Create(const ASource: TParameterSource);
begin
  inherited Create;
  FSource := ASource;
end;

{ ===============================================================================
  ParameterKeyAttribute
  =============================================================================== }

constructor ParameterKeyAttribute.Create(const AKey: string);
begin
  inherited Create;
  FKey := AKey;
end;

{ ===============================================================================
  ParameterValueAttribute
  =============================================================================== }

constructor ParameterValueAttribute.Create(const AValue: Variant);
begin
  inherited Create;
  FValue := AValue;
end;

{ ===============================================================================
  ParameterDescriptionAttribute
  =============================================================================== }

constructor ParameterDescriptionAttribute.Create(const ADescription: string);
begin
  inherited Create;
  FDescription := ADescription;
end;

{ ===============================================================================
  ParameterTypeAttribute
  =============================================================================== }

constructor ParameterTypeAttribute.Create(const AValueType: TParameterValueType);
begin
  inherited Create;
  FValueType := AValueType;
end;

{ ===============================================================================
  ParameterOrderAttribute
  =============================================================================== }

constructor ParameterOrderAttribute.Create(const AOrder: Integer);
begin
  inherited Create;
  FOrder := AOrder;
end;

end.
