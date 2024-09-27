unit MultiLog4D.Factory;

interface

uses
  System.SysUtils,
  FMX.Dialogs,
  MultiLog4D.Interfaces;

type
  TLogFactory = class
  private
    class var FLogger: IMultiLog4D;
    class constructor Create;
  public
    class function GetLogger: IMultiLog4D;
  end;

implementation

uses
  {$IF NOT DEFINED(ANDROID) AND NOT DEFINED(IOS)}
    {$IFDEF MSWINDOWS}
      {$IFDEF ML4D_CONSOLE}
        MultiLog4D.Windows.Console,
      {$ELSEIF DEFINED(ML4D_EVENTVIEWER)}
        MultiLog4D.Windows.Services,
      {$ELSE}
        MultiLog4D.Windows.Files,
      {$ENDIF}
    {$ELSEIF DEFINED(LINUX)}
      {$IFDEF ML4D_CONSOLE}
        MultiLog4D.Linux.Console,
      {$ENDIF}
    {$ELSEIF DEFINED(MACOS)}
      {$IFDEF ML4D_DESKTOP}
        MultiLog4D.MacOs.Desktop,
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    {$IFDEF ANDROID}
      MultiLog4D.Android,
    {$ELSE}
      MultiLog4D.IOS,
    {$ENDIF}
  {$ENDIF}
  System.Classes;

class constructor TLogFactory.Create;
begin
  FLogger := nil;
end;

class function TLogFactory.GetLogger: IMultiLog4D;
begin
  if not Assigned(FLogger) then
  begin
    {$IF NOT DEFINED(ANDROID) AND NOT DEFINED(IOS)}
      {$IFDEF MSWINDOWS}
        {$IFDEF ML4D_CONSOLE}
          FLogger := TMultiLog4DWindowsConsole.Create;
        {$ELSEIF DEFINED(ML4D_EVENTVIEWER)}
          FLogger := TMultiLog4DWindowsServices.Create;
        {$ELSE}
          FLogger := TMultiLog4DWindowsFile.Create(EmptyStr);
        {$ENDIF}
      {$ELSEIF DEFINED(LINUX)}
        {$IFDEF ML4D_CONSOLE}
          FLogger := TMultiLog4DLinuxConsole.Create;
        {$ENDIF}
      {$ELSEIF DEFINED(MACOS)}
        FLogger := TMultiLog4DMacOS.Create;
      {$ENDIF}
    {$ELSE}
      {$IFDEF ANDROID}
        FLogger := TMultiLog4DAndroid.Create;
      {$ELSEIF DEFINED(IOS)}
        FLogger := TMultiLog4DiOS.Create;
      {$ENDIF}
    {$ENDIF}
  end;

  Result := FLogger;
end;


end.
