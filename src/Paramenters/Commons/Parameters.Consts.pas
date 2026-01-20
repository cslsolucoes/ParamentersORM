unit Parameters.Consts;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters.Consts - Constantes do Sistema de Parâmetros
  
  Descrição:
  Define todas as constantes utilizadas pelo sistema de parâmetros, incluindo
  valores padrão para configuração, nomes de tabelas, seções e caminhos.
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 01/01/2026
  ============================================================================= }

interface

{$I ../../Paramenters.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils, StrUtils,
{$ELSE}
  System.SysUtils, System.StrUtils,
{$ENDIF}
  Parameters.Types;

const
  { =============================================================================
    CONFIGURAÇÕES DE BANCO DE DADOS
    
    Descrição:
    Arrays de mapeamento entre tipos de banco de dados (enum) e strings
    utilizadas por cada engine (UniDAC, FireDAC, Zeos). Esses arrays são
    usados para converter o enum TParameterDatabaseTypes para a string
    específica que cada engine espera.
    
    Uso:
    - TDatabaseFireDac: Strings para FireDAC (ex: 'PG' para PostgreSQL)
    - TDatabaseZeus: Strings para Zeos (ex: 'postgresql' para PostgreSQL)
    - TDatabaseUnidac: Strings para UniDAC (ex: 'PostgreSQL' para PostgreSQL)
    - TEngineDatabase: Strings para engines (ex: 'Unidac', 'FireDac', 'Zeos')
    ============================================================================= }

  /// <summary>
  /// Mapeamento de tipos de banco para strings do FireDAC
  /// </summary>
  TDatabaseFireDac : Array [TParameterDatabaseTypes]  of string = ('None', 'FB', 'MySQL', 'PG', 'SQLite', 'MSSQL', 'MSAcc', 'ODBC', 'LDAP');
  
  /// <summary>
  /// Mapeamento de tipos de banco para strings do Zeos
  /// </summary>
  TDatabaseZeus    : Array [TParameterDatabaseTypes]  of string = ('None', 'firebird', 'mysql', 'postgresql', 'sqlite', 'mssql', 'OleDB', 'odbc_a', 'ldap');
  
  /// <summary>
  /// Mapeamento de tipos de banco para strings do UniDAC
  /// </summary>
  TDatabaseUnidac  : Array [TParameterDatabaseTypes]  of string = ('None', 'InterBase', 'MySQL', 'PostgreSQL', 'SQLite', 'SQL Server', 'Access', 'ODBC', 'LDAP');
  
  /// <summary>
  /// Mapeamento de engines para strings
  /// </summary>
  TEngineDatabase  : Array [TParameterDatabaseEngine] of string = ('None', 'Unidac', 'FireDac', 'Zeos', 'LDAP');
  
  { =============================================================================
    VALORES PADRÃO DE CONEXÃO POR TIPO DE BANCO
    ============================================================================= }
  
  // Valores padrão de Host por tipo de banco
  DEFAULT_DATABASE_HOST_FIREBIRD = 'localhost';
  DEFAULT_DATABASE_HOST_MYSQL = 'localhost';
  DEFAULT_DATABASE_HOST_POSTGRESQL = 'localhost';
  DEFAULT_DATABASE_HOST_SQLSERVER = 'localhost';
  DEFAULT_DATABASE_HOST_SQLITE = ''; // SQLite não usa host
  DEFAULT_DATABASE_HOST_ACCESS = ''; // Access não usa host
  DEFAULT_DATABASE_HOST_ODBC = ''; // ODBC usa DSN
  DEFAULT_DATABASE_HOST_LDAP = 'localhost';
  
  // Valores padrão de Porta por tipo de banco
  DEFAULT_DATABASE_PORT_FIREBIRD = 3050;
  DEFAULT_DATABASE_PORT_MYSQL = 3306;
  DEFAULT_DATABASE_PORT_POSTGRESQL = 5432;
  DEFAULT_DATABASE_PORT_SQLSERVER = 1433;
  DEFAULT_DATABASE_PORT_SQLITE = 0; // SQLite não usa porta
  DEFAULT_DATABASE_PORT_ACCESS = 0; // Access não usa porta
  DEFAULT_DATABASE_PORT_ODBC = 0; // ODBC não usa porta diretamente
  DEFAULT_DATABASE_PORT_LDAP = 389;
  
