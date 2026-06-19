--  Signals & Systems: una `Signal` es una `Variable` interpretada sobre un
--  dominio ordenado/temporal. Este paquete añade los generadores estructurales
--  (que solo requieren Zero/One del álgebra) y la convolución discreta, núcleo
--  de los sistemas LTI. Los generadores trascendentes (seno, etc.) viven en la
--  fachada, donde hay un Analytic_Field disponible.
with Adalytical.Variables;

generic
   with package Vars is new Adalytical.Variables (<>);
package Adalytical.Signals is

   subtype Scalar is Vars.Scalar;

   --  Nombre de dominio para el operando abstracto interpretado como señal.
   subtype Signal is Vars.Variable'Class;

   --  Impulso unitario discreto (delta de Kronecker): 1 en i=0, 0 en el resto.
   function Impulse (N : Positive; T0, Dt : Scalar) return Vars.Discrete_Variable
     with Post => Vars.Length (Impulse'Result) = N;

   --  Escalón unitario discreto (Heaviside): 1 en toda la rejilla.
   function Step (N : Positive; T0, Dt : Scalar) return Vars.Discrete_Variable
     with Post => Vars.Length (Step'Result) = N;

   --  Convolución discreta (asume igual espaciado en A y B).
   function Convolve
     (A, B : Vars.Discrete_Variable) return Vars.Discrete_Variable
     with Post =>
       Vars.Length (Convolve'Result) = Vars.Length (A) + Vars.Length (B) - 1;

end Adalytical.Signals;
