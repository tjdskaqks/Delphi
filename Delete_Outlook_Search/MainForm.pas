unit MainForm;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, Registry;

type
   TfrmMain = class(TForm)
      lbl1: TLabel;
      edt1: TEdit;
      btn1: TButton;
      lbl2: TLabel;
      procedure btn1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
      function DeleteSetting(Akey, AGroup: String): Boolean;
      function GetUserFromWindows: String;
      Function Parsing(Const MainString, First, Second: String): String;
   end;

var
   frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btn1Click(Sender: TObject);
var
   name: String;
begin
   name := edt1.Text;

   if DeleteSetting('101f0445', name) then
   begin
      MessageDlg('삭제되었습니다.' + #13#10 + 'jcoder1.tistory.com', mtConfirmation, [mbOK], 0);
   end
   else
   begin
      MessageDlg('성을 확인하거나' + #10 + #13 + '이미 삭제 되었습니다.', mtError, [mbOK], 0);
      edt1.SetFocus;
      edt1.SelectAll;
   end;

end;

function TfrmMain.DeleteSetting(Akey, AGroup: String): Boolean;
var
   Registry: TRegistry;
begin
   if AGroup = '' then
      AGroup := 'Outlook';

   Registry := TRegistry.Create;
   try
      Registry.RootKey := HKEY_CURRENT_USER;
      Registry.OpenKey('Software\Microsoft\Office\16.0\Outlook\Profiles\' +
        AGroup + '\0a0d020000000000c000000000000046', False);

      if Registry.DeleteValue(Akey) then
      begin
         Registry.CloseKey;
         Result := True;
      end
      else
      begin
         Registry.CloseKey;
         Result := False;
      end;
   finally
      Registry.Free;
   end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   searchResult: TSearchRec;
   filename: string;
begin
   if FindFirst('C:\Users\' + GetUserFromWindows +
     '\AppData\Local\Microsoft\Outlook\*.ost', faAnyFile, searchResult) = 0 then
   begin
      repeat
         // ShowMessage('File name = ' + searchResult.Name);
         filename := searchResult.Name;
      until FindNext(searchResult) <> 0;
      FindClose(searchResult);
   end;
    //ShowMessage(SysUtils.GetEnvironmentVariable('APPDATA'));
    //ShowMessage(Parsing(SysUtils.GetEnvironmentVariable('APPDATA'), 's\', '\A'));
   // ShowMessage(Parsing(filename, '- ', '.'));
   edt1.Text := Parsing(filename, '- ', '.');
end;

// 사용자계정 찾기
function TfrmMain.GetUserFromWindows: String;
begin
   Result := Parsing(SysUtils.GetEnvironmentVariable('APPDATA'), 's\', '\A')
end;
(*var
   UserName: String;
   UserNameLen: Dword;
begin
   UserNameLen := 255;
   SetLength(UserName, UserNameLen);
   if GetUserName(PChar(UserName), UserNameLen) then
      Result := Copy(UserName, 1, UserNameLen - 1)
   else
      Result := '';
end;    *)

Function TfrmMain.Parsing(Const MainString, First, Second: String): String;
var
   stmp: String;
begin
   stmp := MainString;
   stmp := Copy(stmp, POS(First, stmp) + length(First), length(stmp));
   Result := Copy(stmp, 1, POS(Second, stmp) - 1);
   //https://auroradp.tistory.com/10
end;

end.
