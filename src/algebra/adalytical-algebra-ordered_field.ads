--  Firma de CUERPO ORDENADO: un cuerpo con relación de orden total (<, <=, =).
--
--  Es el álgebra mínima que necesita el motor Variable (Capa 3): permite componer,
--  evaluar, muestrear en rejilla y comparar, usando SOLO +, -, *, /, y el orden.
--  Las operaciones trascendentes (raíz, seno, exp) requieren Analytic_Field.
--
--  Nota de diseño: la firma es "plana" (autocontenida) en lugar de componerse a
--  partir de Field, para que el motor acceda a `F.Element`, `F."+"`, etc. sin
--  selectores anidados. La jerarquía Field ⊂ Ordered_Field ⊂ Analytic_Field es
--  conceptual; ver docs/Design.md.

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

   with function "<"  (Left, Right : Element) return Boolean is <>;
   with function "<=" (Left, Right : Element) return Boolean is <>;
   with function "="  (Left, Right : Element) return Boolean is <>;
package Adalytical.Algebra.Ordered_Field
  with Pure
is
end Adalytical.Algebra.Ordered_Field;
