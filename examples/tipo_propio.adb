--  Ejemplo "usuario avanzado": declarar tu PROPIO tipo y meterlo en el juego.
--
--  Es la vía intermedia (un escalón por debajo de la fachada Easy.Reals): el
--  usuario declara su tipo, lo certifica como cuerpo ordenado instanciando el
--  álgebra, y a partir de ahí el motor genérico opera sobre él con seguridad de
--  tipos (no se pueden mezclar Euros con otros tipos por error).
with Ada.Text_IO; use Ada.Text_IO;
with Adalytical.Algebra.Ordered_Field;
with Adalytical.Variables;
with Adalytical.Statistics.Descriptive;

procedure Tipo_Propio is

   type Euros is new Long_Float;   --  el tipo del usuario

   --  "Las reglas del juego": Euros es un cuerpo ordenado (operadores heredados).
   package Euro_Algebra is new Adalytical.Algebra.Ordered_Field
     (Element => Euros, Zero => 0.0, One => 1.0);

   --  El motor, instanciado sobre Euros.
   package V     is new Adalytical.Variables (Euro_Algebra);
   package Stats is new Adalytical.Statistics.Descriptive (V);

   Ingresos : constant V.Discrete_Variable :=
     V.Make_Discrete ([100.0, 120.0, 95.0, 130.0], T0 => 0.0, Dt => 1.0);

   Media : constant Euros := Stats.Mean (Ingresos);
begin
   Put_Line ("Tipo propio (Euros) sobre el motor genérico");
   Put_Line ("  Ingreso medio: " & Euros'Image (Media));
end Tipo_Propio;
