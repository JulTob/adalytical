--  Fachada para los reales de doble precisión.
--
--  Instancia (ocultas al usuario) todas las capas del motor sobre el cuerpo de
--  los reales y reexporta nombres amables, de modo que un experto de dominio
--  escribe su matemática sin ver un solo genérico:
--
--     with Adalytical.Easy.Reals; use Adalytical.Easy.Reals;
--     S : Quantity := 2.0 * Sine (Frequency => 1.0) + Value (0.5);
--     D : Series   := Sample_On_Grid (S, T0 => 0.0, Dt => 0.01, N => 100);
--     M : Real     := Mean (D);
with Ada.Numerics;
with Adalytical.Algebra.Reals;
with Adalytical.Variables;
with Adalytical.Statistics.Descriptive;
with Adalytical.Signals;
with Adalytical.Systems;
with Adalytical.Linear_Algebra;

package Adalytical.Easy.Reals is

   subtype Real is Adalytical.Algebra.Reals.Real;

   --  Instancias del motor (detalle de implementación).
   package Var    is new Adalytical.Variables (F => Adalytical.Algebra.Reals.Ordered);
   package Stat   is new Adalytical.Statistics.Descriptive (Vars => Var);
   package Sig    is new Adalytical.Signals (Vars => Var);
   package Sys    is new Adalytical.Systems (Vars => Var);
   package LinAlg is new Adalytical.Linear_Algebra (Real => Real);

   --  Funciones elementales (Sqrt, Sin, Cos, Exp, Log) sobre los reales.
   package Elementary renames Adalytical.Algebra.Reals.Elementary;

   --  Nombres de dominio.
   subtype Quantity is Var.Variable'Class;       --  el operando abstracto
   subtype Series   is Var.Discrete_Variable;    --  datos discretos muestreados
   subtype Samples  is Var.Sample_Array;         --  vector de muestras crudo

   ---------------------------------------------------------------------------
   --  Constructores
   ---------------------------------------------------------------------------
   function Value (X : Real) return Var.Constant_Variable renames Var.Make_Constant;
   function Data (S : Samples; T0 : Real := 0.0; Dt : Real := 1.0) return Series is
     (Var.Make_Discrete (S, T0, Dt));

   ---------------------------------------------------------------------------
   --  Álgebra de operandos (uso infijo natural)
   ---------------------------------------------------------------------------
   function "+" (L, R : Quantity) return Quantity renames Var."+";
   function "-" (L, R : Quantity) return Quantity renames Var."-";
   function "*" (L, R : Quantity) return Quantity renames Var."*";
   function "*" (K : Real; V : Quantity) return Quantity renames Var."*";
   function "*" (V : Quantity; K : Real) return Quantity renames Var."*";
   function "-" (V : Quantity) return Quantity renames Var."-";

   function Evaluate (Q : Quantity; X : Real) return Real is (Q.Evaluate (X));
   function Sample_On_Grid
     (Q : Quantity; T0, Dt : Real; N : Positive) return Series
     renames Var.Sample_On_Grid;

   --  Accesores de una serie discreta.
   function Length (S : Series) return Positive renames Var.Length;
   function Sample (S : Series; I : Natural) return Real renames Var.Sample;
   function Values (S : Series) return Samples renames Var.Values;

   ---------------------------------------------------------------------------
   --  Generadores de señal
   ---------------------------------------------------------------------------
   function Impulse (N : Positive; T0 : Real := 0.0; Dt : Real := 1.0) return Series is
     (Sig.Impulse (N, T0, Dt));
   function Step (N : Positive; T0 : Real := 0.0; Dt : Real := 1.0) return Series is
     (Sig.Step (N, T0, Dt));
   function Convolve (A, B : Series) return Series renames Sig.Convolve;

   --  Sinusoide A·sin(2π f t + φ): captura sus parámetros (un sabor de Variable).
   type Sinusoid is new Var.Variable with private;
   function Sine (Frequency : Real; Amplitude : Real := 1.0; Phase : Real := 0.0)
      return Sinusoid;
   overriding function Kind (V : Sinusoid) return Var.Variable_Kind;
   overriding function Is_Evaluable (V : Sinusoid) return Boolean;
   overriding function Evaluate (V : Sinusoid; X : Real) return Real;

   ---------------------------------------------------------------------------
   --  Estadística descriptiva
   ---------------------------------------------------------------------------
   function Sum      (S : Series) return Real renames Stat.Sum;
   function Mean     (S : Series) return Real renames Stat.Mean;
   function Variance (S : Series) return Real renames Stat.Variance;
   function Std_Dev  (S : Series) return Real is (Elementary.Sqrt (Variance (S)));

   ---------------------------------------------------------------------------
   --  Sistemas LTI (operadores señal -> señal con dispatch)
   ---------------------------------------------------------------------------
   subtype System is Sys.System'Class;
   function FIR  (Coefficients : Samples) return Sys.FIR_System renames Sys.Make_FIR;
   function Gain (Factor : Real) return Sys.Gain_System renames Sys.Make_Gain;
   function Order (S : Sys.FIR_System) return Natural renames Sys.Order;
   function Apply (S : System; Input : Series) return Series is (Sys.Apply (S, Input));

   ---------------------------------------------------------------------------
   --  Álgebra lineal (respaldada por Generic_Real_Arrays)
   ---------------------------------------------------------------------------
   subtype Vector is LinAlg.Vector;
   subtype Matrix is LinAlg.Matrix;
   function Solve (A : Matrix; B : Vector) return Vector renames LinAlg.Solve;

private

   type Sinusoid is new Var.Variable with record
      Frequency : Real;
      Amplitude : Real;
      Phase     : Real;
   end record;

end Adalytical.Easy.Reals;
