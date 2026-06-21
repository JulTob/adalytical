with Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Strings;
with Ada.Strings.Fixed;

package body Adalytical.SVG is

   use Ada.Strings.Unbounded;

   Q  : constant Character := '"';
   LF : constant Character := ASCII.LF;

   --  Formato de número sin notación científica (apto para SVG).
   function Img (F : Float) return String is
      Buf : String (1 .. 32);
   begin
      Ada.Float_Text_IO.Put (To => Buf, Item => F, Aft => 3, Exp => 0);
      return Ada.Strings.Fixed.Trim (Buf, Ada.Strings.Both);
   end Img;

   function Img (N : Integer) return String is
     (Ada.Strings.Fixed.Trim (Integer'Image (N), Ada.Strings.Both));

   function Attr (Name, Value : String) return String is
     (" " & Name & "=" & Q & Value & Q);

   function Escape (S : String) return String is
      R : Unbounded_String;
   begin
      for C of S loop
         case C is
            when '&'    => Append (R, "&amp;");
            when '<'    => Append (R, "&lt;");
            when '>'    => Append (R, "&gt;");
            when others => Append (R, C);
         end case;
      end loop;
      return To_String (R);
   end Escape;

   procedure Add (Doc : in out Document; S : String) is
   begin
      Append (Doc.Body_Text, S);
   end Add;

   ---------------------------------------------------------------------------
   function Create (Width, Height : Positive) return Document is
     (Document'(Width => Width, Height => Height,
                Body_Text => Null_Unbounded_String));

   function Canvas_Width  (Doc : Document) return Positive is (Doc.Width);
   function Canvas_Height (Doc : Document) return Positive is (Doc.Height);

   procedure Line
     (Doc : in out Document; X1, Y1, X2, Y2 : Float;
      Stroke : String := "black"; Width : Float := 1.0) is
   begin
      Add (Doc,
           "  <line" & Attr ("x1", Img (X1)) & Attr ("y1", Img (Y1))
           & Attr ("x2", Img (X2)) & Attr ("y2", Img (Y2))
           & Attr ("stroke", Stroke) & Attr ("stroke-width", Img (Width))
           & "/>" & LF);
   end Line;

   procedure Rect
     (Doc : in out Document; X, Y, W, H : Float;
      Fill : String := "none"; Stroke : String := "black") is
   begin
      Add (Doc,
           "  <rect" & Attr ("x", Img (X)) & Attr ("y", Img (Y))
           & Attr ("width", Img (W)) & Attr ("height", Img (H))
           & Attr ("fill", Fill) & Attr ("stroke", Stroke) & "/>" & LF);
   end Rect;

   procedure Circle
     (Doc : in out Document; CX, CY, R : Float; Fill : String := "black") is
   begin
      Add (Doc,
           "  <circle" & Attr ("cx", Img (CX)) & Attr ("cy", Img (CY))
           & Attr ("r", Img (R)) & Attr ("fill", Fill) & "/>" & LF);
   end Circle;

   procedure Text
     (Doc : in out Document; X, Y : Float; S : String;
      Size : Float := 12.0; Fill : String := "black") is
   begin
      Add (Doc,
           "  <text" & Attr ("x", Img (X)) & Attr ("y", Img (Y))
           & Attr ("font-size", Img (Size)) & Attr ("fill", Fill)
           & Attr ("font-family", "sans-serif") & ">"
           & Escape (S) & "</text>" & LF);
   end Text;

   procedure Polyline
     (Doc : in out Document; Xs, Ys : Float_Array;
      Stroke : String := "black"; Width : Float := 1.5)
   is
      Pts : Unbounded_String;
   begin
      for I in Xs'Range loop
         if I > Xs'First then
            Append (Pts, " ");
         end if;
         Append (Pts, Img (Xs (I)) & "," & Img (Ys (I)));
      end loop;
      Add (Doc,
           "  <polyline" & Attr ("points", To_String (Pts))
           & Attr ("fill", "none") & Attr ("stroke", Stroke)
           & Attr ("stroke-width", Img (Width)) & "/>" & LF);
   end Polyline;

   procedure Animated_Circle
     (Doc : in out Document; CX, CY, R : Float;
      Attribute : String; From, To : Float;
      Fill : String := "black"; Duration : Float := 2.0;
      Repeat : String := "indefinite") is
   begin
      Add (Doc,
           "  <circle" & Attr ("cx", Img (CX)) & Attr ("cy", Img (CY))
           & Attr ("r", Img (R)) & Attr ("fill", Fill) & ">" & LF
           & "    <animate" & Attr ("attributeName", Attribute)
           & Attr ("from", Img (From)) & Attr ("to", Img (To))
           & Attr ("dur", Img (Duration) & "s")
           & Attr ("repeatCount", Repeat) & "/>" & LF
           & "  </circle>" & LF);
   end Animated_Circle;

   ---------------------------------------------------------------------------
   function To_String (Doc : Document) return String is
   begin
      return
        "<?xml version=" & Q & "1.0" & Q & " encoding=" & Q & "UTF-8" & Q & "?>"
        & LF
        & "<svg" & Attr ("xmlns", "http://www.w3.org/2000/svg")
        & Attr ("width", Img (Doc.Width)) & Attr ("height", Img (Doc.Height))
        & Attr ("viewBox", "0 0 " & Img (Doc.Width) & " " & Img (Doc.Height))
        & ">" & LF
        & To_String (Doc.Body_Text)
        & "</svg>" & LF;
   end To_String;

   procedure Save (Doc : Document; Filename : String) is
      F : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create (F, Ada.Text_IO.Out_File, Filename);
      Ada.Text_IO.Put (F, To_String (Doc));
      Ada.Text_IO.Close (F);
   end Save;

end Adalytical.SVG;
