# -*- coding: utf-8 -*-
"""
Conteúdo do Roteiro de Uso para Parameters ORM v1.0.2
Este arquivo será importado pelo generate_parameters_docs.py
"""

USAGE_GUIDE_HTML = '''
<h2 style="color: #2c3e50; margin-top: 0;">🚀 Roteiro de Uso - Parameters ORM v1.0.2</h2>

<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 15px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">📋 O que é o Parameters ORM?</h3>
    <p>O <strong>Parameters ORM v1.0.2</strong> é um sistema unificado de gerenciamento de parâmetros de configuração que permite armazenar e recuperar configurações de múltiplas fontes de dados com fallback automático.</p>
    
    <h4 style="color: #2c3e50; margin-top: 15px;">Units Públicas:</h4>
    <ul>
        <li><strong><code>Parameters.pas</code></strong> - Factory class (TParameters) para criar instâncias</li>
        <li><strong><code>Parameters.Interfaces.pas</code></strong> - Todas as interfaces públicas</li>
    </ul>
    
    <h4 style="color: #2c3e50; margin-top: 15px;">✅ Funcionalidades:</h4>
    <ul>
        <li>✅ Múltiplas fontes: Database, INI Files, JSON Objects</li>
        <li>✅ Fallback automático em cascata</li>
        <li>✅ Suporte a 7 tipos de banco (PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC)</li>
        <li>✅ Suporte a 3 engines (UniDAC, FireDAC, Zeos)</li>
        <li>✅ Thread-safe (proteção com TCriticalSection)</li>
        <li>✅ Hierarquia completa: ContratoID + ProdutoID + Title + Name</li>
        <li>✅ Importação/Exportação bidirecional entre fontes</li>
    </ul>
</div>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">1. Começando - Primeiro Uso (Sem Attributes)</h3>

<div style="background: #f0f8ff; border-left: 4px solid #2196f3; padding: 15px; margin: 20px 0;">
    <h4 style="color: #1976d2; margin-top: 0;">💡 Sem Attributes vs Com Attributes - Qual Usar?</h4>
    
    <div style="background: white; padding: 15px; margin: 15px 0; border-radius: 5px;">
        <h5 style="color: #2e7d32; margin-top: 0;">✅ SEM Attributes (Abordagem Direta)</h5>
        <p><strong>O que é:</strong> Código puro, sem decorators. Você chama os métodos diretamente das interfaces.</p>
        
        <p><strong>✅ Benefícios:</strong></p>
        <ul>
            <li><strong>Simplicidade:</strong> Mais fácil de entender e debugar</li>
            <li><strong>Performance:</strong> Zero overhead de reflexão (RTTI)</li>
            <li><strong>Controle Total:</strong> Você decide exatamente o que fazer em cada linha</li>
            <li><strong>Compatibilidade:</strong> Funciona em qualquer versão do Delphi/FPC</li>
            <li><strong>Curva de Aprendizado:</strong> Rápida - ideal para iniciantes</li>
        </ul>
        
        <p><strong>❌ Desvantagens:</strong></p>
        <ul>
            <li>Mais código repetitivo (boilerplate)</li>
            <li>Mapeamento manual classe ↔ tabela</li>
            <li>Sem validação automática em tempo de compilação</li>
        </ul>
    </div>
    
    <div style="background: white; padding: 15px; margin: 15px 0; border-radius: 5px;">
        <h5 style="color: #d32f2f; margin-top: 0;">⚡ COM Attributes (Abordagem Declarativa)</h5>
        <p><strong>O que é:</strong> Usa decorators como <code>[Table]</code>, <code>[Column]</code>, <code>[Required]</code> para mapear e validar automaticamente.</p>
        
        <p><strong>✅ Benefícios:</strong></p>
        <ul>
            <li><strong>Código Limpo:</strong> Menos linhas, mais declarativo</li>
            <li><strong>Auto-Documentado:</strong> Attributes servem como documentação</li>
            <li><strong>Validação Automática:</strong> <code>[Required]</code>, <code>[Email]</code>, <code>[Range]</code> validam antes de salvar</li>
            <li><strong>Mapeamento Automático:</strong> Classe ↔ Tabela mapeado via reflexão</li>
            <li><strong>Integração ORM:</strong> Perfeito para sistemas complexos com muitas entidades</li>
        </ul>
        
        <p><strong>❌ Desvantagens:</strong></p>
        <ul>
            <li><strong>Performance:</strong> Overhead de RTTI (reflexão em runtime)</li>
            <li><strong>Complexidade:</strong> Curva de aprendizado maior</li>
            <li><strong>Debug:</strong> Mais difícil de rastrear erros (código gerado dinamicamente)</li>
            <li><strong>Compatibilidade:</strong> Requer RTTI habilitado (<code>{$M+}</code>)</li>
        </ul>
    </div>
    
    <div style="background: #fff9c4; padding: 15px; margin: 15px 0; border-radius: 5px; border: 1px solid #f57f17;">
        <p style="margin: 0;"><strong>👉 Recomendação:</strong></p>
        <ul style="margin: 10px 0;">
            <li><strong>Iniciantes:</strong> Comece <strong>SEM Attributes</strong> (Seções 1-6)</li>
            <li><strong>Projetos Simples:</strong> Use <strong>SEM Attributes</strong> (mais rápido e direto)</li>
            <li><strong>Projetos Grandes/ORM:</strong> Use <strong>COM Attributes</strong> (Seção 7) para reduzir boilerplate</li>
        </ul>
    </div>
</div>

<h4 style="margin-top: 20px; color: #2c3e50;">1.1. Usar Database (Sem Attributes)</h4>
<p>Este é o exemplo mais simples e comum: conectar ao banco, inserir e buscar um parâmetro.</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;  // Apenas esta unit!

var
  DB: IParametersDatabase;
  Param: TParameter;
begin
  // 1️⃣ Criar e conectar ao banco
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Port(5432)
    .Database('mydb')
    .Username('postgres')
    .Password('senha')
    .TableName('config')
    .Schema('public')
    .AutoCreateTable(True)  // ✨ Cria tabela automaticamente!
    .Connect;
  
  // 2️⃣ Inserir um parâmetro
  Param := TParameter.Create;
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Titulo := 'ERP';
  Param.Name := 'servidor_api';
  Param.Value := 'https://api.exemplo.com';
  Param.ValueType := pvtString;
  Param.Description := 'URL do servidor de API';
  
  DB.Setter(Param);  // Insere ou atualiza automaticamente!
  Param.Free;
  
  // 3️⃣ Buscar o parâmetro
  DB.ContratoID(1).ProdutoID(1).Title('ERP');
  Param := DB.Getter('servidor_api');
  try
    if Assigned(Param) then
      ShowMessage('Servidor: ' + Param.Value);  // Mostra: https://api.exemplo.com
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">1.2. Usar Arquivo INI (Sem Attributes)</h4>
<p>Perfeito para aplicações desktop que não querem depender de banco de dados:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  Ini: IParametersInifiles;
  Param: TParameter;
begin
  // 1️⃣ Criar arquivo INI
  Ini := TParameters.NewInifiles
    .FilePath('C:\\Config\\app.ini')
    .Section('ERP')
    .AutoCreateFile(True)  // ✨ Cria arquivo se não existir!
    .ContratoID(1)
    .ProdutoID(1);
  
  // 2️⃣ Inserir parâmetro
  Param := TParameter.Create;
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Titulo := 'ERP';
  Param.Name := 'servidor_api';
  Param.Value := 'https://api.exemplo.com';
  
  Ini.Setter(Param);
  Param.Free;
  
  // 3️⃣ Buscar parâmetro
  Param := Ini.Getter('servidor_api');
  try
    if Assigned(Param) then
      ShowMessage('Servidor: ' + Param.Value);
  finally
    if Assigned(Param) then
      Param.Free;
  end;
  
  // O arquivo app.ini foi criado com:
  // [ERP]
  // servidor_api=https://api.exemplo.com
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">1.3. Usar JSON (Sem Attributes)</h4>
<p>Ideal para integração com APIs REST e aplicações modernas:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  Json: IParametersJsonObject;
  Param: TParameter;
begin
  // 1️⃣ Criar JSON
  Json := TParameters.NewJsonObject
    .FilePath('C:\\Config\\app.json')
    .ObjectName('ERP')
    .AutoCreateFile(True)
    .ContratoID(1)
    .ProdutoID(1);
  
  // 2️⃣ Inserir parâmetro
  Param := TParameter.Create;
  Param.ContratoID := 1;
  Param.ProdutoID := 1;
  Param.Titulo := 'ERP';
  Param.Name := 'servidor_api';
  Param.Value := 'https://api.exemplo.com';
  
  Json.Setter(Param);
  Param.Free;
  
  // 3️⃣ Buscar parâmetro
  Param := Json.Getter('servidor_api');
  try
    if Assigned(Param) then
      ShowMessage('Servidor: ' + Param.Value);
  finally
    if Assigned(Param) then
      Param.Free;
  end;
  
  // O arquivo app.json foi criado com:
  // {
  //   "ERP": {
  //     "servidor_api": "https://api.exemplo.com"
  //   }
  // }
end;</code></pre>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">2. Convergência - Múltiplas Fontes com Fallback</h3>

<h4 style="margin-top: 20px; color: #2c3e50;">2.1. Fallback Automático (Database → INI → JSON)</h4>
<p>O sistema tenta buscar em cada fonte automaticamente até encontrar o parâmetro:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  P: IParameters;
  Param: TParameter;
begin
  // 1️⃣ Criar com múltiplas fontes
  P := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
  
  // 2️⃣ Configurar Database (prioridade 1)
  P.Database
    .Host('localhost')
    .Database('mydb')
    .TableName('config')
    .Connect;
  
  // 3️⃣ Configurar INI (fallback se Database falhar)
  P.Inifiles
    .FilePath('C:\\Config\\app.ini')
    .Section('ERP');
  
  // 4️⃣ Configurar JSON (último fallback)
  P.JsonObject
    .FilePath('C:\\Config\\app.json')
    .ObjectName('ERP');
  
  // 5️⃣ Buscar com fallback automático
  P.ContratoID(1).ProdutoID(1);
  P.Database.Title('ERP');
  P.Inifiles.Title('ERP');
  P.JsonObject.Title('ERP');
  
  Param := P.Getter('servidor_api');
  // ✨ Busca AUTOMATICAMENTE:
  // 1º Database → se não encontrar...
  // 2º INI → se não encontrar...
  // 3º JSON → se não encontrar... retorna nil
  
  try
    if Assigned(Param) then
      ShowMessage('Encontrado: ' + Param.Value);
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">2.2. Listar de Todas as Fontes (Merge)</h4>
<p>Combina parâmetros de todas as fontes, removendo duplicatas:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  P: IParameters;
  ParamList: TParameterList;
  I: Integer;
begin
  P := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
  
  // Configurar fontes...
  P.Database.Host('localhost').Database('mydb').Connect;
  P.Inifiles.FilePath('C:\\Config\\app.ini');
  P.JsonObject.FilePath('C:\\Config\\app.json');
  
  // Listar TUDO (merge de todas as fontes)
  ParamList := P.List;
  // ✨ Remove duplicatas automaticamente!
  // Se mesmo parâmetro existe em Database e INI, mostra apenas 1 vez
  
  try
    for I := 0 to ParamList.Count - 1 do
      ShowMessage(ParamList[I].Name + ' = ' + ParamList[I].Value);
  finally
    ParamList.Free;
  end;
end;</code></pre>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">3. Hierarquia Completa - Organizando Parâmetros</h3>

<h4 style="margin-top: 20px; color: #2c3e50;">3.1. Entendendo a Hierarquia (ContratoID + ProdutoID + Title + Name)</h4>
<p>A hierarquia permite organizar parâmetros por contrato, produto e seção:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Param: TParameter;
begin
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .Connect;
  
  // Inserir parâmetro para CONTRATO 1, PRODUTO 1, seção ERP
  Param := TParameter.Create;
  Param.ContratoID := 1;        // Empresa A
  Param.ProdutoID := 1;         // Sistema ERP
  Param.Titulo := 'ERP';        // Seção/Módulo
  Param.Name := 'servidor_api'; // Chave
  Param.Value := 'https://empresa-a-erp.com';
  DB.Setter(Param);
  Param.Free;
  
  // Inserir MESMO parâmetro para CONTRATO 2 (outra empresa)
  Param := TParameter.Create;
  Param.ContratoID := 2;        // Empresa B
  Param.ProdutoID := 1;         // Sistema ERP
  Param.Titulo := 'ERP';
  Param.Name := 'servidor_api'; // Mesma chave!
  Param.Value := 'https://empresa-b-erp.com';  // Valor diferente!
  DB.Setter(Param);
  Param.Free;
  
  // Buscar para Empresa A
  DB.ContratoID(1).ProdutoID(1).Title('ERP');
  Param := DB.Getter('servidor_api');
  ShowMessage(Param.Value);  // https://empresa-a-erp.com
  Param.Free;
  
  // Buscar para Empresa B
  DB.ContratoID(2).ProdutoID(1).Title('ERP');
  Param := DB.Getter('servidor_api');
  ShowMessage(Param.Value);  // https://empresa-b-erp.com
  Param.Free;
  
  // ✨ Mesma chave, valores diferentes por hierarquia!
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">3.2. Múltiplas Seções (Títulos) no Mesmo Sistema</h4>
<p>Organizar parâmetros por módulos/seções:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Param: TParameter;
begin
  DB := TParameters.NewDatabase.Host('localhost').Database('mydb').Connect;
  DB.ContratoID(1).ProdutoID(1);
  
  // Parâmetro do módulo ERP
  DB.Title('ERP');
  Param := DB.Getter('servidor_api');
  ShowMessage('ERP: ' + Param.Value);  // https://erp.exemplo.com
  Param.Free;
  
  // Parâmetro do módulo CRM (MESMA chave, seção diferente!)
  DB.Title('CRM');
  Param := DB.Getter('servidor_api');
  ShowMessage('CRM: ' + Param.Value);  // https://crm.exemplo.com
  Param.Free;
  
  // Parâmetro do módulo Financeiro
  DB.Title('Financeiro');
  Param := DB.Getter('servidor_api');
  ShowMessage('Financeiro: ' + Param.Value);  // https://financeiro.exemplo.com
  Param.Free;
  
  // ✨ Mesma chave em seções diferentes = valores diferentes!
end;</code></pre>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">4. Importação e Exportação entre Fontes</h4>

<h4 style="margin-top: 20px; color: #2c3e50;">4.1. Exportar Database → INI (Backup)</h4>
<p>Fazer backup dos parâmetros do banco para arquivo INI:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Ini: IParametersInifiles;
begin
  // Fonte: Database
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .Connect;
  
  // Destino: INI
  Ini := TParameters.NewInifiles
    .FilePath('C:\\Backup\\config_backup.ini')
    .AutoCreateFile(True);
  
  // Exportar Database → INI
  Ini.ImportFromDatabase(DB);
  // ✨ Todos os parâmetros do banco foram salvos no INI!
  
  ShowMessage('Backup criado em: C:\\Backup\\config_backup.ini');
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">4.2. Importar INI → Database (Restaurar)</h4>
<p>Restaurar parâmetros do arquivo INI para o banco:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Ini: IParametersInifiles;
begin
  // Fonte: INI
  Ini := TParameters.NewInifiles
    .FilePath('C:\\Backup\\config_backup.ini');
  
  // Destino: Database
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .Connect;
  
  // Importar INI → Database
  DB.ImportFromInifiles(Ini);
  // ✨ Todos os parâmetros do INI foram salvos no banco!
  
  ShowMessage('Parâmetros restaurados no banco de dados!');
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">4.3. Migrar Database → JSON</h4>
<p>Migrar parâmetros do banco para JSON:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Json: IParametersJsonObject;
begin
  // Fonte: Database
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .Connect;
  
  // Destino: JSON
  Json := TParameters.NewJsonObject
    .FilePath('C:\\Config\\params.json')
    .AutoCreateFile(True);
  
  // Migrar Database → JSON
  Json.ImportFromDatabase(DB);
  // ✨ Todos os parâmetros agora estão em JSON!
  
  ShowMessage('Migração concluída!');
  ShowMessage(Json.ToJSONString);  // Ver JSON formatado
end;</code></pre>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">5. Operações Avançadas</h3>

<h4 style="margin-top: 20px; color: #2c3e50;">5.1. Listar Tabelas e Bancos Disponíveis</h4>
<p>Descobrir quais bancos e tabelas estão disponíveis:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Databases, Tables: TStringList;
  I: Integer;
begin
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Username('postgres')
    .Password('senha')
    .Connect;
  
  // Listar bancos disponíveis
  Databases := DB.ListAvailableDatabases;
  try
    for I := 0 to Databases.Count - 1 do
      ShowMessage('Banco: ' + Databases[I]);
  finally
    Databases.Free;
  end;
  
  // Listar tabelas do banco atual
  Tables := DB.ListAvailableTables;
  try
    for I := 0 to Tables.Count - 1 do
      ShowMessage('Tabela: ' + Tables[I]);
  finally
    Tables.Free;
  end;
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">5.2. Criar e Dropar Tabelas Manualmente</h4>
<p>Gerenciar tabelas de parâmetros:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
begin
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .TableName('config_teste')
    .Connect;
  
  // Verificar se tabela existe
  if not DB.TableExists then
  begin
    // Criar tabela
    DB.CreateTable;
    ShowMessage('Tabela criada com estrutura padrão!');
  end;
  
  // Usar a tabela...
  
  // Remover tabela (CUIDADO!)
  if MessageDlg('Deseja remover a tabela?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DB.DropTable;
    ShowMessage('Tabela removida!');
  end;
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">5.3. Contar e Verificar Existência</h4>
<p>Operações úteis de contagem e verificação:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  DB: IParametersDatabase;
  Total: Integer;
  Existe: Boolean;
begin
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .ContratoID(1)
    .ProdutoID(1)
    .Title('ERP')
    .Connect;
  
  // Contar parâmetros
  Total := DB.Count;
  ShowMessage('Total de parâmetros: ' + IntToStr(Total));
  
  // Verificar se parâmetro existe
  Existe := DB.Exists('servidor_api');
  if Existe then
    ShowMessage('Parâmetro servidor_api existe!')
  else
    ShowMessage('Parâmetro servidor_api NÃO existe!');
end;</code></pre>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 4px;">
    <div style="color: #856404; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;">⚠️ Regras Importantes</div>
    <div style="color: #856404;">
        <h4 style="margin-top: 10px;">Hierarquia Completa (UNIQUE Constraint)</h4>
        <p>A combinação <code>(ContratoID, ProdutoID, Title, Name)</code> é ÚNICA no banco. Não pode haver duplicatas.</p>
        
        <h4 style="margin-top: 10px;">Métodos Getter vs Get (Deprecated)</h4>
        <ul>
            <li>✅ Use <code>Getter()</code> - Recomendado</li>
            <li>❌ Evite <code>Get()</code> - Deprecated (será removido)</li>
        </ul>
        
        <h4 style="margin-top: 10px;">Métodos Setter vs Update (Deprecated)</h4>
        <ul>
            <li>✅ Use <code>Setter()</code> - Insere se não existir, atualiza se existir</li>
            <li>❌ Evite <code>Update()</code> - Deprecated (será removido)</li>
        </ul>
        
        <h4 style="margin-top: 10px;">Liberar Memória</h4>
        <p>Sempre libere objetos <code>TParameter</code> e <code>TParameterList</code> após uso:</p>
        <pre style="background: #2c3e50; color: #ecf0f1; padding: 10px; border-radius: 4px;"><code>Param := DB.Getter('chave');
try
  // Usar Param...
finally
  if Assigned(Param) then
    Param.Free;
end;</code></pre>
    </div>
</div>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">6. Exemplos Práticos Completos</h3>

<h4 style="margin-top: 20px; color: #2c3e50;">6.1. Sistema Multi-Empresa com Fallback</h4>
<p>Sistema que busca configuração no banco e, se falhar, usa arquivo INI local:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

function GetConfiguracao(AContratoID, AProdutoID: Integer; AChave: string): string;
var
  P: IParameters;
  Param: TParameter;
begin
  Result := '';
  
  // Criar com fallback Database → INI
  P := TParameters.New([pcfDataBase, pcfInifile]);
  
  try
    // Tentar conectar ao banco (pode falhar)
    P.Database
      .Host('servidor-remoto.com')
      .Database('config_global')
      .Username('user')
      .Password('pass')
      .TableName('parametros')
      .Connect;
  except
    // Se banco falhar, INI será usado automaticamente
  end;
  
  // Configurar INI (fallback local)
  P.Inifiles
    .FilePath(ExtractFilePath(ParamStr(0)) + 'config.ini')
    .Section('Sistema');
  
  // Buscar com hierarquia
  P.ContratoID(AContratoID).ProdutoID(AProdutoID);
  P.Database.Title('Sistema');
  P.Inifiles.Title('Sistema');
  
  Param := P.Getter(AChave);
  try
    if Assigned(Param) then
      Result := Param.Value;
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;

// Usar:
var
  ServidorAPI: string;
begin
  ServidorAPI := GetConfiguracao(1, 1, 'servidor_api');
  ShowMessage('API: ' + ServidorAPI);
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">6.2. Configuração Distribuída (Database + JSON Local)</h4>
<p>Configurações globais no banco + configurações locais em JSON:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters;

var
  P: IParameters;
  Param: TParameter;
begin
  P := TParameters.New([pcfDataBase, pcfJsonObject]);
  
  // Configurações GLOBAIS (banco remoto)
  P.Database
    .Host('config-server.com')
    .Database('global_config')
    .TableName('parametros')
    .Connect;
  
  // Configurações LOCAIS (JSON no computador)
  P.JsonObject
    .FilePath(ExtractFilePath(ParamStr(0)) + 'local_config.json')
    .ObjectName('Local');
  
  // Configurar hierarquia
  P.ContratoID(1).ProdutoID(1);
  P.Database.Title('Global');
  P.JsonObject.Title('Local');
  
  // Buscar GLOBAL primeiro, se não achar, busca LOCAL
  Param := P.Getter('timeout_api');
  try
    if Assigned(Param) then
      ShowMessage('Timeout: ' + Param.Value);
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;</code></pre>

<div style="background: #d1ecf1; border-left: 4px solid #0c5460; padding: 20px; margin: 30px 0; border-radius: 4px;">
    <div style="color: #0c5460; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;">💡 Dicas e Boas Práticas</div>
    <div style="color: #0c5460;">
        <ul>
            <li><strong>Use AutoCreateTable(True)</strong> para desenvolvimento - cria a estrutura automaticamente</li>
            <li><strong>Sempre configure hierarquia completa</strong> - ContratoID, ProdutoID e Title antes de buscar</li>
            <li><strong>Use Setter() em vez de Insert()</strong> - ele insere ou atualiza automaticamente</li>
            <li><strong>Libere memória</strong> - TParameter e TParameterList precisam ser liberados manualmente</li>
            <li><strong>Use fallback para contingência</strong> - Database → INI garante que sempre terá configuração</li>
            <li><strong>Organize por Title</strong> - Use títulos como "ERP", "CRM", "Financeiro" para modularizar</li>
        </ul>
    </div>
</div>

<h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">7. Uso Avançado COM Attributes (Mapeamento Declarativo)</h3>

<div style="background: #fff3e0; border-left: 4px solid #ff9800; padding: 15px; margin: 20px 0;">
    <h4 style="color: #e65100; margin-top: 0;">⚡ O que são Attributes?</h4>
    <p><strong>Attributes</strong> (ou decorators) permitem mapear classes Pascal para estruturas de dados usando anotações declarativas como <code>[Table]</code>, <code>[Column]</code>, etc.</p>
    <p><strong>Vantagens:</strong></p>
    <ul>
        <li>Código mais limpo e declarativo</li>
        <li>Mapeamento automático classe ↔ tabela</li>
        <li>Validação em tempo de compilação</li>
        <li>Integração com ORM e reflexão (RTTI)</li>
    </ul>
    <p><strong>Units Attributes disponíveis:</strong></p>
    <ul>
        <li><code>Parameters.Attributes.pas</code> - Attributes principais</li>
        <li><code>Parameters.Attributes.Interfaces.pas</code> - Interfaces de Attributes</li>
        <li><code>Parameters.Attributes.Types.pas</code> - Tipos de Attributes</li>
        <li><code>Parameters.Attributes.Consts.pas</code> - Constantes de Attributes</li>
        <li><code>Parameters.Attributes.Exceptions.pas</code> - Exceções de Attributes</li>
    </ul>
</div>

<h4 style="margin-top: 20px; color: #2c3e50;">7.1. Classe Mapeada com [Table] Attribute</h4>
<p>Usar Attributes para mapear uma classe Pascal para uma tabela de parâmetros:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters,
  Parameters.Attributes;  // ✨ Unit de Attributes!

{$M+}  // Habilitar RTTI
type
  [Table('config')]         // ✨ Mapeia para tabela 'config'
  [Schema('public')]        // ✨ Schema do banco
  TConfiguracao = class
  private
    FID: Integer;
    FName: string;
    FValue: string;
    FDescription: string;
  published
    [PrimaryKey]            // ✨ Chave primária
    [AutoIncrement]         // ✨ Auto incremento
    property ID: Integer read FID write FID;
    
    [Column('name')]        // ✨ Nome da coluna no banco
    [Required]              // ✨ Campo obrigatório
    [MaxLength(100)]        // ✨ Validação de tamanho
    property Name: string read FName write FName;
    
    [Column('value')]
    property Value: string read FValue write FValue;
    
    [Column('description')]
    property Description: string read FDescription write FDescription;
  end;

var
  DB: IParametersDatabase;
  Config: TConfiguracao;
  Param: TParameter;
begin
  // 1️⃣ Conectar ao banco
  DB := TParameters.NewDatabase
    .Host('localhost')
    .Database('mydb')
    .Connect;
  
  // 2️⃣ Criar instância da classe mapeada
  Config := TConfiguracao.Create;
  try
    Config.Name := 'servidor_api';
    Config.Value := 'https://api.exemplo.com';
    Config.Description := 'URL do servidor de API';
    
    // 3️⃣ Converter classe para TParameter usando RTTI
    Param := TParameter.FromClass<TConfiguracao>(Config);
    try
      // 4️⃣ Inserir usando o parâmetro
      DB.Setter(Param);
      ShowMessage('Configuração inserida com Attributes!');
    finally
      Param.Free;
    end;
  finally
    Config.Free;
  end;
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">7.2. Attributes de Validação</h4>
<p>Usar Attributes para validar dados antes de inserir:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters,
  Parameters.Attributes;

{$M+}
type
  [Table('config')]
  TConfiguracao = class
  private
    FEmail: string;
    FPorta: Integer;
    FAtivo: Boolean;
  published
    [Column('email')]
    [Required]              // ✨ Não pode ser vazio
    [Email]                 // ✨ Valida formato de email
    property Email: string read FEmail write FEmail;
    
    [Column('porta')]
    [Required]
    [Range(1, 65535)]       // ✨ Porta entre 1 e 65535
    property Porta: Integer read FPorta write FPorta;
    
    [Column('ativo')]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

var
  Config: TConfiguracao;
  Param: TParameter;
begin
  Config := TConfiguracao.Create;
  try
    Config.Email := 'admin@exemplo.com';  // ✅ Email válido
    Config.Porta := 8080;                 // ✅ Porta válida
    Config.Ativo := True;
    
    // Converter e validar automaticamente
    Param := TParameter.FromClass<TConfiguracao>(Config);
    try
      // ✨ Se validação falhar, lança exceção!
      ShowMessage('Validação passou!');
    finally
      Param.Free;
    end;
  finally
    Config.Free;
  end;
end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">7.3. Attributes de Comportamento</h4>
<p>Controlar comportamento de campos com Attributes:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters,
  Parameters.Attributes;

{$M+}
type
  [Table('config')]
  TConfiguracao = class
  private
    FID: Integer;
    FSenha: string;
    FDataCriacao: TDateTime;
    FVersao: string;
  published
    [PrimaryKey]
    [AutoIncrement]
    property ID: Integer read FID write FID;
    
    [Column('senha')]
    [Encrypted]             // ✨ Campo será criptografado
    property Senha: string read FSenha write FSenha;
    
    [Column('data_criacao')]
    [Timestamp]             // ✨ Timestamp automático
    [Default('NOW()')]      // ✨ Valor padrão no banco
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    
    [Ignore]                // ✨ NÃO será salvo no banco
    property Versao: string read FVersao write FVersao;
  end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">7.4. Attributes de Auditoria</h4>
<p>Rastreamento automático de criação/modificação:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters,
  Parameters.Attributes;

{$M+}
type
  [Table('config')]
  TConfiguracao = class
  private
    FID: Integer;
    FName: string;
    FCreatedAt: TDateTime;
    FUpdatedAt: TDateTime;
    FCreatedBy: Integer;
    FUpdatedBy: Integer;
    FDeletedAt: TDateTime;
  published
    [PrimaryKey]
    [AutoIncrement]
    property ID: Integer read FID write FID;
    
    [Column('name')]
    property Name: string read FName write FName;
    
    [Column('created_at')]
    [Timestamp]             // ✨ Preenchido ao criar
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    
    [Column('updated_at')]
    [Timestamp]             // ✨ Atualizado a cada modificação
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
    
    [Column('created_by')]
    [UserStamp]             // ✨ ID do usuário que criou
    property CreatedBy: Integer read FCreatedBy write FCreatedBy;
    
    [Column('updated_by')]
    [UserStamp]             // ✨ ID do usuário que atualizou
    property UpdatedBy: Integer read FUpdatedBy write FUpdatedBy;
    
    [Column('deleted_at')]
    [SoftDelete]            // ✨ Soft delete (não remove, marca como deletado)
    property DeletedAt: TDateTime read FDeletedAt write FDeletedAt;
  end;</code></pre>

<h4 style="margin-top: 20px; color: #2c3e50;">7.5. Ler Attributes em Runtime (RTTI)</h4>
<p>Acessar Attributes de uma classe em tempo de execução:</p>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Parameters,
  Parameters.Attributes,
  TypInfo, Rtti;

var
  Context: TRttiContext;
  RttiType: TRttiType;
  RttiProp: TRttiProperty;
  Attr: TCustomAttribute;
  TableAttr: TableAttribute;
  ColumnAttr: ColumnAttribute;
begin
  Context := TRttiContext.Create;
  try
    // Obter informações RTTI da classe
    RttiType := Context.GetType(TConfiguracao);
    
    // Ler [Table] attribute da classe
    for Attr in RttiType.GetAttributes do
    begin
      if Attr is TableAttribute then
      begin
        TableAttr := TableAttribute(Attr);
        ShowMessage('Tabela: ' + TableAttr.TableName);
        ShowMessage('Schema: ' + TableAttr.SchemaName);
      end;
    end;
    
    // Ler [Column] attributes das propriedades
    for RttiProp in RttiType.GetProperties do
    begin
      for Attr in RttiProp.GetAttributes do
      begin
        if Attr is ColumnAttribute then
        begin
          ColumnAttr := ColumnAttribute(Attr);
          ShowMessage('Propriedade: ' + RttiProp.Name + 
                      ' → Coluna: ' + ColumnAttr.ColumnName);
        end;
      end;
    end;
  finally
    Context.Free;
  end;
end;</code></pre>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 4px;">
    <div style="color: #856404; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;">⚠️ Quando Usar Attributes?</div>
    <div style="color: #856404;">
        <h4 style="margin-top: 10px;">✅ Use Attributes Quando:</h4>
        <ul>
            <li>Você quer mapeamento declarativo classe ↔ tabela</li>
            <li>Precisa de validação em tempo de compilação</li>
            <li>Está construindo um ORM ou sistema baseado em reflexão</li>
            <li>Quer código mais limpo e auto-documentado</li>
        </ul>
        
        <h4 style="margin-top: 10px;">❌ NÃO Use Attributes Quando:</h4>
        <ul>
            <li>Você está apenas lendo/escrevendo parâmetros simples</li>
            <li>Performance é crítica (RTTI tem overhead)</li>
            <li>Você prefere controle explícito do código</li>
            <li>Está começando a aprender o sistema (comece sem Attributes!)</li>
        </ul>
        
        <h4 style="margin-top: 10px;">💡 Dica:</h4>
        <p>O Parameters ORM funciona <strong>perfeitamente sem Attributes</strong>! Attributes são um recurso <strong>opcional</strong> para casos avançados.</p>
    </div>
</div>
'''
