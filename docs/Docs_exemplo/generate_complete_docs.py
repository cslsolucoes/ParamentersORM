#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para gerar documentação completa com exemplos para todas as units
Execute: python generate_complete_docs.py
"""

import os
import re
import json
from pathlib import Path

def extract_methods_from_pascal(file_path):
    """Extrai métodos de um arquivo Pascal"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    methods = []
    
    # Regex para métodos públicos
    pattern = r'(function|procedure)\s+(\w+)\s*\([^)]*\)[^;]*;'
    
    for match in re.finditer(pattern, content):
        method_type = match.group(1)
        method_name = match.group(2)
        full_signature = match.group(0)
        
        methods.append({
            'signature': full_signature.strip(),
            'name': method_name,
            'type': method_type
        })
    
    return methods

def generate_example(signature, method_name, unit_name, interface_name=None):
    """Gera exemplo de uso baseado na assinatura do método"""
    
    # Exemplos específicos por método
    examples_map = {
        'GetTable': 'var tableName := Field.GetTable; // Retorna nome da tabela',
        'GetColumn': 'var columnName := Field.GetColumn; // Retorna nome da coluna',
        'GetColumnType': 'var columnType := Field.GetColumnType; // Retorna tipo de dado',
        'SetColumnValue': "Field.SetColumnValue('João').MarkChanged; // Define valor e marca como alterado",
        'SetColumnValueWithoutChange': "Field.SetColumnValueWithoutChange('João'); // Define valor sem marcar como alterado",
        'MarkChanged': 'Field.MarkChanged; // Marca campo como alterado',
        'MarkUnchanged': 'Field.MarkUnchanged; // Marca campo como não alterado',
        'Clone': 'var FieldCopy: IField := Field.Clone; // Cria cópia independente',
        'New': "var Field: IField := TField.New('id', 'INTEGER', False, True); // Cria novo campo",
        'Fields': "var Field: IField := Fields.Fields('id'); // Obtém campo pelo nome",
        'Table': "var Table: ITable := Tables.Table('usuarios'); // Obtém tabela pelo nome",
        'Connect': 'Connection.Connect; // Conecta ao banco de dados',
        'Disconnect': 'Connection.Disconnect; // Desconecta do banco',
        'FromParameters': "Connection.FromParameters('database', psInifiles).Connect; // Carrega de INI e conecta",
        'FromIniFile': "Connection.FromIniFile('config.ini', 'database').Connect; // Carrega de INI e conecta",
        'FromJsonFile': "Connection.FromJsonFile('config.json', 'database').Connect; // Carrega de JSON e conecta",
        'FromDatabase': "Connection.FromDatabase('config.db', 'config').Connect; // Carrega de Database e conecta",
        'ParseClass': 'var Table: ITable := Parser.ParseClass(TUsuario); // Converte classe em ITable',
        'MapClassToTable': 'var Table: ITable := Mapper.MapClassToTable(TUsuario); // Mapeia classe para ITable',
        'MapTableToClass': 'Mapper.MapTableToClass(Table, UsuarioInstance); // Mapeia ITable para classe',
        'GenerateInsertSQL': 'var sql := Table.GenerateInsertSQL; // Gera SQL INSERT completo',
        'GenerateInsertSQLOptimized': 'var sql := Table.GenerateInsertSQLOptimized; // Gera SQL INSERT apenas com campos alterados',
        'GenerateUpdateSQL': 'var sql := Table.GenerateUpdateSQL; // Gera SQL UPDATE completo',
        'GenerateUpdateSQLOptimized': 'var sql := Table.GenerateUpdateSQLOptimized; // Gera SQL UPDATE apenas com campos alterados',
        'HasChanges': 'if Table.HasChanges then ... // Verifica se há alterações',
        'LoadFromConnection': 'Tables.Connection(MyConnection).LoadFromConnection; // Carrega estrutura do banco',
        'LoadTablesStructure': 'var Tables: ITables := Connection.LoadTablesStructure; // Carrega todas as tabelas',
        'LoadTableStructure': "var Table: ITable := Connection.LoadTableStructure('usuarios'); // Carrega estrutura de uma tabela",
        'BeginTransaction': 'Connection.BeginTransaction; // Inicia transação',
        'Commit': 'Connection.Commit; // Confirma transação',
        'Rollback': 'Connection.Rollback; // Reverte transação',
        'ExecuteQuery': "var DataSet := Connection.ExecuteQuery('SELECT * FROM usuarios'); // Executa query",
        'ExecuteCommand': "var rows := Connection.ExecuteCommand('INSERT INTO usuarios ...'); // Executa comando",
        'ExecuteScalar': "var value := Connection.ExecuteScalar('SELECT COUNT(*) FROM usuarios'); // Executa e retorna valor único",
        'ToJSON': 'var json := Table.ToJSON; // Serializa para JSON',
        'FromJSON': "Table.FromJSON('{\"table\":\"usuarios\"}'); // Deserializa de JSON",
        'ValidateClass': 'if Parser.ValidateClass(TUsuario) then ... // Valida classe',
        'GetTableName': "var tableName := Parser.GetTableName(TUsuario); // Obtém nome da tabela da classe",
        'GetPrimaryKeyFields': 'var pks := Parser.GetPrimaryKeyFields(TUsuario); // Obtém campos Primary Key',
        'SetFieldValue': "Mapper.SetFieldValue(UsuarioInstance, 'nome', 'João'); // Define valor de campo",
        'GetFieldValue': "var value := Mapper.GetFieldValue(UsuarioInstance, 'nome'); // Obtém valor de campo"
    }
    
    # Tentar encontrar exemplo específico
    if method_name in examples_map:
        return examples_map[method_name]
    
    # Gerar exemplo genérico baseado no tipo de retorno
    if ': ITable' in signature:
        return f"var Table: ITable := {unit_name}.{method_name}(...); // Retorna ITable"
    elif ': IFields' in signature:
        return f"var Fields: IFields := {unit_name}.{method_name}(...); // Retorna IFields"
    elif ': IField' in signature:
        return f"var Field: IField := {unit_name}.{method_name}(...); // Retorna IField"
    elif ': IConnection' in signature:
        return f"var Connection: IConnection := {unit_name}.{method_name}(...); // Retorna IConnection"
    elif ': string' in signature:
        return f"var result: string := {unit_name}.{method_name}(...); // Retorna string"
    elif ': Boolean' in signature:
        return f"var result: Boolean := {unit_name}.{method_name}(...); // Retorna Boolean"
    elif ': Integer' in signature:
        return f"var result: Integer := {unit_name}.{method_name}(...); // Retorna Integer"
    elif ': TStringArray' in signature:
        return f"var result: TStringArray := {unit_name}.{method_name}(...); // Retorna array de strings"
    elif 'procedure' in signature.lower():
        return f"{unit_name}.{method_name}(...); // Executa procedimento"
    else:
        return f"// Exemplo: {unit_name}.{method_name}(...);"

