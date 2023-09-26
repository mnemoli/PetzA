object frmMate: TfrmMate
  Left = 438
  Top = 356
  BorderStyle = bsDialog
  Caption = 'Mate two pets...'
  ClientHeight = 246
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 25
    Width = 51
    Height = 13
    Caption = 'Females:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 184
    Top = 25
    Width = 38
    Height = 13
    Caption = 'Males:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 227
    Height = 13
    Caption = 'Select a female and a male pet, then click mate!'
  end
  object lstFemales: TListBox
    Left = 40
    Top = 41
    Width = 129
    Height = 169
    ItemHeight = 13
    TabOrder = 0
  end
  object lstMales: TListBox
    Left = 192
    Top = 41
    Width = 129
    Height = 169
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 232
    Top = 216
    Width = 59
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button1Click
  end
  object btnMate: TButton
    Left = 168
    Top = 216
    Width = 59
    Height = 25
    Caption = 'Mate'
    Default = True
    TabOrder = 2
    OnClick = btnMateClick
  end
  object btnHelp: TButton
    Left = 296
    Top = 216
    Width = 59
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = btnHelpClick
  end
  object btnBatch: TButton
    Left = 103
    Top = 215
    Width = 59
    Height = 25
    Caption = 'Batch'
    Default = True
    TabOrder = 5
    OnClick = btnBatchClick
  end
  object batchCount: TEdit
    Left = 64
    Top = 218
    Width = 33
    Height = 21
    NumbersOnly = True
    TabOrder = 6
    Text = '10'
    StyleName = 'Windows'
  end
  object btnCustom: TButton
    Left = -1
    Top = 215
    Width = 59
    Height = 25
    Caption = 'Custom'
    Default = True
    TabOrder = 7
    OnClick = btnCustomClick
  end
end
