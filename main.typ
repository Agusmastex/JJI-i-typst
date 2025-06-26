#set page(
  margin: (y: 3cm, x: 2.5cm),
  paper: "a4",
)
#set text(
  font: "Arial",
  size: 11pt,
  lang: "es",
)
#set columns(gutter: 1cm)
#show heading: set text(size: 11pt)
#show heading: set block(below: 1.5em, above: 3em)
#set heading(numbering: "1.1.")
#set cite(form: "normal")
#set ref(supplement: none)
#show figure: set par(leading: 1em)

// Title header
#set align(center)
#v(-2cm)
#image("imgs/header.png", width: 16.5cm)
#v(0.45cm)
#set par(
  leading: 0.32cm,
  spacing: 0pt,
)
#text(12pt)[[INGENIERÍA Y TECNOLOGÍA]]
#v(11pt)
#set math.equation(numbering: "(1)")

#show math.equation.where(block: true): set block(spacing: 1.2em)

//*Modelado y simulación 1D del flujo ascendente agua-vapor con calefacción externa usando el Modelo de Equilibrio Homogéneo 
*Análisis termohidráulico unidimensional del flujo ascendente agua-vapor en régimen estacionario mediante el Modelo de Equilibrio Homogéneo
* \
Autor: Acevedo, Mateo; mateo.acevedo.000\@gmail.com \
Co-autores: Lima, Leon; Mangiavacchi, Norberto \
Orientador: Shin, Hyun Ho \
Departamento de Aplicaciones Industriales, Facultad de Ciencias Químicas,\ Universidad Nacional de Asunción
#v(1cm)
#line(length: 100%)

// Abstract y Resumen
#set align(left)
#set par(
  leading: 1.5em,
  spacing: 3em,
  justify: true,
)

#text(lang: "en")[
*Abstract*\

Due to the widespread use of natural circulation loops in passive safety systems of nuclear reactors, there is significant interest in modeling the phenomena involved in the dynamics of two-phase flow in such systems.
This work explores the performance of the one-dimensional Homogeneous Equilibrium Model (HEM) to simulate steady-state water–steam flows in the ascending section of a natural circulation loop.
The modeled domain corresponds to a vertical annulus that includes a heated region followed by an adiabatic section.
The studied model is based on three conservation equations, mass, momentum, and energy, formulated for the water–steam mixture.
These equations were discretized using a finite difference upwind scheme and solved via the Newton-Raphson method, with numerical evaluation of the Jacobian matrix.
The simulation results were compared with data from the literature, including experimental measurements and simulations performed with the RELAP5/MOD3.3 code, a widely used tool in the thermal-hydraulic analysis of nuclear reactors.
The HEM showed good agreement with temperature profiles but exhibited limitations in predicting the pressure drop beyond the boiling point, as well as in accurately estimating the void fraction profile, particularly in the presence of subcooled boiling and condensation phenomena.

Keywords:
Two-phase flow,
One-dimensional Homogeneous Equilibrium Model (HEM),
Natural circulation loop,
Finite difference method,
Passive cooling systems.

]

#pagebreak()

*Resumen*\
Debido al uso extendido de ciclos de circulación natural en sistemas de seguridad pasivos de los reactores nucleares, existe un alto interés en modelar los fenómenos que intervienen en la dinámica del flujo bifásico en estos sistemas.
En este trabajo se explora el desempeño del Modelo de Equilibrio Homogéneo (HEM, por sus siglas en ingles) unidimensional para simular flujos de agua-vapor en estado estacionario en la sección ascendente de un ciclo de circulación natural.
El dominio modelado corresponde a un ánulo vertical que incluye una región de calentamiento seguida de una sección adiabática.
El modelo estudiado se basa en tres ecuaciones de conservación: masa, cantidad de movimiento y energía, formuladas para la mezcla agua-vapor.
Estas ecuaciones fueron discretizadas mediante un esquema upwind de diferencias finitas, y resueltas utilizando el método de Newton-Raphson, con evaluación numérica del jacobiano.
Los resultados de las simulaciones con el modelo estudiado se compararon con los resultados presentados en la literatura compuestos por datos experimentales y simulaciones obtenidas con el código RELAP5/MOD3.3, ampliamente utilizado en el análisis termo-hidráulico de reactores nucleares.
Se observa que el modelo estudiado reproduce con fidelidad los perfiles de temperatura, aunque presenta limitaciones al predecir la caída de presión a partir del punto de ebullición, así como en la estimación del perfil de fracción de vacío, particularmente en presencia de fenómenos como la ebullición subenfriada y la condensación.


