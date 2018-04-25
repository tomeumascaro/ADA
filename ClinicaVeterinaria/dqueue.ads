generic
	type Item is private;

package dqueue is
	pragma Pure;
		type Queue is limited private;
		type iterator is private;
		
		Bad_Use: exception;
		Space_Overflow: exception;
		
		procedure empty (Qu: out Queue);
		procedure put (Qu: in out Queue; X: in Item);
		procedure rem_first (Qu: in out Queue);
		function get_first (Qu: in Queue) return Item;
		function is_empty (Qu: in Queue) return Boolean;

		function is_valid(it: in iterator) return boolean;
		procedure first(qu: in queue; it: out iterator);
		procedure get(qu: in queue; it: in iterator; x: out item);
		procedure next(qu: in queue; it: in out iterator);



private
	type Cell;
	type Pcell is access Cell;

	type Cell is record
		X: Item;
		Next: Pcell;
	end record;

	type Queue is record
		P, Q: Pcell;
	end record;

	type iterator is record
		s: pcell;
	end record;
end dqueue;