with Ada.Float_Text_IO;
with Ada.Strings;
with Ada.Strings.Fixed;

package body Adalytical.Plots.Series_Line is

   use Ada.Strings.Unbounded;

   function Num (F : Float) return String is
      Buf : String (1 .. 24);
   begin
      Ada.Float_Text_IO.Put (Buf, F, Aft => 2, Exp => 0);
      return Ada.Strings.Fixed.Trim (Buf, Ada.Strings.Both);
   end Num;

   function Chart
     (S : Vars.Discrete_Variable; Title : String := "") return Line_Chart
   is
      Result : Line_Chart;
      N  : constant Positive := Vars.Length (S);
      T0 : constant Float := To_Float (Vars.Origin (S));
      Dt : constant Float := To_Float (Vars.Spacing (S));
   begin
      Result.Title := To_Unbounded_String (Title);
      for I in 0 .. N - 1 loop
         Result.Xs.Append (T0 + Float (I) * Dt);
         Result.Ys.Append (To_Float (Vars.Sample (S, I)));
      end loop;
      return Result;
   end Chart;

   overriding function To_SVG
     (C          : Line_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is
      use Adalytical.SVG;
      N   : constant Natural := Natural (C.Xs.Length);
      W   : constant Float := Float (With_Style.Width);
      H   : constant Float := Float (With_Style.Height);
      M   : constant Float := Float (With_Style.Margin);
      Doc : Document := Create (With_Style.Width, With_Style.Height);
   begin
      --  Ejes.
      Line (Doc, M, H - M, W - M, H - M);   --  eje X
      Line (Doc, M, M, M, H - M);            --  eje Y

      if N = 0 then
         return Doc;
      end if;

      declare
         Xmin : Float := C.Xs.First_Element;
         Xmax : Float := C.Xs.First_Element;
         Ymin : Float := C.Ys.First_Element;
         Ymax : Float := C.Ys.First_Element;
      begin
         for V of C.Xs loop
            Xmin := Float'Min (Xmin, V);
            Xmax := Float'Max (Xmax, V);
         end loop;
         for V of C.Ys loop
            Ymin := Float'Min (Ymin, V);
            Ymax := Float'Max (Ymax, V);
         end loop;
         if Xmax <= Xmin then Xmax := Xmin + 1.0; end if;
         if Ymax <= Ymin then Ymax := Ymin + 1.0; end if;

         declare
            Px : Float_Array (1 .. N);
            Py : Float_Array (1 .. N);
         begin
            for I in 1 .. N loop
               Px (I) := M + (C.Xs (I) - Xmin) / (Xmax - Xmin) * (W - 2.0 * M);
               Py (I) :=
                 H - M - (C.Ys (I) - Ymin) / (Ymax - Ymin) * (H - 2.0 * M);
            end loop;
            Polyline (Doc, Px, Py, Stroke => "#1f77b4", Width => 2.0);
         end;

         Text (Doc, 6.0, H - M, Num (Ymin), Size => 11.0, Fill => "#555555");
         Text (Doc, 6.0, M, Num (Ymax), Size => 11.0, Fill => "#555555");
      end;

      if Length (C.Title) > 0 then
         Text (Doc, M, M - 14.0, To_String (C.Title), Size => 16.0);
      end if;

      return Doc;
   end To_SVG;

end Adalytical.Plots.Series_Line;
