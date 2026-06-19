package body Adalytical.Systems is

   ---------------------------------------------------------------------------
   --  FIR
   ---------------------------------------------------------------------------
   function Make_FIR (Coefficients : Vars.Sample_Array) return FIR_System is
      Normalized : constant Vars.Sample_Array (0 .. Coefficients'Length - 1) :=
        Coefficients;
   begin
      return (Coeff => Coeff_Holders.To_Holder (Normalized));
   end Make_FIR;

   function Order (S : FIR_System) return Natural is
     (S.Coeff.Element'Length - 1);

   overriding function Apply
     (S : FIR_System; Input : Discrete_Variable) return Discrete_Variable
   is
      H : constant Vars.Sample_Array := S.Coeff.Element;
      X : constant Vars.Sample_Array := Vars.Values (Input);
      R : Vars.Sample_Array (0 .. H'Length + X'Length - 2) :=
        [others => Vars.F.Zero];
   begin
      for I in H'Range loop
         for J in X'Range loop
            R (I + J) := Vars.F."+" (R (I + J), Vars.F."*" (H (I), X (J)));
         end loop;
      end loop;
      return Vars.Make_Discrete (R, Vars.Origin (Input), Vars.Spacing (Input));
   end Apply;

   ---------------------------------------------------------------------------
   --  Ganancia
   ---------------------------------------------------------------------------
   function Make_Gain (Factor : Scalar) return Gain_System is
     (Gain_System'(Factor => Factor));

   overriding function Apply
     (S : Gain_System; Input : Discrete_Variable) return Discrete_Variable
   is
      X : constant Vars.Sample_Array := Vars.Values (Input);
      R : Vars.Sample_Array (X'Range);
   begin
      for I in X'Range loop
         R (I) := Vars.F."*" (S.Factor, X (I));
      end loop;
      return Vars.Make_Discrete (R, Vars.Origin (Input), Vars.Spacing (Input));
   end Apply;

end Adalytical.Systems;
