program ParamentersCSL;

{ =============================================================================
  ExemploConfigCRUD - Exemplo de CRUD para Tabela Config
  
  Descrição:
  Projeto de exemplo demonstrando o uso do módulo Parameters.Database
  para realizar operações CRUD na tabela dbcsl.config.
  
  Compatível com:
  - Delphi (Windows)
  - Free Pascal / Lazarus (Windows, Linux, macOS)

  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

{$I src/ParamentersORM.Defines.inc}

{$IFDEF FPC}
  {$MODE DELPHI}
  {$IFDEF WINDOWS}
    {$APPTYPE GUI}
  {$ENDIF}
{$ENDIF}

uses
{$IFDEF FPC}
  Interfaces, Forms, LResources,
{$ELSE}
  Vcl.Forms,
{$ENDIF}
  Parameters.Consts in 'src\Paramenters\Commons\Parameters.Consts.pas',
  Parameters.Exceptions in 'src\Paramenters\Commons\Parameters.Exceptions.pas',
  Parameters.Types in 'src\Paramenters\Commons\Parameters.Types.pas',
  Parameters.Database in 'src\Paramenters\Database\Parameters.Database.pas',
  Parameters.Inifiles in 'src\Paramenters\IniFiles\Parameters.Inifiles.pas',
  Parameters.JsonObject in 'src\Paramenters\JsonObject\Parameters.JsonObject.pas',
  Parameters.Intefaces in 'src\Paramenters\Parameters.Intefaces.pas',
  Parameters in 'src\Paramenters\Parameters.pas',
  ufrmParamenters_Test in 'src\View\ufrmParamenters_Test.pas' {frmConfigCRUD};

{$R *.res}

begin
  Application.Initialize;
  {$IFNDEF FPC}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TfrmConfigCRUD, frmConfigCRUD);
  Application.Run;
end.
