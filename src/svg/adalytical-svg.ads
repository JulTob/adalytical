--  Núcleo SVG: un constructor de documentos vectoriales sin dependencias.
--
--  SVG es texto: ligero en memoria, vectorial (escala sin pérdida), animable y
--  auditable (un .svg es legible y diff-eable). Este paquete acumula primitivas
--  en un buffer y las serializa; es la base sobre la que se montan los plots.
with Ada.Strings.Unbounded;

package Adalytical.SVG is

   type Document is private;

   type Float_Array is array (Positive range <>) of Float;

   --  Lienzo de Width x Height (en unidades de usuario / px).
   function Create (Width, Height : Positive) return Document;

   function Canvas_Width  (Doc : Document) return Positive;
   function Canvas_Height (Doc : Document) return Positive;

   --  Primitivas (añaden un elemento al documento).
   procedure Line
     (Doc : in out Document; X1, Y1, X2, Y2 : Float;
      Stroke : String := "black"; Width : Float := 1.0);

   procedure Rect
     (Doc : in out Document; X, Y, W, H : Float;
      Fill : String := "none"; Stroke : String := "black");

   procedure Circle
     (Doc : in out Document; CX, CY, R : Float; Fill : String := "black");

   procedure Text
     (Doc : in out Document; X, Y : Float; S : String;
      Size : Float := 12.0; Fill : String := "black");

   procedure Polyline
     (Doc : in out Document; Xs, Ys : Float_Array;
      Stroke : String := "black"; Width : Float := 1.5)
     with Pre => Xs'Length = Ys'Length;

   --  Serialización.
   function To_String (Doc : Document) return String;
   procedure Save (Doc : Document; Filename : String);

private

   type Document is record
      Width     : Positive := 1;
      Height    : Positive := 1;
      Body_Text : Ada.Strings.Unbounded.Unbounded_String;
   end record;

end Adalytical.SVG;
