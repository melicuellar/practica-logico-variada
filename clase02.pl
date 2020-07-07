:- encoding(utf8).
/*
En este ejercicio viene bien usar el predicado nth1/3, que relaciona un número, una lista, y el elemento de la lista
en la posición indicada por el número (empezando a contar de 1).
P.ej. prueben estas consultas
?- nth1(X,[a,b,c,d,e],d).
?- nth1(4,[a,b,c,d,e],X).
?- nth1(Orden,[a,b,c,d,e],Elem).
?- nth1(X,[a,b,c,d,e],j).
?- nth1(22,[a,b,c,d,e],X).
*/

/*
Tenemos un modelo de la red de subtes, por medio de un predicado linea/2 que 
relaciona el nombre de la linea con la lista de sus estaciones, en orden. P.ej. 
(reduciendo las lineas)
*/

linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).
linea(d,[catedral,nueveJulio,medicina,plazaItalia,carranza,congresoTucuman]).
linea(e,[bolivar,independenciaE,pichincha,jujuy,boedo,varela,virreyes]).
linea(h,[once,venezuela,humberto1ro,inclan,caseros]).
combinacion([lima,avMayo]).
combinacion([once,miserere]).
combinacion([pellegrini,diagNorte,nueveJulio]).
combinacion([independenciaC,independenciaE]).

% Se pide armar un programa Prolog que a partir de esta información permita consultar:
% a. en qué linea está una estación, predicado estaEn/2.
estaEn(Linea, Estacion):-
    linea(Linea, Estaciones),
    member(Estacion, Estaciones).

% b. dadas dos estaciones de la misma línea, cuántas estaciones hay entre ellas, p.ej. entre Perú y 
% Primera Junta hay 5 estaciones. Predicado distancia/3 (relaciona las dos estaciones y la distancia).
distancia(Estacion1, Estacion2, Distancia):-
    linea(_, Estaciones),
    nth1(Posicion1, Estaciones, Estacion1),
    nth1(Posicion2, Estaciones, Estacion2),
    Distancia is abs(Posicion1 - Posicion2).

distancia2(Estacion1, Estacion2, Distancia):-
    altura(Linea, Estacion1, Posicion1),
    altura(Linea, Estacion2, Posicion2),
    Distancia is abs(Posicion1 - Posicion2).

% c. dadas dos estaciones de distintas líneas, si están a la misma altura (o sea, las dos terceras, 
% las dos quintas, etc.), p.ej. Independencia C y Jujuy que están las dos cuartas. Predicado mismaAltura/2.
mismaAltura(Estacion1, Estacion2):-
    linea(Linea1, Estaciones1),
    linea(Linea2, Estaciones2),
    Linea1 \= Linea2,
    nth1(Posicion, Estaciones1, Estacion1),
    nth1(Posicion, Estaciones2, Estacion2).

altura(Linea, Estacion, Posicion):-
    linea(Linea, Estaciones),
    nth1(Posicion, Estaciones, Estacion).

mismaAltura2(Estacion1, Estacion2):-
    altura(Linea1, Estacion1, Pos),
    altura(Linea2, Estacion2, Pos),
    Linea1 \= Linea2.

% d. dadas dos estaciones, si puedo llegar fácil de una a la otra, esto es, si están en la misma línea, 
% o bien puedo llegar con una sola combinación. Predicado viajeFacil/2.
viajeFacil(Estacion1, Estacion2):-
    mismaLinea(Estacion1, Estacion2).
    
viajeFacil(Estacion1, Estacion2):-
    mismaLinea(Estacion1, Estacion3),
    mismaLinea(Estacion2, Estacion4),
    combinacion(Estacion3, Estacion4).

combinacion(Estacion1, Estacion2):-
    combinacion(Estaciones),
    member(Estacion1, Estaciones),
    member(Estacion2, Estaciones),
    Estacion1 \= Estacion2.


% por ej...
mismaLinea(E1, E2):-
    distancia2(E1, E2, _).

%-----------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------


/*
Ejercicio 2
En un juego de "construya su cañería", hay piezas de distintos tipos: codos, caños y 
canillas.
• De los codos me interesa el color, p.ej. un codo rojo.
• De los caños me interesan color y longitud, p.ej. un caño rojo de 3 metros.
• De las canillas me interesan: tipo (de la pieza que se gira para abrir/cerrar), 
color y ancho (de la boca).
P.ej. una canilla triangular roja de 4 cm de ancho.
*/

%  codo(Color)
%  caño(Color, Longitud)
%  canilla(Color, Ancho, Tipo)
%  extremo(Color, IzquierdoODerecho)

/*
a. Definir un predicado que relacione una cañería con su precio. Una cañería es una 
lista de piezas. Los precios son:
• codos: $5.
• caños: $3 el metro.
• canillas: las triangulares $20, del resto $12 hasta 5 cm de ancho, $15 si son de 
más de 5 cm.
*/

% La clase que viene  => precio(Cañeria, Precio):-

