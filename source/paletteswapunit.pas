unit paletteswapunit;

interface
uses petzpaletteunit, generics.collections, windows, graphics, math, system.SysUtils, system.IOUtils;

var palettes: TDictionary<byte, TgamePalette>;
var paletteindexes: TDictionary<string, byte>;
procedure loadpalettes;
function loadpetzpaletteifexists: tgamepalette;

implementation

function getgamepalettefrombmp(filepath: string): tgamepalette;
  var palette: tgamepalette;
  palettebmp: tbitmap;
  paletteentries: array[0..255] of tpaletteentry;
begin
  if not fileexists(filepath) then
    raise Exception.Create('Palette not found');
  palettebmp := tbitmap.Create;
  palettebmp.LoadFromFile(filepath);
  getpaletteentries(palettebmp.Palette, 0, 256, paletteentries);

  for var i := 0 to 255 do begin
    var color := paletteentries[i];
    palette[i] := color.peRed shl 16 + color.peGreen shl 8 + color.peBlue;
  end;

  result := palette;
end;

function loadpetzpaletteifexists: tgamepalette;
begin
  result := getgamepalettefrombmp(extractfilepath(ParamStr(0)) + 'resource/palettes/petz.bmp');
end;

procedure loadpalettes;
  var palettefiles: TArray<string>;
begin
  palettes := TDictionary<byte, TgamePalette>.Create();
  paletteindexes := TDictionary<string, byte>.Create();
  if not TDirectory.Exists(extractfilepath(ParamStr(0)) + 'resource/palettes') then
    exit;
  palettefiles := TDirectory.GetFiles(extractfilepath(ParamStr(0)) + 'resource/palettes', '*.bmp', TSearchOption.soAllDirectories);
  if length(palettefiles) > 255 then
    raise Exception.Create('You have more than 255 palettes!');
  var paletteindex := 1;
  for var palettepath in palettefiles do begin
    var palettename := tpath.GetFileNameWithoutExtension(extractfilename(palettepath));
    if palettename = 'petz' then
      continue;
    var thispalette := getgamepalettefrombmp(palettepath);
    palettes.AddOrSetValue(paletteindex, thispalette);
    paletteindexes.AddOrSetValue(palettename, paletteindex);
    paletteindex := paletteindex + 1;
  end;
end;

end.
