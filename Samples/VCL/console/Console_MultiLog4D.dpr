program Console_MultiLog4D;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  MultiLog4D.Types,
  MultiLog4D.Config,
  System.IOUtils,
  System.SysUtils;

procedure ShowMenu;
begin
  Writeln('Choose number to print log message');
  Writeln('1. LogWrite');
  Writeln('2. LogWrite Information');
  Writeln('3. LogWrite Warning');
  Writeln('4. LogWrite Error');
  Writeln('5. LogWrite Fatal Error');
  Writeln('0. Exit');
end;

procedure ExecuteOption(const AOption: Integer);
begin
  case AOption of
    1: MultiLog4D.Config.Log
                        .LogWrite('LogWrite using ltInformation. Set TLogType on second parameter.', ltInformation);
    2: MultiLog4D.Config.Log.LogWriteInformation('LogWrite Information');
    3: MultiLog4D.Config.Log.LogWriteWarning('LogWrite Warning');
    4: MultiLog4D.Config.Log.LogWriteError('LogWrite Error');
    5: MultiLog4D.Config.Log.LogWriteFatalError('LogWrite FataError');
  else
    Writeln('Invalid Option. Try again.');
  end;
end;

procedure PauseForUser;
begin
  Writeln('Press any key to continue...');
  Readln;
end;

var
  UserInput: Integer;
begin
  try
    MultiLog4D.Config.Log.LogWrite('>>>>>>>>>> App Console - Starting <<<<<<<<<', ltInformation);

    repeat
      ShowMenu;
      Readln(UserInput);
      if UserInput <> 0 then
      begin
        ExecuteOption(UserInput);
        PauseForUser;
      end;
    until UserInput = 0;

  finally

  end;
end.