  // Valores padrão de Username por tipo de banco
  DEFAULT_DATABASE_USERNAME_FIREBIRD = 'SYSDBA';
  DEFAULT_DATABASE_USERNAME_MYSQL = 'root';
  DEFAULT_DATABASE_USERNAME_POSTGRESQL = 'postgres';
  DEFAULT_DATABASE_USERNAME_SQLSERVER = 'sa';
  DEFAULT_DATABASE_USERNAME_SQLITE = ''; // SQLite não usa username
  DEFAULT_DATABASE_USERNAME_ACCESS = ''; // Access não usa username
  DEFAULT_DATABASE_USERNAME_ODBC = ''; // ODBC pode usar username do DSN
  DEFAULT_DATABASE_USERNAME_LDAP = '';
  
  // Valores padrão de Password por tipo de banco
  DEFAULT_DATABASE_PASSWORD_FIREBIRD = 'masterkey';
  DEFAULT_DATABASE_PASSWORD_MYSQL = '';
  DEFAULT_DATABASE_PASSWORD_POSTGRESQL = '';
  DEFAULT_DATABASE_PASSWORD_SQLSERVER = '';
  DEFAULT_DATABASE_PASSWORD_SQLITE = ''; // SQLite não usa password
  DEFAULT_DATABASE_PASSWORD_ACCESS = ''; // Access não usa password
  DEFAULT_DATABASE_PASSWORD_ODBC = ''; // ODBC pode usar password do DSN
  DEFAULT_DATABASE_PASSWORD_LDAP = '';
  
  // Valores padrão de Database por tipo de banco
  DEFAULT_DATABASE_NAME_FIREBIRD = '';
  DEFAULT_DATABASE_NAME_MYSQL = '';
  DEFAULT_DATABASE_NAME_POSTGRESQL = 'postgres';
  DEFAULT_DATABASE_NAME_SQLSERVER = 'master';
  DEFAULT_DATABASE_NAME_SQLITE = 'config.db';
  DEFAULT_DATABASE_NAME_ACCESS = 'config.mdb';
  DEFAULT_DATABASE_NAME_ODBC = ''; // ODBC usa DSN
  DEFAULT_DATABASE_NAME_LDAP = '';
  
  // Nomes genéricos de DatabaseTypes (usado para conversão de enum para string)
  TDatabaseTypeNames: Array [TParameterDatabaseTypes] of string = (
    'None',        // pdtNone
    'Firebird',    // pdtFireBird
    'MySQL',       // pdtMySQL
    'PostgreSQL',  // pdtPostgreSQL
    'SQLite',      // pdtSQLite
    'SQL Server',  // pdtSQLServer
    'Access',      // pdtAccess
    'ODBC',        // pdtODBC
    'LDAP'         // pdtLDAP
  );

  TDatabaseConfig: array [TParameterDatabaseTypes, TParameterDatabaseEngine] of string = (
                    // Ordem das Colunas:  ( None, Unidac, FireDac, Zeos, LDAP)
                    { dtNone }             ('None', 'None', 'None', 'None', 'None'),
                    { dtInterBase }        ('None', 'InterBase', 'FB', 'firebird', 'None'),
                    { dtMySQL }            ('None', 'MySQL', 'MySQL', 'mysql', 'None'),
                    { dtPostgreSQL }       ('None', 'PostgreSQL', 'PG', 'postgresql', 'None'),
                    { dtSQLite }           ('None', 'SQLite', 'SQLite', 'sqlite', 'None'),
                    { dtSQLServer }        ('None', 'SQL Server', 'MSSQL', 'mssql', 'None'),
                    { dtAccess }           ('None', 'Access', 'MSAcc', 'OleDB', 'None'),
                    { dtODBC }             ('None', 'ODBC', 'ODBC', 'odbc_a', 'None'),
                    { dtLDAP }             ('None', 'None', 'None', 'None', 'LDAP'));

