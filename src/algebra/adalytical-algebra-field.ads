--  Firma de CUERPO (field): Element con +, -, *, / y neutros Zero/One.
--
--  Instanciar este paquete con un tipo y sus operaciones certifica que el tipo
--  se comporta como un cuerpo conmutativo. Los operandos por defecto (`is <>`)
--  toman los operadores directamente visibles del tipo actual, de modo que para
--  los tipos numéricos predefinidos la instanciación es inmediata.

--  Un signature package no referencia sus formales (es un contrato puro): se
--  silencia el aviso correspondiente para habilitar warnings-as-errors en revisión.
pragma Warnings (Off, "*not referenced*");
generic
   type Element is private;

   Zero : Element;   --  neutro aditivo
   One  : Element;   --  neutro multiplicativo

   with function "+" (Left, Right : Element) return Element is <>;
   with function "-" (Left, Right : Element) return Element is <>;
   with function "*" (Left, Right : Element) return Element is <>;
   with function "/" (Left, Right : Element) return Element is <>;
   with function "-" (Right : Element) return Element is <>;   --  inverso aditivo (unario)
package Adalytical.Algebra.Field
  with Pure
is
end Adalytical.Algebra.Field;
