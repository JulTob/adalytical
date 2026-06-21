with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;

package body Adalytical.Plots.Graph is

   package EF renames Ada.Numerics.Elementary_Functions;

   function Plot
     (Adjacency  : Matrix_Type;
      Title      : String := "";
      Threshold  : Real := 0.0;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is
      use Adalytical.SVG;
      N   : constant Natural := Adjacency'Length (1);
      W   : constant Float := Float (With_Style.Width);
      H   : constant Float := Float (With_Style.Height);
      M   : constant Float := Float (With_Style.Margin);
      Doc : Document := Create (With_Style.Width, With_Style.Height);

      Cx  : constant Float := W / 2.0;
      Cy  : constant Float := H / 2.0;
      Rad : constant Float := Float'Min (W, H) / 2.0 - M;

      type Point is record
         X, Y : Float;
      end record;

      Lo1 : constant Integer := Adjacency'First (1);
      Lo2 : constant Integer := Adjacency'First (2);
   begin
      if N = 0 then
         return Doc;
      end if;

      declare
         Pos : array (0 .. N - 1) of Point;
      begin
         for K in 0 .. N - 1 loop
            declare
               Angle : constant Float :=
                 2.0 * Ada.Numerics.Pi * Float (K) / Float (N) - Ada.Numerics.Pi / 2.0;
            begin
               Pos (K) := (X => Cx + Rad * EF.Cos (Angle),
                           Y => Cy + Rad * EF.Sin (Angle));
            end;
         end loop;

         --  Aristas: |A(i,j)| > umbral.
         for I in 0 .. N - 1 loop
            for J in 0 .. N - 1 loop
               if I /= J
                 and then abs (Adjacency (Lo1 + I, Lo2 + J)) > Threshold
               then
                  Line (Doc, Pos (I).X, Pos (I).Y, Pos (J).X, Pos (J).Y,
                        Stroke => "#bbbbbb", Width => 1.0);
               end if;
            end loop;
         end loop;

         --  Nodos (encima) + etiqueta de índice.
         for K in 0 .. N - 1 loop
            Circle (Doc, Pos (K).X, Pos (K).Y, 12.0, Fill => "#1f77b4");
            Text (Doc, Pos (K).X - 4.0, Pos (K).Y + 4.0,
                  Integer'Image (K), Size => 11.0, Fill => "white");
         end loop;
      end;

      if Title'Length > 0 then
         Text (Doc, M, M - 14.0, Title, Size => 16.0);
      end if;

      return Doc;
   end Plot;

end Adalytical.Plots.Graph;
