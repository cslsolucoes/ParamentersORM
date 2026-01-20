#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para adicionar exemplos a todos os métodos do docs-data.js
Execute: python update-docs-with-examples.py
"""

import re
import json

# Mapeamento de exemplos por nome de método
EXAMPLES_MAP = {
    # IField methods
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

def extract_method_name(signature):
    """Extrai nome do método da assinatura"""
    match = re.search(r'(?:function|procedure)\s+(\w+)', signature)
    return match.group(1) if match else None

def add_examples_to_methods(content):
    """Adiciona exemplos aos métodos que não têm"""
    lines = content.split('\n')
    result = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        result.append(line)
        
        # Verificar se é uma linha de comment sem example
        if '"comment":' in line and i + 1 < len(lines):
            next_line = lines[i + 1]
            # Se a próxima linha não tem "example", adicionar
            if 'example' not in next_line and '},' in next_line:
                method_name = None
                # Procurar assinatura nas linhas anteriores
                for j in range(max(0, i - 5), i):
                    if '"signature":' in lines[j]:
                        method_name = extract_method_name(lines[j])
                        break
                
                if method_name and method_name in EXAMPLES_MAP:
                    indent = ' ' * (len(line) - len(line.lstrip()))
                    result.append(f'{indent}"example": "{EXAMPLES_MAP[method_name]}",')
        
        i += 1
    
    return '\n'.join(result)

if __name__ == '__main__':
    print('Script para adicionar exemplos criado!')
    print('Execute manualmente ou integre ao processo de build.')