precio(codo(_), 5).
precio(caño(_, Longitud), Precio):- Precio is 3 * Longitud.
precio(canilla(_, _, triangular), 20).
precio(canilla(_, Ancho, Tipo), 12):- Ancho =< 5, Tipo \= triangular.
precio(canilla(_, Ancho, Tipo), 15):- Ancho > 5, Tipo \= triangular.
precio(extremo(_,_), 0).

precio(Cañeria, Precio):-
    findall(PrecioPieza, (member(Pieza, Cañeria), precio(Pieza, PrecioPieza)) , PreciosPiezas),
    sum_list(PreciosPiezas, Precio).

longitud([], 0).
longitud([_|T], Longitud):-
    longitud(T, LongitudCola),
    Longitud is LongitudCola + 1.
/*
b. Definir el predicado puedoEnchufar/2, tal que
puedoEnchufar(P1,P2)
se verifique si puedo enchufar P1 a la izquierda de P2.
Puedo enchufar dos piezas si son del mismo color, o si son de colores enchufables.
Las piezas azules pueden enchufarse a la izquierda de las rojas, y las rojas pueden 
enchufarse a la izquierda de las negras. Las azules no se pueden enchufar a la 
izquierda de las negras, tiene que haber una roja en el medio.
P.ej.
• sí puedo enchufar (codo rojo, canio negro de 3 m).
• sí puedo enchufar (codo rojo, canio rojo de 3 m) (mismo color).
• no puedo enchufar (canio negro de 3 m, codo rojo) (el rojo tiene que estar a la 
    izquierda del negro).
• no puedo enchufar (codo azul, canio negro de 3 m) (tiene que haber uno rojo en 
    el medio)
*/


% Polimorfismo
color(codo(Color), Color).
color(caño(Color, _), Color).
color(canilla(Color, _, _), Color).
color(extremo(Color, _), Color).

sonEnchufables(Color, Color).
sonEnchufables(azul, rojo).
sonEnchufables(rojo, negro).

puedoEnchufar(Pieza1, Pieza2):-
    color(Pieza1, Color1),
    color(Pieza2, Color2),
    sonEnchufables(Color1, Color2),
    Pieza2 \= extremo(Color2, izquierdo),
    Pieza1 \= extremo(Color1, derecho).

% puedoEnchufar(Pieza1, extremo(_, izquierdo)).
% puedoEnchufar(extremo(_, derecho), Pieza).

/*
c. Modificar el predicado puedoEnchufar/2 de forma tal que pueda preguntar por 
elementos sueltos o porcañerías ya armadas.
P.ej. una cañería (codo azul, canilla roja) la puedo enchufar a la izquierda de 
un codo rojo (o negro), y a la derecha de un canio azul.
Ayuda: si tengo una cañería a la izquierda, ¿qué color tengo que mirar? 
Idem si tengo una cañería a la derecha. 
*/

puedoEnchufar(Canieria, Algo):-
    last(Canieria, UltimaPieza),
    puedoEnchufar(UltimaPieza, Algo).

puedoEnchufar(Algo, [Pieza | _]):-
    puedoEnchufar(Algo, Pieza).
        
/*
d. Definir un predicado canieriaBienArmada/1, que nos indique si una cañería está bien 
armada o no. Una cañería está bien armada si a cada elemento lo puedo enchufar 
al inmediato siguiente, de acuerdo a lo indicado al definir el predicado puedoEnchufar/2. 
*/



/*
e. Modificar el predicado puedoEnchufar/2 para tener en cuenta los extremos, que son 
piezas que se agregan a las posibilidades.
De los extremos me interesa de qué punta son (izquierdo o derecho), y el color, p.ej. 
un extremo izquierdo rojo. Un extremo derecho no puede estar a la izquierda de nada, 
mientras que un extremo izquierdo no puede estar a la derecha de nada.
Verificar que canieriaBienArmada sigue funcionando.
Ayuda: resuélvanlo primero sin listas, y después agréguenle las listas. Lo de las 
listas sale en forma análoga a lo que ya hicieron, ¿en qué me tengo que fijar para 
una lista si la pongo a la izquierda o a la derecha?.
*/





/*
f. (a partir de acá son altamente difíciles!!)
Modificar el predicado canieriaBienArmada/1 para que acepte cañerías formadas por 
elementos y/u otras cañerías. P.ej. una cañería así: codo azul, 
[codo rojo, codo negro], codo negro  se considera bien armada. 
*/





/*
g. armar las cañerías legales posibles a partir de un conjunto de piezas 
(si tengo dos veces la misma pieza, la pongo dos veces, p.ej. [codo rojo, codo rojo] ).
*/



% ------------------------------------------------



perro(firulais).
perro(lazzie).
perro(bobby).
perroComun(bobby).


perroFamoso(Perro):-
    perro(Perro),
    not(perroComun(Perro)).


% ---------------------------------------------------------------------------

