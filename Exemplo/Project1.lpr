program Project1;

{$mode objfpc}{$H+}

uses
  SysUtils,
  Math,                      // Para função Min
  Parameters.Types,
  Parameters.Consts,
  Parameters.Interfaces,
  Parameters;

{ =============================================================================
  Roteiro de Testes - Módulo Parameters
  
  Este programa testa todas as funcionalidades do módulo Parameters:
  1. Conexão com banco de dados
  2. CREATE (Inserir)
  3. READ (Buscar/Listar)
  4. UPDATE (Atualizar)
  5. DELETE (Deletar)
  6. Filtros (Título, ContratoID, ProdutoID)
  
  Autor: Claiton de Souza Linhares
  Data: 02/01/2026
  ============================================================================= }

var
  DB: IParametersDatabase;
  Param: TParameter;
  ParamList: TParameterList;
  I: Integer;
  LSuccess: Boolean;
  LExists: Boolean;
  LCount: Integer;
  LDatabasePath: string;
  TestPassed: Integer;
  TestFailed: Integer;

procedure Separador(const ATitulo: string);
begin
  WriteLn('');
  WriteLn('========================================');
  WriteLn('  ' + ATitulo);
  WriteLn('========================================');
  WriteLn('');
end;

procedure TestePassou(const AMensagem: string);
begin
  Inc(TestPassed);
  WriteLn('✓ PASSOU: ' + AMensagem);
end;

procedure TesteFalhou(const AMensagem: string);
begin
  Inc(TestFailed);
  WriteLn('✗ FALHOU: ' + AMensagem);
end;

