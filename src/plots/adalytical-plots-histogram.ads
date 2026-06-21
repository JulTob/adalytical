--  Diagrama base de un vector indexado por un enumerado: HISTOGRAMA.
--
--  El tipo lleva la semántica: un array sobre un tipo discreto (enum) es,
--  naturalmente, una distribución por categorías -> barras. Las etiquetas se
--  derivan de Category'Image. Genérico sobre el enum, el elemento y su To_Float.
with Adalytical.SVG;
with Ada.Strings.Unbounded;

generic
   type Category is (<>);
   type Element is private;
   type Value_Array is array (Category) of Element;
   with function To_Float (X : Element) return Float;
package Adalytical.Plots.Histogram is

   type Bar_Chart is new Adalytical.Plots.Plottable with private;

   function Chart (Data : Value_Array; Title : String := "") return Bar_Chart;

   overriding function To_SVG
     (C          : Bar_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document;

   function Plot (Data : Value_Array; Title : String := "")
      return Adalytical.SVG.Document
   is (To_SVG (Chart (Data, Title)));

private

   type Bar_Chart is new Adalytical.Plots.Plottable with record
      Data  : Value_Array;
      Title : Ada.Strings.Unbounded.Unbounded_String;
   end record;

end Adalytical.Plots.Histogram;
