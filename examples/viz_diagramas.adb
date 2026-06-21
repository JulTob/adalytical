--  Diagramas type-driven: el TIPO determina la forma.
--    * un vector indexado por un enum  -> histograma
--    * una matriz cuadrada (adyacencia) -> grafo
with Ada.Text_IO;                use Ada.Text_IO;
with Adalytical.Plots.Histogram;
with Adalytical.Easy.Reals;      use Adalytical.Easy.Reals;

procedure Viz_Diagramas is
   --  Histograma: ventas por trimestre (vector indexado por enum).
   type Quarter is (Q1, Q2, Q3, Q4);
   type Sales is array (Quarter) of Real;
   function To_F (X : Real) return Float is (Float (X));
   package Hist is new Adalytical.Plots.Histogram
     (Category => Quarter, Element => Real, Value_Array => Sales, To_Float => To_F);

   H_Fig : constant Figure :=
     Hist.Plot ([Q1 => 120.0, Q2 => 150.0, Q3 => 90.0, Q4 => 200.0],
                "Ventas por trimestre");

   --  Grafo: red de 4 nodos (ciclo).
   A : constant Matrix := [[0.0, 1.0, 0.0, 1.0],
                           [1.0, 0.0, 1.0, 0.0],
                           [0.0, 1.0, 0.0, 1.0],
                           [1.0, 0.0, 1.0, 0.0]];
   G_Fig : constant Figure := Plot_Graph (A, Title => "Red de 4 nodos");
begin
   Save (H_Fig, "histograma.svg");
   Save (G_Fig, "grafo.svg");
   Put_Line ("Generados histograma.svg y grafo.svg");
end Viz_Diagramas;
