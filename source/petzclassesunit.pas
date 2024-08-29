unit petzclassesunit;

interface

uses sysutils, windows, graphics, classes, contnrs, dialogs, bndpetz,
  dllpatchunit, Generics.Collections, petzpaletteunit, paletteswapunit;

var notagain: boolean;

type
  PPointer = ^pointer;
  PBytebool = ^bytebool;
  TRegisterName = (rnEAX, rnESI, rnECX);
  TPetzClassName = (cnAlposprite, cnPetsprite, cnToySprite, cnToyCase, cnSpriteAdpt, cnXDrawport);
  TPetzClassNameTree = array of tpetzclassname;

  TPetzClassInstance = class
  private
    fcpointer: pointer;
  public
    classname: tpetzclassname;
    function instance: pointer;
    constructor create(cpointer: pointer);
    destructor Destroy; override;
  end;

  TPetzClass = class of tpetzclassinstance;

  Tpetzpetmodule = class(tpetzclassinstance);

  TPetzPetzApp = class(tpetzclassinstance)
  private
    function getaccel: haccel;
    function getdrawready: integer;
    procedure setdrawready(value: integer);
    function getpetmodule: tpetzpetmodule;
    procedure setpetmodule(value: tpetzpetmodule);
  public
    property drawready: integer read getdrawready write setdrawready;
    property petmodule: tpetzpetmodule read getpetmodule write setpetmodule;
    property accel: HACCEL read getaccel;
  end;

  TPetzAncestryInfo = class
  private
    procedure setfathertree(value: tpetzancestryinfo);
    function getfathertree: tpetzancestryinfo;
    procedure setmothertree(value: tpetzancestryinfo);
    function getmothertree: tpetzancestryinfo;
    function getbreed: ansistring;
    procedure setbreed(value: ansistring);
    function getname: ansistring;
    procedure setname(value: ansistring);
    function getadopter: ansistring;
    procedure setadopter(value: ansistring);
    function getadoptiondate: tdatetime;
    procedure setadoptiondate(value: tdatetime);
    function getisfemale: boolean;
    procedure setisfemale(value: boolean);
  public
    property isfemale: boolean read getisfemale write setisfemale;
    property breed: ansistring read getbreed write setbreed;
    property name: ansistring read getname write setname;
    property adopter: ansistring read getadopter write setadopter;
    property mothertree: tpetzancestryinfo read getmothertree write setmothertree;
    property fathertree: tpetzancestryinfo read getfathertree write setfathertree;
    property adoptiondate: Tdatetime read getadoptiondate write setadoptiondate;
    procedure streamout(stream: tstream);
    class function create: tpetzancestryinfo;
  end;

  TPetzPetinfo = class
  private
    function getneutered: boolean;
    procedure setneutered(value: boolean);
    procedure setfemale(value: boolean);
    function getfemale: boolean;
    function getancestryinfo: tpetzancestryinfo;
    procedure setancestryinfo(value: tpetzancestryinfo);
    function getcomment: pointer;
    function getheadshot: pointer;
  public
    function pregnant: boolean;
    function conceivetime: longword;
    property ancestryinfo: TPetzAncestryInfo read getancestryinfo write setancestryinfo;
    property isfemale: boolean read getfemale write setfemale;
    property neutered: boolean read getneutered write setneutered;
    property commenttext: pointer read getcomment;
    property headshot: pointer read getheadshot;
  end;

  TPetzLoadInfo = class
    private
      function getsessionid: ushort;
      function getname: ansistring;
      function getspriteindex: integer;
    public
      property sessionid: ushort read getsessionid;
      property name: ansistring read getname;
      property spriteindex: integer read getspriteindex;
  end;

  TPetzAlposprite = class
  private
    function getloadinfo: TPetzLoadInfo;
  public
    function isthisapet: boolean;
    procedure setadjvalue(attr, val: integer);
    property loadinfo: TPetzLoadInfo read getloadinfo;
  end;

  TPetzSpriteAdpt = class
  private
    function getpetslot: integer;
    procedure setpetslot(value: integer);
  public
    property petslot: integer read getpetslot write setpetslot;
  end;

  TPetzPetSprite = class(tpetzalposprite)
  private
    function getid: smallint;
    function getinteracting: TPetzPetSprite;
    procedure setinteracting(value: TPetzPetSprite);
    procedure setstateflag(value: longword);
    function getstateflag: longword;
    function getshoulddraw: boolean;
    procedure setshoulddraw(value: boolean);
    function getloadinfo: tpetzloadinfo;
    function getsessionid: ushort;
  public
    function scriptstack: pointer;
    function isdependent: boolean;
    function petinfo: tpetzpetinfo;
    function isbehindpetdoor: boolean;
    function getbiorhythm(index: integer): integer;
    procedure setbiorhythm(index: integer; value: integer);
    procedure enterpetdoor;
    function name: ansistring;
    function GoalManager: pointer;
    property interactingpet: TPetzPetsprite read getinteracting write setinteracting;
    property stateflag: longword read getstateflag write setstateflag;
    property id: smallint read getid;
    property shoulddraw: boolean read getshoulddraw write setshoulddraw;
    property sessionid: ushort read getsessionid;
  end;

  TPetzClassHook = class
  public
    con, des, conres, desres: pointer;
    conreg, desreg: TRegisterName;
//    classnametree: TPetzClassNameTree;
    classname: tpetzclassname;
  end;

  TPetzDLGGlobals = class
  private
    function getautosavephotos: integer;
    procedure setautosavephotos(value: integer);
    function getphototype: integer;
  public
    property maxautosavephotos: integer read getautosavephotos write setautosavephotos;
    property phototype: integer read getphototype;

  end;

  TPetzRect = record
    x1, y1, x2, y2: integer;
    constructor create(px1, py1, px2, py2: integer);
    class operator add(a, b: TPetzRect): TPetzRect;
    class operator equal(a, b: TPetzRect): bool;
  end;

  TPetzSHLGlobals = class
  private
    function getadoptername: ansistring;
    function getphotopet: TPetzPetSprite;
    procedure setadoptername(const Value: ansistring);
    function getdimensions: tpetzrect;
    function getphotohasbg: boolean;
    function getpickapetmenu: hmenu;
  public
    function mainwindow: hwnd;
    property adoptername: ansistring read getadoptername write setadoptername;
    property photopet: TPetzPetSprite read getphotopet;
    property dimensions: tpetzrect read getdimensions;
    property photohasbg: boolean read getphotohasbg;
    property pickapetmenu: hmenu read getpickapetmenu;
  end;

  TChangetype = (ctCreate, ctDestroy);
  TOnClassChangeEvent = procedure(changetype: tchangetype; classname: tpetzclassname; instance: TPetzClassInstance) of object;
  TPetzClassesMan = class
  private
    finstances: tobjectlist;
    fhooks: tobjectlist;
    fonclasschange: tonclasschangeevent;
    procedure constructorhook(injectpoint: pointer; eax, ecx, edx, esi: pointer);
    procedure destructorhook(injectpoint: pointer; eax, ecx, edx, esi: pointer);
  public
    procedure hookclass(con, des: pointer; classname: tpetzclassname); overload;
    procedure hookclass(con, des, conres, desres: pointer; classname: TPetzClassName; conreg: tregistername = rneax; desreg: TRegisterName = rnecx); overload;
    function count: integer;
    function countinstances(classname: tpetzclassname): integer;
    procedure findclassinstances(classname: tpetzclassname; list: tobjectlist);
    function findclassinstance(classname: tpetzclassname): tpetzclassinstance;
    function classinstancetype(instance: pointer): TPetzClassName;
    constructor create;
    destructor Destroy; override;
    property onClassChange: tonclasschangeevent read fonclasschange write fonclasschange;
  end;

  TPetzCase = class
  private
    function getbuttonindex: integer;
    procedure setbuttonindex(const Value: integer);
    public
      procedure loadpetz(sessionid: ushort; buttonidx: integer);
      property buttonindex: integer read getbuttonindex write setbuttonindex;
  end;

  TPetzPRect = ^TPetzRect;

  TPetzDrawport = class
  private
    function getbits: pbyte;
    function getnumbits: cardinal;
    function getbounds: TPetzRect;
    function getrowwidth: cardinal;
    function gethibits: pinteger;
  public
    property bits: pbyte read getbits;
    property hibits: pinteger read gethibits;
    property numbits: cardinal read getnumbits;
    property bounds: TPetzRect read getbounds;
    property rowwidth: cardinal read getrowwidth;
    procedure Destroy();
    procedure SetOrigin(x, y: integer);
    procedure FillTransparent(bounds: TPetzPRect; color: byte);
    procedure CopyBitsTransparentMask(dstport: TPetzDrawport; psrcrect, pdstrect: TPetzPRect; maskvalue: integer);
    procedure CopyBits(dstport: TPetzDrawport; psrcrect, pdstrect: TPetzPRect);
    procedure Copy8BitCustom(prect, maskprect: TPetzPRect; maskdrawport: TPetzDrawport; forphoto: boolean = false);
    class function MakeNew(bounds: TPetzPRect; circledraw, locolor, hicolor: bool): TPetzDrawport;
  end;

  TPetzStage = class
  private
    function getactivedrawport: TPetzDrawport;
  public
    property activedrawport: TPetzDrawport read getactivedrawport;
  end;

  TPetzWinMenu = class
  private
    function getmenuitemcount: integer;
    function getrectcount: integer;
    procedure setrectcount(const Value: integer);
    function getmenuitem(index: integer): pmenuiteminfoa;
    function getmainwindow: hwnd;
    function getselectedidx: integer;
    function getwidth: integer;
    procedure setwidth(const Value: integer);
    function getrect(index: integer): tpetzprect;
    function getdrawrect: tpetzprect;
    function getrectfirst: integer;
    function gethwnd: hwnd;
    procedure setrectfirst(const Value: integer);
  public
    property menuitemcount: integer read getmenuitemcount;
    property rectfirst: integer read getrectfirst write setrectfirst;
    property rectcount: integer read getrectcount write setrectcount;
    property menuitems[index: integer]: pmenuiteminfoa read getmenuitem;
    property mainwindow: hwnd read getmainwindow;
    property selectedidx: integer read getselectedidx;
    property width: integer read getwidth write setwidth;
    property rects[index: integer]: tpetzprect read getrect;
    property drawrect: tpetzprect read getdrawrect;
    procedure measuremenu;
  end;

  TPetzMenuStruct = record
    sz: integer;
    mask: integer;
    wid: integer;
    disabled: integer;
    flags: integer;
    unknown: integer;
    hdc: hdc;
    rect: trect;
  end;

  PPetzMenuStruct = ^TPetzMenuStruct;

