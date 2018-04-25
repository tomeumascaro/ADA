with Ada.Text_IO, dqueue, darraykeys, pparaula, dbinarysearchtree, Ada.containers, Ada.strings.hash, general_defs;
use Ada.Text_IO, pparaula, Ada.containers, Ada.strings, general_defs;

package clinica is

	type salaEsperes is limited private;
	type salesConsultes is limited private;
	type cclinica is limited private;

	bad_use: exception;
	space_overflow: exception;

	type mascota is record
		nom: tparaula;
	end record;

	type visita is record
		tipus: tipo_visita;
		cicles: integer;
		ciclesconsulta: integer;
		nom: mascota;
	end record;

	type consulta is record
		ocupada: boolean := false;
		ciclein: integer := 0;
		animal: visita;
	end record;

	type nodehistorial is record
		tipus_visita: tipo_visita;
		ciclein: integer;
	end record;
	
	package espera is new dqueue (visita); --coa d'un tipus de visita (per la sala d'espera)
	use espera;

	package coa_historial is new dqueue (nodehistorial); --coa d'un tipus de visita (per cada node de la t.dispersio)
	use coa_historial;

	package consultes is new darraykeys(max_consultes, consulta); --array de claus per controlar estats de les sales de les 5 consultes
	use consultes;

	function mascotaString (m: in mascota) return String; --retorna un string del nom d'una mascota

	package arbreTipusVisita is new dbinarysearchtree(integer, mascota, "<", ">", mascotaString); --arbre binari de noms de mascotes
	use arbreTipusVisita;
	
	type arrayArbres is array (1..4) of Tree; --array de 4 arbres (un per cada tipus de consulta)
	type sales is array(1..max_consultes) of consulta; --array de 5 consultes (sales on s'atenen les mascotes)

	procedure put_salaEsperes (s: in out salaEsperes; v: in visita); --insereix mascota a la sala d'espera en funcio del tipus de visita
	procedure rem_first_salaEsperes (s: in out salaEsperes; v: in visita); --elimina una visita de la sala d'espera
	function  get_first_salaEsperes (s: in salaEsperes) return visita; --retorna la visita amb mes prioritat de la sala d'espera
	function  is_empty_queues(s: in salaEsperes) return boolean; --retorna si la sala d'espera esta buida
	function  tempsDeConsulta (c: in out consulta) return integer; --retorna la duració d'un tipus de consulta
	procedure imprimir_salaEsperes(s: in salaEsperes); --imprimeix el nom de les mascotes que hi ha a la sala d'espera i el seu tipus de visita
	procedure put_mascota_clinica (cl: in out cclinica; m: in mascota); --guarda una mascota a la t.dispersio (per historial)
	procedure put_historial (cl: in out cclinica; m: in mascota; nh: in nodehistorial); --guarda una visita a l'historial d'una mascota
	procedure imprimir_historial_mascota (cl: in cclinica; m: in mascota); --imprimeix l'hisotrial de visites d'una mascota
	procedure empty_clinica (cl: out cclinica); --buida la t.dispersio i tots els historials de les mascotes
	function  consulta_per_obrir(sc: in salesConsultes) return integer; --retorna el numero de consulta que es pot obrir
	procedure obrir_consulta(sc: in out salesConsultes; k: in integer); --obri una consulta (posa true)
	procedure tancar_consulta(sc: in out salesConsultes; k: in integer); --tanca una consulta (posa false)
	function  comprova_consulta(sc: in out salesConsultes; k: in integer) return boolean; --retorna true si una consulta esta oberta (lliure/ocupada) o false si esta tancada
	procedure empty_consultes(sc: out salesConsultes); --buida totes les consultes (posa totes a false)
	procedure imprimir_historial_visita (tr: in arbreTipusVisita.Tree); --imprimeix les mascotes i el nº mascotes que han realitzat un tipus de visita
	procedure empty_historial_visites (a: out arrayArbres); --buida l'historial de tots els tipus de visita
	procedure put_historial_visita(tr: in out arbreTipusVisita.Tree; i: in integer; m: in mascota); --insereix mascota a l'historial d'un tipus de visita

private

	b: constant Ada.Containers.Hash_Type := Ada.Containers.Hash_Type(max_id);
	max_ne: constant natural := max_id * 8 / 10; --factor carrega < 80%

	type cell_state is (free, used); --estat node t.disp. lliure/ocupat

	type cell is record --node t.disp
		nom: mascota;
		st: cell_state;
		historial: coa_historial.Queue;
	end record;

	type dispersion_table is array (natural range 0..integer(b)-1) of cell; --t.dispersio hash tancat

	type cclinica is record
		td: dispersion_table;
		ne: natural;
	end record;

	type salaEsperes is record
		c_revisio: espera.Queue;
		c_cura: espera.Queue;
		c_cirugia: espera.Queue;
		c_emergencia: espera.Queue;
	end record;

	type salesConsultes is record
		c: consultes.set;
	end record;
	
end clinica;