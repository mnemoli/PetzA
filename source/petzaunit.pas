{VERSION HISTORY

v1.0

a few releases..

v1.1 - Game speed control. Menu freeing. Petz 5 Pet names fixed. Removed dependancy check for mating.
Inserted custom draw for Petz 5: Name tags floating above Petz heads.
v1.2 - Petz 2 (demo exe) support. Unlim petz, mouse_over in expandable menu disabled for xp/2k compatibility
v1.3 - Family tree trimmer! Deletes root node
v1.3.1 - Fixed bugs in family tree trimmer by deleting father and mother trees and leaving root node alone
v1.3.2 - Added furking great error message when Petz MD5 hash is not as expected, and PetzA will never run.
 This inludes links to websites and my email address.
v1.4 - Exception handling all over the place. Revamped patchthiscall to allow calling the orig method
 and updated all my patches to use that (Now no addresses needed to hook most classes!). Added
 a "Bring breed back out" for adoption center, uses accelerator keys
v1.4.3 - Fixed bug where onclasschange could be called before the class instance was removed from
the instance list!
v1.4.4 - Fixed a bug where if you hooked an inherited class structure, only part of it would be
removed on free
v1.4.5 - Removed global exception trap in wndproc. Changed class dest/conc slightly (Still trying to fix
 stupid bug).
v1.5 - Reverted to old class hooking code. Added global brain sliders. Made normal brain sliders always-on-top
v2.0 - Uses conceive state so love heart shows up when breeding, awww :)
       Fixed UXTheme.dll bug when closing in non-themed XP by removing Portdisplay form (Graphics32)
       Awesome installer which can automatically update petz exes
       Help file (PENDING)
       Removed WSocket dependancy
v2.0.1 - Fixed Petz 5 bug where weather wasn't loaded properly
v2.0.2 - Fixed longstanding bug where a kernel32 crash was present on close for 95/98 by
         creating forms on demand. Perhaps freeing them while dieing isn't a good idea?
         Improved sex change message
         Game speed UI improvements: Tspinedit now
v2.0.3 - Fixes problems which stopped it working on Petz 2 and Babyz (Imported when didn't need to)
v2.1.0 - Profiles!
v2.1.1 - PetzA doesn't load if Screensaver running (Not supported win95/NT), fixes profile
         manager hanging on scrnsave.
         Profiles support Babyz "Adopted babyz" folder.
v2.1.2 - Changes the currentdir to something else before shuffling profiles
         Better screensaver detection
v2.2.0 - Better keyboard support (Default buttons, mainly)
         Error message in the case where profile can not be switched
         Fixed "Petz version incorrect" screen with new links
         Save camera pictures as GIF
         Brainslider ontop is a configurable option
         Settings screen: reset dialog boxes, brainslider ontop, instant birth
         If profiles are disabled, don't create petzaprofile.xml.
         Fixed bug: if you were dragging brain slider while it disappeared, it would crash
         Disableable message boxes
         Update family tree sex with profile sex
         MD5 for icon duplicate elimination
         No longer called "BabyzA" in babyz.. too confusing
         Can hide navigation bar in Babyz
v2.2.1 - Save settings on Ok, not on program close, to avoid crashes losing settings
         Sound fix in Babyz... Critical section leak in CDxSound::DoStream!
         Hide heart
v2.2.2 - Same sound fix, but for Petz 3 and Petz 3 German
         Petz camera can also take PNGs now
         Fixes screensaver detection
         Fixed familytree2.bmp which crashed TBitmap on win98. Suspect photoshop bmp format
v2.2.3 - Missing line of code in set number of children totally broke it. Fixed now
v2.2.4 - Stop users from changing age to <6, prevents crash. On Petz, not Babyz.
         Babyz diaper "Never gets dirty" option. Every time Babyz tries to set diaper status,
         it sets it to "Clean".
v2.2.5 - Remove resolution check (Petz 5 only) to run on smaller screens like laptops.
         Couple of small bugfixes for profile chooser

         PENDING::Fix diaper problems
         PENDING::Add an "All" menu to the pets submenu. Send all to door. Global brainsliders.

         PENDING::Happy pet certificate removal?
         PENDING::More keyboard shortcuts in menus
         PENDING::Unlimited camera photos
         PENDING::"Bring adopt pet back out" shouldn't work on non-adopt screen
v3.0.0 -

OUTSTANDING BUGS
 - More than 4 Babyz out doesn't work properly
 - Still problems with menu entries?
 - Sliders (apparently?) break after breeding sometimes
   }

unit petzaunit;
{$SCOPEDENUMS ON}

interface

uses sysutils, windows, classes, messages, contnrs, mymenuunit, dllpatchunit, bndpetz,
  petzclassesunit, registry, sliderbrainunit, forms, petzcommon1, CommDlg, graphics,
  aboutunit, dialogs, frmmateunit, trimfamilytreeunit, math, madexcept,
  profilemanagerunit, petzprofilesunit, actnlist, menus, madkernel,
  SCommon, SPatching, HtmlHelpViewer, adoptedpetloadinfounit, Generics.Collections, petzpaletteunit, paletteswapunit;

const petzakeyname = '\Software\Sherlock Software\PetzA';

type TEyeballData = record
  xballz: pointer;
  ballstate: pointer;
  posrotinfo: pointer;
  irisno: integer;
end;

type TDrawData = record
  miniport: TPetzDrawport;
  originalport: TPetzDrawport;
  bounds: TPetzRect;
  palette: byte;
end;

type
  TCameraFormat = (cfBMP, cfGIF, cfPNG); //Don't change order without updating settings combo
  TPetzaPlaymode = (pmStandard, pmServer, pmClient);
  TPetza = class(TObject)
  private
    fautopicsavepath: ShortString;
    fCameraFormat: TCameraFormat;
    foldwndproc: pointer;
    fgamespeed: integer;
    appliedspeed: boolean;
    fshowheart, fnavvisible, fshownavigation: boolean;
    fnodiaperchanges, fbrainslidersontop, pendingrefresh, freacttocamera: boolean;
    lastadoptpet, lastadoptpetslot: integer;
    fbatchbreedcountdefault: integer;
    fbreedingtimer: uint;
    fcustomuserprofile: ansistring;
    fusenewphotonameformat: boolean;
    facpetsadult: boolean;
    ftexturedirises: boolean;
    funlockpalette: boolean;

    procedure patchnodiaper;
    procedure patchreacttocamera(value: bool);
    procedure patchnavigation;
    procedure installclasscreationhooks;
    procedure installdispatchhook;
    procedure setcameraformat(value: TCameraFormat);
    procedure setshowheart(value: boolean);
    procedure setnodiaperchanges(value: Boolean);
    procedure setreacttocamera(value: Boolean);
    procedure setbrainslidersontop(value: Boolean);
    procedure refreshadptpetwrap(sender: tobject);
    function findpet(id: integer): tpetzpetsprite;
    procedure initbrainslidernames;
    procedure onclasschange(changetype: tchangetype; classname: tpetzclassname; instance: TPetzClassInstance);
    procedure setgamespeed(value: integer);
    procedure doenumtreebreeder(node: tpetzancestryinfo; list: tstringlist);
    procedure PatchResolutionCheck;
    procedure setbatchbreedcountdefault(const Value: integer);
    procedure setcustomuserprofile(const Value: ansistring);
    procedure patchcustomuserprofile;
    procedure setusenewphotonameformat(const Value: boolean);
    procedure setacpetsadult(const Value: boolean);
    procedure settexturedirises(const Value: boolean);

  public
    brains: TObjectList;
    actionlist: Tactionlist;
    processingmessage: boolean;
    instantbirth, shownametags: boolean;
    brainageindex: integer;
    brainbarnames: array of string;
    eyeballdata: TEyeballData;
    drawdata: TStack<TDrawData>;
    transparentphotos: boolean;
    neglectdisabled: boolean;
    maskdrawport: TPetzDrawport;
    lastmaskvalue: byte;
    ownername: ansistring;
    function getInstallPath: string;
    procedure loadsettings;
    procedure savesettings;
    procedure patchcamera;
    procedure petzaloaded;
    function enumtreebreeder(petid: smallint; list: tstringlist): boolean;
    function trimtree(petid: smallint; level: integer): boolean;
    function findslider(name: string): integer;
    constructor create;
    destructor Destroy; override;
    function defaultgamespeed: integer;
    property CameraFormat: TCameraFormat read fCameraFormat write setcameraformat;
    property shownavigation: boolean read fshownavigation write fshownavigation;
    property showheart: boolean read fshowheart write setshowheart;
    property brainslidersontop: boolean read fbrainslidersontop write setbrainslidersontop;
    property gamespeed: integer read fgamespeed write setgamespeed;
    property nodiaperchanges: boolean read fnodiaperchanges write setnodiaperchanges;
    property batchbreedcountdefault: integer read fbatchbreedcountdefault write setbatchbreedcountdefault;
    property reacttocamera: boolean read freacttocamera write setreacttocamera;
    property customuserprofile: ansistring read fcustomuserprofile write setcustomuserprofile;
    property usenewphotonameformat: boolean read fusenewphotonameformat write setusenewphotonameformat;
    property ACpetsadult: boolean read facpetsadult write setacpetsadult;
    property texturedirises: boolean read ftexturedirises write settexturedirises;
    property unlockpalette: boolean read funlockpalette write funlockpalette;
  end;

procedure petz2windowcreate(injectpoint: pointer; eax, ecx, edx, esi: longword);
procedure petzwindowcreate(return, instance: pointer); stdcall;
var petza: tpetza;
  hpetzwindowcreate, hloadpetz, hpushscript, htransneu, hsettargetlocation,
  hresetstack, reacttocamerapatch, deliveroffspringpatch,
  draweyeballpatch, inittoypatch, drawphotopatch, drawspritespatch, initstagepatch,
  loadlnzpatch, desxballzpatch, drawfilmstrippatch, drawstackedpatch: TPatchThiscall;
var lnzpalettecache: TDictionary<pointer, byte>;
var  logging: Boolean;
procedure dolog(const message: string);

type TAdjective = (
  AlpoType, Chrz, Toyz, Prop, Part, ThreeD, Color, Flavor, Size, Mass, Friction,
  Tasty, Edible, Fatty, Liquid, Drug, Medicine, Aphrodisiac, Discipline, Chew,
  Tug, Density, Thickness, Soft, Fuzzy, Round, Bounce, Swatty, Pretty, Vain,
  Paint, Groom, BadNoisy, NiceNoisy, Flies, Rideable, Mouselike
  );

type TPetzColor = (
  White, Black, Red, Green, Yellow, Blue, Purple, Pink, Orange, Brown, Gray, Clear
);

type TFlavor = (
  Chicken, Beef, Fish, Turkey, Milk, Sweet, Catnip, Cheese,
  Plastic, Rubber, Soft, Bone, Wood, Metal, Water, Rock, Unknown1,
  HairballFleaspray, Unknown2, Unknown3, Unknown4, Unknown5, Unknown6, Chemicals,
  Garbage, Unknown7, Fleabottle, Plants, HealthyTreat
);

implementation

uses setchildrenunit, mymessageunit, debugunit, gamespeedunit, typinfo, frmsettingsunit, userprofileunit,
  nakedbitmaploader, Vcl.Imaging.pngimage, Vcl.Imaging.gifimg, helpunit, controls, System.StrUtils;

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}


procedure dolog(const message: string);
const eol: Word = $0A0D;
var stream: tfilestream;
begin
  try
    if FileExists(extractfilepath(application.ExeName) + 'PetzALog.txt') then
      stream := TFileStream.Create(extractfilepath(application.ExeName) + 'PetzALog.txt', fmOpenReadWrite or fmShareDenyNone) else
      stream := TFileStream.Create(extractfilepath(application.ExeName) + 'PetzALog.txt', fmCreate or fmShareDenyNone);
    try
      stream.seek(0, soFromEnd);
      if length(message) > 0 then
        stream.write(message[1], Length(message));
      stream.write(eol, sizeof(eol));
    finally
      stream.free;
    end;
  except
  end;
end;

function tpetza.findpet(id: integer): tpetzpetsprite;
var list: tobjectlist;
  pet: tpetzpetsprite;
  t1: integer;
begin
  result := nil;
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    for t1 := 0 to list.count - 1 do begin
      pet := TPetzPetSprite(TPetzClassInstance(list[t1]).instance);
      if pet.id = id then begin
        result := pet;
        exit;
      end;
    end;
  finally
    list.free;
  end;
end;

procedure tpetza.doenumtreebreeder(node: tpetzancestryinfo; list: tstringlist);
begin
  list.Add(node.adopter);
  if node.fathertree <> nil then
    doenumtreebreeder(node.fathertree, list);
  if node.mothertree <> nil then
    doenumtreebreeder(node.mothertree, list);
end;

function tpetza.enumtreebreeder(petid: smallint; list: tstringlist): boolean;
var list1: tobjectlist;
  t1: integer;
  pet: tpetzpetsprite;
begin
  result := false;
  list1 := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list1);
    for t1 := 0 to list1.count - 1 do begin
      pet := TPetzPetSprite(TPetzClassInstance(list1[t1]).instance);
      if pet.id = petid then begin
        doenumtreebreeder(pet.petinfo.ancestryinfo, list);
        result := true;
        exit;
      end;
    end;
  finally
    list1.free;
  end;
end;

