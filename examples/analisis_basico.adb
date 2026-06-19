--  Ejemplo técnico: construye una señal como expresión perezosa, la muestrea,
--  le aplica un filtro FIR (media móvil) y calcula estadística descriptiva.
with Ada.Text_IO;            use Ada.Text_IO;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Analisis_Basico is
   --  Señal: 2·sin(2π·1·t) con un nivel de continua de 0.5.
   S : constant Quantity := 2.0 * Sine (Frequency => 1.0) + Value (0.5);

   --  Muestreo a 100 Hz durante 1 s (Dt = 0.01, N = 100).
   D : constant Series := Sample_On_Grid (S, T0 => 0.0, Dt => 0.01, N => 100);

   --  Filtro de media móvil de 3 coeficientes.
   Smoothed : constant Series :=
     Apply (FIR ([1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0]), D);
begin
   Put_Line ("Adalytical — análisis básico");
   Put_Line ("  Muestras:           " & Length (D)'Image);
   Put_Line ("  Media:              " & Mean (D)'Image);
   Put_Line ("  Varianza:           " & Variance (D)'Image);
   Put_Line ("  Desviación típica:  " & Std_Dev (D)'Image);
   Put_Line ("  Media tras suavizar:" & Mean (Smoothed)'Image);
end Analisis_Basico;
