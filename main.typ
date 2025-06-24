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
*Título del trabajo* \
Autor: Acevedo, Mateo; mateo.acevedo.000\@gmail.com \
Co-autores: Lima, Leon; Mangiavacchi, Norberto \
Orientador: Shin, Hyun Ho \
Facultad de Ciencias Químicas 
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

Keywords:
//
1D Two-phase Flow,
Homogeneous Equilibirum Model (HEM),
Natural Circulation Loop
// Finite difference,
// Newton-Raphson method,
// Passive Cooling Systems,
// Nuclear Safety,
.
]

#pagebreak()

*Resumen*\
Debido a la amplia utilización de ciclos de circulación natural en sistemas de seguridad pasivos para reactores nucleares, existe un alto grado de interés en modelar los fenómenos que ocurren en la dinámica de su flujo cuando operan en régimen bifásico.
Este trabajo presenta la exploración de la validez del Modelo de Equilibrio Homogéneo unidimensional para modelar flujos de agua-vapor en estado estacionario en la sección ascendente de un ciclo de circulación natural.
La región modelada consiste de un ánulo con una región con calefacción seguida de una sección adiabática.
El modelo es conformado por tres ecuaciones de conservación formuladas en torno a la mezcla agua-vapor, y se corresponden con la masa, cantidad de movimiento y energía de la mezcla.
Las ecuaciones fueron discretizadas utilizando un esquema upwind de diferencias finitas, y resueltas mediante el método de Newton-Raphson, calculando el jacobiano numéricamente.
Se compararon los resultados obtenidos tanto con datos experimentales de la literatura como con resultados obtenidos por RELAP5/MOD3.3, un código de simulación para sistemas los térmico-hidráulicos de reactores nucleares.
Se encontró que el modelo estudiado reproduce con fidelidad los perfiles de temperatura, pero posee limitaciones en cuanto a la predicción de la caída de presión posterior al punto de ebullición saturada; y respecto a la predicción cuantitativa del perfil de fracción de vacío teniendo en cuenta los fenómenos de ebullición subenfriada y condensación.

Palabras clave:
//
Flujo bifásico 1D,
Modelo de Equilibrio Homogéneo (HEM),
Ciclo de circulación natural,
// Diferencias finitas,
// Método de Newton-Raphson,
// Sistemas de refrigeración pasivos,
// Seguridad nuclear,
.

#pagebreak()

// Main body

#set page(
  columns: 2,
  numbering: "1",
  number-align: right,
)

= Introducción

Con el accidente de Fukushima en 2011, inició un proceso de transición de los sistemas de seguridad activos hacia los sistemas de seguridad pasivos en el campo de la seguridad nuclear
// @moving-to-passive-designs
@IAEA-SSR21.
// @role-of-passive-severe-accident
Con los sistemas de seguridad pasivos, se opta por depender de fenómenos físicos naturales como la gravedad o las diferencias de presión, en lugar de sistemas que dependen de fuentes de energía externa como bombas, ventiladores, u otros elementos activos
@IAEA-TECDOC-626.

La ventaja de estos sistemas de seguridad pasivos yace en su robustez ante escenarios de accidentes, como los Aciddentes por Pérdida de Refrigerante (LOCAs)
@ESBWR-LOCA.
En el caso de que un evento como este sea acompañado por la ausencia de una fuente de energía eléctrica, sea por parte de la red o por generadores independientes, un sistema de refrigeración activo no cumpliría su función de disipar el calor residual del núcleo. Este fue el caso del accidente de Fukushima
@Fukushima-book.

Dado esto, la implementación de sistemas de refrigeración pasivos en los reactores nucleares es crucial, de modo a lograr disipar el calor residual de la reacción nuclear por un lapso de tiempo suficiente para dar lugar a que puedan tomarse medidas correctivas necesarias para evitar una catástrofe nuclear.
// @cite here

Un diseño común utilizado para refrigerar el núcleo en caso de accidentes es el Ciclo de Circulación Natural (_Natural Circulation Loop_, NCL).
Los NCLs impulsan el flujo de agua refrigerante utilizando únicamente el calor del núcleo como fuente de energía.
El flujo ocurre debido a diferencias de densidad causadas tanto por cambios en la temperatura, como cambios de fase. 

