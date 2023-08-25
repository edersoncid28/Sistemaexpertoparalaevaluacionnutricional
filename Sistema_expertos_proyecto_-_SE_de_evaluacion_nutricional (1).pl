% Sistemas Expertos Proyecto
% Tema: sistema experto de evaluacion nutricional
% Docente: Ing. CCESSA QUINCHO, Mercedes.
% Integrantes
% - MEZA BAUTISTA, Yeisson
% - YARANGA MALLQUI, Ederson R.
% - OCHOA FLORES, Clinio F.

% HECHOS
% almacenar información sobre los rangos de valores
rango(edad, [0, 2, 5, 18, 30, 60, 150]). % Lista que indica los Rangos de edades
rango(imc, [16, 18.5, 25, 30]). % Lista que indica los Rangos de IMC

% constantes y factores de actividad
constante_actividad(sedentario, 1.2).
constante_actividad(actividad_ligera, 1.375).
constante_actividad(actividad_moderada, 1.55).
constante_actividad(actividad_intensa, 1.725).
constante_actividad(actividad_muy_intensa, 1.9).

% REGLAS

%--------------Regla para primer calculo IMC tomando en cuenta las edades, se define los limites para comparalos despues

% Reglas para determinar el estado nutricional basado en el IMC
evaluar_imc(IMC, Estado) :-
    rango(imc, [Limite1, Limite2, Limite3, _]), % Para llamar a la lista rango(imc [16, 18.5, 25, 30])
    (IMC < Limite1 -> Estado = muy_bajo_peso; % si IMC < 16
    IMC < Limite2 -> Estado = bajo_peso; % si IMC < 18.5
    IMC < Limite3 -> Estado = peso_normal; % si IMC < 25
    Estado = sobrepeso). % si IMC < 30

%--------------Regla para el calculo de estado de anemia

% Reglas para evaluar el estado de hemoglobina
evaluar_hemoglobina(Nivel, Estado) :- % toma el valor que se ingreso de nivel y devuelve estado
    (Nivel < 12 -> Estado = anemia; % anemia si es menor a 12
    Estado = normal). % normal si es mayor igual a 12

%--------------Regla para el calculo de estado de IMC

evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc) :-
    % Calcula el IMC
    IMC is Peso / (Talla * Talla), % formula para calcular IMC 
    
    % Determina el estado nutricional basado en el IMC
    evaluar_imc(IMC, EstadoIMC), % Con el IMC calculado, llamamos a la regla evaluar imc para obtener el estado (muy bajo peso, bajo peso, peso normal, sobrepeso)
    
    % Determina el rango de edad
    rango(edad, RangosEdad), % Se usa rango para obtener las lista RangoEdad que tiene los limites de edad predifinidos
    between(1, 6, Index), % Supongamos que hay 6 rangos de edades % Generar un rango de 1 al 6 y asignarlos a la variable Index o indice
    nth1(Index, RangosEdad, LimiteEdad), % Para obtener el primer elemento de la lista en la posicion index
    
    % Evalúa el estado nutricional final basado en edad, IMC
    (Edad < LimiteEdad -> % Si la edad que se captura es menor al limite de edad de la lista
        Resultado_imc = EstadoIMC). % Se guarda el Resultado_imc.

%--------------Reglas para el calculo de kilocalorias en varones y mujeres

% Reglas: cálculo de kilocalorías diarias necesarias para hombres y mujeres
kilocalorias_hombres(Peso, Talla, Edad, Actividad, Kilocalorias) :-
    TMB is (10 * Peso) + (6.25 * Talla) - (5 * Edad) + 5, % Se usa la formula con los datos ingresados
    constante_actividad(Actividad, Factor), % llama a los hechos de actividad para obtener el factor, ejemplo constante_actividad(sedentario, 1.2).
    Kilocalorias is TMB * Factor.

kilocalorias_mujeres(Peso, Talla, Edad, Actividad, Kilocalorias) :-
    TMB is (10 * Peso) + (6.25 * Talla) - (5 * Edad) -161, % Se usa la formula con los datos ingresados
    constante_actividad(Actividad, Factor), % llama a los hechos de actividad para obtener el factor, ejemplo constante_actividad(sedentario, 1.2).
    Kilocalorias is TMB * Factor.


%--------------Reglas para las dietas nutricional

recomendacion(Edad, Talla, Peso, Resultado_imc) :- 
    evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc), % con la reglar evaluar estado imc para obtener Resultado_imc
    Resultado_imc == peso_normal,nl,
    write('Se recomienda una: Dieta equilibrada estandar'),nl,
    write('Compuesta por:'),nl,
    write('- Carbohidratos: 45% a 65% como Panes, Granos, Frutas, Leche o alimentos con azucar. '),nl,
    write('- Proteínas: 10% a 35% como Carne, Pescado, Mariscos, Leche o semillas. '),nl,
    write('- Grasas: 20% a 35% como Aceites, Mantequilla, Productos animales o Frutos secos.').