procedure recursetrimtree(node: TPetzAncestryInfo; level: integer; var index: integer);
var repnode: TPetzAncestryInfo;
begin
  if level = 0 then begin
    inc(index);
    if index mod 4 = 0 then begin
      repnode := TPetzAncestryInfo.create;
      repnode.adopter := 'Trimmed by PetzA';
      repnode.breed := '!';
      repnode.name := '!';
      repnode.adoptiondate := now;
      node.mothertree := repnode;

      repnode := TPetzAncestryInfo.create;
      repnode.adopter := 'Trimmed by PetzA';
      repnode.breed := '!';
      repnode.name := '!';
      repnode.adoptiondate := now;
      node.fathertree := repnode;
    end else begin
      node.mothertree := nil;
      node.fathertree := nil;
    end;

  end else begin
    dec(level);
    if node.mothertree <> nil then
      recursetrimtree(node.mothertree, level, index);
    if node.fathertree <> nil then
      recursetrimtree(node.fathertree, level, index);
  end;
end;

function tpetza.trimtree(petid: smallint; level: integer): boolean;
var list: tobjectlist;
  t1: integer;
  pet: tpetzpetsprite;
  index: integer;
begin
  result := false;
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    for t1 := 0 to list.count - 1 do begin
      pet := TPetzPetSprite(TPetzClassInstance(list[t1]).instance);
      if pet.id = petid then begin
        index := 0;
        recursetrimtree(pet.petinfo.ancestryinfo, level, index);
        result := true;
        break;
      end;
    end;
  finally
    list.free;
  end;
end;

procedure TPetza.setcustomuserprofile(const Value: ansistring);
begin
  fcustomuserprofile := Value;
end;

function tpetza.defaultgamespeed: integer;
begin
  case cpetzver of
    pvbabyz, pvpetz3, pvpetz3german, pvpetz2: result := 30;
    pvpetz4, pvpetz5: result := 50;
  else result := 40;
  end;
end;

{Patch the block of code at 'address' which has size 'totalsize' with a new
 block of code 'newdata' of length 'datasize'}

procedure patchcodebuf(address: pointer; datasize, totalsize: integer; const newdata);
var oldprotect: cardinal;
begin
  if datasize > totalsize then begin
    showmessage('Patchcode: Data is greater than size!');
    exit;
  end;
  VirtualProtect(address, totalsize, PAGE_EXECUTE_READWRITE, oldprotect);
  move(newdata, address^, datasize);
  if datasize < totalsize then
    FillChar(ptr(cardinal(address) + cardinal(datasize))^, totalsize - datasize, byte(nop));
end;

procedure tpetza.setnodiaperchanges(value: Boolean);
begin
  if fnodiaperchanges <> value then begin

    if value and (cpetzver = pvBabyz) then
      patchnodiaper;

    fnodiaperchanges := value;
  end;
end;

procedure tpetza.setreacttocamera(value: Boolean);
begin
  if freacttocamera <> value then begin

    if cpetzver = pvpetz4 then
      patchreacttocamera(value);

    freacttocamera := value;
  end;
end;

procedure tpetza.setshowheart(value: boolean);
var data: array[0..2] of byte;
begin
  if fshowheart <> value then begin
    fshowheart := value;

    case cpetzver of
      pvpetz5: begin
          if fshowheart then begin
            data[0] := $83;
            data[1] := $EC;
            data[2] := $10; //sub esp, 10h
          end else begin
            data[0] := $C2;
            data[1] := $10;
            data[2] := $00; //ret 10h
          end;
          patchcodebuf(rimports.sprite_hart_start, 3, 3, data[0]);
        end;
      pvpetz4: begin
          if fshowheart then begin
            data[0] := $83;
            data[1] := $EC;
            data[2] := $20; //sub esp, 20h
          end else begin
            data[0] := $C2;
            data[1] := $10;
            data[2] := $00; //ret 10h
          end;
          patchcodebuf(rimports.sprite_hart_start, 3, 3, data[0]);
        end;
      pvpetz3, pvpetz3german: begin
          if fshowheart then begin
            data[0] := $83;
            data[1] := $EC;
            data[2] := $10; //sub esp, 10h
          end else begin
            data[0] := $C2;
            data[1] := $10;
            data[2] := $00; //ret 10h
          end;
          patchcodebuf(rimports.sprite_hart_start, 3, 3, data[0]);
        end;
    end;
  end;
end;


procedure TPetza.setusenewphotonameformat(const Value: boolean);
begin
  fusenewphotonameformat := Value;
  if Value = false then begin
    // reset filepath names
    setcameraformat(fcameraformat);
  end;
end;

procedure TPetza.setacpetsadult(const Value: boolean);
begin
  facpetsadult := Value;
end;

procedure TPetza.setbatchbreedcountdefault(const Value: integer);
begin
  fbatchbreedcountdefault := value;
end;

procedure tpetza.setbrainslidersontop(value: Boolean);
var t1: integer;
begin
  if fbrainslidersontop <> value then begin
    fbrainslidersontop := value;
    for t1 := 0 to brains.count - 1 do
      if value then
        tfrmsliderbrain(brains[t1]).FormStyle := fsStayOnTop else
        tfrmsliderbrain(brains[t1]).FormStyle := fsNormal;
  end;
end;

procedure tpetza.loadsettings;
var reg: tregistry;
  pre: string;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(petzakeyname, false) then begin
      if reg.ValueExists('InstantBirth') then
        instantbirth := reg.ReadBool('InstantBirth');
      if reg.ValueExists('ShowNameTags') then
        shownametags := reg.ReadBool('ShowNameTags');
      if reg.ValueExists('BrainSlidersOnTop') then
        brainslidersontop := reg.ReadBool('BrainSlidersOnTop');
      if reg.ValueExists('CameraFormat') then
        cameraformat := TCameraFormat(reg.ReadInteger('CameraFormat'));
      if reg.ValueExists('ShowNavigation') then
        shownavigation := reg.ReadBool('ShowNavigation');
      if reg.ValueExists('ShowHeart') then
        showheart := reg.readbool('ShowHeart');
      if reg.ValueExists('NoDiaperChanges') then
        nodiaperchanges := reg.ReadBool('NoDiaperChanges');
      if reg.ValueExists('BatchBreedCountDefault') then
        batchbreedcountdefault := reg.ReadInteger('BatchBreedCountDefault');
      if reg.ValueExists('ReactToCamera') then
        reacttocamera := reg.ReadBool('ReactToCamera');
      if reg.ValueExists('CustomUserProfile') then
        customuserprofile := reg.ReadString('CustomUserProfile');
      if reg.ValueExists('UseNewPhotoNameFormat') then
        usenewphotonameformat := reg.ReadBool('UseNewPhotoNameFormat');
      if reg.ValueExists('ACPetsAdult') then
        acpetsadult := reg.ReadBool('ACPetsAdult');
      if reg.ValueExists('TransparentPhotos') then
        transparentphotos := reg.ReadBool('TransparentPhotos');
      if reg.ValueExists('DisableNeglect') then
        neglectdisabled := reg.ReadBool('DisableNeglect');
      if reg.ValueExists('TexturedIrises') then
        texturedirises := reg.ReadBool('TexturedIrises');
      if reg.ValueExists('OwnerName') then
        ownername := reg.ReadString('OwnerName');
      if reg.ValueExists('UnlockPalette') then
        unlockpalette := reg.ReadBool('UnlockPalette');


      pre := uppercase(GetEnumName(TypeInfo(tpetzvername), integer(cpetzver)));

      if reg.valueexists(pre + '-GameSpeed') then
        fgamespeed := reg.readinteger(pre + '-GameSpeed');
      if reg.valueexists(pre + '-UseProfiles') then
        profilemanager.useprofiles := reg.readbool(pre + '-UseProfiles');
    end;
  finally
    reg.free;
  end;
end;

procedure tpetza.savesettings;
var
  reg: tregistry;
  pre: string;
begin
  reg := tregistry.create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.openkey(petzakeyname, true) then begin
      reg.WriteBool('InstantBirth', instantbirth);
      reg.writebool('ShowNameTags', shownametags);
      reg.WriteBool('BrainSlidersOnTop', brainslidersontop);
      reg.WriteInteger('CameraFormat', integer(cameraformat));
      reg.WriteBool('ShowNavigation', shownavigation);
      reg.writebool('ShowHeart', showheart);
      reg.WriteBool('NoDiaperChanges', nodiaperchanges);
      reg.WriteBool('ReactToCamera', reacttocamera);
      pre := uppercase(GetEnumName(TypeInfo(tpetzvername), integer(cpetzver)));
      reg.writeinteger(pre + '-GameSpeed', fgamespeed);
      reg.writebool(pre + '-UseProfiles', profilemanager.useprofiles);
      reg.WriteInteger('BatchBreedCountDefault', batchbreedcountdefault);
      reg.WriteString('CustomUserProfile', customuserprofile);
      reg.WriteBool('UseNewPhotoNameFormat', usenewphotonameformat);
      reg.WriteBool('ACPetsAdult', acpetsadult);
      reg.WriteBool('TransparentPhotos', transparentphotos);
      reg.WriteBool('DisableNeglect', neglectdisabled);
      reg.WriteBool('TexturedIrises', texturedirises);
      reg.WriteString('OwnerName', ownername);
      reg.WriteBool('UnlockPalette', unlockpalette);
    end;
  finally
    reg.free;
  end;
end;

procedure tpetza.initbrainslidernames;
begin
  if cpetzver = pvbabyz then begin
    setlength(brainbarnames, 9);
    brainbarnames[0] := 'Energy';
    brainbarnames[1] := 'Fullness';
    brainbarnames[2] := 'Fatness';
    brainbarnames[3] := 'Sickness';
    brainbarnames[4] := 'Medicined';
    brainbarnames[5] := 'Fever';
    brainbarnames[6] := 'C. Pox';
    brainbarnames[7] := 'Neglect';
    brainbarnames[8] := 'Age';
    brainageindex := 8;
  end else
    if cpetzver = pvpetz2 then begin
      setlength(brainbarnames, 17);
      brainbarnames[0] := 'Energy';
      brainbarnames[1] := 'Fullness';
      brainbarnames[2] := 'Fatness';
      brainbarnames[3] := 'Sickness';
      brainbarnames[4] := 'Catnipped';
      brainbarnames[5] := 'Fleas';
      brainbarnames[6] := 'Slider 7';
      brainbarnames[7] := 'Slider 8';
      brainbarnames[8] := 'Slider 9';
      brainbarnames[9] := 'Slider 10';
      brainbarnames[10] := 'Slider 11';
      brainbarnames[11] := 'Slider 12';
      brainbarnames[12] := 'Slider 13';
      brainbarnames[13] := 'Slider 14';
      brainbarnames[14] := 'Slider 15';
      brainbarnames[15] := 'Neglect';
      brainbarnames[16] := 'Age';
      brainageindex := 16;
    end else begin
      setlength(brainbarnames, 9);
      brainbarnames[0] := 'Energy';
      brainbarnames[1] := 'Fullness';
      brainbarnames[2] := 'Fatness';
      brainbarnames[3] := 'Sickness';
      brainbarnames[4] := 'Catnipped';
      brainbarnames[5] := 'Fleas';
      brainbarnames[6] := 'Horniness';
      brainbarnames[7] := 'Neglect';
      brainbarnames[8] := 'Age';
      brainageindex := 8;
    end;
end;

function tpetza.findslider(name: string): integer;
var t1: integer;
begin
  result := 0;
  for t1 := 0 to high(brainbarnames) do
    if ansicomparetext(brainbarnames[t1], name) = 0 then begin
      result := t1;
      exit;
    end;
end;

function booltostr(b: boolean): string;
begin
  if b then result := 'True' else result := 'False';
end;

procedure myscriptsprite_settargetloc(return, instance: pointer; p: ppoint); stdcall;
var list: tobjectlist;
begin
  if not TPetzAlposprite(instance).isthisapet then begin
    showmessage('!');
  end;

  hsettargetlocation.restore;
  list := tobjectlist.create(false);
  try
    //frmabout.memo1.lines.add('X: ' + inttostr(p^.x) + ', Y:' + inttostr(p^.y));

    petzclassesman.findclassinstances(cnpetsprite, list);
    if (list.count > 1) then begin
      if TPetzClassInstance(list[0]).instance = instance then begin
        Thiscall(instance, rimports.scriptsprite_settargetlocation, [cardinal(p)]);
        Thiscall(tpetzclassinstance(list[1]).instance, rimports.scriptsprite_settargetlocation, [cardinal(p)]);
      end;
    end else begin
      Thiscall(instance, rimports.scriptsprite_settargetlocation, [cardinal(p)]);
    end;
  finally
    list.free;
    hsettargetlocation.patch;
  end;
end;

procedure myscriptsprite_resetstack(return, instance: pointer; resettype: integer; i: integer); stdcall;
var list: tobjectlist;
begin
  if not TPetzAlposprite(instance).isthisapet then begin
    showmessage('!');
  end;
  list := tobjectlist.create(false);
  hresetstack.restore;
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    if (list.count > 1) then begin
      if TPetzClassInstance(list[0]).instance = instance then begin
        //frmabout.memo1.lines.add('stackreset');

        Thiscall(instance, rimports.scriptsprite_resetstack,
          [cardinal(resettype), cardinal(i)]);
        Thiscall(tpetzclassinstance(list[1]).instance, rimports.scriptsprite_resetstack,
          [cardinal(resettype), cardinal(i)]);

      end;
    end else begin
      Thiscall(instance, rimports.scriptsprite_resetstack,
        [cardinal(resettype), cardinal(i)]);
    end;
  finally
    list.free;
    hresetstack.patch;
  end;
end;

function myscriptsprite_transneu(return, instance: pointer; i: integer): bool; stdcall;
var list: tobjectlist;
begin
  result := false;
  htransneu.restore;
  list := tobjectlist.create(false);
  try

    petzclassesman.findclassinstances(cnpetsprite, list);
    if (list.count > 1) then begin
      if TPetzClassInstance(list[0]).instance = instance then begin // if this came from 1st dog
        result := bool(Thiscall(instance, rimports.scriptsprite_transneu,
          [cardinal(i)]));

        result := bool(Thiscall(tpetzclassinstance(list[1]).instance, rimports.scriptsprite_transneu,
          [cardinal(i)]));
      end;
    end else begin //just one dog out
      result := bool(Thiscall(instance, rimports.scriptsprite_transneu,
        [cardinal(i)]));
    end;
  finally
    list.free;
    htransneu.patch;
  end;
