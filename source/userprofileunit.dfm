object UserProfile: TUserProfile
  Left = 0
  Top = 0
  Caption = 'Default Pet Profile'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object OK: TButton
    Left = 545
    Top = 409
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 456
    Top = 409
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = CancelClick
  end
  object CustomUserProfile: TMemo
    Left = 24
    Top = 16
    Width = 577
    Height = 369
    Lines.Strings = (
      'CustomUserProfile')
    TabOrder = 2
  end
end