(*procedure mypetzapp_dodrawframe(ecx: pointer); stdcall;*)
procedure createmainwindow(return, instance: pointer); stdcall;
procedure mypetzapp_dodrawframe(return, instance: pointer); stdcall;

function classprop(inst: pointer; prop: longword): pointer;

function petzdlgglobals: Tpetzdlgglobals;
function petzshlglobals: tpetzshlglobals;
function petzcurrentarea: pointer;
function petzoberon: pointer;
function petzcase: TPetzCase;
function petzapp: TPetzPetzApp;
function getxscreen: pointer;
function getxstage: pointer;
procedure mydrawtext(xstage, xdrawport: pointer; text: ansistring; x, y: integer; forecolour, backcolour: integer; size: integer);

type TRPetzApp = record
    drawready, petmodule: integer;
  end;

var petzclassesman: tpetzclassesman;

implementation
uses dllformunit, petzcommon1, petzaunit, ansistrings;

function tpetzpetzapp.getpetmodule: tpetzpetmodule;
begin
  if cpetzver = pvpetz3 then
    result := ppointer(classprop(self, $10))^
  else
    result := ppointer(classprop(self, $1C))^;
end;

procedure tpetzpetzapp.setpetmodule(value: tpetzpetmodule);
begin
if cpetzver = pvpetz3 then
    ppointer(classprop(self, $10))^ := value
  else
    ppointer(classprop(self, $1C))^ := value;
end;

function tpetzpetzapp.getdrawready: integer;
begin
  if cpetzver = pvpetz3 then
    result := pinteger(classprop(self, $4))^
  else
    result := pinteger(classprop(self, $10))^;
end;

procedure tpetzpetzapp.setdrawready(value: integer);
begin
  if cpetzver = pvpetz3 then
    pinteger(classprop(self, $4))^ := value
  else
    pinteger(classprop(self, $10))^ := value;
end;

function tpetzpetzapp.getaccel: haccel;
begin
  case cpetzver of
    pvpetz5: result := plongword(classprop(self, $40))^;
  else raise exception.create('TPetzPetzApp:Getaccel - Not supported!');
  end;
end;

function tpetzspriteadpt.getpetslot: integer;
begin
  case cpetzver of
    pvPetz5: result := pinteger(classprop(self, $3D04))^;
    pvPetz4: result := pinteger(classprop(self, $3D0C))^;
    pvPetz3: result := pinteger(classprop(self, $3BF4))^;
    pvpetz3german: Result := pinteger(classprop(self, $3CF4))^;
  else raise exception.create('TPetzSpriteAdpt:Getpetslot - Not supported!');
  end;
end;

procedure tpetzspriteadpt.setpetslot(value: integer);
begin
  case cpetzver of
    pvpetz5: pinteger(classprop(self, $3D04))^ := value;
    pvpetz4: pinteger(classprop(self, $3D0C))^ := value;
    pvpetz3: pinteger(classprop(self, $3BF4))^ := value;
    pvpetz3german: pinteger(classprop(self, $3CF4))^ := value;
  else raise exception.create('TPetzSpriteAdpt:Setpetslot - Not supported!');
  end;
end;

function TPetzAlposprite.getloadinfo: TPetzLoadInfo;
begin
  result := TPetzLoadInfo(classprop(self, $3698));
end;

function TPetzAlposprite.isthisapet: boolean;
begin
  result := bool(Thiscall(self, rimports.alposprite_isthisapet, [cardinal(self)]));
end;

function tpetzancestryinfo.getadoptiondate: tdatetime;
begin
  result := encodedate(1970, 1, 1) + (plongword(ptr(integer(self) + $14))^ / secsperday);
end;

procedure tpetzancestryinfo.setadoptiondate(value: tdatetime);
begin
  plongword(ptr(integer(self) + $14))^ := round((value - encodedate(1970, 1, 1)) * secsperday);
end;

function TPetzAncestryInfo.getisfemale: boolean;
begin
  result := pbyte(ptr(integer(Self) + $20))^ <> 0;
end;

procedure TPetzAncestryInfo.setisfemale(value: boolean);
begin
  if value then
    pbyte(ptr(integer(Self) + $31))^ := 1 else
    pbyte(ptr(integer(Self) + $31))^ := 0;
end;


function tpetzancestryinfo.getname: ansistring;
var p: PAnsiChar;
begin
  p := PAnsiChar(ptr(integer(self) + $8)^);
  result := p;
end;

procedure tpetzancestryinfo.setname(value: ansistring);
begin
  thiscall(self, rimports.ancestryinfo_setname, [cardinal(PAnsiChar(value))]);
end;

function tpetzancestryinfo.getbreed: ansistring;
var p: PAnsiChar;
begin
  p := PAnsiChar(ptr(integer(self) + $C)^);
  result := p;
end;

procedure tpetzancestryinfo.setbreed(value: ansistring);
begin
  thiscall(self, rimports.ancestryinfo_setbreed, [cardinal(PAnsiChar(value))]);
end;


function tpetzancestryinfo.getadopter: ansistring;
var p: PAnsiChar;
begin
  p := PAnsiChar(ptr(integer(self) + $10)^);
  result := p;
end;

procedure tpetzancestryinfo.setadopter(value: ansistring);
begin
  thiscall(self, rimports.ancestryinfo_setadopter, [cardinal(PAnsiChar(value))]);
end;


procedure tpetzancestryinfo.setfathertree(value: tpetzancestryinfo);
begin
  ppointer(ptr(integer(self) + 4))^ := value;
end;

function tpetzancestryinfo.getfathertree: tpetzancestryinfo;
begin
  result := ppointer(ptr(integer(self) + 4))^;
end;

procedure tpetzancestryinfo.setmothertree(value: tpetzancestryinfo);
begin
  ppointer(self)^ := value;
end;

function tpetzancestryinfo.getmothertree: tpetzancestryinfo;
begin
  result := ppointer(self)^;
end;

class function tpetzancestryinfo.create: tpetzancestryinfo;
var p: pointer;
begin
  case cpetzver of
    pvpetz4, pvpetz5, pvpetz3, pvpetz3german: begin
        p := tpetzancestryinfo(rimports.petzallocmem(52));
        result := pointer(thiscall(p, rimports.ancestryinfo_create, []));
      end;
  else begin
      showmessage('TPetzAncestryInfo:Create - Not supported!');
      result := nil;
    end;
  end;
end;

