// Script Node.js para gerar documentação completa com exemplos
// Execute: node generate-docs.js

const fs = require('fs');
const path = require('path');

// Função para extrair métodos de um arquivo Pascal
function extractMethodsFromPascal(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    const methods = [];
    
    // Regex para encontrar métodos públicos
    const publicMethodRegex = /(function|procedure)\s+(\w+)\s*\([^)]*\)[^;]*;/g;
    let match;
    
    while ((match = publicMethodRegex.exec(content)) !== null) {
        methods.push({
            signature: match[0].trim(),
            name: match[2],
            type: match[1]
        });
    }
    
    return methods;
}

// Função para gerar exemplo de uso baseado na assinatura do método
function generateExample(signature, methodName, unitName) {
    const examples = {
        'GetTable': 'var tableName := Field.GetTable; // Retorna nome da tabela',
        'GetColumn': 'var columnName := Field.GetColumn; // Retorna nome da coluna',
        'SetColumnValue': 'Field.SetColumnValue(\'João\').MarkChanged; // Define valor e marca como alterado',
        'Clone': 'var FieldCopy: IField := Field.Clone; // Cria cópia independente',
        'New': `var Field: IField := TField.New('id', 'INTEGER', False, True); // Cria novo campo`,
        'Fields': `var Field: IField := Fields.Fields('id'); // Obtém campo pelo nome`,
        'Table': `var Table: ITable := Tables.Table('usuarios'); // Obtém tabela pelo nome`,
        'Connect': `Connection.Connect; // Conecta ao banco de dados`,
        'FromParameters': `Connection.FromParameters('database', psInifiles).Connect; // Carrega de INI e conecta`,
        'ParseClass': `var Table: ITable := Parser.ParseClass(TUsuario); // Converte classe em ITable`
    };
    
    // Tentar encontrar exemplo específico
    if (examples[methodName]) {
        return examples[methodName];
    }
    
    // Gerar exemplo genérico baseado no tipo
    if (signature.includes('function') && signature.includes(': I')) {
        const returnType = signature.match(/: (I\w+)/);
        if (returnType) {
            return `var result: ${returnType[1]} := ${unitName}.${methodName}(...); // Retorna ${returnType[1]}`;
        }
    }
    
    if (signature.includes('function') && signature.includes(': string')) {
        return `var result: string := ${unitName}.${methodName}(...); // Retorna string`;
    }
    
    if (signature.includes('function') && signature.includes(': Boolean')) {
        return `var result: Boolean := ${unitName}.${methodName}(...); // Retorna Boolean`;
    }
    
    if (signature.includes('procedure')) {
        return `${unitName}.${methodName}(...); // Executa procedimento`;
    }
    
    return `// Exemplo de uso: ${unitName}.${methodName}(...);`;
}

console.log('Script de geração de documentação criado!');
console.log('Para usar, execute: node generate-docs.js');