Palabras clave:
//
Flujo bifásico,
Modelo de Equilibrio Homogéneo (HEM) unidimensional,
Ciclo de circulación natural,
Diferencias finitas,
// Método de Newton-Raphson,
Sistemas de refrigeración pasivos.
// Seguridad nuclear,


#pagebreak()

// Main body

#set page(
  columns: 2,
  numbering: "1",
  number-align: right,
)

= Introducción


Los sistemas de seguridad pasivos han ganado creciente protagonismo en el diseño de reactores nucleares @IAEA-SSR21, especialmente tras el accidente de Fukushima en 2011, que evidenció las limitaciones de los sistemas activos dependientes de fuentes externas de energía. 
A diferencia de estos últimos, los sistemas pasivos operan aprovechando fenómenos físicos naturales, como la gravedad, la convección natural o las diferencias de presión @IAEA-TECDOC-626.

//Con el accidente de Fukushima en 2011, inició un proceso de transición de los sistemas de seguridad activos hacia los sistemas de seguridad pasivos en el campo de la seguridad nuclear
// @moving-to-passive-designs
//@IAEA-SSR21.
// @role-of-passive-severe-accident
//Con los sistemas de seguridad pasivos, se opta por depender de fenómenos físicos naturales como la gravedad o las diferencias de presión, en lugar de sistemas que dependen de fuentes de energía externa como bombas, ventiladores, u otros elementos activos @IAEA-TECDOC-626.

La ventaja de estos sistemas de seguridad pasivos yace en su robustez ante escenarios de accidentes severos
@ESBWR-LOCA.
En situaciones donde un evento de pérdida de refrigerante se ve acompañado por la interrupción del suministro eléctrico, ya sea desde la red o desde generadores de respaldo, los sistemas de refrigeración activos no pueden cumplir su función de disipar el calor residual del núcleo. Esta fue precisamente la situación ocurrida durante el accidente de Fukushima, donde la pérdida total de energía impidió la operación de los sistemas de enfriamiento, agravando significativamente las consecuencias del evento.


En este contexto, la incorporación de sistemas de refrigeración pasivos en los reactores nucleares resulta fundamental, ya que permiten disipar el calor residual generado por la reacción nuclear durante un periodo suficientemente prolongado, brindando así el margen necesario para implementar medidas correctivas y evitar una catástrofe nuclear.
// @cite here

Una de las configuraciones más empleadas en estos sistemas es el Ciclo de Circulación Natural (_Natural Circulation Loop_, NCL), el cual permite remover calor sin necesidad de elementos activos. En este tipo de ciclos, el flujo del refrigerante es impulsado únicamente por el calor proveniente del núcleo, aprovechando las diferencias de densidad inducidas tanto por los gradientes de temperatura como por los cambios de fase del fluido.


//Dado esto, la implementación de sistemas de refrigeración pasivos en los reactores nucleares es crucial, de modo a lograr disipar el calor residual de la reacción nuclear por un lapso de tiempo suficiente para dar lugar a que puedan tomarse medidas correctivas necesarias para evitar una catástrofe nuclear.
// @cite here

//Un diseño común utilizado para refrigerar el núcleo en caso de accidentes es el Ciclo de Circulación Natural (_Natural Circulation Loop_, NCL).
//Los NCLs impulsan el flujo de agua refrigerante utilizando únicamente el calor del núcleo como fuente de energía.
//El flujo ocurre debido a diferencias de densidad causadas tanto por cambios en la temperatura, como cambios de fase. 


#place(
  auto,
  //scope: "parent",
  float: true,
  clearance: 1.5cm,
  [#figure(
    image("figs/loop.svg"),
    caption: [Esquema de un ciclo de circulación natural bifásico],

  ) <loop>]
)

En la Figura @loop puede observarse un esquema de un NCL prototípico.
La energía ingresa en el sistema mediante un calentador, que representa el calor que desea disiparse. Esto produce un aumento de la temperatura en el fluido refrigerante (agua), lo que a su vez produce una disminución de su densidad.
Por fuerzas de flotación, el agua se eleva a través del tramo vertical de la tubería, y continúa su camino hasta llegar al condensador.
En el condensador el agua vuelve a enfriarse, disminuyendo su temperatura y aumentando nuevamente su densidad. 
Por fuerzas de gravedad, el agua cae por la tubería vertical y se encamina al calentador, completando el ciclo.

