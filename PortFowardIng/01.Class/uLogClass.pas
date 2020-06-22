unit uLogClass;

interface

uses
  windows, Winapi.Messages, System.SysUtils, System.Classes;

procedure WriteLog(sText : string); overload;
procedure WriteLog(sText, sPath : string); overload;

const
{$IFDEF DEBUG}
  LOGFORMAT = '%s [Debug  ]  -  |%s|' + #13#10;
{$ELSE}
  LOGFORMAT = '%s  -  |%s|' + #13#10;
{$ENDIF}

var
  FLogMessage : string;
  FileCS : TRTLCriticalSection;

implementation

procedure WriteLog(sText : string);
var
  tmpStream : TBufferedFileStream;
  sFilename : string;
begin
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'log') then
    ForceDirectories(ExtractFilePath(ParamStr(0)) + 'log');

  sFilename := ExtractFilePath(ParamStr(0)) + 'log' + '\' + FormatDateTime('YYYYMMdd', Now) + '.log';

  EnterCriticalSection(FileCS);
  if not FileExists(sFilename) then
    tmpStream := TBufferedFileStream.Create(sFilename, fmCreate)
  else
    tmpStream := TBufferedFileStream.Create(sFilename, fmOpenReadWrite);
  try
    try
      sText := format(LOGFORMAT, [FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', Now), sText]);
      tmpStream.Seek(0, TSeekOrigin.soEnd);
      tmpStream.Write(TEncoding.Default.GetBytes(sText), TEncoding.Default.GetByteCount(sText));
      tmpStream.FlushBuffer;
    finally
      if assigned(tmpStream) then
        tmpStream.Free;
      LeaveCriticalSection(FileCS);
    end;

  except
    on E : Exception do
    begin
      sText := format(LOGFORMAT, [FormatDateTime('YYYY_MM_dd hh:nn:ss.zzz', Now), E.Message]);
      tmpStream.Seek(0, TSeekOrigin.soEnd);
      tmpStream.Write(TEncoding.Default.GetBytes(sText), TEncoding.Default.GetByteCount(sText));
      tmpStream.FlushBuffer;
      if assigned(tmpStream) then
        tmpStream.Free;
      LeaveCriticalSection(FileCS);
    end;
  end;
end;

procedure WriteLog(sText, sPath : string);
var
  tmpStream : TBufferedFileStream;
  sFilename : string;
begin
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'log\'+ FormatDateTime('YYYYMMdd', Now)) then
    ForceDirectories(ExtractFilePath(ParamStr(0)) + 'log\'+ FormatDateTime('YYYYMMdd', Now));

  sFilename := ExtractFilePath(ParamStr(0)) + 'log\'+ FormatDateTime('YYYYMMdd', Now) + '\' +sPath + '.log';

  EnterCriticalSection(FileCS);
  if not FileExists(sFilename) then
    tmpStream := TBufferedFileStream.Create(sFilename, fmCreate)
  else
    tmpStream := TBufferedFileStream.Create(sFilename, fmOpenReadWrite);
  try
    try
      sText := format(LOGFORMAT, [FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', Now), sText]);
      tmpStream.Seek(0, TSeekOrigin.soEnd);
      tmpStream.Write(TEncoding.Default.GetBytes(sText), TEncoding.Default.GetByteCount(sText));
      tmpStream.FlushBuffer;
    finally
      if assigned(tmpStream) then
        tmpStream.Free;
      LeaveCriticalSection(FileCS);
    end;

  except
    on E : Exception do
    begin
      sText := format(LOGFORMAT, [FormatDateTime('YYYY_MM_dd hh:nn:ss.zzz', Now), E.Message]);
      tmpStream.Seek(0, TSeekOrigin.soEnd);
      tmpStream.Write(TEncoding.Default.GetBytes(sText), TEncoding.Default.GetByteCount(sText));
      tmpStream.FlushBuffer;
      if assigned(tmpStream) then
        tmpStream.Free;
      LeaveCriticalSection(FileCS);
    end;
  end;
end;

initialization

InitializeCriticalSection(FileCS);

finalization

DeleteCriticalSection(FileCS);

end.
