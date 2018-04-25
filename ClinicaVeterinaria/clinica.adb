package body clinica is

--Insereix mascota a la sala d'espera en funcio del tipus de visita
procedure put_salaEsperes (s: in out salaEsperes; v: in visita) is
begin
	case v.tipus is
		when revisio => put(s.c_revisio, v); --dqueue.adb
		when cura => put(s.c_cura, v);
		when cirugia => put(s.c_cirugia, v);
		when emergencia => put(s.c_emergencia, v);
	end case;

end put_salaEsperes;

--Guarda una mascota a la t.dispersio (per historial)
procedure put_mascota_clinica (cl: in out cclinica; m: in mascota) is 
	i, i0: integer;
	na: natural;
begin
	i0 := integer(hash(toString(m.nom)) mod b);
	i := i0;
	na := 0;
	while cl.td(i).st = used and then cl.td(i).nom.nom /= m.nom loop
		na := na + 1;
		i := (i0+na) mod integer(b);
	end loop;
	if cl.ne = max_ne then
		raise space_overflow;
	end if;

	if cl.td(i).st /= used then
		cl.td(i).st := used;
		cl.td(i).nom := m;
		cl.ne := cl.ne + 1;
	end if;
end put_mascota_clinica;

--Guarda una visita a l'historial d'una mascota
procedure put_historial (cl: in out cclinica; m: in mascota; nh: in nodehistorial) is
	i, i0: integer;
	na: natural;
begin
	i0 := integer(hash(toString(m.nom)) mod b);
	i := i0;
	na := 0;
	while cl.td(i).st = used and then cl.td(i).nom.nom /= m.nom loop
		na := na + 1;
		i := (i0+na) mod integer(b);
	end loop;

	put(cl.td(i).historial, nh); --put queue historial (dqueue.adb)

end put_historial;

--Elimina una visita de la sala d'espera
procedure rem_first_salaEsperes (s: in out salaEsperes; v: in visita) is
	tp:tipo_visita renames v.tipus;
