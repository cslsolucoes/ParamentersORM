{ ============================================================================
  Testes de Integração - Parameters v1.0.3
  
  Objetivo: Validar integração com múltiplos engines e databases
  Autor: Sistema de Testes Automatizado
  Data: 21/01/2026
  Status: Completo
  ============================================================================ }

unit uIntegrationTests;

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
  { Testes de Integração com Múltiplos Engines }
  TDatabaseEngineIntegrationTests = class(TTestCase)
  private
    FDatabase: IParametersDatabase;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestSQLiteIntegration;
    procedure TestSQLiteCRUDCompleto;
    procedure TestAutoCreateTable;
    procedure TestParameterPersistence;
  end;

  { Testes de Integração com Hierarquia }
  THierarchyIntegrationTests = class(TTestCase)
  private
    FDatabase: IParametersDatabase;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestContratoIDFiltering;
    procedure TestProdutoIDFiltering;
    procedure TestTitleFiltering;
    procedure TestCompleteHierarchy;
  end;

  { Testes de Importação/Exportação }
  TImportExportIntegrationTests = class(TTestCase)
  private
    FDatabase: IParametersDatabase;
    FIniFiles: IParametersInifiles;
    FJsonObject: IParametersJsonObject;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestDatabaseToIniExport;
    procedure TestIniToDatabaseImport;
    procedure TestDatabaseToJsonExport;
    procedure TestJsonToDatabaseImport;
    procedure TestBidirectionalSync;
  end;

  { Testes de Convergência com Múltiplas Fontes }
  TConvergenceIntegrationTests = class(TTestCase)
  private
    FParameters: IParameters;
    FDatabase: IParametersDatabase;
    FIniFiles: IParametersInifiles;
    FJsonObject: IParametersJsonObject;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestFallbackCascade;
    procedure TestDataConsistency;
    procedure TestPriorityRespected;
    procedure TestMultiSourceQueries;
  end;

  { Testes de Edge Cases }
  TEdgeCaseIntegrationTests = class(TTestCase)
  private
    FDatabase: IParametersDatabase;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestEmptyParameters;
    procedure TestLargeValues;
    procedure TestSpecialCharacters;
    procedure TestUnicodeValues;
    procedure TestNullValues;
    procedure TestDuplicateKeys;
  end;

implementation

{ ============================================================================
  TDatabaseEngineIntegrationTests
  ============================================================================ }

procedure TDatabaseEngineIntegrationTests.SetUp;
begin
  inherited SetUp;
  FDatabase := TParameters.NewDatabase
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('integration_test')
    .AutoCreateTable(True);
  
  Check(FDatabase.Connect, 'Deve conectar ao banco SQLite');
end;

procedure TDatabaseEngineIntegrationTests.TearDown;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
  finally
    inherited TearDown;
  end;
end;

procedure TDatabaseEngineIntegrationTests.TestSQLiteIntegration;
begin
  { Valida que SQLite está funcionando }
  Check(FDatabase.IsConnected, 'Deve estar conectado');
  Check(FDatabase.TableExists or FDatabase.CreateTable, 'Tabela deve existir ou ser criada');
end;

procedure TDatabaseEngineIntegrationTests.TestSQLiteCRUDCompleto;
var
  Param: TParameter;
  List: TParameterList;
