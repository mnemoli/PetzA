unit paletteswapunit;

interface
uses petzpaletteunit, generics.collections, windows, graphics, math, system.SysUtils, system.IOUtils;

var palettes: TDictionary<byte, TgamePalette>;
var paletteindexes: TDictionary<string, byte>;
procedure loadpalettes;

implementation

procedure loadpalettes;
  var palettebmp: TBitmap;
  var fpal: plogpalette;
  var palettefiles: TArray<string>;
begin
  palettes := TDictionary<byte, TgamePalette>.Create();
  paletteindexes := TDictionary<string, byte>.Create();
  if not TDirectory.Exists(extractfilepath(ParamStr(0)) + '/palettes') then
    exit;
  getmem(fpal, sizeof(tlogpalette) + sizeof(tpaletteentry)*255);
  fpal.palNumEntries := 256;
  fpal.palVersion := $300;
  palettebmp := TBitmap.Create();
  palettefiles := TDirectory.GetFiles(extractfilepath(ParamStr(0)) + '/palettes', '*.bmp', TSearchOption.soAllDirectories);
  if length(palettefiles) > 256 then
    raise Exception.Create('You have more than 256 palettes!');
  for var i := 0 to length(palettefiles) - 1 do begin
    var thispalette: tgamepalette;
    palettebmp.LoadFromFile(palettefiles[i]);
    GetPaletteEntries(palettebmp.Palette, 0, 256, fpal.palPalEntry[0]);
    for var j := 0 to 255 do
      begin
        var color := fpal.palPalEntry[j];
        thispalette[j] := color.peRed shl 16 + color.peGreen shl 8 + color.peBlue;
      end;
    var palettename := tpath.GetFileNameWithoutExtension(extractfilename(palettefiles[i]));
    palettes.AddOrSetValue(i + 1, thispalette);
    paletteindexes.AddOrSetValue(palettename, i + 1);
  end;
end;

end.
