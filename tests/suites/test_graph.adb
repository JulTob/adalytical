with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;
with Ada.Strings.Fixed;      use Ada.Strings.Fixed;

procedure Test_Graph is
   --  Triángulo: 3 nodos, todas las aristas presentes.
   A : constant Matrix := [[0.0, 1.0, 1.0],
                           [1.0, 0.0, 1.0],
                           [1.0, 1.0, 0.0]];
   Fig : constant Figure := Plot_Graph (A, Title => "triangulo");
   S   : constant String := To_SVG_String (Fig);
begin
   Section ("Grafo (matriz de adyacencia)");
   Check (Index (S, "<circle") > 0, "dibuja nodos (circle)");
   Check (Index (S, "<line") > 0, "dibuja aristas (line)");
   Check (Index (S, "triangulo") > 0, "incluye el título");
end Test_Graph;
