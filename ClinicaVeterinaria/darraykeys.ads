with pparaula;
use pparaula;

generic
	size: positive;
	type item is private;

package darraykeys is 
	type set is limited private;

	alredy_exist: exception;
	does_not_exist: exception;
	space_overflow: exception;

	procedure empty(s: out set);
	procedure put(s: in out set; k: in Integer; x: in item);
	procedure get(s: in set; k: in Integer; x: out item);
	procedure remove(s: in out set; k: in Integer);
	procedure update(s: in out set; k: in Integer; x: in item);
	procedure obrirConsulta( s: in out set; k: in integer);
	procedure tancarConsulta( s: in out set; k: in integer);
	function  comprovaConsulta(s: in out set; k: in integer) return boolean;
	function  consultesObertes(s: in set) return integer; 

private
	b: constant natural:= size;
	type existence is array(natural range 1..b) of boolean;
	type contents is array (natural range 1..b) of item;

	type set is record
		e: existence;
		c: contents;
	end record;
	
end darraykeys;
