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
     (S     : Vars.Discrete_Variable;
      Title : String := "";
      Kind  : Series_Kind := Kind_Line) return Series_Chart
   is
      Result : Series_Chart;
      N  : constant Positive := Vars.Length (S);
      T0 : constant Float := To_Float (Vars.Origin (S));
      Dt : constant Float := To_Float (Vars.Spacing (S));
   begin
      Result.Title := To_Unbounded_String (Title);
      Result.Kind  := Kind;
      for I in 0 .. N - 1 loop
         Result.Xs.Append (T0 + Float (I) * Dt);
         Result.Ys.Append (To_Float (Vars.Sample (S, I)));
      end loop;
      return Result;
   end Chart;

   overriding function To_SVG
     (C          : Series_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is
      use Adalytical.SVG;
      Color : constant String := "#1f77b4";
      N   : constant Natural := Natural (C.Xs.Length);
      W   : constant Float := Float (With_Style.Width);
      H   : constant Float := Float (With_Style.Height);
      M   : constant Float := Float (With_Style.Margin);
      Doc : Document := Create (With_Style.Width, With_Style.Height);
   begin
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
            function Map_X (X : Float) return Float is
              (M + (X - Xmin) / (Xmax - Xmin) * (W - 2.0 * M));
            function Map_Y (Y : Float) return Float is
              (H - M - (Y - Ymin) / (Ymax - Ymin) * (H - 2.0 * M));

            Base_Y : constant Float :=
              Map_Y (Float'Max (Ymin, Float'Min (Ymax, 0.0)));
         begin
            case C.Kind is
               when Kind_Line =>
                  declare
                     Px : Float_Array (1 .. N);
                     Py : Float_Array (1 .. N);
                  begin
                     for I in 1 .. N loop
                        Px (I) := Map_X (C.Xs.Element (I));
                        Py (I) := Map_Y (C.Ys.Element (I));
                     end loop;
                     Polyline (Doc, Px, Py, Stroke => Color, Width => 2.0);
                  end;

               when Kind_Stem =>
                  for I in 1 .. N loop
                     declare
                        X : constant Float := Map_X (C.Xs.Element (I));
                        Y : constant Float := Map_Y (C.Ys.Element (I));
                     begin
                        Line (Doc, X, Base_Y, X, Y, Stroke => Color, Width => 1.5);
                        Circle (Doc, X, Y, 3.0, Fill => Color);
                     end;
                  end loop;

               when Kind_Scatter =>
                  for I in 1 .. N loop
                     Circle (Doc, Map_X (C.Xs.Element (I)), Map_Y (C.Ys.Element (I)), 3.5,
                             Fill => Color);
                  end loop;
            end case;

            --  Ticks del eje Y (mín / medio / máx).
            declare
               Yt : constant Float_Array (1 .. 3) :=
                 [Ymin, (Ymin + Ymax) / 2.0, Ymax];
            begin
               for V of Yt loop
                  Line (Doc, M - 4.0, Map_Y (V), M, Map_Y (V), Stroke => "#999999");
                  Text (Doc, 4.0, Map_Y (V) + 3.0, Num (V),
                        Size => 9.0, Fill => "#777777");
               end loop;
            end;

            --  Ticks del eje X (primero / último).
            declare
               Xt : constant Float_Array (1 .. 2) := [Xmin, Xmax];
            begin
               for V of Xt loop
                  Line (Doc, Map_X (V), H - M, Map_X (V), H - M + 4.0,
                        Stroke => "#999999");
                  Text (Doc, Map_X (V) - 8.0, H - M + 15.0, Num (V),
                        Size => 9.0, Fill => "#777777");
               end loop;
            end;
         end;
      end;

      if Length (C.Title) > 0 then
         Text (Doc, M, M - 14.0, To_String (C.Title), Size => 16.0);
      end if;

      return Doc;
   end To_SVG;

end Adalytical.Plots.Series_Line;
