package body Adalytical.Signals is

   function Impulse (N : Positive; T0, Dt : Scalar) return Vars.Discrete_Variable
   is
      S : Vars.Sample_Array (0 .. N - 1) := [others => Vars.F.Zero];
   begin
      S (0) := Vars.F.One;
      return Vars.Make_Discrete (S, T0, Dt);
   end Impulse;

   function Step (N : Positive; T0, Dt : Scalar) return Vars.Discrete_Variable
   is
      S : constant Vars.Sample_Array (0 .. N - 1) := [others => Vars.F.One];
   begin
      return Vars.Make_Discrete (S, T0, Dt);
   end Step;

   function Convolve
     (A, B : Vars.Discrete_Variable) return Vars.Discrete_Variable
   is
      SA : constant Vars.Sample_Array := Vars.Values (A);
      SB : constant Vars.Sample_Array := Vars.Values (B);
      R  : Vars.Sample_Array (0 .. SA'Length + SB'Length - 2) :=
        [others => Vars.F.Zero];
   begin
      for I in SA'Range loop
         for J in SB'Range loop
            R (I + J) := Vars.F."+" (R (I + J), Vars.F."*" (SA (I), SB (J)));
         end loop;
      end loop;
      return Vars.Make_Discrete
        (R, Vars.F."+" (Vars.Origin (A), Vars.Origin (B)), Vars.Spacing (A));
   end Convolve;

end Adalytical.Signals;
