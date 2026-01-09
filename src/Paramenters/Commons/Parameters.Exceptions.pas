unit Parameters.Exceptions;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters.Exceptions - Sistema Completo de Exceções e Mensagens de Erro
  
  Descrição:
  Define exceções customizadas e mensagens de erro para o módulo Parameters.
  Fornece tratamento consistente de erros em todo o sistema, garantindo que
  100% das exceções do módulo Parameters usem este sistema.
  
  Estrutura:
  - EParametersException: Classe base para todas as exceções do módulo
  - Exceções específicas por categoria (Connection, SQL, Validation, etc.)
  - Códigos de erro organizados por faixa (1000-1999)
  - Mensagens de erro padronizadas
  - Funções auxiliares para criação de exceções
  - Funções auxiliares para conversão de exceções genéricas
  
  Author: Claiton de Souza Linhares
  Version: 2.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I ../../ParamentersORM.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils,
{$ELSE}
  System.SysUtils,
{$ENDIF}
  Parameters.Types;

type
  { =============================================================================
    EParametersException - Exceção Base para o Módulo Parameters
    =============================================================================
    Classe base para todas as exceções do módulo Parameters.
    Fornece ErrorCode e Operation para facilitar tratamento e logging.
    
    Propriedades:
    - ErrorCode: Código numérico do erro (facilita tratamento programático)
    - Operation: Nome da operação que causou o erro (facilita debug)
    ============================================================================= }
  
  EParametersException = class(Exception)
  private
    FErrorCode: Integer;
    FOperation: string;
  public
    constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''); reintroduce;
    property ErrorCode: Integer read FErrorCode;
    property Operation: string read FOperation;
  end;
  
  { =============================================================================
    Exceções Específicas por Categoria
    ============================================================================= }
  
  // Exceção de Conexão (Database, INI, JSON)
  EParametersConnectionException = class(EParametersException);
  
  // Exceção de SQL (Database)
  EParametersSQLException = class(EParametersException);
  
  // Exceção de Validação (todos os módulos)
  EParametersValidationException = class(EParametersException);
  
  // Exceção de Parâmetro Não Encontrado (todos os módulos)
  EParametersNotFoundException = class(EParametersException);
  
  // Exceção de Configuração (todos os módulos)
  EParametersConfigurationException = class(EParametersException);
  
  // Exceção de Arquivo (INI, JSON)
  EParametersFileException = class(EParametersException);
  
  // Exceção de INI (específica para operações INI)
  EParametersInifilesException = class(EParametersException);
  
  // Exceção de JSON (específica para operações JSON)
  EParametersJsonObjectException = class(EParametersException);

