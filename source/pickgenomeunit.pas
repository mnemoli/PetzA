unit pickgenomeunit;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, petzclassesunit, Vcl.ExtCtrls, alleleunit, Vcl.ComCtrls, dllpatchunit;

type
  TfrmPickGenome = class(TForm)
    btnOk: TButton;
    PageControl1: TPageControl;
    Body: TTabSheet;
    Coat: TTabSheet;
    Eyes: TTabSheet;
    Markings: TTabSheet;
    Ears: TAlleleGroup;
    Head: TAlleleGroup;
    Feet: TAlleleGroup;
    Legs: TAlleleGroup;
    Tail: TAlleleGroup;
    BodyAllele: TAlleleGroup;
    LegExt: TAlleleGroup;
    BodyExt: TAlleleGroup;
    EyeColor: TAlleleGroup;
    LidColor: TAlleleGroup;
    TongueColor: TAlleleGroup;
    Coat1: TAlleleGroup;
    Coat2: TAlleleGroup;
    Coat3: TAlleleGroup;
    Coat4: TAlleleGroup;
    Coat5: TAlleleGroup;
    MF1: TAlleleGroup;
    MF2: TAlleleGroup;
    M1: TAlleleGroup;
    M2: TAlleleGroup;
    coatallele: TAlleleGroup;
    btnCancel: TButton;
    btnAllFather: TButton;
    MainScale: TAlleleGroup;
    btnAllMother: TButton;
    btnPageToMother: TButton;
    btnPageToFather: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAllFatherClick(Sender: TObject);
    procedure btnAllMotherClick(Sender: TObject);
    procedure btnPageToMotherClick(Sender: TObject);
    procedure btnPageToFatherClick(Sender: TObject);
  private
    female, male: TPetzPetSprite;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; female: TPetzPetSprite; male: TPetzPetSprite) overload;
  end;

var
  frmPickGenome: TfrmPickGenome;

implementation
uses frmmateunit, bndpetz, petzaunit, system.Generics.Collections;

var hgenome: TPatchThisCall;
var staticholder: TFrmPickGenome;
type
    allelepair = class(TObject)
    public
      center: integer;
      range: integer;
    end;

{$R *.dfm}

{ TfrmPickGenome }

function mygenomeconstructor(return, instance: pointer; chroms1, chroms2: pointer): pointer; stdcall;
begin
  result := pointer(hgenome.callorigproc(instance, [cardinal(chroms1), cardinal(chroms2)]));
  var genome := TPetzGenome(result);
  with staticholder do begin
    for var i := 0 to ComponentCount-1 do begin
    if components[i].ClassType = TClass(TAlleleGroup) then begin
      var comp := components[i] as TAlleleGroup;
      var ctag := comp.Tag;

      if comp.Allele1.ItemIndex <> 4 then begin
        var al1 := comp.Allele1.Items.Objects[comp.Allele1.ItemIndex] as allelepair;
        var thisallele := genome.chromosomes1[2].alleles[ctag];
        var thisallele2 := genome.chromosomes2[2].alleles[ctag];
        thisallele.center := al1.center;
        thisallele.range := al1.range;
        thisallele2.center := al1.center;
        thisallele2.range := al1.range;

      end;
//      if comp.Allele2.ItemIndex <> 4 then begin
//        var al2 := comp.Allele2.Items.Objects[comp.Allele2.ItemIndex] as allelepair;
//        var thisallele := genome.chromosomes2[2].alleles[ctag];
//        thisallele.center := al2.center;
//        thisallele.range := al2.range;
//      end;
    end;
  end;
  end;
end;

procedure TfrmPickGenome.btnAllFatherClick(Sender: TObject);
begin
  for var i := 0 to ComponentCount-1 do begin
    if components[i].ClassType = TClass(TAlleleGroup) then begin
      var comp := components[i] as TAlleleGroup;
      comp.Allele1.ItemIndex := 2;
      //comp.Allele2.ItemIndex := 2;
    end;
  end;
end;

procedure TfrmPickGenome.btnAllMotherClick(Sender: TObject);
begin
  for var i := 0 to ComponentCount-1 do begin
    if components[i].ClassType = TClass(TAlleleGroup) then begin
      var comp := components[i] as TAlleleGroup;
      comp.Allele1.ItemIndex := 0;
      //comp.Allele2.ItemIndex := 0;
    end;
  end;
end;

procedure TfrmPickGenome.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  close;
end;