Los NCLs pueden ser diseñados para operar tanto en régimen monofásico como bifásico.
En el primer caso, el agua se mantiene en todo momento en forma líquida, y las fuerzas de flotación se manifiestan enteramente por la expansión térmica del líquido.
En el régimen bifásico se permite que el agua experimente un cambio de fase, vaporizándose parcialmente.
En este caso, las fuerzas de flotación son más intensas, debido al cambio abrupto de densidad asociado a la formación de la fase vapor.

//En este caso las fuerzas de flotación son mayores, dado que son producto también del cambio abrupto de densidad producido por la aparición de la fase vapor.

Los NCLs que operan en régimen monofásico están limitados por el umbral impuesto por la temperatura de saturación del fluido @bhattacharyya. 
Por ello, existe un marcado interés en modelar los fenómenos bifásicos que emergen en estos sistemas, dado que permiten extender su capacidad de remoción de calor más allá de dicho límite.
//cite

//Los NCLs monofásicos se hallan restringidos por el criterio de la temperatura de saturación @bhattacharyya.
//De este modo existe un gran interés en modelar los fenómenos bifásicos emergentes que tienen lugar en este tipo de NCLs.

//El modelado de los flujos bifásicos presenta dificultades matemáticas, en tanto es necesario rastrear las múltiples interfaces deformables entre las fases y tomar en cuenta las discontinuidades en las propiedades del fluido que ocurren en ellas @Ishii.

El modelado de flujos bifásicos plantea importantes desafíos matemáticos, ya que implica rastrear múltiples interfaces deformables entre las fases y considerar las discontinuidades en las propiedades del fluido que se manifiestan en dichas interfaces @Ishii.

Para superar estas dificultades, una metodología comúnmente empleada en el modelado de flujos bifásicos en tuberías consiste en realizar un promediado sobre la sección transversal del conducto, lo que permite obtener modelos unidimensionales @Ishii.

//Debido a esto, la metología comúnmente utilizada en el modelado de flujos bifásicos en tuberías es el de promediar las cantidades en la sección transversal, obteniéndose un modelo unidimensional.
//Este es el caso del modelo _two-fluid_ y el modelo _drift-flux_ @Ishii.

En la actualidad, existen diversos códigos de simulación complejos y ampliamente utilizados, como RELAP5 @RELAP y TRACE @TRACE, que implementan modelos de flujo bifásico unidimensional para el análisis termo-hidráulico de sistemas en reactores nucleares.



//Existen ya una diversidad de resolvedores complejos de uso comercial como
//RELAP5 y TRACE, que modelan el flujo bifásico 1D en los sistemas térmico-hidráulicos de un reactor nuclear @RELAP @TRACE.

Sin embargo, el uso de estos códigos comerciales implica además de su costo monetario de la licencia, una elevada complejidad para modificar su código fuente para análisis e investigaciones posteriores.
En este contexto, se considera fundamental el desarrollo de un código propio que no solo permita simular el comportamiento estacionario del flujo bifásico, sino que también sea lo suficientemente flexible y transparente como para ser modificado y adaptado en estudios posteriores, tales como análisis de estabilidad y sensibilidad. Esta necesidad justifica la elección de un modelo simplificado que pueda ser implementado, comprendido y extendido con facilidad.


//computacional y una curva de aprendizaje considerable, lo que dificulta su aplicación en etapas tempranas de diseño o en estudios exploratorios. En este contexto, surge la necesidad de evaluar modelos simplificados que, pese a sus limitaciones, permitan capturar los fenómenos dominantes del flujo bifásico con un costo computacional reducido y mayor facilidad de implementación.



//Así, en este trabajo se presenta la implementación numérica de un modelo simplificado, el Modelo de Equilibrio Homogéneo (_Homogeneous Equilibrium Model_, HEM), en el lenguaje de programación Julia, para la simulación del régimen estacionario de una de las secciones de un ciclo de circulación natural.

