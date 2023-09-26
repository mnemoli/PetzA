object frmProfileManager: TfrmProfileManager
  Left = 66
  Top = 284
  Caption = 'Profiles'
  ClientHeight = 306
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    490
    306)
  TextHeight = 13
  object chkEnabled: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Enable profiles'
    TabOrder = 0
    OnClick = chkEnabledClick
  end
  object grpProfiles: TGroupBox
    Left = 16
    Top = 32
    Width = 467
    Height = 236
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Profiles'
    TabOrder = 1
    ExplicitWidth = 475
    ExplicitHeight = 237
    DesignSize = (
      467
      236)
    object bvl1: TBevel
      Left = 390
      Top = 195
      Width = 9
      Height = 25
      Anchors = [akRight, akBottom]
      Shape = bsRightLine
      ExplicitLeft = 398
      ExplicitTop = 196
    end
    object btnAddProfile: TButton
      Left = 338
      Top = 195
      Width = 49
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddProfileClick
      ExplicitLeft = 346
      ExplicitTop = 196
    end
    object Panel1: TPanel
      Left = 8
      Top = 16
      Width = 451
      Height = 173
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      ExplicitWidth = 459
      ExplicitHeight = 174
      object lstProfiles: TProfileListDisplay
        Left = 1
        Top = 1
        Width = 457
        Height = 172
        onExecute = lstProfilesExecute
        onChange = lstProfilesChange
        ShowEnabled = True
        Align = alClient
        TabStop = True
        TabOrder = 0
      end
    end
    object btnEdit: TButton
      Left = 410
      Top = 195
      Width = 49
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Edit'
      Enabled = False
      TabOrder = 1
      OnClick = btnEditClick
      ExplicitLeft = 418
      ExplicitTop = 196
    end
  end
  object btnOk: TButton
    Left = 330
    Top = 275
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
    ExplicitLeft = 338
    ExplicitTop = 276
  end
  object Button1: TButton
    Left = 408
    Top = 275
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 3
    OnClick = Button1Click
    ExplicitLeft = 416
    ExplicitTop = 276
  end
end