  { =============================================================================
    MAPEAMENTO DE TIPOS DE VALOR
    ============================================================================= }

  // Mapeamento de tipos para strings
  ParameterValueTypeNames: array[TParameterValueType] of string = ('String', 'Integer', 'Float', 'Boolean', 'DateTime', 'JSON');

  // Mapeamento de strings para tipos
  // (usado em funções auxiliares)

  { =============================================================================
    CONFIGURAÇÕES PADRÃO
    ============================================================================= }

  // Fonte padrão
  DEFAULT_PARAMETER_SOURCE = psDatabase;

  // Tipo de valor padrão
  DEFAULT_PARAMETER_VALUE_TYPE = pvtString;

  // Configuração padrão (Database com fallback para INI)
  DEFAULT_PARAMETER_CONFIG: TParameterConfig = [pcfDataBase, pcfInifile];

  // Configuração apenas Database
  DEFAULT_PARAMETER_CONFIG_DATABASE_ONLY: TParameterConfig = [pcfDataBase];

  // Configuração apenas INI
  DEFAULT_PARAMETER_CONFIG_INIFILE_ONLY: TParameterConfig = [pcfInifile];

  // Configuração apenas JSON
  DEFAULT_PARAMETER_CONFIG_JSON_ONLY: TParameterConfig = [pcfJsonObject];

  // Configuração todas as fontes (Database → INI → JSON)
  DEFAULT_PARAMETER_CONFIG_ALL: TParameterConfig = [pcfDataBase, pcfInifile, pcfJsonObject];

  // Ordem de prioridade padrão (cascata)
  DEFAULT_PARAMETER_PRIORITY: array[0..2] of string = ('Database', 'Inifiles', 'JsonObject');

  {$i ../../Paramenters.Database.inc}

  { =============================================================================
    CONFIGURAÇÕES DE ARQUIVOS INI
    ============================================================================= }

  // Nome padrão do arquivo INI
  DEFAULT_PARAMETER_INI_FILENAME = 'parameters.ini';

  // Seção padrão
  DEFAULT_PARAMETER_INI_SECTION = 'Parameters';

  // Criar arquivo automaticamente
  DEFAULT_PARAMETER_AUTO_CREATE_INI = True;

  { =============================================================================
    CONFIGURAÇÕES DE JSON
    ============================================================================= }

  // Nome padrão do arquivo JSON
  DEFAULT_PARAMETER_JSON_FILENAME = 'D:\Dados\config.json';

  // Nome padrão do objeto JSON
  DEFAULT_PARAMETER_JSON_OBJECT_NAME_ROOT = 'parameters';

  // Criar arquivo automaticamente
  DEFAULT_PARAMETER_AUTO_CREATE_JSON = True;

  { =============================================================================
    VALIDAÇÃO E LIMITES
    ============================================================================= }

  // Tamanho máximo do nome do parâmetro
  MAX_PARAMETER_NAME_LENGTH = 255;

  // Tamanho máximo do valor (para tipos string)
  MAX_PARAMETER_VALUE_LENGTH = 65535; // 64KB

  // Tamanho máximo da descrição
  MAX_PARAMETER_DESCRIPTION_LENGTH = 1000;

  { =============================================================================
    CONFIGURAÇÕES DE REORDENAÇÃO AUTOMÁTICA
    ============================================================================= }

  // Habilita reordenação automática ao inserir parâmetros com ordem existente
  // Se True: ao inserir ordem 2 quando já existe, renumerará o existente para 3
  // Se False: não renumerará (pode causar duplicação de ordens)
  DEFAULT_PARAMETER_AUTO_REORDER_ON_INSERT = True;

  // Habilita renumerar automaticamente quando ordem = 0
  // Se True: ordem 0 será automaticamente renumerada para a próxima ordem disponível
  // Se False: ordem 0 será mantida como 0
  DEFAULT_PARAMETER_AUTO_RENUMBER_ZERO_ORDER = True;

  // Habilita reordenação automática ao atualizar parâmetros
  // Se True: ao atualizar ordem, renumerará outros parâmetros automaticamente
  // Se False: não renumerará (pode causar duplicação de ordens)
  DEFAULT_PARAMETER_AUTO_REORDER_ON_UPDATE = True;

