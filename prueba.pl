:-use_module(library(pce)). % libreria para que se muestre la interfaz
:-use_module(library(pce_style_item)).% se ocupa para estilos de letra y colores
:-pce_image_directory('./imagenes'). % acceso a donde se tiene guardada la carpeta de la imagen
:- dynamic color/2. %Numero de colores que se utilizan
resource(pizarronutc, image, image('pizarronutc.jpg')). % instruccion para cargar la imagen en la carpeta que esta almacenada .jpg
resource(li, image, image('logo.jpg')).
imagen_portada(Pantalla, Imagen) :- new(Figura, figure),                  %variables y funciones que se utilizan para que se pueda visualizar la imagen mediante la  interfaz grafica
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),
                                     send(Pantalla, display,Figura,point(0,0)).




inicio:- %Inicio de nuestro programa, creando el objeto de dialogo con la variable D



 new(D,dialog('SISTEMA EXPERTO UNSCH',size(800,2350))),% inicio de nuestra interfaz principal


new(Label1,label(text,' UNIVERSIDAD NACIONAL SAN CRISTOBAL DE HUAMANGA ')),% muestra texto dentro de los label

	send(Label1,colour,red), %sirve para poner los colores en las letras
new(Label2,label(text,'.....................SISTEMAS EXPERTOS...........................')),
	send(Label2,colour,red),
new(Label3,label(text,'.')),
	send(Label3,colour,blue),
new(Label4,label(text,'                    EVALUACIÓN CURRICULAR')),
	send(Label4,colour,blue),


 %llama a los label y los adjunta para mostrarlos en la ventana principal
imagen_portada(D, li),
 send(D,append(Label1)),
 send(D,append(Label2)),
 send(D,append(Label3)),
 send(D,append(Label4)),

%crea el boton que almacenamos en nuestra variable para la funcion que se ha programado anteriormente
 new(Boton1,button('Iniciar',and(message(@prolog,principal),
 and(message(D,open),message(D,free))))),
 send(Boton1,colour,blue),
 new(Bcancelar,button('Anular',and(message(D,destroy),message(D,free)))),
 send(Bcancelar,colour,blue),
%llamada de los botones para que se muestren en la interfaz
 send(D,append(Boton1)),
 send(D,append(Bcancelar)),
 send(D,open_centered).


:-inicio.

%llamando a la funcion principal de nuestro boton iniciar


principal:-
	new(D2, dialog('SISTEMA EXPERTO UNSCH',size(500,400))), %inicio de nuestra interfaz emergente
	new(Label10, label(nombre,'')),send(Label10,colour,red),%color de texto de la variable D2

        imagen_portada(D2, pizarronutc), % carga de imagen


	new(@texto,label(text,'                                           Iniciar Evaluación curricular:')),
		new(@respl,label(text,'')),
	new(Salir,button('Salir',and(message(D2,destroy),message(D2,free)))),




%creaci�n del boton para dar inicio al TEST.

	new(@boton,button('Da click para empezar',message(@prolog,botones))),

	send(D2, append(Label10)),
	new(@btncarrera,button('�analisis?')), %boton para iniciar el test
        send(D2, display,Label10,point(10,20)), %mostrar el contenido de nuestra ventana
	send(D2, display,@boton,point(310,80)), %numeros ajustan las posiciones del  boton
	send(D2, display,@texto,point(50,40)),
	send(D2, display,Salir,point(340,330)),
	send(D2, display,@respl,point(90,90)),
	send(D2,open_centered).                 %fin de la funcion

% se muestra la respuesta de tu test que realizaste por medio de las preguntas
resultado(calificado):-calificado,!.
resultado('no calificado').

calificado:-
	preguntar('¿Cuenta con Programas de Especialización/diplomado afines a las funciones?'),
	preguntar('¿Cuenta con cursos, talleres y/o seminario afines a las funciones?').


:-dynamic si/1,no/1. %suceptible a generar cambios entre verdadero o falso

preguntar(Problema):-new(A1,dialog('TEST VOCACIONAL')),
	new(L9,label(texto,'Responde las siguientes preguntas')),
	new(L10,label(text,Problema)),

% crear botones para si y no


	new(Z1,button(si,and(message(A1,return,si)))),
	new(Z2,button(no,and(message(A1,return,no)))),
	send(A1,gap,size(25,25)),

% llamada de los botones y ventanas emergentes

	send(A1,append(L9)),
	send(A1,append(L10)),
	send(A1,append(Z1)),
	send(A1,append(Z2)),

	send(A1,default_button,si),
	send(A1,open_centered), get(A1,confirm,Answer),
	write(Answer), send(A1,destroy),

%confirmacion de respuesta si y no

 (   (Answer==si)->assert(si(Problema)); %confirma las preguntas si es si en confirmacion y si es no erroneo
 assert(no(Problema)),fail).

%cada vez que el usuario contesta una pregunta la pantalla se limpria y se vuelve a preguntar
consultar(S):-(si(S)->true; (no(S)->fail; preguntar(S))).
limpiar:-retract(si(_)),fail.
limpiar:-retract(no(_)),fail.
limpiar.

% borrado de la ventana emergente para dar el resultado final
botones:-borrado,
	send(@boton,free),
	send(@btncarrera,free),

% resultado de la carrera elegida

resultado(Carrera),
	send(@texto, selection('                            Hemos analizado sus respuestas y llegado a la conclusión que usted esta:')),
	send(@respl,selection(Carrera)),
	new(@boton, button('Iniciar su evaluacion',message(@prolog, botones))),
	send(Menu, display,@boton,point(40,600)),       %llamando los resultados de la ventana emergente
	send(Menu, display,@btncarrera,point(20,50)),
	send(Menu, append, new(Ayuda, popup(Ayuda))),
	limpiar.

borrado:-send(@respl,selection('')). %fin del programa

