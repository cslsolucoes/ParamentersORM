# Exemplo: Listar Parâmetros do Banco de Dados

Este exemplo demonstra como usar o módulo Parameters para listar todos os parâmetros de um banco de dados SQLite.

## 📋 Descrição

O programa `ExemploListarParametros.pas`:
1. Conecta ao banco SQLite (`E:\Pacote\ORM\Data\Config.db`)
2. Lista todos os parâmetros ativos
3. Exibe informações detalhadas de cada parâmetro no console

## 🚀 Como Usar

### Pré-requisitos

1. O arquivo `Config.db` deve existir em `E:\Pacote\ORM\Data\`
2. O banco deve ter uma tabela chamada `config` com a estrutura padrão
3. O projeto deve ter acesso às units do módulo Parameters

### Executar o Exemplo

1. Abra o projeto no Delphi/FreePascal
2. Compile o projeto
3. Execute o programa
4. O console exibirá todos os parâmetros encontrados

## 📝 Estrutura do Código

### Configuração da Conexão

```pascal
DB := TParameters.NewDatabase;
DB.DatabaseType('SQLite')
  .Database('E:\Pacote\ORM\Data\Config.db')
  .TableName('config')
  .AutoCreateTable(False);
```

### Conexão

```pascal
DB.Connect(LSuccess);
if not LSuccess then
  // Tratar erro
```

### Listagem de Parâmetros

```pascal
ParamList := DB.List;
try
  for I := 0 to ParamList.Count - 1 do
  begin
    Param := ParamList[I];
    // Usar parâmetro...
  end;
finally
  ParamList.ClearAll;
  ParamList.Free;
end;
```

## ⚙️ Personalização

### Alterar Caminho do Banco

Edite a linha 42:
```pascal
LDatabasePath := 'E:\Pacote\ORM\Data\Config.db';
```

### Alterar Nome da Tabela

Edite a linha 55:
```pascal
.TableName('config')  // Altere para o nome da sua tabela
```

### Filtrar por ContratoID ou ProdutoID

Adicione antes de listar:
```pascal
DB.ContratoID(1);  // Filtra por ContratoID = 1
DB.ProdutoID(1);   // Filtra por ProdutoID = 1
```

## 📊 Informações Exibidas

Para cada parâmetro, o exemplo exibe:
- **ID**: Identificador único
- **Nome**: Chave do parâmetro
- **Valor**: Valor do parâmetro
- **Tipo**: Tipo do valor (String, Integer, Float, Boolean, DateTime, JSON)
- **Descrição**: Descrição/documentação
- **ContratoID**: ID do contrato associado
- **ProdutoID**: ID do produto associado
- **Ordem**: Ordem de exibição
- **Título**: Categoria do parâmetro
- **Ativo**: Status ativo/inativo
- **Criado em**: Data de criação
- **Atualizado em**: Data de atualização

## ⚠️ Observações Importantes

1. **Liberação de Memória**: Sempre use `ParamList.ClearAll` e `ParamList.Free` após usar a lista
2. **Tratamento de Erros**: O exemplo inclui tratamento de exceções básico
3. **Conexão**: Sempre desconecte do banco com `DB.Disconnect` ao finalizar

## 🔧 Troubleshooting

### Erro: "Não foi possível conectar ao banco de dados"
- Verifique se o arquivo `Config.db` existe
- Verifique se o caminho está correto
- Verifique permissões de acesso ao arquivo

### Erro: "Nenhum parâmetro encontrado"
- Verifique se a tabela `config` existe no banco
- Verifique se há parâmetros com `ativo = 1` (ou `true`)
- Verifique os filtros de ContratoID e ProdutoID

### Erro de Compilação: Unit não encontrada
- Verifique se o caminho das units está configurado no projeto
- Verifique se todas as dependências estão disponíveis

## 📚 Referências

- `Parameters.pas`: Ponto de entrada público
- `Parameters.Interfaces.pas`: Interfaces e tipos públicos
- `Parameters.Consts.pas`: Constantes (ParameterValueTypeNames)
