--  Cuerpo: delega en Generic_Real_Arrays. Es la frontera no analizable por
--  SPARK (ver comentario del spec); el resto de la librería queda demostrable.
package body Adalytical.Linear_Algebra is

   function Solve (A : Matrix; B : Vector) return Vector is
     (Arrays.Solve (A, B));

   function Determinant (A : Matrix) return Real is
     (Arrays.Determinant (A));

end Adalytical.Linear_Algebra;
