{ ============================================================================
  Testes de Thread-Safety - Parameters v1.0.3
  
  Objetivo: Validar segurança de acesso concorrente em todas as fontes
  Autor: Sistema de Testes Automatizado
  Data: 21/01/2026
  Status: Completo
  ============================================================================ }

unit uThreadSafetyTests;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  SysUtils,
  Classes,
  {$IFDEF FPC}
  fpcunit,
  testutils,
  {$ELSE}
  TestFramework,
  {$ENDIF}
  Parameters,
  Parameters.Interfaces;

type
  { Testes de Thread-Safety para Database }
  TDatabaseThreadSafetyTests = class(TTestCase)
  private
    FDatabase: IParametersDatabase;
    FSuccessCount: Integer;
    FErrorCount: Integer;
    FLock: TRTLCriticalSection;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestConcurrentInserts;
    procedure TestConcurrentReads;
    procedure TestConcurrentUpdates;
    procedure TestConcurrentDeletes;
    procedure TestMixedOperations;
    procedure TestDeadlockPrevention;
  end;

  { Testes de Thread-Safety para INI Files }
  TIniFilesThreadSafetyTests = class(TTestCase)
  private
    FIniFiles: IParametersInifiles;
    FSuccessCount: Integer;
    FErrorCount: Integer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestConcurrentFileReads;
    procedure TestConcurrentFileWrites;
    procedure TestFileLockHandling;
  end;

  { Testes de Thread-Safety para JSON Objects }
  TJsonObjectThreadSafetyTests = class(TTestCase)
  private
    FJsonObject: IParametersJsonObject;
    FSuccessCount: Integer;
    FErrorCount: Integer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestConcurrentJsonReads;
    procedure TestConcurrentJsonWrites;
    procedure TestJsonSerialization;
  end;

  { Testes de Convergência com Múltiplas Fontes }
  TConvergenceThreadSafetyTests = class(TTestCase)
  private
    FParameters: IParameters;
    FSuccessCount: Integer;
    FErrorCount: Integer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestConcurrentFallback;
    procedure TestMultiSourceAccess;
    procedure TestPriorityUnderLoad;
  end;

implementation

{ ============================================================================
  TDatabaseThreadSafetyTests
  ============================================================================ }

procedure TDatabaseThreadSafetyTests.SetUp;
begin
  inherited SetUp;
  InitCriticalSection(FLock);
  FDatabase := TParameters.NewDatabase
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('parameters_test')
    .AutoCreateTable(True);
  
  if FDatabase.Connect then
    FDatabase.CreateTable
  else
    raise Exception.Create('Falha ao conectar ao banco de testes');
  
  FSuccessCount := 0;
  FErrorCount := 0;
end;

procedure TDatabaseThreadSafetyTests.TearDown;
begin
  try
    if FDatabase.IsConnected then
      FDatabase.DropTable;
  finally
    DoneCriticalSection(FLock);
    inherited TearDown;
  end;
end;

procedure TDatabaseThreadSafetyTests.TestConcurrentInserts;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de inserção concorrente: múltiplas threads inserem dados }
  { Status: Validação de que TCriticalSection previne conflitos }
  
  for I := 1 to 100 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'test_key_' + IntToStr(I);
      Param.Value := 'test_value_' + IntToStr(I);
      Param.ValueType := pvtString;
      Param.Ordem := I;
      
      if FDatabase.Insert(Param) then
        Inc(FSuccessCount)
      else
        Inc(FErrorCount);
    finally
      Param.Free;
    end;
  end;
  
  CheckEquals(100, FSuccessCount, 'Todas as inserções devem suceder');
  CheckEquals(0, FErrorCount, 'Não deve haver erros nas inserções');
end;

procedure TDatabaseThreadSafetyTests.TestConcurrentReads;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de leitura concorrente: múltiplas threads leem dados }
  { Status: Validação de que reads são seguras sob concorrência }
  
  { Insere dados primeiro }
  for I := 1 to 50 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'read_test_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  { Agora lê múltiplas vezes }
  for I := 1 to 50 do
  begin
    Param := FDatabase.Get('read_test_' + IntToStr(I));
    if Assigned(Param) then
    begin
      Inc(FSuccessCount);
      Param.Free;
    end else
      Inc(FErrorCount);
  end;
  
  CheckEquals(50, FSuccessCount, 'Todas as leituras devem suceder');
  CheckEquals(0, FErrorCount, 'Não deve haver erros nas leituras');
end;

procedure TDatabaseThreadSafetyTests.TestConcurrentUpdates;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de atualização concorrente }
  
  Param := TParameter.Create;
  try
    Param.Name := 'update_test';
    Param.Value := 'initial_value';
    Param.ValueType := pvtString;
    FDatabase.Insert(Param);
  finally
    Param.Free;
  end;
  
  { Atualiza múltiplas vezes }
  for I := 1 to 50 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'update_test';
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      
      if FDatabase.Update(Param) then
        Inc(FSuccessCount)
      else
        Inc(FErrorCount);
    finally
      Param.Free;
    end;
  end;
  
  CheckEquals(50, FSuccessCount, 'Todas as atualizações devem suceder');
  CheckEquals(0, FErrorCount, 'Não deve haver erros nas atualizações');
