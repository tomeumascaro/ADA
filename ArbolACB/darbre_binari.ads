--darbre_binari.ads
generic
	type element is private;
	--max: integer := 100;
		with function Image (x: in element) return string;
		with function "=" (a, b: in element) return boolean;
		with function "<" (a, b: in element) return boolean;
		with function ">" (a, b: in element) return boolean;

package darbre_binari is
	type arbre is limited private;
	type recorregut is array(Natural range<>) of element;
	--type recorregut is private;
	--type index is private;

	bad_use: exception;
	space_overflow: exception;
	bad_recorreguts: exception;

	--procedure empty (a: out arbre); --crea un arbre buid
	--procedure graft (a: out arbre; aesq, adret: in arbre; x: in element); --crea arbre a partir d'una arrel i fill dret i esquerr
	--procedure arrel (a: in arbre; x: out element); --arrel de l'arbre/subarbre
	--procedure esquerr (a: in arbre; aesq: out arbre); --subarbre esquerr
	--procedure dret (a: in arbre; adret: out arbre); --subarbre dret
	--function is_empty (a: in arbre) return boolean; --retorna true si l'arbre està buid

	procedure construir_arbre (inordre: in recorregut; preordre: in recorregut; meu_arbre: in out arbre);
	--procedure recursiu_inordre(p: in out pnode; i: in out integer; b: in out boolean; r: in recorregut);
	function arbre_correcte(a: in arbre; r: in recorregut) return boolean;
	function es_ACB (a: in arbre) return boolean;

private
	type node;
	type pnode is access node;

	--type index is new integer range 0..max;
	--type recorregut is array (index range 1..index'last) of element;
	--type recorregut is array (1..100) of element;

	type node is
		record
			x: element; --element del node
			esq: pnode; --punter del node al subarbre esquerr
			dret: pnode; --punter del node al subarbre dret
		end record;

	type arbre is
		record
			arrel: pnode; --punter a l'arrel de l'arbre
		end record;

end darbre_binari;