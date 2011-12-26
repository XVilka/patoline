type font = {
  file : in_channel;
  offset : int;
  offSize : int;
  nameIndex : int array;
  dictIndex : int array;
  stringIndex : int array;
  subrIndex : string array array;
  gsubrIndex : string array;
}
type glyph = {
  glyphFont : font;
  glyphNumber:int;
  type2 : string;
  matrix : float array;
  subrs : string array;
  gsubrs : string array;
}

exception Index
exception Type2Int of int

val loadFont : ?offset:int -> string->font

val loadGlyph : font -> ?index:int->int -> glyph
val outlines : glyph -> Bezier.curve list
val glyphFont : glyph -> font

val fontName:?index:int->font->string
val fontBBox:?index:int->font->(int*int*int*int)
val italicAngle:?index:int->font->float

