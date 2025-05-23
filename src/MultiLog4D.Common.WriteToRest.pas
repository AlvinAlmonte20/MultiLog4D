unit MultiLog4D.Common.WriteToRest;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts,
  System.JSON,
  {$IFDEF MSWINDOWS}
    Winapi.Windows,
  {$ENDIF}
  MultiLog4D.Types, System.Classes;

type
  TMultiLogWriteToRest = class
  private
    class var FInstance: TMultiLogWriteToRest;
    FHttpServer: string;
    FLogFormat: string;
    FDateTimeFormat: string;
    FUserName: string;
    FTag: string;
    {$IFDEF MSWINDOWS}
    FEventID: DWORD;
    {$ENDIF}
    {$IFDEF LINUX}
    FEventID: LONGWORD;
    {$ENDIF}
    {$IFDEF MACOS}
    FEventID: UInt32;
    {$ENDIF}
    procedure EnsureDirectoryExists;
    function ReplaceLogVariables(const AMsg: string; const ALogType: TLogType): string;
  public
    class function Instance: TMultiLogWriteToRest;
    function HttpServer(const AHttpServer: string): TMultiLogWriteToRest; overload;
    function HttpServer: string; overload;
    function SetLogFormat(const AFormat: string): TMultiLogWriteToRest;
    function SetDateTimeFormat(const ADateTimeFormat: string): TMultiLogWriteToRest;
    function SetUserName(const AUserName: string): TMultiLogWriteToRest;
    function SetTag(const ATag: string): TMultiLogWriteToRest;
    function SetEventID(const AEventID: {$IFDEF MSWINDOWS}DWORD{$ELSEIF DEFINED(LINUX)}LONGWORD{$ELSEIF DEFINED(MACOS)}UInt32{$ENDIF}): TMultiLogWriteToRest;
    function Execute(const AMsg: string; const ALogType: TLogType): TMultiLogWriteToRest;
  end;

implementation

{ TMultiLogWriteToRest }

class function TMultiLogWriteToRest.Instance: TMultiLogWriteToRest;
begin
  if not Assigned(FInstance) then
    FInstance := TMultiLogWriteToRest.Create;
  Result := FInstance;
end;

function TMultiLogWriteToRest.HttpServer(const AHttpServer: string): TMultiLogWriteToRest;
begin
  FHttpServer := AHttpServer;
  Result := Self;
end;

function TMultiLogWriteToRest.HttpServer: string;
begin
  Result := FHttpServer;
end;

function TMultiLogWriteToRest.SetLogFormat(const AFormat: string): TMultiLogWriteToRest;
begin
  FLogFormat := AFormat;
  Result := Self;
end;

function TMultiLogWriteToRest.SetDateTimeFormat(const ADateTimeFormat: string): TMultiLogWriteToRest;
begin
  FDateTimeFormat := ADateTimeFormat;
  Result := Self;
end;

function TMultiLogWriteToRest.SetUserName(const AUserName: string): TMultiLogWriteToRest;
begin
  FUserName := AUserName;
  Result := Self;
end;

function TMultiLogWriteToRest.SetTag(const ATag: string): TMultiLogWriteToRest;
begin
  FTag := ATag;
  Result := Self;
end;

function TMultiLogWriteToRest.SetEventID(const AEventID: {$IFDEF MSWINDOWS}DWORD{$ELSEIF DEFINED(LINUX)}LONGWORD{$ELSEIF DEFINED(MACOS)}UInt32{$ENDIF}): TMultiLogWriteToRest;
begin
  FEventID := AEventID;
  Result := Self;
end;

function TMultiLogWriteToRest.ReplaceLogVariables(const AMsg: string; const ALogType: TLogType): string;
var
  LogPrefix: string;
  LogLine: string;
  DateTimeFormat: string;
  lJsonLog: TJSONObject;
begin
  case ALogType of
    ltInformation: LogPrefix := 'INFO ';
    ltWarning:     LogPrefix := 'WARN ';
    ltError:       LogPrefix := 'ERROR';
    ltFatalError:  LogPrefix := 'FATAL';
  else
    LogPrefix := 'INFO';
  end;

  if FLogFormat.IsEmpty then
    FLogFormat := '${time} ${username} ${eventid} [${log_type}] - ${message}';

  if FDateTimeFormat.IsEmpty then
    DateTimeFormat := 'YYYY-MM-DD hh:nn:ss'
  else
    DateTimeFormat := FDateTimeFormat;

  lJsonLog := TJSONObject.Create;
  try
    //LogLine := FLogFormat;
    //LogLine := StringReplace(LogLine, '${time}', FormatDateTime(DateTimeFormat, Now), [rfReplaceAll]);
    //LogLine := StringReplace(LogLine, '${username}', FUserName, [rfReplaceAll]);
    //LogLine := StringReplace(LogLine, '${log_type}', LogPrefix, [rfReplaceAll]);
    //LogLine := StringReplace(LogLine, '${message}', AMsg, [rfReplaceAll]);
    //LogLine := StringReplace(LogLine, '${eventid}', Format('%4.4d', [FEventID]), [rfReplaceAll]);
    LogLine := AMsg;

    lJsonLog.AddPair('logtype', LogPrefix);
    lJsonLog.AddPair('username', FUserName);
    lJsonLog.AddPair('time', FormatDateTime(DateTimeFormat, Now));
    lJsonLog.AddPair('eventid', Format('%4.4d', [FEventID]));
    lJsonLog.AddPair('tag', FTag);
    lJsonLog.AddPair('msg', LogLine);
    LogLine := lJsonLog.ToString;
    Result := LogLine;
  finally
    FreeAndNil(lJsonLog);
  end;
end;

procedure TMultiLogWriteToRest.EnsureDirectoryExists;
var
  LogDir: string;
begin
  //LogDir := ExtractFilePath(FFileName);
  if not DirectoryExists(LogDir) then
    TDirectory.CreateDirectory(LogDir);
end;

function TMultiLogWriteToRest.Execute(const AMsg: string; const ALogType: TLogType): TMultiLogWriteToRest;
var
  t: TThread;
begin
  //EnsureDirectoryExists;
  t := TThread.CreateAnonymousThread(procedure
    var
      LogLine: string;

      HTTPClient: THTTPClient;
      Response: IHTTPResponse;
      Params: TStringStream;
    begin
      LogLine     := ReplaceLogVariables(AMsg, ALogType);
      HTTPClient  := THTTPClient.Create;
      Params      := TStringStream.Create(LogLine, TEncoding.UTF8);
      try
        HTTPClient.ContentType := 'application/json';
        Response := HTTPClient.Post(FHttpServer, Params);
      finally
        HTTPClient.Free;
        Params.Free;
      end;
      TThread.Queue(TThread.Current, procedure
        begin
          //Some Code To Sycronize in the MainThread
          //Writeln('Response: ' + Response.ContentAsString);
        end);
    end
    );
  t.Start;

  Result := Self;
end;


initialization
  TMultiLogWriteToRest.FInstance := nil;

end.
