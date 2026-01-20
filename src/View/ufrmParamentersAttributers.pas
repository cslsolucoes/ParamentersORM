unit ufrmParamentersAttributers;
{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

(* =============================================================================
  frmParamentersAttributers - Exemplo de CRUD VCL usando Attributes
    Descrição:
  Exemplo completo de implementação CRUD usando o módulo Parameters com Attributes
  para gerenciar a tabela config de forma declarativa.

  ════════════════════════════════════════════════════════════════════════════
  COMPARAÇÃO COM ufrmParamenters.pas (VERSÃO ORIGINAL SEM ATTRIBUTES)
  ════════════════════════════════════════════════════════════════════════════

  ARQUITETURA:
  ┌─────────────────────────────────────────────────────────────────────────┐
  │ ORIGINAL (ufrmParamenters.pas)                                         │
  ├─────────────────────────────────────────────────────────────────────────┤
  │ Formulário → TParameter → IParameters → Database/INI/JSON              │
  │                                                                         │
  │ - Trabalha diretamente com TParameter (classe do módulo)              │
  │ - Métodos: GetParameterFromFields(), LoadFieldsFromParameter()         │
  │ - Código mais verboso, precisa criar TParameter manualmente            │
  └─────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────────────────┐
  │ COM ATTRIBUTES (ufrmParamentersAttributers.pas)                        │
  ├─────────────────────────────────────────────────────────────────────────┤
  │ Formulário → TConfigParameter → IAttributeMapper → TParameter →        │
  │              IParameters → Database/INI/JSON                            │
  │                                                                         │
  │ - Define classe TConfigParameter com Attributes customizados            │
  │ - Usa IAttributeMapper para conversão automática via RTTI              │
  │ - Métodos: GetConfigFromFields(), LoadFieldsFromConfig()               │
  │ - Código mais limpo e declarativo                                       │
  └─────────────────────────────────────────────────────────────────────────┘

  PRINCIPAIS DIFERENÇAS:

  1. CLASSE DE CONFIGURAÇÃO:
     ORIGINAL: Usa TParameter diretamente (classe do módulo Parameters)
     ATTRIBUTES: Define TConfigParameter com Attributes para mapeamento

  2. CONVERSÃO DE DADOS:
     ORIGINAL: GetParameterFromFields() retorna TParameter
     ATTRIBUTES: GetConfigFromFields() retorna TConfigParameter

  3. CARREGAMENTO DE DADOS:
     ORIGINAL: LoadFieldsFromParameter(const AParameter: TParameter)
     ATTRIBUTES: LoadFieldsFromConfig(const AConfig: TConfigParameter)

  4. MAPEAMENTO:
     ORIGINAL: Manual - código explícito para cada propriedade
     ATTRIBUTES: Declarativo - Attributes definem o mapeamento via RTTI

  5. TYPE-SAFETY:
     ORIGINAL: TParameter usa Variant para valores
     ATTRIBUTES: TConfigParameter usa tipos específicos (Integer, string, Boolean)

  VANTAGENS DA VERSÃO COM ATTRIBUTES:

  ✅ Type-Safety: Propriedades tipadas (Integer, string, Boolean) ao invés de Variant
  ✅ IntelliSense: Autocompletar funciona melhor com propriedades tipadas
  ✅ Manutenibilidade: Mudanças na estrutura são feitas apenas na classe
  ✅ Reutilização: A classe pode ser usada em outros contextos (JSON, XML, etc.)
  ✅ Validação: Pode adicionar validações na classe usando Attributes
  ✅ Documentação: Attributes servem como documentação inline do mapeamento
  ✅ Menos Código: Mapeamento declarativo reduz código boilerplate

  DESVANTAGENS / LIMITAÇÕES:

  ⚠️ RTTI: Requer {$M+} e suporte a RTTI (Delphi XE7+ / FPC 3.2.2+)
  ⚠️ Performance: Conversão via RTTI pode ser ligeiramente mais lenta
  ⚠️ Complexidade: Adiciona uma camada de abstração (pode ser pro ou contra)

  NOTA: Os nomes dos métodos foram MANTIDOS IGUAIS ao original para facilitar
  comparação e aprendizado. A única diferença é o tipo de parâmetro/retorno.

  Funcionalidades:
  - List: Lista todos os registros da tabela config
  - Insert: Insere novo registro usando Attributes
  - Update: Atualiza registro existente usando Attributes
  - Delete: Remove registro
  - Usa IAttributeMapper para conversão Classe ↔ TParameter

  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 03/01/2026
  ============================================================================= *)

interface

uses
{$IF DEFINED(FPC)}
  LCLType, LCLIntf, SysUtils, Variants, Classes, StrUtils,
  {$IF DEFINED(WINDOWS)}
  Registry,
  {$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids, DBGrids, ComCtrls, Masks, FileCtrl,
{$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils, System.Win.Registry,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Mask, Vcl.FileCtrl,
{$ENDIF}

  Parameters, Parameters.Interfaces, Parameters.Types,
  Parameters.Exceptions, Parameters.Consts,
  Parameters.Attributes, Parameters.Attributes.Interfaces, Parameters.Attributes.Types;

type
  { =============================================================================
    TConfigParameter - Classe de configuração com Attributes
    =============================================================================
    DIFERENÇA PRINCIPAL vs ufrmParamenters.pas:
    
    No arquivo ORIGINAL (ufrmParamenters.pas):
    - Trabalha diretamente com TParameter (classe do módulo Parameters)
    - Métodos GetParameterFromFields() e LoadFieldsFromParameter() manipulam TParameter
    - Código mais verboso, precisa criar e preencher TParameter manualmente
    
    Neste arquivo COM ATTRIBUTES (ufrmParamentersAttributers.pas):
    - Define uma classe TConfigParameter com Attributes customizados
    - Usa IAttributeMapper para conversão automática Classe ↔ TParameter
    - Código mais limpo e declarativo, mapeamento feito via RTTI
    
    VANTAGENS:
    1. Type-Safety: Propriedades tipadas (Integer, string, Boolean) ao invés de Variant
    2. IntelliSense: Autocompletar funciona melhor com propriedades tipadas
    3. Manutenibilidade: Mudanças na estrutura são feitas apenas na classe
    4. Reutilização: A classe pode ser usada em outros contextos (JSON, XML, etc.)
    5. Validação: Pode adicionar validações na classe usando Attributes
    6. Documentação: Attributes servem como documentação inline do mapeamento
    
    COMO FUNCIONA:
    - [ParameterAttribute('Config')]: Define o título/seção do parâmetro
    - [ContratoIDAttribute(1)]: Define ContratoID padrão
    - [ProdutoIDAttribute(1)]: Define ProdutoID padrão
    - [ParameterKeyAttribute('chave')]: Mapeia propriedade para campo 'chave' no banco
    - [ParameterTypeAttribute(pvtString)]: Define o tipo do valor
    - [ParameterRequiredAttribute]: Indica que o campo é obrigatório
    
    O IAttributeMapper usa RTTI para ler esses Attributes e converter automaticamente
    entre TConfigParameter e TParameter, eliminando código boilerplate.
    ============================================================================= }
  
  {$M+} // Habilita RTTI para Attributes - DEVE estar antes da declaração da classe
  [ParameterAttribute('Config')]      // Título/seção do parâmetro (equivalente a TParameter.Titulo)
  [ContratoIDAttribute(1)]            // ContratoID padrão (equivalente a TParameter.ContratoID)
  [ProdutoIDAttribute(1)]             // ProdutoID padrão (equivalente a TParameter.ProdutoID)
  TConfigParameter = class
  private
    FContratoID: Integer;
    FProdutoID: Integer;
    FOrdem: Integer;
    FTitulo: string;
    FChave: string;
    FValor: string;
    FDescricao: string;
    FAtivo: Boolean;
  public
    constructor Create;
    
    [ParameterKeyAttribute('contrato_id')]
    [ParameterDescriptionAttribute('ID do Contrato')]
    [ParameterTypeAttribute(pvtInteger)]
    [ParameterOrderAttribute(1)]
    property ContratoID: Integer read FContratoID write FContratoID;
    
    [ParameterKeyAttribute('produto_id')]
    [ParameterDescriptionAttribute('ID do Produto')]
    [ParameterTypeAttribute(pvtInteger)]
    [ParameterOrderAttribute(2)]
    property ProdutoID: Integer read FProdutoID write FProdutoID;
    
    [ParameterKeyAttribute('ordem')]
    [ParameterDescriptionAttribute('Ordem de exibição')]
    [ParameterTypeAttribute(pvtInteger)]
    [ParameterOrderAttribute(3)]
    property Ordem: Integer read FOrdem write FOrdem;
    
    [ParameterKeyAttribute('titulo')]
    [ParameterDescriptionAttribute('Título/Seção do parâmetro')]
    [ParameterTypeAttribute(pvtString)]
    [ParameterOrderAttribute(4)]
    property Titulo: string read FTitulo write FTitulo;
    
    [ParameterKeyAttribute('chave')]
    [ParameterDescriptionAttribute('Chave/Nome do parâmetro')]
    [ParameterTypeAttribute(pvtString)]
    [ParameterOrderAttribute(5)]
    [ParameterRequiredAttribute]
    property Chave: string read FChave write FChave;
    
    [ParameterKeyAttribute('valor')]
    [ParameterDescriptionAttribute('Valor do parâmetro')]
    [ParameterTypeAttribute(pvtString)]
    [ParameterOrderAttribute(6)]
    property Valor: string read FValor write FValor;
    
    [ParameterKeyAttribute('descricao')]
    [ParameterDescriptionAttribute('Descrição do parâmetro')]
    [ParameterTypeAttribute(pvtString)]
    [ParameterOrderAttribute(7)]
    property Descricao: string read FDescricao write FDescricao;
    
    [ParameterKeyAttribute('ativo')]
    [ParameterDescriptionAttribute('Status ativo/inativo')]
    [ParameterTypeAttribute(pvtBoolean)]
    [ParameterOrderAttribute(8)]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

type
  TfrmParamentersAttributers = class(TForm)
    dlgInifilesOpen: TOpenDialog;
    dlgInifilesSave: TSaveDialog;
    dlgJsonObjectOpen: TOpenDialog;
    dlgJsonObjectSave: TSaveDialog;
    dlgOpenDatabase: TOpenDialog;
    pnlBottom: TPanel;
    lblStatus: TLabel;
    pnlCenter: TPanel;
    pgcMain: TPageControl;
    tsDatabase: TTabSheet;
    pnlDados: TPanel;
    lblContratoID: TLabel;
    lblProdutoID: TLabel;
    lblOrdem: TLabel;
    lblTituloCampo: TLabel;
    lblChave: TLabel;
    lblValor: TLabel;
    lblDescricao: TLabel;
    edtContratoID: TEdit;
    edtProdutoID: TEdit;
    edtOrdem: TEdit;
    edtTitulo: TEdit;
    edtChave: TEdit;
    memoValor: TMemo;
    memoDescricao: TMemo;
    chkAtivo: TCheckBox;
    btnClear: TButton;
    btnGet: TButton;
    btnInsert: TButton;
    btnUpdate: TButton;
    btnDelete: TButton;
    pnlLista: TPanel;
    lblLista: TLabel;
    lblFiltro: TLabel;
    lblFiltroContrato: TLabel;
    lblFiltroProduto: TLabel;
    edtFiltro: TEdit;
    edtFiltroContrato: TEdit;
    edtFiltroProduto: TEdit;
    btnFiltrar: TButton;
    lvConfig: TListView;
    btnList: TButton;
    btnRefresh: TButton;
    btnLimparFiltro: TButton;
    btnDatabaseImportIni: TButton;
    btnDatabaseImportJson: TButton;
    btnDatabaseExportIni: TButton;
    btnDatabaseExportJson: TButton;
    tsInifiles: TTabSheet;
    pnlInifilesTop: TPanel;
    lblInifilesFilePath: TLabel;
    lblInifilesSection: TLabel;
    lblInifilesAutoCreate: TLabel;
    lblInifilesFiltroContrato: TLabel;
    lblInifilesFiltroProduto: TLabel;
    lblInifilesFiltroInfo: TLabel;
    edtInifilesFilePath: TEdit;
    btnInifilesSelectFile: TButton;
    edtInifilesSection: TEdit;
    chkInifilesAutoCreate: TCheckBox;
    btnInifilesRefresh: TButton;
    edtInifilesFiltroContrato: TEdit;
    edtInifilesFiltroProduto: TEdit;
    pnlInifilesLeft: TPanel;
    lblInifilesContratoID: TLabel;
    lblInifilesProdutoID: TLabel;
    lblInifilesOrdem: TLabel;
    lblInifilesTitulo: TLabel;
    lblInifilesChave: TLabel;
    lblInifilesValor: TLabel;
    lblInifilesDescricao: TLabel;
    edtInifilesContratoID: TEdit;
    edtInifilesProdutoID: TEdit;
    edtInifilesOrdem: TEdit;
    edtInifilesTitulo: TEdit;
    edtInifilesChave: TEdit;
    memoInifilesValor: TMemo;
    memoInifilesDescricao: TMemo;
    chkInifilesAtivo: TCheckBox;
    btnInifilesClear: TButton;
    btnInifilesGet: TButton;
    btnInifilesInsert: TButton;
    btnInifilesUpdate: TButton;
    btnInifilesDelete: TButton;
    pnlInifilesRight: TPanel;
    lblInifilesLista: TLabel;
    lvInifiles: TListView;
    btnInifilesList: TButton;
    btnInifilesCount: TButton;
    btnInifilesExists: TButton;
    btnInifilesImport: TButton;
    btnInifilesExport: TButton;
    btnInifilesImportJson: TButton;
    btnInifilesExportJson: TButton;
    tsJsonObject: TTabSheet;
    pnlJsonObjectTop: TPanel;
    lblJsonObjectFilePath: TLabel;
    lblJsonObjectObjectName: TLabel;
    lblJsonObjectAutoCreate: TLabel;
    lblJsonObjectFiltroContrato: TLabel;
    lblJsonObjectFiltroProduto: TLabel;
    lblJsonObjectFiltroInfo: TLabel;
    edtJsonObjectFilePath: TEdit;
    btnJsonObjectSelectFile: TButton;
    edtJsonObjectObjectName: TEdit;
    chkJsonObjectAutoCreate: TCheckBox;
    btnJsonObjectRefresh: TButton;
    edtJsonObjectFiltroContrato: TEdit;
    edtJsonObjectFiltroProduto: TEdit;
    pnlJsonObjectLeft: TPanel;
    lblJsonObjectContratoID: TLabel;
    lblJsonObjectProdutoID: TLabel;
    lblJsonObjectOrdem: TLabel;
    lblJsonObjectTitulo: TLabel;
    lblJsonObjectChave: TLabel;
    lblJsonObjectValor: TLabel;
    lblJsonObjectDescricao: TLabel;
    edtJsonObjectContratoID: TEdit;
    edtJsonObjectProdutoID: TEdit;
    edtJsonObjectOrdem: TEdit;
    edtJsonObjectTitulo: TEdit;
    edtJsonObjectChave: TEdit;
    memoJsonObjectValor: TMemo;
    memoJsonObjectDescricao: TMemo;
    chkJsonObjectAtivo: TCheckBox;
    btnJsonObjectClear: TButton;
    btnJsonObjectGet: TButton;
    btnJsonObjectInsert: TButton;
    btnJsonObjectUpdate: TButton;
    btnJsonObjectDelete: TButton;
    pnlJsonObjectRight: TPanel;
    lblJsonObjectLista: TLabel;
    lvJsonObject: TListView;
    btnJsonObjectList: TButton;
    btnJsonObjectCount: TButton;
    btnJsonObjectExists: TButton;
    btnJsonObjectImport: TButton;
    btnJsonObjectImportIni: TButton;
    btnJsonObjectExport: TButton;
    btnJsonObjectExportIni: TButton;
    btnJsonObjectSave: TButton;
    btnJsonObjectLoad: TButton;
    pnlTop: TPanel;
    lblTitulo: TLabel;
    lblEngine: TLabel;
    lblDatabaseType: TLabel;
    lblHost: TLabel;
    lblPort: TLabel;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblDatabase: TLabel;
    lblSchema: TLabel;
    lblTableName: TLabel;
    lblODBCDatabaseType: TLabel;
    lblConexaoInfo: TLabel;
    lblConexaoTipo: TLabel;
    lblDLLPath: TLabel;
    edtEngine: TEdit;
    cmbDatabaseType: TComboBox;
    edtHost: TEdit;
    edtPort: TEdit;
    edtUsername: TEdit;
    edtPassword: TEdit;
    edtDatabase: TEdit;
    cmbODBCDSN: TComboBox;
    btnSelectDatabase: TButton;
    cmbODBCDatabaseType: TComboBox;
    edtSchema: TEdit;
    edtTableName: TEdit;
    btnConectar: TButton;
    btnDesconectar: TButton;
    cbApagar: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnLimparFiltroClick(Sender: TObject);
    procedure btnDatabaseImportIniClick(Sender: TObject);
    procedure btnDatabaseImportJsonClick(Sender: TObject);
    procedure btnDatabaseExportIniClick(Sender: TObject);
    procedure btnDatabaseExportJsonClick(Sender: TObject);
    procedure lvConfigSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvConfigColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure btnDesconectarClick(Sender: TObject);
    procedure cmbDatabaseTypeChange(Sender: TObject);
    procedure btnSelectDatabaseClick(Sender: TObject);
    procedure cbApagarClick(Sender: TObject);
    procedure cmbODBCDatabaseTypeChange(Sender: TObject);
    procedure btnInifilesSelectFileClick(Sender: TObject);
    procedure btnInifilesRefreshClick(Sender: TObject);
    procedure btnInifilesListClick(Sender: TObject);
    procedure btnInifilesGetClick(Sender: TObject);
    procedure btnInifilesInsertClick(Sender: TObject);
    procedure btnInifilesUpdateClick(Sender: TObject);
    procedure btnInifilesDeleteClick(Sender: TObject);
    procedure btnInifilesCountClick(Sender: TObject);
    procedure btnInifilesExistsClick(Sender: TObject);
    procedure btnInifilesImportClick(Sender: TObject);
    procedure btnInifilesExportClick(Sender: TObject);
    procedure btnInifilesImportJsonClick(Sender: TObject);
    procedure btnInifilesExportJsonClick(Sender: TObject);
    procedure lvInifilesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnInifilesClearClick(Sender: TObject);
    procedure btnJsonObjectSelectFileClick(Sender: TObject);
    procedure btnJsonObjectRefreshClick(Sender: TObject);
    procedure btnJsonObjectListClick(Sender: TObject);
    procedure btnJsonObjectGetClick(Sender: TObject);
    procedure btnJsonObjectInsertClick(Sender: TObject);
    procedure btnJsonObjectUpdateClick(Sender: TObject);
    procedure btnJsonObjectDeleteClick(Sender: TObject);
    procedure btnJsonObjectCountClick(Sender: TObject);
    procedure btnJsonObjectExistsClick(Sender: TObject);
    procedure btnJsonObjectImportClick(Sender: TObject);
    procedure btnJsonObjectImportIniClick(Sender: TObject);
    procedure btnJsonObjectExportClick(Sender: TObject);
    procedure btnJsonObjectExportIniClick(Sender: TObject);
    procedure btnJsonObjectSaveClick(Sender: TObject);
    procedure btnJsonObjectLoadClick(Sender: TObject);
    procedure lvJsonObjectSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnJsonObjectClearClick(Sender: TObject);
  private
    FParameters: IParameters; // Interface unificada de convergência
    // DIFERENÇA: No original usa FCurrentParameter: TParameter
    // Aqui usa FCurrentConfig: TConfigParameter + FAttributeMapper para conversão
    FAttributeMapper: IAttributeMapper; // Mapper de Attributes - converte Classe ↔ TParameter via RTTI
    FCurrentConfig: TConfigParameter; // Instância atual da classe de configuração (ao invés de TParameter)
    FFiltroTexto: string;
    FFiltroContrato: Integer;
    FFiltroProduto: Integer;
    FSortColumn: Integer;
    FSortAscending: Boolean;
    procedure InitializeParameters;
    procedure LoadDataToListView(const AFiltroTexto: string = ''; AFiltroContrato: Integer = 0; AFiltroProduto: Integer = 0);
    procedure ClearFields;
    // DIFERENÇA: No original usa LoadFieldsFromParameter(const AParameter: TParameter)
    // Aqui usa LoadFieldsFromConfig(const AConfig: TConfigParameter) - trabalha com classe tipada
    procedure LoadFieldsFromConfig(const AConfig: TConfigParameter);
    // DIFERENÇA: No original usa GetParameterFromFields: TParameter
    // Aqui usa GetConfigFromFields: TConfigParameter - retorna classe tipada ao invés de TParameter
    function GetConfigFromFields: TConfigParameter;
    procedure ShowStatus(const AMessage: string; AIsError: Boolean = False);
    function ValidateFields: Boolean;
    procedure SortListView(AColumn: Integer);
    procedure SortListViewDefault; // Ordenação padrão: Contrato → Produto → Título → Ordem
    procedure UpdateConnectionInfo; // Atualiza informações de conexão no pnlTop
    procedure LoadConnectionFields; // Carrega valores atuais nos campos de conexão
    procedure PopulateDatabaseTypeCombo; // Popula o ComboBox com tipos de banco disponíveis
    function GetDLLPath: string; // Obtém o caminho da DLL sendo usada (FireDAC)
    procedure PopulateODBCDatabaseTypeCombo; // Popula o ComboBox com tipos de banco para ODBC
    procedure PopulateODBCDSNCombo; // Popula o ComboBox com DSNs ODBC disponíveis
    function HandleTableNotExists(const AOperation: string): Boolean; // Trata exceção de tabela não existente
    function SelectDatabaseFromList(ADatabases: TStringList): string; // Mostra diálogo de seleção de banco
    procedure AdjustFieldsByDatabaseType; // Ajusta campos conforme tipo de banco selecionado
    procedure UpdateEngineField; // Atualiza o campo edtEngine com detecção automática
    // Métodos para Inifiles
    procedure LoadInifilesDataToListView;
    procedure ClearInifilesFields;
    procedure LoadInifilesFieldsFromConfig(const AConfig: TConfigParameter);
    function GetInifilesConfigFromFields: TConfigParameter;
    procedure ShowInifilesStatus(const AMessage: string; AIsError: Boolean = False);
    function ValidateInifilesFields: Boolean;
    // Métodos para JsonObject
    procedure LoadJsonObjectDataToListView;
    procedure ClearJsonObjectFields;
    procedure LoadJsonObjectFieldsFromConfig(const AConfig: TConfigParameter);
    function GetJsonObjectConfigFromFields: TConfigParameter;
    procedure ShowJsonObjectStatus(const AMessage: string; AIsError: Boolean = False);
    function ValidateJsonObjectFields: Boolean;
  public
    { Public declarations }
  end;

var
  frmParamentersAttributers: TfrmParamentersAttributers;

implementation

{$R *.dfm}

{$I ../Paramenters.Defines.inc}

// Declaração da API ODBC para listar DSNs
function SQLDataSources(EnvironmentHandle: Pointer; Direction: SmallInt;
  ServerName: PChar; BufferLength1: SmallInt; var NameLength1: SmallInt;
  Description: PChar; BufferLength2: SmallInt; var NameLength2: SmallInt): SmallInt; stdcall;
  external 'odbc32.dll' name 'SQLDataSources';
function SQLAllocHandle(HandleType: SmallInt; InputHandle: Pointer;
  var OutputHandle: Pointer): SmallInt; stdcall;
  external 'odbc32.dll' name 'SQLAllocHandle';
function SQLFreeHandle(HandleType: SmallInt; Handle: Pointer): SmallInt; stdcall;
  external 'odbc32.dll' name 'SQLFreeHandle';
function SQLSetEnvAttr(EnvironmentHandle: Pointer; Attribute: Integer;
  ValuePtr: Pointer; StringLength: Integer): SmallInt; stdcall;
  external 'odbc32.dll' name 'SQLSetEnvAttr';

const
  SQL_HANDLE_ENV = 1;
  SQL_FETCH_NEXT = 1;
  SQL_ATTR_ODBC_VERSION = 200;
  SQL_OV_ODBC3 = 3;
  SQL_SUCCESS = 0;
  SQL_SUCCESS_WITH_INFO = 1;
  SQL_NO_DATA = 100;

{ TConfigParameter }

constructor TConfigParameter.Create;
begin
  inherited Create;
  FContratoID := 1;
  FProdutoID := 1;
  FOrdem := 1;
  FTitulo := '';
  FChave := '';
  FValor := '';
  FDescricao := '';
  FAtivo := True;
end;

{ TfrmParamentersAttributers }

procedure TfrmParamentersAttributers.FormCreate(Sender: TObject);
begin
  FCurrentConfig := nil;
  FFiltroTexto := '';
  FFiltroContrato := 0;
  FFiltroProduto := 0;
  FSortColumn := -1;
  FSortAscending := True;
  
  // Cria instância do AttributeMapper
  FAttributeMapper := TAttributeMapper.New;
  
  // Popula ComboBox de DatabaseType
  PopulateDatabaseTypeCombo;
  
  // InitializeParameters já cria e inicializa automaticamente todas as fontes
  InitializeParameters;
  ClearFields;
  ShowStatus('Sistema inicializado. Clique em "Listar Todos" para carregar os dados.');
  
  // Inifiles e JsonObject já foram inicializados automaticamente pelo TParameters.New
  if Assigned(FParameters) then
  begin
    // Atualiza campos de Inifiles com valores padrão
    edtInifilesFilePath.Text := 'D:\Dados\config.ini';
    
    if Assigned(FParameters.Inifiles) then
    begin
      FParameters.Inifiles.FilePath(edtInifilesFilePath.Text);
      edtInifilesSection.Text := FParameters.Inifiles.Section;
      chkInifilesAutoCreate.Checked := FParameters.Inifiles.AutoCreateFile;
    end;
    
    // Atualiza campos de JsonObject com valores padrão
    if Assigned(FParameters.JsonObject) then
    begin
      edtJsonObjectFilePath.Text := FParameters.JsonObject.FilePath;
      edtJsonObjectObjectName.Text := FParameters.JsonObject.ObjectName;
      chkJsonObjectAutoCreate.Checked := FParameters.JsonObject.AutoCreateFile;
    end;
  end;
  
  // Limpa campos de dados
  ClearInifilesFields;
  ClearJsonObjectFields;
end;

procedure TfrmParamentersAttributers.FormDestroy(Sender: TObject);
begin
  if Assigned(FCurrentConfig) then
  begin
    FCurrentConfig.Free;
    FCurrentConfig := nil;
  end;
  FAttributeMapper := nil;
  FParameters := nil;
end;

procedure TfrmParamentersAttributers.FormShow(Sender: TObject);
begin
  // Carrega dados automaticamente ao abrir o formulário
  btnListClick(nil);
end;

procedure TfrmParamentersAttributers.InitializeParameters;
var
  LEngine: TParameterDatabaseEngine;
  LDatabaseTypeEnum: TParameterDatabaseTypes;
  I: TParameterDatabaseTypes;
begin
  // DETECÇÃO AUTOMÁTICA DE ENGINE
  UpdateEngineField;

  // Detecta qual engine está ativo
  LEngine := TParameters.DetectEngine;
  edtEngine.ReadOnly := True;
  edtEngine.Color := clBtnFace;

  // Cria instância do Parameters usando interface unificada
  FParameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
  
  // MELHORIA: Inicializa o AttributeMapper para conversão Classe ↔ TParameter
  // No original não existe - trabalha diretamente com TParameter
  // Aqui o mapper permite usar TConfigParameter (classe tipada) e converter automaticamente
  FAttributeMapper := TAttributeMapper.Create;

  // Configura Database para usar o engine detectado automaticamente
  if LEngine <> pteNone then
    FParameters.Database.Engine(LEngine);

  // Usa valores padrão do arquivo ParamentersORM.Database.inc
  LDatabaseTypeEnum := pdtNone;
  for I := Low(TParameterDatabaseTypes) to High(TParameterDatabaseTypes) do
  begin
    if SameText(DEFAULT_PARAMETERS_DATABASE_TYPE, TDatabaseTypeNames[I]) then
    begin
      LDatabaseTypeEnum := I;
      Break;
    end;
  end;

  if LDatabaseTypeEnum <> pdtNone then
    FParameters.Database.DatabaseType(LDatabaseTypeEnum);

  // Configuração inicial usando valores padrão
  FParameters.Database.Host(DEFAULT_PARAMETERS_HOST)
    .Port(DEFAULT_PARAMETERS_PORT)
    .Username(DEFAULT_PARAMETERS_USERNAME)
    .Password(DEFAULT_PARAMETERS_PASSWORD)
    .Database(DEFAULT_PARAMETERS_DATABASE)
    .Schema(DEFAULT_PARAMETERS_SCHEMA)
    .TableName(DEFAULT_PARAMETERS_TABLE)
    .AutoCreateTable(True);
  edtDatabase.Text := DEFAULT_PARAMETERS_DATABASE;
  
  // Carrega valores nos campos de conexão
  LoadConnectionFields;

  // Conecta automaticamente
  FParameters.Database.Connect;

  // Atualiza informações de conexão
  UpdateConnectionInfo;

  // Atualiza estado dos botões
  btnConectar.Enabled := False;
  btnDesconectar.Enabled := True;

  cmbDatabaseTypeChange(Self);
  
  ShowStatus('Conectado ao banco de dados com sucesso!');
end;

procedure TfrmParamentersAttributers.btnListClick(Sender: TObject);
var
  LCount: Integer;
begin
  try
    // Limpa todos os filtros e lista todos
    FFiltroTexto := '';
    FFiltroContrato := 0;
    FFiltroProduto := 0;
    edtFiltro.Text := '';
    edtFiltroContrato.Text := '';
    edtFiltroProduto.Text := '';
    
    // Usa versão fluente para obter contagem e listar
    FParameters.Count(LCount);
    
    LoadDataToListView;
    ShowStatus(Format('Listagem concluída. %d registro(s) encontrado(s).', [lvConfig.Items.Count]));
  except
    on E: EParametersSQLException do
    begin
      if E.ErrorCode = ERR_SQL_TABLE_NOT_EXISTS then
      begin
        if HandleTableNotExists('listar') then
        begin
          btnListClick(Sender);
        end;
      end
      else
      begin
        ShowStatus('Erro ao listar: ' + E.Message, True);
        ShowMessage('Erro ao listar registros: ' + E.Message);
      end;
    end;
    on E: Exception do
    begin
      ShowStatus('Erro ao listar: ' + E.Message, True);
      ShowMessage('Erro ao listar registros: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInsertClick(Sender: TObject);
var
  LConfig: TConfigParameter;
  LParamList: TParameterList;
  LParam: TParameter;
  LSuccess: Boolean;
  I: Integer;
begin
  if not ValidateFields then
    Exit;
    
  try
    // DIFERENÇA vs ORIGINAL:
    // Original: LParameter := GetParameterFromFields; (retorna TParameter diretamente)
    // Aqui: LConfig := GetConfigFromFields; (retorna TConfigParameter - classe tipada)
    LConfig := GetConfigFromFields;
    
    try
      // MELHORIA: Usa FAttributeMapper para converter TConfigParameter → TParameterList via RTTI
      // Isso elimina código manual e usa os Attributes definidos na classe
      LParamList := FAttributeMapper.MapClassToParameters(LConfig);
      try
        // Busca o parâmetro principal (chave) na lista retornada
        LParam := nil;
        for I := 0 to LParamList.Count - 1 do
        begin
          if SameText(LParamList[I].Name, LConfig.Chave) then
          begin
            LParam := LParamList[I];
            Break;
          end;
        end;
        
        if LParam = nil then
        begin
          ShowStatus('Erro: Parâmetro não encontrado na lista mapeada.', True);
          ShowMessage('Erro: Não foi possível mapear a classe para parâmetro.');
          Exit;
        end;
        
        // Define timestamps
        LParam.CreatedAt := Now;
        LParam.UpdatedAt := Now;
        
        // Usa versão fluente do Insert
        FParameters.Insert(LParam, LSuccess).Refresh;
        
        if LSuccess then
        begin
          ShowStatus('Registro inserido com sucesso!');
          ClearFields;
          LoadDataToListView(FFiltroTexto, FFiltroContrato, FFiltroProduto);
          ShowMessage('Registro inserido com sucesso!');
        end
        else
        begin
          ShowStatus('Erro ao inserir registro. Verifique se a chave já existe.', True);
          ShowMessage('Erro ao inserir registro. Verifique se a chave já existe.');
        end;
      finally
        // Não libera LParam pois ele pertence à lista
        LParamList.ClearAll;
        LParamList.Free;
      end;
    finally
      LConfig.Free;
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao inserir: ' + E.Message, True);
      ShowMessage('Erro ao inserir registro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnUpdateClick(Sender: TObject);
var
  LConfig: TConfigParameter;
  LParamList: TParameterList;
  LParam: TParameter;
  LSuccess: Boolean;
  I: Integer;
begin
  if Trim(edtChave.Text) = '' then
  begin
    ShowMessage('Selecione um registro para atualizar.');
    Exit;
  end;
    
  if not ValidateFields then
    Exit;
    
  try
    // DIFERENÇA vs ORIGINAL:
    // Original: LParameter := GetParameterFromFields; (retorna TParameter)
    // Aqui: LConfig := GetConfigFromFields; (retorna TConfigParameter - classe tipada)
    LConfig := GetConfigFromFields;
    
    try
      // MELHORIA: Usa FAttributeMapper para converter TConfigParameter → TParameterList via RTTI
      // Isso elimina código manual e usa os Attributes definidos na classe
      LParamList := FAttributeMapper.MapClassToParameters(LConfig);
      try
        // Busca o parâmetro principal (chave) na lista retornada
        LParam := nil;
        for I := 0 to LParamList.Count - 1 do
        begin
          if SameText(LParamList[I].Name, LConfig.Chave) then
          begin
            LParam := LParamList[I];
            Break;
          end;
        end;
        
        if LParam = nil then
        begin
          ShowStatus('Erro: Parâmetro não encontrado na lista mapeada.', True);
          ShowMessage('Erro: Não foi possível mapear a classe para parâmetro.');
          Exit;
        end;
        
        // Define timestamp de atualização
        LParam.UpdatedAt := Now;
        
        // Usa versão fluente do Setter
        FParameters.Setter(LParam, LSuccess).Refresh;
        
        if LSuccess then
        begin
          ShowStatus('Registro atualizado com sucesso!');
          LoadDataToListView(FFiltroTexto, FFiltroContrato, FFiltroProduto);
          ShowMessage('Registro atualizado com sucesso!');
        end
        else
        begin
          ShowStatus('Erro ao atualizar registro. Verifique se o registro existe.', True);
          ShowMessage('Erro ao atualizar registro. Verifique se o registro existe.');
        end;
      finally
        // Não libera LParam pois ele pertence à lista
        LParamList.ClearAll;
        LParamList.Free;
      end;
    finally
      LConfig.Free;
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao atualizar: ' + E.Message, True);
      ShowMessage('Erro ao atualizar registro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnDeleteClick(Sender: TObject);
var
  LChave: string;
  LSuccess: Boolean;
begin
  if Trim(edtChave.Text) = '' then
  begin
    ShowMessage('Selecione um registro para deletar.');
    Exit;
  end;
    
  LChave := Trim(edtChave.Text);
  
  if MessageDlg(Format('Deseja realmente deletar o registro com chave "%s"?', [LChave]),
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;
    
  try
    // Usa versão fluente do Delete
    FParameters.Delete(LChave, LSuccess).Refresh;
    
    if LSuccess then
    begin
      ShowStatus('Registro deletado com sucesso!');
      ClearFields;
      LoadDataToListView(FFiltroTexto, FFiltroContrato, FFiltroProduto);
      ShowMessage('Registro deletado com sucesso!');
    end
    else
    begin
      ShowStatus('Erro ao deletar registro.', True);
      ShowMessage('Erro ao deletar registro.');
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao deletar: ' + E.Message, True);
      ShowMessage('Erro ao deletar registro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnGetClick(Sender: TObject);
var
  LChave: string;
  LParameter: TParameter;
  LParamList: TParameterList;
  LConfig: TConfigParameter;
begin
  LChave := Trim(edtChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Informe a chave para buscar.');
    edtChave.SetFocus;
    Exit;
  end;
  
  try
    // Configura hierarquia completa antes de buscar
    if (Trim(edtContratoID.Text) <> '') and (Trim(edtProdutoID.Text) <> '') and (Trim(edtTitulo.Text) <> '') then
    begin
      FParameters.Database
        .ContratoID(StrToIntDef(edtContratoID.Text, 0))
        .ProdutoID(StrToIntDef(edtProdutoID.Text, 0))
        .Title(Trim(edtTitulo.Text))
        .Getter(LChave, LParameter);
    end
    else
    begin
      // Busca ampla
      FParameters.Database.Getter(LChave, LParameter);
    end;
    
    if Assigned(LParameter) and (LParameter.Name <> '') then
    begin
      // MELHORIA: Usa FAttributeMapper para converter TParameter → TConfigParameter via RTTI
      // Isso usa os Attributes definidos na classe para mapeamento automático
      LConfig := TConfigParameter.Create;
      LParamList := nil;
      try
        // Cria TParameterList com o parâmetro único para usar MapParametersToClass
        LParamList := TParameterList.Create;
        LParamList.Add(LParameter);
        
        // Usa FAttributeMapper para preencher TConfigParameter a partir de TParameterList
        FAttributeMapper.MapParametersToClass(LParamList, LConfig);
        
        // Carrega campos do formulário
        LoadFieldsFromConfig(LConfig);
        ShowStatus(Format('Parâmetro "%s" encontrado!', [LChave]));
      finally
        // Não libera LParameter pois ele será liberado abaixo
        LParamList.Clear; // Apenas limpa, não libera objetos
        LParamList.Free;
        LConfig.Free;
      end;
    end
    else
    begin
      ShowStatus(Format('Parâmetro "%s" não encontrado.', [LChave]), True);
      ShowMessage(Format('Parâmetro "%s" não encontrado.', [LChave]));
    end;
    
    if Assigned(LParameter) then
    begin
      LParameter.Free;
      LParameter := nil;
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao buscar: ' + E.Message, True);
      ShowMessage('Erro ao buscar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnClearClick(Sender: TObject);
begin
  ClearFields;
  ShowStatus('Campos limpos.');
end;

procedure TfrmParamentersAttributers.btnRefreshClick(Sender: TObject);
begin
  try
    FParameters.Refresh;
    LoadDataToListView(FFiltroTexto, FFiltroContrato, FFiltroProduto);
    ShowStatus('Dados renovados do banco de dados com sucesso!');
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao renovar dados: ' + E.Message, True);
      ShowMessage('Erro ao renovar dados: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnFiltrarClick(Sender: TObject);
var
  LFiltrosAtivos: TStringList;
begin
  try
    FFiltroTexto := Trim(edtFiltro.Text);
    FFiltroContrato := StrToIntDef(Trim(edtFiltroContrato.Text), 0);
    FFiltroProduto := StrToIntDef(Trim(edtFiltroProduto.Text), 0);
    
    LoadDataToListView(FFiltroTexto, FFiltroContrato, FFiltroProduto);
    
    LFiltrosAtivos := TStringList.Create;
    try
      if FFiltroTexto <> '' then
        LFiltrosAtivos.Add(Format('Texto: "%s"', [FFiltroTexto]));
      if FFiltroContrato > 0 then
        LFiltrosAtivos.Add(Format('Contrato: %d', [FFiltroContrato]));
      if FFiltroProduto > 0 then
        LFiltrosAtivos.Add(Format('Produto: %d', [FFiltroProduto]));
      
      if LFiltrosAtivos.Count > 0 then
        ShowStatus(Format('Filtros aplicados [%s] - %d registro(s) encontrado(s).', 
                         [LFiltrosAtivos.DelimitedText, lvConfig.Items.Count]))
      else
        ShowStatus(Format('Listagem completa. %d registro(s) encontrado(s).', [lvConfig.Items.Count]));
    finally
      LFiltrosAtivos.Free;
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao filtrar: ' + E.Message, True);
      ShowMessage('Erro ao filtrar registros: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnLimparFiltroClick(Sender: TObject);
begin
  edtFiltro.Text := '';
  edtFiltroContrato.Text := '';
  edtFiltroProduto.Text := '';
  FFiltroTexto := '';
  FFiltroContrato := 0;
  FFiltroProduto := 0;
  btnListClick(nil);
end;

procedure TfrmParamentersAttributers.btnDatabaseImportIniClick(Sender: TObject);
var
  LSuccess: Boolean;
  LList: TParameterList;
  I: Integer;
  LParam: TParameter;
  LParamSuccess: Boolean;
  LFilePath: string;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Configure o sistema de parâmetros primeiro.');
    Exit;
  end;
  
  try
    if not Assigned(dlgInifilesOpen) then
    begin
      ShowStatus('Diálogo de seleção de arquivo não configurado.', True);
      Exit;
    end;
    
    dlgInifilesOpen.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
    dlgInifilesOpen.FilterIndex := 1;
    dlgInifilesOpen.Title := 'Importar do INI para Database - Selecionar arquivo';
    dlgInifilesOpen.Options := dlgInifilesOpen.Options + [ofFileMustExist];
    
    if Trim(edtInifilesFilePath.Text) <> '' then
      dlgInifilesOpen.FileName := edtInifilesFilePath.Text;
    
    if not dlgInifilesOpen.Execute then
    begin
      ShowStatus('Importação cancelada pelo usuário.');
      Exit;
    end;
    
    LFilePath := dlgInifilesOpen.FileName;
    FParameters.Inifiles.FilePath(LFilePath);
    
    if (FFiltroContrato > 0) or (FFiltroProduto > 0) then
      FParameters.Inifiles.ContratoID(FFiltroContrato).ProdutoID(FFiltroProduto);
    
    LList := FParameters.Inifiles.List;
    try
      for I := 0 to LList.Count - 1 do
      begin
        LParam := LList[I];
        FParameters.Insert(LParam, LParamSuccess);
        if not LParamSuccess then
          FParameters.Setter(LParam, LParamSuccess);
      end;
      LSuccess := True;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    if LSuccess then
    begin
      ShowStatus(Format('Importação do INI para Database concluída com sucesso! Arquivo: %s', [LFilePath]));
      LoadDataToListView;
      ShowMessage(Format('Parâmetros importados do INI para o Database com sucesso!'#13#10#13#10'Arquivo importado:'#13#10'%s', [LFilePath]));
    end
    else
    begin
      ShowStatus('Erro ao importar do INI.', True);
      ShowMessage('Erro ao importar parâmetros do INI.');
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao importar do INI: ' + E.Message, True);
      ShowMessage('Erro ao importar parâmetros do INI: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnDatabaseImportJsonClick(Sender: TObject);
var
  LSuccess: Boolean;
  LList: TParameterList;
  I: Integer;
  LParam: TParameter;
  LParamSuccess: Boolean;
  LFilePath: string;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Configure o sistema de parâmetros primeiro.');
    Exit;
  end;
  
  try
    if not Assigned(dlgJsonObjectOpen) then
    begin
      ShowStatus('Diálogo de seleção de arquivo não configurado.', True);
      Exit;
    end;
    
    dlgJsonObjectOpen.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
    dlgJsonObjectOpen.FilterIndex := 1;
    dlgJsonObjectOpen.Title := 'Importar do JSON para Database - Selecionar arquivo';
    dlgJsonObjectOpen.Options := dlgJsonObjectOpen.Options + [ofFileMustExist];
    
    if Trim(edtJsonObjectFilePath.Text) <> '' then
      dlgJsonObjectOpen.FileName := edtJsonObjectFilePath.Text;
    
    if not dlgJsonObjectOpen.Execute then
    begin
      ShowStatus('Importação cancelada pelo usuário.');
      Exit;
    end;
    
    LFilePath := dlgJsonObjectOpen.FileName;
    FParameters.JsonObject.FilePath(LFilePath);
    FParameters.JsonObject.LoadFromFile(LFilePath, LSuccess);
    if not LSuccess then
    begin
      ShowStatus('Erro ao carregar arquivo JSON.', True);
      ShowMessage('Erro ao carregar arquivo JSON.');
      Exit;
    end;
    
    FParameters.JsonObject.ContratoID(0).ProdutoID(0);
    
    if (FFiltroContrato > 0) or (FFiltroProduto > 0) then
      FParameters.JsonObject.ContratoID(FFiltroContrato).ProdutoID(FFiltroProduto);
    
    try
      LList := FParameters.JsonObject.List;
    except
      on E: Exception do
      begin
        ShowStatus('Erro ao listar parâmetros do JSON: ' + E.Message, True);
        ShowMessage('Erro ao processar arquivo JSON: ' + E.Message);
        Exit;
      end;
    end;
    
    try
      if LList.Count = 0 then
      begin
        ShowStatus('Nenhum parâmetro encontrado no arquivo JSON para importar.', True);
        ShowMessage('O arquivo JSON não contém parâmetros para importar.');
        Exit;
      end;
      
      LSuccess := False;
      for I := 0 to LList.Count - 1 do
      begin
        LParam := LList[I];
        FParameters.Insert(LParam, LParamSuccess);
        if not LParamSuccess then
          FParameters.Setter(LParam, LParamSuccess);
        if LParamSuccess then
          LSuccess := True;
      end;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    if LSuccess then
    begin
      ShowStatus(Format('Importação do JSON para Database concluída com sucesso! Arquivo: %s', [LFilePath]));
      LoadDataToListView;
      ShowMessage(Format('Parâmetros importados do JSON para o Database com sucesso!'#13#10#13#10'Arquivo importado:'#13#10'%s', [LFilePath]));
    end
    else
    begin
      ShowStatus('Erro ao importar do JSON.', True);
      ShowMessage('Erro ao importar parâmetros do JSON.');
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao importar do JSON: ' + E.Message, True);
      ShowMessage('Erro ao importar parâmetros do JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnDatabaseExportIniClick(Sender: TObject);
var
  LSuccess: Boolean;
  LFilePath: string;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro.');
    Exit;
  end;
  
  try
    if (FFiltroContrato > 0) or (FFiltroProduto > 0) then
    begin
      FParameters.Database.ContratoID(FFiltroContrato).ProdutoID(FFiltroProduto);
      FParameters.Inifiles.ContratoID(FFiltroContrato).ProdutoID(FFiltroProduto);
    end;
    
    FParameters.Inifiles.ImportFromDatabase(FParameters.Database, LSuccess);
    
    if not LSuccess then
    begin
      ShowStatus('Erro ao importar dados do Database para INI.', True);
      ShowMessage('Erro ao importar parâmetros do Database para INI.');
      Exit;
    end;
    
    if not Assigned(dlgInifilesSave) then
    begin
      ShowStatus('Diálogo de salvamento não configurado.', True);
      Exit;
    end;
    
    dlgInifilesSave.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
    dlgInifilesSave.FilterIndex := 1;
    dlgInifilesSave.Title := 'Salvar arquivo INI - Exportar do Database';
    dlgInifilesSave.DefaultExt := 'ini';
    
    if Trim(edtInifilesFilePath.Text) <> '' then
      dlgInifilesSave.FileName := edtInifilesFilePath.Text
    else
      dlgInifilesSave.FileName := 'config_export.ini';
    
    if dlgInifilesSave.Execute then
    begin
      LFilePath := dlgInifilesSave.FileName;
      FParameters.Inifiles.FilePath(LFilePath);
      FParameters.Inifiles.ImportFromDatabase(FParameters.Database, LSuccess);
      
      if LSuccess then
      begin
        edtInifilesFilePath.Text := LFilePath;
        ShowStatus(Format('Exportação concluída! Arquivo salvo em: %s', [LFilePath]));
        ShowMessage(Format('Parâmetros exportados do Database para o INI com sucesso!'#13#10#13#10'Arquivo salvo em:'#13#10'%s', [LFilePath]));
      end
      else
      begin
        ShowStatus('Erro ao salvar arquivo INI.', True);
        ShowMessage('Erro ao salvar arquivo INI.');
      end;
    end
    else
      ShowStatus('Exportação cancelada pelo usuário.');
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao exportar para INI: ' + E.Message, True);
      ShowMessage('Erro ao exportar parâmetros para INI: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnDatabaseExportJsonClick(Sender: TObject);
var
  LSuccess: Boolean;
  LFilePath: string;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro.');
    Exit;
  end;
  
  try
    if (FFiltroContrato > 0) or (FFiltroProduto > 0) then
    begin
      FParameters.Database.ContratoID(FFiltroContrato).ProdutoID(FFiltroProduto);
      FParameters.JsonObject.ContratoID(FFiltroContrato).ProdutoID(FFiltroProduto);
    end;
    
    FParameters.JsonObject.ImportFromDatabase(FParameters.Database, LSuccess);
    
    if not LSuccess then
    begin
      ShowStatus('Erro ao importar dados do Database para JSON.', True);
      ShowMessage('Erro ao importar parâmetros do Database para JSON.');
      Exit;
    end;
    
    if not Assigned(dlgJsonObjectSave) then
    begin
      ShowStatus('Diálogo de salvamento não configurado.', True);
      Exit;
    end;
    
    dlgJsonObjectSave.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
    dlgJsonObjectSave.FilterIndex := 1;
    dlgJsonObjectSave.Title := 'Salvar arquivo JSON - Exportar do Database';
    dlgJsonObjectSave.DefaultExt := 'json';
    
    if Trim(edtJsonObjectFilePath.Text) <> '' then
      dlgJsonObjectSave.FileName := edtJsonObjectFilePath.Text
    else
      dlgJsonObjectSave.FileName := 'config_export.json';
    
    if dlgJsonObjectSave.Execute then
    begin
      LFilePath := dlgJsonObjectSave.FileName;
      FParameters.JsonObject.SaveToFile(LFilePath, LSuccess);
      
      if LSuccess then
      begin
        edtJsonObjectFilePath.Text := LFilePath;
        ShowStatus(Format('Exportação concluída! Arquivo salvo em: %s', [LFilePath]));
        ShowMessage(Format('Parâmetros exportados do Database para o JSON com sucesso!'#13#10#13#10'Arquivo salvo em:'#13#10'%s', [LFilePath]));
      end
      else
      begin
        ShowStatus('Erro ao salvar arquivo JSON.', True);
        ShowMessage('Erro ao salvar arquivo JSON.');
      end;
    end
    else
      ShowStatus('Exportação cancelada pelo usuário.');
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao exportar para JSON: ' + E.Message, True);
      ShowMessage('Erro ao exportar parâmetros para JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.lvConfigSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  LChave: string;
  LParameter: TParameter;
  LParamList: TParameterList;
  LConfig: TConfigParameter;
begin
  if not Selected or (Item = nil) then
    Exit;
    
  LParameter := nil;
  LParamList := nil;
  try
    if Item.SubItems.Count > 4 then
    begin
      LChave := Item.SubItems[4];
      FParameters.Database
        .ContratoID(StrToIntDef(Item.SubItems[0], 0))
        .ProdutoID(StrToIntDef(Item.SubItems[1], 0))
        .Title(Item.SubItems[3])
        .Getter(LChave, LParameter);
    end
    else
    begin
      ShowStatus('Erro: Item sem dados suficientes.', True);
      Exit;
    end;
    
    if Assigned(LParameter) and (LParameter.Name <> '') then
    begin
      // DIFERENÇA vs ORIGINAL:
      // Original: LoadFieldsFromParameter(LParameter); (usa TParameter diretamente)
      // Aqui: Usa FAttributeMapper para converter TParameter → TConfigParameter via RTTI
      // MELHORIA: Usa os Attributes definidos na classe para mapeamento automático
      LConfig := TConfigParameter.Create;
      try
        // Cria TParameterList com o parâmetro único para usar MapParametersToClass
        LParamList := TParameterList.Create;
        LParamList.Add(LParameter);
        
        // Usa FAttributeMapper para preencher TConfigParameter a partir de TParameterList
        // Isso usa RTTI e os Attributes para mapear automaticamente
        FAttributeMapper.MapParametersToClass(LParamList, LConfig);
        
        // DIFERENÇA: Usa LoadFieldsFromConfig ao invés de LoadFieldsFromParameter
        LoadFieldsFromConfig(LConfig);
        ShowStatus(Format('Registro carregado: %s (ID: %s)', [LChave, Item.Caption]));
      finally
        // Não libera LParameter pois ele será liberado abaixo
        LParamList.Clear; // Apenas limpa, não libera objetos
        LParamList.Free;
        LConfig.Free;
      end;
    end
    else
      ShowStatus('Registro não encontrado.', True);
  except
    on E: Exception do
      ShowStatus('Erro ao carregar registro: ' + E.Message, True);
  end;
  
  if Assigned(LParameter) then
  begin
    LParameter.Free;
    LParameter := nil;
  end;
end;

procedure TfrmParamentersAttributers.lvConfigColumnClick(Sender: TObject; Column: TListColumn);
begin
  if FSortColumn = Column.Index then
    FSortAscending := not FSortAscending
  else
  begin
    FSortColumn := Column.Index;
    FSortAscending := True;
  end;
  
  SortListView(FSortColumn);
  ShowStatus(Format('Ordenado por "%s" (%s)', 
                   [Column.Caption, 
                    IfThen(FSortAscending, 'Crescente', 'Decrescente')]));
end;

procedure TfrmParamentersAttributers.LoadDataToListView(const AFiltroTexto: string = ''; AFiltroContrato: Integer = 0; AFiltroProduto: Integer = 0);
var
  LList: TParameterList;
  LItem: TListItem;
  LParameter: TParameter;
  I: Integer;
  LValue: string;
  LFiltroUpper: string;
  LMostraItem: Boolean;
begin
  lvConfig.Items.BeginUpdate;
  try
    try
      lvConfig.Items.Clear;
      LList := FParameters.Database.List;
      LFiltroUpper := UpperCase(Trim(AFiltroTexto));
      
      try
        for I := 0 to LList.Count - 1 do
        begin
          LParameter := LList[I];
          LMostraItem := True;
          
          if LFiltroUpper <> '' then
          begin
            LMostraItem := (Pos(LFiltroUpper, UpperCase(LParameter.Name)) > 0) or
                          (Pos(LFiltroUpper, UpperCase(LParameter.Titulo)) > 0) or
                          (Pos(LFiltroUpper, UpperCase(LParameter.Value)) > 0) or
                          (Pos(LFiltroUpper, UpperCase(LParameter.Description)) > 0);
          end;
          
          if LMostraItem and (AFiltroContrato > 0) then
            LMostraItem := (LParameter.ContratoID = AFiltroContrato);
          
          if LMostraItem and (AFiltroProduto > 0) then
            LMostraItem := (LParameter.ProdutoID = AFiltroProduto);
          
          if LMostraItem then
          begin
            LValue := LParameter.Value;
            if Length(LValue) > 50 then
              LValue := Copy(LValue, 1, 50) + '...';
            
            LItem := lvConfig.Items.Add;
            LItem.Caption := IntToStr(LParameter.ID);
            LItem.SubItems.Add(IntToStr(LParameter.ContratoID));
            LItem.SubItems.Add(IntToStr(LParameter.ProdutoID));
            LItem.SubItems.Add(IntToStr(LParameter.Ordem));
            LItem.SubItems.Add(LParameter.Titulo);
            LItem.SubItems.Add(LParameter.Name);
            LItem.SubItems.Add(LValue);
            LItem.SubItems.Add(LParameter.Description);
            LItem.SubItems.Add(IfThen(LParameter.Ativo, 'Sim', 'Não'));
            LItem.Data := Pointer(I);
          end;
        end;
      finally
        LList.ClearAll;
        LList.Free;
      end;
      
      if FSortColumn >= 0 then
        SortListView(FSortColumn)
      else
        SortListViewDefault;
    except
      on E: Exception do
      begin
        ShowStatus('Erro ao carregar lista: ' + E.Message, True);
        raise;
      end;
    end;
  finally
    lvConfig.Items.EndUpdate;
  end;
end;

procedure TfrmParamentersAttributers.ClearFields;
begin
  // DIFERENÇA vs ORIGINAL:
  // Original: Libera FCurrentParameter (TParameter) e cria novo TParameter.Create
  // Aqui: Libera FCurrentConfig (TConfigParameter) e cria novo TConfigParameter.Create
  // Comportamento similar, mas usando classe tipada ao invés de TParameter
  
  edtContratoID.Text := '1';
  edtProdutoID.Text := '1';
  edtOrdem.Text := '1';
  edtTitulo.Text := '';
  edtChave.Text := '';
  memoValor.Clear;
  memoDescricao.Clear;
  chkAtivo.Checked := True;
  
  // DIFERENÇA: No original usa FCurrentParameter (TParameter)
  // Aqui usa FCurrentConfig (TConfigParameter) - classe tipada
  if Assigned(FCurrentConfig) then
  begin
    FCurrentConfig.Free;
    FCurrentConfig := nil;
  end;
  FCurrentConfig := TConfigParameter.Create;
end;

procedure TfrmParamentersAttributers.LoadFieldsFromConfig(const AConfig: TConfigParameter);
begin
  // DIFERENÇA vs ORIGINAL:
  // Original: LoadFieldsFromParameter(const AParameter: TParameter)
  //   - Recebe TParameter diretamente do módulo Parameters
  //   - Preenche campos do formulário a partir de TParameter
  //   - Cria cópia: FCurrentParameter := TParameter.Create; (copia todas as propriedades)
  //
  // Aqui: LoadFieldsFromConfig(const AConfig: TConfigParameter)
  //   - Recebe TConfigParameter (classe tipada com Attributes)
  //   - Preenche campos do formulário a partir de TConfigParameter
  //   - VANTAGEM: Propriedades tipadas (Integer, string, Boolean) ao invés de Variant
  //   - VANTAGEM: IntelliSense funciona melhor com propriedades tipadas
  //   - VANTAGEM: Pode adicionar validações na classe usando Attributes
  
  if not Assigned(AConfig) then
    Exit;
    
  // Libera instância anterior (se existir)
  if Assigned(FCurrentConfig) then
  begin
    FCurrentConfig.Free;
    FCurrentConfig := nil;
  end;
  
  // Cria cópia da configuração atual
  // DIFERENÇA: No original usa FCurrentParameter (TParameter)
  // Aqui usa FCurrentConfig (TConfigParameter) - classe tipada
  FCurrentConfig := TConfigParameter.Create;
  FCurrentConfig.ContratoID := AConfig.ContratoID;
  FCurrentConfig.ProdutoID := AConfig.ProdutoID;
  FCurrentConfig.Ordem := AConfig.Ordem;
  FCurrentConfig.Titulo := AConfig.Titulo;
  FCurrentConfig.Chave := AConfig.Chave;
  FCurrentConfig.Valor := AConfig.Valor;
  FCurrentConfig.Descricao := AConfig.Descricao;
  FCurrentConfig.Ativo := AConfig.Ativo;
  
  edtContratoID.Text := IntToStr(AConfig.ContratoID);
  edtProdutoID.Text := IntToStr(AConfig.ProdutoID);
  edtOrdem.Text := IntToStr(AConfig.Ordem);
  edtTitulo.Text := AConfig.Titulo;
  edtChave.Text := AConfig.Chave;
  memoValor.Text := AConfig.Valor;
  memoDescricao.Text := AConfig.Descricao;
  chkAtivo.Checked := AConfig.Ativo;
end;

function TfrmParamentersAttributers.GetConfigFromFields: TConfigParameter;
begin
  // DIFERENÇA vs ORIGINAL:
  // Original: GetParameterFromFields: TParameter
  //   - Cria TParameter diretamente
  //   - Preenche propriedades de TParameter (Name, Value, Description, etc.)
  //   - Retorna TParameter (classe do módulo Parameters)
  //
  // Aqui: GetConfigFromFields: TConfigParameter
  //   - Cria TConfigParameter (classe tipada com Attributes)
  //   - Preenche propriedades tipadas (ContratoID: Integer, Chave: string, etc.)
  //   - VANTAGEM: Type-safety - propriedades tipadas ao invés de Variant
  //   - VANTAGEM: IntelliSense funciona melhor
  //   - VANTAGEM: Pode adicionar validações na classe
  //   - MELHORIA: No futuro, pode usar FAttributeMapper para preencher automaticamente via RTTI
  
  Result := TConfigParameter.Create;
  Result.ContratoID := StrToIntDef(edtContratoID.Text, 1);
  Result.ProdutoID := StrToIntDef(edtProdutoID.Text, 1);
  Result.Ordem := StrToIntDef(edtOrdem.Text, 0);
  Result.Titulo := Trim(edtTitulo.Text);
  Result.Chave := Trim(edtChave.Text); // Chave do TConfigParameter (mapeia para TParameter.Name)
  Result.Valor := memoValor.Text;
  Result.Descricao := memoDescricao.Text;
  Result.Ativo := chkAtivo.Checked;
end;

function TfrmParamentersAttributers.ValidateFields: Boolean;
begin
  Result := False;
  
  if Trim(edtContratoID.Text) = '' then
  begin
    ShowMessage('O campo "Contrato ID" é obrigatório.');
    edtContratoID.SetFocus;
    Exit;
  end;
  
  if Trim(edtProdutoID.Text) = '' then
  begin
    ShowMessage('O campo "Produto ID" é obrigatório.');
    edtProdutoID.SetFocus;
    Exit;
  end;
  
  if Trim(edtChave.Text) = '' then
  begin
    ShowMessage('O campo "Chave" é obrigatório.');
    edtChave.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

procedure TfrmParamentersAttributers.ShowStatus(const AMessage: string; AIsError: Boolean = False);
begin
  lblStatus.Caption := AMessage;
  if AIsError then
    lblStatus.Font.Color := clRed
  else
    lblStatus.Font.Color := clGreen;
end;

procedure TfrmParamentersAttributers.SortListView(AColumn: Integer);
var
  I, J: Integer;
  LItem1, LItem2: TListItem;
  LNeedSwap: Boolean;
  LVal1: string;
  
  function CompareItems(AItem1, AItem2: TListItem; APrimaryColumn: Integer): Integer;
  var
    LVal1, LVal2: string;
    LInt1, LInt2: Integer;
    
    function GetColumnValue(AItem: TListItem; ACol: Integer): string;
    begin
      if ACol = 0 then
        Result := AItem.Caption
      else
        Result := AItem.SubItems[ACol - 1];
    end;
    
    function CompareColumn(ACol: Integer): Integer;
    begin
      LVal1 := GetColumnValue(AItem1, ACol);
      LVal2 := GetColumnValue(AItem2, ACol);
      
      case ACol of
        0, 1, 2, 3:
          begin
            LInt1 := StrToIntDef(LVal1, 0);
            LInt2 := StrToIntDef(LVal2, 0);
            if LInt1 < LInt2 then
              Result := -1
            else if LInt1 > LInt2 then
              Result := 1
            else
              Result := 0;
          end;
      else
        Result := CompareText(LVal1, LVal2);
      end;
    end;
    
  begin
    Result := CompareColumn(APrimaryColumn);
    if Result <> 0 then
      Exit;
    
    if APrimaryColumn <> 1 then
    begin
      Result := CompareColumn(1);
      if Result <> 0 then
        Exit;
    end;
    
    if APrimaryColumn <> 2 then
    begin
      Result := CompareColumn(2);
      if Result <> 0 then
        Exit;
    end;
    
    if APrimaryColumn <> 3 then
    begin
      Result := CompareColumn(3);
      if Result <> 0 then
        Exit;
    end;
    
    if APrimaryColumn <> 4 then
    begin
      Result := CompareColumn(4);
      if Result <> 0 then
        Exit;
    end;
    
    if APrimaryColumn <> 5 then
    begin
      Result := CompareColumn(5);
      if Result <> 0 then
        Exit;
    end;
    
    Result := 0;
  end;
  
begin
  if lvConfig.Items.Count < 2 then
    Exit;
    
  lvConfig.Items.BeginUpdate;
  try
    for I := 0 to lvConfig.Items.Count - 2 do
    begin
      for J := I + 1 to lvConfig.Items.Count - 1 do
      begin
        LItem1 := lvConfig.Items[I];
        LItem2 := lvConfig.Items[J];
        
        if FSortAscending then
          LNeedSwap := CompareItems(LItem1, LItem2, AColumn) > 0
        else
          LNeedSwap := CompareItems(LItem1, LItem2, AColumn) < 0;
        
        if LNeedSwap then
        begin
          LVal1 := LItem1.Caption;
          LItem1.Caption := LItem2.Caption;
          LItem2.Caption := LVal1;
          
          LVal1 := LItem1.SubItems.DelimitedText;
          LItem1.SubItems.DelimitedText := LItem2.SubItems.DelimitedText;
          LItem2.SubItems.DelimitedText := LVal1;
          
          LVal1 := IntToStr(Integer(LItem1.Data));
          LItem1.Data := LItem2.Data;
          LItem2.Data := Pointer(StrToIntDef(LVal1, 0));
        end;
      end;
    end;
  finally
    lvConfig.Items.EndUpdate;
  end;
end;

procedure TfrmParamentersAttributers.SortListViewDefault;
var
  I, J: Integer;
  LItem1, LItem2: TListItem;
  LNeedSwap: Boolean;
  LVal1: string;
  
  function CompareItemsDefault(AItem1, AItem2: TListItem): Integer;
  var
    LVal1, LVal2: string;
    LInt1, LInt2: Integer;
    
    function GetColumnValue(AItem: TListItem; ACol: Integer): string;
    begin
      if ACol = 0 then
        Result := AItem.Caption
      else
        Result := AItem.SubItems[ACol - 1];
    end;
    
    function CompareColumn(ACol: Integer): Integer;
    begin
      LVal1 := GetColumnValue(AItem1, ACol);
      LVal2 := GetColumnValue(AItem2, ACol);
      
      case ACol of
        0, 1, 2, 3:
          begin
            LInt1 := StrToIntDef(LVal1, 0);
            LInt2 := StrToIntDef(LVal2, 0);
            if LInt1 < LInt2 then
              Result := -1
            else if LInt1 > LInt2 then
              Result := 1
            else
              Result := 0;
          end;
      else
        Result := CompareText(LVal1, LVal2);
      end;
    end;
    
  begin
    Result := CompareColumn(1);
    if Result <> 0 then
      Exit;
    
    Result := CompareColumn(2);
    if Result <> 0 then
      Exit;
    
    Result := CompareColumn(4);
    if Result <> 0 then
      Exit;
    
    Result := CompareColumn(3);
    if Result <> 0 then
      Exit;
    
    Result := 0;
  end;
  
begin
  if lvConfig.Items.Count < 2 then
    Exit;
    
  lvConfig.Items.BeginUpdate;
  try
    for I := 0 to lvConfig.Items.Count - 2 do
    begin
      for J := I + 1 to lvConfig.Items.Count - 1 do
      begin
        LItem1 := lvConfig.Items[I];
        LItem2 := lvConfig.Items[J];
        LNeedSwap := CompareItemsDefault(LItem1, LItem2) > 0;
        
        if LNeedSwap then
        begin
          LVal1 := LItem1.Caption;
          LItem1.Caption := LItem2.Caption;
          LItem2.Caption := LVal1;
          
          LVal1 := LItem1.SubItems.DelimitedText;
          LItem1.SubItems.DelimitedText := LItem2.SubItems.DelimitedText;
          LItem2.SubItems.DelimitedText := LVal1;
          
          LVal1 := IntToStr(Integer(LItem1.Data));
          LItem1.Data := LItem2.Data;
          LItem2.Data := Pointer(StrToIntDef(LVal1, 0));
        end;
      end;
    end;
    
    ShowStatus('Ordenação padrão aplicada: Contrato → Produto → Título → Ordem');
  finally
    lvConfig.Items.EndUpdate;
  end;
end;

// Métodos de conexão e configuração (copiados do original)
procedure TfrmParamentersAttributers.UpdateConnectionInfo;
var
  LEngine: string;
  LDatabaseType: string;
  LHost: string;
  LDatabase: string;
  LSchema: string;
  LTableName: string;
  LPort: Integer;
  LUsername: string;
  LInfo: string;
  LIsCustom: Boolean;
  LIsConnected: Boolean;
  LDatabaseInterface: IParametersDatabase;
begin
  if not Assigned(FParameters) then
  begin
    lblConexaoInfo.Caption := 'Conexão não inicializada';
    lblConexaoTipo.Caption := '';
    btnConectar.Enabled := True;
    btnDesconectar.Enabled := False;
    Exit;
  end;
  
  try
    LDatabaseInterface := FParameters.Database;
    LDatabaseInterface.IsConnected(LIsConnected);
    
    LEngine := LDatabaseInterface.Engine;
    LDatabaseType := LDatabaseInterface.DatabaseType;
    LHost := LDatabaseInterface.Host;
    LPort := LDatabaseInterface.Port;
    LUsername := LDatabaseInterface.Username;
    LDatabase := LDatabaseInterface.Database;
    LSchema := LDatabaseInterface.Schema;
    LTableName := LDatabaseInterface.TableName;
    
    LIsCustom := (LHost <> '') and (LDatabase <> '') and (LUsername <> '');
    
    if LIsConnected then
      LInfo := Format('[CONECTADO] Engine: %s | Database: %s | Host: %s', [LEngine, LDatabaseType, LHost])
    else
      LInfo := Format('[DESCONECTADO] Engine: %s | Database: %s | Host: %s', [LEngine, LDatabaseType, LHost]);
    
    if LPort > 0 then
      LInfo := LInfo + Format(':%d', [LPort]);
    
    LInfo := LInfo + Format(' | User: %s | DB: %s', [LUsername, LDatabase]);
    
    if LSchema <> '' then
      LInfo := LInfo + Format(' | Schema: %s', [LSchema]);
    
    if LTableName <> '' then
      LInfo := LInfo + Format(' | Table: %s', [LTableName]);
    
    lblConexaoInfo.Caption := LInfo;
    
    if LIsCustom then
      lblConexaoTipo.Caption := '✓ Conexão Customizada (Configuração Manual)'
    else
      lblConexaoTipo.Caption := '⚠ Conexão Padrão (Usando Valores Default)';
    
    lblDLLPath.Caption := GetDLLPath;
    btnConectar.Enabled := not LIsConnected;
    btnDesconectar.Enabled := LIsConnected;
  except
    on E: Exception do
    begin
      lblConexaoInfo.Caption := 'Erro ao obter informações de conexão: ' + E.Message;
      lblConexaoTipo.Caption := '';
      lblDLLPath.Caption := '';
      btnConectar.Enabled := True;
      btnDesconectar.Enabled := False;
    end;
  end;
end;

procedure TfrmParamentersAttributers.LoadConnectionFields;
var
  LDatabaseType: string;
  I: Integer;
  LDatabase: IParametersDatabase;
begin
  if not Assigned(FParameters) then
    Exit;
  
  try
    LDatabase := FParameters.Database;
    LDatabaseType := LDatabase.DatabaseType;
    
    cmbDatabaseType.ItemIndex := -1;
    for I := 0 to cmbDatabaseType.Items.Count - 1 do
    begin
      if SameText(cmbDatabaseType.Items[I], LDatabaseType) then
      begin
        cmbDatabaseType.ItemIndex := I;
        Break;
      end;
    end;
    
    if cmbDatabaseType.ItemIndex = -1 then
      cmbDatabaseType.Text := LDatabaseType;
    
    edtHost.Text := LDatabase.Host;
    edtPort.Text := IntToStr(LDatabase.Port);
    edtUsername.Text := LDatabase.Username;
    edtPassword.Text := LDatabase.Password;
    
    if SameText(LDatabaseType, 'ODBC') then
    begin
      if Trim(cmbODBCDSN.Text) = '' then
        cmbODBCDSN.Text := LDatabase.Database;
    end
    else
    begin
      if Trim(edtDatabase.Text) = '' then
        edtDatabase.Text := LDatabase.Database;
    end;
    edtSchema.Text := LDatabase.Schema;
    edtTableName.Text := LDatabase.TableName;
  except
    on E: Exception do
      ShowStatus('Erro ao carregar campos de conexão: ' + E.Message, True);
  end;
end;

procedure TfrmParamentersAttributers.PopulateDatabaseTypeCombo;
var
  I: TParameterDatabaseTypes;
begin
  cmbDatabaseType.Items.Clear;
  
  for I := Succ(Low(TParameterDatabaseTypes)) to High(TParameterDatabaseTypes) do
    cmbDatabaseType.Items.Add(TDatabaseTypeNames[I]);
  
  cmbDatabaseType.ItemIndex := cmbDatabaseType.Items.IndexOf('PostgreSQL');
  PopulateODBCDatabaseTypeCombo;
  AdjustFieldsByDatabaseType;
end;

function TfrmParamentersAttributers.GetDLLPath: string;
begin
  Result := '';
  // Implementação simplificada - pode ser expandida conforme necessário
end;

procedure TfrmParamentersAttributers.PopulateODBCDatabaseTypeCombo;
var
  I: TParameterDatabaseTypes;
begin
  cmbODBCDatabaseType.Items.Clear;
  
  for I := Succ(Low(TParameterDatabaseTypes)) to High(TParameterDatabaseTypes) do
  begin
    if (I <> pdtNone) and (I <> pdtODBC) and (I <> pdtLDAP) then
      cmbODBCDatabaseType.Items.Add(TDatabaseTypeNames[I]);
  end;
  
  if cmbODBCDatabaseType.Items.Count > 0 then
    cmbODBCDatabaseType.ItemIndex := cmbODBCDatabaseType.Items.IndexOf('PostgreSQL');
end;

procedure TfrmParamentersAttributers.PopulateODBCDSNCombo;
var
  LCurrentText: string;
  LRegistry: TRegistry;
  LValueNames: TStringList;
  I: Integer;
begin
  LCurrentText := cmbODBCDSN.Text;
  cmbODBCDSN.Items.Clear;
  
  LRegistry := TRegistry.Create;
  LValueNames := TStringList.Create;
  try
    LRegistry.RootKey := HKEY_LOCAL_MACHINE;
    if LRegistry.OpenKeyReadOnly('SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources') then
    begin
      LRegistry.GetValueNames(LValueNames);
      for I := 0 to LValueNames.Count - 1 do
      begin
        if cmbODBCDSN.Items.IndexOf(LValueNames[I]) < 0 then
          cmbODBCDSN.Items.Add(LValueNames[I]);
      end;
      LRegistry.CloseKey;
    end;
    
    LValueNames.Clear;
    LRegistry.RootKey := HKEY_CURRENT_USER;
    if LRegistry.OpenKeyReadOnly('SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources') then
    begin
      LRegistry.GetValueNames(LValueNames);
      for I := 0 to LValueNames.Count - 1 do
      begin
        if cmbODBCDSN.Items.IndexOf(LValueNames[I]) < 0 then
          cmbODBCDSN.Items.Add(LValueNames[I]);
      end;
      LRegistry.CloseKey;
    end;
  except
    // Se falhar, permite digitação manual
  end;
  
  if (LCurrentText <> '') and (cmbODBCDSN.Items.IndexOf(LCurrentText) >= 0) then
    cmbODBCDSN.Text := LCurrentText
  else if cmbODBCDSN.Items.Count > 0 then
    cmbODBCDSN.ItemIndex := 0;
end;

function TfrmParamentersAttributers.HandleTableNotExists(const AOperation: string): Boolean;
var
  LTableName: string;
  LResult: Integer;
  LSuccess: Boolean;
  LDatabaseType: string;
  LDatabaseInterface: IParametersDatabase;
begin
  Result := False;
  
  if not Assigned(FParameters) then
    Exit;
  
  try
    LDatabaseInterface := FParameters.Database;
    LDatabaseType := LDatabaseInterface.DatabaseType;
    
    if SameText(LDatabaseType, 'SQLite') then
      LTableName := LDatabaseInterface.TableName
    else if (SameText(LDatabaseType, 'FireBird') or SameText(LDatabaseType, 'Firebird')) then
      LTableName := LDatabaseInterface.TableName
    else if SameText(LDatabaseType, 'MySQL') or SameText(LDatabaseType, 'MariaDB') then
      LTableName := LDatabaseInterface.TableName
    else
    begin
      if LDatabaseInterface.Schema <> '' then
        LTableName := Format('%s.%s', [LDatabaseInterface.Schema, LDatabaseInterface.TableName])
      else
        LTableName := LDatabaseInterface.TableName;
    end;
    
    LResult := MessageDlg(
      Format('A tabela "%s" não existe no banco de dados.'#13#10 +
             'Deseja criar a tabela agora?', [LTableName]),
      mtConfirmation,
      [mbYes, mbNo],
      0,
      mbNo
    );
    
    if LResult = mrYes then
    begin
      LDatabaseInterface.CreateTable(LSuccess);
      
      if LSuccess then
      begin
        ShowStatus(Format('Tabela "%s" criada com sucesso!', [LTableName]));
        ShowMessage(Format('Tabela "%s" criada com sucesso!', [LTableName]));
        Result := True;
      end
      else
      begin
        ShowStatus('Erro ao criar a tabela.', True);
        ShowMessage('Erro ao criar a tabela.');
        Result := False;
      end;
    end
    else
    begin
      ShowStatus(Format('Operação "%s" cancelada: tabela não existe.', [AOperation]));
      Result := False;
    end;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao criar tabela: ' + E.Message, True);
      ShowMessage('Erro ao criar tabela: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TfrmParamentersAttributers.SelectDatabaseFromList(ADatabases: TStringList): string;
var
  LForm: TForm;
  LListBox: TListBox;
  LBtnOK, LBtnCancel: TButton;
  LSelectedIndex: Integer;
begin
  Result := '';
  
  if (not Assigned(ADatabases)) or (ADatabases.Count = 0) then
    Exit;
  
  LForm := TForm.Create(Self);
  try
    LForm.Caption := 'Selecionar Banco de Dados';
    LForm.Width := 400;
    LForm.Height := 400;
    LForm.Position := poScreenCenter;
    LForm.BorderStyle := bsDialog;
    
    LListBox := TListBox.Create(LForm);
    LListBox.Parent := LForm;
    LListBox.Left := 8;
    LListBox.Top := 8;
    LListBox.Width := LForm.ClientWidth - 16;
    LListBox.Height := LForm.ClientHeight - 60;
    LListBox.Anchors := [akLeft, akTop, akRight, akBottom];
    LListBox.Items.Assign(ADatabases);
    LListBox.ItemIndex := 0;
    
    LBtnOK := TButton.Create(LForm);
    LBtnOK.Parent := LForm;
    LBtnOK.Caption := 'OK';
    LBtnOK.ModalResult := mrOK;
    LBtnOK.Left := LForm.ClientWidth - 160;
    LBtnOK.Top := LForm.ClientHeight - 40;
    LBtnOK.Width := 75;
    LBtnOK.Anchors := [akRight, akBottom];
    LBtnOK.Default := True;
    
    LBtnCancel := TButton.Create(LForm);
    LBtnCancel.Parent := LForm;
    LBtnCancel.Caption := 'Cancelar';
    LBtnCancel.ModalResult := mrCancel;
    LBtnCancel.Left := LForm.ClientWidth - 80;
    LBtnCancel.Top := LForm.ClientHeight - 40;
    LBtnCancel.Width := 75;
    LBtnCancel.Anchors := [akRight, akBottom];
    LBtnCancel.Cancel := True;
    
    if LForm.ShowModal = mrOK then
    begin
      LSelectedIndex := LListBox.ItemIndex;
      if (LSelectedIndex >= 0) and (LSelectedIndex < ADatabases.Count) then
        Result := ADatabases[LSelectedIndex];
    end;
  finally
    LForm.Free;
  end;
end;

procedure TfrmParamentersAttributers.AdjustFieldsByDatabaseType;
var
  LDatabaseType: string;
  LIsFileBased: Boolean;
  LIsFireBird: Boolean;
  LIsODBC: Boolean;
  LHasSchema: Boolean;
  LODBCDBType: string;
begin
  if cmbDatabaseType.ItemIndex < 0 then
    Exit;
    
  LDatabaseType := cmbDatabaseType.Text;
  LIsFileBased := SameText(LDatabaseType, 'SQLite') or SameText(LDatabaseType, 'Access');
  LIsFireBird := SameText(LDatabaseType, 'FireBird') or SameText(LDatabaseType, 'Firebird');
  LIsODBC := SameText(LDatabaseType, 'ODBC');
  
  lblHost.Visible := (not LIsFileBased and not LIsODBC) or LIsFireBird;
  edtHost.Visible := (not LIsFileBased and not LIsODBC) or LIsFireBird;
  lblPort.Visible := (not LIsFileBased and not LIsODBC) or LIsFireBird;
  edtPort.Visible := (not LIsFileBased and not LIsODBC) or LIsFireBird;
  btnSelectDatabase.Visible := LIsFileBased or LIsFireBird;
  
  lblODBCDatabaseType.Visible := LIsODBC;
  cmbODBCDatabaseType.Visible := LIsODBC;
  
  if LIsODBC then
  begin
    edtDatabase.Visible := False;
    cmbODBCDSN.Visible := True;
    PopulateODBCDSNCombo;
  end
  else
  begin
    edtDatabase.Visible := True;
    cmbODBCDSN.Visible := False;
  end;
  
  if LIsODBC then
  begin
    lblUsername.Visible := False;
    edtUsername.Visible := False;
    lblPassword.Visible := False;
    edtPassword.Visible := False;
  end
  else
  begin
    lblUsername.Visible := True;
    edtUsername.Visible := True;
    lblPassword.Visible := True;
    edtPassword.Visible := True;
  end;
  
  if LIsODBC then
  begin
    if cmbODBCDatabaseType.ItemIndex >= 0 then
    begin
      LODBCDBType := cmbODBCDatabaseType.Text;
      LHasSchema := SameText(LODBCDBType, 'PostgreSQL') or SameText(LODBCDBType, 'SQL Server');
    end
    else
      LHasSchema := False;
  end
  else
    LHasSchema := SameText(LDatabaseType, 'PostgreSQL') or SameText(LDatabaseType, 'SQL Server');
  
  lblSchema.Visible := LHasSchema;
  edtSchema.Visible := LHasSchema;
  
  if LIsFileBased then
  begin
    lblDatabase.Caption := 'Database File:';
    edtDatabase.Width := 130;
  end
  else if LIsFireBird then
  begin
    lblDatabase.Caption := 'Database/File:';
    edtDatabase.Width := 130;
  end
  else if LIsODBC then
  begin
    lblDatabase.Caption := 'ODBC DSN:';
    edtDatabase.Width := 159;
  end
  else
  begin
    lblDatabase.Caption := 'Database:';
    edtDatabase.Width := 159;
  end;
end;

procedure TfrmParamentersAttributers.UpdateEngineField;
begin
  try
    edtEngine.Text := TParameters.DetectEngineName;
    edtEngine.ReadOnly := True;
    edtEngine.Color := clBtnFace;
    edtEngine.Hint := Format('Engine detectado automaticamente: %s', [TParameters.DetectEngineName]);
    edtEngine.ShowHint := True;
  except
    on E: Exception do
    begin
      edtEngine.Text := 'None';
      edtEngine.ReadOnly := False;
      edtEngine.Color := clWindow;
      edtEngine.Hint := 'Erro ao detectar engine automaticamente. Configure manualmente.';
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnConectarClick(Sender: TObject);
var
  LDatabases: TStringList;
  LSelectedDatabase: string;
  LEngine: string;
  LEngineEnum: TParameterDatabaseEngine;
  LDatabaseType: string;
  LHost: string;
  LPort: Integer;
  LUsername: string;
  LPassword: string;
  LDatabase: string;
  LSchema: string;
  LTableName: string;
  LIsConnected: Boolean;
  LIsFileBased: Boolean;
  LIsFireBird: Boolean;
  LIsFireBirdLocal: Boolean;
  LIsODBC: Boolean;
  LSuccess: Boolean;
begin
  try
    if cmbDatabaseType.ItemIndex < 0 then
    begin
      ShowMessage('Selecione um Database Type.');
      cmbDatabaseType.SetFocus;
      Exit;
    end;
    
    UpdateEngineField;
    LEngineEnum := TParameters.DetectEngine;
    LEngine := TParameters.DetectEngineName;
    LDatabaseType := cmbDatabaseType.Text;
    LDatabase := Trim(edtDatabase.Text);
    LSchema := Trim(edtSchema.Text);
    LTableName := Trim(edtTableName.Text);
    
    LIsFileBased := SameText(LDatabaseType, 'SQLite') or SameText(LDatabaseType, 'Access');
    LIsFireBird := SameText(LDatabaseType, 'FireBird') or SameText(LDatabaseType, 'Firebird');
    LIsODBC := SameText(LDatabaseType, 'ODBC');
    
    if LIsODBC then
    begin
      if Trim(cmbODBCDSN.Text) = '' then
      begin
        ShowMessage('Selecione ou informe um ODBC DSN.');
        cmbODBCDSN.SetFocus;
        Exit;
      end;
      LDatabase := Trim(cmbODBCDSN.Text);
      if cmbODBCDatabaseType.ItemIndex < 0 then
      begin
        ShowMessage('Selecione o tipo de banco de dados para ODBC.');
        cmbODBCDatabaseType.SetFocus;
        Exit;
      end;
      LHost := '';
      LPort := 0;
      LUsername := '';
      LPassword := '';
    end
    else if LIsFireBird then
    begin
      LIsFireBirdLocal := ((Trim(edtHost.Text) = '') and (Pos('\', Trim(edtDatabase.Text)) > 0)) or 
                          ((Trim(edtHost.Text) = '') and (Pos('/', Trim(edtDatabase.Text)) > 0)) or
                          ((Trim(edtHost.Text) = '') and (Pos(':', Trim(edtDatabase.Text)) = 2));
      
      if LIsFireBirdLocal then
      begin
        if Trim(edtDatabase.Text) = '' then
        begin
          if not Assigned(dlgOpenDatabase) then
          begin
            ShowMessage('Diálogo de seleção de arquivo não configurado.');
            Exit;
          end;
          dlgOpenDatabase.Filter := 'FireBird Database (*.fdb)|*.fdb|All Files (*.*)|*.*';
          dlgOpenDatabase.FilterIndex := 1;
          dlgOpenDatabase.Title := 'Selecionar arquivo FireBird';
          dlgOpenDatabase.Options := dlgOpenDatabase.Options - [ofAllowMultiSelect];
          if dlgOpenDatabase.Execute then
          begin
            edtDatabase.Text := dlgOpenDatabase.FileName;
            LDatabase := dlgOpenDatabase.FileName;
          end
          else
          begin
            ShowStatus('Seleção de arquivo cancelada.');
            Exit;
          end;
        end
        else
          LDatabase := Trim(edtDatabase.Text);
        LHost := '';
        LPort := 0;
      end
      else
      begin
        if Trim(edtHost.Text) = '' then
        begin
          ShowMessage('O campo Host é obrigatório para FireBird remoto.');
          edtHost.SetFocus;
          Exit;
        end;
        if Trim(edtDatabase.Text) = '' then
        begin
          ShowMessage('O campo Database é obrigatório.');
          edtDatabase.SetFocus;
          Exit;
        end;
        LHost := Trim(edtHost.Text);
        LPort := StrToIntDef(Trim(edtPort.Text), 3050);
      end;
      LUsername := Trim(edtUsername.Text);
      LPassword := Trim(edtPassword.Text);
    end
    else if LIsFileBased then
    begin
      if Trim(edtDatabase.Text) = '' then
      begin
        ShowMessage('Selecione o arquivo do banco de dados.');
        edtDatabase.SetFocus;
        Exit;
      end;
      LUsername := '';
      LPassword := '';
      LHost := '';
      LPort := 0;
    end
    else
    begin
      if Trim(edtHost.Text) = '' then
      begin
        ShowMessage('O campo Host é obrigatório.');
        edtHost.SetFocus;
        Exit;
      end;
      if Trim(edtUsername.Text) = '' then
      begin
        ShowMessage('O campo Username é obrigatório.');
        edtUsername.SetFocus;
        Exit;
      end;
      LHost := Trim(edtHost.Text);
      LPort := StrToIntDef(Trim(edtPort.Text), 5432);
      LUsername := Trim(edtUsername.Text);
      LPassword := Trim(edtPassword.Text);
      
      if Trim(edtDatabase.Text) = '' then
      begin
        FParameters.Database.IsConnected(LIsConnected);
        if LIsConnected then
          FParameters.Database.Disconnect;
        FParameters.Database
          .Engine(LEngineEnum)
          .DatabaseType(LDatabaseType)
          .Host(LHost)
          .Port(LPort)
          .Username(LUsername)
          .Password(LPassword)
          .Database('');
        LDatabases := nil;
        try
          LDatabases := FParameters.Database.ListAvailableDatabases;
          try
            if (Assigned(LDatabases)) and (LDatabases.Count > 0) then
            begin
              LSelectedDatabase := SelectDatabaseFromList(LDatabases);
              if LSelectedDatabase <> '' then
              begin
                edtDatabase.Text := LSelectedDatabase;
                LDatabase := LSelectedDatabase;
              end
              else
              begin
                ShowStatus('Seleção de banco de dados cancelada.');
                Exit;
              end;
            end
            else
            begin
              ShowMessage('Nenhum banco de dados disponível encontrado.');
              Exit;
            end;
          finally
            if Assigned(LDatabases) then
              LDatabases.Free;
          end;
        except
          on E: Exception do
          begin
            ShowMessage(Format('Erro ao listar bancos disponíveis:'#13#10'%s', [E.Message]));
            Exit;
          end;
        end;
      end
      else
        LDatabase := Trim(edtDatabase.Text);
    end;
    
    FParameters.Database.IsConnected(LIsConnected);
    if LIsConnected then
      FParameters.Database.Disconnect;
    
    FParameters.Database
      .Engine(LEngineEnum)
      .DatabaseType(LDatabaseType);
    
    if LIsODBC then
    begin
      // ODBC: apenas configura DSN
    end
    else if LIsFireBird then
    begin
      if (LHost <> '') and (LPort > 0) then
        FParameters.Database.Host(LHost).Port(LPort);
    end
    else if not LIsFileBased then
      FParameters.Database.Host(LHost).Port(LPort);
    
    if LTableName <> '' then
      FParameters.Database.TableName(LTableName);
    
    if Trim(LDatabase) <> '' then
      FParameters.Database.Database(LDatabase)
    else
      FParameters.Database.Database('');
    
    if not LIsODBC then
    begin
      if LUsername <> '' then
        FParameters.Database.Username(LUsername);
      if LPassword <> '' then
        FParameters.Database.Password(LPassword);
    end;
    
    if SameText(LDatabaseType, 'SQLite') or SameText(LDatabaseType, 'MySQL') or 
       SameText(LDatabaseType, 'MariaDB') or SameText(LDatabaseType, 'Access') or 
       (SameText(LDatabaseType, 'FireBird') or SameText(LDatabaseType, 'Firebird')) then
      FParameters.Database.Schema('')
    else if LSchema <> '' then
      FParameters.Database.Schema(LSchema);
    
    try
      FParameters.Database.Connect;
    except
      on EConn: Exception do
      begin
        if (Pos('Unknown database', EConn.Message) > 0) or 
           (Pos('database', LowerCase(EConn.Message)) > 0) and 
           (Pos('not exist', LowerCase(EConn.Message)) > 0) or
           (Pos('does not exist', LowerCase(EConn.Message)) > 0) then
        begin
          if not LIsFileBased and not LIsODBC and (LDatabaseType <> 'FireBird') then
          begin
            try
              FParameters.Database.Disconnect;
              FParameters.Database
                .Engine(LEngineEnum)
                .DatabaseType(LDatabaseType)
                .Host(LHost)
                .Port(LPort)
                .Username(LUsername)
                .Password(LPassword);
              LDatabases := nil;
              try
                LDatabases := FParameters.Database.ListAvailableDatabases;
                if (Assigned(LDatabases)) and (LDatabases.Count > 0) then
                begin
                  LSelectedDatabase := SelectDatabaseFromList(LDatabases);
                  if LSelectedDatabase <> '' then
                  begin
                    edtDatabase.Text := LSelectedDatabase;
                    LDatabase := LSelectedDatabase;
                    FParameters.Database.Database(LDatabase);
                    FParameters.Database.Connect;
                    if cbApagar.Checked then
                    begin
                      try
                        if FParameters.Database.TableExists then
                        begin
                          FParameters.Database.DropTable(LSuccess);
                          if LSuccess then
                            ShowStatus('Tabela apagada com sucesso antes de conectar.')
                          else
                            ShowStatus('Aviso: Não foi possível apagar a tabela.', True);
                        end;
                        cbApagar.Checked := False;
                      except
                        on E: Exception do
                        begin
                          ShowStatus('Erro ao apagar tabela: ' + E.Message, True);
                          ShowMessage('Erro ao apagar tabela: ' + E.Message);
                          cbApagar.Checked := False;
                        end;
                      end;
                    end;
                  end
                  else
                  begin
                    ShowStatus('Seleção de banco de dados cancelada.');
                    Exit;
                  end;
                end
                else
                begin
                  ShowMessage(Format('Banco de dados "%s" não existe e não foi possível listar bancos disponíveis.'#13#10#13#10'Erro original: %s', [LDatabase, EConn.Message]));
                  Exit;
                end;
              finally
                if Assigned(LDatabases) then
                  LDatabases.Free;
              end;
            except
              on EList: Exception do
              begin
                ShowMessage(Format('Banco de dados "%s" não existe.'#13#10'Erro ao listar bancos disponíveis: %s'#13#10#13#10'Erro original: %s', 
                  [LDatabase, EList.Message, EConn.Message]));
                Exit;
              end;
            end;
          end
          else
            raise;
        end
        else
          raise;
      end;
    end;
    
    if cbApagar.Checked then
    begin
      try
        if FParameters.Database.TableExists then
        begin
          FParameters.Database.DropTable(LSuccess);
          if LSuccess then
            ShowStatus('Tabela apagada com sucesso antes de conectar.')
          else
            ShowStatus('Aviso: Não foi possível apagar a tabela.', True);
        end;
        cbApagar.Checked := False;
      except
        on E: Exception do
        begin
          ShowStatus('Erro ao apagar tabela: ' + E.Message, True);
          ShowMessage('Erro ao apagar tabela: ' + E.Message);
          cbApagar.Checked := False;
        end;
      end;
    end;
    
    UpdateConnectionInfo;
    btnConectar.Enabled := False;
    btnDesconectar.Enabled := True;
    ClearFields;
    LoadDataToListView;
    ShowStatus('Conectado ao banco de dados com sucesso!');
    ShowMessage('Conectado ao banco de dados com sucesso!');
  except
    on E: EParametersSQLException do
    begin
      if E.ErrorCode = ERR_SQL_TABLE_NOT_EXISTS then
      begin
        if HandleTableNotExists('conectar') then
        begin
          UpdateConnectionInfo;
          ShowStatus('Conectado ao banco de dados com sucesso!');
        end
        else
        begin
          btnConectar.Enabled := True;
          btnDesconectar.Enabled := False;
        end;
      end
      else
      begin
        ShowStatus('Erro ao conectar: ' + E.Message, True);
        ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
        btnConectar.Enabled := True;
        btnDesconectar.Enabled := False;
      end;
    end;
    on E: Exception do
    begin
      ShowStatus('Erro ao conectar: ' + E.Message, True);
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
      btnConectar.Enabled := True;
      btnDesconectar.Enabled := False;
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnDesconectarClick(Sender: TObject);
begin
  try
    if not Assigned(FParameters) then
      Exit;
    
    FParameters.Database.Disconnect;
    UpdateConnectionInfo;
    btnConectar.Enabled := True;
    btnDesconectar.Enabled := False;
    ClearFields;
    lvConfig.Items.Clear;
    ShowStatus('Desconectado do banco de dados.');
    ShowMessage('Desconectado do banco de dados.');
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao desconectar: ' + E.Message, True);
      ShowMessage('Erro ao desconectar: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.cmbDatabaseTypeChange(Sender: TObject);
begin
  AdjustFieldsByDatabaseType;
end;

procedure TfrmParamentersAttributers.btnSelectDatabaseClick(Sender: TObject);
var
  LDatabaseType: string;
  LFilter: string;
  LSelectedPath: string;
  LFileName: string;
  LDirectory: string;
  LResult: Integer;
begin
  if not Assigned(dlgOpenDatabase) then
    Exit;
    
  LDatabaseType := cmbDatabaseType.Text;
  
  if SameText(LDatabaseType, 'SQLite') then
  begin
    LResult := MessageDlg(
      'SQLite: Selecionar pasta ou arquivo?' + sLineBreak + sLineBreak +
      'Sim = Selecionar PASTA (será criado um arquivo na pasta)' + sLineBreak +
      'Não = Selecionar ARQUIVO (usar arquivo existente)',
      mtConfirmation,
      [mbYes, mbNo, mbCancel],
      0
    );
    
    if LResult = mrCancel then
      Exit;
    
    if LResult = mrYes then
    begin
      if SelectDirectory('Selecionar pasta para criar arquivo SQLite', '', LSelectedPath) then
      begin
        if Trim(edtTableName.Text) <> '' then
          LFileName := IncludeTrailingPathDelimiter(LSelectedPath) + Trim(edtTableName.Text) + '.db'
        else
          LFileName := IncludeTrailingPathDelimiter(LSelectedPath) + 'config.db';
        edtDatabase.Text := LFileName;
      end;
    end
    else
    begin
      dlgOpenDatabase.Filter := 'SQLite Database (*.db;*.sqlite;*.sqlite3)|*.db;*.sqlite;*.sqlite3|All Files (*.*)|*.*';
      dlgOpenDatabase.FilterIndex := 1;
      dlgOpenDatabase.Title := 'Selecionar arquivo SQLite';
      dlgOpenDatabase.Options := dlgOpenDatabase.Options - [ofAllowMultiSelect];
      if dlgOpenDatabase.Execute then
        edtDatabase.Text := dlgOpenDatabase.FileName;
    end;
  end
  else
  begin
    if SameText(LDatabaseType, 'FireBird') or SameText(LDatabaseType, 'Firebird') then
    begin
      dlgOpenDatabase.Filter := 'FireBird Database (*.fdb)|*.fdb|All Files (*.*)|*.*';
      dlgOpenDatabase.FilterIndex := 1;
    end
    else if SameText(LDatabaseType, 'Access') then
    begin
      dlgOpenDatabase.Filter := 'Access Database (*.mdb;*.accdb)|*.mdb;*.accdb|All Files (*.*)|*.*';
      dlgOpenDatabase.FilterIndex := 1;
    end
    else
    begin
      dlgOpenDatabase.Filter := 'All Files (*.*)|*.*';
      dlgOpenDatabase.FilterIndex := 1;
    end;
    
    dlgOpenDatabase.Title := Format('Selecionar arquivo de banco de dados (%s)', [LDatabaseType]);
    dlgOpenDatabase.Options := dlgOpenDatabase.Options - [ofAllowMultiSelect];
    if dlgOpenDatabase.Execute then
      edtDatabase.Text := dlgOpenDatabase.FileName;
  end;
end;

procedure TfrmParamentersAttributers.cbApagarClick(Sender: TObject);
var
  LTableName: string;
  LResult: Integer;
  LSuccess: Boolean;
  LDatabaseInterface: IParametersDatabase;
begin
  if not Assigned(FParameters) then
    Exit;
  
  if not cbApagar.Checked then
    Exit;
  
  try
    LDatabaseInterface := FParameters.Database;
    
    if not LDatabaseInterface.TableExists then
    begin
      ShowMessage('A tabela não existe. Não há nada para apagar.');
      cbApagar.Checked := False;
      Exit;
    end;
    
    LTableName := LDatabaseInterface.TableName;
    if LDatabaseInterface.Schema <> '' then
      LTableName := Format('%s.%s', [LDatabaseInterface.Schema, LTableName]);
    
    LResult := MessageDlg(
      Format('ATENÇÃO: Esta operação é IRREVERSÍVEL!'#13#10#13#10 +
             'Deseja realmente APAGAR a tabela "%s"?'#13#10 +
             'Todos os dados serão perdidos permanentemente!', [LTableName]),
      mtWarning,
      [mbYes, mbNo],
      0,
      mbNo
    );
    
    if LResult = mrYes then
    begin
      if not LDatabaseInterface.IsConnected then
      begin
        try
          LDatabaseInterface.Connect;
        except
          on E: Exception do
          begin
            ShowMessage(Format('Erro ao conectar para apagar tabela: %s', [E.Message]));
            cbApagar.Checked := False;
            Exit;
          end;
        end;
      end;
      
      LDatabaseInterface.DropTable(LSuccess);
      
      if LSuccess then
      begin
        ShowStatus(Format('Tabela "%s" apagada com sucesso!', [LTableName]));
        ShowMessage(Format('Tabela "%s" apagada com sucesso!', [LTableName]));
        cbApagar.Checked := False;
        ClearFields;
        lvConfig.Items.Clear;
        UpdateConnectionInfo;
      end
      else
      begin
        ShowStatus('Erro ao apagar a tabela.', True);
        ShowMessage('Erro ao apagar a tabela.');
        cbApagar.Checked := False;
      end;
    end
    else
      cbApagar.Checked := False;
  except
    on E: Exception do
    begin
      ShowStatus('Erro ao apagar tabela: ' + E.Message, True);
      ShowMessage('Erro ao apagar tabela: ' + E.Message);
      cbApagar.Checked := False;
    end;
  end;
end;

procedure TfrmParamentersAttributers.cmbODBCDatabaseTypeChange(Sender: TObject);
begin
  AdjustFieldsByDatabaseType;
end;

procedure TfrmParamentersAttributers.btnInifilesSelectFileClick(Sender: TObject);
begin
  if not Assigned(dlgInifilesSave) then
    Exit;
    
  dlgInifilesSave.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
  dlgInifilesSave.FilterIndex := 1;
  dlgInifilesSave.Title := 'Selecionar ou criar arquivo INI';
  dlgInifilesSave.Options := dlgInifilesSave.Options + [ofOverwritePrompt];
  
  if dlgInifilesSave.Execute then
  begin
    edtInifilesFilePath.Text := dlgInifilesSave.FileName;
    FParameters.Inifiles.FilePath(edtInifilesFilePath.Text);
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesRefreshClick(Sender: TObject);
begin
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked)
      .Refresh;
    ShowInifilesStatus('Arquivo INI atualizado com sucesso!');
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao atualizar: ' + E.Message, True);
      ShowMessage('Erro ao atualizar arquivo INI: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesListClick(Sender: TObject);
begin
  try
    LoadInifilesDataToListView;
    ShowInifilesStatus(Format('Listagem concluída. %d registro(s) encontrado(s).', [lvInifiles.Items.Count]));
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao listar: ' + E.Message, True);
      ShowMessage('Erro ao listar parâmetros: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesGetClick(Sender: TObject);
var
  LChave: string;
  LParameter: TParameter;
  LParamList: TParameterList;
  LConfig: TConfigParameter;
begin
  LChave := Trim(edtInifilesChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Informe a chave para buscar.');
    edtInifilesChave.SetFocus;
    Exit;
  end;
  
  try
    if (Trim(edtInifilesContratoID.Text) <> '') and (Trim(edtInifilesProdutoID.Text) <> '') and (Trim(edtInifilesTitulo.Text) <> '') then
    begin
      FParameters.Inifiles
        .FilePath(edtInifilesFilePath.Text)
        .Section(Trim(edtInifilesTitulo.Text))
        .ContratoID(StrToIntDef(edtInifilesContratoID.Text, 0))
        .ProdutoID(StrToIntDef(edtInifilesProdutoID.Text, 0))
        .Title(Trim(edtInifilesTitulo.Text))
        .AutoCreateFile(chkInifilesAutoCreate.Checked)
        .Getter(LChave, LParameter);
    end
    else
    begin
      FParameters.Inifiles
        .FilePath(edtInifilesFilePath.Text)
        .Section(edtInifilesSection.Text)
        .AutoCreateFile(chkInifilesAutoCreate.Checked)
        .Getter(LChave, LParameter);
    end;
    
    if Assigned(LParameter) and (LParameter.Name <> '') then
    begin
      // MELHORIA: Usa FAttributeMapper para converter TParameter → TConfigParameter via RTTI
      LConfig := TConfigParameter.Create;
      LParamList := nil;
      try
        LParamList := TParameterList.Create;
        LParamList.Add(LParameter);
        FAttributeMapper.MapParametersToClass(LParamList, LConfig);
        LoadInifilesFieldsFromConfig(LConfig);
        ShowInifilesStatus(Format('Parâmetro "%s" encontrado!', [LChave]));
      finally
        LParamList.Clear;
        LParamList.Free;
        LConfig.Free;
      end;
    end
    else
    begin
      ShowInifilesStatus(Format('Parâmetro "%s" não encontrado.', [LChave]), True);
      ShowMessage(Format('Parâmetro "%s" não encontrado.', [LChave]));
    end;
    
    if Assigned(LParameter) then
    begin
      LParameter.Free;
      LParameter := nil;
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao buscar: ' + E.Message, True);
      ShowMessage('Erro ao buscar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesInsertClick(Sender: TObject);
var
  LConfig: TConfigParameter;
  LParamList: TParameterList;
  LParam: TParameter;
  LSuccess: Boolean;
  I: Integer;
begin
  if not ValidateInifilesFields then
    Exit;
    
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    LConfig := GetInifilesConfigFromFields;
    try
      // MELHORIA: Usa FAttributeMapper para converter TConfigParameter → TParameterList via RTTI
      LParamList := FAttributeMapper.MapClassToParameters(LConfig);
      try
        // Busca o parâmetro principal (chave) na lista retornada
        LParam := nil;
        for I := 0 to LParamList.Count - 1 do
        begin
          if SameText(LParamList[I].Name, LConfig.Chave) then
          begin
            LParam := LParamList[I];
            Break;
          end;
        end;
        
        if LParam = nil then
        begin
          ShowInifilesStatus('Erro: Parâmetro não encontrado na lista mapeada.', True);
          ShowMessage('Erro: Não foi possível mapear a classe para parâmetro.');
          Exit;
        end;
        
        FParameters.Inifiles.Insert(LParam, LSuccess);
        
        if LSuccess then
        begin
          ShowInifilesStatus('Parâmetro inserido com sucesso!');
          ClearInifilesFields;
          LoadInifilesDataToListView;
          ShowMessage('Parâmetro inserido com sucesso!');
        end
        else
        begin
          ShowInifilesStatus('Erro ao inserir parâmetro.', True);
          ShowMessage('Erro ao inserir parâmetro.');
        end;
      finally
        LParamList.ClearAll;
        LParamList.Free;
      end;
    finally
      LConfig.Free;
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao inserir: ' + E.Message, True);
      ShowMessage('Erro ao inserir parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesUpdateClick(Sender: TObject);
var
  LConfig: TConfigParameter;
  LParamList: TParameterList;
  LParam: TParameter;
  LSuccess: Boolean;
  I: Integer;
begin
  if Trim(edtInifilesChave.Text) = '' then
  begin
    ShowMessage('Selecione um parâmetro para atualizar.');
    Exit;
  end;
    
  if not ValidateInifilesFields then
    Exit;
    
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    LConfig := GetInifilesConfigFromFields;
    try
      // MELHORIA: Usa FAttributeMapper para converter TConfigParameter → TParameterList via RTTI
      LParamList := FAttributeMapper.MapClassToParameters(LConfig);
      try
        // Busca o parâmetro principal (chave) na lista retornada
        LParam := nil;
        for I := 0 to LParamList.Count - 1 do
        begin
          if SameText(LParamList[I].Name, LConfig.Chave) then
          begin
            LParam := LParamList[I];
            Break;
          end;
        end;
        
        if LParam = nil then
        begin
          ShowInifilesStatus('Erro: Parâmetro não encontrado na lista mapeada.', True);
          ShowMessage('Erro: Não foi possível mapear a classe para parâmetro.');
          Exit;
        end;
        
        FParameters.Inifiles.Setter(LParam, LSuccess);
        
        if LSuccess then
        begin
          ShowInifilesStatus('Parâmetro atualizado com sucesso!');
          LoadInifilesDataToListView;
          ShowMessage('Parâmetro atualizado com sucesso!');
        end
        else
        begin
          ShowInifilesStatus('Erro ao atualizar parâmetro.', True);
          ShowMessage('Erro ao atualizar parâmetro.');
        end;
      finally
        LParamList.ClearAll;
        LParamList.Free;
      end;
    finally
      LConfig.Free;
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao atualizar: ' + E.Message, True);
      ShowMessage('Erro ao atualizar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesDeleteClick(Sender: TObject);
var
  LChave: string;
  LTitulo: string;
  LSuccess: Boolean;
begin
  LChave := Trim(edtInifilesChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Selecione um parâmetro para deletar.');
    Exit;
  end;
  
  if MessageDlg(Format('Deseja realmente deletar o parâmetro "%s"?', [LChave]),
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;
    
  try
    LTitulo := Trim(edtInifilesTitulo.Text);
    if LTitulo = '' then
      LTitulo := edtInifilesSection.Text;
    
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(LTitulo)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    FParameters.Inifiles.Delete(LChave, LSuccess);
    
    if LSuccess then
    begin
      ShowInifilesStatus('Parâmetro deletado com sucesso!');
      ClearInifilesFields;
      LoadInifilesDataToListView;
      ShowMessage('Parâmetro deletado com sucesso!');
    end
    else
    begin
      ShowInifilesStatus('Erro ao deletar parâmetro.', True);
      ShowMessage('Erro ao deletar parâmetro.');
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao deletar: ' + E.Message, True);
      ShowMessage('Erro ao deletar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesCountClick(Sender: TObject);
var
  LCount: Integer;
begin
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    FParameters.Inifiles.Count(LCount);
    ShowInifilesStatus(Format('Total de parâmetros: %d', [LCount]));
    ShowMessage(Format('Total de parâmetros no arquivo INI: %d', [LCount]));
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao contar: ' + E.Message, True);
      ShowMessage('Erro ao contar parâmetros: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesExistsClick(Sender: TObject);
var
  LChave: string;
  LExists: Boolean;
begin
  LChave := Trim(edtInifilesChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Informe a chave para verificar.');
    edtInifilesChave.SetFocus;
    Exit;
  end;
  
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    FParameters.Inifiles.Exists(LChave, LExists);
    
    if LExists then
    begin
      ShowInifilesStatus(Format('Parâmetro "%s" existe!', [LChave]));
      ShowMessage(Format('Parâmetro "%s" existe no arquivo INI.', [LChave]));
    end
    else
    begin
      ShowInifilesStatus(Format('Parâmetro "%s" não existe.', [LChave]), True);
      ShowMessage(Format('Parâmetro "%s" não existe no arquivo INI.', [LChave]));
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao verificar: ' + E.Message, True);
      ShowMessage('Erro ao verificar existência: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesImportClick(Sender: TObject);
var
  LSuccess: Boolean;
  LIsConnected: Boolean;
  LFilePath: string;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro (aba Database).');
    Exit;
  end;
  
  FParameters.Database.IsConnected(LIsConnected);
  if not LIsConnected then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro (aba Database).');
    ShowInifilesStatus('Erro: Database não está conectado.', True);
    Exit;
  end;
  
  LFilePath := Trim(edtInifilesFilePath.Text);
  
  if (LFilePath = '') or (ExtractFileName(LFilePath) = '') then
  begin
    if not Assigned(dlgInifilesSave) then
    begin
      ShowInifilesStatus('Diálogo de salvamento não configurado.', True);
      Exit;
    end;
    
    dlgInifilesSave.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
    dlgInifilesSave.FilterIndex := 1;
    dlgInifilesSave.Title := 'Salvar arquivo INI - Importar do Database';
    dlgInifilesSave.DefaultExt := 'ini';
    
    if (LFilePath <> '') and (ExtractFilePath(LFilePath) <> '') then
      dlgInifilesSave.InitialDir := ExtractFilePath(LFilePath)
    else
      dlgInifilesSave.InitialDir := '';
    
    dlgInifilesSave.FileName := 'config_import.ini';
    
    if not dlgInifilesSave.Execute then
    begin
      ShowInifilesStatus('Importação cancelada pelo usuário.');
      Exit;
    end;
    
    LFilePath := Trim(dlgInifilesSave.FileName);
    
    if (LFilePath = '') or (ExtractFileName(LFilePath) = '') then
    begin
      ShowInifilesStatus('Erro: Caminho do arquivo inválido. Selecione um arquivo válido.', True);
      ShowMessage('Erro: O caminho do arquivo selecionado é inválido.');
      Exit;
    end;
    
    edtInifilesFilePath.Text := LFilePath;
  end;
  
  if (LFilePath = '') or (ExtractFileName(LFilePath) = '') then
  begin
    ShowInifilesStatus('Erro: Caminho do arquivo inválido. Informe um caminho válido.', True);
    ShowMessage('Erro: O caminho do arquivo é inválido.');
    Exit;
  end;
  
  try
    FParameters.Inifiles
      .FilePath(LFilePath)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked)
      .ContratoID(StrToIntDef(edtInifilesFiltroContrato.Text, 0))
      .ProdutoID(StrToIntDef(edtInifilesFiltroProduto.Text, 0));
    
    FParameters.Inifiles.ImportFromDatabase(FParameters.Database, LSuccess);
    
    if LSuccess then
    begin
      ShowInifilesStatus(Format('Importação concluída! Arquivo salvo em: %s', [LFilePath]));
      LoadInifilesDataToListView;
      ShowMessage(Format('Parâmetros importados do Database para o arquivo INI com sucesso!'#13#10#13#10'Arquivo salvo em:'#13#10'%s', [LFilePath]));
    end
    else
    begin
      ShowInifilesStatus('Erro ao importar do Database.', True);
      ShowMessage('Erro ao importar parâmetros do Database.');
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao importar: ' + E.Message, True);
      ShowMessage('Erro ao importar do Database: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesExportClick(Sender: TObject);
var
  LSuccess: Boolean;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro (aba Database).');
    Exit;
  end;
  
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    FParameters.Inifiles.ExportToDatabase(FParameters.Database, LSuccess);
    
    if LSuccess then
    begin
      ShowInifilesStatus('Exportação do INI para Database concluída com sucesso!');
      ShowMessage('Parâmetros exportados do arquivo INI para o Database com sucesso!');
    end
    else
    begin
      ShowInifilesStatus('Erro ao exportar para Database.', True);
      ShowMessage('Erro ao exportar parâmetros para Database.');
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao exportar: ' + E.Message, True);
      ShowMessage('Erro ao exportar para Database: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesImportJsonClick(Sender: TObject);
var
  LSuccess: Boolean;
  LList: TParameterList;
  I: Integer;
  LParam: TParameter;
  LParamSuccess: Boolean;
  LJsonFilePath: string;
begin
  if not Assigned(FParameters.JsonObject) then
  begin
    ShowMessage('Configure o arquivo JSON primeiro (aba JsonObject).');
    Exit;
  end;
  
  if not Assigned(dlgJsonObjectOpen) then
  begin
    ShowInifilesStatus('Diálogo de abertura não configurado.', True);
    Exit;
  end;
  
  dlgJsonObjectOpen.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
  dlgJsonObjectOpen.FilterIndex := 1;
  dlgJsonObjectOpen.Title := 'Importar do JSON para INI - Selecionar arquivo';
  dlgJsonObjectOpen.Options := dlgJsonObjectOpen.Options + [ofFileMustExist];
  
  if Trim(edtJsonObjectFilePath.Text) <> '' then
    dlgJsonObjectOpen.FileName := edtJsonObjectFilePath.Text
  else
    dlgJsonObjectOpen.FileName := '';
  
  if not dlgJsonObjectOpen.Execute then
  begin
    ShowInifilesStatus('Importação cancelada pelo usuário.');
    Exit;
  end;
  
  LJsonFilePath := Trim(dlgJsonObjectOpen.FileName);
  
  if (LJsonFilePath = '') or (ExtractFileName(LJsonFilePath) = '') then
  begin
    ShowInifilesStatus('Erro: Caminho do arquivo JSON inválido. Selecione um arquivo válido.', True);
    ShowMessage('Erro: O caminho do arquivo selecionado é inválido.');
    Exit;
  end;
  
  try
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked)
      .ContratoID(StrToIntDef(edtInifilesFiltroContrato.Text, 0))
      .ProdutoID(StrToIntDef(edtInifilesFiltroProduto.Text, 0));
    
    FParameters.JsonObject
      .FilePath(LJsonFilePath)
      .ContratoID(StrToIntDef(edtInifilesFiltroContrato.Text, 0))
      .ProdutoID(StrToIntDef(edtInifilesFiltroProduto.Text, 0));
    
    LList := FParameters.JsonObject.List;
    try
      for I := 0 to LList.Count - 1 do
      begin
        LParam := LList[I];
        FParameters.Inifiles.Insert(LParam, LParamSuccess);
        if not LParamSuccess then
          FParameters.Inifiles.Setter(LParam, LParamSuccess);
      end;
      LSuccess := True;
    finally
      LList.ClearAll;
      LList.Free;
    end;
    
    if LSuccess then
    begin
      ShowInifilesStatus('Importação do JSON para INI concluída com sucesso!');
      LoadInifilesDataToListView;
      ShowMessage('Parâmetros importados do JSON para o INI com sucesso!');
    end
    else
    begin
      ShowInifilesStatus('Erro ao importar do JSON.', True);
      ShowMessage('Erro ao importar parâmetros do JSON.');
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao importar do JSON: ' + E.Message, True);
      ShowMessage('Erro ao importar parâmetros do JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesExportJsonClick(Sender: TObject);
var
  LSuccess: Boolean;
  LFilePath: string;
begin
  if not Assigned(FParameters.JsonObject) then
  begin
    ShowMessage('Configure o arquivo JSON primeiro (aba JsonObject).');
    Exit;
  end;
  
  try
    if not Assigned(dlgJsonObjectSave) then
    begin
      ShowInifilesStatus('Diálogo de salvamento não configurado.', True);
      Exit;
    end;
    
    dlgJsonObjectSave.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
    dlgJsonObjectSave.FilterIndex := 1;
    dlgJsonObjectSave.Title := 'Salvar arquivo JSON - Exportar do INI';
    dlgJsonObjectSave.DefaultExt := 'json';
    
    if Trim(edtJsonObjectFilePath.Text) <> '' then
      dlgJsonObjectSave.FileName := edtJsonObjectFilePath.Text
    else
      dlgJsonObjectSave.FileName := 'config_export.json';
    
    if not dlgJsonObjectSave.Execute then
    begin
      ShowInifilesStatus('Exportação cancelada pelo usuário.');
      Exit;
    end;
    
    LFilePath := dlgJsonObjectSave.FileName;
    
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    FParameters.JsonObject
      .FilePath(LFilePath)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    FParameters.JsonObject.ImportFromInifiles(FParameters.Inifiles, LSuccess);
    
    if not LSuccess then
    begin
      ShowInifilesStatus('Erro ao importar dados do INI para JSON.', True);
      ShowMessage('Erro ao importar parâmetros do INI para JSON.');
      Exit;
    end;
    
    FParameters.JsonObject.SaveToFile(LFilePath, LSuccess);
    
    if LSuccess then
    begin
      edtJsonObjectFilePath.Text := LFilePath;
      ShowInifilesStatus(Format('Exportação concluída! Arquivo salvo em: %s', [LFilePath]));
      ShowMessage(Format('Parâmetros exportados do arquivo INI para o JSON com sucesso!'#13#10#13#10'Arquivo salvo em:'#13#10'%s', [LFilePath]));
    end
    else
    begin
      ShowInifilesStatus('Erro ao salvar arquivo JSON.', True);
      ShowMessage('Erro ao salvar arquivo JSON.');
    end;
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao exportar para JSON: ' + E.Message, True);
      ShowMessage('Erro ao exportar parâmetros para JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.lvInifilesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  LChave: string;
  LTitulo: string;
  LContratoID, LProdutoID: Integer;
  LParameter: TParameter;
  LParamList: TParameterList;
  LConfig: TConfigParameter;
begin
  if not Selected or (Item = nil) then
    Exit;
    
  LParameter := nil;
  LParamList := nil;
  try
    if Item.SubItems.Count > 4 then
    begin
      LTitulo := Item.SubItems[3];
      LChave := Item.SubItems[4];
    end
    else
    begin
      ShowInifilesStatus('Erro: Item sem dados suficientes.', True);
      Exit;
    end;
    
    LContratoID := 0;
    LProdutoID := 0;
    if Item.SubItems.Count > 1 then
    begin
      LContratoID := StrToIntDef(Item.SubItems[0], 0);
      LProdutoID := StrToIntDef(Item.SubItems[1], 0);
    end;
    
    FParameters.Inifiles
      .FilePath(edtInifilesFilePath.Text)
      .Section(LTitulo)
      .ContratoID(LContratoID)
      .ProdutoID(LProdutoID)
      .Title(LTitulo)
      .AutoCreateFile(chkInifilesAutoCreate.Checked)
      .Getter(LChave, LParameter);
    
    if Assigned(LParameter) and (LParameter.Name <> '') then
    begin
      // MELHORIA: Usa FAttributeMapper para converter TParameter → TConfigParameter via RTTI
      LConfig := TConfigParameter.Create;
      try
        LParamList := TParameterList.Create;
        LParamList.Add(LParameter);
        FAttributeMapper.MapParametersToClass(LParamList, LConfig);
        LoadInifilesFieldsFromConfig(LConfig);
        ShowInifilesStatus(Format('Parâmetro carregado: %s (Seção: %s)', [LChave, LTitulo]));
      finally
        LParamList.Clear;
        LParamList.Free;
        LConfig.Free;
      end;
    end
    else
      ShowInifilesStatus(Format('Parâmetro "%s" não encontrado na seção "%s".', [LChave, LTitulo]), True);
  except
    on E: Exception do
    begin
      ShowInifilesStatus('Erro ao carregar: ' + E.Message, True);
      ShowMessage('Erro ao carregar parâmetro: ' + E.Message);
    end;
  end;
  
  if Assigned(LParameter) then
  begin
    LParameter.Free;
    LParameter := nil;
  end;
end;

procedure TfrmParamentersAttributers.btnInifilesClearClick(Sender: TObject);
begin
  ClearInifilesFields;
  ShowInifilesStatus('Campos limpos.');
end;

procedure TfrmParamentersAttributers.btnJsonObjectSelectFileClick(Sender: TObject);
begin
  if not Assigned(dlgJsonObjectSave) then
    Exit;
    
  dlgJsonObjectSave.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
  dlgJsonObjectSave.FilterIndex := 1;
  dlgJsonObjectSave.Title := 'Selecionar ou criar arquivo JSON';
  dlgJsonObjectSave.Options := dlgJsonObjectSave.Options + [ofOverwritePrompt];
  
  if dlgJsonObjectSave.Execute then
  begin
    edtJsonObjectFilePath.Text := dlgJsonObjectSave.FileName;
    FParameters.JsonObject.FilePath(edtJsonObjectFilePath.Text);
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectRefreshClick(Sender: TObject);
begin
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked)
      .Refresh;
    ShowJsonObjectStatus('Objeto JSON atualizado com sucesso!');
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao atualizar: ' + E.Message, True);
      ShowMessage('Erro ao atualizar objeto JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectListClick(Sender: TObject);
begin
  try
    LoadJsonObjectDataToListView;
    ShowJsonObjectStatus(Format('Listagem concluída. %d registro(s) encontrado(s).', [lvJsonObject.Items.Count]));
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao listar: ' + E.Message, True);
      ShowMessage('Erro ao listar parâmetros: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectGetClick(Sender: TObject);
var
  LChave: string;
  LParameter: TParameter;
  LParamList: TParameterList;
  LConfig: TConfigParameter;
begin
  LChave := Trim(edtJsonObjectChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Informe a chave para buscar.');
    edtJsonObjectChave.SetFocus;
    Exit;
  end;
  
  try
    if (Trim(edtJsonObjectContratoID.Text) <> '') and (Trim(edtJsonObjectProdutoID.Text) <> '') and (Trim(edtJsonObjectTitulo.Text) <> '') then
    begin
      FParameters.JsonObject
        .FilePath(edtJsonObjectFilePath.Text)
        .ObjectName(Trim(edtJsonObjectTitulo.Text))
        .ContratoID(StrToIntDef(edtJsonObjectContratoID.Text, 0))
        .ProdutoID(StrToIntDef(edtJsonObjectProdutoID.Text, 0))
        .Title(Trim(edtJsonObjectTitulo.Text))
        .AutoCreateFile(chkJsonObjectAutoCreate.Checked)
        .Getter(LChave, LParameter);
    end
    else
    begin
      FParameters.JsonObject
        .FilePath(edtJsonObjectFilePath.Text)
        .ObjectName(edtJsonObjectObjectName.Text)
        .AutoCreateFile(chkJsonObjectAutoCreate.Checked)
        .Getter(LChave, LParameter);
    end;
    
    if Assigned(LParameter) and (LParameter.Name <> '') then
    begin
      // MELHORIA: Usa FAttributeMapper para converter TParameter → TConfigParameter via RTTI
      LConfig := TConfigParameter.Create;
      LParamList := nil;
      try
        LParamList := TParameterList.Create;
        LParamList.Add(LParameter);
        FAttributeMapper.MapParametersToClass(LParamList, LConfig);
        LoadJsonObjectFieldsFromConfig(LConfig);
        ShowJsonObjectStatus(Format('Parâmetro "%s" encontrado!', [LChave]));
      finally
        LParamList.Clear;
        LParamList.Free;
        LConfig.Free;
      end;
    end
    else
    begin
      ShowJsonObjectStatus(Format('Parâmetro "%s" não encontrado.', [LChave]), True);
      ShowMessage(Format('Parâmetro "%s" não encontrado.', [LChave]));
    end;
    
    if Assigned(LParameter) then
    begin
      LParameter.Free;
      LParameter := nil;
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao buscar: ' + E.Message, True);
      ShowMessage('Erro ao buscar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectInsertClick(Sender: TObject);
var
  LConfig: TConfigParameter;
  LParamList: TParameterList;
  LParam: TParameter;
  LSuccess: Boolean;
  I: Integer;
begin
  if not ValidateJsonObjectFields then
    Exit;
    
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    LConfig := GetJsonObjectConfigFromFields;
    try
      // MELHORIA: Usa FAttributeMapper para converter TConfigParameter → TParameterList via RTTI
      LParamList := FAttributeMapper.MapClassToParameters(LConfig);
      try
        // Busca o parâmetro principal (chave) na lista retornada
        LParam := nil;
        for I := 0 to LParamList.Count - 1 do
        begin
          if SameText(LParamList[I].Name, LConfig.Chave) then
          begin
            LParam := LParamList[I];
            Break;
          end;
        end;
        
        if LParam = nil then
        begin
          ShowJsonObjectStatus('Erro: Parâmetro não encontrado na lista mapeada.', True);
          ShowMessage('Erro: Não foi possível mapear a classe para parâmetro.');
          Exit;
        end;
        
        FParameters.JsonObject.Insert(LParam, LSuccess);
        
        if LSuccess then
        begin
          ShowJsonObjectStatus('Parâmetro inserido com sucesso!');
          ClearJsonObjectFields;
          LoadJsonObjectDataToListView;
          ShowMessage('Parâmetro inserido com sucesso!');
        end
        else
        begin
          ShowJsonObjectStatus('Erro ao inserir parâmetro.', True);
          ShowMessage('Erro ao inserir parâmetro.');
        end;
      finally
        LParamList.ClearAll;
        LParamList.Free;
      end;
    finally
      LConfig.Free;
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao inserir: ' + E.Message, True);
      ShowMessage('Erro ao inserir parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectUpdateClick(Sender: TObject);
var
  LConfig: TConfigParameter;
  LParamList: TParameterList;
  LParam: TParameter;
  LSuccess: Boolean;
  I: Integer;
begin
  if Trim(edtJsonObjectChave.Text) = '' then
  begin
    ShowMessage('Selecione um parâmetro para atualizar.');
    Exit;
  end;
    
  if not ValidateJsonObjectFields then
    Exit;
    
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    LConfig := GetJsonObjectConfigFromFields;
    try
      // MELHORIA: Usa FAttributeMapper para converter TConfigParameter → TParameterList via RTTI
      LParamList := FAttributeMapper.MapClassToParameters(LConfig);
      try
        // Busca o parâmetro principal (chave) na lista retornada
        LParam := nil;
        for I := 0 to LParamList.Count - 1 do
        begin
          if SameText(LParamList[I].Name, LConfig.Chave) then
          begin
            LParam := LParamList[I];
            Break;
          end;
        end;
        
        if LParam = nil then
        begin
          ShowJsonObjectStatus('Erro: Parâmetro não encontrado na lista mapeada.', True);
          ShowMessage('Erro: Não foi possível mapear a classe para parâmetro.');
          Exit;
        end;
        
        FParameters.JsonObject.Setter(LParam, LSuccess);
        
        if LSuccess then
        begin
          ShowJsonObjectStatus('Parâmetro atualizado com sucesso!');
          LoadJsonObjectDataToListView;
          ShowMessage('Parâmetro atualizado com sucesso!');
        end
        else
        begin
          ShowJsonObjectStatus('Erro ao atualizar parâmetro.', True);
          ShowMessage('Erro ao atualizar parâmetro.');
        end;
      finally
        LParamList.ClearAll;
        LParamList.Free;
      end;
    finally
      LConfig.Free;
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao atualizar: ' + E.Message, True);
      ShowMessage('Erro ao atualizar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectDeleteClick(Sender: TObject);
var
  LChave: string;
  LSuccess: Boolean;
begin
  LChave := Trim(edtJsonObjectChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Selecione um parâmetro para deletar.');
    Exit;
  end;
  
  if MessageDlg(Format('Deseja realmente deletar o parâmetro "%s"?', [LChave]),
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;
    
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    FParameters.JsonObject.Delete(LChave, LSuccess);
    
    if LSuccess then
    begin
      ShowJsonObjectStatus('Parâmetro deletado com sucesso!');
      ClearJsonObjectFields;
      LoadJsonObjectDataToListView;
      ShowMessage('Parâmetro deletado com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao deletar parâmetro.', True);
      ShowMessage('Erro ao deletar parâmetro.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao deletar: ' + E.Message, True);
      ShowMessage('Erro ao deletar parâmetro: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectCountClick(Sender: TObject);
var
  LCount: Integer;
begin
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    FParameters.JsonObject.Count(LCount);
    ShowJsonObjectStatus(Format('Total de parâmetros: %d', [LCount]));
    ShowMessage(Format('Total de parâmetros no objeto JSON: %d', [LCount]));
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao contar: ' + E.Message, True);
      ShowMessage('Erro ao contar parâmetros: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectExistsClick(Sender: TObject);
var
  LChave: string;
  LExists: Boolean;
begin
  LChave := Trim(edtJsonObjectChave.Text);
  
  if LChave = '' then
  begin
    ShowMessage('Informe a chave para verificar.');
    edtJsonObjectChave.SetFocus;
    Exit;
  end;
  
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    FParameters.JsonObject.Exists(LChave, LExists);
    
    if LExists then
    begin
      ShowJsonObjectStatus(Format('Parâmetro "%s" existe!', [LChave]));
      ShowMessage(Format('Parâmetro "%s" existe no objeto JSON.', [LChave]));
    end
    else
    begin
      ShowJsonObjectStatus(Format('Parâmetro "%s" não existe.', [LChave]), True);
      ShowMessage(Format('Parâmetro "%s" não existe no objeto JSON.', [LChave]));
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao verificar: ' + E.Message, True);
      ShowMessage('Erro ao verificar existência: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectImportClick(Sender: TObject);
var
  LSuccess: Boolean;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro (aba Database).');
    Exit;
  end;
  
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked)
      .ContratoID(StrToIntDef(edtJsonObjectFiltroContrato.Text, 0))
      .ProdutoID(StrToIntDef(edtJsonObjectFiltroProduto.Text, 0));
    
    FParameters.JsonObject.ImportFromDatabase(FParameters.Database, LSuccess);
    
    if LSuccess then
    begin
      ShowJsonObjectStatus('Importação do Database para JSON concluída com sucesso!');
      LoadJsonObjectDataToListView;
      ShowMessage('Parâmetros importados do Database para o objeto JSON com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao importar do Database.', True);
      ShowMessage('Erro ao importar parâmetros do Database.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao importar: ' + E.Message, True);
      ShowMessage('Erro ao importar do Database: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectImportIniClick(Sender: TObject);
var
  LSuccess: Boolean;
  LIniFilePath: string;
begin
  if not Assigned(FParameters.Inifiles) then
  begin
    ShowMessage('Configure o arquivo INI primeiro (aba Inifiles).');
    Exit;
  end;
  
  if not Assigned(dlgInifilesOpen) then
  begin
    ShowJsonObjectStatus('Diálogo de abertura não configurado.', True);
    Exit;
  end;
  
  dlgInifilesOpen.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
  dlgInifilesOpen.FilterIndex := 1;
  dlgInifilesOpen.Title := 'Importar do INI para JSON - Selecionar arquivo';
  dlgInifilesOpen.Options := dlgInifilesOpen.Options + [ofFileMustExist];
  
  if Trim(edtInifilesFilePath.Text) <> '' then
    dlgInifilesOpen.FileName := edtInifilesFilePath.Text
  else
    dlgInifilesOpen.FileName := '';
  
  if not dlgInifilesOpen.Execute then
  begin
    ShowJsonObjectStatus('Importação cancelada pelo usuário.');
    Exit;
  end;
  
  LIniFilePath := Trim(dlgInifilesOpen.FileName);
  
  if (LIniFilePath = '') or (ExtractFileName(LIniFilePath) = '') then
  begin
    ShowJsonObjectStatus('Erro: Caminho do arquivo INI inválido. Selecione um arquivo válido.', True);
    ShowMessage('Erro: O caminho do arquivo selecionado é inválido.');
    Exit;
  end;
  
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked)
      .ContratoID(StrToIntDef(edtJsonObjectFiltroContrato.Text, 0))
      .ProdutoID(StrToIntDef(edtJsonObjectFiltroProduto.Text, 0));
    
    FParameters.Inifiles
      .FilePath(LIniFilePath)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked)
      .ContratoID(StrToIntDef(edtJsonObjectFiltroContrato.Text, 0))
      .ProdutoID(StrToIntDef(edtJsonObjectFiltroProduto.Text, 0));
    
    FParameters.JsonObject.ImportFromInifiles(FParameters.Inifiles, LSuccess);
    
    if LSuccess then
    begin
      ShowJsonObjectStatus('Importação do INI para JSON concluída com sucesso!');
      LoadJsonObjectDataToListView;
      ShowMessage('Parâmetros importados do INI para o objeto JSON com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao importar do INI.', True);
      ShowMessage('Erro ao importar parâmetros do INI.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao importar do INI: ' + E.Message, True);
      ShowMessage('Erro ao importar parâmetros do INI: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectExportClick(Sender: TObject);
var
  LSuccess: Boolean;
begin
  if not Assigned(FParameters) then
  begin
    ShowMessage('Conecte-se ao banco de dados primeiro (aba Database).');
    Exit;
  end;
  
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    FParameters.JsonObject.ExportToDatabase(FParameters.Database, LSuccess);
    
    if LSuccess then
    begin
      ShowJsonObjectStatus('Exportação do JSON para Database concluída com sucesso!');
      ShowMessage('Parâmetros exportados do objeto JSON para o Database com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao exportar para Database.', True);
      ShowMessage('Erro ao exportar parâmetros para Database.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao exportar: ' + E.Message, True);
      ShowMessage('Erro ao exportar para Database: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectExportIniClick(Sender: TObject);
var
  LSuccess: Boolean;
  LIniFilePath: string;
begin
  if not Assigned(FParameters.Inifiles) then
  begin
    ShowMessage('Configure o arquivo INI primeiro (aba Inifiles).');
    Exit;
  end;
  
  if not Assigned(dlgInifilesSave) then
  begin
    ShowJsonObjectStatus('Diálogo de salvamento não configurado.', True);
    Exit;
  end;
  
  dlgInifilesSave.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
  dlgInifilesSave.FilterIndex := 1;
  dlgInifilesSave.Title := 'Exportar do JSON para INI - Selecionar local e nome do arquivo';
  dlgInifilesSave.DefaultExt := 'ini';
  dlgInifilesSave.Options := dlgInifilesSave.Options + [ofOverwritePrompt];
  
  if Trim(edtInifilesFilePath.Text) <> '' then
    dlgInifilesSave.FileName := edtInifilesFilePath.Text
  else
    dlgInifilesSave.FileName := 'config_export.ini';
  
  if not dlgInifilesSave.Execute then
  begin
    ShowJsonObjectStatus('Exportação cancelada pelo usuário.');
    Exit;
  end;
  
  LIniFilePath := Trim(dlgInifilesSave.FileName);
  
  if (LIniFilePath = '') or (ExtractFileName(LIniFilePath) = '') then
  begin
    ShowJsonObjectStatus('Erro: Caminho do arquivo INI inválido. Selecione um arquivo válido.', True);
    ShowMessage('Erro: O caminho do arquivo selecionado é inválido.');
    Exit;
  end;
  
  try
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(edtJsonObjectObjectName.Text)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
    
    FParameters.Inifiles
      .FilePath(LIniFilePath)
      .Section(edtInifilesSection.Text)
      .AutoCreateFile(chkInifilesAutoCreate.Checked);
    
    FParameters.JsonObject.ExportToInifiles(FParameters.Inifiles, LSuccess);
    
    if LSuccess then
    begin
      ShowJsonObjectStatus('Exportação do JSON para INI concluída com sucesso!');
      ShowMessage('Parâmetros exportados do objeto JSON para o INI com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao exportar para INI.', True);
      ShowMessage('Erro ao exportar parâmetros para INI.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao exportar para INI: ' + E.Message, True);
      ShowMessage('Erro ao exportar parâmetros para INI: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectSaveClick(Sender: TObject);
var
  LFilePath: string;
  LSuccess: Boolean;
begin
  if not Assigned(dlgJsonObjectSave) then
  begin
    ShowJsonObjectStatus('Diálogo de salvamento não configurado.', True);
    Exit;
  end;
  
  dlgJsonObjectSave.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
  dlgJsonObjectSave.FilterIndex := 1;
  dlgJsonObjectSave.Title := 'Salvar arquivo JSON';
  dlgJsonObjectSave.DefaultExt := 'json';
  dlgJsonObjectSave.Options := dlgJsonObjectSave.Options + [ofOverwritePrompt];
  
  if Trim(edtJsonObjectFilePath.Text) <> '' then
    dlgJsonObjectSave.FileName := edtJsonObjectFilePath.Text
  else
    dlgJsonObjectSave.FileName := 'config.json';
  
  if not dlgJsonObjectSave.Execute then
  begin
    ShowJsonObjectStatus('Salvamento cancelado pelo usuário.');
    Exit;
  end;
  
  LFilePath := Trim(dlgJsonObjectSave.FileName);
  
  if (LFilePath = '') or (ExtractFileName(LFilePath) = '') then
  begin
    ShowJsonObjectStatus('Erro: Caminho do arquivo JSON inválido. Selecione um arquivo válido.', True);
    ShowMessage('Erro: O caminho do arquivo selecionado é inválido.');
    Exit;
  end;
  
  try
    FParameters.JsonObject.SaveToFile(LFilePath, LSuccess);
    
    if LSuccess then
    begin
      edtJsonObjectFilePath.Text := LFilePath;
      ShowJsonObjectStatus('Arquivo JSON salvo com sucesso!');
      ShowMessage('Arquivo JSON salvo com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao salvar arquivo JSON.', True);
      ShowMessage('Erro ao salvar arquivo JSON.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao salvar: ' + E.Message, True);
      ShowMessage('Erro ao salvar arquivo JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectLoadClick(Sender: TObject);
var
  LFilePath: string;
  LSuccess: Boolean;
begin
  if not Assigned(dlgJsonObjectOpen) then
  begin
    ShowJsonObjectStatus('Diálogo de abertura não configurado.', True);
    Exit;
  end;
  
  dlgJsonObjectOpen.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
  dlgJsonObjectOpen.FilterIndex := 1;
  dlgJsonObjectOpen.Title := 'Carregar arquivo JSON';
  dlgJsonObjectOpen.Options := dlgJsonObjectOpen.Options + [ofFileMustExist];
  
  if Trim(edtJsonObjectFilePath.Text) <> '' then
    dlgJsonObjectOpen.FileName := edtJsonObjectFilePath.Text
  else
    dlgJsonObjectOpen.FileName := '';
  
  if not dlgJsonObjectOpen.Execute then
  begin
    ShowJsonObjectStatus('Carregamento cancelado pelo usuário.');
    Exit;
  end;
  
  LFilePath := Trim(dlgJsonObjectOpen.FileName);
  
  if (LFilePath = '') or (ExtractFileName(LFilePath) = '') then
  begin
    ShowJsonObjectStatus('Erro: Caminho do arquivo JSON inválido. Selecione um arquivo válido.', True);
    ShowMessage('Erro: O caminho do arquivo selecionado é inválido.');
    Exit;
  end;
  
  try
    FParameters.JsonObject.LoadFromFile(LFilePath, LSuccess);
    
    if LSuccess then
    begin
      edtJsonObjectFilePath.Text := LFilePath;
      LoadJsonObjectDataToListView;
      ShowJsonObjectStatus('Arquivo JSON carregado com sucesso!');
      ShowMessage('Arquivo JSON carregado com sucesso!');
    end
    else
    begin
      ShowJsonObjectStatus('Erro ao carregar arquivo JSON.', True);
      ShowMessage('Erro ao carregar arquivo JSON.');
    end;
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao carregar: ' + E.Message, True);
      ShowMessage('Erro ao carregar arquivo JSON: ' + E.Message);
    end;
  end;
end;

procedure TfrmParamentersAttributers.lvJsonObjectSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  LChave: string;
  LTitulo: string;
  LContratoID, LProdutoID: Integer;
  LParameter: TParameter;
  LParamList: TParameterList;
  LConfig: TConfigParameter;
begin
  if not Selected or (Item = nil) then
    Exit;
    
  LParameter := nil;
  LParamList := nil;
  try
    if Item.SubItems.Count > 4 then
    begin
      LTitulo := Item.SubItems[3];
      LChave := Item.SubItems[4];
    end
    else
    begin
      ShowJsonObjectStatus('Erro: Item sem dados suficientes.', True);
      Exit;
    end;
    
    LContratoID := 0;
    LProdutoID := 0;
    if Item.SubItems.Count > 1 then
    begin
      LContratoID := StrToIntDef(Item.SubItems[0], 0);
      LProdutoID := StrToIntDef(Item.SubItems[1], 0);
    end;
    
    FParameters.JsonObject
      .FilePath(edtJsonObjectFilePath.Text)
      .ObjectName(LTitulo)
      .ContratoID(LContratoID)
      .ProdutoID(LProdutoID)
      .Title(LTitulo)
      .AutoCreateFile(chkJsonObjectAutoCreate.Checked)
      .Getter(LChave, LParameter);
    
    if Assigned(LParameter) and (LParameter.Name <> '') then
    begin
      // MELHORIA: Usa FAttributeMapper para converter TParameter → TConfigParameter via RTTI
      LConfig := TConfigParameter.Create;
      try
        LParamList := TParameterList.Create;
        LParamList.Add(LParameter);
        FAttributeMapper.MapParametersToClass(LParamList, LConfig);
        LoadJsonObjectFieldsFromConfig(LConfig);
        ShowJsonObjectStatus(Format('Parâmetro carregado: %s (Objeto: %s)', [LChave, LTitulo]));
      finally
        LParamList.Clear;
        LParamList.Free;
        LConfig.Free;
      end;
    end
    else
      ShowJsonObjectStatus(Format('Parâmetro "%s" não encontrado no objeto "%s".', [LChave, LTitulo]), True);
  except
    on E: Exception do
    begin
      ShowJsonObjectStatus('Erro ao carregar: ' + E.Message, True);
      ShowMessage('Erro ao carregar parâmetro: ' + E.Message);
    end;
  end;
  
  if Assigned(LParameter) then
  begin
    LParameter.Free;
    LParameter := nil;
  end;
end;

procedure TfrmParamentersAttributers.btnJsonObjectClearClick(Sender: TObject);
begin
  ClearJsonObjectFields;
  ShowJsonObjectStatus('Campos limpos.');
end;

procedure TfrmParamentersAttributers.LoadInifilesDataToListView;
var
  LList: TParameterList;
  LItem: TListItem;
  LParameter: TParameter;
  I: Integer;
  LValue: string;
begin
  lvInifiles.Items.BeginUpdate;
  try
    try
      lvInifiles.Items.Clear;
      
      FParameters.Inifiles
        .FilePath(edtInifilesFilePath.Text)
        .Section(edtInifilesSection.Text)
        .AutoCreateFile(chkInifilesAutoCreate.Checked);
      
      LList := FParameters.Inifiles.List;
      
      try
        for I := 0 to LList.Count - 1 do
        begin
          LParameter := LList[I];
          
          LValue := LParameter.Value;
          if Length(LValue) > 50 then
            LValue := Copy(LValue, 1, 50) + '...';
          
          LItem := lvInifiles.Items.Add;
          LItem.Caption := IntToStr(LParameter.ID);
          LItem.SubItems.Add(IntToStr(LParameter.ContratoID));
          LItem.SubItems.Add(IntToStr(LParameter.ProdutoID));
          LItem.SubItems.Add(IntToStr(LParameter.Ordem));
          LItem.SubItems.Add(LParameter.Titulo);
          LItem.SubItems.Add(LParameter.Name);
          LItem.SubItems.Add(LValue);
          LItem.SubItems.Add(LParameter.Description);
          LItem.SubItems.Add(IfThen(LParameter.Ativo, 'Sim', 'Não'));
          LItem.Data := Pointer(I);
        end;
      finally
        LList.ClearAll;
        LList.Free;
      end;
    except
      on E: Exception do
      begin
        ShowInifilesStatus('Erro ao carregar lista: ' + E.Message, True);
        raise;
      end;
    end;
  finally
    lvInifiles.Items.EndUpdate;
  end;
end;

procedure TfrmParamentersAttributers.ClearInifilesFields;
begin
  edtInifilesContratoID.Text := '1';
  edtInifilesProdutoID.Text := '1';
  edtInifilesOrdem.Text := '1';
  edtInifilesTitulo.Text := '';
  edtInifilesChave.Text := '';
  memoInifilesValor.Clear;
  memoInifilesDescricao.Clear;
  chkInifilesAtivo.Checked := True;
end;

procedure TfrmParamentersAttributers.LoadInifilesFieldsFromConfig(const AConfig: TConfigParameter);
begin
  if not Assigned(AConfig) then
    Exit;
    
  edtInifilesContratoID.Text := IntToStr(AConfig.ContratoID);
  edtInifilesProdutoID.Text := IntToStr(AConfig.ProdutoID);
  edtInifilesOrdem.Text := IntToStr(AConfig.Ordem);
  edtInifilesTitulo.Text := AConfig.Titulo;
  edtInifilesChave.Text := AConfig.Chave;
  memoInifilesValor.Text := AConfig.Valor;
  memoInifilesDescricao.Text := AConfig.Descricao;
  chkInifilesAtivo.Checked := AConfig.Ativo;
end;

function TfrmParamentersAttributers.GetInifilesConfigFromFields: TConfigParameter;
begin
  Result := TConfigParameter.Create;
  Result.ContratoID := StrToIntDef(edtInifilesContratoID.Text, 1);
  Result.ProdutoID := StrToIntDef(edtInifilesProdutoID.Text, 1);
  Result.Ordem := StrToIntDef(edtInifilesOrdem.Text, 0);
  Result.Titulo := Trim(edtInifilesTitulo.Text);
  Result.Chave := Trim(edtInifilesChave.Text);
  Result.Valor := memoInifilesValor.Text;
  Result.Descricao := memoInifilesDescricao.Text;
  Result.Ativo := chkInifilesAtivo.Checked;
end;

procedure TfrmParamentersAttributers.ShowInifilesStatus(const AMessage: string; AIsError: Boolean = False);
begin
  ShowStatus(AMessage, AIsError);
end;

function TfrmParamentersAttributers.ValidateInifilesFields: Boolean;
begin
  Result := False;
  
  if Trim(edtInifilesChave.Text) = '' then
  begin
    ShowMessage('O campo "Chave" é obrigatório.');
    edtInifilesChave.SetFocus;
    Exit;
  end;
  
  if Trim(edtInifilesTitulo.Text) = '' then
  begin
    ShowMessage('O campo "Título" é obrigatório (define a seção do INI).');
    edtInifilesTitulo.SetFocus;
    Exit;
  end;
  
  if Trim(edtInifilesFilePath.Text) = '' then
  begin
    ShowMessage('O campo "File Path" é obrigatório.');
    edtInifilesFilePath.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

procedure TfrmParamentersAttributers.LoadJsonObjectDataToListView;
var
  LList: TParameterList;
  LItem: TListItem;
  LParameter: TParameter;
  I: Integer;
  LValue: string;
begin
  lvJsonObject.Items.BeginUpdate;
  try
    try
      lvJsonObject.Items.Clear;
      
      FParameters.JsonObject
        .FilePath(edtJsonObjectFilePath.Text)
        .ObjectName(edtJsonObjectObjectName.Text)
        .AutoCreateFile(chkJsonObjectAutoCreate.Checked);
      
      LList := FParameters.JsonObject.List;
      
      try
        for I := 0 to LList.Count - 1 do
        begin
          LParameter := LList[I];
          
          LValue := LParameter.Value;
          if Length(LValue) > 50 then
            LValue := Copy(LValue, 1, 50) + '...';
          
          LItem := lvJsonObject.Items.Add;
          LItem.Caption := IntToStr(LParameter.ID);
          LItem.SubItems.Add(IntToStr(LParameter.ContratoID));
          LItem.SubItems.Add(IntToStr(LParameter.ProdutoID));
          LItem.SubItems.Add(IntToStr(LParameter.Ordem));
          LItem.SubItems.Add(LParameter.Titulo);
          LItem.SubItems.Add(LParameter.Name);
          LItem.SubItems.Add(LValue);
          LItem.SubItems.Add(LParameter.Description);
          LItem.SubItems.Add(IfThen(LParameter.Ativo, 'Sim', 'Não'));
          LItem.Data := Pointer(I);
        end;
      finally
        LList.ClearAll;
        LList.Free;
      end;
    except
      on E: Exception do
      begin
        ShowJsonObjectStatus('Erro ao carregar lista: ' + E.Message, True);
        raise;
      end;
    end;
  finally
    lvJsonObject.Items.EndUpdate;
  end;
end;

procedure TfrmParamentersAttributers.ClearJsonObjectFields;
begin
  edtJsonObjectContratoID.Text := '1';
  edtJsonObjectProdutoID.Text := '1';
  edtJsonObjectOrdem.Text := '1';
  edtJsonObjectTitulo.Text := '';
  edtJsonObjectChave.Text := '';
  memoJsonObjectValor.Clear;
  memoJsonObjectDescricao.Clear;
  chkJsonObjectAtivo.Checked := True;
end;

procedure TfrmParamentersAttributers.LoadJsonObjectFieldsFromConfig(const AConfig: TConfigParameter);
begin
  if not Assigned(AConfig) then
    Exit;
    
  edtJsonObjectContratoID.Text := IntToStr(AConfig.ContratoID);
  edtJsonObjectProdutoID.Text := IntToStr(AConfig.ProdutoID);
  edtJsonObjectOrdem.Text := IntToStr(AConfig.Ordem);
  edtJsonObjectTitulo.Text := AConfig.Titulo;
  edtJsonObjectChave.Text := AConfig.Chave;
  memoJsonObjectValor.Text := AConfig.Valor;
  memoJsonObjectDescricao.Text := AConfig.Descricao;
  chkJsonObjectAtivo.Checked := AConfig.Ativo;
end;

function TfrmParamentersAttributers.GetJsonObjectConfigFromFields: TConfigParameter;
begin
  Result := TConfigParameter.Create;
  Result.ContratoID := StrToIntDef(edtJsonObjectContratoID.Text, 1);
  Result.ProdutoID := StrToIntDef(edtJsonObjectProdutoID.Text, 1);
  Result.Ordem := StrToIntDef(edtJsonObjectOrdem.Text, 0);
  Result.Titulo := Trim(edtJsonObjectTitulo.Text);
  Result.Chave := Trim(edtJsonObjectChave.Text);
  Result.Valor := memoJsonObjectValor.Text;
  Result.Descricao := memoJsonObjectDescricao.Text;
  Result.Ativo := chkJsonObjectAtivo.Checked;
end;

procedure TfrmParamentersAttributers.ShowJsonObjectStatus(const AMessage: string; AIsError: Boolean = False);
begin
  ShowStatus(AMessage, AIsError);
end;

function TfrmParamentersAttributers.ValidateJsonObjectFields: Boolean;
begin
  Result := False;
  
  if Trim(edtJsonObjectChave.Text) = '' then
  begin
    ShowMessage('O campo "Chave" é obrigatório.');
    edtJsonObjectChave.SetFocus;
    Exit;
  end;
  
  if Trim(edtJsonObjectTitulo.Text) = '' then
  begin
    ShowMessage('O campo "Título" é obrigatório (define o nome do objeto JSON).');
    edtJsonObjectTitulo.SetFocus;
    Exit;
  end;
  
  if Trim(edtJsonObjectFilePath.Text) = '' then
  begin
    ShowMessage('O campo "File Path" é obrigatório.');
    edtJsonObjectFilePath.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

end.
