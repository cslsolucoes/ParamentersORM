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
from html import escape as escape_html

# Importar conteúdo do roteiro de uso, visão geral e exemplos de units
try:
    from usage_guide_content import USAGE_GUIDE_HTML
except ImportError:
    USAGE_GUIDE_HTML = '<p>Erro: Não foi possível carregar usage_guide_content.py</p>'

try:
    from overview_content import OVERVIEW_HTML
except ImportError:
    OVERVIEW_HTML = '<p>Erro: Não foi possível carregar overview_content.py</p>'

try:
    from units_examples_content import UNITS_EXAMPLES
except ImportError:
    UNITS_EXAMPLES = {}

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

# Units internas do Parameters
INTERNAL_UNITS = [
    "Commons/Parameters.Types.pas",
    "Commons/Parameters.Consts.pas",
    "Commons/Parameters.Exceptions.pas",
    "Database/Parameters.Database.pas",
    "IniFiles/Parameters.Inifiles.pas",
    "JsonObject/Parameters.JsonObject.pas",
    "Attributes/Parameters.Attributes.pas",
    "Attributes/Parameters.Attributes.Interfaces.pas",
    "Attributes/Parameters.Attributes.Types.pas",
    "Attributes/Parameters.Attributes.Consts.pas",
    "Attributes/Parameters.Attributes.Exceptions.pas"
]

def extract_methods_from_pascal(file_path):
    """Extrai métodos de uma unit Pascal"""
    methods = []
    
    if not os.path.exists(file_path):
        return methods
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Encontrar seção interface e implementation
    interface_match = re.search(r'\binterface\b', content, re.IGNORECASE)
    implementation_match = re.search(r'\bimplementation\b', content, re.IGNORECASE)
    
    # Se tem interface, extrair apenas da interface
    # Se não tem interface, extrair de todo o arquivo
    if interface_match:
        if implementation_match:
            # Extrair apenas da seção interface
            interface_content = content[interface_match.end():implementation_match.start()]
        else:
            # Interface até o fim
            interface_content = content[interface_match.end():]
    else:
        # Sem interface, extrair de todo o arquivo
        interface_content = content
    
    # Padrões para métodos de interface
    pattern = r'(function|procedure)\s+(\w+)\s*\([^)]*\)\s*(?::\s*[\w\.]+)?\s*;'
    
    matches = re.finditer(pattern, interface_content, re.MULTILINE | re.IGNORECASE)
    
    # Usar set para evitar duplicatas
    seen_signatures = set()
    
    for match in matches:
        method_type = match.group(1)
        method_name = match.group(2)
        method_signature = match.group(0)
        method_pos = match.start()
        
        # Verificar se já vimos esta assinatura (evitar duplicatas)
        if method_signature in seen_signatures:
            continue
        seen_signatures.add(method_signature)
        
        # Tentar extrair comentário antes do método
        # Buscar no conteúdo original para ter contexto completo
        original_pos = interface_match.end() + method_pos if interface_match else method_pos
        comment = extract_comment_before_method(content, original_pos)
        
        # Se não encontrou comentário, usar mapeamento
        if not comment:
            comment = METHOD_DESCRIPTIONS.get(method_name, f"{method_type} {method_name}")
        
        methods.append({
            'name': method_name,
            'type': method_type,
            'signature': method_signature,
            'description': f"{method_type} {method_name}",
            'comment': comment
        })
    
    return methods

def extract_comment_before_interface_or_class(content, pos, name):
    """Extrai comentário antes de uma interface ou classe"""
    start = max(0, pos - 2000)  # ~20 linhas antes
    context = content[start:pos]
    
    # Procurar comentários de bloco { } antes da interface/classe
    # Buscar o último comentário de bloco antes da posição que contenha o nome
    block_comments = list(re.finditer(r'\{[^}]*\}', context, re.DOTALL | re.IGNORECASE))
    if block_comments:
        # Pegar o último comentário (mais próximo) que contenha o nome da interface/classe
        for comment_match in reversed(block_comments):
            comment = comment_match.group(0).strip('{}').strip()
            # Ignorar comentários que são apenas separadores, forward declarations ou diretivas
            if (len(comment) < 1000 and 
                not re.match(r'^=+$', comment) and 
                not re.search(r'FORWARD\s+DECLARATION', comment, re.IGNORECASE) and
                not re.search(r'\$I\s+', comment, re.IGNORECASE) and  # Ignorar diretivas $I
                not re.search(r'\$IF\s+', comment, re.IGNORECASE) and  # Ignorar diretivas $IF
                (name in comment or len(comment) > 20)):  # Deve conter o nome ou ser descritivo
                # Formatar como HTML
                lines = comment.split('\n')
                formatted = []
                for line in lines:
                    line = line.strip()
                    if line and not line.startswith('='):
                        # Se começa com palavra-chave, fazer negrito
                        if re.match(r'^(Descrição|Uso|Author|Version|Date|Finalidade|Retorno|Exemplo):', line, re.IGNORECASE):
                            key, value = line.split(':', 1) if ':' in line else (line, '')
                            formatted.append(f'<p><strong>{key}:</strong> {value.strip()}</p>')
                        else:
                            formatted.append(f'<p>{line}</p>')
                return '\n'.join(formatted) if formatted else comment
    
    return None

