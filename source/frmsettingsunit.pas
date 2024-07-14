unit frmsettingsunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, registry, mymessageunit, bndpetz, helpunit, UITypes;

type
  TfrmSettings = class(TForm)
    Bevel1: TBevel;
    btnCancel: TButton;
    btnOk: TButton;
    chkBrainSliders: TCheckBox;
    Button3: TButton;
    chkNameTags: TCheckBox;
    btnHelp: TButton;
    GroupBox1: TGroupBox;
    chkShowHeart: TCheckBox;
    chkInstantBirth: TCheckBox;
    lblCameraFormat: TLabel;
    cmbCameraFormat: TComboBox;
    chkReactToCamera: TCheckBox;
    chkUsePhotoNameFormat: TCheckBox;
    chkAdultAC: TCheckBox;
    chkTransparentPhotos: TCheckBox;
    chkDisableNeglect: TCheckBox;
    chkTexturedIrises: TCheckBox;
    chkUnlockPalette: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkUnlockPaletteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation
uses petzaunit;
{$R *.DFM}

procedure TfrmSettings.Button3Click(Sender: TObject);
var reg: tregistry;
begin
  if MessageDlg('This will turn back on all the messages which have been hidden '
    + #13 + #10 + 'by "Do not show this message again". Are you sure that you '
    + #13 + #10 + 'want to do this?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then begin
    reg := TRegistry.Create;
    try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.DeleteKey(TfrmMyMessage.getmessageroot);
    finally
      reg.free;
    end;
    showmessage('All message boxes have been reset');
  end;
end;

procedure TfrmSettings.chkUnlockPaletteClick(Sender: TObject);
begin
  if chkUnlockPalette.checked then begin
    var result := MessageDlg('Unlocking the palette will let you use more colours when ' +
                             'making your own palettes. However, it may change some ' +
                             'basegame colours. ' +
                             'You can create a petz.bmp palette to customise basegame colours.',
                             mtConfirmation, mbOKCancel, 0);
    chkUnlockPalette.Checked := result = mrOK;
  end;
end;

procedure TfrmSettings.btnOkClick(Sender: TObject);
begin
  petza.showheart := chkshowheart.checked;
  petza.instantbirth := chkInstantBirth.checked;
  petza.shownametags := chkNameTags.checked;
  petza.reacttocamera := chkReactToCamera.checked;
  petza.brainslidersontop := chkBrainSliders.checked;
  petza.CameraFormat := TCameraFormat(cmbCameraFormat.itemindex);
  petza.usenewphotonameformat := chkUsePhotonameFormat.Checked;
  petza.ACpetsadult := chkadultac.checked;
  petza.transparentphotos := chktransparentphotos.checked;
  petza.neglectdisabled := chkdisableneglect.Checked;
  petza.texturedirises := chktexturedirises.Checked;
  if petza.unlockpalette <> chkunlockpalette.Checked then
    showmessage('Please restart Petz to apply your changes!');
  petza.unlockpalette := chkunlockpalette.Checked;

end;

procedure TfrmSettings.btnHelpClick(Sender: TObject);
begin
  application.HelpContext(HELP_Settings);
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  chkBrainSliders.checked := petza.brainslidersontop;
  chkNameTags.checked := petza.shownametags;
  chkInstantBirth.Checked := petza.instantbirth;
  cmbCameraFormat.itemindex := integer(petza.CameraFormat);
  chkshowheart.checked := petza.showheart;
  chkReactToCamera.Checked := petza.reacttocamera;
  chkUsePhotonameFormat.Checked := petza.usenewphotonameformat;
  chkadultac.checked := petza.ACpetsadult;
  chktransparentphotos.Checked := petza.transparentphotos;
  chkdisableneglect.Checked := petza.neglectdisabled;
  chktexturedirises.Checked := petza.texturedirises;
  // stupid workaround
  chkunlockpalette.OnClick := nil;
  chkunlockpalette.checked := petza.unlockpalette;
  chkunlockpalette.OnClick := chkUnlockPaletteClick;

  chkshowheart.enabled := cpetzver in verBreeding;
  chkNameTags.Enabled := cpetzver in verNametags;
  chkInstantBirth.Enabled := assigned(rimports.petsprite_isoffspringdue);
  lblCameraFormat.enabled := cpetzver in verCamera;
  cmbCameraFormat.enabled := cpetzver in verCamera;
  chkReactToCamera.Enabled := cpetzver = pvpetz4;
  chkUsePhotonameFormat.Enabled := cpetzver in verNametags;
  chkadultac.Enabled := cpetzver in verNametags;
  chkdisableneglect.Enabled := cpetzver in verNametags;
  chktexturedirises.Enabled := cpetzver = pvpetz4;
  chkunlockpalette.Enabled := cpetzver = pvpetz4;
end;

end.

