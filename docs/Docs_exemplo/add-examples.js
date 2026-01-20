// Script para adicionar exemplos a todos os métodos
// Este script adiciona exemplos aos métodos que ainda não têm

const fs = require('fs');

// Ler o arquivo docs-data.js
const content = fs.readFileSync('docs-data.js', 'utf8');

// Função para gerar exemplo baseado na assinatura
function generateExample(signature, methodName) {
    const examples = {
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
        'LoadFromJSONObject': "Field.LoadFromJSONObject(JsonObject); // Carrega de JSON",
        'SetAsChanged': 'Field.SetAsChanged; // Marca como alterado',
        'SetAsUnchanged': 'Field.SetAsUnchanged; // Marca como não alterado',
        'IsFieldChanged': 'if Field.IsFieldChanged then ... // Verifica se foi alterado',
        'IsFieldPrimaryKey': 'if Field.IsFieldPrimaryKey then ... // Verifica se é Primary Key',
        'FieldAllowsNull': 'if Field.FieldAllowsNull then ... // Verifica se permite NULL',
        'SetColumnValue': "Field.SetColumnValue('João').MarkChanged; // Define valor e marca como alterado",
        'SetColumnValueWithoutChange': "Field.SetColumnValueWithoutChange('João'); // Define valor sem marcar como alterado",
        'MarkChanged': 'Field.MarkChanged; // Marca como alterado',
        'MarkUnchanged': 'Field.MarkUnchanged; // Marca como não alterado',
        'Clone': 'var FieldCopy: IField := Field.Clone; // Cria cópia independente'
    };
    
    return examples[methodName] || `// Exemplo: ${methodName}(...);`;
}

console.log('Script criado! Execute: node add-examples.js');