def extract_interfaces_from_pascal(file_path):
    """Extrai interfaces de uma unit Pascal"""
    interfaces = []
    seen_interfaces = set()  # Para evitar duplicatas (forward declarations)
    
    if not os.path.exists(file_path):
        return interfaces
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Padrão para interface (captura também forward declarations)
    pattern = r'(\w+)\s*=\s*interface'
    
    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in matches:
        interface_name = match.group(1)
        interface_pos = match.start()
        
        # Ignorar se já processamos esta interface (evitar forward declarations)
        if interface_name in seen_interfaces:
            continue
        
        # Verificar se é forward declaration (não tem 'end;' depois)
        interface_end = content.find('end;', match.end())
        if interface_end <= 0:
            # É forward declaration, pular
            continue
        
        # Verificar se tem métodos ou propriedades (não é apenas forward declaration)
        interface_content = content[match.end():interface_end]
        # Se não tem nada além de espaços/comentários/GUID, é forward declaration
        interface_body = re.sub(r'\{[^}]*\}', '', interface_content)  # Remove GUID
        interface_body = re.sub(r'//.*', '', interface_body)  # Remove comentários de linha
        interface_body = re.sub(r'\{[^}]*\}', '', interface_body)  # Remove comentários de bloco
        interface_body = interface_body.strip()
        
        if not interface_body or len(interface_body) < 10:
            # Provavelmente é forward declaration, pular
            continue
        
        seen_interfaces.add(interface_name)
        
        # Extrair descrição da interface
        description = extract_comment_before_interface_or_class(content, interface_pos, interface_name)
        if not description:
            # Tentar buscar comentário de linha antes
            lines = content[:interface_pos].split('\n')
            comments = []
            for line in reversed(lines[-10:]):
                line = line.strip()
                if line.startswith('//') and not line.startswith('// ='):
                    comment = line[2:].strip()
                    if comment and len(comment) > 5:
                        comments.insert(0, comment)
                elif line and not line.startswith('{') and not line.startswith('}'):
                    break
            if comments:
                description = '<p>' + ' '.join(comments) + '</p>'
            else:
                description = f"<p>Interface <code>{interface_name}</code> para acesso a parâmetros.</p>"
        
        # Extrai métodos da interface
        # Encontrar o 'end;' correto que fecha esta interface específica
        interface_start = match.end()
        interface_end = -1
        
        # Buscar o primeiro 'end;' após a declaração que:
        # 1. Não está em comentário
        # 2. Tem métodos válidos antes dele
        # 3. Não tem outra declaração de interface diferente antes dele
        search_pos = interface_start
        max_search = min(len(content), interface_start + 50000)  # Limitar busca
        
        while search_pos < max_search:
            end_pos = content.find('end;', search_pos)
            if end_pos < 0:
                break
            
            # Verificar se não está em comentário de linha
            line_start = content.rfind('\n', max(0, interface_start - 100), end_pos)
            if line_start >= 0:
                line = content[line_start:end_pos]
                if '//' in line:
                    comment_pos = line.find('//')
                    end_in_line = line.find('end;')
                    if end_in_line > comment_pos:
                        # 'end;' está após comentário, pular
                        search_pos = end_pos + 4
                        continue
            
            # Verificar conteúdo entre interface_start e end_pos
            between_content = content[interface_start:end_pos]
            
            # Verificar se há outra declaração de interface diferente entre interface_start e end_pos
            # Padrão: nome = interface (mas não forward declaration que é apenas "nome = interface;")
            other_interface_pattern = r'(\w+)\s*=\s*interface\b'
            other_interfaces = list(re.finditer(other_interface_pattern, between_content, re.IGNORECASE))
            
            has_other_interface = False
            for other_match in other_interfaces:
                other_name = other_match.group(1)
                if other_name != interface_name:
                    # Verificar se não é forward declaration
                    # Forward declarations são apenas "nome = interface;" sem métodos depois
                    other_pos_in_content = interface_start + other_match.start()
                    # Procurar o próximo 'end;' após esta outra interface
                    next_end_after_other = content.find('end;', other_pos_in_content)
                    if next_end_after_other > 0 and next_end_after_other < end_pos:
                        # Verificar se há métodos entre a outra interface e seu 'end;'
                        other_interface_content = content[other_pos_in_content:next_end_after_other]
                        method_pattern_check = r'(function|procedure)\s+\w+'
                        if re.search(method_pattern_check, other_interface_content, re.IGNORECASE):
                            # É uma interface completa com métodos antes deste 'end;'
                            # Então este 'end;' fecha a interface anterior, não a atual
                            has_other_interface = True
                            break
            
            if has_other_interface:
                # Há outra interface completa antes deste 'end;', então este 'end;' fecha a interface anterior
                search_pos = end_pos + 4
                continue
            
            # Verificar se há métodos válidos antes deste 'end;'
            method_pattern = r'(function|procedure)\s+\w+(?:\s*\([^)]*\))?\s*(?::\s*[\w\.]+)?\s*;'
            if re.search(method_pattern, between_content, re.IGNORECASE):
                # Se não há outra interface antes deste 'end;' e há métodos, aceitar este 'end;'
                # (a verificação de outra interface já foi feita acima)
                # Depois vamos filtrar os métodos para garantir que são da interface correta
                interface_end = end_pos
                break
            
            # Não encontrou métodos, continuar procurando
            search_pos = end_pos + 4
        
        if interface_end > 0:
            interface_content = content[interface_start:interface_end]
            
            # Extrair métodos diretamente do conteúdo da interface
            methods = extract_methods_from_pascal_content(interface_content)
            
            # Filtrar métodos: apenas os que realmente pertencem a esta interface
            # Um método pertence à interface se:
            # 1. Retorna o tipo da interface (ex: : IParametersDatabase) OU
            # 2. Tem a interface como parâmetro OU
            # 3. Não referencia nenhuma outra interface conhecida (métodos que retornam tipos primitivos)
            filtered_methods = []
            known_interfaces = ['IParametersDatabase', 'IParametersInifiles', 'IParametersJsonObject', 'IParameters']
            
            for method in methods:
                method_sig = method.get('signature', '')
                # Verificar se o método referencia a interface atual
                if interface_name in method_sig:
                    # Método referencia a interface atual, incluir
                    filtered_methods.append(method)
                else:
                    # Método não referencia a interface atual diretamente
                    # Verificar se referencia outra interface conhecida
                    references_other_interface = any(
                        iface_name in method_sig 
                        for iface_name in known_interfaces 
                        if iface_name != interface_name
                    )
                    
                    if not references_other_interface:
                        # Não referencia outra interface conhecida
                        # Pode ser um método que retorna tipo primitivo (string, Integer, Boolean, etc.)
                        # ou que não tem tipo de retorno (procedure)
                        # Incluir apenas se estiver realmente dentro desta interface
                        # (verificação já feita ao encontrar o 'end;' correto)
                        filtered_methods.append(method)
                    # Se referencia outra interface, excluir (não pertence a esta interface)
            
            methods = filtered_methods
            
            # Ajustar comentários usando o conteúdo completo (para pegar comentários antes da interface)
            for method in methods:
                # Encontrar a posição real do método no conteúdo completo
                method_signature = method['signature']
                # Buscar a assinatura no conteúdo completo, mas dentro da interface
                real_pos = content.find(method_signature, interface_start)
                if real_pos >= 0 and real_pos < interface_end:
                    # Extrair comentário usando a posição real no conteúdo completo
                    comment = extract_comment_before_method(content, real_pos)
                    if comment:
                        method['comment'] = comment
        else:
            methods = []
        
        interfaces.append({
            'name': interface_name,
            'description': description,
            'methods': methods
        })
    
    return interfaces