const
  { =============================================================================
    CÓDIGOS DE ERRO - Organizados por Faixa
    ============================================================================= }
  
  // ========== ERROS DE CONEXÃO (1000-1099) ==========
  ERR_CONNECTION_NOT_ASSIGNED = 1001;
  ERR_CONNECTION_FAILED = 1002;
  ERR_CONNECTION_ALREADY_EXISTS = 1003;
  ERR_CONNECTION_NOT_CONNECTED = 1004;
  ERR_DISCONNECTION_FAILED = 1005;
  ERR_CONNECTION_TIMEOUT = 1006;
  ERR_CONNECTION_INVALID_CREDENTIALS = 1007;
  ERR_CONNECTION_DATABASE_NOT_FOUND = 1008;
  ERR_CONNECTION_DRIVE_NOT_READY = 1009; // FireBird específico
  
  // ========== ERROS DE SQL (1100-1199) ==========
  ERR_SQL_EXECUTION_FAILED = 1101;
  ERR_SQL_QUERY_FAILED = 1102;
  ERR_SQL_INVALID = 1103;
  ERR_SQL_INJECTION_DETECTED = 1104;
  ERR_SQL_TABLE_NOT_EXISTS = 1105;
  ERR_SQL_TABLE_CREATE_FAILED = 1106;
  ERR_SQL_TABLE_DROP_FAILED = 1107;
  ERR_SQL_TABLE_STRUCTURE_INVALID = 1108; // Estrutura incompatível
  ERR_SQL_COLUMN_NOT_FOUND = 1109;
  ERR_SQL_COLUMN_TYPE_MISMATCH = 1110;
  ERR_SQL_PRIMARY_KEY_MISSING = 1111;
  ERR_SQL_GENERATOR_EXISTS = 1112; // FireBird
  ERR_SQL_TRIGGER_EXISTS = 1113; // FireBird
  ERR_SQL_GENERATOR_NOT_FOUND = 1114; // FireBird
  ERR_SQL_TRIGGER_NOT_FOUND = 1115; // FireBird
  
  // ========== ERROS DE VALIDAÇÃO (1200-1299) ==========
  ERR_PARAMETER_NAME_EMPTY = 1201;
  ERR_PARAMETER_NAME_INVALID = 1202;
  ERR_PARAMETER_VALUE_INVALID = 1203;
  ERR_PARAMETER_REQUIRED = 1204;
  ERR_TABLE_NAME_EMPTY = 1205;
  ERR_SCHEMA_NAME_EMPTY = 1206;
  ERR_CONTRATO_ID_INVALID = 1207;
  ERR_PRODUTO_ID_INVALID = 1208;
  ERR_ORDEM_INVALID = 1209;
  ERR_TITULO_EMPTY = 1210;
  ERR_CHAVE_EMPTY = 1211;
  ERR_CHAVE_INVALID = 1212;
  
  // ========== ERROS DE OPERAÇÃO (1300-1399) ==========
  ERR_PARAMETER_NOT_FOUND = 1301;
  ERR_PARAMETER_ALREADY_EXISTS = 1302;
  ERR_INSERT_FAILED = 1303;
  ERR_UPDATE_FAILED = 1304;
  ERR_DELETE_FAILED = 1305;
  ERR_LIST_FAILED = 1306;
  ERR_GET_FAILED = 1307;
  ERR_COUNT_FAILED = 1308;
  ERR_EXISTS_FAILED = 1309;
  ERR_REFRESH_FAILED = 1310;
  
  // ========== ERROS DE CONFIGURAÇÃO (1400-1499) ==========
  ERR_ENGINE_NOT_DEFINED = 1401;
  ERR_DATABASE_TYPE_NOT_DEFINED = 1402;
  ERR_HOST_NOT_DEFINED = 1403;
  ERR_DATABASE_NOT_DEFINED = 1404;
  ERR_INVALID_CONFIGURATION = 1405;
  ERR_PORT_INVALID = 1406;
  ERR_USERNAME_NOT_DEFINED = 1407;
  ERR_SCHEMA_NOT_DEFINED = 1408; // Quando schema é obrigatório
  
  // ========== ERROS DE ARQUIVO (1500-1599) ==========
  ERR_FILE_NOT_FOUND = 1501;
  ERR_FILE_CANNOT_READ = 1502;
  ERR_FILE_CANNOT_WRITE = 1503;
  ERR_FILE_CANNOT_CREATE = 1504;
  ERR_FILE_ACCESS_DENIED = 1505;
  ERR_FILE_LOCKED = 1506;
  ERR_FILE_INVALID_FORMAT = 1507;
  ERR_FILE_ENCODING_INVALID = 1508;
  ERR_FILE_PATH_EMPTY = 1509;
  ERR_FILE_PATH_INVALID = 1510;
  ERR_DIRECTORY_NOT_EXISTS = 1511;
  ERR_DIRECTORY_CANNOT_CREATE = 1512;
  
  // ========== ERROS DE INI (1600-1699) ==========
  ERR_INI_FILE_NOT_FOUND = 1601;
  ERR_INI_FILE_CANNOT_READ = 1602;
  ERR_INI_FILE_CANNOT_WRITE = 1603;
  ERR_INI_SECTION_EMPTY = 1604;
  ERR_INI_SECTION_NOT_FOUND = 1605;
  ERR_INI_KEY_NOT_FOUND = 1606;
  ERR_INI_KEY_ALREADY_EXISTS = 1607;
  ERR_INI_INVALID_FORMAT = 1608;
  
  // ========== ERROS DE JSON (1700-1799) ==========
  ERR_JSON_FILE_NOT_FOUND = 1701;
  ERR_JSON_FILE_CANNOT_READ = 1702;
  ERR_JSON_FILE_CANNOT_WRITE = 1703;
  ERR_JSON_INVALID_FORMAT = 1704;
  ERR_JSON_INVALID_ENCODING = 1705;
  ERR_JSON_OBJECT_NOT_FOUND = 1706;
  ERR_JSON_KEY_NOT_FOUND = 1707;
  ERR_JSON_KEY_ALREADY_EXISTS = 1708;
  ERR_JSON_OBJECT_NAME_EMPTY = 1709;
  ERR_JSON_PARSE_ERROR = 1710;
  ERR_JSON_EMPTY = 1711;
  
  // ========== ERROS DE IMPORTAÇÃO/EXPORTAÇÃO (1800-1899) ==========
  ERR_IMPORT_FAILED = 1801;
  ERR_EXPORT_FAILED = 1802;
  ERR_IMPORT_SOURCE_NOT_FOUND = 1803;
  ERR_IMPORT_TARGET_NOT_FOUND = 1804;
  ERR_EXPORT_SOURCE_NOT_FOUND = 1805;
  ERR_EXPORT_TARGET_NOT_FOUND = 1806;
  ERR_IMPORT_INVALID_DATA = 1807;
  ERR_EXPORT_INVALID_DATA = 1808;
  ERR_IMPORT_OVERWRITE_DENIED = 1809;
  
  { =============================================================================
    MENSAGENS DE ERRO - Padronizadas e Formatáveis
    ============================================================================= }
  
  // ========== MENSAGENS DE CONEXÃO ==========
  MSG_CONNECTION_NOT_ASSIGNED = 'Conexao nao foi inicializada. Use TParameters.New() para criar uma instancia.';
  MSG_CONNECTION_FAILED = 'Falha ao conectar ao banco de dados. Verifique as configuracoes de conexao (Host, Port, Username, Password, Database).';
  MSG_CONNECTION_NOT_CONNECTED = 'Nao ha conexao ativa com o banco de dados. Use Connect() para estabelecer conexao.';
  MSG_DISCONNECTION_FAILED = 'Falha ao desconectar do banco de dados.';
  MSG_CONNECTION_TIMEOUT = 'Timeout ao conectar ao banco de dados. Verifique se o servidor esta acessivel.';
  MSG_CONNECTION_INVALID_CREDENTIALS = 'Credenciais invalidas. Verifique Username e Password.';
  MSG_CONNECTION_DATABASE_NOT_FOUND = 'Banco de dados "%s" nao encontrado. Verifique o nome do banco ou liste os bancos disponiveis.';
  MSG_CONNECTION_DRIVE_NOT_READY = 'Drive nao esta acessivel ou nao existe. Verifique o caminho do arquivo.';
  
  // ========== MENSAGENS DE SQL ==========
  MSG_SQL_EXECUTION_FAILED = 'Falha ao executar comando SQL: %s';
  MSG_SQL_QUERY_FAILED = 'Falha ao executar consulta SQL: %s';
  MSG_SQL_INVALID = 'SQL invalido: %s';
  MSG_SQL_TABLE_NOT_EXISTS = 'Tabela "%s" nao existe. Use CreateTable() para criar a tabela.';
  MSG_SQL_TABLE_CREATE_FAILED = 'Falha ao criar tabela "%s": %s';
  MSG_SQL_TABLE_DROP_FAILED = 'Falha ao remover tabela "%s": %s';
  MSG_SQL_TABLE_STRUCTURE_INVALID = 'Estrutura da tabela "%s" incompativel. %s';
  MSG_SQL_COLUMN_NOT_FOUND = 'Coluna "%s" nao encontrada na tabela "%s".';
  MSG_SQL_COLUMN_TYPE_MISMATCH = 'Coluna "%s" deve ser do tipo %s, mas encontrado: %s';
  MSG_SQL_PRIMARY_KEY_MISSING = 'Coluna "%s" deve ser PRIMARY KEY.';
  MSG_SQL_GENERATOR_EXISTS = 'Generator "%s" ja existe no banco de dados.';
  MSG_SQL_TRIGGER_EXISTS = 'Trigger "%s" ja existe no banco de dados.';
  
  // ========== MENSAGENS DE VALIDAÇÃO ==========
  MSG_PARAMETER_NAME_EMPTY = 'O nome do parametro nao pode estar vazio.';
  MSG_PARAMETER_NAME_INVALID = 'Nome de parametro invalido: "%s". Use apenas letras, numeros e underscores.';
  MSG_PARAMETER_VALUE_INVALID = 'Valor do parametro invalido para o tipo %s: "%s"';
  MSG_PARAMETER_REQUIRED = 'O parametro "%s" e obrigatorio.';
  MSG_TABLE_NAME_EMPTY = 'O nome da tabela nao pode estar vazio. Use TableName() para definir.';
  MSG_SCHEMA_NAME_EMPTY = 'O nome do schema nao pode estar vazio. Use Schema() para definir.';
  MSG_CONTRATO_ID_INVALID = 'Contrato ID deve ser um numero valido (>= 0).';
  MSG_PRODUTO_ID_INVALID = 'Produto ID deve ser um numero valido (>= 0).';
  MSG_ORDEM_INVALID = 'Ordem deve ser um numero valido (>= 0).';
  MSG_TITULO_EMPTY = 'O titulo nao pode estar vazio.';
  MSG_CHAVE_EMPTY = 'A chave nao pode estar vazia.';
  MSG_CHAVE_INVALID = 'Chave invalida: "%s". Use apenas letras, numeros e underscores.';
  
  // ========== MENSAGENS DE OPERAÇÃO ==========
  MSG_PARAMETER_NOT_FOUND = 'Parametro "%s" nao encontrado na tabela %s.';
  MSG_PARAMETER_ALREADY_EXISTS = 'Parametro "%s" ja existe na tabela %s.';
  MSG_INSERT_FAILED = 'Falha ao inserir parametro "%s": %s';
  MSG_UPDATE_FAILED = 'Falha ao atualizar parametro "%s": %s';
  MSG_DELETE_FAILED = 'Falha ao deletar parametro "%s": %s';
  MSG_LIST_FAILED = 'Falha ao listar parametros: %s';
  MSG_GET_FAILED = 'Falha ao obter parametro "%s": %s';
  MSG_COUNT_FAILED = 'Falha ao contar parametros: %s';
  MSG_EXISTS_FAILED = 'Falha ao verificar existencia do parametro "%s": %s';
  MSG_REFRESH_FAILED = 'Falha ao renovar dados: %s';
  
  // ========== MENSAGENS DE CONFIGURAÇÃO ==========
  MSG_ENGINE_NOT_DEFINED = 'Engine de banco de dados nao definido. Use Engine() para configurar.';
  MSG_DATABASE_TYPE_NOT_DEFINED = 'Tipo de banco de dados nao definido. Use DatabaseType() para configurar.';
  MSG_HOST_NOT_DEFINED = 'Host do servidor nao definido. Use Host() para configurar.';
  MSG_DATABASE_NOT_DEFINED = 'Nome do banco de dados nao definido. Use Database() para configurar.';
  MSG_INVALID_CONFIGURATION = 'Configuracao invalida: %s';
  MSG_PORT_INVALID = 'Porta deve ser um numero valido entre 1 e 65535.';
  MSG_USERNAME_NOT_DEFINED = 'Username nao definido. Use Username() para configurar.';
  MSG_SCHEMA_NOT_DEFINED = 'Schema nao definido. Use Schema() para configurar (obrigatorio para %s).';
  
  // ========== MENSAGENS DE ARQUIVO ==========
  MSG_FILE_NOT_FOUND = 'Arquivo nao encontrado: %s';
  MSG_FILE_CANNOT_READ = 'Nao foi possivel ler o arquivo: %s';
  MSG_FILE_CANNOT_WRITE = 'Nao foi possivel escrever no arquivo: %s';
  MSG_FILE_CANNOT_CREATE = 'Nao foi possivel criar o arquivo: %s';
  MSG_FILE_ACCESS_DENIED = 'Acesso negado ao arquivo: %s';
  MSG_FILE_LOCKED = 'Arquivo esta sendo usado por outro processo: %s';
  MSG_FILE_INVALID_FORMAT = 'Formato de arquivo invalido: %s';
  MSG_FILE_ENCODING_INVALID = 'Encoding do arquivo invalido ou nao suportado: %s';
  MSG_FILE_PATH_EMPTY = 'Caminho do arquivo nao pode estar vazio.';
  MSG_FILE_PATH_INVALID = 'Caminho do arquivo invalido: %s';
  MSG_DIRECTORY_NOT_EXISTS = 'Diretorio nao existe: %s';
  MSG_DIRECTORY_CANNOT_CREATE = 'Nao foi possivel criar o diretorio: %s';
  
  // ========== MENSAGENS DE INI ==========
  MSG_INI_FILE_NOT_FOUND = 'Arquivo INI nao encontrado: %s';
  MSG_INI_FILE_CANNOT_READ = 'Nao foi possivel ler o arquivo INI: %s';
  MSG_INI_FILE_CANNOT_WRITE = 'Nao foi possivel escrever no arquivo INI: %s';
  MSG_INI_SECTION_EMPTY = 'Secao do INI nao pode estar vazia. Use Section() para definir.';
  MSG_INI_SECTION_NOT_FOUND = 'Secao "%s" nao encontrada no arquivo INI.';
  MSG_INI_KEY_NOT_FOUND = 'Chave "%s" nao encontrada na secao "%s".';
  MSG_INI_KEY_ALREADY_EXISTS = 'Chave "%s" ja existe na secao "%s".';
  MSG_INI_INVALID_FORMAT = 'Formato do arquivo INI invalido: %s';
  
  // ========== MENSAGENS DE JSON ==========
  MSG_JSON_FILE_NOT_FOUND = 'Arquivo JSON nao encontrado: %s';
  MSG_JSON_FILE_CANNOT_READ = 'Nao foi possivel ler o arquivo JSON: %s';
  MSG_JSON_FILE_CANNOT_WRITE = 'Nao foi possivel escrever no arquivo JSON: %s';
  MSG_JSON_INVALID_FORMAT = 'Formato JSON invalido: %s';
  MSG_JSON_INVALID_ENCODING = 'Encoding do arquivo JSON invalido. Suportado: UTF-8 (com/sem BOM) ou ANSI.';
  MSG_JSON_OBJECT_NOT_FOUND = 'Objeto JSON "%s" nao encontrado.';
  MSG_JSON_KEY_NOT_FOUND = 'Chave "%s" nao encontrada no objeto "%s".';
  MSG_JSON_KEY_ALREADY_EXISTS = 'Chave "%s" ja existe no objeto "%s".';
  MSG_JSON_OBJECT_NAME_EMPTY = 'Nome do objeto JSON nao pode estar vazio. Use ObjectName() para definir.';
  MSG_JSON_PARSE_ERROR = 'Erro ao parsear arquivo JSON: %s';
  MSG_JSON_EMPTY = 'Arquivo JSON esta vazio ou nao contem dados validos.';
  
  // ========== MENSAGENS DE IMPORTAÇÃO/EXPORTAÇÃO ==========
  MSG_IMPORT_FAILED = 'Falha ao importar dados: %s';
  MSG_EXPORT_FAILED = 'Falha ao exportar dados: %s';
  MSG_IMPORT_SOURCE_NOT_FOUND = 'Fonte de importacao nao encontrada ou nao configurada.';
  MSG_IMPORT_TARGET_NOT_FOUND = 'Destino de importacao nao encontrado ou nao configurado.';
  MSG_EXPORT_SOURCE_NOT_FOUND = 'Fonte de exportacao nao encontrada ou nao configurada.';
  MSG_EXPORT_TARGET_NOT_FOUND = 'Destino de exportacao nao encontrado ou nao configurado.';
  MSG_IMPORT_INVALID_DATA = 'Dados invalidos para importacao: %s';
  MSG_EXPORT_INVALID_DATA = 'Dados invalidos para exportacao: %s';
  MSG_IMPORT_OVERWRITE_DENIED = 'Importacao cancelada pelo usuario (sobrescrita negada).';