procedure tpetzancestryinfo.streamout(stream: tstream);
begin
{:004EF320 ; public: void __thiscall AncestryInfo::StreamOut(class ostream &)const
.text:004EF320                 public ?StreamOut@AncestryInfo@@QBEXAAVostream@@@Z
.text:004EF320 ?StreamOut@AncestryInfo@@QBEXAAVostream@@@Z proc near
.text:004EF320                                         ; CODE XREF: PetzInfo::StreamOut(ostream &)+111p
.text:004EF320                                         ; PetzInfo::StreamOut(ostream &)+18Ep ...
.text:004EF320
.text:004EF320 var_5           = dword ptr -5
.text:004EF320 arg_0           = dword ptr  4
.text:004EF320
.text:004EF320                 sub     esp, 8
.text:004EF323                 push    ebx
.text:004EF324                 mov     ebx, ds:?write@ostream@@QAEAAV1@PBDH@Z ; ostream::write(char const *,int)
.text:004EF32A                 push    ebp
.text:004EF32B                 mov     ebp, [esp+10h+arg_0]
.text:004EF32F                 push    esi
.text:004EF330                 mov     esi, ecx
.text:004EF332                 push    edi}

  stream.write(plongword(ptr(integer(self) + $1C))^, 16);

{.text:004EF33D                 mov     edi, [esi+8]
.text:004EF340                 test    edi, edi
.text:004EF342                 jz      short loc_4EF354
.text:004EF344                 or      ecx, 0FFFFFFFFh
.text:004EF347                 xor     eax, eax
.text:004EF349                 repne scasb
.text:004EF34B                 not     ecx
.text:004EF34D                 dec     ecx
.text:004EF34E                 mov     [esp+18h+var_5+1], ecx
.text:004EF352                 jmp     short loc_4EF35C
.text:004EF354 ; ---------------------------------------------------------------------------
.text:004EF354
.text:004EF354 loc_4EF354:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+22j
.text:004EF354                 mov     [esp+18h+var_5+1], 0
.text:004EF35C
.text:004EF35C loc_4EF35C:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+32j
.text:004EF35C                 lea     ecx, [esp+18h+var_5+1]
.text:004EF360                 push    4
.text:004EF362                 push    ecx
.text:004EF363                 mov     ecx, ebp
.text:004EF365                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF367                 mov     eax, [esp+18h+var_5+1]
.text:004EF36B                 test    eax, eax
.text:004EF36D                 jle     short loc_4EF378
.text:004EF36F                 mov     edx, [esi+8]
.text:004EF372                 push    eax
.text:004EF373                 push    edx
.text:004EF374                 mov     ecx, ebp
.text:004EF376                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF378
.text:004EF378 loc_4EF378:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+4Dj
.text:004EF378                 mov     edi, [esi+0Ch]
.text:004EF37B                 test    edi, edi
.text:004EF37D                 jz      short loc_4EF38F
.text:004EF37F                 or      ecx, 0FFFFFFFFh
.text:004EF382                 xor     eax, eax
.text:004EF384                 repne scasb
.text:004EF386                 not     ecx
.text:004EF388                 dec     ecx
.text:004EF389                 mov     [esp+18h+var_5+1], ecx
.text:004EF38D                 jmp     short loc_4EF397
.text:004EF38F ; ---------------------------------------------------------------------------
.text:004EF38F
.text:004EF38F loc_4EF38F:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+5Dj
.text:004EF38F                 mov     [esp+18h+var_5+1], 0
.text:004EF397
.text:004EF397 loc_4EF397:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+6Dj
.text:004EF397                 lea     eax, [esp+18h+var_5+1]
.text:004EF39B                 push    4
.text:004EF39D                 push    eax
.text:004EF39E                 mov     ecx, ebp
.text:004EF3A0                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF3A2                 mov     eax, [esp+18h+var_5+1]
.text:004EF3A6                 test    eax, eax
.text:004EF3A8                 jle     short loc_4EF3B3
.text:004EF3AA                 mov     ecx, [esi+0Ch]
.text:004EF3AD                 push    eax
.text:004EF3AE                 push    ecx
.text:004EF3AF                 mov     ecx, ebp
.text:004EF3B1                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF3B3
.text:004EF3B3 loc_4EF3B3:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+88j
.text:004EF3B3                 mov     edi, [esi+10h]
.text:004EF3B6                 test    edi, edi
.text:004EF3B8                 jz      short loc_4EF3CA
.text:004EF3BA                 or      ecx, 0FFFFFFFFh
.text:004EF3BD                 xor     eax, eax
.text:004EF3BF                 repne scasb
.text:004EF3C1                 not     ecx
.text:004EF3C3                 dec     ecx
.text:004EF3C4                 mov     [esp+18h+var_5+1], ecx
.text:004EF3C8                 jmp     short loc_4EF3D2
.text:004EF3CA ; ---------------------------------------------------------------------------
.text:004EF3CA
.text:004EF3CA loc_4EF3CA:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+98j
.text:004EF3CA                 mov     [esp+18h+var_5+1], 0
.text:004EF3D2
.text:004EF3D2 loc_4EF3D2:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+A8j
.text:004EF3D2                 lea     edx, [esp+18h+var_5+1]
.text:004EF3D6                 push    4
.text:004EF3D8                 push    edx
.text:004EF3D9                 mov     ecx, ebp
.text:004EF3DB                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF3DD                 mov     eax, [esp+18h+var_5+1]
.text:004EF3E1                 test    eax, eax
.text:004EF3E3                 jle     short loc_4EF3EE
.text:004EF3E5                 push    eax
.text:004EF3E6                 mov     eax, [esi+10h]
.text:004EF3E9                 push    eax
.text:004EF3EA                 mov     ecx, ebp
.text:004EF3EC                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF3EE
.text:004EF3EE loc_4EF3EE:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+C3j
.text:004EF3EE                 lea     ecx, [esi+18h]
.text:004EF3F1                 push    4
.text:004EF3F3                 push    ecx
.text:004EF3F4                 mov     ecx, ebp
.text:004EF3F6                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF3F8                 lea     edx, [esi+14h]
.text:004EF3FB                 push    4
.text:004EF3FD                 push    edx
.text:004EF3FE                 mov     ecx, ebp
.text:004EF400                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF402                 lea     eax, [esi+2Ch]
.text:004EF405                 push    4
.text:004EF407                 push    eax
.text:004EF408                 mov     ecx, ebp
.text:004EF40A                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF40C                 mov     al, [esi+30h]
.text:004EF40F                 mov     byte ptr [esp+18h+var_5], 0
.text:004EF414                 test    al, al
.text:004EF416                 jz      short loc_4EF41D
.text:004EF418                 mov     byte ptr [esp+18h+var_5], 1
.text:004EF41D
.text:004EF41D loc_4EF41D:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+F6j
.text:004EF41D                 mov     al, [esi+31h]
.text:004EF420                 test    al, al
.text:004EF422                 jz      short loc_4EF429
.text:004EF424                 or      byte ptr [esp+18h+var_5], 2
.text:004EF429
.text:004EF429 loc_4EF429:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+102j
.text:004EF429                 lea     ecx, [esp+18h+var_5]
.text:004EF42D                 push    1
.text:004EF42F                 push    ecx
.text:004EF430                 mov     ecx, ebp
.text:004EF432                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF434                 mov     edi, [esi]
.text:004EF436                 lea     eax, [esp+18h+arg_0]
.text:004EF43A                 test    edi, edi
.text:004EF43C                 setnz   dl
.text:004EF43F                 push    1
.text:004EF441                 push    eax
.text:004EF442                 mov     ecx, ebp
.text:004EF444                 mov     byte ptr [esp+20h+arg_0], dl
.text:004EF448                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF44A                 mov     al, byte ptr [esp+18h+arg_0]
.text:004EF44E                 test    al, al
.text:004EF450                 jz      short loc_4EF45A
.text:004EF452                 mov     ecx, [esi]
.text:004EF454                 push    ebp
.text:004EF455                 call    ?StreamOut@AncestryInfo@@QBEXAAVostream@@@Z ; AncestryInfo::StreamOut(ostream &)
.text:004EF45A
.text:004EF45A loc_4EF45A:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+130j
.text:004EF45A                 mov     edi, [esi+4]
.text:004EF45D                 lea     edx, [esp+18h+arg_0]
.text:004EF461                 test    edi, edi
.text:004EF463                 setnz   cl
.text:004EF466                 mov     byte ptr [esp+18h+arg_0], cl
.text:004EF46A                 push    1
.text:004EF46C                 push    edx
.text:004EF46D                 mov     ecx, ebp
.text:004EF46F                 call    ebx ; ostream::write(char const *,int) ; ostream::write(char const *,int)
.text:004EF471                 mov     al, byte ptr [esp+18h+arg_0]
.text:004EF475                 test    al, al
.text:004EF477                 jz      short loc_4EF482
.text:004EF479                 mov     ecx, [esi+4]
.text:004EF47C                 push    ebp
.text:004EF47D                 call    ?StreamOut@AncestryInfo@@QBEXAAVostream@@@Z ; AncestryInfo::StreamOut(ostream &)
.text:004EF482
.text:004EF482 loc_4EF482:                             ; CODE XREF: AncestryInfo::StreamOut(ostream &)+157j
.text:004EF482                 pop     edi
.text:004EF483                 pop     esi
.text:004EF484                 pop     ebp
.text:004EF485                 pop     ebx
.text:004EF486                 add     esp, 8
.text:004EF489                 retn    4
                             }