# Mapeamento de descrições para métodos do Parameters ORM
METHOD_DESCRIPTIONS = {
    # TParameters factory methods
    'New': 'Cria uma nova instância de IParameters com configuração padrão ou customizada',
    'NewDatabase': 'Cria uma nova instância de IParametersDatabase para acesso a parâmetros em banco de dados',
    'NewInifiles': 'Cria uma nova instância de IParametersInifiles para acesso a parâmetros em arquivos INI',
    'NewJsonObject': 'Cria uma nova instância de IParametersJsonObject para acesso a parâmetros em objetos JSON',
    
    # IParametersDatabase - Configuração
    'TableName': 'Define ou obtém o nome da tabela de parâmetros',
    'Schema': 'Define ou obtém o schema da tabela',
    'AutoCreateTable': 'Define ou obtém se a tabela deve ser criada automaticamente',
    'Engine': 'Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)',
    'DatabaseType': 'Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)',
    'Host': 'Define ou obtém o host do banco de dados',
    'Port': 'Define ou obtém a porta do banco de dados',
    'Username': 'Define ou obtém o usuário do banco de dados',
    'Password': 'Define ou obtém a senha do banco de dados',
    'Database': 'Define ou obtém o nome do banco de dados',
    'ContratoID': 'Define ou obtém o ID do contrato para filtro',
    'ProdutoID': 'Define ou obtém o ID do produto para filtro',
    'Title': 'Define ou obtém o título/seção dos parâmetros',
    
    # IParametersDatabase - CRUD
    'List': 'Lista todos os parâmetros ativos do banco de dados',
    'Get': 'Busca um parâmetro específico por nome/chave',
    'Insert': 'Insere um novo parâmetro no banco de dados',
    'Update': 'Atualiza um parâmetro existente no banco de dados',
    'Delete': 'Remove um parâmetro do banco de dados (soft delete)',
    'Exists': 'Verifica se um parâmetro existe no banco de dados',
    'Count': 'Retorna o número de parâmetros ativos',
    
    # IParametersDatabase - Conexão
    'Connect': 'Conecta ao banco de dados',
    'Disconnect': 'Desconecta do banco de dados',
    'IsConnected': 'Verifica se está conectado ao banco de dados',
    
    # IParametersDatabase - Tabela
    'CreateTable': 'Cria a tabela de parâmetros se não existir',
    'DropTable': 'Remove a tabela de parâmetros',
    'MigrateTable': 'Migra a estrutura da tabela para a versão atual',
    'TableExists': 'Verifica se a tabela existe no banco de dados',
    'Refresh': 'Recarrega os parâmetros do banco de dados',
    
    # IParametersInifiles
    'FilePath': 'Define ou obtém o caminho do arquivo INI',
    'Section': 'Define ou obtém a seção do arquivo INI',
    'FileExists': 'Verifica se o arquivo INI existe',
    
    # IParametersJsonObject
    'JsonObject': 'Define ou obtém o objeto JSON',
    'ObjectName': 'Define ou obtém o nome do objeto JSON',
    'ToJSON': 'Retorna o objeto JSON completo como string',
    'ToJSONString': 'Retorna o objeto JSON formatado como string',
    'SaveToFile': 'Salva o objeto JSON em arquivo',
    'LoadFromFile': 'Carrega o objeto JSON de arquivo',
    'LoadFromString': 'Carrega o objeto JSON de string',
    
    # IParameters - Convergência
    'Source': 'Define ou obtém a fonte ativa de parâmetros',
    'AddSource': 'Adiciona uma fonte à lista de fontes disponíveis',
    'RemoveSource': 'Remove uma fonte da lista',
    'HasSource': 'Verifica se uma fonte está ativa',
    'Priority': 'Define a ordem de prioridade das fontes',
    'Database': 'Retorna a interface IParametersDatabase',
    'Inifiles': 'Retorna a interface IParametersInifiles',
    'JsonObject': 'Retorna a interface IParametersJsonObject',
}

