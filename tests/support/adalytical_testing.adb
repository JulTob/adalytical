with Ada.Text_IO; use Ada.Text_IO;

package body Adalytical_Testing is

   Passed : Natural := 0;
   Failed : Natural := 0;

   procedure Section (Name : String) is
   begin
      New_Line;
      Put_Line ("== " & Name & " ==");
   end Section;

   procedure Check (Condition : Boolean; Name : String) is
   begin
      if Condition then
         Passed := Passed + 1;
         Put_Line ("  [PASS] " & Name);
      else
         Failed := Failed + 1;
         Put_Line ("  [FAIL] " & Name);
      end if;
   end Check;

   procedure Check_Close
     (Got, Expected : Long_Float; Name : String; Tol : Long_Float := 1.0e-9)
   is
      Within : constant Boolean := abs (Got - Expected) <= Tol;
   begin
      Check
        (Within,
         Name & " (got=" & Got'Image & " exp=" & Expected'Image & ")");
   end Check_Close;

   procedure Report is
   begin
      New_Line;
      Put_Line
        ("Total:" & Natural'Image (Passed + Failed)
         & "   Passed:" & Natural'Image (Passed)
         & "   Failed:" & Natural'Image (Failed));
   end Report;

   function Failures return Natural is (Failed);

end Adalytical_Testing;
