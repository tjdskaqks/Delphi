program Delete_Outlook_Search;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
   Application.Initialize;
   Application.MainFormOnTaskbar := True;
   TStyleManager.TrySetStyle('TabletDark');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