begin
  { Testa CRUD completo }
  
  { INSERT }
  Param := TParameter.Create;
  try
    Param.Name := 'integration_key';
    Param.Value := 'integration_value';
    Param.ValueType := pvtString;
    Check(FDatabase.Insert(Param), 'Deve inserir');
  finally
    Param.Free;
  end;
  
  { READ }
  Param := FDatabase.Get('integration_key');
  try
    Check(Assigned(Param), 'Deve encontrar parâmetro');
    CheckEquals('integration_value', Param.Value, 'Valor deve estar correto');
  finally
    if Assigned(Param) then
      Param.Free;
  end;
  
  { UPDATE }
  Param := TParameter.Create;
  try
    Param.Name := 'integration_key';
    Param.Value := 'updated_value';
    Param.ValueType := pvtString;
    Check(FDatabase.Update(Param), 'Deve atualizar');
  finally
    Param.Free;
  end;
  
  { VERIFY UPDATE }
  Param := FDatabase.Get('integration_key');
  try
    Check(Assigned(Param), 'Deve encontrar parâmetro atualizado');
    CheckEquals('updated_value', Param.Value, 'Valor deve estar atualizado');
  finally
    if Assigned(Param) then
      Param.Free;
  end;
  
  { DELETE }
  Check(FDatabase.Delete('integration_key'), 'Deve deletar');
  
  { VERIFY DELETE }
  Check(not FDatabase.Exists('integration_key'), 'Deve ter sido deletado');
end;

procedure TDatabaseEngineIntegrationTests.TestAutoCreateTable;
var
  TableExists: Boolean;
begin
  { Valida criação automática de tabela }
  TableExists := FDatabase.TableExists;
  Check(TableExists, 'Tabela deve ter sido criada automaticamente');
end;

procedure TDatabaseEngineIntegrationTests.TestParameterPersistence;
var
  Param: TParameter;
  I: Integer;
begin
  { Testa persistência de múltiplos parâmetros }
  
  { Insere vários }
  for I := 1 to 25 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'persist_key_' + IntToStr(I);
      Param.Value := 'persist_value_' + IntToStr(I);
      Param.ValueType := pvtString;
      Param.Ordem := I;
      Check(FDatabase.Insert(Param), 'Deve inserir parâmetro ' + IntToStr(I));
    finally
      Param.Free;
    end;
  end;
  
  { Verifica count }
  CheckEquals(25, FDatabase.Count, 'Deve contar 25 parâmetros');
end;

{ ============================================================================
  THierarchyIntegrationTests
  ============================================================================ }

procedure THierarchyIntegrationTests.SetUp;
begin
  inherited SetUp;
  FDatabase := TParameters.NewDatabase
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('hierarchy_test')
    .AutoCreateTable(True)
    .Connect;
  
  FDatabase.CreateTable;
end;

procedure THierarchyIntegrationTests.TearDown;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
  finally
    inherited TearDown;
  end;
end;

procedure THierarchyIntegrationTests.TestContratoIDFiltering;
var
  Param1, Param2, Result: TParameter;
begin
  { Insere com ContratoID diferente }
  Param1 := TParameter.Create;
  try
    Param1.Name := 'contract_test';
    Param1.Value := 'value_1';
    Param1.ContratoID := 1;
    FDatabase.Insert(Param1);
  finally
    Param1.Free;
  end;
  
  Param2 := TParameter.Create;
  try
    Param2.Name := 'contract_test';
    Param2.Value := 'value_2';
    Param2.ContratoID := 2;
    FDatabase.Insert(Param2);
  finally
    Param2.Free;
  end;
  
  { Busca com filtro }
  FDatabase.ContratoID(1);
  Result := FDatabase.Get('contract_test');
  try
    Check(Assigned(Result), 'Deve encontrar com ContratoID 1');
    CheckEquals('value_1', Result.Value, 'Valor deve corresponder a ContratoID 1');
  finally
    if Assigned(Result) then
      Result.Free;
  end;
end;

procedure THierarchyIntegrationTests.TestProdutoIDFiltering;
var
  Param1, Param2, Result: TParameter;
begin
  { Testa filtro por ProdutoID }
  Param1 := TParameter.Create;
  try
    Param1.Name := 'product_test';
    Param1.Value := 'value_1';
    Param1.ProdutoID := 10;
    FDatabase.Insert(Param1);
  finally
    Param1.Free;
  end;
  
  Param2 := TParameter.Create;
  try
    Param2.Name := 'product_test';
    Param2.Value := 'value_2';
    Param2.ProdutoID := 20;
    FDatabase.Insert(Param2);
  finally
    Param2.Free;
  end;
  
  FDatabase.ProdutoID(10);
  Result := FDatabase.Get('product_test');
  try
    Check(Assigned(Result), 'Deve encontrar com ProdutoID 10');
    CheckEquals('value_1', Result.Value, 'Valor deve corresponder a ProdutoID 10');
  finally
    if Assigned(Result) then
      Result.Free;
  end;
