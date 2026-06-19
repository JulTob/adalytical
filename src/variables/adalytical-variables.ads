--  Capa 3 — el motor. `Variable` es el operando abstracto: "cualquier cosa que
--  respeta las reglas del juego (álgebra)". Es genérico sobre un cuerpo ordenado,
--  de modo que delega TODA la aritmética en el álgebra del tipo del usuario.
--
--  Estrategia híbrida: una interfaz con dispatch (capa fluida y heterogénea) y
--  sabores concretos. Los sabores "puros" (Constant, Analytic, Discrete) son
--  hojas; la composición (`+`, `*`, escalado) construye nodos perezosos que se
--  materializan al muestrear en una rejilla o reducir a un estadístico.
with Adalytical.Algebra.Ordered_Field;
with Ada.Containers.Indefinite_Holders;

generic
   with package F is new Adalytical.Algebra.Ordered_Field (<>);
package Adalytical.Variables is

   subtype Scalar is F.Element;

   type Variable_Kind is
     (Constant_Kind, Analytic_Kind, Discrete_Kind, Composite_Kind, Scaled_Kind);

   ---------------------------------------------------------------------------
   --  La interfaz: el operando abstracto.
   ---------------------------------------------------------------------------
   type Variable is interface;

   function Kind (V : Variable) return Variable_Kind is abstract;

   --  ¿Puede evaluarse punto a punto sobre el dominio?
   function Is_Evaluable (V : Variable) return Boolean is abstract;

   --  Evalúa en un punto del dominio (p. ej. el tiempo). Pre: ser evaluable.
   function Evaluate (V : Variable; X : Scalar) return Scalar is abstract
     with Pre'Class => Is_Evaluable (V);

   ---------------------------------------------------------------------------
   --  Sabor: constante (ignora el punto del dominio).
   ---------------------------------------------------------------------------
   type Constant_Variable is new Variable with private;
   function Make_Constant (Value : Scalar) return Constant_Variable;
   overriding function Kind (V : Constant_Variable) return Variable_Kind;
   overriding function Is_Evaluable (V : Constant_Variable) return Boolean;
   overriding function Evaluate (V : Constant_Variable; X : Scalar) return Scalar;

   ---------------------------------------------------------------------------
   --  Sabor: función analítica (envuelve una función Scalar -> Scalar de nivel
   --  biblioteca; es la vía para que el usuario aporte su propia f(t)).
   ---------------------------------------------------------------------------
   type Real_Function is access function (X : Scalar) return Scalar;
   type Analytic_Variable is new Variable with private;
   function Make_Analytic (Fun : Real_Function) return Analytic_Variable
     with Pre => Fun /= null;
   overriding function Kind (V : Analytic_Variable) return Variable_Kind;
   overriding function Is_Evaluable (V : Analytic_Variable) return Boolean;
   overriding function Evaluate (V : Analytic_Variable; X : Scalar) return Scalar;

   ---------------------------------------------------------------------------
   --  Sabor: datos discretos en rejilla uniforme X(i) = T0 + i*Dt, i en 0..N-1.
   ---------------------------------------------------------------------------
   type Sample_Array is array (Natural range <>) of Scalar;
   type Discrete_Variable is new Variable with private;
   function Make_Discrete
     (Samples : Sample_Array; T0, Dt : Scalar) return Discrete_Variable
     with Pre => Samples'Length > 0;
   overriding function Kind (V : Discrete_Variable) return Variable_Kind;
   overriding function Is_Evaluable (V : Discrete_Variable) return Boolean;
   --  Evalúa por vecino más cercano en la rejilla (búsqueda lineal con el orden).
   overriding function Evaluate (V : Discrete_Variable; X : Scalar) return Scalar;
   function Length (V : Discrete_Variable) return Positive;
   function Sample (V : Discrete_Variable; I : Natural) return Scalar
     with Pre => I < Length (V);
   function Values (V : Discrete_Variable) return Sample_Array
     with Post => Values'Result'Length = Length (V);
   function Origin  (V : Discrete_Variable) return Scalar;
   function Spacing (V : Discrete_Variable) return Scalar;  --  Dt entre muestras

   ---------------------------------------------------------------------------
   --  Composición algebraica perezosa. Devuelve Variable'Class: el resultado es
   --  a su vez una Variable, así que las expresiones se encadenan.
   ---------------------------------------------------------------------------
   function "+" (Left, Right : Variable'Class) return Variable'Class;
   function "-" (Left, Right : Variable'Class) return Variable'Class;
   function "*" (Left, Right : Variable'Class) return Variable'Class;
   function "*" (Factor : Scalar; V : Variable'Class) return Variable'Class;
   function "*" (V : Variable'Class; Factor : Scalar) return Variable'Class;
   function "-" (V : Variable'Class) return Variable'Class;

   --  Materializa cualquier Variable evaluable sobre una rejilla uniforme.
   function Sample_On_Grid
     (V : Variable'Class; T0, Dt : Scalar; N : Positive) return Discrete_Variable
     with Pre => V.Is_Evaluable;

private

   type Constant_Variable is new Variable with record
      Value : Scalar;
   end record;

   type Analytic_Variable is new Variable with record
      Fun : Real_Function;
   end record;

   package Sample_Holders is new Ada.Containers.Indefinite_Holders (Sample_Array);

   type Discrete_Variable is new Variable with record
      Data : Sample_Holders.Holder;
      N    : Positive;
      T0   : Scalar;
      Dt   : Scalar;
   end record;

   package Variable_Holders is
     new Ada.Containers.Indefinite_Holders (Variable'Class);

   type Binary_Operator is (Op_Add, Op_Sub, Op_Mul);

   type Composite_Variable is new Variable with record
      Operator : Binary_Operator;
      Left     : Variable_Holders.Holder;
      Right    : Variable_Holders.Holder;
   end record;
   overriding function Kind (V : Composite_Variable) return Variable_Kind;
   overriding function Is_Evaluable (V : Composite_Variable) return Boolean;
   overriding function Evaluate (V : Composite_Variable; X : Scalar) return Scalar;

   type Scaled_Variable is new Variable with record
      Factor  : Scalar;
      Operand : Variable_Holders.Holder;
   end record;
   overriding function Kind (V : Scaled_Variable) return Variable_Kind;
   overriding function Is_Evaluable (V : Scaled_Variable) return Boolean;
   overriding function Evaluate (V : Scaled_Variable; X : Scalar) return Scalar;

end Adalytical.Variables;
