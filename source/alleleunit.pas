unit alleleunit;

interface

uses
  SysUtils, Classes, Graphics, Controls, StdCtrls, ExtCtrls;

type TAlleleGroup = class(TGroupBox)
private
  fallele1: TComboBox;
//  fallele2: TComboBox;
//  pr: TPanel;
//  frexpress1: TRadioButton;
//  frexpress2: TRadioButton;
public
  constructor Create(AOwner: TComponent; name: string); overload;
  constructor Create(AOwner: TComponent); overload; override;
  destructor Destroy; override;
published
  property Allele1: TComboBox read fallele1;
//  property Allele2: TComboBox read fallele2;
//  property Express1: TRadioButton read frexpress1;
//  property Express2: TRadioButton read frexpress2;
end;

procedure Register;

implementation

procedure Register;
begin
  registercomponents('Standard', [TAlleleGroup]);
end;

{ TAlleleGroup }

constructor TAlleleGroup.Create(AOwner: TComponent);
begin
  Create(AOwner, 'Not Set');
end;

constructor TAlleleGroup.Create(AOwner: TComponent; name: string);
begin
  inherited Create(AOwner);

  Caption := name;
  Width := 200;
  Height := 57;

  fallele1 := TComboBox.Create(self);
  with fallele1 do
  begin
      Left := 19;
      Top := 21;
      Width := 120;
      Height := 23;
      TabOrder := 1;
      SetSubComponent(true);
      Parent := self;
      Style := csDropdownList;
  end;

//  fallele2 := TComboBox.Create(self);
//  with fallele2 do
//  begin
//      Left := 140;
//      Top := 21;
//      Width := 120;
//      Height := 23;
//      TabOrder := 1;
//      SetSubComponent(true);
//      Parent := self;
//      Style := csDropdownList;
//      Visible := false;
//  end;

//  pr := TPanel.Create(self);
//  with pr do
//  begin
//    Left := 3;
//    Top := 50;
//    Width := 174;
//    Height := 39;
//    Caption := 'Panel1';
//    ShowCaption := False;
//    TabOrder := 2;
//    SetSubComponent(true);
//    Parent := self;
//    Visible := false;
//  end;
//
//  frexpress1 := TRadioButton.Create(pr);
//  with frexpress1 do
//  begin
//    Left := 16;
//    Top := 8;
//    Width := 113;
//    Height := 17;
//    Caption := 'Express';
//    TabOrder := 0;
//    SetSubComponent(true);
//    Parent := pr;
//  end;
//
//  frexpress2 := TRadioButton.Create(pr);
//  with frexpress2 do
//  begin
//    Left := 100;
//    Top := 8;
//    Width := 113;
//    Height := 17;
//    Caption := 'Express';
//    TabOrder := 1;
//    SetSubComponent(true);
//    Parent := pr;
//  end;
end;

destructor TAlleleGroup.Destroy;
begin
  fallele1.Free;
//  fallele2.Free;
//  frexpress1.Free;
//  frexpress2.Free;
//  pr.Free;
  inherited;
end;

end.
