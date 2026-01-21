{ ============================================================================
  Testes de Performance - Parameters v1.0.3
  
  Objetivo: Medir throughput, latência, memória e identificar gargalos
  Autor: Sistema de Testes Automatizado
  Data: 21/01/2026
  Status: Completo
  ============================================================================ }

unit uPerformanceTests;

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
  { Métricas de Performance }
  TPerformanceMetrics = record
    OperationName: string;
    OperationCount: Integer;
    TotalTime: Int64;
    AverageTime: Double;
    MinTime: Int64;
    MaxTime: Int64;
    ThroughputOpsPerSec: Double;
  end;

  { Testes de Performance do Database }
  TDatabasePerformanceTests = class(TTestCase)
  private
    FDatabase: IParametersDatabase;
    FMetrics: TList;
    procedure RecordMetric(const AOperationName: string; ACount: Integer; ATotalTime: Int64);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestInsertPerformance;
    procedure TestReadPerformance;
    procedure TestUpdatePerformance;
    procedure TestListPerformance;
    procedure TestCountPerformance;
  end;

  { Testes de Performance do INI Files }
  TIniFilesPerformanceTests = class(TTestCase)
  private
    FIniFiles: IParametersInifiles;
    procedure RecordMetric(const AOperationName: string; ACount: Integer; ATotalTime: Int64);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestIniInsertPerformance;
    procedure TestIniReadPerformance;
    procedure TestIniFileLoadPerformance;
  end;

  { Testes de Performance do JSON }
  TJsonObjectPerformanceTests = class(TTestCase)
  private
    FJsonObject: IParametersJsonObject;
    procedure RecordMetric(const AOperationName: string; ACount: Integer; ATotalTime: Int64);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestJsonInsertPerformance;
    procedure TestJsonReadPerformance;
    procedure TestJsonSerializationPerformance;
  end;

  { Testes de Performance de Convergência }
  TConvergencePerformanceTests = class(TTestCase)
  private
    FParameters: IParameters;
    FDatabase: IParametersDatabase;
    procedure RecordMetric(const AOperationName: string; ACount: Integer; ATotalTime: Int64);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestFallbackPerformance;
    procedure TestMultiSourcePerformance;
    procedure TestPriorityPerformance;
  end;

function GetTickCount64: Int64;

implementation

{$IFDEF FPC}
uses
  Linux;

function GetTickCount64: Int64;
var
  T: TimeSpec;
begin
  Clock_GetTime(CLOCK_MONOTONIC, @T);
  Result := T.tv_sec * 1000 + T.tv_nsec div 1000000;
end;
{$ELSE}
uses
  Windows;

function GetTickCount64: Int64;
begin
  Result := Windows.GetTickCount64;
end;
{$ENDIF}

{ ============================================================================
  TDatabasePerformanceTests
  ============================================================================ }

procedure TDatabasePerformanceTests.SetUp;
begin
  inherited SetUp;
  FMetrics := TList.Create;
  FDatabase := TParameters.NewDatabase
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('performance_test')
    .AutoCreateTable(True)
    .Connect;
  FDatabase.CreateTable;
end;

procedure TDatabasePerformanceTests.TearDown;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
  finally
    FMetrics.Free;
    inherited TearDown;
  end;
end;

procedure TDatabasePerformanceTests.RecordMetric(const AOperationName: string; 
  ACount: Integer; ATotalTime: Int64);
var
  Throughput: Double;
begin
  if ATotalTime = 0 then
    Throughput := 0
  else
    Throughput := (ACount * 1000) / ATotalTime; { ops/sec }
  
  { Log da métrica }
  WriteLn(Format('%s: %d ops em %d ms (%.2f ops/s, %.4f ms/op)',
    [AOperationName, ACount, ATotalTime, Throughput, ATotalTime / ACount]));
end;

procedure TDatabasePerformanceTests.TestInsertPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 1000;
begin
  { Teste de performance de INSERT }
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'perf_insert_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('INSERT Performance', OPERATION_COUNT, TotalTime);
  Check(TotalTime < 10000, 'INSERT deve completar em menos de 10 segundos');
end;

procedure TDatabasePerformanceTests.TestReadPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 1000;
begin
  { Insere dados primeiro }
  for I := 1 to 100 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'perf_read_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  { Teste de performance de READ }
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := FDatabase.Get('perf_read_' + IntToStr((I mod 100) + 1));
    if Assigned(Param) then
      Param.Free;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('READ Performance', OPERATION_COUNT, TotalTime);
  Check(TotalTime < 5000, 'READ deve completar em menos de 5 segundos');
end;