/*
Se organiza un juego que consiste en ir buscando distintos objetos por el mundo. 
Cada participante está en un determinado nivel, cada nivel implica ciertas tareas, 
cada tarea consiste en buscar un objeto en una ciudad.
Representamos las tareas como functores buscar(Cosa,Ciudad), y definimos el predicado 
tarea/2 de esta forma:
*/
tarea(basico, buscar(libro, jartum)).
tarea(basico, buscar(arbol, patras)).
tarea(basico, buscar(roca, telaviv)).
tarea(intermedio, buscar(arbol, sofia)).
tarea(intermedio, buscar(arbol, bucarest)).
tarea(avanzado, buscar(perro, bari)).
tarea(avanzado, buscar(flor, belgrado)). 

/*
o sea, si estoy en el nivel básico, mis tareas posibles son buscar un libro en Jartum, 
un árbol en Patras o una roca en Tel Aviv.

Para definir en qué nivel está cada participante se define el predicado nivelActual/2, de esta forma:
*/
nivelActual(pepe, basico).
nivelActual(lucy, intermedio).
nivelActual(juancho, avanzado). 
nivelActual(mati, basico).

/*
También vamos a necesitar saber qué idioma se habla en cada ciudad, qué idiomas habla 
cada persona, y el capital actual de cada persona. Esto lo representamos con los 
predicados idioma/2, habla/2 y capital/2:
*/

idioma(alejandria, arabe).
idioma(jartum, arabe).
idioma(patras, griego).
idioma(telaviv, hebreo).
idioma(sofia, bulgaro).
idioma(bari, italiano).
idioma(bucarest, rumano).
idioma(belgrado, serbio).

habla(pepe, bulgaro).
habla(pepe, griego).
habla(pepe, italiano).
habla(juancho, arabe).
habla(juancho, griego).
habla(juancho, hebreo).
habla(lucy, griego).

capital(pepe, 1200).
capital(lucy, 3000).
capital(juancho, 500). 
capital(mati, 15000). 

/*Definir los siguientes predicados:
a. destinoPosible/2 e idiomaUtil/2.
destinoPosible/2 relaciona personas con ciudades; una ciudad es destino posible para 
un nivel si alguna tarea que tiene que hacer la persona (dado su nivel) se lleva a 
cabo en la ciudad. P.ej. los destinos posibles para Pepe son: Jartum, Patras y Tel Aviv.
*/

destinoPosible(Persona, Ciudad):-
    nivelActual(Persona, Nivel),
    tarea(Nivel, buscar(_, Ciudad)).

/*
idiomaUtil/2 relaciona persona con idiomas: un idioma es útil para una persona si en 
alguno de los destinos posibles para su nivel se habla el idioma. P.ej. los idiomas 
útiles para Pepe son: árabe, griego y hebreo. 
*/
idiomaUtil(Persona, Idioma):- 
    destinoPosible(Persona, Ciudad), 
    idioma(Ciudad, Idioma).


/*
b. excelenteCompaniero/2, que relaciona dos participantes. P2 es un excelente compañero 
para P1 si habla los idiomas de todos los destinos posibles del nivel donde está P1.
P.ej. Juancho es un excelente compañero para Pepe, porque habla todos los idiomas de 
los destinos posibles para el nivel de Pepe.
Asegurar que el predicado sea inversible para los dos parámetros. 
*/
excelenteCompaniero(Participante1, Participante2):-
    capital(Participante1, _),
    capital(Participante2, _),
    Participante1 \= Participante2, 
    forall(idiomaUtil(Participante1, Idioma), habla(Participante2, Idioma)). 

/*
c. interesante/1: un nivel es interesante si se cumple alguna de estas condiciones
• todas las cosas posibles para buscar en ese nivel están vivas 
(las cosas vivas en el ejemplo son: árbol,perro y flor)
• en alguno de los destinos posibles para el nivel se habla italiano.
• la suma del capital de los participantes de ese nivel es mayor a 10000
Asegurar que el predicado sea inversible. 
*/
tieneVida(arbol).
tieneVida(perro).
tieneVida(flor).

interesante(Nivel):-
    tarea(Nivel, _),
    forall(tarea(Nivel, buscar(Algo, _)), tieneVida(Algo)).

interesante(Nivel):-
    tarea(Nivel, buscar(_, Ciudad)),
    idioma(Ciudad, italiano).

interesante(Nivel):-
    tarea(Nivel, _),
    findall(Capital, (nivelActual(Persona, Nivel), capital(Persona, Capital)), Capitales), 
    sum_list(Capitales, Total), 
    Total > 10000.

/*
d. complicado/1: un participante está complicado si: no habla ninguno de los idiomas 
de los destinos posibles para su nivel actual; está en un nivel distinto de básico y 
su capital es menor a 1500, o está en el nivel básico y su capital es menor a 500. 
*/

complicado(Participante):-
    capital(Participante,_),
    forall( idiomaUtil(Participante, Idioma), not(habla(Participante,Idioma))).

complicado(Persona):- 
    nivelActual(Persona,_),
    not( (idiomaUtil(Persona, Idioma), habla(Persona, Idioma)) ).