{ =============================================================================
  FUNÇÕES AUXILIARES - Criação de Exceções
  ============================================================================= }

// Cria exceção de conexão
function CreateConnectionException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersConnectionException;

// Cria exceção de SQL
function CreateSQLException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersSQLException;

// Cria exceção de validação
function CreateValidationException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersValidationException;

// Cria exceção de não encontrado
function CreateNotFoundException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersNotFoundException;

// Cria exceção de configuração
function CreateConfigurationException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersConfigurationException;

// Cria exceção de arquivo
function CreateFileException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersFileException;

// Cria exceção de INI
function CreateInifilesException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersInifilesException;

// Cria exceção de JSON
function CreateJsonObjectException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersJsonObjectException;

{ =============================================================================
  FUNÇÕES AUXILIARES - Conversão de Exceções Genéricas
  ============================================================================= }

// Converte exceção genérica para exceção do Parameters (quando possível)
function ConvertToParametersException(const AException: Exception; const AOperation: string = ''): EParametersException;

// Verifica se uma exceção é do tipo Parameters
function IsParametersException(const AException: Exception): Boolean;

// Obtém código de erro de uma exceção (retorna 0 se não for exceção Parameters)
function GetExceptionErrorCode(const AException: Exception): Integer;

// Obtém operação de uma exceção (retorna string vazia se não for exceção Parameters)
function GetExceptionOperation(const AException: Exception): string;

