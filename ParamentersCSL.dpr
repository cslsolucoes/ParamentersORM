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
  Version: 1.0.1
  Date: 02/01/2026
  ============================================================================= }

{$I src/Paramenters.Defines.inc}

{$IFDEF FPC}
  {$MODE DELPHI}
  {$IFDEF WINDOWS}
    {$APPTYPE GUI}
  {$ENDIF}
{$ENDIF}

uses
  {$IFDEF FPC}
  Interfaces,
  {$ELSE}
  Vcl.Forms,
  {$ENDIF }
  Parameters.Consts in 'src\Paramenters\Commons\Parameters.Consts.pas',
  Parameters.Exceptions in 'src\Paramenters\Commons\Parameters.Exceptions.pas',
  Parameters.Types in 'src\Paramenters\Commons\Parameters.Types.pas',
  Parameters.Database in 'src\Paramenters\Database\Parameters.Database.pas',
  Parameters.Inifiles in 'src\Paramenters\IniFiles\Parameters.Inifiles.pas',
  Parameters.JsonObject in 'src\Paramenters\JsonObject\Parameters.JsonObject.pas',
  Parameters.Interfaces in 'src\Paramenters\Parameters.Interfaces.pas',
  Parameters in 'src\Paramenters\Parameters.pas',
  ufrmParamenters in 'src\View\ufrmParamenters.pas' {frmParamenters},
  Parameters.Attributes in 'src\Paramenters\Attributes\Parameters.Attributes.pas',
  Parameters.Attributes.Interfaces in 'src\Paramenters\Attributes\Parameters.Attributes.Interfaces.pas',
  Parameters.Attributes.Exceptions in 'src\Paramenters\Attributes\Parameters.Attributes.Exceptions.pas',
  Parameters.Attributes.Consts in 'src\Paramenters\Attributes\Parameters.Attributes.Consts.pas',
  Parameters.Attributes.Types in 'src\Paramenters\Attributes\Parameters.Attributes.Types.pas',
  ufrmParamentersAttributers in 'src\View\ufrmParamentersAttributers.pas' {frmParamentersAttributers};

{$R *.res}

begin
  Application.Initialize;
  {$IFNDEF FPC}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  //Application.CreateForm(TfrmParamenters, frmParamenters);
  Application.CreateForm(TfrmParamentersAttributers, frmParamentersAttributers);
  Application.Run;
end.
