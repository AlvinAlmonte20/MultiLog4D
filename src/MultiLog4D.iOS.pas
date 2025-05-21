unit MultiLog4D.iOS;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,

  MultiLog4D.Interfaces,
  MultiLog4D.Types,
  MultiLog4D.Base
{$IFDEF IOS}
  , iOSapi.Foundation
  , Macapi.Helpers
{$ENDIF}
  , MultiLog4D.Common.WriteToRest
  ;

type
  TMultiLog4DiOS = class(TMultiLog4DBase)
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

procedure TMultiLog4DiOS.WriteToRest(const AMsg: string; const ALogType: TLogType);
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

function TMultiLog4DiOS.LogWrite(const AMsg: string; const ALogType: TLogType): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  case ALogType of
    ltWarning:     LogWriteWarning(AMsg);
    ltError:       LogWriteError(AMsg);
    ltFatalError:  LogWriteFatalError(AMsg);
    else           LogWriteInformation(AMsg);
  end;

  if loRest in FLogOutput then
    WriteToRest(AMsg, ALogType);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteInformation(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF IOS}
    NSLog(StringToID(FTag + GetLogPrefix(ltInformation) + AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltInformation);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteWarning(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF IOS}
    NSLog(StringToID(FTag + GetLogPrefix(ltWarning) + AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltWarning);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteError(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF IOS}
    NSLog(StringToID(FTag + GetLogPrefix(ltError) + AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltError);

  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteFatalError(const AMsg: string): IMultiLog4D;
begin
  if not FEnableLog then
    Exit(Self);

  {$IFDEF IOS}
    NSLog(StringToID(FTag + GetLogPrefix(ltFatalError) + AMsg));
  {$ENDIF}

  if loRest in FLogOutput then
    WriteToRest(AMsg, ltFatalError);

  Result := Self as IMultiLog4D;
end;


end.