implementation

{ EParametersException }

constructor EParametersException.Create(const AMessage: string; const AErrorCode: Integer; const AOperation: string);
begin
  inherited Create(AMessage);
  FErrorCode := AErrorCode;
  FOperation := AOperation;
end;

{ Funções Auxiliares - Criação de Exceções }

function CreateConnectionException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersConnectionException;
begin
  Result := EParametersConnectionException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateSQLException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersSQLException;
begin
  Result := EParametersSQLException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateValidationException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersValidationException;
begin
  Result := EParametersValidationException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateNotFoundException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersNotFoundException;
begin
  Result := EParametersNotFoundException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateConfigurationException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersConfigurationException;
begin
  Result := EParametersConfigurationException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateFileException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersFileException;
begin
  Result := EParametersFileException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateInifilesException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersInifilesException;
begin
  Result := EParametersInifilesException.Create(AMessage, AErrorCode, AOperation);
end;

function CreateJsonObjectException(const AMessage: string; const AErrorCode: Integer; const AOperation: string): EParametersJsonObjectException;
begin
  Result := EParametersJsonObjectException.Create(AMessage, AErrorCode, AOperation);
end;

{ Funções Auxiliares - Conversão de Exceções }

function ConvertToParametersException(const AException: Exception; const AOperation: string): EParametersException;
var
  LMessage: string;
  LErrorCode: Integer;
  LOperation: string;