begin
	--put_line(tipo_visita'image(tp));
	case tp is
		when revisio => rem_first(s.c_revisio);  --dqueue.adb
		when cura => rem_first(s.c_cura);
		when cirugia => rem_first(s.c_cirugia);
		when emergencia => rem_first(s.c_emergencia);
	end case;
end rem_first_salaEsperes;

--Retorna la visita amb mes prioritat de la sala d'espera
function get_first_salaEsperes (s: in salaEsperes) return visita is
	revisio, cura, cirugia, emergencia: visita;
	crevisio, ccura, ccirugia, cemergencia: integer; --cicles de cada consulta
	min, min1, min2: integer;
begin
	if is_empty(s.c_revisio) then --dqueue.adb
		crevisio := 99999;
	else
		revisio := get_first(s.c_revisio); --dqueue.adb
		crevisio := revisio.cicles;
	end if;

	if is_empty(s.c_cura) then
		ccura := 99999;
	else
		cura := get_first(s.c_cura);
		ccura := cura.cicles;
	end if;

	if is_empty(s.c_cirugia) then
		ccirugia := 99999;
	else
		cirugia := get_first(s.c_cirugia);
		ccirugia := cirugia.cicles;
	end if;

	if is_empty(s.c_emergencia) then
		cemergencia := 99999;
	else
		emergencia := get_first(s.c_emergencia);
		cemergencia := emergencia.cicles;
	end if;

	min1 := integer'min(crevisio, ccura);
	min2 := integer'min(ccirugia, cemergencia);
	min := integer'min(min1, min2);
	if (min = crevisio ) then
		return revisio;
	end if;
	if (min = ccura) then
		return cura;
	end if;
	if (min = ccirugia) then
		return cirugia;
	end if;
	return emergencia; --si no és cap dels anteriors, serà emergencia


end get_first_salaEsperes;

--Retorna la duració d'un tipus de consulta
function tempsDeConsulta (c: in out consulta) return integer is
begin
	c.animal.ciclesconsulta := c.animal.ciclesconsulta-1;
	return c.animal.ciclesconsulta;
end tempsDeConsulta;

--Retorna si la sala d'espera esta buida
function is_empty_queues(s: in salaEsperes) return boolean is       
begin
	if is_empty(s.c_revisio) and then is_empty(s.c_cura) and then 
	is_empty(s.c_cirugia) and then is_empty(s.c_emergencia) then --dqueue.adb
		return true;
	else
		return false;
	end if;
end is_empty_queues;

--Imprimeix el nom de les mascotes que hi ha a una coa de la sala d'espera i el seu tipus de visita
procedure imprimir_coaEspera(q: in espera.Queue) is
	x: visita;
	it: espera.iterator;
begin
	first(q, it);
	while (is_valid(it)) loop
		get(q, it, x);
		put_line(toString(x.nom.nom) & " (" & tipo_visita'image(x.tipus) & ")");
		next(q, it);
	end loop;
end imprimir_coaEspera;

--Imprimeix el nom de les mascotes que hi ha a la sala d'espera i el seu tipus de visita
procedure imprimir_salaEsperes(s: in salaEsperes) is
begin
	put_line("");
	put_line("MASCOTES EN ESPERA:");
	if is_empty(s.c_revisio) and then is_empty(s.c_cura) and then is_empty(s.c_cirugia) and then is_empty(s.c_emergencia) then
		put_line("No hi ha cap mascota a la sala d'espera");
	else
		imprimir_coaEspera(s.c_revisio);
		imprimir_coaEspera(s.c_cura);
		imprimir_coaEspera(s.c_cirugia);
		imprimir_coaEspera(s.c_emergencia);
	end if;

end imprimir_salaEsperes;

--Retorna un string del nom d'una mascota
function mascotaString (m: in mascota) return String is
begin
	return toString(m.nom);
end mascotaString;

--Imprimeix les mascotes i el nº mascotes que han realitzat un tipus de visita
procedure imprimir_historial_visita (tr: in arbreTipusVisita.Tree) is
begin
	print_tree(tr); --dbinarysearchtree.adb
end imprimir_historial_visita;

--Buida l'historial de tots els tipus de visita
procedure empty_historial_visites (a: out arrayArbres) is
begin
	for i in 1..a'length loop
		empty(a(i)); --dbinarysearchtree.adb
	end loop;
end empty_historial_visites;

--Insereix mascota a l'historial d'un tipus de visita
procedure put_historial_visita(tr: in out arbreTipusVisita.Tree; i: in integer; m: in mascota) is 
begin
	put_tree(tr,i,m); --dbinarysearchtree.adb
end put_historial_visita;

--Imprimeix l'hisotrial de visites d'una mascota
procedure imprimir_historial_mascota (cl: in cclinica; m: in mascota) is 
	it: coa_historial.iterator;
	i, i0: integer;
	na: natural;
	nh: nodehistorial;
begin
	i0 := integer(hash(toString(m.nom)) mod b);
	i := i0;
	na := 0;
	while cl.td(i).st = used and then cl.td(i).nom.nom /= m.nom loop
		na := na + 1;
		i := (i0+na) mod integer(b);
	end loop;
	if (cl.td(i).st = free) then
		put_line("ERROR: Aquesta mascota no ha entrat mai a la clinica.");
	else
		if is_empty(cl.td(i).historial) then  --dqueue.adb
			put_line("Aquesta mascota encara no ha realitzat cap consulta.");
		else
			first(cl.td(i).historial, it);  --dqueue.adb
			while (is_valid(it)) loop --dqueue.adb
				get(cl.td(i).historial, it, nh); --dqueue.adb
				put_line(tipo_visita'image(nh.tipus_visita) &" (Cicle entrada: " &nh.ciclein'Img &")");
				next(cl.td(i).historial, it); --dqueue.adb
			end loop;
		end if;
	end if;
end imprimir_historial_mascota;

--Buida la t.dispersio i tots els historials de les mascotes
procedure empty_clinica (cl: out cclinica) is
begin
	for i in 0..integer(b)-1 loop
		cl.td(i).st := free;
		empty(cl.td(i).historial); --dqueue.adb
	end loop;
	cl.ne := 0;
end empty_clinica;

--Retorna el numero de consulta que es pot obrir
function consulta_per_obrir(sc: in salesConsultes) return integer is
begin
	return consultesObertes(sc.c); --darraykeys.adb
end consulta_per_obrir;

--Obri una consulta (posa true)
procedure obrir_consulta(sc: in out salesConsultes; k: in integer) is
begin
	obrirConsulta(sc.c, k); --darraykeys.adb
end obrir_consulta;

--Tanca una consulta (posa false)
procedure tancar_consulta(sc: in out salesConsultes; k: in integer) is
begin
	tancarConsulta(sc.c, k); --darraykeys.adb
end tancar_consulta;

--Retorna true si una consulta esta oberta (lliure/ocupada) o false si esta tancada
function comprova_consulta(sc: in out salesConsultes; k: in integer) return boolean is
begin
	return comprovaConsulta(sc.c, k); --darraykeys.adb
end comprova_consulta;

--Buida totes les consultes (posa totes a false)
procedure empty_consultes(sc: out salesConsultes) is
begin
	empty(sc.c); --darraykeys.adb
end empty_consultes;

end clinica;