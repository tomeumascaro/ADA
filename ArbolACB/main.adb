with Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
with darbre_binari;
--use darbre_binari;

procedure main is

	--package provaArbreBinari is new darbre_binari(integer, Integer'Image, "=", "<", ">");
	package provaArbreBinari is new darbre_binari(character, character'Image, "=", "<", ">");
	use provaArbreBinari;
	meu_arbre: arbre;
	fitxer: File_Type;
	resultats: File_Type;
	--index: integer := 0;
	--arraypreordre: recorregut(index);
	--arrayinordre: recorregut(index);
	--idxpreordre: index;
	--idxinordre: index;
--	idxpreordre: integer := 0;
--	idxinordre: integer := 0;
--	arraypreordre: recorregut(1..14); --limitar length array
--	arrayinordre: recorregut(1..14);
	--num: integer;
	x: character;
	--c: character;

procedure first (idx: integer) is

	idxpreordre: integer := 0;
	idxinordre: integer := 0;
	arraypreordre: recorregut(1..idx); --limitar length array
	arrayinordre: recorregut(1..idx);
begin

	if Argument_Count /= 1 then
		raise bad_use;
	else
		Open(fitxer, In_File, Argument(1)); --obrim fitxer
		while not End_Of_File(fitxer) loop --mentres no final fitxer
			while not End_Of_Line(fitxer) loop --llegim 1a linia
				--get (fitxer, num); --agafam nombres (bota els espais)
				get (fitxer, x);
				--idxpreordre := idxpreordre + 1;
				--arraypreordre(idxpreordre) := num; --ficam num a arraypreordre
				if x /= ' ' then
					idxinordre := idxinordre + 1;
					arrayinordre(idxinordre) := x;
				--put_line("Element afegit a arraypreordre: " & Integer'Image(num));
					put_line("Element afegit a arrayinordre: " & character'Image(x));
				end if;
			end loop;
			--Ada.Text_IO.new_line; --botam a la 2a linia
			while not End_Of_File(fitxer) loop --llegim 2a linia
				--get(fitxer, num); --agafam nombres (bota els blancs)
				get (fitxer, x);
				--idxinordre := idxinordre + 1;
				--arrayinordre(idxinordre) := num; --ficam num a arrayinordre
				if x /= ' ' then
					idxpreordre := idxpreordre + 1;
					arraypreordre(idxpreordre) := x;
				--put_line("Element afegit a arrayinordre: " & Integer'Image(num));
					put_line("Element afegit a arraypreordre: " & character'Image(x));
				end if;
			end loop;
			
		end loop;
		Close(fitxer);

		for i in arraypreordre'range loop
			put(character'image(arraypreordre(i)));
		end loop;

		put_line("");
		for i in arrayinordre'range loop
			put(character'image(arrayinordre(i)));
		end loop;
		put_line("");

		
		--operacions
		construir_arbre(arrayinordre, arraypreordre, meu_arbre);

		--arrel(meu_arbre, c);
		--Put_line((1=>c));

		Open(resultats, Out_File, "resultats.txt");
		if arbre_correcte(meu_arbre, arrayinordre) then
			put_line("Arbre correcte!");
			put(resultats, '1');
		else
			put_line("joder");
			put(resultats, '0');
		end if;

		if es_ACB(meu_arbre) then
			put_line("Arbre ACB!");
			put(resultats, '1');
		else
			put_line("joder 2");
			put(resultats, '0');
		end if;
		Close(resultats);

	end if;

end first;


idx: integer := 0;

begin
	--open i llegir linia i guardar length dins idx
	Open(fitxer, In_File, Argument(1)); --obrim fitxer
	while not End_Of_Line(fitxer) loop
		get(fitxer, x);
		idx := idx + 1;
	end loop;
	Close(fitxer);
	--put_line(integer'image(idx));
	idx := idx / 2;
	put_line(integer'image(idx));
	first(idx);

exception
	when constraint_Error => put_line("ERROR: Fitxer possiblement incorrecte");
	when bad_use => put_line("ERROR: Escriure un argument (nom fitxer)");
	when name_error => put_line("ERROR: No existeix el fitxer");
	when bad_recorreguts => put_line("ERROR: Recorreguts incorrectes");

end main;