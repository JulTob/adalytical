with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;
with Ada.Strings.Fixed;      use Ada.Strings.Fixed;

procedure Test_Visualization is
   D    : constant Series := Data ([0.0, 1.0, 0.5, 1.5, 1.0]);
   Fig  : constant Figure := Plot (D, Title => "demo");
   SVG  : constant String := To_SVG_String (Fig);
   Stm  : constant String := To_SVG_String (Stem (D, "stem"));
   Scat : constant String := To_SVG_String (Scatter (D, "scatter"));
begin
   Section ("Visualization (SVG)");
   Check (Index (SVG, "<svg") > 0, "contiene la etiqueta <svg>");
   Check (Index (SVG, "</svg>") > 0, "cierra el documento svg");
   Check (Index (SVG, "<polyline") > 0, "line plot dibuja polyline");
   Check (Index (SVG, "demo") > 0, "incluye el título");
   Check (Index (SVG, "viewBox") > 0, "tiene viewBox (escalable)");
   Check (Index (Stm, "<circle") > 0, "stem dibuja marcadores");
   Check (Index (Scat, "<circle") > 0, "scatter dibuja puntos");
end Test_Visualization;
