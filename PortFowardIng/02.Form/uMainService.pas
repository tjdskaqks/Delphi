unit uMainService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  System.Generics.Collections, System.RegularExpressions, IdContext, IdSocketHandle, IdThread, IdComponent,
  IdBaseComponent, IdCustomTCPServer, IdMappedPortTCP, uTPLb_Codec, uTPLb_BaseNonVisualComponent, uTPLb_CryptographicLibrary, inifiles,
  uLogClass,
  uMappedTCPClass;

type

  THanilnPortFowarding_Service = class(TService)
    CryptographicLibrary1 : TCryptographicLibrary;
    Codec1 : TCodec;
    procedure ServiceCreate(Sender : TObject);
    procedure ServiceStart(Sender : TService; var Started : Boolean);
    procedure ServiceStop(Sender : TService; var Stopped : Boolean);
    procedure ServicePause(Sender : TService; var Paused : Boolean);
    procedure ServiceContinue(Sender : TService; var Continued : Boolean);
    procedure ServiceDestroy(Sender : TObject);
  private
    AllowIpList : TList<string>; // 허용 IP 리스트
    FowardingList : TList<TFowardingClass>; // 포트포워딩할 IP, PORT 리스트<TFowardingClass>
    { Private declarations }
    procedure AddAllowIpList(s : string); // 허용 IP 리스트 추가
    procedure LoadIniFile; // 암호회된 INI 읽어오기
  public
    function GetServiceController : TServiceController; override;
    { Public declarations }
  end;

var
  HanilnPortFowarding_Service : THanilnPortFowarding_Service;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode : DWord); stdcall;
begin
  HanilnPortFowarding_Service.Controller(CtrlCode);
end;

procedure THanilnPortFowarding_Service.AddAllowIpList(s : string);
var
  ipRegExp : string;
begin
  ipRegExp :=
    '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';
  // 정규식을 이용해 IPv4 체크
  if ((s <> '') and TRegEx.IsMatch(s, ipRegExp)) then
  begin
    // 존재하지 않으면 추가
    if AllowIpList.IndexOf(s) = -1 then
      AllowIpList.Add(s);
  end;
end;

function THanilnPortFowarding_Service.GetServiceController : TServiceController;
begin
  Result := ServiceController;
end;

procedure THanilnPortFowarding_Service.ServiceContinue(Sender : TService; var Continued : Boolean);
begin
  WriteLog('Service Continue');
end;

procedure THanilnPortFowarding_Service.ServiceCreate(Sender : TObject);
begin
  WriteLog('Create!');
end;

procedure THanilnPortFowarding_Service.ServiceDestroy(Sender : TObject);
begin
  WriteLog('Destroy!');
end;

procedure THanilnPortFowarding_Service.ServicePause(Sender : TService; var Paused : Boolean);
begin
  WriteLog('Service Pause');
end;

procedure THanilnPortFowarding_Service.ServiceStart(Sender : TService; var Started : Boolean);
begin
  WriteLog('Service Start');
  // 암호화 키 설정
  // CBC - AES256
  try
    Codec1.Password := '1234';
    AllowIpList     := TList<string>.Create;
    FowardingList   := TList<TFowardingClass>.Create;
    LoadIniFile;
  except
    on E : Exception do
      WriteLog(E.Message);
  end;
end;

procedure THanilnPortFowarding_Service.ServiceStop(Sender : TService; var Stopped : Boolean);
begin
  WriteLog('Service Stop');
  if assigned(FowardingList) then
    FowardingList.Free;
  if assigned(AllowIpList) then
    AllowIpList.Free;
end;

procedure THanilnPortFowarding_Service.LoadIniFile;
var
  I : Integer;
  nCnt, nCnt2 : Integer;
  sDecrypt : string;
  stmpStr : string;
  s1, s2, s3, s4 : string;
begin
  WriteLog('Service LoadIniFile');
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini') do
  begin
    try
      // 허용 ip 개수
      nCnt2 := ReadInteger('ALLOWIPLIST_CNT', 'CNT', 0);

      if nCnt2 > 0 then
      begin
        for I := 0 to nCnt2 - 1 do
        begin
          stmpStr := ReadString('IPLIST', Format('IP_%d', [I]), '');
          Codec1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          // WriteLog(sDecrypt);
          AddAllowIpList(sDecrypt);
        end;
      end;
      // 포트포워딩할 IP, PORT 리스트 개수
      nCnt := ReadInteger('PORTLIST_CNT', 'CNT', 0);
      if nCnt > 0 then
      begin
        for I := 0 to nCnt - 1 do
        begin
          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'BINDIP', '');
          Codec1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          s1 := sDecrypt;

          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'BINDPORT', '');
          Codec1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          s2 := sDecrypt;

          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'MAPPEDIP', '');
          Codec1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          s3 := sDecrypt;

          stmpStr := ReadString(Format('LIST_%d', [I + 1]), 'MAPPEPORT', '');
          Codec1.DecryptString(sDecrypt, stmpStr, TEncoding.UTF8);
          s4 := sDecrypt;
          // WriteLog(s1 + s2 + s3 + s4);
          // FowardingList에 Create해서 추가 및 허용 리스트 담기
          FowardingList.Add(TFowardingClass.Create(s1, s2, s3, s4, AllowIpList));
        end;
      end;

    finally
      Free;
    end;
  end;
end;

end.
