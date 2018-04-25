--dlist.ads
generic
	type item is private; --element i els seus tipus de comparacions
		with function "=" (a, b: in item) return boolean; --comparar elements =
		with function "<" (a, b: in item) return boolean; --comparar elements <
		with function ">" (a, b: in item) return boolean; --comparar elements >
		with function Image (a: in item) return string; --imprimir elements

package dlist is
	type list is limited private; --la llista no es pot modificar ni comparar desde un altre package

	bad_use: exception;
	space_overflow: exception;

	procedure empty(lista: out list); --crea una llista buida
	procedure insert(lista: in out list ; elem: in item); --insereix un element a la llista
	procedure dis_order (lista: in out list ; elem: in item); --ordena la llista
	procedure print_list(lista: in list); --imprimeix la llista
	function is_empty(lista: in list) return boolean; --comprova si la llista és buida

private
	type cell; --node
	type pcell is access cell; --punter al node

	type cell is --node
		record
			elem: item; --element del node
			next: pcell; --punter al pròxim node
		end record;

	type list is --llista
		record
			first: pcell; --primer element de la llista
			last: pcell; --últim element de la llista
		end record;
end dlist;