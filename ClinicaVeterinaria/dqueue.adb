package body dqueue is

--Buida una queue
PROCEDURE Empty (Qu: OUT Queue) IS
	P: Pcell RENAMES Qu.P;
	Q: Pcell RENAMES Qu.Q;
BEGIN
	P := NULL;
	Q := NULL;
END Empty;

--Retorna si la queue esta buida o no
FUNCTION Is_Empty (Qu: IN Queue) RETURN Boolean IS
	Q: Pcell RENAMES Qu.Q;
BEGIN
	RETURN Q = NULL;
END Is_Empty;

--Retorna el primer element de la queue
FUNCTION Get_First (Qu: IN Queue) RETURN Item IS
	Q: Pcell RENAMES Qu.Q;
BEGIN
	RETURN Q.X;
EXCEPTION
	WHEN Constraint_Error => RAISE Bad_Use;
END Get_First;

--Insereix un element al final de la queue
PROCEDURE Put (Qu: IN OUT Queue; X: IN Item) IS
	P: Pcell RENAMES Qu.P;
	Q: Pcell RENAMES Qu.Q;
	R: Pcell;
BEGIN
	R := NEW Cell;
	R.All := (X, NULL);
	IF P = NULL THEN -- Qu está vacía
		Q := R;
	ELSE
		P.Next := R;
	END IF;
	P := R;
EXCEPTION
	WHEN Storage_Error => RAISE Space_Overflow;
END Put;

--Elimina el primer element de la queue
PROCEDURE Rem_First (Qu: IN OUT Queue) IS
	P: Pcell RENAMES Qu.P;
	Q: Pcell RENAMES Qu.Q;
BEGIN
	Q := Q.Next;
	IF Q = NULL THEN
		P := NULL;
	END IF;
EXCEPTION
	WHEN Constraint_Error => RAISE Bad_Use;
END Rem_First;


--ITERATOR

function is_valid(it: in iterator) return boolean is
		begin
		 	return it.s /= null;
		end is_valid;

procedure get(qu: in queue; it: in iterator; x: out item) is
	s: pcell renames it.s;
begin
			x:= s.x;
end get;

procedure first(qu: in queue; it: out iterator) is
begin
	it.s:= qu.q;
end first;

procedure next(qu: in queue; it: in out iterator) is
	s: pcell renames it.s;
begin
	s := s.next;
end next;

end dqueue;