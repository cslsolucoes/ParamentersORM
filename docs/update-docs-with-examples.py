#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para adicionar exemplos a todos os métodos do docs-data.js
Execute: python update-docs-with-examples.py
"""

import re
import json

# Mapeamento de exemplos por nome de método do Parameters ORM
EXAMPLES_MAP = {
    # TParameters factory methods
    'New': 'var Parameters: IParameters; Parameters := TParameters.New;',
    'NewDatabase': 'var DB: IParametersDatabase; DB := TParameters.NewDatabase;',
    'NewInifiles': 'var Ini: IParametersInifiles; Ini := TParameters.NewInifiles;',
    'NewJsonObject': 'var Json: IParametersJsonObject; Json := TParameters.NewJsonObject;',
    # IParametersDatabase methods
    'Connect': 'DB.Connect; // ou DB.Connect(LSuccess);',
    'Get': 'var Param: TParameter; Param := DB.Get(\'chave\');',
    'Getter': 'var Param: TParameter; Param := DB.Getter(\'chave\'); // Busca com hierarquia quando configurada',
    'List': 'var List: TParameterList; List := DB.List;',
    'Insert': 'DB.Insert(Param);',
    'Update': 'DB.Update(Param);',
    'Setter': 'DB.Setter(Param); // Insere se não existir, atualiza se existir (requer hierarquia completa)',
    'Delete': 'DB.Delete(\'chave\');',
    'Exists': 'if DB.Exists(\'chave\') then ...',
    'Count': 'var Count: Integer; Count := DB.Count;',
    'TableName': 'DB.TableName(\'config\');',
    'Schema': 'DB.Schema(\'public\');',
    'Host': 'DB.Host(\'localhost\');',
    'Port': 'DB.Port(5432);',
    'Database': 'DB.Database(\'mydb\');',
    'Username': 'DB.Username(\'user\');',
    'Password': 'DB.Password(\'pass\');',
    'ContratoID': 'DB.ContratoID(1);',
    'ProdutoID': 'DB.ProdutoID(1);',
    'Title': 'DB.Title(\'ERP\').Get(\'host\');',
    'CreateTable': 'DB.CreateTable; // ou DB.CreateTable(LSuccess);',
    'DropTable': 'DB.DropTable; // ou DB.DropTable(LSuccess);',
    'MigrateTable': 'DB.MigrateTable; // ou DB.MigrateTable(LSuccess);',
    'TableExists': 'if DB.TableExists then ...',
    'IsConnected': 'if DB.IsConnected then ...',
    'Disconnect': 'DB.Disconnect;',
    'Refresh': 'DB.Refresh;',
    # IParametersInifiles methods
    'FilePath': 'Ini.FilePath(\'C:\\config.ini\');',
    'Section': 'Ini.Section(\'Parameters\');',
    # IParametersJsonObject methods
    'JsonObject': 'Json.JsonObject(MyJsonObject);',
    'ObjectName': 'Json.ObjectName(\'Parameters\');',
    
    # Parameters.Consts functions
    'GetBooleanSQLType': 'var SQLType: string; SQLType := GetBooleanSQLType(pdtPostgreSQL); // Retorna \'BOOLEAN\'',
    'GetBooleanSQLDefault': 'var Default: string; Default := GetBooleanSQLDefault(pdtPostgreSQL, True); // Retorna \'true\'',
    
    # IParametersDatabase - Métodos adicionais
    'AutoCreateTable': 'DB.AutoCreateTable(True); // Auto-criar tabela se não existir',
    'Query': 'DB.Query(MyQuery); // Define query para SELECT',
    'ExecQuery': 'DB.ExecQuery(MyExecQuery); // Define query para INSERT/UPDATE/DELETE',
    'ListAvailableDatabases': 'var DBs: TStringList; DBs := DB.ListAvailableDatabases;',
    'ListAvailableTables': 'var Tables: TStringList; Tables := DB.ListAvailableTables;',
    'CreateAccessDatabase': 'DB.CreateAccessDatabase(\'C:\\Data\\config.mdb\');',
    'IndexExists': 'if DB.IndexExists(\'idx_config_chave\') then ...',
    'GetDropIndexSQL': 'var SQL: string; SQL := DB.GetDropIndexSQL(\'idx_config_chave\', pdtPostgreSQL, \'config\');',
    'EscapeSQL': 'var Escaped: string; Escaped := DB.EscapeSQL(\'O\'Brien\'); // Retorna \'O\'\'Brien\'',
    'BooleanToSQL': 'var SQLValue: string; SQLValue := DB.BooleanToSQL(True); // Retorna \'1\' ou \'true\' conforme banco',
    'BooleanToSQLCondition': 'var Condition: string; Condition := DB.BooleanToSQLCondition(True); // Retorna condição WHERE',
    'BooleanFromDataSet': 'var Value: Boolean; Value := DB.BooleanFromDataSet(DataSet, \'ativo\');',
    'ValueTypeToString': 'var TypeStr: string; TypeStr := DB.ValueTypeToString(pvtString);',
    'StringToValueType': 'var ValueType: TParameterValueType; ValueType := DB.StringToValueType(\'String\');',
    'DataSetToParameter': 'var Param: TParameter; Param := DB.DataSetToParameter(DataSet);',
    'ExecuteSQL': 'if DB.ExecuteSQL(\'UPDATE config SET valor = \'teste\'\') then ...',
    'QuerySQL': 'var DataSet: TDataSet; DataSet := DB.QuerySQL(\'SELECT * FROM config\');',
    'GetNextOrder': 'var NextOrder: Integer; NextOrder := DB.GetNextOrder(\'ERP\', 1, 1);',
    'TituloExistsForContratoProduto': 'if DB.TituloExistsForContratoProduto(\'ERP\', 1, 1) then ...',
    'ExistsWithTitulo': 'if DB.ExistsWithTitulo(\'host\', \'ERP\', 1, 1) then ...',
    
    # IParametersInifiles - Métodos adicionais
    'AutoCreateFile': 'Ini.AutoCreateFile(True); // Auto-criar arquivo se não existir',
    'FileExists': 'if Ini.FileExists then ...',
    'ImportFromDatabase': 'Ini.ImportFromDatabase(DB, LSuccess); // Importa de Database',
    'ExportToDatabase': 'Ini.ExportToDatabase(DB, LSuccess); // Exporta para Database',
    'GetSectionName': 'var Section: string; Section := Ini.GetSectionName(\'ERP\', 1, 1);',
    'GetTituloFromSection': 'var Titulo: string; Titulo := Ini.GetTituloFromSection(\'[ERP_1_1]\');',
    'ParseComment': 'var Comment: string; Comment := Ini.ParseComment(\'; Comentário\');',
    'ParseKey': 'var Key: string; Key := Ini.ParseKey(\'host=localhost\');',
    'ParseValue': 'var Value: string; Value := Ini.ParseValue(\'host=localhost\');',
    'FormatIniLine': 'var Line: string; Line := Ini.FormatIniLine(\'host\', \'localhost\', \'Host do servidor\');',
    'ReadParameterFromIni': 'var Param: TParameter; Param := Ini.ReadParameterFromIni(\'host\', \'ERP\');',
    'WriteParameterToIni': 'Ini.WriteParameterToIni(Param);',
    'WriteIniFileLines': 'Ini.WriteIniFileLines(Lines);',
    'FindSectionInLines': 'var Index: Integer; Index := Ini.FindSectionInLines(Lines, \'ERP\');',
    'FindKeyInSection': 'var Index: Integer; Index := Ini.FindKeyInSection(Lines, 0, \'host\');',
    'RemoveEmptySection': 'Ini.RemoveEmptySection(Lines, \'ERP\');',
    'ExistsInSection': 'if Ini.ExistsInSection(\'host\', \'ERP\') then ...',
    'GetKeysCountInSection': 'var Count: Integer; Count := Ini.GetKeysCountInSection(\'ERP\');',
    
    # IParametersJsonObject - Métodos adicionais
    'AutoCreateFile': 'Json.AutoCreateFile(True); // Auto-criar arquivo se não existir',
    'FileExists': 'if Json.FileExists then ...',
    'SaveToFile': 'Json.SaveToFile(\'C:\\config.json\'); // ou Json.SaveToFile(\'C:\\config.json\', LSuccess);',
    'LoadFromString': 'Json.LoadFromString(\'{"ERP":{"host":"localhost"}}\');',
    'LoadFromFile': 'Json.LoadFromFile(\'C:\\config.json\'); // ou Json.LoadFromFile(\'C:\\config.json\', LSuccess);',
    'ImportFromDatabase': 'Json.ImportFromDatabase(DB, LSuccess); // Importa de Database',
    'ExportToDatabase': 'Json.ExportToDatabase(DB, LSuccess); // Exporta para Database',
    'ImportFromInifiles': 'Json.ImportFromInifiles(Ini, LSuccess); // Importa de INI',
    'ExportToInifiles': 'Json.ExportToInifiles(Ini, LSuccess); // Exporta para INI',
    'GetObjectName': 'var ObjName: string; ObjName := Json.GetObjectName(\'ERP\', 1, 1);',
    'GetTituloFromObjectName': 'var Titulo: string; Titulo := Json.GetTituloFromObjectName(\'ERP_1_1\');',
    'ExistsInObject': 'if Json.ExistsInObject(\'host\', \'ERP\') then ...',
    'ReadParameterFromJson': 'var Param: TParameter; Param := Json.ReadParameterFromJson(\'host\', \'ERP\');',
    'WriteParameterToJson': 'Json.WriteParameterToJson(Param);',
    
    # IParameters - Métodos de convergência
    'NewJsonObjectFromFile': 'var Json: IParametersJsonObject; Json := TParameters.NewJsonObjectFromFile(\'C:\\config.json\');',
    'Source': 'Parameters.Source(psDatabase); // Define fonte ativa',
    'AddSource': 'Parameters.AddSource(psInifiles); // Adiciona fonte à lista',
    'RemoveSource': 'Parameters.RemoveSource(psJsonObject); // Remove fonte da lista',
    'HasSource': 'if Parameters.HasSource(psDatabase) then ...',
    'Priority': 'Parameters.Priority([psDatabase, psInifiles, psJsonObject]); // Define ordem de prioridade',
    'TryGetFromSource': 'var Param: TParameter; if Parameters.TryGetFromSource(\'host\', psDatabase, Param) then ...',
    'IsSourceAvailable': 'if Parameters.IsSourceAvailable(psDatabase) then ...',
    'Getter': 'var Param: TParameter; Param := Parameters.Getter(\'chave\'); // Busca em cascata (Database → INI → JSON)',
    'Setter': 'Parameters.Setter(Param); // Insere se não existir, atualiza se existir (requer hierarquia completa)',
    
    # Parameters.Database - Métodos privados/internos
    'AdjustOrdersForInsert': '// Método interno: ajusta ordem dos parâmetros ao inserir',
    'AdjustOrdersForUpdate': '// Método interno: ajusta ordem dos parâmetros ao atualizar',
    'StringToDatabaseType': 'var DBType: TParameterDatabaseTypes; DBType := StringToDatabaseType(\'PostgreSQL\');',
    'GetDatabaseTypeForEngine': 'var DBType: TParameterDatabaseTypes; DBType := GetDatabaseTypeForEngine(pteUnidac, \'PostgreSQL\');',
    'GetConnectionProperty': 'var Value: string; Value := GetConnectionProperty(Connection, \'Database\');',
    'SetConnectionProperty': 'SetConnectionProperty(Connection, \'Database\', \'mydb\');',
    'CreateProviderForDatabaseType': '// Método interno: cria provider para tipo de banco',
    'ConfigureZeosLibraryLocation': '// Método interno: configura localização das DLLs do Zeos',
    
    # Parameters.Inifiles - Métodos privados/internos
    'GetInsertPositionByOrder': 'var Pos: Integer; Pos := GetInsertPositionByOrder(Lines, \'ERP\', 5);',
    'WriteContratoSection': '// Método interno: escreve seção de contrato no INI',
    'ReadContratoSection': '// Método interno: lê seção de contrato do INI',
    
    # Parameters.JsonObject - Métodos privados/internos
    'GetKeysInObject': 'var Keys: TStringList; Keys := GetKeysInObject(JsonObject, \'ERP\');',
    'GetKeysCountInObject': 'var Count: Integer; Count := GetKeysCountInObject(JsonObject, \'ERP\');',
    'WriteContratoObject': '// Método interno: escreve objeto de contrato no JSON',
    'ReadContratoObject': '// Método interno: lê objeto de contrato do JSON',
    'ParameterToJsonValue': 'var JsonValue: TJSONValue; JsonValue := ParameterToJsonValue(Param);',
    'JsonValueToParameter': 'var Param: TParameter; Param := JsonValueToParameter(JsonValue, \'host\');',
    'FormatJSONString': 'var Formatted: string; Formatted := FormatJSONString(JsonString);',
    'GetValueCaseInsensitive': 'var Value: string; Value := GetValueCaseInsensitive(JsonObject, \'HOST\');',
    'GetJsonValue': 'var JsonValue: TJSONValue; JsonValue := GetJsonValue(JsonObject, \'host\');',
    'AddJsonPair': 'AddJsonPair(JsonObject, \'host\', \'localhost\'); // Adiciona par chave-valor',
    'RemoveJsonPair': 'RemoveJsonPair(JsonObject, \'host\'); // Remove par chave-valor',
    
    # Parameters.Exceptions functions - Criação de Exceções
    'CreateConnectionException': 'raise CreateConnectionException(MSG_CONNECTION_FAILED, ERR_CONNECTION_FAILED, \'Connect\');',
    'CreateSQLException': 'raise CreateSQLException(Format(MSG_SQL_EXECUTION_FAILED, [SQL]), ERR_SQL_EXECUTION_FAILED, \'ExecuteSQL\');',
    'CreateValidationException': 'raise CreateValidationException(MSG_PARAMETER_NAME_EMPTY, ERR_PARAMETER_NAME_EMPTY, \'Insert\');',
    'CreateNotFoundException': 'raise CreateNotFoundException(Format(MSG_PARAMETER_NOT_FOUND, [AName, FTableName]), ERR_PARAMETER_NOT_FOUND, \'Get\');',
    'CreateConfigurationException': 'raise CreateConfigurationException(MSG_ENGINE_NOT_DEFINED, ERR_ENGINE_NOT_DEFINED, \'Connect\');',
    'CreateFileException': 'raise CreateFileException(Format(MSG_FILE_NOT_FOUND, [AFilePath]), ERR_FILE_NOT_FOUND, \'LoadFromFile\');',
    'CreateInifilesException': 'raise CreateInifilesException(Format(MSG_INI_FILE_NOT_FOUND, [FFilePath]), ERR_INI_FILE_NOT_FOUND, \'Get\');',
    'CreateJsonObjectException': 'raise CreateJsonObjectException(Format(MSG_JSON_INVALID_FORMAT, [AJsonString]), ERR_JSON_INVALID_FORMAT, \'LoadFromString\');',
    
    # Parameters.Exceptions functions - Conversão de Exceções
    'ConvertToParametersException': 'try ... except on E: Exception do raise ConvertToParametersException(E, \'Operacao\'); end;',
    'IsParametersException': 'if IsParametersException(E) then ShowMessage(\'Exceção do Parameters\');',
    'GetExceptionErrorCode': 'var Code: Integer; Code := GetExceptionErrorCode(E); // Retorna código do erro ou 0',
    'GetExceptionOperation': 'var Op: string; Op := GetExceptionOperation(E); // Retorna nome da operação ou string vazia',
    # IField methods (legacy - manter para compatibilidade)
    'GetTable': 'var tableName := Field.GetTable; // Retorna nome da tabela',
    'GetColumn': 'var columnName := Field.GetColumn; // Retorna nome da coluna',
    'GetColumnType': 'var columnType := Field.GetColumnType; // Retorna tipo de dado',
    'GetColumnTypeCode': 'var code := Field.GetColumnTypeCode; // Retorna código do tipo',
    'GetIsNull': 'var isNull := Field.GetIsNull; // Retorna "YES" ou "NO"',
    'GetIsNullBool': 'var isNull := Field.GetIsNullBool; // Retorna True ou False',
    'GetValue': 'var value := Field.GetValue; // Retorna valor atual do campo',
    'GetToDefault': 'var defaultValue := Field.GetToDefault; // Retorna valor padrão',
    'GetIsChanged': 'var changed := Field.GetIsChanged; // Retorna 0 ou 1',
    'GetIsPKey': 'var isPKey := Field.GetIsPKey; // Retorna 0 ou 1',
    'GetPosition': 'var position := Field.GetPosition; // Retorna posição do campo',
    'GetConstraintName': 'var constraint := Field.GetConstraintName; // Retorna nome da constraint',
    'GetFielsJson': 'var json := Field.GetFielsJson; // Retorna objeto JSON',
    'SetTable': "Field.SetTable('usuarios'); // Define nome da tabela",
    'SetColumn': "Field.SetColumn('id'); // Define nome da coluna",
    'SetColumnType': "Field.SetColumnType('INTEGER'); // Define tipo de dado",
    'SetColumnTypeCode': 'Field.SetColumnTypeCode(3); // Define código do tipo',
    'SetIsNull': "Field.SetIsNull('NO'); // Define flag nullable",
    'SetIsNullBool': 'Field.SetIsNullBool(False); // Define flag nullable como Boolean',
    'SetValue': "Field.SetValue('João'); // Define valor do campo",
    'SetToDefault': "Field.SetToDefault('0'); // Define valor padrão",
    'SetIsChanged': 'Field.SetIsChanged(1); // Define flag de alteração',
    'SetIsPKey': 'Field.SetIsPKey(1); // Define flag de Primary Key',
    'SetPosition': 'Field.SetPosition(1); // Define posição do campo',
    'SetConstraintName': "Field.SetConstraintName('pk_usuarios'); // Define nome da constraint",
    'LoadFromJSONObject': 'Field.LoadFromJSONObject(JsonObject); // Carrega de JSON',
    'SetAsChanged': 'Field.SetAsChanged; // Marca como alterado',
    'SetAsUnchanged': 'Field.SetAsUnchanged; // Marca como não alterado',
    'IsFieldChanged': 'if Field.IsFieldChanged then ... // Verifica se foi alterado',
    'IsFieldPrimaryKey': 'if Field.IsFieldPrimaryKey then ... // Verifica se é Primary Key',
    'FieldAllowsNull': 'if Field.FieldAllowsNull then ... // Verifica se permite NULL',
    'SetColumnValue': "Field.SetColumnValue('João').MarkChanged; // Define valor e marca como alterado",
    'SetColumnValueWithoutChange': "Field.SetColumnValueWithoutChange('João'); // Define valor sem marcar como alterado",
    'MarkChanged': 'Field.MarkChanged; // Marca como alterado',
    'MarkUnchanged': 'Field.MarkUnchanged; // Marca como não alterado',
    'Clone': 'var FieldCopy: IField := Field.Clone; // Cria cópia independente',
    
    # IFields methods
    'DatabaseTypes': 'Fields.DatabaseTypes(dtPostgreSQL); // Define tipo de banco',
    'Fields': "var Field: IField := Fields.Fields('id'); // Obtém campo pelo nome",
    'GetPrimaryKey': 'var pks := Fields.GetPrimaryKey; // Retorna array com Primary Keys',
    'GetFields': "var Field: IField := Fields.GetFields('id'); // Obtém campo (nil se não existir)",
    'GetFieldsByIndex': 'var Field: IField := Fields.GetFieldsByIndex(0); // Obtém campo por índice',
    'GetFieldsList': 'var list := Fields.GetFieldsList; // Retorna lista de campos',
    'FieldsCount': 'var count := Fields.FieldsCount; // Retorna número de campos',
    'FieldExist': "if Fields.FieldExist('id') then ... // Verifica se campo existe",
    'Remove': "Fields.Remove('id'); // Remove campo",
    'Clear': 'Fields.Clear; // Remove todos os campos',
    'HasChanges': 'if Fields.HasChanges then ... // Verifica se há alterações',
    'ClearAllChanges': 'Fields.ClearAllChanges; // Limpa todas as alterações',
    'GetAllChangedFieldNames': 'var changed := Fields.GetAllChangedFieldNames; // Retorna campos alterados',
    'ToJSON': 'var json := Fields.ToJSON; // Serializa para JSON',
    'FromJSON': "Fields.FromJSON('{\"fields\":[...]}'); // Deserializa de JSON",
    'Add': 'Fields.Add(Field); // Adiciona campo à lista',
    
    # ITable methods
    'TableName': "Table.TableName('usuarios'); // Define nome da tabela",
    'Alias': "Table.Alias('u'); // Define alias da tabela",
    'GenerateInsertSQL': "var sql := Table.GenerateInsertSQL; // Gera SQL INSERT completo",
    'GenerateInsertSQLOptimized': "var sql := Table.GenerateInsertSQLOptimized; // Gera SQL INSERT apenas com campos alterados",
    'GenerateUpdateSQL': "var sql := Table.GenerateUpdateSQL; // Gera SQL UPDATE completo",
    'GenerateUpdateSQLOptimized': "var sql := Table.GenerateUpdateSQLOptimized; // Gera SQL UPDATE apenas com campos alterados",
    'GenerateWhereByPrimaryKey': "var where := Table.GenerateWhereByPrimaryKey; // Gera cláusula WHERE",
    'ValidateNotNullFields': 'Table.ValidateNotNullFields; // Valida campos obrigatórios',
    'GetChangedFieldNames': 'var changed := Table.GetChangedFieldNames; // Retorna campos alterados',
    'LoadFieldsFromDB': 'Table.LoadFieldsFromDB(DataSet); // Carrega campos do DataSet',
    'LoadValuesFromDataSet': 'Table.LoadValuesFromDataSet(DataSet); // Carrega valores do DataSet',
    'ApplyValuesToDataSet': 'Table.ApplyValuesToDataSet(DataSet); // Aplica valores ao DataSet',
    'AuditFields': 'Table.AuditFields(True); // Habilita auditoria',
    'FieldDateCreated': "Table.FieldDateCreated('data_cadastro'); // Define campo de data de criação",
    'FieldDateUpdated': "Table.FieldDateUpdated('data_alteracao'); // Define campo de data de atualização",
    'FieldIsDeleted': "Table.FieldIsDeleted('is_deleted'); // Define campo de soft delete",
    'FieldIsActive': "Table.FieldIsActive('is_active'); // Define campo de ativação",
    'ExcludeFields': "Table.ExcludeFields('id,created_at'); // Exclui campos do SQL",
    'EndTable': 'var parent := Table.EndTable; // Retorna ao container pai',
    
    # ITables methods
    'Connection': 'Tables.Connection(MyConnection).LoadFromConnection; // Define conexão e carrega',
    'ExtractConnectionInfo': 'var info := Tables.ExtractConnectionInfo; // Extrai informações da conexão',
    'DetectEngine': 'var engine := Tables.DetectEngine; // Detecta engine',
    'DetectDatabaseType': 'var dbType := Tables.DetectDatabaseType; // Detecta tipo de banco',
    'GetConnectionDatabase': 'var dbName := Tables.GetConnectionDatabase; // Obtém nome do database',
    'GetConnectionSchema': "var schema := Tables.GetConnectionSchema('public'); // Obtém schema",
    'LoadFromConnection': 'Tables.Connection(MyConnection).LoadFromConnection; // Carrega estrutura completa',
    'LoadTables': 'Tables.LoadTables; // Carrega apenas nomes das tabelas',
    'LoadTableFields': "Tables.LoadTableFields('usuarios'); // Carrega campos de uma tabela",
    'LoadAllFields': 'Tables.LoadAllFields; // Carrega campos de todas as tabelas',
    'Refresh': 'Tables.Refresh; // Recarrega estrutura',
    'Table': "var Table: ITable := Tables.Table('usuarios'); // Obtém tabela",
    'GetTable': "var Table: ITable := Tables.GetTable('usuarios'); // Obtém tabela (nil se não existir)",
    'GetTableByIndex': 'var Table: ITable := Tables.GetTableByIndex(0); // Obtém tabela por índice',
    'GetTablesList': 'var list := Tables.GetTablesList; // Retorna lista de tabelas',
    'TablesCount': 'var count := Tables.TablesCount; // Retorna número de tabelas',
    'TableExists': "if Tables.TableExists('usuarios') then ... // Verifica se tabela existe",
    'GetTablesNames': 'var names := Tables.GetTablesNames; // Retorna array com nomes das tabelas',
    'GetSchemasList': 'var schemas := Tables.GetSchemasList; // Retorna array com schemas',
    'GetDatabasesList': 'var databases := Tables.GetDatabasesList; // Retorna array com databases',
    'ClearAllChanges': 'Tables.ClearAllChanges; // Limpa todas as alterações',
    'GetAllChangedFieldNames': 'var changed := Tables.GetAllChangedFieldNames; // Retorna campos alterados',
    'ValidateAllTables': 'Tables.ValidateAllTables; // Valida todas as tabelas',
    'RemoveTable': "Tables.RemoveTable('usuarios'); // Remove tabela",
    'GetSQLTables': 'var sql := Tables.GetSQLTables; // Retorna SQL para listar tabelas',
    'GetSQLFields': "var sql := Tables.GetSQLFields('usuarios'); // Retorna SQL para listar campos",
    
    # IConnection methods
    'Engine': 'Connection.Engine(teFireDAC); // Define engine',
    'DatabaseType': 'Connection.DatabaseType(dtPostgreSQL); // Define tipo de banco',
    'Host': "Connection.Host('localhost'); // Define host",
    'Port': 'Connection.Port(5432); // Define porta',
    'Username': "Connection.Username('postgres'); // Define usuário",
    'Password': "Connection.Password('mypass'); // Define senha",
    'ConnectionString': "Connection.ConnectionString('Host=localhost;...'); // Define connection string",
    'FromIniFile': "Connection.FromIniFile('config.ini', 'database').Connect; // Carrega de INI e conecta",
    'FromJsonFile': "Connection.FromJsonFile('config.json', 'database').Connect; // Carrega de JSON e conecta",
    'FromDatabase': "Connection.FromDatabase('config.db', 'config').Connect; // Carrega de Database e conecta",
    'FromParameters': "Connection.FromParameters('database', psInifiles).Connect; // Carrega de Parameters e conecta",
    'Connect': 'Connection.Connect; // Conecta ao banco',
    'Disconnect': 'Connection.Disconnect; // Desconecta do banco',
    'IsConnected': 'if Connection.IsConnected then ... // Verifica se está conectado',
    'Ping': 'if Connection.Ping then ... // Testa conexão',
    'Reconnect': 'Connection.Reconnect; // Reconecta',
    'BeginTransaction': 'Connection.BeginTransaction; // Inicia transação',
    'Commit': 'Connection.Commit; // Confirma transação',
    'Rollback': 'Connection.Rollback; // Reverte transação',
    'InTransaction': 'if Connection.InTransaction then ... // Verifica se está em transação',
    'ExecuteQuery': "var DataSet := Connection.ExecuteQuery('SELECT * FROM usuarios'); // Executa query",
    'ExecuteCommand': "var rows := Connection.ExecuteCommand('INSERT INTO ...'); // Executa comando",
    'ExecuteScalar': "var count := Connection.ExecuteScalar('SELECT COUNT(*) FROM usuarios'); // Executa e retorna valor único",
    'NativeConnection': 'var nativeConn := Connection.NativeConnection; // Retorna conexão nativa',
    'NativeEngine': 'var engine := Connection.NativeEngine; // Retorna engine nativo',
    'GetConnectionInfo': 'var info := Connection.GetConnectionInfo; // Retorna informações da conexão',
    'GetServerVersion': 'var version := Connection.GetServerVersion; // Retorna versão do servidor',
    'GetClientVersion': 'var version := Connection.GetClientVersion; // Retorna versão do cliente',
    'LoadTablesStructure': 'var Tables: ITables := Connection.LoadTablesStructure; // Carrega estrutura completa',
    'LoadTableStructure': "var Table: ITable := Connection.LoadTableStructure('usuarios'); // Carrega estrutura de uma tabela",
    'UsePool': 'Connection.UsePool(True).PoolSize(10); // Ativa pool',
    'PoolSize': 'Connection.PoolSize(10); // Define tamanho do pool',
    'GetFromPool': 'var conn := Connection.GetFromPool; // Obtém conexão do pool',
    'ReturnToPool': 'Connection.ReturnToPool; // Retorna conexão ao pool',
    
    # IAttributeParser methods
    'ParseClass': 'var Table: ITable := Parser.ParseClass(TUsuario); // Converte classe em ITable',
    'ParseClassToFields': 'var Fields: IFields := Parser.ParseClassToFields(TUsuario); // Converte classe em IFields',
    'GetTableName': "var tableName := Parser.GetTableName(TUsuario); // Obtém nome da tabela",
    'GetSchemaName': "var schemaName := Parser.GetSchemaName(TUsuario); // Obtém nome do schema",
    'GetPrimaryKeyFields': 'var pks := Parser.GetPrimaryKeyFields(TUsuario); // Obtém campos Primary Key',
    'GetFieldNames': 'var fields := Parser.GetFieldNames(TUsuario); // Obtém nomes dos campos',
    'ValidateClass': 'if Parser.ValidateClass(TUsuario) then ... // Valida classe',
    
    # IAttributeMapper methods
    'MapClassToTable': 'var Table: ITable := Mapper.MapClassToTable(TUsuario); // Converte classe em ITable',
    'MapTableToClass': 'Mapper.MapTableToClass(Table, UsuarioInstance); // Preenche instância com dados da tabela',
    'SetFieldValue': "Mapper.SetFieldValue(UsuarioInstance, 'nome', 'João'); // Define valor de campo",
    'GetFieldValue': "var value := Mapper.GetFieldValue(UsuarioInstance, 'nome'); // Obtém valor de campo"
}

def extract_method_name(signature_line):
    """Extrai nome do método da linha de assinatura"""
    # A linha tem formato: "signature": "function Get(...): ...;",
    # Preciso extrair apenas a parte da assinatura
    if ':' in signature_line:
        # Pegar a parte após os dois pontos
        sig_part = signature_line.split(':', 1)[1].strip()
        # Remover aspas e vírgula final
        sig_part = sig_part.strip('"').strip(',').strip()
    else:
        sig_part = signature_line.strip().strip('"')
    
    # Agora extrair o nome do método da assinatura
    match = re.search(r'(?:function|procedure)\s+(\w+)', sig_part, re.IGNORECASE)
    if match:
        return match.group(1)
    
    # Fallback: tentar pegar primeiro identificador após function/procedure
    match = re.search(r'(function|procedure)\s+(\w+)', sig_part, re.IGNORECASE)
    if match:
        return match.group(2)
    
    return None

def extract_full_signature(signature_line):
    """Extrai a assinatura completa do método"""
    if ':' in signature_line:
        sig_part = signature_line.split(':', 1)[1].strip()
        sig_part = sig_part.strip('"').strip(',').strip()
    else:
        sig_part = signature_line.strip().strip('"')
    return sig_part

def generate_individualized_example(method_name, full_signature):
    """Gera exemplo individualizado baseado na assinatura completa do método"""
    # Se não tem exemplo base no map, retornar None
    if method_name not in EXAMPLES_MAP:
        return None
    
    base_example = EXAMPLES_MAP[method_name]
    
    # Extrair parâmetros da assinatura
    params_match = re.search(r'\(([^)]*)\)', full_signature)
    if not params_match:
        # Método sem parâmetros - usar exemplo base
        return base_example
    
    params_str = params_match.group(1).strip()
    if not params_str:
        # Método sem parâmetros - usar exemplo base
        return base_example
    
    # Dividir parâmetros (separados por ;)
    # Mas também considerar vírgulas se não houver ponto e vírgula
    if ';' in params_str:
        params = [p.strip() for p in params_str.split(';') if p.strip()]
    else:
        # Se não tem ;, pode ser separado por vírgula (caso raro)
        params = [p.strip() for p in params_str.split(',') if p.strip()]
    
    # Verificar se é função ou procedure
    is_function = 'function' in full_signature.lower()
    return_type = None
    if is_function:
        # Extrair tipo de retorno - buscar após o último ) e antes do ;
        # Formato: "function Get(...): TParameter;"
        # Primeiro encontrar o fechamento dos parâmetros
        params_end = full_signature.rfind(')')
        if params_end > 0:
            # Buscar : após o )
            return_part = full_signature[params_end:]
            return_match = re.search(r':\s*([^;]+)', return_part)
            if return_match:
                return_type = return_match.group(1).strip()
    
    # Se tem apenas 1 parâmetro e o exemplo base menciona overloads, limpar o exemplo base
    if len(params) == 1 and base_example and ('ou ' in base_example.lower() or ' or ' in base_example.lower()):
        # Remover referências a overloads
        if '//' in base_example:
            comment_part = base_example.split('//', 1)[1]
            if 'ou ' in comment_part.lower() or ' or ' in comment_part.lower():
                # Pegar apenas a primeira parte antes de "ou" ou "or"
                main_part = base_example.split('//', 1)[0].strip()
                comment = comment_part.split(' ou ')[0].split(' or ')[0].strip()
                base_example = f'{main_part} // {comment}'
    
    # Gerar exemplo específico baseado nos parâmetros
    example_lines = []
    
    # Se tem retorno, declarar variável
    if return_type:
        var_name = method_name.lower() + 'Result'
        example_lines.append(f'var {var_name}: {return_type};')
    
    # Gerar chamada do método com parâmetros específicos
    call_parts = []
    param_index = 0
    for param in params:
        # Extrair nome e tipo do parâmetro: "const AName: string" ou "out ASuccess: Boolean"
        param_type_match = re.search(r':\s*(\w+)', param)
        if not param_type_match:
            continue
            
        param_type = param_type_match.group(1).lower()
        param_name_match = re.search(r'(\w+)\s*:', param)
        param_name = param_name_match.group(1) if param_name_match else 'value'
        
        # Verificar se é parâmetro out/var
        is_out = 'out' in param.lower() or 'var' in param.lower()
        
        # Gerar valor de exemplo baseado no tipo e contexto
        if 'success' in param_name.lower() or 'result' in param_name.lower() or is_out:
            call_parts.append('LSuccess')
        elif 'source' in param_name.lower():
            call_parts.append('psDatabase')  # Segundo parâmetro com source
        elif 'tparametersource' in param_type.lower():
            call_parts.append('psDatabase')  # Tipo TParameterSource
        elif 'string' in param_type:
            # Diferentes valores para diferentes posições
            if param_index == 0:
                call_parts.append("'chave'")
            elif param_index == 1:
                call_parts.append("'valor'")
            else:
                call_parts.append("'parametro'")
        elif 'integer' in param_type or 'int' in param_type:
            call_parts.append(str(param_index + 1))
        elif 'boolean' in param_type or 'bool' in param_type:
            call_parts.append('True')
        elif 'double' in param_type or 'float' in param_type or 'currency' in param_type:
            call_parts.append('1.0')
        elif 'tparameter' in param_type.lower():
            call_parts.append('Param')
        elif 'tparameterlist' in param_type.lower():
            call_parts.append('List')
        elif 'iparametersdatabase' in param_type.lower():
            call_parts.append('DB')
        elif 'iparametersinifiles' in param_type.lower():
            call_parts.append('Ini')
        elif 'iparametersjsonobject' in param_type.lower():
            call_parts.append('Json')
        elif 'tparameterconfig' in param_type.lower():
            call_parts.append('[pcfDataBase]')
        else:
            call_parts.append('value')
        
        param_index += 1
    
    # Determinar objeto base (DB, Ini, Json, etc)
    obj_name = 'DB'
    if 'inifiles' in full_signature.lower() or 'ini' in full_signature.lower():
        obj_name = 'Ini'
    elif 'json' in full_signature.lower():
        obj_name = 'Json'
    elif 'parameters' in full_signature.lower() and 'database' not in full_signature.lower():
        obj_name = 'Parameters'
    
    # Formatar chamada do método com quebras de linha e indentação
    if len(call_parts) > 1:
        # Múltiplos parâmetros - formatar com quebras de linha e indentação
        method_call_parts = []
        method_call_parts.append(f"{obj_name}.{method_name}(")
        for i, part in enumerate(call_parts):
            if i < len(call_parts) - 1:
                method_call_parts.append(f"  {part},")
            else:
                method_call_parts.append(f"  {part}")
        method_call_parts.append(");")
        method_call = '\n'.join(method_call_parts)
    else:
        # Um parâmetro - manter em uma linha
        if len(call_parts) == 1:
            method_call = f"{obj_name}.{method_name}({call_parts[0]});"
        else:
            method_call = f"{obj_name}.{method_name}();"
    
    if return_type:
        # Sempre colocar atribuição em linha separada quando há retorno
        example_lines.append(f"{var_name} := {method_call}")
    else:
        example_lines.append(method_call)
    
    # Adicionar comentário específico baseado nos parâmetros
    comment = None
    if len(params) > 1:
        # Identificar tipo do segundo parâmetro para comentário mais específico
        if len(params) >= 2:
            second_param = params[1] if len(params) > 1 else ''
            if 'source' in second_param.lower() or 'tparametersource' in second_param.lower():
                comment = '// Versão com especificação de fonte'
            elif 'out' in second_param.lower() or 'var' in second_param.lower():
                comment = '// Versão com parâmetro de saída'
            else:
                comment = f'// Versão com {len(params)} parâmetro(s)'
    elif 'out' in params_str.lower() or 'var' in params_str.lower():
        comment = '// Versão com parâmetro de saída'
    elif len(params) == 1:
        # Método com apenas 1 parâmetro - comentário simples
        if '//' in base_example:
            comment_text = base_example.split('//', 1)[1].strip()
            # Remover referências a overloads no exemplo base
            if 'ou ' in comment_text.lower() or ' or ' in comment_text.lower():
                # Usar apenas a primeira parte do comentário ou comentário genérico
                comment_parts = comment_text.split(' ou ')
                if len(comment_parts) > 1:
                    comment_text = comment_parts[0].strip()
                else:
                    comment_parts = comment_text.split(' or ')
                    if len(comment_parts) > 1:
                        comment_text = comment_parts[0].strip()
            comment = f'// {comment_text}'
        else:
            comment = '// Versão simples'
    elif '//' in base_example:
        comment = f"// {base_example.split('//', 1)[1].strip()}"
    
    # Adicionar comentário à última linha
    if comment:
        # Se a última linha tem quebra de linha (múltiplos parâmetros), adicionar comentário na última linha
        if '\n' in example_lines[-1]:
            # Adicionar comentário após o fechamento do parêntese
            last_line = example_lines[-1]
            if last_line.rstrip().endswith(');'):
                # Substituir ); por ); // comentário
                example_lines[-1] = last_line.rstrip()[:-2] + f'); {comment}'
            else:
                example_lines[-1] = last_line.rstrip() + f' {comment}'
        else:
            example_lines[-1] = example_lines[-1] + f' {comment}'
    
    # Retornar exemplo formatado com quebras de linha
    return '\n'.join(example_lines)

def add_examples_to_methods(content):
    """Adiciona exemplos aos métodos que não têm"""
    lines = content.split('\n')
    result = []
    i = 0
    example_replacements = {}  # Dicionário para armazenar substituições de exemplos
    
    while i < len(lines):
        line = lines[i]
        
        # Verificar se esta linha será substituída
        if i in example_replacements:
            # Substituir pela nova linha
            indent = ' ' * (len(line) - len(line.lstrip()))
            new_example = example_replacements[i]
            example_escaped = new_example.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')
            result.append(f'{indent}"example": "{example_escaped}",')
            i += 1
            continue
        
        # Pular linhas de exemplo duplicadas (se a linha anterior já tinha example)
        if '"example":' in line and len(result) > 0:
            # Verificar se a linha anterior também era example
            prev_line = result[-1].strip() if result else ''
            if '"example":' in prev_line:
                # Pular esta linha (exemplo duplicado)
                i += 1
                continue
        
        result.append(line)
        
        # Verificar se é uma linha de comment (descrição do método)
        if '"comment":' in line:
            # Verificar se já tem example nas próximas linhas (até 10 linhas para garantir)
            has_example = False
            example_line_index = None
            # Verificar próxima linha imediatamente
            if i + 1 < len(lines):
                next_line = lines[i + 1]
                # Se a próxima linha é o fim do objeto (}, ou ]), não tem example - pode adicionar
                if '},' in next_line or ']' in next_line:
                    has_example = False  # Garantir que é False para adicionar exemplo
                else:
                    # Verificar se tem example nas próximas linhas
                    for j in range(i + 1, min(i + 11, len(lines))):
                        if '"example":' in lines[j]:
                            has_example = True
                            example_line_index = j
                            break
                        if '},' in lines[j] or ']' in lines[j]:
                            break
            
            # Buscar assinatura e nome do método para gerar exemplo individualizado
            method_name = None
            full_signature = None
            
            # Primeiro tentar pegar do campo "name" (mais confiável)
            for j in range(i - 1, max(0, i - 20), -1):
                if '"name":' in lines[j]:
                    name_line = lines[j]
                    name_match = re.search(r'"name":\s*"(\w+)"', name_line)
                    if name_match:
                        method_name = name_match.group(1)
                        break
            
            # Se não encontrou pelo name, tentar pela assinatura
            if not method_name:
                for j in range(i - 1, max(0, i - 20), -1):
                    if '"signature":' in lines[j]:
                        sig_line = lines[j]
                        method_name = extract_method_name(sig_line)
                        full_signature = extract_full_signature(sig_line)
                        if method_name:
                            break
            
            # Se ainda não encontrou, buscar assinatura
            if method_name and not full_signature:
                for j in range(i - 1, max(0, i - 20), -1):
                    if '"signature":' in lines[j]:
                        full_signature = extract_full_signature(lines[j])
                        break
            
            # Se tem example existente, verificar se precisa atualizar (para métodos com overloads)
            if has_example and example_line_index is not None and method_name and full_signature:
                # Gerar exemplo individualizado
                new_example = generate_individualized_example(method_name, full_signature)
                if new_example:
                    # Verificar se tem múltiplos parâmetros (overload)
                    params_match = re.search(r'\(([^)]*)\)', full_signature)
                    has_multiple_params = False
                    if params_match:
                        params_str = params_match.group(1).strip()
                        if params_str:
                            if ';' in params_str:
                                params = [p.strip() for p in params_str.split(';') if p.strip()]
                            else:
                                params = [p.strip() for p in params_str.split(',') if p.strip()]
                            has_multiple_params = len(params) > 1
                    
                    # Verificar se o exemplo atual menciona overloads (tem "ou" ou "or")
                    current_example_line = lines[example_line_index]
                    current_example_match = re.search(r'"example":\s*"([^"]*)"', current_example_line)
                    has_overload_reference = False
                    if current_example_match:
                        current_example = current_example_match.group(1)
                        has_overload_reference = ' ou ' in current_example.lower() or ' or ' in current_example.lower()
                    
                    # Se tem múltiplos parâmetros OU o exemplo atual menciona overloads, substituir
                    if has_multiple_params or has_overload_reference:
                        # Marcar para substituir quando chegar na linha do exemplo
                        example_replacements[example_line_index] = new_example
            
            # Se não tem example, adicionar (mesmo que a próxima linha seja o fim)
            if not has_example and method_name:
                # Gerar exemplo individualizado baseado na assinatura completa
                if full_signature:
                    example = generate_individualized_example(method_name, full_signature)
                else:
                    # Fallback: usar exemplo base se não conseguiu gerar individualizado
                    example = EXAMPLES_MAP.get(method_name)
                
                if example:
                    indent = ' ' * (len(line) - len(line.lstrip()))
                    # Escapar aspas e quebras de linha no exemplo
                    example_escaped = example.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')
                    # Adicionar vírgula se a linha comment não termina com vírgula
                    last_line = result[-1].rstrip()
                    if not last_line.endswith(','):
                        result[-1] = last_line + ','
                    # Adicionar exemplo ANTES do fim do objeto
                    result.append(f'{indent}"example": "{example_escaped}",')
        
        # Se estamos substituindo uma linha de exemplo
        if i in example_replacements:
            # Substituir pela nova linha
            indent = ' ' * (len(lines[i]) - len(lines[i].lstrip()))
            new_example = example_replacements[i]
            example_escaped = new_example.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')
            result.append(f'{indent}"example": "{example_escaped}",')
            i += 1
            continue
        
        i += 1
    
    return '\n'.join(result)

if __name__ == '__main__':
    import sys
    
    input_file = 'docs-data.js'
    output_file = 'docs-data.js'
    
    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    
    print(f'Lendo {input_file}...')
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    print('Adicionando exemplos aos métodos...')
    updated_content = add_examples_to_methods(content)
    
    print(f'Salvando em {output_file}...')
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    print('Exemplos adicionados com sucesso!')