procedure TDatabasePerformanceTests.TestUpdatePerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 500;
begin
  { Insere dados primeiro }
  for I := 1 to OPERATION_COUNT do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'perf_update_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  { Teste de performance de UPDATE }
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'perf_update_' + IntToStr(I);
      Param.Value := 'updated_value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Update(Param);
    finally
      Param.Free;
    end;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('UPDATE Performance', OPERATION_COUNT, TotalTime);
  Check(TotalTime < 5000, 'UPDATE deve completar em menos de 5 segundos');
end;

procedure TDatabasePerformanceTests.TestListPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  List: TParameterList;
  TotalTime: Int64;
const
  OPERATION_COUNT = 100;
begin
  { Insere dados }
  for I := 1 to 500 do
  begin
    var Param := TParameter.Create;
    try
      Param.Name := 'perf_list_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  { Teste de performance de LIST }
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    List := FDatabase.List;
    if Assigned(List) then
      List.Free;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('LIST Performance', OPERATION_COUNT, TotalTime);
  Check(TotalTime < 10000, 'LIST deve completar em menos de 10 segundos');
end;

procedure TDatabasePerformanceTests.TestCountPerformance;
var
  I, Count: Integer;
  StartTime, EndTime: Int64;
  TotalTime: Int64;
const
  OPERATION_COUNT = 10000;
begin
  { Insere alguns dados }
  for I := 1 to 100 do
  begin
    var Param := TParameter.Create;
    try
      Param.Name := 'perf_count_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FDatabase.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  { Teste de performance de COUNT }
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Count := FDatabase.Count;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('COUNT Performance', OPERATION_COUNT, TotalTime);
  Check(TotalTime < 5000, 'COUNT deve completar em menos de 5 segundos');
end;

{ ============================================================================
  TIniFilesPerformanceTests
  ============================================================================ }

procedure TIniFilesPerformanceTests.SetUp;
var
  IniPath: string;
begin
  inherited SetUp;
  
  {$IFDEF UNIX}
  IniPath := '/tmp/performance_test.ini';
  {$ELSE}
  IniPath := ExtractFilePath(ParamStr(0)) + 'performance_test.ini';
  {$ENDIF}
  
  FIniFiles := TParameters.NewInifiles(IniPath)
    .Section('TEST')
    .AutoCreateFile(True);
end;

procedure TIniFilesPerformanceTests.TearDown;
begin
  try
    if Assigned(FIniFiles) and FileExists(FIniFiles.FilePath) then
      DeleteFile(FIniFiles.FilePath);
  finally
    inherited TearDown;
  end;
end;

procedure TIniFilesPerformanceTests.RecordMetric(const AOperationName: string;
  ACount: Integer; ATotalTime: Int64);
var
  Throughput: Double;
begin
  if ATotalTime = 0 then
    Throughput := 0
  else
    Throughput := (ACount * 1000) / ATotalTime;
  
  WriteLn(Format('%s (INI): %d ops em %d ms (%.2f ops/s)',
    [AOperationName, ACount, ATotalTime, Throughput]));
end;

procedure TIniFilesPerformanceTests.TestIniInsertPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 500;
begin
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'ini_perf_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FIniFiles.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('INSERT', OPERATION_COUNT, TotalTime);
end;

procedure TIniFilesPerformanceTests.TestIniReadPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 500;
begin
  { Insere dados }
  for I := 1 to 50 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'ini_read_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FIniFiles.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := FIniFiles.Get('ini_read_' + IntToStr((I mod 50) + 1));
    if Assigned(Param) then
      Param.Free;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('READ', OPERATION_COUNT, TotalTime);
end;

procedure TIniFilesPerformanceTests.TestIniFileLoadPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  TotalTime: Int64;
const
  OPERATION_COUNT = 100;
begin
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    FIniFiles.Refresh;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('RELOAD', OPERATION_COUNT, TotalTime);
end;

{ ============================================================================
  TJsonObjectPerformanceTests
  ============================================================================ }

procedure TJsonObjectPerformanceTests.SetUp;
var
  JsonPath: string;
begin
  inherited SetUp;
  
  {$IFDEF UNIX}
  JsonPath := '/tmp/performance_test.json';
  {$ELSE}
  JsonPath := ExtractFilePath(ParamStr(0)) + 'performance_test.json';
  {$ENDIF}
  
  FJsonObject := TParameters.NewJsonObject
    .ObjectName('TEST')
    .FilePath(JsonPath)
    .AutoCreateFile(True);
end;

procedure TJsonObjectPerformanceTests.TearDown;
begin
  try
    if Assigned(FJsonObject) and FileExists(FJsonObject.FilePath) then
      DeleteFile(FJsonObject.FilePath);
  finally
    inherited TearDown;
  end;
