unit MultiLog4D.Config;

interface

uses
  MultiLog4D.Interfaces,
  MultiLog4D.Util,
  MultiLog4D.Types;

function Log: IMultiLog4D;

implementation

var
 _Log : IMultiLog4D;

function Log: IMultiLog4D;
begin
  Result := _Log;
end;

initialization

 _Log := TMultiLog4DUtil.Logger
                        .Tag('TMultiLog4D')
                        .EventID(Random(1000))
                        .UserName('D2Bridge')
                        .Category(ecApplication)
                        //.FileName(ExtractFilePath(Application.exename) + 'LogFile.txt')
                        //.FileName(ExtractFilePath(Paramstr(0)) + 'LogFile.txt')
                        .Output([loConsole, loFile, loEventViewer, loRest])
                        .HttpServer('https://posttestserver.dev/p/3jeqepvu8bw2eva4/post');
end.
