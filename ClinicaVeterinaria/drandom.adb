with Ada.Numerics.discrete_Random;
package body drandom is

   subtype Rand_Range is Positive;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   gen : Rand_Int.Generator;

   function generate_random_number (n: in Positive) return Integer is
   begin
      return Rand_Int.Random(gen) mod n;  -- or mod n+1 to include the end value
   end generate_random_number;

	procedure reset_seed (n: in integer) is
	begin
		Rand_Int.Reset(gen, n);
	end reset_seed;

begin
   Rand_Int.Reset(gen);
end drandom;