  { =============================================================================
    CONFIGURAÇÕES DE IMPORTAÇÃO
    ============================================================================= }

  // Comportamento padrão ao importar quando chave já existe
  // Se True: sobrepõe automaticamente sem perguntar
  // Se False: pergunta ao usuário antes de sobrepor (requer callback)
  DEFAULT_PARAMETER_IMPORT_OVERWRITE_EXISTING = False;

  // Habilita flag para permitir sobreposição silenciosa na importação
  // Se True: permite definir flag para sobrepor sem perguntar
  // Se False: sempre pergunta (ou usa callback)
  DEFAULT_PARAMETER_IMPORT_ALLOW_SILENT_OVERWRITE = True;

  { =============================================================================
    FORMATOS E EXTENSÕES
    ============================================================================= }

  // Extensão padrão para arquivos INI
  PARAMETER_INI_EXTENSION = '.ini';

  // Extensão padrão para arquivos JSON
  PARAMETER_JSON_EXTENSION = '.json';

  { =============================================================================
    MENSAGENS E TEXTO
    ============================================================================= }

  // Mensagem quando parâmetro não encontrado
  PARAMETER_NOT_FOUND = 'Parameter not found';

  // Mensagem quando fonte não configurada
  PARAMETER_SOURCE_NOT_CONFIGURED = 'Parameter source not configured';

  // Mensagem quando tabela não existe
  PARAMETER_TABLE_NOT_EXISTS = 'Parameter table does not exist';

  // Mensagem quando arquivo não existe
  PARAMETER_FILE_NOT_EXISTS = 'Parameter file does not exist';

  { =============================================================================
    ORDENAÇÃO PADRÃO
    ============================================================================= }

  // Ordenação padrão para listagem de parâmetros
  // Ordem: Contrato → Produto → Título → Ordem
  // Esta ordenação é aplicada automaticamente em todas as consultas de listagem
  DEFAULT_PARAMETER_ORDER_BY = 'contrato_id, produto_id, titulo, ordem';

  { =============================================================================
    ESTRUTURA DE TABELA PADRÃO (SQL)
    ============================================================================= }

  // SQL para criar tabela no PostgreSQL
  // IMPORTANTE: BIGSERIAL é equivalente a BIGINT + SEQUENCE + DEFAULT nextval()
  // BIGSERIAL já inclui auto-incremento automaticamente
  // CONSTRAINT UNIQUE garante unicidade da combinação: contrato_id, produto_id, titulo, chave
  SQL_CREATE_TABLE_POSTGRESQL = 
    'CREATE TABLE IF NOT EXISTS %s (' +
    'config_id BIGSERIAL NOT NULL PRIMARY KEY, ' +
    'contrato_id INTEGER NOT NULL DEFAULT 1, ' +
    'produto_id INTEGER NOT NULL DEFAULT 1, ' +
    'ordem INTEGER NOT NULL DEFAULT 0, ' +
    'titulo VARCHAR(255) NOT NULL, ' +
    'chave VARCHAR(255) NOT NULL, ' +
    'valor BYTEA, ' +
    'descricao TEXT, ' +
    'ativo BOOLEAN NOT NULL DEFAULT true, ' +
    'data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'data_alteracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'CONSTRAINT chaves_unicas UNIQUE (contrato_id, produto_id, titulo, chave)' +
    ')';

  // SQL para criar tabela no MySQL
  // IMPORTANTE: AUTO_INCREMENT deve vir antes de PRIMARY KEY
  // BIGINT AUTO_INCREMENT PRIMARY KEY garante auto-incremento
  // CONSTRAINT UNIQUE garante unicidade da combinação: contrato_id, produto_id, titulo, chave
  SQL_CREATE_TABLE_MYSQL =
    'CREATE TABLE IF NOT EXISTS %s (' +
    'config_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, ' +
    'contrato_id INTEGER NOT NULL DEFAULT 1, ' +
    'produto_id INTEGER NOT NULL DEFAULT 1, ' +
    'ordem INTEGER NOT NULL DEFAULT 0, ' +
    'titulo VARCHAR(255) NOT NULL, ' +
    'chave VARCHAR(255) NOT NULL, ' +
    'valor BLOB, ' +
    'descricao TEXT, ' +
    'ativo BOOLEAN NOT NULL DEFAULT true, ' +
    'data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
    'CONSTRAINT chaves_unicas UNIQUE (contrato_id, produto_id, titulo, chave)' +
    ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4';

