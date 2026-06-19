--  Firma de CUERPO ANALÍTICO: un cuerpo ordenado más las funciones trascendentes
--  habituales (raíz, exponencial, logaritmo, trigonométricas).
--
--  Verdad arquitectónica importante: un cuerpo abstracto solo da +,-,*,/ y orden.
--  La desviación típica (sqrt), un seno generador, etc. NO pueden expresarse con
--  operaciones de cuerpo; requieren este álgebra enriquecida. Por eso los tipos
--  que la satisfacen (p. ej. los reales de doble precisión) habilitan ese material,
--  y los que solo son cuerpo ordenado, no.

--  Signature package: no referencia sus formales (contrato puro).
pragma Warnings (Off, "*not referenced*");
generic
   type Element is private;

   Zero : Element;
   One  : Element;

   with function "+" (Left, Right : Element) return Element is <>;
   with function "-" (Left, Right : Element) return Element is <>;
   with function "*" (Left, Right : Element) return Element is <>;
   with function "/" (Left, Right : Element) return Element is <>;
   with function "-" (Right : Element) return Element is <>;

   with function "<" (Left, Right : Element) return Boolean is <>;

   with function Sqrt (X : Element) return Element is <>;
   with function Exp  (X : Element) return Element is <>;
   with function Log  (X : Element) return Element is <>;
   with function Sin  (X : Element) return Element is <>;
   with function Cos  (X : Element) return Element is <>;
package Adalytical.Algebra.Analytic_Field
  with Pure
is
end Adalytical.Algebra.Analytic_Field;