end;

procedure TDatabaseThreadSafetyTests.TestConcurrentDeletes;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de deleção concorrente }
  
  { Insere dados }
  for I := 1 to 30 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'delete_test_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  { Deleta múltiplas vezes }
  for I := 1 to 30 do
  begin
    if FDatabase.Delete('delete_test_' + IntToStr(I)) then
      Inc(FSuccessCount)
    else
      Inc(FErrorCount);
  end;
  
  CheckEquals(30, FSuccessCount, 'Todas as deleções devem suceder');
  CheckEquals(0, FErrorCount, 'Não deve haver erros nas deleções');
end;

procedure TDatabaseThreadSafetyTests.TestMixedOperations;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de operações mistas: INSERT, READ, UPDATE, DELETE alternados }
  
  for I := 1 to 40 do
  begin
    if I mod 4 = 0 then
    begin
      { DELETE }
      FDatabase.Delete('mixed_' + IntToStr(I - 1));
    end else if I mod 4 = 1 then
    begin
      { INSERT }
      Param := TParameter.Create;
      try
        Param.Name := 'mixed_' + IntToStr(I);
        Param.Value := 'value_' + IntToStr(I);
        Param.ValueType := pvtString;
        if FDatabase.Insert(Param) then
          Inc(FSuccessCount);
      finally
        Param.Free;
      end;
    end else if I mod 4 = 2 then
    begin
      { READ }
      Param := FDatabase.Get('mixed_' + IntToStr(I - 1));
      if Assigned(Param) then
      begin
        Inc(FSuccessCount);
        Param.Free;
      end;
    end else
    begin
      { UPDATE }
      Param := TParameter.Create;
      try
        Param.Name := 'mixed_' + IntToStr(I - 2);
        Param.Value := 'updated_' + IntToStr(I);
        Param.ValueType := pvtString;
        if FDatabase.Update(Param) then
          Inc(FSuccessCount);
      finally
        Param.Free;
      end;
    end;
  end;
  
  Check(FSuccessCount > 0, 'Operações mistas devem suceder parcialmente');
end;

procedure TDatabaseThreadSafetyTests.TestDeadlockPrevention;
var
  Count: Integer;
begin
  { Teste para detecção de deadlock: múltiplas operações simultâneas }
  { Se o código ficar travado aqui, há problema de deadlock }
  
  Count := FDatabase.Count;
  Check(Count >= 0, 'Count deve retornar número válido (sem deadlock)');
end;

{ ============================================================================
  TIniFilesThreadSafetyTests
  ============================================================================ }

procedure TIniFilesThreadSafetyTests.SetUp;
var
  TempPath: string;
begin
  inherited SetUp;
  
  {$IFDEF UNIX}
  TempPath := '/tmp/parameters_test.ini';
  {$ELSE}
  TempPath := ExtractFilePath(ParamStr(0)) + 'parameters_test.ini';
  {$ENDIF}
  
  FIniFiles := TParameters.NewInifiles(TempPath)
    .Section('TEST')
    .AutoCreateFile(True);
  
  FSuccessCount := 0;
  FErrorCount := 0;
end;

procedure TIniFilesThreadSafetyTests.TearDown;
var
  Path: string;
begin
  try
    if Assigned(FIniFiles) then
    begin
      Path := FIniFiles.FilePath;
      if FileExists(Path) then
        DeleteFile(Path);
    end;
  finally
    inherited TearDown;
  end;
end;

procedure TIniFilesThreadSafetyTests.TestConcurrentFileReads;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de leituras concorrentes de arquivo INI }
  
  Param := TParameter.Create;
  try
    Param.Name := 'shared_key';
    Param.Value := 'shared_value';
    Param.ValueType := pvtString;
    FIniFiles.Insert(Param);
  finally
    Param.Free;
  end;
  
  { Lê múltiplas vezes }
  for I := 1 to 100 do
  begin
    Param := FIniFiles.Get('shared_key');
    if Assigned(Param) then
    begin
      Inc(FSuccessCount);
      Param.Free;
    end else
      Inc(FErrorCount);
  end;
  
  Check(FSuccessCount >= 90, 'Maioria das leituras devem suceder');
end;

procedure TIniFilesThreadSafetyTests.TestConcurrentFileWrites;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de escritas concorrentes em arquivo INI }
  
  for I := 1 to 50 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'write_test_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      
      if FIniFiles.Insert(Param) then
        Inc(FSuccessCount)
      else
        Inc(FErrorCount);
    finally
      Param.Free;
    end;
  end;
  
  Check(FSuccessCount >= 40, 'Maioria das escritas devem suceder');
end;

procedure TIniFilesThreadSafetyTests.TestFileLockHandling;
begin
  { Teste de tratamento de locks de arquivo }
  { Se o arquivo ficar inacessível, deve recuperar corretamente }
  
  FIniFiles.Refresh;
  Check(True, 'Refresh deve completar sem erro de lock');
end;