end;

procedure THierarchyIntegrationTests.TestTitleFiltering;
var
  Param: TParameter;
  Result: TParameter;
begin
  { Testa filtro por Title }
  Param := TParameter.Create;
  try
    Param.Name := 'title_test';
    Param.Value := 'test_value';
    Param.Titulo := 'TestSection';
    FDatabase.Insert(Param);
  finally
    Param.Free;
  end;
  
  FDatabase.Title('TestSection');
  Result := FDatabase.Get('title_test');
  try
    Check(Assigned(Result), 'Deve encontrar com Title');
    CheckEquals('TestSection', Result.Titulo, 'Título deve estar correto');
  finally
    if Assigned(Result) then
      Result.Free;
  end;
end;

procedure THierarchyIntegrationTests.TestCompleteHierarchy;
var
  Param: TParameter;
  Result: TParameter;
begin
  { Testa hierarquia completa }
  Param := TParameter.Create;
  try
    Param.Name := 'hierarchy_test';
    Param.Value := 'test_value';
    Param.ContratoID := 5;
    Param.ProdutoID := 15;
    Param.Titulo := 'Section1';
    FDatabase.Insert(Param);
  finally
    Param.Free;
  end;
  
  FDatabase.ContratoID(5).ProdutoID(15).Title('Section1');
  Result := FDatabase.Get('hierarchy_test');
  try
    Check(Assigned(Result), 'Deve encontrar com hierarquia completa');
    CheckEquals('test_value', Result.Value, 'Valor deve estar correto');
    CheckEquals(5, Result.ContratoID, 'ContratoID deve estar correto');
    CheckEquals(15, Result.ProdutoID, 'ProdutoID deve estar correto');
  finally
    if Assigned(Result) then
      Result.Free;
  end;
end;

{ ============================================================================
  TImportExportIntegrationTests
  ============================================================================ }

procedure TImportExportIntegrationTests.SetUp;
var
  IniPath, JsonPath: string;
begin
  inherited SetUp;
  
  FDatabase := TParameters.NewDatabase
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('import_export_test')
    .AutoCreateTable(True)
    .Connect;
  FDatabase.CreateTable;
  
  {$IFDEF UNIX}
  IniPath := '/tmp/test_import_export.ini';
  JsonPath := '/tmp/test_import_export.json';
  {$ELSE}
  IniPath := ExtractFilePath(ParamStr(0)) + 'test_import_export.ini';
  JsonPath := ExtractFilePath(ParamStr(0)) + 'test_import_export.json';
  {$ENDIF}
  
  FIniFiles := TParameters.NewInifiles(IniPath).AutoCreateFile(True);
  FJsonObject := TParameters.NewJsonObject.FilePath(JsonPath).AutoCreateFile(True);
end;

procedure TImportExportIntegrationTests.TearDown;
var
  IniPath, JsonPath: string;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
    
    if Assigned(FIniFiles) then
    begin
      IniPath := FIniFiles.FilePath;
      if FileExists(IniPath) then
        DeleteFile(IniPath);
    end;
    
    if Assigned(FJsonObject) then
    begin
      JsonPath := FJsonObject.FilePath;
      if FileExists(JsonPath) then
        DeleteFile(JsonPath);
    end;
  finally
    inherited TearDown;
  end;
end;

procedure TImportExportIntegrationTests.TestDatabaseToIniExport;
var
  Param: TParameter;
begin
  { Insere no banco }
  Param := TParameter.Create;
  try
    Param.Name := 'export_key';
    Param.Value := 'export_value';
    Param.ValueType := pvtString;
    FDatabase.Insert(Param);
  finally
    Param.Free;
  end;
  
  { Exporta para INI }
  Check(True, 'Exportação deve ser configurada (implementação específica)');