En la Figura
// @loop
puede observarse un diagrama de un NCL prototípico.
La energía ingresa en el sistema mediante un calentador, que representa el sistema cuyo calor desea disiparse. Esto produce un aumento de la temperatura en el fluido refrigerante, lo que a su vez produce una disminución de su densidad.
Por fuerzas de flotación, el agua se eleva a través del tramo vertical de la tubería, y continúa su camino hasta llegar al condensador.
En el condensador el agua vuelve a enfriarse, disminuyendo su temperatura y aumentando nuevamente su densidad. 
Por fuerzas de gravedad, el agua cae por la tubería vertical y se encamina al calentador, completando el ciclo.

Los NCLs pueden ser diseñados para operar tanto en régimen monofásico como bifásico.
En el primer caso, el agua se mantiene en todo momento en forma líquida, y las fuerzas de flotación se manifiestan enteramente por la expansión térmica del líquido.
En el régimen bifásico se permite que el agua experimente un cambio de fase, vaporizándose parcialmente.
En este caso las fuerzas de flotación son mayores, dado que son producto también del cambio abrupto de densidad producido por la aparición de la fase vapor.

Los NCLs monofásicos se hallan restringidos por el criterio de la temperatura de saturación
@bhattacharyya.
De este modo existe un gran interés en modelar los fenómenos bifásicos emergentes que tienen lugar en este tipo de NCLs.

El modelado de los flujos bifásicos presenta dificultades matemáticas, en tanto es necesario rastrear las múltiples interfaces deformables entre las fases y tomar en cuenta las discontinuidades en las propiedades del fluido que ocurren en ellas
@Ishii.

Debido a esto, la metología comúnmente utilizada en el modelado de flujos bifásicos en tuberías es el de promediar las cantidades en la sección transversal, obteniéndose un modelo unidimensional.
Este es el caso del modelo _two-fluid_ y el modelo _drift-flux_ @Ishii.

Existen ya una diversidad de resolvedores complejos de uso comercial como
RELAP5 y TRACE, que modelan el flujo bifásico 1D en los sistemas térmico-hidráulicos de un reactor nuclear @RELAP @TRACE.

En este trabajo, se presenta la implementación numérica de un modelo simplificado, el modelo HEM _(Homogeneous Equilibrium Model)_ en el lenguaje de programación Julia para la simulación del estado estacionario del sistema.

// El trabajo presenta un modelo de flujo en estado estacionario.
// Esta decisión se fundamenta tanto en que las mediciones disponibles en la literatura analizan al sistema cuando ya alcanzó el estado estacionario, como en el hecho de que las condiciones de frontera elegidas producen un estado estacionario natural.
// Las inestabilidades transitorias emergen de analizar el sistema completo.

// El dominio computacional consiste de una subsección de un NCL, la tubería vertical a través de la cual el fluido recibe la energía del calentador y asciende.
// La elección de este dominio restringido se justifica en la disponibilidad de mediciones experimentales para esta subsección del NCL que se utilizaron para validar el modelo y su implementación.

= Objetivos
*Objetivo general* \
// Implementar y validar un resolvedor de flujo agua-vapor en estado estacionario en una tubería vertical utilizando el modelo HEM 1D.
Explorar la validez del modelo HEM para modelar flujos de agua-vapor en estado estacionario en un ánulo vertical con calefacción.

*Objetivos específicos* \
- Derivar las ecuaciones 1D de conservación de masa, cantidad de movimiento y energía para un flujo bifásico agua-vapor en un ánulo vertical.
- Elegir un esquema de discretización y un método numérico para la resolución de las ecuaciones.
- Implementar el método numérico en el lenguaje de programación Julia.
// - Validar el modelo y la implementación empleando datos experimentales de la literatura.
- Comparar los resultados del modelo con resultados de otros códigos de simulación y datos experimentales de la literatura.

= Materiales y Métodos
== Modelado matemático
Se estudió el flujo bifásico agua-vapor en estado estacionario en un ánulo vertical con un tramo inicial a través de la cual ingresa calor uniformemente, considerando al resto del ánulo como adiabático.