end;

function tpetzdlgglobals.getautosavephotos: integer;
begin
  case cpetzver of
    pvpetz5,pvpetz4: result := pinteger(classprop(self, $2C))^;
  else raise exception.create('Not supported');
  end;
end;

function TPetzDLGGlobals.getphototype: integer;
begin
  case cpetzver of
    pvpetz4: result := pinteger(classprop(self, $38))^;
    pvpetz3: result := pinteger(classprop(self, $34))^;
  else raise exception.Create('Not supported');
  end;
end;

procedure tpetzdlgglobals.setautosavephotos(value: integer);
begin
  case cpetzver of
    pvpetz5,pvpetz4: pinteger(classprop(self, $2C))^ := value;
  else raise exception.create('SetAutoSavePhotos - Not supported!');

  end;
end;

function TPetzSHLGlobals.getadoptername: ansistring;
begin
  result := pansichar(classprop(self, $240));
end;

function TPetzSHLGlobals.getdimensions: tpetzrect;
begin
  result := tpetzprect(classprop(self, 648))^;
end;

function TPetzSHLGlobals.getphotohasbg: boolean;
begin
  case cpetzver of
    pvpetz4: result := pboolean(classprop(self, $379))^;
    else result := false;
  end;
end;

function TPetzSHLGlobals.getphotopet: TPetzPetSprite;
begin
  case cpetzver of
    pvpetz4,pvpetz3: result := TPetzPetSprite(classprop(self, $2c8)^)
  end;
end;

function TPetzSHLGlobals.getpickapetmenu: hmenu;
begin
  result := hmenu(classprop(self, $6e0)^);
end;

function tpetzshlglobals.mainwindow: hwnd;
type phwnd = ^hwnd;
begin
  result := 0;
  case cpetzver of
    pvpetz2: result := phwnd(ptr(integer(self) + $630))^;
    pvpetz3, pvpetz3german, pvpetz4: result := phwnd(ptr(integer(self) + $4CC))^;
    pvpetz5: result := phwnd(ptr(integer(self) + $544))^;
    pvbabyz: result := phwnd(ptr(integer(self) + $7F4))^;
  else showmessage('TPetzSHLGlobals:MainWindow - Not supported!');
  end;
end;

procedure TPetzSHLGlobals.setadoptername(const Value: ansistring);
begin
  ansistrings.strpcopy(pansichar(classprop(self, $240)), value);
end;

function petzdlgglobals: Tpetzdlgglobals;
begin
  case cpetzver of
   pvpetz5: result := TPetzDLGGlobals(rimports.get_dlgglobals);
   pvpetz4: result := TPetzDLGGlobals(ppointer($6371A0)^);
   pvpetz3: result := TPetzDLGGlobals(ppointer($639228)^);
   else raise exception.create('GetPetzDlgGlobals - Not supported!');
  end;
end;

function petzshlglobals: TPetzSHLGlobals;
begin
  result := nil;
  case cpetzver of
    pvPetz2: result := TPetzSHLGlobals(ppointer(ptr($503D18))^);
    pvPetz3: result := TPetzSHLGlobals(ppointer(ptr($639220))^);
    pvPetz3german: result := TPetzSHLGlobals(ppointer(ptr($639420))^);
    pvPetz4: result := TPetzSHLGlobals(ppointer(ptr($637198))^);
    pvPetz5: result := TPetzSHLGlobals(ppointer(ptr($668A80))^);
    pvBabyz: result := TPetzSHLGlobals(ppointer(ptr($7C4858))^);
  else showmessage('PetzSHLGlobals: Not supported!');
  end;
end;

function petzapp: TPetzPetzApp;
begin
  case cpetzver of
    pvpetz5: result := ppointer($6587C0)^;
  else raise exception.create('Petzapp: Not supported!');
  end;
end;

function petzoberon: pointer;
begin
  case cpetzver of
    pvPetz5: result := ptr($66A810);
    pvPetz4: result := ptr($638fd0);
    pvBabyz: result := ptr($7C7410);
  else begin
      showmessage('PetzOberon: Not supported!');
      result := nil;
    end;
  end;
end;

function petzcase: TPetzCase;
begin
  result := TPetzCase(ppointer(ptr($0063930c))^);
end;

function petzcurrentarea: pointer;
begin
  result := ppointer(ptr($66A820))^;
end;

function classprop(inst: pointer; prop: longword): pointer;
begin
  result := ptr(cardinal(inst) + prop);
end;

function removeext(const s: string): string;
begin
  result := copy(s, 1, pos('.', s) - 1);
end;

procedure mydrawtext(xstage, xdrawport: pointer; text: ansistring; x, y: integer; forecolour, backcolour: integer; size: integer);
var r: trect;
begin
  r.left := x;
  r.right := x + 100;
  r.top := y;
  r.bottom := y + 50;


  thiscall(xdrawport, rimports.xdrawport_xdrawtext, [cardinal(PAnsiChar(text)), cardinal(@r), 0, cardinal(-1), 0, cardinal(size), 0]);
  r.left := r.left - 1;
  r.top := r.top - 1;
  thiscall(xdrawport, rimports.xdrawport_xdrawtext, [cardinal(PAnsiChar(text)), cardinal(@r), 255, cardinal(-1), 0, cardinal(size), 0]);
  thiscall(xstage, rimports.xstage_setdirty, [cardinal(@r), cardinal(false)]);
end;

procedure drawpetnametags(xstage, xdrawport: pointer);
var r: trect;
  list: tobjectlist;
  t1: integer;
  pet: tpetzpetsprite;
begin
  list := tobjectlist.create(false);
  try
    petzclassesman.findclassinstances(cnpetsprite, list);

    for t1 := 0 to list.count - 1 do begin
      pet := tpetzpetsprite(tpetzclassinstance(list[t1]).instance);
      r := prect(thiscall(pet, rimports.alposprite_getgrabrect, []))^;
      mydrawtext(xstage, getxscreen, pet.name, r.left - 10, r.top - 10, 255, -1, -16);
    end;
  finally
    list.free;
  end;

end;

function getxstage: pointer;
begin
  case cpetzver of
    pvpetz5: result := ppointer(ptr($668E30))^;
    pvbabyz: result := ppointer(ptr($7C4C48))^;
    pvpetz4: result := rimports.g_stage^;
    pvpetz3: result := ppointer(ptr($006395d0))^;
  else raise Exception.create('GetXStage::Not supported');
  end;
end;

function getxscreen: pointer;
begin
  case cpetzver of
    pvpetz4: result := ppointer(ptr($00631bc8))^;
    pvpetz5: result := ppointer(ptr($663500))^;
    pvpetz3: result := ppointer(ptr($633c18))^;
  end;
end;


procedure displayport(xdrawport: pointer; filename: string);
type tsize = record
    x, y: integer;
  end;
var bits: pbytearray;
  size: Tsize;
  depth: integer;
  stream: tmemorystream;
begin
  thiscall(xdrawport, rimports.xdrawport_enablehicolorbitmap, [1]);
  bits := pbytearray(thiscall(xdrawport, rimports.xdrawport_getbits, []));
  if bits = nil then begin
    showmessage('Doesn''t support highbits!');
    exit;
  end;

  thiscall(xdrawport, rimports.xdrawport_getsize, [cardinal(@size)]);
  depth := thiscall(xdrawport, rimports.xdrawport_getdepth, []);
  showmessage(inttostr(size.x) + ',' + inttostr(size.y) + ' ' + inttostr(depth));

  stream := tmemorystream.create;
  try
    stream.Write(bits^, size.x * size.y * (depth div 8));
    stream.savetofile(filename);
  finally
    stream.free;
  end;
end;

procedure mypetzapp_dodrawframe(return, instance: pointer); stdcall;
var xstage {, xsaveport, xtileport, xdrawport}: pointer;
  r: trect;
  petzapp: TPetzPetzApp;
begin
  petzapp := TPetzPetzApp(instance);

  if petzapp.drawready = 0 then begin

    thiscall(instance, rimports.petzapp_preparedrawframe, [1]);

    petzapp.drawready := 1; // we're busy drawing

    rimports.xdrawport_openscreendrawport;

    thiscall(petzapp.petmodule, rimports.petmodule_dodrawframe, []);

    r := rect(50, 50, 300, 300);

    xstage := getxstage;

    if xstage <> nil then begin
      //xsaveport := ppointer(ptr(cardinal(xstage) + $8))^;
      //xtileport := ppointer(ptr(cardinal(xstage) + $4))^; // tile port
     // xdrawport := ppointer(ptr(cardinal(xstage) + $0C))^; // tile port

      if (getxscreen <> nil) then begin
         //thiscall(xtileport, rimports.xdrawport_xfillrect, [cardinal(@r), 00000000]);
      if petza.shownametags then
        drawpetnametags(xstage, getxscreen);

