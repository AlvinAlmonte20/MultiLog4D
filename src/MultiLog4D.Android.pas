unit MultiLog4D.Android;

interface

uses
  System.SysUtils,

  Multilog4D.Base,
  Multilog4D.Types,
  Multilog4D.Interfaces
  {$IFDEF ANDROID}
  ,Androidapi.Helpers
  ,Androidapi.JNI.JavaTypes
  ,Androidapi.JNI.Util
  ,MultiLog4D.Java.Interfaces
  {$ENDIF}
  ,MultiLog4D.Common.WriteToRest;

type
  TMultiLog4DAndroid = class(TMultiLog4DBase)
  private
    procedure WriteToRest(const AMsg: string; const ALogType: TLogType);
  public
    function LogWrite(const AMsg: string; const ALogType: TLogType): IMultiLog4D; override;
    function LogWriteInformation(const AMsg: string): IMultiLog4D; override;
    function LogWriteWarning(const AMsg: string): IMultiLog4D; override;
    function LogWriteError(const AMsg: string): IMultiLog4D; override;
    function LogWriteFatalError(const AMsg: string): IMultiLog4D; override;
  end;

implementation

procedure TMultiLog4DAndroid.WriteToRest(const AMsg: string; const ALogType: TLogType);
begin
  TMultiLogWriteToRest.Instance
    .HttpServer(FHttpServer)
    .SetLogFormat(FLogFormat)
    .SetDateTimeFormat(FDateTimeFormat)
    .SetUserName(FUserName)
    .SetEventID(FEventID)
    .SetTag(FTag)
    .Execute(AMsg, ALogType);
end;

function TMultiLog4DAndroid.LogWrite(const AMsg: string; const ALogType: TLogType): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  case ALogType of
    ltWarning    : LogWriteWarning(AMsg);
    ltError      : LogWriteError(AMsg);
    ltFatalError : LogWriteFatalError(AMsg);
  else
    LogWriteInformation(AMsg);
  end;

  if loRest in FLogOutput then
    WriteToRest(AMsg, ALogType);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteInformation(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF ANDROID}
    if FTag = EmptyStr then
      GetDefaultTag;

    TJutil_Log.JavaClass.i(StringToJString(FTag), StringToJString(AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltInformation);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteWarning(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF ANDROID}
    if FTag = EmptyStr then
      GetDefaultTag;

    TJutil_Log.JavaClass.w(StringToJString(FTag), StringToJString(AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltWarning);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteError(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF ANDROID}
    if FTag = EmptyStr then
      GetDefaultTag;

    TJutil_Log.JavaClass.e(StringToJString(FTag), StringToJString(AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltError);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteFatalError(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF ANDROID}
    if FTag = EmptyStr then
      GetDefaultTag;

    TJutil_Log.JavaClass.e(StringToJString(FTag), StringToJString(AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltFatalError);

  Result := Self as IMultiLog4D;
end;

end.
