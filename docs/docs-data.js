// Documentacao completa do Parameters ORM v1.0.0
// Gerado automaticamente - Nao editar manualmente

const documentation = {
    "overview": {
        "title": "Visao Geral",
        "path": "Parameters ORM v1.0.2",
        "description": "\n<div style=\"background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px;\">\n    <h2 style=\"color: white; margin-top: 0;\">🔧 Parameters ORM v1.0.2</h2>\n    <p style=\"font-size: 1.1em; line-height: 1.6;\">\n        Sistema unificado de gerenciamento de parâmetros de configuração para Delphi/Free Pascal, \n        com suporte a múltiplas fontes de dados (Banco de Dados, Arquivos INI, Objetos JSON) e fallback automático.\n    </p>\n    <div style=\"margin-top: 20px; padding: 15px; background: rgba(255,255,255,0.1); border-radius: 5px;\">\n        <strong>Status:</strong> ✅ Pronto para Uso em Produção | \n        <strong>Versão:</strong> 1.0.2 | \n        <strong>Completude:</strong> ~95%\n    </div>\n</div>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">📋 O que é o Parameters ORM?</h2>\n\n<p style=\"font-size: 1.05em; line-height: 1.8;\">\n    O <strong>Parameters ORM v1.0.2</strong> é um módulo que elimina a complexidade de gerenciar configurações \n    de aplicação, permitindo armazenar e recuperar parâmetros de múltiplas fontes com hierarquia completa e fallback automático.\n</p>\n\n<h3 style=\"color: #34495e; margin-top: 25px;\">🎯 Quando Usar</h3>\n<ul style=\"line-height: 1.8; margin-left: 20px;\">\n    <li><strong>Aplicações que precisam de configuração flexível:</strong> Permite alternar entre Database, INI e JSON sem mudar o código</li>\n    <li><strong>Sistemas com requisito de contingência:</strong> Fallback automático garante disponibilidade mesmo se uma fonte falhar</li>\n    <li><strong>Aplicações multi-tenant:</strong> Suporte nativo a ContratoID e ProdutoID para isolamento de dados</li>\n    <li><strong>Migração de configurações:</strong> Importação/Exportação facilita migração entre fontes</li>\n</ul>\n\n<h3 style=\"color: #34495e; margin-top: 25px;\">📦 Requisitos</h3>\n<ul style=\"line-height: 1.8; margin-left: 20px;\">\n    <li><strong>Compiladores:</strong> Delphi 10.1 ou superior OU Free Pascal (FPC) 3.0 ou superior</li>\n    <li><strong>Bibliotecas de Banco de Dados</strong> (uma das seguintes):\n        <ul style=\"margin-left: 20px;\">\n            <li>UniDAC (Devart)</li>\n            <li>FireDAC (Embarcadero)</li>\n            <li>Zeos (Open Source)</li>\n        </ul>\n    </li>\n</ul>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;\">\n    <h4 style=\"margin-top: 0; color: #856404;\">⚙️ Configuração de Diretivas</h4>\n    <p style=\"color: #856404;\">No arquivo <code>ParamentersORM.Defines.inc</code>, defina qual engine será usado:</p>\n    <pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>// Para usar UniDAC\n{$DEFINE USE_UNIDAC}\n\n// Para usar FireDAC\n{$DEFINE USE_FIREDAC}\n\n// Para usar Zeos\n{$DEFINE USE_ZEOS}</code></pre>\n    <p style=\"color: #856404; margin-bottom: 0;\"><strong>⚠️ Importante:</strong> Apenas uma diretiva deve estar ativa por vez.</p>\n</div>\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">✨ Funcionalidades Principais</h3>\n    <ul style=\"line-height: 1.8;\">\n        <li><strong>Múltiplas Fontes:</strong> Database, INI Files, JSON Objects</li>\n        <li><strong>Fallback Automático:</strong> Busca em cascata (Database → INI → JSON)</li>\n        <li><strong>Multi-Engine:</strong> UniDAC, FireDAC, Zeos</li>\n        <li><strong>Multi-Database:</strong> PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC</li>\n        <li><strong>Thread-Safe:</strong> Proteção com TCriticalSection</li>\n        <li><strong>Hierarquia Completa:</strong> ContratoID + ProdutoID + Title + Name</li>\n        <li><strong>Import/Export:</strong> Bidirecional entre todas as fontes</li>\n        <li><strong>Fluent Interface:</strong> Métodos encadeáveis para código limpo</li>\n    </ul>\n</div>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">🚀 Começando - Instalação</h2>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">1. Adicionar Units ao Uses</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  System.SysUtils,\n  Parameters;              // ✨ Apenas esta unit para começar!</code></pre>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">2. Criar Instância e Conectar</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>var\n  DB: IParametersDatabase;\nbegin\n  // 1️⃣ Criar instância\n  DB := TParameters.NewDatabase;\n  \n  // 2️⃣ Configurar conexão (SQLite exemplo)\n  DB.DatabaseType('SQLite')\n    .Database('C:\\Config\\params.db')\n    .TableName('config')\n    .AutoCreateTable(True);  // ✨ Cria tabela automaticamente!\n  \n  // 3️⃣ Conectar\n  DB.Connect;\n  \n  // 4️⃣ Usar...\n  // (exemplos nas próximas seções)\nend;</code></pre>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">📝 CRUD Básico - Primeiros Passos</h2>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">CREATE - Inserir Parâmetro</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>var\n  Param: TParameter;\nbegin\n  Param := TParameter.Create;\n  try\n    // Preencher hierarquia COMPLETA (obrigatório!)\n    Param.ContratoID := 1;        // ✅ DEVE SER > 0\n    Param.ProdutoID := 1;         // ✅ DEVE SER > 0\n    Param.Titulo := 'ERP';        // ✅ Seção/Módulo\n    Param.Name := 'servidor_api'; // ✅ Chave única\n    Param.Value := 'https://api.exemplo.com';\n    Param.ValueType := pvtString;\n    Param.Description := 'URL do servidor de API';\n    Param.Ordem := 1;\n    Param.Ativo := True;\n    \n    // Inserir (usa Setter - insere ou atualiza automaticamente)\n    DB.Setter(Param);\n    WriteLn('✅ Parâmetro salvo!');\n  finally\n    Param.Free;\n  end;\nend;</code></pre>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">READ - Buscar Parâmetro</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>var\n  Param: TParameter;\nbegin\n  // Configurar hierarquia antes de buscar\n  DB.ContratoID(1)\n    .ProdutoID(1)\n    .Title('ERP');\n  \n  // Buscar parâmetro\n  Param := DB.Getter('servidor_api');\n  try\n    if Assigned(Param) then\n    begin\n      WriteLn('Valor: ' + Param.Value);\n      WriteLn('Título: ' + Param.Titulo);\n      WriteLn('Descrição: ' + Param.Description);\n    end\n    else\n      WriteLn('❌ Parâmetro não encontrado!');\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\nend;</code></pre>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">UPDATE - Atualizar Parâmetro</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>var\n  Param: TParameter;\nbegin\n  // Buscar existente\n  DB.ContratoID(1).ProdutoID(1).Title('ERP');\n  Param := DB.Getter('servidor_api');\n  \n  if Assigned(Param) then\n  begin\n    try\n      // Modificar valor\n      Param.Value := 'https://nova-api.exemplo.com';\n      \n      // Atualizar (Setter atualiza se já existe)\n      DB.Setter(Param);\n      WriteLn('✅ Parâmetro atualizado!');\n    finally\n      Param.Free;\n    end;\n  end;\nend;</code></pre>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">DELETE - Remover Parâmetro</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>begin\n  // Configurar hierarquia\n  DB.ContratoID(1).ProdutoID(1).Title('ERP');\n  \n  // Deletar (soft delete - marca como inativo)\n  DB.Delete('servidor_api');\n  \n  WriteLn('✅ Parâmetro deletado!');\nend;</code></pre>\n\n<h3 style=\"color: #34495e; margin-top: 20px;\">LIST - Listar Todos os Parâmetros</h3>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>var\n  ParamList: TParameterList;\n  I: Integer;\nbegin\n  // Configurar filtros\n  DB.ContratoID(1).ProdutoID(1).Title('ERP');\n  \n  // Listar todos\n  ParamList := DB.List;\n  try\n    WriteLn('Total: ', ParamList.Count);\n    \n    for I := 0 to ParamList.Count - 1 do\n    begin\n      WriteLn(Format('%s = %s', [\n        ParamList[I].Name,\n        ParamList[I].Value\n      ]));\n    end;\n  finally\n    ParamList.Free;\n  end;\nend;</code></pre>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 4px;\">\n    <h3 style=\"color: #856404; margin-top: 0;\">⚠️ Regras de Negócio - Hierarquia Completa</h3>\n    <div style=\"color: #856404;\">\n        <p><strong>IMPORTANTE:</strong> Todos os métodos CRUD respeitam a hierarquia completa de identificação:</p>\n        \n        <h4 style=\"margin-top: 15px;\">Constraint UNIQUE:</h4>\n        <p><code>ContratoID + ProdutoID + Title + Name</code></p>\n        <p>Esta combinação deve ser ÚNICA. Não pode haver duplicatas.</p>\n        \n        <h4 style=\"margin-top: 15px;\">Comportamento dos Métodos:</h4>\n        <ul>\n            <li><strong>Getter():</strong> Busca específica quando hierarquia configurada, busca ampla quando não configurada</li>\n            <li><strong>Setter():</strong> Sempre requer hierarquia completa. Insere se não existir, atualiza se existir</li>\n            <li><strong>Delete():</strong> Respeita hierarquia completa. Soft delete (marca como inativo)</li>\n            <li><strong>Exists():</strong> Respeita hierarquia completa</li>\n            <li><strong>List():</strong> Retorna apenas parâmetros ativos que correspondem aos filtros</li>\n        </ul>\n        \n        <h4 style=\"margin-top: 15px;\">Nomenclatura Recomendada:</h4>\n        <ul>\n            <li>✅ Use <code>Getter()</code> em vez de <code>Get()</code> (deprecated)</li>\n            <li>✅ Use <code>Setter()</code> em vez de <code>Update()</code> (deprecated)</li>\n        </ul>\n    </div>\n</div>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">💡 Tipos de Valor Suportados</h2>\n\n<table style=\"width: 100%; border-collapse: collapse; margin: 20px 0;\">\n    <thead>\n        <tr style=\"background: #3498db; color: white;\">\n            <th style=\"padding: 12px; text-align: left; border: 1px solid #ddd;\">Tipo</th>\n            <th style=\"padding: 12px; text-align: left; border: 1px solid #ddd;\">Enum</th>\n            <th style=\"padding: 12px; text-align: left; border: 1px solid #ddd;\">Descrição</th>\n            <th style=\"padding: 12px; text-align: left; border: 1px solid #ddd;\">Exemplo</th>\n        </tr>\n    </thead>\n    <tbody>\n        <tr style=\"background: #f8f9fa;\">\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">String</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\"><code>pvtString</code></td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Texto genérico</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">'localhost'</td>\n        </tr>\n        <tr>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Integer</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\"><code>pvtInteger</code></td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Número inteiro</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">5432</td>\n        </tr>\n        <tr style=\"background: #f8f9fa;\">\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Float</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\"><code>pvtFloat</code></td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Número decimal</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">3.14</td>\n        </tr>\n        <tr>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Boolean</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\"><code>pvtBoolean</code></td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Verdadeiro/Falso</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">True / False</td>\n        </tr>\n        <tr style=\"background: #f8f9fa;\">\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">DateTime</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\"><code>pvtDateTime</code></td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Data e hora</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Now</td>\n        </tr>\n        <tr>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">JSON</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\"><code>pvtJSON</code></td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">Objeto JSON</td>\n            <td style=\"padding: 12px; border: 1px solid #ddd;\">{\"key\":\"value\"}</td>\n        </tr>\n    </tbody>\n</table>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">📚 Arquitetura - Units Públicas</h2>\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">🔓 Units Públicas (API Externa)</h3>\n    <p>O módulo Parameters expõe apenas <strong>2 units públicas</strong>:</p>\n    <ul style=\"line-height: 1.8;\">\n        <li><strong><code>Parameters.pas</code></strong> - Ponto de entrada com Factory methods (TParameters.New, TParameters.NewDatabase, etc.)</li>\n        <li><strong><code>Parameters.Interfaces.pas</code></strong> - Todas as interfaces públicas (IParameters, IParametersDatabase, IParametersInifiles, IParametersJsonObject)</li>\n    </ul>\n    \n    <h4 style=\"margin-top: 15px;\">⚠️ IMPORTANTE:</h4>\n    <p><strong>NÃO use units internas diretamente!</strong> Units como <code>Parameters.Database</code>, <code>Parameters.Inifiles</code>, <code>Parameters.JsonObject</code>, etc. são internas e podem mudar sem aviso. Use sempre os Factory methods de <code>Parameters.pas</code>.</p>\n</div>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">🎯 Exemplo Completo - Aplicação Simples</h2>\n\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>program ExemploParameters;\n\n{$APPTYPE CONSOLE}\n\nuses\n  System.SysUtils,\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Param: TParameter;\n  ParamList: TParameterList;\n  I: Integer;\n\nbegin\n  try\n    WriteLn('=== Parameters ORM - Exemplo Completo ===');\n    WriteLn;\n    \n    // 1️⃣ CONECTAR\n    WriteLn('[1] Conectando ao banco...');\n    DB := TParameters.NewDatabase;\n    DB.DatabaseType('SQLite')\n      .Database('C:\\Config\\params.db')\n      .TableName('config')\n      .AutoCreateTable(True)\n      .Connect;\n    WriteLn('✅ Conectado!');\n    WriteLn;\n    \n    // 2️⃣ INSERIR\n    WriteLn('[2] Inserindo parâmetros...');\n    Param := TParameter.Create;\n    try\n      Param.ContratoID := 1;\n      Param.ProdutoID := 1;\n      Param.Titulo := 'ERP';\n      Param.Name := 'servidor_api';\n      Param.Value := 'https://api.exemplo.com';\n      Param.ValueType := pvtString;\n      Param.Description := 'URL do servidor de API';\n      DB.Setter(Param);\n      WriteLn('✅ Parâmetro inserido!');\n    finally\n      Param.Free;\n    end;\n    WriteLn;\n    \n    // 3️⃣ BUSCAR\n    WriteLn('[3] Buscando parâmetro...');\n    DB.ContratoID(1).ProdutoID(1).Title('ERP');\n    Param := DB.Getter('servidor_api');\n    try\n      if Assigned(Param) then\n        WriteLn('✅ Encontrado: ' + Param.Value)\n      else\n        WriteLn('❌ Não encontrado!');\n    finally\n      if Assigned(Param) then\n        Param.Free;\n    end;\n    WriteLn;\n    \n    // 4️⃣ LISTAR\n    WriteLn('[4] Listando todos os parâmetros...');\n    ParamList := DB.List;\n    try\n      WriteLn('Total: ', ParamList.Count);\n      for I := 0 to ParamList.Count - 1 do\n        WriteLn('  - ', ParamList[I].Name, ' = ', ParamList[I].Value);\n    finally\n      ParamList.Free;\n    end;\n    WriteLn;\n    \n    WriteLn('=== Fim do Exemplo ===');\n    \n  except\n    on E: Exception do\n      WriteLn('ERRO: ', E.Message);\n  end;\n  \n  ReadLn;\nend.</code></pre>\n\n<div style=\"background: #d1ecf1; border-left: 4px solid #0c5460; padding: 20px; margin: 30px 0; border-radius: 4px;\">\n    <h3 style=\"color: #0c5460; margin-top: 0;\">💡 Dicas e Boas Práticas</h3>\n    <div style=\"color: #0c5460;\">\n        <ul style=\"line-height: 1.8;\">\n            <li><strong>Use AutoCreateTable(True)</strong> durante desenvolvimento - cria a estrutura automaticamente</li>\n            <li><strong>Sempre preencha hierarquia completa</strong> - ContratoID, ProdutoID e Title são obrigatórios</li>\n            <li><strong>Use Setter() em vez de Insert()</strong> - ele insere ou atualiza automaticamente</li>\n            <li><strong>Libere memória</strong> - TParameter e TParameterList devem ser liberados com Free</li>\n            <li><strong>Use interfaces</strong> - IParametersDatabase tem contagem de referência automática</li>\n            <li><strong>Configure filtros uma vez</strong> - ContratoID() e ProdutoID() persistem na instância</li>\n            <li><strong>Verifique Assigned()</strong> - Getter() retorna nil se não encontrar</li>\n            <li><strong>Organize por Title</strong> - Use títulos como 'ERP', 'CRM', 'Financeiro' para modularizar</li>\n        </ul>\n    </div>\n</div>\n\n<h2 style=\"color: #2c3e50; margin-top: 30px;\">🔗 Próximos Passos</h2>\n\n<div style=\"background: #fff9c4; border-left: 4px solid #f57f17; padding: 20px; margin: 20px 0; border-radius: 4px;\">\n    <p style=\"margin: 0;\"><strong>👉 Aprofunde-se:</strong></p>\n    <ul style=\"margin: 10px 0; line-height: 1.8;\">\n        <li><strong>Roteiro de Uso:</strong> Exemplos práticos de uso com Database, INI e JSON</li>\n        <li><strong>Roteiro de Uso → Externo:</strong> Documentação completa das interfaces (IParameters, IParametersDatabase, IParametersInifiles, IParametersJsonObject)</li>\n        <li><strong>Units Internas:</strong> Detalhes técnicos de implementação (apenas para desenvolvedores avançados)</li>\n    </ul>\n</div>\n"
    },
    "usageGuide": {
        "title": "Roteiro de Uso",
        "path": "Guia Prático",
        "description": "\n<h2 style=\"color: #2c3e50; margin-top: 0;\">🚀 Roteiro de Uso - Parameters ORM v1.0.2</h2>\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 15px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 O que é o Parameters ORM?</h3>\n    <p>O <strong>Parameters ORM v1.0.2</strong> é um sistema unificado de gerenciamento de parâmetros de configuração que permite armazenar e recuperar configurações de múltiplas fontes de dados com fallback automático.</p>\n    \n    <h4 style=\"color: #2c3e50; margin-top: 15px;\">Units Públicas:</h4>\n    <ul>\n        <li><strong><code>Parameters.pas</code></strong> - Factory class (TParameters) para criar instâncias</li>\n        <li><strong><code>Parameters.Interfaces.pas</code></strong> - Todas as interfaces públicas</li>\n    </ul>\n    \n    <h4 style=\"color: #2c3e50; margin-top: 15px;\">✅ Funcionalidades:</h4>\n    <ul>\n        <li>✅ Múltiplas fontes: Database, INI Files, JSON Objects</li>\n        <li>✅ Fallback automático em cascata</li>\n        <li>✅ Suporte a 7 tipos de banco (PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC)</li>\n        <li>✅ Suporte a 3 engines (UniDAC, FireDAC, Zeos)</li>\n        <li>✅ Thread-safe (proteção com TCriticalSection)</li>\n        <li>✅ Hierarquia completa: ContratoID + ProdutoID + Title + Name</li>\n        <li>✅ Importação/Exportação bidirecional entre fontes</li>\n    </ul>\n</div>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">1. Começando - Primeiro Uso (Sem Attributes)</h3>\n\n<div style=\"background: #f0f8ff; border-left: 4px solid #2196f3; padding: 15px; margin: 20px 0;\">\n    <h4 style=\"color: #1976d2; margin-top: 0;\">💡 Sem Attributes vs Com Attributes - Qual Usar?</h4>\n    \n    <div style=\"background: white; padding: 15px; margin: 15px 0; border-radius: 5px;\">\n        <h5 style=\"color: #2e7d32; margin-top: 0;\">✅ SEM Attributes (Abordagem Direta)</h5>\n        <p><strong>O que é:</strong> Código puro, sem decorators. Você chama os métodos diretamente das interfaces.</p>\n        \n        <p><strong>✅ Benefícios:</strong></p>\n        <ul>\n            <li><strong>Simplicidade:</strong> Mais fácil de entender e debugar</li>\n            <li><strong>Performance:</strong> Zero overhead de reflexão (RTTI)</li>\n            <li><strong>Controle Total:</strong> Você decide exatamente o que fazer em cada linha</li>\n            <li><strong>Compatibilidade:</strong> Funciona em qualquer versão do Delphi/FPC</li>\n            <li><strong>Curva de Aprendizado:</strong> Rápida - ideal para iniciantes</li>\n        </ul>\n        \n        <p><strong>❌ Desvantagens:</strong></p>\n        <ul>\n            <li>Mais código repetitivo (boilerplate)</li>\n            <li>Mapeamento manual classe ↔ tabela</li>\n            <li>Sem validação automática em tempo de compilação</li>\n        </ul>\n    </div>\n    \n    <div style=\"background: white; padding: 15px; margin: 15px 0; border-radius: 5px;\">\n        <h5 style=\"color: #d32f2f; margin-top: 0;\">⚡ COM Attributes (Abordagem Declarativa)</h5>\n        <p><strong>O que é:</strong> Usa decorators como <code>[Table]</code>, <code>[Column]</code>, <code>[Required]</code> para mapear e validar automaticamente.</p>\n        \n        <p><strong>✅ Benefícios:</strong></p>\n        <ul>\n            <li><strong>Código Limpo:</strong> Menos linhas, mais declarativo</li>\n            <li><strong>Auto-Documentado:</strong> Attributes servem como documentação</li>\n            <li><strong>Validação Automática:</strong> <code>[Required]</code>, <code>[Email]</code>, <code>[Range]</code> validam antes de salvar</li>\n            <li><strong>Mapeamento Automático:</strong> Classe ↔ Tabela mapeado via reflexão</li>\n            <li><strong>Integração ORM:</strong> Perfeito para sistemas complexos com muitas entidades</li>\n        </ul>\n        \n        <p><strong>❌ Desvantagens:</strong></p>\n        <ul>\n            <li><strong>Performance:</strong> Overhead de RTTI (reflexão em runtime)</li>\n            <li><strong>Complexidade:</strong> Curva de aprendizado maior</li>\n            <li><strong>Debug:</strong> Mais difícil de rastrear erros (código gerado dinamicamente)</li>\n            <li><strong>Compatibilidade:</strong> Requer RTTI habilitado (<code>{$M+}</code>)</li>\n        </ul>\n    </div>\n    \n    <div style=\"background: #fff9c4; padding: 15px; margin: 15px 0; border-radius: 5px; border: 1px solid #f57f17;\">\n        <p style=\"margin: 0;\"><strong>👉 Recomendação:</strong></p>\n        <ul style=\"margin: 10px 0;\">\n            <li><strong>Iniciantes:</strong> Comece <strong>SEM Attributes</strong> (Seções 1-6)</li>\n            <li><strong>Projetos Simples:</strong> Use <strong>SEM Attributes</strong> (mais rápido e direto)</li>\n            <li><strong>Projetos Grandes/ORM:</strong> Use <strong>COM Attributes</strong> (Seção 7) para reduzir boilerplate</li>\n        </ul>\n    </div>\n</div>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">1.1. Usar Database (Sem Attributes)</h4>\n<p>Este é o exemplo mais simples e comum: conectar ao banco, inserir e buscar um parâmetro.</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;  // Apenas esta unit!\n\nvar\n  DB: IParametersDatabase;\n  Param: TParameter;\nbegin\n  // 1️⃣ Criar e conectar ao banco\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Port(5432)\n    .Database('mydb')\n    .Username('postgres')\n    .Password('senha')\n    .TableName('config')\n    .Schema('public')\n    .AutoCreateTable(True)  // ✨ Cria tabela automaticamente!\n    .Connect;\n  \n  // 2️⃣ Inserir um parâmetro\n  Param := TParameter.Create;\n  Param.ContratoID := 1;\n  Param.ProdutoID := 1;\n  Param.Titulo := 'ERP';\n  Param.Name := 'servidor_api';\n  Param.Value := 'https://api.exemplo.com';\n  Param.ValueType := pvtString;\n  Param.Description := 'URL do servidor de API';\n  \n  DB.Setter(Param);  // Insere ou atualiza automaticamente!\n  Param.Free;\n  \n  // 3️⃣ Buscar o parâmetro\n  DB.ContratoID(1).ProdutoID(1).Title('ERP');\n  Param := DB.Getter('servidor_api');\n  try\n    if Assigned(Param) then\n      ShowMessage('Servidor: ' + Param.Value);  // Mostra: https://api.exemplo.com\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">1.2. Usar Arquivo INI (Sem Attributes)</h4>\n<p>Perfeito para aplicações desktop que não querem depender de banco de dados:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  Ini: IParametersInifiles;\n  Param: TParameter;\nbegin\n  // 1️⃣ Criar arquivo INI\n  Ini := TParameters.NewInifiles\n    .FilePath('C:\\Config\\app.ini')\n    .Section('ERP')\n    .AutoCreateFile(True)  // ✨ Cria arquivo se não existir!\n    .ContratoID(1)\n    .ProdutoID(1);\n  \n  // 2️⃣ Inserir parâmetro\n  Param := TParameter.Create;\n  Param.ContratoID := 1;\n  Param.ProdutoID := 1;\n  Param.Titulo := 'ERP';\n  Param.Name := 'servidor_api';\n  Param.Value := 'https://api.exemplo.com';\n  \n  Ini.Setter(Param);\n  Param.Free;\n  \n  // 3️⃣ Buscar parâmetro\n  Param := Ini.Getter('servidor_api');\n  try\n    if Assigned(Param) then\n      ShowMessage('Servidor: ' + Param.Value);\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\n  \n  // O arquivo app.ini foi criado com:\n  // [ERP]\n  // servidor_api=https://api.exemplo.com\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">1.3. Usar JSON (Sem Attributes)</h4>\n<p>Ideal para integração com APIs REST e aplicações modernas:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  Json: IParametersJsonObject;\n  Param: TParameter;\nbegin\n  // 1️⃣ Criar JSON\n  Json := TParameters.NewJsonObject\n    .FilePath('C:\\Config\\app.json')\n    .ObjectName('ERP')\n    .AutoCreateFile(True)\n    .ContratoID(1)\n    .ProdutoID(1);\n  \n  // 2️⃣ Inserir parâmetro\n  Param := TParameter.Create;\n  Param.ContratoID := 1;\n  Param.ProdutoID := 1;\n  Param.Titulo := 'ERP';\n  Param.Name := 'servidor_api';\n  Param.Value := 'https://api.exemplo.com';\n  \n  Json.Setter(Param);\n  Param.Free;\n  \n  // 3️⃣ Buscar parâmetro\n  Param := Json.Getter('servidor_api');\n  try\n    if Assigned(Param) then\n      ShowMessage('Servidor: ' + Param.Value);\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\n  \n  // O arquivo app.json foi criado com:\n  // {\n  //   \"ERP\": {\n  //     \"servidor_api\": \"https://api.exemplo.com\"\n  //   }\n  // }\nend;</code></pre>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">2. Convergência - Múltiplas Fontes com Fallback</h3>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">2.1. Fallback Automático (Database → INI → JSON)</h4>\n<p>O sistema tenta buscar em cada fonte automaticamente até encontrar o parâmetro:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  P: IParameters;\n  Param: TParameter;\nbegin\n  // 1️⃣ Criar com múltiplas fontes\n  P := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);\n  \n  // 2️⃣ Configurar Database (prioridade 1)\n  P.Database\n    .Host('localhost')\n    .Database('mydb')\n    .TableName('config')\n    .Connect;\n  \n  // 3️⃣ Configurar INI (fallback se Database falhar)\n  P.Inifiles\n    .FilePath('C:\\Config\\app.ini')\n    .Section('ERP');\n  \n  // 4️⃣ Configurar JSON (último fallback)\n  P.JsonObject\n    .FilePath('C:\\Config\\app.json')\n    .ObjectName('ERP');\n  \n  // 5️⃣ Buscar com fallback automático\n  P.ContratoID(1).ProdutoID(1);\n  P.Database.Title('ERP');\n  P.Inifiles.Title('ERP');\n  P.JsonObject.Title('ERP');\n  \n  Param := P.Getter('servidor_api');\n  // ✨ Busca AUTOMATICAMENTE:\n  // 1º Database → se não encontrar...\n  // 2º INI → se não encontrar...\n  // 3º JSON → se não encontrar... retorna nil\n  \n  try\n    if Assigned(Param) then\n      ShowMessage('Encontrado: ' + Param.Value);\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">2.2. Listar de Todas as Fontes (Merge)</h4>\n<p>Combina parâmetros de todas as fontes, removendo duplicatas:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  P: IParameters;\n  ParamList: TParameterList;\n  I: Integer;\nbegin\n  P := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);\n  \n  // Configurar fontes...\n  P.Database.Host('localhost').Database('mydb').Connect;\n  P.Inifiles.FilePath('C:\\Config\\app.ini');\n  P.JsonObject.FilePath('C:\\Config\\app.json');\n  \n  // Listar TUDO (merge de todas as fontes)\n  ParamList := P.List;\n  // ✨ Remove duplicatas automaticamente!\n  // Se mesmo parâmetro existe em Database e INI, mostra apenas 1 vez\n  \n  try\n    for I := 0 to ParamList.Count - 1 do\n      ShowMessage(ParamList[I].Name + ' = ' + ParamList[I].Value);\n  finally\n    ParamList.Free;\n  end;\nend;</code></pre>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">3. Hierarquia Completa - Organizando Parâmetros</h3>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">3.1. Entendendo a Hierarquia (ContratoID + ProdutoID + Title + Name)</h4>\n<p>A hierarquia permite organizar parâmetros por contrato, produto e seção:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Param: TParameter;\nbegin\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .Connect;\n  \n  // Inserir parâmetro para CONTRATO 1, PRODUTO 1, seção ERP\n  Param := TParameter.Create;\n  Param.ContratoID := 1;        // Empresa A\n  Param.ProdutoID := 1;         // Sistema ERP\n  Param.Titulo := 'ERP';        // Seção/Módulo\n  Param.Name := 'servidor_api'; // Chave\n  Param.Value := 'https://empresa-a-erp.com';\n  DB.Setter(Param);\n  Param.Free;\n  \n  // Inserir MESMO parâmetro para CONTRATO 2 (outra empresa)\n  Param := TParameter.Create;\n  Param.ContratoID := 2;        // Empresa B\n  Param.ProdutoID := 1;         // Sistema ERP\n  Param.Titulo := 'ERP';\n  Param.Name := 'servidor_api'; // Mesma chave!\n  Param.Value := 'https://empresa-b-erp.com';  // Valor diferente!\n  DB.Setter(Param);\n  Param.Free;\n  \n  // Buscar para Empresa A\n  DB.ContratoID(1).ProdutoID(1).Title('ERP');\n  Param := DB.Getter('servidor_api');\n  ShowMessage(Param.Value);  // https://empresa-a-erp.com\n  Param.Free;\n  \n  // Buscar para Empresa B\n  DB.ContratoID(2).ProdutoID(1).Title('ERP');\n  Param := DB.Getter('servidor_api');\n  ShowMessage(Param.Value);  // https://empresa-b-erp.com\n  Param.Free;\n  \n  // ✨ Mesma chave, valores diferentes por hierarquia!\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">3.2. Múltiplas Seções (Títulos) no Mesmo Sistema</h4>\n<p>Organizar parâmetros por módulos/seções:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Param: TParameter;\nbegin\n  DB := TParameters.NewDatabase.Host('localhost').Database('mydb').Connect;\n  DB.ContratoID(1).ProdutoID(1);\n  \n  // Parâmetro do módulo ERP\n  DB.Title('ERP');\n  Param := DB.Getter('servidor_api');\n  ShowMessage('ERP: ' + Param.Value);  // https://erp.exemplo.com\n  Param.Free;\n  \n  // Parâmetro do módulo CRM (MESMA chave, seção diferente!)\n  DB.Title('CRM');\n  Param := DB.Getter('servidor_api');\n  ShowMessage('CRM: ' + Param.Value);  // https://crm.exemplo.com\n  Param.Free;\n  \n  // Parâmetro do módulo Financeiro\n  DB.Title('Financeiro');\n  Param := DB.Getter('servidor_api');\n  ShowMessage('Financeiro: ' + Param.Value);  // https://financeiro.exemplo.com\n  Param.Free;\n  \n  // ✨ Mesma chave em seções diferentes = valores diferentes!\nend;</code></pre>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">4. Importação e Exportação entre Fontes</h4>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">4.1. Exportar Database → INI (Backup)</h4>\n<p>Fazer backup dos parâmetros do banco para arquivo INI:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Ini: IParametersInifiles;\nbegin\n  // Fonte: Database\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .Connect;\n  \n  // Destino: INI\n  Ini := TParameters.NewInifiles\n    .FilePath('C:\\Backup\\config_backup.ini')\n    .AutoCreateFile(True);\n  \n  // Exportar Database → INI\n  Ini.ImportFromDatabase(DB);\n  // ✨ Todos os parâmetros do banco foram salvos no INI!\n  \n  ShowMessage('Backup criado em: C:\\Backup\\config_backup.ini');\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">4.2. Importar INI → Database (Restaurar)</h4>\n<p>Restaurar parâmetros do arquivo INI para o banco:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Ini: IParametersInifiles;\nbegin\n  // Fonte: INI\n  Ini := TParameters.NewInifiles\n    .FilePath('C:\\Backup\\config_backup.ini');\n  \n  // Destino: Database\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .Connect;\n  \n  // Importar INI → Database\n  DB.ImportFromInifiles(Ini);\n  // ✨ Todos os parâmetros do INI foram salvos no banco!\n  \n  ShowMessage('Parâmetros restaurados no banco de dados!');\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">4.3. Migrar Database → JSON</h4>\n<p>Migrar parâmetros do banco para JSON:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Json: IParametersJsonObject;\nbegin\n  // Fonte: Database\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .Connect;\n  \n  // Destino: JSON\n  Json := TParameters.NewJsonObject\n    .FilePath('C:\\Config\\params.json')\n    .AutoCreateFile(True);\n  \n  // Migrar Database → JSON\n  Json.ImportFromDatabase(DB);\n  // ✨ Todos os parâmetros agora estão em JSON!\n  \n  ShowMessage('Migração concluída!');\n  ShowMessage(Json.ToJSONString);  // Ver JSON formatado\nend;</code></pre>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">5. Operações Avançadas</h3>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">5.1. Listar Tabelas e Bancos Disponíveis</h4>\n<p>Descobrir quais bancos e tabelas estão disponíveis:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Databases, Tables: TStringList;\n  I: Integer;\nbegin\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Username('postgres')\n    .Password('senha')\n    .Connect;\n  \n  // Listar bancos disponíveis\n  Databases := DB.ListAvailableDatabases;\n  try\n    for I := 0 to Databases.Count - 1 do\n      ShowMessage('Banco: ' + Databases[I]);\n  finally\n    Databases.Free;\n  end;\n  \n  // Listar tabelas do banco atual\n  Tables := DB.ListAvailableTables;\n  try\n    for I := 0 to Tables.Count - 1 do\n      ShowMessage('Tabela: ' + Tables[I]);\n  finally\n    Tables.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">5.2. Criar e Dropar Tabelas Manualmente</h4>\n<p>Gerenciar tabelas de parâmetros:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\nbegin\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .TableName('config_teste')\n    .Connect;\n  \n  // Verificar se tabela existe\n  if not DB.TableExists then\n  begin\n    // Criar tabela\n    DB.CreateTable;\n    ShowMessage('Tabela criada com estrutura padrão!');\n  end;\n  \n  // Usar a tabela...\n  \n  // Remover tabela (CUIDADO!)\n  if MessageDlg('Deseja remover a tabela?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then\n  begin\n    DB.DropTable;\n    ShowMessage('Tabela removida!');\n  end;\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">5.3. Contar e Verificar Existência</h4>\n<p>Operações úteis de contagem e verificação:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\n  Total: Integer;\n  Existe: Boolean;\nbegin\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .ContratoID(1)\n    .ProdutoID(1)\n    .Title('ERP')\n    .Connect;\n  \n  // Contar parâmetros\n  Total := DB.Count;\n  ShowMessage('Total de parâmetros: ' + IntToStr(Total));\n  \n  // Verificar se parâmetro existe\n  Existe := DB.Exists('servidor_api');\n  if Existe then\n    ShowMessage('Parâmetro servidor_api existe!')\n  else\n    ShowMessage('Parâmetro servidor_api NÃO existe!');\nend;</code></pre>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 4px;\">\n    <div style=\"color: #856404; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;\">⚠️ Regras Importantes</div>\n    <div style=\"color: #856404;\">\n        <h4 style=\"margin-top: 10px;\">Hierarquia Completa (UNIQUE Constraint)</h4>\n        <p>A combinação <code>(ContratoID, ProdutoID, Title, Name)</code> é ÚNICA no banco. Não pode haver duplicatas.</p>\n        \n        <h4 style=\"margin-top: 10px;\">Métodos Getter vs Get (Deprecated)</h4>\n        <ul>\n            <li>✅ Use <code>Getter()</code> - Recomendado</li>\n            <li>❌ Evite <code>Get()</code> - Deprecated (será removido)</li>\n        </ul>\n        \n        <h4 style=\"margin-top: 10px;\">Métodos Setter vs Update (Deprecated)</h4>\n        <ul>\n            <li>✅ Use <code>Setter()</code> - Insere se não existir, atualiza se existir</li>\n            <li>❌ Evite <code>Update()</code> - Deprecated (será removido)</li>\n        </ul>\n        \n        <h4 style=\"margin-top: 10px;\">Liberar Memória</h4>\n        <p>Sempre libere objetos <code>TParameter</code> e <code>TParameterList</code> após uso:</p>\n        <pre style=\"background: #2c3e50; color: #ecf0f1; padding: 10px; border-radius: 4px;\"><code>Param := DB.Getter('chave');\ntry\n  // Usar Param...\nfinally\n  if Assigned(Param) then\n    Param.Free;\nend;</code></pre>\n    </div>\n</div>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">6. Exemplos Práticos Completos</h3>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">6.1. Sistema Multi-Empresa com Fallback</h4>\n<p>Sistema que busca configuração no banco e, se falhar, usa arquivo INI local:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nfunction GetConfiguracao(AContratoID, AProdutoID: Integer; AChave: string): string;\nvar\n  P: IParameters;\n  Param: TParameter;\nbegin\n  Result := '';\n  \n  // Criar com fallback Database → INI\n  P := TParameters.New([pcfDataBase, pcfInifile]);\n  \n  try\n    // Tentar conectar ao banco (pode falhar)\n    P.Database\n      .Host('servidor-remoto.com')\n      .Database('config_global')\n      .Username('user')\n      .Password('pass')\n      .TableName('parametros')\n      .Connect;\n  except\n    // Se banco falhar, INI será usado automaticamente\n  end;\n  \n  // Configurar INI (fallback local)\n  P.Inifiles\n    .FilePath(ExtractFilePath(ParamStr(0)) + 'config.ini')\n    .Section('Sistema');\n  \n  // Buscar com hierarquia\n  P.ContratoID(AContratoID).ProdutoID(AProdutoID);\n  P.Database.Title('Sistema');\n  P.Inifiles.Title('Sistema');\n  \n  Param := P.Getter(AChave);\n  try\n    if Assigned(Param) then\n      Result := Param.Value;\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\nend;\n\n// Usar:\nvar\n  ServidorAPI: string;\nbegin\n  ServidorAPI := GetConfiguracao(1, 1, 'servidor_api');\n  ShowMessage('API: ' + ServidorAPI);\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">6.2. Configuração Distribuída (Database + JSON Local)</h4>\n<p>Configurações globais no banco + configurações locais em JSON:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;\n\nvar\n  P: IParameters;\n  Param: TParameter;\nbegin\n  P := TParameters.New([pcfDataBase, pcfJsonObject]);\n  \n  // Configurações GLOBAIS (banco remoto)\n  P.Database\n    .Host('config-server.com')\n    .Database('global_config')\n    .TableName('parametros')\n    .Connect;\n  \n  // Configurações LOCAIS (JSON no computador)\n  P.JsonObject\n    .FilePath(ExtractFilePath(ParamStr(0)) + 'local_config.json')\n    .ObjectName('Local');\n  \n  // Configurar hierarquia\n  P.ContratoID(1).ProdutoID(1);\n  P.Database.Title('Global');\n  P.JsonObject.Title('Local');\n  \n  // Buscar GLOBAL primeiro, se não achar, busca LOCAL\n  Param := P.Getter('timeout_api');\n  try\n    if Assigned(Param) then\n      ShowMessage('Timeout: ' + Param.Value);\n  finally\n    if Assigned(Param) then\n      Param.Free;\n  end;\nend;</code></pre>\n\n<div style=\"background: #d1ecf1; border-left: 4px solid #0c5460; padding: 20px; margin: 30px 0; border-radius: 4px;\">\n    <div style=\"color: #0c5460; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;\">💡 Dicas e Boas Práticas</div>\n    <div style=\"color: #0c5460;\">\n        <ul>\n            <li><strong>Use AutoCreateTable(True)</strong> para desenvolvimento - cria a estrutura automaticamente</li>\n            <li><strong>Sempre configure hierarquia completa</strong> - ContratoID, ProdutoID e Title antes de buscar</li>\n            <li><strong>Use Setter() em vez de Insert()</strong> - ele insere ou atualiza automaticamente</li>\n            <li><strong>Libere memória</strong> - TParameter e TParameterList precisam ser liberados manualmente</li>\n            <li><strong>Use fallback para contingência</strong> - Database → INI garante que sempre terá configuração</li>\n            <li><strong>Organize por Title</strong> - Use títulos como \"ERP\", \"CRM\", \"Financeiro\" para modularizar</li>\n        </ul>\n    </div>\n</div>\n\n<h3 style=\"margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;\">7. Uso Avançado COM Attributes (Mapeamento Declarativo)</h3>\n\n<div style=\"background: #fff3e0; border-left: 4px solid #ff9800; padding: 15px; margin: 20px 0;\">\n    <h4 style=\"color: #e65100; margin-top: 0;\">⚡ O que são Attributes?</h4>\n    <p><strong>Attributes</strong> (ou decorators) permitem mapear classes Pascal para estruturas de dados usando anotações declarativas como <code>[Table]</code>, <code>[Column]</code>, etc.</p>\n    <p><strong>Vantagens:</strong></p>\n    <ul>\n        <li>Código mais limpo e declarativo</li>\n        <li>Mapeamento automático classe ↔ tabela</li>\n        <li>Validação em tempo de compilação</li>\n        <li>Integração com ORM e reflexão (RTTI)</li>\n    </ul>\n    <p><strong>Units Attributes disponíveis:</strong></p>\n    <ul>\n        <li><code>Parameters.Attributes.pas</code> - Attributes principais</li>\n        <li><code>Parameters.Attributes.Interfaces.pas</code> - Interfaces de Attributes</li>\n        <li><code>Parameters.Attributes.Types.pas</code> - Tipos de Attributes</li>\n        <li><code>Parameters.Attributes.Consts.pas</code> - Constantes de Attributes</li>\n        <li><code>Parameters.Attributes.Exceptions.pas</code> - Exceções de Attributes</li>\n    </ul>\n</div>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">7.1. Classe Mapeada com [Table] Attribute</h4>\n<p>Usar Attributes para mapear uma classe Pascal para uma tabela de parâmetros:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters,\n  Parameters.Attributes;  // ✨ Unit de Attributes!\n\n{$M+}  // Habilitar RTTI\ntype\n  [Table('config')]         // ✨ Mapeia para tabela 'config'\n  [Schema('public')]        // ✨ Schema do banco\n  TConfiguracao = class\n  private\n    FID: Integer;\n    FName: string;\n    FValue: string;\n    FDescription: string;\n  published\n    [PrimaryKey]            // ✨ Chave primária\n    [AutoIncrement]         // ✨ Auto incremento\n    property ID: Integer read FID write FID;\n    \n    [Column('name')]        // ✨ Nome da coluna no banco\n    [Required]              // ✨ Campo obrigatório\n    [MaxLength(100)]        // ✨ Validação de tamanho\n    property Name: string read FName write FName;\n    \n    [Column('value')]\n    property Value: string read FValue write FValue;\n    \n    [Column('description')]\n    property Description: string read FDescription write FDescription;\n  end;\n\nvar\n  DB: IParametersDatabase;\n  Config: TConfiguracao;\n  Param: TParameter;\nbegin\n  // 1️⃣ Conectar ao banco\n  DB := TParameters.NewDatabase\n    .Host('localhost')\n    .Database('mydb')\n    .Connect;\n  \n  // 2️⃣ Criar instância da classe mapeada\n  Config := TConfiguracao.Create;\n  try\n    Config.Name := 'servidor_api';\n    Config.Value := 'https://api.exemplo.com';\n    Config.Description := 'URL do servidor de API';\n    \n    // 3️⃣ Converter classe para TParameter usando RTTI\n    Param := TParameter.FromClass<TConfiguracao>(Config);\n    try\n      // 4️⃣ Inserir usando o parâmetro\n      DB.Setter(Param);\n      ShowMessage('Configuração inserida com Attributes!');\n    finally\n      Param.Free;\n    end;\n  finally\n    Config.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">7.2. Attributes de Validação</h4>\n<p>Usar Attributes para validar dados antes de inserir:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters,\n  Parameters.Attributes;\n\n{$M+}\ntype\n  [Table('config')]\n  TConfiguracao = class\n  private\n    FEmail: string;\n    FPorta: Integer;\n    FAtivo: Boolean;\n  published\n    [Column('email')]\n    [Required]              // ✨ Não pode ser vazio\n    [Email]                 // ✨ Valida formato de email\n    property Email: string read FEmail write FEmail;\n    \n    [Column('porta')]\n    [Required]\n    [Range(1, 65535)]       // ✨ Porta entre 1 e 65535\n    property Porta: Integer read FPorta write FPorta;\n    \n    [Column('ativo')]\n    property Ativo: Boolean read FAtivo write FAtivo;\n  end;\n\nvar\n  Config: TConfiguracao;\n  Param: TParameter;\nbegin\n  Config := TConfiguracao.Create;\n  try\n    Config.Email := 'admin@exemplo.com';  // ✅ Email válido\n    Config.Porta := 8080;                 // ✅ Porta válida\n    Config.Ativo := True;\n    \n    // Converter e validar automaticamente\n    Param := TParameter.FromClass<TConfiguracao>(Config);\n    try\n      // ✨ Se validação falhar, lança exceção!\n      ShowMessage('Validação passou!');\n    finally\n      Param.Free;\n    end;\n  finally\n    Config.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">7.3. Attributes de Comportamento</h4>\n<p>Controlar comportamento de campos com Attributes:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters,\n  Parameters.Attributes;\n\n{$M+}\ntype\n  [Table('config')]\n  TConfiguracao = class\n  private\n    FID: Integer;\n    FSenha: string;\n    FDataCriacao: TDateTime;\n    FVersao: string;\n  published\n    [PrimaryKey]\n    [AutoIncrement]\n    property ID: Integer read FID write FID;\n    \n    [Column('senha')]\n    [Encrypted]             // ✨ Campo será criptografado\n    property Senha: string read FSenha write FSenha;\n    \n    [Column('data_criacao')]\n    [Timestamp]             // ✨ Timestamp automático\n    [Default('NOW()')]      // ✨ Valor padrão no banco\n    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;\n    \n    [Ignore]                // ✨ NÃO será salvo no banco\n    property Versao: string read FVersao write FVersao;\n  end;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">7.4. Attributes de Auditoria</h4>\n<p>Rastreamento automático de criação/modificação:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters,\n  Parameters.Attributes;\n\n{$M+}\ntype\n  [Table('config')]\n  TConfiguracao = class\n  private\n    FID: Integer;\n    FName: string;\n    FCreatedAt: TDateTime;\n    FUpdatedAt: TDateTime;\n    FCreatedBy: Integer;\n    FUpdatedBy: Integer;\n    FDeletedAt: TDateTime;\n  published\n    [PrimaryKey]\n    [AutoIncrement]\n    property ID: Integer read FID write FID;\n    \n    [Column('name')]\n    property Name: string read FName write FName;\n    \n    [Column('created_at')]\n    [Timestamp]             // ✨ Preenchido ao criar\n    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;\n    \n    [Column('updated_at')]\n    [Timestamp]             // ✨ Atualizado a cada modificação\n    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;\n    \n    [Column('created_by')]\n    [UserStamp]             // ✨ ID do usuário que criou\n    property CreatedBy: Integer read FCreatedBy write FCreatedBy;\n    \n    [Column('updated_by')]\n    [UserStamp]             // ✨ ID do usuário que atualizou\n    property UpdatedBy: Integer read FUpdatedBy write FUpdatedBy;\n    \n    [Column('deleted_at')]\n    [SoftDelete]            // ✨ Soft delete (não remove, marca como deletado)\n    property DeletedAt: TDateTime read FDeletedAt write FDeletedAt;\n  end;</code></pre>\n\n<h4 style=\"margin-top: 20px; color: #2c3e50;\">7.5. Ler Attributes em Runtime (RTTI)</h4>\n<p>Acessar Attributes de uma classe em tempo de execução:</p>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters,\n  Parameters.Attributes,\n  TypInfo, Rtti;\n\nvar\n  Context: TRttiContext;\n  RttiType: TRttiType;\n  RttiProp: TRttiProperty;\n  Attr: TCustomAttribute;\n  TableAttr: TableAttribute;\n  ColumnAttr: ColumnAttribute;\nbegin\n  Context := TRttiContext.Create;\n  try\n    // Obter informações RTTI da classe\n    RttiType := Context.GetType(TConfiguracao);\n    \n    // Ler [Table] attribute da classe\n    for Attr in RttiType.GetAttributes do\n    begin\n      if Attr is TableAttribute then\n      begin\n        TableAttr := TableAttribute(Attr);\n        ShowMessage('Tabela: ' + TableAttr.TableName);\n        ShowMessage('Schema: ' + TableAttr.SchemaName);\n      end;\n    end;\n    \n    // Ler [Column] attributes das propriedades\n    for RttiProp in RttiType.GetProperties do\n    begin\n      for Attr in RttiProp.GetAttributes do\n      begin\n        if Attr is ColumnAttribute then\n        begin\n          ColumnAttr := ColumnAttribute(Attr);\n          ShowMessage('Propriedade: ' + RttiProp.Name + \n                      ' → Coluna: ' + ColumnAttr.ColumnName);\n        end;\n      end;\n    end;\n  finally\n    Context.Free;\n  end;\nend;</code></pre>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 4px;\">\n    <div style=\"color: #856404; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;\">⚠️ Quando Usar Attributes?</div>\n    <div style=\"color: #856404;\">\n        <h4 style=\"margin-top: 10px;\">✅ Use Attributes Quando:</h4>\n        <ul>\n            <li>Você quer mapeamento declarativo classe ↔ tabela</li>\n            <li>Precisa de validação em tempo de compilação</li>\n            <li>Está construindo um ORM ou sistema baseado em reflexão</li>\n            <li>Quer código mais limpo e auto-documentado</li>\n        </ul>\n        \n        <h4 style=\"margin-top: 10px;\">❌ NÃO Use Attributes Quando:</h4>\n        <ul>\n            <li>Você está apenas lendo/escrevendo parâmetros simples</li>\n            <li>Performance é crítica (RTTI tem overhead)</li>\n            <li>Você prefere controle explícito do código</li>\n            <li>Está começando a aprender o sistema (comece sem Attributes!)</li>\n        </ul>\n        \n        <h4 style=\"margin-top: 10px;\">💡 Dica:</h4>\n        <p>O Parameters ORM funciona <strong>perfeitamente sem Attributes</strong>! Attributes são um recurso <strong>opcional</strong> para casos avançados.</p>\n    </div>\n</div>\n"
    },
    "publicUnitsGuide": {
        "title": "Units Publicas",
        "path": "Units Publicas",
        "description": "\n            <h2>Units Publicas</h2>\n            <p>O modulo Parameters expoe apenas 2 units publicas:</p>\n            <ul>\n                <li><strong>Parameters.pas</strong> - Ponto de entrada (Factory methods + TParametersImpl)</li>\n                <li><strong>Parameters.Interfaces.pas</strong> - Interfaces publicas</li>\n            </ul>\n            \n            <div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 20px 0; border-radius: 4px;\">\n                <div style=\"color: #856404; font-size: 1.25em; font-weight: bold; margin-top: 0; margin-bottom: 15px;\">⚠️ Regras de Negócio - Versão 1.0.2</div>\n                <div style=\"color: #856404;\">\n                    <div style=\"font-size: 1.1em; font-weight: bold; margin-top: 15px; margin-bottom: 10px;\">Hierarquia Completa de Identificação</div>\n                    <p>Todos os métodos CRUD respeitam a constraint UNIQUE: <code>(ContratoID, ProdutoID, Title, Name)</code></p>\n                    <ul>\n                        <li><strong>Getter():</strong> Busca específica quando hierarquia configurada, busca ampla quando não configurada</li>\n                        <li><strong>Setter():</strong> Sempre requer hierarquia completa. Insere se não existir, atualiza se existir</li>\n                        <li><strong>Delete():</strong> Respeita hierarquia completa</li>\n                        <li><strong>Exists():</strong> Respeita hierarquia completa</li>\n                    </ul>\n                    \n                    <div style=\"font-size: 1.1em; font-weight: bold; margin-top: 15px; margin-bottom: 10px;\">Nomenclatura de Métodos</div>\n                    <ul>\n                        <li>Use <code>Getter()</code> em vez de <code>Get()</code> (deprecated)</li>\n                        <li>Use <code>Setter()</code> em vez de <code>Update()</code> (deprecated)</li>\n                    </ul>\n                </div>\n            </div>\n            \n            <h2>Interfaces Consolidadas</h2><p>Documentação completa de todas as interfaces públicas do módulo Parameters, organizadas por interface principal.</p><div style=\"margin-bottom: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #3498db;\"><h3 style=\"color: #2c3e50; margin-top: 0;\">IParametersDatabase</h3><div style=\"margin-bottom: 15px; color: #555;\"><p>Interface <code>IParametersDatabase</code> para acesso a parâmetros.</p></div><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableName</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableName(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o nome da tabela de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.TableName();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableName</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableName: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o nome da tabela de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.TableName();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Schema</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Schema(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o schema da tabela</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Schema();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Schema</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Schema: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o schema da tabela</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Schema();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">AutoCreateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function AutoCreateTable(const AValue: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém se a tabela deve ser criada automaticamente</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.AutoCreateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">AutoCreateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function AutoCreateTable: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém se a tabela deve ser criada automaticamente</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.AutoCreateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Engine</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Engine(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Engine();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Engine</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Engine();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Engine</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Engine: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Engine();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DatabaseType</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DatabaseType(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.DatabaseType();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DatabaseType</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.DatabaseType();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DatabaseType</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DatabaseType: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.DatabaseType();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Host</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Host(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o host do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Host();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Host</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Host: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o host do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Host();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Port</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Port(const AValue: Integer): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a porta do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Port();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Port</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Port: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a porta do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Port();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Username</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Username(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o usuário do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Username();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Username</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Username: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o usuário do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Username();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Password</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Password(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a senha do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Password();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Password</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Password: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a senha do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Password();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Database</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Database(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna a interface IParametersDatabase</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Database();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Database</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Database: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna a interface IParametersDatabase</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Database();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ContratoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ContratoID(const AValue: Integer): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do contrato para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ContratoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ContratoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ContratoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do contrato para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ContratoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ProdutoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ProdutoID(const AValue: Integer): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do produto para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ProdutoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ProdutoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ProdutoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do produto para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ProdutoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Title</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Title(const AValue: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o título/seção dos parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Title();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Title</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Title: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o título/seção dos parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Title();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">List</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function List: TParameterList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Lista todos os parâmetros ativos do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.List();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">List</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function List(out AList: TParameterList): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Lista todos os parâmetros ativos do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.List();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Getter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Getter(const AName: string): TParameter;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Getter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Getter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Getter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Getter(const AName: string; out AParameter: TParameter): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Getter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Getter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Insert</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Insert(const AParameter: TParameter): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Insere um novo parâmetro no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Insert();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Insert</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Insere um novo parâmetro no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Insert();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Setter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Setter(const AParameter: TParameter): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Setter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Setter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Setter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Setter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Setter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Delete</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Delete(const AName: string): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove um parâmetro do banco de dados (soft delete)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Delete();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Delete</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove um parâmetro do banco de dados (soft delete)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Delete();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Exists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Exists(const AName: string): Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se um parâmetro existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Exists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Exists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Exists(const AName: string; out AExists: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se um parâmetro existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Exists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Count</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Count: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna o número de parâmetros ativos</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Count();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Count</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Count(out ACount: Integer): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna o número de parâmetros ativos</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Count();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">IsConnected</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function IsConnected: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se está conectado ao banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.IsConnected();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">IsConnected</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function IsConnected(out AConnected: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se está conectado ao banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.IsConnected();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Connect</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Connect: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Conecta ao banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Connect();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Connect</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Connect(out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Conecta ao banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Connect();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Disconnect</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Disconnect: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Desconecta do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Disconnect();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Refresh</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Refresh: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Recarrega os parâmetros do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Refresh();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableExists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableExists: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se a tabela existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.TableExists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableExists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableExists(out AExists: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se a tabela existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.TableExists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">CreateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function CreateTable: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Cria a tabela de parâmetros se não existir</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.CreateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">CreateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function CreateTable(out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Cria a tabela de parâmetros se não existir</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.CreateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DropTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DropTable: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove a tabela de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.DropTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DropTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DropTable(out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove a tabela de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.DropTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">MigrateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function MigrateTable: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Migra a estrutura da tabela para a versão atual</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.MigrateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">MigrateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function MigrateTable(out ASuccess: Boolean): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Migra a estrutura da tabela para a versão atual</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.MigrateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableDatabases</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableDatabases</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ListAvailableDatabases();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableDatabases</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableDatabases: TStringList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableDatabases</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ListAvailableDatabases();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableTables</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableTables(out ATables: TStringList): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableTables</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ListAvailableTables();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableTables</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableTables: TStringList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableTables</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ListAvailableTables();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Connection</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Connection(AConnection: TObject): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Connection</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Connection();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Query</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Query(AQuery: TDataSet): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Query</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.Query();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ExecQuery</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ExecQuery(AExecQuery: TDataSet): IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ExecQuery</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">DB.ExecQuery();</code></pre></div><div style=\"margin-bottom: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #3498db;\"><h3 style=\"color: #2c3e50; margin-top: 0;\">IParametersInifiles</h3><div style=\"margin-bottom: 15px; color: #555;\"><p>Interface <code>IParametersInifiles</code> para acesso a parâmetros.</p></div><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableName</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableName: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o nome da tabela de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.TableName();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Schema</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Schema: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o schema da tabela</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Schema();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">AutoCreateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function AutoCreateTable: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém se a tabela deve ser criada automaticamente</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.AutoCreateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Engine</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Engine: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Engine();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DatabaseType</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DatabaseType: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.DatabaseType();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Host</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Host: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o host do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Host();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Port</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Port: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a porta do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Port();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Username</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Username: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o usuário do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Username();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Password</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Password: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a senha do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Password();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Database</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Database: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna a interface IParametersDatabase</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Database();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ContratoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ContratoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do contrato para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.ContratoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ProdutoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ProdutoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do produto para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.ProdutoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Title</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Title: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o título/seção dos parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Title();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">List</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function List: TParameterList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Lista todos os parâmetros ativos do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.List();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Getter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Getter(const AName: string): TParameter;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Getter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Getter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Exists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Exists(const AName: string): Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se um parâmetro existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Exists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Count</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Count: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna o número de parâmetros ativos</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.Count();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">IsConnected</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function IsConnected: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se está conectado ao banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.IsConnected();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableExists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableExists: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se a tabela existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.TableExists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableDatabases</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableDatabases: TStringList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableDatabases</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.ListAvailableDatabases();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableTables</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableTables: TStringList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableTables</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Ini.ListAvailableTables();</code></pre></div><div style=\"margin-bottom: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #3498db;\"><h3 style=\"color: #2c3e50; margin-top: 0;\">IParametersJsonObject</h3><div style=\"margin-bottom: 15px; color: #555;\"><p>Interface <code>IParametersJsonObject</code> para acesso a parâmetros.</p></div><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableName</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableName: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o nome da tabela de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.TableName();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Schema</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Schema: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o schema da tabela</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Schema();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">AutoCreateTable</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function AutoCreateTable: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém se a tabela deve ser criada automaticamente</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.AutoCreateTable();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Engine</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Engine: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Engine();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">DatabaseType</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function DatabaseType: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.DatabaseType();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Host</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Host: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o host do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Host();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Port</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Port: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a porta do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Port();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Username</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Username: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o usuário do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Username();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Password</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Password: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a senha do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Password();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Database</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Database: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna a interface IParametersDatabase</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Database();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ContratoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ContratoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do contrato para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.ContratoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ProdutoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ProdutoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do produto para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.ProdutoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Title</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Title: string;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o título/seção dos parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Title();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">List</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function List: TParameterList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Lista todos os parâmetros ativos do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.List();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Getter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Getter(const AName: string): TParameter;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Getter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Getter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Exists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Exists(const AName: string): Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se um parâmetro existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Exists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Count</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Count: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna o número de parâmetros ativos</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.Count();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">IsConnected</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function IsConnected: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se está conectado ao banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.IsConnected();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">TableExists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function TableExists: Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se a tabela existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.TableExists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableDatabases</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableDatabases: TStringList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableDatabases</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.ListAvailableDatabases();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ListAvailableTables</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ListAvailableTables: TStringList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function ListAvailableTables</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Json.ListAvailableTables();</code></pre></div><div style=\"margin-bottom: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #3498db;\"><h3 style=\"color: #2c3e50; margin-top: 0;\">IParameters</h3><div style=\"margin-bottom: 15px; color: #555;\"><p>IParameters - Interface Principal de Convergência</p>\n<p>Interface unificada que gerencia múltiplas fontes de dados (Database, INI, JSON)</p>\n<p>com suporte a fallback automático para contingência.</p>\n<p>Exemplo de uso:</p>\n<p>var Parameters: IParameters;</p>\n<p>Parameters := TParameters.New([pcfDataBase, pcfInifile]);</p>\n<p>Parameters.Database.Host('localhost').Connect;</p>\n<p>Parameters.Inifiles.FilePath('config.ini');</p>\n<p>Param := Parameters.Get('database_host'); // Busca em cascata: Database → INI</p></div><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Source</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Source(ASource: TParameterSource): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a fonte ativa de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Source();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Source</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Source: TParameterSource;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém a fonte ativa de parâmetros</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Source();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">AddSource</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function AddSource(ASource: TParameterSource): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Adiciona uma fonte à lista de fontes disponíveis</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.AddSource();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">RemoveSource</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function RemoveSource(ASource: TParameterSource): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove uma fonte da lista</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.RemoveSource();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">HasSource</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function HasSource(ASource: TParameterSource): Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se uma fonte está ativa</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.HasSource();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Priority</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Priority(ASources: TParameterSourceArray): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define a ordem de prioridade das fontes</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Priority();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Getter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Getter(const AName: string): TParameter;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Getter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Getter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Getter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Getter(const AName: string; ASource: TParameterSource): TParameter;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Getter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Getter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">List</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function List: TParameterList;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Lista todos os parâmetros ativos do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.List();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">List</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function List(out AList: TParameterList): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Lista todos os parâmetros ativos do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.List();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Insert</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Insert(const AParameter: TParameter): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Insere um novo parâmetro no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Insert();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Insert</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Insere um novo parâmetro no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Insert();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Setter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Setter(const AParameter: TParameter): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Setter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Setter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Setter</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function Setter</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Setter();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Delete</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Delete(const AName: string): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove um parâmetro do banco de dados (soft delete)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Delete();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Delete</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Delete(const AName: string; out ASuccess: Boolean): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Remove um parâmetro do banco de dados (soft delete)</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Delete();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Exists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Exists(const AName: string): Boolean;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se um parâmetro existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Exists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Exists</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Exists(const AName: string; out AExists: Boolean): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Verifica se um parâmetro existe no banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Exists();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Count</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Count: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna o número de parâmetros ativos</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Count();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Count</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Count(out ACount: Integer): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna o número de parâmetros ativos</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Count();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Refresh</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Refresh: IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Recarrega os parâmetros do banco de dados</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Refresh();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ContratoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ContratoID(const AValue: Integer): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do contrato para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.ContratoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ContratoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ContratoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do contrato para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.ContratoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ProdutoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ProdutoID(const AValue: Integer): IParameters;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do produto para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.ProdutoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">ProdutoID</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function ProdutoID: Integer;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Define ou obtém o ID do produto para filtro</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.ProdutoID();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Database</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Database: IParametersDatabase;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Permite acesso a métodos exclusivos de cada fonte</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Database();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">Inifiles</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function Inifiles: IParametersInifiles;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna a interface IParametersInifiles</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.Inifiles();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">JsonObject</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function JsonObject: IParametersJsonObject;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">Retorna a interface IParametersJsonObject</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.JsonObject();</code></pre><h4 style=\"color: #34495e; margin-top: 20px; margin-bottom: 15px;\">EndParameters</h4><p style=\"font-family: monospace; font-weight: bold; color: #2c3e50; margin-bottom: 10px; margin-left: 20px; font-size: 14px;\">function EndParameters: IInterface;</p><p style=\"color: #555; margin-bottom: 10px; margin-left: 20px;\">function EndParameters</p><pre style=\"margin-top: 10px; margin-bottom: 20px; margin-left: 20px; padding: 15px; background: #2c3e50; border-radius: 4px; overflow-x: auto;\"><code style=\"color: #ecf0f1; font-size: 13px;\">Parameters.EndParameters();</code></pre></div>\n        "
    },
    "units": [
        {
            "id": "parameters",
            "name": "Parameters.pas",
            "path": "src\\Paramenters\\Parameters.pas",
            "description": "<p>Modulo.Parameters - Ponto de Entrada Público do Sistema de Parâmetros</p>\n<p><strong>Descrição:</strong> </p>\n<p>Este é o único arquivo que deve ser usado externamente para acessar o módulo</p>\n<p>Parameters. Todas as implementações estão ocultas e acessíveis apenas via</p>\n<p>interfaces públicas.</p>\n<p><strong>Uso:</strong> </p>\n<pre><code>uses Modulo.Parameters;\nvar Parameters: IParametersDatabase;\nParameters := TParameters.New\n.Connection(MyConnection)\n.Query(MyQuery)\n.TableName(&#x27;config&#x27;)\n.Schema(&#x27;dbcsl&#x27;);</code></pre>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>",
            "interfaces": [],
            "classes": [
                {
                    "name": "TParameters",
                    "description": "<p>TParameters - Factory Class para criar instâncias de IParameters</p>",
                    "publicMethods": [
                        {
                            "name": "New",
                            "type": "function",
                            "signature": "function New: IParameters;",
                            "comment": "Cria uma nova instância de IParameters com configuração padrão ou customizada"
                        },
                        {
                            "name": "New",
                            "type": "function",
                            "signature": "function New(AConfig: TParameterConfig): IParameters;",
                            "comment": "Cria uma nova instância de IParameters com configuração padrão ou customizada"
                        },
                        {
                            "name": "NewDatabase",
                            "type": "function",
                            "signature": "function NewDatabase: IParametersDatabase;",
                            "comment": "Cria uma nova instância de IParametersDatabase para acesso a parâmetros em banco de dados"
                        },
                        {
                            "name": "NewDatabase",
                            "type": "function",
                            "signature": "function NewDatabase(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil): IParametersDatabase;",
                            "comment": "Cria uma nova instância de IParametersDatabase para acesso a parâmetros em banco de dados"
                        },
                        {
                            "name": "NewInifiles",
                            "type": "function",
                            "signature": "function NewInifiles: IParametersInifiles;",
                            "comment": "Cria uma nova instância de IParametersInifiles para acesso a parâmetros em arquivos INI"
                        },
                        {
                            "name": "NewInifiles",
                            "type": "function",
                            "signature": "function NewInifiles(const AFilePath: string): IParametersInifiles;",
                            "comment": "Cria uma nova instância de IParametersInifiles para acesso a parâmetros em arquivos INI"
                        },
                        {
                            "name": "NewJsonObject",
                            "type": "function",
                            "signature": "function NewJsonObject: IParametersJsonObject;",
                            "comment": "Cria uma nova instância de IParametersJsonObject para acesso a parâmetros em objetos JSON"
                        },
                        {
                            "name": "NewJsonObject",
                            "type": "function",
                            "signature": "function NewJsonObject(AJsonObject: TJSONObject): IParametersJsonObject;",
                            "comment": "Cria uma nova instância de IParametersJsonObject para acesso a parâmetros em objetos JSON"
                        },
                        {
                            "name": "NewJsonObject",
                            "type": "function",
                            "signature": "function NewJsonObject(const AJsonString: string): IParametersJsonObject;",
                            "comment": "Cria uma nova instância de IParametersJsonObject para acesso a parâmetros em objetos JSON"
                        },
                        {
                            "name": "NewJsonObjectFromFile",
                            "type": "function",
                            "signature": "function NewJsonObjectFromFile(const AFilePath: string): IParametersJsonObject;",
                            "comment": "function NewJsonObjectFromFile"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "TParametersImpl",
                    "description": "<p>TParametersImpl - Implementação de IParameters (seção implementation)</p>\n<p>Esta classe fica na seção implementation e não é acessível externamente.</p>\n<p>Apenas a interface IParameters é exposta publicamente.</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(AConfig: TParameterConfig);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "destructor Destroy"
                        },
                        {
                            "name": "Source",
                            "type": "function",
                            "signature": "function Source(ASource: TParameterSource): IParameters;",
                            "comment": "IParameters implementation"
                        },
                        {
                            "name": "Source",
                            "type": "function",
                            "signature": "function Source: TParameterSource;",
                            "comment": "Define ou obtém a fonte ativa de parâmetros"
                        },
                        {
                            "name": "AddSource",
                            "type": "function",
                            "signature": "function AddSource(ASource: TParameterSource): IParameters;",
                            "comment": "Adiciona uma fonte à lista de fontes disponíveis"
                        },
                        {
                            "name": "RemoveSource",
                            "type": "function",
                            "signature": "function RemoveSource(ASource: TParameterSource): IParameters;",
                            "comment": "Remove uma fonte da lista"
                        },
                        {
                            "name": "HasSource",
                            "type": "function",
                            "signature": "function HasSource(ASource: TParameterSource): Boolean;",
                            "comment": "Verifica se uma fonte está ativa"
                        },
                        {
                            "name": "Priority",
                            "type": "function",
                            "signature": "function Priority(ASources: TParameterSourceArray): IParameters;",
                            "comment": "Define a ordem de prioridade das fontes"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string; ASource: TParameterSource): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List(out AList: TParameterList): IParameters;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter): IParameters;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter): IParameters;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParameters;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string): IParameters;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParameters;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string; out AExists: Boolean): IParameters;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count(out ACount: Integer): IParameters;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Refresh",
                            "type": "function",
                            "signature": "function Refresh: IParameters;",
                            "comment": "Recarrega os parâmetros do banco de dados"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID(const AValue: Integer): IParameters;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID(const AValue: Integer): IParameters;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database: IParametersDatabase;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "Inifiles",
                            "type": "function",
                            "signature": "function Inifiles: IParametersInifiles;",
                            "comment": "Retorna a interface IParametersInifiles"
                        },
                        {
                            "name": "JsonObject",
                            "type": "function",
                            "signature": "function JsonObject: IParametersJsonObject;",
                            "comment": "Retorna a interface IParametersJsonObject"
                        },
                        {
                            "name": "EndParameters",
                            "type": "function",
                            "signature": "function EndParameters: IInterface;",
                            "comment": "function EndParameters"
                        }
                    ],
                    "privateMethods": [
                        {
                            "name": "TryGetFromSource",
                            "type": "function",
                            "signature": "function TryGetFromSource(const AName: string; ASource: TParameterSource; out AParameter: TParameter): Boolean;",
                            "comment": "function TryGetFromSource"
                        },
                        {
                            "name": "IsSourceAvailable",
                            "type": "function",
                            "signature": "function IsSourceAvailable(ASource: TParameterSource): Boolean;",
                            "comment": "function IsSourceAvailable"
                        }
                    ]
                }
            ],
            "functions": [
                {
                    "name": "New",
                    "type": "function",
                    "signature": "function New(AConfig: TParameterConfig): IParameters;",
                    "description": "function New",
                    "comment": "Cria uma nova instância de IParameters com configuração padrão ou customizada"
                },
                {
                    "name": "NewDatabase",
                    "type": "function",
                    "signature": "function NewDatabase(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil): IParametersDatabase;",
                    "description": "function NewDatabase",
                    "comment": "Cria uma nova instância de IParametersDatabase para acesso a parâmetros em banco de dados"
                },
                {
                    "name": "NewInifiles",
                    "type": "function",
                    "signature": "function NewInifiles(const AFilePath: string): IParametersInifiles;",
                    "description": "function NewInifiles",
                    "comment": "Cria uma nova instância de IParametersInifiles para acesso a parâmetros em arquivos INI"
                },
                {
                    "name": "NewJsonObject",
                    "type": "function",
                    "signature": "function NewJsonObject(AJsonObject: TJSONObject): IParametersJsonObject;",
                    "description": "function NewJsonObject",
                    "comment": "Cria uma nova instância de IParametersJsonObject para acesso a parâmetros em objetos JSON"
                },
                {
                    "name": "NewJsonObject",
                    "type": "function",
                    "signature": "function NewJsonObject(const AJsonString: string): IParametersJsonObject;",
                    "description": "function NewJsonObject",
                    "comment": "Cria uma nova instância de IParametersJsonObject para acesso a parâmetros em objetos JSON"
                },
                {
                    "name": "NewJsonObjectFromFile",
                    "type": "function",
                    "signature": "function NewJsonObjectFromFile(const AFilePath: string): IParametersJsonObject;",
                    "description": "function NewJsonObjectFromFile",
                    "comment": "function NewJsonObjectFromFile"
                }
            ]
        },
        {
            "id": "parameters.interfaces",
            "name": "Parameters.Interfaces.pas",
            "path": "src\\Paramenters\\Parameters.Interfaces.pas",
            "description": "<p>Modulo.Parameters.Intefaces - Interfaces do Sistema de Parâmetros</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define a interface IParametersDatabase para acesso a parâmetros em banco de dados.</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>",
            "interfaces": [
                {
                    "name": "IParametersDatabase",
                    "description": "<p>Interface <code>IParametersDatabase</code> para acesso a parâmetros.</p>",
                    "methods": [
                        {
                            "name": "TableName",
                            "type": "function",
                            "signature": "function TableName(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o nome da tabela de parâmetros"
                        },
                        {
                            "name": "TableName",
                            "type": "function",
                            "signature": "function TableName: string;",
                            "comment": "Define ou obtém o nome da tabela de parâmetros"
                        },
                        {
                            "name": "Schema",
                            "type": "function",
                            "signature": "function Schema(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o schema da tabela"
                        },
                        {
                            "name": "Schema",
                            "type": "function",
                            "signature": "function Schema: string;",
                            "comment": "Define ou obtém o schema da tabela"
                        },
                        {
                            "name": "AutoCreateTable",
                            "type": "function",
                            "signature": "function AutoCreateTable(const AValue: Boolean): IParametersDatabase;",
                            "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                        },
                        {
                            "name": "AutoCreateTable",
                            "type": "function",
                            "signature": "function AutoCreateTable: Boolean;",
                            "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine: string;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType: string;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "Host",
                            "type": "function",
                            "signature": "function Host(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o host do banco de dados"
                        },
                        {
                            "name": "Host",
                            "type": "function",
                            "signature": "function Host: string;",
                            "comment": "Define ou obtém o host do banco de dados"
                        },
                        {
                            "name": "Port",
                            "type": "function",
                            "signature": "function Port(const AValue: Integer): IParametersDatabase;",
                            "comment": "Define ou obtém a porta do banco de dados"
                        },
                        {
                            "name": "Port",
                            "type": "function",
                            "signature": "function Port: Integer;",
                            "comment": "Define ou obtém a porta do banco de dados"
                        },
                        {
                            "name": "Username",
                            "type": "function",
                            "signature": "function Username(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o usuário do banco de dados"
                        },
                        {
                            "name": "Username",
                            "type": "function",
                            "signature": "function Username: string;",
                            "comment": "Define ou obtém o usuário do banco de dados"
                        },
                        {
                            "name": "Password",
                            "type": "function",
                            "signature": "function Password(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém a senha do banco de dados"
                        },
                        {
                            "name": "Password",
                            "type": "function",
                            "signature": "function Password: string;",
                            "comment": "Define ou obtém a senha do banco de dados"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database(const AValue: string): IParametersDatabase;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database: string;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID(const AValue: Integer): IParametersDatabase;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID(const AValue: Integer): IParametersDatabase;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title: string;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List(out AList: TParameterList): IParametersDatabase;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersDatabase;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter): IParametersDatabase;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter): IParametersDatabase;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string): IParametersDatabase;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersDatabase;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count(out ACount: Integer): IParametersDatabase;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "IsConnected",
                            "type": "function",
                            "signature": "function IsConnected: Boolean;",
                            "comment": "Verifica se está conectado ao banco de dados"
                        },
                        {
                            "name": "IsConnected",
                            "type": "function",
                            "signature": "function IsConnected(out AConnected: Boolean): IParametersDatabase;",
                            "comment": "Verifica se está conectado ao banco de dados"
                        },
                        {
                            "name": "Connect",
                            "type": "function",
                            "signature": "function Connect: IParametersDatabase;",
                            "comment": "Conecta ao banco de dados"
                        },
                        {
                            "name": "Connect",
                            "type": "function",
                            "signature": "function Connect(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Conecta ao banco de dados"
                        },
                        {
                            "name": "Disconnect",
                            "type": "function",
                            "signature": "function Disconnect: IParametersDatabase;",
                            "comment": "Desconecta do banco de dados"
                        },
                        {
                            "name": "Refresh",
                            "type": "function",
                            "signature": "function Refresh: IParametersDatabase;",
                            "comment": "Recarrega os parâmetros do banco de dados"
                        },
                        {
                            "name": "TableExists",
                            "type": "function",
                            "signature": "function TableExists: Boolean;",
                            "comment": "Verifica se a tabela existe no banco de dados"
                        },
                        {
                            "name": "TableExists",
                            "type": "function",
                            "signature": "function TableExists(out AExists: Boolean): IParametersDatabase;",
                            "comment": "Verifica se a tabela existe no banco de dados"
                        },
                        {
                            "name": "CreateTable",
                            "type": "function",
                            "signature": "function CreateTable: IParametersDatabase;",
                            "comment": "Cria a tabela de parâmetros se não existir"
                        },
                        {
                            "name": "CreateTable",
                            "type": "function",
                            "signature": "function CreateTable(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Cria a tabela de parâmetros se não existir"
                        },
                        {
                            "name": "DropTable",
                            "type": "function",
                            "signature": "function DropTable: IParametersDatabase;",
                            "comment": "Remove a tabela de parâmetros"
                        },
                        {
                            "name": "DropTable",
                            "type": "function",
                            "signature": "function DropTable(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Remove a tabela de parâmetros"
                        },
                        {
                            "name": "MigrateTable",
                            "type": "function",
                            "signature": "function MigrateTable: IParametersDatabase;",
                            "comment": "Migra a estrutura da tabela para a versão atual"
                        },
                        {
                            "name": "MigrateTable",
                            "type": "function",
                            "signature": "function MigrateTable(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Migra a estrutura da tabela para a versão atual"
                        },
                        {
                            "name": "ListAvailableDatabases",
                            "type": "function",
                            "signature": "function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase;",
                            "comment": "function ListAvailableDatabases"
                        },
                        {
                            "name": "ListAvailableDatabases",
                            "type": "function",
                            "signature": "function ListAvailableDatabases: TStringList;",
                            "comment": "function ListAvailableDatabases"
                        },
                        {
                            "name": "ListAvailableTables",
                            "type": "function",
                            "signature": "function ListAvailableTables(out ATables: TStringList): IParametersDatabase;",
                            "comment": "function ListAvailableTables"
                        },
                        {
                            "name": "ListAvailableTables",
                            "type": "function",
                            "signature": "function ListAvailableTables: TStringList;",
                            "comment": "function ListAvailableTables"
                        },
                        {
                            "name": "Connection",
                            "type": "function",
                            "signature": "function Connection(AConnection: TObject): IParametersDatabase;",
                            "comment": "function Connection"
                        },
                        {
                            "name": "Query",
                            "type": "function",
                            "signature": "function Query(AQuery: TDataSet): IParametersDatabase;",
                            "comment": "function Query"
                        },
                        {
                            "name": "ExecQuery",
                            "type": "function",
                            "signature": "function ExecQuery(AExecQuery: TDataSet): IParametersDatabase;",
                            "comment": "function ExecQuery"
                        }
                    ]
                },
                {
                    "name": "IParametersInifiles",
                    "description": "<p>Interface <code>IParametersInifiles</code> para acesso a parâmetros.</p>",
                    "methods": [
                        {
                            "name": "TableName",
                            "type": "function",
                            "signature": "function TableName: string;",
                            "comment": "Define ou obtém o nome da tabela de parâmetros"
                        },
                        {
                            "name": "Schema",
                            "type": "function",
                            "signature": "function Schema: string;",
                            "comment": "Define ou obtém o schema da tabela"
                        },
                        {
                            "name": "AutoCreateTable",
                            "type": "function",
                            "signature": "function AutoCreateTable: Boolean;",
                            "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine: string;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType: string;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "Host",
                            "type": "function",
                            "signature": "function Host: string;",
                            "comment": "Define ou obtém o host do banco de dados"
                        },
                        {
                            "name": "Port",
                            "type": "function",
                            "signature": "function Port: Integer;",
                            "comment": "Define ou obtém a porta do banco de dados"
                        },
                        {
                            "name": "Username",
                            "type": "function",
                            "signature": "function Username: string;",
                            "comment": "Define ou obtém o usuário do banco de dados"
                        },
                        {
                            "name": "Password",
                            "type": "function",
                            "signature": "function Password: string;",
                            "comment": "Define ou obtém a senha do banco de dados"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database: string;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title: string;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "IsConnected",
                            "type": "function",
                            "signature": "function IsConnected: Boolean;",
                            "comment": "Verifica se está conectado ao banco de dados"
                        },
                        {
                            "name": "TableExists",
                            "type": "function",
                            "signature": "function TableExists: Boolean;",
                            "comment": "Verifica se a tabela existe no banco de dados"
                        },
                        {
                            "name": "ListAvailableDatabases",
                            "type": "function",
                            "signature": "function ListAvailableDatabases: TStringList;",
                            "comment": "function ListAvailableDatabases"
                        },
                        {
                            "name": "ListAvailableTables",
                            "type": "function",
                            "signature": "function ListAvailableTables: TStringList;",
                            "comment": "function ListAvailableTables"
                        }
                    ]
                },
                {
                    "name": "IParametersJsonObject",
                    "description": "<p>Interface <code>IParametersJsonObject</code> para acesso a parâmetros.</p>",
                    "methods": [
                        {
                            "name": "TableName",
                            "type": "function",
                            "signature": "function TableName: string;",
                            "comment": "Define ou obtém o nome da tabela de parâmetros"
                        },
                        {
                            "name": "Schema",
                            "type": "function",
                            "signature": "function Schema: string;",
                            "comment": "Define ou obtém o schema da tabela"
                        },
                        {
                            "name": "AutoCreateTable",
                            "type": "function",
                            "signature": "function AutoCreateTable: Boolean;",
                            "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine: string;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType: string;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "Host",
                            "type": "function",
                            "signature": "function Host: string;",
                            "comment": "Define ou obtém o host do banco de dados"
                        },
                        {
                            "name": "Port",
                            "type": "function",
                            "signature": "function Port: Integer;",
                            "comment": "Define ou obtém a porta do banco de dados"
                        },
                        {
                            "name": "Username",
                            "type": "function",
                            "signature": "function Username: string;",
                            "comment": "Define ou obtém o usuário do banco de dados"
                        },
                        {
                            "name": "Password",
                            "type": "function",
                            "signature": "function Password: string;",
                            "comment": "Define ou obtém a senha do banco de dados"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database: string;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title: string;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "IsConnected",
                            "type": "function",
                            "signature": "function IsConnected: Boolean;",
                            "comment": "Verifica se está conectado ao banco de dados"
                        },
                        {
                            "name": "TableExists",
                            "type": "function",
                            "signature": "function TableExists: Boolean;",
                            "comment": "Verifica se a tabela existe no banco de dados"
                        },
                        {
                            "name": "ListAvailableDatabases",
                            "type": "function",
                            "signature": "function ListAvailableDatabases: TStringList;",
                            "comment": "function ListAvailableDatabases"
                        },
                        {
                            "name": "ListAvailableTables",
                            "type": "function",
                            "signature": "function ListAvailableTables: TStringList;",
                            "comment": "function ListAvailableTables"
                        }
                    ]
                },
                {
                    "name": "IParameters",
                    "description": "<p>IParameters - Interface Principal de Convergência</p>\n<p>Interface unificada que gerencia múltiplas fontes de dados (Database, INI, JSON)</p>\n<p>com suporte a fallback automático para contingência.</p>\n<p>Exemplo de uso:</p>\n<p>var Parameters: IParameters;</p>\n<p>Parameters := TParameters.New([pcfDataBase, pcfInifile]);</p>\n<p>Parameters.Database.Host('localhost').Connect;</p>\n<p>Parameters.Inifiles.FilePath('config.ini');</p>\n<p>Param := Parameters.Get('database_host'); // Busca em cascata: Database → INI</p>",
                    "methods": [
                        {
                            "name": "Source",
                            "type": "function",
                            "signature": "function Source(ASource: TParameterSource): IParameters;",
                            "comment": "Define ou obtém a fonte ativa de parâmetros"
                        },
                        {
                            "name": "Source",
                            "type": "function",
                            "signature": "function Source: TParameterSource;",
                            "comment": "Define ou obtém a fonte ativa de parâmetros"
                        },
                        {
                            "name": "AddSource",
                            "type": "function",
                            "signature": "function AddSource(ASource: TParameterSource): IParameters;",
                            "comment": "Adiciona uma fonte à lista de fontes disponíveis"
                        },
                        {
                            "name": "RemoveSource",
                            "type": "function",
                            "signature": "function RemoveSource(ASource: TParameterSource): IParameters;",
                            "comment": "Remove uma fonte da lista"
                        },
                        {
                            "name": "HasSource",
                            "type": "function",
                            "signature": "function HasSource(ASource: TParameterSource): Boolean;",
                            "comment": "Verifica se uma fonte está ativa"
                        },
                        {
                            "name": "Priority",
                            "type": "function",
                            "signature": "function Priority(ASources: TParameterSourceArray): IParameters;",
                            "comment": "Define a ordem de prioridade das fontes"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string; ASource: TParameterSource): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List(out AList: TParameterList): IParameters;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter): IParameters;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter): IParameters;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParameters;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string): IParameters;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParameters;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string; out AExists: Boolean): IParameters;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count(out ACount: Integer): IParameters;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Refresh",
                            "type": "function",
                            "signature": "function Refresh: IParameters;",
                            "comment": "Recarrega os parâmetros do banco de dados"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID(const AValue: Integer): IParameters;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID(const AValue: Integer): IParameters;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database: IParametersDatabase;",
                            "comment": "Permite acesso a métodos exclusivos de cada fonte"
                        },
                        {
                            "name": "Inifiles",
                            "type": "function",
                            "signature": "function Inifiles: IParametersInifiles;",
                            "comment": "Retorna a interface IParametersInifiles"
                        },
                        {
                            "name": "JsonObject",
                            "type": "function",
                            "signature": "function JsonObject: IParametersJsonObject;",
                            "comment": "Retorna a interface IParametersJsonObject"
                        },
                        {
                            "name": "EndParameters",
                            "type": "function",
                            "signature": "function EndParameters: IInterface;",
                            "comment": "function EndParameters"
                        }
                    ]
                }
            ],
            "classes": [],
            "functions": [
                {
                    "name": "TableName",
                    "type": "function",
                    "signature": "function TableName(const AValue: string): IParametersDatabase;",
                    "description": "function TableName",
                    "comment": "Define ou obtém o nome da tabela de parâmetros"
                },
                {
                    "name": "Schema",
                    "type": "function",
                    "signature": "function Schema(const AValue: string): IParametersDatabase;",
                    "description": "function Schema",
                    "comment": "Define ou obtém o schema da tabela"
                },
                {
                    "name": "AutoCreateTable",
                    "type": "function",
                    "signature": "function AutoCreateTable(const AValue: Boolean): IParametersDatabase;",
                    "description": "function AutoCreateTable",
                    "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                },
                {
                    "name": "Engine",
                    "type": "function",
                    "signature": "function Engine(const AValue: string): IParametersDatabase;",
                    "description": "function Engine",
                    "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                },
                {
                    "name": "Engine",
                    "type": "function",
                    "signature": "function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase;",
                    "description": "function Engine",
                    "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                },
                {
                    "name": "DatabaseType",
                    "type": "function",
                    "signature": "function DatabaseType(const AValue: string): IParametersDatabase;",
                    "description": "function DatabaseType",
                    "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                },
                {
                    "name": "DatabaseType",
                    "type": "function",
                    "signature": "function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase;",
                    "description": "function DatabaseType",
                    "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                },
                {
                    "name": "Host",
                    "type": "function",
                    "signature": "function Host(const AValue: string): IParametersDatabase;",
                    "description": "function Host",
                    "comment": "Define ou obtém o host do banco de dados"
                },
                {
                    "name": "Port",
                    "type": "function",
                    "signature": "function Port(const AValue: Integer): IParametersDatabase;",
                    "description": "function Port",
                    "comment": "Define ou obtém a porta do banco de dados"
                },
                {
                    "name": "Username",
                    "type": "function",
                    "signature": "function Username(const AValue: string): IParametersDatabase;",
                    "description": "function Username",
                    "comment": "Define ou obtém o usuário do banco de dados"
                },
                {
                    "name": "Password",
                    "type": "function",
                    "signature": "function Password(const AValue: string): IParametersDatabase;",
                    "description": "function Password",
                    "comment": "Define ou obtém a senha do banco de dados"
                },
                {
                    "name": "Database",
                    "type": "function",
                    "signature": "function Database(const AValue: string): IParametersDatabase;",
                    "description": "function Database",
                    "comment": "Retorna a interface IParametersDatabase"
                },
                {
                    "name": "ContratoID",
                    "type": "function",
                    "signature": "function ContratoID(const AValue: Integer): IParametersDatabase;",
                    "description": "function ContratoID",
                    "comment": "Define ou obtém o ID do contrato para filtro"
                },
                {
                    "name": "ProdutoID",
                    "type": "function",
                    "signature": "function ProdutoID(const AValue: Integer): IParametersDatabase;",
                    "description": "function ProdutoID",
                    "comment": "Define ou obtém o ID do produto para filtro"
                },
                {
                    "name": "Title",
                    "type": "function",
                    "signature": "function Title(const AValue: string): IParametersDatabase;",
                    "description": "function Title",
                    "comment": "Define ou obtém o título/seção dos parâmetros"
                },
                {
                    "name": "List",
                    "type": "function",
                    "signature": "function List(out AList: TParameterList): IParametersDatabase;",
                    "description": "function List",
                    "comment": "Lista todos os parâmetros ativos do banco de dados"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string): TParameter;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersDatabase;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter): IParametersDatabase;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter): IParametersDatabase;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string): IParametersDatabase;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string): Boolean;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersDatabase;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Count",
                    "type": "function",
                    "signature": "function Count(out ACount: Integer): IParametersDatabase;",
                    "description": "function Count",
                    "comment": "Retorna o número de parâmetros ativos"
                },
                {
                    "name": "IsConnected",
                    "type": "function",
                    "signature": "function IsConnected(out AConnected: Boolean): IParametersDatabase;",
                    "description": "function IsConnected",
                    "comment": "Verifica se está conectado ao banco de dados"
                },
                {
                    "name": "Connect",
                    "type": "function",
                    "signature": "function Connect(out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function Connect",
                    "comment": "Conecta ao banco de dados"
                },
                {
                    "name": "TableExists",
                    "type": "function",
                    "signature": "function TableExists(out AExists: Boolean): IParametersDatabase;",
                    "description": "function TableExists",
                    "comment": "Verifica se a tabela existe no banco de dados"
                },
                {
                    "name": "CreateTable",
                    "type": "function",
                    "signature": "function CreateTable(out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function CreateTable",
                    "comment": "Cria a tabela de parâmetros se não existir"
                },
                {
                    "name": "DropTable",
                    "type": "function",
                    "signature": "function DropTable(out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function DropTable",
                    "comment": "Remove a tabela de parâmetros"
                },
                {
                    "name": "MigrateTable",
                    "type": "function",
                    "signature": "function MigrateTable(out ASuccess: Boolean): IParametersDatabase;",
                    "description": "function MigrateTable",
                    "comment": "Migra a estrutura da tabela para a versão atual"
                },
                {
                    "name": "ListAvailableDatabases",
                    "type": "function",
                    "signature": "function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase;",
                    "description": "function ListAvailableDatabases",
                    "comment": "function ListAvailableDatabases"
                },
                {
                    "name": "ListAvailableTables",
                    "type": "function",
                    "signature": "function ListAvailableTables(out ATables: TStringList): IParametersDatabase;",
                    "description": "function ListAvailableTables",
                    "comment": "function ListAvailableTables"
                },
                {
                    "name": "Connection",
                    "type": "function",
                    "signature": "function Connection(AConnection: TObject): IParametersDatabase;",
                    "description": "function Connection",
                    "comment": "function Connection"
                },
                {
                    "name": "Query",
                    "type": "function",
                    "signature": "function Query(AQuery: TDataSet): IParametersDatabase;",
                    "description": "function Query",
                    "comment": "function Query"
                },
                {
                    "name": "ExecQuery",
                    "type": "function",
                    "signature": "function ExecQuery(AExecQuery: TDataSet): IParametersDatabase;",
                    "description": "function ExecQuery",
                    "comment": "function ExecQuery"
                },
                {
                    "name": "FilePath",
                    "type": "function",
                    "signature": "function FilePath(const AValue: string): IParametersInifiles;",
                    "description": "function FilePath",
                    "comment": "Define ou obtém o caminho do arquivo INI"
                },
                {
                    "name": "Section",
                    "type": "function",
                    "signature": "function Section(const AValue: string): IParametersInifiles;",
                    "description": "function Section",
                    "comment": "Define ou obtém a seção do arquivo INI"
                },
                {
                    "name": "AutoCreateFile",
                    "type": "function",
                    "signature": "function AutoCreateFile(const AValue: Boolean): IParametersInifiles;",
                    "description": "function AutoCreateFile",
                    "comment": "function AutoCreateFile"
                },
                {
                    "name": "ContratoID",
                    "type": "function",
                    "signature": "function ContratoID(const AValue: Integer): IParametersInifiles;",
                    "description": "function ContratoID",
                    "comment": "Define ou obtém o ID do contrato para filtro"
                },
                {
                    "name": "ProdutoID",
                    "type": "function",
                    "signature": "function ProdutoID(const AValue: Integer): IParametersInifiles;",
                    "description": "function ProdutoID",
                    "comment": "Define ou obtém o ID do produto para filtro"
                },
                {
                    "name": "Title",
                    "type": "function",
                    "signature": "function Title(const AValue: string): IParametersInifiles;",
                    "description": "function Title",
                    "comment": "Define ou obtém o título/seção dos parâmetros"
                },
                {
                    "name": "List",
                    "type": "function",
                    "signature": "function List(out AList: TParameterList): IParametersInifiles;",
                    "description": "function List",
                    "comment": "Lista todos os parâmetros ativos do banco de dados"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersInifiles;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter): IParametersInifiles;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter): IParametersInifiles;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string): IParametersInifiles;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersInifiles;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Count",
                    "type": "function",
                    "signature": "function Count(out ACount: Integer): IParametersInifiles;",
                    "description": "function Count",
                    "comment": "Retorna o número de parâmetros ativos"
                },
                {
                    "name": "FileExists",
                    "type": "function",
                    "signature": "function FileExists(out AExists: Boolean): IParametersInifiles;",
                    "description": "function FileExists",
                    "comment": "Verifica se o arquivo INI existe"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "JsonObject",
                    "type": "function",
                    "signature": "function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject;",
                    "description": "function JsonObject",
                    "comment": "Retorna a interface IParametersJsonObject"
                },
                {
                    "name": "ObjectName",
                    "type": "function",
                    "signature": "function ObjectName(const AValue: string): IParametersJsonObject;",
                    "description": "function ObjectName",
                    "comment": "Define ou obtém o nome do objeto JSON"
                },
                {
                    "name": "FilePath",
                    "type": "function",
                    "signature": "function FilePath(const AValue: string): IParametersJsonObject;",
                    "description": "function FilePath",
                    "comment": "Define ou obtém o caminho do arquivo INI"
                },
                {
                    "name": "AutoCreateFile",
                    "type": "function",
                    "signature": "function AutoCreateFile(const AValue: Boolean): IParametersJsonObject;",
                    "description": "function AutoCreateFile",
                    "comment": "function AutoCreateFile"
                },
                {
                    "name": "ContratoID",
                    "type": "function",
                    "signature": "function ContratoID(const AValue: Integer): IParametersJsonObject;",
                    "description": "function ContratoID",
                    "comment": "Define ou obtém o ID do contrato para filtro"
                },
                {
                    "name": "ProdutoID",
                    "type": "function",
                    "signature": "function ProdutoID(const AValue: Integer): IParametersJsonObject;",
                    "description": "function ProdutoID",
                    "comment": "Define ou obtém o ID do produto para filtro"
                },
                {
                    "name": "Title",
                    "type": "function",
                    "signature": "function Title(const AValue: string): IParametersJsonObject;",
                    "description": "function Title",
                    "comment": "Define ou obtém o título/seção dos parâmetros"
                },
                {
                    "name": "List",
                    "type": "function",
                    "signature": "function List(out AList: TParameterList): IParametersJsonObject;",
                    "description": "function List",
                    "comment": "Lista todos os parâmetros ativos do banco de dados"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string): IParametersJsonObject;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersJsonObject;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Count",
                    "type": "function",
                    "signature": "function Count(out ACount: Integer): IParametersJsonObject;",
                    "description": "function Count",
                    "comment": "Retorna o número de parâmetros ativos"
                },
                {
                    "name": "FileExists",
                    "type": "function",
                    "signature": "function FileExists(out AExists: Boolean): IParametersJsonObject;",
                    "description": "function FileExists",
                    "comment": "Verifica se o arquivo INI existe"
                },
                {
                    "name": "SaveToFile",
                    "type": "function",
                    "signature": "function SaveToFile(const AFilePath: string = ''): IParametersJsonObject;",
                    "description": "function SaveToFile",
                    "comment": "Salva o objeto JSON em arquivo"
                },
                {
                    "name": "SaveToFile",
                    "type": "function",
                    "signature": "function SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function SaveToFile",
                    "comment": "Salva o objeto JSON em arquivo"
                },
                {
                    "name": "LoadFromString",
                    "type": "function",
                    "signature": "function LoadFromString(const AJsonString: string): IParametersJsonObject;",
                    "description": "function LoadFromString",
                    "comment": "Carrega o objeto JSON de string"
                },
                {
                    "name": "LoadFromFile",
                    "type": "function",
                    "signature": "function LoadFromFile(const AFilePath: string = ''): IParametersJsonObject;",
                    "description": "function LoadFromFile",
                    "comment": "Carrega o objeto JSON de arquivo"
                },
                {
                    "name": "LoadFromFile",
                    "type": "function",
                    "signature": "function LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function LoadFromFile",
                    "comment": "Carrega o objeto JSON de arquivo"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "ImportFromInifiles",
                    "type": "function",
                    "signature": "function ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;",
                    "description": "function ImportFromInifiles",
                    "comment": "function ImportFromInifiles"
                },
                {
                    "name": "ImportFromInifiles",
                    "type": "function",
                    "signature": "function ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ImportFromInifiles",
                    "comment": "function ImportFromInifiles"
                },
                {
                    "name": "ExportToInifiles",
                    "type": "function",
                    "signature": "function ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;",
                    "description": "function ExportToInifiles",
                    "comment": "function ExportToInifiles"
                },
                {
                    "name": "ExportToInifiles",
                    "type": "function",
                    "signature": "function ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ExportToInifiles",
                    "comment": "function ExportToInifiles"
                },
                {
                    "name": "Source",
                    "type": "function",
                    "signature": "function Source(ASource: TParameterSource): IParameters;",
                    "description": "function Source",
                    "comment": "Define ou obtém a fonte ativa de parâmetros"
                },
                {
                    "name": "AddSource",
                    "type": "function",
                    "signature": "function AddSource(ASource: TParameterSource): IParameters;",
                    "description": "function AddSource",
                    "comment": "Adiciona uma fonte à lista de fontes disponíveis"
                },
                {
                    "name": "RemoveSource",
                    "type": "function",
                    "signature": "function RemoveSource(ASource: TParameterSource): IParameters;",
                    "description": "function RemoveSource",
                    "comment": "Remove uma fonte da lista"
                },
                {
                    "name": "HasSource",
                    "type": "function",
                    "signature": "function HasSource(ASource: TParameterSource): Boolean;",
                    "description": "function HasSource",
                    "comment": "Verifica se uma fonte está ativa"
                },
                {
                    "name": "Priority",
                    "type": "function",
                    "signature": "function Priority(ASources: TParameterSourceArray): IParameters;",
                    "description": "function Priority",
                    "comment": "Define a ordem de prioridade das fontes"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string; ASource: TParameterSource): TParameter;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "List",
                    "type": "function",
                    "signature": "function List(out AList: TParameterList): IParameters;",
                    "description": "function List",
                    "comment": "Lista todos os parâmetros ativos do banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter): IParameters;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParameters;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter): IParameters;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParameters;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string): IParameters;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParameters;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string; out AExists: Boolean): IParameters;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Count",
                    "type": "function",
                    "signature": "function Count(out ACount: Integer): IParameters;",
                    "description": "function Count",
                    "comment": "Retorna o número de parâmetros ativos"
                },
                {
                    "name": "ContratoID",
                    "type": "function",
                    "signature": "function ContratoID(const AValue: Integer): IParameters;",
                    "description": "function ContratoID",
                    "comment": "Define ou obtém o ID do contrato para filtro"
                },
                {
                    "name": "ProdutoID",
                    "type": "function",
                    "signature": "function ProdutoID(const AValue: Integer): IParameters;",
                    "description": "function ProdutoID",
                    "comment": "Define ou obtém o ID do produto para filtro"
                }
            ]
        },
        {
            "id": "commons_parameters.types",
            "name": "Parameters.Types.pas",
            "path": "src\\Paramenters\\Commons\\Parameters.Types.pas",
            "description": "<p>Modulo.Parameters.Types - Tipos do Sistema de Parâmetros</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define todos os tipos utilizados pelo sistema de parâmetros, incluindo</p>\n<p>TParameter, TParameterList, TParameterValueType, TParameterSource.</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Types - Tipos Base do Sistema</h3>\n    <p><strong>Finalidade:</strong> Define todos os tipos base usados no módulo Parameters (TParameter, TParameterList, enums, etc.)</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 1: Criar e Usar TParameter</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Types;\n\nvar\n  Param: TParameter;\nbegin\n  // Criar nova instância\n  Param := TParameter.Create;\n  try\n    // Preencher propriedades\n    Param.ID := 0;                    // Auto-incremento\n    Param.Name := 'api_timeout';      // Chave\n    Param.Value := '30000';           // Valor (string)\n    Param.ValueType := pvtInteger;    // Tipo\n    Param.Description := 'Timeout da API em milissegundos';\n    Param.ContratoID := 1;            // Filtro de contrato\n    Param.ProdutoID := 1;             // Filtro de produto\n    Param.Ordem := 10;                // Ordem de exibição\n    Param.Titulo := 'API';            // Título/Seção\n    Param.Ativo := True;              // Ativo\n    Param.CreatedAt := Now;           // Data de criação\n    Param.UpdatedAt := Now;           // Data de atualização\n    \n    WriteLn('Parâmetro criado: ', Param.Name);\n  finally\n    Param.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 2: Usar TParameterList</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Types;\n\nvar\n  ParamList: TParameterList;\n  Param: TParameter;\n  I: Integer;\nbegin\n  // Criar lista\n  ParamList := TParameterList.Create;\n  try\n    // Adicionar parâmetros\n    Param := TParameter.Create;\n    Param.Name := 'param1';\n    Param.Value := 'value1';\n    ParamList.Add(Param);\n    \n    Param := TParameter.Create;\n    Param.Name := 'param2';\n    Param.Value := 'value2';\n    ParamList.Add(Param);\n    \n    // Iterar pela lista\n    for I := 0 to ParamList.Count - 1 do\n      WriteLn(ParamList[I].Name, ' = ', ParamList[I].Value);\n    \n    // Limpar tudo (libera objetos automaticamente)\n    ParamList.ClearAll;\n  finally\n    ParamList.Free;\n  end;\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 3: Usar Enums de Tipo</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Types;\n\nvar\n  Param: TParameter;\n  ValueType: TParameterValueType;\nbegin\n  Param := TParameter.Create;\n  try\n    // String\n    Param.ValueType := pvtString;\n    Param.Value := 'localhost';\n    \n    // Integer\n    Param.ValueType := pvtInteger;\n    Param.Value := '5432';\n    \n    // Float\n    Param.ValueType := pvtFloat;\n    Param.Value := '3.14';\n    \n    // Boolean\n    Param.ValueType := pvtBoolean;\n    Param.Value := 'True';\n    \n    // DateTime\n    Param.ValueType := pvtDateTime;\n    Param.Value := DateTimeToStr(Now);\n    \n    // JSON\n    Param.ValueType := pvtJSON;\n    Param.Value := '{\"host\":\"localhost\",\"port\":5432}';\n  finally\n    Param.Free;\n  end;\nend;</code></pre>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;\">\n    <strong>⚠️ IMPORTANTE:</strong> TParameterList.ClearAll libera TODOS os objetos TParameter da lista antes de limpar. Use Free apenas na própria lista.\n</div>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "TParameter",
                    "description": "<p>Classe <code>TParameter</code>.</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create;",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "destructor Destroy"
                        },
                        {
                            "name": "ID",
                            "type": "property",
                            "signature": "property ID: Integer read FID write FID;",
                            "comment": "Propriedade ID do tipo Integer"
                        },
                        {
                            "name": "Name",
                            "type": "property",
                            "signature": "property Name: string read FName write FName;",
                            "comment": "Propriedade Name do tipo string"
                        },
                        {
                            "name": "Value",
                            "type": "property",
                            "signature": "property Value: string read FValue write FValue;",
                            "comment": "Propriedade Value do tipo string"
                        },
                        {
                            "name": "ValueType",
                            "type": "property",
                            "signature": "property ValueType: TParameterValueType read FValueType write FValueType;",
                            "comment": "Propriedade ValueType do tipo TParameterValueType"
                        },
                        {
                            "name": "Description",
                            "type": "property",
                            "signature": "property Description: string read FDescription write FDescription;",
                            "comment": "Propriedade Description do tipo string"
                        },
                        {
                            "name": "ContratoID",
                            "type": "property",
                            "signature": "property ContratoID: Integer read FContratoID write FContratoID;",
                            "comment": "Propriedade ContratoID do tipo Integer"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "property",
                            "signature": "property ProdutoID: Integer read FProdutoID write FProdutoID;",
                            "comment": "Propriedade ProdutoID do tipo Integer"
                        },
                        {
                            "name": "Ordem",
                            "type": "property",
                            "signature": "property Ordem: Integer read FOrdem write FOrdem;",
                            "comment": "Propriedade Ordem do tipo Integer"
                        },
                        {
                            "name": "Titulo",
                            "type": "property",
                            "signature": "property Titulo: string read FTitulo write FTitulo;",
                            "comment": "Propriedade Titulo do tipo string"
                        },
                        {
                            "name": "Ativo",
                            "type": "property",
                            "signature": "property Ativo: Boolean read FAtivo write FAtivo;",
                            "comment": "Propriedade Ativo do tipo Boolean"
                        },
                        {
                            "name": "CreatedAt",
                            "type": "property",
                            "signature": "property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;",
                            "comment": "Propriedade CreatedAt do tipo TDateTime"
                        },
                        {
                            "name": "UpdatedAt",
                            "type": "property",
                            "signature": "property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;",
                            "comment": "Propriedade UpdatedAt do tipo TDateTime"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "TParameterList",
                    "description": "<p>UpdatedAt - Data/hora da última atualização</p>\n<p>Atualizado automaticamente na modificação.</p>",
                    "publicMethods": [
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "destructor Destroy"
                        },
                        {
                            "name": "ClearAll",
                            "type": "procedure",
                            "signature": "procedure ClearAll;",
                            "comment": "List ainda existe, mas está vazia"
                        }
                    ],
                    "privateMethods": []
                }
            ],
            "functions": []
        },
        {
            "id": "commons_parameters.consts",
            "name": "Parameters.Consts.pas",
            "path": "src\\Paramenters\\Commons\\Parameters.Consts.pas",
            "description": "<p>Modulo.Parameters.Consts - Constantes do Sistema de Parâmetros</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define todas as constantes utilizadas pelo sistema de parâmetros, incluindo</p>\n<p>valores padrão para configuração, nomes de tabelas, seções e caminhos.</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 01/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Consts - Constantes do Sistema</h3>\n    <p><strong>Finalidade:</strong> Define todas as constantes padrão usadas no módulo (nomes de tabela, campos, SQL, mensagens, etc.)</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 1: Usar Constantes de Tabela</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Consts,\n  Parameters;\n\nvar\n  DB: IParametersDatabase;\nbegin\n  DB := TParameters.NewDatabase;\n  \n  // Usar constantes padrão\n  DB.TableName(DEFAULT_TABLE_NAME)        // 'parameters'\n    .Schema(DEFAULT_SCHEMA)               // 'public'\n    .Connect;\n  \n  WriteLn('Conectado à tabela: ', DEFAULT_TABLE_NAME);\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 2: Usar Constantes de Campo</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Consts;\n\nbegin\n  // Nomes de campos (útil para queries personalizadas)\n  WriteLn('ID Field: ', FIELD_ID);                    // 'id'\n  WriteLn('Name Field: ', FIELD_NAME);                // 'name'\n  WriteLn('Value Field: ', FIELD_VALUE);              // 'value'\n  WriteLn('ValueType Field: ', FIELD_VALUE_TYPE);     // 'value_type'\n  WriteLn('Description Field: ', FIELD_DESCRIPTION);  // 'description'\n  WriteLn('ContratoID Field: ', FIELD_CONTRATO_ID);   // 'contrato_id'\n  WriteLn('ProdutoID Field: ', FIELD_PRODUTO_ID);     // 'produto_id'\n  WriteLn('Titulo Field: ', FIELD_TITULO);            // 'titulo'\n  WriteLn('Ordem Field: ', FIELD_ORDEM);              // 'ordem'\n  WriteLn('Ativo Field: ', FIELD_ATIVO);              // 'ativo'\n  WriteLn('CreatedAt Field: ', FIELD_CREATED_AT);     // 'created_at'\n  WriteLn('UpdatedAt Field: ', FIELD_UPDATED_AT);     // 'updated_at'\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 3: Usar Mensagens Padrão</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Consts;\n\nbegin\n  // Mensagens de erro padrão\n  WriteLn(MSG_ERROR_CONNECTION);          // 'Erro ao conectar ao banco de dados'\n  WriteLn(MSG_ERROR_NOT_CONNECTED);       // 'Não conectado ao banco de dados'\n  WriteLn(MSG_ERROR_PARAMETER_NOT_FOUND); // 'Parâmetro não encontrado'\n  WriteLn(MSG_ERROR_INVALID_VALUE);       // 'Valor inválido'\n  \n  // Mensagens de sucesso\n  WriteLn(MSG_SUCCESS_INSERT);            // 'Parâmetro inserido com sucesso'\n  WriteLn(MSG_SUCCESS_UPDATE);            // 'Parâmetro atualizado com sucesso'\n  WriteLn(MSG_SUCCESS_DELETE);            // 'Parâmetro deletado com sucesso'\nend;</code></pre>\n\n<div style=\"background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;\">\n    <strong>💡 DICA:</strong> Use as constantes em vez de hardcoded strings para facilitar manutenção e evitar erros de digitação.\n</div>\n",
            "interfaces": [],
            "classes": [],
            "functions": [
                {
                    "name": "GetBooleanSQLType",
                    "type": "function",
                    "signature": "function GetBooleanSQLType(const ADatabaseType: TParameterDatabaseTypes): string;",
                    "description": "function GetBooleanSQLType",
                    "comment": "Retorna o tipo SQL correto para campo boolean conforme o banco de dados Usado na criação de tabelas para garantir compatibilidade"
                },
                {
                    "name": "GetBooleanSQLDefault",
                    "type": "function",
                    "signature": "function GetBooleanSQLDefault(const ADatabaseType: TParameterDatabaseTypes; const AValue: Boolean = True): string;",
                    "description": "function GetBooleanSQLDefault",
                    "comment": "Retorna o valor DEFAULT correto para campo boolean conforme o banco de dados Usado na criação de tabelas para garantir compatibilidade"
                }
            ]
        },
        {
            "id": "commons_parameters.exceptions",
            "name": "Parameters.Exceptions.pas",
            "path": "src\\Paramenters\\Commons\\Parameters.Exceptions.pas",
            "description": "<p>Modulo.Parameters.Exceptions - Sistema Completo de Exceções e Mensagens de Erro</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define exceções customizadas e mensagens de erro para o módulo Parameters.</p>\n<p>Fornece tratamento consistente de erros em todo o sistema, garantindo que</p>\n<p>100% das exceções do módulo Parameters usem este sistema.</p>\n<p>Estrutura:</p>\n<p>- EParametersException: Classe base para todas as exceções do módulo</p>\n<p>- Exceções específicas por categoria (Connection, SQL, Validation, etc.)</p>\n<p>- Códigos de erro organizados por faixa (1000-1999)</p>\n<p>- Mensagens de erro padronizadas</p>\n<p>- Funções auxiliares para criação de exceções</p>\n<p>- Funções auxiliares para conversão de exceções genéricas</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 2.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Exceptions - Sistema de Exceções</h3>\n    <p><strong>Finalidade:</strong> Define todas as exceções customizadas do módulo com códigos de erro e mensagens detalhadas</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 1: Capturar Exceções Específicas</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters,\n  Parameters.Exceptions;\n\nvar\n  DB: IParametersDatabase;\n  Param: TParameter;\nbegin\n  try\n    DB := TParameters.NewDatabase;\n    DB.DatabaseType('PostgreSQL')\n      .Host('localhost')\n      .Port(5432)\n      .Database('mydb')\n      .Username('user')\n      .Password('pass')\n      .Connect;\n      \n    Param := DB.Getter('config_key');\n    \n  except\n    // Erro de conexão\n    on E: EParameterDatabaseConnectionError do\n      WriteLn('Erro de conexão: ', E.Message, ' [Código: ', E.ErrorCode, ']');\n      \n    // Parâmetro não encontrado\n    on E: EParameterNotFoundError do\n      WriteLn('Parâmetro não encontrado: ', E.Message);\n      \n    // Valor inválido\n    on E: EParameterValidationError do\n      WriteLn('Validação falhou: ', E.Message);\n      \n    // Erro genérico\n    on E: EParameterError do\n      WriteLn('Erro: ', E.Message, ' [Código: ', E.ErrorCode, ']');\n  end;\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 2: Lançar Exceções Customizadas</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Exceptions;\n\nprocedure ValidateParameter(const AValue: string);\nbegin\n  if Trim(AValue) = '' then\n    raise EParameterValidationError.Create('Valor não pode ser vazio', 1001);\n    \n  if Length(AValue) > 255 then\n    raise EParameterValidationError.Create('Valor muito longo (máx 255 caracteres)', 1002);\nend;\n\nvar\n  Value: string;\nbegin\n  try\n    Value := '';\n    ValidateParameter(Value);\n  except\n    on E: EParameterValidationError do\n      WriteLn('Validação falhou: ', E.Message, ' [Código: ', E.ErrorCode, ']');\n  end;\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📊 Hierarquia de Exceções</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>EParameterError (Base)\n├── EParameterDatabaseError\n│   ├── EParameterDatabaseConnectionError\n│   ├── EParameterDatabaseQueryError\n│   └── EParameterDatabaseTableError\n├── EParameterInifileError\n│   ├── EParameterInifileNotFoundError\n│   └── EParameterInifileParseError\n├── EParameterJsonObjectError\n│   └── EParameterJsonParseError\n├── EParameterNotFoundError\n├── EParameterValidationError\n└── EParameterConfigError</code></pre>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;\">\n    <strong>⚠️ IMPORTANTE:</strong> Todas as exceções herdam de EParameterError e têm propriedades Message e ErrorCode.\n</div>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "EParametersException",
                    "description": "<p>EParametersException - Exceção Base para o Módulo Parameters</p>\n<p>Classe base para todas as exceções do módulo Parameters.</p>\n<p>Fornece ErrorCode e Operation para facilitar tratamento e logging.</p>\n<p>Propriedades:</p>\n<p>- ErrorCode: Código numérico do erro (facilita tratamento programático)</p>\n<p>- Operation: Nome da operação que causou o erro (facilita debug)</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "ErrorCode",
                            "type": "property",
                            "signature": "property ErrorCode: Integer read FErrorCode;",
                            "comment": "Propriedade ErrorCode do tipo Integer"
                        },
                        {
                            "name": "Operation",
                            "type": "property",
                            "signature": "property Operation: string read FOperation;",
                            "comment": "Propriedade Operation do tipo string"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "EParametersConnectionException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersSQLException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersValidationException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersNotFoundException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersConfigurationException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersFileException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersInifilesException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "EParametersJsonObjectException",
                    "description": "<p>Exceções Específicas por Categoria</p>",
                    "publicMethods": [],
                    "privateMethods": []
                }
            ],
            "functions": [
                {
                    "name": "CreateConnectionException",
                    "type": "function",
                    "signature": "function CreateConnectionException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersConnectionException;",
                    "description": "function CreateConnectionException",
                    "comment": "Cria exceção de conexão"
                },
                {
                    "name": "CreateSQLException",
                    "type": "function",
                    "signature": "function CreateSQLException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersSQLException;",
                    "description": "function CreateSQLException",
                    "comment": "Cria exceção de SQL"
                },
                {
                    "name": "CreateValidationException",
                    "type": "function",
                    "signature": "function CreateValidationException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersValidationException;",
                    "description": "function CreateValidationException",
                    "comment": "Cria exceção de validação"
                },
                {
                    "name": "CreateNotFoundException",
                    "type": "function",
                    "signature": "function CreateNotFoundException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersNotFoundException;",
                    "description": "function CreateNotFoundException",
                    "comment": "Cria exceção de não encontrado"
                },
                {
                    "name": "CreateConfigurationException",
                    "type": "function",
                    "signature": "function CreateConfigurationException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersConfigurationException;",
                    "description": "function CreateConfigurationException",
                    "comment": "Cria exceção de configuração"
                },
                {
                    "name": "CreateFileException",
                    "type": "function",
                    "signature": "function CreateFileException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersFileException;",
                    "description": "function CreateFileException",
                    "comment": "Cria exceção de arquivo"
                },
                {
                    "name": "CreateInifilesException",
                    "type": "function",
                    "signature": "function CreateInifilesException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersInifilesException;",
                    "description": "function CreateInifilesException",
                    "comment": "Cria exceção de INI"
                },
                {
                    "name": "CreateJsonObjectException",
                    "type": "function",
                    "signature": "function CreateJsonObjectException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EParametersJsonObjectException;",
                    "description": "function CreateJsonObjectException",
                    "comment": "Cria exceção de JSON"
                },
                {
                    "name": "ConvertToParametersException",
                    "type": "function",
                    "signature": "function ConvertToParametersException(const AException: Exception; const AOperation: string = ''): EParametersException;",
                    "description": "function ConvertToParametersException",
                    "comment": "Converte exceção genérica para exceção do Parameters (quando possível)"
                },
                {
                    "name": "IsParametersException",
                    "type": "function",
                    "signature": "function IsParametersException(const AException: Exception): Boolean;",
                    "description": "function IsParametersException",
                    "comment": "Verifica se uma exceção é do tipo Parameters"
                },
                {
                    "name": "GetExceptionErrorCode",
                    "type": "function",
                    "signature": "function GetExceptionErrorCode(const AException: Exception): Integer;",
                    "description": "function GetExceptionErrorCode",
                    "comment": "Obtém código de erro de uma exceção (retorna 0 se não for exceção Parameters)"
                },
                {
                    "name": "GetExceptionOperation",
                    "type": "function",
                    "signature": "function GetExceptionOperation(const AException: Exception): string;",
                    "description": "function GetExceptionOperation",
                    "comment": "Obtém operação de uma exceção (retorna string vazia se não for exceção Parameters)"
                }
            ]
        },
        {
            "id": "database_parameters.database",
            "name": "Parameters.Database.pas",
            "path": "src\\Paramenters\\Database\\Parameters.Database.pas",
            "description": "<p>Modulo.Parameters.Database - Implementação de Acesso a Parâmetros em Banco de Dados</p>\n<p><strong>Descrição:</strong> </p>\n<p>Implementa IParametersDatabase para acesso a parâmetros na tabela config</p>\n<p>do banco de dados. Módulo independente que aceita conexão genérica.</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Database - Implementação Database</h3>\n    <p><strong>Finalidade:</strong> Implementação completa de IParametersDatabase com suporte a UniDAC, FireDAC e Zeos</p>\n    <p><strong>⚠️ NÃO USE DIRETAMENTE!</strong> Use sempre TParameters.NewDatabase</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">✅ USO CORRETO (Factory Method)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;  // ✅ CORRETO - Use apenas Parameters.pas\n\nvar\n  DB: IParametersDatabase;\nbegin\n  // ✅ Criar via Factory Method\n  DB := TParameters.NewDatabase;\n  \n  DB.DatabaseType('PostgreSQL')\n    .Host('localhost')\n    .Port(5432)\n    .Database('mydb')\n    .Username('postgres')\n    .Password('pass')\n    .TableName('config')\n    .Schema('public')\n    .AutoCreateTable(True)\n    .Connect;\n    \n  // Usar normalmente...\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">❌ USO INCORRETO (Direto)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Database;  // ❌ ERRADO - NÃO use units internas!\n\nvar\n  DB: TParametersDatabase;  // ❌ Classe interna\nbegin\n  // ❌ NÃO faça isso!\n  DB := TParametersDatabase.Create;\n  // ...\nend;</code></pre>\n\n<div style=\"background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;\">\n    <strong>🚫 AVISO:</strong> Esta unit é INTERNA. Suas classes e métodos podem mudar sem aviso. Use SEMPRE os Factory Methods de TParameters!\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📚 Documentação Completa</h4>\n<p>Para documentação completa de métodos, veja <strong>Roteiro de Uso → Externo → IParametersDatabase</strong></p>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "TParametersDatabase",
                    "description": "<p>TParametersDatabase - Implementação de IParametersDatabase (Independente)</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create;",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(AConnection: TObject; AQuery: TDataSet = nil; AExecQuery: TDataSet = nil);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "destructor Destroy"
                        },
                        {
                            "name": "TableName",
                            "type": "function",
                            "signature": "function TableName(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o nome da tabela de parâmetros"
                        },
                        {
                            "name": "TableName",
                            "type": "function",
                            "signature": "function TableName: string;",
                            "comment": "Define ou obtém o nome da tabela de parâmetros"
                        },
                        {
                            "name": "Schema",
                            "type": "function",
                            "signature": "function Schema(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o schema da tabela"
                        },
                        {
                            "name": "Schema",
                            "type": "function",
                            "signature": "function Schema: string;",
                            "comment": "Define ou obtém o schema da tabela"
                        },
                        {
                            "name": "AutoCreateTable",
                            "type": "function",
                            "signature": "function AutoCreateTable(const AValue: Boolean): IParametersDatabase;",
                            "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                        },
                        {
                            "name": "AutoCreateTable",
                            "type": "function",
                            "signature": "function AutoCreateTable: Boolean;",
                            "comment": "Define ou obtém se a tabela deve ser criada automaticamente"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine(const AValue: TParameterDatabaseEngine): IParametersDatabase;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "Engine",
                            "type": "function",
                            "signature": "function Engine: string;",
                            "comment": "Define ou obtém o engine de banco de dados (UniDAC, FireDAC, Zeos)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType(const AValue: TParameterDatabaseTypes): IParametersDatabase;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "DatabaseType",
                            "type": "function",
                            "signature": "function DatabaseType: string;",
                            "comment": "Define ou obtém o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            "name": "Host",
                            "type": "function",
                            "signature": "function Host(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o host do banco de dados"
                        },
                        {
                            "name": "Host",
                            "type": "function",
                            "signature": "function Host: string;",
                            "comment": "Define ou obtém o host do banco de dados"
                        },
                        {
                            "name": "Port",
                            "type": "function",
                            "signature": "function Port(const AValue: Integer): IParametersDatabase;",
                            "comment": "Define ou obtém a porta do banco de dados"
                        },
                        {
                            "name": "Port",
                            "type": "function",
                            "signature": "function Port: Integer;",
                            "comment": "Define ou obtém a porta do banco de dados"
                        },
                        {
                            "name": "Username",
                            "type": "function",
                            "signature": "function Username(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o usuário do banco de dados"
                        },
                        {
                            "name": "Username",
                            "type": "function",
                            "signature": "function Username: string;",
                            "comment": "Define ou obtém o usuário do banco de dados"
                        },
                        {
                            "name": "Password",
                            "type": "function",
                            "signature": "function Password(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém a senha do banco de dados"
                        },
                        {
                            "name": "Password",
                            "type": "function",
                            "signature": "function Password: string;",
                            "comment": "Define ou obtém a senha do banco de dados"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database(const AValue: string): IParametersDatabase;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "Database",
                            "type": "function",
                            "signature": "function Database: string;",
                            "comment": "Retorna a interface IParametersDatabase"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID(const AValue: Integer): IParametersDatabase;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID(const AValue: Integer): IParametersDatabase;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title(const AValue: string): IParametersDatabase;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title: string;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "Connection",
                            "type": "function",
                            "signature": "function Connection(AConnection: TObject): IParametersDatabase;",
                            "comment": "function Connection"
                        },
                        {
                            "name": "Query",
                            "type": "function",
                            "signature": "function Query(AQuery: TDataSet): IParametersDatabase;",
                            "comment": "function Query"
                        },
                        {
                            "name": "ExecQuery",
                            "type": "function",
                            "signature": "function ExecQuery(AExecQuery: TDataSet): IParametersDatabase;",
                            "comment": "function ExecQuery"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List(out AList: TParameterList): IParametersDatabase;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersDatabase;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter): IParametersDatabase;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter): IParametersDatabase;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Update",
                            "type": "function",
                            "signature": "function Update(const AParameter: TParameter): IParametersDatabase;",
                            "comment": "Atualiza um parâmetro existente no banco de dados"
                        },
                        {
                            "name": "Update",
                            "type": "function",
                            "signature": "function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Atualiza um parâmetro existente no banco de dados"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string): IParametersDatabase;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersDatabase;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count(out ACount: Integer): IParametersDatabase;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "IsConnected",
                            "type": "function",
                            "signature": "function IsConnected: Boolean;",
                            "comment": "Verifica se está conectado ao banco de dados"
                        },
                        {
                            "name": "IsConnected",
                            "type": "function",
                            "signature": "function IsConnected(out AConnected: Boolean): IParametersDatabase;",
                            "comment": "Verifica se está conectado ao banco de dados"
                        },
                        {
                            "name": "Connect",
                            "type": "function",
                            "signature": "function Connect: IParametersDatabase;",
                            "comment": "Conecta ao banco de dados"
                        },
                        {
                            "name": "Connect",
                            "type": "function",
                            "signature": "function Connect(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Conecta ao banco de dados"
                        },
                        {
                            "name": "Disconnect",
                            "type": "function",
                            "signature": "function Disconnect: IParametersDatabase;",
                            "comment": "Desconecta do banco de dados"
                        },
                        {
                            "name": "Refresh",
                            "type": "function",
                            "signature": "function Refresh: IParametersDatabase;",
                            "comment": "Recarrega os parâmetros do banco de dados"
                        },
                        {
                            "name": "TableExists",
                            "type": "function",
                            "signature": "function TableExists: Boolean;",
                            "comment": "Verifica se a tabela existe no banco de dados"
                        },
                        {
                            "name": "TableExists",
                            "type": "function",
                            "signature": "function TableExists(out AExists: Boolean): IParametersDatabase;",
                            "comment": "Verifica se a tabela existe no banco de dados"
                        },
                        {
                            "name": "CreateTable",
                            "type": "function",
                            "signature": "function CreateTable: IParametersDatabase;",
                            "comment": "Cria a tabela de parâmetros se não existir"
                        },
                        {
                            "name": "CreateTable",
                            "type": "function",
                            "signature": "function CreateTable(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Cria a tabela de parâmetros se não existir"
                        },
                        {
                            "name": "DropTable",
                            "type": "function",
                            "signature": "function DropTable: IParametersDatabase;",
                            "comment": "Remove a tabela de parâmetros"
                        },
                        {
                            "name": "DropTable",
                            "type": "function",
                            "signature": "function DropTable(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Remove a tabela de parâmetros"
                        },
                        {
                            "name": "MigrateTable",
                            "type": "function",
                            "signature": "function MigrateTable: IParametersDatabase;",
                            "comment": "Migra a estrutura da tabela para a versão atual"
                        },
                        {
                            "name": "MigrateTable",
                            "type": "function",
                            "signature": "function MigrateTable(out ASuccess: Boolean): IParametersDatabase;",
                            "comment": "Migra a estrutura da tabela para a versão atual"
                        },
                        {
                            "name": "ListAvailableDatabases",
                            "type": "function",
                            "signature": "function ListAvailableDatabases(out ADatabases: TStringList): IParametersDatabase;",
                            "comment": "function ListAvailableDatabases"
                        },
                        {
                            "name": "ListAvailableDatabases",
                            "type": "function",
                            "signature": "function ListAvailableDatabases: TStringList;",
                            "comment": "function ListAvailableDatabases"
                        },
                        {
                            "name": "ListAvailableTables",
                            "type": "function",
                            "signature": "function ListAvailableTables(out ATables: TStringList): IParametersDatabase;",
                            "comment": "function ListAvailableTables"
                        },
                        {
                            "name": "ListAvailableTables",
                            "type": "function",
                            "signature": "function ListAvailableTables: TStringList;",
                            "comment": "function ListAvailableTables"
                        }
                    ],
                    "privateMethods": [
                        {
                            "name": "GetFullTableName",
                            "type": "function",
                            "signature": "function GetFullTableName: string;",
                            "comment": "$ENDIF $ENDIF"
                        },
                        {
                            "name": "GetFullTableNameForSQL",
                            "type": "function",
                            "signature": "function GetFullTableNameForSQL: string;",
                            "comment": "function GetFullTableNameForSQL"
                        },
                        {
                            "name": "InternalTableExists",
                            "type": "function",
                            "signature": "function InternalTableExists: Boolean;",
                            "comment": "function InternalTableExists"
                        },
                        {
                            "name": "EnsureTableExists",
                            "type": "function",
                            "signature": "function EnsureTableExists: Boolean;",
                            "comment": "function EnsureTableExists"
                        },
                        {
                            "name": "ValidateSQLiteTableStructure",
                            "type": "function",
                            "signature": "function ValidateSQLiteTableStructure: Boolean;",
                            "comment": "function ValidateSQLiteTableStructure"
                        },
                        {
                            "name": "CreateAccessDatabase",
                            "type": "function",
                            "signature": "function CreateAccessDatabase(const AFilePath: string): Boolean;",
                            "comment": "function CreateAccessDatabase"
                        },
                        {
                            "name": "IndexExists",
                            "type": "function",
                            "signature": "function IndexExists(const AIndexName: string; ADatabaseType: TParameterDatabaseTypes; const ATableName: string): Boolean;",
                            "comment": "function IndexExists"
                        },
                        {
                            "name": "GetDropIndexSQL",
                            "type": "function",
                            "signature": "function GetDropIndexSQL(const AIndexName: string; ADatabaseType: TParameterDatabaseTypes; const ATableName: string): string;",
                            "comment": "function GetDropIndexSQL"
                        },
                        {
                            "name": "GetDefaultHost",
                            "type": "function",
                            "signature": "function GetDefaultHost: string;",
                            "comment": "function GetDefaultHost"
                        },
                        {
                            "name": "GetDefaultPort",
                            "type": "function",
                            "signature": "function GetDefaultPort: Integer;",
                            "comment": "function GetDefaultPort"
                        },
                        {
                            "name": "GetDefaultUsername",
                            "type": "function",
                            "signature": "function GetDefaultUsername: string;",
                            "comment": "function GetDefaultUsername"
                        },
                        {
                            "name": "GetDefaultPassword",
                            "type": "function",
                            "signature": "function GetDefaultPassword: string;",
                            "comment": "function GetDefaultPassword"
                        },
                        {
                            "name": "GetDefaultDatabase",
                            "type": "function",
                            "signature": "function GetDefaultDatabase: string;",
                            "comment": "function GetDefaultDatabase"
                        },
                        {
                            "name": "EscapeSQL",
                            "type": "function",
                            "signature": "function EscapeSQL(const AValue: string): string;",
                            "comment": "function EscapeSQL"
                        },
                        {
                            "name": "BooleanToSQL",
                            "type": "function",
                            "signature": "function BooleanToSQL(const AValue: Boolean): string;",
                            "comment": "function BooleanToSQL"
                        },
                        {
                            "name": "BooleanToSQLCondition",
                            "type": "function",
                            "signature": "function BooleanToSQLCondition(const AValue: Boolean): string;",
                            "comment": "function BooleanToSQLCondition"
                        },
                        {
                            "name": "BooleanFromDataSet",
                            "type": "function",
                            "signature": "function BooleanFromDataSet(ADataSet: TDataSet; const AFieldName: string): Boolean;",
                            "comment": "function BooleanFromDataSet"
                        },
                        {
                            "name": "ValueTypeToString",
                            "type": "function",
                            "signature": "function ValueTypeToString(const AValueType: TParameterValueType): string;",
                            "comment": "function ValueTypeToString"
                        },
                        {
                            "name": "StringToValueType",
                            "type": "function",
                            "signature": "function StringToValueType(const AValue: string): TParameterValueType;",
                            "comment": "function StringToValueType"
                        },
                        {
                            "name": "DataSetToParameter",
                            "type": "function",
                            "signature": "function DataSetToParameter(ADataSet: TDataSet): TParameter;",
                            "comment": "function DataSetToParameter"
                        },
                        {
                            "name": "ExecuteSQL",
                            "type": "function",
                            "signature": "function ExecuteSQL(const ASQL: string): Boolean;",
                            "comment": "function ExecuteSQL"
                        },
                        {
                            "name": "QuerySQL",
                            "type": "function",
                            "signature": "function QuerySQL(const ASQL: string): TDataSet;",
                            "comment": "function QuerySQL"
                        },
                        {
                            "name": "BuildSelectFieldsSQL",
                            "type": "function",
                            "signature": "function BuildSelectFieldsSQL: string;",
                            "comment": "function BuildSelectFieldsSQL"
                        },
                        {
                            "name": "GetTableColumns",
                            "type": "function",
                            "signature": "function GetTableColumns: TStringList;",
                            "comment": "function GetTableColumns"
                        },
                        {
                            "name": "ValidateTableStructure",
                            "type": "function",
                            "signature": "function ValidateTableStructure: Boolean;",
                            "comment": "function ValidateTableStructure"
                        },
                        {
                            "name": "GetNextOrder",
                            "type": "function",
                            "signature": "function GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer;",
                            "comment": "function GetNextOrder"
                        },
                        {
                            "name": "TituloExistsForContratoProduto",
                            "type": "function",
                            "signature": "function TituloExistsForContratoProduto(const ATitulo: string; AContratoID, AProdutoID: Integer; const AExcludeChave: string = ''): Boolean;",
                            "comment": "function TituloExistsForContratoProduto"
                        },
                        {
                            "name": "ExistsWithTitulo",
                            "type": "function",
                            "signature": "function ExistsWithTitulo(const AName, ATitulo: string; AContratoID, AProdutoID: Integer): Boolean;",
                            "comment": "function ExistsWithTitulo"
                        },
                        {
                            "name": "AdjustOrdersForInsert",
                            "type": "procedure",
                            "signature": "procedure AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer);",
                            "comment": "procedure AdjustOrdersForInsert"
                        },
                        {
                            "name": "AdjustOrdersForUpdate",
                            "type": "procedure",
                            "signature": "procedure AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID, AOldOrder, ANewOrder: Integer; const AChave: string);",
                            "comment": "procedure AdjustOrdersForUpdate"
                        },
                        {
                            "name": "ListAvailableDatabasesInternal",
                            "type": "function",
                            "signature": "function ListAvailableDatabasesInternal: TStringList;",
                            "comment": "function ListAvailableDatabasesInternal"
                        },
                        {
                            "name": "ListAvailableTablesInternal",
                            "type": "function",
                            "signature": "function ListAvailableTablesInternal: TStringList;",
                            "comment": "function ListAvailableTablesInternal"
                        },
                        {
                            "name": "StringToDatabaseType",
                            "type": "function",
                            "signature": "function StringToDatabaseType(const AValue: string): TParameterDatabaseTypes;",
                            "comment": "Funções auxiliares para conversão de DatabaseType"
                        },
                        {
                            "name": "GetDatabaseTypeForEngine",
                            "type": "function",
                            "signature": "function GetDatabaseTypeForEngine(const ADatabaseType: TParameterDatabaseTypes; const AEngine: TParameterDatabaseEngine): string;",
                            "comment": "function GetDatabaseTypeForEngine"
                        },
                        {
                            "name": "GetCurrentEngine",
                            "type": "function",
                            "signature": "function GetCurrentEngine: TParameterDatabaseEngine;",
                            "comment": "function GetCurrentEngine"
                        },
                        {
                            "name": "GetConnectionProperty",
                            "type": "function",
                            "signature": "function GetConnectionProperty(const APropName: string): Variant;",
                            "comment": "Métodos auxiliares para conexão genérica (usando RTTI)"
                        },
                        {
                            "name": "SetConnectionProperty",
                            "type": "procedure",
                            "signature": "procedure SetConnectionProperty(const APropName: string; const AValue: Variant);",
                            "comment": "procedure SetConnectionProperty"
                        },
                        {
                            "name": "IsConnectionConnected",
                            "type": "function",
                            "signature": "function IsConnectionConnected: Boolean;",
                            "comment": "function IsConnectionConnected"
                        },
                        {
                            "name": "ConnectConnection",
                            "type": "procedure",
                            "signature": "procedure ConnectConnection;",
                            "comment": "procedure ConnectConnection"
                        },
                        {
                            "name": "DisconnectConnection",
                            "type": "procedure",
                            "signature": "procedure DisconnectConnection;",
                            "comment": "procedure DisconnectConnection"
                        },
                        {
                            "name": "CreateInternalConnection",
                            "type": "procedure",
                            "signature": "procedure CreateInternalConnection;",
                            "comment": "procedure CreateInternalConnection"
                        },
                        {
                            "name": "DestroyInternalConnection",
                            "type": "procedure",
                            "signature": "procedure DestroyInternalConnection;",
                            "comment": "procedure DestroyInternalConnection"
                        },
                        {
                            "name": "CreateProviderForDatabaseType",
                            "type": "procedure",
                            "signature": "procedure CreateProviderForDatabaseType(const ADatabaseType: TParameterDatabaseTypes);",
                            "comment": "procedure CreateProviderForDatabaseType"
                        },
                        {
                            "name": "DestroyAllProviders",
                            "type": "procedure",
                            "signature": "procedure DestroyAllProviders;",
                            "comment": "procedure DestroyAllProviders"
                        },
                        {
                            "name": "ConfigureFireDACDLLPaths",
                            "type": "procedure",
                            "signature": "procedure ConfigureFireDACDLLPaths;",
                            "comment": "procedure ConfigureFireDACDLLPaths"
                        },
                        {
                            "name": "ConfigureZeosLibraryLocation",
                            "type": "procedure",
                            "signature": "procedure ConfigureZeosLibraryLocation(AConnection: TZConnection; ADatabaseType: TParameterDatabaseTypes);",
                            "comment": "$IF DEFINED(USE_ZEOS)"
                        }
                    ]
                }
            ],
            "functions": []
        },
        {
            "id": "inifiles_parameters.inifiles",
            "name": "Parameters.Inifiles.pas",
            "path": "src\\Paramenters\\IniFiles\\Parameters.Inifiles.pas",
            "description": "<p>Modulo.Parameters.Inifiles - Implementação de Acesso a Parâmetros em Arquivos INI</p>\n<p><strong>Descrição:</strong> </p>\n<p>Implementa IParametersInifiles para acesso a parâmetros em arquivos INI.</p>\n<p>Suporta importação/exportação bidirecional com Database.</p>\n<p>Formato INI:</p>\n<p>- Título = Sessão</p>\n<p>- Chave e valor = itens da sessão</p>\n<p>- Itens inativos começam com \"#\" na frente</p>\n<p>- Descrição = comentário na frente de cada item</p>\n<p>- Contrato e produto = sessão separada</p>\n<p>- Ordem = sequência de colocação</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Inifiles - Implementação INI Files</h3>\n    <p><strong>Finalidade:</strong> Implementação completa de IParametersInifiles para arquivos INI</p>\n    <p><strong>⚠️ NÃO USE DIRETAMENTE!</strong> Use sempre TParameters.NewInifiles</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">✅ USO CORRETO (Factory Method)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;  // ✅ CORRETO - Use apenas Parameters.pas\n\nvar\n  Ini: IParametersInifiles;\nbegin\n  // ✅ Criar via Factory Method\n  Ini := TParameters.NewInifiles;\n  \n  Ini.FilePath('C:\\Config\\params.ini')\n     .Section('ERP')\n     .AutoCreateFile(True)\n     .ContratoID(1)\n     .ProdutoID(1);\n     \n  // Usar normalmente...\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">❌ USO INCORRETO (Direto)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Inifiles;  // ❌ ERRADO - NÃO use units internas!\n\nvar\n  Ini: TParametersInifiles;  // ❌ Classe interna\nbegin\n  // ❌ NÃO faça isso!\n  Ini := TParametersInifiles.Create;\n  // ...\nend;</code></pre>\n\n<div style=\"background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;\">\n    <strong>🚫 AVISO:</strong> Esta unit é INTERNA. Suas classes e métodos podem mudar sem aviso. Use SEMPRE os Factory Methods de TParameters!\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📚 Documentação Completa</h4>\n<p>Para documentação completa de métodos, veja <strong>Roteiro de Uso → Externo → IParametersInifiles</strong></p>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "TParametersInifiles",
                    "description": "<p>TParametersInifiles - Implementação de IParametersInifiles</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create;",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AFilePath: string);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "destructor Destroy"
                        },
                        {
                            "name": "FilePath",
                            "type": "function",
                            "signature": "function FilePath(const AValue: string): IParametersInifiles;",
                            "comment": "Define ou obtém o caminho do arquivo INI"
                        },
                        {
                            "name": "FilePath",
                            "type": "function",
                            "signature": "function FilePath: string;",
                            "comment": "Define ou obtém o caminho do arquivo INI"
                        },
                        {
                            "name": "Section",
                            "type": "function",
                            "signature": "function Section(const AValue: string): IParametersInifiles;",
                            "comment": "Define ou obtém a seção do arquivo INI"
                        },
                        {
                            "name": "Section",
                            "type": "function",
                            "signature": "function Section: string;",
                            "comment": "Define ou obtém a seção do arquivo INI"
                        },
                        {
                            "name": "AutoCreateFile",
                            "type": "function",
                            "signature": "function AutoCreateFile(const AValue: Boolean): IParametersInifiles;",
                            "comment": "function AutoCreateFile"
                        },
                        {
                            "name": "AutoCreateFile",
                            "type": "function",
                            "signature": "function AutoCreateFile: Boolean;",
                            "comment": "function AutoCreateFile"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID(const AValue: Integer): IParametersInifiles;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID(const AValue: Integer): IParametersInifiles;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title(const AValue: string): IParametersInifiles;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title: string;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List(out AList: TParameterList): IParametersInifiles;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersInifiles;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter): IParametersInifiles;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter): IParametersInifiles;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Update",
                            "type": "function",
                            "signature": "function Update(const AParameter: TParameter): IParametersInifiles;",
                            "comment": "Atualiza um parâmetro existente no banco de dados"
                        },
                        {
                            "name": "Update",
                            "type": "function",
                            "signature": "function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                            "comment": "Atualiza um parâmetro existente no banco de dados"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string): IParametersInifiles;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersInifiles;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersInifiles;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count(out ACount: Integer): IParametersInifiles;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "FileExists",
                            "type": "function",
                            "signature": "function FileExists: Boolean;",
                            "comment": "Verifica se o arquivo INI existe"
                        },
                        {
                            "name": "FileExists",
                            "type": "function",
                            "signature": "function FileExists(out AExists: Boolean): IParametersInifiles;",
                            "comment": "Verifica se o arquivo INI existe"
                        },
                        {
                            "name": "Refresh",
                            "type": "function",
                            "signature": "function Refresh: IParametersInifiles;",
                            "comment": "Recarrega os parâmetros do banco de dados"
                        },
                        {
                            "name": "ImportFromDatabase",
                            "type": "function",
                            "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles;",
                            "comment": "function ImportFromDatabase"
                        },
                        {
                            "name": "ImportFromDatabase",
                            "type": "function",
                            "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;",
                            "comment": "function ImportFromDatabase"
                        },
                        {
                            "name": "ExportToDatabase",
                            "type": "function",
                            "signature": "function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles;",
                            "comment": "function ExportToDatabase"
                        },
                        {
                            "name": "ExportToDatabase",
                            "type": "function",
                            "signature": "function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;",
                            "comment": "function ExportToDatabase"
                        },
                        {
                            "name": "EndInifiles",
                            "type": "function",
                            "signature": "function EndInifiles: IInterface;",
                            "comment": "function EndInifiles"
                        }
                    ],
                    "privateMethods": [
                        {
                            "name": "EnsureFile",
                            "type": "function",
                            "signature": "function EnsureFile: Boolean;",
                            "comment": "Métodos auxiliares privados"
                        },
                        {
                            "name": "GetSectionName",
                            "type": "function",
                            "signature": "function GetSectionName(const ATitulo: string): string;",
                            "comment": "function GetSectionName"
                        },
                        {
                            "name": "GetTituloFromSection",
                            "type": "function",
                            "signature": "function GetTituloFromSection(const ASection: string): string;",
                            "comment": "function GetTituloFromSection"
                        },
                        {
                            "name": "ParseComment",
                            "type": "function",
                            "signature": "function ParseComment(const ALine: string): string;",
                            "comment": "function ParseComment"
                        },
                        {
                            "name": "ParseKey",
                            "type": "function",
                            "signature": "function ParseKey(const ALine: string): string;",
                            "comment": "function ParseKey"
                        },
                        {
                            "name": "ParseValue",
                            "type": "function",
                            "signature": "function ParseValue(const ALine: string): string;",
                            "comment": "function ParseValue"
                        },
                        {
                            "name": "FormatIniLine",
                            "type": "function",
                            "signature": "function FormatIniLine(const AParameter: TParameter): string;",
                            "comment": "function FormatIniLine"
                        },
                        {
                            "name": "ReadParameterFromIni",
                            "type": "function",
                            "signature": "function ReadParameterFromIni(const ASection, AKey: string): TParameter;",
                            "comment": "function ReadParameterFromIni"
                        },
                        {
                            "name": "WriteParameterToIni",
                            "type": "procedure",
                            "signature": "procedure WriteParameterToIni(const AParameter: TParameter);",
                            "comment": "procedure WriteParameterToIni"
                        },
                        {
                            "name": "GetAllSections",
                            "type": "function",
                            "signature": "function GetAllSections: TStringList;",
                            "comment": "function GetAllSections"
                        },
                        {
                            "name": "ReadIniFileLines",
                            "type": "function",
                            "signature": "function ReadIniFileLines: TStringList;",
                            "comment": "function ReadIniFileLines"
                        },
                        {
                            "name": "WriteIniFileLines",
                            "type": "procedure",
                            "signature": "procedure WriteIniFileLines(ALines: TStringList);",
                            "comment": "procedure WriteIniFileLines"
                        },
                        {
                            "name": "FindSectionInLines",
                            "type": "function",
                            "signature": "function FindSectionInLines(ALines: TStringList; const ASection: string): Integer;",
                            "comment": "function FindSectionInLines"
                        },
                        {
                            "name": "FindKeyInSection",
                            "type": "function",
                            "signature": "function FindKeyInSection(ALines: TStringList; AStartIndex: Integer; const AKey: string): Integer;",
                            "comment": "function FindKeyInSection"
                        },
                        {
                            "name": "RemoveEmptySection",
                            "type": "procedure",
                            "signature": "procedure RemoveEmptySection(ALines: TStringList; ASectionIndex: Integer);",
                            "comment": "procedure RemoveEmptySection"
                        },
                        {
                            "name": "ExistsInSection",
                            "type": "function",
                            "signature": "function ExistsInSection(const AName, ASection: string): Boolean;",
                            "comment": "function ExistsInSection"
                        },
                        {
                            "name": "GetKeysCountInSection",
                            "type": "function",
                            "signature": "function GetKeysCountInSection(ALines: TStringList; ASectionIndex: Integer): Integer;",
                            "comment": "function GetKeysCountInSection"
                        },
                        {
                            "name": "GetInsertPositionByOrder",
                            "type": "function",
                            "signature": "function GetInsertPositionByOrder(ALines: TStringList; ASectionIndex: Integer; AOrder: Integer): Integer;",
                            "comment": "function GetInsertPositionByOrder"
                        },
                        {
                            "name": "WriteContratoSection",
                            "type": "procedure",
                            "signature": "procedure WriteContratoSection(AContratoID, AProdutoID: Integer);",
                            "comment": "procedure WriteContratoSection"
                        },
                        {
                            "name": "ReadContratoSection",
                            "type": "procedure",
                            "signature": "procedure ReadContratoSection(out AContratoID, AProdutoID: Integer);",
                            "comment": "procedure ReadContratoSection"
                        }
                    ]
                }
            ],
            "functions": [
                {
                    "name": "GetSectionName",
                    "type": "function",
                    "signature": "function GetSectionName(const ATitulo: string): string;",
                    "description": "function GetSectionName",
                    "comment": "function GetSectionName"
                },
                {
                    "name": "GetTituloFromSection",
                    "type": "function",
                    "signature": "function GetTituloFromSection(const ASection: string): string;",
                    "description": "function GetTituloFromSection",
                    "comment": "function GetTituloFromSection"
                },
                {
                    "name": "ParseComment",
                    "type": "function",
                    "signature": "function ParseComment(const ALine: string): string;",
                    "description": "function ParseComment",
                    "comment": "function ParseComment"
                },
                {
                    "name": "ParseKey",
                    "type": "function",
                    "signature": "function ParseKey(const ALine: string): string;",
                    "description": "function ParseKey",
                    "comment": "function ParseKey"
                },
                {
                    "name": "ParseValue",
                    "type": "function",
                    "signature": "function ParseValue(const ALine: string): string;",
                    "description": "function ParseValue",
                    "comment": "function ParseValue"
                },
                {
                    "name": "FormatIniLine",
                    "type": "function",
                    "signature": "function FormatIniLine(const AParameter: TParameter): string;",
                    "description": "function FormatIniLine",
                    "comment": "function FormatIniLine"
                },
                {
                    "name": "ReadParameterFromIni",
                    "type": "function",
                    "signature": "function ReadParameterFromIni(const ASection, AKey: string): TParameter;",
                    "description": "function ReadParameterFromIni",
                    "comment": "function ReadParameterFromIni"
                },
                {
                    "name": "WriteParameterToIni",
                    "type": "procedure",
                    "signature": "procedure WriteParameterToIni(const AParameter: TParameter);",
                    "description": "procedure WriteParameterToIni",
                    "comment": "procedure WriteParameterToIni"
                },
                {
                    "name": "WriteIniFileLines",
                    "type": "procedure",
                    "signature": "procedure WriteIniFileLines(ALines: TStringList);",
                    "description": "procedure WriteIniFileLines",
                    "comment": "procedure WriteIniFileLines"
                },
                {
                    "name": "FindSectionInLines",
                    "type": "function",
                    "signature": "function FindSectionInLines(ALines: TStringList; const ASection: string): Integer;",
                    "description": "function FindSectionInLines",
                    "comment": "function FindSectionInLines"
                },
                {
                    "name": "FindKeyInSection",
                    "type": "function",
                    "signature": "function FindKeyInSection(ALines: TStringList; AStartIndex: Integer; const AKey: string): Integer;",
                    "description": "function FindKeyInSection",
                    "comment": "function FindKeyInSection"
                },
                {
                    "name": "RemoveEmptySection",
                    "type": "procedure",
                    "signature": "procedure RemoveEmptySection(ALines: TStringList; ASectionIndex: Integer);",
                    "description": "procedure RemoveEmptySection",
                    "comment": "procedure RemoveEmptySection"
                },
                {
                    "name": "ExistsInSection",
                    "type": "function",
                    "signature": "function ExistsInSection(const AName, ASection: string): Boolean;",
                    "description": "function ExistsInSection",
                    "comment": "function ExistsInSection"
                },
                {
                    "name": "GetKeysCountInSection",
                    "type": "function",
                    "signature": "function GetKeysCountInSection(ALines: TStringList; ASectionIndex: Integer): Integer;",
                    "description": "function GetKeysCountInSection",
                    "comment": "function GetKeysCountInSection"
                },
                {
                    "name": "GetInsertPositionByOrder",
                    "type": "function",
                    "signature": "function GetInsertPositionByOrder(ALines: TStringList; ASectionIndex: Integer; AOrder: Integer): Integer;",
                    "description": "function GetInsertPositionByOrder",
                    "comment": "function GetInsertPositionByOrder"
                },
                {
                    "name": "WriteContratoSection",
                    "type": "procedure",
                    "signature": "procedure WriteContratoSection(AContratoID, AProdutoID: Integer);",
                    "description": "procedure WriteContratoSection",
                    "comment": "procedure WriteContratoSection"
                },
                {
                    "name": "ReadContratoSection",
                    "type": "procedure",
                    "signature": "procedure ReadContratoSection(out AContratoID, AProdutoID: Integer);",
                    "description": "procedure ReadContratoSection",
                    "comment": "procedure ReadContratoSection"
                },
                {
                    "name": "FilePath",
                    "type": "function",
                    "signature": "function FilePath(const AValue: string): IParametersInifiles;",
                    "description": "function FilePath",
                    "comment": "Define ou obtém o caminho do arquivo INI"
                },
                {
                    "name": "Section",
                    "type": "function",
                    "signature": "function Section(const AValue: string): IParametersInifiles;",
                    "description": "function Section",
                    "comment": "Define ou obtém a seção do arquivo INI"
                },
                {
                    "name": "AutoCreateFile",
                    "type": "function",
                    "signature": "function AutoCreateFile(const AValue: Boolean): IParametersInifiles;",
                    "description": "function AutoCreateFile",
                    "comment": "function AutoCreateFile"
                },
                {
                    "name": "ContratoID",
                    "type": "function",
                    "signature": "function ContratoID(const AValue: Integer): IParametersInifiles;",
                    "description": "function ContratoID",
                    "comment": "Define ou obtém o ID do contrato para filtro"
                },
                {
                    "name": "ProdutoID",
                    "type": "function",
                    "signature": "function ProdutoID(const AValue: Integer): IParametersInifiles;",
                    "description": "function ProdutoID",
                    "comment": "Define ou obtém o ID do produto para filtro"
                },
                {
                    "name": "Title",
                    "type": "function",
                    "signature": "function Title(const AValue: string): IParametersInifiles;",
                    "description": "function Title",
                    "comment": "Define ou obtém o título/seção dos parâmetros"
                },
                {
                    "name": "List",
                    "type": "function",
                    "signature": "function List(out AList: TParameterList): IParametersInifiles;",
                    "description": "function List",
                    "comment": "Lista todos os parâmetros ativos do banco de dados"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string): TParameter;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersInifiles;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter): IParametersInifiles;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter): IParametersInifiles;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Update",
                    "type": "function",
                    "signature": "function Update(const AParameter: TParameter): IParametersInifiles;",
                    "description": "function Update",
                    "comment": "Atualiza um parâmetro existente no banco de dados"
                },
                {
                    "name": "Update",
                    "type": "function",
                    "signature": "function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Update",
                    "comment": "Atualiza um parâmetro existente no banco de dados"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string): IParametersInifiles;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string): Boolean;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersInifiles;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Count",
                    "type": "function",
                    "signature": "function Count(out ACount: Integer): IParametersInifiles;",
                    "description": "function Count",
                    "comment": "Retorna o número de parâmetros ativos"
                },
                {
                    "name": "FileExists",
                    "type": "function",
                    "signature": "function FileExists(out AExists: Boolean): IParametersInifiles;",
                    "description": "function FileExists",
                    "comment": "Verifica se o arquivo INI existe"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                }
            ]
        },
        {
            "id": "jsonobject_parameters.jsonobject",
            "name": "Parameters.JsonObject.pas",
            "path": "src\\Paramenters\\JsonObject\\Parameters.JsonObject.pas",
            "description": "<p>Parameters.JsonObject - Implementação de Acesso a Parâmetros em Objetos JSON</p>\n<p><strong>Descrição:</strong> </p>\n<p>Implementa IParametersJsonObject para acesso a parâmetros em objetos JSON.</p>\n<p>Suporta importação/exportação bidirecional com Database.</p>\n<p>Formato JSON:</p>\n<p>- Título = Nome do objeto JSON (seção)</p>\n<p>- Chave e valor = propriedades dentro do objeto</p>\n<p>- Contrato e produto = objeto separado \"Contrato\"</p>\n<p>- Ordem = sequência de colocação (mantida pela ordem das chaves)</p>\n<p>Estrutura JSON:</p>\n<p>- Objeto \"Contrato\" contém Contrato_ID e Produto_ID</p>\n<p>- Cada título (ex: \"ERP\") é um objeto JSON</p>\n<p>- Cada chave dentro do título é um objeto com: valor, descricao, ativo, ordem</p>\n<p>Encoding:</p>\n<p>- Leitura: Suporta UTF-8 (com/sem BOM) e ANSI (fallback)</p>\n<p>- Escrita: Sempre UTF-8 sem BOM</p>\n<p>- Simplificado para facilitar manutenção e compatibilidade</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 02/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.JsonObject - Implementação JSON Objects</h3>\n    <p><strong>Finalidade:</strong> Implementação completa de IParametersJsonObject para objetos JSON</p>\n    <p><strong>⚠️ NÃO USE DIRETAMENTE!</strong> Use sempre TParameters.NewJsonObject</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">✅ USO CORRETO (Factory Method)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters;  // ✅ CORRETO - Use apenas Parameters.pas\n\nvar\n  Json: IParametersJsonObject;\nbegin\n  // ✅ Criar via Factory Method\n  Json := TParameters.NewJsonObject;\n  \n  Json.FilePath('C:\\Config\\params.json')\n      .ObjectName('ERP')\n      .AutoCreateFile(True)\n      .ContratoID(1)\n      .ProdutoID(1);\n      \n  // Usar normalmente...\nend;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">❌ USO INCORRETO (Direto)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.JsonObject;  // ❌ ERRADO - NÃO use units internas!\n\nvar\n  Json: TParametersJsonObject;  // ❌ Classe interna\nbegin\n  // ❌ NÃO faça isso!\n  Json := TParametersJsonObject.Create;\n  // ...\nend;</code></pre>\n\n<div style=\"background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;\">\n    <strong>🚫 AVISO:</strong> Esta unit é INTERNA. Suas classes e métodos podem mudar sem aviso. Use SEMPRE os Factory Methods de TParameters!\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📚 Documentação Completa</h4>\n<p>Para documentação completa de métodos, veja <strong>Roteiro de Uso → Externo → IParametersJsonObject</strong></p>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "TParametersJsonObject",
                    "description": "<p>TParametersJsonObject - Implementação de IParametersJsonObject</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create;",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(AJsonObject: TJSONObject);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "CreateFromString",
                            "type": "constructor",
                            "signature": "constructor CreateFromString(const AJsonString: string);",
                            "comment": "constructor CreateFromString"
                        },
                        {
                            "name": "CreateFromFile",
                            "type": "constructor",
                            "signature": "constructor CreateFromFile(const AFilePath: string);",
                            "comment": "constructor CreateFromFile"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "destructor Destroy"
                        },
                        {
                            "name": "JsonObject",
                            "type": "function",
                            "signature": "function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject;",
                            "comment": "Retorna a interface IParametersJsonObject"
                        },
                        {
                            "name": "JsonObject",
                            "type": "function",
                            "signature": "function JsonObject: TJSONObject;",
                            "comment": "Retorna a interface IParametersJsonObject"
                        },
                        {
                            "name": "ObjectName",
                            "type": "function",
                            "signature": "function ObjectName(const AValue: string): IParametersJsonObject;",
                            "comment": "Define ou obtém o nome do objeto JSON"
                        },
                        {
                            "name": "ObjectName",
                            "type": "function",
                            "signature": "function ObjectName: string;",
                            "comment": "Define ou obtém o nome do objeto JSON"
                        },
                        {
                            "name": "FilePath",
                            "type": "function",
                            "signature": "function FilePath(const AValue: string): IParametersJsonObject;",
                            "comment": "Define ou obtém o caminho do arquivo INI"
                        },
                        {
                            "name": "FilePath",
                            "type": "function",
                            "signature": "function FilePath: string;",
                            "comment": "Define ou obtém o caminho do arquivo INI"
                        },
                        {
                            "name": "AutoCreateFile",
                            "type": "function",
                            "signature": "function AutoCreateFile(const AValue: Boolean): IParametersJsonObject;",
                            "comment": "function AutoCreateFile"
                        },
                        {
                            "name": "AutoCreateFile",
                            "type": "function",
                            "signature": "function AutoCreateFile: Boolean;",
                            "comment": "function AutoCreateFile"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID(const AValue: Integer): IParametersJsonObject;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ContratoID",
                            "type": "function",
                            "signature": "function ContratoID: Integer;",
                            "comment": "Define ou obtém o ID do contrato para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID(const AValue: Integer): IParametersJsonObject;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "function",
                            "signature": "function ProdutoID: Integer;",
                            "comment": "Define ou obtém o ID do produto para filtro"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title(const AValue: string): IParametersJsonObject;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "Title",
                            "type": "function",
                            "signature": "function Title: string;",
                            "comment": "Define ou obtém o título/seção dos parâmetros"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List: TParameterList;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "List",
                            "type": "function",
                            "signature": "function List(out AList: TParameterList): IParametersJsonObject;",
                            "comment": "Lista todos os parâmetros ativos do banco de dados"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string): TParameter;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Getter",
                            "type": "function",
                            "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersJsonObject;",
                            "comment": "function Getter"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter): IParametersJsonObject;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Insert",
                            "type": "function",
                            "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "Insere um novo parâmetro no banco de dados"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter): IParametersJsonObject;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Setter",
                            "type": "function",
                            "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "function Setter"
                        },
                        {
                            "name": "Update",
                            "type": "function",
                            "signature": "function Update(const AParameter: TParameter): IParametersJsonObject;",
                            "comment": "Atualiza um parâmetro existente no banco de dados"
                        },
                        {
                            "name": "Update",
                            "type": "function",
                            "signature": "function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "Atualiza um parâmetro existente no banco de dados"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string): IParametersJsonObject;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Delete",
                            "type": "function",
                            "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "Remove um parâmetro do banco de dados (soft delete)"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string): Boolean;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Exists",
                            "type": "function",
                            "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersJsonObject;",
                            "comment": "Verifica se um parâmetro existe no banco de dados"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count: Integer;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "Count",
                            "type": "function",
                            "signature": "function Count(out ACount: Integer): IParametersJsonObject;",
                            "comment": "Retorna o número de parâmetros ativos"
                        },
                        {
                            "name": "FileExists",
                            "type": "function",
                            "signature": "function FileExists: Boolean;",
                            "comment": "Verifica se o arquivo INI existe"
                        },
                        {
                            "name": "FileExists",
                            "type": "function",
                            "signature": "function FileExists(out AExists: Boolean): IParametersJsonObject;",
                            "comment": "Verifica se o arquivo INI existe"
                        },
                        {
                            "name": "Refresh",
                            "type": "function",
                            "signature": "function Refresh: IParametersJsonObject;",
                            "comment": "Recarrega os parâmetros do banco de dados"
                        },
                        {
                            "name": "ToJSON",
                            "type": "function",
                            "signature": "function ToJSON: TJSONObject;",
                            "comment": "Retorna o objeto JSON completo como string"
                        },
                        {
                            "name": "ToJSONString",
                            "type": "function",
                            "signature": "function ToJSONString: string;",
                            "comment": "Retorna o objeto JSON formatado como string"
                        },
                        {
                            "name": "SaveToFile",
                            "type": "function",
                            "signature": "function SaveToFile(const AFilePath: string = ''): IParametersJsonObject;",
                            "comment": "Salva o objeto JSON em arquivo"
                        },
                        {
                            "name": "SaveToFile",
                            "type": "function",
                            "signature": "function SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "Salva o objeto JSON em arquivo"
                        },
                        {
                            "name": "LoadFromString",
                            "type": "function",
                            "signature": "function LoadFromString(const AJsonString: string): IParametersJsonObject;",
                            "comment": "Carrega o objeto JSON de string"
                        },
                        {
                            "name": "LoadFromFile",
                            "type": "function",
                            "signature": "function LoadFromFile(const AFilePath: string = ''): IParametersJsonObject;",
                            "comment": "Carrega o objeto JSON de arquivo"
                        },
                        {
                            "name": "LoadFromFile",
                            "type": "function",
                            "signature": "function LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "Carrega o objeto JSON de arquivo"
                        },
                        {
                            "name": "ImportFromDatabase",
                            "type": "function",
                            "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;",
                            "comment": "function ImportFromDatabase"
                        },
                        {
                            "name": "ImportFromDatabase",
                            "type": "function",
                            "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "function ImportFromDatabase"
                        },
                        {
                            "name": "ExportToDatabase",
                            "type": "function",
                            "signature": "function ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;",
                            "comment": "function ExportToDatabase"
                        },
                        {
                            "name": "ExportToDatabase",
                            "type": "function",
                            "signature": "function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "function ExportToDatabase"
                        },
                        {
                            "name": "ImportFromInifiles",
                            "type": "function",
                            "signature": "function ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;",
                            "comment": "function ImportFromInifiles"
                        },
                        {
                            "name": "ImportFromInifiles",
                            "type": "function",
                            "signature": "function ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "function ImportFromInifiles"
                        },
                        {
                            "name": "ExportToInifiles",
                            "type": "function",
                            "signature": "function ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;",
                            "comment": "function ExportToInifiles"
                        },
                        {
                            "name": "ExportToInifiles",
                            "type": "function",
                            "signature": "function ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;",
                            "comment": "function ExportToInifiles"
                        },
                        {
                            "name": "EndJsonObject",
                            "type": "function",
                            "signature": "function EndJsonObject: IInterface;",
                            "comment": "function EndJsonObject"
                        }
                    ],
                    "privateMethods": [
                        {
                            "name": "EnsureJsonObject",
                            "type": "function",
                            "signature": "function EnsureJsonObject: Boolean;",
                            "comment": "Métodos auxiliares privados"
                        },
                        {
                            "name": "EnsureFile",
                            "type": "function",
                            "signature": "function EnsureFile: Boolean;",
                            "comment": "function EnsureFile"
                        },
                        {
                            "name": "GetObjectName",
                            "type": "function",
                            "signature": "function GetObjectName(const ATitulo: string): string;",
                            "comment": "function GetObjectName"
                        },
                        {
                            "name": "GetTituloFromObjectName",
                            "type": "function",
                            "signature": "function GetTituloFromObjectName(const AObjectName: string): string;",
                            "comment": "function GetTituloFromObjectName"
                        },
                        {
                            "name": "ExistsInObject",
                            "type": "function",
                            "signature": "function ExistsInObject(const AName, AObjectName: string): Boolean;",
                            "comment": "function ExistsInObject"
                        },
                        {
                            "name": "ReadParameterFromJson",
                            "type": "function",
                            "signature": "function ReadParameterFromJson(const AObjectName, AKey: string): TParameter;",
                            "comment": "function ReadParameterFromJson"
                        },
                        {
                            "name": "WriteParameterToJson",
                            "type": "procedure",
                            "signature": "procedure WriteParameterToJson(const AParameter: TParameter);",
                            "comment": "procedure WriteParameterToJson"
                        },
                        {
                            "name": "GetAllObjectNames",
                            "type": "function",
                            "signature": "function GetAllObjectNames: TStringList;",
                            "comment": "function GetAllObjectNames"
                        },
                        {
                            "name": "GetKeysInObject",
                            "type": "function",
                            "signature": "function GetKeysInObject(AJsonObj: TJSONObject): TStringList;",
                            "comment": "function GetKeysInObject"
                        },
                        {
                            "name": "GetKeysCountInObject",
                            "type": "function",
                            "signature": "function GetKeysCountInObject(AJsonObj: TJSONObject): Integer;",
                            "comment": "function GetKeysCountInObject"
                        },
                        {
                            "name": "GetNextOrder",
                            "type": "function",
                            "signature": "function GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer;",
                            "comment": "function GetNextOrder"
                        },
                        {
                            "name": "AdjustOrdersForInsert",
                            "type": "procedure",
                            "signature": "procedure AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer);",
                            "comment": "procedure AdjustOrdersForInsert"
                        },
                        {
                            "name": "AdjustOrdersForUpdate",
                            "type": "procedure",
                            "signature": "procedure AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID: Integer; const AChave: string; AOldOrder, ANewOrder: Integer);",
                            "comment": "procedure AdjustOrdersForUpdate"
                        },
                        {
                            "name": "WriteContratoObject",
                            "type": "procedure",
                            "signature": "procedure WriteContratoObject(AContratoID, AProdutoID: Integer);",
                            "comment": "procedure WriteContratoObject"
                        },
                        {
                            "name": "ReadContratoObject",
                            "type": "procedure",
                            "signature": "procedure ReadContratoObject(out AContratoID, AProdutoID: Integer);",
                            "comment": "procedure ReadContratoObject"
                        },
                        {
                            "name": "ParameterToJsonValue",
                            "type": "function",
                            "signature": "function ParameterToJsonValue(const AParameter: TParameter): TJSONObject;",
                            "comment": "function ParameterToJsonValue"
                        },
                        {
                            "name": "JsonValueToParameter",
                            "type": "function",
                            "signature": "function JsonValueToParameter(AJsonValue: TJSONObject; const ATitulo, AKey: string): TParameter;",
                            "comment": "function JsonValueToParameter"
                        },
                        {
                            "name": "FormatJSONString",
                            "type": "function",
                            "signature": "function FormatJSONString(const AJsonString: string; AIndent: Integer = 2): string;",
                            "comment": "function FormatJSONString"
                        },
                        {
                            "name": "GetValueCaseInsensitive",
                            "type": "function",
                            "signature": "function GetValueCaseInsensitive(AJsonObj: TJSONObject; const AKey: string): TJSONValue;",
                            "comment": "function GetValueCaseInsensitive"
                        },
                        {
                            "name": "GetJsonValue",
                            "type": "function",
                            "signature": "function GetJsonValue(AJsonObj: TJSONObject; const AKey: string): TJSONValue;",
                            "comment": "function GetJsonValue"
                        },
                        {
                            "name": "AddJsonPair",
                            "type": "procedure",
                            "signature": "procedure AddJsonPair(AJsonObj: TJSONObject; const AKey: string; AValue: TJSONValue);",
                            "comment": "procedure AddJsonPair"
                        },
                        {
                            "name": "AddJsonPair",
                            "type": "procedure",
                            "signature": "procedure AddJsonPair(AJsonObj: TJSONObject; const AKey: string; const AValue: string);",
                            "comment": "procedure AddJsonPair"
                        },
                        {
                            "name": "RemoveJsonPair",
                            "type": "procedure",
                            "signature": "procedure RemoveJsonPair(AJsonObj: TJSONObject; const AKey: string);",
                            "comment": "procedure RemoveJsonPair"
                        }
                    ]
                }
            ],
            "functions": [
                {
                    "name": "GetObjectName",
                    "type": "function",
                    "signature": "function GetObjectName(const ATitulo: string): string;",
                    "description": "function GetObjectName",
                    "comment": "function GetObjectName"
                },
                {
                    "name": "GetTituloFromObjectName",
                    "type": "function",
                    "signature": "function GetTituloFromObjectName(const AObjectName: string): string;",
                    "description": "function GetTituloFromObjectName",
                    "comment": "function GetTituloFromObjectName"
                },
                {
                    "name": "ExistsInObject",
                    "type": "function",
                    "signature": "function ExistsInObject(const AName, AObjectName: string): Boolean;",
                    "description": "function ExistsInObject",
                    "comment": "function ExistsInObject"
                },
                {
                    "name": "ReadParameterFromJson",
                    "type": "function",
                    "signature": "function ReadParameterFromJson(const AObjectName, AKey: string): TParameter;",
                    "description": "function ReadParameterFromJson",
                    "comment": "function ReadParameterFromJson"
                },
                {
                    "name": "WriteParameterToJson",
                    "type": "procedure",
                    "signature": "procedure WriteParameterToJson(const AParameter: TParameter);",
                    "description": "procedure WriteParameterToJson",
                    "comment": "procedure WriteParameterToJson"
                },
                {
                    "name": "GetKeysInObject",
                    "type": "function",
                    "signature": "function GetKeysInObject(AJsonObj: TJSONObject): TStringList;",
                    "description": "function GetKeysInObject",
                    "comment": "function GetKeysInObject"
                },
                {
                    "name": "GetKeysCountInObject",
                    "type": "function",
                    "signature": "function GetKeysCountInObject(AJsonObj: TJSONObject): Integer;",
                    "description": "function GetKeysCountInObject",
                    "comment": "function GetKeysCountInObject"
                },
                {
                    "name": "GetNextOrder",
                    "type": "function",
                    "signature": "function GetNextOrder(const ATitulo: string; AContratoID, AProdutoID: Integer): Integer;",
                    "description": "function GetNextOrder",
                    "comment": "function GetNextOrder"
                },
                {
                    "name": "AdjustOrdersForInsert",
                    "type": "procedure",
                    "signature": "procedure AdjustOrdersForInsert(const ATitulo: string; AContratoID, AProdutoID, AOrder: Integer);",
                    "description": "procedure AdjustOrdersForInsert",
                    "comment": "procedure AdjustOrdersForInsert"
                },
                {
                    "name": "AdjustOrdersForUpdate",
                    "type": "procedure",
                    "signature": "procedure AdjustOrdersForUpdate(const ATitulo: string; AContratoID, AProdutoID: Integer; const AChave: string; AOldOrder, ANewOrder: Integer);",
                    "description": "procedure AdjustOrdersForUpdate",
                    "comment": "procedure AdjustOrdersForUpdate"
                },
                {
                    "name": "WriteContratoObject",
                    "type": "procedure",
                    "signature": "procedure WriteContratoObject(AContratoID, AProdutoID: Integer);",
                    "description": "procedure WriteContratoObject",
                    "comment": "procedure WriteContratoObject"
                },
                {
                    "name": "ReadContratoObject",
                    "type": "procedure",
                    "signature": "procedure ReadContratoObject(out AContratoID, AProdutoID: Integer);",
                    "description": "procedure ReadContratoObject",
                    "comment": "procedure ReadContratoObject"
                },
                {
                    "name": "ParameterToJsonValue",
                    "type": "function",
                    "signature": "function ParameterToJsonValue(const AParameter: TParameter): TJSONObject;",
                    "description": "function ParameterToJsonValue",
                    "comment": "function ParameterToJsonValue"
                },
                {
                    "name": "JsonValueToParameter",
                    "type": "function",
                    "signature": "function JsonValueToParameter(AJsonValue: TJSONObject; const ATitulo, AKey: string): TParameter;",
                    "description": "function JsonValueToParameter",
                    "comment": "function JsonValueToParameter"
                },
                {
                    "name": "FormatJSONString",
                    "type": "function",
                    "signature": "function FormatJSONString(const AJsonString: string; AIndent: Integer = 2): string;",
                    "description": "function FormatJSONString",
                    "comment": "function FormatJSONString"
                },
                {
                    "name": "GetValueCaseInsensitive",
                    "type": "function",
                    "signature": "function GetValueCaseInsensitive(AJsonObj: TJSONObject; const AKey: string): TJSONValue;",
                    "description": "function GetValueCaseInsensitive",
                    "comment": "function GetValueCaseInsensitive"
                },
                {
                    "name": "GetJsonValue",
                    "type": "function",
                    "signature": "function GetJsonValue(AJsonObj: TJSONObject; const AKey: string): TJSONValue;",
                    "description": "function GetJsonValue",
                    "comment": "function GetJsonValue"
                },
                {
                    "name": "AddJsonPair",
                    "type": "procedure",
                    "signature": "procedure AddJsonPair(AJsonObj: TJSONObject; const AKey: string; AValue: TJSONValue);",
                    "description": "procedure AddJsonPair",
                    "comment": "procedure AddJsonPair"
                },
                {
                    "name": "AddJsonPair",
                    "type": "procedure",
                    "signature": "procedure AddJsonPair(AJsonObj: TJSONObject; const AKey: string; const AValue: string);",
                    "description": "procedure AddJsonPair",
                    "comment": "procedure AddJsonPair"
                },
                {
                    "name": "RemoveJsonPair",
                    "type": "procedure",
                    "signature": "procedure RemoveJsonPair(AJsonObj: TJSONObject; const AKey: string);",
                    "description": "procedure RemoveJsonPair",
                    "comment": "procedure RemoveJsonPair"
                },
                {
                    "name": "JsonObject",
                    "type": "function",
                    "signature": "function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject;",
                    "description": "function JsonObject",
                    "comment": "Retorna a interface IParametersJsonObject"
                },
                {
                    "name": "ObjectName",
                    "type": "function",
                    "signature": "function ObjectName(const AValue: string): IParametersJsonObject;",
                    "description": "function ObjectName",
                    "comment": "Define ou obtém o nome do objeto JSON"
                },
                {
                    "name": "FilePath",
                    "type": "function",
                    "signature": "function FilePath(const AValue: string): IParametersJsonObject;",
                    "description": "function FilePath",
                    "comment": "Define ou obtém o caminho do arquivo INI"
                },
                {
                    "name": "AutoCreateFile",
                    "type": "function",
                    "signature": "function AutoCreateFile(const AValue: Boolean): IParametersJsonObject;",
                    "description": "function AutoCreateFile",
                    "comment": "function AutoCreateFile"
                },
                {
                    "name": "ContratoID",
                    "type": "function",
                    "signature": "function ContratoID(const AValue: Integer): IParametersJsonObject;",
                    "description": "function ContratoID",
                    "comment": "Define ou obtém o ID do contrato para filtro"
                },
                {
                    "name": "ProdutoID",
                    "type": "function",
                    "signature": "function ProdutoID(const AValue: Integer): IParametersJsonObject;",
                    "description": "function ProdutoID",
                    "comment": "Define ou obtém o ID do produto para filtro"
                },
                {
                    "name": "Title",
                    "type": "function",
                    "signature": "function Title(const AValue: string): IParametersJsonObject;",
                    "description": "function Title",
                    "comment": "Define ou obtém o título/seção dos parâmetros"
                },
                {
                    "name": "List",
                    "type": "function",
                    "signature": "function List(out AList: TParameterList): IParametersJsonObject;",
                    "description": "function List",
                    "comment": "Lista todos os parâmetros ativos do banco de dados"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string): TParameter;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Getter",
                    "type": "function",
                    "signature": "function Getter(const AName: string; out AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Getter",
                    "comment": "function Getter"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Insert",
                    "type": "function",
                    "signature": "function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Insert",
                    "comment": "Insere um novo parâmetro no banco de dados"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Setter",
                    "type": "function",
                    "signature": "function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Setter",
                    "comment": "function Setter"
                },
                {
                    "name": "Update",
                    "type": "function",
                    "signature": "function Update(const AParameter: TParameter): IParametersJsonObject;",
                    "description": "function Update",
                    "comment": "Atualiza um parâmetro existente no banco de dados"
                },
                {
                    "name": "Update",
                    "type": "function",
                    "signature": "function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Update",
                    "comment": "Atualiza um parâmetro existente no banco de dados"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string): IParametersJsonObject;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Delete",
                    "type": "function",
                    "signature": "function Delete(const AName: string; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function Delete",
                    "comment": "Remove um parâmetro do banco de dados (soft delete)"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string): Boolean;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Exists",
                    "type": "function",
                    "signature": "function Exists(const AName: string; out AExists: Boolean): IParametersJsonObject;",
                    "description": "function Exists",
                    "comment": "Verifica se um parâmetro existe no banco de dados"
                },
                {
                    "name": "Count",
                    "type": "function",
                    "signature": "function Count(out ACount: Integer): IParametersJsonObject;",
                    "description": "function Count",
                    "comment": "Retorna o número de parâmetros ativos"
                },
                {
                    "name": "FileExists",
                    "type": "function",
                    "signature": "function FileExists(out AExists: Boolean): IParametersJsonObject;",
                    "description": "function FileExists",
                    "comment": "Verifica se o arquivo INI existe"
                },
                {
                    "name": "SaveToFile",
                    "type": "function",
                    "signature": "function SaveToFile(const AFilePath: string = ''): IParametersJsonObject;",
                    "description": "function SaveToFile",
                    "comment": "Salva o objeto JSON em arquivo"
                },
                {
                    "name": "SaveToFile",
                    "type": "function",
                    "signature": "function SaveToFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function SaveToFile",
                    "comment": "Salva o objeto JSON em arquivo"
                },
                {
                    "name": "LoadFromString",
                    "type": "function",
                    "signature": "function LoadFromString(const AJsonString: string): IParametersJsonObject;",
                    "description": "function LoadFromString",
                    "comment": "Carrega o objeto JSON de string"
                },
                {
                    "name": "LoadFromFile",
                    "type": "function",
                    "signature": "function LoadFromFile(const AFilePath: string = ''): IParametersJsonObject;",
                    "description": "function LoadFromFile",
                    "comment": "Carrega o objeto JSON de arquivo"
                },
                {
                    "name": "LoadFromFile",
                    "type": "function",
                    "signature": "function LoadFromFile(const AFilePath: string; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function LoadFromFile",
                    "comment": "Carrega o objeto JSON de arquivo"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ImportFromDatabase",
                    "type": "function",
                    "signature": "function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ImportFromDatabase",
                    "comment": "function ImportFromDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase): IParametersJsonObject;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "ExportToDatabase",
                    "type": "function",
                    "signature": "function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ExportToDatabase",
                    "comment": "function ExportToDatabase"
                },
                {
                    "name": "ImportFromInifiles",
                    "type": "function",
                    "signature": "function ImportFromInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;",
                    "description": "function ImportFromInifiles",
                    "comment": "function ImportFromInifiles"
                },
                {
                    "name": "ImportFromInifiles",
                    "type": "function",
                    "signature": "function ImportFromInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ImportFromInifiles",
                    "comment": "function ImportFromInifiles"
                },
                {
                    "name": "ExportToInifiles",
                    "type": "function",
                    "signature": "function ExportToInifiles(AInifiles: IParametersInifiles): IParametersJsonObject;",
                    "description": "function ExportToInifiles",
                    "comment": "function ExportToInifiles"
                },
                {
                    "name": "ExportToInifiles",
                    "type": "function",
                    "signature": "function ExportToInifiles(AInifiles: IParametersInifiles; out ASuccess: Boolean): IParametersJsonObject;",
                    "description": "function ExportToInifiles",
                    "comment": "function ExportToInifiles"
                }
            ]
        },
        {
            "id": "attributes_parameters.attributes",
            "name": "Parameters.Attributes.pas",
            "path": "src\\Paramenters\\Attributes\\Parameters.Attributes.pas",
            "description": "<p>Parameters.Attributes - Implementação do Sistema de Attributes</p>\n<p><strong>Descrição:</strong> </p>\n<p>Implementa IAttributeParser e IAttributeMapper para parsing e mapeamento</p>\n<p>de classes Pascal com atributos para estruturas TParameter e TParameterList.</p>\n<p>Hierarquia:</p>\n<p>Attributes (Runtime) → IAttributeParser → IAttributeMapper → IParameters</p>\n<p>Funcionalidades:</p>\n<p>- Parsing de classes com atributos via RTTI</p>\n<p>- Conversão Classe → TParameter/TParameterList</p>\n<p>- Mapeamento bidirecional Classe ↔ TParameter</p>\n<p>- Validação de atributos</p>\n<p>Compatibilidade:</p>\n<p>- Delphi XE7+: Suporte completo</p>\n<p>- FPC 3.2.2+: Suporte com limitações conhecidas</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 03/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Attributes - Sistema de Attributes</h3>\n    <p><strong>Finalidade:</strong> Define todos os attributes para decorar classes de parâmetros com metadados</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 1: Attribute de Tabela</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Attributes;\n\ntype\n  [Table('config', 'public')]\n  TConfigParameter = class(TObject)\n  private\n    [PrimaryKey]\n    [AutoIncrement]\n    FID: Integer;\n    \n    [Column('name')]\n    [Required]\n    FName: string;\n    \n    [Column('value')]\n    FValue: string;\n    \n  public\n    property ID: Integer read FID write FID;\n    property Name: string read FName write FName;\n    property Value: string read FValue write FValue;\n  end;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo 2: Attributes de Validação</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Attributes;\n\ntype\n  TUserParameter = class(TObject)\n  private\n    [Column('email')]\n    [Required]\n    [Email]\n    FEmail: string;\n    \n    [Column('age')]\n    [Range(18, 120)]\n    FAge: Integer;\n    \n    [Column('username')]\n    [Required]\n    [MaxLength(50)]\n    FUsername: string;\n    \n  public\n    property Email: string read FEmail write FEmail;\n    property Age: Integer read FAge write FAge;\n    property Username: string read FUsername write FUsername;\n  end;</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📊 Attributes Disponíveis</h4>\n<table style=\"width: 100%; border-collapse: collapse; margin: 20px 0;\">\n    <thead>\n        <tr style=\"background: #3498db; color: white;\">\n            <th style=\"padding: 12px; border: 1px solid #ddd;\">Categoria</th>\n            <th style=\"padding: 12px; border: 1px solid #ddd;\">Attribute</th>\n            <th style=\"padding: 12px; border: 1px solid #ddd;\">Descrição</th>\n        </tr>\n    </thead>\n    <tbody>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Tabela</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[Table]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Nome da tabela e schema</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Coluna</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[Column]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Nome da coluna</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Chave</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[PrimaryKey]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Chave primária</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Auto</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[AutoIncrement]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Auto-incremento</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Validação</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[Required]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Campo obrigatório</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Validação</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[MaxLength]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Tamanho máximo</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Validação</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[Range]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Faixa de valores</td></tr>\n        <tr><td style=\"padding: 12px; border: 1px solid #ddd;\">Validação</td><td style=\"padding: 12px; border: 1px solid #ddd;\">[Email]</td><td style=\"padding: 12px; border: 1px solid #ddd;\">Email válido</td></tr>\n    </tbody>\n</table>\n\n<div style=\"background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;\">\n    <strong>💡 FUTURO:</strong> Sistema de attributes será usado para mapeamento automático no Parameters ORM v2.0+\n</div>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "TAttributeParser",
                    "description": "<p>TAttributeParser - Implementação de IAttributeParser</p>\n<p>Implementa parsing de classes Pascal com atributos para estruturas TParameter/TParameterList.</p>\n<p>Usa RTTI para ler atributos em runtime e converter para estrutura do Parameters ORM.</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create;",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "Destrói instância e libera contexto RTTI"
                        },
                        {
                            "name": "New",
                            "type": "function",
                            "signature": "function New: IAttributeParser;",
                            "comment": "Cria uma nova instância de IParameters com configuração padrão ou customizada"
                        },
                        {
                            "name": "ParseClass",
                            "type": "function",
                            "signature": "function ParseClass(const AClassType: TClass): TParameterList;",
                            "comment": "function ParseClass"
                        },
                        {
                            "name": "ParseClass",
                            "type": "function",
                            "signature": "function ParseClass(const AInstance: TObject): TParameterList;",
                            "comment": "function ParseClass"
                        },
                        {
                            "name": "GetClassTitle",
                            "type": "function",
                            "signature": "function GetClassTitle(const AClassType: TClass): string;",
                            "comment": "function GetClassTitle"
                        },
                        {
                            "name": "GetClassTitle",
                            "type": "function",
                            "signature": "function GetClassTitle(const AInstance: TObject): string;",
                            "comment": "function GetClassTitle"
                        },
                        {
                            "name": "GetClassContratoID",
                            "type": "function",
                            "signature": "function GetClassContratoID(const AClassType: TClass): Integer;",
                            "comment": "function GetClassContratoID"
                        },
                        {
                            "name": "GetClassContratoID",
                            "type": "function",
                            "signature": "function GetClassContratoID(const AInstance: TObject): Integer;",
                            "comment": "function GetClassContratoID"
                        },
                        {
                            "name": "GetClassProdutoID",
                            "type": "function",
                            "signature": "function GetClassProdutoID(const AClassType: TClass): Integer;",
                            "comment": "function GetClassProdutoID"
                        },
                        {
                            "name": "GetClassProdutoID",
                            "type": "function",
                            "signature": "function GetClassProdutoID(const AInstance: TObject): Integer;",
                            "comment": "function GetClassProdutoID"
                        },
                        {
                            "name": "GetClassSource",
                            "type": "function",
                            "signature": "function GetClassSource(const AClassType: TClass): TParameterSource;",
                            "comment": "function GetClassSource"
                        },
                        {
                            "name": "GetClassSource",
                            "type": "function",
                            "signature": "function GetClassSource(const AInstance: TObject): TParameterSource;",
                            "comment": "function GetClassSource"
                        },
                        {
                            "name": "GetParameterProperties",
                            "type": "function",
                            "signature": "function GetParameterProperties(const AClassType: TClass): TStringArray;",
                            "comment": "function GetParameterProperties"
                        },
                        {
                            "name": "GetParameterProperties",
                            "type": "function",
                            "signature": "function GetParameterProperties(const AInstance: TObject): TStringArray;",
                            "comment": "function GetParameterProperties"
                        },
                        {
                            "name": "GetPropertyKey",
                            "type": "function",
                            "signature": "function GetPropertyKey(const AInstance: TObject; const APropertyName: string): string;",
                            "comment": "function GetPropertyKey"
                        },
                        {
                            "name": "GetPropertyDefaultValue",
                            "type": "function",
                            "signature": "function GetPropertyDefaultValue(const AInstance: TObject; const APropertyName: string): Variant;",
                            "comment": "function GetPropertyDefaultValue"
                        },
                        {
                            "name": "GetPropertyDescription",
                            "type": "function",
                            "signature": "function GetPropertyDescription(const AInstance: TObject; const APropertyName: string): string;",
                            "comment": "function GetPropertyDescription"
                        },
                        {
                            "name": "GetPropertyValueType",
                            "type": "function",
                            "signature": "function GetPropertyValueType(const AInstance: TObject; const APropertyName: string): TParameterValueType;",
                            "comment": "function GetPropertyValueType"
                        },
                        {
                            "name": "GetPropertyOrder",
                            "type": "function",
                            "signature": "function GetPropertyOrder(const AInstance: TObject; const APropertyName: string): Integer;",
                            "comment": "function GetPropertyOrder"
                        },
                        {
                            "name": "IsPropertyRequired",
                            "type": "function",
                            "signature": "function IsPropertyRequired(const AInstance: TObject; const APropertyName: string): Boolean;",
                            "comment": "function IsPropertyRequired"
                        },
                        {
                            "name": "ValidateClass",
                            "type": "function",
                            "signature": "function ValidateClass(const AClassType: TClass): Boolean;",
                            "comment": "function ValidateClass"
                        },
                        {
                            "name": "ValidateClass",
                            "type": "function",
                            "signature": "function ValidateClass(const AInstance: TObject): Boolean;",
                            "comment": "function ValidateClass"
                        }
                    ],
                    "privateMethods": [
                        {
                            "name": "GetRttiType",
                            "type": "function",
                            "signature": "function GetRttiType(const AClassType: TClass): TRttiType;",
                            "comment": "function GetRttiType"
                        },
                        {
                            "name": "GetParameterAttribute",
                            "type": "function",
                            "signature": "function GetParameterAttribute(const ARttiType: TRttiType): ParameterAttribute;",
                            "comment": "function GetParameterAttribute"
                        },
                        {
                            "name": "GetContratoIDAttribute",
                            "type": "function",
                            "signature": "function GetContratoIDAttribute(const ARttiType: TRttiType): ContratoIDAttribute;",
                            "comment": "function GetContratoIDAttribute"
                        },
                        {
                            "name": "GetProdutoIDAttribute",
                            "type": "function",
                            "signature": "function GetProdutoIDAttribute(const ARttiType: TRttiType): ProdutoIDAttribute;",
                            "comment": "function GetProdutoIDAttribute"
                        },
                        {
                            "name": "GetParameterSourceAttribute",
                            "type": "function",
                            "signature": "function GetParameterSourceAttribute(const ARttiType: TRttiType): ParameterSourceAttribute;",
                            "comment": "function GetParameterSourceAttribute"
                        },
                        {
                            "name": "ConvertRttiTypeToValueType",
                            "type": "function",
                            "signature": "function ConvertRttiTypeToValueType(const ARttiType: TRttiType): TParameterValueType;",
                            "comment": "function ConvertRttiTypeToValueType"
                        },
                        {
                            "name": "GetParameterKey",
                            "type": "function",
                            "signature": "function GetParameterKey(const ARttiProperty: TRttiProperty): string;",
                            "comment": "function GetParameterKey"
                        },
                        {
                            "name": "GetParameterValue",
                            "type": "function",
                            "signature": "function GetParameterValue(const ARttiProperty: TRttiProperty): Variant;",
                            "comment": "function GetParameterValue"
                        },
                        {
                            "name": "GetParameterDescription",
                            "type": "function",
                            "signature": "function GetParameterDescription(const ARttiProperty: TRttiProperty): string;",
                            "comment": "function GetParameterDescription"
                        },
                        {
                            "name": "GetParameterValueType",
                            "type": "function",
                            "signature": "function GetParameterValueType(const ARttiProperty: TRttiProperty): TParameterValueType;",
                            "comment": "function GetParameterValueType"
                        },
                        {
                            "name": "GetParameterOrder",
                            "type": "function",
                            "signature": "function GetParameterOrder(const ARttiProperty: TRttiProperty): Integer;",
                            "comment": "function GetParameterOrder"
                        },
                        {
                            "name": "IsParameterRequired",
                            "type": "function",
                            "signature": "function IsParameterRequired(const ARttiProperty: TRttiProperty): Boolean;",
                            "comment": "function IsParameterRequired"
                        },
                        {
                            "name": "VariantToString",
                            "type": "function",
                            "signature": "function VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;",
                            "comment": "function VariantToString"
                        },
                        {
                            "name": "ParsePropertyToParameter",
                            "type": "function",
                            "signature": "function ParsePropertyToParameter(const ARttiProperty: TRttiProperty; const AInstance: TObject; \n      const ATitulo: string; const AContratoID, AProdutoID: Integer): TParameter;",
                            "comment": "function ParsePropertyToParameter"
                        },
                        {
                            "name": "CreateParameterNotFoundException",
                            "type": "function",
                            "signature": "function CreateParameterNotFoundException(const AClassName, AOperation: string): EParametersAttributeException;",
                            "comment": "function CreateParameterNotFoundException"
                        },
                        {
                            "name": "CreateRTTINotAvailableException",
                            "type": "function",
                            "signature": "function CreateRTTINotAvailableException(const AClassName, AOperation: string): EParametersAttributeException;",
                            "comment": "function CreateRTTINotAvailableException"
                        }
                    ]
                },
                {
                    "name": "TAttributeMapper",
                    "description": "<p>TAttributeMapper - Implementação de IAttributeMapper</p>\n<p>Implementa mapeamento bidirecional entre classes Pascal e estruturas TParameter.</p>\n<p>Permite converter Classe → TParameterList e TParameterList → Classe, além de</p>\n<p>acesso individual a valores de parâmetros usando chaves.</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create;",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Destroy",
                            "type": "destructor",
                            "signature": "destructor Destroy;",
                            "comment": "Destrói instância e libera recursos"
                        },
                        {
                            "name": "New",
                            "type": "function",
                            "signature": "function New: IAttributeMapper;",
                            "comment": "Cria uma nova instância de IParameters com configuração padrão ou customizada"
                        },
                        {
                            "name": "MapClassToParameters",
                            "type": "function",
                            "signature": "function MapClassToParameters(const AClassType: TClass): TParameterList;",
                            "comment": "function MapClassToParameters"
                        },
                        {
                            "name": "MapClassToParameters",
                            "type": "function",
                            "signature": "function MapClassToParameters(const AInstance: TObject): TParameterList;",
                            "comment": "function MapClassToParameters"
                        },
                        {
                            "name": "MapParametersToClass",
                            "type": "function",
                            "signature": "function MapParametersToClass(AParameters: TParameterList; AInstance: TObject): IAttributeMapper;",
                            "comment": "function MapParametersToClass"
                        },
                        {
                            "name": "SetParameterValue",
                            "type": "function",
                            "signature": "function SetParameterValue(AInstance: TObject; const AParameterKey: string; const AValue: Variant): IAttributeMapper;",
                            "comment": "function SetParameterValue"
                        },
                        {
                            "name": "GetParameterValue",
                            "type": "function",
                            "signature": "function GetParameterValue(const AInstance: TObject; const AParameterKey: string): Variant;",
                            "comment": "function GetParameterValue"
                        }
                    ],
                    "privateMethods": [
                        {
                            "name": "GetRttiType",
                            "type": "function",
                            "signature": "function GetRttiType(const AClassType: TClass): TRttiType;",
                            "comment": "function GetRttiType"
                        },
                        {
                            "name": "GetRttiPropertyByKey",
                            "type": "function",
                            "signature": "function GetRttiPropertyByKey(const ARttiType: TRttiType; const AParameterKey: string): TRttiProperty;",
                            "comment": "function GetRttiPropertyByKey"
                        },
                        {
                            "name": "SetPropertyValue",
                            "type": "function",
                            "signature": "function SetPropertyValue(const AInstance: TObject; const AProperty: TRttiProperty; const AValue: Variant): Boolean;",
                            "comment": "function SetPropertyValue"
                        },
                        {
                            "name": "GetPropertyValue",
                            "type": "function",
                            "signature": "function GetPropertyValue(const AInstance: TObject; const AProperty: TRttiProperty): Variant;",
                            "comment": "function GetPropertyValue"
                        },
                        {
                            "name": "VariantToString",
                            "type": "function",
                            "signature": "function VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;",
                            "comment": "function VariantToString"
                        }
                    ]
                }
            ],
            "functions": [
                {
                    "name": "GetRttiType",
                    "type": "function",
                    "signature": "function GetRttiType(const AClassType: TClass): TRttiType;",
                    "description": "function GetRttiType",
                    "comment": "function GetRttiType"
                },
                {
                    "name": "GetParameterAttribute",
                    "type": "function",
                    "signature": "function GetParameterAttribute(const ARttiType: TRttiType): ParameterAttribute;",
                    "description": "function GetParameterAttribute",
                    "comment": "function GetParameterAttribute"
                },
                {
                    "name": "GetContratoIDAttribute",
                    "type": "function",
                    "signature": "function GetContratoIDAttribute(const ARttiType: TRttiType): ContratoIDAttribute;",
                    "description": "function GetContratoIDAttribute",
                    "comment": "function GetContratoIDAttribute"
                },
                {
                    "name": "GetProdutoIDAttribute",
                    "type": "function",
                    "signature": "function GetProdutoIDAttribute(const ARttiType: TRttiType): ProdutoIDAttribute;",
                    "description": "function GetProdutoIDAttribute",
                    "comment": "function GetProdutoIDAttribute"
                },
                {
                    "name": "GetParameterSourceAttribute",
                    "type": "function",
                    "signature": "function GetParameterSourceAttribute(const ARttiType: TRttiType): ParameterSourceAttribute;",
                    "description": "function GetParameterSourceAttribute",
                    "comment": "function GetParameterSourceAttribute"
                },
                {
                    "name": "ConvertRttiTypeToValueType",
                    "type": "function",
                    "signature": "function ConvertRttiTypeToValueType(const ARttiType: TRttiType): TParameterValueType;",
                    "description": "function ConvertRttiTypeToValueType",
                    "comment": "function ConvertRttiTypeToValueType"
                },
                {
                    "name": "GetParameterKey",
                    "type": "function",
                    "signature": "function GetParameterKey(const ARttiProperty: TRttiProperty): string;",
                    "description": "function GetParameterKey",
                    "comment": "function GetParameterKey"
                },
                {
                    "name": "GetParameterValue",
                    "type": "function",
                    "signature": "function GetParameterValue(const ARttiProperty: TRttiProperty): Variant;",
                    "description": "function GetParameterValue",
                    "comment": "function GetParameterValue"
                },
                {
                    "name": "GetParameterDescription",
                    "type": "function",
                    "signature": "function GetParameterDescription(const ARttiProperty: TRttiProperty): string;",
                    "description": "function GetParameterDescription",
                    "comment": "function GetParameterDescription"
                },
                {
                    "name": "GetParameterValueType",
                    "type": "function",
                    "signature": "function GetParameterValueType(const ARttiProperty: TRttiProperty): TParameterValueType;",
                    "description": "function GetParameterValueType",
                    "comment": "function GetParameterValueType"
                },
                {
                    "name": "GetParameterOrder",
                    "type": "function",
                    "signature": "function GetParameterOrder(const ARttiProperty: TRttiProperty): Integer;",
                    "description": "function GetParameterOrder",
                    "comment": "function GetParameterOrder"
                },
                {
                    "name": "IsParameterRequired",
                    "type": "function",
                    "signature": "function IsParameterRequired(const ARttiProperty: TRttiProperty): Boolean;",
                    "description": "function IsParameterRequired",
                    "comment": "function IsParameterRequired"
                },
                {
                    "name": "VariantToString",
                    "type": "function",
                    "signature": "function VariantToString(const AValue: Variant; const AValueType: TParameterValueType): string;",
                    "description": "function VariantToString",
                    "comment": "function VariantToString"
                },
                {
                    "name": "ParsePropertyToParameter",
                    "type": "function",
                    "signature": "function ParsePropertyToParameter(const ARttiProperty: TRttiProperty; const AInstance: TObject; \n      const ATitulo: string; const AContratoID, AProdutoID: Integer): TParameter;",
                    "description": "function ParsePropertyToParameter",
                    "comment": "function ParsePropertyToParameter"
                },
                {
                    "name": "CreateParameterNotFoundException",
                    "type": "function",
                    "signature": "function CreateParameterNotFoundException(const AClassName, AOperation: string): EParametersAttributeException;",
                    "description": "function CreateParameterNotFoundException",
                    "comment": "function CreateParameterNotFoundException"
                },
                {
                    "name": "CreateRTTINotAvailableException",
                    "type": "function",
                    "signature": "function CreateRTTINotAvailableException(const AClassName, AOperation: string): EParametersAttributeException;",
                    "description": "function CreateRTTINotAvailableException",
                    "comment": "function CreateRTTINotAvailableException"
                }
            ]
        },
        {
            "id": "attributes_parameters.attributes.interfaces",
            "name": "Parameters.Attributes.Interfaces.pas",
            "path": "src\\Paramenters\\Attributes\\Parameters.Attributes.Interfaces.pas",
            "description": "<p>Parameters.Attributes.Interfaces - Interfaces para Sistema de Attributes</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define interfaces para parsing e mapeamento de atributos via RTTI.</p>\n<p>Hierarquia:</p>\n<p>Attributes (Runtime) → IAttributeParser → IAttributeMapper → IParameters</p>\n<p>Interfaces:</p>\n<p>- IAttributeParser: Parsing de classes com atributos para TParameter/TParameterList</p>\n<p>- IAttributeMapper: Mapeamento bidirecional Classe ↔ TParameter</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 03/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Attributes.Interfaces - Interfaces de Attributes</h3>\n    <p><strong>Finalidade:</strong> Define interfaces para leitura e processamento de attributes via RTTI</p>\n    <p><strong>Status:</strong> 🚧 Em desenvolvimento (v2.0+)</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🔮 Uso Futuro (v2.0+)</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Attributes.Interfaces;\n\nvar\n  Reader: IAttributeReader;\n  Metadata: IEntityMetadata;\nbegin\n  // Criar leitor de attributes\n  Reader := TAttributeReader.Create;\n  \n  // Ler metadados da classe\n  Metadata := Reader.ReadMetadata(TConfigParameter);\n  \n  WriteLn('Tabela: ', Metadata.TableName);\n  WriteLn('Schema: ', Metadata.SchemaName);\n  WriteLn('Colunas: ', Metadata.Columns.Count);\nend;</code></pre>\n\n<div style=\"background: #fff9c4; border-left: 4px solid #f57f17; padding: 15px; margin: 20px 0;\">\n    <strong>⚠️ EM DESENVOLVIMENTO:</strong> Esta funcionalidade será implementada na versão 2.0 do Parameters ORM.\n</div>\n",
            "interfaces": [
                {
                    "name": "IAttributeParser",
                    "description": "<p>IAttributeParser - Interface para parsing de atributos via RTTI</p>\n<p>Responsável por converter classes Pascal com atributos em estruturas</p>\n<p>TParameter e TParameterList do Parameters ORM. Usa RTTI para ler atributos em runtime.</p>\n<p>Funcionalidades:</p>\n<p>- Parsing de classes com atributos para TParameter/TParameterList</p>\n<p>- Extração de informações de classe (título, ContratoID, ProdutoID)</p>\n<p>- Identificação de propriedades com [ParameterKey]</p>\n<p>- Validação de atributos</p>",
                    "methods": [
                        {
                            "name": "ParseClass",
                            "type": "function",
                            "signature": "function ParseClass(const AClassType: TClass): TParameterList;",
                            "comment": "function ParseClass"
                        },
                        {
                            "name": "ParseClass",
                            "type": "function",
                            "signature": "function ParseClass(const AInstance: TObject): TParameterList;",
                            "comment": "function ParseClass"
                        },
                        {
                            "name": "GetClassTitle",
                            "type": "function",
                            "signature": "function GetClassTitle(const AClassType: TClass): string;",
                            "comment": "function GetClassTitle"
                        },
                        {
                            "name": "GetClassTitle",
                            "type": "function",
                            "signature": "function GetClassTitle(const AInstance: TObject): string;",
                            "comment": "function GetClassTitle"
                        },
                        {
                            "name": "GetClassContratoID",
                            "type": "function",
                            "signature": "function GetClassContratoID(const AClassType: TClass): Integer;",
                            "comment": "function GetClassContratoID"
                        },
                        {
                            "name": "GetClassContratoID",
                            "type": "function",
                            "signature": "function GetClassContratoID(const AInstance: TObject): Integer;",
                            "comment": "function GetClassContratoID"
                        },
                        {
                            "name": "GetClassProdutoID",
                            "type": "function",
                            "signature": "function GetClassProdutoID(const AClassType: TClass): Integer;",
                            "comment": "function GetClassProdutoID"
                        },
                        {
                            "name": "GetClassProdutoID",
                            "type": "function",
                            "signature": "function GetClassProdutoID(const AInstance: TObject): Integer;",
                            "comment": "function GetClassProdutoID"
                        },
                        {
                            "name": "GetClassSource",
                            "type": "function",
                            "signature": "function GetClassSource(const AClassType: TClass): TParameterSource;",
                            "comment": "function GetClassSource"
                        },
                        {
                            "name": "GetClassSource",
                            "type": "function",
                            "signature": "function GetClassSource(const AInstance: TObject): TParameterSource;",
                            "comment": "function GetClassSource"
                        },
                        {
                            "name": "GetParameterProperties",
                            "type": "function",
                            "signature": "function GetParameterProperties(const AClassType: TClass): TStringArray;",
                            "comment": "function GetParameterProperties"
                        },
                        {
                            "name": "GetParameterProperties",
                            "type": "function",
                            "signature": "function GetParameterProperties(const AInstance: TObject): TStringArray;",
                            "comment": "function GetParameterProperties"
                        },
                        {
                            "name": "GetPropertyKey",
                            "type": "function",
                            "signature": "function GetPropertyKey(const AInstance: TObject; const APropertyName: string): string;",
                            "comment": "function GetPropertyKey"
                        },
                        {
                            "name": "GetPropertyDefaultValue",
                            "type": "function",
                            "signature": "function GetPropertyDefaultValue(const AInstance: TObject; const APropertyName: string): Variant;",
                            "comment": "function GetPropertyDefaultValue"
                        },
                        {
                            "name": "GetPropertyDescription",
                            "type": "function",
                            "signature": "function GetPropertyDescription(const AInstance: TObject; const APropertyName: string): string;",
                            "comment": "function GetPropertyDescription"
                        },
                        {
                            "name": "GetPropertyValueType",
                            "type": "function",
                            "signature": "function GetPropertyValueType(const AInstance: TObject; const APropertyName: string): TParameterValueType;",
                            "comment": "function GetPropertyValueType"
                        },
                        {
                            "name": "GetPropertyOrder",
                            "type": "function",
                            "signature": "function GetPropertyOrder(const AInstance: TObject; const APropertyName: string): Integer;",
                            "comment": "function GetPropertyOrder"
                        },
                        {
                            "name": "IsPropertyRequired",
                            "type": "function",
                            "signature": "function IsPropertyRequired(const AInstance: TObject; const APropertyName: string): Boolean;",
                            "comment": "function IsPropertyRequired"
                        },
                        {
                            "name": "ValidateClass",
                            "type": "function",
                            "signature": "function ValidateClass(const AClassType: TClass): Boolean;",
                            "comment": "function ValidateClass"
                        },
                        {
                            "name": "ValidateClass",
                            "type": "function",
                            "signature": "function ValidateClass(const AInstance: TObject): Boolean;",
                            "comment": "function ValidateClass"
                        }
                    ]
                },
                {
                    "name": "IAttributeMapper",
                    "description": "<p>IAttributeMapper - Interface para mapeamento bidirecional Classe ↔ TParameter</p>\n<p>Responsável por mapear valores entre classes Pascal e estruturas TParameter.</p>\n<p>Permite conversão bidirecional: Classe → TParameter e TParameter → Classe.</p>\n<p>Funcionalidades:</p>\n<p>- Conversão Classe → TParameterList (com valores)</p>\n<p>- Conversão TParameterList → Classe (preenche propriedades)</p>\n<p>- Acesso individual a valores de parâmetros</p>",
                    "methods": [
                        {
                            "name": "MapClassToParameters",
                            "type": "function",
                            "signature": "function MapClassToParameters(const AClassType: TClass): TParameterList;",
                            "comment": "function MapClassToParameters"
                        },
                        {
                            "name": "MapClassToParameters",
                            "type": "function",
                            "signature": "function MapClassToParameters(const AInstance: TObject): TParameterList;",
                            "comment": "function MapClassToParameters"
                        },
                        {
                            "name": "MapParametersToClass",
                            "type": "function",
                            "signature": "function MapParametersToClass(AParameters: TParameterList; AInstance: TObject): IAttributeMapper;",
                            "comment": "Agora Config.DatabaseHost, Config.DatabasePort, etc. estão preenchidos }"
                        },
                        {
                            "name": "SetParameterValue",
                            "type": "function",
                            "signature": "function SetParameterValue(AInstance: TObject; const AParameterKey: string; const AValue: Variant): IAttributeMapper;",
                            "comment": "Define Config.DatabaseHost se [ParameterKey('database_host')] estiver na propriedade }"
                        },
                        {
                            "name": "GetParameterValue",
                            "type": "function",
                            "signature": "function GetParameterValue(const AInstance: TObject; const AParameterKey: string): Variant;",
                            "comment": "Retorna Config.DatabaseHost se [ParameterKey('database_host')] estiver na propriedade }"
                        }
                    ]
                }
            ],
            "classes": [],
            "functions": [
                {
                    "name": "ParseClass",
                    "type": "function",
                    "signature": "function ParseClass(const AClassType: TClass): TParameterList;",
                    "description": "function ParseClass",
                    "comment": "function ParseClass"
                },
                {
                    "name": "ParseClass",
                    "type": "function",
                    "signature": "function ParseClass(const AInstance: TObject): TParameterList;",
                    "description": "function ParseClass",
                    "comment": "function ParseClass"
                },
                {
                    "name": "GetClassTitle",
                    "type": "function",
                    "signature": "function GetClassTitle(const AClassType: TClass): string;",
                    "description": "function GetClassTitle",
                    "comment": "function GetClassTitle"
                },
                {
                    "name": "GetClassTitle",
                    "type": "function",
                    "signature": "function GetClassTitle(const AInstance: TObject): string;",
                    "description": "function GetClassTitle",
                    "comment": "function GetClassTitle"
                },
                {
                    "name": "GetClassContratoID",
                    "type": "function",
                    "signature": "function GetClassContratoID(const AClassType: TClass): Integer;",
                    "description": "function GetClassContratoID",
                    "comment": "function GetClassContratoID"
                },
                {
                    "name": "GetClassContratoID",
                    "type": "function",
                    "signature": "function GetClassContratoID(const AInstance: TObject): Integer;",
                    "description": "function GetClassContratoID",
                    "comment": "function GetClassContratoID"
                },
                {
                    "name": "GetClassProdutoID",
                    "type": "function",
                    "signature": "function GetClassProdutoID(const AClassType: TClass): Integer;",
                    "description": "function GetClassProdutoID",
                    "comment": "function GetClassProdutoID"
                },
                {
                    "name": "GetClassProdutoID",
                    "type": "function",
                    "signature": "function GetClassProdutoID(const AInstance: TObject): Integer;",
                    "description": "function GetClassProdutoID",
                    "comment": "function GetClassProdutoID"
                },
                {
                    "name": "GetClassSource",
                    "type": "function",
                    "signature": "function GetClassSource(const AClassType: TClass): TParameterSource;",
                    "description": "function GetClassSource",
                    "comment": "function GetClassSource"
                },
                {
                    "name": "GetClassSource",
                    "type": "function",
                    "signature": "function GetClassSource(const AInstance: TObject): TParameterSource;",
                    "description": "function GetClassSource",
                    "comment": "function GetClassSource"
                },
                {
                    "name": "GetParameterProperties",
                    "type": "function",
                    "signature": "function GetParameterProperties(const AClassType: TClass): TStringArray;",
                    "description": "function GetParameterProperties",
                    "comment": "function GetParameterProperties"
                },
                {
                    "name": "GetParameterProperties",
                    "type": "function",
                    "signature": "function GetParameterProperties(const AInstance: TObject): TStringArray;",
                    "description": "function GetParameterProperties",
                    "comment": "function GetParameterProperties"
                },
                {
                    "name": "GetPropertyKey",
                    "type": "function",
                    "signature": "function GetPropertyKey(const AInstance: TObject; const APropertyName: string): string;",
                    "description": "function GetPropertyKey",
                    "comment": "function GetPropertyKey"
                },
                {
                    "name": "GetPropertyDefaultValue",
                    "type": "function",
                    "signature": "function GetPropertyDefaultValue(const AInstance: TObject; const APropertyName: string): Variant;",
                    "description": "function GetPropertyDefaultValue",
                    "comment": "function GetPropertyDefaultValue"
                },
                {
                    "name": "GetPropertyDescription",
                    "type": "function",
                    "signature": "function GetPropertyDescription(const AInstance: TObject; const APropertyName: string): string;",
                    "description": "function GetPropertyDescription",
                    "comment": "function GetPropertyDescription"
                },
                {
                    "name": "GetPropertyValueType",
                    "type": "function",
                    "signature": "function GetPropertyValueType(const AInstance: TObject; const APropertyName: string): TParameterValueType;",
                    "description": "function GetPropertyValueType",
                    "comment": "function GetPropertyValueType"
                },
                {
                    "name": "GetPropertyOrder",
                    "type": "function",
                    "signature": "function GetPropertyOrder(const AInstance: TObject; const APropertyName: string): Integer;",
                    "description": "function GetPropertyOrder",
                    "comment": "function GetPropertyOrder"
                },
                {
                    "name": "IsPropertyRequired",
                    "type": "function",
                    "signature": "function IsPropertyRequired(const AInstance: TObject; const APropertyName: string): Boolean;",
                    "description": "function IsPropertyRequired",
                    "comment": "function IsPropertyRequired"
                },
                {
                    "name": "ValidateClass",
                    "type": "function",
                    "signature": "function ValidateClass(const AClassType: TClass): Boolean;",
                    "description": "function ValidateClass",
                    "comment": "function ValidateClass"
                },
                {
                    "name": "ValidateClass",
                    "type": "function",
                    "signature": "function ValidateClass(const AInstance: TObject): Boolean;",
                    "description": "function ValidateClass",
                    "comment": "function ValidateClass"
                },
                {
                    "name": "MapClassToParameters",
                    "type": "function",
                    "signature": "function MapClassToParameters(const AClassType: TClass): TParameterList;",
                    "description": "function MapClassToParameters",
                    "comment": "function MapClassToParameters"
                },
                {
                    "name": "MapClassToParameters",
                    "type": "function",
                    "signature": "function MapClassToParameters(const AInstance: TObject): TParameterList;",
                    "description": "function MapClassToParameters",
                    "comment": "function MapClassToParameters"
                },
                {
                    "name": "MapParametersToClass",
                    "type": "function",
                    "signature": "function MapParametersToClass(AParameters: TParameterList; AInstance: TObject): IAttributeMapper;",
                    "description": "function MapParametersToClass",
                    "comment": "Agora Config.DatabaseHost, Config.DatabasePort, etc. estão preenchidos }"
                },
                {
                    "name": "SetParameterValue",
                    "type": "function",
                    "signature": "function SetParameterValue(AInstance: TObject; const AParameterKey: string; const AValue: Variant): IAttributeMapper;",
                    "description": "function SetParameterValue",
                    "comment": "Define Config.DatabaseHost se [ParameterKey('database_host')] estiver na propriedade }"
                },
                {
                    "name": "GetParameterValue",
                    "type": "function",
                    "signature": "function GetParameterValue(const AInstance: TObject; const AParameterKey: string): Variant;",
                    "description": "function GetParameterValue",
                    "comment": "Retorna Config.DatabaseHost se [ParameterKey('database_host')] estiver na propriedade }"
                }
            ]
        },
        {
            "id": "attributes_parameters.attributes.types",
            "name": "Parameters.Attributes.Types.pas",
            "path": "src\\Paramenters\\Attributes\\Parameters.Attributes.Types.pas",
            "description": "<p>Parameters.Attributes.Types - Definição de Atributos para Mapeamento Runtime</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define todos os atributos (Custom Attributes) usados para mapeamento</p>\n<p>declarativo de classes Pascal para parâmetros de configuração.</p>\n<p>Hierarquia:</p>\n<p>Attributes (Runtime) → IAttributeParser → IAttributeMapper → IParameters</p>\n<p>Atributos Suportados:</p>\n<p>- Classe: Parameter, ContratoID, ProdutoID, ParameterSource</p>\n<p>- Propriedade: ParameterKey, ParameterValue, ParameterDescription,</p>\n<p>ParameterType, ParameterOrder, ParameterRequired</p>\n<p>Compatibilidade:</p>\n<p>- Delphi XE7+: Suporte completo a RTTI e Attributes</p>\n<p>- FPC 3.2.2+: Suporte a RTTI via TypInfo e Rtti, Custom Attributes estável</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 03/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Attributes.Types - Tipos de Attributes</h3>\n    <p><strong>Finalidade:</strong> Define tipos e enums usados no sistema de attributes</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📊 Tipos Principais</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>// Tipo de coluna\nTColumnType = (\n  ctString,\n  ctInteger,\n  ctFloat,\n  ctBoolean,\n  ctDateTime,\n  ctText,\n  ctBlob\n);\n\n// Tipo de validação\nTValidationType = (\n  vtRequired,\n  vtMaxLength,\n  vtMinLength,\n  vtRange,\n  vtEmail,\n  vtURL,\n  vtPattern\n);\n\n// Metadados de coluna\nTColumnMetadata = class\n  Name: string;\n  ColumnName: string;\n  ColumnType: TColumnType;\n  IsPrimaryKey: Boolean;\n  IsAutoIncrement: Boolean;\n  IsForeignKey: Boolean;\n  IsRequired: Boolean;\n  MaxLength: Integer;\n  DefaultValue: string;\nend;</code></pre>\n\n<div style=\"background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;\">\n    <strong>💡 NOTA:</strong> Estes tipos são usados internamente pelo sistema de attributes para armazenar metadados extraídos via RTTI.\n</div>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "TConfigERP",
                    "description": "<p>Atributos de Classe</p>\n<p>Atributos usados na declaração da classe para mapear para parâmetros.</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "ParameterAttribute",
                    "description": "<p>Atributo para definir título/seção do parâmetro</p>\n<p>Obrigatório: Toda classe que usa Attributes DEVE ter [Parameter]</p>\n<p>Parâmetros:</p>\n<p>ATitle: Título/seção do parâmetro (ex: 'ERP', 'CRM', 'Database')</p>\n<p><strong>Uso:</strong> </p>\n<p>[Parameter('ERP')]</p>\n<p>TConfigERP = class</p>\n<p>// ...</p>\n<p>end;</p>\n<p>Mapeamento:</p>\n<p>- Database: Campo 'titulo' na tabela</p>\n<p>- INI: Nome da seção [ERP]</p>\n<p>- JSON: Nome do objeto \"ERP\"</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const ATitle: string);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Title",
                            "type": "property",
                            "signature": "property Title: string read FTitle;",
                            "comment": "Título/seção do parâmetro"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "TConfigERP",
                    "description": "<p>Título/seção do parâmetro</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "ContratoIDAttribute",
                    "description": "<p>Atributo para definir ContratoID</p>\n<p>Opcional: Se não especificado, usa valor padrão ou configuração do IParameters</p>\n<p>Parâmetros:</p>\n<p>AContratoID: ID do contrato</p>\n<p><strong>Uso:</strong> </p>\n<p>[Parameter('ERP')]</p>\n<p>[ContratoID(1)]</p>\n<p>TConfigERP = class</p>\n<p>// ...</p>\n<p>end;</p>\n<p>Mapeamento:</p>\n<p>- Database: Campo 'contrato_id' na tabela</p>\n<p>- INI: Seção [ERP_1] (formato: [Titulo_ContratoID])</p>\n<p>- JSON: Objeto \"ERP_1\"</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AContratoID: Integer);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "ContratoID",
                            "type": "property",
                            "signature": "property ContratoID: Integer read FContratoID;",
                            "comment": "ID do contrato"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "TConfigERP",
                    "description": "<p>Cria atributo [ContratoID] com ID do contrato</p>\n<p>Parâmetros:</p>\n<p>AContratoID: ID do contrato</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "ProdutoIDAttribute",
                    "description": "<p>Atributo para definir ProdutoID</p>\n<p>Opcional: Se não especificado, usa valor padrão ou configuração do IParameters</p>\n<p>Parâmetros:</p>\n<p>AProdutoID: ID do produto</p>\n<p><strong>Uso:</strong> </p>\n<p>[Parameter('ERP')]</p>\n<p>[ContratoID(1)]</p>\n<p>[ProdutoID(1)]</p>\n<p>TConfigERP = class</p>\n<p>// ...</p>\n<p>end;</p>\n<p>Mapeamento:</p>\n<p>- Database: Campo 'produto_id' na tabela</p>\n<p>- INI: Seção [ERP_1_1] (formato: [Titulo_ContratoID_ProdutoID])</p>\n<p>- JSON: Objeto \"ERP_1_1\"</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AProdutoID: Integer);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "ProdutoID",
                            "type": "property",
                            "signature": "property ProdutoID: Integer read FProdutoID;",
                            "comment": "ID do produto"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "TConfigERP",
                    "description": "<p>Cria atributo [ProdutoID] com ID do produto</p>\n<p>Parâmetros:</p>\n<p>AProdutoID: ID do produto</p>",
                    "publicMethods": [],
                    "privateMethods": []
                },
                {
                    "name": "ParameterSourceAttribute",
                    "description": "<p>Atributo para definir fonte de dados preferencial</p>\n<p>Opcional: Se não especificado, usa fonte padrão do IParameters</p>\n<p>Parâmetros:</p>\n<p>ASource: Fonte de dados (psDatabase, psInifiles, psJsonObject)</p>\n<p><strong>Uso:</strong> </p>\n<p>[Parameter('ERP')]</p>\n<p>[ParameterSource(psDatabase)]</p>\n<p>TConfigERP = class</p>\n<p>// ...</p>\n<p>end;</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const ASource: TParameterSource);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Source",
                            "type": "property",
                            "signature": "property Source: TParameterSource read FSource;",
                            "comment": "Fonte de dados preferencial"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "ParameterKeyAttribute",
                    "description": "<p>Atributo para mapear propriedade para chave do parâmetro</p>\n<p>Obrigatório: Toda propriedade mapeada DEVE ter [ParameterKey]</p>\n<p>Parâmetros:</p>\n<p>AKey: Nome da chave do parâmetro (campo 'chave' no banco, chave no INI/JSON)</p>\n<p><strong>Uso:</strong> </p>\n<p>[ParameterKey('database_host')]</p>\n<p>property DatabaseHost: string;</p>\n<p>Nota: Pode ser combinado com outros atributos: [ParameterKey('host'), ParameterValue('localhost')]</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AKey: string);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Key",
                            "type": "property",
                            "signature": "property Key: string read FKey;",
                            "comment": "Nome da chave do parâmetro"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "ParameterValueAttribute",
                    "description": "<p>Atributo para definir valor padrão do parâmetro</p>\n<p>Opcional: Use quando parâmetro tem valor padrão (usado se não existir no banco/INI/JSON)</p>\n<p>Parâmetros:</p>\n<p>AValue: Valor padrão (Variant - suporta string, Integer, Float, Boolean, etc.)</p>\n<p><strong>Uso:</strong> </p>\n<p>[ParameterKey('database_host')]</p>\n<p>[ParameterValue('localhost')]</p>\n<p>property DatabaseHost: string;</p>\n<p>Nota: Valor é usado ao carregar se parâmetro não existir no banco/INI/JSON</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AValue: Variant);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Value",
                            "type": "property",
                            "signature": "property Value: Variant read FValue;",
                            "comment": "Valor padrão do parâmetro"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "ParameterDescriptionAttribute",
                    "description": "<p>Atributo para definir descrição/comentário do parâmetro</p>\n<p>Opcional: Use quando quer documentar o parâmetro</p>\n<p>Parâmetros:</p>\n<p>ADescription: Descrição/comentário do parâmetro</p>\n<p><strong>Uso:</strong> </p>\n<p>[ParameterKey('database_host')]</p>\n<p>[ParameterDescription('Host do banco de dados ERP')]</p>\n<p>property DatabaseHost: string;</p>\n<p>Mapeamento:</p>\n<p>- Database: Campo 'descricao' na tabela</p>\n<p>- INI: Comentário na linha do parâmetro</p>\n<p>- JSON: Campo 'description' no objeto do parâmetro</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const ADescription: string);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Description",
                            "type": "property",
                            "signature": "property Description: string read FDescription;",
                            "comment": "Descrição/comentário do parâmetro"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "ParameterTypeAttribute",
                    "description": "<p>Atributo para definir tipo do valor do parâmetro</p>\n<p>Opcional: Se não especificado, é inferido automaticamente do tipo da propriedade</p>\n<p>Parâmetros:</p>\n<p>AValueType: Tipo do valor (pvtString, pvtInteger, pvtFloat, pvtBoolean, pvtDateTime, pvtJSON)</p>\n<p><strong>Uso:</strong> </p>\n<p>[ParameterKey('database_port')]</p>\n<p>[ParameterType(pvtInteger)]</p>\n<p>property DatabasePort: Integer;</p>\n<p>Nota: Geralmente não é necessário - tipo é inferido automaticamente</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AValueType: TParameterValueType);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "ValueType",
                            "type": "property",
                            "signature": "property ValueType: TParameterValueType read FValueType;",
                            "comment": "Tipo do valor do parâmetro"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "ParameterOrderAttribute",
                    "description": "<p>Atributo para definir ordem de exibição do parâmetro</p>\n<p>Opcional: Se não especificado, ordem é automática</p>\n<p>Parâmetros:</p>\n<p>AOrder: Ordem de exibição (1, 2, 3, ...)</p>\n<p><strong>Uso:</strong> </p>\n<p>[ParameterKey('database_host')]</p>\n<p>[ParameterOrder(1)]</p>\n<p>property DatabaseHost: string;</p>\n<p>Mapeamento:</p>\n<p>- Database: Campo 'ordem' na tabela</p>\n<p>- INI: Ordem das linhas na seção</p>\n<p>- JSON: Ordem dos campos no objeto</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AOrder: Integer);",
                            "comment": "constructor Create"
                        },
                        {
                            "name": "Order",
                            "type": "property",
                            "signature": "property Order: Integer read FOrder;",
                            "comment": "Ordem de exibição do parâmetro"
                        }
                    ],
                    "privateMethods": []
                },
                {
                    "name": "ParameterRequiredAttribute",
                    "description": "<p>Atributo para marcar parâmetro como obrigatório</p>\n<p>Opcional: Use quando parâmetro é obrigatório (gera exceção se não existir)</p>\n<p><strong>Uso:</strong> </p>\n<p>[ParameterKey('database_host')]</p>\n<p>[ParameterRequired]</p>\n<p>property DatabaseHost: string;</p>\n<p>Nota: Ao carregar, se parâmetro não existir, gera EParametersNotFoundException</p>",
                    "publicMethods": [],
                    "privateMethods": []
                }
            ],
            "functions": []
        },
        {
            "id": "attributes_parameters.attributes.consts",
            "name": "Parameters.Attributes.Consts.pas",
            "path": "src\\Paramenters\\Attributes\\Parameters.Attributes.Consts.pas",
            "description": "<p>Parameters.Attributes.Consts - Constantes para Sistema de Attributes</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define constantes usadas pelo sistema de Attributes para mapeamento runtime.</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 03/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Attributes.Consts - Constantes de Attributes</h3>\n    <p><strong>Finalidade:</strong> Define constantes padrão para o sistema de attributes</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📊 Constantes Disponíveis</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>// Nomes de attributes\nconst\n  ATTR_TABLE = 'Table';\n  ATTR_COLUMN = 'Column';\n  ATTR_PRIMARY_KEY = 'PrimaryKey';\n  ATTR_AUTO_INCREMENT = 'AutoIncrement';\n  ATTR_FOREIGN_KEY = 'ForeignKey';\n  ATTR_REQUIRED = 'Required';\n  ATTR_MAX_LENGTH = 'MaxLength';\n  ATTR_MIN_LENGTH = 'MinLength';\n  ATTR_RANGE = 'Range';\n  ATTR_EMAIL = 'Email';\n  ATTR_URL = 'URL';\n  ATTR_PATTERN = 'Pattern';\n  ATTR_DEFAULT = 'Default';\n  ATTR_IGNORE = 'Ignore';\n  ATTR_COMPUTED = 'Computed';\n\n// Mensagens de validação padrão\nconst\n  MSG_VALIDATION_REQUIRED = 'Campo obrigatório';\n  MSG_VALIDATION_MAX_LENGTH = 'Tamanho máximo excedido';\n  MSG_VALIDATION_MIN_LENGTH = 'Tamanho mínimo não atingido';\n  MSG_VALIDATION_RANGE = 'Valor fora da faixa permitida';\n  MSG_VALIDATION_EMAIL = 'Email inválido';\n  MSG_VALIDATION_URL = 'URL inválida';\n  MSG_VALIDATION_PATTERN = 'Formato inválido';</code></pre>\n\n<div style=\"background: #d1ecf1; border-left: 4px solid #0c5460; padding: 15px; margin: 20px 0;\">\n    <strong>💡 USO:</strong> Estas constantes são usadas internamente para identificar e validar attributes em tempo de execução.\n</div>\n",
            "interfaces": [],
            "classes": [],
            "functions": []
        },
        {
            "id": "attributes_parameters.attributes.exceptions",
            "name": "Parameters.Attributes.Exceptions.pas",
            "path": "src\\Paramenters\\Attributes\\Parameters.Attributes.Exceptions.pas",
            "description": "<p>Parameters.Attributes.Exceptions - Exceções Específicas para Sistema de Attributes</p>\n<p><strong>Descrição:</strong> </p>\n<p>Define exceções customizadas para o sistema de Attributes (RTTI e mapeamento).</p>\n<p>Herda de EParametersConfigurationException pois erros de atributos são erros</p>\n<p>de configuração/mapeamento de classes.</p>\n<p>Hierarquia:</p>\n<p>EParametersException → EParametersConfigurationException → EParametersAttributeException</p>\n<p>Códigos de Erro:</p>\n<p>Faixa 1900-1999 reservada para erros de Attributes</p>\n<p><strong>Author:</strong> Claiton de Souza Linhares</p>\n<p><strong>Version:</strong> 1.0.0</p>\n<p><strong>Date:</strong> 03/01/2026</p>\n\n\n<div style=\"background: #e8f4f8; border-left: 4px solid #3498db; padding: 20px; margin: 20px 0;\">\n    <h3 style=\"color: #2c3e50; margin-top: 0;\">📋 Parameters.Attributes.Exceptions - Exceções de Attributes</h3>\n    <p><strong>Finalidade:</strong> Define exceções específicas para o sistema de attributes</p>\n</div>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">📊 Exceções Disponíveis</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>// Hierarquia de exceções\nEAttributeError (Base)\n├── EAttributeValidationError\n│   ├── EAttributeRequiredError\n│   ├── EAttributeMaxLengthError\n│   ├── EAttributeRangeError\n│   └── EAttributePatternError\n├── EAttributeMetadataError\n│   ├── EAttributeTableNotFoundError\n│   └── EAttributeColumnNotFoundError\n└── EAttributeRTTIError</code></pre>\n\n<h4 style=\"color: #34495e; margin-top: 25px;\">🎯 Exemplo de Uso</h4>\n<pre style=\"background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;\"><code>uses\n  Parameters.Attributes.Exceptions;\n\nprocedure ValidateEmail(const AEmail: string);\nbegin\n  if not IsValidEmail(AEmail) then\n    raise EAttributeValidationError.Create(\n      'Email inválido: ' + AEmail,\n      ERR_ATTR_VALIDATION_EMAIL\n    );\nend;\n\nbegin\n  try\n    ValidateEmail('invalid-email');\n  except\n    on E: EAttributeValidationError do\n      WriteLn('Erro de validação: ', E.Message, ' [', E.ErrorCode, ']');\n  end;\nend;</code></pre>\n\n<div style=\"background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;\">\n    <strong>⚠️ IMPORTANTE:</strong> Estas exceções são lançadas automaticamente pelo sistema de validação quando attributes são violados.\n</div>\n",
            "interfaces": [],
            "classes": [
                {
                    "name": "EParametersAttributeException",
                    "description": "<p>EParametersAttributeException - Exceção Específica para Attributes</p>\n<p>Exceção específica para erros relacionados ao sistema de Attributes (RTTI e mapeamento).</p>\n<p>Herda de EParametersConfigurationException pois erros de atributos são erros de</p>\n<p>configuração/mapeamento de classes.</p>\n<p>Hierarquia:</p>\n<p>EParametersException → EParametersConfigurationException → EParametersAttributeException</p>\n<p>Códigos de Erro:</p>\n<p>Faixa 1900-1999 reservada para erros de Attributes</p>",
                    "publicMethods": [
                        {
                            "name": "Create",
                            "type": "constructor",
                            "signature": "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            "comment": "constructor Create"
                        }
                    ],
                    "privateMethods": []
                }
            ],
            "functions": []
        }
    ]
};

// IDs das units publicas (para navegacao)
const publicUnitIds = [
    "parameters",
    "parameters.interfaces"
];
