unit paletteswapunit;

interface
uses petzpaletteunit, generics.collections, windows, graphics, math;

var palettes: TDictionary<byte, TgamePalette>;
procedure loadpalettes;

implementation

const palettenamelist: array[0..2] of string = ('PaletteOddballz', 'PalettePastel', 'PaletteBabyz');

procedure loadpalettes;
  var palettebmp: TBitmap;
  var fpal: plogpalette;
begin
  palettes := TDictionary<byte, TgamePalette>.Create();
  getmem(fpal, sizeof(tlogpalette) + sizeof(tpaletteentry)*255);
  fpal.palNumEntries := 256;
  fpal.palVersion := $300;
  palettebmp := TBitmap.Create();
  for var i := 0 to 2 do begin
    var thispalette: tgamepalette;
    palettebmp.LoadFromResourceName(hinstance, palettenamelist[i]);
    GetPaletteEntries(palettebmp.Palette, 0, 256, fpal.palPalEntry[0]);
    for var j := 0 to 255 do
      begin
        var color := fpal.palPalEntry[j];
        thispalette[j] := color.peRed shl 16 + color.peGreen shl 8 + color.peBlue;
      end;
    palettes.AddOrSetValue(i, thispalette);
  end;
end;

end.