  // SQL para criar tabela no SQL Server
  // IMPORTANTE: IDENTITY(1,1) garante auto-incremento começando em 1, incrementando de 1 em 1
  // IDENTITY deve vir antes de PRIMARY KEY
  // CONSTRAINT UNIQUE garante unicidade da combinação: contrato_id, produto_id, titulo, chave
  SQL_CREATE_TABLE_SQLSERVER =
    'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''%s'') AND type in (N''U'')) ' +
    'CREATE TABLE %s (' +
    'config_id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY, ' +
    'contrato_id INTEGER NOT NULL DEFAULT 1, ' +
    'produto_id INTEGER NOT NULL DEFAULT 1, ' +
    'ordem INTEGER NOT NULL DEFAULT 0, ' +
    'titulo NVARCHAR(255) NOT NULL, ' +
    'chave NVARCHAR(255) NOT NULL, ' +
    'valor VARBINARY(MAX), ' +
    'descricao NVARCHAR(MAX), ' +
    'ativo BIT NOT NULL DEFAULT 1, ' +
    'data_cadastro DATETIME2 NOT NULL DEFAULT GETDATE(), ' +
    'data_alteracao DATETIME2 NOT NULL DEFAULT GETDATE(), ' +
    'CONSTRAINT chaves_unicas UNIQUE (contrato_id, produto_id, titulo, chave)' +
    ')';

  // SQL para criar tabela no SQLite
  // IMPORTANTE: INTEGER PRIMARY KEY AUTOINCREMENT garante auto-incremento
  // O Zeos detecta automaticamente INTEGER PRIMARY KEY como auto-incremento
  // CONSTRAINT UNIQUE com ON CONFLICT REPLACE garante unicidade e substitui em caso de conflito
  SQL_CREATE_TABLE_SQLITE =
    'CREATE TABLE IF NOT EXISTS %s (' +
    'config_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
    'contrato_id INTEGER NOT NULL DEFAULT 1, ' +
    'produto_id INTEGER NOT NULL DEFAULT 1, ' +
    'ordem INTEGER NOT NULL DEFAULT 0, ' +
    'titulo TEXT NOT NULL, ' +
    'chave TEXT NOT NULL, ' +
    'valor BLOB, ' +
    'descricao BLOB, ' +
    'ativo INTEGER NOT NULL DEFAULT 1, ' +
    'data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'CONSTRAINT chaves_unicas UNIQUE (contrato_id ASC, produto_id ASC, titulo ASC, chave ASC) ON CONFLICT REPLACE' +
    ')';

  // SQL para criar tabela no FireBird
  // IMPORTANTE: FireBird precisa de GENERATOR e TRIGGER para auto-increment
  // FireBird: comandos separados (não pode executar múltiplos DDL em uma única execução)
  // config_id é BIGINT NOT NULL PRIMARY KEY, o auto-incremento é feito pelo TRIGGER
  SQL_CREATE_TABLE_FIREBIRD =
    'CREATE TABLE %s (' +
    'config_id BIGINT NOT NULL PRIMARY KEY, ' +
    'contrato_id INTEGER NOT NULL DEFAULT 1, ' +
    'produto_id INTEGER NOT NULL DEFAULT 1, ' +
    'ordem INTEGER NOT NULL DEFAULT 0, ' +
    'titulo VARCHAR(255) NOT NULL, ' +
    'chave VARCHAR(255) NOT NULL, ' +
    'valor BLOB SUB_TYPE BINARY, ' +
    'descricao BLOB SUB_TYPE TEXT, ' +
    'ativo SMALLINT NOT NULL DEFAULT 1, ' +
    'data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'data_alteracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'CONSTRAINT chaves_unicas UNIQUE (contrato_id, produto_id, titulo, chave)' +
    ')';

