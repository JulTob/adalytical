with Adalytical_Testing;        use Adalytical_Testing;
with Adalytical.SVG;
with Adalytical.Plots.Histogram;
with Ada.Strings.Fixed;          use Ada.Strings.Fixed;

procedure Test_Histogram is
   type Fruit is (Apple, Banana, Cherry);
   type Counts is array (Fruit) of Long_Float;

   function LF (X : Long_Float) return Float is (Float (X));

   package H is new Adalytical.Plots.Histogram
     (Category => Fruit, Element => Long_Float,
      Value_Array => Counts, To_Float => LF);

   Doc : constant Adalytical.SVG.Document :=
     H.Plot ([Apple => 3.0, Banana => 7.0, Cherry => 5.0], "frutas");
   S   : constant String := Adalytical.SVG.To_String (Doc);
begin
   Section ("Histograma (vector-enum)");
   Check (Index (S, "<rect") > 0, "dibuja barras (rect)");
   Check (Index (S, "APPLE") > 0, "etiqueta de categoría APPLE");
   Check (Index (S, "CHERRY") > 0, "etiqueta de categoría CHERRY");
   Check (Index (S, "frutas") > 0, "incluye el título");
end Test_Histogram;
