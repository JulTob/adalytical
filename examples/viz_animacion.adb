--  Animación SVG nativa (SMIL): el navegador interpola, sin JS ni bucle de render.
with Ada.Text_IO;     use Ada.Text_IO;
with Adalytical.SVG;  use Adalytical.SVG;

procedure Viz_Animacion is
   Doc : Document := Create (400, 200);
begin
   --  Un punto que recorre el lienzo horizontalmente.
   Animated_Circle (Doc, 30.0, 100.0, 10.0,
                    Attribute => "cx", From => 30.0, To => 370.0,
                    Fill => "#1f77b4", Duration => 3.0);
   --  Un punto que late (radio).
   Animated_Circle (Doc, 200.0, 100.0, 6.0,
                    Attribute => "r", From => 6.0, To => 24.0,
                    Fill => "#e4572e", Duration => 1.5);
   Save (Doc, "animacion.svg");
   Put_Line ("Generado animacion.svg (ábrelo en un navegador para ver la animación)");
end Viz_Animacion;