  // IMPORTANTE: Firebird armazena nomes de generators e triggers em UPPERCASE
  // Mas ao criar, podemos usar minúsculas se usar aspas duplas, ou maiúsculas sem aspas
  // Para consistência, vamos usar maiúsculas sem aspas (padrão Firebird)
  SQL_CREATE_GENERATOR_FIREBIRD = 'CREATE GENERATOR GEN_%s_CONFIG_ID';

  SQL_CREATE_TRIGGER_FIREBIRD =
    'CREATE TRIGGER TRG_%s_CONFIG_ID FOR %s ' +
    'ACTIVE BEFORE INSERT POSITION 0 AS ' +
    'BEGIN ' +
    '  IF (NEW.config_id IS NULL) THEN ' +
    '    NEW.config_id = GEN_ID(GEN_%s_CONFIG_ID, 1); ' +
    'END';

  // SQL para criar tabela no Access
  // IMPORTANTE: Access via ODBC tem sintaxe específica e restritiva
  // - COUNTER para auto-incremento (não AUTOINCREMENT, não IDENTITY)
  // - COUNTER já é PRIMARY KEY automaticamente, mas pode ser explícito
  // - VARCHAR(255) para texto limitado (não TEXT)
  // - YESNO para boolean (não BIT no CREATE TABLE via ODBC)
  // - DATETIME sem DEFAULT (ODBC não suporta funções no DEFAULT)
  // - DEFAULT só funciona com valores literais simples
  // - OLE Object para BLOB (não VARBINARY)
  // - CONSTRAINT UNIQUE será criada separadamente via índice
  SQL_CREATE_TABLE_ACCESS =
    'CREATE TABLE %s (' +
    'config_id COUNTER NOT NULL PRIMARY KEY, ' +
    'contrato_id INTEGER NOT NULL DEFAULT 1, ' +
    'produto_id INTEGER NOT NULL DEFAULT 1, ' +
    'ordem INTEGER NOT NULL DEFAULT 0, ' +
    'titulo VARCHAR(255) NOT NULL, ' +
    'chave VARCHAR(255) NOT NULL, ' +
    'valor OLE Object, ' +
    'descricao MEMO, ' +
    'ativo YESNO NOT NULL DEFAULT -1, ' +
    'data_cadastro DATETIME, ' +
    'data_alteracao DATETIME' +
    ')';

  // SQL para criar índice UNIQUE composto (deve ser executado separadamente após CREATE TABLE)
  // Índice composto permite chaves duplicadas em títulos diferentes
  // A unicidade é garantida pela combinação: chave + titulo + contrato_id + produto_id
  SQL_CREATE_INDEX_POSTGRESQL = 'CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_chave_titulo ON %s (chave, titulo, contrato_id, produto_id)';
  SQL_CREATE_INDEX_MYSQL = 'CREATE UNIQUE INDEX idx_%s_chave_titulo ON %s (chave, titulo, contrato_id, produto_id)';
  SQL_CREATE_INDEX_SQLSERVER = 'CREATE UNIQUE INDEX idx_%s_chave_titulo ON %s (chave, titulo, contrato_id, produto_id)';
  SQL_CREATE_INDEX_SQLITE = 'CREATE UNIQUE INDEX IF NOT EXISTS idx_%s_chave_titulo ON %s (chave ASC, titulo ASC, contrato_id ASC, produto_id ASC)';
  SQL_CREATE_INDEX_FIREBIRD = 'CREATE UNIQUE INDEX idx_%s_chave_titulo ON %s (chave, titulo, contrato_id, produto_id)';
  SQL_CREATE_INDEX_ACCESS = 'CREATE UNIQUE INDEX idx_%s_chave_titulo ON %s (chave, titulo, contrato_id, produto_id)';

  { =============================================================================
    SQL QUERIES PADRÃO
    ============================================================================= }

  // Query para buscar parâmetro por nome
  SQL_SELECT_PARAMETER = 'SELECT name, value, value_type, description, created_at, updated_at FROM %s WHERE name = ''%s''';

