unit uMappedTCPClass;

interface

uses
  System.SysUtils, IdContext, IdSocketHandle, IdThread, IdComponent, IdBaseComponent, IdCustomTCPServer, IdServerIOHandler,
  IdServerIOHandlerSocket, IdServerIOHandlerStack, System.RegularExpressions, System.Generics.Collections, IdMappedPortTCP, uLogClass,
  IdSSL, IdSSLOpenSSL, IdIntercept, IdServerInterceptLogBase, IdServerInterceptLogFile, Vcl.Forms;

type
  TFowardingClass = class
    IdMappedPortTCP : TIdMappedPortTCP;
    IdServerIOHandlerSSLOpenSSL : TIdServerIOHandlerSSLOpenSSL;
    IdServerInterceptLogFile : TIdServerInterceptLogFile;
    procedure IdMappedPortTCP1AfterBind(Sender : TObject);
    procedure IdMappedPortTCP1BeforeBind(AHandle : TIdSocketHandle);
    procedure IdMappedPortTCP1BeforeConnect(AContext : TIdContext);
    procedure IdMappedPortTCP1BeforeListenerRun(AThread : TIdThread);
    procedure IdMappedPortTCP1ContextCreated(AContext : TIdContext);
    procedure IdMappedPortTCP1Connect(AContext : TIdContext);
    procedure IdMappedPortTCP1Disconnect(AContext : TIdContext);
    procedure IdMappedPortTCP1Execute(AContext : TIdContext);
    procedure IdMappedPortTCP1Exception(AContext : TIdContext; AException : Exception);
    procedure IdMappedPortTCP1OutboundConnect(AContext : TIdContext);
    procedure IdMappedPortTCP1OutboundData(AContext : TIdContext);
    procedure IdMappedPortTCP1OutboundDisconnect(AContext : TIdContext);
    procedure IdMappedPortTCP1Status(ASender : TObject; const AStatus : TIdStatus; const AStatusText : string);
  private
    BindIP : string;
    BindPort : integer;
    MappedIP : string;
    MappedPort : integer;
    sPath : string;
    AllowIpList : TList<string>; // 허용 IP 리스트
    function IsAllowIp(sip : string) : Boolean; // 허용된 IP 리스트에 있는지 확인
  protected
    { protected declarations }
    procedure Connect;
    procedure Disconnect;
  public
    { public declarations }
    constructor Create(sBindIP, sBindPort, sMappedIP, sMappedPort : string; sAllowIpList : TList<string>);
    destructor Destroy;
  end;

const
  ipRegExp =
    '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';

implementation

{ TFowardingClass }

procedure TFowardingClass.Connect;
begin
  IdMappedPortTCP.Active := true;
end;

constructor TFowardingClass.Create(sBindIP, sBindPort, sMappedIP, sMappedPort : string; sAllowIpList : TList<string>);
begin
  BindIP     := sBindIP;
  BindPort   := sBindPort.ToInteger;
  MappedIP   := sMappedIP;
  MappedPort := sMappedPort.ToInteger;
  // IPv4 체크
  if not(TRegEx.IsMatch(BindIP, ipRegExp) or not TRegEx.IsMatch(MappedIP, ipRegExp)) then
  begin
    //WriteLog('free1');
    free;
  end;
  // 포트 범위 체크
  if not((BindPort > 0) and (BindPort < 65536)) or not((MappedPort > 0) and (MappedPort < 65536)) then
  begin
    //WriteLog('free2');
    free;
  end;
  //WriteLog('FowardingClass.Create');

  AllowIpList                                   := sAllowIpList; // 넘겨준 리스트 담기 (이미 create 했기 때문에 얕은 복사
  IdMappedPortTCP                               := TIdMappedPortTCP.Create; // IdMappedPortTCP Create
  IdServerIOHandlerSSLOpenSSL                   := TIdServerIOHandlerSSLOpenSSL.Create;
  IdServerIOHandlerSSLOpenSSL.SSLOptions.Method := sslvTLSv1_2;
  // IdServerInterceptLogFile                      := TIdServerInterceptLogFile.Create;
  // IdServerInterceptLogFile.Filename             := 'C:\Users\JSH\Desktop\HanilnPortFowarding\log\IdServerInterceptLogFile.log';
  try
    IdMappedPortTCP.Intercept := IdServerInterceptLogFile;
    IdMappedPortTCP.IOHandler := IdServerIOHandlerSSLOpenSSL;
    // 이벤트 연결
    IdMappedPortTCP.OnAfterBind          := IdMappedPortTCP1AfterBind;
    IdMappedPortTCP.OnBeforeBind         := IdMappedPortTCP1BeforeBind;
    IdMappedPortTCP.OnBeforeConnect      := IdMappedPortTCP1BeforeConnect;
    IdMappedPortTCP.OnBeforeListenerRun  := IdMappedPortTCP1BeforeListenerRun;
    IdMappedPortTCP.OnContextCreated     := IdMappedPortTCP1ContextCreated;
    IdMappedPortTCP.OnConnect            := IdMappedPortTCP1Connect;
    IdMappedPortTCP.OnDisconnect         := IdMappedPortTCP1Disconnect;
    IdMappedPortTCP.OnExecute            := IdMappedPortTCP1Execute;
    IdMappedPortTCP.OnException          := IdMappedPortTCP1Exception;
    IdMappedPortTCP.OnOutboundConnect    := IdMappedPortTCP1OutboundConnect;
    IdMappedPortTCP.OnOutboundData       := IdMappedPortTCP1OutboundData;
    IdMappedPortTCP.OnOutboundDisconnect := IdMappedPortTCP1OutboundDisconnect;
    IdMappedPortTCP.OnStatus             := IdMappedPortTCP1Status;

