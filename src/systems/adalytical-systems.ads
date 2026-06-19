--  Sistemas: operadores señal -> señal con dispatch dinámico. `System` es una
--  interfaz; `Apply` es la primitiva despachante (el "polimorfismo de retorno"
--  Signal -> Signal). Se incluyen dos sistemas LTI concretos: FIR (convolución
--  con sus coeficientes) y ganancia (escalado).
with Adalytical.Variables;
with Ada.Containers.Indefinite_Holders;

generic
   with package Vars is new Adalytical.Variables (<>);
package Adalytical.Systems is

   subtype Scalar is Vars.Scalar;
   subtype Discrete_Variable is Vars.Discrete_Variable;

   --  La interfaz de sistema.
   type System is interface;
   function Apply
     (S : System; Input : Discrete_Variable) return Discrete_Variable
   is abstract;

   ---------------------------------------------------------------------------
   --  Sistema FIR (respuesta finita al impulso): convoluciona con sus taps.
   ---------------------------------------------------------------------------
   type FIR_System is new System with private;
   function Make_FIR (Coefficients : Vars.Sample_Array) return FIR_System
     with Pre => Coefficients'Length > 0;
   overriding function Apply
     (S : FIR_System; Input : Discrete_Variable) return Discrete_Variable;
   function Order (S : FIR_System) return Natural;   --  número de taps menos 1

   ---------------------------------------------------------------------------
   --  Sistema de ganancia: escala la señal por un factor constante.
   ---------------------------------------------------------------------------
   type Gain_System is new System with private;
   function Make_Gain (Factor : Scalar) return Gain_System;
   overriding function Apply
     (S : Gain_System; Input : Discrete_Variable) return Discrete_Variable;

private

   --  Hace directamente visible el "=" predefinido del array (lo exige el
   --  formal por defecto de Indefinite_Holders).
   use type Vars.Sample_Array;
   package Coeff_Holders is
     new Ada.Containers.Indefinite_Holders (Vars.Sample_Array);

   type FIR_System is new System with record
      Coeff : Coeff_Holders.Holder;
   end record;

   type Gain_System is new System with record
      Factor : Scalar;
   end record;

end Adalytical.Systems;
