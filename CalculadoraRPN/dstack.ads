--dstack.ads
generic
	max: integer := 100;

package dstack is
	type stack is limited private; --pila no és generic perque nomes es una pila, no pot ser res més
									--limited private: no es pot modificar (:=) ni comparar (= , /=) desde un altre package
	bad_use: exception;
	space_overflow: exception;

	procedure empty(pila: out stack); --Cream una pila buida
	procedure push(pila: in out stack ; elem: in integer); --Afegim un element a la pila
	procedure pop(pila: in out stack); --Eliminam l'element del cim de la pila
	function top(pila: in stack) return integer; --Agafam l'element del cim de la pila
	function is_empty(pila: in stack) return boolean; --Comprovam si la pila és buida

private
	type index is new integer range 0..max; --index es un enter

	type stack is --definim la pila (cim de la pila)
		record
			top: index := 0; --top és un index (enter)
		end record;
end dstack;