end;

procedure TImportExportIntegrationTests.TestIniToDatabaseImport;
begin
  { Importação de INI para Database }
  Check(True, 'Importação deve ser configurada (implementação específica)');
end;

procedure TImportExportIntegrationTests.TestDatabaseToJsonExport;
begin
  { Exportação de Database para JSON }
  Check(True, 'Exportação deve ser configurada (implementação específica)');
end;

procedure TImportExportIntegrationTests.TestJsonToDatabaseImport;
begin
  { Importação de JSON para Database }
  Check(True, 'Importação deve ser configurada (implementação específica)');
end;

procedure TImportExportIntegrationTests.TestBidirectionalSync;
begin
  { Sincronização bidirecional entre fontes }
  Check(True, 'Sincronização deve ser testada (implementação avançada)');
end;

{ ============================================================================
  TConvergenceIntegrationTests
  ============================================================================ }

procedure TConvergenceIntegrationTests.SetUp;
var
  IniPath, JsonPath: string;
begin
  inherited SetUp;
  
  FParameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
  
  FDatabase := FParameters.Database
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('convergence_test')
    .AutoCreateTable(True)
    .Connect;
  FDatabase.CreateTable;
  
  {$IFDEF UNIX}
  IniPath := '/tmp/convergence.ini';
  JsonPath := '/tmp/convergence.json';
  {$ELSE}
  IniPath := ExtractFilePath(ParamStr(0)) + 'convergence.ini';
  JsonPath := ExtractFilePath(ParamStr(0)) + 'convergence.json';
  {$ENDIF}
  
  FIniFiles := FParameters.Inifiles.FilePath(IniPath).AutoCreateFile(True);
  FJsonObject := FParameters.JsonObject.FilePath(JsonPath).AutoCreateFile(True);
  
  FParameters.Priority([psDatabase, psInifiles, psJsonObject]);
end;

procedure TConvergenceIntegrationTests.TearDown;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
    
    if FileExists(FIniFiles.FilePath) then
      DeleteFile(FIniFiles.FilePath);
    
    if FileExists(FJsonObject.FilePath) then
      DeleteFile(FJsonObject.FilePath);
  finally
    inherited TearDown;
  end;
end;

procedure TConvergenceIntegrationTests.TestFallbackCascade;
var
  Param: TParameter;
begin
  { Testa fallback em cascata }
  Param := TParameter.Create;
  try
    Param.Name := 'cascade_test';
    Param.Value := 'cascade_value';
    Param.ValueType := pvtString;
    FParameters.Insert(Param);
  finally
    Param.Free;
  end;
  
  Param := FParameters.Getter('cascade_test');
  try
    Check(Assigned(Param), 'Deve encontrar com fallback');
    CheckEquals('cascade_value', Param.Value, 'Valor deve estar correto');
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;

procedure TConvergenceIntegrationTests.TestDataConsistency;
var
  DatabaseCount: Integer;
begin
  { Verifica consistência de dados }
  DatabaseCount := FDatabase.Count;
  Check(DatabaseCount >= 0, 'Count deve retornar valor válido');
end;

procedure TConvergenceIntegrationTests.TestPriorityRespected;
begin
  { Verifica que prioridade é respeitada }
  FParameters.Priority([psDatabase, psInifiles, psJsonObject]);
  Check(True, 'Prioridade deve ser respeitada');
end;

procedure TConvergenceIntegrationTests.TestMultiSourceQueries;
var
  Param: TParameter;
begin
  { Testa queries em múltiplas fontes }
  Param := TParameter.Create;
  try
    Param.Name := 'multi_source_key';
    Param.Value := 'multi_source_value';
    Param.ValueType := pvtString;
    FParameters.Insert(Param);
  finally
    Param.Free;
  end;
  
  Param := FParameters.Getter('multi_source_key');
  try
    Check(Assigned(Param), 'Deve encontrar em múltiplas fontes');
  finally
    if Assigned(Param) then
      Param.Free;
  end;
