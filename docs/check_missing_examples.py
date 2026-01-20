#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para verificar quais métodos e funções não têm exemplos
"""

import re

def check_missing_examples():
    """Verifica quais métodos e funções não têm exemplos"""
    
    with open('docs-data.js', 'r', encoding='utf-8') as f:
        content = f.read()
    
    missing_examples = []
    current_unit = None
    
    # Dividir em linhas para análise
    lines = content.split('\n')
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Detectar nome da unit
        unit_match = re.search(r'"name":\s*"([^"]+\.pas)"', line)
        if unit_match:
            current_unit = unit_match.group(1)
        
        # Detectar início de método/função
        # Padrão: "name": "MethodName",
        name_match = re.search(r'"name":\s*"([^"]+)"', line)
        if name_match:
            method_name = name_match.group(1)
            
            # Verificar se é método/função (não é type, class, etc)
            # Procurar por "type": "function" ou "type": "procedure" nas próximas linhas
            method_type = None
            signature = None
            has_example = False
            
            # Verificar próximas 10 linhas
            for j in range(i, min(i + 15, len(lines))):
                next_line = lines[j]
                
                # Verificar tipo
                type_match = re.search(r'"type":\s*"(function|procedure)"', next_line)
                if type_match:
                    method_type = type_match.group(1)
                
                # Verificar assinatura
                sig_match = re.search(r'"signature":\s*"([^"]+)"', next_line)
                if sig_match:
                    signature = sig_match.group(1)
                
                # Verificar se tem exemplo
                if '"example":' in next_line:
                    # Verificar se o exemplo não está vazio
                    example_match = re.search(r'"example":\s*"([^"]*)"', next_line)
                    if example_match and example_match.group(1).strip():
                        has_example = True
                        break
                
                # Se encontrou outro "name" antes de encontrar "example", parar
                if j > i and '"name":' in next_line:
                    break
            
            # Se encontrou método/função sem exemplo
            if method_type and not has_example and current_unit:
                missing_examples.append({
                    'unit': current_unit,
                    'type': method_type,
                    'name': method_name,
                    'signature': signature or 'N/A'
                })
        
        i += 1
    
    # Exibir resultados
    if missing_examples:
        print(f"\n{'='*80}")
        print(f"ENCONTRADOS {len(missing_examples)} MÉTODOS/FUNÇÕES SEM EXEMPLOS:")
        print(f"{'='*80}\n")
        
        # Agrupar por unit
        by_unit = {}
        for item in missing_examples:
            unit = item['unit']
            if unit not in by_unit:
                by_unit[unit] = []
            by_unit[unit].append(item)
        
        for unit, items in sorted(by_unit.items()):
            print(f"\n📁 {unit} ({len(items)} sem exemplos):")
            for item in items[:20]:  # Limitar a 20 por unit
                print(f"  - {item['type']}: {item['name']}")
            if len(items) > 20:
                print(f"  ... e mais {len(items) - 20} métodos")
    else:
        print("\n✅ TODOS OS MÉTODOS E FUNÇÕES TÊM EXEMPLOS!")
    
    return missing_examples

if __name__ == '__main__':
    check_missing_examples()
