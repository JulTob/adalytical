package body Adalytical.Variables is

   ---------------------------------------------------------------------------
   --  Constante
   ---------------------------------------------------------------------------
   function Make_Constant (Value : Scalar) return Constant_Variable is
     (Constant_Variable'(Value => Value));

   overriding function Kind (V : Constant_Variable) return Variable_Kind is
     (Constant_Kind);

   overriding function Is_Evaluable (V : Constant_Variable) return Boolean is
     (True);

   overriding function Evaluate
     (V : Constant_Variable; X : Scalar) return Scalar is (V.Value);

   ---------------------------------------------------------------------------
   --  Función analítica
   ---------------------------------------------------------------------------
   function Make_Analytic (Fun : Real_Function) return Analytic_Variable is
     (Analytic_Variable'(Fun => Fun));

   overriding function Kind (V : Analytic_Variable) return Variable_Kind is
     (Analytic_Kind);

   overriding function Is_Evaluable (V : Analytic_Variable) return Boolean is
     (V.Fun /= null);

   overriding function Evaluate
     (V : Analytic_Variable; X : Scalar) return Scalar is (V.Fun (X));

   ---------------------------------------------------------------------------
   --  Datos discretos
   ---------------------------------------------------------------------------
   function Make_Discrete
     (Samples : Sample_Array; T0, Dt : Scalar) return Discrete_Variable
   is
      Normalized : constant Sample_Array (0 .. Samples'Length - 1) := Samples;
   begin
      return Discrete_Variable'
        (Data => Sample_Holders.To_Holder (Normalized),
         N    => Samples'Length,
         T0   => T0,
         Dt   => Dt);
   end Make_Discrete;

   overriding function Kind (V : Discrete_Variable) return Variable_Kind is
     (Discrete_Kind);

   overriding function Is_Evaluable (V : Discrete_Variable) return Boolean is
     (True);

   function Length (V : Discrete_Variable) return Positive is (V.N);

   function Sample (V : Discrete_Variable; I : Natural) return Scalar is
     (V.Data.Element (I));

   function Values (V : Discrete_Variable) return Sample_Array is
     (V.Data.Element);

   function Origin (V : Discrete_Variable) return Scalar is (V.T0);

   function Spacing (V : Discrete_Variable) return Scalar is (V.Dt);

   overriding function Evaluate
     (V : Discrete_Variable; X : Scalar) return Scalar
   is
      S : constant Sample_Array := V.Data.Element;

      --  Distancia |A - B| usando solo el orden del cuerpo.
      function Dist (A, B : Scalar) return Scalar is
        (if F."<" (A, B) then F."-" (B, A) else F."-" (A, B));

      Grid       : Scalar  := V.T0;
      Best_Index : Natural := S'First;
      Best_Dist  : Scalar  := Dist (X, V.T0);
      Cur_Dist   : Scalar;
   begin
      for I in S'Range loop
         Cur_Dist := Dist (X, Grid);
         if F."<" (Cur_Dist, Best_Dist) then
            Best_Dist  := Cur_Dist;
            Best_Index := I;
         end if;
         Grid := F."+" (Grid, V.Dt);
      end loop;
      return S (Best_Index);
   end Evaluate;

   ---------------------------------------------------------------------------
   --  Composición perezosa
   ---------------------------------------------------------------------------
   overriding function Kind (V : Composite_Variable) return Variable_Kind is
     (Composite_Kind);

   overriding function Is_Evaluable (V : Composite_Variable) return Boolean is
     (V.Left.Element.Is_Evaluable and then V.Right.Element.Is_Evaluable);

   overriding function Evaluate
     (V : Composite_Variable; X : Scalar) return Scalar
   is
      L : constant Scalar := V.Left.Element.Evaluate (X);
      R : constant Scalar := V.Right.Element.Evaluate (X);
   begin
      case V.Operator is
         when Op_Add => return F."+" (L, R);
         when Op_Sub => return F."-" (L, R);
         when Op_Mul => return F."*" (L, R);
      end case;
   end Evaluate;

   overriding function Kind (V : Scaled_Variable) return Variable_Kind is
     (Scaled_Kind);

   overriding function Is_Evaluable (V : Scaled_Variable) return Boolean is
     (V.Operand.Element.Is_Evaluable);

   overriding function Evaluate
     (V : Scaled_Variable; X : Scalar) return Scalar is
     (F."*" (V.Factor, V.Operand.Element.Evaluate (X)));

   ---------------------------------------------------------------------------
   --  Operadores
   ---------------------------------------------------------------------------
   function "+" (Left, Right : Variable'Class) return Variable'Class is
     (Composite_Variable'
        (Operator => Op_Add,
         Left     => Variable_Holders.To_Holder (Left),
         Right    => Variable_Holders.To_Holder (Right)));

   function "-" (Left, Right : Variable'Class) return Variable'Class is
     (Composite_Variable'
        (Operator => Op_Sub,
         Left     => Variable_Holders.To_Holder (Left),
         Right    => Variable_Holders.To_Holder (Right)));

   function "*" (Left, Right : Variable'Class) return Variable'Class is
     (Composite_Variable'
        (Operator => Op_Mul,
         Left     => Variable_Holders.To_Holder (Left),
         Right    => Variable_Holders.To_Holder (Right)));

   function "*" (Factor : Scalar; V : Variable'Class) return Variable'Class is
     (Scaled_Variable'
        (Factor  => Factor,
         Operand => Variable_Holders.To_Holder (V)));

   function "*" (V : Variable'Class; Factor : Scalar) return Variable'Class is
     (Factor * V);

   function "-" (V : Variable'Class) return Variable'Class is
     (Scaled_Variable'
        (Factor  => F."-" (F.One),
         Operand => Variable_Holders.To_Holder (V)));

   ---------------------------------------------------------------------------
   --  Materialización
   ---------------------------------------------------------------------------
   function Sample_On_Grid
     (V : Variable'Class; T0, Dt : Scalar; N : Positive) return Discrete_Variable
   is
      S : Sample_Array (0 .. N - 1);
      X : Scalar := T0;
   begin
      for I in S'Range loop
         S (I) := V.Evaluate (X);
         X := F."+" (X, Dt);
      end loop;
      return Make_Discrete (S, T0, Dt);
   end Sample_On_Grid;

end Adalytical.Variables;
