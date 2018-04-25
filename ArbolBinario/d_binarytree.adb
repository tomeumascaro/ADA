--d_binarytree.adb
--is_path_sum(arbre, item, sumaacumulada, objectiu)
--Recorregut PREORDRE (NLR) -> Es comença del node arrel

package body d_binarytree is

	
	function value(a: in arbre; i: in rang) return item is
	begin
		return a.m(i);
	end value;


	function exist_left(a: in arbre; i: in rang) return boolean is
	begin
		return a.free > (2*i);
	end exist_left;


	function exist_right(a:in arbre; i: in rang) return boolean is
	begin
		return a.free > ((2*i) + 1);
	end exist_right;


	function idx_left(a: in arbre; i: in rang) return rang is
	begin
		return (2*i);
	end idx_left;


	function idx_right(a: in arbre; i: in rang) return rang is
	begin
		return ((2*i) + 1);
	end idx_right;


	function sumatori(a: in arbre; i: in rang; sum: in item; x: in item) return boolean is
		ac: item;
		l, r: rang;
		exist: boolean;
	begin
		ac := value(a, i);
		ac := ac + sum;
		if exist_left(a, i) then
			l := idx_left(a, i);
			exist := sumatori(a, l, ac, x);
			if exist then
				return true;
			end if;
			if exist_right(a, i) then
				r := idx_right(a, i);
				return sumatori(a, r, ac, x);
			else
				return false;
			end if;
		else
			return ac = x;
		end if;
	end sumatori;


	procedure inserir(a: in out arbre; x: in item) is
		free: rang renames a.free;
		m: mem renames a.m;
	begin
		m(free) := x;
		free := free + 1;
	end inserir;


	function is_path_sum(a: in arbre; x: in item) return boolean is
		e: boolean;
	begin
		e := false;
		return sumatori(a, 1, first_item, x);
	end is_path_sum;

end d_binarytree;