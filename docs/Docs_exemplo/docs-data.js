// Documentação completa do Database ORM v2.0
// Gerado automaticamente - Não editar manualmente

const documentation = {
    overview: {
        title: "Visão Geral",
        path: "Database ORM v2.0",
        description: `
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px;">
                <h2 style="color: white; margin-top: 0;">🗄️ Database ORM v2.0</h2>
                <p style="font-size: 1.1em; line-height: 1.6;">
                    Sistema completo de <strong>mapeamento objeto-relacional (ORM)</strong> para Delphi/Free Pascal, 
                    projetado para simplificar o acesso a bancos de dados com uma arquitetura moderna, escalável e fácil de usar.
                </p>
            </div>
            
            <h2 style="color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px;">📋 O que é o Database ORM?</h2>
            
            <p style="font-size: 1.05em; line-height: 1.8;">
                O <strong>Database ORM v2.0</strong> é uma biblioteca que elimina a necessidade de escrever SQL manualmente, 
                permitindo que você trabalhe com objetos Pascal como se fossem tabelas do banco de dados. 
                Ele abstrai a complexidade do acesso a dados, fornecendo uma interface fluente e intuitiva.
            </p>
            
            <div style="background: #ecf0f1; padding: 20px; border-left: 5px solid #3498db; margin: 20px 0; border-radius: 5px;">
                <h3 style="color: #2c3e50; margin-top: 0;">💡 Por que usar um ORM?</h3>
                <ul style="line-height: 1.8;">
                    <li><strong>Produtividade:</strong> Reduz drasticamente o código necessário para operações CRUD</li>
                    <li><strong>Manutenibilidade:</strong> Código mais limpo e fácil de entender</li>
                    <li><strong>Segurança:</strong> Proteção automática contra SQL Injection</li>
                    <li><strong>Portabilidade:</strong> Troque de banco de dados sem alterar o código</li>
                    <li><strong>Type-Safety:</strong> Erros detectados em tempo de compilação</li>
                </ul>
            </div>
            
            <h2 style="color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-top: 40px;">🏗️ Arquitetura Hierárquica e Encapsulamento</h2>
            
            <p style="font-size: 1.05em; line-height: 1.8;">
                O projeto implementa uma <strong>Arquitetura Hierárquica</strong> de 8 níveis com <strong>Encapsulamento Rigoroso</strong>, 
                garantindo modularidade, testabilidade e manutenibilidade.
            </p>
            
            <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto; font-size: 1.1em;"><code>Field → Fields → Table → Tables → Database → TypeDatabase → Parameters → Connection</code></pre>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;">
                <div style="background: #e8f5e9; padding: 20px; border-radius: 8px; border-left: 5px solid #4caf50;">
                    <h3 style="color: #2c3e50; margin-top: 0;">📐 Arquitetura Hierárquica</h3>
                    <p style="line-height: 1.8;">
                        Estrutura de <strong>8 níveis</strong> onde cada nível representa uma camada de responsabilidade específica. 
                        Isso facilita a compreensão, manutenção e extensão do sistema.
                    </p>
                    <ul style="line-height: 1.8;">
                        <li>Separação clara de responsabilidades</li>
                        <li>Facilita testes unitários</li>
                        <li>Permite evolução independente de cada nível</li>
                    </ul>
                </div>
                
                <div style="background: #fff3e0; padding: 20px; border-radius: 8px; border-left: 5px solid #ff9800;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🔒 Encapsulamento</h3>
                    <p style="line-height: 1.8;">
                        Cada nível <strong>só conhece o nível imediatamente abaixo</strong> via interface. 
                        Isso garante independência total entre módulos.
                    </p>
                    <ul style="line-height: 1.8;">
                        <li>Módulos independentes e testáveis</li>
                        <li>Mudanças isoladas não afetam outros níveis</li>
                        <li>Factory methods para criação segura</li>
                    </ul>
                </div>
            </div>
            
            <h2 style="color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-top: 40px;">✨ Funcionalidades Principais</h2>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 20px 0;">
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #3498db;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🔧 Geração Automática de SQL</h3>
                    <ul style="line-height: 1.8;">
                        <li>INSERT, UPDATE, DELETE gerados automaticamente</li>
                        <li>SQL otimizado (apenas campos alterados)</li>
                        <li>Proteção contra SQL Injection</li>
                        <li>Suporte a transações</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #e74c3c;">
                    <h3 style="color: #2c3e50; margin-top: 0;">📊 Carregamento Automático</h3>
                    <ul style="line-height: 1.8;">
                        <li>Estrutura de tabelas carregada automaticamente</li>
                        <li>Metadados de campos (tipo, nullable, PK)</li>
                        <li>Suporte a múltiplos schemas</li>
                        <li>Detecção automática de engine e banco</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #2ecc71;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🔄 Rastreamento de Alterações</h3>
                    <ul style="line-height: 1.8;">
                        <li>Detecção automática de campos modificados</li>
                        <li>SQL otimizado (UPDATE apenas campos alterados)</li>
                        <li>Histórico de alterações</li>
                        <li>Validação antes de persistir</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #9b59b6;">
                    <h3 style="color: #2c3e50; margin-top: 0;">📝 Auditoria Automática</h3>
                    <ul style="line-height: 1.8;">
                        <li>Campos de data (cadastro/alteracao) preenchidos automaticamente</li>
                        <li>Soft delete (is_deleted)</li>
                        <li>Controle de ativação (is_active)</li>
                        <li>Rastreamento de usuário (opcional)</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #f39c12;">
                    <h3 style="color: #2c3e50; margin-top: 0;">✅ Validação de Campos</h3>
                    <ul style="line-height: 1.8;">
                        <li>Validação de campos obrigatórios (NOT NULL)</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #1abc9c;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🔗 Serialização JSON</h3>
                    <ul style="line-height: 1.8;">
                        <li>Conversão automática para JSON</li>
                        <li>Carregamento de JSON para objetos</li>
                        <li>Integração com APIs REST</li>
                        <li>Suporte a DataSet</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #e67e22;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🏷️ Attributes (RTTI)</h3>
                    <ul style="line-height: 1.8;">
                        <li>Mapeamento declarativo via atributos</li>
                        <li>Reduz código boilerplate</li>
                        <li>Type-safe em tempo de compilação</li>
                        <li>Compatível com FPC 3.2.2+</li>
                    </ul>
                </div>
                
                <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-top: 4px solid #34495e;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🔗 Relationships</h3>
                    <ul style="line-height: 1.8;">
                        <li>HasOne (1:1)</li>
                        <li>HasMany (1:N)</li>
                        <li>BelongsTo (N:1)</li>
                        <li>Carregamento lazy ou eager</li>
                    </ul>
                </div>
            </div>
            
            <h2 style="color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-top: 40px;">🚀 Engines e Bancos Suportados</h2>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;">
                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🔌 Engines de Acesso</h3>
                    <ul style="line-height: 1.8;">
                        <li><strong>FireDAC</strong> - Framework nativo do Delphi (XE7+)</li>
                        <li><strong>UniDAC</strong> - Universal Data Access Components (Comercial)</li>
                        <li><strong>Zeos</strong> - Biblioteca Open-Source (Recomendado para FPC/Lazarus)</li>
                        <li><strong>SQLdb</strong> - Nativo do Free Pascal Compiler</li>
                    </ul>
                    <p style="margin-top: 15px; padding: 10px; background: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px;">
                        <strong>💡 Dica:</strong> O sistema detecta automaticamente qual engine está disponível e usa a mais apropriada.
                    </p>
                </div>
                
                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px;">
                    <h3 style="color: #2c3e50; margin-top: 0;">🗄️ Bancos de Dados</h3>
                    <ul style="line-height: 1.8;">
                        <li><strong>PostgreSQL</strong> - Banco relacional avançado</li>
                        <li><strong>MySQL / MariaDB</strong> - Banco relacional popular</li>
                        <li><strong>SQL Server</strong> - Banco da Microsoft</li>
                        <li><strong>FireBird</strong> - Banco open-source</li>
                        <li><strong>SQLite</strong> - Banco embarcado</li>
                        <li><strong>Access</strong> - Banco da Microsoft Office</li>
                        <li><strong>ODBC</strong> - Conectividade universal</li>
                    </ul>
                    <p style="margin-top: 15px; padding: 10px; background: #d1ecf1; border-left: 4px solid #17a2b8; border-radius: 4px;">
                        <strong>🌐 No-SQL:</strong> Suporte planejado para LDAP.
                    </p>
                </div>
            </div>
            
            <h2 style="color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-top: 40px;">💼 Aplicabilidade em Projetos</h2>
            
            <div style="background: #f8f9fa; padding: 25px; border-radius: 8px; margin: 20px 0;">
                <h3 style="color: #2c3e50; margin-top: 0;">🎯 Casos de Uso Ideais</h3>
                
                <div style="margin-top: 20px;">
                    <h4 style="color: #3498db;">1. Aplicações Desktop (Delphi/Lazarus)</h4>
                    <p style="line-height: 1.8;">
                        Perfeito para sistemas de gestão empresarial, CRMs, ERPs e aplicações administrativas. 
                        O ORM simplifica o desenvolvimento de formulários de cadastro, relatórios e consultas complexas.
                    </p>
                    <ul style="line-height: 1.8;">
                        <li>Sistemas de gestão (ERP, CRM, TMS)</li>
                        <li>Aplicativos administrativos</li>
                        <li>Ferramentas de análise de dados</li>
                        <li>Softwares de controle de estoque</li>
                    </ul>
                </div>
                
                <div style="margin-top: 25px;">
                    <h4 style="color: #3498db;">2. APIs REST e Serviços Web</h4>
                    <p style="line-height: 1.8;">
                        Ideal para criar APIs RESTful que precisam acessar bancos de dados. 
                        A serialização JSON integrada facilita a comunicação entre frontend e backend.
                    </p>
                    <ul style="line-height: 1.8;">
                        <li>APIs REST para aplicações web</li>
                        <li>Microserviços com acesso a dados</li>
                        <li>Integração entre sistemas</li>
                        <li>Backend para aplicativos mobile</li>
                    </ul>
                </div>
                
                <div style="margin-top: 25px;">
                    <h4 style="color: #3498db;">3. Migração e Portabilidade</h4>
                    <p style="line-height: 1.8;">
                        Facilita a migração entre diferentes bancos de dados sem alterar o código da aplicação. 
                        Ideal para projetos que precisam suportar múltiplos ambientes.
                    </p>
                    <ul style="line-height: 1.8;">
                        <li>Migração de banco de dados</li>
                        <li>Aplicações multi-ambiente (dev, prod)</li>
                        <li>Suporte a diferentes clientes com bancos diferentes</li>
                        <li>Prototipação rápida com SQLite, produção com PostgreSQL</li>
                    </ul>
                </div>
                
                <div style="margin-top: 25px;">
                    <h4 style="color: #3498db;">4. Desenvolvimento Rápido (RAD)</h4>
                    <p style="line-height: 1.8;">
                        Reduz drasticamente o tempo de desenvolvimento de funcionalidades CRUD, 
                        permitindo focar na lógica de negócio ao invés de SQL.
                    </p>
                    <ul style="line-height: 1.8;">
                        <li>Prototipação rápida de funcionalidades</li>
                        <li>Desenvolvimento de MVPs</li>
                        <li>Geração automática de formulários</li>
                        <li>Relatórios dinâmicos baseados em estrutura</li>
                    </ul>
                </div>
            </div>
            
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 25px; border-radius: 10px; margin: 30px 0;">
                <h3 style="color: white; margin-top: 0;">🎓 Vantagens Competitivas</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-top: 15px;">
                    <div>
                        <strong>⚡ Performance</strong>
                        <p style="margin: 5px 0 0 0; opacity: 0.9;">SQL otimizado e cache inteligente</p>
                    </div>
                    <div>
                        <strong>🔒 Segurança</strong>
                        <p style="margin: 5px 0 0 0; opacity: 0.9;">Proteção automática contra SQL Injection</p>
                    </div>
                    <div>
                        <strong>📈 Escalabilidade</strong>
                        <p style="margin: 5px 0 0 0; opacity: 0.9;">Arquitetura preparada para crescimento</p>
                    </div>
                    <div>
                        <strong>🛠️ Manutenibilidade</strong>
                        <p style="margin: 5px 0 0 0; opacity: 0.9;">Código limpo e bem estruturado</p>
                    </div>
                </div>
            </div>
            
            <div style="background: #fff3cd; padding: 20px; border-left: 5px solid #ffc107; border-radius: 5px; margin: 20px 0;">
                <h3 style="color: #856404; margin-top: 0;">⚠️ Quando NÃO usar?</h3>
                <p style="line-height: 1.8; color: #856404;">
                    O Database ORM é ideal para a maioria dos casos, mas considere SQL nativo para:
                </p>
                <ul style="line-height: 1.8; color: #856404;">
                    <li>Consultas extremamente complexas com múltiplos JOINs</li>
                    <li>Operações em lote muito grandes (milhões de registros)</li>
                    <li>Stored procedures complexas já existentes</li>
                    <li>Casos onde performance crítica exige SQL otimizado manualmente</li>
                </ul>
            </div>
        `
    },
    usageGuide: {
        title: "Roteiro de Uso",
        path: "Guia Prático",
        description: `
            <h2 style="color: #2c3e50; margin-top: 0;">🚀 Roteiro de Uso - Database ORM v2.0</h2>
            
            <p>Este guia apresenta exemplos práticos de uso do Database ORM v2.0, desde a configuração básica até operações avançadas.</p>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">1. Configuração de Conexão</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.1. Conexão via Parameters (Sem Attributes)</h4>
            <p>Conectar ao banco <code>dbsgp</code> e carregar a estrutura da tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

var
              Connection: IConnection;
              Tables: ITables;
              Table: ITable;
            begin
              // 1. Conectar ao banco (auto-detecta fonte: INI → JSON → Database)
              Connection := TDatabase.New
                .FromParameters('database')
                .Connect;
              
              // 2. Carregar estrutura do banco (mapeia todas as tabelas e campos)
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
              
              // 3. Acessar tabela admcore_pessoa (já mapeada com todos os campos)
              Table := Tables.Table('admcore_pessoa');
              
              // 4. Usar a tabela - campos já estão mapeados do banco
              Table.Fields('tipopessoa').SetValue('F')
                .Fields('nome').SetValue('JOÃO SILVA')
                .Fields('cpfcnpj').SetValue('123.456.789-00')
                .Fields('tipo').SetValue('1')
                .Fields('substituto_trib_iss').SetValue('false');
              
              // Não precisa criar campos manualmente!
              // A estrutura foi carregada automaticamente do banco
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.2. Conexão via Parameters (Com Attributes)</h4>
            <p>Conectar ao banco <code>dbsgp</code> e usar Attributes para mapear a classe <code>TPessoa</code> para a tabela <code>admcore_pessoa</code> (mesma operação do 1.1, mas usando Attributes). <strong>✨ AUTOMATIZAÇÃO:</strong> Você não precisa declarar campos privados! O sistema carrega TODOS os campos dinamicamente do banco:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}  // Habilita RTTI para Attributes
type
              { ✨ AUTOMATIZAÇÃO: Você NÃO precisa declarar campos privados!
                O sistema carrega TODOS os campos dinamicamente do banco.
                
                📌 ONDE DEFINE A TABELA?
                O Attribute [Table('admcore_pessoa')] define qual tabela será usada!
                O Attribute [Schema('public')] define o schema (opcional).
                
                Quando você chama TableFromClass(Pessoa), o sistema:
                1. Lê o Attribute [Table('admcore_pessoa')] via RTTI
                2. Identifica que deve usar a tabela 'admcore_pessoa'
                3. Carrega TODOS os campos dessa tabela do banco automaticamente
                4. Armazena os campos em memória na ITable/IFields }
              [Table('admcore_pessoa')]  // ← AQUI define qual tabela será usada!
              [Schema('public')]          // ← Schema (opcional)
              TPessoa = class
                { ✨ Classe vazia! Não precisa declarar FId, FNome, etc.
                  Todos os campos são carregados dinamicamente do banco em memória. }
              end;

var
              Connection: IConnection;
              Tables: ITables;
              Pessoa: TPessoa;
              Table: ITable;
            begin
              // 1. Conectar ao banco (auto-detecta fonte: INI → JSON → Database)
              Connection := TDatabase.New
                .FromParameters('database')
                .Connect;
              
              // 2. Carregar estrutura do banco (mapeia todas as tabelas e campos)
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
              
              // 3. Usar Attributes apenas para identificar a tabela
              Pessoa := TPessoa.Create;
              
              // ✨ AUTOMATIZAÇÃO: TableFromClass() lê o Attribute [Table('admcore_pessoa')]
              // da classe TPessoa via RTTI e identifica qual tabela usar.
              // Depois carrega TODOS os 28 campos do banco dinamicamente.
              // Os campos são armazenados em memória na ITable/IFields
              Table := Tables.TableFromClass(Pessoa);
              // ↑ Internamente faz: Parser.GetTableName(TPessoa) → retorna 'admcore_pessoa'
              
              // 4. Acessar campos dinamicamente (sem precisar declarar propriedades!)
              Table.Fields('tipopessoa').SetValue('F');
              Table.Fields('nome').SetValue('JOÃO SILVA');
              Table.Fields('cpfcnpj').SetValue('123.456.789-00');
              Table.Fields('tipo').SetValue('1');
              Table.Fields('substituto_trib_iss').SetValue('false');
              // ✨ Todos os 28 campos estão disponíveis dinamicamente!
              // Table.Fields('nomefantasia').SetValue('...');
              // Table.Fields('sexo').SetValue('M');
              // etc.
              
              // 5. Gerar SQL com todos os campos
              ShowMessage(Table.GenerateInsertSQLOptimized);
              
              Pessoa.Free;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.3. Conexão Manual (Sem Attributes)</h4>
            <p>Conectar manualmente ao banco <code>dbsgp</code> e carregar a estrutura da tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

var
  Connection: IConnection;
  Tables: ITables;
  Table: ITable;
begin
  // 1. Configuração manual para banco dbsgp
  Connection := TDatabase.New
    .Engine(teFireDAC)
    .DatabaseType(dtPostgreSQL)
    .Host('201.87.244.234')
    .Port(5432)
    .Database('dbsgp')
    .Schema('public')
    .Username('postgres')
    .Password('postmy')
    .Connect;
  
  // 2. Carregar estrutura do banco (mapeia todas as tabelas e campos)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
  
  // 3. Acessar tabela admcore_pessoa (já mapeada com todos os campos)
  Table := Tables.Table('admcore_pessoa');
  
  // 4. Usar a tabela - campos já estão mapeados do banco
  Table.Fields('tipopessoa').SetValue('F')
    .Fields('nome').SetValue('JOÃO SILVA')
    .Fields('cpfcnpj').SetValue('123.456.789-00')
    .Fields('tipo').SetValue('1')
    .Fields('substituto_trib_iss').SetValue('false');
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.4. Conexão Manual (Com Attributes)</h4>
            <p>Conectar manualmente ao banco <code>dbsgp</code> e usar Attributes para mapear a classe <code>TPessoa</code> (mesma operação do 1.3, mas usando Attributes). <strong>✨ AUTOMATIZAÇÃO:</strong> Você não precisa declarar campos privados! O sistema carrega TODOS os campos dinamicamente do banco:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

{$M+}  // Habilita RTTI para Attributes
type
  { ✨ AUTOMATIZAÇÃO: Você NÃO precisa declarar campos privados!
    O sistema carrega TODOS os campos dinamicamente do banco.
    Attributes são apenas para mapeamento (nome da tabela), não para declaração de campos. }
  [Table('admcore_pessoa')]
  [Schema('public')]
  TPessoa = class
    { ✨ Não precisa declarar FId, FNome, etc.!
      Todos os campos são carregados dinamicamente do banco em memória. }
  end;

var
  Connection: IConnection;
  Tables: ITables;
  Pessoa: TPessoa;
  Table: ITable;
begin
  // 1. Configuração manual para banco dbsgp
  Connection := TDatabase.New
    .Engine(teFireDAC)
    .DatabaseType(dtPostgreSQL)
    .Host('201.87.244.234')
    .Port(5432)
    .Database('dbsgp')
    .Schema('public')
    .Username('postgres')
    .Password('postmy')
    .Connect;
  
  // 2. Carregar estrutura do banco (mapeia todas as tabelas e campos)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
  
  // 3. Usar Attributes apenas para identificar a tabela
  Pessoa := TPessoa.Create;
  
  // ✨ AUTOMATIZAÇÃO: TableFromClass() lê o Attribute [Table('admcore_pessoa')]
  // da classe TPessoa via RTTI e identifica qual tabela usar.
  // Depois carrega TODOS os 28 campos do banco dinamicamente.
  // Os campos são armazenados em memória na ITable/IFields
  Table := Tables.TableFromClass(Pessoa);
  // ↑ Internamente faz: Parser.GetTableName(TPessoa) → retorna 'admcore_pessoa'
  
  // 4. Acessar campos dinamicamente (sem precisar declarar propriedades!)
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
  Table.Fields('tipo').SetValue('1');
  Table.Fields('substituto_trib_iss').SetValue('false');
  // ✨ Todos os 28 campos estão disponíveis dinamicamente!
  
  // 5. Gerar SQL com todos os campos
  ShowMessage(Table.GenerateInsertSQLOptimized);
  
  Pessoa.Free;
end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">2. Carregamento de Estrutura do Banco</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.1. Carregar Todas as Tabelas (Sem Attributes)</h4>
            <p>Carrega a estrutura completa do banco <code>dbsgp</code>, incluindo a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

var
  Tables: ITables;
  Table: ITable;
begin
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;  // Carrega todas as tabelas e campos automaticamente
    
  // Listar tabelas
  var tableNames := Tables.GetTablesNames;
  for var name in tableNames do
    WriteLn(name);
    
  // Acessar tabela admcore_pessoa
  Table := Tables.Table('admcore_pessoa');
  if Assigned(Table) then
  begin
    WriteLn('Tabela: ' + Table.TableName);
    WriteLn('Campos: ' + IntToStr(Table.Fields.FieldsCount));
  end;
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.2. Carregar Todas as Tabelas (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}  // Habilita RTTI para Attributes
type
              { ✨ AUTOMATIZAÇÃO: Você NÃO precisa declarar campos privados!
                O sistema carrega TODOS os campos dinamicamente do banco.
                Attributes são apenas para mapeamento (nome da tabela). }
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
                { ✨ Classe vazia! Não precisa declarar FId, FNome, etc.
                  Todos os campos são carregados dinamicamente do banco. }
              end;

var
              Tables: ITables;
              Table: ITable;
            begin
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;  // Carrega estrutura do banco
              
              // ✨ AUTOMATIZAÇÃO: TableFromClass() faz TUDO automaticamente:
              // 1. Lê o Attribute [Table('admcore_pessoa')] via RTTI
              // 2. Identifica qual tabela usar
              // 3. Carrega TODOS os 28 campos dinamicamente do banco
              // NÃO precisa chamar LoadFromClass() antes - é redundante!
              Table := Tables.TableFromClass(TPessoa);
              if Assigned(Table) then
              begin
                WriteLn('Tabela carregada: ' + Table.TableName);
                WriteLn('Total de campos: ' + IntToStr(Table.Fields.FieldsCount));
                // ✨ Acessar campos dinamicamente
                // Table.Fields('nome').SetValue('João');
              end;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.3. Carregar Tabela Específica (Sem Attributes)</h4>
            <p>Carrega apenas a estrutura da tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Tables: ITables;
              Table: ITable;
            begin
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadTables;  // Carrega apenas nomes das tabelas
                
              // Carregar campos da tabela admcore_pessoa
              Tables.LoadTableFields('admcore_pessoa');
              
              // Acessar tabela
              Table := Tables.Table('admcore_pessoa');
              if Assigned(Table) then
              begin
                WriteLn('Tabela: ' + Table.TableName);
                WriteLn('Total de campos: ' + IntToStr(Table.Fields.FieldsCount));
                // Listar alguns campos
                WriteLn('Campo id: ' + Table.Fields.GetFields('id').Column);
                WriteLn('Campo nome: ' + Table.Fields.GetFields('nome').Column);
                WriteLn('Campo cpfcnpj: ' + Table.Fields.GetFields('cpfcnpj').Column);
              end;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.4. Carregar Tabela Específica (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}  // Habilita RTTI para Attributes
type
              { ✨ AUTOMATIZAÇÃO: Você NÃO precisa declarar campos privados!
                O sistema carrega TODOS os campos dinamicamente do banco.
                Attributes são apenas para mapeamento (nome da tabela). }
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
                { ✨ Classe vazia! Não precisa declarar FId, FNome, etc.
                  Todos os campos são carregados dinamicamente do banco. }
              end;

var
              Tables: ITables;
              Table: ITable;
            begin
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;  // Carrega estrutura do banco
              
              // ✨ AUTOMATIZAÇÃO: TableFromClass() faz TUDO automaticamente:
              // 1. Lê o Attribute [Table('admcore_pessoa')] via RTTI
              // 2. Identifica qual tabela usar
              // 3. Carrega TODOS os 28 campos dinamicamente do banco
              // NÃO precisa chamar LoadFromClass() antes - é redundante!
              Table := Tables.TableFromClass(TPessoa);
              if Assigned(Table) then
              begin
                WriteLn('Tabela: ' + Table.TableName);
                WriteLn('Total de campos: ' + IntToStr(Table.Fields.FieldsCount));
                // ✨ Acessar campos dinamicamente (sem precisar declarar propriedades!)
                Table.Fields('nome').SetValue('João');
                Table.Fields('cpfcnpj').SetValue('123.456.789-00');
              end;
            end;</code></pre>
            
            <div style="background: #fff3e0; border-left: 4px solid #ff9800; padding: 15px; margin: 20px 0; border-radius: 4px;">
                <strong style="color: #e65100;">⚠️ Nota sobre LoadFromClass() vs TableFromClass():</strong>
                <p style="margin-top: 10px; color: #e65100;">
                    <strong>LoadFromClass(TPessoa)</strong> cria a tabela a partir dos Attributes da classe (sem carregar campos do banco).<br/>
                    <strong>TableFromClass(TPessoa)</strong> faz tudo: lê Attributes, identifica tabela, e carrega TODOS os campos do banco automaticamente.<br/>
                    <strong>Portanto, não é necessário chamar LoadFromClass() antes de TableFromClass() - é redundante!</strong>
                </p>
            </div>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">3. Sistema de Attributes (RTTI) - Mapeamento Declarativo</h3>
            
            <p style="margin-top: 15px;">O Database ORM v2.0 suporta <strong>mapeamento declarativo</strong> usando Attributes (RTTI), permitindo mapear classes Pascal diretamente para tabelas do banco de dados.</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.1. Configuração em ORM.Defines.inc</h4>
            <p>Para habilitar o suporte a Attributes, edite o arquivo <code>ORM.Defines.inc</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>{===============================================================================
  SISTEMA DE ATTRIBUTES (RTTI) - MAPEAMENTO DECLARATIVO
  ======================================================
  Habilita suporte a Attributes para mapeamento declarativo de classes.
  
  Requisitos:
  - Delphi XE7+ ou FPC 3.2.2+
  - RTTI habilitado nas classes ({$M+} ou {$TYPEINFO ON})
  
  Se desabilitado, métodos que usam Attributes retornarão erro informativo.
===============================================================================}

// Descomente para habilitar suporte a Attributes:
{$DEFINE USE_ATTRIBUTES}

{$IF NOT DEFINED(USE_ATTRIBUTES)}
  {$MESSAGE HINT 'Database ORM: Suporte a Attributes desabilitado.'}
  {$MESSAGE HINT 'Database ORM: Você ainda pode usar o sistema manual sem Attributes.'}
{$ELSE}
  {$MESSAGE HINT 'Database ORM: Suporte a Attributes habilitado.'}
  {$MESSAGE HINT 'Database ORM: Você pode usar [Table], [Field], etc. em suas classes.'}
{$ENDIF}</code></pre>
            
            <div style="background: #e8f5e9; border-left: 4px solid #4caf50; padding: 15px; margin: 20px 0; border-radius: 4px;">
                <strong style="color: #2e7d32;">💡 Estratégia 3: Híbrida com Escolha em Runtime (Recomendada)</strong>
                <p style="margin-top: 10px; color: #1b5e20;">O sistema implementa uma <strong>estratégia híbrida</strong> que combina:</p>
                <ul style="margin-left: 20px; margin-top: 10px; color: #1b5e20;">
                    <li><strong>Compilação condicional:</strong> A diretiva <code>{$DEFINE USE_ATTRIBUTES}</code> controla se o código está compilado</li>
                    <li><strong>Escolha em runtime:</strong> Mesmo com <code>USE_ATTRIBUTES</code> habilitado, você pode escolher usar ou não Attributes</li>
                    <li><strong>Detecção automática:</strong> Métodos que detectam se a classe tem Attributes e usam automaticamente</li>
                    <li><strong>Métodos explícitos:</strong> Métodos que forçam uso de Attributes ou sistema manual</li>
                </ul>
            </div>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.2. Definindo Classes com Attributes</h4>
            <p>Primeiro, defina sua classe com os Attributes necessários. <strong>✨ AUTOMATIZAÇÃO:</strong> Você <strong>NÃO precisa declarar campos privados</strong>! O sistema carrega TODOS os campos dinamicamente do banco. Attributes são apenas para mapeamento (identificar qual tabela usar). Exemplo usando a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

{$M+}  // Habilita RTTI para Attributes

type
  { ✨ AUTOMATIZAÇÃO: Você NÃO precisa declarar campos privados!
    O sistema carrega TODOS os 28 campos dinamicamente do banco em memória.
    
    📌 ONDE DEFINE A TABELA?
    O Attribute [Table('admcore_pessoa')] define qual tabela será usada!
    O Attribute [Schema('public')] define o schema (opcional).
    
    Quando você chama TableFromClass(Pessoa), o sistema:
    1. Lê o Attribute [Table('admcore_pessoa')] via RTTI
    2. Identifica que deve usar a tabela 'admcore_pessoa'
    3. Carrega TODOS os campos dessa tabela do banco automaticamente
    4. Armazena os campos em memória na ITable/IFields
    
    Todos os campos são acessados dinamicamente via Table.Fields('nome_do_campo'). }
  [Table('admcore_pessoa')]  // ← AQUI define qual tabela será usada!
  [Schema('public')]          // ← Schema (opcional)
  TPessoa = class
    { ✨ Classe vazia! Não precisa declarar FId, FNome, etc.
      Todos os campos são carregados dinamicamente do banco quando usar TableFromClass().
      Os campos ficam armazenados em memória na ITable/IFields. }
  end;</code></pre>
            
            <div style="background: #e3f2fd; border-left: 4px solid #2196f3; padding: 15px; margin: 20px 0; border-radius: 4px;">
                <strong style="color: #1565c0;">💡 Como Funciona:</strong>
                <ul style="margin-left: 20px; margin-top: 10px; color: #1565c0;">
                    <li><strong>Attributes [Table] e [Schema]:</strong> Apenas identificam qual tabela usar</li>
                    <li><strong>Campos dinâmicos:</strong> Todos os campos são carregados do banco e armazenados em memória na <code>ITable/IFields</code></li>
                    <li><strong>Acesso dinâmico:</strong> Use <code>Table.Fields('nome').SetValue('João')</code> para acessar qualquer campo</li>
                    <li><strong>Sem declaração:</strong> Não precisa declarar propriedades ou campos privados na classe</li>
                </ul>
            </div>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.3. Uso com Detecção Automática (Recomendado)</h4>
            <p>O método <code>TableFromClass()</code> detecta automaticamente se a classe tem Attributes e carrega TODOS os campos dinamicamente do banco:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

var
  Tables: ITables;
  Table: ITable;
  Pessoa: TPessoa;
begin
  // 1. Criar instância (classe vazia, sem campos declarados)
  Pessoa := TPessoa.Create;
  
  // 2. Carregar estrutura do banco
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;
  
  // 3. Detecção automática: usa Attributes para identificar tabela
  // ✨ Carrega TODOS os 28 campos dinamicamente do banco
  Table := Tables.TableFromClass(Pessoa);
  
  // 4. Acessar campos dinamicamente (sem precisar declarar propriedades!)
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
  Table.Fields('tipo').SetValue('1');
  Table.Fields('substituto_trib_iss').SetValue('false');
  // ✨ Todos os 28 campos estão disponíveis dinamicamente!
  
  Pessoa.Free;
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.4. Forçar Uso de Attributes</h4>
            <p>Para garantir que Attributes sejam usados (retorna erro se não tiver):</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>// Força uso de Attributes - retorna erro se classe não tiver Attributes
Table := Tables.TableFromClassWithAttributes(Pessoa);</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.5. Forçar Sistema Manual (Ignorar Attributes)</h4>
            <p>Para usar o sistema manual mesmo que a classe tenha Attributes:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>// Ignora Attributes e usa sistema manual
Table := Tables.Table('admcore_pessoa')
  .TableFromClassManual(Pessoa)  // Ignora Attributes
  .Fields('nome').SetValue('JOÃO SILVA')
  .Fields('cpfcnpj').SetValue('123.456.789-00')
  .Fields('tipopessoa').SetValue('F')
  .Fields('tipo').SetValue('1')
  .Fields('substituto_trib_iss').SetValue('false');</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.6. Verificar se Classe tem Attributes</h4>
            <p>Antes de usar, você pode verificar se a classe tem Attributes:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>if Tables.HasAttributes(TPessoa) then
begin
  // Classe tem Attributes - usar mapeamento declarativo
  Table := Tables.TableFromClassWithAttributes(Pessoa);
end
else
begin
  // Classe não tem Attributes - usar sistema manual
  Table := Tables.Table('admcore_pessoa')
    .Fields('nome').SetValue('JOÃO SILVA')
    .Fields('cpfcnpj').SetValue('123.456.789-00')
    .Fields('tipopessoa').SetValue('F')
    .Fields('tipo').SetValue('1')
    .Fields('substituto_trib_iss').SetValue('false');
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.7. Carregar Valores de Instância</h4>
            <p>Com campos dinâmicos, você acessa diretamente via <code>Table.Fields()</code> (não precisa de propriedades na classe):</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  Table: ITable;
  Pessoa: TPessoa;
begin
  // 1. Criar instância (classe vazia, sem propriedades)
  Pessoa := TPessoa.Create;
  
  // 2. Carregar tabela com Attributes (identifica tabela)
  // ✨ Todos os 28 campos são carregados dinamicamente do banco
  Table := Tables.TableFromClass(Pessoa);
  
  // 3. Acessar campos dinamicamente (sem precisar declarar propriedades!)
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
  Table.Fields('tipo').SetValue('1');
  Table.Fields('substituto_trib_iss').SetValue('false');
  // ✨ Todos os 28 campos estão disponíveis dinamicamente!
  
  Pessoa.Free;
end;</code></pre>
            
            <div style="background: #fff3e0; border-left: 4px solid #ff9800; padding: 15px; margin: 20px 0; border-radius: 4px;">
                <strong style="color: #e65100;">⚠️ Importante:</strong>
                <ul style="margin-left: 20px; margin-top: 10px; color: #e65100;">
                    <li>Se <code>USE_ATTRIBUTES</code> não estiver definido em <code>ORM.Defines.inc</code>, os métodos retornarão erro informativo</li>
                    <li>Mesmo com <code>USE_ATTRIBUTES</code> habilitado, você pode escolher não usar Attributes em runtime</li>
                    <li>O sistema manual (Fields/Table/Tables) sempre funciona, independente de Attributes</li>
                    <li>Attributes requerem RTTI habilitado nas classes (<code>{$M+}</code> ou <code>{$TYPEINFO ON}</code>)</li>
                </ul>
            </div>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">4. Trabalhando com Tabelas e Campos</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">4.1. Acessar Tabela (Sem Attributes)</h4>
            <p>O sistema carrega automaticamente a estrutura do banco. Você não precisa criar campos manualmente:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

var
              Tables: ITables;
              Table: ITable;
            begin
              // 1. Carregar estrutura do banco (mapeia todas as tabelas e campos)
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;  // ✨ Carrega TODAS as tabelas e campos automaticamente
              
              // 2. Acessar tabela admcore_pessoa (já mapeada com todos os campos)
              Table := Tables.Table('admcore_pessoa');
              
              // 3. Apenas definir valores - os campos já existem!
              Table.Fields('tipopessoa').SetValue('F')
                .Fields('nome').SetValue('JOÃO SILVA')
                .Fields('cpfcnpj').SetValue('123.456.789-00')
                .Fields('tipo').SetValue('1')
                .Fields('substituto_trib_iss').SetValue('false');
              
              // Não precisa criar Fields manualmente!
              // A estrutura já foi carregada do banco automaticamente
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">4.2. Acessar Tabela (Com Attributes)</h4>
            <p>Usar Attributes para mapear a classe <code>TPessoa</code> para a tabela <code>admcore_pessoa</code> (mesma operação do 4.1, mas usando Attributes). <strong>✨ AUTOMATIZAÇÃO:</strong> O sistema carrega automaticamente TODOS os campos do banco, você só precisa mapear os campos que quer usar na classe:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}
type
              { ✨ AUTOMATIZAÇÃO: Você só precisa mapear os campos que quer usar!
                O sistema carrega automaticamente TODOS os campos do banco.
                Não precisa listar todos os 28 campos da tabela admcore_pessoa! }
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
                { ✨ Você pode adicionar outros campos conforme necessário,
                  mas não precisa mapear todos! O sistema carrega do banco automaticamente. }
              public
                [Field('id'), PrimaryKey, AutoInc]
                property Id: Integer read FId write FId;
                
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
                { ✨ Outros campos da tabela (nomefantasia, sexo, datanasc, etc.)
                  são carregados automaticamente do banco, mesmo sem estar na classe! }
              end;

var
              Tables: ITables;
              Table: ITable;
              Pessoa: TPessoa;
            begin
              // 1. Carregar estrutura do banco (mapeia todas as tabelas e campos)
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
              
              // 2. Usar Attributes para mapear classe para tabela
              Pessoa := TPessoa.Create;
              Pessoa.TipoPessoa := 'F';
              Pessoa.Nome := 'JOÃO SILVA';
              Pessoa.CpfCnpj := '123.456.789-00';
              Pessoa.Tipo := 1;
              Pessoa.SubstitutoTribIss := False;
              
              // ✨ AUTOMATIZAÇÃO: Carrega TODOS os campos do banco automaticamente
              // e mapeia apenas os valores da classe para os campos correspondentes
              Table := Tables.TableFromClass(Pessoa);
              
              // 3. A tabela agora tem TODOS os 28 campos do banco!
              // Mas apenas os campos mapeados na classe têm valores
              // Você pode acessar qualquer campo: Table.Fields('nomefantasia'), etc.
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">4.3. Definir Valores nos Campos (Sem Attributes)</h4>
            <p>Exemplo definindo valores na tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Tables: ITables;
              Table: ITable;
            begin
              // Acessar tabela e definir valores (Fluent API)
              Table := Tables.Table('admcore_pessoa')
                .Fields('tipopessoa').SetValue('F')
                .Fields('nome').SetValue('JOÃO SILVA')
                .Fields('cpfcnpj').SetValue('123.456.789-00')
                .Fields('tipo').SetValue('1')
                .Fields('substituto_trib_iss').SetValue('false');
                
              // Verificar se há alterações
              if Table.HasChanges then
                WriteLn('Tabela possui campos alterados');
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">4.4. Definir Valores nos Campos (Com Attributes)</h4>
            <p>Exemplo usando Attributes para definir valores na tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}
type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
              public
                [Field('id'), PrimaryKey, AutoInc]
                property Id: Integer read FId write FId;
                
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
              end;

var
              Tables: ITables;
              Table: ITable;
              Pessoa: TPessoa;
            begin
              Pessoa := TPessoa.Create;
              Pessoa.TipoPessoa := 'F';
              Pessoa.Nome := 'JOÃO SILVA';
              Pessoa.CpfCnpj := '123.456.789-00';
              Pessoa.Tipo := 1;
              Pessoa.SubstitutoTribIss := False;
              
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .DatabaseTypes(dtPostgreSQL);
              
              // Usando Attributes - carrega valores automaticamente da instância
              Table := Tables.TableFromClass(Pessoa);
              
              // Verificar se há alterações
              if Table.HasChanges then
                WriteLn('Tabela possui campos alterados');
                
              Pessoa.Free;
            end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">5. Geração de SQL</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">5.1. SQL INSERT Otimizado (Sem Attributes)</h4>
            <p>Exemplo gerando INSERT para a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Table: ITable;
              SQL: string;
            begin
              Table := Tables.Table('admcore_pessoa')
                .Fields('tipopessoa').SetValue('F')
                .Fields('nome').SetValue('JOÃO SILVA')
                .Fields('cpfcnpj').SetValue('123.456.789-00')
                .Fields('tipo').SetValue('1')
                .Fields('substituto_trib_iss').SetValue('false');
                
              // Gera INSERT apenas com campos alterados
              SQL := Table.GenerateInsertSQLOptimized;
              // Resultado: INSERT INTO public.admcore_pessoa (tipopessoa, nome, cpfcnpj, tipo, substituto_trib_iss) VALUES ('F', 'JOÃO SILVA', '123.456.789-00', 1, false)
              
              // Executar SQL
              Connection.ExecuteCommand(SQL);
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">5.2. SQL INSERT Otimizado (Com Attributes)</h4>
            <p>Exemplo gerando INSERT usando Attributes para a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}
type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
              public
                [Field('id'), PrimaryKey, AutoInc]
                property Id: Integer read FId write FId;
                
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
              end;

var
              Pessoa: TPessoa;
              Table: ITable;
              SQL: string;
            begin
              Pessoa := TPessoa.Create;
              Pessoa.TipoPessoa := 'F';
              Pessoa.Nome := 'JOÃO SILVA';
              Pessoa.CpfCnpj := '123.456.789-00';
              Pessoa.Tipo := 1;
              Pessoa.SubstitutoTribIss := False;
              
              // Usando Attributes - cria tabela automaticamente
              Table := Tables.TableFromClass(Pessoa);
              
              // Gera INSERT apenas com campos alterados
              SQL := Table.GenerateInsertSQLOptimized;
              // Resultado: INSERT INTO public.admcore_pessoa (tipopessoa, nome, cpfcnpj, tipo, substituto_trib_iss) VALUES ('F', 'JOÃO SILVA', '123.456.789-00', 1, false)
              
              // Executar SQL
              Connection.ExecuteCommand(SQL);
              
              Pessoa.Free;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">5.3. SQL UPDATE Otimizado (Sem Attributes)</h4>
            <p>Exemplo gerando UPDATE para a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Table: ITable;
              SQL: string;
            begin
              Table := Tables.Table('admcore_pessoa')
                .Fields('id').SetValue('1')  // Primary Key
                .Fields('nome').SetValue('JOÃO SILVA ATUALIZADO');
                
              // Gera UPDATE apenas com campos alterados
              SQL := Table.GenerateUpdateSQLOptimized;
              // Resultado: UPDATE public.admcore_pessoa SET nome = 'JOÃO SILVA ATUALIZADO' WHERE id = 1
              
              // Executar SQL
              Connection.ExecuteCommand(SQL);
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">5.4. SQL UPDATE Otimizado (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

type
              [Table('admcore_pessoa')]
              [Schema('public')]
              [Schema('public')]
              TUsuario = class
              private
                FId: Integer;
                FNome: string;
              public
                [Field('id'), PrimaryKey]
                property Id: Integer read FId write FId;
                
                [Field('nome')]
                property Nome: string read FNome write FNome;
              end;

var
              Usuario: TUsuario;
              Table: ITable;
              SQL: string;
            begin
              Pessoa := TPessoa.Create;
              Pessoa.Id := 1;  // Primary Key
              Pessoa.Nome := 'JOÃO SILVA ATUALIZADO';
              Pessoa.TipoPessoa := 'F';
              Pessoa.CpfCnpj := '123.456.789-00';
              Pessoa.Tipo := 1;
              Pessoa.SubstitutoTribIss := False;
              
              // Usando Attributes - carrega valores da instância
              Table := Tables.TableFromClass(Pessoa);
              
              // Gera UPDATE apenas com campos alterados
              SQL := Table.GenerateUpdateSQLOptimized;
              // Resultado: UPDATE public.admcore_pessoa SET nome = 'JOÃO SILVA ATUALIZADO' WHERE id = 1
              
              // Executar SQL
              Connection.ExecuteCommand(SQL);
              
              Pessoa.Free;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">5.5. Cláusula WHERE por Primary Key (Sem Attributes)</h4>
            <p>Exemplo gerando WHERE para a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Table: ITable;
              WhereClause: string;
            begin
              Table := Tables.Table('admcore_pessoa')
                .Fields('id').SetValue('1')
                .Fields('nome').SetValue('JOÃO SILVA');
                
              // Gera cláusula WHERE baseada nas Primary Keys
              WhereClause := Table.GenerateWhereByPrimaryKey;
              // Resultado: WHERE id = 1
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">5.6. Cláusula WHERE por Primary Key (Com Attributes)</h4>
            <p>Exemplo gerando WHERE usando Attributes para a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

{$M+}
type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FNome: string;
              public
                [Field('id'), PrimaryKey]
                property Id: Integer read FId write FId;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
              end;

var
              Pessoa: TPessoa;
              Table: ITable;
              WhereClause: string;
            begin
              Pessoa := TPessoa.Create;
              Pessoa.Id := 1;
              Pessoa.Nome := 'JOÃO SILVA';
              
              // Usando Attributes - Primary Key detectada automaticamente
              Table := Tables.TableFromClass(Pessoa);
              
              // Gera cláusula WHERE baseada nas Primary Keys (detectadas via Attributes)
              WhereClause := Table.GenerateWhereByPrimaryKey;
              // Resultado: WHERE id = 1
              
              Pessoa.Free;
            end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">6. Auditoria Automática</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">6.1. Auditoria Automática (Sem Attributes)</h4>
            <p>Exemplo de auditoria na tabela <code>admcore_pessoa</code> (campo <code>data_alteracao</code>):</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Table: ITable;
            begin
              Table := Tables.Table('admcore_pessoa')
                .DatabaseTypes(dtPostgreSQL)
                .AuditFields(True)  // Habilita auditoria
                .FieldDateUpdated('data_alteracao')  // Campo existente na tabela
                .Fields('nome').SetValue('JOÃO SILVA')
                .Fields('tipopessoa').SetValue('F')
                .Fields('cpfcnpj').SetValue('123.456.789-00')
                .Fields('tipo').SetValue('1')
                .Fields('substituto_trib_iss').SetValue('false');
                
              // Ao gerar INSERT, campos de auditoria são preenchidos automaticamente
              var SQL := Table.GenerateInsertSQLOptimized;
              // Inclui: data_alteracao = NOW()
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">6.2. Auditoria Automática (Com Attributes)</h4>
            <p>Exemplo de auditoria usando Attributes na tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

{$M+}
type
  [Table('admcore_pessoa')]
  [Schema('public')]
  TPessoa = class
  private
    FId: Integer;
    FTipoPessoa: string;
    FNome: string;
    FCpfCnpj: string;
    FTipo: Integer;
    FSubstitutoTribIss: Boolean;
    FDataAlteracao: TDateTime;
  public
    [Field('id'), PrimaryKey, AutoInc]
    property Id: Integer read FId write FId;
    
    [Field('tipopessoa'), NotNull, Size(2)]
    property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
    
    [Field('nome'), NotNull, Size(200)]
    property Nome: string read FNome write FNome;
    
    [Field('cpfcnpj'), NotNull, Size(20)]
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    
    [Field('tipo'), NotNull]
    property Tipo: Integer read FTipo write FTipo;
    
    [Field('substituto_trib_iss'), NotNull]
    property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
    
    [Field('data_alteracao'), AuditDateUpdated]
    property DataAlteracao: TDateTime read FDataAlteracao write FDataAlteracao;
  end;

var
  Pessoa: TPessoa;
  Table: ITable;
begin
  Pessoa := TPessoa.Create;
  Pessoa.Nome := 'JOÃO SILVA';
  Pessoa.TipoPessoa := 'F';
  Pessoa.CpfCnpj := '123.456.789-00';
  Pessoa.Tipo := 1;
  Pessoa.SubstitutoTribIss := False;
  
  // Usando Attributes - campos de auditoria são detectados automaticamente
  Table := Tables.TableFromClass(Pessoa)
    .AuditFields(True);  // Habilita auditoria
  
  // Ao gerar INSERT, campos de auditoria são preenchidos automaticamente
  var SQL := Table.GenerateInsertSQLOptimized;
  // Inclui: data_alteracao = NOW()
  
  Pessoa.Free;
end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">7. Validação de Campos</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">7.1. Validação de Campos (Sem Attributes)</h4>
            <p>Exemplo de validação na tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Table: ITable;
            begin
              Table := Tables.Table('admcore_pessoa')
                .Fields('tipopessoa').SetValue('F')  // Campo obrigatório
                .Fields('nome').SetValue('JOÃO SILVA')  // Campo obrigatório
                .Fields('cpfcnpj').SetValue('123.456.789-00')  // Campo obrigatório
                .Fields('tipo').SetValue('1')  // Campo obrigatório
                .Fields('substituto_trib_iss').SetValue('false');  // Campo obrigatório
                
              try
                // Valida campos NOT NULL
                Table.ValidateNotNullFields;
                
                // Se passar, pode gerar SQL
                var SQL := Table.GenerateInsertSQLOptimized;
              except
                on E: EDatabaseValidationException do
                  WriteLn('Erro de validação: ' + E.Message);
              end;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">7.2. Validação de Campos (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
              public
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
              end;

var
              Pessoa: TPessoa;
              Table: ITable;
begin
              Pessoa := TPessoa.Create;
              Pessoa.Nome := 'JOÃO SILVA';  // Campo obrigatório (detectado via [NotNull])
              Pessoa.TipoPessoa := 'F';  // Campo obrigatório
              Pessoa.CpfCnpj := '123.456.789-00';  // Campo obrigatório
              Pessoa.Tipo := 1;  // Campo obrigatório
              Pessoa.SubstitutoTribIss := False;  // Campo obrigatório
              
              // Usando Attributes - validação automática baseada em [NotNull]
              Table := Tables.TableFromClass(Pessoa);
              
              try
                // Valida campos NOT NULL (detectados via Attributes)
                Table.ValidateNotNullFields;
                
                // Se passar, pode gerar SQL
                var SQL := Table.GenerateInsertSQLOptimized;
              except
                on E: EDatabaseValidationException do
                  WriteLn('Erro de validação: ' + E.Message);
              end;
              
              Pessoa.Free;
            end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">8. Serialização JSON</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">8.1. Converter Tabela para JSON (Sem Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Table: ITable;
              JSON: string;
            begin
              Table := Tables.Table('admcore_pessoa')
                .Fields('id').SetValue('1')
                .Fields('tipopessoa').SetValue('F')
                .Fields('nome').SetValue('JOÃO SILVA')
                .Fields('cpfcnpj').SetValue('123.456.789-00')
                .Fields('tipo').SetValue('1')
                .Fields('substituto_trib_iss').SetValue('false');
                
              // Converter para JSON
              JSON := Table.ToJSON;
              // Resultado: {"id":"1","tipopessoa":"F","nome":"JOÃO SILVA","cpfcnpj":"123.456.789-00","tipo":1,"substituto_trib_iss":false}
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">8.2. Converter Tabela para JSON (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
              public
                [Field('id'), PrimaryKey]
                property Id: Integer read FId write FId;
                
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
              end;

var
              Pessoa: TPessoa;
              Table: ITable;
              JSON: string;
            begin
              Pessoa := TPessoa.Create;
              Pessoa.Id := 1;
              Pessoa.TipoPessoa := 'F';
              Pessoa.Nome := 'JOÃO SILVA';
              Pessoa.CpfCnpj := '123.456.789-00';
              Pessoa.Tipo := 1;
              Pessoa.SubstitutoTribIss := False;
              
              // Usando Attributes - carrega valores da instância
              Table := Tables.TableFromClass(Pessoa);
              
              // Converter para JSON
              JSON := Table.ToJSON;
              // Resultado: {"id":1,"tipopessoa":"F","nome":"JOÃO SILVA","cpfcnpj":"123.456.789-00","tipo":1,"substituto_trib_iss":false}
              
              Pessoa.Free;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">8.3. Carregar Tabela de JSON (Sem Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
  Table: ITable;
  JSON: string;
begin
  JSON := '{"id":1,"tipopessoa":"F","nome":"JOÃO SILVA","cpfcnpj":"123.456.789-00","tipo":1,"substituto_trib_iss":false}';
  
  Table := Tables.Table('admcore_pessoa')
    .FromJSON(JSON);  // Carrega valores do JSON
    
  // Agora pode gerar SQL
  var SQL := Table.GenerateInsertSQLOptimized;
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">8.4. Carregar Tabela de JSON (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
              public
                [Field('id'), PrimaryKey]
                property Id: Integer read FId write FId;
                
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
              end;

var
              Pessoa: TPessoa;
              Table: ITable;
              JSON: string;
            begin
              JSON := '{"id":1,"tipopessoa":"F","nome":"JOÃO SILVA","cpfcnpj":"123.456.789-00","tipo":1,"substituto_trib_iss":false}';
              
              // Carrega JSON e depois converte para instância usando Attributes
              Table := Tables.TableFromClass(TPessoa)
                .FromJSON(JSON);  // Carrega valores do JSON
              
              // Ou criar instância e carregar valores
              Pessoa := TPessoa.Create;
              Table := Tables.TableFromClass(Pessoa)
                .FromJSON(JSON);  // Carrega valores do JSON na instância
              
              // Agora pode gerar SQL
              var SQL := Table.GenerateInsertSQLOptimized;
              
              Pessoa.Free;
            end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">9. Transações</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">9.1. Transações (Sem Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>var
              Connection: IConnection;
            begin
              Connection := TDatabase.New
                .FromParameters('database')
                .Connect;
                
              try
                // Iniciar transação
                Connection.BeginTransaction;
                
                // Executar operações
                var Table1 := Tables.Table('admcore_pessoa')
                  .Fields('tipopessoa').SetValue('F')
                  .Fields('nome').SetValue('JOÃO SILVA')
                  .Fields('cpfcnpj').SetValue('123.456.789-00')
                  .Fields('tipo').SetValue('1')
                  .Fields('substituto_trib_iss').SetValue('false')
                  .GenerateInsertSQLOptimized;
                Connection.ExecuteCommand(Table1);
                
                // Exemplo com segunda tabela (se necessário)
                // var Table2 := Tables.Table('outra_tabela')
                //   .Fields('pessoa_id').SetValue('1')
                //   .GenerateInsertSQLOptimized;
                // Connection.ExecuteCommand(Table2);
                
                // Confirmar transação
                Connection.Commit;
              except
                // Reverter em caso de erro
                Connection.Rollback;
                raise;
              end;
            end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">9.2. Transações (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

type
              [Table('admcore_pessoa')]
              [Schema('public')]
              TPessoa = class
              private
                FId: Integer;
                FTipoPessoa: string;
                FNome: string;
                FCpfCnpj: string;
                FTipo: Integer;
                FSubstitutoTribIss: Boolean;
              public
                [Field('id'), PrimaryKey, AutoInc]
                property Id: Integer read FId write FId;
                
                [Field('tipopessoa'), NotNull, Size(2)]
                property TipoPessoa: string read FTipoPessoa write FTipoPessoa;
                
                [Field('nome'), NotNull, Size(200)]
                property Nome: string read FNome write FNome;
                
                [Field('cpfcnpj'), NotNull, Size(20)]
                property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
                
                [Field('tipo'), NotNull]
                property Tipo: Integer read FTipo write FTipo;
                
                [Field('substituto_trib_iss'), NotNull]
                property SubstitutoTribIss: Boolean read FSubstitutoTribIss write FSubstitutoTribIss;
              end;

var
              Connection: IConnection;
              Pessoa: TPessoa;
              Table1: ITable;
            begin
              Connection := TDatabase.New
                .FromParameters('database')
                .Connect;
                
              try
                // Iniciar transação
                Connection.BeginTransaction;
                
                // Criar pessoa usando Attributes
                Pessoa := TPessoa.Create;
                Pessoa.TipoPessoa := 'F';
                Pessoa.Nome := 'JOÃO SILVA';
                Pessoa.CpfCnpj := '123.456.789-00';
                Pessoa.Tipo := 1;
                Pessoa.SubstitutoTribIss := False;
                Table1 := Tables.TableFromClass(Pessoa);
                Connection.ExecuteCommand(Table1.GenerateInsertSQLOptimized);
                
                // Exemplo com segunda tabela (se necessário)
                // var Pessoa2 := TPessoa.Create;
                // ... preencher dados ...
                // var Table2 := Tables.TableFromClass(Pessoa2);
                // Connection.ExecuteCommand(Table2.GenerateInsertSQLOptimized);
                
                // Confirmar transação
                Connection.Commit;
                
                Pessoa.Free;
              except
                // Reverter em caso de erro
                Connection.Rollback;
                raise;
              end;
            end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">10. Exemplo Completo: CRUD de Pessoas</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">10.1. CRUD Completo (Sem Attributes)</h4>
            <p>Exemplo completo de CRUD usando a tabela <code>admcore_pessoa</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
  Database.Interfaces;

procedure ExemploCRUDPessoas;
var
  Connection: IConnection;
  Tables: ITables;
  Table: ITable;
  SQL: string;
begin
  // 1. Conectar ao banco dbsgp
  Connection := TDatabase.New
    .FromParameters('database')
    .Connect;
    
  // 2. Carregar estrutura do banco
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;
    
  // 3. CREATE - Inserir nova pessoa
  Table := Tables.Table('admcore_pessoa')
    .DatabaseTypes(dtPostgreSQL)
    .AuditFields(True)
    .FieldDateUpdated('data_alteracao')
    .Fields('tipopessoa').SetValue('F')
    .Fields('nome').SetValue('JOÃO SILVA')
    .Fields('cpfcnpj').SetValue('123.456.789-00')
    .Fields('tipo').SetValue('1')
    .Fields('substituto_trib_iss').SetValue('false');
    
  SQL := Table.GenerateInsertSQLOptimized;
  Connection.ExecuteCommand(SQL);
  
  // 4. READ - Carregar usuário existente
  var DataSet := Connection.ExecuteQuery('SELECT * FROM usuarios WHERE id = 1');
  try
    if not DataSet.IsEmpty then
    begin
      Table := Tables.Table('usuarios')
        .LoadValuesFromDataSet(DataSet);
        
      var nome := Table.Fields('nome').GetValue;
      var email := Table.Fields('email').GetValue;
    end;
  finally
    DataSet.Free;
  end;
  
  // 5. UPDATE - Atualizar usuário
  Table := Tables.Table('usuarios')
    .Fields('id').SetValue('1')
    .Fields('nome').SetValue('João Silva Atualizado');
    
  SQL := Table.GenerateUpdateSQLOptimized;
  Connection.ExecuteCommand(SQL);
  
  // 6. DELETE - Soft delete (marcar como deletado)
  Table := Tables.Table('usuarios')
    .AuditFields(True)
    .FieldIsDeleted('is_deleted')
    .Fields('id').SetValue('1')
    .Fields('is_deleted').SetValue('true');
    
  SQL := Table.GenerateUpdateSQLOptimized;
  Connection.ExecuteCommand(SQL);
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">10.2. CRUD Completo (Com Attributes)</h4>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses
              Database.Interfaces;

type
              [Table('admcore_pessoa')]
              [Schema('public')]
              [Schema('public')]
              TUsuario = class
              private
                FId: Integer;
                FNome: string;
                FEmail: string;
                FSenha: string;
                FDataCadastro: TDateTime;
                FIsDeleted: Boolean;
              public
                [Field('id'), PrimaryKey, AutoInc]
                property Id: Integer read FId write FId;
                
                [Field('nome'), Required, NotNull]
                property Nome: string read FNome write FNome;
                
                [Field('email')]
                property Email: string read FEmail write FEmail;
                
                [Field('senha')]
                property Senha: string read FSenha write FSenha;
                
                [Field('data_cadastro'), AuditDateCreated]
                property DataCadastro: TDateTime read FDataCadastro write FDataCadastro;
                
                [Field('is_deleted'), AuditIsDeleted]
                property IsDeleted: Boolean read FIsDeleted write FIsDeleted;
              end;

procedure ExemploCRUDComAttributes;
var
              Connection: IConnection;
              Tables: ITables;
              Usuario: TUsuario;
              Table: ITable;
              SQL: string;
              DataSet: TDataSet;
begin
              // 1. Conectar ao banco
              Connection := TDatabase.New
                .FromParameters('database')
                .Connect;
                
              // 2. Carregar estrutura do banco
              Tables := TDatabase.NewTables
                .Connection(Connection.NativeConnection)
                .LoadFromConnection;
                
              // 3. CREATE - Inserir novo usuário usando Attributes
              Usuario := TUsuario.Create;
              Usuario.Nome := 'João Silva';
              Usuario.Email := 'joao@example.com';
              Usuario.Senha := 'hash123';
              
              Table := Tables.TableFromClass(Usuario)
                .AuditFields(True);
              
              SQL := Table.GenerateInsertSQLOptimized;
              Connection.ExecuteCommand(SQL);
              
              // 4. READ - Carregar usuário existente usando Attributes
              DataSet := Connection.ExecuteQuery('SELECT * FROM usuarios WHERE id = 1');
              try
                if not DataSet.IsEmpty then
                begin
                  Usuario := TUsuario.Create;
                  Table := Tables.TableFromClass(Usuario)
                    .LoadValuesFromDataSet(DataSet);
                  
                  // Valores já estão na instância Usuario via Attributes
                  var nome := Usuario.Nome;
                  var email := Usuario.Email;
                end;
              finally
                DataSet.Free;
              end;
              
              // 5. UPDATE - Atualizar usuário usando Attributes
              Usuario := TUsuario.Create;
              Usuario.Id := 1;
              Usuario.Nome := 'João Silva Atualizado';
              
              Table := Tables.TableFromClass(Usuario);
              SQL := Table.GenerateUpdateSQLOptimized;
              Connection.ExecuteCommand(SQL);
              
              // 6. DELETE - Soft delete usando Attributes
              Usuario := TUsuario.Create;
              Usuario.Id := 1;
              Usuario.IsDeleted := True;
              
              Table := Tables.TableFromClass(Usuario)
                .AuditFields(True);
              SQL := Table.GenerateUpdateSQLOptimized;
              Connection.ExecuteCommand(SQL);
              
              Usuario.Free;
            end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">📚 Próximos Passos</h3>
            
            <ul style="margin-left: 20px; margin-top: 10px;">
                <li>Explore a documentação completa de cada unit no menu lateral</li>
                <li>Veja exemplos específicos de cada método na documentação</li>
                <li>Consulte os arquivos de exemplo em <code>src/view/</code></li>
                <li>Leia a proposta de implementação em <code>Analises/PROPOSAL_ATTRIBUTES.md</code></li>
            </ul>
        `
    },
    publicUnitsGuide: {
        title: "Roteiro de Uso - Units Públicas",
        path: "Guia Prático - Units Públicas",
        description: `
            <h2 style="color: #2c3e50; margin-top: 0;">🔓 Roteiro de Uso - Units Públicas (API Externa)</h2>
            
            <div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 15px; margin: 20px 0;">
                <h3 style="color: #2c3e50; margin-top: 0;">📋 O que são as Units Públicas?</h3>
                <p>As <strong>Units Públicas</strong> são os únicos arquivos que você deve usar ao integrar o Database ORM v2.0 em seus projetos. Elas fornecem uma API limpa e estável para acesso ao banco de dados.</p>
                
                <h4 style="color: #2c3e50; margin-top: 15px;">Units Disponíveis:</h4>
                <ul>
                    <li><strong><code>Database.Interfaces.pas</code></strong> - Re-exporta todas as interfaces, tipos, exceções e constantes necessárias</li>
                    <li><strong><code>Database.pas</code></strong> - Factory class (<code>TDatabase</code>) para criar conexões, tabelas, campos, etc.</li>
                </ul>
                
                <h4 style="color: #2c3e50; margin-top: 15px;">⚠️ IMPORTANTE:</h4>
                <p><strong>NÃO use units internas diretamente!</strong> Units como <code>Database.Connetions</code>, <code>Database.Tables</code>, <code>Database.Fields</code>, etc. são internas e podem mudar sem aviso. Use sempre <code>TDatabase.New</code>, <code>TDatabase.NewTables</code>, etc. da unit pública <code>Database.pas</code>.</p>
                
                <h4 style="color: #2c3e50; margin-top: 15px;">✅ O que está implementado:</h4>
                <ul>
                    <li>✅ Factory methods para criar conexões, tabelas, campos</li>
                    <li>✅ Suporte a Attributes (RTTI) para mapeamento declarativo</li>
                    <li>✅ Carregamento automático de estrutura do banco</li>
                    <li>✅ Geração de SQL otimizado (INSERT, UPDATE, DELETE)</li>
                    <li>✅ Validação de campos obrigatórios</li>
                    <li>✅ Auditoria automática</li>
                    <li>✅ Serialização/Deserialização JSON</li>
                    <li>✅ Suporte a múltiplos engines (FireDAC, UniDAC, Zeos, SQLdb)</li>
                    <li>✅ Suporte a múltiplos bancos (PostgreSQL, MySQL, SQL Server, FireBird, SQLite, Access, ODBC)</li>
                </ul>
            </div>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">1. Configuração de Conexão (Usando Units Públicas)</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.1. Conexão via Parameters (Sem Attributes)</h4>
            <p>Conectar ao banco <code>dbsgp</code> usando <strong>APENAS</strong> as units públicas (<code>Database</code> e <code>Database.Interfaces</code>):</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var
  Connection: IConnection;
  Tables: ITables;
  Table: ITable;
begin
  // ✨ APENAS units públicas: Database e Database.Interfaces
  // 1. Conectar ao banco (auto-detecta fonte: INI → JSON → Database)
  Connection := TDatabase.New
    .FromParameters('database')
    .Connect;
  
  // 2. Carregar estrutura do banco (mapeia todas as tabelas e campos)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
  
  // 3. Acessar tabela admcore_pessoa (já mapeada com todos os campos)
  Table := Tables.Table('admcore_pessoa');
  
  // 4. Usar a tabela - campos já estão mapeados do banco
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
  Table.Fields('tipo').SetValue('1');
  Table.Fields('substituto_trib_iss').SetValue('false');
  
  // Não precisa criar campos manualmente!
  // A estrutura foi carregada automaticamente do banco
end;</code></pre>
            <p><strong>⚠️ DIFERENÇA:</strong> Este exemplo usa <code>TDatabase.New</code> e <code>TDatabase.NewTables</code> (units públicas), não <code>TDatabase.New</code> ou <code>TDatabase.NewTables</code> (units internas).</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.2. Conexão via Parameters (Com Attributes)</h4>
            <p>Conectar ao banco <code>dbsgp</code> e usar Attributes para mapear a classe <code>TPessoa</code> para a tabela <code>admcore_pessoa</code> usando <strong>APENAS</strong> units públicas:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>{$IF DEFINED(USE_ATTRIBUTES)}
uses Database, Database.Interfaces;

{$M+}
type
  { ✨ AUTOMATIZAÇÃO: Você NÃO precisa declarar campos privados!
    O sistema carrega TODOS os campos dinamicamente do banco.
    Attributes são apenas para mapeamento (nome da tabela). }
  [Table('admcore_pessoa')]
  [Schema('public')]
  TPessoa = class
    { ✨ Classe vazia! Não precisa declarar FId, FNome, etc.
      Todos os campos são carregados dinamicamente do banco. }
  end;

var
  Connection: IConnection;
  Tables: ITables;
  Pessoa: TPessoa;
  Table: ITable;
begin
  // ✨ APENAS units públicas: Database e Database.Interfaces
  // 1. Conectar ao banco usando TDatabase.New (unit pública)
  Connection := TDatabase.New
    .FromParameters('database')
    .Connect;
  
  // 2. Carregar estrutura do banco usando TDatabase.NewTables (unit pública)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
  
  // 3. Usar Attributes apenas para identificar a tabela
  Pessoa := TPessoa.Create;
  // ✨ AUTOMATIZAÇÃO: Carrega TODOS os 28 campos do banco dinamicamente
  // Os campos são armazenados em memória na ITable/IFields
  Table := Tables.TableFromClass(Pessoa);
  
  // 4. Acessar campos dinamicamente (sem precisar declarar propriedades!)
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
  Table.Fields('tipo').SetValue('1');
  Table.Fields('substituto_trib_iss').SetValue('false');
  // ✨ Todos os 28 campos estão disponíveis dinamicamente!
  
  // 5. Gerar SQL com todos os campos
  ShowMessage(Table.GenerateInsertSQLOptimized);
  Pessoa.Free;
end;
{$ENDIF}</code></pre>
            <p><strong>⚠️ DIFERENÇA:</strong> Este exemplo usa <code>TDatabase.New</code> e <code>TDatabase.NewTables</code> (units públicas), não <code>TDatabase.New</code> ou <code>TDatabase.NewTables</code> (units internas).</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.3. Conexão Manual (Sem Attributes)</h4>
            <p>Conectar manualmente ao banco <code>dbsgp</code> usando <strong>APENAS</strong> units públicas:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var
  Connection: IConnection;
  Tables: ITables;
  Table: ITable;
begin
  // ✨ APENAS units públicas: Database e Database.Interfaces
  // 1. Configuração manual para banco dbsgp usando TDatabase.New (unit pública)
  Connection := TDatabase.New
    .Engine(teFireDAC)
    .DatabaseType(dtPostgreSQL)
    .Host('201.87.244.234')
    .Port(5432)
    .Database('dbsgp')
    .Schema('public')
    .Username('postgres')
    .Password('postmy')
    .Connect;
  
  // 2. Carregar estrutura do banco usando TDatabase.NewTables (unit pública)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;  // ✨ Carrega estrutura automaticamente
  
  // 3. Acessar tabela admcore_pessoa
  Table := Tables.Table('admcore_pessoa');
  
  // 4. Usar a tabela
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">1.4. Conexão Manual (Com Attributes)</h4>
            <p>Conectar manualmente e usar Attributes usando <strong>APENAS</strong> units públicas:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>{$IF DEFINED(USE_ATTRIBUTES)}
uses Database, Database.Interfaces;

{$M+}
type
  [Table('admcore_pessoa')]
  [Schema('public')]
  TPessoa = class
  end;

var
  Connection: IConnection;
  Tables: ITables;
  Pessoa: TPessoa;
  Table: ITable;
begin
  // ✨ APENAS units públicas: Database e Database.Interfaces
  // 1. Configuração manual usando TDatabase.New (unit pública)
  Connection := TDatabase.New
    .Engine(teFireDAC)
    .DatabaseType(dtPostgreSQL)
    .Host('201.87.244.234')
    .Port(5432)
    .Database('dbsgp')
    .Schema('public')
    .Username('postgres')
    .Password('postmy')
    .Connect;
  
  // 2. Carregar estrutura usando TDatabase.NewTables (unit pública)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;
  
  // 3. Usar Attributes
  Pessoa := TPessoa.Create;
  Table := Tables.TableFromClass(Pessoa);
  
  // 4. Acessar campos dinamicamente
  Table.Fields('tipopessoa').SetValue('F');
  Table.Fields('nome').SetValue('JOÃO SILVA');
  Table.Fields('cpfcnpj').SetValue('123.456.789-00');
  
  ShowMessage(Table.GenerateInsertSQLOptimized);
  Pessoa.Free;
end;
{$ENDIF}</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">2. Database.Interfaces - Interfaces e Tipos</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.1. Importando Interfaces e Tipos</h4>
            <p>A unit <code>Database.Interfaces</code> re-exporta todas as interfaces, tipos, exceções e constantes necessárias para uso do Database ORM:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database.Interfaces;

var Connection: IConnection;
var Tables: ITables;
var Table: ITable;
var Fields: IFields;
var Field: IField;</code></pre>
            <p><strong>Nota:</strong> Ao usar <code>Database.Interfaces</code>, você tem acesso a todas as interfaces principais do sistema sem precisar importar units internas.</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.2. Tipos Disponíveis</h4>
            <p>Tipos expostos via <code>Database.Interfaces</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database.Interfaces;

var Engine: TDatabaseEngine;
var DatabaseType: TDatabaseTypes;
var Status: TDatabaseStatus;
var ConnectionData: TConnectionData;

// Exemplos de uso
Engine := teFireDAC;
DatabaseType := dtPostgreSQL;
Status := dsInactive;</code></pre>
            <ul>
                <li><code>TDatabaseEngine</code> - Engine de acesso (teNone, teUnidac, teFireDAC, teZeos)</li>
                <li><code>TDatabaseTypes</code> - Tipo de banco (dtPostgreSQL, dtMySQL, dtSQLServer, etc.)</li>
                <li><code>TDatabaseStatus</code> - Status do banco (dsNone, dsInactive, dsEdit, dsInsert, dsDeleted)</li>
                <li><code>TConnectionData</code> - Dados de conexão (Host, Port, Database, Username, Password, etc.)</li>
            </ul>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">2.3. Exceções Disponíveis</h4>
            <p>Exceções expostas via <code>Database.Interfaces</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database.Interfaces;

try
  // Operação com banco
except
  on E: EDatabaseConnectionException do
    ShowMessage('Erro de conexão: ' + E.Message);
  on E: EDatabaseSQLException do
    ShowMessage('Erro de SQL: ' + E.Message);
  on E: EDatabaseValidationException do
    ShowMessage('Erro de validação: ' + E.Message);
  on E: EDatabaseException do
    ShowMessage('Erro do Database ORM: ' + E.Message);
end;</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">3. Database (Factory Class)</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.1. Criar Conexão</h4>
            <p>Criar uma nova conexão usando a Factory Class <code>TDatabase</code> (unit pública):</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var Connection: IConnection;
Connection := TDatabase.New
  .FromParameters('database')
  .Connect;</code></pre>
            <p><strong>⚠️ IMPORTANTE:</strong> Use apenas <code>Database</code> e <code>Database.Interfaces</code>. Não use units internas como <code>Database.Connetions</code> ou <code>Database.Tables</code>.</p>
            <p><strong>Exemplo completo:</strong></p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var Connection: IConnection;
begin
  // ✨ Usando apenas units públicas: Database e Database.Interfaces
  Connection := TDatabase.New
    .FromParameters('database')
    .Connect;
    
  if Connection.IsConnected then
    ShowMessage('Conectado com sucesso!')
  else
    ShowMessage('Falha na conexão');
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.2. Criar Gerenciador de Tabelas</h4>
            <p>Criar um gerenciador de tabelas usando apenas a unit pública <code>Database</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var Tables: ITables;
Tables := TDatabase.NewTables
  .Connection(Connection.NativeConnection)
  .LoadFromConnection;</code></pre>
            <p><strong>⚠️ IMPORTANTE:</strong> Use <code>TDatabase.NewTables</code> (da unit pública <code>Database</code>), não <code>TDatabase.NewTables</code> (unit interna).</p>
            <p><strong>Exemplo completo:</strong></p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var Connection: IConnection;
var Tables: ITables;
var Table: ITable;
begin
  // 1. Criar conexão usando unit pública Database
  Connection := TDatabase.New
    .FromParameters('database')
    .Connect;
    
  // 2. Criar gerenciador de tabelas usando unit pública Database
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;
    
  // 3. Acessar uma tabela específica
  Table := Tables.Table('admcore_pessoa');
  if Assigned(Table) then
    ShowMessage('Tabela encontrada: ' + Table.TableName);
end;</code></pre>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.3. Criar Tabela Individual</h4>
            <p>Criar uma tabela individual usando apenas as units públicas:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var Fields: IFields;
var Table: ITable;
begin
  // ✨ Usando apenas units públicas: Database e Database.Interfaces
  // 1. Criar container de campos usando TDatabase.NewFields
  Fields := TDatabase.NewFields;
  
  // 2. Adicionar campos usando factory method CreateField() (recomendado)
  // ✅ MELHOR ENCAPSULAMENTO: CreateField() mantém a implementação de Field oculta
  Fields.Add(Fields.CreateField('id', 'INTEGER', False));
  Fields.Add(Fields.CreateField('nome', 'VARCHAR(200)', True));
  Fields.Add(Fields.CreateField('email', 'VARCHAR(100)', True));
  
  // Alternativa: Usar TDatabase.NewField (também válido, mas menos encapsulado)
  // Fields.Add(TDatabase.NewField('id', 'INTEGER', False));
  
  // 3. Criar tabela usando TDatabase.NewTable
  Table := TDatabase.NewTable(Fields, 'usuarios');
  
  ShowMessage('Tabela criada: ' + Table.TableName);
end;</code></pre>
            <p><strong>⚠️ IMPORTANTE:</strong> Todos os métodos usam <code>TDatabase</code> (unit pública), não classes internas como <code>TDatabase.NewFields</code> ou <code>TDatabase.NewTable</code>.</p>
            <p><strong>💡 DICA:</strong> Para criar campos, você pode usar <code>Fields.CreateField()</code> (factory method - melhor encapsulamento) ou <code>TDatabase.NewField</code> (também válido).</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.4. Criar Campos</h4>
            <p>Criar campos individuais usando apenas a unit pública <code>Database</code>:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

var Field: IField;
var Fields: IFields;
begin
  // ✨ Usando factory method CreateField() (recomendado - melhor encapsulamento)
  Fields := TDatabase.NewFields;
  // Método 1: Criar com parâmetros usando CreateField()
  Field := Fields.CreateField('id', 'INTEGER', False);
  
  // Alternativa: Usar TDatabase.NewField (também válido)
  // Field := TDatabase.NewField('id', 'INTEGER', False);
  Field.SetIsPKey(1); // Definir como Primary Key
  
  // Método 2: Criar vazio e configurar depois usando CreateField()
  Field := Fields.CreateField('campo', '', True);
  Field.Column := 'nome';
  Field.Column := 'nome';
  Field.ColumnType := 'VARCHAR(200)';
  Field.isNullBool := True;
  Field.SetToDefault('NULL');
  
  // Método 3: Criar com valor inicial usando CreateField()
  Field := Fields.CreateField('email', 'VARCHAR(100)', True);
  Field.SetValue('usuario@exemplo.com');
  Field.SetAsChanged;
end;</code></pre>
            <p><strong>⚠️ IMPORTANTE:</strong> Use <code>Fields.CreateField()</code> (factory method - recomendado) ou <code>TDatabase.NewField</code> (unit pública), não <code>TDatabase.NewField</code> (unit interna).</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">3.5. Usar Attributes (se habilitado)</h4>
            <p>Criar parsers e mappers de Attributes para mapeamento declarativo:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>{$IF DEFINED(USE_ATTRIBUTES)}
uses Database, Database.Interfaces;

{$M+}
type
  [Table('usuarios')]
  [Schema('public')]
  TUsuario = class
  end;

var Parser: IAttributeParser;
var Mapper: IAttributeMapper;
var Table: ITable;
begin
  // 1. Criar parser de Attributes
  Parser := TDatabase.NewAttributeParser;
  
  // 2. Extrair informações da classe
  var TableName := Parser.GetTableName(TUsuario);
  ShowMessage('Tabela: ' + TableName);
  
  // 3. Criar mapper de Attributes
  Mapper := TDatabase.NewAttributeMapper;
  
  // 4. Mapear classe para ITable
  Table := Mapper.MapClassToTable(TUsuario);
  ShowMessage('Tabela mapeada: ' + Table.TableName);
end;
{$ENDIF}</code></pre>
            
            <h3 style="margin-top: 30px; color: #3498db; border-bottom: 2px solid #3498db; padding-bottom: 10px;">4. Exemplo Completo - CRUD com Units Públicas</h3>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">4.1. Exemplo Completo de Uso</h4>
            <p>Exemplo completo demonstrando o uso <strong>APENAS</strong> das units públicas (<code>Database</code> e <code>Database.Interfaces</code>) em um CRUD:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

procedure ExemploCRUD;
var
  Connection: IConnection;
  Tables: ITables;
  Table: ITable;
begin
  try
    // ✨ APENAS units públicas: Database e Database.Interfaces
    // 1. Criar conexão usando TDatabase.New (unit pública)
    Connection := TDatabase.New
      .FromParameters('database')
      .Connect;
    
    if not Connection.IsConnected then
      raise Exception.Create('Falha na conexão');
    
    // 2. Criar gerenciador de tabelas usando TDatabase.NewTables (unit pública)
    Tables := TDatabase.NewTables
      .Connection(Connection.NativeConnection)
      .LoadFromConnection;
    
    // 3. Acessar tabela (via interface ITables - exposta por Database.Interfaces)
    Table := Tables.Table('admcore_pessoa');
    if not Assigned(Table) then
      raise Exception.Create('Tabela não encontrada');
    
    // 4. Inserir dados (via interface ITable - exposta por Database.Interfaces)
    Table.Fields('tipopessoa').SetValue('F');
    Table.Fields('nome').SetValue('JOÃO SILVA');
    Table.Fields('cpfcnpj').SetValue('123.456.789-00');
    Table.Fields('tipo').SetValue('1');
    Table.Fields('substituto_trib_iss').SetValue('false');
    
    // 5. Gerar SQL de INSERT
    var SQLInsert := Table.GenerateInsertSQLOptimized;
    ShowMessage('SQL INSERT: ' + SQLInsert);
    
    // 6. Atualizar dados
    Table.Fields('nome').SetValue('JOÃO SILVA SANTOS');
    var SQLUpdate := Table.GenerateUpdateSQLOptimized;
    ShowMessage('SQL UPDATE: ' + SQLUpdate);
    
  except
    // ✨ Exceções expostas por Database.Interfaces
    on E: EDatabaseException do
      ShowMessage('Erro do Database ORM: ' + E.Message);
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;</code></pre>
            <p><strong>⚠️ IMPORTANTE:</strong> Este exemplo usa <strong>APENAS</strong> as units públicas. Não há referências a units internas como <code>Database.Connetions</code>, <code>Database.Tables</code>, <code>TConnection</code> ou <code>TTables</code>.</p>
            
            <h4 style="margin-top: 20px; color: #2c3e50;">4.2. Trabalhando com Múltiplas Tabelas</h4>
            <p>Exemplo de uso com múltiplas tabelas usando <strong>APENAS</strong> units públicas:</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto;"><code>uses Database, Database.Interfaces;

procedure ExemploMultiplasTabelas;
var
  Connection: IConnection;
  Tables: ITables;
  TablePessoa: ITable;
  TableEndereco: ITable;
begin
  // ✨ APENAS units públicas: Database e Database.Interfaces
  // 1. Criar conexão usando TDatabase.New (unit pública)
  Connection := TDatabase.New
    .FromParameters('database')
    .Connect;
  
  // 2. Carregar estrutura do banco usando TDatabase.NewTables (unit pública)
  Tables := TDatabase.NewTables
    .Connection(Connection.NativeConnection)
    .LoadFromConnection;
  
  // 3. Acessar múltiplas tabelas (via interface ITables - exposta por Database.Interfaces)
  TablePessoa := Tables.Table('admcore_pessoa');
  TableEndereco := Tables.Table('admcore_endereco');
  
  // 4. Trabalhar com cada tabela (via interface ITable - exposta por Database.Interfaces)
  if Assigned(TablePessoa) then
  begin
    TablePessoa.Fields('nome').SetValue('MARIA SANTOS');
    var SQLPessoa := TablePessoa.GenerateInsertSQLOptimized;
  end;
  
  if Assigned(TableEndereco) then
  begin
    TableEndereco.Fields('logradouro').SetValue('Rua das Flores');
    TableEndereco.Fields('numero').SetValue('123');
    var SQLEndereco := TableEndereco.GenerateInsertSQLOptimized;
  end;
end;</code></pre>
            <p><strong>⚠️ IMPORTANTE:</strong> Este exemplo usa <strong>APENAS</strong> as units públicas. Todas as interfaces (<code>IConnection</code>, <code>ITables</code>, <code>ITable</code>) são expostas por <code>Database.Interfaces</code>, e todas as factory methods (<code>TDatabase.New</code>, <code>TDatabase.NewTables</code>) são da unit pública <code>Database</code>.</p>
        `
    },
    units: [
        {
            id: "field-interfaces",
            name: "Database.Field.Interfaces",
            path: "src/Fields/Database.Field.Interfaces.pas",
            description: `
                <p>Define a interface <code>IField</code> que representa um campo individual de uma tabela de banco de dados.</p>
                <p><strong>Hierarquia:</strong> Nível 1 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            interfaces: [
                {
                    name: "IField",
                    guid: "{B2C3D4E5-F6A7-8901-BCDE-F12345678901}",
                    description: "Interface que representa um campo individual de uma tabela de banco de dados. Fornece acesso a propriedades e métodos helper para gerenciamento de campos.",
                    methods: [
                        {
                            signature: "function GetTable: string;",
                            comment: "Obtém o nome da tabela ao qual o campo pertence",
                            example: "var tableName := Field.GetTable; // Retorna 'usuarios'"
                        },
                        {
                            signature: "function GetColumn: string;",
                            comment: "Obtém o nome da coluna (ex: 'id', 'nome')",
                            example: "var columnName := Field.GetColumn; // Retorna 'id'"
                        },
                        {
                            signature: "function GetColumnType: string;",
                            comment: "Obtém o tipo de dado (ex: 'VARCHAR', 'INTEGER')",
                            example: "var columnType := Field.GetColumnType; // Retorna 'VARCHAR' ou 'INTEGER'"
                        },
                        {
                            signature: "function GetColumnTypeCode: Integer;",
                            comment: "Obtém o código do tipo para categorização interna",
                            example: "var code := Field.GetColumnTypeCode; // Retorna código do tipo (ex: 3 para INTEGER)"
                        },
                        {
                            signature: "function GetIsNull: string;",
                            comment: "Obtém flag de nullable ('YES' = permite NULL, 'NO' = NOT NULL)",
                            example: "var isNull := Field.GetIsNull; // Retorna 'YES' ou 'NO'"
                        },
                        {
                            signature: "function GetIsNullBool: Boolean;",
                            comment: "Obtém flag de nullable como Boolean",
                            example: "var isNull := Field.GetIsNullBool; // Retorna True ou False"
                        },
                        {
                            signature: "function GetValue: string;",
                            comment: "Obtém o valor atual do campo",
                            example: "var value := Field.GetValue; // Retorna valor atual do campo"
                        },
                        {
                            signature: "function GetToDefault: string;",
                            comment: "Obtém o valor padrão do schema do banco",
                            example: "var defaultValue := Field.GetToDefault; // Retorna valor padrão do schema"
                        },
                        {
                            signature: "function GetIsChanged: Integer;",
                            comment: "Obtém flag de alteração (0 = não alterado, 1 = alterado)",
                            example: "var changed := Field.GetIsChanged; // Retorna 0 ou 1"
                        },
                        {
                            signature: "function GetIsPKey: Integer;",
                            comment: "Obtém flag de Primary Key (0 = não é PK, 1 = Primary Key)",
                            example: "var isPKey := Field.GetIsPKey; // Retorna 0 ou 1"
                        },
                        {
                            signature: "function GetPosition: Integer;",
                            comment: "Obtém a posição ordinal do campo na tabela",
                            example: "var position := Field.GetPosition; // Retorna posição do campo (1, 2, 3...)"
                        },
                        {
                            signature: "function GetConstraintName: string;",
                            comment: "Obtém o nome da constraint (se houver)",
                            example: "var constraint := Field.GetConstraintName; // Retorna nome da constraint ou ''"
                        },
                        {
                            signature: "function GetFielsJson: TjsonObject;",
                            comment: "Obtém representação JSON do campo",
                            example: "var json := Field.GetFielsJson; // Retorna objeto JSON com dados do campo"
                        },
                        {
                            signature: "procedure SetTable(const AValue: string);",
                            comment: "Define o nome da tabela ao qual o campo pertence",
                            example: "Field.SetTable('usuarios'); // Define nome da tabela"
                        },
                        {
                            signature: "procedure SetColumn(const AValue: string);",
                            comment: "Define o nome da coluna",
                            example: "Field.SetColumn('id'); // Define nome da coluna"
                        },
                        {
                            signature: "procedure SetColumnType(const AValue: string);",
                            comment: "Define o tipo de dado",
                            example: "Field.SetColumnType('INTEGER'); // Define tipo de dado"
                        },
                        {
                            signature: "procedure SetColumnTypeCode(AValue: Integer);",
                            comment: "Define o código do tipo",
                            example: "Field.SetColumnTypeCode(3); // Define código do tipo"
                        },
                        {
                            signature: "procedure SetIsNull(const AValue: string);",
                            comment: "Define flag de nullable",
                            example: "Field.SetIsNull('NO'); // Define flag nullable como 'NO'"
                        },
                        {
                            signature: "procedure SetIsNullBool(const AValue: Boolean);",
                            comment: "Define flag de nullable como Boolean",
                            example: "Field.SetIsNullBool(False); // Define flag nullable como False"
                        },
                        {
                            signature: "procedure SetValue(const AValue: string);",
                            comment: "Define o valor atual do campo",
                            example: "Field.SetValue('João'); // Define valor do campo"
                        },
                        {
                            signature: "procedure SetToDefault(const AValue: string);",
                            comment: "Define o valor padrão",
                            example: "Field.SetToDefault('0'); // Define valor padrão"
                        },
                        {
                            signature: "procedure SetIsChanged(AValue: Integer);",
                            comment: "Define flag de alteração",
                            example: "Field.SetIsChanged(1); // Marca campo como alterado"
                        },
                        {
                            signature: "procedure SetIsPKey(AValue: Integer);",
                            comment: "Define flag de Primary Key",
                            example: "Field.SetIsPKey(1); // Define campo como Primary Key"
                        },
                        {
                            signature: "procedure SetPosition(AValue: Integer);",
                            comment: "Define a posição ordinal do campo",
                            example: "Field.SetPosition(1); // Define posição do campo"
                        },
                        {
                            signature: "procedure SetConstraintName(const AValue: string);",
                            comment: "Define o nome da constraint",
                            example: "Field.SetConstraintName('pk_usuarios'); // Define nome da constraint"
                        },
                        {
                            signature: "procedure LoadFromJSONObject(const AField: TjsonObject);",
                            comment: "Carrega dados do campo a partir de um objeto JSON",
                            example: "Field.LoadFromJSONObject(JsonObject); // Carrega dados de JSON"
                        },
                        {
                            signature: "procedure SetAsChanged;",
                            comment: "Marca o campo como alterado (isChanged := 1)",
                            example: "Field.SetAsChanged; // Marca campo como alterado"
                        },
                        {
                            signature: "procedure SetAsUnchanged;",
                            comment: "Marca o campo como não alterado (isChanged := 0)",
                            example: "Field.SetAsUnchanged; // Marca campo como não alterado"
                        },
                        {
                            signature: "function IsFieldChanged: Boolean;",
                            comment: "Retorna True se isChanged = 1",
                            example: "if Field.IsFieldChanged then ShowMessage('Campo foi alterado');"
                        },
                        {
                            signature: "function IsFieldPrimaryKey: Boolean;",
                            comment: "Retorna True se isPKey = 1",
                            example: "if Field.IsFieldPrimaryKey then ShowMessage('Campo é Primary Key');"
                        },
                        {
                            signature: "function FieldAllowsNull: Boolean;",
                            comment: "Retorna True se isNull = 'YES'",
                            example: "if Field.FieldAllowsNull then ShowMessage('Campo permite NULL');"
                        },
                        {
                            signature: "function SetColumnValue(const AValue: string): IField;",
                            comment: "Define valor e marca como alterado se diferente. Retorna Self para encadeamento (Fluent Interface).",
                            example: "Field.SetColumnValue('João').MarkChanged; // Define valor e marca como alterado"
                        },
                        {
                            signature: "function SetColumnValueWithoutChange(const AValue: string): IField;",
                            comment: "Define valor sem marcar como alterado. Retorna Self para encadeamento."
                        },
                        {
                            signature: "function MarkChanged: IField;",
                            comment: "Marca como alterado e retorna Self para encadeamento."
                        },
                        {
                            signature: "function MarkUnchanged: IField;",
                            comment: "Marca como não alterado e retorna Self para encadeamento."
                        },
                        {
                            signature: "function Clone: IField;",
                            comment: "Cria cópia completa do campo"
                        }
                    ],
                    properties: [
                        {
                            name: "Table",
                            type: "string",
                            comment: "Nome da tabela ao qual o campo pertence"
                        },
                        {
                            name: "Column",
                            type: "string",
                            comment: "Nome da coluna"
                        },
                        {
                            name: "ColumnType",
                            type: "string",
                            comment: "Tipo de dado"
                        },
                        {
                            name: "ColumnTypeCode",
                            type: "Integer",
                            comment: "Código do tipo"
                        },
                        {
                            name: "isNull",
                            type: "string",
                            comment: "'YES' = permite NULL, 'NO' = NOT NULL"
                        },
                        {
                            name: "isNullBool",
                            type: "Boolean",
                            comment: "Flag de nullable como Boolean"
                        },
                        {
                            name: "Value",
                            type: "string",
                            comment: "Valor atual do campo"
                        },
                        {
                            name: "ToDefault",
                            type: "string",
                            comment: "Valor padrão do schema do banco"
                        },
                        {
                            name: "isChanged",
                            type: "Integer",
                            comment: "0 = não alterado, 1 = alterado (para SQL otimizado)"
                        },
                        {
                            name: "isPKey",
                            type: "Integer",
                            comment: "0 = não é PK, 1 = Primary Key"
                        },
                        {
                            name: "Position",
                            type: "Integer",
                            comment: "Posição ordinal do campo na tabela"
                        },
                        {
                            name: "ConstraintName",
                            type: "string",
                            comment: "Nome da constraint (se houver)"
                        },
                        {
                            name: "FielsJson",
                            type: "TjsonObject",
                            comment: "Representação JSON do campo"
                        }
                    ]
                }
            ]
        },
        {
            id: "field",
            name: "Database.Field",
            path: "src/Fields/Database.Field.pas",
            description: `
                <p>Implementação da interface <code>IField</code>. Armazena informações de campo do schema do banco de dados.</p>
                <p><strong>Hierarquia:</strong> Nível 1 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            classes: [
                {
                    name: "TField",
                    description: "Implementação da interface IField. Armazena informações de campo do schema do banco de dados: nome da coluna, tipo de dado, flag de nullable, valor atual, valor padrão, rastreamento de alterações, flag de Primary Key, posição na tabela, nome da constraint.",
                    publicMethods: [
                        {
                            signature: "constructor Create; overload;",
                            comment: "Cria uma nova instância de TField com valores padrão"
                        },
                        {
                            signature: "constructor Create(AField: TjsonObject); overload;",
                            comment: "Cria uma nova instância de TField a partir de um objeto JSON"
                        },
                        {
                            signature: "constructor Create(const ATable, AColumn, AColumnType: string; AColumnTypeCode: Integer; AIsNull: string; AValue, AToDefault: string; AIsChanged, AIsPKey, APosition: Integer; AConstraintName: string); overload;",
                            comment: "Cria uma nova instância de TField com todos os parâmetros"
                        },
                        {
                            signature: "class function New: IField; overload;",
                            comment: "Método factory para criar nova instância vazia de IField"
                        },
                        {
                            signature: "class function New(AField: TjsonObject): IField; overload;",
                            comment: "Método factory para criar nova instância de IField a partir de JSON"
                        },
                        {
                            signature: "class function New(const ATable, AColumn, AColumnType: string; AColumnTypeCode: Integer; AIsNull: string; AValue, AToDefault: string; AIsChanged, AIsPKey, APosition: Integer; AConstraintName: string): IField; overload;",
                            comment: "Método factory para criar nova instância de IField com todos os parâmetros"
                        },
                        {
                            signature: "procedure LoadFromJSONObject(const AField: TjsonObject);",
                            comment: "Carrega dados do campo a partir de um objeto JSON"
                        },
                        {
                            signature: "procedure SetAsChanged;",
                            comment: "Marca o campo como alterado (isChanged := 1)"
                        },
                        {
                            signature: "procedure SetAsUnchanged;",
                            comment: "Marca o campo como não alterado (isChanged := 0)"
                        },
                        {
                            signature: "function IsFieldChanged: Boolean;",
                            comment: "Retorna True se isChanged = 1"
                        },
                        {
                            signature: "function IsFieldPrimaryKey: Boolean;",
                            comment: "Retorna True se isPKey = 1"
                        },
                        {
                            signature: "function FieldAllowsNull: Boolean;",
                            comment: "Retorna True se isNull = 'YES'"
                        },
                        {
                            signature: "function SetColumnValue(const AValue: string): IField;",
                            comment: "Define valor e marca como alterado se diferente. Retorna Self para encadeamento."
                        },
                        {
                            signature: "function SetColumnValueWithoutChange(const AValue: string): IField;",
                            comment: "Define valor sem marcar como alterado. Retorna Self para encadeamento."
                        },
                        {
                            signature: "function MarkChanged: IField;",
                            comment: "Marca como alterado e retorna Self para encadeamento."
                        },
                        {
                            signature: "function MarkUnchanged: IField;",
                            comment: "Marca como não alterado e retorna Self para encadeamento."
                        },
                        {
                            signature: "function Clone: IField;",
                            comment: "Cria cópia completa do campo"
                        }
                    ],
                    privateMethods: [
                        {
                            signature: "function GetTable: string;",
                            comment: "Getter para propriedade Table"
                        },
                        {
                            signature: "function GetColumn: string;",
                            comment: "Getter para propriedade Column"
                        },
                        {
                            signature: "function GetColumnType: string;",
                            comment: "Getter para propriedade ColumnType"
                        },
                        {
                            signature: "function GetColumnTypeCode: Integer;",
                            comment: "Getter para propriedade ColumnTypeCode"
                        },
                        {
                            signature: "function GetIsNull: string;",
                            comment: "Getter para propriedade isNull"
                        },
                        {
                            signature: "function GetIsNullBool: Boolean;",
                            comment: "Getter para propriedade isNullBool"
                        },
                        {
                            signature: "function GetValue: string;",
                            comment: "Getter para propriedade Value"
                        },
                        {
                            signature: "function GetToDefault: string;",
                            comment: "Getter para propriedade ToDefault"
                        },
                        {
                            signature: "function GetIsChanged: Integer;",
                            comment: "Getter para propriedade isChanged"
                        },
                        {
                            signature: "function GetIsPKey: Integer;",
                            comment: "Getter para propriedade isPKey"
                        },
                        {
                            signature: "function GetPosition: Integer;",
                            comment: "Getter para propriedade Position"
                        },
                        {
                            signature: "function GetConstraintName: string;",
                            comment: "Getter para propriedade ConstraintName"
                        },
                        {
                            signature: "function GetFielsJson: TjsonObject;",
                            comment: "Getter para propriedade FielsJson"
                        },
                        {
                            signature: "procedure SetTable(const AValue: string);",
                            comment: "Setter para propriedade Table"
                        },
                        {
                            signature: "procedure SetColumn(const AValue: string);",
                            comment: "Setter para propriedade Column"
                        },
                        {
                            signature: "procedure SetColumnType(const AValue: string);",
                            comment: "Setter para propriedade ColumnType"
                        },
                        {
                            signature: "procedure SetColumnTypeCode(AValue: Integer);",
                            comment: "Setter para propriedade ColumnTypeCode"
                        },
                        {
                            signature: "procedure SetIsNull(const AValue: string);",
                            comment: "Setter para propriedade isNull"
                        },
                        {
                            signature: "procedure SetIsNullBool(const AValue: Boolean);",
                            comment: "Setter para propriedade isNullBool"
                        },
                        {
                            signature: "procedure SetValue(const AValue: string);",
                            comment: "Setter para propriedade Value"
                        },
                        {
                            signature: "procedure SetToDefault(const AValue: string);",
                            comment: "Setter para propriedade ToDefault"
                        },
                        {
                            signature: "procedure SetIsChanged(AValue: Integer);",
                            comment: "Setter para propriedade isChanged"
                        },
                        {
                            signature: "procedure SetIsPKey(AValue: Integer);",
                            comment: "Setter para propriedade isPKey"
                        },
                        {
                            signature: "procedure SetPosition(AValue: Integer);",
                            comment: "Setter para propriedade Position"
                        },
                        {
                            signature: "procedure SetConstraintName(const AValue: string);",
                            comment: "Setter para propriedade ConstraintName"
                        }
                    ]
                }
            ]
        },
        {
            id: "fields-interfaces",
            name: "Database.Fields.Interfaces",
            path: "src/Fields/Database.Fields.Interfaces.pas",
            description: `
                <p>Define a interface <code>IFields</code> que representa um container para múltiplas tabelas (IFields).</p>
                <p><strong>Hierarquia:</strong> Nível 2 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            interfaces: [
                {
                    name: "IFields",
                    guid: "{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}",
                    description: "Container para múltiplas tabelas (IFields). Fornece acesso a tabelas individuais e operações globais.",
                    methods: [
                        {
                            signature: "function DatabaseTypes(Value: TDatabaseTypes): IFields; overload;",
                            comment: "Define o tipo de banco de dados (propagado para todas as tabelas). Retorna Self para encadeamento.",
                            example: "Fields.DatabaseTypes(dtPostgreSQL); // Define tipo de banco PostgreSQL"
                        },
                        {
                            signature: "function DatabaseTypes: TDatabaseTypes; overload;",
                            comment: "Obtém o tipo de banco de dados",
                            example: "var dbType := Fields.DatabaseTypes; // Retorna tipo de banco configurado"
                        },
                        {
                            signature: "function Fields(const AFieldsName: string): IField;",
                            comment: "Obtém ou cria uma tabela pelo nome, retorna IField",
                            example: "var Field: IField := Fields.Fields('id'); // Obtém campo 'id'"
                        },
                        {
                            signature: "function GetPrimaryKey: TStringArray;",
                            comment: "Obtém a(s) Colunas que são chaves primárias",
                            example: "var pks := Fields.GetPrimaryKey; // Retorna array com nomes das Primary Keys"
                        },
                        {
                            signature: "function GetFields(const AFieldsName: string): IField;",
                            comment: "Obtém uma tabela pelo nome (nil se não existir)",
                            example: "var Field: IField := Fields.GetFields('id'); // Retorna campo ou nil"
                        },
                        {
                            signature: "function GetFieldsByIndex(AIndex: Integer): IField;",
                            comment: "Obtém tabela por índice (0-based)",
                            example: "var Field: IField := Fields.GetFieldsByIndex(0); // Retorna primeiro campo"
                        },
                        {
                            signature: "function GetFieldsList: TList<IField>;",
                            comment: "Retorna a lista interna de tabelas (para iteração)",
                            example: "var list := Fields.GetFieldsList; // Retorna lista para iteração"
                        },
                        {
                            signature: "function FieldsCount: Integer;",
                            comment: "Retorna número de tabelas",
                            example: "var count := Fields.FieldsCount; // Retorna número de campos"
                        },
                        {
                            signature: "function FieldExist(const AFieldName: string): Boolean;",
                            comment: "Verifica se uma tabela existe",
                            example: "if Fields.FieldExist('id') then ShowMessage('Campo existe');"
                        },
                        {
                            signature: "function Remove(const AFieldName: string): IFields;",
                            comment: "Remove uma tabela pelo nome. Retorna Self para encadeamento.",
                            example: "Fields.Remove('id'); // Remove campo 'id'"
                        },
                        {
                            signature: "function Clear: IFields;",
                            comment: "Remove todas as tabelas. Retorna Self para encadeamento.",
                            example: "Fields.Clear; // Remove todos os campos"
                        },
                        {
                            signature: "function HasChanges: Boolean;",
                            comment: "Retorna true se alguma tabela tiver alterações",
                            example: "if Fields.HasChanges then ShowMessage('Há alterações pendentes');"
                        },
                        {
                            signature: "function ClearAllChanges: IFields;",
                            comment: "Limpa alterações em todas as tabelas. Retorna Self para encadeamento.",
                            example: "Fields.ClearAllChanges; // Limpa todas as alterações"
                        },
                        {
                            signature: "function GetAllChangedFieldNames: TStringArray;",
                            comment: "Retorna todos os campos alterados de todas as tabelas",
                            example: "var changed := Fields.GetAllChangedFieldNames; // Retorna array com campos alterados"
                        },
                        {
                            signature: "function ToJSON: string;",
                            comment: "Serializa todas as tabelas para JSON",
                            example: "var json := Fields.ToJSON; // Retorna JSON com todos os campos"
                        },
                        {
                            signature: "function FromJSON(const AJSON: string): IFields;",
                            comment: "Deserializa todas as tabelas de JSON. Retorna Self para encadeamento.",
                            example: "Fields.FromJSON('{\"fields\":[...]}'); // Carrega campos de JSON"
                        },
                        {
                            signature: "function Add(const AFieldName: IField): IFields;",
                            comment: "Adiciona campos à lista. Retorna Self para encadeamento.",
                            example: "Fields.Add(Field).Add(AnotherField); // Adiciona campos à lista"
                        }
                    ]
                }
            ]
        },
        {
            id: "fields-impl",
            name: "Database.Fields",
            path: "src/Fields/Database.Fields.pas",
            description: `
                <p>Implementação da interface <code>IFields</code>. Container para múltiplas tabelas (IFields).</p>
                <p><strong>Hierarquia:</strong> Nível 2 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            classes: [
                {
                    name: "TFields",
                    description: "Implementação da interface IFields. Container para múltiplas tabelas (IFields). Gerencia múltiplas tabelas e fornece acesso via método Fields().",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria uma nova instância de TFields",
                            example: "var Fields: TFields := TFields.Create; // Cria nova instância"
                        },
                        {
                            signature: "destructor Destroy; override;",
                            comment: "Destrói a instância e libera recursos",
                            example: "Fields.Free; // Destrói instância (gerenciado automaticamente por ARC)"
                        },
                        {
                            signature: "class function New: IFields;",
                            comment: "Método factory para criar nova instância de IFields",
                            example: "var Fields: IFields := TDatabase.NewFields; // Cria nova instância via factory"
                        },
                        {
                            signature: "function DatabaseTypes(Value: TDatabaseTypes): IFields; overload;",
                            comment: "Define o tipo de banco de dados (propagado para todas as tabelas). Retorna Self para encadeamento.",
                            example: "Fields.DatabaseTypes(dtPostgreSQL); // Define tipo de banco"
                        },
                        {
                            signature: "function DatabaseTypes: TDatabaseTypes; overload;",
                            comment: "Obtém o tipo de banco de dados",
                            example: "var dbType := Fields.DatabaseTypes; // Retorna tipo de banco"
                        },
                        {
                            signature: "function Fields(const AFieldName: string): IField;",
                            comment: "Obtém ou cria uma tabela pelo nome, retorna IField",
                            example: "var Field: IField := Fields.Fields('id'); // Obtém campo 'id'"
                        },
                        {
                            signature: "function GetPrimaryKey: TStringArray;",
                            comment: "Obtém a(s) Colunas que são chaves primárias",
                            example: "var pks := Fields.GetPrimaryKey; // Retorna array com Primary Keys"
                        },
                        {
                            signature: "function GetFields(const AFieldName: string): IField;",
                            comment: "Obtém uma tabela pelo nome (nil se não existir)",
                            example: "var Field: IField := Fields.GetFields('id'); // Retorna campo ou nil"
                        },
                        {
                            signature: "function GetFieldsByIndex(AIndex: Integer): IField;",
                            comment: "Obtém tabela por índice (0-based)",
                            example: "var Field: IField := Fields.GetFieldsByIndex(0); // Retorna primeiro campo"
                        },
                        {
                            signature: "function FieldsCount: Integer;",
                            comment: "Retorna número de tabelas",
                            example: "var count := Fields.FieldsCount; // Retorna número de campos"
                        },
                        {
                            signature: "function FieldExist(const AFieldName: string): Boolean;",
                            comment: "Verifica se uma tabela existe",
                            example: "if Fields.FieldExist('id') then ShowMessage('Campo existe');"
                        },
                        {
                            signature: "function Add(const AFieldName: IField): IFields;",
                            comment: "Adiciona campos à lista. Retorna Self para encadeamento.",
                            example: "Fields.Add(Field).Add(AnotherField); // Adiciona campos"
                        },
                        {
                            signature: "function Remove(const AFieldName: string): IFields;",
                            comment: "Remove uma tabela pelo nome. Retorna Self para encadeamento.",
                            example: "Fields.Remove('id'); // Remove campo"
                        },
                        {
                            signature: "function Clear: IFields;",
                            comment: "Remove todas as tabelas. Retorna Self para encadeamento.",
                            example: "Fields.Clear; // Remove todos os campos"
                        },
                        {
                            signature: "function HasChanges: Boolean;",
                            comment: "Retorna true se alguma tabela tiver alterações",
                            example: "if Fields.HasChanges then ShowMessage('Há alterações');"
                        },
                        {
                            signature: "function ClearAllChanges: IFields;",
                            comment: "Limpa alterações em todas as tabelas. Retorna Self para encadeamento.",
                            example: "Fields.ClearAllChanges; // Limpa todas as alterações"
                        },
                        {
                            signature: "function GetAllChangedFieldNames: TStringArray;",
                            comment: "Retorna todos os campos alterados de todas as tabelas",
                            example: "var changed := Fields.GetAllChangedFieldNames; // Retorna campos alterados"
                        },
                        {
                            signature: "function ToJSON: string;",
                            comment: "Serializa todas as tabelas para JSON",
                            example: "var json := Fields.ToJSON; // Retorna JSON com todos os campos"
                        },
                        {
                            signature: "function FromJSON(const AJSON: string): IFields;",
                            comment: "Deserializa todas as tabelas de JSON. Retorna Self para encadeamento.",
                            example: "Fields.FromJSON('{\"fields\":[...]}'); // Carrega campos de JSON"
                        }
                    ],
                    privateMethods: [
                        {
                            signature: "function GetFieldsList: TList<IField>;",
                            comment: "Retorna a lista interna de tabelas (para iteração)"
                        }
                    ]
                }
            ]
        },
        {
            id: "table-interfaces",
            name: "Database.Table.Interfaces",
            path: "src/Tables/Database.Table.Interfaces.pas",
            description: `
                <p>Define a interface <code>ITable</code> que representa uma coleção de campos para uma tabela específica do banco de dados.</p>
                <p><strong>Hierarquia:</strong> Nível 3 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            interfaces: [
                {
                    name: "ITable",
                    guid: "{C1D2E3F4-A5B6-7890-CDEF-123456789ABC}",
                    description: "Interface que representa uma coleção de campos para uma tabela específica do banco de dados. Fornece geração de SQL, auditoria e serialização.",
                    methods: [
                        {
                            signature: "function TableName(Value: string): ITable; overload;",
                            comment: "Define o nome da tabela. Retorna Self para encadeamento.",
                            example: "Table.TableName('usuarios'); // Define nome da tabela"
                        },
                        {
                            signature: "function TableName: string; overload;",
                            comment: "Obtém o nome da tabela",
                            example: "var tableName := Table.TableName; // Retorna 'usuarios'"
                        },
                        {
                            signature: "function Alias(Value: string): ITable; overload;",
                            comment: "Define o alias da tabela. Retorna Self para encadeamento.",
                            example: "Table.Alias('u'); // Define alias da tabela"
                        },
                        {
                            signature: "function Alias: string; overload;",
                            comment: "Obtém o alias da tabela",
                            example: "var alias := Table.Alias; // Retorna alias da tabela"
                        },
                        {
                            signature: "function DatabaseTypes(Value: TDatabaseTypes): ITable; overload;",
                            comment: "Define o tipo de banco de dados. Retorna Self para encadeamento.",
                            example: "Table.DatabaseTypes(dtPostgreSQL); // Define tipo de banco"
                        },
                        {
                            signature: "function DatabaseTypes: TDatabaseTypes; overload;",
                            comment: "Obtém o tipo de banco de dados",
                            example: "var dbType := Table.DatabaseTypes; // Retorna tipo de banco"
                        },
                        {
                            signature: "function GenerateInsertSQL: string;",
                            comment: "Gera SQL INSERT com todos os campos",
                            example: "var sql := Table.GenerateInsertSQL; // Gera: INSERT INTO usuarios (id, nome) VALUES (1, 'João')"
                        },
                        {
                            signature: "function GenerateInsertSQLOptimized: string;",
                            comment: "Gera SQL INSERT apenas com campos alterados",
                            example: "var sql := Table.GenerateInsertSQLOptimized; // Gera INSERT apenas com campos que foram alterados"
                        },
                        {
                            signature: "function GenerateUpdateSQL: string;",
                            comment: "Gera SQL UPDATE com todos os campos",
                            example: "var sql := Table.GenerateUpdateSQL; // Gera: UPDATE usuarios SET id=1, nome='João' WHERE id=1"
                        },
                        {
                            signature: "function GenerateUpdateSQLOptimized: string;",
                            comment: "Gera SQL UPDATE apenas com campos alterados",
                            example: "var sql := Table.GenerateUpdateSQLOptimized; // Gera UPDATE apenas com campos alterados"
                        },
                        {
                            signature: "function GenerateWhereByPrimaryKey: string;",
                            comment: "Gera cláusula WHERE baseada nas Primary Keys",
                            example: "var where := Table.GenerateWhereByPrimaryKey; // Retorna: WHERE id=1"
                        },
                        {
                            signature: "procedure ValidateNotNullFields;",
                            comment: "Valida campos obrigatórios (NOT NULL)",
                            example: "Table.ValidateNotNullFields; // Lança exceção se campo obrigatório estiver vazio"
                        },
                        {
                            signature: "function HasChanges: Boolean;",
                            comment: "Verifica se há campos alterados",
                            example: "if Table.HasChanges then ShowMessage('Há alterações');"
                        },
                        {
                            signature: "function GetChangedFieldNames: TStringArray;",
                            comment: "Obtém nomes dos campos alterados",
                            example: "var changed := Table.GetChangedFieldNames; // Retorna array com nomes dos campos alterados"
                        },
                        {
                            signature: "function LoadFieldsFromDB(ADataSet: TDataSet): ITable;",
                            comment: "Carrega estrutura de campos do banco de dados",
                            example: "Table.LoadFieldsFromDB(DataSet); // Carrega campos do DataSet"
                        },
                        {
                            signature: "function LoadValuesFromDataSet(ADataSet: TDataSet): ITable;",
                            comment: "Carrega valores de um DataSet",
                            example: "Table.LoadValuesFromDataSet(DataSet); // Carrega valores do DataSet para os campos"
                        },
                        {
                            signature: "function ApplyValuesToDataSet(ADataSet: TDataSet): ITable;",
                            comment: "Aplica valores a um DataSet",
                            example: "Table.ApplyValuesToDataSet(DataSet); // Aplica valores dos campos ao DataSet"
                        },
                        {
                            signature: "function ToJSON: string;",
                            comment: "Serializa tabela para JSON",
                            example: "var json := Table.ToJSON; // Retorna JSON com dados da tabela"
                        },
                        {
                            signature: "function FromJSON(const AJSON: string): ITable;",
                            comment: "Deserializa tabela de JSON",
                            example: "Table.FromJSON('{\"table\":\"usuarios\",\"fields\":[...]}'); // Carrega dados de JSON"
                        },
                        {
                            signature: "function AuditFields(AEnabled: Boolean): ITable; overload;",
                            comment: "Habilita ou desabilita auditoria automática. Retorna Self para encadeamento.",
                            example: "Table.AuditFields(True); // Habilita auditoria automática"
                        },
                        {
                            signature: "function AuditFields: Boolean; overload;",
                            comment: "Obtém status da auditoria",
                            example: "if Table.AuditFields then ShowMessage('Auditoria ativa');"
                        },
                        {
                            signature: "function FieldDateCreated(const AFieldName: String): ITable; overload;",
                            comment: "Define nome do campo de data de criação. Retorna Self para encadeamento.",
                            example: "Table.FieldDateCreated('data_cadastro'); // Define campo de data de criação"
                        },
                        {
                            signature: "function FieldDateCreated: String; overload;",
                            comment: "Obtém nome do campo de data de criação",
                            example: "var fieldName := Table.FieldDateCreated; // Retorna 'data_cadastro'"
                        },
                        {
                            signature: "function FieldDateUpdated(const AFieldName: String): ITable; overload;",
                            comment: "Define nome do campo de data de atualização. Retorna Self para encadeamento.",
                            example: "Table.FieldDateUpdated('data_alteracao'); // Define campo de data de atualização"
                        },
                        {
                            signature: "function FieldDateUpdated: String; overload;",
                            comment: "Obtém nome do campo de data de atualização",
                            example: "var fieldName := Table.FieldDateUpdated; // Retorna 'data_alteracao'"
                        },
                        {
                            signature: "function FieldIsDeleted(const AFieldName: String): ITable; overload;",
                            comment: "Define nome do campo de soft delete. Retorna Self para encadeamento.",
                            example: "Table.FieldIsDeleted('is_deleted'); // Define campo de soft delete"
                        },
                        {
                            signature: "function FieldIsDeleted: String; overload;",
                            comment: "Obtém nome do campo de soft delete",
                            example: "var fieldName := Table.FieldIsDeleted; // Retorna 'is_deleted'"
                        },
                        {
                            signature: "function FieldIsActive(const AFieldName: String): ITable; overload;",
                            comment: "Define nome do campo de ativação. Retorna Self para encadeamento.",
                            example: "Table.FieldIsActive('is_active'); // Define campo de ativação"
                        },
                        {
                            signature: "function FieldIsActive: String; overload;",
                            comment: "Obtém nome do campo de ativação",
                            example: "var fieldName := Table.FieldIsActive; // Retorna 'is_active'"
                        },
                        {
                            signature: "function ExcludeFields(const AFields: String): ITable; overload;",
                            comment: "Define lista de campos excluídos. Retorna Self para encadeamento.",
                            example: "Table.ExcludeFields('id,created_at'); // Exclui campos do SQL gerado"
                        },
                        {
                            signature: "function ExcludeFields: String; overload;",
                            comment: "Obtém lista de campos excluídos",
                            example: "var excluded := Table.ExcludeFields; // Retorna lista de campos excluídos"
                        },
                        {
                            signature: "function Fields: IFields;",
                            comment: "Retorna interface IFields para acesso aos campos",
                            example: "var Fields: IFields := Table.Fields; // Obtém acesso aos campos"
                        },
                        {
                            signature: "function EndTable: IInterface;",
                            comment: "Retorna ao container pai (nível superior)",
                            example: "var parent := Table.EndTable; // Retorna ao container pai"
                        },
                        {
                            signature: "function FromClass(const AClassType: TClass): ITable; overload;",
                            comment: "Cria ITable a partir de classe com Attributes (detecção automática). Se a classe tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClass(TUsuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function FromClass(const AInstance: TObject): ITable; overload;",
                            comment: "Cria ITable a partir de instância com Attributes (detecção automática). Se a instância tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClass(Usuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function FromClassWithAttributes(const AClassType: TClass): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassWithAttributes(TUsuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function FromClassWithAttributes(const AInstance: TObject): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassWithAttributes(Usuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function FromClassManual(const AClassType: TClass): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Retorna Self para preenchimento manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassManual(TUsuario).Fields('nome').SetValue('João'); // Ignora Attributes"
                        },
                        {
                            signature: "function FromClassManual(const AInstance: TObject): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Retorna Self para preenchimento manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassManual(Usuario).Fields('nome').SetValue('João'); // Ignora Attributes"
                        },
                        {
                            signature: "function LoadFromClass(AInstance: TObject): ITable;",
                            comment: "Carrega valores de instância (detecção automática). Se tiver Attributes, carrega; senão, não faz nada. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "Table.LoadFromClass(Usuario); // Carrega valores se tiver Attributes"
                        },
                        {
                            signature: "function HasAttributes(const AClassType: TClass): Boolean; overload;",
                            comment: "Verifica se classe tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if Table.HasAttributes(TUsuario) then ShowMessage('Classe tem Attributes');"
                        },
                        {
                            signature: "function HasAttributes(const AInstance: TObject): Boolean; overload;",
                            comment: "Verifica se instância tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if Table.HasAttributes(Usuario) then ShowMessage('Instância tem Attributes');"
                        }
                    ]
                }
            ]
        },
        {
            id: "table-impl",
            name: "Database.Table",
            path: "src/Tables/Database.Table.pas",
            description: `
                <p>Implementação da interface <code>ITable</code>. Representa uma coleção de campos para uma tabela específica do banco de dados.</p>
                <p><strong>Hierarquia:</strong> Nível 3 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            classes: [
                {
                    name: "TTable",
                    description: "Implementação da interface ITable. Responsável pela geração de SQL, auditoria e serialização de dados.",
                    publicMethods: [
                        {
                            signature: "constructor Create(AOwner: IFields; const ATableName: string);",
                            comment: "Cria uma nova instância de TTable",
                            example: "var Table: TTable := TTable.Create(Fields, 'usuarios'); // Cria tabela 'usuarios'"
                        },
                        {
                            signature: "destructor Destroy; override;",
                            comment: "Destrói a instância e libera recursos",
                            example: "Table.Free; // Destrói instância (gerenciado automaticamente por ARC)"
                        },
                        {
                            signature: "class function New(AOwner: IFields; const ATableName: string): ITable;",
                            comment: "Método factory para criar nova instância de ITable",
                            example: "var Table: ITable := TDatabase.NewTable(Fields, 'usuarios'); // Cria tabela via factory"
                        },
                        {
                            signature: "function FromClass(const AClassType: TClass): ITable; overload;",
                            comment: "Cria ITable a partir de classe com Attributes (detecção automática). Se a classe tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClass(TUsuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function FromClass(const AInstance: TObject): ITable; overload;",
                            comment: "Cria ITable a partir de instância com Attributes (detecção automática). Se a instância tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClass(Usuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function FromClassWithAttributes(const AClassType: TClass): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassWithAttributes(TUsuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function FromClassWithAttributes(const AInstance: TObject): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassWithAttributes(Usuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function FromClassManual(const AClassType: TClass): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Retorna Self para preenchimento manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassManual(TUsuario).Fields('nome').SetValue('João'); // Ignora Attributes"
                        },
                        {
                            signature: "function FromClassManual(const AInstance: TObject): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Retorna Self para preenchimento manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTable(TDatabase.NewFields, 'usuarios').FromClassManual(Usuario).Fields('nome').SetValue('João'); // Ignora Attributes"
                        },
                        {
                            signature: "function LoadFromClass(AInstance: TObject): ITable;",
                            comment: "Carrega valores de instância (detecção automática). Se tiver Attributes, carrega; senão, não faz nada. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "Table.LoadFromClass(Usuario); // Carrega valores se tiver Attributes"
                        },
                        {
                            signature: "function HasAttributes(const AClassType: TClass): Boolean; overload;",
                            comment: "Verifica se classe tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if Table.HasAttributes(TUsuario) then ShowMessage('Classe tem Attributes');"
                        },
                        {
                            signature: "function HasAttributes(const AInstance: TObject): Boolean; overload;",
                            comment: "Verifica se instância tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if Table.HasAttributes(Usuario) then ShowMessage('Instância tem Attributes');"
                        }
                    ]
                }
            ]
        },
        {
            id: "tables-interfaces",
            name: "Database.Tables.Interfaces",
            path: "src/Tables/Database.Tables.Interfaces.pas",
            description: `
                <p>Define a interface <code>ITables</code> que representa um container para múltiplas tabelas do banco de dados.</p>
                <p><strong>Hierarquia:</strong> Nível 4 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            interfaces: [
                {
                    name: "ITables",
                    guid: "{D1E2F3A4-B5C6-7890-DEF1-23456789ABCD}",
                    description: "Container para múltiplas tabelas do banco de dados. Gerencia toda a estrutura do banco (Database/Schema/Tables/Fields) de forma automática e fluente.",
                    methods: [
                        {
                            signature: "function Connection(AConnection: TObject): ITables; overload;",
                            comment: "Define a conexão com o banco de dados. Quando definida, automaticamente detecta: Engine, DatabaseType, Database, Schema. Retorna Self para encadeamento.",
                            example: "Tables.Connection(MyConnection).LoadFromConnection; // Define conexão e carrega estrutura"
                        },
                        {
                            signature: "function Connection: TObject; overload;",
                            comment: "Obtém a conexão com o banco de dados",
                            example: "var conn := Tables.Connection; // Retorna objeto de conexão"
                        },
                        {
                            signature: "function DatabaseTypes(Value: TDatabaseTypes): ITables; overload;",
                            comment: "Define o tipo de banco de dados. Se não definido, é detectado automaticamente da conexão. Quando definido, SOBRESCREVE o valor detectado. Retorna Self para encadeamento.",
                            example: "Tables.DatabaseTypes(dtPostgreSQL); // Define tipo de banco (sobrescreve detecção)"
                        },
                        {
                            signature: "function DatabaseTypes: TDatabaseTypes; overload;",
                            comment: "Obtém o tipo de banco de dados",
                            example: "var dbType := Tables.DatabaseTypes; // Retorna tipo de banco"
                        },
                        {
                            signature: "function Database(Value: string): ITables; overload;",
                            comment: "Define o nome do database/catalog. Se não definido, é detectado automaticamente da conexão. Quando definido, SOBRESCREVE o valor detectado. Retorna Self para encadeamento.",
                            example: "Tables.Database('mydb'); // Define nome do database (sobrescreve detecção)"
                        },
                        {
                            signature: "function Database: string; overload;",
                            comment: "Obtém o nome do database/catalog",
                            example: "var dbName := Tables.Database; // Retorna nome do database"
                        },
                        {
                            signature: "function Schema(Value: string): ITables; overload;",
                            comment: "Define o nome do schema. Se não definido, é detectado automaticamente da conexão (com padrão inteligente). Quando definido, SOBRESCREVE o valor detectado. Retorna Self para encadeamento.",
                            example: "Tables.Schema('public'); // Define schema (sobrescreve detecção)"
                        },
                        {
                            signature: "function Schema: string; overload;",
                            comment: "Obtém o nome do schema",
                            example: "var schemaName := Tables.Schema; // Retorna nome do schema"
                        },
                        {
                            signature: "function ExtractConnectionInfo: TConnectionData;",
                            comment: "Extrai todas as informações da conexão para TConnectionData",
                            example: "var info := Tables.ExtractConnectionInfo; // Extrai informações da conexão"
                        },
                        {
                            signature: "function DetectEngine: TDatabaseEngine;",
                            comment: "Detecta o engine da conexão (UNIDAC, FireDAC, Zeos)",
                            example: "var engine := Tables.DetectEngine; // Retorna engine detectado"
                        },
                        {
                            signature: "function DetectDatabaseType: TDatabaseTypes;",
                            comment: "Detecta o tipo de banco de dados da conexão",
                            example: "var dbType := Tables.DetectDatabaseType; // Retorna tipo de banco detectado"
                        },
                        {
                            signature: "function GetConnectionDatabase: string;",
                            comment: "Obtém o nome do database da conexão",
                            example: "var dbName := Tables.GetConnectionDatabase; // Retorna nome do database"
                        },
                        {
                            signature: "function GetConnectionSchema(const ADefault: string = ''): string;",
                            comment: "Obtém o schema da conexão (com padrão inteligente)",
                            example: "var schema := Tables.GetConnectionSchema('public'); // Retorna schema ou padrão"
                        },
                        {
                            signature: "function LoadFromConnection: ITables;",
                            comment: "Carrega automaticamente todas as tabelas e campos do banco. Retorna Self para encadeamento.",
                            example: "Tables.Connection(MyConnection).LoadFromConnection; // Carrega estrutura completa do banco"
                        },
                        {
                            signature: "function LoadTables: ITables;",
                            comment: "Carrega apenas a lista de tabelas (sem campos). Retorna Self para encadeamento.",
                            example: "Tables.LoadTables; // Carrega apenas nomes das tabelas"
                        },
                        {
                            signature: "function LoadTableFields(const ATableName: string): ITables;",
                            comment: "Carrega campos de uma tabela específica. Retorna Self para encadeamento.",
                            example: "Tables.LoadTableFields('usuarios'); // Carrega campos da tabela 'usuarios'"
                        },
                        {
                            signature: "function LoadAllFields: ITables;",
                            comment: "Carrega campos de todas as tabelas. Retorna Self para encadeamento.",
                            example: "Tables.LoadAllFields; // Carrega campos de todas as tabelas"
                        },
                        {
                            signature: "function Refresh: ITables;",
                            comment: "Recarrega estrutura do banco. Retorna Self para encadeamento.",
                            example: "Tables.Refresh; // Recarrega estrutura do banco"
                        },
                        {
                            signature: "function Table(const ATableName: string): ITable; overload;",
                            comment: "Obtém ou cria uma tabela pelo nome, retorna ITable",
                            example: "var Table: ITable := Tables.Table('usuarios'); // Obtém tabela 'usuarios'"
                        },
                        {
                            signature: "function Table(const ASchema, ATableName: string): ITable; overload;",
                            comment: "Obtém uma tabela pelo nome completo (schema.table)",
                            example: "var Table: ITable := Tables.Table('public', 'usuarios'); // Obtém tabela com schema"
                        },
                        {
                            signature: "function GetTable(const ATableName: string): ITable;",
                            comment: "Obtém uma tabela pelo nome (nil se não existir)",
                            example: "var Table: ITable := Tables.GetTable('usuarios'); // Retorna tabela ou nil"
                        },
                        {
                            signature: "function GetTableByIndex(AIndex: Integer): ITable;",
                            comment: "Obtém tabela por índice (0-based)",
                            example: "var Table: ITable := Tables.GetTableByIndex(0); // Retorna primeira tabela"
                        },
                        {
                            signature: "function GetTablesList: TList<ITable>;",
                            comment: "Retorna a lista interna de tabelas (para iteração)",
                            example: "var tablesList := Tables.GetTablesList; // Retorna lista de tabelas"
                        },
                        {
                            signature: "function TablesCount: Integer;",
                            comment: "Retorna número de tabelas carregadas",
                            example: "var count := Tables.TablesCount; // Retorna número de tabelas"
                        },
                        {
                            signature: "function TableExists(const ATableName: string): Boolean;",
                            comment: "Verifica se uma tabela existe",
                            example: "if Tables.TableExists('usuarios') then ShowMessage('Tabela existe');"
                        },
                        {
                            signature: "function GetTablesNames: TStringArray;",
                            comment: "Retorna array com nomes de todas as tabelas",
                            example: "var names := Tables.GetTablesNames; // Retorna array com nomes das tabelas"
                        },
                        {
                            signature: "function GetSchemasList: TStringArray;",
                            comment: "Retorna lista de schemas disponíveis (PostgreSQL, SQL Server)",
                            example: "var schemas := Tables.GetSchemasList; // Retorna array com schemas"
                        },
                        {
                            signature: "function GetDatabasesList: TStringArray;",
                            comment: "Retorna lista de databases/catalogs disponíveis",
                            example: "var databases := Tables.GetDatabasesList; // Retorna array com databases"
                        },
                        {
                            signature: "function HasChanges: Boolean;",
                            comment: "Retorna true se alguma tabela tiver alterações",
                            example: "if Tables.HasChanges then ShowMessage('Há alterações pendentes');"
                        },
                        {
                            signature: "function ClearAllChanges: ITables;",
                            comment: "Limpa alterações em todas as tabelas. Retorna Self para encadeamento.",
                            example: "Tables.ClearAllChanges; // Limpa todas as alterações"
                        },
                        {
                            signature: "function GetAllChangedFieldNames: TStringArray;",
                            comment: "Retorna todos os campos alterados de todas as tabelas",
                            example: "var changed := Tables.GetAllChangedFieldNames; // Retorna array com campos alterados"
                        },
                        {
                            signature: "function ValidateAllTables: ITables;",
                            comment: "Valida campos obrigatórios em todas as tabelas. Retorna Self para encadeamento.",
                            example: "Tables.ValidateAllTables; // Valida todas as tabelas"
                        },
                        {
                            signature: "function ToJSON: string;",
                            comment: "Serializa todas as tabelas para JSON",
                            example: "var json := Tables.ToJSON; // Retorna JSON com todas as tabelas"
                        },
                        {
                            signature: "function FromJSON(const AJSON: string): ITables;",
                            comment: "Deserializa tabelas de JSON. Retorna Self para encadeamento.",
                            example: "Tables.FromJSON('{\"tables\":[...]}'); // Carrega tabelas de JSON"
                        },
                        {
                            signature: "function Clear: ITables;",
                            comment: "Remove todas as tabelas da memória. Retorna Self para encadeamento.",
                            example: "Tables.Clear; // Remove todas as tabelas"
                        },
                        {
                            signature: "function RemoveTable(const ATableName: string): ITables;",
                            comment: "Remove uma tabela específica. Retorna Self para encadeamento.",
                            example: "Tables.RemoveTable('usuarios'); // Remove tabela 'usuarios'"
                        },
                        {
                            signature: "function GetSQLTables: string;",
                            comment: "Retorna SQL para listar tabelas (conforme tipo de banco)",
                            example: "var sql := Tables.GetSQLTables; // Retorna SQL para listar tabelas"
                        },
                        {
                            signature: "function GetSQLFields(const ATableName: string): string;",
                            comment: "Retorna SQL para listar campos de uma tabela",
                            example: "var sql := Tables.GetSQLFields('usuarios'); // Retorna SQL para listar campos"
                        },
                        {
                            signature: "function TableFromClass(const AClassType: TClass): ITable; overload;",
                            comment: "Obtém ou cria tabela a partir de classe com Attributes (detecção automática). Se a classe tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := Tables.TableFromClass(TUsuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function TableFromClass(const AInstance: TObject): ITable; overload;",
                            comment: "Obtém ou cria tabela a partir de instância com Attributes (detecção automática). Se a instância tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := Tables.TableFromClass(Usuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function TableFromClassWithAttributes(const AClassType: TClass): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := Tables.TableFromClassWithAttributes(TUsuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function TableFromClassWithAttributes(const AInstance: TObject): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := Tables.TableFromClassWithAttributes(Usuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function TableFromClassManual(const AClassType: TClass): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := Tables.TableFromClassManual(TUsuario); // Ignora Attributes, usa sistema manual"
                        },
                        {
                            signature: "function TableFromClassManual(const AInstance: TObject): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := Tables.TableFromClassManual(Usuario); // Ignora Attributes, usa sistema manual"
                        },
                        {
                            signature: "function LoadFromClass(const AClassType: TClass): ITables; overload;",
                            comment: "Carrega estrutura de classe com Attributes (detecção automática). Se tiver Attributes, carrega; senão, não faz nada. Retorna Self para encadeamento. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "Tables.LoadFromClass(TUsuario); // Carrega estrutura se tiver Attributes"
                        },
                        {
                            signature: "function LoadFromClass(const AInstance: TObject): ITables; overload;",
                            comment: "Carrega estrutura de instância com Attributes (detecção automática). Se tiver Attributes, carrega; senão, não faz nada. Retorna Self para encadeamento. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "Tables.LoadFromClass(Usuario); // Carrega estrutura se tiver Attributes"
                        },
                        {
                            signature: "function HasAttributes(const AClassType: TClass): Boolean; overload;",
                            comment: "Verifica se classe tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if Tables.HasAttributes(TUsuario) then ShowMessage('Classe tem Attributes');"
                        },
                        {
                            signature: "function HasAttributes(const AInstance: TObject): Boolean; overload;",
                            comment: "Verifica se instância tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if Tables.HasAttributes(Usuario) then ShowMessage('Instância tem Attributes');"
                        }
                    ]
                }
            ]
        },
        {
            id: "tables-impl",
            name: "Database.Tables",
            path: "src/Tables/Database.Tables.pas",
            description: `
                <p>Implementação da interface <code>ITables</code>. Container para múltiplas tabelas do banco de dados.</p>
                <p><strong>Hierarquia:</strong> Nível 4 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
            `,
            classes: [
                {
                    name: "TTables",
                    description: "Implementação da interface ITables. Gerencia múltiplas tabelas e fornece acesso via método Table().",
                    publicMethods: [
                        {
                            signature: "constructor Create; overload;",
                            comment: "Cria uma nova instância de TTables",
                            example: "var Tables: TTables := TTables.Create; // Cria nova instância"
                        },
                        {
                            signature: "constructor Create(AConnection: TObject; AData: TJSONObject); overload;",
                            comment: "Cria uma nova instância de TTables com conexão e dados JSON",
                            example: "var Tables: TTables := TTables.Create(MyConnection, JsonData); // Cria com conexão e JSON"
                        },
                        {
                            signature: "class function New: ITables;",
                            comment: "Método factory para criar nova instância de ITables",
                            example: "var Tables: ITables := TDatabase.NewTables; // Cria via factory"
                        },
                        {
                            signature: "function TableFromClass(const AClassType: TClass): ITable; overload;",
                            comment: "Obtém ou cria tabela a partir de classe com Attributes (detecção automática). Se a classe tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTables.TableFromClass(TUsuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function TableFromClass(const AInstance: TObject): ITable; overload;",
                            comment: "Obtém ou cria tabela a partir de instância com Attributes (detecção automática). Se a instância tiver Attributes, usa; senão, retorna erro. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTables.TableFromClass(Usuario); // Detecta e usa Attributes se disponível"
                        },
                        {
                            signature: "function TableFromClassWithAttributes(const AClassType: TClass): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTables.TableFromClassWithAttributes(TUsuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function TableFromClassWithAttributes(const AInstance: TObject): ITable; overload;",
                            comment: "Força uso de Attributes (retorna erro se não tiver). Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTables.TableFromClassWithAttributes(Usuario); // Garante uso de Attributes"
                        },
                        {
                            signature: "function TableFromClassManual(const AClassType: TClass): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTables.TableFromClassManual(TUsuario); // Ignora Attributes, usa sistema manual"
                        },
                        {
                            signature: "function TableFromClassManual(const AInstance: TObject): ITable; overload;",
                            comment: "Ignora Attributes e usa sistema manual. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "var Table: ITable := TDatabase.NewTables.TableFromClassManual(Usuario); // Ignora Attributes, usa sistema manual"
                        },
                        {
                            signature: "function LoadFromClass(const AClassType: TClass): ITables; overload;",
                            comment: "Carrega estrutura de classe com Attributes (detecção automática). Se tiver Attributes, carrega; senão, não faz nada. Retorna Self para encadeamento. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "TDatabase.NewTables.LoadFromClass(TUsuario); // Carrega estrutura se tiver Attributes"
                        },
                        {
                            signature: "function LoadFromClass(const AInstance: TObject): ITables; overload;",
                            comment: "Carrega estrutura de instância com Attributes (detecção automática). Se tiver Attributes, carrega; senão, não faz nada. Retorna Self para encadeamento. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "TDatabase.NewTables.LoadFromClass(Usuario); // Carrega estrutura se tiver Attributes"
                        },
                        {
                            signature: "function HasAttributes(const AClassType: TClass): Boolean; overload;",
                            comment: "Verifica se classe tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if TDatabase.NewTables.HasAttributes(TUsuario) then ShowMessage('Classe tem Attributes');"
                        },
                        {
                            signature: "function HasAttributes(const AInstance: TObject): Boolean; overload;",
                            comment: "Verifica se instância tem Attributes. Requer {$DEFINE USE_ATTRIBUTES}.",
                            example: "if TDatabase.NewTables.HasAttributes(Usuario) then ShowMessage('Instância tem Attributes');"
                        }
                    ]
                }
            ]
        },
        {
            id: "connection-interfaces",
            name: "Database.Connetions.Interfaces",
            path: "src/Connetions/Database.Connetions.Interfaces.pas",
            description: `
                <p>Define a interface <code>IConnection</code> que abstrai todos os engines de banco de dados (UniDAC, FireDAC, Zeos, SQLdb) através de uma interface única.</p>
                <p><strong>Hierarquia:</strong> Nível 8 - Field → Fields → Table → Tables → Database → TypeDatabase → Parameters → Connection</p>
                <p><strong>Funcionalidades:</strong></p>
                <ul>
                    <li>Abstração completa de engines (UniDAC, FireDAC, Zeos, SQLdb)</li>
                    <li>Suporte a múltiplas fontes de Parameters (INI, JSON, Database)</li>
                    <li>Gerenciamento de conexão (Connect, Disconnect, Ping, Reconnect)</li>
                    <li>Transações (BeginTransaction, Commit, Rollback)</li>
                    <li>Pool de conexões</li>
                    <li>Execução de queries e comandos SQL</li>
                    <li>Carregamento de estrutura de tabelas (função principal)</li>
                </ul>
                <p><strong>Dependências:</strong></p>
                <p>A interface <code>IConnection</code> depende do módulo Parameters (Nível 7) para obter dados de conexão. Permite trabalhar com UniDAC, FireDAC, Zeos e SQLdb de forma unificada.</p>
            `,
            interfaces: [
                {
                    name: "IConnection",
                    guid: "{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}",
                    description: "Interface única para abstração de todos os engines. Permite trabalhar com UniDAC, FireDAC, Zeos e SQLdb de forma unificada. Depende de Parameters (Nível 7) para obter dados de conexão.",
                    methods: [
                        {
                            signature: "function Engine(Value: TDatabaseEngine): IConnection; overload;",
                            comment: "Define o engine (UniDAC, FireDAC, Zeos, SQLdb). Retorna Self para encadeamento.",
                            example: "Connection.Engine(teFireDAC); // Define engine FireDAC"
                        },
                        {
                            signature: "function Engine: TDatabaseEngine; overload;",
                            comment: "Obtém o engine",
                            example: "var engine := Connection.Engine; // Retorna engine atual"
                        },
                        {
                            signature: "function DatabaseType(Value: TDatabaseTypes): IConnection; overload;",
                            comment: "Define o tipo de banco (PostgreSQL, MySQL, etc.). Retorna Self para encadeamento.",
                            example: "Connection.DatabaseType(dtPostgreSQL); // Define tipo PostgreSQL"
                        },
                        {
                            signature: "function DatabaseType: TDatabaseTypes; overload;",
                            comment: "Obtém o tipo de banco",
                            example: "var dbType := Connection.DatabaseType; // Retorna tipo de banco"
                        },
                        {
                            signature: "function Host(Value: string): IConnection; overload;",
                            comment: "Define o host do servidor. Retorna Self para encadeamento.",
                            example: "Connection.Host('localhost'); // Define host"
                        },
                        {
                            signature: "function Host: string; overload;",
                            comment: "Obtém o host do servidor",
                            example: "var host := Connection.Host; // Retorna host"
                        },
                        {
                            signature: "function Port(Value: Integer): IConnection; overload;",
                            comment: "Define a porta do servidor. Retorna Self para encadeamento.",
                            example: "Connection.Port(5432); // Define porta PostgreSQL"
                        },
                        {
                            signature: "function Port: Integer; overload;",
                            comment: "Obtém a porta do servidor",
                            example: "var port := Connection.Port; // Retorna porta"
                        },
                        {
                            signature: "function Database(Value: string): IConnection; overload;",
                            comment: "Define o nome do database. Retorna Self para encadeamento.",
                            example: "Connection.Database('mydb'); // Define nome do database"
                        },
                        {
                            signature: "function Database: string; overload;",
                            comment: "Obtém o nome do database",
                            example: "var dbName := Connection.Database; // Retorna nome do database"
                        },
                        {
                            signature: "function Schema(Value: string): IConnection; overload;",
                            comment: "Define o schema (PostgreSQL, SQL Server). Retorna Self para encadeamento.",
                            example: "Connection.Schema('public'); // Define schema"
                        },
                        {
                            signature: "function Schema: string; overload;",
                            comment: "Obtém o schema",
                            example: "var schema := Connection.Schema; // Retorna schema"
                        },
                        {
                            signature: "function Username(Value: string): IConnection; overload;",
                            comment: "Define o usuário. Retorna Self para encadeamento.",
                            example: "Connection.Username('postgres'); // Define usuário"
                        },
                        {
                            signature: "function Username: string; overload;",
                            comment: "Obtém o usuário",
                            example: "var user := Connection.Username; // Retorna usuário"
                        },
                        {
                            signature: "function Password(Value: string): IConnection; overload;",
                            comment: "Define a senha. Retorna Self para encadeamento.",
                            example: "Connection.Password('mypass'); // Define senha"
                        },
                        {
                            signature: "function Password: string; overload;",
                            comment: "Obtém a senha",
                            example: "var pass := Connection.Password; // Retorna senha"
                        },
                        {
                            signature: "function ConnectionString(Value: string): IConnection; overload;",
                            comment: "Define a connection string completa. Retorna Self para encadeamento.",
                            example: "Connection.ConnectionString('Host=localhost;Database=mydb;...'); // Define connection string"
                        },
                        {
                            signature: "function ConnectionString: string; overload;",
                            comment: "Obtém a connection string completa",
                            example: "var connStr := Connection.ConnectionString; // Retorna connection string"
                        },
                        {
                            signature: "function FromIniFile(const AFileName: string; const ASection: string = 'database'): IConnection;",
                            comment: "Carrega configuração de arquivo INI. Retorna Self para encadeamento.",
                            example: "Connection.FromIniFile('config.ini', 'database').Connect; // Carrega de INI e conecta"
                        },
                        {
                            signature: "function FromJsonFile(const AFileName: string; const APath: string = 'database'): IConnection;",
                            comment: "Carrega configuração de arquivo JSON. Retorna Self para encadeamento.",
                            example: "Connection.FromJsonFile('config.json', 'database').Connect; // Carrega de JSON e conecta"
                        },
                        {
                            signature: "function FromDatabase(const AFileName: string; const ATableName: string = 'config'): IConnection;",
                            comment: "Carrega configuração de banco de dados (SQLite, etc.). Retorna Self para encadeamento.",
                            example: "Connection.FromDatabase('config.db', 'config').Connect; // Carrega de Database e conecta"
                        },
                        {
                            signature: "function FromParameters(const AParameterName: string; const ASource: TDatabaseSource = TDatabaseSource.psNone): IConnection;",
                            comment: "Carrega configuração do módulo Parameters (Nível 7). Permite escolher a fonte: INI, JSON ou Database. Retorna Self para encadeamento.",
                            example: "Connection.FromParameters('database').Connect; // Carrega de Parameters (INI) e conecta"
                        },
                        {
                            signature: "function Connect: IConnection;",
                            comment: "Conecta ao banco de dados. Retorna Self para encadeamento.",
                            example: "Connection.Connect; // Conecta ao banco"
                        },
                        {
                            signature: "function Disconnect: IConnection;",
                            comment: "Desconecta do banco de dados. Retorna Self para encadeamento.",
                            example: "Connection.Disconnect; // Desconecta do banco"
                        },
                        {
                            signature: "function IsConnected: Boolean;",
                            comment: "Verifica se está conectado",
                            example: "if Connection.IsConnected then ShowMessage('Conectado');"
                        },
                        {
                            signature: "function Ping: Boolean;",
                            comment: "Testa a conexão",
                            example: "if Connection.Ping then ShowMessage('Conexão OK');"
                        },
                        {
                            signature: "function Reconnect: IConnection;",
                            comment: "Reconecta ao banco. Retorna Self para encadeamento.",
                            example: "Connection.Reconnect; // Reconecta ao banco"
                        },
                        {
                            signature: "function BeginTransaction: IConnection;",
                            comment: "Inicia uma transação. Retorna Self para encadeamento.",
                            example: "Connection.BeginTransaction; // Inicia transação"
                        },
                        {
                            signature: "function Commit: IConnection;",
                            comment: "Confirma a transação. Retorna Self para encadeamento.",
                            example: "Connection.Commit; // Confirma transação"
                        },
                        {
                            signature: "function Rollback: IConnection;",
                            comment: "Reverte a transação. Retorna Self para encadeamento.",
                            example: "Connection.Rollback; // Reverte transação"
                        },
                        {
                            signature: "function InTransaction: Boolean;",
                            comment: "Verifica se está em transação",
                            example: "if Connection.InTransaction then ShowMessage('Em transação');"
                        },
                        {
                            signature: "function ExecuteQuery(const ASQL: string): TObject;",
                            comment: "Executa uma query e retorna DataSet",
                            example: "var DataSet := Connection.ExecuteQuery('SELECT * FROM usuarios'); // Executa query e retorna DataSet"
                        },
                        {
                            signature: "function ExecuteCommand(const ASQL: string): Integer;",
                            comment: "Executa um comando (INSERT, UPDATE, DELETE) e retorna número de linhas afetadas",
                            example: "var rows := Connection.ExecuteCommand('INSERT INTO usuarios (nome) VALUES (''João'')'); // Retorna número de linhas afetadas"
                        },
                        {
                            signature: "function ExecuteScalar(const ASQL: string): Variant;",
                            comment: "Executa query e retorna valor único",
                            example: "var count := Connection.ExecuteScalar('SELECT COUNT(*) FROM usuarios'); // Retorna valor único"
                        },
                        {
                            signature: "function NativeConnection: TObject;",
                            comment: "Retorna a conexão nativa do engine (para casos especiais)",
                            example: "var nativeConn := Connection.NativeConnection; // Retorna conexão nativa (TFDConnection, TUniConnection, etc.)"
                        },
                        {
                            signature: "function NativeEngine: TDatabaseEngine;",
                            comment: "Retorna o engine nativo",
                            example: "var engine := Connection.NativeEngine; // Retorna engine nativo"
                        },
                        {
                            signature: "function GetConnectionInfo: TConnectionData;",
                            comment: "Retorna informações da conexão",
                            example: "var info := Connection.GetConnectionInfo; // Retorna informações completas da conexão"
                        },
                        {
                            signature: "function GetServerVersion: string;",
                            comment: "Retorna versão do servidor",
                            example: "var version := Connection.GetServerVersion; // Retorna versão do servidor (ex: 'PostgreSQL 14.5')"
                        },
                        {
                            signature: "function GetClientVersion: string;",
                            comment: "Retorna versão do cliente/engine",
                            example: "var version := Connection.GetClientVersion; // Retorna versão do cliente/engine"
                        },
                        {
                            signature: "function LoadTablesStructure: ITables;",
                            comment: "Carrega estrutura de todas as tabelas do banco (FUNÇÃO PRINCIPAL)",
                            example: "var Tables: ITables := Connection.LoadTablesStructure; // Carrega estrutura completa do banco"
                        },
                        {
                            signature: "function LoadTableStructure(const ATableName: string): ITable;",
                            comment: "Carrega estrutura de uma tabela específica",
                            example: "var Table: ITable := Connection.LoadTableStructure('usuarios'); // Carrega estrutura da tabela 'usuarios'"
                        },
                        {
                            signature: "function UsePool(Value: Boolean): IConnection; overload;",
                            comment: "Ativa/desativa pool de conexões. Retorna Self para encadeamento.",
                            example: "Connection.UsePool(True).PoolSize(10); // Ativa pool com tamanho 10"
                        },
                        {
                            signature: "function UsePool: Boolean; overload;",
                            comment: "Obtém status do pool de conexões",
                            example: "if Connection.UsePool then ShowMessage('Pool ativo');"
                        },
                        {
                            signature: "function PoolSize(Value: Integer): IConnection; overload;",
                            comment: "Define tamanho do pool. Retorna Self para encadeamento.",
                            example: "Connection.PoolSize(10); // Define tamanho do pool"
                        },
                        {
                            signature: "function PoolSize: Integer; overload;",
                            comment: "Obtém tamanho do pool",
                            example: "var size := Connection.PoolSize; // Retorna tamanho do pool"
                        },
                        {
                            signature: "function GetFromPool: IConnection;",
                            comment: "Obtém conexão do pool",
                            example: "var conn := Connection.GetFromPool; // Obtém conexão do pool"
                        },
                        {
                            signature: "function ReturnToPool: IConnection;",
                            comment: "Retorna conexão ao pool. Retorna Self para encadeamento.",
                            example: "Connection.ReturnToPool; // Retorna conexão ao pool"
                        }
                    ]
                }
            ]
        },
        {
            id: "connection-impl",
            name: "Database.Connetions",
            path: "src/Connetions/Database.Connetions.pas",
            description: `
                <p>Implementação da interface <code>IConnection</code>. Abstrai todos os engines de banco de dados (UniDAC, FireDAC, Zeos, SQLdb) através de uma interface única.</p>
                <p><strong>Hierarquia:</strong> Nível 8 - Field → Fields → Table → Tables → Database → TypeDatabase → Parameters → Connection</p>
                <p><strong>Funcionalidades:</strong></p>
                <ul>
                    <li>Abstração completa de engines (UniDAC, FireDAC, Zeos, SQLdb)</li>
                    <li>Suporte a múltiplas fontes de Parameters (INI, JSON, Database)</li>
                    <li>Gerenciamento de conexão (Connect, Disconnect, Ping, Reconnect)</li>
                    <li>Transações (BeginTransaction, Commit, Rollback)</li>
                    <li>Pool de conexões</li>
                    <li>Execução de queries e comandos SQL</li>
                    <li>Carregamento de estrutura de tabelas (função principal)</li>
                </ul>
                <p><strong>Integração com Parameters (Nível 7):</strong></p>
                <p>O <code>TConnection</code> usa o módulo Parameters como fonte única de verdade para dados de conexão. Ao invés de duplicar dados em memória, armazena apenas referência ao Parameters e busca valores em runtime quando necessário. Isso reduz uso de memória e garante que os valores sempre estejam atualizados.</p>
            `,
            classes: [
                {
                    name: "TConnection",
                    description: "Implementação da interface IConnection. Abstrai UniDAC, FireDAC, Zeos e SQLdb através de uma interface única. Usa o módulo Parameters (Nível 7) como fonte única de verdade para dados de conexão, buscando valores em runtime e evitando duplicação em memória.",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria uma nova instância de TConnection. Inicializa referência ao Parameters (fonte única de verdade) e configuração manual (usada apenas quando não usa Parameters).",
                            example: "var Connection: TConnection := TConnection.Create; // Cria nova instância"
                        },
                        {
                            signature: "destructor Destroy; override;",
                            comment: "Destrói a instância e libera recursos. Desconecta do banco, destrói conexão nativa e libera pool de conexões.",
                            example: "Connection.Free; // Destrói instância (gerenciado automaticamente por ARC)"
                        },
                        {
                            signature: "class function New: IConnection;",
                            comment: "Método factory para criar nova instância de IConnection. Retorna interface gerenciada automaticamente.",
                            example: "var Connection: IConnection := TDatabase.New; // Cria via factory"
                        },
                        {
                            signature: "function Engine(Value: TDatabaseEngine): IConnection; overload;",
                            comment: "Define o engine (UniDAC, FireDAC, Zeos, SQLdb). Valida se a engine está disponível nas diretivas de ORM.Defines.inc. Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Engine(teFireDAC); // Define engine FireDAC (configuração manual)"
                        },
                        {
                            signature: "function Engine: TDatabaseEngine; overload;",
                            comment: "Obtém o engine. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var engine := Connection.Engine; // Retorna engine atual"
                        },
                        {
                            signature: "function DatabaseType(Value: TDatabaseTypes): IConnection; overload;",
                            comment: "Define o tipo de banco (PostgreSQL, MySQL, etc.). Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.DatabaseType(dtPostgreSQL); // Define tipo PostgreSQL (configuração manual)"
                        },
                        {
                            signature: "function DatabaseType: TDatabaseTypes; overload;",
                            comment: "Obtém o tipo de banco. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var dbType := Connection.DatabaseType; // Retorna tipo de banco"
                        },
                        {
                            signature: "function Host(Value: string): IConnection; overload;",
                            comment: "Define o host do servidor. Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Host('localhost'); // Define host (configuração manual)"
                        },
                        {
                            signature: "function Host: string; overload;",
                            comment: "Obtém o host do servidor. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var host := Connection.Host; // Retorna host"
                        },
                        {
                            signature: "function Port(Value: Integer): IConnection; overload;",
                            comment: "Define a porta do servidor. Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Port(5432); // Define porta PostgreSQL (configuração manual)"
                        },
                        {
                            signature: "function Port: Integer; overload;",
                            comment: "Obtém a porta do servidor. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var port := Connection.Port; // Retorna porta"
                        },
                        {
                            signature: "function Database(Value: string): IConnection; overload;",
                            comment: "Define o nome do database. Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Database('mydb'); // Define nome do database (configuração manual)"
                        },
                        {
                            signature: "function Database: string; overload;",
                            comment: "Obtém o nome do database. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var dbName := Connection.Database; // Retorna nome do database"
                        },
                        {
                            signature: "function Schema(Value: string): IConnection; overload;",
                            comment: "Define o schema (PostgreSQL, SQL Server). Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Schema('public'); // Define schema (configuração manual)"
                        },
                        {
                            signature: "function Schema: string; overload;",
                            comment: "Obtém o schema. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var schema := Connection.Schema; // Retorna schema"
                        },
                        {
                            signature: "function Username(Value: string): IConnection; overload;",
                            comment: "Define o usuário. Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Username('postgres'); // Define usuário (configuração manual)"
                        },
                        {
                            signature: "function Username: string; overload;",
                            comment: "Obtém o usuário. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var user := Connection.Username; // Retorna usuário"
                        },
                        {
                            signature: "function Password(Value: string): IConnection; overload;",
                            comment: "Define a senha. Configuração manual (não recomendado - use Parameters). Retorna Self para encadeamento.",
                            example: "Connection.Password('mypass'); // Define senha (configuração manual)"
                        },
                        {
                            signature: "function Password: string; overload;",
                            comment: "Obtém a senha. Se estiver usando Parameters, busca do Parameters em runtime. Caso contrário, retorna configuração manual.",
                            example: "var pass := Connection.Password; // Retorna senha"
                        },
                        {
                            signature: "function ConnectionString(Value: string): IConnection; overload;",
                            comment: "Define a connection string completa. Retorna Self para encadeamento.",
                            example: "Connection.ConnectionString('Host=localhost;Database=mydb;...'); // Define connection string"
                        },
                        {
                            signature: "function ConnectionString: string; overload;",
                            comment: "Obtém a connection string completa",
                            example: "var connStr := Connection.ConnectionString; // Retorna connection string"
                        },
                        {
                            signature: "function FromIniFile(const AFileName: string; const ASection: string = 'database'): IConnection;",
                            comment: "Carrega configuração de arquivo INI usando o módulo Parameters. Retorna Self para encadeamento.",
                            example: "Connection.FromIniFile('config.ini', 'database').Connect; // Carrega de INI e conecta"
                        },
                        {
                            signature: "function FromJsonFile(const AFileName: string; const APath: string = 'database'): IConnection;",
                            comment: "Carrega configuração de arquivo JSON usando o módulo Parameters. Retorna Self para encadeamento.",
                            example: "Connection.FromJsonFile('config.json', 'database').Connect; // Carrega de JSON e conecta"
                        },
                        {
                            signature: "function FromDatabase(const AFileName: string; const ATableName: string = 'config'): IConnection;",
                            comment: "Carrega configuração de banco de dados (SQLite, etc.) usando o módulo Parameters. Retorna Self para encadeamento.",
                            example: "Connection.FromDatabase('config.db', 'config').Connect; // Carrega de Database e conecta"
                        },
                        {
                            signature: "function FromParameters(const AParameterName: string; const ASource: TDatabaseSource = TDatabaseSource.psNone): IConnection;",
                            comment: "Carrega configuração do módulo Parameters (Nível 7). Permite escolher a fonte: INI, JSON ou Database. Se ASource = psNone, auto-detecta a fonte. Retorna Self para encadeamento.",
                            example: "Connection.FromParameters('database').Connect; // Carrega de Parameters (INI) e conecta"
                        },
                        {
                            signature: "function Connect: IConnection;",
                            comment: "Conecta ao banco de dados. Cria conexão nativa do engine e configura parâmetros. Retorna Self para encadeamento.",
                            example: "Connection.Connect; // Conecta ao banco"
                        },
                        {
                            signature: "function Disconnect: IConnection;",
                            comment: "Desconecta do banco de dados. Fecha conexão nativa e limpa estado. Retorna Self para encadeamento.",
                            example: "Connection.Disconnect; // Desconecta do banco"
                        },
                        {
                            signature: "function IsConnected: Boolean;",
                            comment: "Verifica se está conectado ao banco de dados",
                            example: "if Connection.IsConnected then ShowMessage('Conectado');"
                        },
                        {
                            signature: "function Ping: Boolean;",
                            comment: "Testa a conexão com o banco de dados. Executa um comando simples para verificar se a conexão está ativa.",
                            example: "if Connection.Ping then ShowMessage('Conexão OK');"
                        },
                        {
                            signature: "function Reconnect: IConnection;",
                            comment: "Reconecta ao banco. Desconecta e conecta novamente. Retorna Self para encadeamento.",
                            example: "Connection.Reconnect; // Reconecta ao banco"
                        },
                        {
                            signature: "function BeginTransaction: IConnection;",
                            comment: "Inicia uma transação no banco de dados. Retorna Self para encadeamento.",
                            example: "Connection.BeginTransaction; // Inicia transação"
                        },
                        {
                            signature: "function Commit: IConnection;",
                            comment: "Confirma a transação atual. Retorna Self para encadeamento.",
                            example: "Connection.Commit; // Confirma transação"
                        },
                        {
                            signature: "function Rollback: IConnection;",
                            comment: "Reverte a transação atual. Retorna Self para encadeamento.",
                            example: "Connection.Rollback; // Reverte transação"
                        },
                        {
                            signature: "function InTransaction: Boolean;",
                            comment: "Verifica se está em uma transação ativa",
                            example: "if Connection.InTransaction then ShowMessage('Em transação');"
                        },
                        {
                            signature: "function ExecuteQuery(const ASQL: string): TObject;",
                            comment: "Executa uma query SQL e retorna DataSet compatível. O tipo retornado depende do engine (TFDQuery, TUniQuery, TZQuery, etc.).",
                            example: "var DataSet := Connection.ExecuteQuery('SELECT * FROM usuarios'); // Executa query e retorna DataSet"
                        },
                        {
                            signature: "function ExecuteCommand(const ASQL: string): Integer;",
                            comment: "Executa um comando SQL (INSERT, UPDATE, DELETE) e retorna número de linhas afetadas",
                            example: "var rows := Connection.ExecuteCommand('INSERT INTO usuarios (nome) VALUES (''João'')'); // Retorna número de linhas afetadas"
                        },
                        {
                            signature: "function ExecuteScalar(const ASQL: string): Variant;",
                            comment: "Executa uma query SQL e retorna o primeiro valor da primeira linha (valor único)",
                            example: "var count := Connection.ExecuteScalar('SELECT COUNT(*) FROM usuarios'); // Retorna valor único"
                        },
                        {
                            signature: "function NativeConnection: TObject;",
                            comment: "Retorna a conexão nativa do engine (TFDConnection, TUniConnection, TZConnection, etc.). Útil para casos especiais onde é necessário acessar funcionalidades específicas do engine.",
                            example: "var nativeConn := Connection.NativeConnection; // Retorna conexão nativa (TFDConnection, TUniConnection, etc.)"
                        },
                        {
                            signature: "function NativeEngine: TDatabaseEngine;",
                            comment: "Retorna o engine nativo usado pela conexão",
                            example: "var engine := Connection.NativeEngine; // Retorna engine nativo"
                        },
                        {
                            signature: "function GetConnectionInfo: TConnectionData;",
                            comment: "Retorna informações completas da conexão em uma estrutura TConnectionData (Engine, DatabaseType, Host, Port, Database, Schema, Username, Password)",
                            example: "var info := Connection.GetConnectionInfo; // Retorna informações completas da conexão"
                        },
                        {
                            signature: "function GetServerVersion: string;",
                            comment: "Retorna a versão do servidor de banco de dados",
                            example: "var version := Connection.GetServerVersion; // Retorna versão do servidor (ex: 'PostgreSQL 14.5')"
                        },
                        {
                            signature: "function GetClientVersion: string;",
                            comment: "Retorna a versão do cliente/engine (FireDAC, UniDAC, Zeos, etc.)",
                            example: "var version := Connection.GetClientVersion; // Retorna versão do engine (ex: 'FireDAC 10.2')"
                        },
                        {
                            signature: "function LoadTablesStructure: ITables;",
                            comment: "Carrega estrutura de todas as tabelas do banco de dados. Esta é uma das funções principais do Connection. Retorna ITables com todas as tabelas e campos mapeados.",
                            example: "var Tables := Connection.LoadTablesStructure; // Carrega estrutura de todas as tabelas"
                        },
                        {
                            signature: "function LoadTableStructure(const ATableName: string): ITable;",
                            comment: "Carrega estrutura de uma tabela específica do banco de dados. Esta é uma das funções principais do Connection. Retorna ITable com a tabela e seus campos mapeados.",
                            example: "var Table := Connection.LoadTableStructure('usuarios'); // Carrega estrutura da tabela 'usuarios'"
                        },
                        {
                            signature: "function UsePool(Value: Boolean): IConnection; overload;",
                            comment: "Ativa ou desativa o pool de conexões. Retorna Self para encadeamento.",
                            example: "Connection.UsePool(True); // Ativa pool de conexões"
                        },
                        {
                            signature: "function UsePool: Boolean; overload;",
                            comment: "Verifica se o pool de conexões está ativo",
                            example: "if Connection.UsePool then ShowMessage('Pool ativo');"
                        },
                        {
                            signature: "function PoolSize(Value: Integer): IConnection; overload;",
                            comment: "Define o tamanho do pool de conexões. Retorna Self para encadeamento.",
                            example: "Connection.PoolSize(10); // Define tamanho do pool"
                        },
                        {
                            signature: "function PoolSize: Integer; overload;",
                            comment: "Obtém o tamanho do pool de conexões",
                            example: "var size := Connection.PoolSize; // Retorna tamanho do pool"
                        },
                        {
                            signature: "function GetFromPool: IConnection;",
                            comment: "Obtém uma conexão do pool. Retorna uma conexão disponível ou cria nova se o pool não estiver cheio.",
                            example: "var pooledConn := Connection.GetFromPool; // Obtém conexão do pool"
                        },
                        {
                            signature: "function ReturnToPool: IConnection;",
                            comment: "Retorna uma conexão ao pool. Retorna Self para encadeamento.",
                            example: "Connection.ReturnToPool; // Retorna conexão ao pool"
                        }
                    ]
                }
            ]
        },
        {
            id: "attributes-interfaces",
            name: "Database.Attributes.Interfaces",
            path: "src/Attributes/Database.Attributes.Interfaces.pas",
            description: `
                <p>Define interfaces para parsing e mapeamento de atributos via RTTI.</p>
                <p><strong>Hierarquia:</strong> Attributes (Runtime) → Table (Nível 3) → Tables (Nível 4) → Connection (Nível 8)</p>
            `,
            interfaces: [
                {
                    name: "IAttributeParser",
                    guid: "{B1C2D3E4-F5A6-7890-ABCD-EF1234567890}",
                    description: "Interface para parsing de atributos via RTTI. Responsável por converter classes Pascal com atributos em estruturas ITable e IFields do Database ORM. Usa RTTI para ler atributos em runtime. Funcionalidades: Parsing de classes com atributos para ITable/IFields, Extração de informações de tabela (nome, schema), Identificação de campos Primary Key, Validação de atributos.",
                    methods: [
                        {
                            signature: "function ParseClass(const AClassType: TClass): ITable; overload;",
                            comment: "Converte classe com atributos em ITable completa. Parâmetros: AClassType - Tipo da classe (TClass) a ser parseada. Retorno: ITable com estrutura completa (campos, Primary Keys, etc.). Exceção: EDatabaseAttributeException se classe não tiver [Table] ou RTTI.",
                            example: "var Table: ITable := Parser.ParseClass(TUsuario); // Converte classe TUsuario em ITable"
                        },
                        {
                            signature: "function ParseClass(const AInstance: TObject): ITable; overload;",
                            comment: "Converte instância de classe com atributos em ITable completa (com valores). Parâmetros: AInstance - Instância da classe a ser parseada. Retorno: ITable com estrutura e valores da instância. Nota: Preenche valores dos campos a partir das propriedades da instância.",
                            example: "var Table: ITable := Parser.ParseClass(UsuarioInstance); // Converte instância em ITable com valores"
                        },
                        {
                            signature: "function ParseClassToFields(const AClassType: TClass): IFields; overload;",
                            comment: "Converte classe em IFields (apenas campos, sem ITable). Parâmetros: AClassType - Tipo da classe (TClass) a ser parseada. Retorno: IFields com todos os campos mapeados. Nota: Útil quando precisa apenas dos campos, não da tabela completa.",
                            example: "var Fields: IFields := Parser.ParseClassToFields(TUsuario); // Converte classe em IFields"
                        },
                        {
                            signature: "function ParseClassToFields(const AInstance: TObject): IFields; overload;",
                            comment: "Converte instância em IFields (apenas campos, com valores). Parâmetros: AInstance - Instância da classe a ser parseada. Retorno: IFields com campos e valores da instância.",
                            example: "var Fields: IFields := Parser.ParseClassToFields(UsuarioInstance); // Converte instância em IFields"
                        },
                        {
                            signature: "function GetTableName(const AClassType: TClass): string; overload;",
                            comment: "Obtém nome da tabela da classe (do atributo [Table]). Parâmetros: AClassType - Tipo da classe. Retorno: Nome da tabela ou string vazia se não encontrado. Exceção: EDatabaseAttributeException se não tiver [Table].",
                            example: "var tableName := Parser.GetTableName(TUsuario); // Retorna 'usuarios'"
                        },
                        {
                            signature: "function GetTableName(const AInstance: TObject): string; overload;",
                            comment: "Obtém nome da tabela da instância. Parâmetros: AInstance - Instância da classe. Retorno: Nome da tabela.",
                            example: "var tableName := Parser.GetTableName(UsuarioInstance); // Retorna nome da tabela"
                        },
                        {
                            signature: "function GetSchemaName(const AClassType: TClass): string; overload;",
                            comment: "Obtém nome do schema da classe (do atributo [Schema]). Parâmetros: AClassType - Tipo da classe. Retorno: Nome do schema ou DEFAULT_SCHEMA se não encontrado.",
                            example: "var schemaName := Parser.GetSchemaName(TUsuario); // Retorna 'public' ou schema definido"
                        },
                        {
                            signature: "function GetSchemaName(const AInstance: TObject): string; overload;",
                            comment: "Obtém nome do schema da instância. Parâmetros: AInstance - Instância da classe. Retorno: Nome do schema.",
                            example: "var schemaName := Parser.GetSchemaName(UsuarioInstance); // Retorna nome do schema"
                        },
                        {
                            signature: "function GetPrimaryKeyFields(const AClassType: TClass): TStringArray; overload;",
                            comment: "Obtém lista de campos Primary Key da classe. Parâmetros: AClassType - Tipo da classe. Retorno: Array de strings com nomes dos campos Primary Key. Exceção: EDatabaseAttributeException se nenhuma Primary Key for encontrada.",
                            example: "var pks := Parser.GetPrimaryKeyFields(TUsuario); // Retorna ['id']"
                        },
                        {
                            signature: "function GetPrimaryKeyFields(const AInstance: TObject): TStringArray; overload;",
                            comment: "Obtém lista de campos Primary Key da instância. Parâmetros: AInstance - Instância da classe. Retorno: Array de strings com nomes dos campos Primary Key.",
                            example: "var pks := Parser.GetPrimaryKeyFields(UsuarioInstance); // Retorna array com campos Primary Key"
                        },
                        {
                            signature: "function GetFieldNames(const AClassType: TClass): TStringArray; overload;",
                            comment: "Obtém lista de todos os campos mapeados da classe. Parâmetros: AClassType - Tipo da classe. Retorno: Array de strings com nomes de todos os campos (exceto [Ignore]).",
                            example: "var fields := Parser.GetFieldNames(TUsuario); // Retorna ['id', 'nome', 'email']"
                        },
                        {
                            signature: "function GetFieldNames(const AInstance: TObject): TStringArray; overload;",
                            comment: "Obtém lista de todos os campos mapeados da instância. Parâmetros: AInstance - Instância da classe. Retorno: Array de strings com nomes de todos os campos.",
                            example: "var fields := Parser.GetFieldNames(UsuarioInstance); // Retorna array com nomes dos campos"
                        },
                        {
                            signature: "function ValidateClass(const AClassType: TClass): Boolean; overload;",
                            comment: "Valida se classe tem atributos corretos (pelo menos [Table]). Parâmetros: AClassType - Tipo da classe a validar. Retorno: True se classe tem [Table] e RTTI disponível, False caso contrário.",
                            example: "if Parser.ValidateClass(TUsuario) then ShowMessage('Classe válida');"
                        },
                        {
                            signature: "function ValidateClass(const AInstance: TObject): Boolean; overload;",
                            comment: "Valida se instância tem atributos corretos. Parâmetros: AInstance - Instância da classe a validar. Retorno: True se válida, False caso contrário.",
                            example: "if Parser.ValidateClass(UsuarioInstance) then ShowMessage('Instância válida');"
                        }
                    ]
                },
                {
                    name: "IAttributeMapper",
                    guid: "{C2D3E4F5-A6B7-8901-CDEF-123456789012}",
                    description: "Interface para mapeamento bidirecional Classe ↔ ITable. Responsável por mapear valores entre classes Pascal e estruturas ITable. Permite conversão bidirecional: Classe → ITable e ITable → Classe. Funcionalidades: Conversão Classe → ITable (com valores), Conversão ITable → Classe (preenche propriedades), Acesso individual a valores de campos.",
                    methods: [
                        {
                            signature: "function MapClassToTable(const AClassType: TClass): ITable; overload;",
                            comment: "Converte classe em ITable completa (sem valores). Parâmetros: AClassType - Tipo da classe (TClass) a ser mapeada. Retorno: ITable com estrutura completa da classe. Nota: Usa IAttributeParser internamente para parsing.",
                            example: "var Table: ITable := Mapper.MapClassToTable(TUsuario); // Converte classe em ITable"
                        },
                        {
                            signature: "function MapClassToTable(const AInstance: TObject): ITable; overload;",
                            comment: "Converte instância de classe em ITable completa (com valores). Parâmetros: AInstance - Instância da classe a ser mapeada. Retorno: ITable com estrutura e valores da instância.",
                            example: "var Table: ITable := Mapper.MapClassToTable(Usuario); // Converte instância em ITable com valores"
                        },
                        {
                            signature: "function MapTableToClass(const ATable: ITable; AInstance: TObject): IAttributeMapper; overload;",
                            comment: "Preenche instância da classe com dados de ITable. Parâmetros: ATable - ITable com dados a serem mapeados, AInstance - Instância da classe a ser preenchida. Retorno: Self (para Fluent API). Nota: Mapeia valores de ITable para propriedades da instância usando RTTI.",
                            example: "Mapper.MapTableToClass(Table, Usuario); // Preenche Usuario.Nome, Usuario.Email, etc."
                        },
                        {
                            signature: "function SetFieldValue(AInstance: TObject; const AFieldName: string; const AValue: Variant): IAttributeMapper; overload;",
                            comment: "Define valor de campo na classe usando nome do campo do banco. Parâmetros: AInstance - Instância da classe, AFieldName - Nome do campo no banco (não nome da propriedade), AValue - Valor a ser definido (Variant). Retorno: Self (para Fluent API). Nota: Busca propriedade pelo atributo [Field] correspondente.",
                            example: "Mapper.SetFieldValue(Usuario, 'nome', 'João Silva'); // Define Usuario.Nome se [Field('nome')] estiver na propriedade"
                        },
                        {
                            signature: "function GetFieldValue(const AInstance: TObject; const AFieldName: string): Variant; overload;",
                            comment: "Obtém valor de campo da classe usando nome do campo do banco. Parâmetros: AInstance - Instância da classe, AFieldName - Nome do campo no banco (não nome da propriedade). Retorno: Valor da propriedade (Variant) ou Null se não encontrado. Nota: Busca propriedade pelo atributo [Field] correspondente.",
                            example: "var value := Mapper.GetFieldValue(Usuario, 'nome'); // Retorna Usuario.Nome se [Field('nome')] estiver na propriedade"
                        }
                    ]
                }
            ]
        },
        {
            id: "attributes-impl",
            name: "Database.Attributes",
            path: "src/Attributes/Database.Attributes.pas",
            description: `
                <p>Implementação das interfaces <code>IAttributeParser</code> e <code>IAttributeMapper</code> para parsing e mapeamento de atributos via RTTI.</p>
                <p><strong>Hierarquia:</strong> Attributes (Runtime) → Table (Nível 3) → Tables (Nível 4) → Connection (Nível 8)</p>
            `,
            classes: [
                {
                    name: "TAttributeParser",
                    description: "Implementação da interface IAttributeParser. Responsável por converter classes Pascal com atributos em estruturas ITable e IFields usando RTTI para ler atributos em runtime.",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria instância de TAttributeParser. Inicializa contexto RTTI.",
                            example: "var Parser: TAttributeParser := TAttributeParser.Create; // Cria nova instância"
                        },
                        {
                            signature: "destructor Destroy; override;",
                            comment: "Destrói instância e libera contexto RTTI",
                            example: "Parser.Free; // Destrói instância (gerenciado automaticamente por ARC)"
                        },
                        {
                            signature: "class function New: IAttributeParser;",
                            comment: "Método factory para criar nova instância de IAttributeParser",
                            example: "var Parser: IAttributeParser := TAttributeParser.New; // Cria via factory"
                        },
                        {
                            signature: "function ParseClass(const AClassType: TClass): ITable; overload;",
                            comment: "Converte classe em ITable (sem valores). Parâmetros: AClassType - Tipo da classe. Retorno: ITable com estrutura completa. Exceção: EDatabaseAttributeException se não tiver [Table].",
                            example: "var Table: ITable := Parser.ParseClass(TUsuario); // Converte classe TUsuario em ITable"
                        },
                        {
                            signature: "function ParseClass(const AInstance: TObject): ITable; overload;",
                            comment: "Converte instância em ITable (com valores). Parâmetros: AInstance - Instância da classe. Retorno: ITable com estrutura e valores da instância.",
                            example: "var Table: ITable := Parser.ParseClass(Usuario); // Converte instância em ITable com valores"
                        },
                        {
                            signature: "function ParseClassToFields(const AClassType: TClass): IFields; overload;",
                            comment: "Converte classe em IFields (apenas campos). Parâmetros: AClassType - Tipo da classe. Retorno: IFields com todos os campos mapeados.",
                            example: "var Fields: IFields := Parser.ParseClassToFields(TUsuario); // Converte classe em IFields"
                        },
                        {
                            signature: "function ParseClassToFields(const AInstance: TObject): IFields; overload;",
                            comment: "Converte instância em IFields (campos com valores). Parâmetros: AInstance - Instância da classe. Retorno: IFields com campos e valores.",
                            example: "var Fields: IFields := Parser.ParseClassToFields(Usuario); // Converte instância em IFields"
                        },
                        {
                            signature: "function GetTableName(const AClassType: TClass): string; overload;",
                            comment: "Obtém nome da tabela da classe (do atributo [Table]). Parâmetros: AClassType - Tipo da classe. Retorno: Nome da tabela. Exceção: EDatabaseAttributeException se não tiver [Table].",
                            example: "var tableName := Parser.GetTableName(TUsuario); // Retorna 'usuarios'"
                        },
                        {
                            signature: "function GetTableName(const AInstance: TObject): string; overload;",
                            comment: "Obtém nome da tabela da instância. Parâmetros: AInstance - Instância da classe. Retorno: Nome da tabela.",
                            example: "var tableName := Parser.GetTableName(Usuario); // Retorna nome da tabela"
                        },
                        {
                            signature: "function GetSchemaName(const AClassType: TClass): string; overload;",
                            comment: "Obtém nome do schema da classe (do atributo [Schema]). Parâmetros: AClassType - Tipo da classe. Retorno: Nome do schema ou DEFAULT_SCHEMA se não encontrado.",
                            example: "var schemaName := Parser.GetSchemaName(TUsuario); // Retorna 'public' ou schema definido"
                        },
                        {
                            signature: "function GetSchemaName(const AInstance: TObject): string; overload;",
                            comment: "Obtém nome do schema da instância. Parâmetros: AInstance - Instância da classe. Retorno: Nome do schema.",
                            example: "var schemaName := Parser.GetSchemaName(Usuario); // Retorna nome do schema"
                        },
                        {
                            signature: "function GetPrimaryKeyFields(const AClassType: TClass): TStringArray; overload;",
                            comment: "Obtém lista de campos Primary Key da classe. Parâmetros: AClassType - Tipo da classe. Retorno: Array com nomes dos campos Primary Key. Exceção: EDatabaseAttributeException se nenhuma Primary Key encontrada.",
                            example: "var pks := Parser.GetPrimaryKeyFields(TUsuario); // Retorna ['id']"
                        },
                        {
                            signature: "function GetPrimaryKeyFields(const AInstance: TObject): TStringArray; overload;",
                            comment: "Obtém lista de campos Primary Key da instância. Parâmetros: AInstance - Instância da classe. Retorno: Array com nomes dos campos Primary Key.",
                            example: "var pks := Parser.GetPrimaryKeyFields(Usuario); // Retorna array com campos Primary Key"
                        },
                        {
                            signature: "function GetFieldNames(const AClassType: TClass): TStringArray; overload;",
                            comment: "Obtém lista de todos os campos mapeados da classe. Parâmetros: AClassType - Tipo da classe. Retorno: Array com nomes de todos os campos (exceto [Ignore]).",
                            example: "var fields := Parser.GetFieldNames(TUsuario); // Retorna ['id', 'nome', 'email']"
                        },
                        {
                            signature: "function GetFieldNames(const AInstance: TObject): TStringArray; overload;",
                            comment: "Obtém lista de todos os campos mapeados da instância. Parâmetros: AInstance - Instância da classe. Retorno: Array com nomes de todos os campos.",
                            example: "var fields := Parser.GetFieldNames(Usuario); // Retorna array com nomes dos campos"
                        },
                        {
                            signature: "function ValidateClass(const AClassType: TClass): Boolean; overload;",
                            comment: "Valida se classe tem atributos corretos (pelo menos [Table]). Parâmetros: AClassType - Tipo da classe. Retorno: True se classe tem [Table] e RTTI disponível, False caso contrário.",
                            example: "if Parser.ValidateClass(TUsuario) then ShowMessage('Classe válida');"
                        },
                        {
                            signature: "function ValidateClass(const AInstance: TObject): Boolean; overload;",
                            comment: "Valida se instância tem atributos corretos. Parâmetros: AInstance - Instância da classe. Retorno: True se válida, False caso contrário.",
                            example: "if Parser.ValidateClass(Usuario) then ShowMessage('Instância válida');"
                        },
                        {
                            signature: "function GetFieldAttribute(const ARttiProperty: TRttiProperty): FieldAttribute;",
                            comment: "Obtém atributo [Field] da propriedade RTTI. Parâmetros: ARttiProperty - Propriedade RTTI. Retorno: FieldAttribute ou nil se não encontrado. Nota: Método público para uso externo (ex: TAttributeMapper).",
                            example: "var fieldAttr := Parser.GetFieldAttribute(RttiProperty); // Retorna FieldAttribute ou nil"
                        }
                    ]
                },
                {
                    name: "TAttributeMapper",
                    description: "Implementação da interface IAttributeMapper. Responsável por mapear valores entre classes Pascal e estruturas ITable. Permite conversão bidirecional: Classe → ITable e ITable → Classe, além de acesso individual a valores de campos usando nomes do banco de dados.",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria instância de TAttributeMapper. Inicializa contexto RTTI e parser de atributos.",
                            example: "var Mapper: TAttributeMapper := TAttributeMapper.Create; // Cria nova instância"
                        },
                        {
                            signature: "destructor Destroy; override;",
                            comment: "Destrói instância e libera recursos",
                            example: "Mapper.Free; // Destrói instância (gerenciado automaticamente por ARC)"
                        },
                        {
                            signature: "class function New: IAttributeMapper;",
                            comment: "Método factory para criar nova instância de IAttributeMapper",
                            example: "var Mapper: IAttributeMapper := TAttributeMapper.New; // Cria via factory"
                        },
                        {
                            signature: "function MapClassToTable(const AClassType: TClass): ITable; overload;",
                            comment: "Converte classe em ITable (sem valores). Parâmetros: AClassType - Tipo da classe. Retorno: ITable com estrutura completa. Nota: Delega para TAttributeParser.ParseClass.",
                            example: "var Table: ITable := Mapper.MapClassToTable(TUsuario); // Converte classe em ITable"
                        },
                        {
                            signature: "function MapClassToTable(const AInstance: TObject): ITable; overload;",
                            comment: "Converte instância em ITable (com valores). Parâmetros: AInstance - Instância da classe. Retorno: ITable com estrutura e valores. Nota: Delega para TAttributeParser.ParseClass.",
                            example: "var Table: ITable := Mapper.MapClassToTable(Usuario); // Converte instância em ITable com valores"
                        },
                        {
                            signature: "function MapTableToClass(const ATable: ITable; AInstance: TObject): IAttributeMapper; overload;",
                            comment: "Preenche instância da classe com dados de ITable. Parâmetros: ATable - ITable com dados, AInstance - Instância a ser preenchida. Retorno: Self (para Fluent API). Nota: Mapeia valores de ITable para propriedades usando RTTI e [Field].",
                            example: "Mapper.MapTableToClass(Table, Usuario); // Preenche Usuario com dados da Table"
                        },
                        {
                            signature: "function SetFieldValue(AInstance: TObject; const AFieldName: string; const AValue: Variant): IAttributeMapper; overload;",
                            comment: "Define valor de campo na classe usando nome do campo do banco. Parâmetros: AInstance - Instância da classe, AFieldName - Nome do campo no banco (não nome da propriedade), AValue - Valor a ser definido (Variant). Retorno: Self (para Fluent API). Nota: Busca propriedade pelo atributo [Field] correspondente.",
                            example: "Mapper.SetFieldValue(Usuario, 'nome', 'João'); // Define Usuario.Nome se [Field('nome')] estiver na propriedade"
                        },
                        {
                            signature: "function GetFieldValue(const AInstance: TObject; const AFieldName: string): Variant; overload;",
                            comment: "Obtém valor de campo da classe usando nome do campo do banco. Parâmetros: AInstance - Instância da classe, AFieldName - Nome do campo no banco (não nome da propriedade). Retorno: Valor da propriedade (Variant) ou Null se não encontrado. Nota: Busca propriedade pelo atributo [Field] correspondente.",
                            example: "var value := Mapper.GetFieldValue(Usuario, 'nome'); // Retorna Usuario.Nome se [Field('nome')] estiver na propriedade"
                        }
                    ]
                }
            ]
        },
        {
            id: "types",
            name: "Database.Types",
            path: "src/Commons/Database.Types.pas",
            description: `
                <p>Define tipos, enums e estruturas de dados utilizados pelo módulo Database.</p>
                <p><strong>Tipos Principais:</strong> TDatabaseEngine, TDatabaseTypes, TDatabaseStatus, TConnectionData, TVariableType, TDatabaseTypeVariable, TDatabaseFields</p>
            `,
            types: [
                {
                    name: "TDatabaseEngine",
                    definition: "(teNone, teUnidac, teFireDAC, teZeos)",
                    comment: "Enum que representa o engine de acesso ao banco de dados (UniDAC, FireDAC, Zeos)"
                },
                {
                    name: "TDatabaseTypes",
                    definition: "(dtNone, dtFireBird, dtMySQL, dtPostgreSQL, dtSQLServer, dtSQLite, dtAccess, dtODBC)",
                    comment: "Enum que representa o tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                },
                {
                    name: "TDatabaseStatus",
                    definition: "(dsNone, dsInactive, dsEdit, dsInsert, dsDeleted)",
                    comment: "Enum que representa o estado do banco de dados"
                },
                {
                    name: "TConnectionData",
                    definition: "record com Engine, DatabaseType, Database, Schema, Host, Port, Username, Password",
                    comment: "Estrutura que armazena informações completas de uma conexão"
                },
                {
                    name: "TVariableType",
                    definition: "class com Numeric, Character, Time, Date, DateTime, Boolean",
                    comment: "Classe que armazena tipos de variáveis suportados por um banco de dados específico"
                },
                {
                    name: "TDatabaseTypeVariable",
                    definition: "(ptNone, ptNumericInteger, ptNumericFloat, ptCharacterString, ptCharacterText, ptCharacterChar, ptDatetime, ptDatetimeTime, ptDatetimeDate, ptBoolean, ptBooleanInteger)",
                    comment: "Enum que representa o tipo de variável de um campo (numérico, texto, data, etc.)"
                },
                {
                    name: "TDatabaseFields",
                    definition: "class com Table, Column, ColumnType, ColumnTypeCode, IsNull, Value, ToDefault, IsChanged, IsPKey, Position, ConstraintName",
                    comment: "Classe que armazena dados detalhados de um campo de banco de dados"
                },
                {
                    name: "TStringArray",
                    definition: "array of string (FPC) ou System.TArray<string> (Delphi)",
                    comment: "Array de strings compatível com FPC e Delphi"
                },
                {
                    name: "TByteArray",
                    definition: "array of Byte (FPC) ou System.TArray<Byte> (Delphi)",
                    comment: "Array de bytes compatível com FPC e Delphi"
                }
            ],
            functions: [
                {
                    signature: "function GetVariableTypesForDatabase(const ADatabaseType: TDatabaseTypes; const AFireBirdVersion3: Boolean = False): TVariableType;",
                    comment: "Retorna os tipos de variáveis suportados por um tipo de banco de dados específico",
                    example: "var varTypes := GetVariableTypesForDatabase(dtPostgreSQL); // Retorna tipos suportados pelo PostgreSQL"
                },
                {
                    signature: "function IsTypeInList(const ADataType, ATypeList: string): Boolean;",
                    comment: "Verifica se um tipo de dado está presente em uma lista de tipos separados por vírgula",
                    example: "if IsTypeInList('varchar', 'varchar,char,text') then ... // Verifica se 'varchar' está na lista"
                },
                {
                    signature: "function GetVariableType(const ADataType: string; const ADatabaseType: TDatabaseTypes; const AFireBirdVersion3: Boolean = False): TDatabaseTypeVariable;",
                    comment: "Determina o tipo de variável (TDatabaseTypeVariable) baseado no tipo de dado e banco de dados",
                    example: "var varType := GetVariableType('VARCHAR', dtPostgreSQL); // Retorna ptCharacterString"
                }
            ]
        },
        {
            id: "exceptions",
            name: "Database.Exceptions",
            path: "src/Commons/Database.Exceptions.pas",
            description: `
                <p>Define exceções customizadas e mensagens de erro para o módulo Database.</p>
                <p><strong>Estrutura:</strong> EDatabaseException (base) → Exceções específicas por categoria (Connection, SQL, Validation, etc.)</p>
            `,
            classes: [
                {
                    name: "EDatabaseException",
                    description: "Classe base para todas as exceções do módulo Database. Fornece ErrorCode e Operation para facilitar tratamento e logging.",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção com mensagem, código de erro e operação",
                            example: "raise EDatabaseException.Create('Erro ao conectar', 1001, 'Connect');"
                        },
                        {
                            signature: "property ErrorCode: Integer read FErrorCode;",
                            comment: "Código numérico do erro (facilita tratamento programático)",
                            example: "var code := Exception.ErrorCode; // Retorna código do erro"
                        },
                        {
                            signature: "property Operation: string read FOperation;",
                            comment: "Nome da operação que causou o erro (facilita debug)",
                            example: "var op := Exception.Operation; // Retorna nome da operação"
                        }
                    ]
                },
                {
                    name: "EDatabaseConnectionException",
                    description: "Exceção específica para erros de conexão com o banco de dados",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção de conexão",
                            example: "raise EDatabaseConnectionException.Create('Falha na conexão', ERR_CONNECTION_FAILED, 'Connect');"
                        }
                    ]
                },
                {
                    name: "EDatabaseSQLException",
                    description: "Exceção específica para erros de SQL",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção de SQL",
                            example: "raise EDatabaseSQLException.Create('SQL inválido', ERR_SQL_INVALID, 'ExecuteQuery');"
                        }
                    ]
                },
                {
                    name: "EDatabaseValidationException",
                    description: "Exceção específica para erros de validação",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção de validação",
                            example: "raise EDatabaseValidationException.Create('Campo obrigatório vazio', ERR_VALIDATION_REQUIRED_FIELD, 'ValidateNotNullFields');"
                        }
                    ]
                },
                {
                    name: "EDatabaseNotFoundException",
                    description: "Exceção específica para recursos não encontrados",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção de não encontrado",
                            example: "raise EDatabaseNotFoundException.Create('Tabela não encontrada', ERR_TABLE_NOT_FOUND, 'GetTable');"
                        }
                    ]
                },
                {
                    name: "EDatabaseConfigurationException",
                    description: "Exceção específica para erros de configuração",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção de configuração",
                            example: "raise EDatabaseConfigurationException.Create('Configuração inválida', ERR_INVALID_CONFIGURATION, 'FromParameters');"
                        }
                    ]
                }
            ],
            constants: [
                {
                    name: "ERR_CONNECTION_NOT_ASSIGNED",
                    value: "1001",
                    comment: "Código de erro: Conexão não atribuída"
                },
                {
                    name: "ERR_CONNECTION_FAILED",
                    value: "1002",
                    comment: "Código de erro: Falha na conexão"
                },
                {
                    name: "ERR_SQL_EXECUTION_FAILED",
                    value: "1101",
                    comment: "Código de erro: Falha na execução de SQL"
                },
                {
                    name: "ERR_VALIDATION_REQUIRED_FIELD",
                    value: "1201",
                    comment: "Código de erro: Campo obrigatório vazio"
                },
                {
                    name: "ERR_TABLE_NOT_FOUND",
                    value: "1301",
                    comment: "Código de erro: Tabela não encontrada"
                },
                {
                    name: "ERR_INVALID_CONFIGURATION",
                    value: "1401",
                    comment: "Código de erro: Configuração inválida"
                }
            ]
        },
        {
            id: "consts",
            name: "Database.Consts",
            path: "src/Commons/Database.Consts.pas",
            description: `
                <p>Define todas as constantes utilizadas pelo sistema de database, incluindo valores padrão para configuração, mapeamentos de engines e tipos de banco.</p>
            `,
            constants: [
                {
                    name: "DEFAULT_DATABASE_ENGINE",
                    value: "'UniDAC', 'FireDAC' ou 'Zeos' (conforme diretivas de compilação)",
                    comment: "Engine padrão conforme diretivas USE_UNIDAC, USE_FIREDAC ou USE_ZEOS"
                },
                {
                    name: "EngineDatabase",
                    value: "Array[TDatabaseEngine] of string",
                    comment: "Mapeamento de engines para strings: ('None', 'Unidac', 'FireDac', 'Zeos')"
                },
                {
                    name: "DatabaseFireDac",
                    value: "Array[TDatabaseTypes] of string",
                    comment: "Mapeamento de tipos de banco para strings do FireDAC: ('None', 'FB', 'MySQL', 'PG', 'SQLite', 'MSSQL', 'MSAcc', 'ODBC')"
                },
                {
                    name: "DatabaseZeus",
                    value: "Array[TDatabaseTypes] of string",
                    comment: "Mapeamento de tipos de banco para strings do Zeos: ('None', 'firebird', 'mysql', 'postgresql', 'sqlite', 'mssql', 'OleDB', 'odbc_a')"
                },
                {
                    name: "DatabaseUnidac",
                    value: "Array[TDatabaseTypes] of string",
                    comment: "Mapeamento de tipos de banco para strings do UniDAC: ('None', 'InterBase', 'MySQL', 'PostgreSQL', 'SQLite', 'SQL Server', 'Access', 'ODBC')"
                },
                {
                    name: "TDatabaseTypeNames",
                    value: "Array[TDatabaseTypes] of string",
                    comment: "Nomes genéricos de DatabaseTypes: ('None', 'Firebird', 'MySQL', 'PostgreSQL', 'SQLite', 'SQL Server', 'Access', 'ODBC')"
                },
                {
                    name: "DatabaseConfig",
                    value: "Array[TDatabaseTypes, TDatabaseEngine] of string",
                    comment: "Array bidimensional para mapear tipo de banco + engine"
                },
                {
                    name: "DEFAULT_CONFIG_HOST",
                    value: "'201.87.244.234'",
                    comment: "Host padrão para configuração"
                },
                {
                    name: "DEFAULT_CONFIG_PORT",
                    value: "5432",
                    comment: "Porta padrão para configuração"
                },
                {
                    name: "DEFAULT_CONFIG_USERNAME",
                    value: "'postgres'",
                    comment: "Usuário padrão para configuração"
                },
                {
                    name: "DEFAULT_CONFIG_DATABASE",
                    value: "'dbsgp'",
                    comment: "Database padrão para configuração"
                },
                {
                    name: "DEFAULT_CONFIG_SCHEMA",
                    value: "'dbcsl'",
                    comment: "Schema padrão para configuração"
                },
                {
                    name: "DEFAULT_CONFIG_TABLE",
                    value: "'config'",
                    comment: "Tabela padrão para configuração"
                }
            ]
        },
        {
            id: "connection-parameters",
            name: "Database.Connection.Paramenters",
            path: "src/Connetions/Database.Connection.Paramenters.pas",
            description: `
                <p>Classe helper para integração com o módulo externo Parameters (Nível 7). Encapsula toda a lógica de integração, separando responsabilidades do TConnection.</p>
                <p><strong>Hierarquia:</strong> Nível 8 - Field → Fields → Table → Tables → Database → TypeDatabase → Parameters → Connection</p>
                <p><strong>Responsabilidades:</strong></p>
                <ul>
                    <li>Converter entre tipos do Database ORM e tipos do Parameters</li>
                    <li>Carregar configurações de INI, JSON e Database</li>
                    <li>Retornar dados de conexão de forma padronizada</li>
                    <li>Gerenciar caminhos de arquivos de configuração</li>
                    <li>Buscar valores individuais em runtime (sem duplicar em memória)</li>
                </ul>
                <p><strong>Dependências:</strong></p>
                <ul>
                    <li>Módulo externo: <code>E:/CSL/ORM/src/Paramenters/</code></li>
                    <li>Database.Types (TDatabaseEngine, TDatabaseTypes, TDatabaseSource)</li>
                    <li>Database.Exceptions (EDatabaseConfigurationException)</li>
                    <li>Database.Consts (arrays de conversão)</li>
                </ul>
            `,
            types: [
                {
                    name: "TConnectionParametersData",
                    definition: "record com Engine, DatabaseType, Host, Port, Database, Schema, Username, Password",
                    comment: "Estrutura de dados que encapsula os parâmetros de conexão obtidos do módulo Parameters. Retorna todos os dados de conexão de forma padronizada, independente da fonte (INI, JSON, Database).",
                    fields: [
                        {
                            name: "Engine",
                            type: "TDatabaseEngine",
                            comment: "Engine de acesso ao banco de dados (FireDAC, UniDAC, Zeos, etc.)"
                        },
                        {
                            name: "DatabaseType",
                            type: "TDatabaseTypes",
                            comment: "Tipo de banco de dados (PostgreSQL, MySQL, SQL Server, etc.)"
                        },
                        {
                            name: "Host",
                            type: "string",
                            comment: "Hostname ou endereço IP do servidor de banco de dados"
                        },
                        {
                            name: "Port",
                            type: "Integer",
                            comment: "Porta do servidor de banco de dados"
                        },
                        {
                            name: "Database",
                            type: "string",
                            comment: "Nome do banco de dados"
                        },
                        {
                            name: "Schema",
                            type: "string",
                            comment: "Schema do banco de dados (PostgreSQL, SQL Server)"
                        },
                        {
                            name: "Username",
                            type: "string",
                            comment: "Nome de usuário para autenticação"
                        },
                        {
                            name: "Password",
                            type: "string",
                            comment: "Senha para autenticação"
                        }
                    ]
                }
            ],
            classes: [
                {
                    name: "TConnectionParameters",
                    description: "Classe helper que encapsula toda a lógica de integração com o módulo externo Parameters. Responsável por converter tipos, carregar configurações e retornar dados de conexão de forma padronizada.",
                    publicMethods: [
                        {
                            signature: "class function GetConfigBasePath: string;",
                            comment: "Retorna o caminho base para arquivos de configuração (pasta data/). Busca na ordem: pasta do executável/data/, pasta atual/data/, ou string vazia se não encontrado.",
                            example: "var basePath := TConnectionParameters.GetConfigBasePath; // Retorna 'data\\' ou caminho padrão"
                        },
                        {
                            signature: "class function ConvertParameterSource(const ASource: TDatabaseSource): Parameters.Types.TParameterSource;",
                            comment: "Converte TDatabaseSource do Database ORM para TParameterSource do módulo Parameters. Parâmetros: ASource - Fonte de parâmetros do Database ORM. Retorno: Fonte de parâmetros do módulo Parameters.",
                            example: "var paramSource := TConnectionParameters.ConvertParameterSource(psInifiles); // Converte para tipo do Parameters"
                        },
                        {
                            signature: "class function ConvertParameterDatabaseType(const AParamType: Parameters.Types.TParameterDatabaseTypes): TDatabaseTypes;",
                            comment: "Converte tipo de banco de dados do módulo Parameters para Database ORM. Parâmetros: AParamType - Tipo de banco do módulo Parameters. Retorno: Tipo de banco do Database ORM.",
                            example: "var dbType := TConnectionParameters.ConvertParameterDatabaseType(pdtPostgreSQL); // Converte para tipo do Database ORM"
                        },
                        {
                            signature: "class function ConvertParameterEngine(const AParamEngine: Parameters.Types.TParameterDatabaseEngine): TDatabaseEngine;",
                            comment: "Converte engine de acesso do módulo Parameters para Database ORM. Parâmetros: AParamEngine - Engine do módulo Parameters. Retorno: Engine do Database ORM.",
                            example: "var engine := TConnectionParameters.ConvertParameterEngine(pteFireDAC); // Converte para tipo do Database ORM"
                        },
                        {
                            signature: "class function ParseDatabaseType(const ATypeStr: string): TDatabaseTypes;",
                            comment: "Converte string para enum TDatabaseTypes. Parâmetros: ATypeStr - String com o nome do tipo de banco (ex: 'PostgreSQL', 'MySQL'). Retorno: Tipo de banco correspondente ou dtNone se não encontrado. Nota: Busca primeiro no array TDatabaseTypeNames, depois nos arrays de aliases por engine (DatabaseFireDac, DatabaseUnidac, DatabaseZeus).",
                            example: "var dbType := TConnectionParameters.ParseDatabaseType('PostgreSQL'); // Retorna dtPostgreSQL"
                        },
                        {
                            signature: "class function ParseEngine(const AEngineStr: string): TDatabaseEngine;",
                            comment: "Converte string para enum TDatabaseEngine. Parâmetros: AEngineStr - String com o nome da engine (ex: 'FireDAC', 'UniDAC', 'Zeos'). Retorno: Engine correspondente ou teNone se não encontrado. Nota: Suporta aliases: 'FD' para FireDAC, 'Z' para Zeos. Considera diretivas de ORM.Defines.inc para validação.",
                            example: "var engine := TConnectionParameters.ParseEngine('FireDAC'); // Retorna teFireDAC"
                        },
                        {
                            signature: "class function GetDefaultEngine: TDatabaseEngine;",
                            comment: "Retorna o engine padrão baseado nas diretivas de ORM.Defines.inc. Retorno: Engine padrão disponível (prioridade: UniDAC > FireDAC > Zeos). Nota: Verifica as diretivas {$DEFINE USE_UNIDAC}, {$DEFINE USE_FIREDAC}, {$DEFINE USE_ZEOS}.",
                            example: "var engine := TConnectionParameters.GetDefaultEngine; // Retorna engine padrão conforme USE_*"
                        },
                        {
                            signature: "class function IsEngineAvailable(const AEngine: TDatabaseEngine): Boolean;",
                            comment: "Verifica se uma engine está disponível (compilada). Parâmetros: AEngine - Engine a verificar. Retorno: True se a engine está disponível, False caso contrário. Nota: Verifica diretivas de ORM.Defines.inc.",
                            example: "if TConnectionParameters.IsEngineAvailable(teFireDAC) then ... // Verifica se FireDAC está disponível"
                        },
                        {
                            signature: "class function GetParamValue(const AParameters: Parameters.Interfaces.IParameters; const AKey: string; const ASource: Parameters.Types.TParameterSource): string;",
                            comment: "Busca um valor string do módulo Parameters. Parâmetros: AParameters - Instância do módulo Parameters, AKey - Chave do parâmetro (ex: 'hostname', 'username'), ASource - Fonte do parâmetro (INI, JSON, Database). Retorno: Valor do parâmetro ou string vazia se não encontrado.",
                            example: "var host := TConnectionParameters.GetParamValue(Parameters, 'hostname', psInifiles); // Obtém hostname"
                        },
                        {
                            signature: "class function GetParamValueAsInteger(const AParameters: Parameters.Interfaces.IParameters; const AKey: string; const ASource: Parameters.Types.TParameterSource; const ADefault: Integer = 0): Integer;",
                            comment: "Busca um valor inteiro do módulo Parameters. Parâmetros: AParameters - Instância do módulo Parameters, AKey - Chave do parâmetro (ex: 'port'), ASource - Fonte do parâmetro (INI, JSON, Database), ADefault - Valor padrão se não encontrado (padrão: 0). Retorno: Valor inteiro do parâmetro ou ADefault se não encontrado.",
                            example: "var port := TConnectionParameters.GetParamValueAsInteger(Parameters, 'port', psInifiles, 5432); // Obtém porta"
                        },
                        {
                            signature: "class function CreateParametersInstance(const ASource: Parameters.Types.TParameterSource; const AParameterName: string): Parameters.Interfaces.IParameters;",
                            comment: "Cria uma instância do módulo Parameters configurada para uma fonte específica. Parâmetros: ASource - Fonte de parâmetros (INI, JSON, Database), AParameterName - Nome da seção/path/tabela (ex: 'database'). Retorno: Instância configurada do módulo Parameters. Exceção: EDatabaseConfigurationException se a fonte não for suportada.",
                            example: "var params := TConnectionParameters.CreateParametersInstance(psInifiles, 'database'); // Cria instância de Parameters"
                        },
                        {
                            signature: "class function LoadFromSource(const AParameterName: string; const ASource: Parameters.Types.TParameterSource): TConnectionParametersData;",
                            comment: "Carrega todos os dados de conexão de uma fonte específica. Parâmetros: AParameterName - Nome da seção/path/tabela (ex: 'database'), ASource - Fonte de parâmetros (INI, JSON, Database). Retorno: Estrutura com todos os dados de conexão. Exceção: EDatabaseConfigurationException se houver erro ao carregar configuração.",
                            example: "var data := TConnectionParameters.LoadFromSource('database', psInifiles); // Carrega dados de INI"
                        },
                        {
                            signature: "class function GetEngine(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): TDatabaseEngine;",
                            comment: "Busca o engine de acesso ao banco de dados do módulo Parameters em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Engine de acesso ou engine padrão se não encontrado.",
                            example: "var engine := TConnectionParameters.GetEngine(Parameters, psInifiles); // Obtém engine"
                        },
                        {
                            signature: "class function GetDatabaseType(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): TDatabaseTypes;",
                            comment: "Busca o tipo de banco de dados do módulo Parameters em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Tipo de banco ou dtNone se não encontrado.",
                            example: "var dbType := TConnectionParameters.GetDatabaseType(Parameters, psInifiles); // Obtém tipo de banco"
                        },
                        {
                            signature: "class function GetHost(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): string;",
                            comment: "Busca o hostname do servidor de banco de dados em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Hostname ou string vazia se não encontrado. Nota: Tenta primeiro 'hostname', depois 'host' como fallback.",
                            example: "var host := TConnectionParameters.GetHost(Parameters, psInifiles); // Obtém host"
                        },
                        {
                            signature: "class function GetPort(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): Integer;",
                            comment: "Busca a porta do servidor de banco de dados em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Porta ou 0 se não encontrado.",
                            example: "var port := TConnectionParameters.GetPort(Parameters, psInifiles); // Obtém porta"
                        },
                        {
                            signature: "class function GetDatabase(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): string;",
                            comment: "Busca o nome do banco de dados em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Nome do banco ou string vazia se não encontrado. Nota: Tenta primeiro 'banco', depois 'database' como fallback.",
                            example: "var dbName := TConnectionParameters.GetDatabase(Parameters, psInifiles); // Obtém nome do database"
                        },
                        {
                            signature: "class function GetSchema(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): string;",
                            comment: "Busca o schema do banco de dados em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Schema ou string vazia se não encontrado.",
                            example: "var schema := TConnectionParameters.GetSchema(Parameters, psInifiles); // Obtém schema"
                        },
                        {
                            signature: "class function GetUsername(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): string;",
                            comment: "Busca o nome de usuário para autenticação em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Nome de usuário ou string vazia se não encontrado.",
                            example: "var username := TConnectionParameters.GetUsername(Parameters, psInifiles); // Obtém usuário"
                        },
                        {
                            signature: "class function GetPassword(const AParameters: Parameters.Interfaces.IParameters; const ASource: Parameters.Types.TParameterSource): string;",
                            comment: "Busca a senha para autenticação em runtime. Parâmetros: AParameters - Instância do módulo Parameters, ASource - Fonte do parâmetro. Retorno: Senha ou string vazia se não encontrado.",
                            example: "var password := TConnectionParameters.GetPassword(Parameters, psInifiles); // Obtém senha"
                        },
                        {
                            signature: "class function LoadFromIniFile(const AParameterName: string; const AFileName: string = ''): TConnectionParametersData;",
                            comment: "Carrega configuração de conexão de um arquivo INI. Parâmetros: AParameterName - Nome da seção no INI (ex: 'database'), AFileName - Caminho do arquivo INI (opcional, usa padrão data/config.ini se vazio). Retorno: Estrutura com todos os dados de conexão carregados. Exceção: EDatabaseConfigurationException se o arquivo INI não for encontrado.",
                            example: "var data := TConnectionParameters.LoadFromIniFile('database', ''); // Usa data/config.ini, seção [database]"
                        },
                        {
                            signature: "class function LoadFromJsonFile(const AParameterName: string; const AFileName: string = ''): TConnectionParametersData;",
                            comment: "Carrega configuração de conexão de um arquivo JSON. Parâmetros: AParameterName - Path no JSON (ex: 'database'), AFileName - Caminho do arquivo JSON (opcional, usa padrão data/config.json se vazio). Retorno: Estrutura com todos os dados de conexão carregados. Exceção: EDatabaseConfigurationException se o arquivo JSON não for encontrado.",
                            example: "var data := TConnectionParameters.LoadFromJsonFile('database', ''); // Usa data/config.json, path \"database\""
                        },
                        {
                            signature: "class function LoadFromDatabase(const AParameterName: string; const AFileName: string = ''): TConnectionParametersData;",
                            comment: "Carrega configuração de conexão de um banco de dados SQLite. Parâmetros: AParameterName - Nome da tabela no Database (ex: 'config'), AFileName - Caminho do arquivo SQLite (opcional, usa padrão data/dbcsl.db se vazio). Retorno: Estrutura com todos os dados de conexão carregados. Exceção: EDatabaseConfigurationException se o arquivo Database não for encontrado.",
                            example: "var data := TConnectionParameters.LoadFromDatabase('config', ''); // Usa data/dbcsl.db, tabela 'config'"
                        },
                        {
                            signature: "class function LoadFromParameters(const AParameterName: string; const ASource: TParameterSource = psNone): TConnectionParametersData;",
                            comment: "Carrega configuração do módulo Parameters com detecção automática de fonte. Parâmetros: AParameterName - Título/chave do parâmetro (seção/path/tabela, ex: 'database'), ASource - Fonte do parâmetro (psNone = auto-detecta, psInifiles, psJsonObject, psDatabase). Retorno: Estrutura com todos os dados de conexão carregados. Exceção: EDatabaseConfigurationException se nenhum arquivo de configuração for encontrado. Nota: Se ASource = psNone, tenta detectar automaticamente na ordem: 1. INI (data/config.ini), 2. JSON (data/config.json), 3. Database (data/dbcsl.db).",
                            example: "var data := TConnectionParameters.LoadFromParameters('database', psNone); // Auto-detecta e carrega"
                        }
                    ]
                }
            ]
        },
        {
            id: "attributes-types",
            name: "Database.Interfaces",
            path: "src/Attributes/Database.Interfaces.pas",
            description: `
                <p>Define todos os atributos (Custom Attributes) usados para mapeamento declarativo de classes Pascal para tabelas de banco de dados.</p>
                <p><strong>Hierarquia:</strong> Attributes (Runtime) → Table (Nível 3) → Tables (Nível 4) → Connection (Nível 8)</p>
            `,
            classes: [
                {
                    name: "TableAttribute",
                    description: "Atributo para mapear classe para tabela do banco de dados",
                    publicMethods: [
                        {
                            signature: "constructor Create(const ATableName: string);",
                            comment: "Cria atributo [Table] com nome da tabela",
                            example: "[Table('usuarios')] // Mapeia classe para tabela 'usuarios'"
                        },
                        {
                            signature: "property TableName: string read FTableName;",
                            comment: "Nome da tabela no banco de dados",
                            example: "var tableName := TableAttr.TableName; // Retorna 'usuarios'"
                        }
                    ]
                },
                {
                    name: "SchemaAttribute",
                    description: "Atributo para definir schema da tabela (PostgreSQL, SQL Server)",
                    publicMethods: [
                        {
                            signature: "constructor Create(const ASchemaName: string);",
                            comment: "Cria atributo [Schema] com nome do schema",
                            example: "[Schema('public')] // Define schema 'public'"
                        },
                        {
                            signature: "property SchemaName: string read FSchemaName;",
                            comment: "Nome do schema",
                            example: "var schemaName := SchemaAttr.SchemaName; // Retorna 'public'"
                        }
                    ]
                },
                {
                    name: "FieldAttribute",
                    description: "Atributo para mapear propriedade para campo do banco de dados",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AFieldName: string);",
                            comment: "Cria atributo [Field] com nome do campo",
                            example: "[Field('id')] // Mapeia propriedade para campo 'id'"
                        },
                        {
                            signature: "property FieldName: string read FFieldName;",
                            comment: "Nome do campo no banco de dados",
                            example: "var fieldName := FieldAttr.FieldName; // Retorna 'id'"
                        }
                    ]
                },
                {
                    name: "PrimaryKeyAttribute",
                    description: "Atributo para marcar campo como Primary Key",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria atributo [PrimaryKey]",
                            example: "[Field('id'), PrimaryKey] // Marca campo 'id' como Primary Key"
                        }
                    ]
                },
                {
                    name: "AutoIncAttribute",
                    description: "Atributo para marcar campo como Auto Increment",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria atributo [AutoInc]",
                            example: "[Field('id'), PrimaryKey, AutoInc] // Marca campo como Auto Increment"
                        }
                    ]
                },
                {
                    name: "NotNullAttribute",
                    description: "Atributo para marcar campo como NOT NULL (obrigatório)",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria atributo [NotNull]",
                            example: "[Field('nome'), NotNull] // Marca campo como obrigatório"
                        }
                    ]
                },
                {
                    name: "IgnoreAttribute",
                    description: "Atributo para ignorar propriedade no mapeamento",
                    publicMethods: [
                        {
                            signature: "constructor Create;",
                            comment: "Cria atributo [Ignore]",
                            example: "[Ignore] // Ignora propriedade no mapeamento"
                        }
                    ]
                },
                {
                    name: "DefaultAttribute",
                    description: "Atributo para definir valor padrão do campo",
                    publicMethods: [
                        {
                            signature: "constructor Create(const ADefaultValue: string);",
                            comment: "Cria atributo [Default] com valor padrão",
                            example: "[Field('status'), Default('ativo')] // Define valor padrão 'ativo'"
                        },
                        {
                            signature: "property DefaultValue: string read FDefaultValue;",
                            comment: "Valor padrão do campo",
                            example: "var defaultValue := DefaultAttr.DefaultValue; // Retorna 'ativo'"
                        }
                    ]
                },
                {
                    name: "SizeAttribute",
                    description: "Atributo para definir tamanho máximo do campo (VARCHAR, CHAR)",
                    publicMethods: [
                        {
                            signature: "constructor Create(const ASize: Integer);",
                            comment: "Cria atributo [Size] com tamanho máximo",
                            example: "[Field('nome'), Size(100)] // Define tamanho máximo de 100 caracteres"
                        },
                        {
                            signature: "property Size: Integer read FSize;",
                            comment: "Tamanho máximo do campo",
                            example: "var size := SizeAttr.Size; // Retorna 100"
                        }
                    ]
                },
                {
                    name: "PrecisionAttribute",
                    description: "Atributo para definir precisão de campo numérico (DECIMAL, NUMERIC)",
                    publicMethods: [
                        {
                            signature: "constructor Create(const APrecision, AScale: Integer);",
                            comment: "Cria atributo [Precision] com precisão e escala",
                            example: "[Field('valor'), Precision(10, 2)] // Define precisão 10, escala 2"
                        },
                        {
                            signature: "property Precision: Integer read FPrecision;",
                            comment: "Precisão total do campo numérico",
                            example: "var precision := PrecisionAttr.Precision; // Retorna 10"
                        },
                        {
                            signature: "property Scale: Integer read FScale;",
                            comment: "Casas decimais do campo numérico",
                            example: "var scale := PrecisionAttr.Scale; // Retorna 2"
                        }
                    ]
                },
                {
                    name: "HasOneAttribute",
                    description: "Atributo para relacionamento 1:1 (HasOne) - Futuro",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AEntityName: string);",
                            comment: "Cria atributo [HasOne] para relacionamento 1:1",
                            example: "[HasOne('Endereco')] // Define relacionamento 1:1 com Endereco"
                        }
                    ]
                },
                {
                    name: "HasManyAttribute",
                    description: "Atributo para relacionamento 1:N (HasMany) - Futuro",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AEntityName: string);",
                            comment: "Cria atributo [HasMany] para relacionamento 1:N",
                            example: "[HasMany('Pedidos')] // Define relacionamento 1:N com Pedidos"
                        }
                    ]
                },
                {
                    name: "BelongsToAttribute",
                    description: "Atributo para relacionamento N:1 (BelongsTo) - Futuro",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AEntityName: string);",
                            comment: "Cria atributo [BelongsTo] para relacionamento N:1",
                            example: "[BelongsTo('Usuario')] // Define relacionamento N:1 com Usuario"
                        }
                    ]
                }
            ],
            aliases: [
                {
                    name: "Tabela",
                    alias: "TableAttribute",
                    comment: "Alias em português para TableAttribute"
                },
                {
                    name: "Campo",
                    alias: "FieldAttribute",
                    comment: "Alias em português para FieldAttribute"
                },
                {
                    name: "PK",
                    alias: "PrimaryKeyAttribute",
                    comment: "Alias para PrimaryKeyAttribute"
                },
                {
                    name: "AutoInc",
                    alias: "AutoIncAttribute",
                    comment: "Alias para AutoIncAttribute"
                },
                {
                    name: "NotNull",
                    alias: "NotNullAttribute",
                    comment: "Alias para NotNullAttribute"
                },
                {
                    name: "Ignore",
                    alias: "IgnoreAttribute",
                    comment: "Alias para IgnoreAttribute"
                }
            ]
        },
        {
            id: "attributes-consts",
            name: "Database.Attributes.Consts",
            path: "src/Attributes/Database.Attributes.Consts.pas",
            description: `
                <p>Define constantes usadas pelo sistema de Attributes para mapeamento runtime.</p>
                <p><strong>Constantes:</strong> Mensagens de erro e valores padrão para campos, precisão, escala e schema.</p>
            `,
            constants: [
                {
                    name: "ERR_ATTRIBUTE_TABLE_NOT_FOUND",
                    value: "'Classe não possui atributo [Table]'",
                    comment: "Mensagem de erro quando classe não possui atributo [Table]. Usado quando uma classe é processada mas não tem o atributo obrigatório [Table]."
                },
                {
                    name: "ERR_ATTRIBUTE_FIELD_NOT_FOUND",
                    value: "'Propriedade não possui atributo [Field]'",
                    comment: "Mensagem de erro: Propriedade não possui atributo [Field]"
                },
                {
                    name: "ERR_ATTRIBUTE_INVALID_CLASS",
                    value: "'Classe inválida ou sem RTTI habilitado'",
                    comment: "Mensagem de erro: Classe inválida ou sem RTTI habilitado"
                },
                {
                    name: "ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE",
                    value: "'RTTI não disponível para esta classe'",
                    comment: "Mensagem de erro: RTTI não disponível para esta classe"
                },
                {
                    name: "ERR_ATTRIBUTE_PRIMARY_KEY_NOT_FOUND",
                    value: "'Nenhuma Primary Key encontrada na classe'",
                    comment: "Mensagem de erro: Nenhuma Primary Key encontrada na classe"
                },
                {
                    name: "ERR_ATTRIBUTE_INVALID_PROPERTY",
                    value: "'Propriedade inválida ou sem atributos'",
                    comment: "Mensagem de erro: Propriedade inválida ou sem atributos"
                },
                {
                    name: "DEFAULT_FIELD_SIZE",
                    value: "255",
                    comment: "Tamanho padrão para campos VARCHAR quando não especificado via [Size]. Valor padrão: 255 caracteres."
                },
                {
                    name: "DEFAULT_PRECISION",
                    value: "10",
                    comment: "Precisão padrão para campos numéricos quando não especificado via [Precision]. Valor padrão: 10 dígitos."
                },
                {
                    name: "DEFAULT_SCALE",
                    value: "2",
                    comment: "Escala padrão (casas decimais) para campos numéricos quando não especificado via [Precision]. Valor padrão: 2 casas decimais."
                },
                {
                    name: "DEFAULT_SCHEMA",
                    value: "'public'",
                    comment: "Schema padrão quando não especificado via [Schema]. Valor padrão: 'public' (comum em PostgreSQL)."
                }
            ]
        },
        {
            id: "attributes-exceptions",
            name: "Database.Attributes.Exceptions",
            path: "src/Attributes/Database.Attributes.Exceptions.pas",
            description: `
                <p>Define exceções customizadas para o sistema de Attributes (RTTI e mapeamento).</p>
                <p><strong>Hierarquia:</strong> EDatabaseException → EDatabaseConfigurationException → EDatabaseAttributeException</p>
            `,
            classes: [
                {
                    name: "EDatabaseAttributeException",
                    description: "Exceção específica para erros relacionados ao sistema de Attributes. Herda de EDatabaseConfigurationException.",
                    publicMethods: [
                        {
                            signature: "constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');",
                            comment: "Cria uma nova exceção de Attribute",
                            example: "raise EDatabaseAttributeException.Create('Classe sem [Table]', ERR_ATTRIBUTE_TABLE_NOT_FOUND_CODE, 'ParseClass');"
                        }
                    ]
                }
            ],
            constants: [
                {
                    name: "ERR_ATTRIBUTE_TABLE_NOT_FOUND_CODE",
                    value: "1301",
                    comment: "Código de erro: Atributo [Table] não encontrado"
                },
                {
                    name: "ERR_ATTRIBUTE_FIELD_NOT_FOUND_CODE",
                    value: "1302",
                    comment: "Código de erro: Atributo [Field] não encontrado"
                },
                {
                    name: "ERR_ATTRIBUTE_INVALID_CLASS_CODE",
                    value: "1303",
                    comment: "Código de erro: Classe inválida ou sem RTTI"
                },
                {
                    name: "ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE_CODE",
                    value: "1304",
                    comment: "Código de erro: RTTI não disponível"
                },
                {
                    name: "ERR_ATTRIBUTE_PRIMARY_KEY_NOT_FOUND_CODE",
                    value: "1305",
                    comment: "Código de erro: Primary Key não encontrada"
                },
                {
                    name: "ERR_ATTRIBUTE_INVALID_PROPERTY_CODE",
                    value: "1306",
                    comment: "Código de erro: Propriedade inválida"
                },
                {
                    name: "ERR_ATTRIBUTE_SCHEMA_NOT_FOUND_CODE",
                    value: "1307",
                    comment: "Código de erro: Schema não encontrado"
                },
                {
                    name: "ERR_ATTRIBUTE_PARSING_FAILED_CODE",
                    value: "1308",
                    comment: "Código de erro: Falha no parsing"
                },
                {
                    name: "ERR_ATTRIBUTE_MAPPING_FAILED_CODE",
                    value: "1309",
                    comment: "Código de erro: Falha no mapeamento"
                },
                {
                    name: "ERR_ATTRIBUTE_VALIDATION_FAILED_CODE",
                    value: "1310",
                    comment: "Código de erro: Falha na validação"
                }
            ],
            functions: [
                {
                    signature: "function CreateAttributeException(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção de Attribute com mensagem formatada",
                    example: "raise CreateAttributeException('Erro ao processar atributos', 1301, 'ParseClass');"
                },
                {
                    signature: "function CreateTableNotFoundException(const AClassName: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando atributo [Table] não é encontrado",
                    example: "raise CreateTableNotFoundException('TUsuario', 'ParseClass');"
                },
                {
                    signature: "function CreateFieldNotFoundException(const APropertyName: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando atributo [Field] não é encontrado",
                    example: "raise CreateFieldNotFoundException('Nome', 'ParseProperty');"
                },
                {
                    signature: "function CreateInvalidClassException(const AClassName: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando classe é inválida ou sem RTTI",
                    example: "raise CreateInvalidClassException('TUsuario', 'ParseClass');"
                },
                {
                    signature: "function CreateRTTINotAvailableException(const AClassName: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando RTTI não está disponível",
                    example: "raise CreateRTTINotAvailableException('TUsuario', 'GetRttiType');"
                },
                {
                    signature: "function CreatePrimaryKeyNotFoundException(const AClassName: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando Primary Key não é encontrada na classe. Parâmetros: AClassName - Nome da classe sem Primary Key, AOperation - Nome da operação (padrão: ''). Retorno: Exceção com código ERR_ATTRIBUTE_PRIMARY_KEY_NOT_FOUND_CODE.",
                    example: "raise CreatePrimaryKeyNotFoundException('TUsuario', 'GetPrimaryKeyFields');"
                },
                {
                    signature: "function CreateInvalidPropertyException(const APropertyName: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando propriedade é inválida ou sem atributos. Parâmetros: APropertyName - Nome da propriedade inválida, AOperation - Nome da operação (padrão: ''). Retorno: Exceção com código ERR_ATTRIBUTE_INVALID_PROPERTY_CODE.",
                    example: "raise CreateInvalidPropertyException('Nome', 'ParseProperty');"
                },
                {
                    signature: "function CreateParsingFailedException(const AClassName: string; const AError: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando parsing da classe falha. Parâmetros: AClassName - Nome da classe que falhou no parsing, AError - Mensagem de erro detalhada, AOperation - Nome da operação (padrão: ''). Retorno: Exceção com código ERR_ATTRIBUTE_PARSING_FAILED_CODE.",
                    example: "raise CreateParsingFailedException('TUsuario', 'Erro ao ler RTTI', 'ParseClass');"
                },
                {
                    signature: "function CreateMappingFailedException(const AClassName: string; const AError: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando mapeamento Classe → ITable falha. Parâmetros: AClassName - Nome da classe que falhou no mapeamento, AError - Mensagem de erro detalhada, AOperation - Nome da operação (padrão: ''). Retorno: Exceção com código ERR_ATTRIBUTE_MAPPING_FAILED_CODE.",
                    example: "raise CreateMappingFailedException('TUsuario', 'Erro ao criar ITable', 'MapClassToTable');"
                },
                {
                    signature: "function CreateValidationFailedException(const AClassName: string; const AError: string; const AOperation: string = ''): EDatabaseAttributeException;",
                    comment: "Cria exceção quando validação da classe falha. Parâmetros: AClassName - Nome da classe que falhou na validação, AError - Mensagem de erro detalhada, AOperation - Nome da operação (padrão: ''). Retorno: Exceção com código ERR_ATTRIBUTE_VALIDATION_FAILED_CODE.",
                    example: "raise CreateValidationFailedException('TUsuario', 'Primary Key não encontrada', 'ValidateClass');"
                }
            ]
        },
        {
            id: "database-interfaces",
            name: "Database.Interfaces",
            path: "src/Database.Interfaces.pas",
            description: `
                <p><strong>🔓 ARQUIVO PÚBLICO/EXTERNO</strong></p>
                <p>Este é o arquivo de interfaces públicas que deve ser usado externamente. Re-exporta todas as interfaces, tipos, exceções e constantes necessárias para uso do Database ORM em outros projetos.</p>
                <p><strong>Arquivos Públicos (3):</strong></p>
                <ul>
                    <li><code>Database.Interfaces.pas</code> (este arquivo - re-exporta interfaces)</li>
                    <li><code>Database.pas</code> (Factory class)</li>
                    <li><code>Database.dfm</code> (DataModule - opcional)</li>
                </ul>
                <p><strong>⚠️ IMPORTANTE:</strong> Todos os outros arquivos são internos e não devem ser acessados diretamente.</p>
                <p><strong>Re-exporta:</strong></p>
                <ul>
                    <li><strong>Interfaces:</strong> IConnection, ITables, ITable, IFields, IField</li>
                    <li><strong>Tipos:</strong> TDatabaseEngine, TDatabaseTypes, TDatabaseStatus, TDatabaseSource, TConnectionData, TStringArray</li>
                    <li><strong>Exceções:</strong> EDatabaseException, EDatabaseConnectionException, EDatabaseSQLException, EDatabaseValidationException, EDatabaseNotFoundException, EDatabaseConfigurationException</li>
                    <li><strong>Constantes:</strong> TDatabaseTypeNames, TEngineDatabase, DatabaseFireDac, DatabaseUnidac, etc.</li>
                    <li><strong>Attributes (condicional):</strong> IAttributeParser, IAttributeMapper, TableAttribute, FieldAttribute, etc.</li>
                </ul>
            `,
            notes: [
                {
                    title: "Uso Básico",
                    content: `
                        <pre><code>uses Database.Interfaces;

var Connection: IConnection;
Connection := TDatabase.New
  .FromParameters('database')
  .Connect;`
                },
                {
                    title: "Nota sobre Re-exportação",
                    content: `
                        <p>Em Pascal, quando incluímos units no "uses", todos os tipos, interfaces, exceções e constantes dessas units ficam automaticamente disponíveis. Não é necessário fazer type aliases ou re-exportações explícitas.</p>
                    `
                }
            ]
        },
        {
            id: "database",
            name: "Database",
            path: "src/Database.pas",
            description: `
                <p><strong>🔓 ARQUIVO PÚBLICO/EXTERNO</strong></p>
                <p>Este é o único arquivo que deve ser usado externamente para acessar o módulo Database ORM. Todas as implementações estão ocultas e acessíveis apenas via interfaces públicas.</p>
                <p><strong>Arquivos Públicos (3):</strong></p>
                <ul>
                    <li><code>Database.pas</code> (este arquivo - Factory class)</li>
                    <li><code>Database.Interfaces.pas</code> (Interfaces públicas)</li>
                    <li><code>Database.dfm</code> (DataModule - opcional)</li>
                </ul>
                <p><strong>⚠️ IMPORTANTE:</strong> Todos os outros arquivos são internos e não devem ser acessados diretamente.</p>
                <p><strong>Factory Pattern:</strong> A classe <code>TDatabase</code> fornece métodos estáticos para criar instâncias de todas as interfaces principais do sistema.</p>
            `,
            classes: [
                {
                    name: "TDatabase",
                    description: "Factory Class para criar instâncias de interfaces Database ORM. Fornece métodos estáticos (class methods) para criar conexões, tabelas, campos e parsers de Attributes.",
                    publicMethods: [
                        {
                            signature: "class function New: IConnection;",
                            comment: "Cria uma nova instância da interface IConnection que gerencia conexões com banco de dados através de múltiplos engines (UniDAC, FireDAC, Zeos, SQLdb).\n\nFinalidade:\n  Cria uma nova instância da interface IConnection que gerencia conexões com banco de dados através de múltiplos engines (UniDAC, FireDAC, Zeos, SQLdb).\n\nRetorno:\n  IConnection: Interface de conexão configurada e pronta para uso.",
                            example: "var Connection: IConnection;\nConnection := TDatabase.New\n  .FromParameters('database')\n  .Connect;"
                        },
                        {
                            signature: "class function NewTables: ITables;",
                            comment: "Cria uma nova instância da interface ITables que gerencia múltiplas tabelas do banco de dados, permitindo acesso fluente a tabelas e campos.\n\nFinalidade:\n  Cria uma nova instância da interface ITables que gerencia múltiplas tabelas do banco de dados, permitindo acesso fluente a tabelas e campos.\n\nRetorno:\n  ITables: Interface de gerenciamento de tabelas.",
                            example: `var Tables: ITables;
Tables := TDatabase.NewTables
  .Connection(Connection.NativeConnection)
  .LoadFromConnection;`
                        },
                        {
                            signature: "class function NewTable(const AFields: IFields; const ATableName: string): ITable;",
                            comment: "Cria uma nova instância da interface ITable que representa uma tabela individual com seus campos.\n\nFinalidade:\n  Cria uma nova instância da interface ITable que representa uma tabela individual com seus campos.\n\nParâmetros:\n  AFields: IFields - Container de campos para a tabela\n  ATableName: string - Nome da tabela\n\nRetorno:\n  ITable: Interface de tabela configurada.",
                            example: `var Fields: IFields;
var Table: ITable;
Fields := TDatabase.NewFields;
Table := TDatabase.NewTable(Fields, 'usuarios');`
                        },
                        {
                            signature: "class function NewFields: IFields;",
                            comment: "Cria uma nova instância da interface IFields que representa um container de campos para uma tabela.\n\nFinalidade:\n  Cria uma nova instância da interface IFields que representa um container de campos para uma tabela.\n\nRetorno:\n  IFields: Interface de container de campos.",
                            example: `var Fields: IFields;
Fields := TDatabase.NewFields;`
                        },
                        {
                            signature: "class function NewField(const AColumn: string; const AColumnType: string = ''; const AIsNull: Boolean = True): IField; overload;",
                            comment: "Cria uma nova instância da interface IField que representa um campo individual de uma tabela.\n\nFinalidade:\n  Cria uma nova instância da interface IField que representa um campo individual de uma tabela.\n\nParâmetros:\n  AColumn: string - Nome da coluna\n  AColumnType: string - Tipo da coluna (opcional)\n  AIsNull: Boolean - Se o campo permite NULL (opcional, padrão: True)\n\nRetorno:\n  IField: Interface de campo configurada.",
                            example: `var Field: IField;
Field := TDatabase.NewField('id', 'INTEGER', False);`
                        },
                        {
                            signature: "class function NewField: IField; overload;",
                            comment: "Cria uma nova instância vazia da interface IField.\n\nFinalidade:\n  Cria uma nova instância vazia da interface IField. Útil quando você quer configurar o campo manualmente depois.\n\nRetorno:\n  IField: Interface de campo vazia.",
                            example: `var Field: IField;
Field := TDatabase.NewField;
Field.Column := 'id';
Field.ColumnType := 'INTEGER';
Field.isNullBool := False;`
                        },
                        {
                            signature: "class function NewAttributeParser: IAttributeParser;",
                            comment: "Cria uma nova instância da interface IAttributeParser que permite analisar classes com Attributes (RTTI) e extrair informações de mapeamento.\n\nFinalidade:\n  Cria uma nova instância da interface IAttributeParser que permite analisar classes com Attributes (RTTI) e extrair informações de mapeamento.\n\nRetorno:\n  IAttributeParser: Interface de parser de attributes.\n\nDisponibilidade:\n  Disponível apenas quando {$DEFINE USE_ATTRIBUTES} está habilitado.",
                            example: `{$IF DEFINED(USE_ATTRIBUTES)}
var Parser: IAttributeParser;
Parser := TDatabase.NewAttributeParser;
var TableName: string := Parser.GetTableName(TUsuario);
{$ENDIF}`
                        },
                        {
                            signature: "class function NewAttributeMapper: IAttributeMapper;",
                            comment: "Cria uma nova instância da interface IAttributeMapper que permite mapear classes com Attributes para estruturas ITable/IFields.\n\nFinalidade:\n  Cria uma nova instância da interface IAttributeMapper que permite mapear classes com Attributes para estruturas ITable/IFields.\n\nRetorno:\n  IAttributeMapper: Interface de mapper de attributes.\n\nDisponibilidade:\n  Disponível apenas quando {$DEFINE USE_ATTRIBUTES} está habilitado.",
                            example: `{$IF DEFINED(USE_ATTRIBUTES)}
var Mapper: IAttributeMapper;
Mapper := TDatabase.NewAttributeMapper;
var Table: ITable := Mapper.MapClassToTable(TUsuario);
{$ENDIF}`
                        }
                    ]
                },
                {
                    name: "TDatabaseORM",
                    description: "DataModule opcional para integração com o ambiente Delphi/Lazarus. Pode ser usado para gerenciar conexões e tabelas em aplicações com DataModule.",
                    publicMethods: []
                }
            ],
            notes: [
                {
                    title: "Uso Básico",
                    content: `
<pre><code>uses Database, Database.Interfaces;

var Connection: IConnection;
Connection := TDatabase.New
  .FromParameters('database')
  .Connect;

var Tables: ITables;
Tables := TDatabase.NewTables
  .Connection(Connection.NativeConnection)
  .LoadFromConnection;</code></pre>
                    `
                },
                {
                    title: "Uso com Attributes",
                    content: `
<pre><code>uses Database, Database.Interfaces;

{$M+}  // Habilita RTTI para Attributes
type
  [Table('usuarios')]
  [Schema('public')]
  TUsuario = class
  end;

var Tables: ITables;
Tables := TDatabase.NewTables
  .Connection(Connection.NativeConnection)
  .LoadFromConnection;

var Table: ITable;
Table := Tables.TableFromClass(TUsuario.Create);</code></pre>
                    `
                }
            ]
        },
        {
            id: "database-dfm",
            name: "Database.dfm",
            path: "src/Database.dfm",
            description: `
                <p><strong>🔓 ARQUIVO PÚBLICO/EXTERNO (Opcional)</strong></p>
                <p>DataModule opcional para integração com o ambiente Delphi/Lazarus. Este arquivo define o formulário DataModule <code>TDatabaseORM</code> que pode ser usado para gerenciar conexões e tabelas em aplicações com DataModule.</p>
                <p><strong>Arquivos Públicos (3):</strong></p>
                <ul>
                    <li><code>Database.pas</code> (Factory class)</li>
                    <li><code>Database.Interfaces.pas</code> (Interfaces públicas)</li>
                    <li><code>Database.dfm</code> (este arquivo - DataModule opcional)</li>
                </ul>
                <p><strong>⚠️ IMPORTANTE:</strong> Este arquivo é opcional. Você pode usar o Database ORM sem ele, apenas usando a Factory class <code>TDatabase</code>.</p>
            `,
            notes: [
                {
                    title: "Uso do DataModule",
                    content: `
                        <p>O DataModule <code>TDatabaseORM</code> pode ser adicionado ao seu projeto Delphi/Lazarus para gerenciar conexões e tabelas de forma visual. No entanto, o uso da Factory class <code>TDatabase</code> é recomendado para maior flexibilidade.</p>
                    `
                }
            ]
        }
    ]
};
