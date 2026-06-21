with Adalytical_Testing;  use Adalytical_Testing;
with Adalytical.SVG;
with Ada.Strings.Fixed;   use Ada.Strings.Fixed;

procedure Test_Animation is
   Doc : Adalytical.SVG.Document := Adalytical.SVG.Create (200, 100);
begin
   Adalytical.SVG.Animated_Circle
     (Doc, 20.0, 50.0, 8.0,
      Attribute => "cx", From => 20.0, To => 180.0, Fill => "red");
   declare
      S : constant String := Adalytical.SVG.To_String (Doc);
   begin
      Section ("Animación (SVG)");
      Check (Index (S, "<animate") > 0, "incluye elemento <animate>");
      Check (Index (S, "attributeName") > 0, "anima un atributo");
      Check (Index (S, "repeatCount") > 0, "tiene repeatCount (bucle)");
   end;
end Test_Animation;
