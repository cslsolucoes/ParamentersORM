# 📝 Prompt para Geração de Documentação Similar

Use este prompt para solicitar a geração de documentação HTML interativa similar à documentação do Database ORM v2.0.

---

## 🎯 Prompt Completo

```
Preciso gerar uma documentação HTML interativa completa para um projeto [NOME_DO_PROJETO] em [LINGUAGEM/TECNOLOGIA].

A documentação deve seguir o mesmo padrão e estrutura da documentação do Database ORM v2.0, com as seguintes características:

## 📋 Estrutura Geral

### 1. Arquivo HTML Principal (index.html)
- Interface moderna com sidebar fixa à esquerda (redimensionável)
- Área de conteúdo principal à direita
- Design responsivo com cores profissionais (#2c3e50, #3498db, etc.)
- Navegação hierárquica com 3 níveis (nível 1, 2 e 3)
- Submenus expansíveis/colapsáveis
- Scroll suave e highlight temporário ao navegar
- Suporte a busca por hash na URL

### 2. Arquivo de Dados (docs-data.js)
- Estrutura JavaScript com objeto `documentation`
- Seções principais:
  - `overview`: Visão geral do projeto com HTML formatado
  - `usageGuide`: Roteiro de uso interno (com exemplos organizados em h3/h4)
  - `publicUnitsGuide`: Roteiro de uso externo/público
  - `units`: Array de units/módulos documentados

### 3. Estrutura de Cada Unit
Cada unit deve conter:
```javascript
{
    id: "identificador-unico",
    name: "Nome.Unit",
    path: "caminho/para/arquivo",
    description: "<p>Descrição HTML formatada</p>",
    interfaces: [
        {
            name: "INomeInterface",
            guid: "{GUID-UNICO}",
            description: "Descrição da interface",
            methods: [
                {
                    signature: "function Metodo: IRetorno;",
                    comment: "Descrição do método",
                    example: "var result := Objeto.Metodo; // Exemplo de uso"
                }
            ],
            properties: [
                {
                    name: "Propriedade",
                    type: "Tipo",
                    comment: "Descrição"
                }
            ]
        }
    ],
    classes: [
        {
            name: "TClasse",
            description: "Descrição da classe",
            publicMethods: [/* mesma estrutura de methods */],
            privateMethods: [/* mesma estrutura de methods */]
        }
    ],
    types: [
        {
            name: "TTipo",
            definition: "type TTipo = ...",
            comment: "Descrição"
        }
    ],
    functions: [/* funções globais */],
    constants: [/* constantes */],
    aliases: [/* aliases de tipos */]
}
```

## 🎨 Características Visuais

### Cores e Estilo
- Background: #f5f5f5
- Sidebar: #2c3e50 (fundo escuro)
- Links ativos: #3498db (azul)
- Cards: branco com sombra sutil
- Código: fundo #2c3e50 com texto #ecf0f1
- Badges: cores diferentes por tipo (público, privado, protegido)

### Navegação Hierárquica
- **Nível 1**: Menu principal (azul #3498db)
- **Nível 2**: Submenu (verde #2ecc71)
- **Nível 3**: Sub-submenu (laranja #e67e22)
- Indicadores visuais (▶) para itens com submenu
- Transições suaves ao expandir/recolher

### Seções de Conteúdo
- Cards brancos com bordas arredondadas
- Títulos com bordas inferiores coloridas
- Métodos agrupados por nome (detecção de overloads)
- Exemplos de código em blocos escuros
- Comentários formatados com indentação

## ⚙️ Funcionalidades JavaScript

### Navegação
- `generateNavigation()`: Gera menu lateral baseado nos dados
- `showSection(sectionId)`: Mostra seção específica
- `scrollToSection(sectionId)`: Rola até seção específica
- `scrollToMethod(methodId, unitId)`: Rola até método específico
- `toggleSubmenu(element)`: Expande/recolhe submenu
- Detecção automática de overloads (múltiplos métodos com mesmo nome)

### Interatividade
- Highlight temporário (2 segundos) ao navegar
- Scroll suave para elementos
- Sidebar redimensionável (arrastar borda)
- Filtragem de conteúdo (mostrar apenas item clicado em roteiros de uso)
- Suporte a hash na URL (#section-id)

### Processamento de Conteúdo
- Extração automática de títulos h3/h4 para navegação
- Agrupamento de métodos por nome
- Geração de IDs únicos para elementos
- Escape de HTML para segurança

## 📚 Estrutura de Dados Esperada

### Overview
```javascript
overview: {
    title: "Visão Geral",
    path: "Nome do Projeto",
    description: `
        <div style="...">HTML formatado com:
        - Gradientes e cores
        - Cards informativos
        - Listas de funcionalidades
        - Grids responsivos
        - Seções organizadas
        </div>
    `
}
```

### Usage Guide
```javascript
usageGuide: {
    description: `
        <h3>Seção Principal</h3>
        <h4>Exemplo Específico</h4>
        <p>Descrição do exemplo...</p>
        <pre><code>código de exemplo</code></pre>
    `
}
```

### Units
Array de objetos unit com interfaces, classes, métodos, etc.

## 🔧 Scripts de Geração (Opcional)

Se necessário, criar scripts auxiliares:
- **Python**: `generate_complete_docs.py` - Extrai métodos de arquivos fonte
- **JavaScript**: `generate-docs.js` - Processa e gera dados
- **Python**: `update-docs-with-examples.py` - Adiciona exemplos aos métodos

## 📝 Requisitos Específicos

1. **Responsividade**: Funcionar em desktop e mobile
2. **Performance**: Carregamento rápido, dados em arquivo separado
3. **Acessibilidade**: Navegação por teclado, contraste adequado
4. **Manutenibilidade**: Código organizado e comentado
5. **Extensibilidade**: Fácil adicionar novas units/seções

## 🎯 Exemplo de Uso

Após gerar a documentação, o usuário deve poder:
1. Abrir `index.html` no navegador
2. Navegar pela sidebar
3. Ver conteúdo formatado na área principal
4. Clicar em métodos para ver detalhes
5. Expandir/recolher seções
6. Usar hash na URL para links diretos

## 📦 Entregáveis Esperados

1. `index.html` - Arquivo HTML completo e funcional
2. `docs-data.js` - Dados da documentação em JavaScript
3. (Opcional) Scripts de geração/atualização
4. (Opcional) README com instruções de uso

## 🔍 Detalhes Técnicos Importantes

- **IDs únicos**: Gerar IDs normalizados (lowercase, hífens)
- **Overloads**: Detectar e agrupar métodos com mesmo nome
- **Hierarquia**: Respeitar estrutura de 3 níveis de navegação
- **Scroll**: Offset de 100px do topo ao navegar
- **Cache**: Não usar cache para dados (sempre recarregar)
- **CORS**: Funcionar via file:// ou servidor HTTP

---

Por favor, gere a documentação completa seguindo exatamente este padrão, adaptando para o contexto do projeto [NOME_DO_PROJETO].
```