Así, el presente trabajo se enfoca en la implementación en el lenguaje de programación Julia @Julia y validación de un modelo unidimensional de equilibrio homogéneo (_Homogeneous Equilibrium Model_, HEM) para simular el flujo bifásico agua-vapor en estado estacionario, aplicado a la sección ascendente de un ciclo de circulación natural.
Dicha sección es una de las más crítica en el modelado debido a los efectos del cambio de fase que conlleva a discontinuidades en las propiedades y modificaciones en las pérdidas por fricción y en la transferencia de energía. 

El dominio modelado corresponde a un ánulo vertical que incluye una región de calentamiento seguida de una sección adiabática, configuraciones que reflejan condiciones típicas en sistemas de refrigeración pasiva de reactores nucleares.

El modelo matemático se compone de las ecuaciones de conservación de masa, cantidad de movimiento y energía de la mezcla agua-vapor, formuladas bajo el supuesto de equilibrio térmico y mecánico entre fases. Estas ecuaciones fueron discretizadas mediante un esquema _upwind_ de diferencias finitas y resueltas empleando el método de Newton-Raphson, con evaluación numérica del jacobiano. 

Finalmente, los resultados obtenidos se comparan con datos disponibles en la literatura, que incluyen tanto mediciones experimentales como simulaciones realizadas con el código RELAP5/MOD3.3, con el objetivo de evaluar el desempeño y las limitaciones del modelo HEM en la predicción de variables como la fracción de vacío, la temperatura y la presión a lo largo del sistema.

//Se muestra que el modelo HEM reproduce con fidelidad el perfil de temperaturas de tanto las mediciones experimentales de la literatura, como los resultados producidos por RELAP5/MOD3.3.
//Sin embargo, se observaron desviaciones en el perfil de presiones y de fracción de vacío.
//El modelo implementado no reproduce cuantitativamente las fracciones de vacío experimentales, y posee dificultades en capturar fenómenos bifásicos como la ebullición subenfriada, y la condensación.

Este trabajo se desarrolla como sigue: en la Sección 2, se presentan los objetivos del trabajo. Los materiales y métodos, en donde se presentan el modelo y el método numérico se exponen en la Sección 3, y en la Sección 4 se muestran los resultados obtenidos con las comparaciones y discusiones de los mismos.
Finalmente, se presentan los conclusiones en la Sección 5.


//En este trabajo, se presenta la implementación numérica de un modelo simplificado, el modelo HEM _(Homogeneous Equilibrium Model)_ en el lenguaje de programación Julia para la simulación del estado estacionario del sistema.

// El trabajo presenta un modelo de flujo en estado estacionario.
// Esta decisión se fundamenta tanto en que las mediciones disponibles en la literatura analizan al sistema cuando ya alcanzó el estado estacionario, como en el hecho de que las condiciones de frontera elegidas producen un estado estacionario natural.
// Las inestabilidades transitorias emergen de analizar el sistema completo.

// El dominio computacional consiste de una subsección de un NCL, la tubería vertical a través de la cual el fluido recibe la energía del calentador y asciende.
// La elección de este dominio restringido se justifica en la disponibilidad de mediciones experimentales para esta subsección del NCL que se utilizaron para validar el modelo y su implementación.

= Objetivos
*Objetivo general* \
// Implementar y validar un resolvedor de flujo agua-vapor en estado estacionario en una tubería vertical utilizando el modelo HEM 1D.
Explorar el desempeño del modelo HEM para modelar flujos de agua-vapor en estado estacionario en un ánulo vertical con calentamiento.

*Objetivos específicos* \
- Derivar las ecuaciones 1D de conservación de masa, cantidad de movimiento y energía para un flujo bifásico agua-vapor en un ánulo vertical.
- Elegir un esquema de discretización y un método numérico para la resolución de las ecuaciones.
- Implementar el método numérico en el lenguaje de programación Julia.
// - Validar el modelo y la implementación empleando datos experimentales de la literatura.
- Comparar los resultados del modelo con resultados de la literatura.

= Materiales y Métodos
== Modelado matemático
Se estudió el flujo bifásico agua-vapor en estado estacionario en un ánulo vertical con un tramo inicial a través de la cual ingresa calor uniformemente, considerando al resto del ánulo como adiabático.

Considerando a la mezcla agua-vapor como un único pseudo-fluido, se obtuvieron las ecuaciones de conservación de masa, cantidad de movimiento, y energía de la mezcla.
Esta consideración de que ambas fases poseen una única presión, temperatura y velocidad requiere un alto grado de acoplamiento térmico y mecánico para su validez @Ishii.
Las ecuaciones unidimensionales se obtienen a partir del promedio sobre la sección transversal del dominio.

