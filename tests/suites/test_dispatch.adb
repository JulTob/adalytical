--  Verifica la API homogénea: distintos diagramas renderizan por dispatch a
--  través de la interfaz Plottable.
with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;
with Adalytical.Plots;
with Adalytical.SVG;
with Ada.Strings.Fixed;      use Ada.Strings.Fixed;

procedure Test_Dispatch is
   D     : constant Series := Data ([1.0, 2.0, 1.5]);
   A     : constant Matrix := [[0.0, 1.0], [1.0, 0.0]];
   Serie : Adalytical.Plots.Plottable'Class := Plot_Line.Chart (D, "serie");
   Grafo : Adalytical.Plots.Plottable'Class := Graph_Plot.Chart (A, "grafo");
begin
   Section ("Dispatch Plottable (API homogénea)");
   Check (Index (Adalytical.SVG.To_String (Serie.To_SVG), "<polyline") > 0,
          "serie renderiza vía dispatch");
   Check (Index (Adalytical.SVG.To_String (Grafo.To_SVG), "<circle") > 0,
          "grafo renderiza vía dispatch");
end Test_Dispatch;
