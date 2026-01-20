{ =============================================================================
  Exemplo: Migrar Tabela Existente
  =============================================================================
  
  Este exemplo demonstra como usar o método MigrateTable para atualizar
  a estrutura da tabela existente sem perder dados.
  
  O método MigrateTable:
  1. Verifica se a tabela existe
  2. Remove o índice UNIQUE antigo (idx_config_chave) se existir
  3. Cria o novo índice UNIQUE composto (idx_config_chave_titulo) se não existir
  
  Isso permite que chaves duplicadas existam em títulos diferentes.
  
  Autor: Claiton de Souza Linhares
  Data: 02/01/2026
  ============================================================================= }

program ExemploMigrateTable;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Parameters.Types,
  Parameters.Consts,
  Parameters.Interfaces,
  Parameters;

var
  DB: IParametersDatabase;
  LSuccess: Boolean;
  LDatabasePath: string;

begin
  try
    WriteLn('========================================');
    WriteLn('  Exemplo: Migrar Tabela Existente');
    WriteLn('========================================');
    WriteLn('');

    // Define o caminho do banco de dados
    LDatabasePath := 'E:\Pacote\ORM\Data\Config.db';
    
    WriteLn('Configurando conexão com banco SQLite...');
    WriteLn('Arquivo: ' + LDatabasePath);
    WriteLn('');

    // Cria instância de IParametersDatabase
    DB := TParameters.NewDatabase;
    
    // Configura conexão SQLite
    DB.DatabaseType('SQLite')
      .Database(LDatabasePath)
      .TableName('config');

    WriteLn('Conectando ao banco de dados...');
    
    // Conecta ao banco
    DB.Connect(LSuccess);
    
    if not LSuccess then
    begin
      WriteLn('ERRO: Não foi possível conectar ao banco de dados!');
      WriteLn('Verifique se o arquivo existe e está acessível.');
      ReadLn;
      Exit;
    end;
    
    WriteLn('✓ Conectado com sucesso!');
    WriteLn('');

    // Verifica se a tabela existe
    if not DB.TableExists then
    begin
      WriteLn('A tabela não existe. Use CreateTable() para criar.');
      WriteLn('');
      WriteLn('Pressione ENTER para sair...');
      ReadLn;
      Exit;
    end;

    WriteLn('Tabela encontrada. Iniciando migração...');
    WriteLn('');
    WriteLn('Migração irá:');
    WriteLn('  1. Remover índice antigo (idx_config_chave) se existir');
    WriteLn('  2. Criar índice novo (idx_config_chave_titulo) se não existir');
    WriteLn('');

    // Executa a migração
    DB.MigrateTable(LSuccess);
    
    if LSuccess then
    begin
      WriteLn('✓ Migração concluída com sucesso!');
      WriteLn('');
      WriteLn('Agora você pode inserir chaves duplicadas em títulos diferentes.');
      WriteLn('Exemplo:');
      WriteLn('  - Título "chat", chave "url" = permitido');
      WriteLn('  - Título "erp", chave "url" = permitido');
      WriteLn('  - Título "chat", chave "url" (duplicado) = bloqueado');
    end
    else
    begin
      WriteLn('ERRO: Falha na migração!');
      WriteLn('Verifique os logs para mais detalhes.');
    end;

    WriteLn('');
    WriteLn('========================================');
    WriteLn('  Migração concluída!');
    WriteLn('========================================');
    WriteLn('');

    // Desconecta do banco
    DB.Disconnect;
    WriteLn('Desconectado do banco de dados.');
    WriteLn('');
    WriteLn('Pressione ENTER para sair...');
    ReadLn;

  except
    on E: Exception do
    begin
      WriteLn('');
      WriteLn('========================================');
      WriteLn('  ERRO!');
      WriteLn('========================================');
      WriteLn('Classe: ' + E.ClassName);
      WriteLn('Mensagem: ' + E.Message);
      WriteLn('');
      WriteLn('Pressione ENTER para sair...');
      ReadLn;
    end;
  end;
end.
