unit uFrm_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSButton, FMX.Objects, FMX.TMSBaseControl,
  FMX.TMSBitmap, FMX.TMSCustomEdit, FMX.TMSEdit, Winapi.Windows;

type
  Tfrm_Login = class(TForm)
    edt_InputPassword: TTMSFMXEdit;
    btn_Login: TTMSFMXButton;
    stylbk1: TStyleBook;
    lbl1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_LoginClick(Sender: TObject);
    procedure edt_InputPasswordKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowLoginForm: Boolean;

implementation

{$R *.fmx}
var
  sPassword: string;
  tryLoginCnt: Integer;

function ShowLoginForm: Boolean;
begin
  with Tfrm_Login.Create(nil) do
  begin
    Result := ShowModal = mrOk;

    Free;
  end;
end;

procedure Tfrm_Login.btn_LoginClick(Sender: TObject);
begin
  if edt_InputPassword.Text = sPassword then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    lbl1.Visible := True;
    Inc(tryLoginCnt);
    lbl1.Text := Format('%d번 틀렸습니다.', [tryLoginCnt]);
  end;
  if tryLoginCnt = 5 then
    Close;
end;

procedure Tfrm_Login.edt_InputPasswordKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btn_LoginClick(Self);
end;

procedure Tfrm_Login.FormCreate(Sender: TObject);
begin
  sPassword := '1234%' + FormatDateTime('mm', Now);
  tryLoginCnt := 0;
  lbl1.Visible := False;
end;

end.

