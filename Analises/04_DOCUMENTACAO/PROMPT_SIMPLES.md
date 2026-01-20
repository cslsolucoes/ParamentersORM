# 🚀 Prompt Simples para Gerar Documentação

## Versão Curta (Copiar e Colar)

```
Gere uma documentação HTML interativa completa para [NOME_DO_PROJETO] seguindo o padrão da documentação do Database ORM v2.0.

A documentação deve ter:

1. **index.html** com:
   - Sidebar fixa à esquerda (redimensionável) com navegação hierárquica de 3 níveis
   - Área de conteúdo principal à direita
   - Design moderno (cores: #2c3e50, #3498db, #2ecc71, #e67e22)
   - Scroll suave, highlight temporário, submenus expansíveis

2. **docs-data.js** com estrutura:
```javascript
const documentation = {
    overview: {
        title: "Visão Geral",
        path: "Nome do Projeto",
        description: "HTML formatado com cards, grids, listas..."
    },
    usageGuide: {
        description: "HTML com h3 (seções) e h4 (exemplos)"
    },
    publicUnitsGuide: {
        description: "HTML com exemplos de uso público"
    },
    units: [
        {
            id: "identificador",
            name: "Nome.Unit",
            path: "caminho/arquivo",
            description: "Descrição HTML",
            interfaces: [{
                name: "INome",
                guid: "{GUID}",
                description: "Descrição",
                methods: [{
                    signature: "function Metodo: IRetorno;",
                    comment: "Descrição",
                    example: "var result := Objeto.Metodo; // Exemplo"
                }]
            }],
            classes: [/* mesma estrutura */]
        }
    ]
};
```

3. **Funcionalidades JavaScript**:
   - Navegação hierárquica com 3 níveis
   - Detecção automática de overloads (agrupar métodos com mesmo nome)
   - Scroll suave até seções/métodos
   - Filtragem de conteúdo em roteiros de uso
   - Sidebar redimensionável
   - Suporte a hash na URL

4. **Estilo Visual**:
   - Cards brancos com sombras
   - Código em blocos escuros (#2c3e50)
   - Badges coloridos por tipo
   - Grids responsivos
   - Transições suaves

Adapte para o contexto do projeto [NOME_DO_PROJETO] e gere os arquivos completos.
```

---

## Versão Detalhada (Para Mais Contexto)

Use o arquivo `PROMPT_GERACAO_DOCUMENTACAO.md` para uma versão completa com todos os detalhes técnicos.

---

## 🎯 Exemplo de Uso Rápido

1. Copie o prompt acima
2. Substitua `[NOME_DO_PROJETO]` pelo nome do seu projeto
3. Adicione informações específicas sobre:
   - Estrutura de arquivos
   - Convenções de código
   - Funcionalidades principais
4. Cole no assistente de IA
5. Revise e ajuste conforme necessário

---

**Dica:** Para projetos grandes, gere a documentação por partes (uma unit por vez) e depois consolide.
