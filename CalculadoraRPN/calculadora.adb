--Calculadora RPN
--Permet les operacions: +,-,*,/,^
--Exemple: (3 + 4) x 5 amb format RPN és: 3 4 + 5 x
--Exemple compilació: calculadora 3 4 +
with Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_IO;
use Ada.Command_Line, Ada.Text_IO, Ada.Integer_Text_IO;
with dstack;

procedure calculadora is

	package pilaInteger is new dstack; --cream una pila tipus dstack
	use pilaInteger; --usam la pila creada
	pila: stack; --nom de la pila
	operadors: constant array (1..5) of character := ('+', '-', 'x', '/', '^');
	primer: integer;
	segon: integer;
	resultat: integer;
	numero: integer;
	numElementsPila: integer := 0; --comptador d'elements de la pila


	--Comprova si es llegeix un operador (true) o un nombre (false)
	function esoperador(s: in string) return boolean is
	begin
		if s'length /= 1 then --si la longitud de l'string no és 1 ja no pot ser un operador
			return false;
		end if;

		for i in operadors'range loop
			if operadors(i) = s(1) then --si el 1r element de l'string llegit és dins l'array d'operadors
				return true;
			end if;
		end loop;

		return false;
	end esoperador;


	--Realitza el càlcul específic de cada operador i retorna el resultat
	--Desempila dos elements de la pila (si és possible) i realitza el càlcul
	function calcular(first, second: in integer ; c: in character) return integer is
	begin
		if is_empty(pila) then
			put_line("ERROR: Pila buida");
   		else
      		segon := top(pila);
      		pop(pila);
      		numElementsPila := numElementsPila - 1;
      		--put_line("POP OK"); --llevar
      	
      		if is_empty(pila) then
				--put_line("ERROR: Pila buida despres del primer pop"); --llevar
				resultat := segon;
			else
				primer := top(pila);
				pop(pila);
				numElementsPila := numElementsPila - 1;
				--put_line("POP OK"); --llevar

				case c is
					when '+' => resultat := primer + segon;
					when '-' => resultat := primer - segon;
					when 'x' => resultat := primer * segon;
					when '/' => resultat := primer / segon;
					when '^' =>	resultat := primer ** segon;
					when others => put_line("ERROR: Operador invalid");
				end case;
			end if;
		end if;

		return resultat;
	end calcular;

--Es fa un recorregut mirant cada element de l'operació.
--Si l'element és un operador es fa el càlcul pertinent i s'empila el resultat a la pila.
--Si l'element és un nombre, empilam el nombre a la pila.
begin
	put_line("Calculadora RPN");
	if Argument_Count = 0 then -- ens diu el nombre d'arguments
    	put_Line("ERROR: No s'ha especificat cap operacio");
  	else
    	-- Miram tots els arguments
    	for arg in 1 .. Argument_Count loop
      		if esoperador(Argument(arg)) then
      			if numElementsPila >= 2 then --només es pot operar si a la pila hi ha >=2 elements
      				numero := calcular(primer, segon, Argument(arg)(1));
      				push(pila, numero);
      				numElementsPila := numElementsPila + 1;
      				--put_line("Operacio OK"); --llevar
      			else
      				raise bad_use; --si a la pila no hi ha >= 2 elements, no es pot operar => Error
      			end if;
			else --si no es un simbol, sera un nº
				numero := Integer'Value(Argument(arg));
				push(pila, numero);
				numElementsPila := numElementsPila + 1;
				--put_line("Numero empilat"); --llevar
			end if;

	    end loop;

	    pop(pila); --feim un pop, i si la pila queda buida el resultat es correcte
	    if is_empty(pila) then
	    	put_line("Resultat: " & Integer'image(numero));
	    else
	    	--put_line("ERROR: Operacio no valida 2"); --llevar
	    	raise bad_use;
	    end if;
  	end if;

exception
	when bad_use => put_line("ERROR: Operacio no valida");

end calculadora;