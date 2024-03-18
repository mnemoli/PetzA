object frmSettings: TfrmSettings
  Left = 421
  Top = 372
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'PetzA Settings'
  ClientHeight = 183
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    396
    183)
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 142
    Width = 396
    Height = 41
    Align = alBottom
    Shape = bsTopLine
  end
  object lblCameraFormat: TLabel
    Left = 224
    Top = 8
    Width = 106
    Height = 13
    Caption = 'Camera picture format:'
  end
  object btnCancel: TButton
    Left = 242
    Top = 150
    Width = 67
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
    ExplicitLeft = 238
    ExplicitTop = 149
  end
  object btnOk: TButton
    Left = 170
    Top = 150
    Width = 68
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOkClick
    ExplicitLeft = 166
    ExplicitTop = 149
  end
  object chkBrainSliders: TCheckBox
    Left = 8
    Top = 8
    Width = 217
    Height = 17
    Caption = 'Brainsliders should be "Always on top"'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object Button3: TButton
    Left = -6
    Top = 150
    Width = 169
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reset hidden warning messages'
    TabOrder = 9
    OnClick = Button3Click
    ExplicitLeft = -10
    ExplicitTop = 149
  end
  object chkNameTags: TCheckBox
    Left = 8
    Top = 24
    Width = 217
    Height = 17
    Caption = 'Draw name tags on pets'
    TabOrder = 1
  end
  object btnHelp: TButton
    Left = 314
    Top = 150
    Width = 68
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 7
    OnClick = btnHelpClick
    ExplicitLeft = 310
    ExplicitTop = 149
  end
  object chkHideNavigation: TCheckBox
    Left = 8
    Top = 40
    Width = 201
    Height = 17
    Caption = 'Hide Babyz navigation bar'
    TabOrder = 2
  end
  object cmbCameraFormat: TComboBox
    Left = 232
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 4
    Items.Strings = (
      'Bitmap (Petz Default)'
      'GIF'
      'PNG')
  end
  object chkUsePhotoNameFormat: TCheckBox
    Left = 232
    Top = 51
    Width = 201
    Height = 17
    Caption = 'New photo name format'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object chkNoDiapers: TCheckBox
    Left = 8
    Top = 56
    Width = 201
    Height = 17
    Caption = 'Diapers can'#39't be soiled'
    Enabled = False
    TabOrder = 3
  end
  object chkTransparentPhotos: TCheckBox
    Left = 232
    Top = 69
    Width = 201
    Height = 17
    Caption = 'Transparent photos (gif/png)'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object chkStopWalking: TCheckBox
    Left = 8
    Top = 72
    Width = 201
    Height = 17
    Caption = 'Stop Babyz walking'
    Enabled = False
    TabOrder = 11
  end
end
