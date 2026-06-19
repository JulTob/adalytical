--  Arnés de tests propio y mínimo: sin dependencias externas, integrable con
--  el factor de revisión `tests`. (Migrable a AUnit en el futuro; ver Design.md.)
package Adalytical_Testing is

   --  Imprime una cabecera de sección.
   procedure Section (Name : String);

   --  Registra una comprobación booleana.
   procedure Check (Condition : Boolean; Name : String);

   --  Comprueba igualdad numérica con tolerancia (comparación de flotantes).
   procedure Check_Close
     (Got, Expected : Long_Float; Name : String; Tol : Long_Float := 1.0e-9);

   --  Imprime el resumen final.
   procedure Report;

   --  Número de comprobaciones fallidas (para el código de salida).
   function Failures return Natural;

end Adalytical_Testing;
