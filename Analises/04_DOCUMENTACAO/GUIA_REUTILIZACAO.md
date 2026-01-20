# 🔄 Guia de Reutilização da Documentação

## ✅ Sim, você pode usar em qualquer projeto!

A estrutura de documentação do Database ORM v2.0 é **100% reutilizável** e pode ser adaptada para qualquer projeto, independente da linguagem ou tecnologia.

---

## 🚀 Como Adaptar para Outro Projeto

### Passo 1: Copiar Arquivos Base

Copie os seguintes arquivos para o seu novo projeto:

```
SeuProjeto/
├── Docs/
│   ├── index.html          # Interface HTML (pode usar como está)
│   ├── docs-data.js        # Dados (precisa adaptar)
│   └── (scripts opcionais)
```

### Passo 2: Adaptar `docs-data.js`

#### 2.1. Alterar Informações do Projeto

```javascript
const documentation = {
    overview: {
        title: "Visão Geral",
        path: "SEU PROJETO v1.0",  // ← Alterar aqui
        description: `
            <div style="...">
                <h2>SEU PROJETO</h2>  <!-- ← Alterar aqui -->
                <p>Descrição do seu projeto...</p>
            </div>
        `
    },
    // ... resto da estrutura
};
```

#### 2.2. Adaptar Estrutura de Units

A estrutura de `units` é genérica e funciona para qualquer linguagem:

**Para projetos Pascal/Delphi:**
```javascript
units: [
    {
        id: "minha-unit",
        name: "MinhaUnit",
        path: "src/MinhaUnit.pas",
        interfaces: [...],
        classes: [...]
    }
]
```

**Para projetos JavaScript/TypeScript:**
```javascript
units: [
    {
        id: "meu-modulo",
        name: "meuModulo",
        path: "src/meuModulo.ts",
        interfaces: [...],  // ou "types" para TypeScript
        classes: [...],      // ou "functions" para JS
        exports: [...]       // adicione campos conforme necessário
    }
]
```

**Para projetos Python:**
```javascript
units: [
    {
        id: "meu-modulo",
        name: "meu_modulo",
        path: "src/meu_modulo.py",
        classes: [...],
        functions: [...],
        constants: [...]
    }
]
```

**Para projetos C#/.NET:**
```javascript
units: [
    {
        id: "meu-namespace",
        name: "MeuNamespace",
        path: "src/MeuNamespace.cs",
        interfaces: [...],
        classes: [...],
        enums: [...]  // adicione conforme necessário
    }
]
```

### Passo 3: Personalizar Cores e Estilo (Opcional)

No `index.html`, você pode alterar as cores do tema:

```css
/* Cores padrão */
--primary: #3498db;      /* Azul */
--secondary: #2ecc71;     /* Verde */
--accent: #e67e22;        /* Laranja */
--dark: #2c3e50;         /* Escuro */
--light: #ecf0f1;         /* Claro */

/* Personalize para seu projeto */
--primary: #9b59b6;      /* Roxo */
--secondary: #1abc9c;    /* Turquesa */
--accent: #f39c12;       /* Amarelo */
```

### Passo 4: Adaptar Nomenclatura (Opcional)

Se sua linguagem usa termos diferentes:

- **Pascal**: `units`, `interfaces`, `classes`
- **JavaScript**: `modules`, `types`, `functions`
- **Python**: `modules`, `classes`, `functions`
- **C#**: `namespaces`, `interfaces`, `classes`

Você pode renomear as seções no HTML:

```javascript
// Em index.html, altere os títulos:
'<h2 class="section-title">Interfaces</h2>'  // Pascal
'<h2 class="section-title">Types</h2>'        // TypeScript
'<h2 class="section-title">Classes</h2>'      // Genérico
```

---

## 📋 Checklist de Adaptação

- [ ] Copiar `index.html` e `docs-data.js`
- [ ] Alterar título e descrição do projeto em `overview`
- [ ] Adaptar estrutura de `units` para sua linguagem
- [ ] Preencher dados reais do seu projeto
- [ ] (Opcional) Personalizar cores
- [ ] (Opcional) Renomear seções conforme linguagem
- [ ] Testar navegação e funcionalidades
- [ ] Adicionar exemplos específicos do seu projeto

---

## 🎯 Exemplos de Adaptação

### Exemplo 1: Projeto JavaScript/TypeScript

```javascript
const documentation = {
    overview: {
        title: "Visão Geral",
        path: "MyLibrary v2.0",
        description: `<h2>MyLibrary</h2><p>Biblioteca JavaScript moderna...</p>`
    },
    units: [
        {
            id: "utils",
            name: "utils",
            path: "src/utils.ts",
            description: "<p>Utilitários gerais</p>",
            functions: [
                {
                    signature: "function formatDate(date: Date): string;",
                    comment: "Formata data para string",
                    example: "const formatted = formatDate(new Date());"
                }
            ],
            classes: [
                {
                    name: "DateHelper",
                    description: "Helper para manipulação de datas",
                    publicMethods: [...]
                }
            ]
        }
    ]
};
```

