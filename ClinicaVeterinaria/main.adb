--Bartomeu Mascaró Arbona (41585659A) & Telm Francesc Serra Malagrava (43217664C)
--Practica 3 (Clinica veterinaria) - Estructures de Dades - Enginyeria Informatica (UIB 2016-2017)
with Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_IO, Ada.Numerics, Ada.Numerics.Discrete_Random, drandom, pparaula, clinica, general_defs;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, drandom, pparaula, clinica, general_defs;

procedure main is

	mode, opcio: character := 'z';
	sortida: File_Type;
	origen_t: OrigenParaules(teclat); --entrada teclat
	origen_d : OrigenParaules(f_directe); --entrada fitxer
	p, nom, word, word2: tparaula;
	boxers: sales; --array de 5 consultes (sales on s'atenen les mascotes)
	v, proximaConsulta: visita;
	m: mascota;
	sesp: salaEsperes; --4 queues, una per cada tipus visita
	arbres: arrayArbres; --array de 4 arbres, un per cada tipus visita
	s: salesConsultes; --array de sales per realitzar les consultes
	cl: cclinica; --historial mascota
	nh: nodehistorial; --node historial mascota

begin

    if Argument_Count /= 2 then --Arg.1 = Nº cicles / Arg.2 = Llavor
       put_line("ERROR: Introduir 2 arguments.");
    else
    	max_cicles := integer'value(Argument(1));
    	reset_seed(integer'value(Argument(2)));

	    while mode /= 'a' and mode /= 'm' loop
	    	put_line("MANUAL (m) / AUTOMATIC (a) ?");
	    	get(origen_t, word, linia, columna);
	        mode := caracter(word,2);
	    end loop;

	    if mode = 'a' then --Automatic
	    	put_line("Simulacio realitzada, obriu el fitxer automatic.txt");
	        open(sortida, out_file, "automatic.txt");
	        set_output(sortida); --puts al fitxer
	    end if;

	    empty_consultes(s); --buidam sales de consultes
	    empty_clinica(cl); --buidam hashing (historial mascotes)
	    empty_historial_visites(arbres); --buidam arbres (historial visites)
	    obrir_consulta(s, 1); --començam amb la 1a consulta oberta

	    while ncicles <= max_cicles loop
	        if mode = 'm' then --Manual
	        	while opcio /= 'c' loop
	        		put_line("------------------------------------------------------------------");
	            	put_line("");
	                put_line("MENU:");
	                put_line("Mascotes en espera (1)");
	                put_line("Historial mascota (2)");
	                put_line("Historial tipus consulta (3)");
	                put_line("Cicle seguent (c)");
	                put("Elegeix una opcio: ");
	                get(origen_t, word2, linia, columna);
	                opcio := caracter(word2,1);
	                case opcio is
	                	when '1' => imprimir_salaEsperes(sesp);
	                	when '2' => put("Nom mascota: ");
	                            	get(origen_t, nom, linia, columna);
	                            	m.nom := nom;
	                            	imprimir_historial_mascota(cl, m);
	                	when '3' => put_line("1.Reviso / 2.Cura / 3.Cirugia / 4.Emergencia");
	                            	put("Opcio: ");
	                            	ada.Integer_Text_IO.get(n);
	                            	if n >= 1 and n <= 4 then
	                            		put_line("Mascotes que han realitzat una consulta del tipus " &integer'image(n) &":");
	                              		imprimir_historial_visita(arbres(n));
	                            	end if;
	                	when 'c' => put_line("Seguent cicle");
	                	when others => put_line("ERROR: Clicar 1,2,3,c");
	                end case;
	            end loop;
	            opcio := 'z'; --Per poder tornar entrar al bucle al proxim cicle
	        end if;
	        put_line("");
	        put_line("Cicle num: " & integer'image(ncicles));
	        put_line("------------------------------------------------------------------");

	        --Si una consulta esta buida (lliure) a l'inici del cicle, te un 10% de prob. de tancar-se
	        while numBoxer <= max_consultes loop
	            if comprova_consulta(s, numBoxer) and then boxers(numBoxer).ocupada = false then --si la consulta esta oberta i lliure
	                probConsulta := generate_random_number(99); --prob. tancar la consulta
	                if probConsulta < 10 then --10% tancar consulta
	                	nconsulta := 1;
	                	nconsultesObertes:= 0;
	                	while nconsulta <= max_consultes loop --compta consultes obertes
	                   		if comprova_consulta(s, nconsulta) then
	                    		nconsultesObertes := nconsultesObertes + 1;
	                   		end if;
	                   		nconsulta := nconsulta + 1;
	                	end loop;
	                	if nconsultesObertes > 1 then --si hi ha > 1 consulta oberta
	                   		tancar_consulta(s, numBoxer);
	                   		put_line("Tancam la consulta " &integer'image(numBoxer));
	                	end if;
	             	end if;
	            end if;
	            numBoxer := numBoxer + 1;
	        end loop;

	        --Cada inici de cicle hi ha un 10% de prob. d'obrir una nova consulta
	        probConsulta := generate_random_number(99); --prob. obrir una consulta
	        if probConsulta < 10 then --10% obrir consulta
	            consultaAobrir := consulta_per_obrir(s); --nº consulta que es pot obrir
	            if consultaAobrir <= max_consultes then --maxim 5 consultes obertes
	            	obrir_consulta(s, consultaAobrir);
	            	put_line("Obrim la consulta "& integer'image(consultaAobrir));
	            end if;
	        end if;
	        
	        --Pot entrar una nova mascota (75% prob.)
	        probMascota := generate_random_number(99); --prob. nova mascota
	        if probMascota > 25 then --si entra mascota a la clinica
	            open(origen => origen_d, nom => "mascotes");
	            nmascota := generate_random_number(size(origen_d)); --num mascota que agafam del fitxer
	            if nmascota = 0 then
	            	nmascota := 1;
	            end if;
	            get(origen_d, p, nmascota);
	            put(toString(p) & " entra a la clinica");
	            close(origen_d);

	            probTipusVisita := generate_random_number(3); --prob. tipus visita nova mascota (25% cada tipus)
	            m.nom := p;
	            v.tipus := tipo_visita'val(probTipusVisita);
	            v.cicles := ncicles - probTipusVisita;
	            v.nom := m;
	            v.ciclesconsulta := cic_duracio_tvisita(probTipusVisita+1);
	            put_line(" (" & tipo_visita'image(v.tipus) & ")");
	            put_mascota_clinica(cl, m); --guardam mascota a la t.disp.
	      		put_salaEsperes(sesp, v); --mascota entra a la sala d'espera
	        end if;

	        --Si hi ha alguna consulta lliure, la mascota amb mes prioritat de la sala d'espera hi entra
	        numBoxer := 1;
	        while numBoxer <= max_consultes loop
	            if comprova_consulta(s, numBoxer) and then boxers(numBoxer).ocupada = false then --si la consulta esta oberta i lliure
	                if is_empty_queues(sesp)=false then --si hi ha alguna mascota a la sala d'espera       
	                    proximaConsulta := get_first_salaEsperes(sesp); --agafam el mes prioritari
	                    rem_first_salaEsperes(sesp,proximaConsulta); --l'eliminam de la sala d'espera i entra a la consulta
	                    boxers(numBoxer).ocupada := true;
	                    boxers(numBoxer).ciclein := ncicles;
	                    boxers(numBoxer).animal:= proximaConsulta;
	                    put_line("Entra la mascota " & toString(proximaConsulta.nom.nom) & " a la consulta " & integer'image(numBoxer) & " (" & tipo_visita'image(proximaConsulta.tipus) & ")");
	                end if;
	            end if;
	            numBoxer := numBoxer + 1;
	        end loop;

	        --Control de cicles de les consultes
	        numBoxer := 1;
	        while numBoxer <= max_consultes loop
	            if boxers(numBoxer).ocupada then
	            	ciclesRestants := tempsDeConsulta(boxers(numBoxer));
	            	if ciclesRestants /= 0 then --si la consulta encara no ha acabat la feina
	            		put_line("A la consulta " & integer'image(numBoxer) & " li falten " & integer'image(ciclesRestants) & " cicles");
	                else --si la consulta ja ha acabat la feina
	                	put_line("La mascota " & toString(boxers(numBoxer).animal.nom.nom) & " ha sortit de la consulta " & integer'image(numBoxer) & " (" & tipo_visita'image(boxers(numBoxer).animal.tipus) & ")");
	                	boxers(numBoxer).ocupada := false;
	                	nh.tipus_visita := boxers(numBoxer).animal.tipus;
	                	nh.ciclein := boxers(numBoxer).ciclein;
	                	put_historial(cl, boxers(numBoxer).animal.nom, nh); --Guardam visita a l'historial de la mascota
	                	put_historial_visita(arbres(tipo_visita'pos(nh.tipus_visita)+1), num, boxers(numBoxer).animal.nom); --Guardam mascota a l'historial del tipus de visita que ha fet
	                	num := num + 1;

	                	--Si una consulta ha acabat la feina, te un 10% de prob. de tancar-se
	                	probConsulta := generate_random_number(99); --prob. tancar la consulta
	                    if probConsulta < 10 then --10% tancar consulta
	                    	nconsulta := 1;
	                    	nconsultesObertes:= 0;
	                    	while nconsulta <= max_consultes loop --compta consultes obertes
	                        	if comprova_consulta(s, nconsulta) then
	                        		nconsultesObertes := nconsultesObertes + 1;
	                        	end if;
	                        	nconsulta := nconsulta + 1;
	                    	end loop;
	                    	if nconsultesObertes > 1 then --si hi ha > 1 consulta oberta
	                        	tancar_consulta(s, numBoxer);
	                        	put_line("Tancam la consulta " &integer'image(numBoxer));
	                        end if;
	                	end if;
	            	end if;
	            end if;
	            numBoxer := numBoxer + 1;
	        end loop;
	   		
	   		--Control d'estats de les consultes
	        put_line("");   
	        put_line("*******************************");
	        numBoxer := 1;
	        while numBoxer <= max_consultes loop
	            if comprova_consulta(s, numBoxer) then --si consulta oberta
	            	if boxers(numBoxer).ocupada then --si consulta oberta i ocupada
	                	put_line("* La consulta " & integer'image(numBoxer) & " esta ocupada *");
	            	else --si consulta oberta i lliure
	                	put_line("* La consulta " & integer'image(numBoxer) & " esta lliure  *");
	            	end if;
	            else --si consulta tancada
	            	put_line("* La consulta " & integer'image(numBoxer) & " esta tancada *");
	            end if;
	            numBoxer:= numBoxer + 1;
	        end loop;
	        ncicles := ncicles + 1;
	        put_line("*******************************");
		end loop;
	end if;
end main;