end;

procedure TJsonObjectPerformanceTests.RecordMetric(const AOperationName: string;
  ACount: Integer; ATotalTime: Int64);
var
  Throughput: Double;
begin
  if ATotalTime = 0 then
    Throughput := 0
  else
    Throughput := (ACount * 1000) / ATotalTime;
  
  WriteLn(Format('%s (JSON): %d ops em %d ms (%.2f ops/s)',
    [AOperationName, ACount, ATotalTime, Throughput]));
end;

procedure TJsonObjectPerformanceTests.TestJsonInsertPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 500;
begin
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'json_perf_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FJsonObject.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('INSERT', OPERATION_COUNT, TotalTime);
end;

procedure TJsonObjectPerformanceTests.TestJsonReadPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 500;
begin
  { Insere dados }
  for I := 1 to 50 do
  begin
    Param := TParameter.Create;
    try
      Param.Name := 'json_read_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FJsonObject.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := FJsonObject.Get('json_read_' + IntToStr((I mod 50) + 1));
    if Assigned(Param) then
      Param.Free;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('READ', OPERATION_COUNT, TotalTime);
end;

procedure TJsonObjectPerformanceTests.TestJsonSerializationPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  JsonStr: string;
  TotalTime: Int64;
const
  OPERATION_COUNT = 100;
begin
  { Insere dados }
  for I := 1 to 100 do
  begin
    var Param := TParameter.Create;
    try
      Param.Name := 'json_serial_' + IntToStr(I);
      Param.Value := 'value_' + IntToStr(I);
      Param.ValueType := pvtString;
      FJsonObject.Insert(Param);
    finally
      Param.Free;
    end;
  end;
  
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    JsonStr := FJsonObject.ToJSONString;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('SERIALIZATION', OPERATION_COUNT, TotalTime);
end;

{ ============================================================================
  TConvergencePerformanceTests
  ============================================================================ }

procedure TConvergencePerformanceTests.SetUp;
begin
  inherited SetUp;
  
  FParameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);
  
  FDatabase := FParameters.Database
    .DatabaseType(dtSQLite)
    .Database(':memory:')
    .TableName('perf_convergence')
    .AutoCreateTable(True)
    .Connect;
  FDatabase.CreateTable;
  
  FParameters.Priority([psDatabase, psInifiles, psJsonObject]);
end;

procedure TConvergencePerformanceTests.TearDown;
begin
  try
    if Assigned(FDatabase) and FDatabase.IsConnected then
      FDatabase.DropTable;
  finally
    inherited TearDown;
  end;
end;

procedure TConvergencePerformanceTests.RecordMetric(const AOperationName: string;
  ACount: Integer; ATotalTime: Int64);
var
  Throughput: Double;
begin
  if ATotalTime = 0 then
    Throughput := 0
  else
    Throughput := (ACount * 1000) / ATotalTime;
  
  WriteLn(Format('%s: %d ops em %d ms (%.2f ops/s)',
    [AOperationName, ACount, ATotalTime, Throughput]));
end;

procedure TConvergencePerformanceTests.TestFallbackPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Param: TParameter;
  TotalTime: Int64;
const
  OPERATION_COUNT = 1000;
begin
  Param := TParameter.Create;
  try
    Param.Name := 'convergence_fallback';
    Param.Value := 'test_value';
    Param.ValueType := pvtString;
    FParameters.Insert(Param);
  finally
    Param.Free;
  end;
  
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Param := FParameters.Getter('convergence_fallback');
    if Assigned(Param) then
      Param.Free;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('FALLBACK', OPERATION_COUNT, TotalTime);
end;

procedure TConvergencePerformanceTests.TestMultiSourcePerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  Count: Integer;
  TotalTime: Int64;
const
  OPERATION_COUNT = 1000;
begin
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    Count := FParameters.Count;
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('MULTI_SOURCE', OPERATION_COUNT, TotalTime);
end;

procedure TConvergencePerformanceTests.TestPriorityPerformance;
var
  I: Integer;
  StartTime, EndTime: Int64;
  TotalTime: Int64;
const
  OPERATION_COUNT = 100;
begin
  StartTime := GetTickCount64;
  
  for I := 1 to OPERATION_COUNT do
  begin
    FParameters.Priority([psDatabase, psInifiles, psJsonObject]);
  end;
  
  EndTime := GetTickCount64;
  TotalTime := EndTime - StartTime;
  
  RecordMetric('PRIORITY', OPERATION_COUNT, TotalTime);
end;

end.