Considerando a la mezcla agua-vapor como un único pseudo-fluido, se obtuvieron las ecuaciones de conservación de masa, cantidad de movimiento, y energía de la mezcla.
Esta consideración de que ambas fases poseen una única presión, temperatura y velocidad requiere un alto grado de acoplamiento térmico y mecánico para su validez @Ishii.
Las ecuaciones unidimensionalizadas se obtienen realizando un promediado en la sección transversal.

Las ecuaciones gobernantes resultantes son las encontradas en la literatura @todreaskazimi2 @Ishii para el modelo HEM adaptadas para el estado estacionario:

$
d/(d z) (rho v) = 0 \
v (d v)/(d z) = -1/rho (d p)/(d z) - f/(2D_h) v^2 - g \
d/(d z) (rho h v) = v (d p)/(d z) + S_h \
$

Donde $z$ es la posición axial a lo largo del sistema, y $rho$, $v$, $p$ y $h$ representan la densidad, la velocidad, la presión y la entalpía de la mezcla agua-vapor, respectivamente.

$S_h$ representa el término fuente debido a la entrada de calor al sistema. Es una función definida por tramos, tomando un valor positivo sólo en la región del calentador.

#set math.cases(gap: 2em)
$
S_h = cases(
  Q/(A L_h) "," #h(1em) & 0 <= z <= L_h,
  0 "," & L_h < z <= L,
)
$

Donde $A$, $L_h$ y $Q$ representan el área de flujo anular, la longitud de la región calentada, y la entrada total de calor, respectivamente.

$f$ es el factor de fricción de Darcy, que se calcula utilizando el modelo propuesto por #cite(<churchill>, form: "prose"), según:

$ f = 8[(8/"Re" + (f_1 + f_2)^(-1.5))]^(1/12) $
$ f_1 = {-2.457 ln[(7/"Re")^0.9 + 0.27 epsilon/D_h]}^16 $ 
$ f_2 = (37530/"Re")^16 $

Donde $epsilon$ representa la rugosidad de las paredes del ánulo.

Las propiedades termodinámicas fueron calculadas utilizando el paquete CoolProp de Julia.

$ rho = hat(f)(p,h) $

Las condiciones de frontera del sistema son definidas a la entrada del ánulo.

$
rho(0) = rho_"in", #h(1em)
v(0)     = v_"in" \
h(0)     = h_"in", #h(1em)
p(0)     = P_"in"
$

  Donde $v_"in"$ y $P_"in"$ son datos dados por las condiciones experimentales simuladas, y $h_"in"$ y $rho_"in"$ son calculadas a partir de las condiciones mediante las propiedades termodinámicas.


== Método numérico
=== Adimensionalización
Para la resolución numérica, se adimensionalizaron las ecuaciones de modo a reducir el error relativo entre las variables. Las variables adimensionalizadas se definieron de la siguiente manera:

$
z^* = z/L #h(1cm)
rho^* = rho/rho_0 \
v^* = v/v_0 #h(1cm)
h^* = (h - h_0)/(h_L_h - h_0) \ 
p^* = (p - p_0)/(rho_0 g L) \
$

Las ecuaciones de conservación adimensionalizadas son las siguientes.

$
d/(d z^*)(ρ^* v^*) = 0\
v^* (d v^*)/(d z^*) = - 1/"Fr" 1/ρ^*  (d p^*)/(d z^*) - (f L)/(2 D_h) (v^*)^2 - 1/"Fr"\
d/(d z^*) (ρ^* h^* v^*) = "Ec"/"Fr"  v^* (d p^*)/(d z^*) + L/L_h\
// ρ_0 ρ^* = hat(f)(h_0 + (h_L_h - h_0) h^*, p_0 + ρ_0 g L p^*)\
$

Donde los números de Froude y de Eckert se definen según:

$
"Fr" &= v_0^2/(g L) \
"Ec" &= v_0^2/(h_L_h - h_0)
$

=== Discretización
La discretización de las ecuaciones adimensionalizadas se realizó empleando un esquema de diferencias finitas.

