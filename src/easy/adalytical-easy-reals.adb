package body Adalytical.Easy.Reals is

   function Sine
     (Frequency : Real; Amplitude : Real := 1.0; Phase : Real := 0.0)
      return Sinusoid is
   begin
      return (Frequency => Frequency, Amplitude => Amplitude, Phase => Phase);
   end Sine;

   overriding function Kind (V : Sinusoid) return Var.Variable_Kind is
     (Var.Analytic_Kind);

   overriding function Is_Evaluable (V : Sinusoid) return Boolean is (True);

   overriding function Evaluate (V : Sinusoid; X : Real) return Real is
     (V.Amplitude
      * Elementary.Sin (2.0 * Ada.Numerics.Pi * V.Frequency * X + V.Phase));

end Adalytical.Easy.Reals;
