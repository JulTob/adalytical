# Cookbook — recetas para usar Adalytical

Pensado para personas que conocen su dominio, no necesariamente Ada avanzado.
Todas las recetas se compilan con el proyecto (ver `examples/`).

## 0. Esqueleto

```ada
with Ada.Text_IO;            use Ada.Text_IO;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Mi_Programa is
begin
   null;  --  tu matemática aquí
end Mi_Programa;
```

Compila y ejecuta con `bash scripts/checks/tests.sh` como referencia, o añade tu
fuente a `examples/` y constrúyela con el proyecto de ejemplos.

## 1. Estadística sobre tus datos

```ada
Datos : constant Series := Data ([12.0, 15.0, 11.0, 18.0, 14.0]);
begin
   Put_Line ("Media:    " & Mean (Datos)'Image);
   Put_Line ("Varianza: " & Variance (Datos)'Image);
   Put_Line ("Std:      " & Std_Dev (Datos)'Image);
   Put_Line ("Suma:     " & Sum (Datos)'Image);
```

`Data` admite tiempo inicial y espaciado: `Data (Muestras, T0 => 0.0, Dt => 0.5)`.

## 2. Construir una señal y muestrearla

`Quantity` es el operando abstracto; lo compones con `+`, `-`, `*` y escalado.
Es **perezoso**: no se calcula nada hasta que muestreas o reduces.

```ada
--  2·sin(2π·1·t) + 0.5
S : constant Quantity := 2.0 * Sine (Frequency => 1.0) + Value (0.5);
D : constant Series   := Sample_On_Grid (S, T0 => 0.0, Dt => 0.01, N => 100);
```

## 3. Aplicar un sistema (filtro)

```ada
--  Media móvil de 3 puntos como filtro FIR.
Suavizada : constant Series :=
  Apply (FIR ([1.0/3.0, 1.0/3.0, 1.0/3.0]), D);

--  Ganancia.
Amplificada : constant Series := Apply (Gain (2.0), D);
```

## 4. Álgebra lineal

```ada
A : constant Matrix := [[2.0, 0.0], [0.0, 4.0]];
B : constant Vector := [2.0, 8.0];
X : constant Vector := Solve (A, B);   --  resuelve A·x = b
```

## 5. Declarar tu PROPIO tipo (usuario avanzado)

Un escalón por debajo de la fachada: declaras tu tipo, lo certificas como cuerpo
ordenado, y el motor opera sobre él con seguridad de tipos. Ejemplo completo en
[`examples/tipo_propio.adb`](../examples/tipo_propio.adb):

```ada
with Adalytical.Algebra.Ordered_Field;
with Adalytical.Variables;
with Adalytical.Statistics.Descriptive;

procedure Mi_Modelo is
   type Euros is new Long_Float;                       --  tu tipo

   package Euro_Algebra is new Adalytical.Algebra.Ordered_Field
     (Element => Euros, Zero => 0.0, One => 1.0);      --  las reglas del juego

   package V     is new Adalytical.Variables (Euro_Algebra);
   package Stats is new Adalytical.Statistics.Descriptive (V);

   Ingresos : constant V.Discrete_Variable :=
     V.Make_Discrete ([100.0, 120.0, 95.0, 130.0], T0 => 0.0, Dt => 1.0);
begin
   --  Stats.Mean (Ingresos) es de tipo Euros: no se mezcla con otros tipos.
   null;
end Mi_Modelo;
```

> Para dominios sin inversos (p. ej. magnitudes solo no-negativas) usa
> predicados/subtipos del tipo base; un cuerpo requiere inversos. Modelar fuzzy
> e intervalos como álgebras propias está en la hoja de ruta (ver `STATUS.md`).
