respuesta(si).
respuesta(no).

% Preguntas y Puntajes para cada rubro
rubro_preguntas(Rubro, Puntaje) :-
    preguntas_rubro(Rubro, Preguntas),
    hacer_preguntas(Preguntas, Puntaje).

% Preguntas de formacion academica con un peso de 30%
preguntas_rubro(rubro1, [
    ['¿Cuenta con titulo profesional? (si/no) ', 30], 
    ['¿Cuenta con maestria? (si/no) ', 10], 
    ['¿Cuenta con doctorado? (si/no) ', 10]
]).
preguntas_rubro(rubro2, [
    ['¿Cuenta con un programa de especializacion? (si/no) ', 16], 
    ['¿Cuenta con dos programas de especializacion? (si/no) ', 4], 
    ['¿Cuenta con mas de dos programas de especializacion? (si/no) ', 5]
]).
preguntas_rubro(rubro3, [
    ['¿Cuenta con un curso/ taller y/o seminario? (si/no) ', 16], 
    ['¿cuenta con dos cursos/talleres y/o seminarios? (si/no) ', 4], 
    ['¿cuenta con mas dos cursos/ talleres y/o seminarios? (si/no) ', 5]
]).

% Preguntas de Experiencia laboral general con un peso de 30%
preguntas_rubro(rubro4, [
    ['¿Tiene un maximo de 2 experiencia profesional general? (si/no) ', 60], 
    ['¿Cuenta con una experiencia profesional general mayor a 4 anios? (si/no) ', 40]
]).

% Preguntas de experiencia especifica con un peso de 40%
preguntas_rubro(rubro5, [
    ['Cuenta con un maximo de 2 anios de experiencia en la funcion y/o materia? (si/no) ', 53], 
    ['¿Cuenta con experiencia mayor a 4 anios en la funcion y/o materia? (si/no) ', 7]
]).
preguntas_rubro(rubro6, [
    ['¿Cuenta con un maximo de 2 anios de experiencia especifica asociada al Sector Publico? (si/no) ', 9], 
    ['¿Cuenta con experiencia de al menos 4 anios especifica asociada al Sector Publico? (si/no) ', 6], 
    ['¿Cuenta con experiencia mayor a 6 anios especifica asociada al Sector Publico? (si/no) ', 5]
]).
preguntas_rubro(rubro7, [
    ['¿Cuenta con un maximo de 2 anios de experiencia en el nivel especifico del puesto? (si/no) ', 9], 
    ['¿Cuenta con experiencia de al menos 4 anios en el nivel especifico del puesto? ', 6], 
    ['¿Cuenta con experiencia mayor a 6 anios especifico del puesto? (si/no) ', 5]
]).

% Predicado para hacer preguntas y obtener respuestas
preguntar(Pregunta, Respuesta) :-
    write(Pregunta),
    read(Respuesta),
    respuesta(Respuesta).

hacer_preguntas([], 0).
hacer_preguntas([[Pregunta, Puntaje] | RestoPreguntas], PuntajeTotal) :-
    preguntar(Pregunta, Respuesta),
    (Respuesta = si -> hacer_preguntas(RestoPreguntas, PuntajeAcumulado), PuntajeTotal is PuntajeAcumulado + Puntaje
    ; Respuesta = no -> PuntajeTotal is 0
    ).

% Predicado para calcular el puntaje total
calcular_puntaje_total(PuntajeTotal) :-
    rubro_preguntas(rubro1, PuntajeRubro1),
    rubro_preguntas(rubro2, PuntajeRubro2),
    rubro_preguntas(rubro3, PuntajeRubro3),
    rubro_preguntas(rubro4, PuntajeRubro4),
    rubro_preguntas(rubro5, PuntajeRubro5),
    rubro_preguntas(rubro6, PuntajeRubro6),
    rubro_preguntas(rubro7, PuntajeRubro7),
    Peso1 is (PuntajeRubro1 + PuntajeRubro2 + PuntajeRubro3) * 0.3,
    Peso2 is (PuntajeRubro4) * 0.3,
    Peso3 is (PuntajeRubro5 + PuntajeRubro6 + PuntajeRubro7) * 0.4,
    PuntajeTotal is Peso1 + Peso2 + Peso3.

% Consulta inicial para iniciar el programa
iniciar_programa :-
    calcular_puntaje_total(Puntaje),
    format('Tu puntaje total es: ~w~n', [Puntaje]),
    (Puntaje > 64 ->
        format('Calificado~n');
        format('No calificado~n')
    ).

% Consulta para iniciar el programa
:- iniciar_programa.