Sistema de ecuaciones del modelo HEM utilizadas en este trabajo corresponden a las formulaciones reportadas en la literatura @todreaskazimi2 @Ishii, adaptadas específicamente para condiciones de estado estacionario:

//Las ecuaciones gobernantes resultantes son las encontradas en la literatura @todreaskazimi2 @Ishii para el modelo HEM adaptadas para el estado estacionario:

$
d/(d z) (rho v) = 0, $
$
v (d v)/(d z) = -1/rho (d p)/(d z) - f/(2D_h) v^2 - g,
$$
d/(d z) (rho h v) = v (d p)/(d z) + S_h, \
$
donde $z$ es la coordenada axial a lo largo del sistema, y $rho$, $v$, $p$ y $h$ representan la densidad, la velocidad, la presión y la entalpía de la mezcla agua-vapor, respectivamente, $D_h$ es el diámetro hidráulico y $g$ es la aceleración de la gravedad.
$S_h$ representa el término fuente debido a la entrada de calor al sistema. Es una función definida por tramos, tomando un valor positivo sólo en la región del calentador:
#set math.cases(gap: 2em)
$
S_h = cases(
  Q/(A L_h) "," #h(1em) & 0 <= z <= L_h,
  0 "," & L_h < z <= L,
)
$
donde $A$, $L_h$, $L$ y $Q$ representan el área de flujo anular, la longitud de la región calentada, la longitud total del dominio, y la entrada total de calor, respectivamente.

$f$ es el factor de fricción de Darcy, que se calcula utilizando el modelo propuesto por #cite(<churchill>, form: "prose"), según:

