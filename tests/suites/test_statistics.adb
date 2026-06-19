with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Test_Statistics is
   D : constant Series := Data ([1.0, 2.0, 3.0, 4.0]);
begin
   Section ("Statistics");
   Check_Close (Sum (D), 10.0, "suma = 10");
   Check_Close (Mean (D), 2.5, "media = 2.5");
   Check_Close (Variance (D), 1.25, "varianza poblacional = 1.25");
   Check_Close (Std_Dev (D), 1.1180339887498949, "desviación típica = sqrt(1.25)");
end Test_Statistics;
