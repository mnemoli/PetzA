object frmSettings: TfrmSettings
  Left = 421
  Top = 372
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'PetzA Settings'
  ClientHeight = 241
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    400
    241)
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 200
    Width = 400
    Height = 41
    Align = alBottom
    Shape = bsTopLine
    ExplicitTop = 142
    ExplicitWidth = 396
  end
  object lblCameraFormat: TLabel
    Left = 224
    Top = 8
    Width = 106
    Height = 13
    Caption = 'Camera picture format:'
  end
  object lblDefaultPalette: TLabel
    Left = 224
    Top = 159
    Width = 69
    Height = 13
    Caption = 'Default palette'
  end
  object btnCancel: TButton
    Left = 250
    Top = 208
    Width = 67
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object btnOk: TButton
    Left = 178
    Top = 208
    Width = 68
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOkClick
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
    Left = 2
    Top = 208
    Width = 169
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reset hidden warning messages'
    TabOrder = 8
    OnClick = Button3Click
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
    Left = 322
    Top = 208
    Width = 68
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 7
    OnClick = btnHelpClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 80
    Width = 217
    Height = 81
    Caption = 'Mating'
    TabOrder = 4
    object chkShowHeart: TCheckBox
      Left = 8
      Top = 32
      Width = 201
      Height = 17
      Caption = 'Show love heart when mating'
      TabOrder = 1
    end
    object chkInstantBirth: TCheckBox
      Left = 8
      Top = 16
      Width = 201
      Height = 17
      Caption = 'Babies should be born instantly'
      TabOrder = 0
    end
    object chkTweakEyelidColours: TCheckBox
      Left = 8
      Top = 50
      Width = 201
      Height = 17
      Caption = 'Change eyelid genes'
      TabOrder = 2
      OnClick = chkTweakEyelidColoursClick
    end
  end
  object cmbCameraFormat: TComboBox
    Left = 232
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 3
    Items.Strings = (
      'Bitmap (Petz Default)'
      'GIF'
      'PNG')
  end
  object chkReactToCamera: TCheckBox
    Left = 232
    Top = 51
    Width = 201
    Height = 17
    Caption = 'Petz react to camera'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object chkUsePhotoNameFormat: TCheckBox
    Left = 232
    Top = 67
    Width = 201
    Height = 17
    Caption = 'New photo name format'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object chkAdultAC: TCheckBox
    Left = 231
    Top = 102
    Width = 201
    Height = 17
    Caption = 'AC Petz as adults'
    TabOrder = 10
  end
  object chkTransparentPhotos: TCheckBox
    Left = 232
    Top = 85
    Width = 201
    Height = 17
    Caption = 'Transparent photos (gif/png)'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object chkDisableNeglect: TCheckBox
    Left = 8
    Top = 40
    Width = 201
    Height = 17
    Caption = 'Disable daily neglect'
    TabOrder = 12
  end
  object chkTexturedIrises: TCheckBox
    Left = 8
    Top = 56
    Width = 201
    Height = 17
    Caption = 'Enable textured irises'
    Enabled = False
    TabOrder = 13
  end
  object chkUnlockPalette: TCheckBox
    Left = 231
    Top = 136
    Width = 97
    Height = 17
    Caption = 'Unlock palette'
    TabOrder = 14
    OnClick = chkUnlockPaletteClick
  end
  object chkEnablePalettes: TCheckBox
    Left = 231
    Top = 120
    Width = 130
    Height = 17
    Caption = 'Enable palette swaps'
    TabOrder = 15
  end
  object cmbDefaultPalette: TComboBox
    Left = 232
    Top = 173
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 16
  end
end
