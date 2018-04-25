--dstack.adb
package body dstack is

	type block is --definim l'estructura del bloc de la pila (element i seguent)
		record
			elem: integer; --elem és un item (enter)
			next: index; --next és un index (enter)
		end record;

	type mem_space is array(index range 1..index'last) of block; --espai de memòria és un array de blocs (element i seguent)

	ms: mem_space; --ms és l'espai de memòria (array)
	free: index; --free és un index (enter)

	--Enllaça tots els blocs. És invocat desde les declaracions del seu package,
	--de manera que que serà la primera operació que s'executarà.
	procedure prep_mem_space is
	begin
		for i in index range 1..index'last-1 loop
			ms(i).next := i+1;
		end loop;
		ms(index'last).NEXT := 0;
		free := 1;
	end prep_mem_space;


	--Agafa un bloc de la llista de blocs lliures.
	function get_block return index is
		r: index; --r és un index (enter)
	begin
		if free = 0 then
			raise space_overflow;
		end if;
		r := free; --r apunta on apunta free
		free := ms(free).next; --free apunta al següent bloc
		ms(r).next := 0; --borram enllaç entre bloc apuntat per r i el següent (apunta a null)

		return r; --bloc que hem agafat de la llista de blocs lliures
	end get_block;


	--Elimina un bloc de la pila i l'afageix a la llista de blocs lliures
	procedure release_block(r: in out index) is
	begin
		ms(r).next := free; --el bloc apuntat per r apunta allà (al bloc) on apunta free
		free := r; --free apunta allà (al bloc) on apunta r
		r := 0; --borram punter r (r apunta a null) i així només tenim el punter free
	end release_block;


	--Allibera (free) tots els blocs de la pila.
	--Ho fa enllaçant l'últim element de la pila al primer element de la llista de blocs lliures.
	procedure release_stack(p: in out index) is
		r: index;
	begin
		if p /= 0 then
			r := p;
			while ms(r).next /= 0 loop
				r := ms(r).next;
			end loop;
			ms(r).next := free;
			free := p;
			p := 0;
		end if;
	end release_stack;


	--Crea una pila buida
	procedure empty(pila: out stack) is
		p: index renames pila.top; --al top de la pila (que és un index, enter) ara li deim "p"
	begin
		release_stack(p); --Buidam tots els blocs de la pila (free)
	end empty;


	--Mira si la pila esta buida
	function is_empty (pila: in stack) return boolean is
		p: index renames pila.top;
	begin
		return p = 0; --si p és 0, retorna true (si no és 0, retorna false)
	end is_empty;


	--Mira quin element hi ha al cim de la pila
	function top (pila: in stack) return integer is
		p: index renames pila.top;
	begin
		return ms(p).elem; --retorna l'element del cim (p) de l'espai de memòria (array ms)
	exception
		when constraint_error => raise bad_use; --error si es vol consultar el top d'una pila buida (es mira la pos. 0 de l'array ms)
	end top;


	--Empilam un element a la pila
	procedure push (pila: in out stack ; elem: in integer) is
		p: index renames pila.top;
		r: index; --r és un index (enter)
	begin
		r := get_block; --r és el bloc que hem agafat de la llista de blocs lliures
		ms(r) := (elem,p); --emmagatzemam l'element (elem) empilat dins el bloc obtingut (r), el qual apunta al cim (p)
		p := r; --el cim (p) passa a ser el nou bloc (r) que conté l'element (elem) empilat
	end push;
	

	--Desempilam l'element del cim de la pila
	procedure pop (pila: in out stack) is
		p: index renames pila.top;
		r: index; --p és un index (enter)
	begin
		r := p; --r agafa la posició del cim de la pila (p)
		p := ms(p).next; --el nou cim de la pila (p) passa a ser el següent element de l'array ms de blocs (memòria)
		release_block(r); --elimina el bloc de la posició r (el primer cim de la pila)
	exception
		when constraint_error => raise bad_use; --error si es vol desempilar una pila buida (es mira la pos. 0 de l'array ms)
	end pop;



--Declaracions de package
begin
	prep_mem_space; --Primera operació que s'executa
end dstack;