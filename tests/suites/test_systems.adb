with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Test_Systems is
   In_Sig   : constant Series         := Data ([1.0, 2.0, 3.0]);
   Doubled  : constant Series         := Apply (Gain (2.0), In_Sig);
   Filter   : constant Sys.FIR_System := FIR ([1.0, 1.0, 1.0]);
   Imp_Resp : constant Series         := Apply (Filter, Impulse (1));
begin
   Section ("Systems (LTI con dispatch)");
   Check_Close (Sample (Doubled, 0), 2.0, "ganancia x2: [0]");
   Check_Close (Sample (Doubled, 2), 6.0, "ganancia x2: [2]");
   Check (Order (Filter) = 2, "FIR: orden = taps - 1 = 2");
   Check (Length (Imp_Resp) = 3, "respuesta al impulso: longitud 3");
   Check_Close (Sample (Imp_Resp, 1), 1.0, "respuesta al impulso h[1] = 1");
end Test_Systems;
