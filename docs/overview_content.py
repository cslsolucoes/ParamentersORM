# -*- coding: utf-8 -*-
"""
Conteúdo da Visão Geral mesclado com ComoUsar.html
"""

OVERVIEW_HTML = '''
<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px;">
    <h2 style="color: white; margin-top: 0;">🔧 Parameters ORM v1.0.2</h2>
    <p style="font-size: 1.1em; line-height: 1.6;">
        Sistema unificado de gerenciamento de parâmetros de configuração para Delphi/Free Pascal, 
        com suporte a múltiplas fontes de dados (Banco de Dados, Arquivos INI, Objetos JSON) e fallback automático.
    </p>
    <div style="margin-top: 20px; padding: 15px; background: rgba(255,255,255,0.1); border-radius: 5px;">
        <strong>Status:</strong> ✅ Pronto para Uso em Produção | 
        <strong>Versão:</strong> 1.0.2 | 
        <strong>Completude:</strong> ~95%
    </div>
</div>

<h2 style="color: #2c3e50; margin-top: 30px;">📋 O que é o Parameters ORM?</h2>

<p style="font-size: 1.05em; line-height: 1.8;">
    O <strong>Parameters ORM v1.0.2</strong> é um módulo que elimina a complexidade de gerenciar configurações 
    de aplicação, permitindo armazenar e recuperar parâmetros de múltiplas fontes com hierarquia completa e fallback automático.
</p>

<h3 style="color: #34495e; margin-top: 25px;">🎯 Quando Usar</h3>
<ul style="line-height: 1.8; margin-left: 20px;">
    <li><strong>Aplicações que precisam de configuração flexível:</strong> Permite alternar entre Database, INI e JSON sem mudar o código</li>
    <li><strong>Sistemas com requisito de contingência:</strong> Fallback automático garante disponibilidade mesmo se uma fonte falhar</li>
    <li><strong>Aplicações multi-tenant:</strong> Suporte nativo a ContratoID e ProdutoID para isolamento de dados</li>
    <li><strong>Migração de configurações:</strong> Importação/Exportação facilita migração entre fontes</li>
</ul>

<h3 style="color: #34495e; margin-top: 25px;">📦 Requisitos</h3>
<ul style="line-height: 1.8; margin-left: 20px;">
    <li><strong>Compiladores:</strong> Delphi 10.1 ou superior OU Free Pascal (FPC) 3.0 ou superior</li>
    <li><strong>Bibliotecas de Banco de Dados</strong> (uma das seguintes):
        <ul style="margin-left: 20px;">
            <li>UniDAC (Devart)</li>
            <li>FireDAC (Embarcadero)</li>
            <li>Zeos (Open Source)</li>
        </ul>
    </li>
</ul>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;">
    <h4 style="margin-top: 0; color: #856404;">⚙️ Configuração de Diretivas</h4>
    <p style="color: #856404;">No arquivo <code>ParamentersORM.Defines.inc</code>, defina qual engine será usado:</p>
    <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>// Para usar UniDAC
{$DEFINE USE_UNIDAC}

// Para usar FireDAC
{$DEFINE USE_FIREDAC}

// Para usar Zeos
{$DEFINE USE_ZEOS}</code></pre>
    <p style="color: #856404; margin-bottom: 0;"><strong>⚠️ Importante:</strong> Apenas uma diretiva deve estar ativa por vez.</p>
</div>

<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">✨ Funcionalidades Principais</h3>
    <ul style="line-height: 1.8;">
        <li><strong>Múltiplas Fontes:</strong> Database, INI Files, JSON Objects</li>
        <li><strong>Fallback Automático:</strong> Busca em cascata (Database → INI → JSON)</li>
        <li><strong>Multi-Engine:</strong> UniDAC, FireDAC, Zeos</li>
        <li><strong>Multi-Database:</strong> PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC</li>
        <li><strong>Thread-Safe:</strong> Proteção com TCriticalSection</li>
        <li><strong>Hierarquia Completa:</strong> ContratoID + ProdutoID + Title + Name</li>
        <li><strong>Import/Export:</strong> Bidirecional entre todas as fontes</li>
        <li><strong>Fluent Interface:</strong> Métodos encadeáveis para código limpo</li>
    </ul>
</div>

<h2 style="color: #2c3e50; margin-top: 30px;">🚀 Começando - Instalação</h2>

<h3 style="color: #34495e; margin-top: 20px;">1. Adicionar Units ao Uses</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  System.SysUtils,
  Parameters;              // ✨ Apenas esta unit para começar!</code></pre>

<h3 style="color: #34495e; margin-top: 20px;">2. Criar Instância e Conectar</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  DB: IParametersDatabase;
begin
  // 1️⃣ Criar instância
  DB := TParameters.NewDatabase;
  
  // 2️⃣ Configurar conexão (SQLite exemplo)
  DB.DatabaseType('SQLite')
    .Database('C:\\Config\\params.db')
    .TableName('config')
    .AutoCreateTable(True);  // ✨ Cria tabela automaticamente!
  
  // 3️⃣ Conectar
  DB.Connect;
  
  // 4️⃣ Usar...
  // (exemplos nas próximas seções)
end;</code></pre>

<h2 style="color: #2c3e50; margin-top: 30px;">📝 CRUD Básico - Primeiros Passos</h2>

<h3 style="color: #34495e; margin-top: 20px;">CREATE - Inserir Parâmetro</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  Param: TParameter;
begin
  Param := TParameter.Create;
  try
    // Preencher hierarquia COMPLETA (obrigatório!)
    Param.ContratoID := 1;        // ✅ DEVE SER > 0
    Param.ProdutoID := 1;         // ✅ DEVE SER > 0
    Param.Titulo := 'ERP';        // ✅ Seção/Módulo
    Param.Name := 'servidor_api'; // ✅ Chave única
    Param.Value := 'https://api.exemplo.com';
    Param.ValueType := pvtString;
    Param.Description := 'URL do servidor de API';
    Param.Ordem := 1;
    Param.Ativo := True;
    
    // Inserir (usa Setter - insere ou atualiza automaticamente)
    DB.Setter(Param);
    WriteLn('✅ Parâmetro salvo!');
  finally
    Param.Free;
  end;
end;</code></pre>

<h3 style="color: #34495e; margin-top: 20px;">READ - Buscar Parâmetro</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  Param: TParameter;
begin
  // Configurar hierarquia antes de buscar
  DB.ContratoID(1)
    .ProdutoID(1)
    .Title('ERP');
  
  // Buscar parâmetro
  Param := DB.Getter('servidor_api');
  try
    if Assigned(Param) then
    begin
      WriteLn('Valor: ' + Param.Value);
      WriteLn('Título: ' + Param.Titulo);
      WriteLn('Descrição: ' + Param.Description);
    end
    else
      WriteLn('❌ Parâmetro não encontrado!');
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;</code></pre>

<h3 style="color: #34495e; margin-top: 20px;">UPDATE - Atualizar Parâmetro</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  Param: TParameter;
begin
  // Buscar existente
  DB.ContratoID(1).ProdutoID(1).Title('ERP');
  Param := DB.Getter('servidor_api');
  
  if Assigned(Param) then
  begin
    try
      // Modificar valor
      Param.Value := 'https://nova-api.exemplo.com';
      
      // Atualizar (Setter atualiza se já existe)
      DB.Setter(Param);
      WriteLn('✅ Parâmetro atualizado!');
    finally
      Param.Free;
    end;
  end;
end;</code></pre>

<h3 style="color: #34495e; margin-top: 20px;">DELETE - Remover Parâmetro</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>begin
  // Configurar hierarquia
  DB.ContratoID(1).ProdutoID(1).Title('ERP');
  
  // Deletar (soft delete - marca como inativo)
  DB.Delete('servidor_api');
  
  WriteLn('✅ Parâmetro deletado!');
end;</code></pre>

<h3 style="color: #34495e; margin-top: 20px;">LIST - Listar Todos os Parâmetros</h3>
<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  ParamList: TParameterList;
  I: Integer;
begin
  // Configurar filtros
  DB.ContratoID(1).ProdutoID(1).Title('ERP');
  
  // Listar todos
  ParamList := DB.List;
  try
    WriteLn('Total: ', ParamList.Count);
    
    for I := 0 to ParamList.Count - 1 do
    begin
      WriteLn(Format('%s = %s', [
        ParamList[I].Name,
        ParamList[I].Value
      ]));
    end;
  finally
    ParamList.Free;
  end;
end;</code></pre>

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 4px;">
    <h3 style="color: #856404; margin-top: 0;">⚠️ Regras de Negócio - Hierarquia Completa</h3>
    <div style="color: #856404;">
        <p><strong>IMPORTANTE:</strong> Todos os métodos CRUD respeitam a hierarquia completa de identificação:</p>
        
        <h4 style="margin-top: 15px;">Constraint UNIQUE:</h4>
        <p><code>ContratoID + ProdutoID + Title + Name</code></p>
        <p>Esta combinação deve ser ÚNICA. Não pode haver duplicatas.</p>
        
        <h4 style="margin-top: 15px;">Comportamento dos Métodos:</h4>
        <ul>
            <li><strong>Getter():</strong> Busca específica quando hierarquia configurada, busca ampla quando não configurada</li>
            <li><strong>Setter():</strong> Sempre requer hierarquia completa. Insere se não existir, atualiza se existir</li>
            <li><strong>Delete():</strong> Respeita hierarquia completa. Soft delete (marca como inativo)</li>
            <li><strong>Exists():</strong> Respeita hierarquia completa</li>
            <li><strong>List():</strong> Retorna apenas parâmetros ativos que correspondem aos filtros</li>
        </ul>
        
        <h4 style="margin-top: 15px;">Nomenclatura Recomendada:</h4>
        <ul>
            <li>✅ Use <code>Getter()</code> em vez de <code>Get()</code> (deprecated)</li>
            <li>✅ Use <code>Setter()</code> em vez de <code>Update()</code> (deprecated)</li>
        </ul>
    </div>
</div>

<h2 style="color: #2c3e50; margin-top: 30px;">💡 Tipos de Valor Suportados</h2>

<table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
    <thead>
        <tr style="background: #3498db; color: white;">
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Tipo</th>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Enum</th>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Descrição</th>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Exemplo</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background: #f8f9fa;">
            <td style="padding: 12px; border: 1px solid #ddd;">String</td>
            <td style="padding: 12px; border: 1px solid #ddd;"><code>pvtString</code></td>
            <td style="padding: 12px; border: 1px solid #ddd;">Texto genérico</td>
            <td style="padding: 12px; border: 1px solid #ddd;">'localhost'</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ddd;">Integer</td>
            <td style="padding: 12px; border: 1px solid #ddd;"><code>pvtInteger</code></td>
            <td style="padding: 12px; border: 1px solid #ddd;">Número inteiro</td>
            <td style="padding: 12px; border: 1px solid #ddd;">5432</td>
        </tr>
        <tr style="background: #f8f9fa;">
            <td style="padding: 12px; border: 1px solid #ddd;">Float</td>
            <td style="padding: 12px; border: 1px solid #ddd;"><code>pvtFloat</code></td>
            <td style="padding: 12px; border: 1px solid #ddd;">Número decimal</td>
            <td style="padding: 12px; border: 1px solid #ddd;">3.14</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ddd;">Boolean</td>
            <td style="padding: 12px; border: 1px solid #ddd;"><code>pvtBoolean</code></td>
            <td style="padding: 12px; border: 1px solid #ddd;">Verdadeiro/Falso</td>
            <td style="padding: 12px; border: 1px solid #ddd;">True / False</td>
        </tr>
        <tr style="background: #f8f9fa;">
            <td style="padding: 12px; border: 1px solid #ddd;">DateTime</td>
            <td style="padding: 12px; border: 1px solid #ddd;"><code>pvtDateTime</code></td>
            <td style="padding: 12px; border: 1px solid #ddd;">Data e hora</td>
            <td style="padding: 12px; border: 1px solid #ddd;">Now</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ddd;">JSON</td>
            <td style="padding: 12px; border: 1px solid #ddd;"><code>pvtJSON</code></td>
            <td style="padding: 12px; border: 1px solid #ddd;">Objeto JSON</td>
            <td style="padding: 12px; border: 1px solid #ddd;">{"key":"value"}</td>
        </tr>
    </tbody>
</table>

<h2 style="color: #2c3e50; margin-top: 30px;">📚 Arquitetura - Units Públicas</h2>

<div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;">
    <h3 style="color: #2c3e50; margin-top: 0;">🔓 Units Públicas (API Externa)</h3>
    <p>O módulo Parameters expõe apenas <strong>2 units públicas</strong>:</p>
    <ul style="line-height: 1.8;">
        <li><strong><code>Parameters.pas</code></strong> - Ponto de entrada com Factory methods (TParameters.New, TParameters.NewDatabase, etc.)</li>
        <li><strong><code>Parameters.Interfaces.pas</code></strong> - Todas as interfaces públicas (IParameters, IParametersDatabase, IParametersInifiles, IParametersJsonObject)</li>
    </ul>
    
    <h4 style="margin-top: 15px;">⚠️ IMPORTANTE:</h4>
    <p><strong>NÃO use units internas diretamente!</strong> Units como <code>Parameters.Database</code>, <code>Parameters.Inifiles</code>, <code>Parameters.JsonObject</code>, etc. são internas e podem mudar sem aviso. Use sempre os Factory methods de <code>Parameters.pas</code>.</p>
</div>

<h2 style="color: #2c3e50; margin-top: 30px;">🎯 Exemplo Completo - Aplicação Simples</h2>

<pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>program ExemploParameters;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Parameters;

var
  DB: IParametersDatabase;
  Param: TParameter;
  ParamList: TParameterList;
  I: Integer;

begin
  try
    WriteLn('=== Parameters ORM - Exemplo Completo ===');
    WriteLn;
    
    // 1️⃣ CONECTAR
    WriteLn('[1] Conectando ao banco...');
    DB := TParameters.NewDatabase;
    DB.DatabaseType('SQLite')
      .Database('C:\\Config\\params.db')
      .TableName('config')
      .AutoCreateTable(True)
      .Connect;
    WriteLn('✅ Conectado!');
    WriteLn;
    
    // 2️⃣ INSERIR
    WriteLn('[2] Inserindo parâmetros...');
    Param := TParameter.Create;
    try
      Param.ContratoID := 1;
      Param.ProdutoID := 1;
      Param.Titulo := 'ERP';
      Param.Name := 'servidor_api';
      Param.Value := 'https://api.exemplo.com';
      Param.ValueType := pvtString;
      Param.Description := 'URL do servidor de API';
      DB.Setter(Param);
      WriteLn('✅ Parâmetro inserido!');
    finally
      Param.Free;
    end;
    WriteLn;
    
    // 3️⃣ BUSCAR
    WriteLn('[3] Buscando parâmetro...');
    DB.ContratoID(1).ProdutoID(1).Title('ERP');
    Param := DB.Getter('servidor_api');
    try
      if Assigned(Param) then
        WriteLn('✅ Encontrado: ' + Param.Value)
      else
        WriteLn('❌ Não encontrado!');
    finally
      if Assigned(Param) then
        Param.Free;
    end;
    WriteLn;
    
    // 4️⃣ LISTAR
    WriteLn('[4] Listando todos os parâmetros...');
    ParamList := DB.List;
    try
      WriteLn('Total: ', ParamList.Count);
      for I := 0 to ParamList.Count - 1 do
        WriteLn('  - ', ParamList[I].Name, ' = ', ParamList[I].Value);
    finally
      ParamList.Free;
    end;
    WriteLn;
    
    WriteLn('=== Fim do Exemplo ===');
    
  except
    on E: Exception do
      WriteLn('ERRO: ', E.Message);
  end;
  
  ReadLn;
end.</code></pre>

<div style="background: #d1ecf1; border-left: 4px solid #0c5460; padding: 20px; margin: 30px 0; border-radius: 4px;">
    <h3 style="color: #0c5460; margin-top: 0;">💡 Dicas e Boas Práticas</h3>
    <div style="color: #0c5460;">
        <ul style="line-height: 1.8;">
            <li><strong>Use AutoCreateTable(True)</strong> durante desenvolvimento - cria a estrutura automaticamente</li>
            <li><strong>Sempre preencha hierarquia completa</strong> - ContratoID, ProdutoID e Title são obrigatórios</li>
            <li><strong>Use Setter() em vez de Insert()</strong> - ele insere ou atualiza automaticamente</li>
            <li><strong>Libere memória</strong> - TParameter e TParameterList devem ser liberados com Free</li>
            <li><strong>Use interfaces</strong> - IParametersDatabase tem contagem de referência automática</li>
            <li><strong>Configure filtros uma vez</strong> - ContratoID() e ProdutoID() persistem na instância</li>
            <li><strong>Verifique Assigned()</strong> - Getter() retorna nil se não encontrar</li>
            <li><strong>Organize por Title</strong> - Use títulos como 'ERP', 'CRM', 'Financeiro' para modularizar</li>
        </ul>
    </div>
</div>

<h2 style="color: #2c3e50; margin-top: 30px;">🔗 Próximos Passos</h2>

<div style="background: #fff9c4; border-left: 4px solid #f57f17; padding: 20px; margin: 20px 0; border-radius: 4px;">
    <p style="margin: 0;"><strong>👉 Aprofunde-se:</strong></p>
    <ul style="margin: 10px 0; line-height: 1.8;">
        <li><strong>Roteiro de Uso:</strong> Exemplos práticos de uso com Database, INI e JSON</li>
        <li><strong>Roteiro de Uso → Externo:</strong> Documentação completa das interfaces (IParameters, IParametersDatabase, IParametersInifiles, IParametersJsonObject)</li>
        <li><strong>Units Internas:</strong> Detalhes técnicos de implementação (apenas para desenvolvedores avançados)</li>
    </ul>
</div>
'''
