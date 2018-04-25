--darbre_binari.adb
with Ada.Text_IO;
use Ada.Text_IO;

package body darbre_binari is

	function nodes_recursiu (idxPreordre: in out integer; primer: in integer; derrer: in integer; inordre: in recorregut; preordre: in recorregut) return pnode is
		actual: pnode;
		idxInordre: integer;
		--actual := new node;

	begin
		--actual := new node;
		put_line(integer'Image(idxPreordre));
		--actual.x := preordre(idxPreordre);
		--idxPreordre := idxPreordre + 1;

		if primer > derrer then
			return null;
		else
			actual := new node;
			actual.x := preordre(idxPreordre);
			idxPreordre := idxPreordre + 1;
		--end if;

		if primer = derrer then

			return actual;

		else
			idxInordre := primer;
			while idxInordre < derrer and then inordre(idxInordre) /= actual.x loop --cercam element, i fins que no el trobem...
				idxInordre := idxInordre + 1; --incrementam index inordre
			end loop;

			--quan hem trobat element
			if inordre(idxInordre) = actual.x then --si contingut inordre = contingut actual
				--cridades recursives d'esquerra (ficam x)
				--actual.esq := nodes_recursiu(idxPreordre, primer, derrer, inordre, preordre);
				--cridades recursives de dreta (ficam x)
				--actual.dret := nodes_recursiu(idxPreordre, primer, derrer, inordre, preordre);
				if idxPreordre <= preordre'length then
					actual.esq := nodes_recursiu(idxPreordre, primer, idxInordre-1, inordre, preordre);
				end if;
				if idxPreordre <= preordre'length then
					actual.dret := nodes_recursiu(idxPreordre, idxInordre+1, derrer, inordre, preordre);
				end if;
			else
				--raise bad_use; --raise bad_recorreguts;
				raise bad_recorreguts;
			end if;

			return actual;

		end if;

		end if;

	end nodes_recursiu;
	
	
	procedure construir_arbre (inordre: in recorregut; preordre: in recorregut; meu_arbre: in out arbre) is
		--idxPreordre : integer := 1;
		idxPreordre: integer;
		--primer : integer := 1;
		--derrer : integer := inordre'length;
	
	begin
		idxPreordre := 1;
		--meu_arbre.arrel := nodes_recursiu (idxPreordre, primer, derrer, inordre, preordre);
		meu_arbre.arrel := nodes_recursiu (idxPreordre, 1, preordre'length, inordre, preordre);
	
	end construir_arbre;


	procedure recursiu_inordre(p: in pnode; i: in out integer; b: in out boolean; r: in recorregut) is

	begin

		if p /= null then
			put_line(Image(p.x));
			if b then
				recursiu_inordre(p.esq, i, b, r);
				b := (r(i) = p.x);
			end if;

			if b then
				i := i + 1;
				recursiu_inordre(p.dret, i, b, r);
			end if;

		end if;

	end recursiu_inordre;



	function arbre_correcte(a: in arbre; r: in recorregut) return boolean is
		b: boolean := true;
		i: integer := 1;
		--p: pnode := a.arrel;
	begin
		--put_line(Image(p.x));
		recursiu_inordre(a.arrel, i, b, r);
		return b;

	end arbre_correcte;



	function es_ACB (p: in pnode) return boolean is
		esq: pnode renames p.esq;
		dret: pnode renames p.dret;

	begin
		if p = null or esq = null or dret = null then
			return true;
		else
			if esq.x < p.x and dret.x > p.x then
				return es_ACB(esq) and es_ACB(dret);
			else
				return false;
			end if;
		end if;

	end es_ACB;



	function es_ACB (a: in arbre) return boolean is

	begin
		return es_ACB(a.arrel);
	end es_ACB;

end darbre_binari;