end;

function mycheckforbabyzcd(return, instance: pointer): bytebool; stdcall;
begin
  result := true;
end;

function petdatetodelphidate(p: longword): tdatetime;
begin
  result := encodedate(1970, 1, 1) + p / SecsPerDay; {1970 is Unix epoch}
end;

function myisoffspringdue(return, instance: pointer): bool; stdcall;
var pet: TPetzPetSprite;
  days: integer;
  t: single;
var
  Saved8087CW: Word;
begin
  Saved8087CW := Default8087CW;
  try
    Set8087CW($1332); {normal FPU}

    pet := TPetzPetSprite(instance);
    try
      t := now - petdatetodelphidate(pet.petinfo.conceivetime);
      days := trunc(t);
      result := ((days >= 0) and petza.instantbirth) or (days >= 2);
    except
      result := false;
    end;
  finally
    Set8087CW(Saved8087CW);
  end;
{eax=trunc(difftime(curtime,pregtime)*1/(24*60*60))
.text:0057EB5F                 cmp     eax, 2
.text:0057EB62                 setnl   dl}
end;

function getthumbnail(return, instance: pointer): hbitmap; stdcall;
begin
  result := 0;
end;

function win2kornewer: boolean;
begin
  result := (Win32MajorVersion >= 5);
end;

function myspriteadpt_loadpetz(return, instance: pointer; petindex: integer; b1, b2: bool): bool; stdcall;
  var list: TObjectList;
  pet: TPetzPetSprite;
begin
  petza.lastadoptpet := petindex;
  petza.lastadoptpetslot := TPetzSpriteAdpt(instance).petslot;
  result := bool(hloadpetz.callorigproc(instance, [petindex, cardinal(b1), cardinal(b2)]));
  if petza.ACpetsadult then begin
    list := TObjectList.Create(false);
    petzclassesman.findclassinstances(cnpetsprite, list);
    pet := tpetzpetsprite(TPetzClassInstance(list[list.count - 1]).instance);
    pet.setbiorhythm(petza.findslider('Age'), 100);
    list.Free;
  end;
end;

procedure exceptionhandler(const exceptIntf: IMEException;
  var handled: boolean);
var cn: TPetzClassName;
begin
  try
    if assigned(petza) and Assigned(petzclassesman) then begin
      exceptIntf.BugReport := exceptIntf.BugReport + #13#10#13#10 + 'Instance count: ' + inttostr(petzclassesman.count);
      for cn := low(cn) to high(cn) do
        exceptIntf.BugReport := exceptIntf.BugReport + #13#10 + GetEnumName(TypeInfo(tpetzclassname), ord(cn)) + ': ' + inttostr(petzclassesman.countinstances(cn));
    end;
    handled := false;
  except
  end;
end;

function locatehelpfile: string;
var reg: TRegistry;
begin
  result := '';
  reg := TRegistry.Create;
  try
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey(petzakeyname, false) and reg.ValueExists('Helpfile') then
        result := reg.ReadString('Helpfile');
  finally
    reg.free;
  end;
end;

//called when PetzA is totally loaded

procedure TPetzA.petzaloaded;
begin
  profilemanager.petzisstarting;
end;

procedure refreshadptpet(sender: tmymenuitem);
var pet: TPetzPetSprite;
  adpt: TPetzSpriteAdpt;
  list: tobjectlist;
begin
  if not (cpetzver in verAdoptcenter) then exit;

//  if petzclassesman.countinstances(cnSpriteAdpt) = 0 then exit; //not in the adoption centre!

  if petza.lastadoptpet <> -1 then begin
    list := tobjectlist.create(false);
    try
      petzclassesman.findclassinstances(cnpetsprite, list);
      if list.count = 0 then exit;
      pet := tpetzpetsprite(TPetzClassInstance(list[list.count - 1]).instance);
      pet.enterpetdoor;
      adpt := TPetzSpriteAdpt(petzclassesman.findclassinstance(cnSpriteAdpt).instance);
      if adpt <> nil then begin
        adpt.petslot := petza.lastadoptpetslot; //load to same slot
        Thiscall(adpt, rimports.spriteadpt_loadpetz, [petza.lastadoptpet, 1, 1]);
      end;
    finally
      list.free;
    end;
  end;
end;

procedure sendalltopetdoor(sender: tmymenuitem);
  var list: tobjectlist;
  pet: TPetzPetSprite;
  t1: integer;
begin
  list := tobjectlist.create(false);
  petzclassesman.findclassinstances(cnpetsprite, list);
  for t1 := 0 to list.count - 1 do begin
    pet := TPetzPetSprite(TPetzClassInstance(list[t1]).instance);
    pet.enterpetdoor;
  end;
end;

procedure tpetza.refreshadptpetwrap(sender: tobject);
begin
  refreshadptpet(nil);
end;

function mydrawiris(circlerenderblock: pointer): bool; stdcall;
var thisptr: pointer;
begin
  asm
    mov thisptr, ecx;
  end;
  thiscall(petza.eyeballdata.xballz, ptr($004501d0), [cardinal(circlerenderblock),
  cardinal(petza.eyeballdata.ballstate), cardinal(petza.eyeballdata.posrotinfo),
  petza.eyeballdata.irisno]);
  var t := thiscall(thisptr, ptr($0045e750), [cardinal(circlerenderblock)]);
  result := boolean(t);
end;

procedure mydraweyeball(return, instance, drawportin, ballframeex, ballstatein: pointer;
ballid: integer; outerrenderblock: pointer;
ballsize: integer; center: pointer); stdcall; begin
  var irisnox: integer;
  var lnz := ppointer(classprop(instance, $184))^;
  if(ballid = pinteger(classprop(lnz, $8a0))^) then
    irisnox := pinteger(classprop(lnz, $8a8))^
  else
    irisnox := pinteger(classprop(lnz, $8ac))^;
  with petza.eyeballdata do begin
    xballz := instance;
    ballstate := ballstatein;
    irisno := irisnox;
    posrotinfo := classprop(ballframeex, $544);
  end;
  draweyeballpatch.callorigproc(instance, [cardinal(drawportin), cardinal(ballframeex),
  cardinal(ballstatein), ballid, cardinal(outerrenderblock), ballsize, cardinal(center)]);
end;

procedure TPetza.settexturedirises(const Value: boolean);
begin
  if value <> ftexturedirises then begin
    ftexturedirises := value;
    case cpetzver of
      pvpetz4: begin  
        if value then begin
          retargetcall(ptr($451fb4), @mydrawiris);
          if assigned(draweyeballpatch) then
            draweyeballpatch.patch
          else
            draweyeballpatch := patchthiscall(rimports.xballz_draweyeball, @mydraweyeball);
        end else begin
          if (assigned(draweyeballpatch)) then begin
            retargetcall(ptr($451fb4), ptr($45e750));
            draweyeballpatch.restore;
          end;
        end;
      end;
    end;
  end;
end;

function getattrvalfromtext(attr: integer; text: string): integer;
  var val: integer;
begin
  val := -1;
  try
    val := strtoint(text);
  except
    if attr = Ord(TAdjective.Color) then
      val := GetEnumValue(TypeInfo(TPetzColor), text)
    else if attr = Ord(TAdjective.Flavor) then
      val := GetEnumValue(TypeInfo(TFlavor), text);
  end;
  result := val;
end;

