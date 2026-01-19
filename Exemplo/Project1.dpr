program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Parameters.Types,              // Tipos: TParameter, TParameterList (deve vir primeiro)
  Parameters.Consts,             // Constantes (ParameterValueTypeNames)
  Parameters.Interfaces,         // Interfaces e tipos públicos
  Parameters;                     // Ponto de entrada público

{ =============================================================================
  Exemplo: Listar Parâmetros do Banco de Dados SQLite

  Este exemplo demonstra como:
  1. Conectar ao banco SQLite (Config.db)
  2. Criar tabela automaticamente se não existir
  3. Listar todos os parâmetros
  4. Buscar parâmetro por título e chave

  Autor: Claiton de Souza Linhares
  Data: 02/01/2026
  ============================================================================= }

var
  DB: IParametersDatabase;
  ParamList: TParameterList;
  Param: TParameter;
  Parameters: IParameters;
  I: Integer;
  LSuccess: Boolean;
  LCount: Integer;
  LDatabasePath: string;
  LValue: string; // Variável para armazenar o valor antes de liberar

begin
  try
    // Define o caminho do banco de dados
    LDatabasePath := 'E:\Pacote\ORM\Data\Config.db';

    WriteLn('Configurando conexão com banco SQLite...');
    WriteLn('Arquivo: ' + LDatabasePath);
    WriteLn('');

    // Cria instância de IParametersDatabase
    DB := TParameters.NewDatabase;

    // Configura conexão SQLite
    // Para SQLite, não precisa de Host, Port, Username, Password
    DB.DatabaseType('SQLite')           // Define tipo de banco
      .Database(LDatabasePath)          // Caminho completo do arquivo .db
      .TableName('config')              // Nome da tabela
      .AutoCreateTable(True);           // ✅ CORRIGIDO: Criar tabela automaticamente se não existir

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

    // Verifica se está conectado
    if not DB.IsConnected then
    begin
      WriteLn('ERRO: Conexão não estabelecida!');
      ReadLn;
      Exit;
    end;

    // Conta quantos parâmetros existem
    LCount := DB.Count;
    WriteLn('Total de parâmetros encontrados: ' + IntToStr(LCount));
    WriteLn('');

    if LCount = 0 then
    begin
      WriteLn('Nenhum parâmetro encontrado no banco de dados.');
      WriteLn('');
      WriteLn('Pressione ENTER para sair...');
      ReadLn;
      Exit;
    end;

    // Lista todos os parâmetros
    WriteLn('========================================');
    WriteLn('  Lista de Parâmetros');
    WriteLn('========================================');
    WriteLn('');

    ParamList := DB.List;
    try
      for I := 0 to ParamList.Count - 1 do
      begin
        Param := ParamList[I];

        WriteLn('--- Parâmetro #' + IntToStr(I + 1) + ' ---');
        WriteLn('ID: ' + IntToStr(Param.ID));
        WriteLn('Nome: ' + Param.Name);
        WriteLn('Valor: ' + Param.Value);
        WriteLn('Tipo: ' + ParameterValueTypeNames[Param.ValueType]);
        WriteLn('Descrição: ' + Param.Description);
        WriteLn('ContratoID: ' + IntToStr(Param.ContratoID));
        WriteLn('ProdutoID: ' + IntToStr(Param.ProdutoID));
        WriteLn('Ordem: ' + IntToStr(Param.Ordem));
        WriteLn('Título: ' + Param.Titulo);
        WriteLn('Ativo: ' + BoolToStr(Param.Ativo, True));
        WriteLn('Criado em: ' + DateTimeToStr(Param.CreatedAt));
        WriteLn('Atualizado em: ' + DateTimeToStr(Param.UpdatedAt));
        WriteLn('');
      end;
    finally
      // IMPORTANTE: Liberar a lista e todos os objetos
      ParamList.ClearAll;
      ParamList.Free;
    end;

    // ✅ CORRIGIDO: Busca por título e depois por chave
    // Armazena o valor antes de liberar o objeto
    Param := DB.Title('chat').Get('url');
    try
      if Assigned(Param) then
      begin
        LValue := Param.Value; // ✅ Armazena o valor antes de liberar
        WriteLn('Valor encontrado: ' + LValue);
      end
      else
      begin
        WriteLn('Parâmetro não encontrado!');
      end;
    finally
      if Assigned(Param) then
        Param.Free;
    end;

    WriteLn('');
    WriteLn('========================================');
    WriteLn('  Listagem concluída!');
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

