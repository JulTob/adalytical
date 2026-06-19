--  Adalytical — análisis matemático y estadístico en Ada.
--
--  Filosofía (misión original de Ada): que un experto de dominio escriba las
--  matemáticas de su campo con corrección garantizada por el tipado, sin cruzar
--  niveles de abstracción. La librería se organiza en tres capas:
--
--    Capa 1  Adalytical.Algebra.*   — las "reglas del juego" (firmas algebraicas).
--    Capa 2  el tipo del usuario     — declara su tipo e instancia un álgebra.
--    Capa 3  Adalytical.Variables/*  — el motor Variable/Signal (oculto al usuario).
--
--  La fachada Adalytical.Easy.* preinstancia todo para uso sin genéricos.
package Adalytical
  with Pure
is
   Version : constant String := "0.1.0-dev";

   --  Se eleva cuando se pide una operación que la encarnación concreta de una
   --  Variable no soporta (p. ej. evaluar punto a punto una función generalizada).
   Unsupported_Operation : exception;

   --  Se eleva al combinar Variables/Signals con dominios incompatibles.
   Domain_Mismatch : exception;

end Adalytical;
