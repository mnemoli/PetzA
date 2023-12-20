unit nomatchunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Vcl.Imaging.gifimg, ExtCtrls, shellapi;

type
  TfrmNoMatch = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Image1: TImage;
    Label2: TLabel;
    Button2: TButton;
    procedure Label3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNoMatch: TfrmNoMatch;

implementation

{$R *.DFM}

procedure TfrmNoMatch.Label3Click(Sender: TObject);
begin
shellexecute(handle,'open','http://www.sherlocksoftware.org/phpBB2/',nil,nil,sw_shownormal);
end;

procedure TfrmNoMatch.Label2Click(Sender: TObject);
begin
shellexecute(handle,'open','http://www.sherlocksoftware.org/page.php?id=7',nil,nil,sw_shownormal);
end;

procedure TfrmNoMatch.Label1Click(Sender: TObject);
begin
shellexecute(handle,'open','mailto:n.sherlock@gmail.com',nil,nil,sw_shownormal);
end;

procedure TfrmNoMatch.Button2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmNoMatch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action:=cafree;
end;

procedure TfrmNoMatch.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  close;
end;

end.
