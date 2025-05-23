program Horse_MultiLog4D;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  MultiLog4D.Common,
  MultiLog4D.Util,
  MultiLog4D.Types,
  MultiLog4D.Config,
  System.IOUtils,
  System.SysUtils;

var
  LOutputLogPath : string;
begin
  LOutputLogPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'MyLog');
  ForceDirectories(LOutputLogPath);

  MultiLog4D.Config.Log.LogWriteInformation('>>>>>>>>>> Starting <<<<<<<<<<')

  THorse
    .Get('/test1',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      MultiLog4D.Config.Log.LogWriteInformation('Before Test1');

      Res.Send('test1');

      MultiLog4D.Config.Log.LogWriteInformation('After Test1');
    end
    )
    .Get('/test2',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('test2');

      MultiLog4D.Config.Log.LogWriteInformation('Test2');
    end
    )
    .Get('/test3',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('test3');

      MultiLog4D.Config.Log.LogWriteInformation('Test3');
    end
    );

  THorse
    .Listen(9000);
end.
