program ParamentersCSL;

{$IFDEF FPC}
  {$MODE DELPHI}
  {$IFDEF WINDOWS}
    {$APPTYPE GUI}
  {$ENDIF}
{$ENDIF}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ufrmParamenters_Test, Parameters, Parameters.Intefaces,
  Parameters.JsonObject, Parameters.Inifiles, Parameters.Database,
  Parameters.Types, Parameters.Exceptions, Parameters.Consts
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TfrmConfigCRUD, frmConfigCRUD);
  Application.Run;
end.