$ f = 8[(8/"Re" + (f_1 + f_2)^(-1.5))]^(1/12)#h(-0.3cm), $
$ f_1 = {-2.457 ln[(7/"Re")^0.9 #h(-0.3cm) + 0.27 epsilon/D_h]}^16 #h(-0.3cm), $ 
$ f_2 = (37530/"Re")^16#h(-0.3cm), $
donde $epsilon$ representa la rugosidad de las paredes del ánulo, y $"Re"$ es el número de Reynolds basado en el diámetro hidráulico $D_h$ y velocidad local $v$:

$
"Re" = (rho D_h v)/mu,
$

con la densidad de la mezcla $rho$ y viscosidad dinámica también de la mezcla $mu$.

Las propiedades termodinámicas de la mezcla se define como:
$
rho = alpha rho_g + (1 - alpha) rho_l,
$
donde $alpha$ es la fracción de vacío que se estima por medio de la siguiente expresión:
$
alpha = (x/ρ_g)/(x/ρ_g + (1 - x)/ρ_l),
$
donde $x$ es la calidad del vapor, y $rho_l$ y $rho_g$ son las densidades del líquido y vapor saturados. Estos valores termodinámicos de cada fase son calculados utilizando el paquete CoolProp @coolprop de Julia: 
$ 
x = "PropsSI"(p,h), $$
T = "PropsSI"(p,h), $$
rho_g = "PropsSI"(p,x=1), $$
rho_l = "PropsSI"(p,x=0),
$
y finalmente,
$
rho = "PropsSI"(p,h).
$
Esto es, la calidad $x$, la temperatura $T$ y la densidad de la mezcla $rho$ se obtienen a partir de la presión y entalpía, y las densidades de cada fase se obtienen considerando la calidad 0 o 1, dependiendo si es líquido saturado o vapor saturado, respectivamente.

//*Las propiedades de la mezcla es obtenida... Aquí hay que hablar de la fracción de vacío que aparece de la nada en los resultados..*

Las condiciones de frontera del sistema son definidas a la entrada del ánulo.

$
rho(0) = rho_0, #h(1em)
v(0)     = v_0, \
h(0)     = h_0, #h(1em)
p(0)     = p_0,
$
donde $v_0$ y $p_0$ corresponden a condiciones de entrada definidas por los casos experimentales simulados, mientras que $h_0$ y $rho_0$ se determinan a partir de dichas condiciones utilizando las propiedades termodinámicas del fluido.


== Método numérico
=== Adimensionalización
Para la resolución numérica, se adimensionalizaron las ecuaciones de modo a reducir el error relativo entre las variables. Las variables adimensionalizadas se definieron de la siguiente manera:

$
z^* = z/L, #h(1cm)
rho^* = rho/rho_0, \
v^* = v/v_0, #h(1cm)
h^* = (h - h_0)/(h_L_h - h_0), \ 
p^* = (p - p_0)/(rho_0 g L), \
$
donde $h_L_h$ es la entalpía de la mezcla a la salida del calentador.

$ h_L_h = h_0 + Q/(rho_0 v_0 A ) $

Las ecuaciones de conservación adimensionalizadas son las siguientes:

$
d/(d z^*)(ρ^* v^*) = 0,
$
$
v^* (d v^*)/(d z^*) = - 1/"Fr" 1/ρ^*  (d p^*)/(d z^*)  #h(3cm) \ #h(2cm) - (f("Re") L)/(2 D_h) (v^*)^2 - 1/"Fr",
$
$
d/(d z^*) (ρ^* h^* v^*) = "Ec"/"Fr"  v^* (d p^*)/(d z^*) + L/L_h,\
// ρ_0 ρ^* = hat(f)(h_0 + (h_L_h - h_0) h^*, p_0 + ρ_0 g L p^*)\
$
donde los números de Froude y de Eckert se definen según:

$
"Fr" &= v_0^2/(g L), $
$
"Ec" &= v_0^2/(h_L_h - h_0).
$

Para facilitar la lectura de las ecuaciones, se omite en adelante el superíndice $.^*$ que denota variables adimensionales.

=== Discretización
La discretización de las ecuaciones adimensionales se realizó empleando un esquema de diferencias finitas.

Se colocaron $N$ nodos $[z_1, ..., z_N]$ espaciados uniformemente con distancia $Delta z = 1/N$ entre sí a lo largo del dominio computacional, donde todas las variables son calculadas sobre los mismos. Esto es, $psi_i = psi(z_i)$ para $psi in {rho, v, h, p}$ e $i in {1, ..., N}$.

Para las derivadas de primer orden, se utilizó el esquema upwind, donde cada derivada se calcula tomando una diferencia finita en el sentido del flujo, esto es:

$ (d psi)/(d z) approx (psi_i - psi_(i-1))/(Delta z) #h(0.5cm) "si" v_i > 0. $

Las ecuaciones discretizadas resultan:

$
(rho_i v_i - rho_(i-1) v_(i-1) )/(Delta z) = 0, 
$
$
v_i (v_i - v_(i-1))/(Delta z) = - 1/"Fr" (p_i - p_(i-1))/(rho_i Delta z) #h(3.0cm) \ #h(3.0cm) - (f("Re")L)/(2 D_h) v_i^2 - 1/"Fr", 
$
$
(rho_i h_i v_i - rho_(i-1) h_(i-1) v_(i-1))/(Delta z)  #h(3.0cm) \ #h(2.0cm) = "Ec"/"Fr" v_i (p_i - p_(i-1))/(Delta z) + L/L_h, 
$
$
rho_i = "PropSI"(p_i, h_i),
$
donde $i in {2,...,N}$.

*hablar sobre las condiciones de frontera o de entrada y de la salida.*



=== Resolución

El sistema de ecuaciones no lineales obtenidos de la discretización del modelo se puede escribir como:

$ bold(F)(bold(Q)) = bold(0), $
donde $bold(F)$ es una función vectorial que retorna un vector de tamaño $4N$, y recibe como argumento de entrada el vector de incógnitas
// $bold(Q) = [rho_1, .., rho_N, v_1, ..., v_N, h_1, ..., h_N, p_1, ... p_N]^T$
$bold(Q) = [bold(rho) #h(0.4em) bold(v) #h(0.4em) bold(h) #h(0.4em) bold(p)]^T$
donde $bold(rho)$, $bold(v)$, $bold(h)$ y $bold(p)$ son los vectores de tamaño $N$ cada uno cuyos elementos son los valores de las variables en los nodos, esto es, por ejemplo $ bold(rho)= [rho_1, ..., rho_N]$.


Para su resolución se empleó el método de Newton-Rapshon, donde se resuelve de forma iterativa el sistema lineal:

// $ bold(Q)_(k+1) = bold(Q)_k - J^(-1)(bold(Q_k)) bold(F)(bold(Q_k)) $
$ J(bold(Q)_k)(bold(Q)_(k+1) - bold(Q)_k) = -bold(F)(bold(Q_k)), $

donde $J$ representa la matriz jacobiana de $bold(F)$, a la que le corresponden columnas dadas por $(partial bold(F))/(partial x_j)$, que son aproximadas numéricamente según el esquema:

$ (partial bold(F))/(partial x_j) (bold(Q)_k) approx (bold(F)(bold(Q) + delta bold(e)_j) - bold(F)(bold(Q)))/delta, $

donde $bold(e)_j$ es la $j$-ésima columna de la matriz identidad y $delta$ es un número real positivo pequeño.


*Mencionar la condición de entrada en el método de newton-raphson...*

== Experimentos numéricos
Se evaluó el desempeño del modelo HEM comparando sus resultados con las mediciones experimentales de #cite(<ozar>, form: "prose") y con los resultados de simulación de RELAP5/MOD3.3 producidos por #cite(<RELAP-2016>, form: "prose") en dos escenarios distintos.
En ambos escenarios se simuló la entrada de agua líquida subenfriada, con distintos valores de presión de entrada $P_"in"$, velocidad de entrada $v_"in"$, subenfriamiento $Delta T_"sub"$ en la entrada al ánulo, y con distintos valores de densidad de flujo de calor $q''_upright(w)$ provista por el calentador. Las condiciones experimentales que se simularon se resumen en la Tabla @conditions.

#show table: set text(font: "Libertinus Serif", size:12pt)
#set figure(gap: 1.5em)


#figure(
table(
  columns: 5,
  stroke: none,
  align: center+horizon,
  table.hline(),
  table.cell(rowspan: 2)[Caso],
  [$p_0$],       
  [$v_0$],       
  [$Delta T_"sub"$],
  [$q''_upright(w) ""$],       
  [[kPa]],
  [[m/s]],
  [[ºC]],
  [[kW/m#super[2]]],
  table.hline(),
  [1],
  [498], [0.24], [30], [156],
  [2],
  [181], [0.24], [19], [56],
  table.hline(),
),
  caption: [Condiciones experimentales simuladas],
) <conditions>

En cada caso, se realizaron la prueba de independencia de malla aumentando progresivamente la cantidad de nodos $N$ del dominio computacional. Así, se presentan resultados obtenidos con $N = 50$.


=  Resultados y Discusión

Los resultados del Caso 1 se muestra en la Figura @subcooled y del Caso 2 en la Figura @flashing. En ambos casos, se comparan los perfiles de fracción de vacío, temperatura y presión a lo largo del dominio seleccionado.

La Figura @subcooled(a) muestra que el modelo HEM captura la transición de la fase líquida a la fase vapor, pero la cantidad de vapor producido es mayor comparado a los datos experimentales y a las soluciones de RELAP5 presentados en la literatura.

Para estas condiciones experimentales, debería observarse una ebullición subenfriada _(subcooled boiling)_. El modelo HEM, en lugar de predecir un cambio de fase gradual con generación de vapor previa a la saturación, predice un salto brusco en la fracción de vacío cuando el líquido alcanza la temperatura de saturación.

Del mismo modo, la fracción de vapor máxima alcanzada es sobrestimada debido a que el modelo HEM no considera efectos de condensación. Como la fracción de vacío es calculada exclusivamente a partir de la presión y la temperatura de la mezcla, $alpha$ no posee una ecuación de transporte asociada a ella. Debido a esto, no puede capturar fenómenos de generación (ebullición subenfriada) y consumo (condensación) mediante modelos asociados al término fuente en su ecuación de transporte.

En la Figura @subcooled(b) se aprecia la fidelidad con la que el modelo HEM reproduce el perfil axial de temperaturas. // Por qué se logra esto?

#place(
  auto,
  scope: "parent",
  float: true,
  clearance: 1.5cm,
  [#figure(
    image("figs/fig_3.svg"),
    caption: [Comparación del modelo HEM (línea azul), RELAP5 (línea rojo) y datos experimentales (punto negro) para las condiciones experimentales del Caso 1.],

  ) <subcooled>]
)

En la Figura @subcooled(c) se observa que el modelo HEM reproduce adecuadamente el perfil axial de presión en la región líquida del flujo. Sin embargo, a partir del inicio de la ebullición saturada, identificado por un cambio en la pendiente del perfil, el modelo subestima la caída de presión en comparación con RELAP5/MOD3.3 y los datos experimentales, debido a la formación de la fase vapor.

Este error en la predicción puede analizarse teniendo en cuenta las fuerzas de fricción que la fase vapor trae consigo. Estas fuerzas no son contempladas por el modelo. Las burbujas, o los _slugs_ de vapor producen un impedimento al flujo debido a las fuerzas de rozamiento en la interfase líquido-vapor; lo cual trae a su vez una mayor caída de presión asociada. Esta falencia del modelo HEM podría corregirse seleccionando un modelo para el factor de fricción que refleje esta dinámica característica del flujo bifásico.

Para el Caso 2, en la Figura @flashing(a) se observa que el modelo evaluado es incapaz de reproducir el pequeño pico de fracción de vacío en la sección con calefacción que se produce nuevamente debido a los efectos de ebullición subenfriada.
Sin embargo, a diferencia de los resultados de RELAP5/MOD3.3, el modelo HEM sí captura la vaporización instantánea _(flash)_ que se produce debido a la caída de presión en la región adiabática.

Los resultados del perfil de temperatura nuevamente son satisfactorios para el Caso 2, como se observa en la Figura @flashing(b). Si bien, no reproduce los valores precisos de las temperaturas obtenidas experimentalmente, se obtiene resultados muy próximos a las soluciones realizadas por RELAP5/MOD3.3. 
#place(
  top,
  scope: "parent",
  float: true,
  clearance: 1.5cm,
  [#figure(
    image("figs/fig_8.svg"),
    caption: [Comparación del modelo HEM (línea azul), RELAP5 (línea rojo) y datos experimentales (punto negro) para las condiciones experimentales del Caso 2.],

  ) <flashing>]
)

