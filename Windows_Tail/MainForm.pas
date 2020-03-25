unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, AdvMetroForm, ExtCtrls, StdCtrls, AdvEdit, AdvFileNameEdit,
  AdvMetroButton, Math, AdvEdBtn, ComCtrls, sStatusBar, ShellAPI;

type
  TTMSForm2 = class(TAdvMetroForm)
    pnl1: TPanel;
    edt_1: TAdvFileNameEdit;
    btn1: TAdvMetroButton;
    btn2: TAdvMetroButton;
    mmo1: TMemo;
    btn3: TAdvMetroButton;
    stsbr1: TsStatusBar;
    procedure AdvMetroFormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure AdvMetroFormDestroy(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure mmo1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmo1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure WndProc(var Message: TMessage); override;
    procedure CheckStateLabel;
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
  end;

var
  TMSForm2: TTMSForm2;
  FMsg: LongInt;
  FNotify: THandle;
  FThread: THandle;
  FWnd: THandle;
  FPathName, FFileName: string;

implementation

{$R *.dfm}

function Look(P: Pointer): Integer;
begin
  while WaitForSingleObject(FNotify, INFINITE) = WAIT_OBJECT_0 do
  begin
    PostMessage(FWnd, FMsg, 0, 0);
    FindNextChangeNotification(FNotify);
  end;
end;

procedure TTMSForm2.AdvMetroFormCreate(Sender: TObject);
begin
  FMsg := RegisterWindowMessage('FileChangeNotify');
  FWnd := Handle;
  DragAcceptFiles(Handle, True);
end;

procedure TTMSForm2.AdvMetroFormDestroy(Sender: TObject);
begin
  btn2Click(Self);
end;

procedure TTMSForm2.btn1Click(Sender: TObject);
var
  ID: Cardinal;
begin
  if FileExists(edt_1.Text) then
  begin
    FPathName := ExtractFilePath(edt_1.Text);
    FFileName := edt_1.Text;

    WinExec(PAnsiChar('notepad ' + FFileName), SW_SHOWNORMAL); // 테스트용 프로그램

    FNotify := FindFirstChangeNotification(PWideChar(FPathName),
      False, // 하위 디렉토리 검색 안함
        FILE_NOTIFY_CHANGE_SIZE or
      FILE_NOTIFY_CHANGE_LAST_WRITE);
    FThread := BeginThread(nil, 0, Look, nil, 0, ID); // 감시 쓰레드 시작

    btn1.Enabled := False;
    btn2.Enabled := True;
  end;
end;

procedure TTMSForm2.btn2Click(Sender: TObject);
begin
  try
    TerminateThread(FThread, 0);
    WaitForSingleObject(FThread, INFINITE);
    CloseHandle(FThread);
    FindCloseChangeNotification(FNotify);
  except
    ;
  end;

  btn1.Enabled := True;
  btn2.Enabled := False;
end;

procedure TTMSForm2.btn3Click(Sender: TObject);
begin
  case (Sender as TAdvMetroButton).Tag of
    1:
      begin
        Self.FormStyle := fsStayOnTop;
        btn3.Caption := '해제';
        btn3.Tag := 2;
      end;
    2:
      begin
        Self.FormStyle := fsNormal;
        btn3.Caption := '위로 보기';
        btn3.Tag := 1;
      end;
  end;
end;

procedure TTMSForm2.CheckStateLabel;
var
  Coor: TPoint;
  LineNumber, Col: Int32;
begin
  Coor := mmo1.CaretPos;

  LineNumber := Coor.Y + 1;
  Col := Coor.X + 1;

  stsbr1.SimpleText := 'Ln ' + IntToStr(LineNumber) + ', Col ' + IntToStr(Col);
end;

procedure TTMSForm2.mmo1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CheckStateLabel;
end;

procedure TTMSForm2.mmo1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CheckStateLabel;
end;

procedure TTMSForm2.WMDropFiles(var msg: TMessage);
var
  i, NumFiles, NameLength: Integer;
  hDrop: THandle;
  tmpFile: array [0..MAX_PATH] of Char;

begin
  inherited;
  hDrop:=msg.WParam;
  try
    NumFiles:=DragQueryFile(hDrop, $FFFFFFFF, nil, 0);

    for i:=0 to NumFiles-1 do begin
      {4} // 파일이름 String 의 길이를 얻어옴
      NameLength:=DragQueryFile(hDrop, i, nil, 0);

      {5} // 드롭된 파일의 이름을 받아옴
      DragQueryFile(hDrop, i, tmpFile, NameLength+1);

      {6-1} // 파일이 있다면 open 을 통해 실행시킴
      if FileExists(StrPas(tmpFile)) then
      begin
        edt_1.Text := StrPas(tmpFile);
      end
      {6-2} // 파일이 없다면 명령행 인자가 있을지도 모르므로 open이 아니라 실행
      else begin
        //WinExec(tmpFile, SW_SHOWNORMAL);
      end;
    end; // for
  finally
    DragFinish(hDrop);
  end;
end;

procedure TTMSForm2.WndProc(var Message: TMessage);
var
  strm: TFileStream;
begin
  inherited WndProc(Message);

  if Message.Msg = FMsg then
  begin
    try
      strm := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
    except
      on Exception do
        Exit;
    end;

    try
      strm.Position := 0;
      mmo1.Lines.LoadFromStream(strm);

       // 커서를 마지막으로 보내기
      mmo1.SelStart := SendMessage(mmo1.Handle, EM_LINEINDEX, mmo1.Lines.Count - 1, 0);
      mmo1.SelLength := 0;
      mmo1.Perform(EM_SCROLLCARET, 0, 0);
    finally
      strm.Free;
    end;
  end;
end;

end.