//    WriteLog(BindIP);
//    WriteLog(BindPort.ToString);
//    WriteLog(MappedIP);
//    WriteLog(MappedPort.ToString);

    sPath := StringReplace(BindIP + '.' + BindPort.ToString, '.', '_', [rfReplaceAll]); // 19.19.20.77.3389 => 19_19_20_77_3389.log

    with IdMappedPortTCP do
    begin
      Bindings.Clear;
      defaultport       := 0;
      Bindings.Add.IP   := BindIP;
      Bindings.Add.port := BindPort;
      mappedHost        := MappedIP;
      // MappedPort        := MappedPort;
    end;
    IdMappedPortTCP.MappedPort := MappedPort;
    Connect;
  except
    on E : Exception do
      WriteLog('FowardingClass - Exception : ' + E.Message);
  end;
end;

destructor TFowardingClass.Destroy;
begin
  inherited;
  Disconnect;

  // if assigned(IdServerInterceptLogFile) then
  // IdServerInterceptLogFile.free;

  if assigned(IdServerIOHandlerSSLOpenSSL) then
    IdServerIOHandlerSSLOpenSSL.free;

  if assigned(IdMappedPortTCP) then
    IdMappedPortTCP.free;

  if assigned(AllowIpList) then
    AllowIpList.free;
end;

procedure TFowardingClass.Disconnect;
begin
  IdMappedPortTCP.Active := False;
end;

procedure TFowardingClass.IdMappedPortTCP1AfterBind(Sender : TObject);
begin
  WriteLog('AfterBind', sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1BeforeBind(AHandle : TIdSocketHandle);
begin
  WriteLog('BeforeBind', sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1BeforeConnect(AContext : TIdContext);
begin
  // 허용된 ip인지 체크
  if not IsAllowIp(AContext.Binding.PeerIP) then
  begin
    // 허용된 ip가 아니면 연결해제
    AContext.Connection.Disconnect;
    WriteLog(format('BeforeConnect Disconnect - Not Allow IP : %s, Port : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]
      ), sPath);
  end
  else
  begin
    WriteLog(format('BeforeConnect - Allow IP : %s, Port : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
  end;
end;

procedure TFowardingClass.IdMappedPortTCP1BeforeListenerRun(AThread : TIdThread);
begin
  WriteLog('BeforeListenerRun', sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1Connect(AContext : TIdContext);
begin
  WriteLog(format('Connect -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
  WriteLog(format('Connect -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1ContextCreated(AContext : TIdContext);
begin
  WriteLog(format('ContextCreated -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
  WriteLog(format('ContextCreated -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1Disconnect(AContext : TIdContext);
begin
  WriteLog(format('Disconnect -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
  WriteLog(format('Disconnect -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1Exception(AContext : TIdContext; AException : Exception);
begin
  WriteLog(format('Exception -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
  WriteLog(format('Exception -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
  WriteLog(format('Exception - AException : %s, StackTrace : %s', [AException.Message, AException.StackTrace]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1Execute(AContext : TIdContext);
begin
//  WriteLog(format('Execute -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
//  WriteLog(format('Execute -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1OutboundConnect(AContext : TIdContext);
begin
  WriteLog(format('OutboundConnect -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
  WriteLog(format('OutboundConnect -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1OutboundData(AContext : TIdContext);
begin
//  WriteLog(format('OutboundData -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
//  WriteLog(format('OutboundData -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1OutboundDisconnect(AContext : TIdContext);
begin
  WriteLog(format('OutboundDisconnect -  IP : %s, Port : %d', [AContext.Binding.IP, AContext.Binding.port]), sPath);
  WriteLog(format('OutboundDisconnect -  PeerIP : %s, PeerPort : %d', [AContext.Binding.PeerIP, AContext.Binding.PeerPort]), sPath);
end;

procedure TFowardingClass.IdMappedPortTCP1Status(ASender : TObject; const AStatus : TIdStatus; const AStatusText : string);
begin
  case AStatus of
    hsResolving :
      WriteLog('Status - hsResolving : ' + AStatusText, sPath);
    hsConnecting :
      WriteLog('Status - hsConnecting : ' + AStatusText, sPath);
    hsConnected :
      WriteLog('Status - hsConnected : ' + AStatusText, sPath);
    hsDisconnecting :
      WriteLog('Status - hsDisconnecting : ' + AStatusText, sPath);
    hsDisconnected :
      WriteLog('Status - hsDisconnected : ' + AStatusText, sPath);
    hsStatusText :
      WriteLog('Status - hsStatusText : ' + AStatusText, sPath);
    ftpTransfer :
      WriteLog('Status - ftpTransfer : ' + AStatusText, sPath);
    ftpReady :
      WriteLog('Status - ftpReady : ' + AStatusText, sPath);
    ftpAborted :
      WriteLog('Status - ftpAborted : ' + AStatusText, sPath);
  end;
end;

function TFowardingClass.IsAllowIp(sip : string) : Boolean;
begin
  Result := False;
  if AllowIpList.IndexOf(sip) <> -1 then
    Result := true;
end;

end.
