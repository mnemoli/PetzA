unit frmmateunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, contnrs,helpunit, petzcommon1, petzclassesunit, mymenuunit;

type
  TfrmMate = class(TForm)
    Label1: TLabel;
    lstFemales: TListBox;
    Label2: TLabel;
    lstMales: TListBox;
    Button1: TButton;
    btnMate: TButton;
    Label3: TLabel;
    btnHelp: TButton;
    btnBatch: TButton;
    batchCount: TEdit;
    OwnerNameLabel: TLabel;
    OwnerNameEdit: TEdit;
    chkFasterBatching: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure btnMateClick(Sender: TObject);
    procedure btnBatchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    function validate(out female, male: TPetzPetSprite): boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMate: TfrmMate;

var batchbreedcount: integer;
var waitingforpettocomeout: boolean;
var lastmotherid: uint;
var lastfather: TPetzPetSprite;
var oldshowheart, olddisablebreeding: boolean;

function matebystateconceive(female, male: TPetzPetSprite): boolean;
procedure deliveroffspring(female: TPetzPetSprite);
procedure unpatchbreedingcalls;
procedure petmate(sender: tmymenuitem = nil);

implementation
uses bndpetz, mymessageunit, dllpatchunit, petzaunit;
{$R *.DFM}

procedure TfrmMate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := cafree;
end;

procedure TfrmMate.Button1Click(Sender: TObject);
begin
  close;
end;

procedure patchbreedingcalls;
  var data: array[0..4] of byte;
begin
  // Patch the birth dialog away
  // Known issue - skips setting adopter name
  data[0] := $C2;
  data[1] := $10;
  data[2] := $00; //ret 10h
  patchcode(rimports.dobirthdialog, 3, 3, @data);
  // Patch the "pet is old enough to come out on their own" dialogue away
  if petza.usefasterbatchbreeding then begin
    data[0] := $e9;
    data[1] := $83;
    data[2] := $02;
    data[3] := 00;
    data[4] := 00;
    patchcode(ptr($412a44), 5, 5, @data);
  end else begin
    data[0] := $EB;
    data[1] := $2F;
    patchcode(ptr($00412aea), 2, 2, @data);
  end;

end;

procedure unpatchbreedingcalls;
  var data: array[0..4] of byte;
begin
  // Restore birth dialog
  data[0] := $64;
  data[1] := $A1;
  data[2] := $00;
  patchcode(rimports.dobirthdialog, 3, 3, @data);

  // Restore pet is old enough dialog
  if petza.usefasterbatchbreeding then begin
    data[0] := $0f;
    data[1] := $8d;
    data[2] := $82;
    data[3] := $02;
    data[4] := $00;
    patchcode(ptr($412a44), 5, 5, @data);
  end else begin
    data[0] := $50;
    data[1] := $42;
    patchcode(ptr($00412aea), 2, 2, @data);
  end;

end;

function matebystateconceive(female, male: TPetzPetSprite): boolean;
var state: Pointer;
  var old: TPetzPetSprite;
  old90: longword;
  buffer: array[0..100] of byte;
begin
 try
    old := female.interactingpet;
    female.interactingpet := male;

    old90 := female.stateflag;
    female.stateflag := 1;

    try
      state := pointer(thiscall(@buffer[0], rimports.stateconceive_stateconceive, []));
      thiscall(state, rimports.stateconceive_execute, [cardinal(female), 1, 0]);
      result := female.petinfo.pregnant;
    finally
      female.interactingpet := old;
      female.stateflag := old90;
    end;
  except
    result := false;
  end;
end;

// deletes mother, brings offspring out at position 1
procedure deliveroffspring(female: TPetzPetSprite);
  var offspring: TPetzPetSprite;
  motherid: uint;
begin
  offspring := TPetzPetSprite(thiscall(female, rimports.petsprite_deliveroffspring, []));
  if offspring <> nil then begin
    motherid := female.id;
    // Age up offspring
    offspring.setbiorhythm(8, 100);
    // Delete mother and offspring
    thiscall(female, rimports.petsprite_setshouldibedeleted, [1]);
    thiscall(offspring, rimports.petsprite_setshouldibedeleted, [1]);
    thiscall(petzoberon, rimports.oberon_fixshouldibedeleted, []);
    // Call mother back out, which results in offspring coming out
    petzcase.loadpetz(motherid, 1);
  end;
end;

procedure petmate(sender: tmymenuitem = nil);
var list: tobjectlist;
  male, female: boolean;
  t1: integer;
  petsprite: tpetzpetsprite;
begin
  male := false;
  female := false;
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    for t1 := 0 to list.count - 1 do begin
      petsprite := TPetzPetSprite(TPetzClassInstance(list[t1]).instance);
      female := female or (petsprite.petinfo.isfemale { and (not petsprite.isdependent)});
      male := male or ((not petsprite.petinfo.isfemale) {and (not petsprite.isdependent)});
    end;

    if (not female) or (not male) then showmessage('You don''t have both a female and a male pet out!') else begin
      frmmate := tfrmmate.create(application);

      for t1 := 0 to list.count - 1 do
        if TPetzPetSprite(TPetzClassInstance(list[t1]).instance).petinfo.isfemale then
          frmmate.lstFemales.items.AddObject(TPetzPetSprite(TPetzClassInstance(list[t1]).instance).name, pointer(TPetzPetSprite(TPetzClassInstance(list[t1]).instance).id)) else
          frmmate.lstMales.items.AddObject(TPetzPetSprite(TPetzClassInstance(list[t1]).instance).name, pointer(TPetzPetSprite(TPetzClassInstance(list[t1]).instance).id));

      frmmate.show;
    end;
  finally
    list.free;
  end;
