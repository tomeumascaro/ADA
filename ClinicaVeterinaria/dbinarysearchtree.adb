--dbinarysearchtree.adb
with Ada.Text_IO; use Ada.Text_IO;

package body dbinarysearchtree is

procedure empty (s: out Tree) is
	root: pnode renames s.root;
begin
	root := null;
end empty;

function is_empty(s: in Tree) return boolean is
	root: pnode renames s.root;
begin
	return root = null;
end is_empty;

procedure put (p: in out pnode; k: in key; x: in item) is
begin
	if p = null then
		p := new node;
		p.all := (k, x, null, null);
	else
		if k < p.k then
			put (p.lc, k, x);
		elsif k > p.k then
			put (p.rc, k, x);
		else
			raise already_exists;
		end if;
	end if;
exception
	when storage_error => raise space_overflow;
end put;

procedure put_tree (s: in out Tree; k: in key; x: in item) is
	root: pnode renames s.root;
begin
	put(root, k, x);
end put_tree;

procedure get (s: in pnode; k: in key; x: out item) is
begin
	if s = null then
		raise does_not_exist;
	else
		if k < s.k then
			get(s.lc, k, x);
		elsif k > s.k then
			get(s.rc, k, x);
		else
			x := s.x;
		end if;
	end if;
end get;

procedure get (s: in Tree; k: in key; x: out item) is
	root: pnode renames s.root;
begin
	get(root, k, x);
end get;

procedure inorder (N : pnode) is
begin
    if N.lc /= null then
    	inorder(N.lc);
    end if;
    put_line(Image(N.x));
    if N.rc /= null then
    	inorder(N.rc);
    end if;
end Inorder;

function count_nodes (N: pnode) return integer is
begin
	if N /= null then
		if N.lc = null and N.rc = null then
			return 1;
		elsif N.lc /= null and N.rc = null then
			return count_nodes(N.lc) + 1;
		elsif N.lc = null and N.rc /= null then
			return count_nodes(N.rc) + 1;
		else --N.lc /= null and N.rc /= null
			return count_nodes(N.lc) + count_nodes(N.rc);
		end if;
	else
		return 0;
	end if;
end count_nodes;

procedure print_tree (s: in Tree) is
	root: pnode renames s.root;
	nnodes: integer;
begin
	if is_empty(s) then
		put_line("No hi ha cap mascota que hagi realitzat aquest tipus de consulta.");
	else
		nnodes := count_nodes(root);
		put_line("Num. consultes d'aquest tipus: " &integer'Image(nnodes));
		inorder(root);
	end if;
end print_tree;

end dbinarysearchtree;