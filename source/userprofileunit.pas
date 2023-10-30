unit userprofileunit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TUserProfile = class(TForm)
    OK: TButton;
    Cancel: TButton;
    CustomUserProfile: TMemo;
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    constructor Create(AOwner: TComponent; text: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserProfile: TUserProfile;

implementation
uses petzaunit;

{$R *.dfm}

procedure TUserProfile.CancelClick(Sender: TObject);
begin
  self.Close;
end;

constructor TUserProfile.Create(AOwner: TComponent; text: string);
begin
  inherited Create(AOwner);
  CustomUserProfile.Text := text;
end;

procedure TUserProfile.OKClick(Sender: TObject);
begin
  petza.customuserprofile := CustomUserProfile.Text;
  self.Close;
end;

end.