begin
  LMessage := AException.Message;
  LOperation := AOperation;
  
  // Se já for exceção Parameters, retorna como está (mas pode atualizar Operation)
  if AException is EParametersException then
  begin
    Result := EParametersException(AException);
    if (LOperation <> '') and (Result.Operation = '') then
    begin
      // Cria nova exceção com Operation atualizada
      if AException is EParametersConnectionException then
        Result := CreateConnectionException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersSQLException then
        Result := CreateSQLException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersValidationException then
        Result := CreateValidationException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersNotFoundException then
        Result := CreateNotFoundException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersConfigurationException then
        Result := CreateConfigurationException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersFileException then
        Result := CreateFileException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersInifilesException then
        Result := CreateInifilesException(LMessage, Result.ErrorCode, LOperation)
      else if AException is EParametersJsonObjectException then
        Result := CreateJsonObjectException(LMessage, Result.ErrorCode, LOperation)
      else
        Result := EParametersException.Create(LMessage, Result.ErrorCode, LOperation);
    end
    else
      Result := EParametersException(AException);
    Exit;
  end;
  
  // Tenta detectar tipo de erro pela mensagem
  LMessage := UpperCase(LMessage);
  
  // Erros de conexão
  if (Pos('CONNECTION', LMessage) > 0) or 
     (Pos('CONNECT', LMessage) > 0) or
     (Pos('DISCONNECT', LMessage) > 0) or
     (Pos('TIMEOUT', LMessage) > 0) or
     (Pos('CREDENTIALS', LMessage) > 0) or
     (Pos('DATABASE', LMessage) > 0) and (Pos('NOT FOUND', LMessage) > 0) then
  begin
    if Pos('NOT CONNECTED', LMessage) > 0 then
      LErrorCode := ERR_CONNECTION_NOT_CONNECTED
    else if Pos('TIMEOUT', LMessage) > 0 then
      LErrorCode := ERR_CONNECTION_TIMEOUT
    else if Pos('CREDENTIALS', LMessage) > 0 then
      LErrorCode := ERR_CONNECTION_INVALID_CREDENTIALS
    else
      LErrorCode := ERR_CONNECTION_FAILED;
    Result := CreateConnectionException(AException.Message, LErrorCode, LOperation);
  end
  // Erros de SQL
  else if (Pos('SQL', LMessage) > 0) or
          (Pos('TABLE', LMessage) > 0) or
          (Pos('COLUMN', LMessage) > 0) or
          (Pos('QUERY', LMessage) > 0) or
          (Pos('EXECUTE', LMessage) > 0) then
  begin
    if Pos('TABLE NOT EXISTS', LMessage) > 0 then
      LErrorCode := ERR_SQL_TABLE_NOT_EXISTS
    else if Pos('TABLE STRUCTURE', LMessage) > 0 then
      LErrorCode := ERR_SQL_TABLE_STRUCTURE_INVALID
    else if Pos('COLUMN NOT FOUND', LMessage) > 0 then
      LErrorCode := ERR_SQL_COLUMN_NOT_FOUND
    else
      LErrorCode := ERR_SQL_EXECUTION_FAILED;
    Result := CreateSQLException(AException.Message, LErrorCode, LOperation);
  end
  // Erros de arquivo
  else if (Pos('FILE', LMessage) > 0) or
          (Pos('CANNOT READ', LMessage) > 0) or
          (Pos('CANNOT WRITE', LMessage) > 0) or
          (Pos('ACCESS DENIED', LMessage) > 0) or
          (Pos('LOCKED', LMessage) > 0) then
  begin
    if Pos('NOT FOUND', LMessage) > 0 then
      LErrorCode := ERR_FILE_NOT_FOUND
    else if Pos('CANNOT READ', LMessage) > 0 then
      LErrorCode := ERR_FILE_CANNOT_READ
    else if Pos('CANNOT WRITE', LMessage) > 0 then
      LErrorCode := ERR_FILE_CANNOT_WRITE
    else if Pos('ACCESS DENIED', LMessage) > 0 then
      LErrorCode := ERR_FILE_ACCESS_DENIED
    else
      LErrorCode := ERR_FILE_CANNOT_CREATE;
    Result := CreateFileException(AException.Message, LErrorCode, LOperation);
  end
  // Erros de JSON
  else if (Pos('JSON', LMessage) > 0) or
          (Pos('PARSE', LMessage) > 0) and (Pos('JSON', LMessage) > 0) then
  begin
    if Pos('INVALID FORMAT', LMessage) > 0 then
      LErrorCode := ERR_JSON_INVALID_FORMAT
    else if Pos('ENCODING', LMessage) > 0 then
      LErrorCode := ERR_JSON_INVALID_ENCODING
    else if Pos('PARSE', LMessage) > 0 then
      LErrorCode := ERR_JSON_PARSE_ERROR
    else
      LErrorCode := ERR_JSON_INVALID_FORMAT;
    Result := CreateJsonObjectException(AException.Message, LErrorCode, LOperation);
  end
  // Erros de validação
  else if (Pos('EMPTY', LMessage) > 0) or
          (Pos('INVALID', LMessage) > 0) or
          (Pos('REQUIRED', LMessage) > 0) then
  begin
    if Pos('NAME EMPTY', LMessage) > 0 then
      LErrorCode := ERR_PARAMETER_NAME_EMPTY
    else if Pos('TABLE NAME EMPTY', LMessage) > 0 then
      LErrorCode := ERR_TABLE_NAME_EMPTY
    else
      LErrorCode := ERR_PARAMETER_REQUIRED;
    Result := CreateValidationException(AException.Message, LErrorCode, LOperation);
  end
  // Fallback: exceção genérica do Parameters
  else
  begin
    Result := EParametersException.Create(AException.Message, 0, LOperation);
  end;
end;

function IsParametersException(const AException: Exception): Boolean;
begin
  Result := AException is EParametersException;
end;

function GetExceptionErrorCode(const AException: Exception): Integer;
begin
  if AException is EParametersException then
    Result := EParametersException(AException).ErrorCode
  else
    Result := 0;
end;

function GetExceptionOperation(const AException: Exception): string;
begin
  if AException is EParametersException then
    Result := EParametersException(AException).Operation
  else
    Result := '';
end;

end.