recomendacion(Edad, Talla, Peso, Resultado_imc) :-
    evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc),
    Resultado_imc == sobrepeso,nl,
    write('Se recomienda una: Dieta baja en carbohidratos'),nl,
    write('Compuesta por:'),nl,
    write('- Carbohidratos: 5% a 20% como Panes, Granos, Frutas, Leche o alimentos con azucar. '),nl,
    write('- Proteinas: 25% a 35% como Carne, Pescado, Mariscos, Leche o semillas. '),nl,
    write('- Grasas: 30% a 60% como Aceites, Mantequilla, Productos animales o Frutos secos. ').

recomendacion(Edad, Talla, Peso, Resultado_imc) :-
    evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc),
    Resultado_imc ==  bajo_peso,nl, 
    write('Se recomienda una: Dieta alta en proteínas'),nl,
    write('Compuesta por:'),nl,
    write('- Carbohidratos: 20% a 40% como Panes, Granos, Frutas, Leche o alimentos con azucar. '),nl,
    write('- Proteinas: 30% a 50% como Carne, Pescado, Mariscos, Leche o semillas. '),nl,
    write('- Grasas: 25% a 35% como Aceites, Mantequilla, Productos animales o Frutos secos. ').

recomendacion(Edad, Talla, Peso, Resultado_imc) :-
    evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc),
    Resultado_imc ==  muy_bajo_peso,nl, 
    write('Se recomienda una: Dieta alta en proteínas'),nl,
    write('Compuesta por:'),nl,
    write('- Carbohidratos: 20% a 40% como Panes, Granos, Frutas, Leche o alimentos con azucar. '),nl,
    write('- Proteinas: 30% a 50% como Carne, Pescado, Mariscos, Leche o semillas. '),nl,
    write('- Grasas: 25% a 35% como Aceites, Mantequilla, Productos animales o Frutos secos. ').

% Regla para iniciar el sistema de nutrición

e :- write('** Bienbenido al sistema experto de nutricion ** '),nl,nl,
    write('¿Cual es su genero? elija la opcion 1 o 2: '),
	nl,write('1 masculino'),
	nl,write('2 femenino'),nl,
    read(Respuesta),
    (
        Respuesta = 1 -> ejecutar_sistema_hombres ; % Si la respuesta es 1, ejecuta regla 1
        Respuesta = 2 -> ejecutar_sistema_mujeres ; % Si la respuesta es 2, ejecuta regla 2
        write('Respuesta inválida') % Manejo de respuesta inválida
    ).

% Ejecutar sistema para hombres y mujeres

ejecutar_sistema_hombres :-
    write('Ingrese su edad: '), read(Edad),
    write('Ingrese su talla (en metros): '), read(Talla),
    write('Ingrese su peso (en kg): '), read(Peso),
    write('Ingrese su nivel de hemoglobina: '), read(NivelHemoglobina),
    write('Elija entre: sedentario. / actividad_ligera. / actividad_moderada. / actividad_intensa./ actividad_muy_intensa.'),nl,
    write('Ingrese su nivel de actividad fisica: '), read(Actividad),
    

    kilocalorias_hombres(Peso, Talla, Edad, Actividad, Kilocalorias),
    evaluar_hemoglobina(NivelHemoglobina, Estadohemoglobina),
    evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc), nl,
    write('** Resultado de la evaluacion **'),nl,nl,
    write('Su estado de IMC es: '), write(Resultado_imc), nl,    
    write('Su estado de hemoglobina es: '), write(Estadohemoglobina), nl,
    write('Las kilocalorias que consume su cuerpo es un total de: '), write(Kilocalorias),nl,
    recomendacion(Edad, Talla, Peso, Resultado_imc).

ejecutar_sistema_mujeres :-
    write('Ingrese su edad: '), read(Edad),
    write('Ingrese su talla (en metros): '), read(Talla),
    write('Ingrese su peso (en kg): '), read(Peso),
    write('Ingrese su nivel de hemoglobina: '), read(NivelHemoglobina),
    write('Elija entre: sedentario. / actividad_ligera. / actividad_moderada. / actividad_intensa./ actividad_muy_intensa.'),nl,
    write('Ingrese su nivel de actividad fisica: '), read(Actividad),
    

    kilocalorias_mujeres(Peso, Talla, Edad, Actividad, Kilocalorias),
    evaluar_hemoglobina(NivelHemoglobina, Estadohemoglobina),
    evaluar_estado_imc(Edad, Talla, Peso, Resultado_imc), nl,
    write('** Resultado de la evaluacion **'),nl,nl,
    write('Su estado de IMC es: '), write(Resultado_imc), nl,   
    write('Su estado de hemoglobina es: '), write(Estadohemoglobina), nl,
    write('Las kilocalorias que consume su cuerpo es un total de: '), write(Kilocalorias),nl,
    recomendacion(Edad, Talla, Peso, Resultado_imc).

