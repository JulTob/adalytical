with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Test_Linear_Algebra is
   --  Sistema diagonal: 2·x1 = 2, 4·x2 = 8  =>  x = [1, 2].
   A : constant Matrix := [[2.0, 0.0], [0.0, 4.0]];
   B : constant Vector := [2.0, 8.0];
   X : constant Vector := Solve (A, B);
begin
   Section ("Linear_Algebra (Generic_Real_Arrays / LAPACK)");
   Check_Close (X (X'First),     1.0, "solve x1 = 1");
   Check_Close (X (X'First + 1), 2.0, "solve x2 = 2");
end Test_Linear_Algebra;