{        if not notagain then begin
        displayport(xtileport,'c:\dumptile.raw');
        displayport(xsaveport,'c:\dumpsave.raw');
        displayport(getxscreen,'c:\dumpscreen.raw');
        notagain:=true;
        end;}
         //thiscall(xtileport,rimports.xdrawport_xdrawtext, [cardinal(PAnsiChar('Hello')),cardinal(@r),0,cardinal(-1),0,cardinal(-24),0]);

         //thiscall(xscreen, rimports.xdrawport_xfillrect, [cardinal(@r), 00000000]);
         //thiscall(xstage, rimports.xstage_copytileport, [cardinal(xscreen), cardinal(@r)]);
         //thiscall(xstage, rimports.xstage_copysaveport, [cardinal(xscreen), cardinal(@r)]);
      end;
    end;

    petzapp.drawready := byte(rimports.xdrawport_closescreendrawport);
  // did we succeed? We can fail if we are trying to close an already closed port
  end;
end;

procedure createmainwindow(return, instance: pointer); stdcall;
var filename: string;
  shlglobals: pointer;
  h: hwnd;
begin
{  ax := pword($63B064)^;
  mov     ebx, ecx
.text:00406001                 push    edi
.text:00406002                 mov     word ptr [esp+258h+String], ax
.text:00406007                 mov     ecx, 48h
.text:0040600C                 xor     eax, eax
.text:0040600E                 lea     edi, [esp+12h]
.text:00406012                 rep stosd               ; Repeat until ECX=0: Store EAX at [EDI] every rep
.text:00406014                 stosw                   ; Store AX at [EDI]
}
  shlglobals := rimports.getshlglobals;
  case plongword(classprop(shlglobals, $278))^ of
    1: filename := 'Dogz 5.exe';
    0: filename := 'Catz 5.exe';
  else
    filename := 'Petz 5.exe';
  end;
 {.text:0040604D                 call    ?GetFilenameWOExtension@@YAPADPADPBD@Z ; GetFilenameWOExtension(char *,char const *)}

  h := CreateWindowExA(0, PAnsiChar($63ACCC), PAnsiChar(AnsiString(removeext(filename))), $2CF0000, 0, 0, $177, $12C, 0, hmenu(classprop(shlglobals, $538)^), hinst(classprop(shlglobals, $518)^), nil);
  plongword(classprop(shlglobals, $544))^ := h;
  plongword(classprop(shlglobals, $540))^ := plongword(classprop(shlglobals, $544))^;
  setwindowlonga(plongword(classprop(shlglobals, $544))^, integer($0FFFFFFEB), $3ACBBCA3);

  Thiscall(shlglobals, rimports.shlglobals_setshlrect, [cardinal(rimports.getshlglobals) + $29C]);

