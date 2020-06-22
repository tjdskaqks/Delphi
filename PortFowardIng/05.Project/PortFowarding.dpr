program PortFowarding;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrm_Main in '..\02.Form\uFrm_Main.pas' {frm_Main},
  uFrm_Login in '..\02.Form\uFrm_Login.pas' {frm_Login};

{$R *.res}

begin
  Application.Initialize;
//  {$IF DEBUG}
  if ShowLoginForm then
  begin
    Application.CreateForm(Tfrm_Main, frm_Main);
    Application.Run;
  end;
//  {$ELSE}
//  Application.CreateForm(Tfrm_Main, frm_Main);
//  Application.Run;
//  {$ENDIF}
end.