Se colocaron $N$ nodos $[z_1^*, ..., z_N^*]$ espaciados uniformemente a una distancia #colbreak() $Delta z^* = 1/N$ entre sí a lo largo del dominio computacional, donde todas las variables son caluladas de manera sencilla sobre los mismos. Esto es, $psi_i^* = psi^*(z_i^*)$ para $psi in {rho, v, h, p}$.

Para las derivadas espaciales, se utilizó el esquema upwind, donde cada derivada se calcula en tomando una diferencia finita teniendo en cuenta el sentido del flujo.

$ (d psi^*)/(d z^*) approx (psi_i^* - psi_(i-1)^*)/(Delta z^*) #h(0.5cm) (v_i^* > 0) $

Las ecuaciones discretizadas resultan:

$
(rho_i v_i - rho_(i-1) v_(i-1) )/(Delta z) = 0 \
v_i (v_i - v_(i-1))/(Delta z) = -1/rho_i (p_i - p_(i-1))/(Delta z) - f/(2 D_h) v_i^2 - g \
(rho_i h_i v_i - rho_(i-1) h_(i-1) v_(i-1))/(Delta z) = v_i (p_i - p_(i-1))/(Delta z) + Q_i/(A L_h) \ 
rho_i = hat(f)(p_i, h_i) \
$

Donde se suprimió la notación de modo a que $rho_i$ represente a $rho_i^*$.

=== Resolución

El sistema no lineal de $4N$ ecuaciones se puede escribir como:

$ bold(F)(bold(Q)) = bold(0) $

Donde 
// $bold(Q) = [rho_1, .., rho_N, v_1, ..., v_N, h_1, ..., h_N, p_1, ... p_N]^T$
$bold(Q) = [bold(rho) #h(0.4em) bold(v) #h(0.4em) bold(h) #h(0.4em) bold(p)]^T$
es el vector de incógnitas con $bold(rho) = [rho_1, ..., rho_N]$ y $bold(v)$, $bold(h)$ y $bold(p)$ definidos análogamente.


Para su resolución se empleó el método de Newton-Rapshon, donde se resulve el sistema lineal:

// $ bold(Q)_(k+1) = bold(Q)_k - J^(-1)(bold(Q_k)) bold(F)(bold(Q_k)) $
$ J(bold(Q)_k)(bold(Q)_(k+1) - bold(Q)_k) = -bold(F)(bold(Q_k)) $

Donde $J$ representa la matriz jacobiana de $bold(F)$, a la que le corresponden columnas dadas por $(partial bold(F))/(partial x_j)$, que son aproximadas numéricamente según el esquema:

$ (partial bold(F))/(partial x_j) approx (bold(F)(bold(Q) + delta bold(e)_j) - bold(F)(bold(Q)))/delta $

Donde $bold(e)_j$ es la $j$-ésima columna de la matriz identidad.

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
  [$P_"in"$],       
  [$v_"in"$],       
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
  caption: [Condiciones experimentales \ simuladas]
) <conditions>

=  Resultados y Discusión

En la Figura @subcooled (a) se observa que el modelo HEM captura el fenómeno general de transición a fase vapor, pero no reproduce cuantitativamente el perfil axial de fracción de vacío.

Para estas condiciones experimentales, debería observarse una ebullición subenfriada _(subcooled boiling)_. El modelo HEM, en lugar de predecir un cambio de fase gradual con generación de vapor previa a la saturación, predice un salto brusco en la fracción de vacío cuando el líquido alcanza la temperatura de saturación.

Del mismo modo, la fracción de vapor máxima alcanzada es sobrestimada debido a que el modelo HEM no considera efectos de condensación. Como la fracción de vacío es calculada exclusivamente a partir de la presión y la temperatura de la mezcla, $alpha$ no posee una ecuación de transporte asociada a ella. Debido a esto, no puede capturar fenómenos de generación (ebullición subenfriada) y consumo (condensación) mediante modelos asociados al término fuente en su ecuación de transporte.

En la Figura @subcooled (b) se aprecia la fidelidad con la que el modelo HEM reproduce el perfil axial de temperaturas. // Por qué se logra esto?