---

## 📌 Como Usar Este Prompt

1. **Substitua os placeholders**:
   - `[NOME_DO_PROJETO]` → Nome do seu projeto
   - `[LINGUAGEM/TECNOLOGIA]` → Linguagem/tecnologia usada

2. **Adicione informações específicas**:
   - Estrutura de arquivos do projeto
   - Convenções de nomenclatura
   - Padrões de código específicos
   - Funcionalidades únicas

3. **Forneça contexto adicional**:
   - Arquivos fonte para análise
   - Exemplos de código existente
   - Documentação parcial (se houver)
   - Requisitos específicos de estilo

4. **Especifique prioridades**:
   - Quais units/módulos documentar primeiro
   - Seções mais importantes
   - Funcionalidades críticas

---

## 🎨 Personalizações Possíveis

### Cores do Tema
```javascript
// Substitua no CSS do index.html
const theme = {
    primary: '#3498db',      // Azul principal
    secondary: '#2ecc71',    // Verde secundário
    accent: '#e67e22',       // Laranja de destaque
    dark: '#2c3e50',        // Fundo escuro
    light: '#ecf0f1',        // Fundo claro
    text: '#333'             // Texto principal
};
```

### Estrutura de Navegação
- Adicione mais níveis se necessário
- Modifique cores por nível
- Ajuste padding/indentação

### Funcionalidades Extras
- Busca/filtro de conteúdo
- Exportação para PDF
- Modo escuro/claro
- Impressão otimizada

---

## 📚 Referências

Para entender melhor a estrutura, consulte:
- `index.html` - Interface HTML completa
- `docs-data.js` - Estrutura de dados
- `generate_complete_docs.py` - Script de extração
- `update-docs-with-examples.py` - Script de exemplos

---

**Última Atualização:** 27/01/2025  
**Versão do Prompt:** 1.0