procedure myinittoy(return, instance: pointer; b: boolean; host: pointer); stdcall;
  begin
  inittoypatch.callorigproc(instance, [cardinal(b), cardinal(host)]);
  if b then begin

  var alpo := TPetzAlpoSprite(instance);
  var xlib := ppointer(classprop(alpo, $4))^;
  var handle := hinst(ppointer(thiscall(xlib, rimports.xlib_getinstancelist, []))^);
  var idx := alpo.loadinfo.spriteindex;
  var resource := FindResource(handle, pwidechar('ADJECTIVES' + inttostr(idx)), 'TXT');
  if resource <> 0 then begin
    var loader := LoadResource(handle, resource);
    if loader = 0 then
      exit;
    var lock := LockResource(loader);
    if lock = nil then
      exit;

    var sz := SizeOfResource(handle, resource);

    var attributesstr: ansistring;
    SetString(attributesstr, pansichar(lock), sz);
    var attributestuplelist := string(attributesstr).Split([''#13#10''], TStringSplitOptions.ExcludeEmpty);
    for var attributetuplestr in attributestuplelist do begin      
      var tuple := attributetuplestr.Split([' ', ''#9''], TStringSplitOptions.ExcludeEmpty);
      if length(tuple) > 1 then begin
         var attr, val: integer;
         val := -1;
         attr := -1;
        try
          attr := strtoint(tuple[0]);
        except
          attr := GetEnumValue(TypeInfo(TAdjective), tuple[0]);
        end;
        if attr = -1 then continue;

        if length(tuple) = 2 then begin
          val := getattrvalfromtext(attr, tuple[1]);
        end else if length(tuple) = 3 then begin
          var min := getattrvalfromtext(attr, tuple[1]);
          var max := getattrvalfromtext(attr, tuple[2]);
          if (min <> -1) and (max <> -1) then
            val := RandomRange(min, max + 1);
        end else begin
          var randtext := RandomRange(1, length(tuple));
          val := getattrvalfromtext(attr, tuple[randtext]);
        end;

        if (attr <> -1) and (val <> -1) then
          alpo.setadjvalue(attr, val);
      end;
    end;
  end;
  end;
end;

function mywritedib(filename: PAnsiChar; dib: HGlobal): longword; cdecl;
var stream: TMemoryStream;
  p: pointer;
  bitmap: TNakedBitmapLoader;
  gif: tgifimage;
  png: TPNGImage;
  Ext: TGIFGraphicControlExtension;
  fileext: string;
begin
  try
    stream := tmemorystream.create;
    try
      p := GlobalLock(dib);
      try
        stream.Write(p^, GlobalSize(dib));
        stream.position := 0;
        bitmap := TNakedBitmapLoader.create;
        fileext := uppercase(ExtractFileExt(filename));
        try
          bitmap.LoadNakedFromStream(stream, petza.transparentphotos and (fileext = '.PNG'));

          if fileext = '.GIF' then begin
            gif := TGIFImage.Create;
            try
              gif.DitherMode := dmFloydSteinberg;
              gif.ColorReduction := rmQuantize;
              gif.Assign(bitmap);
              if petza.transparentphotos and not petzshlglobals.photohasbg then begin
                // Create an extension to set the transparency flag
                Ext := TGIFGraphicControlExtension.Create(gif.Images[0]);
                Ext.Transparent := True;
                Ext.TransparentColor := TColor($fefefe);
              end;
              gif.SaveToFile(filename);
            finally
              gif.free;
            end;
          end else
            if fileext = '.PNG' then begin
              gif := TGIFImage.Create;
              try
                gif.DitherMode := dmFloydSteinberg;
                gif.ColorReduction := rmQuantize;
                gif.Assign(bitmap);
                bitmap.assign(gif);
                png := TPNGImage.Create;
                try
                  png.CompressionLevel := 9;
                  png.Assign(bitmap);
                  if petza.transparentphotos and not petzshlglobals.photohasbg then
                    png.TransparentColor := TColor($fefefe);
                  png.SaveToFile(filename);
                finally
                  png.free;
                end;
              finally
                gif.free;
              end;
            end else
              bitmap.savetofile(filename);
        finally
          bitmap.free;
        end;
      finally
        GlobalUnlock(dib);
      end;
    finally
      stream.free;
    end;
    result := 1; //success
  except
    result := 0; //fail
  end;
end;

function setsavefilename(): bool;
  var pet: TPetzPetSprite;
  var names: ansistring;
  var timestamp: string;
  var petlist: TObjectList;
  var namelist: TStringList;
begin
  if petza.fusenewphotonameformat then begin
    if petzdlgglobals.phototype = 2 then begin
      petlist := tobjectlist.create(false);
      namelist := tstringlist.create(TDuplicates.dupIgnore, true, false);
      petzclassesman.findclassinstances(cnpetsprite, petlist);
      for var t1 := 0 to petlist.count - 1 do begin
        pet := TPetzPetSprite(TPetzClassInstance(petlist[t1]).instance);
        namelist.add(pet.name);
      end;
      for var t1 := 0 to namelist.Count - 1 do begin
        if length(names) > 0 then
          names := names + '_' + namelist[t1]
        else
          names := namelist[t1];
      end;
    end else begin
      pet := petzshlglobals.photopet;
      names := pet.name;
    end;
    DateTimeToString(timestamp, 'yymmddhhnnss', Now());
    var ext := RightStr(petza.fautopicsavepath, 4);
    petza.fautopicsavepath := '%s\PetzPix\' + names + '-' + timestamp + '-%d.' + ext;
  end;
  rimports.xdrawport_closescreendrawport;
end;

function stripfileext(const s: ansistring): ansistring;
begin
  result := copy(s, 1, length(s) - length(ExtractFileExt(s)));
end;

function mydrawphotop4(return: pointer; stage: TPetzStage; pt1, pt2, hasbg: pointer): cardinal; stdcall;
var bits: pbyte;
var bitsnum: cardinal;
begin
  // would like to call orig and exit earlier if we have background, but
  // delphi is doing something weird and always showing the hasbg bool as true
  bits := stage.activedrawport.bits;
  bitsnum := stage.activedrawport.numbits;
  fillchar(bits^, bitsnum, 200);
  result := drawphotopatch.callorigproc(stage, [cardinal(pt1), cardinal(pt2), cardinal(hasbg)]);
end;

function mydrawphotop3(return: pointer; stage: TPetzStage; pt1, pt2: pointer): cardinal; stdcall;
var port: pointer;
var bits: pbyte;
var bitsnum: cardinal;
begin
  bits := stage.activedrawport.bits;
  bitsnum := stage.activedrawport.numbits;
  fillchar(bits^, bitsnum, 200);
  result := drawphotopatch.callorigproc(stage, [cardinal(pt1), cardinal(pt2)]);
end;

function mypicgetsavefilename(var opfn: topenfilenamea): bool; stdcall;
var s: string;
begin
  case petza.CameraFormat of
    TCameraFormat.cfGIF: begin
        opfn.lpstrDefExt := 'gif';
        opfn.nFilterIndex := 1;
      end;
    TCameraFormat.cfBMP: begin
        opfn.lpstrDefExt := 'bmp';
        opfn.nFilterIndex := 2;
      end;
    TCameraFormat.cfPNG: begin
        opfn.lpstrDefExt := 'png';
        opfn.nFilterIndex := 3;
      end;
  end;

  s := stripfileext(opfn.lpstrFile);
  StrPCopy(opfn.lpstrFile, s); //has to go into the buffer that the caller supplied

  opfn.lpstrFilter := 'GIF Image'#0'*.gif'#0'Windows Bitmap'#0'*.bmp'#0'PNG Image'#0'*.png'#0; // ie. terminated by 2 nulls}
  result := GetSaveFileNamea(opfn);
end;

procedure TPetzA.setcameraformat(value: TCameraFormat);
begin
  fCameraFormat := value;
  if cpetzver = pvbabyz then begin

    case fCameraFormat of //update the path for the autosave location for pics
      TCameraFormat.cfBMP: fautopicsavepath := '%s\BabyPix\babyz%d.bmp';
      TCameraFormat.cfGIF: fautopicsavepath := '%s\BabyPix\babyz%d.gif';
      TCameraFormat.cfPNG: fautopicsavepath := '%s\BabyPix\babyz%d.png';
    end;
  end else begin

    case fCameraFormat of //update the path for the autosave location for pics
      TCameraFormat.cfBMP: fautopicsavepath := '%s\PetzPix\petz%d.bmp';
      TCameraFormat.cfGIF: fautopicsavepath := '%s\PetzPix\petz%d.gif';
      TCameraFormat.cfPNG: fautopicsavepath := '%s\PetzPix\petz%d.png';
    end;
  end;
  fautopicsavepath := fautopicsavepath + #0;
end;

procedure TPetza.setgamespeed(value: integer);
begin
  case cpetzver of
    pvpetz3, pvpetz3german, pvpetz4, pvpetz5, pvbabyz, pvpetz2: begin
        if not KillTimer(petzshlglobals.mainwindow, 1003) then showmessage('Uh oh');
        settimer(petzshlglobals.mainwindow, 1003, value, nil);
       fgamespeed := value;
      end;
  else showmessage('TPetzA:SetGameSpeed - Unsupported!');
  end;
end;

{Remove the check for minimum width and height screen resolutions. Widescreen
laptops can't play Petz otherwise!}

procedure TPetzA.PatchResolutionCheck;
var p:pointer;
oldprotect:cardinal;
begin
  case cpetzver of
    pvPetz5: begin
        p:=pointer($43E29B);
        VirtualProtect(p, 6, PAGE_EXECUTE_READWRITE, oldprotect);
        FillChar(p^,6,nop);

        p:=pointer($43E2B1);
        VirtualProtect(p, 6, PAGE_EXECUTE_READWRITE, oldprotect);
        FillChar(p^,6,nop);
      end;
  end;

end;

//Add gif support to camera if possible

procedure tpetza.patchcamera;
var p: Pointer;
  oldprotect: cardinal;
begin
  case cpetzver of
    pvpetz5: begin //patch camera
        retargetcall(ptr($417D39), @mypicgetsavefilename);
        retargetcall(ptr($4179A1), @mywritedib);

        p := ptr($418FEE); //Place to put offset for default save path for autosave
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($419042); //And again. I assume that one is "Test if exists", one is "Save now"
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($417BF4);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($417C42);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];

        petzdlgglobals.maxautosavephotos := 30000;
      end;
    pvPetz4: begin
        drawphotopatch := patchthiscall(ptr($48a3b0), @mydrawphotop4);
        var b: byte := byte(nop);
        patchcodebuf(ptr($48a514), 1, 11, b);
        retargetcall(ptr($418F45), @mypicgetsavefilename);
        retargetcall(ptr($418BB1), @mywritedib);
        retargetcall(ptr($419fc8), @setsavefilename);

        p := ptr($418E04);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($418E53);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($41A0AA);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($41A0FE);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];

      // petzdlgglobals.maxautosavephotos := 30000; NOT WORKING
      end;
    pvPetz3: begin
        drawphotopatch := patchthiscall(ptr($005706a0), @mydrawphotop3);
        var b: byte := byte(nop);
        patchcodebuf(ptr($5706c1), 1, 11, b);
        retargetcall(ptr($527B7E), @mypicgetsavefilename);
        retargetcall(ptr($528C16), @mywritedib);
        retargetcall(ptr($5280A4), @mywritedib);
        retargetcall(ptr($528a84), @setsavefilename);

        p := ptr($527A34);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($527A86);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($528B74);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($528BCE);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
      end;
    pvPetz3German: begin
        retargetcall(ptr($52870E), @mypicgetsavefilename);

        retargetcall(ptr($5297A6), @mywritedib);
        retargetcall(ptr($528C34), @mywritedib);

        p := ptr($5285C4);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($528616);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($529704);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
        p := ptr($52975E);
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
      end;
    pvbabyz: begin

        retargetcall(ptr($503F2B), @mypicgetsavefilename);

        retargetcall(ptr($503C03), @mywritedib);

        p := ptr($503D33); //Babyz has a nice "Generate unique pic name" routine
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        ppointer(p)^ := @fautopicsavepath[1];
      end;
  end;
end;

//called instead of dispatch message in WinMain

procedure dispatchhook(var msg: tagMSG); stdcall;
var handled: boolean;
  key: TWMKey;
begin
  handled := false;

  if (msg.message >= WM_Keyfirst) and (msg.message <= wm_keylast) then begin

    key.Msg := msg.message;
    key.CharCode := msg.wparam;
    key.KeyData := msg.lparam;

    if (screen <> nil) and (Screen.ActiveForm <> nil) and (GetForegroundWindow = Screen.ActiveForm.handle) then begin

      handled := IsDialogMessage(screen.ActiveForm.Handle, msg);
      screen.ActiveForm.IsShortCut(key);
    end else
      petza.actionlist.IsShortCut(key);
  end;

  if not handled then begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end;
end;

procedure hooktranslate(var msg: tagMSG); stdcall;
begin
  //nop
end;

procedure tpetza.patchnavigation;
var p: PByte;
  oldprotect: cardinal;
begin
  if (cpetzver <> pvbabyz) or (getxstage = nil) then exit;

  //we're called because ShowNavigation doesn't match what the game is doing
  if not (shownavigation) then begin //hide
    p := ptr($658001); //Draw (Stop from being visible
    VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
    p^ := iRet;

    p := ptr($655A66); //Runupdate (Stop from updating, registering etc)
    VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
    p^ := iRet;

    p := ptr($6555B5); //Runclicks (Stop hand from moving and performing actions)
    VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
    p^ := iRet;

    fnavvisible := false;
  end else begin
    p := ptr($658001); //Draw (Stop from being visible
    VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
    p^ := $55; //push ebp

    p := ptr($655A66); //Runupdate (Stop from updating, registering etc)
    VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
    p^ := $55;

    p := ptr($6555B5); //Runclicks (Stop hand from moving and performing actions)
    VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
    p^ := $55;

    fnavvisible := true;
  end;

  thiscall(getxstage, rimports.xstage_redostage, []); //Redraw to remove/add nav bar
end;

procedure tpetza.installdispatchhook;
var oldprotect: Cardinal;
  p: PPointer;
begin
  case cpetzver of
    pvpetz5: begin
        p := ptr($5A75B0); //don't translate
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @hooktranslate;

        p := ptr($5A7618); //Hook dispatch
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @dispatchhook;
      end;
    pvpetz4: begin
        p := ptr($58B5CC); //don't translate
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @hooktranslate;

        p := ptr($58B5D0); //Hook dispatch
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @dispatchhook;
      end;
    pvpetz3: begin
        p := ptr($58653C); //don't translate
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @hooktranslate;

        p := ptr($586540); //Hook dispatch
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @dispatchhook;
      end;
    pvpetz3german: begin
        p := ptr($58653C); //don't translate
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @hooktranslate;

        p := ptr($586540); //Hook dispatch
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @dispatchhook;
      end;
    pvpetz2: begin
        p := ptr($517AE4); //don't translate
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @hooktranslate;

        p := ptr($517AE8); //Hook dispatch
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @dispatchhook;
      end;
    pvbabyz: begin
        p := ptr($6C86E4); //don't translate
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @hooktranslate;

        p := ptr($6C86E8); //Hook dispatch
        VirtualProtect(p, 4, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := @dispatchhook;
      end;
  end;
end;

procedure tpetza.installclasscreationhooks;
begin
  //  NEW CODE: petzclassesman.hookclass(rimports.petsprite_petsprite, rimports.petsprite_free, cnpetsprite);

//Old way:
  case cpetzver of
    pvpetz2: begin
        petzclassesman.hookclass(ptr($45C3C0), ptr($45C68C), ptr($45C3F6), ptr($45C6C0), cnpetsprite, rnECX);
      end;
    pvpetz3: begin
        petzclassesman.hookclass(ptr($4CE7DC), ptr($4CEA20), ptr($4CE7E7), ptr($4CEA42), cnpetsprite);
        patchthiscall(rimports.petzapp_dodrawframe, @mypetzapp_dodrawframe);
      end;
    pvpetz3german: begin
        petzclassesman.hookclass(ptr($4CF1B9), ptr($4CF410), ptr($4CF1CA), ptr($4CF45C), cnpetsprite, rnEsi);
      end;
    pvpetz4: begin
        petzclassesman.hookclass(ptr($4CBA5A), ptr($4CC040), ptr($4CBA7B), ptr($4CC062), cnpetsprite, rnESI);
        patchthiscall(rimports.petzapp_dodrawframe, @mypetzapp_dodrawframe);
      end;
    pvpetz5: begin
        petzclassesman.hookclass(ptr($4CFC51), ptr($4D0220), ptr($4CFC5C), ptr($4D0248), cnPetsprite);
        petzclassesman.hookclass(ptr($4EB863), ptr($492DF0), ptr($4EB86E), ptr($492E13), cnToySprite);
        petzclassesman.hookclass(ptr($4E0EE4), ptr($4E0F60), ptr($4E0EEF), ptr($4E0F87), cntoycase);
        petzclassesman.hookclass(ptr($4DD26D), ptr($4DD2C0), ptr($4DD27A), ptr($4DD2D5), cnspriteadpt);
        petzclassesman.hookclass(ptr($4641DA), ptr($464290), ptr($464201), ptr($4642B6), cnxdrawport, rnESI);
        patchthiscall(rimports.petzapp_dodrawframe, @mypetzapp_dodrawframe);
{$IFDEF private}
  //  patchthiscall(rimports.createmainwindow,@createmainwindow);
  //  patchthiscall(rimports.scriptsprite_pushstoredaction, @myscriptsprite_pushstoredaction);
{$ENDIF}
  //  patchthiscall(ptr($480860),@dummy);
      end;
    pvBabyz: begin
        petzclassesman.hookclass(ptr($580438), ptr($580FB8), ptr($580463), ptr($580FE8), cnpetsprite, rnECX);
      end;
  else begin
      showmessage('Unlimited: Not implemented!');
      exit;
    end;
  end;
end;

function myclosehandlepatchbabyz: longbool;
asm
mov eax,[esp+4] //load the argument (Handle)
push eax //Give a copy of it to CloseHandle
call CloseHandle
push eax //Save the result
push $007BE0A8 //offset for critical section
call LeaveCriticalSection
pop eax //let the caller know the result from CloseHandle
ret 4 //remove that argument after returning
end;

function myclosehandlepatchpetz3: longbool;
asm
mov eax,[esp+4] //load the argument (Handle)
push eax //Give a copy of it to CloseHandle
call CloseHandle
push eax //Save the result
push $00630DE8 //offset for critical section
call LeaveCriticalSection
pop eax //let the caller know the result from CloseHandle
ret 4 //remove that argument after returning
end;

function myclosehandlepatchpetz3german: longbool;
asm
mov eax,[esp+4] //load the argument (Handle)
push eax //Give a copy of it to CloseHandle
call CloseHandle
push eax //Save the result
push $00630FE8 //offset for critical section
call LeaveCriticalSection
pop eax //let the caller know the result from CloseHandle
ret 4 //remove that argument after returning
end;

{Return the install path for PetzA (ie. in Program files\sherlock software\,
 or '' if there is no path found}

function tpetza.getInstallPath: string;
var reg: tregistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey(petzakeyname, false) then
      if reg.ValueExists('InstallPath') then begin
        result := reg.ReadString('InstallPath');
        exit;
      end;
    result := ''; //not found
  finally
    reg.free;
  end;
end;

procedure mysetdiaperstatus(return, instance: pointer; status: Integer); stdcall;
begin
  thiscall(instance, rimports.scriptsprite_setdiaperstatus, [0]);

  pbyte(classprop(ppointer(classprop(instance, $7560))^, $9545C))^ := 0;
  plongword(classprop(instance, $46F0))^ := 0;
end;

procedure tpetza.patchnodiaper;
begin
  patchthiscall(ptr($590B8B), @mysetdiaperstatus);
end;

function customdeliveroffspring(return, instance: TPetzPetSprite): pointer; stdcall;
  var offspring: TPetzPetSprite;
begin
  petzshlglobals.adoptername := petza.ownername;
  offspring := TPetzPetSprite(deliveroffspringpatch.callorigproc(instance, []));
  thiscall(offspring.petinfo.commenttext, rimports.textinfo_adopttext, [cardinal(petza.customuserprofile), cardinal(-1)]);
  thiscall(offspring.petinfo.ancestryinfo, rimports.ancestryinfo_setadopter, [cardinal(petza.ownername)]);
  thiscall(pointer(classprop(offspring.petinfo, $5bba8)^), rimports.textinfo_adopttext, [cardinal(petza.ownername), cardinal(-1)]);
  result := offspring;
end;

procedure mycopy8bit(prect: TPetzPRect); stdcall;
  var port: TPetzDrawport;
begin
asm
  mov port, ecx;
end;
  port.Copy8BitCustom(prect, prect, petza.maskdrawport);
end;

procedure mydesxballz(return, instance: pointer); stdcall;
begin
  lnzpalettecache.Remove(instance);
  desxballzpatch.callorigproc(instance, []);
end;

procedure myloadlnz(return, instance, path: pointer; param2: cardinal; xballz, cache: pointer); stdcall;
var lnzdict: pointer;
const categorytitle: pansichar = '[Palette]';
var palette: integer;
var gotsection: bool;
var palettename: pansichar;
var paletteidx: byte;
begin
  loadlnzpatch.callorigproc(instance, [cardinal(path), param2, cardinal(xballz), cardinal(cache)]);
  lnzdict := classprop(cache, 380);
  // set file position
  gotsection := bool(thiscall(lnzdict, ptr($00431f30), [cardinal(categorytitle)]));
  if gotsection then begin
    // get next line
    palettename := pansichar(thiscall(lnzdict, ptr($00431fe0), []));
    if length(palettename) > 0 then begin
      var gotpalette := paletteindexes.TryGetValue(palettename, paletteidx);
      if not gotpalette then
        exit;
      paletteidx := paletteindexes[palettename];
      lnzpalettecache.AddOrSetValue(xballz, paletteidx);
    end;
  end;
end;

procedure myinitstage(return, instance: pointer; b1, b2: bool); stdcall;
var maskrect: TPetzRect;
begin
  initstagepatch.callorigproc(instance, [cardinal(b1), cardinal(b2)]);
  if not assigned(petza.maskdrawport) then begin
    maskrect := TPetzPRect(classprop(petzshlglobals, 648))^;
    maskrect.x1 := maskrect.x1 - 128;
    maskrect.y1 := maskrect.y1 - 128;
    maskrect.x2 := maskrect.x2 + 128;
    maskrect.y2 := maskrect.y2 + 128;
    petza.maskdrawport := TPetzDrawport.MakeNew(@maskrect, false, true, false);
    petza.maskdrawport.SetOrigin(128, 128);
  end;
end;

function mymakepicturefrombuffer(rect: tpetzprect): hglobal; stdcall;
var instance: tpetzdrawport;
begin
asm
  mov instance, ecx;
end;

  var localrect := tpetzrect.create(0, 0, rect.x2 - rect.x1, rect.y2 - rect.y1);
  localrect.x2 := ((rect.x2 - rect.x1) + 3) and $FFFC;
  var localdrawport := tpetzdrawport.makenew(@localrect, false, true, true);
  localdrawport.SetOrigin(-rect.x1, -rect.y1);

  // jiggle rect around to right position... bad magic numbers...
  var adjustedrect := tpetzrect.create(rect.x1 + 128, rect.y1 + 128, rect.x1 + localrect.x2 + 128, rect.y1 + localrect.y2 + 128);
  // fill out to the nearest multiple of 4
  rect.x2 := rect.x1 + localrect.x2;

  if (localrect.x2 <= 0) or (localrect.y2 <= 0) then begin
    result := 0;
    exit;
  end;

  instance.CopyBits(localdrawport, rect, rect);
  localdrawport.Copy8BitCustom(@localrect, @adjustedrect, petza.maskdrawport, true);

  var bytes := (localrect.y2 * localrect.x2) * 4 + 40;
  var datahandle := globalalloc($42, bytes);
  if datahandle = 0 then
    raise Exception.Create('Failed to allocate photo memory');

  var lock := GlobalLock(datahandle);
  var lockAsBitmapInfo := pBitmapInfo(lock);

  lockAsBitmapInfo.bmiHeader.biWidth := localrect.x2;
  lockAsBitmapInfo.bmiHeader.biHeight := localrect.y2;
  lockAsBitmapInfo.bmiHeader.biSizeImage := lockAsBitmapInfo.bmiHeader.biWidth * lockAsBitmapInfo.bmiHeader.biHeight;
  lockAsBitmapInfo.bmiHeader.biSize := 40;
  lockAsBitmapInfo.bmiHeader.biPlanes := 1;
  lockAsBitmapInfo.bmiHeader.biBitCount := 32;

  var hibitsptr := localdrawport.hibits;

  copymemory(ptr(cardinal(lock) + 40), localdrawport.hibits, lockAsBitmapInfo.bmiHeader.biSizeImage * 4);

  GlobalUnlock(datahandle);
  localdrawport.Destroy;

  result := datahandle;
end;

procedure mysnapshot(ballstate, rect1, rect2: pointer; bgcolor: integer; sprite1, sprite2: pointer); stdcall;
var xballz: pointer;
palette: byte;
originalpalette, newpalette: TGamePalette;
begin
asm
  mov xballz, ecx;
end;
  var gotpalette := lnzpalettecache.TryGetValue(xballz, palette);
  if not gotpalette then begin
    thiscall(xballz, ptr($00452440), [cardinal(ballstate), cardinal(rect1), cardinal(rect2), cardinal(bgcolor), cardinal(sprite1), cardinal(sprite2)]);
    exit;
  end;
  // crummy code - would be better to swap a ptr here rather than copy vals
  // but original code looks directly at static address
  originalpalette := pgamepalette($631398)^;
  palettes.TryGetValue(palette, newpalette);
  pgamepalette($631398)^ := newpalette;
  thiscall(xballz, ptr($00452440), [cardinal(ballstate), cardinal(rect1), cardinal(rect2), cardinal(bgcolor), cardinal(sprite1), cardinal(sprite2)]);
  pgamepalette($631398)^ := originalpalette;
end;

function mymakepicturefrombufferbg(rect: tpetzprect): hglobal; cdecl;
var instance: tpetzdrawport;
begin
  instance := tpetzdrawport(ptr($00631bc8)^);

  // jiggle the screen drawport around to make it copyable
  var boundsptr: tpetzprect := tpetzprect(classprop(instance, 12));
  var bounds: tpetzrect := boundsptr^;
  var dimensions := petzshlglobals.dimensions;
  boundsptr.x2 := dimensions.x2 - dimensions.x1;
  boundsptr.y2 := dimensions.y2 - dimensions.y1;
  var nearestmultiple := (boundsptr.x2 + 3) and $FFFC;
  var backup1 := pinteger(classprop(instance, 28))^;
  var backup2 := pinteger(classprop(instance, 32))^;
  pinteger(classprop(instance, 28))^ := nearestmultiple;
  pinteger(classprop(instance, 32))^ := nearestmultiple * (boundsptr.y2);

  var localrect := tpetzrect.create(0, 0, rect.x2 - rect.x1, rect.y2 - rect.y1);
  localrect.x2 := ((rect.x2 - rect.x1) + 3) and $FFFC;
  var localdrawport := tpetzdrawport.makenew(@localrect, false, true, true);
  // set use hi color otherwise xcopybits doesn't work right
  pinteger(classprop(localdrawport, 168))^ := 1;
  localdrawport.SetOrigin(-rect.x1, -rect.y1);

  instance.CopyBits(localdrawport, rect, rect);

  // restore screen drawport settings
  boundsptr.x1 := bounds.x1;
  boundsptr.y1 := bounds.y1;
  boundsptr.x2 := bounds.x2;
  boundsptr.y2 := bounds.y2;
  pinteger(classprop(instance, 28))^ := backup1;
  pinteger(classprop(instance, 32))^ := backup2;

  var bytes := (localrect.y2 * localrect.x2) * 4 + 40;
  var datahandle := globalalloc($42, bytes);
  if datahandle = 0 then
    raise Exception.Create('Failed to allocate photo memory');

  var lock := GlobalLock(datahandle);
  var lockAsBitmapInfo := pBitmapInfo(lock);

  lockAsBitmapInfo.bmiHeader.biWidth := localrect.x2;
  lockAsBitmapInfo.bmiHeader.biHeight := localrect.y2;
  lockAsBitmapInfo.bmiHeader.biSizeImage := lockAsBitmapInfo.bmiHeader.biWidth * lockAsBitmapInfo.bmiHeader.biHeight;
  lockAsBitmapInfo.bmiHeader.biSize := 40;
  lockAsBitmapInfo.bmiHeader.biPlanes := 1;
  lockAsBitmapInfo.bmiHeader.biBitCount := 32;

  copymemory(ptr(cardinal(lock) + 40), localdrawport.hibits, lockAsBitmapInfo.bmiHeader.biSizeImage * 4);

  GlobalUnlock(datahandle);
  localdrawport.Destroy;

  result := datahandle;
end;

procedure mydrawfilmstrip(return, filmstrip: pointer; param1: short; drawport: TPetzDrawport; bounds1, bounds2: TPetzPRect; param5: integer; param6: byte); stdcall;
var thismaskdrawport: TPetzDrawport;
var localbounds: TPetzRect;
var inrect: TPetzRect;
//var filmstrip: pointer;
begin
asm
  mov filmstrip, ecx;
end;
  if pcardinal(drawport)^ <> $58dea4 then begin
    // if this is a texture and not a drawport, do original
    drawfilmstrippatch.callorigproc(filmstrip, [cardinal(param1), cardinal(drawport), cardinal(bounds1), cardinal(bounds2), cardinal(param5), cardinal(param6)]);
    exit;
  end;

  inrect := bounds1^;
  localbounds.x1 := 0;
  localbounds.y1 := 0;
  localbounds.x2 := inrect.x2 - inrect.x1;
  localbounds.y2 := inrect.y2 - inrect.y1;
  if (localbounds.x2 = 0) and (localbounds.y2 = 0) then
    exit;
 // create new small drawport big enough for the filmstrip
  thismaskdrawport := TPetzDrawport.MakeNew(@localbounds, false, true, false);
  // set origin
  thismaskdrawport.setorigin(-inrect.x1, -inrect.y1);
  // fill with transparent
  thismaskdrawport.FillTransparent(@inrect, 253);
  // draw on small drawport
  drawfilmstrippatch.callorigproc(filmstrip, [cardinal(param1), cardinal(thismaskdrawport), cardinal(@inrect), cardinal(bounds2), cardinal(param5), cardinal(param6)]);
  // copy to original drawport
  thismaskdrawport.CopyBitsTransparentMask(drawport, @inrect, @inrect, -1);
  // set filmstrip bits to 0, all filmstrips will just use palette 0
  thismaskdrawport.CopyBitsTransparentMask(petza.maskdrawport, @inrect, @inrect, 0);
  thismaskdrawport.Destroy;
end;

procedure mydrawstacked(return, sprite: pointer; drawport: TPetzDrawport; stackdraw: integer); stdcall;
var dd: TDrawData;
var spritebounds: TPetzRect;
var drawref: pointer;
begin
  if petza.drawdata.Count > 0 then begin
    dd := petza.drawdata.Peek;
    spritebounds := TPetzPRect(classprop(sprite, 320))^;
    // Copy over what we've already drawn
    dd.miniport.CopyBitsTransparentMask(dd.originalport, @dd.bounds, @dd.bounds, -1);
    dd.miniport.CopyBitsTransparentMask(petza.maskdrawport, @dd.bounds, @dd.bounds, dd.palette);
    dd.miniport.FillTransparent(@dd.bounds, 253);
    // Draw stacked sprite
    drawref := ppointer(cardinal(ppointer(sprite)^) + $74)^;
    thiscall(sprite, drawref, [cardinal(@spritebounds), cardinal(@spritebounds), cardinal(dd.originalport), cardinal(stackdraw)]);
  end else
    drawstackedpatch.callorigproc(sprite, [cardinal(drawport), cardinal(stackdraw)]);
end;

procedure mydisplayballzframe(port, bounds, ballstate: pointer); stdcall;
var xballz: pointer;
var thismaskdrawport: TPetzDrawport;
var localbounds: TPetzRect;
var inrect: TPetzRect;
var lnz: pointer;
var palette: byte;
var dd: TDrawData;
begin
asm
  mov xballz, ecx;
end;
  inrect := TPetzPRect(bounds)^;
  localbounds.x1 := 0;
  localbounds.y1 := 0;

  if (inrect.x1 > inrect.x2) or (inrect.y1 > inrect.y2) then begin
    localbounds.x2 := inrect.x2 - inrect.x1;
    localbounds.y2 := inrect.y2 - inrect.y1;
  end else begin
    localbounds.x2 := inrect.x2 - inrect.x1;
    localbounds.y2 := inrect.y2 - inrect.y1;
  end;

  if (localbounds.x2 < 0) or (localbounds.y2 < 0) then
    localbounds.x2 := -localbounds.x2;

  lnz := ppointer(classprop(xballz, 388))^;
  lnzpalettecache.TryGetValue(xballz, palette);

  if (localbounds.x2 <= 0) or (localbounds.y2 <= 0) then
    exit;

  // create new small drawport big enough for the pet
  thismaskdrawport := TPetzDrawport.MakeNew(@localbounds, true, true, false);
  // set origin
  thismaskdrawport.setorigin(-inrect.x1, -inrect.y1);
  //petza.maskdrawport.SetOrigin(128, 128);
  // fill with transparent
  thismaskdrawport.FillTransparent(@inrect, 253);
  dd.miniport := thismaskdrawport;
  dd.originalport := port;
  dd.bounds := inrect;
  dd.palette := palette;
  petza.drawdata.Push(dd);
  // draw onto the small drawport
  thiscall(xballz, ptr($00450bd0), [cardinal(thismaskdrawport), cardinal(@inrect), cardinal(ballstate)]);
  //drawspritespatch.callorigproc(xballz, [cardinal(thismaskdrawport), cardinal(@inrect), cardinal(ballstate)]);
  // copy from small drawport to main drawport with transparency
  thismaskdrawport.CopyBitsTransparentMask(port, @inrect, @inrect, -1);
  // copy from small drawport to mask drawport
  thismaskdrawport.CopyBitsTransparentMask(petza.maskdrawport, @inrect, @inrect, palette);
  // destruct
  thismaskdrawport.Destroy;

  petza.lastmaskvalue := palette;
  petza.drawdata.Pop;
end;


procedure mydraw(sprite: pointer; port: TPetzDrawport; region: pointer); stdcall;
  var stage: TPetzStage;
  var localrect1, localrect2, spriterect, regionrect: TPetzRect;
  var rectct, ctr: integer;
  var rectptr: TPetzRect;
  var isstacked, dirty: byte;
  var rectsarrayptr: cardinal;
  var vftable: cardinal;
  var portbounds: TPetzRect;
  var thisdrawport: TPetzDrawport;
begin
asm
  mov stage, ecx;
end;
  localrect1 := TPetzRect.create(0, 0, 0, 0);
  vftable := cardinal(ppointer(sprite)^);
  spriterect := TPetzPRect(classprop(sprite, 320))^;
  if (spriterect.x1 <> 0) or (spriterect.y1 <> 0) or (spriterect.x2 <> 0) or (spriterect.y2 <> 0) then
    localrect1 := spriterect;
  regionrect := TPetzPRect(classprop(classprop(sprite, 352), 28))^;
  if (regionrect.x1 <> 0) or (regionrect.y1 <> 0) or (regionrect.x2 <> 0) or (regionrect.y2 <> 0) then begin
    if (localrect1.x1 <> 0) or (localrect1.y1 <> 0) or (localrect1.x2 <> 0) or (localrect1.y2 <> 0) then
      regionrect := regionrect + localrect1;
    localrect1 := regionrect;
  end;

  if ((localrect1.x1 = 0) and (localrect1.x2 = 0) and (localrect1.y1 = 0) and (localrect1.y2 = 0)) then
    exit;

  dirty := pbyte(classprop(sprite, 316))^;

  if dirty <> 0 then begin
    portbounds := TPetzRect.create(0, 0, localrect1.x2 - localrect1.x1, localrect1.y2 - localrect1.y1);
    if ((portbounds.x1 = 0) and (portbounds.x2 = 0) and (portbounds.y1 = 0) and (portbounds.y2 = 0)) then
    exit;

    thisdrawport := TPetzDrawport.MakeNew(@portbounds, true, true, false);
    thisdrawport.SetOrigin(-localrect1.x1, -localrect1.y1);
    thisdrawport.FillTransparent(@localrect1, 253);
    petza.lastmaskvalue := 0;
    thiscall(sprite, ppointer(vftable + $74)^, [cardinal(@localrect1), cardinal(@spriterect), cardinal(thisdrawport), cardinal(0)]);
    thisdrawport.CopyBitsTransparentMask(port, @localrect1, @localrect1, -1);
    thisdrawport.CopyBitsTransparentMask(petza.maskdrawport, @localrect1, @localrect1, petza.lastmaskvalue);
    thiscall(sprite, ppointer(vftable + $50)^, []);
    thisdrawport.Destroy;
    exit;
  end;
  ctr := 0;
  rectsarrayptr := 0;
  while true do begin
    rectct := pinteger(classprop(region, 4))^;
    if rectct <= ctr then begin
      thiscall(sprite, ppointer(vftable + $50)^, []);
      exit;
    end;
    rectptr := TPetzPRect(cardinal(ppointer(region)^) + rectsarrayptr)^;
    if (localrect1.x1 < rectptr.x2) and (localrect1.y1 < rectptr.y2) and (rectptr.x1 < localrect1.x2) and (rectptr.y1 < localrect1.y2) then begin
      localrect2 := localrect1 + rectptr;
      regionrect := localrect1 + rectptr;
    end else begin
      regionrect.x1 := 0;
      regionrect.y1 := 0;
      regionrect.x2 := 0;
      regionrect.y2 := 0;
    end;
    if (regionrect.x1 <> 0) or (regionrect.y1 <> 0) or (regionrect.x2 <> 0) or (regionrect.y2 <> 0) then begin
      isstacked := pbyte(classprop(sprite, 312))^;
      if (isstacked <> 0) or (localrect1 = localrect2) then begin
        //portbounds := TPetzRect.create(0, 0, localrect1.x2 - localrect1.x1, localrect1.y2 - localrect1.y1);
        //if ((portbounds.x1 = 0) and (portbounds.x2 = 0) and (portbounds.y1 = 0) and (portbounds.y2 = 0)) then
          //exit;
        //thisdrawport := TPetzDrawport.MakeNew(@portbounds, true, true, false);
        //thisdrawport.SetOrigin(-localrect1.x1, -localrect1.y1);
        //thisdrawport.FillTransparent(@spriterect, 253);
        petza.lastmaskvalue := 0;
        thiscall(sprite, ppointer(vftable + $74)^, [cardinal(@localrect1), cardinal(@spriterect), cardinal(port), cardinal(0)]);
        // drawing when something is entirely inside...
        // bug here because entire sprite palette swaps when palette swapped pet is inside
        //thisdrawport.CopyBitsTransparentMask(port, @spriterect, @spriterect, -1);
        //thisdrawport.CopyBitsTransparentMask(petza.maskdrawport, @spriterect, @spriterect, petza.lastmaskvalue);
        //thisdrawport.Destroy;
        thiscall(sprite, ppointer(vftable + $50)^, []);
        exit;
      end;
      portbounds := TPetzRect.create(0, 0, localrect2.x2 - localrect2.x1, localrect2.y2 - localrect2.y1);
      if ((portbounds.x1 = 0) and (portbounds.x2 = 0) and (portbounds.y1 = 0) and (portbounds.y2 = 0)) then
        exit;
      thisdrawport := TPetzDrawport.MakeNew(@portbounds, true, true, false);
      thisdrawport.SetOrigin(-localrect2.x1, -localrect2.y1);
      thisdrawport.FillTransparent(@localrect2, 253);
      petza.lastmaskvalue := 0;
      // drawing in background of some other sprite in front
      // think it's ok...
      thiscall(sprite, ppointer(vftable + $74)^, [cardinal(@localrect2), cardinal(@spriterect), cardinal(thisdrawport), cardinal(0)]);
      thisdrawport.CopyBitsTransparentMask(port, @localrect2, @localrect2, -1);
      thisdrawport.CopyBitsTransparentMask(petza.maskdrawport, @localrect2, @localrect2, 0);
      thisdrawport.Destroy;
    end;
    ctr := ctr + 1;
    rectsarrayptr := rectsarrayptr + 16;
  end;
end;

procedure mydrawsprites(sprites: pointer); stdcall;
var instance: TPetzStage;
var port: pointer;
var boundsrect : TPetzRect;
begin
asm
  mov instance, ecx;
end;
  boundsrect := petza.maskdrawport.bounds;
  boundsrect.x1 := boundsrect.x1 - 128;
  boundsrect.y1 := boundsrect.y1 - 128;
  boundsrect.x2 := boundsrect.x2 + 128;
  boundsrect.y2 := boundsrect.y2 + 128;
  petza.maskdrawport.FillTransparent(@boundsrect, 0);
  port := instance.activedrawport;
  pboolean(classprop(port, 168))^ := true;
  pinteger(classprop(port, 164))^ := 1;
  // call orig
  thiscall(instance, ptr($00489c50), [cardinal(sprites)]);
  // set values back
  pboolean(classprop(port, 168))^ := false;
  pinteger(classprop(port, 164))^ := 0;
end;

function mycreatepalette: hpalette; cdecl;
  var logpalette: plogpalette;
  forcedcolours: tdictionary<byte, tcolor>;
begin

  // set up forced colour dictionary
  forcedcolours := tdictionary<byte, tcolor>.create();
  // Otherwise lots of graphics get messed up with white outlines
  forcedcolours.Add(0, $0);
  // Highlight colour
  forcedcolours.Add(243, getsyscolor(13));
  // Menu background grey
  forcedcolours.Add(201, $d8f6f4);

  // set up logpalette needed to return an hpalette
  var sz := sizeof(TLogPalette) + (255) * sizeof(TPaletteEntry);
  getmem(logpalette, sz);
  logpalette.palVersion := $300;
  logpalette.palNumEntries := $100;

  // load the palette bmp
  // load petz.bmp if exists in palettes
  // otherwise use palette.bmp from basegame resources
  var xmemptr: pcardinal;
  var xmem: pointer;
  var gotcustompetzpalette: boolean;

  try
    var custompetzpalette := paletteswapunit.loadpetzpaletteifexists;
    xmemptr := @custompetzpalette;
    gotcustompetzpalette := true;
  except
  end;

  if not gotcustompetzpalette then begin
    var path: ansistring := '\\Art\\palette.bmp';
    var read: ansistring := 'rb';
    xmem := rimports.petzallocmem($20);
    thiscall(xmem, ptr($439590), [cardinal(0)]);
    var palettefile := thiscall(xmem, ptr($4398d0), [cardinal(path), cardinal(read), cardinal(0), cardinal(false)]);

    if palettefile <> 0 then
      raise Exception.Create('Petz palette BMP not found');

    thiscall(xmem, ptr($043a250), [cardinal(false), cardinal(false)]);
    xmemptr := pcardinal(pcardinal(cardinal(xmem) + 4)^ + 54);
  end;

  var paletteptr: pcardinal := pcardinal($631398);
  var paletteptr2 := pbitmapinfo($631370);

  // fill colours in two places... thanks petz...
  for var i := 0 to 255 do begin
    paletteptr^ := xmemptr^;
    var color := paletteptr2.bmiColors[i];
    logpalette.palPalEntry[i].peRed := color.rgbRed;
    logpalette.palPalEntry[i].peGreen := color.rgbGreen;
    logpalette.palPalEntry[i].peBlue := color.rgbRed;
    paletteptr := pcardinal(cardinal(paletteptr) + 4);
    xmemptr := pcardinal(cardinal(xmemptr) + 4);
  end;

  // force some colours to be correct
  for var p in forcedcolours do begin
    paletteptr2.bmiColors[p.key].rgbRed := p.value;
    paletteptr2.bmiColors[p.key].rgbGreen := p.Value shr 8;
    paletteptr2.bmiColors[p.key].rgbBlue := p.Value shr 16;
    var color := paletteptr2.bmiColors[p.key];
    logpalette.palPalEntry[p.key].peRed := color.rgbRed;
    logpalette.palPalEntry[p.key].peGreen := color.rgbGreen;
    logpalette.palPalEntry[p.key].peBlue := color.rgbRed;
  end;

  // free stuff
  if not gotcustompetzpalette then begin
    thiscall(xmem, ptr($43a2a0), []);
    if (xmem <> nil) then
      thiscall(xmem, ppointer(pcardinal(xmem)^)^, [cardinal(1)]);
  end;
  freemem(logpalette, sz);

  result := createpalette(logpalette);
end;

procedure tpetza.patchcustomuserprofile;
begin
  deliveroffspringpatch := patchthiscall(rimports.petsprite_deliveroffspring, @customdeliveroffspring);
end;

procedure tpetza.patchreacttocamera(value: bool);
var data: array[0..6] of byte;
var data2: array[0..2] of byte;
begin
  if value = false then begin
      data[4] := $00;
      data[3] := $00;
      data[2] := $01;
      data[1] := $5d;
      data[0] := $e9;
      patchcodebuf(ptr($4faee0), 5, 6, data[0]);
      var d := nop;
      patchcodebuf(ptr($4faedc), sizeof(nop), 2, d);
    end
  else begin
      data[5] := $00;
      data[4] := $00;
      data[3] := $01;
      data[2] := $5c;
      data[1] := $84;
      data[0] := $0f;
      data2[1] := $1c;
      data2[0] := $75;
      patchcodebuf(ptr($4faee0), 6, 6, data[0]);
      patchcodebuf(ptr($4faedc), 2, 2, data2[0]);
  end;

end;

constructor tpetza.create;
type ppointer = ^pointer;
var oldprotect: cardinal;
  p: PByte;
  b: byte;
  action: TAction;
var thispalette: tgamepalette;
begin
  Application.HelpFile := locatehelpfile;
  foldwndproc := nil;
  pendingrefresh := false;
  lastadoptpet := -1;
  processingmessage := false;
  patches := TObjectList.create;
  menumanager := tmenumanager.create;
  profilemanager := tprofilemanager.create(extractfilepath(ParamStr(0)));
  petzclassesman := TPetzClassesMan.create;
  petzclassesman.onClassChange := onclasschange;
  initbrainslidernames;

  actionlist := TActionList.Create(nil);

  if assigned(rimports.spriteadpt_loadpetz) then begin
    action := taction.Create(actionlist);
    action.ActionList := actionlist;
    action.ShortCut := shortcut(ord('D'), [ssAlt]);
    action.OnExecute := refreshadptpetwrap;
    action.Enabled := True;
  end;

  tfrmmymessage.setmessageroot(petzakeyname + '\DisableDialogs');

  brains := TObjectList.Create;

  RegisterExceptionHandler(exceptionhandler, stdontsync);

  InstallClassCreationHooks;

  case cpetzver of
    pvpetz5: begin
        //petzclassesman.hookclass(ptr($4EB863), ptr($492DF0), ptr($4EB86E), ptr($492E13), cnToySprite);
        //petzclassesman.hookclass(ptr($4E0EE4), ptr($4E0F60), ptr($4E0EEF), ptr($4E0F87), cntoycase);
        //petzclassesman.hookclass(ptr($4641DA), ptr($464290), ptr($464201), ptr($4642B6), cnxdrawport, rnESI);
        patchthiscall(rimports.petzapp_dodrawframe, @mypetzapp_dodrawframe);

  //  patchthiscall(ptr($480860),@dummy);
      end;
  end;

  if assigned(rimports.petsprite_isoffspringdue) then
    patchthiscall(rimports.petsprite_isoffspringdue, @myisoffspringdue);
  if assigned(rimports.petzapp_checkforbabyzcd) then
    patchthiscall(rimports.petzapp_checkforbabyzcd, @mycheckforbabyzcd);
  if assigned(rimports.spriteadpt_loadpetz) then
    hloadpetz := patchthiscall(rimports.spriteadpt_loadpetz, @myspriteadpt_loadpetz) else
    hloadpetz := nil;

  if cpetzver in verAdoptcenter then begin
    petzclassesman.hookclass(rimports.spriteadpt_spriteadpt, rimports.spriteadpt_free, cnspriteadpt);
  end;

  if cpetzver = pvPetz5 then begin //disable weather
    thiscall(ptr($6658D0), rimports.cdatafile_getinstdata, [cardinal(pchar('Weather Enabled')), cardinal(petzshlglobals) + $4F8, 1, 3, 0]);
  end;

  case cpetzver of
    pvpetz5: begin
{        p := ptr($4D1360);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // allow mothers with children out of nursery, replace with uncontrolled jmp

        Causes too many problems to enable}

        p := ptr($4E1D0C);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // replace with uncontrolled jump to allow any number of petz out!

        p := ptr($4E1CAC);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // replace with uncontrolled jump to allow any petz in nursery
      end;
    pvpetz3: begin
        p := ptr($4E9DBA);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // replace with uncontrolled jump to allow any number of petz out!
      end;
    pvpetz3german: begin
        p := ptr($4EA8BD);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // replace with uncontrolled jump to allow any number of petz out!
      end;
    pvpetz4: begin
        p := ptr($4DC3E2);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // replace with uncontrolled jump to allow any number of petz out!
      end;
    pvbabyz: begin
        p := ptr($517E50); // check when getting from grandma's
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        pbyte(p)^ := $20;

        p := ptr($60ED92); // check for too many babyz, should send to grandma's
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        pbyte(p)^ := $20;

        //Check while building house nav, erase weird code that runs on
        //unexpected playscene names
        p := ptr($66C699);

        VirtualProtect(p, 251, PAGE_EXECUTE_READWRITE, oldprotect);
        FillChar(p^, 251, $90);
      end;
    pvpetz2: begin
        p := ptr($4472D5);
        VirtualProtect(p, 1, PAGE_EXECUTE_READWRITE, oldprotect);
        p^ := $EB; // replace with uncontrolled jump to allow any number of petz out!

        //patchthiscall(ptr($4AD208), @getthumbnail);

        if win2kornewer then begin
          p := ptr($481326);
          VirtualProtect(p, 11, PAGE_EXECUTE_READWRITE, oldprotect);
          fillchar(p^, 11, $90); // replace with uncontrolled jump to skip a block of code in expandable menu wndproc
        end;

{    //always allow sounds
     p:=ptr($47B3D4);
     virtualprotect(p,6,page_execute_readwrite,oldprotect);
     fillchar(p,6,$90);}
      end;
  end;

  if cpetzver = pvpetz2 then
    patchgeneric(ptr($47B5AA), ptr($47B615), petz2windowcreate)
  else
    hpetzwindowcreate := patchthiscall(rimports.petzapp_createmainwindow, @petzwindowcreate);

 //Fixes for sound lockups on Babyz/Petz3
  case cpetzver of
    pvbabyz: begin
        p := ptr($4569B7); //CALL DS:CLOSEHANDLE
        b := icall;
        patchcodebuf(p, sizeof(b), 6, b); //change to normal call
        retargetcall(p, @myclosehandlepatchbabyz); //and point to our func. Note NOP spacing
      end;
    pvPetz3: begin
        p := ptr($446776); //CALL DS:CLOSEHANDLE
        b := icall;
        patchcodebuf(p, sizeof(b), 6, b); //change to normal call
        retargetcall(p, @myclosehandlepatchpetz3); //and point to our func. Note NOP spacing
      end;
    pvPetz3German: begin
        p := ptr($446696); //CALL DS:CLOSEHANDLE
        b := icall;
        patchcodebuf(p, sizeof(b), 6, b); //change to normal call
        retargetcall(p, @myclosehandlepatchpetz3german); //and point to our func. Note NOP spacing
      end;
  end;

  // Set up custom user profile
  case cpetzver of
    pvpetz4, pvpetz3, pvpetz5: begin
      patchcustomuserprofile;
    end;
  end;

  // Patch InitToy for custom toy adjective loading
  case cpetzver of
    pvpetz4, pvpetz3: begin
      inittoypatch := patchthiscall(rimports.toysprite_inittoy, @myinittoy);
    end;
  end;

  installdispatchhook;

  patchcamera;

  patchresolutioncheck;

  cameraformat := TCameraFormat.cfBMP; //set up the gif camera details
  instantbirth := false;
  shownametags := false;
  brainslidersontop := true;
  fgamespeed := defaultgamespeed;
  appliedspeed := false;
  batchbreedcountdefault := 10;

  fshowheart := true; //by default, heart still shows

  fnavvisible := true; //The game is showing the navigation
  shownavigation := true; //Show it by default
  fnodiaperchanges := False; //by default, diapers get soiled just like normal :)
  freacttocamera := true;
  fusenewphotonameformat := true;
  neglectdisabled := true;
  ownername := petzshlglobals.adoptername;

  // breeding settings
  fbreedingtimer := 0;
  fbatchbreedcountdefault := 10;

  // Patch drawing for extra palettes
  drawdata := TStack<TDrawData>.Create();
  retargetcall(ptr($004c9c4f), @mydrawsprites);
  drawfilmstrippatch := patchthiscall(ptr($00461d10), @mydrawfilmstrip);
  retargetcall(ptr($0047d3d7), @mydisplayballzframe);
  initstagepatch := patchthiscall(ptr($00489610), @myinitstage);
  drawstackedpatch := patchthiscall(ptr($00488b60), @mydrawstacked);
  retargetcall(ptr($004365f2), @mycopy8bit);
  // Patch lnz loading and unloading for extra palettes
  lnzpalettecache := TDictionary<pointer, byte>.Create();
  loadlnzpatch := patchthiscall(ptr($0046c390), @myloadlnz);
  desxballzpatch := patchthiscall(ptr($0044b6d0), @mydesxballz);
  // Load palettes
  loadpalettes;
  // Make photos hicolor
  retargetcall(ptr($0048a554), @mymakepicturefrombuffer);
  retargetcall(ptr($0048a4e7), @mymakepicturefrombufferbg);
  // Make headshots palettised
  retargetcall(ptr($004cefc5), @mysnapshot);
  retargetcall(ptr($004CED8D), @mysnapshot);


  loadsettings; //pretty late in the peace so all objects are created

  if unlockpalette then begin
    // Load palette without windows colours
    // and from petz.bmp if exists
    retargetcall(ptr($4359a9), @mycreatepalette);
    retargetcall(ptr($4359da), @mycreatepalette);
    retargetcall(ptr($435a01), @mycreatepalette);
    // Cheapo: map all palette indexes to themselves
    b := $0;
    patchcodebuf(ptr($45c865), 1, 1, b);
    b := 255;
    patchcodebuf(ptr($45c872), 1, 1, b);
    // Remap this colour - used as menu background colour
    b := 201;
    patchcodebuf(ptr($4a94ac), 1, 1, b);
    patchcodebuf(ptr($4aabbe), 1, 1, b);
  end;

  if neglectdisabled then
    // Disable neglect accumulating from not taking pets out
    case cpetzver of
      pvpetz4: begin
        b := $EB;
        patchcodebuf(ptr($4d4c65), 1, 1, b);
      end;
      pvpetz3: begin
        b := $EB;
        patchcodebuf(ptr($4dd88a), 1, 1, b);
      end;
  end;

  petzaloaded; //should be last instruction
end;

destructor tpetza.destroy;
begin
  //Restore old wndproc
  if (foldwndproc <> nil) and (findpetzwindow <> 0) then
    setwindowlong(findpetzwindow, GWL_WNDPROC, integer(foldwndproc));

  actionlist.free;

  //brains.free; Er. Reported "WinAPI function failed" in DestroyHandle. Lets just do this for now

  savesettings; // do early on so that all objects are available

  restorepatches; //unhook and delete patches
  petzclassesman.free; // now remove class
  patches.free; // nothing interesting happens here
  menumanager.free; // delete and free menus
  profilemanager.free;

  inherited;
end;

procedure setgamespeed(sender: tmymenuitem);
begin
  tfrmgamespeed.create(nil).showmodal;
end;

procedure setnumchildren(sender: tmymenuitem);
begin
  tfrmsetnumchildren.create(nil).showmodal;
end;

procedure gotonursery(sender: TMyMenuItem);
var s: string;
begin
  if cpetzver <> pvpetz5 then Exit;
  s := 'Nursery';
  Thiscall(petzoberon, ptr($4CEB10), [cardinal(pchar(s))]);
end;

procedure ageallbabies(sender: tmymenuitem);
var list: tobjectlist;
  t1: integer;
  found: boolean;
  pet: tpetzpetsprite;
begin
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    found := false;
    for t1 := 0 to list.count - 1 do begin
      pet := tpetzpetsprite(TPetzClassInstance(list[t1]).instance);
      if pet.isdependent then begin
        pet.setbiorhythm(petza.findslider('Age'), 100);
        found := true;
      end;
    end;
    if found then nonmodalmessage('Successfully set all babies ages to 100', 'AgeBabies') else
      nonmodalmessage('Couldn''t find any babies. Make sure that you have your babies out and try again');
  finally
    list.free;
  end;
end;

procedure ageallinternal(age: integer);
var list: tobjectlist;
  t1: integer;
  pet: tpetzpetsprite;
begin
  list := tobjectlist.Create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    for t1 := 0 to list.Count - 1 do begin
      pet := tpetzpetsprite(tpetzclassinstance(list[t1]).instance);
      pet.setbiorhythm(petza.findslider('Age'), age);
    end;

  finally
    list.Free;
  end;
end;

procedure ageall100(sender: TMyMenuItem);
begin
  ageallinternal(100);
end;

procedure ageall12(sender: TMyMenuItem);
begin
  ageallinternal(12);
end;

procedure petmate(sender: tmymenuitem);
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

procedure petoptionshandler(sender: tmymenuitem);
type pbytebool = ^bytebool;
var t1, t2: integer;
  list: tobjectlist;
  pet: tpetzpetsprite;
  brain: TfrmSliderBrain;
  frm: TfrmTrimFamilyTree;
begin
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    for t1 := 0 to list.count - 1 do begin
      pet := TPetzPetSprite(TPetzClassInstance(list[t1]).instance);
      if longword(pet.id) = sender.data then begin
        if sender.name = 'sendtodoor' then
          pet.enterpetdoor else
          if sender.name = 'brainsliders' then begin

            for t2 := 0 to petza.brains.count - 1 do //Do we already have this one open?
              if (not tfrmsliderbrain(petza.brains[t2]).global) and
                (tfrmsliderbrain(petza.brains[t2]).petid = pet.id) then begin
                tfrmsliderbrain(petza.brains[t2]).show;
                exit;
              end;
                     //we need to make this one
            brain := TfrmSliderBrain.create(nil, petza.brainslidersontop, false, pet.id);
            petza.brains.add(brain);
            brain.show;
          end else
            if sender.name = 'sexchange' then begin
              pet.petinfo.isfemale := not pet.petinfo.isfemale;
              if pet.petinfo.isfemale then
                nonmodalmessage('Successfully switched ' + pet.name + ' to a female.', 'SexChangeSuccess') else
                nonmodalmessage('Successfully switched ' + pet.name + ' to a male.', 'SexChangeSuccess');
            end else
              if sender.name = 'neuter' then begin
                pet.petinfo.neutered := not pet.petinfo.neutered;
                if pet.petinfo.neutered then
                  nonmodalmessage('Successfully neutered ' + pet.name + '!', 'NeuterSuccess') else
                  nonmodalmessage('Successfully unneutered ' + pet.name + '!', 'NeuterSuccess');
              end else
                if sender.name = 'trimtree' then begin
                  frm := tfrmtrimfamilytree.create(application);
                  frm.petid := pet.id;
                  frm.petname := pet.name;
                  frm.Show;
                end;
        break;
      end;
    end;
  finally
    list.free;
  end;
end;

procedure testgoals(sender: TMyMenuItem);
var pet: TPetzPetSprite;
begin
  pet := petza.findpet(sender.id);
  if pet = nil then raise exception.create('bleh');
  pet.GoalManager
end;

procedure RebuildPetzMenu;
var list: tobjectlist;
  t1: integer;
  pet: hmenu;
  petsprite: TPetzPetSprite;
  dependant: boolean;
begin
  if not petza.pendingrefresh then exit;
{$IFDEF petzadebug}
  frmDebug.Memo1.lines.add('Refresh menu');
{$ENDIF}
  petza.pendingrefresh := false;
  if (menumanager.petsmenu = 0) then
    exit; {Menu doesn't exist!}
  while GetMenuItemCount(menumanager.petsmenu) > 0 do begin
    menumanager.delete(menumanager.petsmenu, 0, true);
  end;
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);
    for t1 := 0 to list.count - 1 do begin
      pet := createmenu;
      petsprite := TPetzPetSprite(TPetzClassInstance(list[t1]).instance);

      dependant := assigned(rimports.petsprite_getisdependent) and petsprite.isdependent;

      menumanager.additem(menumanager.petsmenu, petsprite.name, petsprite.name, 0, nil, pet, true);

      if assigned(rimports.petsprite_enterpetdoor) and not dependant then
        menumanager.additem(pet, 'sendtodoor', 'Send to pet door', petsprite.id, petoptionshandler);
      menumanager.additem(pet, 'brainsliders', 'Brain sliders...', petsprite.id, petoptionshandler);

      if cpetzver in verBreeding then begin
        menumanager.additem(pet, 'sexchange', 'Sex change', petsprite.id, petoptionshandler);
        menumanager.additem(pet, 'neuter', 'Neuter/Unneuter', petsprite.id, petoptionshandler);
        menumanager.additem(pet, 'trimtree', 'Trim family tree...', petsprite.id, petoptionshandler);
      end;

//      menumanager.additem(pet, 'test', 'Test', petsprite.id, testgoals);
      //menumanager.additem(pet, 'profile', 'Profile...', TPetzPetSprite(TPetzClassInstance(list[t1]).instance).id, petoptionshandler);

    end;
  finally
    list.free;
  end;
  DrawMenuBar(findpetzwindow);
end;


procedure pushdogaction(eax, ecx, edx: cardinal);
begin
//  frmDLLMain.memo1.lines.add('dog action: ' + inttostr(eax));
end;

function dopetzmsghandler(hwnd: HWND; msg: longword; wparam: longint; lparam: longint): lresult; stdcall;
const boringmessages: array[0..10] of integer = (wm_mousemove, wm_lbuttonup, wm_lbuttondown, wm_timer, wm_nchittest, wm_setcursor,
    wm_windowposchanging, wm_windowposchanged, wm_rbuttondown, wm_rbuttonup, wm_mouseleave);
  function inheritedwnd: lresult;
  begin
    result := CallWindowProc(petza.foldwndproc, hwnd, msg, wparam, lparam);
  end;

var msg1: tagMSG;
begin
//  result := 1;
  msg1.message := msg;
  msg1.hwnd := hwnd;
  msg1.wparam := wparam;
  msg1.LParam := lparam;

  case msg of
    wm_timer: begin
        result := inheritedwnd;
        try
          if petza.shownavigation <> petza.fnavvisible then
            petza.patchnavigation;

          if not petza.appliedspeed then begin
            petza.appliedspeed := true;
            petza.gamespeed := petza.fgamespeed;
          end;

          // Handle async batch breeding
          if waitingforpettocomeout = true then begin
            if petza.fbreedingtimer = 10 then begin
             // We've waited long enough for the last offspring to come out, so
             // call the next one out
             waitingforpettocomeout := false;
             petzcase.loadpetz(lastmotherid, 0);
             batchbreedcount := batchbreedcount - 1;
             petza.fbreedingtimer := 0;

             // If we still have more offspring to make, re-mate
             if batchbreedcount > 0 then begin
               var female := petza.findpet(lastmotherid);
               frmmateunit.matebystateconceive(female, lastfather);
               frmmateunit.deliveroffspring(female);
               waitingforpettocomeout := true;
             end
             else begin
                // If we have no more offspring to make,
                // find the breeding popup and close it
                var popupform: TForm;
                for var I := 0 to Screen.FormCount-1 do begin
                  var frm := screen.Forms[i];
                  if fsModal in Frm.FormState then begin
                    if frm is tfrmmymessage then
                      frm.ModalResult := Controls.mrOk;
                  end;
                end;
                lastmotherid := 0;
                lastfather := nil;
                petmate(nil);
                petza.showheart	:= oldshowheart;
                unpatchbreedingcalls;
             end;
            end
          else
            petza.fbreedingtimer := petza.fbreedingtimer + 1;
          end;
        except
          HandleException;
        end;
      end;
    wm_command: begin
   //is this one of our menus?
   //showmessage(inttostr(hwnd)+','+inttostr(msg)+','+inttostr(wparam)+','+inttostr(lparam));
        begin
          result := inheritedwnd;
          try
            if menumanager.wmcommand(wparam and $FFFF) then begin
              result := 0;
              exit;
            end;
          except
            HandleException;
          end;
        end;
      end;
    WM_REBUILDPETZMENU: begin
        try
          rebuildpetzmenu;
        except
          HandleException;
        end;
        result := 1;
      end;
  else
    result := inheritedwnd;
  end;
end;

procedure aboutpetza(sender: tmymenuitem);
begin
  tfrmabout.create(nil).show;
end;

procedure followmouse(x, y: integer);
(*var list: tobjectlist;
  t1: integer;*)
begin
(*  if (x > 0) and (y > 0) then begin
    list := tobjectlist.create(false);
    try
      petzclassesman.findclassinstances(cnpetsprite, list);
      for t1 := 0 to list.count - 1 do begin
        if thiscall(TPetzClassInstance(list[t1]).instance, addr(petsprite_getisbehindpetdoor), []) and $FF = 0 then
          Thiscall(TPetzClassInstance(list[t1]).instance, addr(petsprite_locomotetopoint), [x, y]);
      end;
    finally
      list.free;
    end;
  end;*)
end;

procedure tpetza.onclasschange(changetype: tchangetype; classname: tpetzclassname; instance: TPetzClassInstance);
{$IFDEF petzadebug}
var s: string;
{$ENDIF}
begin
  if classname = cnpetsprite then begin
    pendingrefresh := true; // refresh once per message loop, nice
    PostMessage(findpetzwindow, WM_REBUILDPETZMENU, 0, 0);
  end;
{$IFDEF petzadebug}
  if changetype = ctcreate then
    s := 'Created ' else
    s := 'Destroyed ';
  s := s + GetEnumName(TypeInfo(TPETZCLASSNAME), Ord(classname));
  s := s + ' ' + inttostr(petzclassesman.countinstances(classname));
  s := s + '  :: ' + inttostr(GetCurrentThreadId);
  frmDebug.Memo1.Lines.Add(s);
{$ENDIF}
end;

procedure adpt(sender: tmymenuitem);
var spradpt: TPetzClassInstance;
begin
  spradpt := petzclassesman.findclassinstance(cnSpriteAdpt);
  if spradpt = nil then showmessage('nil!');
end;

procedure opensettings(sender: TMyMenuItem);
var settings: TFrmsettings;
begin
  settings := TFrmsettings.Create(nil);
  try
    settings.ShowModal;
    petza.savesettings;
  finally
    settings.free;
  end;
end;

procedure openprofiles(sender: TMyMenuItem);
var prof: TfrmProfileManager;
begin
  prof := TfrmProfileManager.Create(nil);
  try
    prof.ShowModal;
  finally
    prof.free;
  end;
end;

procedure openuserprofile(sender: TMyMenuItem);
var prof: TUserProfile;
begin
  prof := TUserProfile.Create(nil);
  try
    prof.ShowModal;
  finally
    prof.free;
  end;
end;

procedure openhelp(sender: TMyMenuItem);
begin
Application.HelpCommand(HELP_CONTEXT,HELP_Welcome);
end;

procedure petz2windowcreate(injectpoint: pointer; eax, ecx, edx, esi: longword);
begin
  try
    petzwindowcreate(nil, nil);
  except
    HandleException;
  end;
end;

procedure globalbrainsliders(sender: tmymenuitem);
var brain: TfrmSliderBrain;
  t1: integer;
begin
  for t1 := 0 to petza.brains.count - 1 do //Do we already have this one open?
    if tfrmsliderbrain(petza.brains[t1]).global then begin
      tfrmsliderbrain(petza.brains[t1]).show;
      exit;
    end;

  brain := TfrmSliderBrain.create(nil, petza.brainslidersontop, true);
  petza.brains.add(brain);
  brain.show;
end;

procedure handleareaclick(sender: TMyMenuItem);
var area: pointer;
  s: string;
begin
  s := sender.name;
  if length(s) = 0 then exit;
  area := pointer(thiscall(petzoberon, rimports.oberon_getarea, [cardinal(pchar(s))]));
  if area = nil then
    showmessage('Sorry, the playscene (' + sender.name + ') hasn''t been loaded by Babyz, there must be a problem with it.')
  else
    thiscall(ptr($7C7424), ptr($436DA0), [cardinal(area)]);
end;

function stripext(const filename: string): string;
begin
  result := copy(filename, 1, length(filename) - length(ExtractFileExt(filename)));
end;

procedure buildareamenu(areamenu: HMENU);
var f: TSearchRec;
  s: string;
begin
  while GetMenuItemCount(areamenu) > 0 do begin
    menumanager.delete(areamenu, 0, true);
  end;

  if findfirst(extractfilepath(ParamStr(0)) + 'Resource\Area\*.env', faAnyFile and (not faDirectory), f) = 0 then begin
    try
      repeat
        s := stripext(f.Name);
        menumanager.additem(areamenu, s, s, 0, handleareaclick);
      until findnext(f) <> 0;
    finally
      sysutils.findclose(f);
    end;
  end;
end;


procedure petzwindowcreate(return, instance: pointer); stdcall;
var wnd: hwnd;
  needsep: boolean;
  areamenu: HMENU;
{$IFDEF ONLINE}onlinemenu: HMENU; {$ENDIF}
begin

  if instance <> nil then
    hpetzwindowcreate.callorigproc(instance, []);

  try
    wnd := findpetzwindow;
    if wnd = 0 then begin
      showmessage('Couldn''t find the Petz window! PetzA cannot run!');
      exit;
    end;
    petza.foldwndproc := pointer(GetWindowLong(wnd, GWL_WNDPROC)); //subclass wndproc
    setwindowlong(wnd, GWL_WNDPROC, integer(@dopetzmsghandler));

    menumanager.BuildMenu(wnd);

    if cpetzver = pvbabyz then begin
      areamenu := CreatePopupMenu;
      menumanager.additem(menumanager.submenu, 'areas', 'Playscenes', 0, nil, areamenu, true);
      buildareamenu(areamenu);
    end;

//  menumanager.additem(menumanager.submenu, 'followmouse', 'Petz follow mouse', 0, petsfollowmouse1);

    if assigned(rimports.petsprite_mate) then
      menumanager.additem(menumanager.submenu, 'mate', 'Mate two pets...', 0, petmate);
    menumanager.additem(menumanager.submenu, 'globalsliders', 'Global brain sliders...', 0, globalbrainsliders);
    if cpetzver in [pvpetz5] then begin
      menumanager.additem(menumanager.submenu, 'numchildren', 'Set number of children...', 0, setnumchildren);
    end;

    menumanager.additem(menumanager.submenu, 'speed', 'Set game speed...', 0, setgamespeed);

    menumanager.addseparator(menumanager.submenu);

    needsep := false;

    if assigned(rimports.petsprite_getisdependent) and
      assigned(rimports.petsprite_setpetbiorhythm) then begin
      needsep := true;
      menumanager.additem(menumanager.submenu, 'ageall', 'Make babies grow up', 0, ageallbabies);
    end;
    
    if assigned(rimports.petsprite_setpetbiorhythm) then begin
      menumanager.additem(menumanager.submenu, 'ageall12', 'Age all to 12', 0, ageall12);
      menumanager.additem(menumanager.submenu, 'ageall100', 'Age all to 100', 0, ageall100);
    end;

  menumanager.additem(menumanager.submenu, 'sendalltopetdoor', 'Send all to pet door', 0, sendalltopetdoor);
   
    if assigned(rimports.spriteadpt_loadpetz) then begin
      needsep := true;
      menumanager.additem(menumanager.submenu, 'refreshadptpet', 'Bring adoption centre pet back out '#9'Alt-D', 0, refreshadptpet);
    end;
     
    if cpetzver = pvpetz5 then
      menumanager.additem(menumanager.submenu, 'nursery', 'Go to the nursery', 0, gotonursery);

    if needsep then menumanager.addseparator(menumanager.submenu);

    menumanager.additem(menumanager.submenu, 'settings', 'Settings...', 0, opensettings);
    menumanager.additem(menumanager.submenu, 'profiles', 'Manage profiles...', 0, openprofiles);
    if cpetzver in [pvpetz4, pvpetz5, pvpetz3] then
      menumanager.additem(menumanager.submenu, 'userprofile', 'Set default pet profile...', 0, openuserprofile);

    menumanager.addseparator(menumanager.submenu);

    menumanager.additem(menumanager.submenu, 'help', 'Help', 0, openhelp);
    menumanager.additem(menumanager.submenu, 'about', 'About ' + petzvername(cpetzver) + '...', 0, aboutpetza);
  except
    handleexception;
  end;
end;

function GetDLLVersion: longword;
begin
  case cpetzver of
    pvpetz5: result := $44000004;
    pvpetz3, pvPetz3German: result := $43000104;
    pvpetz4: result := $44000007;
    pvBabyz: result := $11000000;
    pvpetz2: result := $41000104;
  else begin
      showmessage('Petz version not supported');
      result := 0;
    end;
  end;
end;

procedure GetLoadInfo(loadinfo: pointer; loadtype: integer; a3: pchar; xlibrarylist: pointer); cdecl;
//var proc: Pointer;
begin
//  rimports.xdownload_getdefaultloadinfo(loadinfo, loadtype, a3, xlibrarylist);
 { if xlibrarylist<>nil then begin
   Thiscall(xlibrarylist,ppointer(ppointer(xlibrarylist)^)^,[1]);
  end;}
//nop. Could "Get default load info", but we don't want to make ourselves accessible to Petz now, do we?
end;

exports GetDLLVersion,
  GetLoadInfo;

initialization
finalization
  try
    petza.free;
  except
    HandleException;
  end;
end.

