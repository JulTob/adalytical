--  Diagramas de una serie discreta: línea, stem (tallo) y scatter (dispersión).
--
--  Comparten el escalado a píxeles y los ejes con ticks; el modo se elige con
--  Series_Kind. Genérico sobre una instancia del motor más una función To_Float
--  que proyecta el escalar del usuario a un número (el "puente" a píxeles).
with Adalytical.Variables;
with Adalytical.SVG;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

generic
   with package Vars is new Adalytical.Variables (<>);
   with function To_Float (X : Vars.Scalar) return Float;
package Adalytical.Plots.Series_Line is

   type Series_Kind is (Kind_Line, Kind_Stem, Kind_Scatter);

   type Series_Chart is new Adalytical.Plots.Plottable with private;

   function Chart
     (S     : Vars.Discrete_Variable;
      Title : String := "";
      Kind  : Series_Kind := Kind_Line) return Series_Chart;

   overriding function To_SVG
     (C          : Series_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document;

   --  Conveniencias (un paso): el diagrama base de una serie es la línea.
   function Plot
     (S          : Vars.Discrete_Variable;
      Title      : String := "";
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is (To_SVG (Chart (S, Title, Kind_Line), With_Style));

   function Stem
     (S          : Vars.Discrete_Variable;
      Title      : String := "";
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is (To_SVG (Chart (S, Title, Kind_Stem), With_Style));

   function Scatter
     (S          : Vars.Discrete_Variable;
      Title      : String := "";
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is (To_SVG (Chart (S, Title, Kind_Scatter), With_Style));

private

   package Float_Vectors is new Ada.Containers.Vectors (Positive, Float);

   type Series_Chart is new Adalytical.Plots.Plottable with record
      Xs    : Float_Vectors.Vector;
      Ys    : Float_Vectors.Vector;
      Title : Ada.Strings.Unbounded.Unbounded_String;
      Kind  : Series_Kind := Kind_Line;
   end record;

end Adalytical.Plots.Series_Line;