{ text:004060EE                 lea     edi, [esp+258h+WindowName]
.text:004060F5                 or      ecx, 0FFFFFFFFh
.text:004060F8                 xor     eax, eax
.text:004060FA                 lea     edx, [esp+258h+String]
.text:004060FE                 repne scasb
.text:00406100                 not     ecx
.text:00406102                 sub     edi, ecx
.text:00406104                 mov     esi, edi
.text:00406106                 mov     ebp, ecx
.text:00406108                 mov     edi, edx
.text:0040610A                 or      ecx, 0FFFFFFFFh
.text:0040610D                 repne scasb
.text:0040610F                 mov     ecx, ebp
.text:00406111                 dec     edi
.text:00406112                 shr     ecx, 2
.text:00406115                 rep movsd
.text:00406117                 mov     ecx, ebp
.text:00406119                 lea     eax, [esp+258h+String]
.text:0040611D                 and     ecx, 3
.text:00406120                 push    eax             ; lpString
.text:00406121                 rep movsb
.text:00406123                 mov     ecx, [ebx+3Ch]
.text:00406126                 push    ecx             ; hWnd
.text:00406127                 call    ds:SetWindowTextA ; Change the text of the window's title bar}
end;

function tpetzpetinfo.getancestryinfo: tpetzancestryinfo;
begin
  case cpetzver of
    pvpetz5: result := ppointer(ptr(integer(self) + $5BBB4))^;
    pvpetz4, pvpetz3, pvpetz3german: result := ppointer(ptr(integer(self) + $5BBA4))^;
  else begin
      result := nil;
      showmessage('TPetzPetInfo:Getancestryinfo - Not supported!');
    end;
  end;
end;

function TPetzPetinfo.getcomment: pointer;
begin
  case cpetzver of
    pvpetz5: result := pointer(classprop(self, $5bbbc)^);
    pvpetz4, pvpetz3: result := pointer(classprop(self, $5bbac)^);
  else begin
    result := nil;
    showmessage('TPetzPetInfo:GetComment - Not supported!');
  end;
  end;
end;

procedure tpetzpetinfo.setancestryinfo(value: tpetzancestryinfo);
begin
  case cpetzver of
    pvpetz5: ppointer(ptr(integer(self) + $5BBB4))^ := value;
    pvpetz4, pvpetz3, pvpetz3german: ppointer(ptr(integer(self) + $5BBA4))^ := value;
  else
    showmessage('TPetzPetInfo:Getancestryinfo - Not supported!');
  end;

end;

function tpetzpetinfo.getneutered: boolean;
begin
  case cpetzver of
    pvpetz5: result := pbytebool(integer(self) + $5BBB1)^;
    pvpetz4, pvpetz3, pvpetz3german: result := pbytebool(integer(self) + $5BBA1)^;
  else begin
      showmessage('Getneutered: Unsupported!');
      result := false;
    end;
  end;
end;

procedure tpetzpetinfo.setneutered(value: boolean);
begin
  case cpetzver of
    pvpetz5: pbytebool(integer(self) + $5BBB1)^ := value;
    pvpetz4, pvpetz3, pvpetz3german: pbytebool(integer(self) + $5BBA1)^ := value;
  else begin
      showmessage('Setneutered: Unsupported!');
    end;
  end;
end;

procedure tpetzpetinfo.setfemale(value: boolean);
begin
  case cpetzver of
    pvPetz5: pbytebool(integer(self) + $5BBB0)^ := value;
    pvPetz4: pbytebool(integer(self) + $5BBA0)^ := value;
    pvPetz3, pvpetz3german: pbytebool(integer(self) + $5BBA0)^ := value;
    pvBabyz: pbytebool(integer(self) + $953D8)^ := value;
  else begin
      showmessage('Setfemale: Unsupported!');
    end;
  end;

  if ancestryinfo <> nil then begin
    ancestryinfo.isfemale := value;
  end;
end;

function tpetzpetinfo.getfemale: boolean;
begin
  case cpetzver of
    pvPetz5: result := pbytebool(integer(self) + $5BBB0)^;
    pvpetz4: result := pbytebool(integer(Self) + $5BBA0)^;
    pvpetz3, pvpetz3german: result := pbytebool(integer(Self) + $5BBA0)^;
    pvBabyz: result := pbytebool(integer(self) + $953D8)^;
  else begin
      showmessage('Isfemale: Unsupported!');
      result := false;
    end;
  end;
end;

function TPetzPetinfo.getheadshot: pointer;
begin
  result := ppointer(classprop(self, $1404))^;
end;

function tpetzpetinfo.conceivetime: longword;
begin
  case cpetzver of
    pvpetz5: result := plongword(integer(self) + $5BB98)^;
    pvpetz3, pvpetz4, pvpetz3german: result := plongword(integer(self) + $5BB94)^;
  else begin
      showmessage('Conceivetime: Unsupported!');
      result := 0;
    end;
  end;
end;

function tpetzpetinfo.pregnant: boolean;
begin
  case cpetzver of
    pvpetz5: result := pbyte(integer(self) + $5BB90)^ > 0;
    pvpetz4, pvpetz3, pvpetz3german: result := pbyte(integer(self) + $5BB8C)^ > 0;
  else begin
      showmessage('Pregnant: Unsupported!');
      result := false;
    end;
  end;
end;

function tpetzpetsprite.GoalManager: pointer;
begin
  case cpetzver of
    pvpetz5: result := ppointer(integer(self) + $3D50)^;
  else begin
      showmessage('TPetzPetSprite[GoalManager] - Unsupported!');
      result := nil;
    end;
  end;
end;

function tpetzpetsprite.scriptstack: pointer;
begin
  case cpetzver of
    pvpetz5: result := ppointer(integer(self) + $3418)^;
  else begin
      showmessage('TPetzPetSprite[Scriptstack] - Unsupported!');
      result := nil;
    end;
  end;
end;

function tpetzpetsprite.isbehindpetdoor: boolean;
begin
  result := False;
  if not assigned(rimports.petsprite_getisbehindpetdoor) then
    showmessage('Isbehindpetdoor: Not implemented!') else
    result := Bool(Thiscall(self, rimports.petsprite_getisbehindpetdoor, []));
end;

function tpetzpetsprite.isdependent: boolean;
begin
  result := false;
  if not assigned(rimports.petsprite_getisdependent) then
    showmessage('Getisdependent: Not supported!') else
    result := bytebool(thiscall(self, rimports.petsprite_getisdependent, []));
end;

function tpetzpetsprite.petinfo: tpetzpetinfo;
type ppointer = ^pointer;
begin
  case cpetzver of
    pvPetz5: result := tpetzpetinfo(ppointer(integer(self) + $4B64)^); // load petinfo pointer from ourselves
    pvPetz4: result := tpetzpetinfo(ppointer(integer(self) + $4B74)^);
    pvPetz3: result := tpetzpetinfo(ppointer(integer(self) + $4A18)^);
    pvPetz3German: result := tpetzpetinfo(ppointer(integer(self) + $4B18)^);
    pvbabyz: result := tpetzpetinfo(ppointer(integer(self) + $53E4)^);
  else begin
      showmessage('Petinfo: Unsupported!');
      result := nil;
    end;
  end;
end;

procedure tpetzpetsprite.setstateflag(value: longword);
begin
  case cpetzver of
    pvpetz5: plongword(classprop(self, $4B90))^ := value;
    pvpetz4: plongword(classprop(self, $4BA0))^ := value;
    pvpetz3: plongword(classprop(self, $4A44))^ := value;
    pvpetz3german: plongword(classprop(self, $4B44))^ := value;
  else
    showmessage('Set state flag: Not supported!');
  end;
end;

function tpetzpetsprite.getstateflag: longword;
begin
  case cpetzver of
    pvpetz5: result := plongword(classprop(self, $4B90))^;
    pvpetz4: result := plongword(classprop(self, $4BA0))^;
    pvpetz3: result := plongword(classprop(self, $4A44))^;
    pvpetz3german: result := plongword(classprop(self, $4B44))^;
  else begin
      showmessage('Get state flag: Not supported!');
      result := 0;
    end;
  end;
end;

function TPetzPetSprite.getsessionid: ushort;
begin
  result := self.getloadinfo.sessionid;
end;

function tpetzpetsprite.getshoulddraw: boolean;
begin
//  result := bool(classprop(self, $491C));
end;

procedure tpetzpetsprite.setshoulddraw(value: boolean);
begin
  pboolean(classprop(self, $491C))^ := value;
end;

function tpetzpetsprite.getloadinfo: TPetzLoadInfo;
begin
  var internals := classprop(self, $3E08); // pointer to internals;
  var loadinfo := tpetzloadinfo(ppointer(classprop(internals, $12))^);
  var peep := loadinfo.getname;
  result := loadinfo;
end;

function tpetzpetsprite.getinteracting: TPetzPetsprite;
begin
  case cpetzver of
    pvpetz5: result := tpetzpetsprite(ppointer(classprop(self, $4B2C))^);
    pvPetz4: result := tpetzpetsprite(ppointer(classprop(self, $4B30))^);
    pvPetz3: result := tpetzpetsprite(ppointer(classprop(self, $49F4))^);
    pvPetz3german: result := tpetzpetsprite(ppointer(classprop(self, $4AF4))^);
  else begin
      showmessage('Get interacting: Not supported!');
      result := nil;
    end;
  end;
end;

procedure tpetzpetsprite.setinteracting(value: TPetzPetSprite);
begin
  case cpetzver of
    pvpetz5: ppointer(classprop(self, $4B2C))^ := value;
    pvpetz4: ppointer(classprop(self, $4B30))^ := value;
    pvpetz3: ppointer(classprop(self, $49F4))^ := value;
    pvpetz3german: ppointer(classprop(self, $4AF4))^ := value;
  else begin
      showmessage('Set interacting: Not supported!');
    end;
  end;
end;

function tpetzpetsprite.getbiorhythm(index: integer): integer;
begin
  result := thiscall(self, rimports.petsprite_getpetbiorhythm, [cardinal(self), index]);
end;

procedure tpetzpetsprite.setbiorhythm(index: integer; value: integer);
begin
  thiscall(self, rimports.petsprite_setpetbiorhythm, [cardinal(self), index, value]);
end;

procedure tpetzpetsprite.enterpetdoor;
begin
  Thiscall(self, rimports.petsprite_enterpetdoor, []);
end;

function tpetzpetsprite.name: ansistring;
var s: string;
  t1: integer;
begin
  case cpetzver of
    pvpetz5: begin
        s := PAnsiChar(ptr(integer(self) + $3439));
        if pos(' ', s) > 0 then begin
          for t1 := length(s) downto 1 do
            if s[t1] = ' ' then break;
          result := copy(s, 1, t1 - 1);
        end else
          result := s;
      end;
    pvpetz4: result := PAnsiChar(ptr(integer(self) + $369A));
    pvpetz3, pvpetz3german: result := PAnsiChar(ptr(integer(self) + $3686));
    pvpetz2: result := PAnsiChar(ptr(integer(self) + $15A));
    pvbabyz: result := PAnsiChar(ptr(integer(self) + $3E12));
  else begin
      result := '<not implemented>';
    end;
  end;

end;

function tpetzpetsprite.getid: smallint;
begin
  case cpetzver of
    pvpetz5: result := psmallint(integer(self) + $3694)^;
    pvpetz3, pvpetz3german: result := psmallint(integer(self) + $3684)^;
    pvpetz4: result := psmallint(integer(self) + $3698)^;
    pvbabyz: result := psmallint(integer(self) + $3E10)^;
    pvpetz2: result := 0;
  else begin
      showmessage('Id not implemented!');
      result := 0;
    end;
  end;
end;

procedure constructorhookproc(injectpoint: pointer; eax, ecx, edx, esi: longword);
begin
  petzclassesman.constructorhook(injectpoint, pointer(eax), pointer(ecx), pointer(edx), pointer(esi));
end;

procedure destructorhookproc(injectpoint: pointer; eax, ecx, edx, esi: longword);
begin
  petzclassesman.destructorhook(injectpoint, pointer(eax), pointer(ecx), pointer(edx), pointer(esi));
end;

function tpetzclassinstance.instance: pointer;
begin
  result := fcpointer;
end;

constructor tpetzclassinstance.create(cpointer: pointer);
begin
  fcpointer := cpointer;
end;

destructor tpetzclassinstance.destroy;
begin
  inherited;
end;

function tpetzclassesman.count: integer;
begin
  result := finstances.Count;
end;

procedure tpetzclassesman.destructorhook(injectpoint: pointer; eax, ecx, edx, esi: pointer);
var t1, t2: integer;
  cinst: TPetzClassInstance;
  instance: pointer;
begin
  for t1 := 0 to fhooks.count - 1 do
    if tpetzclasshook(fhooks[t1]).des = injectpoint then begin
      case tpetzclasshook(fhooks[t1]).desreg of
        rnEAX: instance := eax;
        rnESI: instance := esi;
        rnECX: instance := ecx;
      else begin
          showmessage('Invalid destructor register');
          instance := nil;
        end;
      end;
      for t2 := finstances.count - 1 downto 0 do
        if TPetzClassInstance(finstances[t2]).fcpointer = instance then begin
          cinst := TPetzClassInstance(finstances[t2]);
          if Assigned(fonclasschange) then
            fonclasschange(ctDestroy, cinst.classname, cinst);
          finstances.delete(t2);
          exit;
        end;
      exit;
    end;
end;

procedure tpetzclassesman.constructorhook(injectpoint: pointer; eax, ecx, edx, esi: pointer);
var t1: integer;
  cinst: TPetzClassInstance;
  instance: pointer;
begin
  for t1 := 0 to fhooks.count - 1 do
    if tpetzclasshook(fhooks[t1]).con = injectpoint then begin
      case tpetzclasshook(fhooks[t1]).conreg of
        rnEAX: instance := eax;
        rnESI: instance := esi;
        rnECX: instance := ecx;
      else begin
          showmessage('Invalid constructor register');
          instance := nil;
        end;
      end;
      cinst := TPetzClassInstance.create(instance);
      cinst.classname {tree} := tpetzclasshook(fhooks[t1]).classname {tree};
      finstances.add(cinst);
      if Assigned(fonclasschange) then
        fonclasschange(ctCreate, cinst.classname, cinst);
      exit;
    end;
  showmessage('Coulnd''t find constructor');
end;

function myconstructor(return, instance: pointer; arg: longword): pointer; stdcall;
var t1, t2: integer;
  cinst: TPetzClassInstance;
begin {Shouldn't really swallow exceptions: If a class can't be created, Petz NEEDS to know!}
  result := nil;
  for t1 := 0 to patches.count - 1 do
    if (patches[t1] is TPatchThiscall) and (tpatchthiscall(patches[t1]).oldaddress = return) then begin
      //Allow the class to be constructed and return for our calling code
      result := pointer(tpatchthiscall(patches[t1]).callorigproc(instance, [arg]));

      for t2 := 0 to petzclassesman.fhooks.count - 1 do
        if TPetzClassHook(petzclassesman.fhooks[t2]).con = return then begin
          cinst := TPetzClassInstance.create(result); // Used to be "Instance". Result should be better?
          cinst.classname := tpetzclasshook(petzclassesman.fhooks[t2]).classname;
          petzclassesman.finstances.add(cinst);
          if Assigned(petzclassesman.fonclasschange) then
            petzclassesman.fonclasschange(ctCreate, cinst.classname, cinst);
          exit;
        end;
    end;
  showmessage('Not found');
end;

procedure mydestructor(return, instance: pointer); stdcall;
var t1, t2: integer;
  cinst: TPetzClassInstance;
  cn: TPetzClassName;
begin
  for t1 := patches.count - 1 downto 0 do
    if (patches[t1] is TPatchThiscall) and (tpatchthiscall(patches[t1]).oldaddress = return) then begin
      tpatchthiscall(patches[t1]).callorigproc(instance, []);

      for t2 := petzclassesman.finstances.count - 1 downto 0 do
        if TPetzClassInstance(petzclassesman.finstances[t2]).instance = instance then begin
          cinst := TPetzClassInstance(petzclassesman.finstances[t2]);
          cn := cinst.classname;
          petzclassesman.finstances.delete(t2); //cinst now freed
          //DO NOT EXIT there may be more than one class to remove due to INHERITANCE! You fuckwit.
          if Assigned(petzclassesman.fonclasschange) then
            petzclassesman.fonclasschange(ctDestroy, cn, nil); //don't give cinst, don't want idiot code trying to use it
        end;
    end;
end;

procedure tpetzclassesman.hookclass(con, des: pointer; classname: tpetzclassname);
var hook: tpetzclasshook;
begin
  hook := TPetzClassHook.Create;
  hook.con := con;
  hook.des := des;
  hook.classname := classname;
  fhooks.add(hook);
  patchthiscall(con, @myconstructor);
  patchthiscall(des, @mydestructor);
end;

procedure tpetzclassesman.hookclass(con, des, conres, desres: pointer; classname: TPetzClassName; conreg: tregistername = rneax; desreg: TRegisterName = rnecx);
var hook: tpetzclasshook;
begin
  hook := TPetzClassHook.create;
  hook.con := con;
  hook.des := des;
  hook.conres := conres;
  hook.desres := desres;
  hook.conreg := conreg;
  hook.desreg := desreg;
  hook.classname := classname;
  fhooks.add(hook);
  patchgeneric(con, conres, constructorhookproc);
  patchgeneric(des, desres, destructorhookproc);
end;

function tpetzclassesman.countinstances(classname: tpetzclassname): integer;
var t1: integer;
  instance: TPetzClassInstance;
begin
  result := 0;
  for t1 := 0 to finstances.count - 1 do begin
    instance := TPetzClassInstance(finstances[t1]);
    if instance.classname = classname then inc(result);
  end;
end;

function tpetzclassesman.classinstancetype(instance: pointer): TPetzClassName;
var t1: integer;
begin
  result := cnAlposprite;
  for t1 := 0 to finstances.count - 1 do begin
    if TPetzClassInstance(finstances[t1]).instance = instance then begin
      result := TPetzClassInstance(finstances[t1]).classname;
      exit;
    end;
  end;
end;

procedure tpetzclassesman.findclassinstances(classname: tpetzclassname; list: tobjectlist);
var t1: integer;
  instance: TPetzClassInstance;
begin
  assert(list.count = 0);
  for t1 := 0 to finstances.count - 1 do begin
    instance := TPetzClassInstance(finstances[t1]);
    if instance.classname = classname then
      list.add(instance);
  end;
end;

function tpetzclassesman.findclassinstance(classname: tpetzclassname): TPetzClassInstance;
var t1: integer;
  instance: TPetzClassInstance;
begin
  result := nil;
  for t1 := 0 to finstances.count - 1 do begin
    instance := TPetzClassInstance(finstances[t1]);
    if instance.classname = classname then begin
      result := instance;
      exit;
    end;
  end;
end;

constructor tpetzclassesman.create;
begin
  finstances := tobjectlist.create;
  fhooks := tobjectlist.create;
  fonclasschange := nil;
end;

destructor tpetzclassesman.destroy;
begin
  finstances.free;
  fhooks.free;
end;

{ TPetzLoadInfo }

function TPetzLoadInfo.getname: ansistring;
begin
  var str: ansistring;
  setstring(str, pansichar(classprop(self, $2)), 256);
  result := str;
end;

function TPetzLoadInfo.getsessionid: ushort;
begin
  result := ushort(classprop(self, $0)^);
end;

function TPetzLoadInfo.getspriteindex: integer;
begin
  result := pinteger(classprop(self, $308))^;
end;

{ TPetzCase }

function TPetzCase.getbuttonindex: integer;
begin
  result := pinteger(classprop(petzcase, $3d2c))^;
end;

procedure TPetzCase.loadpetz(sessionid: ushort; buttonidx: integer);
begin
  self.buttonindex := buttonidx;
  thiscall(self, rimports.case_loadpetz, [sessionid, 1, 1, 1]);
end;

procedure TPetzAlposprite.setadjvalue(attr, val: integer);
begin
  thiscall(self, rimports.alposprite_setadjvalue, [cardinal(attr), cardinal(val)]);
end;

procedure TPetzCase.setbuttonindex(const Value: integer);
begin
  pinteger(classprop(petzcase, $3d2c))^ := value;
end;

{ TPetzStage }

function TPetzStage.getactivedrawport: TPetzDrawport;
begin
  result := TPetzDrawport(ppointer(classprop(self, 12))^);
end;

{ TPetzDrawport }

procedure TPetzDrawport.Copy8BitCustom(prect, maskprect: TPetzPRect; maskdrawport: TPetzDrawport; forphoto: boolean = false);
var bitsptr, maskbitsptr: pbyte;
var hibitsptr: pcardinal;
var color: cardinal;
var rgbpalette: pointer;
var height, width, rowbytes: integer;
var rect: TPetzRect;
var startpos, startposmask: integer;
var rawrowbytes, maskrawrowbytes: integer;
var palar: tgamepalette;
var outofbounds: boolean;
begin
  rect := prect^;
  height := rect.y2 - rect.y1;
  width := rect.x2 - rect.x1;
  rawrowbytes :=  pinteger(classprop(self, 28))^;
  maskrawrowbytes :=  pinteger(classprop(maskdrawport, 28))^;
  rowbytes := (rect.x1 - rect.x2) + rawrowbytes;
  var maskrowbytes := (maskprect.x1 - maskprect.x2) + maskrawrowbytes;

  startpos := ((bounds.y2 - rect.y2) * rawrowbytes) + rect.x1;
  outofbounds := false;
  if (maskdrawport.bounds.y1 - 128 > maskprect.y1) or (maskdrawport.bounds.x1 - 128 > maskprect.x1)
  or (maskdrawport.bounds.y2 + 128 < maskprect.y2) or (maskdrawport.bounds.x2 + 128 < maskprect.x2) then
    outofbounds := true;
  startposmask := ((maskdrawport.bounds.y2 - maskprect.y2) * maskrawrowbytes) + maskprect.x1;
  bitsptr := pbyte(cardinal(bits) + startpos);
  maskbitsptr := pbyte(cardinal(maskdrawport.bits) + startposmask);
  hibitsptr := pointer(cardinal(hibits) + startpos * 4);

  rgbpalette := ppointer($00630d58)^;

  if height > 0 then
    if width > 0 then begin
      for var y := 0 to height - 1 do begin
        for var x := 0 to width - 1 do begin
          if (bitsptr^ = 200) and forphoto and petza.transparentphotos and not petzshlglobals.photohasbg then
                hibitsptr^ := $fefefe
          else if bitsptr^ <> 253 then begin
            var maskcolor := 0;
            if not outofbounds then
              maskcolor := maskbitsptr^;
            if maskcolor = 0 then
              color := pinteger(cardinal(rgbpalette) + bitsptr^ * 4)^
            else begin
             var didgetpalette := palettes.TryGetValue(maskcolor, palar);
              if didgetpalette then
                color := palar[bitsptr^]
              else
                color := pinteger(cardinal(rgbpalette) + bitsptr^ * 4)^;
            end;
            hibitsptr^ := color;
          end;
          bitsptr := bitsptr + 1;
          maskbitsptr := maskbitsptr + 1;
          hibitsptr := pointer(cardinal(hibitsptr) + 4);
        end;
        bitsptr := bitsptr + rowbytes;
        hibitsptr := pointer(cardinal(hibitsptr) + rowbytes * 4);
        maskbitsptr := maskbitsptr + maskrowbytes;
      end;
    end;
end;

procedure TPetzDrawport.CopyBits(dstport: TPetzDrawport; psrcrect,
  pdstrect: TPetzPRect);
begin
  thiscall(self, ptr($004361a0), [cardinal(dstport), cardinal(psrcrect), cardinal(pdstrect), cardinal(0)]);
end;

procedure TPetzDrawport.CopyBitsTransparentMask(dstport: TPetzDrawport; psrcrect,
  pdstrect: TPetzPRect; maskvalue: integer);
var srcbits, dstbits: pbyte;
var srcsize, dstsize: TPetzRect;
var srcrect, dstrect: TPetzRect;
var srcrowwidth, dstrowwidth: integer;
begin
  srcsize := bounds;
  dstsize := dstport.bounds;

  srcrect := TPetzPRect(psrcrect)^;
  srcrect.x1 := srcrect.x1 + srcsize.x1;
  srcrect.x2 := srcrect.x2 + srcsize.x1;
  srcrect.y1 := srcrect.y1 + srcsize.y1;
  srcrect.y2 := srcrect.y2 + srcsize.y1;
  dstrect := TPetzPRect(pdstrect)^;
  dstrect.x1 := dstrect.x1 + dstsize.x1;
  dstrect.x2 := dstrect.x2 + dstsize.x1;
  dstrect.y1 := dstrect.y1 + dstsize.y1;
  dstrect.y2 := dstrect.y2 + dstsize.y1;

  if srcrect.x1 < 0 then begin
    dstrect.x1 := dstrect.x1 - srcrect.x1;
    srcrect.x1 := 0;
  end;
  if srcrect.y1 < 0 then begin
    dstrect.y1 := dstrect.y1 - srcrect.y1;
    srcrect.y1 := 0;
  end;
  if srcsize.x2 < srcrect.x2 then begin
    dstrect.x2 := dstrect.x2 + (srcsize.x2 - srcrect.x2);
    srcrect.x2 := srcsize.x2;
  end;
  if srcsize.y2 < srcrect.y2 then begin
    dstrect.y2 := dstrect.y2 + (srcsize.y2 - srcrect.y2);
    srcrect.y2 := srcsize.y2;
  end;

  if dstrect.x1 < 0 then begin
    srcrect.x1 := srcrect.x1 - dstrect.x1;
    dstrect.x1 := 0;
  end;
  if dstrect.y1 < 0 then begin
    srcrect.y1 := srcrect.y1 - dstrect.y1;
    dstrect.y1 := 0;
  end;
  if dstsize.x2 < dstrect.x2 then begin
    srcrect.x2 := srcrect.x2 + (dstsize.x2 - dstrect.x2);
    dstrect.x2 := dstsize.x2;
  end;
  if dstsize.y2 < dstrect.y2 then begin
    srcrect.y2 := srcrect.y2 + (dstsize.y2 - dstrect.y2);
    dstrect.y2 := dstsize.y2;
  end;

  srcrowwidth := rowwidth;
  dstrowwidth := dstport.rowwidth;

  var startpos := ((srcsize.y2 - srcrect.y2) * srcrowwidth) + srcrect.x1;

  srcbits := pbyte(cardinal(bits) + startpos);

  startpos := ((dstsize.y2 - dstrect.y2) * dstrowwidth) + dstrect.x1;

  dstbits := pbyte(cardinal(dstport.bits) + startpos);

  for var y := srcrect.y1 to srcrect.y2 - 1 do begin
    for var x := srcrect.x1 to srcrect.x2 - 1 do begin
    if srcbits^ <> 253 then
      if maskvalue <> -1 then
        dstbits^ := maskvalue
      else
        dstbits^ := srcbits^;
      dstbits := dstbits + 1;
      srcbits := srcbits + 1;
    end;
    srcbits := srcbits + (srcrowwidth - (srcrect.x2 - srcrect.x1));
    dstbits := dstbits + (dstrowwidth - (dstrect.x2 - dstrect.x1));
  end;
end;

class function TPetzDrawport.MakeNew(bounds: TPetzPRect; circledraw, locolor,
  hicolor: bool): TPetzDrawport;
begin
  var mem: TPetzDrawport;
  mem := rimports.petzallocmem(172);
  thiscall(mem, ptr($0045bbf0), []);
  thiscall(mem, ptr($0045bd40), [cardinal(bounds), cardinal(8), cardinal(circledraw), cardinal(locolor), cardinal(hicolor)]);
  result := mem;
end;

procedure TPetzDrawport.Destroy;
begin
  thiscall(self, ptr($0045bca0), []);
  rimports.petzdeletemem(self);
end;

procedure TPetzDrawport.FillTransparent(bounds: TPetzPRect; color: byte);
begin
  thiscall(self, ptr($00436e90), [cardinal(bounds), cardinal(color)]);
end;

function TPetzDrawport.getbits: pbyte;
begin
  result := ppointer(classprop(self, 148))^;
end;

function TPetzDrawport.getbounds: TPetzRect;
begin
  result := TPetzPRect(classprop(self, 12))^;
end;

function TPetzDrawport.gethibits: pinteger;
begin
  result := ppointer(classprop(self, 152))^;
end;

function TPetzDrawport.getnumbits: cardinal;
begin
  result := pcardinal(classprop(self, 32))^;
end;

function TPetzDrawport.getrowwidth: cardinal;
begin
  result := pcardinal(classprop(self, 28))^;
end;

procedure TPetzDrawport.SetOrigin(x, y: integer);
begin
  thiscall(self, ptr($00460740), [cardinal(x), cardinal(y)]);
end;

{ TPetzRect }

class operator TPetzRect.add(a, b: TPetzRect): TPetzRect;
var output: TPetzRect;
begin
  output.x1 := b.x1;
  if a.x1 <= b.x1 then
    output.x1 := a.x1;
  output.y1 := b.y1;
  if a.y1 <= b.y1 then
    output.y1 := a.y1;
  output.x2 := b.x2;
  if b.x2 <= a.x2 then
    output.x2 := a.x2;
  output.y2 := b.y2;
  if b.y2 <= a.y2 then
    output.y2 := a.y2;
  result := output;
end;

constructor TPetzRect.create(px1, py1, px2, py2: integer);
begin
  x1 := px1;
  x2 := px2;
  y1 := py1;
  y2 := py2;
end;

class operator TPetzRect.equal(a, b: TPetzRect): bool;
begin
  result := (a.x1 = b.x1) and (a.y1 = b.y1) and (a.x2 = b.x2) and (a.y2 = b.y2);
end;

{ TPetzWinMenu }

function TPetzWinMenu.getdrawrect: tpetzprect;
begin
  result := tpetzprect(classprop(self, $48));
end;

function TPetzWinMenu.gethwnd: hwnd;
begin
  result := hwnd(classprop(self, $38)^);
end;

function TPetzWinMenu.getmainwindow: hwnd;
begin
  result := hwnd(classprop(self, $34));
end;

function TPetzWinMenu.getmenuitem(index: integer): pmenuiteminfoa;
begin
  result := pmenuiteminfoa(cardinal(ppointer(classprop(self, $20))^) + (index * 44))
end;

function TPetzWinMenu.getmenuitemcount: integer;
begin
  result := pinteger(classprop(self, $24))^;
end;

function TPetzWinMenu.getrect(index: integer): tpetzprect;
begin
  var root := cardinal(ppointer(classprop(self, $1c)^));
  result := tpetzprect(root + (index * 16));
end;

function TPetzWinMenu.getrectcount: integer;
begin
  result := pinteger(classprop(self, $2c))^;
end;

function TPetzWinMenu.getrectfirst: integer;
begin
  result := pinteger(classprop(self, $28))^;
end;

function TPetzWinMenu.getselectedidx: integer;
begin
  result := pinteger(classprop(self, $40))^;
end;

function TPetzWinMenu.getwidth: integer;
begin
  result := pinteger(classprop(self, $30))^;
end;

procedure TPetzWinMenu.measuremenu;
begin
  thiscall(self, ptr($40a060), [cardinal(self.gethwnd)]);
  invalidaterect(gethwnd, nil, true);
  updatewindow(gethwnd);
end;

procedure TPetzWinMenu.setrectcount(const Value: integer);
begin
  pinteger(classprop(self, $2c))^ := value;
end;

procedure TPetzWinMenu.setrectfirst(const Value: integer);
begin
  pinteger(classprop(self, $28))^ := value;
end;

procedure TPetzWinMenu.setwidth(const Value: integer);
begin
  pinteger(classprop(self, $30))^ := value;
end;

end.
