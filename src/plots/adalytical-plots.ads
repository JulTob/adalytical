--  Capa de visualización tipada. El principio es el mismo del motor: el TIPO del
--  dato determina su diagrama base (una serie -> línea; un vector indexado por un
--  enum -> histograma; una matriz -> grafo; ...).
--
--  Diseño híbrido: `Plottable` es la interfaz con dispatch (cada diagrama ofrece
--  su render), y los plotters concretos se instancian genéricamente sobre los
--  tipos del motor. Por ahora (v0.2) solo está el line plot de una serie; el
--  resto figura en el backlog (STATUS.md).
with Adalytical.SVG;

package Adalytical.Plots is

   --  Parámetros de presentación.
   type Style is record
      Width  : Positive := 720;
      Height : Positive := 420;
      Margin : Positive := 50;
   end record;

   Default_Style : constant Style := (others => <>);

   --  Backbone de dispatch: todo diagrama sabe renderizarse a SVG.
   type Plottable is interface;
   function To_SVG
     (P : Plottable; With_Style : Style := Default_Style)
      return Adalytical.SVG.Document is abstract;

end Adalytical.Plots;
