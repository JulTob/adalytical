with Adalytical_Testing;     use Adalytical_Testing;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Test_Signals is
   Imp  : constant Series := Impulse (5);
   Stp  : constant Series := Step (5);
   --  Convolucionar con el impulso unitario devuelve la señal sin cambios.
   Conv : constant Series := Convolve (Impulse (1), Data ([2.0, 3.0, 4.0]));
begin
   Section ("Signals");
   Check (Length (Imp) = 5, "impulso: longitud 5");
   Check_Close (Sample (Imp, 0), 1.0, "impulso[0] = 1");
   Check_Close (Sample (Imp, 1), 0.0, "impulso[1] = 0");
   Check_Close (Sum (Stp), 5.0, "suma del escalón(5) = 5");
   Check (Length (Conv) = 3, "conv impulso*[2,3,4]: longitud 3");
   Check_Close (Sample (Conv, 0), 2.0, "conv[0] = 2");
   Check_Close (Sample (Conv, 2), 4.0, "conv[2] = 4");
end Test_Signals;
