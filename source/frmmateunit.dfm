object frmMate: TfrmMate
  Left = 438
  Top = 356
  BorderStyle = bsDialog
  Caption = 'Mate two pets...'
  ClientHeight = 247
  ClientWidth = 306
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
    Left = 8
    Top = 24
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
    Left = 160
    Top = 24
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
    Left = 16
    Top = 40
    Width = 129
    Height = 169
    ItemHeight = 13
    TabOrder = 0
  end
  object lstMales: TListBox
    Left = 168
    Top = 40
    Width = 129
    Height = 169
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 176
    Top = 216
    Width = 59
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button1Click
  end
  object btnMate: TButton
    Left = 112
    Top = 216
    Width = 59
    Height = 25
    Caption = 'Mate'
    Default = True
    TabOrder = 2
    OnClick = btnMateClick
  end
  object btnHelp: TButton
    Left = 240
    Top = 216
    Width = 59
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = btnHelpClick
  end
  object btnBatch: TButton
    Left = 47
    Top = 216
    Width = 59
    Height = 25
    Caption = 'Batch'
    Default = True
    TabOrder = 5
    OnClick = btnBatchClick
  end
  object batchCount: TEdit
    Left = 8
    Top = 218
    Width = 33
    Height = 21
    NumbersOnly = True
    TabOrder = 6
    Text = '10'
    StyleName = 'Windows'
  end
end
