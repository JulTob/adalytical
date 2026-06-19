with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Test_Variables is
   V1   : constant Quantity := Value (2.0);
   V2   : constant Quantity := Value (1.0);
   Expr : constant Quantity := 2.0 * V1 + V2;   --  = 5
   Diff : constant Quantity := V1 - V2;          --  = 1
begin
   Section ("Variables / álgebra de operandos");
   Check_Close (Evaluate (Value (3.0), 0.0), 3.0, "constante evalúa a su valor");
   Check_Close (Evaluate (Expr, 0.0), 5.0, "expresión perezosa 2*2+1 = 5");
   Check_Close (Evaluate (Diff, 0.0), 1.0, "resta 2-1 = 1");
   Check_Close (Evaluate (-V1, 0.0), -2.0, "negación = -2");
   Check (Length (Sample_On_Grid (Expr, 0.0, 1.0, 4)) = 4,
          "Sample_On_Grid produce N muestras");
end Test_Variables;
