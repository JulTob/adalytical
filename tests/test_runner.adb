with Ada.Command_Line;
with Adalytical_Testing;
with Test_Variables;
with Test_Signals;
with Test_Systems;
with Test_Statistics;
with Test_Linear_Algebra;
with Test_Visualization;
with Test_Histogram;
with Test_Graph;
with Test_Animation;

procedure Test_Runner is
begin
   Test_Variables;
   Test_Signals;
   Test_Systems;
   Test_Statistics;
   Test_Linear_Algebra;
   Test_Visualization;
   Test_Histogram;
   Test_Graph;
   Test_Animation;

   Adalytical_Testing.Report;

   if Adalytical_Testing.Failures > 0 then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Test_Runner;