procedure TfrmPickGenome.btnOkClick(Sender: TObject);
begin
  staticholder := self;
  hgenome := patchthiscall(rimports.genome_genome, @mygenomeconstructor);
  var matefrm := self.Owner as TFrmMate;
  var backup := matefrm.batchCount.Text;
  matefrm.batchCount.text := inttostr(1);
  matefrm.btnBatchClick(self);
  matefrm.batchCount.Text := backup;
  petza.batchbreedcountdefault := strtoint(backup);
  hgenome.restore;
  ModalResult := mrOK;
  close;
end;

procedure TfrmPickGenome.btnPageToFatherClick(Sender: TObject);
begin
  var thispage := pagecontrol1.Pages[pagecontrol1.ActivePageIndex];
  for var i := 0 to thispage.ControlCount-1 do begin
    if thispage.controls[i].ClassType = TClass(TAlleleGroup) then begin
      var comp := thispage.controls[i] as TAlleleGroup;
      comp.Allele1.ItemIndex := 2;
    end;
  end;
end;

procedure TfrmPickGenome.btnPageToMotherClick(Sender: TObject);
begin
  var thispage := pagecontrol1.Pages[pagecontrol1.ActivePageIndex];
  for var i := 0 to thispage.ControlCount-1 do begin
    if thispage.controls[i].ClassType = TClass(TAlleleGroup) then begin
      var comp := thispage.controls[i] as TAlleleGroup;
      comp.Allele1.ItemIndex := 0;
    end;
  end;
end;

function breedidtoname(id: integer): string;
begin
  if id < 1000 then begin
    result := inttostr(id);
    exit;
  end;
  try
    var loadinfo := TPetzLoadInfo(rimports.findbreedclassloadinfo(id));
    if loadinfo = nil then
      result := 'notfound'
    else begin
      var breedname := copy(trim(loadinfo.breed), 0, 4);
      result := breedname;
    end;
  except
    result := 'error';
  end;

end;

constructor TfrmPickGenome.Create(AOwner: TComponent; female: TPetzPetSprite; male: TPetzPetSprite);
  var genome1, genome2: TPetzGenome;
begin
  inherited Create(AOwner);
  genome1 := female.petinfo.genome;
  genome2 := male.petinfo.genome;
  self.female := female;
  self.male := male;
  for var i := 0 to ComponentCount-1 do begin
    if components[i].ClassType = TClass(TAlleleGroup) then begin
      var comp := components[i] as TAlleleGroup;
      var tag := comp.Tag;
      var al1 := genome1.chromosomes1[2].alleles[tag];
      var al2 := genome1.chromosomes2[2].alleles[tag];
      var al3 := genome2.chromosomes1[2].alleles[tag];
      var al4 := genome2.chromosomes2[2].alleles[tag];
      var allele1 := breedidtoname(al1.center) + ' (' + uinttostr(al1.range) + ') f';
      var allele2 := breedidtoname(al2.center) + ' (' + uinttostr(al2.range) + ') f';
      var allele3 := breedidtoname(al3.center) + ' (' + uinttostr(al3.range) + ') m';
      var allele4 := breedidtoname(al4.center) + ' (' + uinttostr(al4.range) + ') m';

      var pair1, pair2, pair3, pair4: allelepair;
      pair1 := allelepair.Create;
      pair2 := allelepair.Create;
      pair3 := allelepair.Create;
      pair4 := allelepair.Create;
      with pair1 do begin
        center := al1.center;
        range := al1.range;
      end;
       with pair2 do begin
        center := al2.center;
        range := al2.range;
      end;
       with pair3 do begin
        center := al3.center;
        range := al3.range;
      end;
       with pair4 do begin
        center := al4.center;
        range := al4.range;
      end;

      comp.Allele1.AddItem(allele1, pair1);
      comp.Allele1.AddItem(allele2, pair2);
      comp.Allele1.AddItem(allele3, pair3);
      comp.Allele1.AddItem(allele4, pair4);
//      comp.Allele2.AddItem(allele1, pair1);
//      comp.Allele2.AddItem(allele2, pair2);
//      comp.Allele2.AddItem(allele3, pair3);
//      comp.Allele2.AddItem(allele4, pair4);

      comp.Allele1.AddItem('Random', nil);
//      comp.Allele2.AddItem('Random', nil);

      comp.Allele1.ItemIndex := 4;
//      comp.Allele2.ItemIndex := 4;

//      var randex := Random(2);
//      if randex = 0 then
//        comp.Express1.Checked := true
//      else
//        comp.Express2.Checked := true;
    end;
  end;
end;

end.