def process_all_units(src_path):
    """Processa todas as units em src e gera documentação"""
    
    units_data = []
    
    # Mapeamento de units para processar
    units_to_process = [
        ('Fields', 'Database.Field.Interfaces', 'IField'),
        ('Fields', 'Database.Field', 'TField'),
        ('Fields', 'Database.Fields.Interfaces', 'IFields'),
        ('Fields', 'Database.Fields', 'TFields'),
        ('Tables', 'Database.Table.Interfaces', 'ITable'),
        ('Tables', 'Database.Table', 'TTable'),
        ('Tables', 'Database.Tables.Interfaces', 'ITables'),
        ('Tables', 'Database.Tables', 'TTables'),
        ('Connetions', 'Database.Connetions.Interfaces', 'IConnection'),
        ('Connetions', 'Database.Connetions', 'TConnection'),
        ('Attributes', 'Database.Attributes.Interfaces', 'IAttributeParser'),
        ('Attributes', 'Database.Attributes', 'TAttributeParser'),
        ('Commons', 'Database.Types', None),
        ('Commons', 'Database.Exceptions', None),
        ('Commons', 'Database.Consts', None),
    ]
    
    for folder, unit_name, main_class in units_to_process:
        file_path = Path(src_path) / folder / f"{unit_name}.pas"
        
        if not file_path.exists():
            print(f"Arquivo não encontrado: {file_path}")
            continue
        
        print(f"Processando: {unit_name}")
        
        # Extrair métodos
        methods = extract_methods_from_pascal(file_path)
        
        # Criar estrutura de documentação
        unit_data = {
            'id': unit_name.lower().replace('.', '-'),
            'name': unit_name,
            'path': f'src/{folder}/{unit_name}.pas',
            'description': f'<p>Unit {unit_name}</p>',
            'methods': []
        }
        
        for method in methods:
            example = generate_example(
                method['signature'],
                method['name'],
                main_class or unit_name.split('.')[-1]
            )
            
            unit_data['methods'].append({
                'signature': method['signature'],
                'comment': f"Método {method['name']}",
                'example': example
            })
        
        units_data.append(unit_data)
    
    return units_data

if __name__ == '__main__':
    src_path = '../src'
    units = process_all_units(src_path)
    
    print(f"\nProcessadas {len(units)} units")
    print("Documentação gerada com sucesso!")
