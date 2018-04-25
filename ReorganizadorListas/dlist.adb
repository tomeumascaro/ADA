--dlist.adb
with Ada.Text_IO;
use Ada.Text_IO;

package body dlist is

	--Cream una llista buida
	procedure empty(lista: out list) is
		first: pcell renames lista.first;
	begin
		first := null; --punter al primer element apunta a null, així la llista és buida
	end empty;


	--Comprovam si la llista és buida
	function is_empty(lista: in list) return boolean is
		first: pcell renames lista.first;
	begin
		return first = null; --si el punter al primer element apunta a null, retorna true
	end is_empty;


	--Afegim un element al final de la llista
	procedure insert(lista: in out list ; elem: in item) is
		first: pcell renames lista.first; --punter al primer node de la llista
		last: pcell renames lista.last; --punter a l'últim node de la llista
		aux: pcell := null; --punter auxiliar
	begin
		aux := new cell; --nou node a la llista
		aux.all := (elem, null); --nou node apunta a null

		if first = null then
			first := aux;
			last := aux;
		else
			last.next := aux; --el nou node ara és l'últim element de la llista
			last := aux;
		end if;

	exception
		when storage_error => raise space_overflow;
	end insert;


	--Imprimim la llista (si no és buida)
	procedure print_list(lista: in list) is
		aux: pcell; --punter als nodes de la llista
	begin
		aux := lista.first;
		if is_empty(lista) then
			put_line("ERROR: Llista buida");
			raise bad_use;
		else
			while aux /= null loop
				put(Image(aux.elem)); --imprimim l'element del node apuntat per aux
				put(" ");
				aux := aux.next; --avançam el punter
			end loop;
		end if;
	end print_list;


	--Concatenam dues llistes
	procedure concatenate(a, b: in out list) is
		c: list; --llista auxiliar
	begin
		if a.first = null then
			c := b;
		elsif b.first = null then
			c := a;
		else
			a.last.next := b.first; --concatenam llista "a" amb llista "b"
			c.first := a.first;
			c.last := b.last;
		end if;
		a := c; --llista "a" és la llista concatenada
		b := (null, null); --llista "b" queda buida

	exception
		when storage_error => raise space_overflow;
	end concatenate;


	--Reorganitza la llista enllaçada a partir d'un valor (elem).
	--Els valors menors que "elem" es trobaran en primer lloc, seguits
	--dels valors iguals a "elem" i, després, els valors superiors a "elem".
	--S'utilitzen 8 punters dins la llista (lista) i tres llistes auxiliars (menors, iguals, majors).
	--Quan s'acaba el bucle la llista "lista" està buida perquè el punter al primer element (first) va
	--avançant en cada iteració fins arribar a apuntar a null.
	procedure dis_order (lista: in out list ; elem: in item) is
		first: pcell renames lista.first; --punter al primer node de la llista
		last: pcell renames lista.last; --punter a l'últim node de la llista
		menors, iguals, majors: list; --llistes auxiliars d'elements menors, iguals i majors
		firstMenors, lastMenors: pcell := null; --punter al primer i derrer element menor (dins lista)
		firstIguals, lastIguals: pcell := null; --punter al primer i derrer element igual (dins lista)
		firstMajors, lastMajors: pcell := null; --punter al primer i derrer element major (dins lista)
	begin
		while first /= null loop
		
			if first.elem < elem then --Valors menors que "elem"
				if firstMenors = null then --si encara no hi ha cap element que sigui el primer menor
					firstMenors := first;
					lastMenors := first;
				else
					lastMenors.next := first;
					lastMenors := first;
				end if;
				first := first.next;
				lastMenors.next := null;

			elsif first.elem = elem then --Valors iguals que "elem"
				if firstIguals = null then --si encara no hi ha cap element que sigui el primer igual
					firstIguals := first;
					lastIguals := first;
				else
					lastIguals.next := first;
					lastIguals := first;
				end if;
				first := first.next;
				lastIguals.next := null;

			elsif first.elem > elem then --Valors majors que "elem"
				if firstMajors = null then --si encara no hi ha cap element que sigui el primer major
					firstMajors := first;
					lastMajors := first;
				else
					lastMajors.next := first;
					lastMajors := first;
				end if;
				first := first.next;
				lastMajors.next := null;

			end if;

		end loop;

		menors.first := firstMenors; --punt. primer elem. < de la ll."menors" apunta allà mateix que punt. firstMenors
		menors.last := lastMenors;   --punt. derrer elem. < de la ll."menors" apunta allà mateix que punt. lastMenors
		iguals.first := firstIguals; --punt. primer elem. = de la ll."iguals" apunta allà mateix que punt. firstIguals
		iguals.last := lastIguals;   --punt. derrer elem. = de la ll."iguals" apunta allà mateix que punt. lastIguals
		majors.first := firstMajors; --punt. primer elem. > de la ll."majors" apunta allà mateix que punt. firstMajors
		majors.last := lastMajors;   --punt. derrer elem. > de la ll."majors" apunta allà mateix que punt. lastMajors

		concatenate(lista, menors); --concat. ll.buida ("lista") amb ll.menors i la guardam a "lista"
		concatenate(lista, iguals); --concat. ll.menors ("lista") amb ll.iguals i la guardam a "lista"
		concatenate(lista, majors); --concat. ll.menorsiguals ("lista") amb ll.majors i la guardam a "lista"

	exception
		when storage_error => raise space_overflow;
		when bad_use => raise bad_use;
	end dis_order;

end dlist;