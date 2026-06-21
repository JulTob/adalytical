package body Adalytical.Plots.Histogram is

   use Ada.Strings.Unbounded;

   function Chart (Data : Value_Array; Title : String := "") return Bar_Chart is
     (Bar_Chart'(Data => Data, Title => To_Unbounded_String (Title)));

   overriding function To_SVG
     (C          : Bar_Chart;
      With_Style : Adalytical.Plots.Style := Adalytical.Plots.Default_Style)
      return Adalytical.SVG.Document
   is
      use Adalytical.SVG;
      N : constant Positive :=
        Category'Pos (Category'Last) - Category'Pos (Category'First) + 1;
      W   : constant Float := Float (With_Style.Width);
      H   : constant Float := Float (With_Style.Height);
      M   : constant Float := Float (With_Style.Margin);
      Doc : Document := Create (With_Style.Width, With_Style.Height);

      Plot_W : constant Float := W - 2.0 * M;
      Plot_H : constant Float := H - 2.0 * M;
      Bar_W  : constant Float := Plot_W / Float (N);
      Vmax   : Float := 0.0;
      Idx    : Natural := 0;
   begin
      for Cat in Category loop
         Vmax := Float'Max (Vmax, To_Float (C.Data (Cat)));
      end loop;
      if Vmax <= 0.0 then
         Vmax := 1.0;
      end if;

      --  Ejes.
      Line (Doc, M, H - M, W - M, H - M);
      Line (Doc, M, M, M, H - M);

      for Cat in Category loop
         declare
            V  : constant Float := To_Float (C.Data (Cat));
            BH : constant Float := (V / Vmax) * Plot_H;
            X  : constant Float := M + Float (Idx) * Bar_W;
            Y  : constant Float := H - M - BH;
         begin
            Rect (Doc, X + Bar_W * 0.1, Y, Bar_W * 0.8, BH,
                  Fill => "#1f77b4", Stroke => "#0d3b66");
            Text (Doc, X + Bar_W * 0.15, H - M + 14.0,
                  Category'Image (Cat), Size => 10.0, Fill => "#333333");
         end;
         Idx := Idx + 1;
      end loop;

      if Length (C.Title) > 0 then
         Text (Doc, M, M - 14.0, To_String (C.Title), Size => 16.0);
      end if;

      return Doc;
   end To_SVG;

end Adalytical.Plots.Histogram;