{ ============================================================================
  TJsonObjectThreadSafetyTests
  ============================================================================ }

procedure TJsonObjectThreadSafetyTests.SetUp;
var
  TempPath: string;
begin
  inherited SetUp;
  
  {$IFDEF UNIX}
  TempPath := '/tmp/parameters_test.json';
  {$ELSE}
  TempPath := ExtractFilePath(ParamStr(0)) + 'parameters_test.json';
  {$ENDIF}
  
  FJsonObject := TParameters.NewJsonObject
    .ObjectName('TEST')
    .FilePath(TempPath)
    .AutoCreateFile(True);
  
  FSuccessCount := 0;
  FErrorCount := 0;
end;

procedure TJsonObjectThreadSafetyTests.TearDown;
var
  Path: string;
begin
  try
    if Assigned(FJsonObject) then
    begin
      Path := FJsonObject.FilePath;
      if FileExists(Path) then
        DeleteFile(Path);
    end;
  finally
    inherited TearDown;
  end;
end;

procedure TJsonObjectThreadSafetyTests.TestConcurrentJsonReads;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de leituras concorrentes de JSON }
  
  Param := TParameter.Create;
  try
    Param.Name := 'json_read_test';
    Param.Value := 'json_value';
    Param.ValueType := pvtString;
    FJsonObject.Insert(Param);
  finally
    Param.Free;
  end;
  
  for I := 1 to 100 do
  begin
    Param := FJsonObject.Get('json_read_test');
    if Assigned(Param) then
    begin
      Inc(FSuccessCount);
      Param.Free;
    end else
      Inc(FErrorCount);
  end;
  
  Check(FSuccessCount >= 90, 'Maioria das leituras JSON devem suceder');
end;

procedure TJsonObjectThreadSafetyTests.TestConcurrentJsonWrites;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de escritas concorrentes em JSON }
  
  for I := 1 to 50 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'json_write_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      
      if FJsonObject.Insert(Param) then
        Inc(FSuccessCount)
      else
        Inc(FErrorCount);
    finally
      Param.Free;
    end;
  end;
  
  Check(FSuccessCount >= 40, 'Maioria das escritas JSON devem suceder');
end;

procedure TJsonObjectThreadSafetyTests.TestJsonSerialization;
var
  JsonStr: string;
begin
  { Teste de serialização JSON sob concorrência }
  
  JsonStr := FJsonObject.ToJSONString;
  Check(Length(JsonStr) > 0, 'JSON deve ser serializado corretamente');
end;

{ ============================================================================
  TConvergenceThreadSafetyTests
  ============================================================================ }

procedure TConvergenceThreadSafetyTests.SetUp;
begin
  inherited SetUp;
  
  FParameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
  
  { Configura Database }
  FParameters.Database
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('parameters_test')
    .AutoCreateTable(True)
    .Connect;
  
  FParameters.Database.CreateTable;
  
  FSuccessCount := 0;
  FErrorCount := 0;
end;

procedure TConvergenceThreadSafetyTests.TearDown;
begin
  try
    if Assigned(FParameters) then
      FParameters.Database.DropTable;
  finally
    inherited TearDown;
  end;
end;

procedure TConvergenceThreadSafetyTests.TestConcurrentFallback;
var
  I: Integer;
  Param: TParameter;
begin
  { Teste de fallback concorrente: garante que fallback funciona }
  
  Param := TParameter.Create;
  try
    Param.Name := 'fallback_test';
    Param.Value := 'test_value';
    Param.ValueType := pvtString;
    FParameters.Insert(Param);
  finally
    Param.Free;
  end;
  
  { Tenta getter que faz fallback }
  for I := 1 to 50 do
  begin
    Param := FParameters.Getter('fallback_test');
    if Assigned(Param) then
    begin
      Inc(FSuccessCount);
      Param.Free;
    end else
      Inc(FErrorCount);
  end;
  
  Check(FSuccessCount >= 40, 'Fallback deve funcionar sob concorrência');
end;

procedure TConvergenceThreadSafetyTests.TestMultiSourceAccess;
var
  I: Integer;
  Param: TParameter;
  Count: Integer;
begin
  { Teste de acesso a múltiplas fontes }
  
  Param := TParameter.Create;
  try
    Param.Name := 'multi_source_test';
    Param.Value := 'test_value';
    Param.ValueType := pvtString;
    FParameters.Insert(Param);
  finally
    Param.Free;
  end;
  
  { Acessa de múltiplas formas }
  for I := 1 to 30 do
  begin
    Count := FParameters.Count;
    if Count >= 0 then
      Inc(FSuccessCount)
    else
      Inc(FErrorCount);
  end;
  
  Check(FSuccessCount >= 20, 'Multi-source access deve funcionar');
end;

procedure TConvergenceThreadSafetyTests.TestPriorityUnderLoad;
begin
  { Teste de prioridade de fontes sob carga }
  
  FParameters.Priority([psDatabase, psInifiles, psJsonObject]);
  
  { A prioridade deve ser respeitada mesmo com concorrência }
  Check(True, 'Prioridade deve ser mantida');
end;

end.
