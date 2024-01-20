unit paletteswapunit;

interface
uses petzpaletteunit, generics.collections, windows, graphics, math;

var palettes: TDictionary<byte, TgamePalette>;
procedure loadpalettes;

implementation

const palettenamelist: array[0..1] of string = ('PaletteOddballz', 'PalettePastel');

procedure loadpalettes;
  var palettebmp: TBitmap;
  var fpal: plogpalette;
begin
  palettes := TDictionary<byte, TgamePalette>.Create();
  getmem(fpal, sizeof(tlogpalette) + sizeof(tpaletteentry)*255);
  fpal.palNumEntries := 256;
  fpal.palVersion := $300;
  palettebmp := TBitmap.Create();
  for var i := 0 to 1 do begin
    var thispalette: tgamepalette;
    palettebmp.LoadFromResourceName(hinstance, palettenamelist[i]);
    GetPaletteEntries(palettebmp.Palette, 0, 256, fpal.palPalEntry[0]);
    for var j := 0 to 15 do
      begin
        for var k := 0 to 15 do begin
          var color: TColor := palettebmp.canvas.Pixels[k, j];
          thispalette[(j * 16) + k] := getrvalue(color) shl 16 + getgvalue(color) shl 8 + getbvalue(color);
        end;
      end;
    palettes.AddOrSetValue(i, thispalette);
  end;
end;

end.