def extract_comment_before_method(content, method_pos):
    """Extrai comentário antes de um método"""
    # Buscar comentários nas últimas 20 linhas antes do método
    start = max(0, method_pos - 2000)  # ~20 linhas antes
    context = content[start:method_pos]
    
    # Ignorar padrões que não são descrições de métodos
    ignore_patterns = [
        r'^\s*//\s*=+',  # Separadores de seção (// =====)
        r'^\s*\{.*=+',   # Separadores de bloco ({ =====)
        r'\$IF',         # Diretivas de compilação
        r'\$ELSE',
        r'\$ENDIF',
        r'^\s*//\s*CONFIGURAÇÃO',
        r'^\s*//\s*CRUD',
        r'^\s*//\s*FACTORY',
    ]
    
    # Procurar comentários de linha // antes do método
    lines = context.split('\n')
    comments = []
    for line in reversed(lines[-15:]):  # Últimas 15 linhas
        line_stripped = line.strip()
        
        # Ignorar se é um padrão a ser ignorado
        should_ignore = False
        for pattern in ignore_patterns:
            if re.match(pattern, line_stripped, re.IGNORECASE):
                should_ignore = True
                break
        
        if should_ignore:
            continue
        
        if line_stripped.startswith('//'):
            comment = line_stripped[2:].strip()
            # Ignorar comentários vazios ou muito curtos
            if comment and len(comment) > 3:
                # Ignorar se é apenas um separador
                if not re.match(r'^=+$', comment):
                    comments.insert(0, comment)
        elif line_stripped.startswith('{') and line_stripped.endswith('}'):
            # Comentário de bloco em uma linha
            comment = line_stripped[1:-1].strip()
            if comment and len(comment) > 3 and len(comment) < 200:
                # Ignorar se contém apenas separadores
                if not re.match(r'^=+', comment):
                    comments.insert(0, comment)
        elif line_stripped and not line_stripped.startswith('{') and not line_stripped.startswith('}'):
            # Se encontrou código (não comentário), parar de buscar
            if not line_stripped.startswith('//'):
                break
    
    if comments:
        # Juntar comentários e limpar
        result = ' '.join(comments)
        # Remover múltiplos espaços
        result = re.sub(r'\s+', ' ', result)
        # Limitar tamanho
        if len(result) > 300:
            result = result[:297] + '...'
        return result
    
    return None

