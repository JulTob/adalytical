package body Adalytical.Statistics.Descriptive is

   function Sum (V : Discrete_Variable) return Scalar is
      Data : constant Vars.Sample_Array := Vars.Values (V);
      Acc  : Scalar := Vars.F.Zero;
   begin
      for X of Data loop
         Acc := Vars.F."+" (Acc, X);
      end loop;
      return Acc;
   end Sum;

   function Mean (V : Discrete_Variable) return Scalar is
      Data  : constant Vars.Sample_Array := Vars.Values (V);
      Acc   : Scalar := Vars.F.Zero;
      Count : Scalar := Vars.F.Zero;
   begin
      for X of Data loop
         Acc   := Vars.F."+" (Acc, X);
         Count := Vars.F."+" (Count, Vars.F.One);
      end loop;
      return Vars.F."/" (Acc, Count);
   end Mean;

   function Variance (V : Discrete_Variable) return Scalar is
      Data  : constant Vars.Sample_Array := Vars.Values (V);
      M     : constant Scalar := Mean (V);
      Acc   : Scalar := Vars.F.Zero;
      Count : Scalar := Vars.F.Zero;
      D     : Scalar;
   begin
      for X of Data loop
         D     := Vars.F."-" (X, M);
         Acc   := Vars.F."+" (Acc, Vars.F."*" (D, D));
         Count := Vars.F."+" (Count, Vars.F.One);
      end loop;
      return Vars.F."/" (Acc, Count);
   end Variance;

end Adalytical.Statistics.Descriptive;
