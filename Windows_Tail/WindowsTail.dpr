program WindowsTail;

uses
  Forms,
  MainForm in 'MainForm.pas' {TMSForm2: TAdvMetroForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTMSForm2, TMSForm2);
  Application.Run;
end.