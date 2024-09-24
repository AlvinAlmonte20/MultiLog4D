unit Unit4;

interface

uses
  MultiLog4D.Util,
  MultiLog4D.Types,

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, UI.Standard, UI.Edit, UI.Base,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    rbInformation: TRadioButton;
    rbWarning: TRadioButton;
    rbError: TRadioButton;
    rbFatalError: TRadioButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

procedure TForm4.Button1Click(Sender: TObject);
var
  LStrTypeMsg : string;
  LTypeMsg : TLogType; //Uses MultiLog4D.Types
begin
  if rbInformation.IsChecked then
  begin
    LTypeMsg := TLogType.ltInformation;
    LStrTypeMsg := 'Information';
  end
  else if rbWarning.IsChecked then
  begin
    LTypeMsg := TLogType.ltWarning;
    LStrTypeMsg := 'Warning';
  end
  else if rbError.IsChecked then
  begin
    LTypeMsg := TLogType.ltError;
    LStrTypeMsg := 'Error';
  end
  else
  begin
    LTypeMsg := TLogType.ltFatalError;
    LStrTypeMsg := 'Faltal Error';
  end;

  TMultiLog4DUtil
   .Logger
   .LogWrite(Format('LogWrite Type: %s', [LStrTypeMsg]), LTypeMsg);
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  TMultiLog4DUtil
    .Logger
    .LogWriteInformation('Information')
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  TMultiLog4DUtil
    .Logger
    .LogWriteInformation('Warning')
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  TMultiLog4DUtil
    .Logger
    .LogWriteInformation('Error')
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
  TMultiLog4DUtil
    .Logger
    .LogWriteInformation('Fatal Error')
end;

end.
