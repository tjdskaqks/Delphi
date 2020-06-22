unit uFrm_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.Layouts, FMX.TMSListEditor, System.Rtti, FMX.Grid.Style, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, FMX.TMSListView, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.TMSBaseControl, FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData,
  FMX.TMSCustomGrid, FMX.TMSGrid, System.RegularExpressions, System.IniFiles, FMX.Menus, FMX.ListBox, FMX.TMSIPEdit,
  uTPLb_Codec, uTPLb_BaseNonVisualComponent, uTPLb_CryptographicLibrary;

type
  Tinfo = record
    sBindip: string;
    nBindPort: Integer;
    sMappedIp: string;
    nMappedPort: Integer;
  end;

  Tfrm_Main = class(TForm)
    stylbk1: TStyleBook;
    btn_SaveIni: TButton;
    pm1: TPopupMenu;
    MenuItem1: TMenuItem;
    cryptgrphclbry1: TCryptographicLibrary;
    cdc1: TCodec;
    grp1: TGroupBox;
    grid_List: TTMSFMXGrid;
    btn_Remove: TButton;
    btn_Add: TButton;
    grp2: TGroupBox;
    lst1: TListBox;
    edt_InputIp: TTMSFMXIPEdit;
    btn_AddIp: TButton;
    Label1: TLabel;
    procedure btn_AddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_RemoveClick(Sender: TObject);
    procedure grid_ListGetCellLayout(Sender: TObject; ACol, ARow: Integer; ALayout: TTMSFMXGridCellLayout; ACellState: TCellState);
    procedure grid_SetNo;
    function IsVaildCheck: Boolean;
    function SaveIniFile: Boolean;
    procedure LoadIniFile;
    procedure btn_SaveIniClick(Sender: TObject);
    procedure pm1Popup(Sender: TObject);
    procedure btn_AddIpClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.fmx}

procedure Tfrm_Main.btn_AddClick(Sender: TObject);
begin
  if IsVaildCheck then
  begin
    grid_List.RowCount := grid_List.RowCount + 1;
    grid_SetNo;
  end
  else
  begin
    MessageDlg('아이피 또는 포트를 확인하세요.', TMsgDlgType.mtError, [TMsgDlgBtn.mbYes], 0);
  end;
end;

procedure Tfrm_Main.btn_AddIpClick(Sender: TObject);
begin
  // 허용할 ip 추가 - 중복방지를 위해 검사 후 추가
  if lst1.Items.IndexOf(edt_InputIp.IPAddress) = -1 then
    lst1.Items.Add(edt_InputIp.IPAddress);
  Application.Initialize
end;

procedure Tfrm_Main.btn_RemoveClick(Sender: TObject);
begin
  if (grid_List.Selected > 0) and (grid_List.RowCount > grid_List.Selected) then
  begin
    grid_List.DeleteRow(grid_List.Selected);
    grid_SetNo;
  end;
end;

procedure Tfrm_Main.btn_SaveIniClick(Sender: TObject);
begin
  if SaveIniFile then
    MessageDlg('저장 성공', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes], 0)
  else
    MessageDlg('저장 실패', TMsgDlgType.mtError, [TMsgDlgBtn.mbYes], 0);
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  with grid_List do
  begin
    Cells[0, 0] := 'No';
    Cells[1, 0] := 'BindingIP';
    Cells[2, 0] := 'Port';
    Cells[3, 0] := 'MappingIp';
    Cells[4, 0] := 'Port';
  end;
  LoadIniFile;
  grid_SetNo;
end;

procedure Tfrm_Main.grid_ListGetCellLayout(Sender: TObject; ACol, ARow: Integer; ALayout: TTMSFMXGridCellLayout; ACellState: TCellState);
begin
  ALayout.TextAlign := TTextAlign.Center;
end;

procedure Tfrm_Main.grid_SetNo;
var
  i: Integer;
begin
  if grid_List.RowCount > 1 then
    for i := 1 to grid_List.RowCount do
      grid_List.Cells[0, i] := i.ToString;
end;

function Tfrm_Main.IsVaildCheck: Boolean;
var
  ipRegExp: string;
  sBindip, sMappedIp: string;
  nBindPort, nMappedPort: Integer;
begin
  Result := True;
  ipRegExp :=
    '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';

  if grid_List.RowCount > 1 then
  begin
    try
      sBindip := grid_List.Cells[1, grid_List.RowCount - 1];
      nBindPort := string.toInteger(grid_List.Cells[2, grid_List.RowCount - 1]);
      sMappedIp := grid_List.Cells[3, grid_List.RowCount - 1];
      nMappedPort := string.toInteger(grid_List.Cells[4, grid_List.RowCount - 1]);

      if not ((sBindip <> '') and TRegEx.IsMatch(sBindip, ipRegExp)) then
      begin
        Result := False;
      end;

      if not ((sMappedIp <> '') and TRegEx.IsMatch(sMappedIp, ipRegExp)) then
      begin
        Result := False;
      end;

      if not ((nBindPort > 0) and (nBindPort < 65535)) then
      begin
        Result := False;
      end;

      if not ((nMappedPort > 0) and (nMappedPort < 65535)) then
      begin
        Result := False;
      end;
    except
      on E: Exception do
      begin
        Result := False;
        MessageDlg('아이피 또는 포트를 확인하세요.', TMsgDlgType.mtError, [TMsgDlgBtn.mbYes], 0);
      end;
    end;
  end;
