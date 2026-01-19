unit Parameters.Types;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters.Types - Tipos do Sistema de Parâmetros
  
  Descrição:
  Define todos os tipos utilizados pelo sistema de parâmetros, incluindo
  TParameter, TParameterList, TParameterValueType, TParameterSource.
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I ../../Paramenters.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  {$IF FPC_FULLVERSION >= 30200}
    SysUtils, Classes, Generics.Collections,
  {$ELSE}
    SysUtils, Classes, fgl,
  {$ENDIF}
{$ELSE}
  System.SysUtils, System.Classes, System.Generics.Collections,
{$ENDIF}
  DB;

type

  // =============================================================================
  // CONFIGURATION TYPES
  // =============================================================================

  // Enum para opções de configuração
  TParameterConfigOption = (pcfNone, pcfDataBase, pcfInifile, pcfJsonObject);
  
  // Set para permitir múltiplas opções de configuração
  // Permite combinações como: [pcfDataBase, pcfInifile] (Database com fallback para INI)
  TParameterConfig = set of TParameterConfigOption;

  // =============================================================================
  // DATABASE TYPES
  // =============================================================================

  // Engine de acesso ao banco de dados
  TParameterDatabaseEngine = (pteNone, pteUnidac, pteFireDAC, pteZeos, pteLDAP);

  // tipo de banco de dados
  TParameterDatabaseTypes = (pdtNone, pdtFireBird, pdtMySQL, pdtPostgreSQL, pdtSQLite, pdtSQLServer, pdtAccess, pdtODBC, pdtLDAP);

  { =============================================================================
    TIPOS DE VALOR DE PARÂMETRO
    ============================================================================= }

  TParameterValueType = (
    pvtString,      // String/Texto
    pvtInteger,     // Inteiro
    pvtFloat,       // Float/Double
    pvtBoolean,     // Boolean
    pvtDateTime,    // Data/Hora
    pvtJSON         // JSON
  );
  
  { =============================================================================
    FONTE DE PARÂMETRO
    ============================================================================= }
  
  TParameterSource = (
    psNone,
    psDatabase,     // Banco de dados
    psInifiles,     // Arquivo INI
    psJsonObject    // Objeto JSON
  );
  
  // Array de fontes de parâmetro (para prioridade)
  // Deve ser declarado APÓS TParameterSource
  {$IF DEFINED(FPC)}
    TParameterSourceArray = array of TParameterSource;
  {$ELSE}
    TParameterSourceArray = System.TArray<TParameterSource>;
  {$ENDIF}

  { =============================================================================
    TParameter - Classe que representa um Parâmetro de Configuração
    =============================================================================
    
    Finalidade:
      Representa um parâmetro de configuração com todas as suas propriedades.
      Usado para transferência de dados entre as diferentes fontes (Database, INI, JSON).
    
    Propriedades:
      ID: Integer
        Identificador único do parâmetro (geralmente auto-incremento do banco).
        Valor padrão: 0
      
      Name: string
        Nome (chave) do parâmetro. Deve ser único dentro de um título/contrato/produto.
        Exemplo: 'database_host', 'api_timeout', 'max_connections'
        Valor padrão: '' (string vazia)
      
      Value: string
        Valor do parâmetro como string. Pode ser convertido para outros tipos
        baseado em ValueType.
        Valor padrão: '' (string vazia)
      
      ValueType: TParameterValueType
        Tipo do valor: pvtString, pvtInteger, pvtFloat, pvtBoolean, pvtDateTime, pvtJSON
        Valor padrão: pvtString
      
      Description: string
        Descrição/documentação do parâmetro.
        Valor padrão: '' (string vazia)
      
      ContratoID: Integer
        ID do contrato associado ao parâmetro. Usado para filtragem e organização.
        Valor padrão: 0 (sem contrato específico)
      
      ProdutoID: Integer
        ID do produto associado ao parâmetro. Usado para filtragem e organização.
        Valor padrão: 0 (sem produto específico)
      
      Ordem: Integer
        Ordem de exibição/processamento do parâmetro dentro de um título.
        Valor padrão: 0 (ordem automática)
      
      Titulo: string
        Título/categoria do parâmetro. Agrupa parâmetros relacionados.
        Exemplo: 'ERP', 'API', 'Database', 'Email'
        Valor padrão: '' (string vazia)
      
      Ativo: Boolean
        Indica se o parâmetro está ativo (True) ou inativo (False).
        Parâmetros inativos podem ser ignorados em algumas operações.
        Valor padrão: True
      
      CreatedAt: TDateTime
        Data/hora de criação do parâmetro.
        Valor padrão: Now (data/hora atual)
      
      UpdatedAt: TDateTime
        Data/hora da última atualização do parâmetro.
        Valor padrão: Now (data/hora atual)
    
    Exemplo:
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
    ============================================================================= }
  
  TParameter = class
  private
    FID: Integer;              // Identificador único do parâmetro
    FName: string;             // Nome (chave) do parâmetro
    FValue: string;            // Valor do parâmetro como string
    FValueType: TParameterValueType; // Tipo do valor (String, Integer, etc.)
    FDescription: string;      // Descrição/documentação
    FContratoID: Integer;      // ID do contrato associado
    FProdutoID: Integer;       // ID do produto associado
    FOrdem: Integer;           // Ordem de exibição/processamento
    FTitulo: string;           // Título/categoria do parâmetro
    FAtivo: Boolean;           // Indica se está ativo
    FCreatedAt: TDateTime;     // Data/hora de criação
    FUpdatedAt: TDateTime;     // Data/hora da última atualização
  public
    { Create - Construtor
      
      Finalidade:
        Cria uma nova instância de TParameter com valores padrão.
      
      Valores Padrão:
        - ID: 0
        - Name: '' (string vazia)
        - Value: '' (string vazia)
        - ValueType: pvtString
        - Description: '' (string vazia)
        - ContratoID: 0
        - ProdutoID: 0
        - Ordem: 0
        - Titulo: '' (string vazia)
        - Ativo: True
        - CreatedAt: Now
        - UpdatedAt: Now
    }
    constructor Create;
    
    { Destroy - Destrutor
      
      Finalidade:
        Libera a instância de TParameter.
    }
    destructor Destroy; override;
    
    // ========== PROPRIEDADES BÁSICAS ==========
    
    { ID - Identificador único do parâmetro
      Geralmente preenchido automaticamente pelo banco de dados (auto-incremento).
    }
    property ID: Integer read FID write FID;
    
    { Name - Nome (chave) do parâmetro
      Deve ser único dentro de um título/contrato/produto.
      Exemplo: 'database_host', 'api_timeout'
    }
    property Name: string read FName write FName;
    
    { Value - Valor do parâmetro como string
      Pode ser convertido para outros tipos baseado em ValueType.
    }
    property Value: string read FValue write FValue;
    
    { ValueType - Tipo do valor
      Define como o Value deve ser interpretado: String, Integer, Float, Boolean, DateTime, JSON
    }
    property ValueType: TParameterValueType read FValueType write FValueType;
    
    { Description - Descrição/documentação do parâmetro
      Útil para documentar o propósito e uso do parâmetro.
    }
    property Description: string read FDescription write FDescription;
    
    // ========== PROPRIEDADES ESPECÍFICAS DA TABELA CONFIG ==========
    
    { ContratoID - ID do contrato associado
      Usado para filtragem e organização de parâmetros por contrato.
    }
    property ContratoID: Integer read FContratoID write FContratoID;
    
    { ProdutoID - ID do produto associado
      Usado para filtragem e organização de parâmetros por produto.
    }
    property ProdutoID: Integer read FProdutoID write FProdutoID;
    
    { Ordem - Ordem de exibição/processamento
      Define a ordem dentro de um título. 0 = ordem automática.
    }
    property Ordem: Integer read FOrdem write FOrdem;
    
    { Titulo - Título/categoria do parâmetro
      Agrupa parâmetros relacionados (ex: 'ERP', 'API', 'Database').
    }
    property Titulo: string read FTitulo write FTitulo;
    
    { Ativo - Indica se o parâmetro está ativo
      Parâmetros inativos podem ser ignorados em algumas operações.
    }
    property Ativo: Boolean read FAtivo write FAtivo;
    
    { CreatedAt - Data/hora de criação
      Preenchido automaticamente na inserção.
    }
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    
    { UpdatedAt - Data/hora da última atualização
      Atualizado automaticamente na modificação.
    }
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
  end;
  
  (* =============================================================================
    TParameterList - Lista de Parâmetros
    =============================================================================
    
    Finalidade:
      Lista genérica que armazena instâncias de TParameter. Herda de TList<TParameter>
      e adiciona funcionalidade para liberar automaticamente os objetos ao ser destruída.
    
    Características:
      - Herda de TList<TParameter> (System.Generics.Collections)
      - Libera automaticamente todos os objetos TParameter no destrutor
      - Método ClearAll() libera objetos e limpa a lista
    
    Uso:
      var List: TParameterList;
      List := Parameters.List;
      try
        for var I := 0 to List.Count - 1 do
          ShowMessage(List[I].Name + ' = ' + List[I].Value);
      finally
        List.Free; // Libera todos os objetos automaticamente
      end;
    ============================================================================= *)
  
  TParameterList = class(TList<TParameter>)
  public
    { Destroy - Destrutor
      
      Finalidade:
        Libera automaticamente todos os objetos TParameter na lista antes de
        destruir a lista. Chama ClearAll() internamente.
    }
    destructor Destroy; override;
    
    { ClearAll - Libera todos os objetos e limpa a lista
      
      Finalidade:
        Libera (Free) todos os objetos TParameter na lista e depois limpa a lista.
        Útil quando precisa limpar a lista sem destruí-la.
      
      Exemplo:
        List.ClearAll; // Libera objetos e limpa lista
        // List ainda existe, mas está vazia
    }
    procedure ClearAll;
  end;

  { =============================================================================
    CALLBACKS PARA IMPORTAÇÃO
    ============================================================================= }
  
  // Callback para perguntar se deve sobrepor parâmetro existente durante importação
  // Retorna True para sobrepor, False para pular
  // NOTA: Declarado APÓS TParameter para evitar forward declaration
  TParameterImportOverwriteCallback = function(const AExistingParameter, ANewParameter: TParameter): Boolean of object;
  
  // Tipo de callback simples (sem objeto)
  TParameterImportOverwriteCallbackSimple = function(const AExistingParameter, ANewParameter: TParameter): Boolean;

implementation

{ TParameter }

constructor TParameter.Create;
begin
  inherited;
  FID := 0;
  FName := '';
  FValue := '';
  FValueType := pvtString;
  FDescription := '';
  FContratoID := 0;
  FProdutoID := 0;
  FOrdem := 0;
  FTitulo := '';
  FAtivo := True;
  FCreatedAt := Now;
  FUpdatedAt := Now;
end;

destructor TParameter.Destroy;
begin
  inherited;
end;

{ TParameterList }

destructor TParameterList.Destroy;
begin
  ClearAll;
  inherited;
end;

procedure TParameterList.ClearAll;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  Clear; // Chama o Clear da classe base (não virtual)
end;

end.
