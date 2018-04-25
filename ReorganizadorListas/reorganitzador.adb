--reorganitzador
with Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
with dlist;

procedure reorganitzador is
	
	package listaInteger is new dlist(Integer, "=", "<", ">", Integer'Image); --nova llista
	use listaInteger;
	llista: list; --nom llista
	fitxer: File_Type; --nom fitxer
	numOrdenar: Integer;
	num: Integer;

begin
	empty(llista); --cream llista buida
	Open(fitxer, Mode => In_File, Name => "llista_init"); --obrim fitxer

	while not End_Of_File(fitxer) loop
		get(fitxer, num); --llegim nombres del fitxer
		insert(llista, num); --i els afegim a la llista
	end loop;
	close(fitxer);

	put_line("Llista sense ordenar: ");
	print_list(llista); --imprimim llista sense ordenar
	put_line("");
	put_line("");
	put("Per quin nombre vols ordenar? ");
	get(numOrdenar); --llegim nombre
	dis_order(llista, numOrdenar); --ordenam la llista pel nombre llegit
	put_line("");
	put_line("Llista ordenada: ");
	print_list(llista); --imprimim llista ordenada

exception
	when bad_use => put_line("ERROR: Lista erronea.");
	when space_overflow => put_line("ERROR: Memoria insuficiente.");
	when others => put_line("ERROR");

end reorganitzador;