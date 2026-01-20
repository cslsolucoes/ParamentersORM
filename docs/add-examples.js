// Script para adicionar exemplos a todos os métodos do Parameters ORM
// Este script adiciona exemplos aos métodos que ainda não têm
// NOTA: Este script é uma versão simplificada. Para individualização de overloads,
// use o script Python: update-docs-with-examples.py

const fs = require('fs');

// Ler o arquivo docs-data.js
const content = fs.readFileSync('docs-data.js', 'utf8');

// Função para gerar exemplo baseado na assinatura
// Exemplos do Parameters ORM (não Database ORM)
function generateExample(signature, methodName) {
    const examples = {
        // TParameters factory methods
        'New': 'var Parameters: IParameters; Parameters := TParameters.New;',
        'NewDatabase': 'var DB: IParametersDatabase; DB := TParameters.NewDatabase;',
        'NewInifiles': 'var Ini: IParametersInifiles; Ini := TParameters.NewInifiles;',
        'NewJsonObject': 'var Json: IParametersJsonObject; Json := TParameters.NewJsonObject;',
        // IParametersDatabase methods
        'Connect': 'DB.Connect;',
        'Get': 'var Param: TParameter; Param := DB.Get(\'chave\');',
        'List': 'var List: TParameterList; List := DB.List;',
        'Insert': 'DB.Insert(Param);',
        'Update': 'DB.Update(Param);',
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
        'CreateTable': 'DB.CreateTable;',
        'DropTable': 'DB.DropTable;',
        'MigrateTable': 'DB.MigrateTable;',
        'TableExists': 'if DB.TableExists then ...',
        'IsConnected': 'if DB.IsConnected then ...',
        'Disconnect': 'DB.Disconnect;',
        'Refresh': 'DB.Refresh;',
        // IParametersInifiles methods
        'FilePath': 'Ini.FilePath(\'C:\\config.ini\');',
        'Section': 'Ini.Section(\'Parameters\');',
        // IParametersJsonObject methods
        'JsonObject': 'Json.JsonObject(MyJsonObject);',
        'ObjectName': 'Json.ObjectName(\'Parameters\');',
        // Parameters.Consts functions
        'GetBooleanSQLType': 'var SQLType: string; SQLType := GetBooleanSQLType(pdtPostgreSQL);',
        'GetBooleanSQLDefault': 'var Default: string; Default := GetBooleanSQLDefault(pdtPostgreSQL, True);'
    };
    
    return examples[methodName] || `// Exemplo: ${methodName}(...);`;
}

console.log('Script para adicionar exemplos do Parameters ORM criado!');
console.log('NOTA: Para individualização de overloads, use: python update-docs-with-examples.py');