Finalmente, en la Figura @flashing(c) se observa que la predicción del perfil de presión es incluso mejor en el Caso 2. Esto se debe a que el fluido permanece en estado líquido durante todo su trayecto hasta que se vaporiza instantáneamente justo antes de la salida del sistema.



= Conclusiones


La implementación y validación del modelo HEM desarrollada en este trabajo pone en evidencia tanto sus fortalezas como sus limitaciones para la simulación de flujos bifásicos en sistemas de circulación natural.

//En ambos casos, la predicción del perfil axial de fracción de vacío es muy limitada. Por más de que se refleje el fenómeno general del cambio de fase, el modelo no logra reproducir fenómenos clave en la hidráulica térmica del flujo bifásico, tales como la ebullición subenfriada y la condensación.

En los dos casos analizados, los resultados del perfil axial de fracción de vacío resultó limitada. Aunque el modelo reproduce el cambio de fase, no logra capturar adecuadamente procesos térmicos, como la ebullición subenfriada y la condensación.

//Sin embargo, las predicciones de los perfiles de temperatura y presión revelan que, incluso con un modelo simplificado, es posible capturar la evolución de estas dos variables a lo largo de un sistema de flujo estacionario con calefacción sin recurrir a modelos bifásicos complejos.

Por otro lado, los perfiles de temperatura y presión fueron reproducidos con notable fidelidad, lo que demuestra que, incluso mediante un modelo simplificado, es posible capturar la evolución de estas variables sin recurrir a formulaciones bifásicas más complejas.


//Este trabajo sienta bases para continuar explorando la viabilidad de modelos sencillos que aún así capturen los fenómenos más relevantes de los flujos bifásicos, proporcionando un punto de partida sólido para la implementación y validación de modelos más avanzados como el modelo _drift-flux_ o formulaciones transitorias.

Este trabajo establece una base sólida para continuar evaluando la viabilidad de modelos simples que permitan describir los aspectos más relevantes del flujo bifásico con menor costo computacional. Además, abre la posibilidad de avanzar hacia modelos más elaborados, como el _drift-flux_ o formulaciones transitorias, a partir de una implementación validada y comprensible.

//Como trabajo futuro, se podría revisitar este modelo incorporando tanto una ecuación de transporte para la fracción de vacío, como un modelo actualizado que capture la dinámica bifásica en la caída de presión.

Como línea futura de trabajo, se plantea extender el modelo mediante la incorporación de una ecuación de transporte para la fracción de vacío, así como el desarrollo de una formulación mejorada del término de fricción que permita representar con mayor precisión la dinámica bifásica durante la caída de presión.



#bibliography(
  "references.bib",
  title: "Referencias Bibliográficas",
  style: "apa-no-doi-no-issue.csl"
)