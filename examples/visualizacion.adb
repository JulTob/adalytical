--  Ejemplo de visualización: muestrea una señal y escribe su line plot en SVG.
with Ada.Text_IO;            use Ada.Text_IO;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Visualizacion is
   S   : constant Quantity := 2.0 * Sine (Frequency => 1.0) + Value (0.5);
   D   : constant Series   := Sample_On_Grid (S, T0 => 0.0, Dt => 0.01, N => 200);
   D2  : constant Series   := Sample_On_Grid (S, T0 => 0.0, Dt => 0.05, N => 20);
begin
   Save (Plot (D, Title => "2*sin(2pi t) + 0.5"), "onda.svg");
   Save (Stem (D2, Title => "stem"), "onda_stem.svg");
   Save (Scatter (D2, Title => "scatter"), "onda_scatter.svg");
   Put_Line ("SVG: onda.svg, onda_stem.svg, onda_scatter.svg ("
             & Length (D)'Image & " muestras)");
end Visualizacion;
