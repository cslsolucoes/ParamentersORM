program ExemplosBuscarParametro;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Parameters.Types,              // Tipos: TParameter, TParameterList
  Parameters.Consts,             // Constantes (ParameterValueTypeNames)
  Parameters.Interfaces,         // Interfaces e tipos públicos
  Parameters;                     // Ponto de entrada público

{ =============================================================================
  Exemplos: Buscar Parâmetro Específico
  
  Este exemplo demonstra diferentes formas de buscar um parâmetro específico:
  1. Buscar usando IParametersDatabase
  2. Buscar usando IParameters (com fallback automático)
  3. Verificar se existe antes de buscar
  4. Tratamento de erros
  5. Buscar com filtros (ContratoID, ProdutoID)
  
  Autor: Claiton de Souza Linhares
  Data: 02/01/2026
  ============================================================================= }

var
  DB: IParametersDatabase;
  Parameters: IParameters;
  Param: TParameter;
  LSuccess: Boolean;
  LExists: Boolean;
  LDatabasePath: string;
  ParamNames: array[0..2] of string;
  ParamName: string;
  FoundCount: Integer;
  I: Integer;

begin
  try
    WriteLn('========================================');
    WriteLn('  Exemplos: Buscar Parâmetro Específico');
    WriteLn('========================================');
    WriteLn('');

    // Define o caminho do banco de dados
    LDatabasePath := 'E:\Pacote\ORM\Data\Config.db';
    
    WriteLn('Configurando conexão com banco SQLite...');
    WriteLn('Arquivo: ' + LDatabasePath);
    WriteLn('');

    // =============================================================================
    // EXEMPLO 1: Buscar usando IParametersDatabase (método direto)
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 1: Buscar com IParametersDatabase');
    WriteLn('========================================');
    WriteLn('');

    DB := TParameters.NewDatabase;
    DB.DatabaseType('SQLite')
      .Database(LDatabasePath)
      .TableName('config')
      .AutoCreateTable(False)
      .Connect(LSuccess);

    if not LSuccess then
    begin
      WriteLn('ERRO: Não foi possível conectar ao banco de dados!');
      ReadLn;
      Exit;
    end;

    WriteLn('✓ Conectado com sucesso!');
    WriteLn('');

    // Busca um parâmetro específico por nome
    WriteLn('Buscando parâmetro "database_host"...');
    Param := DB.Get('database_host');
    
    if Assigned(Param) then
    begin
      WriteLn('✓ Parâmetro encontrado!');
      WriteLn('  Nome: ' + Param.Name);
      WriteLn('  Valor: ' + Param.Value);
      WriteLn('  Tipo: ' + ParameterValueTypeNames[Param.ValueType]);
      WriteLn('  Descrição: ' + Param.Description);
      Param.Free; // IMPORTANTE: Liberar o objeto
    end
    else
    begin
      WriteLn('✗ Parâmetro não encontrado!');
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 2: Verificar se existe antes de buscar
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 2: Verificar se existe antes de buscar');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Verificando se parâmetro "api_timeout" existe...');
    LExists := DB.Exists('api_timeout');
    
    if LExists then
    begin
      WriteLn('✓ Parâmetro existe! Buscando...');
      Param := DB.Get('api_timeout');
      try
        WriteLn('  Nome: ' + Param.Name);
        WriteLn('  Valor: ' + Param.Value);
      finally
        Param.Free;
      end;
    end
    else
    begin
      WriteLn('✗ Parâmetro não existe!');
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 3: Buscar usando método com out parameter (Fluent Interface)
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 3: Buscar com Fluent Interface');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Buscando parâmetro "max_connections"...');
    DB.Get('max_connections', Param);
    
    if Assigned(Param) then
    begin
      WriteLn('✓ Parâmetro encontrado!');
      WriteLn('  Nome: ' + Param.Name);
      WriteLn('  Valor: ' + Param.Value);
      Param.Free;
    end
    else
    begin
      WriteLn('✗ Parâmetro não encontrado!');
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 4: Buscar com filtros (ContratoID e ProdutoID)
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 4: Buscar com filtros (ContratoID/ProdutoID)');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Configurando filtros: ContratoID=1, ProdutoID=1');
    DB.ContratoID(1).ProdutoID(1);
    
    WriteLn('Buscando parâmetro "erp_host" com filtros...');
    Param := DB.Get('erp_host');
    
    if Assigned(Param) then
    begin
      WriteLn('✓ Parâmetro encontrado!');
      WriteLn('  Nome: ' + Param.Name);
      WriteLn('  Valor: ' + Param.Value);
      WriteLn('  ContratoID: ' + IntToStr(Param.ContratoID));
      WriteLn('  ProdutoID: ' + IntToStr(Param.ProdutoID));
      Param.Free;
    end
    else
    begin
      WriteLn('✗ Parâmetro não encontrado com os filtros especificados!');
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 5: Buscar usando IParameters (com fallback automático)
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 5: Buscar com IParameters (fallback automático)');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Configurando múltiplas fontes (Database + INI)...');
    Parameters := TParameters.New([pcfDataBase, pcfInifile]);
    
    // Configura Database
    Parameters.Database
      .DatabaseType('SQLite')
      .Database(LDatabasePath)
      .TableName('config')
      .Connect(LSuccess);
    
    if LSuccess then
      WriteLn('✓ Database configurado e conectado!');
    
    // Configura INI como fallback
    Parameters.Inifiles
      .FilePath('E:\Pacote\ORM\Data\config.ini')
      .Section('Parameters');
    
    WriteLn('✓ INI configurado como fallback!');
    WriteLn('');

    // Define ordem de prioridade (Database primeiro, depois INI)
    Parameters.Priority([psDatabase, psInifiles]);
    
    WriteLn('Buscando parâmetro "database_port" (busca em cascata)...');
    WriteLn('Ordem: Database → INI');
    WriteLn('');
    
    Param := Parameters.Get('database_port');
    
    if Assigned(Param) then
    begin
      WriteLn('✓ Parâmetro encontrado!');
      WriteLn('  Nome: ' + Param.Name);
      WriteLn('  Valor: ' + Param.Value);
      WriteLn('  Tipo: ' + ParameterValueTypeNames[Param.ValueType]);
      Param.Free;
    end
    else
    begin
      WriteLn('✗ Parâmetro não encontrado em nenhuma fonte!');
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 6: Buscar em fonte específica usando IParameters
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 6: Buscar em fonte específica');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Buscando parâmetro "test_key" APENAS no Database...');
    Param := Parameters.Get('test_key', psDatabase);
    
    if Assigned(Param) then
    begin
      WriteLn('✓ Parâmetro encontrado no Database!');
      WriteLn('  Nome: ' + Param.Name);
      WriteLn('  Valor: ' + Param.Value);
      Param.Free;
    end
    else
    begin
      WriteLn('✗ Parâmetro não encontrado no Database!');
      WriteLn('  (Não busca em outras fontes quando especifica fonte)');
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 7: Tratamento de erros e validação
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 7: Tratamento de erros');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Buscando parâmetro com tratamento de erros...');
    try
      Param := DB.Get('invalid_parameter_name');
      
      if Assigned(Param) then
      begin
        WriteLn('✓ Parâmetro encontrado!');
        WriteLn('  Nome: ' + Param.Name);
        WriteLn('  Valor: ' + Param.Value);
        Param.Free;
      end
      else
      begin
        WriteLn('✗ Parâmetro não encontrado (retornou nil)');
        WriteLn('  Isso é normal - não é um erro, apenas não existe.');
      end;
    except
      on E: Exception do
      begin
        WriteLn('ERRO ao buscar parâmetro:');
        WriteLn('  Classe: ' + E.ClassName);
        WriteLn('  Mensagem: ' + E.Message);
      end;
    end;
    WriteLn('');

    // =============================================================================
    // EXEMPLO 8: Buscar múltiplos parâmetros
    // =============================================================================
    WriteLn('========================================');
    WriteLn('  EXEMPLO 8: Buscar múltiplos parâmetros');
    WriteLn('========================================');
    WriteLn('');

    WriteLn('Buscando vários parâmetros...');
    WriteLn('');

    // Lista de parâmetros para buscar
    ParamNames[0] := 'database_host';
    ParamNames[1] := 'database_port';
    ParamNames[2] := 'database_name';
    
    FoundCount := 0;
    for I := 0 to High(ParamNames) do
    begin
      ParamName := ParamNames[I];
      Param := DB.Get(ParamName);
      if Assigned(Param) then
      begin
        Inc(FoundCount);
        WriteLn('✓ ' + ParamName + ' = ' + Param.Value);
        Param.Free;
      end
      else
      begin
        WriteLn('✗ ' + ParamName + ' = (não encontrado)');
      end;
    end;
    
    WriteLn('');
    WriteLn('Total encontrado: ' + IntToStr(FoundCount) + ' de ' + IntToStr(Length(ParamNames)));
    WriteLn('');

    // Desconecta
    DB.Disconnect;
    WriteLn('Desconectado do banco de dados.');
    WriteLn('');

    WriteLn('========================================');
    WriteLn('  Todos os exemplos concluídos!');
    WriteLn('========================================');
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
