# -*- coding: utf-8 -*-
"""
Exemplos práticos de uso para Units Internas
"""

# Dicionário com exemplos de uso por unit
UNITS_EXAMPLES = {
    'Commons/Parameters.Types.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Types - Tipos Base do Sistema</h3>
    <p><strong>Finalidade:</strong> Define todos os tipos base usados no módulo Parameters (TParameter, TParameterList, enums, etc.)</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 1: Criar e Usar TParameter</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Types;

var
  Param: TParameter;
begin
  // Criar nova instância
  Param := TParameter.Create;
  try
    // Preencher propriedades
    Param.ID := 0;                    // Auto-incremento
    Param.Name := 'api_timeout';      // Chave
    Param.Value := '30000';           // Valor (string)
    Param.ValueType := pvtInteger;    // Tipo
    Param.Description := 'Timeout da API em milissegundos';
    Param.ContratoID := 1;            // Filtro de contrato
    Param.ProdutoID := 1;             // Filtro de produto
    Param.Ordem := 10;                // Ordem de exibição
    Param.Titulo := 'API';            // Título/Seção
    Param.Ativo := True;              // Ativo
    Param.CreatedAt := Now;           // Data de criação
    Param.UpdatedAt := Now;           // Data de atualização
    
    WriteLn('Parâmetro criado: ', Param.Name);
  finally
    Param.Free;
  end;
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 2: Usar TParameterList</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Types;

var
  ParamList: TParameterList;
  Param: TParameter;
  I: Integer;
begin
  // Criar lista
  ParamList := TParameterList.Create;
  try
    // Adicionar parâmetros
    Param := TParameter.Create;
    Param.Name := 'param1';
    Param.Value := 'value1';
    ParamList.Add(Param);
    
    Param := TParameter.Create;
    Param.Name := 'param2';
    Param.Value := 'value2';
    ParamList.Add(Param);
    
    // Iterar pela lista
    for I := 0 to ParamList.Count - 1 do
      WriteLn(ParamList[I].Name, ' = ', ParamList[I].Value);
    
    // Limpar tudo (libera objetos automaticamente)
    ParamList.ClearAll;
  finally
    ParamList.Free;
  end;
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 3: Usar Enums de Tipo</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Types;

var
  Param: TParameter;
  ValueType: TParameterValueType;
begin
  Param := TParameter.Create;
  try
    // String
    Param.ValueType := pvtString;
    Param.Value := 'localhost';
    
    // Integer
    Param.ValueType := pvtInteger;
    Param.Value := '5432';
    
    // Float
    Param.ValueType := pvtFloat;
    Param.Value := '3.14';
    
    // Boolean
    Param.ValueType := pvtBoolean;
    Param.Value := 'True';
    
    // DateTime
    Param.ValueType := pvtDateTime;
    Param.Value := DateTimeToStr(Now);
    
    // JSON
    Param.ValueType := pvtJSON;
    Param.Value := '{"host":"localhost","port":5432}';
  finally
    Param.Free;
  end;
end;</code></pre>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;">
    <strong>⚠️ IMPORTANTE:</strong> TParameterList.ClearAll libera TODOS os objetos TParameter da lista antes de limpar. Use Free apenas na própria lista.
</div>
''',

    'Commons/Parameters.Consts.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Consts - Constantes do Sistema</h3>
    <p><strong>Finalidade:</strong> Define todas as constantes padrão usadas no módulo (nomes de tabela, campos, SQL, mensagens, etc.)</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 1: Usar Constantes de Tabela</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Consts,
  Parameters;

var
  DB: IParametersDatabase;
begin
  DB := TParameters.NewDatabase;
  
  // Usar constantes padrão
  DB.TableName(DEFAULT_TABLE_NAME)        // 'parameters'
    .Schema(DEFAULT_SCHEMA)               // 'public'
    .Connect;
  
  WriteLn('Conectado à tabela: ', DEFAULT_TABLE_NAME);
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 2: Usar Constantes de Campo</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Consts;

begin
  // Nomes de campos (útil para queries personalizadas)
  WriteLn('ID Field: ', FIELD_ID);                    // 'id'
  WriteLn('Name Field: ', FIELD_NAME);                // 'name'
  WriteLn('Value Field: ', FIELD_VALUE);              // 'value'
  WriteLn('ValueType Field: ', FIELD_VALUE_TYPE);     // 'value_type'
  WriteLn('Description Field: ', FIELD_DESCRIPTION);  // 'description'
  WriteLn('ContratoID Field: ', FIELD_CONTRATO_ID);   // 'contrato_id'
  WriteLn('ProdutoID Field: ', FIELD_PRODUTO_ID);     // 'produto_id'
  WriteLn('Titulo Field: ', FIELD_TITULO);            // 'titulo'
  WriteLn('Ordem Field: ', FIELD_ORDEM);              // 'ordem'
  WriteLn('Ativo Field: ', FIELD_ATIVO);              // 'ativo'
  WriteLn('CreatedAt Field: ', FIELD_CREATED_AT);     // 'created_at'
  WriteLn('UpdatedAt Field: ', FIELD_UPDATED_AT);     // 'updated_at'
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 3: Usar Mensagens Padrão</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Consts;

begin
  // Mensagens de erro padrão
  WriteLn(MSG_ERROR_CONNECTION);          // 'Erro ao conectar ao banco de dados'
  WriteLn(MSG_ERROR_NOT_CONNECTED);       // 'Não conectado ao banco de dados'
  WriteLn(MSG_ERROR_PARAMETER_NOT_FOUND); // 'Parâmetro não encontrado'
  WriteLn(MSG_ERROR_INVALID_VALUE);       // 'Valor inválido'
  
  // Mensagens de sucesso
  WriteLn(MSG_SUCCESS_INSERT);            // 'Parâmetro inserido com sucesso'
  WriteLn(MSG_SUCCESS_UPDATE);            // 'Parâmetro atualizado com sucesso'
  WriteLn(MSG_SUCCESS_DELETE);            // 'Parâmetro deletado com sucesso'
end;</code></pre>

<div style="background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;">
    <strong>💡 DICA:</strong> Use as constantes em vez de hardcoded strings para facilitar manutenção e evitar erros de digitação.
</div>
''',

    'Commons/Parameters.Exceptions.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Exceptions - Sistema de Exceções</h3>
    <p><strong>Finalidade:</strong> Define todas as exceções customizadas do módulo com códigos de erro e mensagens detalhadas</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 1: Capturar Exceções Específicas</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters,
  Parameters.Exceptions;

var
  DB: IParametersDatabase;
  Param: TParameter;
begin
  try
    DB := TParameters.NewDatabase;
    DB.DatabaseType('PostgreSQL')
      .Host('localhost')
      .Port(5432)
      .Database('mydb')
      .Username('user')
      .Password('pass')
      .Connect;
      
    Param := DB.Getter('config_key');
    
  except
    // Erro de conexão
    on E: EParameterDatabaseConnectionError do
      WriteLn('Erro de conexão: ', E.Message, ' [Código: ', E.ErrorCode, ']');
      
    // Parâmetro não encontrado
    on E: EParameterNotFoundError do
      WriteLn('Parâmetro não encontrado: ', E.Message);
      
    // Valor inválido
    on E: EParameterValidationError do
      WriteLn('Validação falhou: ', E.Message);
      
    // Erro genérico
    on E: EParameterError do
      WriteLn('Erro: ', E.Message, ' [Código: ', E.ErrorCode, ']');
  end;
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 2: Lançar Exceções Customizadas</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Exceptions;

procedure ValidateParameter(const AValue: string);
begin
  if Trim(AValue) = '' then
    raise EParameterValidationError.Create('Valor não pode ser vazio', 1001);
    
  if Length(AValue) > 255 then
    raise EParameterValidationError.Create('Valor muito longo (máx 255 caracteres)', 1002);
end;

var
  Value: string;
begin
  try
    Value := '';
    ValidateParameter(Value);
  except
    on E: EParameterValidationError do
      WriteLn('Validação falhou: ', E.Message, ' [Código: ', E.ErrorCode, ']');
  end;
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">📊 Hierarquia de Exceções</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>EParameterError (Base)
├── EParameterDatabaseError
│   ├── EParameterDatabaseConnectionError
│   ├── EParameterDatabaseQueryError
│   └── EParameterDatabaseTableError
├── EParameterInifileError
│   ├── EParameterInifileNotFoundError
│   └── EParameterInifileParseError
├── EParameterJsonObjectError
│   └── EParameterJsonParseError
├── EParameterNotFoundError
├── EParameterValidationError
└── EParameterConfigError</code></pre>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;">
    <strong>⚠️ IMPORTANTE:</strong> Todas as exceções herdam de EParameterError e têm propriedades Message e ErrorCode.
</div>
''',

    'Database/Parameters.Database.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Database - Implementação Database</h3>
    <p><strong>Finalidade:</strong> Implementação completa de IParametersDatabase com suporte a UniDAC, FireDAC e Zeos</p>
    <p><strong>⚠️ NÃO USE DIRETAMENTE!</strong> Use sempre TParameters.NewDatabase</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">✅ USO CORRETO (Factory Method)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;  // ✅ CORRETO - Use apenas Parameters.pas

var
  DB: IParametersDatabase;
begin
  // ✅ Criar via Factory Method
  DB := TParameters.NewDatabase;
  
  DB.DatabaseType('PostgreSQL')
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('pass')
    .TableName('config')
    .Schema('public')
    .AutoCreateTable(True)
    .Connect;
    
  // Usar normalmente...
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">❌ USO INCORRETO (Direto)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Database;  // ❌ ERRADO - NÃO use units internas!

var
  DB: TParametersDatabase;  // ❌ Classe interna
begin
  // ❌ NÃO faça isso!
  DB := TParametersDatabase.Create;
  // ...
end;</code></pre>

<div style="background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;">
    <strong>🚫 AVISO:</strong> Esta unit é INTERNA. Suas classes e métodos podem mudar sem aviso. Use SEMPRE os Factory Methods de TParameters!
</div>

<h4 style="color: #34495e; margin-top: 25px;">📚 Documentação Completa</h4>
<p>Para documentação completa de métodos, veja <strong>Roteiro de Uso → Externo → IParametersDatabase</strong></p>
''',

    'IniFiles/Parameters.Inifiles.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Inifiles - Implementação INI Files</h3>
    <p><strong>Finalidade:</strong> Implementação completa de IParametersInifiles para arquivos INI</p>
    <p><strong>⚠️ NÃO USE DIRETAMENTE!</strong> Use sempre TParameters.NewInifiles</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">✅ USO CORRETO (Factory Method)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;  // ✅ CORRETO - Use apenas Parameters.pas

var
  Ini: IParametersInifiles;
begin
  // ✅ Criar via Factory Method
  Ini := TParameters.NewInifiles;
  
  Ini.FilePath('C:\\Config\\params.ini')
     .Section('ERP')
     .AutoCreateFile(True)
     .ContratoID(1)
     .ProdutoID(1);
     
  // Usar normalmente...
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">❌ USO INCORRETO (Direto)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Inifiles;  // ❌ ERRADO - NÃO use units internas!

var
  Ini: TParametersInifiles;  // ❌ Classe interna
begin
  // ❌ NÃO faça isso!
  Ini := TParametersInifiles.Create;
  // ...
end;</code></pre>

<div style="background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;">
    <strong>🚫 AVISO:</strong> Esta unit é INTERNA. Suas classes e métodos podem mudar sem aviso. Use SEMPRE os Factory Methods de TParameters!
</div>

<h4 style="color: #34495e; margin-top: 25px;">📚 Documentação Completa</h4>
<p>Para documentação completa de métodos, veja <strong>Roteiro de Uso → Externo → IParametersInifiles</strong></p>
''',

    'JsonObject/Parameters.JsonObject.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.JsonObject - Implementação JSON Objects</h3>
    <p><strong>Finalidade:</strong> Implementação completa de IParametersJsonObject para objetos JSON</p>
    <p><strong>⚠️ NÃO USE DIRETAMENTE!</strong> Use sempre TParameters.NewJsonObject</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">✅ USO CORRETO (Factory Method)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;  // ✅ CORRETO - Use apenas Parameters.pas

var
  Json: IParametersJsonObject;
begin
  // ✅ Criar via Factory Method
  Json := TParameters.NewJsonObject;
  
  Json.FilePath('C:\\Config\\params.json')
      .ObjectName('ERP')
      .AutoCreateFile(True)
      .ContratoID(1)
      .ProdutoID(1);
      
  // Usar normalmente...
end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">❌ USO INCORRETO (Direto)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.JsonObject;  // ❌ ERRADO - NÃO use units internas!

var
  Json: TParametersJsonObject;  // ❌ Classe interna
begin
  // ❌ NÃO faça isso!
  Json := TParametersJsonObject.Create;
  // ...
end;</code></pre>

<div style="background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;">
    <strong>🚫 AVISO:</strong> Esta unit é INTERNA. Suas classes e métodos podem mudar sem aviso. Use SEMPRE os Factory Methods de TParameters!
</div>

<h4 style="color: #34495e; margin-top: 25px;">📚 Documentação Completa</h4>
<p>Para documentação completa de métodos, veja <strong>Roteiro de Uso → Externo → IParametersJsonObject</strong></p>
''',

    'Attributes/Parameters.Attributes.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Attributes - Sistema de Attributes</h3>
    <p><strong>Finalidade:</strong> Define todos os attributes para decorar classes de parâmetros com metadados</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 1: Attribute de Tabela</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Attributes;

type
  [Table('config', 'public')]
  TConfigParameter = class(TObject)
  private
    [PrimaryKey]
    [AutoIncrement]
    FID: Integer;
    
    [Column('name')]
    [Required]
    FName: string;
    
    [Column('value')]
    FValue: string;
    
  public
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
  end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo 2: Attributes de Validação</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Attributes;

type
  TUserParameter = class(TObject)
  private
    [Column('email')]
    [Required]
    [Email]
    FEmail: string;
    
    [Column('age')]
    [Range(18, 120)]
    FAge: Integer;
    
    [Column('username')]
    [Required]
    [MaxLength(50)]
    FUsername: string;
    
  public
    property Email: string read FEmail write FEmail;
    property Age: Integer read FAge write FAge;
    property Username: string read FUsername write FUsername;
  end;</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">📊 Attributes Disponíveis</h4>
<table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
    <thead>
        <tr style="background: #3498db; color: white;">
            <th style="padding: 12px; border: 1px solid #ddd;">Categoria</th>
            <th style="padding: 12px; border: 1px solid #ddd;">Attribute</th>
            <th style="padding: 12px; border: 1px solid #ddd;">Descrição</th>
        </tr>
    </thead>
    <tbody>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Tabela</td><td style="padding: 12px; border: 1px solid #ddd;">[Table]</td><td style="padding: 12px; border: 1px solid #ddd;">Nome da tabela e schema</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Coluna</td><td style="padding: 12px; border: 1px solid #ddd;">[Column]</td><td style="padding: 12px; border: 1px solid #ddd;">Nome da coluna</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Chave</td><td style="padding: 12px; border: 1px solid #ddd;">[PrimaryKey]</td><td style="padding: 12px; border: 1px solid #ddd;">Chave primária</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Auto</td><td style="padding: 12px; border: 1px solid #ddd;">[AutoIncrement]</td><td style="padding: 12px; border: 1px solid #ddd;">Auto-incremento</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Validação</td><td style="padding: 12px; border: 1px solid #ddd;">[Required]</td><td style="padding: 12px; border: 1px solid #ddd;">Campo obrigatório</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Validação</td><td style="padding: 12px; border: 1px solid #ddd;">[MaxLength]</td><td style="padding: 12px; border: 1px solid #ddd;">Tamanho máximo</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Validação</td><td style="padding: 12px; border: 1px solid #ddd;">[Range]</td><td style="padding: 12px; border: 1px solid #ddd;">Faixa de valores</td></tr>
        <tr><td style="padding: 12px; border: 1px solid #ddd;">Validação</td><td style="padding: 12px; border: 1px solid #ddd;">[Email]</td><td style="padding: 12px; border: 1px solid #ddd;">Email válido</td></tr>
    </tbody>
</table>

<div style="background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;">
    <strong>💡 FUTURO:</strong> Sistema de attributes será usado para mapeamento automático no Parameters ORM v2.0+
</div>
''',

    'Attributes/Parameters.Attributes.Interfaces.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Attributes.Interfaces - Interfaces de Attributes</h3>
    <p><strong>Finalidade:</strong> Define interfaces para leitura e processamento de attributes via RTTI</p>
    <p><strong>Status:</strong> 🚧 Em desenvolvimento (v2.0+)</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">🔮 Uso Futuro (v2.0+)</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Attributes.Interfaces;

var
  Reader: IAttributeReader;
  Metadata: IEntityMetadata;
begin
  // Criar leitor de attributes
  Reader := TAttributeReader.Create;
  
  // Ler metadados da classe
  Metadata := Reader.ReadMetadata(TConfigParameter);
  
  WriteLn('Tabela: ', Metadata.TableName);
  WriteLn('Schema: ', Metadata.SchemaName);
  WriteLn('Colunas: ', Metadata.Columns.Count);
end;</code></pre>

<div style="background: #fff9c4; border-left: 4px solid #f57f17; padding: 15px; margin: 20px 0;">
    <strong>⚠️ EM DESENVOLVIMENTO:</strong> Esta funcionalidade será implementada na versão 2.0 do Parameters ORM.
</div>
''',

    'Attributes/Parameters.Attributes.Types.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Attributes.Types - Tipos de Attributes</h3>
    <p><strong>Finalidade:</strong> Define tipos e enums usados no sistema de attributes</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">📊 Tipos Principais</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>// Tipo de coluna
TColumnType = (
  ctString,
  ctInteger,
  ctFloat,
  ctBoolean,
  ctDateTime,
  ctText,
  ctBlob
);

// Tipo de validação
TValidationType = (
  vtRequired,
  vtMaxLength,
  vtMinLength,
  vtRange,
  vtEmail,
  vtURL,
  vtPattern
);

// Metadados de coluna
TColumnMetadata = class
  Name: string;
  ColumnName: string;
  ColumnType: TColumnType;
  IsPrimaryKey: Boolean;
  IsAutoIncrement: Boolean;
  IsForeignKey: Boolean;
  IsRequired: Boolean;
  MaxLength: Integer;
  DefaultValue: string;
end;</code></pre>

<div style="background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;">
    <strong>💡 NOTA:</strong> Estes tipos são usados internamente pelo sistema de attributes para armazenar metadados extraídos via RTTI.
</div>
''',

    'Attributes/Parameters.Attributes.Consts.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Attributes.Consts - Constantes de Attributes</h3>
    <p><strong>Finalidade:</strong> Define constantes padrão para o sistema de attributes</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">📊 Constantes Disponíveis</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>// Nomes de attributes
const
  ATTR_TABLE = 'Table';
  ATTR_COLUMN = 'Column';
  ATTR_PRIMARY_KEY = 'PrimaryKey';
  ATTR_AUTO_INCREMENT = 'AutoIncrement';
  ATTR_FOREIGN_KEY = 'ForeignKey';
  ATTR_REQUIRED = 'Required';
  ATTR_MAX_LENGTH = 'MaxLength';
  ATTR_MIN_LENGTH = 'MinLength';
  ATTR_RANGE = 'Range';
  ATTR_EMAIL = 'Email';
  ATTR_URL = 'URL';
  ATTR_PATTERN = 'Pattern';
  ATTR_DEFAULT = 'Default';
  ATTR_IGNORE = 'Ignore';
  ATTR_COMPUTED = 'Computed';

// Mensagens de validação padrão
const
  MSG_VALIDATION_REQUIRED = 'Campo obrigatório';
  MSG_VALIDATION_MAX_LENGTH = 'Tamanho máximo excedido';
  MSG_VALIDATION_MIN_LENGTH = 'Tamanho mínimo não atingido';
  MSG_VALIDATION_RANGE = 'Valor fora da faixa permitida';
  MSG_VALIDATION_EMAIL = 'Email inválido';
  MSG_VALIDATION_URL = 'URL inválida';
  MSG_VALIDATION_PATTERN = 'Formato inválido';</code></pre>

<div style="background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;">
    <strong>💡 USO:</strong> Estas constantes são usadas internamente para identificar e validar attributes em tempo de execução.
</div>
''',

    'Attributes/Parameters.Attributes.Exceptions.pas': '''
<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 Parameters.Attributes.Exceptions - Exceções de Attributes</h3>
    <p><strong>Finalidade:</strong> Define exceções específicas para o sistema de attributes</p>
</div>

<h4 style="color: #34495e; margin-top: 25px;">📊 Exceções Disponíveis</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>// Hierarquia de exceções
EAttributeError (Base)
├── EAttributeValidationError
│   ├── EAttributeRequiredError
│   ├── EAttributeMaxLengthError
│   ├── EAttributeRangeError
│   └── EAttributePatternError
├── EAttributeMetadataError
│   ├── EAttributeTableNotFoundError
│   └── EAttributeColumnNotFoundError
└── EAttributeRTTIError</code></pre>

<h4 style="color: #34495e; margin-top: 25px;">🎯 Exemplo de Uso</h4>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters.Attributes.Exceptions;

procedure ValidateEmail(const AEmail: string);
begin
  if not IsValidEmail(AEmail) then
    raise EAttributeValidationError.Create(
      'Email inválido: ' + AEmail,
      ERR_ATTR_VALIDATION_EMAIL
    );
end;

begin
  try
    ValidateEmail('invalid-email');
  except
    on E: EAttributeValidationError do
      WriteLn('Erro de validação: ', E.Message, ' [', E.ErrorCode, ']');
  end;
end;</code></pre>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;">
    <strong>⚠️ IMPORTANTE:</strong> Estas exceções são lançadas automaticamente pelo sistema de validação quando attributes são violados.
</div>
'''
}
