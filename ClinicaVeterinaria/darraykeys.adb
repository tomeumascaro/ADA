with Ada.Text_IO; 
use Ada.Text_IO;

package body darraykeys is 

procedure empty(s: out set) is 
	e: existence renames s.e;
begin
	for k in 1..b loop
		e(k):=false;
	end loop;
end empty;

procedure put(s: in out set; k: in integer; x: in item ) is 
	e: existence renames s.e;
	c: contents renames s.c;
begin
	e(k):=true;c(k):=x;
end put;

procedure update ( s: in out set; k: in integer ; x: in item) is 
	e: existence renames s.e;
	c: contents renames s.c;
begin
	if not e(k) then raise does_not_exist; end if;
	c(k):=x;
end update;

procedure get ( s: in set ; k: in integer ; x: out item) is 
	e: existence renames s.e;
	c: contents renames s.c;
begin
	if not e(k) then raise does_not_exist; end if;
	x:= c(k);
end get;

procedure remove (s: in out set; k: in integer) is 
	e: existence renames s.e;
begin
	if not e(k) then raise does_not_exist; end if;
	e(k):=false;
end remove;

function print(s: in set; k: in Integer) return item is
	c: contents renames s.c;
begin
	return c(k);
end print;

function consultesObertes (s: in set)return integer is
	e: existence renames s.e;
	x: integer;
begin
	x:=1;
	while x /= b+1 loop
		if(e(x)=false) then 
			return x;
		end if;
		x := x+1;
	end loop;
	return b+1;
end consultesObertes ;

function comprovaConsulta(s: in out set; k: in integer) return boolean is
	e: existence renames s.e;
begin
	if e(k) = true then
		return true;
	else
		return false;
	end if;
end comprovaConsulta;

procedure obrirConsulta(s: in out set; k: in integer) is
	e: existence renames s.e;
begin
	e(k):= true;
end obrirConsulta;

procedure tancarConsulta(s: in out set; k :in integer) is 
	e: existence renames s.e;
begin
	e(k):= false;
end tancarConsulta;
	
end darraykeys;