#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para gerar documentação completa do Parameters ORM v1.0.0
Extrai informações das units Pascal e gera docs-data.js
"""

import os
import re
import json
from pathlib import Path

# Caminhos
BASE_DIR = Path(__file__).parent.absolute()
# BASE_DIR = E:\CSL\ORM\src\Paramenters\docs
# SRC_DIR deve ser = E:\CSL\ORM\src\Paramenters\src\Paramenters
SRC_DIR = (BASE_DIR.parent / "src" / "Paramenters").resolve()
OUTPUT_FILE = BASE_DIR / "docs-data.js"

print(f"DEBUG: BASE_DIR = {BASE_DIR}")
print(f"DEBUG: SRC_DIR = {SRC_DIR}")
print(f"DEBUG: SRC_DIR exists = {SRC_DIR.exists()}")

# Units públicas do Parameters
PUBLIC_UNITS = [
    "Parameters.pas",
    "Parameters.Interfaces.pas"
]

def extract_methods_from_pascal(file_path):
    """Extrai métodos de uma unit Pascal"""
    methods = []
    
    if not os.path.exists(file_path):
        return methods
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Padrões para métodos de interface
    pattern = r'(function|procedure)\s+(\w+)\s*\([^)]*\)\s*(?::\s*[\w\.]+)?\s*;'
    
    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in matches:
        method_type = match.group(1)
        method_name = match.group(2)
        
        methods.append({
            'name': method_name,
            'type': method_type,
            'signature': match.group(0),
            'description': f"{method_type} {method_name}"
        })
    
    return methods

def extract_interfaces_from_pascal(file_path):
    """Extrai interfaces de uma unit Pascal"""
    interfaces = []
    
    if not os.path.exists(file_path):
        return interfaces
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Padrão para interface
    pattern = r'(\w+)\s*=\s*interface'
    
    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in matches:
        interface_name = match.group(1)
        
        # Extrai métodos da interface
        interface_end = content.find('end;', match.end())
        if interface_end > 0:
            interface_content = content[match.end():interface_end]
            methods = extract_methods_from_pascal_content(interface_content)
        else:
            methods = []
        
        interfaces.append({
            'name': interface_name,
            'description': f"Interface {interface_name}",
            'methods': methods
        })
    
    return interfaces

def extract_methods_from_pascal_content(content):
    """Extrai métodos de um conteúdo Pascal"""
    methods = []
    pattern = r'(function|procedure)\s+(\w+)\s*\([^)]*\)\s*(?::\s*[\w\.]+)?\s*;'
    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in matches:
        methods.append({
            'name': match.group(2),
            'type': match.group(1),
            'signature': match.group(0)
        })
    
    return methods

def extract_classes_from_pascal(file_path):
    """Extrai classes de uma unit Pascal"""
    classes = []
    
    if not os.path.exists(file_path):
        return classes
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Padrão para class
    pattern = r'(\w+)\s*=\s*class'
    
    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in matches:
        class_name = match.group(1)
        classes.append({
            'name': class_name,
            'description': f"Class {class_name}"
        })
    
    return classes

def process_unit(unit_name):
    """Processa uma unit Pascal e extrai informações"""
    # SRC_DIR já é o caminho absoluto para src/Paramenters
    full_path = SRC_DIR / unit_name
    
    if not full_path.exists():
        print(f"  [AVISO] Arquivo nao encontrado: {full_path}")
        return None
    
    print(f"Processando: {unit_name}")
    
    # Extrai interfaces
    interfaces = extract_interfaces_from_pascal(str(full_path))
    
    # Extrai classes
    classes = extract_classes_from_pascal(str(full_path))
    
    # Extrai métodos (se não estiverem em interfaces)
    methods = extract_methods_from_pascal(str(full_path))
    
    # Lê descrição da unit
    with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
        desc_match = re.search(r'\{[^}]*Descrição[^}]*\}', content, re.IGNORECASE | re.DOTALL)
        description = desc_match.group(0).strip('{}').strip() if desc_match else f"Unit {unit_name}"
    
    return {
        'id': unit_name.lower().replace('.pas', '').replace('/', '_'),
        'name': unit_name,
        'path': str(full_path.relative_to(BASE_DIR.parent)) if BASE_DIR.parent in full_path.parents else str(full_path),
        'description': description[:500],
        'interfaces': interfaces,
        'classes': classes,
        'functions': methods
    }

def generate_docs_data():
    """Gera o arquivo docs-data.js"""
    
    print("Gerando documentacao do Parameters ORM v1.0.0...")
    
    # Processa units públicas
    units = []
    for unit_name in PUBLIC_UNITS:
        unit_data = process_unit(unit_name)
        if unit_data:
            units.append(unit_data)
        else:
            print(f"  [AVISO] Nao foi possivel processar: {unit_name}")
    
    # Gera overview
    overview = {
        'title': 'Visao Geral',
        'path': 'Parameters ORM v1.0.0',
        'description': '''
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px;">
                <h2 style="color: white; margin-top: 0;">Parameters ORM v1.0.0</h2>
                <p style="font-size: 1.1em; line-height: 1.6;">
                    Sistema unificado de gerenciamento de parametros de configuracao para Delphi/Free Pascal, 
                    com suporte a multiplas fontes de dados (Banco de Dados, Arquivos INI, Objetos JSON) e fallback automatico.
                </p>
            </div>
        '''
    }
    
    # Gera usage guide
    usage_guide = {
        'title': 'Guia de Uso',
        'path': 'Guia de Uso',
        'description': '<h2>Inicio Rapido</h2><p>Exemplos praticos de uso do Parameters ORM.</p>'
    }
    
    # Gera public units guide
    public_units_guide = {
        'title': 'Units Publicas',
        'path': 'Units Publicas',
        'description': '<h2>Units Publicas</h2><p>O modulo Parameters expoe apenas 2 units publicas:</p><ul><li><strong>Parameters.pas</strong> - Ponto de entrada (Factory methods + TParametersImpl)</li><li><strong>Parameters.Interfaces.pas</strong> - Interfaces publicas</li></ul>'
    }
    
    # Monta estrutura completa
    docs_data = {
        'overview': overview,
        'usageGuide': usage_guide,
        'publicUnitsGuide': public_units_guide,
        'units': units
    }
    
    # Gera JavaScript
    js_content = f'''// Documentacao completa do Parameters ORM v1.0.0
// Gerado automaticamente - Nao editar manualmente

const documentation = {json.dumps(docs_data, indent=4, ensure_ascii=False)};

// IDs das units publicas (para navegacao)
const publicUnitIds = {json.dumps([u['id'] for u in units], indent=4)};
'''
    
    # Salva arquivo
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(js_content)
    
    print(f"[OK] Documentacao gerada em: {OUTPUT_FILE}")
    print(f"[OK] {len(units)} units processadas")
    print(f"[OK] {sum(len(u.get('interfaces', [])) for u in units)} interfaces encontradas")
    print(f"[OK] {sum(len(u.get('classes', [])) for u in units)} classes encontradas")

if __name__ == '__main__':
    generate_docs_data()
