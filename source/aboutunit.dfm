object frmAbout: TfrmAbout
  Left = 438
  Top = 350
  BorderStyle = bsDialog
  Caption = 'About Petz 5a...'
  ClientHeight = 100
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 297
    Height = 13
    Caption = 'Petz 5a (V1.4.3) was originally developed by Nicholas Sherlock'
  end
  object Label2: TLabel
    Left = 8
    Top = 79
    Width = 246
    Height = 13
    Caption = 'Copyright (C) Sherlock Software 2006-2018'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 47
    Width = 91
    Height = 13
    Caption = 'Email the author at:'
  end
  object Label4: TLabel
    Left = 105
    Top = 46
    Width = 107
    Height = 13
    Cursor = crHandPoint
    Caption = 'n.sherlock@gmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 8
    Top = 63
    Width = 79
    Height = 13
    Caption = 'Visit the website:'
  end
  object Label6: TLabel
    Left = 105
    Top = 63
    Width = 125
    Height = 13
    Cursor = crHandPoint
    Caption = 'www.sherlocksoftware.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label6Click
  end
  object Label7: TLabel
    Left = 8
    Top = 27
    Width = 227
    Height = 13
    Caption = 'PetzA originally developed by Nicholas Sherlock'
  end
  object Button1: TButton
    Left = 276
    Top = 74
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Ok'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 320
    Top = 8
    Width = 89
    Height = 33
    Lines.Strings = (
      'M'
      'e'
      'm'
      'o'
      '1')
    ScrollBars = ssVertical
    TabOrder = 1
    Visible = False
  end
  object XMLDocument1: TXMLDocument
    Left = 344
    Top = 40
  end
end