def extract_methods_from_pascal_content(content):
    """Extrai métodos de um conteúdo Pascal"""
    methods = []
    
    # Padrão para function, procedure, constructor, destructor
    # Torna parâmetros opcionais para capturar métodos sem parâmetros também
    pattern = r'(function|procedure|constructor|destructor)\s+(\w+)(?:\s*\([^)]*\))?\s*(?::\s*[\w\.]+)?\s*;'
    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in matches:
        method_name = match.group(2)
        method_pos = match.start()
        
        # Tentar extrair comentário antes do método
        comment = extract_comment_before_method(content, method_pos)
        
        # Se não encontrou comentário, usar mapeamento
        if not comment:
            comment = METHOD_DESCRIPTIONS.get(method_name, f"{match.group(1)} {method_name}")
        
        methods.append({
            'name': method_name,
            'type': match.group(1),
            'signature': match.group(0).strip(),
            'comment': comment
        })
    
    # Extrair propriedades (property)
    property_pattern = r'property\s+(\w+)\s*(?:\[[^\]]+\])?\s*:\s*([^;]+?)(?:\s+read\s+(\w+))?(?:\s+write\s+(\w+))?;'
    property_matches = re.finditer(property_pattern, content, re.MULTILINE | re.IGNORECASE)
    
    for match in property_matches:
        property_name = match.group(1)
        property_type = match.group(2).strip()
        read_accessor = match.group(3) if match.group(3) else None
        write_accessor = match.group(4) if match.group(4) else None
        property_pos = match.start()
        
        # Extrair comentário antes da propriedade
        comment = extract_comment_before_method(content, property_pos)
        
        # Construir assinatura da propriedade
        signature_parts = [f'property {property_name}: {property_type}']
        if read_accessor:
            signature_parts.append(f'read {read_accessor}')
        if write_accessor:
            signature_parts.append(f'write {write_accessor}')
        signature = ' '.join(signature_parts) + ';'
        
        if not comment:
            comment = f"Propriedade {property_name} do tipo {property_type}"
        
        methods.append({
            'name': property_name,
            'type': 'property',
            'signature': signature,
            'comment': comment
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
        class_pos = match.start()
        
        # Extrair descrição da classe
        description = extract_comment_before_interface_or_class(content, class_pos, class_name)
        if not description:
            # Tentar buscar comentário de linha imediatamente antes da classe
            # Buscar nas últimas 10 linhas antes da declaração da classe
            lines = content[:class_pos].split('\n')
            # Pegar as últimas 10 linhas antes da classe
            context_lines = lines[-10:] if len(lines) >= 10 else lines
            
            # Buscar o comentário mais próximo (última linha antes da classe)
            # Começar da última linha (mais próxima da classe) e ir para trás
            found_comment = None
            for i in range(len(context_lines) - 1, -1, -1):
                line = context_lines[i]
                line_stripped = line.strip()
                
                # Se encontrou código (não comentário, não vazio), parar
                if line_stripped and not line_stripped.startswith('//') and not line_stripped.startswith('{') and not line_stripped.startswith('}'):
                    # Se não é comentário e não é vazio, parar
                    if not re.match(r'^\s*(type|const|var|uses|unit|interface|implementation)\s*$', line_stripped, re.IGNORECASE):
                        # Se encontrou código antes de encontrar comentário, parar
                        break
                
                # Buscar comentários de linha // que não sejam separadores
                if line_stripped.startswith('//') and not line_stripped.startswith('// =') and not line_stripped.startswith('//='):
                    comment = line_stripped[2:].strip()
                    # Ignorar comentários muito curtos ou vazios
                    if comment and len(comment) > 3:
                        # Ignorar se é apenas separador
                        if not re.match(r'^=+$', comment):
                            # Ignorar comentários genéricos sobre categorias (mas aceitar se mencionar o nome da classe)
                            if (not re.search(r'específicas? por categoria|exceções? específicas?', comment, re.IGNORECASE) or
                                class_name.lower() in comment.lower()):
                                found_comment = comment
                                break  # Usar o primeiro comentário específico encontrado (mais próximo)
            
            if found_comment:
                # Limpar múltiplos espaços
                found_comment = re.sub(r'\s+', ' ', found_comment)
                description = f'<p>{found_comment}</p>'
            else:
                description = f"<p>Classe <code>{class_name}</code>.</p>"
        
        # Extrair métodos públicos e privados
        class_end = content.find('end;', match.end())
        public_methods = []
        private_methods = []
        
        if class_end > 0:
            class_content = content[match.end():class_end]
            
            # Verificar se é uma classe simples (sem corpo, apenas herança)
            # Exemplo: EParametersConnectionException = class(EParametersException);
            simple_class_match = re.match(r'^\s*\([^)]+\)\s*;', class_content.strip())
            if simple_class_match:
                # Classe simples sem métodos - apenas adicionar sem métodos
                pass
            else:
                # Classe com corpo - extrair métodos
                # Buscar seção public
                public_match = re.search(r'\bpublic\b', class_content, re.IGNORECASE)
                if public_match:
                    # Buscar próxima seção (private, protected, end)
                    next_section = re.search(r'\b(private|protected|end)\b', class_content[public_match.end():], re.IGNORECASE)
                    if next_section:
                        public_end = public_match.end() + next_section.start()
                    else:
                        public_end = len(class_content)
                    public_content = class_content[public_match.end():public_end]
                    public_methods = extract_methods_from_pascal_content(public_content)
                
                # Buscar seção private
                private_match = re.search(r'\bprivate\b', class_content, re.IGNORECASE)
                if private_match:
                    # Buscar próxima seção (public, protected, end)
                    next_section = re.search(r'\b(public|protected|end)\b', class_content[private_match.end():], re.IGNORECASE)
                    if next_section:
                        private_end = private_match.end() + next_section.start()
                    else:
                        private_end = len(class_content)
                    private_content = class_content[private_match.end():private_end]
                    private_methods = extract_methods_from_pascal_content(private_content)
        
        classes.append({
            'name': class_name,
            'description': description,
            'publicMethods': public_methods,
            'privateMethods': private_methods
        })
    
    return classes

def process_unit(unit_path):
    """Processa uma unit Pascal e extrai informações"""
    # SRC_DIR já é o caminho absoluto para src/Paramenters
    # unit_path pode ser apenas o nome (ex: "Parameters.pas") ou caminho relativo (ex: "Commons/Parameters.Types.pas")
    full_path = SRC_DIR / unit_path
    
    if not full_path.exists():
        print(f"  [AVISO] Arquivo nao encontrado: {full_path}")
        return None
    
    print(f"Processando: {unit_path}")
    
    # Extrai interfaces
    interfaces = extract_interfaces_from_pascal(str(full_path))
    
    # Extrai classes
    classes = extract_classes_from_pascal(str(full_path))
    
    # Extrai métodos (se não estiverem em interfaces)
    methods = extract_methods_from_pascal(str(full_path))
    
    # Verificar se há exemplos de uso para esta unit
    unit_example = UNITS_EXAMPLES.get(unit_path, '')
    
    # Lê descrição da unit
    with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
        
        # Buscar comentário de bloco que contenha "Descrição" (pode estar antes ou depois de "unit")
        desc_match = re.search(r'\{[^}]*Descrição[^}]*\}', content, re.IGNORECASE | re.DOTALL)
        if desc_match:
            comment_text = desc_match.group(0).strip('{}').strip()
            # Formatar como HTML
            lines = comment_text.split('\n')
            formatted = []
            in_code_block = False
            code_lines = []
            
            for line in lines:
                line_stripped = line.strip()
                if not line_stripped or line_stripped.startswith('='):
                    continue
                
                # Se começa com palavra-chave, fazer negrito
                if re.match(r'^(Descrição|Uso|Author|Version|Date|Finalidade|Retorno|Exemplo):', line_stripped, re.IGNORECASE):
                    # Se estava em bloco de código, fechar
                    if in_code_block:
                        code_text = '\n'.join(code_lines)
                        formatted.append(f'<pre><code>{escape_html(code_text)}</code></pre>')
                        code_lines = []
                        in_code_block = False
                    key, value = line_stripped.split(':', 1) if ':' in line_stripped else (line_stripped, '')
                    formatted.append(f'<p><strong>{key}:</strong> {value.strip()}</p>')
                elif (line_stripped.startswith('uses') or 
                      line_stripped.startswith('var') or 
                      (line_stripped.startswith('Parameters') and ':' in line_stripped) or
                      line_stripped.startswith('.') or
                      line_stripped.endswith(';')):
                    # Código de exemplo - acumular em bloco
                    in_code_block = True
                    code_lines.append(line_stripped)
                else:
                    # Se estava em bloco de código, fechar
                    if in_code_block:
                        code_text = '\n'.join(code_lines)
                        formatted.append(f'<pre><code>{escape_html(code_text)}</code></pre>')
                        code_lines = []
                        in_code_block = False
                    formatted.append(f'<p>{line_stripped}</p>')
            
            # Fechar bloco de código se ainda estiver aberto
            if in_code_block:
                code_text = '\n'.join(code_lines)
                formatted.append(f'<pre><code>{escape_html(code_text)}</code></pre>')
            
            description = '\n'.join(formatted) if formatted else f'<p>{comment_text}</p>'
        else:
            unit_name_from_path = unit_path.split('/')[-1].split('\\')[-1]
            description = f"<p>Unit <code>{unit_name_from_path}</code>.</p>"
    
    # Adicionar exemplos de uso se disponíveis
    if unit_example:
        description += '\n\n' + unit_example
    
    # Extrai nome da unit do caminho
    unit_name = unit_path.split('/')[-1].split('\\')[-1]  # Pega apenas o nome do arquivo
    
    return {
        'id': unit_path.lower().replace('.pas', '').replace('/', '_').replace('\\', '_'),
        'name': unit_name,
        'path': str(full_path.relative_to(BASE_DIR.parent)) if BASE_DIR.parent in full_path.parents else str(full_path),
        'description': description,  # Removido limite de 500 caracteres
        'interfaces': interfaces,
        'classes': classes,  # Incluir classes extraídas
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
    
    # Processa units internas
    print("\nProcessando units internas...")
    for unit_path in INTERNAL_UNITS:
        unit_data = process_unit(unit_path)
        if unit_data:
            units.append(unit_data)
        else:
            print(f"  [AVISO] Nao foi possivel processar: {unit_path}")
    
    # Gera overview (usar conteúdo mesclado de ComoUsar.html)
    overview = {
        'title': 'Visao Geral',
        'path': 'Parameters ORM v1.0.2',
        'description': OVERVIEW_HTML
    }
    
    # Gera usage guide
    # Usar conteúdo importado do arquivo separado
    # Usar conteúdo importado do arquivo separado (roteiro completo)
    usage_guide = {
        'title': 'Roteiro de Uso',
        'path': 'Guia Prático',
        'description': USAGE_GUIDE_HTML
    }
    
    # Coletar todas as interfaces de todas as units públicas
    all_interfaces = []
    for unit in units:
        if any(unit['name'] == pub_name for pub_name in PUBLIC_UNITS):
            if 'interfaces' in unit and unit['interfaces']:
                for iface in unit['interfaces']:
                    all_interfaces.append({
                        'name': iface['name'],
                        'description': iface.get('description', ''),
                        'methods': iface.get('methods', [])
                    })
    
    # Gerar HTML consolidado de todas as interfaces
    interfaces_html = '<h2>Interfaces Consolidadas</h2>'
    interfaces_html += '<p>Documentação completa de todas as interfaces públicas do módulo Parameters, organizadas por interface principal.</p>'
    
    # Objetos principais para cada interface
    interface_objects = {
        'IParameters': 'Parameters',
        'IParametersDatabase': 'DB',
        'IParametersInifiles': 'Ini',
        'IParametersJsonObject': 'Json'
    }
    
    for iface in all_interfaces:
        obj_name = interface_objects.get(iface['name'], 'Obj')
        interfaces_html += f'<div style="margin-bottom: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #3498db;">'
        interfaces_html += f'<h3 style="color: #2c3e50; margin-top: 0;">{iface["name"]}</h3>'
        if iface.get('description'):
            interfaces_html += f'<div style="margin-bottom: 15px; color: #555;">{iface["description"]}</div>'
        
        if iface.get('methods'):
            # Cada método terá seu próprio h4 e seção visual individualizada
            for method in iface['methods']:
                method_example = method.get('example', '')
                if not method_example and method.get('signature'):
                    # Gerar exemplo básico se não tiver
                    method_name = method.get('name', '')
                    if method_name:
                        method_example = f'{obj_name}.{method_name}();'
                
                # Criar h4 individual para cada método (será contado no menu)
                method_name_display = method.get('name', method.get('signature', 'Método'))
                interfaces_html += f'<h4 style="color: #34495e; margin-top: 20px; margin-bottom: 15px;">{escape_html(method_name_display)}</h4>'
                
                # Envolver conteúdo em <p> e <pre> diretamente (sem div wrapper) para que o JavaScript funcione
                # Assinatura do método
                interfaces_html += f'<p style="font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;">{escape_html(method.get("signature", ""))}</p>'
                
                # Comentário
                if method.get('comment'):
                    interfaces_html += f'<p style="color: #555; margin-bottom: 10px; margin-left: 20px;">{escape_html(method["comment"])}</p>'
                
                # Exemplo
                if method_example:
                    interfaces_html += f'<pre style="margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;"><code style="color: #ecf0f1; font-size: 13px;">{escape_html(method_example)}</code></pre>'
        
        interfaces_html += '</div>'
    
    # Gera public units guide
    public_units_guide = {
        'title': 'Units Publicas',
        'path': 'Units Publicas',
        'description': f'''
            <h2>Units Publicas</h2>
            <p>O modulo Parameters expoe apenas 2 units publicas:</p>
            <ul>
                <li><strong>Parameters.pas</strong> - Ponto de entrada (Factory methods + TParametersImpl)</li>
                <li><strong>Parameters.Interfaces.pas</strong> - Interfaces publicas</li>
            </ul>
            
            <div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 20px 0; border-radius: 4px;">
                <div style="color: #856404; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;">⚠️ Regras de Negócio - Versão 1.0.2</div>
                <div style="color: #856404;">
                    <div style="font-size: 1.1em; font-weight: bold; margin-top: 15px; margin-bottom: 10px;">Hierarquia Completa de Identificação</div>
                    <p>Todos os métodos CRUD respeitam a constraint UNIQUE: <code>(ContratoID, ProdutoID, Title, Name)</code></p>
                    <ul>
                        <li><strong>Getter():</strong> Busca específica quando hierarquia configurada, busca ampla quando não configurada</li>
                        <li><strong>Setter():</strong> Sempre requer hierarquia completa. Insere se não existir, atualiza se existir</li>
                        <li><strong>Delete():</strong> Respeita hierarquia completa</li>
                        <li><strong>Exists():</strong> Respeita hierarquia completa</li>
                    </ul>
                    
                    <div style="font-size: 1.1em; font-weight: bold; margin-top: 15px; margin-bottom: 10px;">Nomenclatura de Métodos</div>
                    <ul>
                        <li>Use <code>Getter()</code> em vez de <code>Get()</code> (deprecated)</li>
                        <li>Use <code>Setter()</code> em vez de <code>Update()</code> (deprecated)</li>
                    </ul>
                </div>
            </div>
            
            {interfaces_html}
        '''
    }
    
    # Monta estrutura completa
    docs_data = {
        'overview': overview,
        'usageGuide': usage_guide,
        'publicUnitsGuide': public_units_guide,
        'units': units
    }
    
    # Separa units públicas das internas
    public_units_list = [u for u in units if any(u['name'] == pub_name for pub_name in PUBLIC_UNITS)]
    internal_units_list = [u for u in units if u not in public_units_list]
    
    # Gera JavaScript
    js_content = f'''// Documentacao completa do Parameters ORM v1.0.0
// Gerado automaticamente - Nao editar manualmente

const documentation = {json.dumps(docs_data, indent=4, ensure_ascii=False)};

// IDs das units publicas (para navegacao)
const publicUnitIds = {json.dumps([u['id'] for u in public_units_list], indent=4)};
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
