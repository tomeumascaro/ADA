--main.adb
with Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
with d_binarytree;

procedure main is

	package arbrebinari is new d_binarytree(integer, 0, 50, "+", "=", Integer'Image);
	use arbrebinari;
	a: arbre;
	fitxer: File_Type;
	num: integer;
	numero: integer;

begin

	Open(fitxer, In_File, "arbre_init"); --obrim fitxer
	while not End_Of_File(fitxer) loop
		get(fitxer, num); --llegim nombres del fitxer
		inserir(a, num); --i els afegim a l'arbre
	end loop;
	close(fitxer);

	if Argument_Count /= 1 then
		raise bad_use;
	else
		numero := Integer'Value(Argument(1));
		if is_path_sum(a, numero) then
			put_line("OK");
		else
			put_line("no");
		end if;
	end if;

exception
	when bad_use => put_line("ERROR: Escribir un argumento (numero)");
	--when constraint_error => put_line("ERROR");
end main;