end;

procedure Tfrm_Main.MenuItem1Click(Sender: TObject);
begin
  lst1.Items.Delete(lst1.ItemIndex);
end;

// 리스트 인덱스 클릭했을때만 활성화
procedure Tfrm_Main.pm1Popup(Sender: TObject);
begin
  if lst1.ItemIndex <> -1 then
  begin
    MenuItem1.Enabled := True;
  end
  else
  begin
    MenuItem1.Enabled := False;
  end;
end;

function Tfrm_Main.SaveIniFile: Boolean;
var
  i: Integer;
  ipRegExp: string;
  sBindip, sMappedIp: string;
  nBindPort, nMappedPort: Integer;
  TmpEnc: string;
begin
  Result := True;
  ipRegExp :=
    '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';

  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini') do
  begin
    try
      if grid_List.RowCount >= 2 then
      begin
        try
          WriteInteger('PORTLIST_CNT', 'CNT', grid_List.RowCount - 1);
          for i := 1 to grid_List.RowCount - 1 do
          begin
            sBindip := grid_List.Cells[1, i];
            nBindPort := string.toInteger(grid_List.Cells[2, i]);
            sMappedIp := grid_List.Cells[3, i];
            nMappedPort := string.toInteger(grid_List.Cells[4, i]);

            if not ((sBindip <> '') and TRegEx.IsMatch(sBindip, ipRegExp)) then
            begin
              Result := False;
            end
            else//              WriteString(Format('LIST_%d', [i]), 'BINDIP', sBindip);
            begin
              cdc1.EncryptString(sBindip, TmpEnc, TEncoding.UTF8);
              WriteString(Format('LIST_%d', [i]), 'BINDIP', TmpEnc);
            end;

            if not ((nBindPort > 0) and (nBindPort < 65535)) then
            begin
              Result := False;
            end
            else
            begin
              cdc1.EncryptString(nBindPort.ToString, TmpEnc, TEncoding.UTF8);
              WriteString(Format('LIST_%d', [i]), 'BINDPORT', TmpEnc);
            end;

            if not ((sMappedIp <> '') and TRegEx.IsMatch(sMappedIp, ipRegExp)) then
            begin
              Result := False;
            end
            else
            begin
              cdc1.EncryptString(sMappedIp, TmpEnc, TEncoding.UTF8);
              WriteString(Format('LIST_%d', [i]), 'MAPPEDIP', TmpEnc);
            end;

            if not ((nMappedPort > 0) and (nMappedPort < 65535)) then
            begin
              Result := False;
            end
            else
            begin
              cdc1.EncryptString(nMappedPort.ToString, TmpEnc, TEncoding.UTF8);
              WriteString(Format('LIST_%d', [i]), 'MAPPEPORT', TmpEnc);
            end;
          end;
        except
          on E: Exception do
          begin
            Result := False;
            MessageDlg('아이피 또는 포트를 확인하세요.', TMsgDlgType.mtError, [TMsgDlgBtn.mbYes], 0);
          end;
        end;
      end;

      if lst1.Count > 0 then
      begin
        try
          WriteInteger('ALLOWIPLIST_CNT', 'CNT', lst1.Count);
          for i := 0 to lst1.Count - 1 do
          begin
            cdc1.EncryptString(lst1.Items.Strings[i], TmpEnc, TEncoding.UTF8);
            WriteString('IPLIST', Format('IP_%d', [i]), TmpEnc);
          end;
        except
          on E: Exception do
          begin
            Result := False;
            MessageDlg('아이피 또는 포트를 확인하세요.', TMsgDlgType.mtError, [TMsgDlgBtn.mbYes], 0);
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure Tfrm_Main.LoadIniFile;
var
  I: Integer;
  nCnt, nCnt2: Integer;
  sDecrypt: string;
  stmpStr: string;
begin
  // 비밀번호
  cdc1.Password := '1234';
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini') do
  begin
    try
      nCnt := ReadInteger('PORTLIST_CNT', 'CNT', 0);
      if nCnt > 0 then
      begin
        grid_List.RowCount := nCnt + 1;

        for I := 0 to nCnt do
        begin
          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'BINDIP', '');
          cdc1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          grid_List.Cells[1, I + 1] := sDecrypt;

          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'BINDPORT', '');
          cdc1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          grid_List.Cells[2, I + 1] := sDecrypt;

          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'MAPPEDIP', '');
          cdc1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          grid_List.Cells[3, I + 1] := sDecrypt;

          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'MAPPEPORT', '');
          cdc1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          grid_List.Cells[4, I + 1] := sDecrypt;
        end;
      end;

      nCnt2 := ReadInteger('ALLOWIPLIST_CNT', 'CNT', 0);
      if nCnt2 > 0 then
      begin
        for I := 0 to nCnt2 - 1 do
        begin
          stmpStr := ReadString('IPLIST', Format('IP_%d', [I]), '');
          cdc1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);

          if lst1.Items.IndexOf(stmpStr) = -1 then
          begin
            lst1.Items.add(sDecrypt);
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

end.

