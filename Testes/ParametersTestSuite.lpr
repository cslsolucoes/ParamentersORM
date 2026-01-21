{ ============================================================================
  Suite Completa de Testes - Parameters v1.0.3
  
  Objetivo: Executar todos os testes (Thread-Safety, Integração, Performance)
  Compilador: FPC 3.2.2+ / Lazarus 4.4+
  Data: 21/01/2026
  ============================================================================ }

program ParametersTestSuite;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  SysUtils,
  Classes,
  {$IFDEF FPC}
  fpcunit,
  testregistry,
  testdefaultrunner,
  {$ELSE}
  TestFramework,
  GUITestRunner,
  {$ENDIF}
  uThreadSafetyTests,
  uIntegrationTests,
  uPerformanceTests;

begin
  {$IFDEF FPC}
  { Registra todos os testes }
  RegisterTest(TDatabaseThreadSafetyTests);
  RegisterTest(TIniFilesThreadSafetyTests);
  RegisterTest(TJsonObjectThreadSafetyTests);
  RegisterTest(TConvergenceThreadSafetyTests);
  
  RegisterTest(TDatabaseEngineIntegrationTests);
  RegisterTest(THierarchyIntegrationTests);
  RegisterTest(TImportExportIntegrationTests);
  RegisterTest(TConvergenceIntegrationTests);
  RegisterTest(TEdgeCaseIntegrationTests);
  
  RegisterTest(TDatabasePerformanceTests);
  RegisterTest(TIniFilesPerformanceTests);
  RegisterTest(TJsonObjectPerformanceTests);
  RegisterTest(TConvergencePerformanceTests);
  
  { Executa os testes }
  RunRegisteredTests;
  {$ELSE}
  { Delphi: usa GUI Test Runner }
  GUITestRunner.RunRegisteredTests;
  {$ENDIF}
end.
