--  Diagrama base de una serie discreta: line plot sobre ejes.
--
--  Genérico sobre una instancia del motor más una función `To_Float` que indica
--  cómo el escalar del usuario se proyecta a un número (el "puente" a píxeles).
--  La fachada Easy.Reals lo instancia con la conversión trivial de Long_Float.
with Adalytical.Variables;
with Adalytical.SVG;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

generic
   with package Vars is new Adalytical.Variables (<>);
   with function To_Float (X : Vars.Scalar) return Float;
package Adalytical.Plots.Series_Line is

   type Line_Chart is new Adalytical.Plots.Plottable with private;

   function Chart
     (S : Vars.Discrete_Variable; Title : String := "") return Line_Chart;

   overriding function To_SVG
     (C          : Line_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document;

   --  Conveniencia: diagrama base (line plot) de una serie en un paso.
   function Plot
     (S          : Vars.Discrete_Variable;
      Title      : String := "";
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is (To_SVG (Chart (S, Title), With_Style));

private

   package Float_Vectors is new Ada.Containers.Vectors (Positive, Float);

   type Line_Chart is new Adalytical.Plots.Plottable with record
      Xs    : Float_Vectors.Vector;
      Ys    : Float_Vectors.Vector;
      Title : Ada.Strings.Unbounded.Unbounded_String;
   end record;

end Adalytical.Plots.Series_Line;
