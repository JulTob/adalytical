--  Estadística descriptiva que se calcula SOLO con operaciones de cuerpo
--  (+, -, *, /): suma, media y varianza poblacional. La desviación típica
--  necesita raíz cuadrada (Analytic_Field) y vive en la fachada.
with Adalytical.Variables;

generic
   with package Vars is new Adalytical.Variables (<>);
package Adalytical.Statistics.Descriptive is

   subtype Scalar is Vars.Scalar;
   subtype Discrete_Variable is Vars.Discrete_Variable;

   function Sum (V : Discrete_Variable) return Scalar;

   function Mean (V : Discrete_Variable) return Scalar;

   --  Varianza poblacional (divide entre N).
   function Variance (V : Discrete_Variable) return Scalar;

end Adalytical.Statistics.Descriptive;
