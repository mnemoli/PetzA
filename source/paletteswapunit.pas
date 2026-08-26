unit paletteswapunit;

interface
uses petzpaletteunit, generics.collections, windows, graphics, math, system.SysUtils, system.IOUtils;

// track palette index to actual palette and no. of pets using it
var palettes: TDictionary<byte, TPair<PGamePalette, integer>>;
// track palette name to palette index
var paletteindexes: TDictionary<ansistring, byte>;
function getpaletteindexfromfilename(filename: string): integer;
function loadpetzpaletteifexists: pgamepalette;
procedure removepaletteusage(filename: string);

implementation

function getpalettefrombmpinternal(filepath: string): pgamepalette;
  var palettebmp: tbitmap;
  paletteentries: array[0..255] of tpaletteentry;
begin
  if not fileexists(filepath) then
    raise Exception.Create('Palette not found');
  palettebmp := tbitmap.Create;
  palettebmp.LoadFromFile(filepath);
  getpaletteentries(palettebmp.Palette, 0, 256, paletteentries);

   var palette: pgamepalette;
   new(palette);

  for var i := 0 to 255 do begin
    var color := paletteentries[i];
    palette[i] := color.peRed shl 16 + color.peGreen shl 8 + color.peBlue;
  end;

  result := palette;
end;

function loadpalettefrombmp(filename: string): pgamepalette;
begin
  var filepath := extractfilepath(ParamStr(0)) + 'resource/palettes/' + filename + '.bmp';
  result := getpalettefrombmpinternal(filepath);
end;

function getpaletteindexfromfilename(filename: string): integer;
begin
  if paletteindexes.ContainsKey(filename) then begin
    result := paletteindexes[filename];
    var temp := palettes[result];
    temp.Value := temp.value + 1;
    palettes[result] := temp;
    exit;
  end;
  var freekey := -1;
  for var i := 1 to 255 do begin
    if not palettes.ContainsKey(i) then begin
      freekey := i;
      break;
    end;
  end;
  if freekey = -1 then begin
    result := -1;
    exit;
  end;

  var palette := loadpalettefrombmp(filename);
  paletteindexes.add(filename, freekey);
  palettes.Add(freekey, TPair<PGamePalette, integer>.Create(palette, 1));
  result := freekey;
end;

procedure removepaletteusage(filename: string);
begin
  if paletteindexes.ContainsKey(filename) then begin
    var idx := paletteindexes[filename];
    var numusages := palettes[idx];
    numusages.Value := numusages.value - 1;
    if numusages.value < 1 then begin
      var p := palettes[idx];
      dispose(p.Key);
      palettes.Remove(idx);
      paletteindexes.Remove(filename);
    end else begin
      palettes[idx] := numusages;
    end;
  end;
end;

function loadpetzpaletteifexists: pgamepalette;
begin
  result := loadpalettefrombmp('petz');
end;

end.
