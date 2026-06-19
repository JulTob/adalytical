--  Ejemplo "experto de dominio": un analista (no programador) modela la
--  producción semanal de una planta y calcula métricas y coste. Observa que NO
--  aparece un solo genérico: solo la matemática del problema, vía la fachada.
with Ada.Text_IO;            use Ada.Text_IO;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Modelo_Produccion is
   --  Producción semanal observada (12 semanas), en miles de unidades.
   Produccion : constant Series :=
     Data ([10.0, 12.0, 11.0, 13.0, 15.0, 14.0,
            16.0, 18.0, 17.0, 19.0, 20.0, 22.0]);

   Coste_Unitario : constant Real := 3.5;                       --  € por unidad
   Coste_Total    : constant Real := Coste_Unitario * Sum (Produccion);
begin
   Put_Line ("Modelo de producción (12 semanas)");
   Put_Line ("  Producción media:  " & Mean (Produccion)'Image & "  (miles uds.)");
   Put_Line ("  Desviación típica: " & Std_Dev (Produccion)'Image);
   Put_Line ("  Producción total:  " & Sum (Produccion)'Image);
   Put_Line ("  Coste total:       " & Coste_Total'Image & "  (miles €)");
end Modelo_Produccion;
