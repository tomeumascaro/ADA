--general_defs.ads
package general_defs is

	type tipo_visita is (revisio, cura, cirugia, emergencia);
	cic_duracio_tvisita: constant array (1..4) of integer := (3, 5, 8, 4);

	max_id: constant integer := 5000;
	max_consultes: constant integer := 5; --Nº maxim de consultes (sales per atendre les mascotes)

	max_cicles, linia, columna, nmascota, probTipusVisita, ciclesRestants,
		probMascota, probConsulta, nconsulta, nconsultesObertes, n: integer;
	ncicles, numBoxer, consultaAobrir, num: integer:=1;

end general_defs;