  // Query para buscar todos os parâmetros
  SQL_SELECT_ALL_PARAMETERS = 'SELECT name, value, value_type, description, created_at, updated_at FROM %s ORDER BY name';

  // Query para inserir parâmetro
  SQL_INSERT_PARAMETER = 'INSERT INTO %s (name, value, value_type, description, created_at, updated_at) VALUES (''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';

  // Query para atualizar parâmetro
  SQL_UPDATE_PARAMETER = 'UPDATE %s SET value = ''%s'', value_type = ''%s'', description = ''%s'', updated_at = ''%s'' WHERE name = ''%s''';

  // Query para deletar parâmetro
  SQL_DELETE_PARAMETER = 'DELETE FROM %s WHERE name = ''%s''';

  // Query para verificar se parâmetro existe
  SQL_EXISTS_PARAMETER = 'SELECT COUNT(*) FROM %s WHERE name = ''%s''';

  { =============================================================================
    MAPEAMENTO DE TIPOS SQL DE BOOLEAN POR BANCO DE DADOS
    ============================================================================= }

  // Retorna o tipo SQL correto para campo boolean conforme o banco de dados
  // Usado na criação de tabelas para garantir compatibilidade
  function GetBooleanSQLType(const ADatabaseType: TParameterDatabaseTypes): string;

  // Retorna o valor DEFAULT correto para campo boolean conforme o banco de dados
  // Usado na criação de tabelas para garantir compatibilidade
  function GetBooleanSQLDefault(const ADatabaseType: TParameterDatabaseTypes; const AValue: Boolean = True): string;

implementation

{ =============================================================================
  FUNÇÕES AUXILIARES - TIPOS SQL DE BOOLEAN
  ============================================================================= }

function GetBooleanSQLType(const ADatabaseType: TParameterDatabaseTypes): string;
begin
  // Retorna o tipo SQL correto para campo boolean conforme o banco de dados
  case ADatabaseType of
    pdtPostgreSQL:
      // PostgreSQL tem tipo BOOLEAN nativo
      Result := 'BOOLEAN';
    pdtMySQL:
      // MySQL/MariaDB tem tipo BOOLEAN (alias para TINYINT(1))
      Result := 'BOOLEAN';
    pdtSQLServer:
      // SQL Server usa BIT para boolean
      Result := 'BIT';
    pdtSQLite:
      // SQLite não tem tipo boolean nativo, usa INTEGER
      Result := 'INTEGER';
    pdtFireBird:
      // FireBird 2.5 não tem boolean nativo, usa SMALLINT
      // FireBird 3.0+ tem boolean, mas para compatibilidade usa SMALLINT
      Result := 'SMALLINT';
    pdtAccess:
      // Access via ODBC usa YESNO para boolean
      Result := 'YESNO';
    else
      // Para outros bancos ou tipo desconhecido, usa INTEGER (mais compatível)
      Result := 'INTEGER';
  end;
end;

function GetBooleanSQLDefault(const ADatabaseType: TParameterDatabaseTypes; const AValue: Boolean = True): string;
begin
  // Retorna o valor DEFAULT correto para campo boolean conforme o banco de dados
  case ADatabaseType of
    pdtPostgreSQL:
      // PostgreSQL aceita true/false diretamente
      Result := IfThen(AValue, 'true', 'false');
    pdtMySQL:
      // MySQL aceita true/false ou 1/0
      Result := IfThen(AValue, 'true', 'false');
    pdtSQLServer:
      // SQL Server usa 1 para true, 0 para false
      Result := IfThen(AValue, '1', '0');
    pdtSQLite:
      // SQLite usa 1 para true, 0 para false
      Result := IfThen(AValue, '1', '0');
    pdtFireBird:
      // FireBird usa 1 para true, 0 para false
      Result := IfThen(AValue, '1', '0');
    pdtAccess:
      // Access usa -1 para True, 0 para False
      Result := IfThen(AValue, '-1', '0');
    else
      // Para outros bancos ou tipo desconhecido, usa 1/0 (mais compatível)
      Result := IfThen(AValue, '1', '0');
  end;
end;

end.
