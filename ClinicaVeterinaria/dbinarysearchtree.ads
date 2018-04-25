--dbinarysearchtree.ads
with pparaula; use pparaula;

generic
	type key is private;
	type item is private;
	with function "<"(k1, k2: in key) return boolean;
	with function ">"(k1, k2: in key) return boolean;
	with function Image (x: in item) return string;

package dbinarysearchtree is
	type Tree is limited private;
	type pnode is limited private;
	

	already_exists: exception;
	does_not_exist: exception;
	space_overflow: exception;

	procedure empty (s: out Tree);
	procedure put_tree (s: in out Tree; k: in key; x: in item);
	procedure get (s: in Tree; k: in key; x: out item);
	procedure print_tree (s: in Tree);

private
	type node;
	type pnode is access node;

	type node is record
		k: key;
		x: item;
		lc, rc: pnode;
	end record;

	type Tree is record
		root: pnode;
	end record;
end dbinarysearchtree;