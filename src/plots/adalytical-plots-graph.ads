--  Diagrama base de una matriz cuadrada: GRAFO.
--
--  El tipo lleva la semántica: una matriz cuadrada es una matriz de adyacencia
--  -> nodos y aristas. Los nodos se disponen en círculo y se traza una arista
--  entre i y j cuando |A(i,j)| supera un umbral.
--
--  API homogénea (T-208): `Graph_Chart` implementa la interfaz `Plottable`, igual
--  que `Series_Chart` y `Bar_Chart`, de modo que cualquier diagrama se renderiza
--  por dispatch (`P : Plottable'Class; ... P.To_SVG`). `Plot` se mantiene como
--  conveniencia de un paso.
with Adalytical.SVG;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

generic
   type Real is digits <>;
   type Matrix_Type is array (Integer range <>, Integer range <>) of Real;
package Adalytical.Plots.Graph is

   type Graph_Chart is new Adalytical.Plots.Plottable with private;

   function Chart
     (Adjacency : Matrix_Type;
      Title     : String := "";
      Threshold : Real := 0.0) return Graph_Chart
     with Pre => Adjacency'Length (1) = Adjacency'Length (2);

   overriding function To_SVG
     (C          : Graph_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document;

   --  Conveniencia (compatibilidad): construye y renderiza en un paso.
   function Plot
     (Adjacency  : Matrix_Type;
      Title      : String := "";
      Threshold  : Real := 0.0;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is (To_SVG (Chart (Adjacency, Title, Threshold), With_Style))
     with Pre => Adjacency'Length (1) = Adjacency'Length (2);

private

   type Edge is record
      A, B : Natural;
   end record;

   package Edge_Vectors is new Ada.Containers.Vectors (Positive, Edge);

   type Graph_Chart is new Adalytical.Plots.Plottable with record
      Node_Count : Natural := 0;
      Edges      : Edge_Vectors.Vector;
      Title      : Ada.Strings.Unbounded.Unbounded_String;
   end record;

end Adalytical.Plots.Graph;
