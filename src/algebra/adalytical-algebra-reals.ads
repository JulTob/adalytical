--  Capa 2 — instancia de referencia: los reales de doble precisión (Long_Float).
--
--  Provee las tres firmas algebraicas ya instanciadas. Sirve de ejemplo de cómo
--  "un tipo entra al juego": los operadores predefinidos de Long_Float satisfacen
--  los formales por defecto (`is <>`); las trascendentes vienen de la librería
--  numérica estándar.
with Adalytical.Algebra.Field;
with Adalytical.Algebra.Ordered_Field;
with Adalytical.Algebra.Analytic_Field;
with Ada.Numerics.Generic_Elementary_Functions;

package Adalytical.Algebra.Reals is

   subtype Real is Long_Float;

   package Elementary is new Ada.Numerics.Generic_Elementary_Functions (Real);

   package As_Field is new Adalytical.Algebra.Field
     (Element => Real, Zero => 0.0, One => 1.0);

   package Ordered is new Adalytical.Algebra.Ordered_Field
     (Element => Real, Zero => 0.0, One => 1.0);

   package Analytic is new Adalytical.Algebra.Analytic_Field
     (Element => Real, Zero => 0.0, One => 1.0,
      Sqrt => Elementary.Sqrt,
      Exp  => Elementary.Exp,
      Log  => Elementary.Log,
      Sin  => Elementary.Sin,
      Cos  => Elementary.Cos);

end Adalytical.Algebra.Reals;