begin
  TestPassed := 0;
  TestFailed := 0;
  
  try
    WriteLn('╔════════════════════════════════════════╗');
    WriteLn('║  ROTEIRO DE TESTES - MÓDULO PARAMETERS ║');
    WriteLn('╚════════════════════════════════════════╝');
    WriteLn('');
    
    // =========================================================================
    // TESTE 1: CONFIGURAÇÃO E CONEXÃO
    // =========================================================================
    Separador('TESTE 1: Configuração e Conexão');
    
    LDatabasePath := 'E:\Pacote\ORM\Data\Config.db';
    WriteLn('Arquivo do banco: ' + LDatabasePath);
    WriteLn('');
    
    DB := TParameters.NewDatabase;
    DB.DatabaseType('SQLite')
      .Database(LDatabasePath)
      .TableName('config')
      .AutoCreateTable(True);
    
    WriteLn('Conectando ao banco...');
    DB.Connect(LSuccess);
    
    if LSuccess and DB.IsConnected then
    begin
      TestePassou('Conexão estabelecida com sucesso');
    end
    else
    begin
      TesteFalhou('Não foi possível conectar ao banco');
      WriteLn('Pressione ENTER para sair...');
      ReadLn;
      Exit;
    end;
    
    // =========================================================================
    // TESTE 2: COUNT (Contar parâmetros)
    // =========================================================================
    Separador('TESTE 2: Count - Contar Parâmetros');
    
    LCount := DB.Count;
    WriteLn('Total de parâmetros no banco: ' + IntToStr(LCount));
    
    if LCount >= 0 then
      TestePassou('Count retornou valor válido')
    else
      TesteFalhou('Count retornou valor inválido');
    
    // =========================================================================
    // TESTE 3: CREATE - Inserir Parâmetros
    // =========================================================================
    Separador('TESTE 3: CREATE - Inserir Parâmetros');
    
    // Teste 3.1: Inserir parâmetro simples
    WriteLn('3.1 - Inserindo parâmetro "teste_simples"...');
    
    // Verifica se já existe antes de inserir
    if DB.Exists('teste_simples') then
    begin
      WriteLn('  ⚠ Parâmetro já existe, deletando antes de inserir...');
      DB.Delete('teste_simples', LSuccess);
    end;
    
    Param := TParameter.Create;
    Param.Name := 'teste_simples';
    Param.Value := 'valor_teste';
    Param.ValueType := pvtString;
    Param.Titulo := 'Testes';
    Param.Description := 'Parâmetro de teste simples';
    Param.ContratoID := 1;  // ✅ CORRIGIDO: Deve ser > 0
    Param.ProdutoID := 1;   // ✅ CORRIGIDO: Deve ser > 0
    Param.Ordem := 1;
    Param.Ativo := True;
    
    DB.Insert(Param, LSuccess);
    Param.Free;
    
    if LSuccess then
      TestePassou('Inserção de parâmetro simples')
    else
      TesteFalhou('Falha ao inserir parâmetro simples');
    
    // Teste 3.2: Inserir parâmetro com título específico
    WriteLn('');
    WriteLn('3.2 - Inserindo parâmetro "teste_titulo" no título "API"...');
    
    // Verifica se já existe antes de inserir
    if DB.Title('API').Exists('teste_titulo') then
    begin
      WriteLn('  ⚠ Parâmetro já existe, deletando antes de inserir...');
      DB.Title('API').Delete('teste_titulo', LSuccess);
    end;
    
    Param := TParameter.Create;
    Param.Name := 'teste_titulo';
    Param.Value := 'https://api.exemplo.com';
    Param.ValueType := pvtString;
    Param.Titulo := 'API';
    Param.Description := 'URL da API de teste';
    Param.ContratoID := 1;
    Param.ProdutoID := 1;
    Param.Ordem := 1;
    Param.Ativo := True;
    
    DB.Insert(Param, LSuccess);
    Param.Free;
    
    if LSuccess then
      TestePassou('Inserção de parâmetro com título específico')
    else
      TesteFalhou('Falha ao inserir parâmetro com título');
    
    // Teste 3.3: Inserir parâmetro Integer
    WriteLn('');
    WriteLn('3.3 - Inserindo parâmetro Integer "teste_integer"...');
    
    // Verifica se já existe antes de inserir
    if DB.Exists('teste_integer') then
    begin
      WriteLn('  ⚠ Parâmetro já existe, deletando antes de inserir...');
      DB.Delete('teste_integer', LSuccess);
    end;
    
    Param := TParameter.Create;
    Param.Name := 'teste_integer';
    Param.Value := '42';
    Param.ValueType := pvtInteger;
    Param.Titulo := 'Testes';
    Param.Description := 'Número de teste';
    Param.ContratoID := 1;  // ✅ CORRIGIDO: Deve ser > 0
    Param.ProdutoID := 1;   // ✅ CORRIGIDO: Deve ser > 0
    Param.Ordem := 1;
    Param.Ativo := True;
    
    DB.Insert(Param, LSuccess);
    Param.Free;
    
    if LSuccess then
      TestePassou('Inserção de parâmetro Integer')
    else
      TesteFalhou('Falha ao inserir parâmetro Integer');
    
    // =========================================================================
    // TESTE 4: READ - Buscar Parâmetros
    // =========================================================================
    Separador('TESTE 4: READ - Buscar Parâmetros');
    
    // Teste 4.1: Buscar por chave simples
    WriteLn('4.1 - Buscando parâmetro "teste_simples"...');
    Param := DB.Getter('teste_simples');
    
    if Assigned(Param) then
    begin
      if SameText(Param.Value, 'valor_teste') then
        TestePassou('Busca por chave simples retornou valor correto')
      else
        TesteFalhou('Busca retornou valor incorreto');
      Param.Free;
    end
    else
    begin
      TesteFalhou('Busca por chave simples retornou nil');
    end;
    
    // Teste 4.2: Buscar com filtro de título
    WriteLn('');
    WriteLn('4.2 - Buscando com filtro de título (Title("API").Getter("teste_titulo"))...');
    Param := DB.Title('API').Getter('teste_titulo');
    
    if Assigned(Param) then
    begin
      if SameText(Param.Titulo, 'API') and SameText(Param.Name, 'teste_titulo') then
        TestePassou('Busca com filtro de título funcionou corretamente')
      else
        TesteFalhou('Busca com filtro de título retornou parâmetro incorreto');
      Param.Free;
    end
    else
    begin
      TesteFalhou('Busca com filtro de título retornou nil');
    end;
    
    // Teste 4.3: Verificar se existe
    WriteLn('');
    WriteLn('4.3 - Verificando se parâmetro existe (Exists("teste_simples"))...');
    LExists := DB.Exists('teste_simples');
    
    if LExists then
      TestePassou('Método Exists retornou True corretamente')
    else
      TesteFalhou('Método Exists retornou False para parâmetro existente');
    
    // Teste 4.4: Listar todos os parâmetros
    WriteLn('');
    WriteLn('4.4 - Listando todos os parâmetros...');
    ParamList := DB.List;
    
    if Assigned(ParamList) then
    begin
      WriteLn('  Total encontrado: ' + IntToStr(ParamList.Count));
      if ParamList.Count > 0 then
      begin
        TestePassou('List retornou lista com ' + IntToStr(ParamList.Count) + ' parâmetros');
        
        // Exibe primeiros 3 parâmetros
        WriteLn('');
        WriteLn('  Primeiros parâmetros:');
        for I := 0 to Min(2, ParamList.Count - 1) do
        begin
          Param := ParamList[I];
          WriteLn('    - ' + Param.Name + ' = ' + Param.Value + ' (Título: ' + Param.Titulo + ')');
        end;
      end
      else
      begin
        TesteFalhou('List retornou lista vazia');
      end;
      
      ParamList.ClearAll;
      ParamList.Free;
    end
    else
    begin
      TesteFalhou('List retornou nil');
    end;
    
    // =========================================================================
    // TESTE 5: UPDATE - Atualizar Parâmetros
    // =========================================================================
    Separador('TESTE 5: UPDATE - Atualizar Parâmetros');
    
    // Teste 5.1: Atualizar valor simples
    WriteLn('5.1 - Atualizando valor do parâmetro "teste_simples"...');
    Param := DB.Getter('teste_simples');
    
    if Assigned(Param) then
    begin
      try
        WriteLn('  Valor antigo: ' + Param.Value);
        
        // ✅ CORRIGIDO: Garantir que ContratoID, ProdutoID e Titulo estão preenchidos
        if Param.ContratoID <= 0 then
          Param.ContratoID := 1;
        if Param.ProdutoID <= 0 then
          Param.ProdutoID := 1;
        if Trim(Param.Titulo) = '' then
          Param.Titulo := 'Testes';
        
        Param.Value := 'valor_atualizado_' + FormatDateTime('hhnnss', Now);
        Param.Description := 'Descrição atualizada em ' + DateTimeToStr(Now);
        
        DB.Setter(Param, LSuccess);
        
        if LSuccess then
        begin
          TestePassou('Atualização de parâmetro com Setter');
          
          // Verificar se realmente atualizou
          Param.Free;
          Param := DB.Getter('teste_simples');
          if Assigned(Param) then
          begin
            WriteLn('  Valor novo: ' + Param.Value);
            if Pos('valor_atualizado_', Param.Value) > 0 then
              TestePassou('Valor foi atualizado corretamente no banco')
            else
              TesteFalhou('Valor não foi atualizado no banco');
          end;
        end
        else
        begin
          TesteFalhou('Falha ao atualizar parâmetro com Setter');
        end;
      finally
        if Assigned(Param) then
          Param.Free;
      end;
    end
    else
    begin
      TesteFalhou('Não foi possível buscar parâmetro para atualizar');
    end;
    
    // Teste 5.2: Atualizar com Setter direto
    WriteLn('');
    WriteLn('5.2 - Atualizando com método Setter direto...');
    Param := DB.Title('API').Getter('teste_titulo');
    
    if Assigned(Param) then
    begin
      try
        WriteLn('  Valor antigo: ' + Param.Value);
        
        // ✅ CORRIGIDO: Garantir que ContratoID e ProdutoID estão preenchidos
        if Param.ContratoID <= 0 then
          Param.ContratoID := 1;
        if Param.ProdutoID <= 0 then
          Param.ProdutoID := 1;
        // Titulo já está preenchido pelo filtro Title('API')
        
        Param.Value := 'https://nova-api.exemplo.com';
        Param.Description := 'URL atualizada em ' + DateTimeToStr(Now);
        
        DB.Setter(Param, LSuccess);
        
        if LSuccess then
          TestePassou('Atualização com método Setter')
        else
          TesteFalhou('Falha ao atualizar com método Setter');
      finally
        Param.Free;
      end;
    end
    else
    begin
      TesteFalhou('Não foi possível buscar parâmetro para atualizar');
    end;
    
    // =========================================================================
    // TESTE 6: DELETE - Deletar Parâmetros
    // =========================================================================
    Separador('TESTE 6: DELETE - Deletar Parâmetros');
    
    // Teste 6.1: Deletar parâmetro
    WriteLn('6.1 - Deletando parâmetro "teste_integer"...');
    
    // Verificar se existe antes
    if DB.Exists('teste_integer') then
    begin
      WriteLn('  Parâmetro existe antes de deletar');
      DB.Delete('teste_integer', LSuccess);
      
      if LSuccess then
      begin
        TestePassou('Deleção de parâmetro');
        
        // Verificar se foi deletado
        if not DB.Exists('teste_integer') then
          TestePassou('Parâmetro foi deletado corretamente (não existe mais)')
        else
          TesteFalhou('Parâmetro ainda existe após deleção');
      end
      else
      begin
        TesteFalhou('Falha ao deletar parâmetro');
      end;
    end
    else
    begin
      TesteFalhou('Parâmetro não existe para deletar');
    end;
    
    // =========================================================================
    // TESTE 7: FILTROS (ContratoID e ProdutoID)
    // =========================================================================
    Separador('TESTE 7: Filtros (ContratoID e ProdutoID)');
    
    // Teste 7.1: Buscar com filtro de ContratoID
    WriteLn('7.1 - Buscando com filtro ContratoID=1...');
    DB.ContratoID(1);
    Param := DB.Getter('teste_titulo');
    
    if Assigned(Param) then
    begin
      if Param.ContratoID = 1 then
        TestePassou('Filtro de ContratoID funcionou corretamente')
      else
        TesteFalhou('Filtro de ContratoID não funcionou (retornou ContratoID=' + IntToStr(Param.ContratoID) + ')');
      Param.Free;
    end
    else
    begin
      TesteFalhou('Filtro de ContratoID não retornou parâmetro');
    end;
    
    // Teste 7.2: Buscar com filtro de ProdutoID
    WriteLn('');
    WriteLn('7.2 - Buscando com filtro ProdutoID=1...');
    DB.ProdutoID(1);
    Param := DB.Getter('teste_titulo');
    
    if Assigned(Param) then
    begin
      if Param.ProdutoID = 1 then
        TestePassou('Filtro de ProdutoID funcionou corretamente')
      else
        TesteFalhou('Filtro de ProdutoID não funcionou');
      Param.Free;
    end
    else
    begin
      TesteFalhou('Filtro de ProdutoID não retornou parâmetro');
    end;
    
    // Limpar filtros
    DB.ContratoID(0).ProdutoID(0);
    
    // =========================================================================
    // TESTE 8: LIMPEZA - Deletar parâmetros de teste
    // =========================================================================
    Separador('TESTE 8: Limpeza - Deletar Parâmetros de Teste');
    
    WriteLn('Deletando parâmetros de teste criados...');
    
    // Deletar teste_simples
    if DB.Exists('teste_simples') then
    begin
      DB.Delete('teste_simples', LSuccess);
      if LSuccess then
        WriteLn('  ✓ teste_simples deletado')
      else
        WriteLn('  ✗ Erro ao deletar teste_simples');
    end;
    
    // Deletar teste_titulo
    if DB.Exists('teste_titulo') then
    begin
      DB.Delete('teste_titulo', LSuccess);
      if LSuccess then
        WriteLn('  ✓ teste_titulo deletado')
      else
        WriteLn('  ✗ Erro ao deletar teste_titulo');
    end;
    
    // =========================================================================
    // RESUMO FINAL
    // =========================================================================
    Separador('RESUMO DOS TESTES');
    
    WriteLn('Total de testes: ' + IntToStr(TestPassed + TestFailed));
    WriteLn('✓ Testes passaram: ' + IntToStr(TestPassed));
    WriteLn('✗ Testes falharam: ' + IntToStr(TestFailed));
    WriteLn('');
    
    if TestFailed = 0 then
    begin
      WriteLn('╔════════════════════════════════════════╗');
      WriteLn('║  ✓ TODOS OS TESTES PASSARAM!           ║');
      WriteLn('╚════════════════════════════════════════╝');
    end
    else
    begin
      WriteLn('╔════════════════════════════════════════╗');
      WriteLn('║  ⚠ ALGUNS TESTES FALHARAM             ║');
      WriteLn('╚════════════════════════════════════════╝');
    end;
    
    // Desconectar
    DB.Disconnect;
    WriteLn('');
    WriteLn('Desconectado do banco de dados.');
    WriteLn('');
    WriteLn('Pressione ENTER para sair...');
    ReadLn;
    
  except
    on E: Exception do
    begin
      WriteLn('');
      WriteLn('╔════════════════════════════════════════╗');
      WriteLn('║  ERRO DURANTE OS TESTES!              ║');
      WriteLn('╚════════════════════════════════════════╝');
      WriteLn('');
      WriteLn('Classe: ' + E.ClassName);
      WriteLn('Mensagem: ' + E.Message);
      WriteLn('');
      WriteLn('Pressione ENTER para sair...');
      ReadLn;
    end;
  end;
end.