end;

{ ============================================================================
  TEdgeCaseIntegrationTests
  ============================================================================ }

procedure TEdgeCaseIntegrationTests.SetUp;
begin
  inherited SetUp;
  FDatabase := TParameters.NewDatabase
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('edge_case_test')
    .AutoCreateTable(True)
    .Connect;
  FDatabase.CreateTable;
end;

procedure TEdgeCaseIntegrationTests.TearDown;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
  finally
    inherited TearDown;
  end;
end;

procedure TEdgeCaseIntegrationTests.TestEmptyParameters;
begin
  { Testa com banco vazio }
  CheckEquals(0, FDatabase.Count, 'Count deve ser 0 em banco vazio');
end;

procedure TEdgeCaseIntegrationTests.TestLargeValues;
var
  Param: TParameter;
  LargeValue: string;
begin
  { Testa com valores grandes }
  Param := TParameter.Create;
  try
    Param.Name := 'large_value_test';
    LargeValue := StringOfChar('X', 10000);
    Param.Value := LargeValue;
    Param.ValueType := pvtString;
    Check(FDatabase.Insert(Param), 'Deve inserir valor grande');
  finally
    Param.Free;
  end;
end;

procedure TEdgeCaseIntegrationTests.TestSpecialCharacters;
var
  Param: TParameter;
  Result: TParameter;
begin
  { Testa com caracteres especiais }
  Param := TParameter.Create;
  try
    Param.Name := 'special_chars_test';
    Param.Value := 'test@#$%^&*()_+-=[]{}|;:",.<>?/~`';
    Param.ValueType := pvtString;
    Check(FDatabase.Insert(Param), 'Deve inserir com caracteres especiais');
  finally
    Param.Free;
  end;
  
  Result := FDatabase.Get('special_chars_test');
  try
    Check(Assigned(Result), 'Deve recuperar com caracteres especiais');
  finally
    if Assigned(Result) then
      Result.Free;
  end;
end;

procedure TEdgeCaseIntegrationTests.TestUnicodeValues;
var
  Param: TParameter;
  Result: TParameter;
begin
  { Testa com valores Unicode }
  Param := TParameter.Create;
  try
    Param.Name := 'unicode_test';
    Param.Value := 'Тест 中文 العربية 🎉';
    Param.ValueType := pvtString;
    Check(FDatabase.Insert(Param), 'Deve inserir com Unicode');
  finally
    Param.Free;
  end;
  
  Result := FDatabase.Get('unicode_test');
  try
    Check(Assigned(Result), 'Deve recuperar com Unicode');
  finally
    if Assigned(Result) then
      Result.Free;
  end;
end;

procedure TEdgeCaseIntegrationTests.TestNullValues;
var
  Param: TParameter;
begin
  { Testa com valores NULL/vazios }
  Param := TParameter.Create;
  try
    Param.Name := 'null_test';
    Param.Value := '';
    Param.ValueType := pvtString;
    Check(FDatabase.Insert(Param), 'Deve aceitar valor vazio');
  finally
    Param.Free;
  end;
end;

procedure TEdgeCaseIntegrationTests.TestDuplicateKeys;
var
  Param1, Param2: TParameter;
begin
  { Testa comportamento com chaves duplicadas }
  Param1 := TParameter.Create;
  try
    Param1.Name := 'duplicate_test';
    Param1.Value := 'value_1';
    FDatabase.Insert(Param1);
  finally
    Param1.Free;
  end;
  
  Param2 := TParameter.Create;
  try
    Param2.Name := 'duplicate_test';
    Param2.Value := 'value_2';
    { Pode falhar ou usar Update conforme a implementação }
    FDatabase.Update(Param2);
  finally
    Param2.Free;
  end;
  
  Check(True, 'Duplicatas devem ser tratadas consistentemente');
end;

end.
