--  Álgebra lineal: vectores y matrices respaldados por la librería estándar
--  Ada.Numerics.Generic_Real_Arrays (operaciones de matriz densas, resolución
--  de sistemas, etc.).
--
--  Frontera de verificación: el CUERPO se marca `SPARK_Mode => Off` porque
--  delega en código numérico no analizable por SPARK. El resto de la librería
--  (Variables, Statistics) permanece en estilo demostrable; ver docs/Design.md.
with Ada.Numerics.Generic_Real_Arrays;

generic
   type Real is digits <>;
package Adalytical.Linear_Algebra is

   package Arrays is new Ada.Numerics.Generic_Real_Arrays (Real);

   subtype Vector is Arrays.Real_Vector;
   subtype Matrix is Arrays.Real_Matrix;

   --  Resuelve el sistema lineal A·x = b.
   function Solve (A : Matrix; B : Vector) return Vector
     with Pre => A'Length (1) = A'Length (2) and then A'Length (1) = B'Length;

   --  Determinante de una matriz cuadrada.
   function Determinant (A : Matrix) return Real
     with Pre => A'Length (1) = A'Length (2);

end Adalytical.Linear_Algebra;
