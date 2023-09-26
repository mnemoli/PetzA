object frmPickGenome: TfrmPickGenome
  Left = 0
  Top = 0
  Caption = 'frmPickGenome'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object btnOk: TButton
    Left = 717
    Top = 567
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOkClick
  end
  object PageControl1: TPageControl
    Left = 24
    Top = 16
    Width = 753
    Height = 545
    ActivePage = Body
    TabOrder = 1
    object Body: TTabSheet
      Caption = 'Body'
      object Ears: TAlleleGroup
        Tag = 3
        Left = 16
        Top = 3
        Width = 200
        Height = 57
        Caption = 'Ears'
        TabOrder = 0
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Head: TAlleleGroup
        Tag = 4
        Left = 16
        Top = 106
        Width = 200
        Height = 57
        Caption = 'Head'
        TabOrder = 1
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Feet: TAlleleGroup
        Tag = 6
        Left = 16
        Top = 209
        Width = 200
        Height = 57
        Caption = 'Feet'
        TabOrder = 2
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Legs: TAlleleGroup
        Tag = 7
        Left = 16
        Top = 312
        Width = 200
        Height = 57
        Caption = 'Legs'
        TabOrder = 3
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Tail: TAlleleGroup
        Tag = 8
        Left = 16
        Top = 415
        Width = 200
        Height = 57
        Caption = 'Tail'
        TabOrder = 4
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object BodyAllele: TAlleleGroup
        Tag = 9
        Left = 239
        Top = 3
        Width = 200
        Height = 57
        Caption = 'Body'
        TabOrder = 5
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object LegExt: TAlleleGroup
        Tag = 22
        Left = 239
        Top = 106
        Width = 200
        Height = 57
        Caption = 'Leg Extension'
        TabOrder = 6
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object BodyExt: TAlleleGroup
        Tag = 23
        Left = 239
        Top = 209
        Width = 200
        Height = 57
        Caption = 'Body Extension'
        TabOrder = 7
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object MainScale: TAlleleGroup
        Tag = 2
        Left = 239
        Top = 312
        Width = 200
        Height = 57
        Caption = 'Scale'
        TabOrder = 8
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object btnPageToMother: TButton
        Left = 480
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Mother'
        TabOrder = 9
        OnClick = btnPageToMotherClick
      end
      object btnPageToFather: TButton
        Left = 601
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Father'
        TabOrder = 10
        OnClick = btnPageToFatherClick
      end
    end
    object Eyes: TTabSheet
      Caption = 'Eyes'
      ImageIndex = 2
      object EyeColor: TAlleleGroup
        Tag = 12
        Left = 3
        Top = 3
        Width = 200
        Height = 57
        Caption = 'Eye Color'
        TabOrder = 0
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object LidColor: TAlleleGroup
        Tag = 13
        Left = 3
        Top = 106
        Width = 200
        Height = 57
        Caption = 'Lid Color'
        TabOrder = 1
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object TongueColor: TAlleleGroup
        Tag = 11
        Left = 3
        Top = 209
        Width = 200
        Height = 57
        Caption = 'Tongue'
        TabOrder = 2
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Button5: TButton
        Left = 480
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Mother'
        TabOrder = 3
        OnClick = btnPageToMotherClick
      end
      object Button6: TButton
        Left = 601
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Father'
        TabOrder = 4
        OnClick = btnPageToFatherClick
      end
    end
    object Coat: TTabSheet
      Caption = 'Coat'
      ImageIndex = 1
      object Coat1: TAlleleGroup
        Tag = 14
        Left = 3
        Top = 3
        Width = 200
        Height = 57
        Caption = 'Coat Color 1'
        TabOrder = 0
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Coat2: TAlleleGroup
        Tag = 15
        Left = 3
        Top = 106
        Width = 200
        Height = 57
        Caption = 'Coat Color 2'
        TabOrder = 1
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Coat3: TAlleleGroup
        Tag = 16
        Left = 3
        Top = 209
        Width = 250
        Height = 97
        Caption = 'Coat Color 3'
        TabOrder = 2
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Coat4: TAlleleGroup
        Tag = 16
        Left = 3
        Top = 304
        Width = 200
        Height = 57
        Caption = 'Coat Color 4'
        TabOrder = 3
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Coat5: TAlleleGroup
        Tag = 17
        Left = 3
        Top = 407
        Width = 200
        Height = 57
        Caption = 'Coat Color 5'
        TabOrder = 4
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object coatallele: TAlleleGroup
        Tag = 10
        Left = 242
        Top = 3
        Width = 200
        Height = 57
        Caption = 'Coat'
        TabOrder = 5
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Button1: TButton
        Left = 480
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Mother'
        TabOrder = 6
        OnClick = btnPageToMotherClick
      end
      object Button2: TButton
        Left = 601
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Father'
        TabOrder = 7
        OnClick = btnPageToFatherClick
      end
    end
    object Markings: TTabSheet
      Caption = 'Markings'
      ImageIndex = 3
      object MF1: TAlleleGroup
        Tag = 19
        Left = 3
        Top = 3
        Width = 200
        Height = 57
        Caption = 'Marking Factor 1'
        TabOrder = 0
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object MF2: TAlleleGroup
        Tag = 18
        Left = 3
        Top = 106
        Width = 200
        Height = 57
        Caption = 'Marking Factor 2'
        TabOrder = 1
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object M1: TAlleleGroup
        Tag = 20
        Left = 3
        Top = 209
        Width = 200
        Height = 57
        Caption = 'Marking 1'
        TabOrder = 2
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object M2: TAlleleGroup
        Tag = 21
        Left = 3
        Top = 312
        Width = 200
        Height = 57
        Caption = 'Marking 2'
        TabOrder = 3
        Allele1.Left = 19
        Allele1.Top = 21
        Allele1.Width = 120
        Allele1.Height = 23
        Allele1.Style = csDropDownList
        Allele1.TabOrder = 0
      end
      object Button3: TButton
        Left = 480
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Mother'
        TabOrder = 4
        OnClick = btnPageToMotherClick
      end
      object Button4: TButton
        Left = 601
        Top = 35
        Width = 115
        Height = 25
        Caption = 'Page to Father'
        TabOrder = 5
        OnClick = btnPageToFatherClick
      end
    end
  end
  object btnCancel: TButton
    Left = 629
    Top = 567
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnAllFather: TButton
    Left = 548
    Top = 567
    Width = 75
    Height = 25
    Caption = 'All to Father'
    TabOrder = 3
    OnClick = btnAllFatherClick
  end
  object btnAllMother: TButton
    Left = 467
    Top = 567
    Width = 75
    Height = 25
    Caption = 'All to Mother'
    TabOrder = 4
    OnClick = btnAllMotherClick
  end
end