end;


procedure syncbatch();
begin

  // first conception and delivery has already happened before this call
  // mother is not out
  // offspring is at position 1

  while batchbreedcount > 0 do begin

  // get last offspring and remove from scene
   var lastoffspring := petzcase.getpetatbuttonindex(1);
   if lastoffspring <> nil then begin
      thiscall(lastoffspring, rimports.petsprite_setshouldibedeleted, [1]);
      thiscall(petzoberon, rimports.oberon_fixshouldibedeleted, []);
   end;
   petzcase.loadpetz(lastmotherid, 0);
   batchbreedcount := batchbreedcount - 1;

   // If we still have more offspring to make, re-mate
   if batchbreedcount > 0 then begin
     var female := petzcase.getpetatbuttonindex(0);
     matebystateconceive(female, lastfather);
     deliveroffspring(female);
   end
   else begin
      // no more batching to do
      lastmotherid := 0;
      lastfather := nil;
      petza.showheart  := oldshowheart;
      petza.disablebreeding := olddisablebreeding;
      // cannot unpatch here - old enough dialogue fires on next frame
//      unpatchbreedingcalls;
      waitingforpettocomeout := true;
   end;
  end;
end;


function TFrmMate.validate(out female, male: TPetzPetSprite): boolean;
  var list: tobjectlist;
  t1: integer;
begin
  if (lstFemales.itemindex < 0) or (lstmales.itemindex < 0) then begin
    showmessage('You must select both a male and a female');
    result := false;
    exit;
  end;
 //okay, make sure both pets are still here, then mate
  male := nil;
  female := nil;
  list := tobjectlist.create(false);
  petzclassesman.findclassinstances(cnpetsprite, list);
  for t1 := 0 to list.count - 1 do
    if TPetzPetSprite(TPetzClassInstance(list[t1]).instance).id = integer(lstfemales.items.objects[lstFemales.ItemIndex]) then
      female := TPetzClassInstance(list[t1]).instance else
      if TPetzPetSprite(TPetzClassInstance(list[t1]).instance).id = integer(lstmales.items.objects[lstmales.ItemIndex]) then
        male := TPetzClassInstance(list[t1]).instance;

  if (male = nil) or (female = nil) then begin
    nonmodalmessage('Sorry, one of the pets you have selected is no longer out. Please try again.');
    result := false;
    exit;
  end;

  if TPetzPetSprite(female).petinfo.pregnant then begin
    nonmodalmessage('The female pet is already pregnant.');
    result := false;
    exit;
  end;

  result := true;
  list.Free;
end;

procedure TfrmMate.btnMateClick(Sender: TObject);
  var male, female: TPetzPetSprite;
begin
    petza.ownername := OwnerNameEdit.Text;
    if validate(female, male) then begin
      var temp := petza.disablebreeding;
      petza.disablebreeding := false;
      if matebystateconceive(female, male) then
        nonmodalmessage('Success!','MateSuccess') else
        nonmodalmessage('Couldn''t mate. Perhaps one pet is too young, or another problem occured');
      petza.disablebreeding := temp;
    end;
end;

procedure TfrmMate.FormShow(Sender: TObject);
begin
  lstfemales.itemindex := 0;
  lstmales.itemindex := 0;
  batchcount.text := inttostr(petza.batchbreedcountdefault);
  btnBatch.Enabled := cpetzver = pvpetz4;
  OwnerNameEdit.Text := petza.ownername;
  chkFasterBatching.Checked := petza.usefasterbatchbreeding;
end;

procedure TfrmMate.btnBatchClick(Sender: TObject);
  var female, male: TPetzPetSprite;
begin
  petza.ownername := OwnerNameEdit.Text;
  petza.usefasterbatchbreeding := chkFasterBatching.Checked;
  // Validate batch count
  var bc: integer := 1;
  try
    bc := strtoint(batchCount.Text);
  except
    nonmodalmessage('Invalid batch count');
    exit;
  end;

  if validate(female, male) then begin
    // Make sure that the breeding heart won't be shown while batching
    oldshowheart := petza.showheart;
    petza.showheart := false;
    olddisablebreeding := petza.disablebreeding;
    petza.disablebreeding := false;
    patchbreedingcalls;

    // Mate n times. The actual looping has to take place in petza unit message handling for slow batching
    if matebystateconceive(female, male) then begin
       lastmotherid := female.id;
       deliveroffspring(female);
      // Set up values for async re-mate calls
      lastfather := male;
      batchbreedcount := bc;
      petza.batchbreedcountdefault := bc;
      if petza.usefasterbatchbreeding then begin
        syncbatch
      end
      else begin
        waitingforpettocomeout := true;
        modalmessage('Breeding...');
      end;
      close;
    end
    else begin
      unpatchbreedingcalls;
      nonmodalmessage('Couldn''t mate. Perhaps one pet is too young, or another problem occured');
    end;
  end;

end;

procedure TfrmMate.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,HELP_BreedingIntro);
end;

end.