#place(
  auto,
  scope: "parent",
  float: true,
  clearance: 1.5cm,
  [#figure(
    image("figs/fig_3.svg"),
    caption: [Comparación del modelo HEM (azul), RELAP5 (rojo) y datos experimentales (negro) para las condiciones experimentales del caso 1.],

  ) <subcooled>]
)

En la Figura @subcooled (c) se visualiza que el modelo HEM predice satisfactoriamente el perfil axial de presión en un primer tramo; pero a partir del punto de cambio de pendiente, predice una caída de presión menor a la predicha por RELAP5/MOD3.3, que se condice con las mediciones experimentales. Este cambio de pendiente ocurre en el punto donde empieza la ebullición saturada. De este modo, el modelo HEM predice correctamente la presión del sistema mientras el fluido se mantenga en estado líquido, y subestima la caída de presión en cuanto empieza la ebullición y se genera la fase vapor.

Este error en la predicción puede analizarse teniendo en cuenta las nuevas fuerzas de fricción que la fase vapor trae consigo. Estas fuerzas no son contempladas por el modelo. Las burbujas, o los _slugs_ de vapor producen un impedimento al flujo debido a las fuerzas de rozamiento en la interfase líquido-vapor; lo cual trae a su vez una mayor caída de presión asociada. Esta falencia del modelo HEM podría corregirse selecccionando un modelo para el factor de fricción que refleje esta dinámica característica del flujo bifásico.

En la Figura @flashing (a) se observa que el modelo evaluado es incapaz de reproducir el pequeño pico de fracción de vacío en la sección con calefacción que se produce nuevamente debido a los efectos de ebullición subenfriada.

Sin embargo, a diferencia de los resultados de RELAP5/MOD3.3, el modelo HEM sí captura cualitativamente la vaporización instantánea _(flash)_ que se produce debido a la caída de presión en la región adiabática.

Los resultados de predicción del perfil de temperatura nuevamente son satisfactorios para el caso 2, como se observa en la Figura @flashing (b). Si bien no reproduce cuantitativamente las temperaturas experimentales, reproduce de manera muy próxima los resultados predichos por RELAP5/MOD3.3. 
#place(
  top,
  scope: "parent",
  float: true,
  clearance: 1.5cm,
  [#figure(
    image("figs/fig_8.svg"),
    caption: [Comparación del modelo HEM (azul), RELAP5 (rojo) y datos experimentales (negro) para las condiciones experimentales del caso 2.],

  ) <flashing>]
)

Finalmente, en la Figura @flashing (c) se observa que la predicción del perfil de presión es incluso mejor en el caso 2. Esto se debe a que el fluido permanece en estado líquido durante todo su trayecto hasta que se vaporiza instantáneamente justo antes de la salida del sistema.



= Conclusiones

La exploración de la aplicabilidad del modelo HEM realizada en este trabajo revela tanto limitaciones como fortalezas del modelo HEM para la simulación de flujos bifásicos. 

En ambos casos, la predicción del perfil axial de fracción de vacío es muy limitada. Por más de que se refleje el fenómeno general del cambio de fase, el modelo no logra reproducir fenómenos clave en la hidráulica térmica del flujo bifásico, tales como la ebullición subenfriada y la condensación.

Sin embargo, las predicciones de los perfiles de temperatura y presión revelan que, incluso con un modelo simplificado, es posible capturar la evolución de estas dos variables a lo largo de un sistema de flujo estacionario con calefacción sin recurrir a modelos bifásicos complejos.

Este trabajo sienta bases para continuar explorando la viabilidad de modelos sencillos que aún así capturen los fenómenos más relevantes de los flujos bifásicos, proporcionando un punto de partida sólido para la implementación y validación de de modelos más avanzados como el modelo _drift-flux_ o formulaciones transitorias.

Como trabajo futuro, se podría revisitar este modelo incorporando tanto una ecuación de transporte para la fracción de vacío, como un modelo actualizado que capture la dinámica bifásica en la caída de presión.

#bibliography(
  "references.bib",
  title: "Referencias Bibliográficas",
  style: "apa-no-doi-no-issue.csl"
)