### Exemplo 2: Projeto Python

```javascript
const documentation = {
    overview: {
        title: "Visão Geral",
        path: "MyPythonLib v1.0",
        description: `<h2>MyPythonLib</h2><p>Biblioteca Python...</p>`
    },
    units: [
        {
            id: "helpers",
            name: "helpers",
            path: "src/helpers.py",
            description: "<p>Funções auxiliares</p>",
            functions: [
                {
                    signature: "def format_date(date: datetime) -> str:",
                    comment: "Formata data para string",
                    example: "formatted = format_date(datetime.now())"
                }
            ],
            classes: [
                {
                    name: "DateHelper",
                    description: "Helper para manipulação de datas",
                    publicMethods: [...]
                }
            ]
        }
    ]
};
```

### Exemplo 3: Projeto C#

```javascript
const documentation = {
    overview: {
        title: "Visão Geral",
        path: "MyCSharpLib v3.0",
        description: `<h2>MyCSharpLib</h2><p>Biblioteca C#...</p>`
    },
    units: [
        {
            id: "helpers",
            name: "MyCSharpLib.Helpers",
            path: "src/Helpers.cs",
            description: "<p>Classes auxiliares</p>",
            interfaces: [
                {
                    name: "IDateHelper",
                    description: "Interface para manipulação de datas",
                    methods: [...]
                }
            ],
            classes: [
                {
                    name: "DateHelper",
                    description: "Implementação de IDateHelper",
                    publicMethods: [...]
                }
            ]
        }
    ]
};
```

---

## 🔧 Scripts de Geração (Opcional)

Se quiser gerar a documentação automaticamente, adapte os scripts:

### Para JavaScript/TypeScript:
```javascript
// generate-docs.js
const fs = require('fs');
const path = require('path');

// Ler arquivos .ts ou .js
function extractFromTypeScript(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    // Extrair classes, interfaces, funções
    // ...
}
```

### Para Python:
```python
# generate-docs.py
import ast
import json

def extract_from_python(file_path):
    with open(file_path, 'r') as f:
        tree = ast.parse(f.read())
    # Extrair classes, funções
    # ...
```

### Para C#:
```csharp
// generate-docs.cs
using System.Reflection;

// Usar Reflection para extrair tipos, métodos
// ...
```

---

## 💡 Dicas de Adaptação

### 1. Mantenha a Estrutura Base
A estrutura HTML e JavaScript funciona para qualquer projeto. Não precisa alterar.

### 2. Adapte Apenas os Dados
Foque em preencher `docs-data.js` com os dados reais do seu projeto.

### 3. Use Scripts de Extração
Crie scripts para extrair automaticamente informações dos arquivos fonte.

### 4. Personalize Visualmente
Altere cores, logos, favicons conforme a identidade do seu projeto.

### 5. Adicione Seções Específicas
Se seu projeto tem conceitos únicos, adicione novas seções:
```javascript
documentation = {
    overview: {...},
    usageGuide: {...},
    apiReference: {...},      // Nova seção
    examples: {...},           // Nova seção
    units: [...]
};
```

---

## 🎨 Personalização Avançada

### Adicionar Logo
```html
<!-- No index.html, dentro de .sidebar-header -->
<img src="logo.png" alt="Logo" style="max-width: 200px; margin-bottom: 10px;">
```

### Adicionar Busca
```javascript
// Adicionar campo de busca na sidebar
function addSearch() {
    const searchHTML = `
        <div style="padding: 10px 20px;">
            <input type="text" id="searchInput" placeholder="Buscar..." 
                   style="width: 100%; padding: 8px; border-radius: 4px;">
        </div>
    `;
    // Implementar lógica de busca
}
```

### Adicionar Modo Escuro
```javascript
// Adicionar toggle de tema
function toggleTheme() {
    document.body.classList.toggle('dark-theme');
}
```

---

## ✅ Vantagens da Reutilização

1. **Economia de Tempo**: Não precisa criar do zero
2. **Consistência**: Mesma estrutura em todos os projetos
3. **Profissionalismo**: Interface moderna e polida
4. **Manutenibilidade**: Código já testado e funcional
5. **Extensibilidade**: Fácil adicionar novas funcionalidades

---

## 📚 Recursos Adicionais

- **Prompt Completo**: `PROMPT_GERACAO_DOCUMENTACAO.md`
- **Prompt Simples**: `PROMPT_SIMPLES.md`
- **Exemplo Original**: `index.html` e `docs-data.js`

---

## 🆘 Problemas Comuns

### Problema: Navegação não funciona
**Solução**: Verifique se `docs-data.js` está no mesmo diretório e se o objeto `documentation` está definido.

### Problema: Estilos quebrados
**Solução**: Verifique se todos os estilos CSS estão no `<style>` do `index.html`.

### Problema: IDs duplicados
**Solução**: Certifique-se de que os `id` das units são únicos.

### Problema: Scroll não funciona
**Solução**: Verifique se os IDs dos elementos correspondem aos links de navegação.

---

**Última Atualização:** 27/01/2025  
**Versão:** 1.0
