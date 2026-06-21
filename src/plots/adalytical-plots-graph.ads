--  Diagrama base de una matriz cuadrada: GRAFO.
--
--  El tipo lleva la semántica: una matriz cuadrada es, naturalmente, una matriz
--  de adyacencia -> nodos y aristas. Los nodos se disponen en círculo y se traza
--  una arista entre i y j cuando |A(i,j)| supera un umbral. Genérico sobre el
--  tipo real y el tipo matriz (compatible con Adalytical.Linear_Algebra).
with Adalytical.SVG;

generic
   type Real is digits <>;
   type Matrix_Type is array (Integer range <>, Integer range <>) of Real;
package Adalytical.Plots.Graph is

   function Plot
     (Adjacency  : Matrix_Type;
      Title      : String := "";
      Threshold  : Real := 0.0;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
     with Pre => Adjacency'Length (1) = Adjacency'Length (2);

end Adalytical.Plots.Graph;
