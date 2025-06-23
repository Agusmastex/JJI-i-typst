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

Keywords: Word 1, Word 2, Word 3, Word 4, Word 5, 
]

#pagebreak()

*Resumen*\

Palabras clave: Palabra 1, Palabra 2, Palabra 3, Palabra 4, Palabra 5.

#pagebreak()

// Main body

#set page(
  columns: 2,
  numbering: "1",
  number-align: right,
)
// #counter(page).update(1)

= Introducción

// Colocar antecedentes previos a Fukushima

Con el accidente de Fukushima en 2011, inició un proceso de transición de los sistemas de seguridad activos hacia los sistemas de seguridad pasivos en el campo de la seguridad nuclear.
// @moving-to-passive-designs
@IAEA-SSR21
// @role-of-passive-severe-accident
Con los sistemas de seguridad pasivos, se opta por depender de fenómenos físicos naturales como la gravedad o las diferencias de presión, en lugar de sistemas que dependen de fuentes de energía externa como bombas, ventiladores, u otros elementos activos. 
@IAEA-TECDOC-626

La ventaja de estos sistemas de seguridad pasivos yace en su robustez ante escenarios de accidentes, como los Aciddentes por Pérdida de Refrigerante (LOCAs).
@ESBWR-LOCA
En el caso de que un evento como este sea acompañado por la ausencia de una fuente de energía eléctrica, sea por parte de la red o por generadores independientes, un sistema de refrigeración activo no cumpliría su función de disipar el calor residual del núcleo. Este fue el caso del accidente de Fukushima. 
@Fukushima-book

Dado esto, la implementación de sistemas de refrigeración pasivos en los reactores nucleares es crucial, de modo a lograr disipar el calor residual de la reacción nuclear por un lapso de tiempo suficiente para dar lugar a que puedan tomarse medidas correctivas necesarias para evitar una catástrofe nuclear.

Un diseño común utilizado para refrigerar el núcleo en caso de accidentes es el Ciclo de Circulación Natural (_Natural Circulation Loop_, NCL).
Los NCLs impulsan el flujo de agua refrigerante utilizando únicamente el calor del núcleo como fuente de energía.
El flujo ocurre debido a diferencias de densidad causadas tanto por cambios en la temperatura, como cambios de fase. 

En la
// @loop
puede observarse un diagrama de un NCL prototípico.
La energía ingresa en el sistema mediante un calentador, que representa el sistema cuyo calor desea disiparse. Esto produce un aumento de la temperatura en el fluido refrigerante, lo que a su vez produce una disminución de su densidad.
Por fuerzas de flotación, el agua se eleva a través del tramo vertical de la tubería, y continúa su camino hasta llegar al condensador.
En el condensador el agua vuelve a enfriarse, disminuyendo su temperatura y aumentando nuevamente su densidad. 
Por fuerzas de gravedad, el agua cae por la tubería vertical y se encamina al calentador, completando el ciclo.

Los NCLs pueden ser diseñados para operar tanto en régimen monofásico como bifásico.
En el régimen monofásico, el agua se mantiene en todo momento en forma líquida, y las fuerzas de flotación se manifiestan enteramente por la expansión térmica del líquido.
En el régimen bifásico se permite que el agua experimente un cambio de fase, vaporizándose parcialmente.
En este caso las fuerzas de flotación son producto también del cambio abrupto de densidad producido por la aparición de la fase vapor.

Los NCLs monofásicos se hallan restringidos por el criterio de la temperatura de saturación
@bhattacharyya.
De este modo existe un gran interés en modelar los fenómenos bifásicos emergentes que tienen lugar en los NCLs bifásicos.

El modelado de flujo bifásico presenta dificultades matemáticas, en tanto es necesario rastrear las múltiples interfaces deformables entre las fases y tomar en cuenta las discontinuidades en las propiedades del fluido que ocurren en ellas.
@Ishii

Debido a esto, la metología comúnmente utilizada en el modelado de flujos bifásicos en tuberías es el de promediar las cantidades en la sección transversal, obteniéndose un modelo unidimensional.
Este es el caso del modelo _two-fluid_ y el modelo _drift-flux_.

Existen ya una diversidad de resolvedores complejos de uso comercial como
RELAP5
@RELAP
y 
TRACE 
@TRACE
,
que modelan el flujo bifásico 1D en los sistemas térmico-hidráulicos de un reactor nuclear.

En este trabajo, se presenta la implementación numérica de un modelo simplificado, el modelo HEM _(Homogeneous Equilibrium Model)_ en el lenguaje de programación Julia.

// El trabajo presenta un modelo de flujo en estado estacionario.
// Esta decisión se fundamenta tanto en que las mediciones disponibles en la literatura analizan al sistema cuando ya alcanzó el estado estacionario, como en el hecho de que las condiciones de frontera elegidas producen un estado estacionario natural.
// Las inestabilidades transitorias emergen de analizar el sistema completo.

// El dominio computacional consiste de una subsección de un NCL, la tubería vertical a través de la cual el fluido recibe la energía del calentador y asciende.
// La elección de este dominio restringido se justifica en la disponibilidad de mediciones experimentales para esta subsección del NCL que se utilizaron para validar el modelo y su implementación.

// Como trabajo futuro, se podrán utilizar los resultados de este modelo para realizar un análisis del sistema completo y transitorio del NCL.

= Objetivos
*Objetivo general* \
// Implementar y validar un resolvedor de flujo agua-vapor en estado estacionario en una tubería vertical utilizando el modelo HEM 1D.
Explorar la validez del modelo HEM para modelar flujos de agua-vapor en estado estacionario en un ánulo vertical.

*Objetivos específicos* \
- Derivar las ecuaciones 1D de conservación de masa, cantidad de movimiento y energía para un flujo bifásico agua-vapor en un ánulo vertical.
- Elegir un esquema de discretización y un método numérico para la resolución de las ecuaciones.
- Implementar el método numérico en el lenguaje de programación Julia.
// - Validar el modelo y la implementación empleando datos experimentales de la literatura.
- Comparar los resultados del modelo con resultados de otros códigos de simulación y datos experimentales de la literatura.

= Materiales y Métodos

// Modelado matemático
// Método numérico
// Experimentos numéricos
//   - Experimentos presentados en la literatura/Literatura comparada
//   - Experimento numérico (propiamente dicho)
//         Convergencia de malla


== Modelado matemático
Se estudió el flujo bifásico agua-vapor en estado estacionario en un ánulo vertical con un tramo inicial a través de la cual ingresa calor uniformemente, considerando al resto del ánulo como adiabático.

=== _Homogeneous Equilibrium Model_ 

Partiendo de las ecuaciones de conservación de masa, cantidad de movimiento y energía de la mezcla agua-vapor, mediante un promediado en la sección transversal se obtuvieron las ecuaciones de conservación 1D.

Se impuso equilibrio termodinámico instantáneo entre las dos fases, así como el no-deslizamiento entre fases, de modo a que ambas la fase líquida y la fase vapor circulen con la misma velocidad.

Las ecuaciones gobernantes resultantes son las encontradas en la literatura para el modelo HEM en estado estacionario:

$
d/(d z) (rho v) = 0 \
v (d v)/(d z) = -1/rho (d p)/(d z) - f/(2D_h) v^2 - g \
d/(d z) (rho h v) = v (d p)/(d z) + Q/(A L_h) \
// rho = hat(f)(p,h)  
$

Donde $z$ es la posición axial a lo largo del sistema, y $rho$, $v$, $p$ y $h$ representan la densidad, la velocidad, la presión y la entalpía de la mezcla agua-vapor, respectivamente.

Del mismo modo, $D_h$ y $A$ representan el diámetro hidráulico y el área de flujo del ánulo.
$L_h$ es la longitud de la región calentada; y $f$ es el factor de fricción bifásico, que se calcula utilizando el modelo propuesto por #cite(<churchill>, form: "prose"), según:

$ f = 8[(8/"Re" + (f_1 + f_2)^(-1.5))]^(1/12) $
$ f_1 = {-2.457 ln[(7/"Re")^0.9 + 0.27 epsilon/D_h]}^16 $ 
$ f_2 = (37530/"Re")^16 $

Donde $epsilon$ representa la rugosidad de las paredes del ánulo.


=== Propiedades termodinámicas

Se calcularon las propiedades termodinámicas utilizando el paquete _Coolprop_ de Julia.

$ rho = hat(f)(p,h) $

== Método numérico
=== Adimensionalización
Para la resolución numérica, se adimensionalizaron las ecuaciones de modo a reducir el error relativo entre las variables, que se adimensionalizaron de la siguiente manera:

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
La discretización de las ecuaciones se realizó empleando un esquema upwind de diferencias finitas.

$
(rho_i v_i - rho_(i-1) v_(i-1) )/(Delta z) = 0 \
v_i (v_i - v_(i-1))/(Delta z) = -1/rho_i (p_i - p_(i-1))/(Delta z) - f/(2 D_h) v_i^2 - g \
(rho_i h_i v_i - rho_(i-1) h_(i-1) v_(i-1))/(Delta z) = v_i (p_i - p_(i-1))/(Delta z) + Q_i/(A L_h) \ 
rho_i = hat(f)(p_i, h_i) \
$

=== Resolución

El sistema no lineal de $4N$ ecuaciones se puede representar como:

$ bold(F)(bold(Q)) = bold(0) $

Para su resolución, se empleó el método de Newton-Rapshon, donde se resulve el sistema lineal:

// $ bold(Q)_(k+1) = bold(Q)_k - J^(-1)(bold(Q_k)) bold(F)(bold(Q_k)) $
$ J(bold(Q)_k)(bold(Q)_(k+1) - bold(Q)_k) = -bold(F)(bold(Q_k)) $

Donde $J$ representa la matriz jacobiana de $bold(F)$, a la que le corresponden columnas dadas por $(partial bold(F))/(partial x_j)$, que son aproximadas numéricamente según el esquema:

$ (partial bold(F))/(partial x_j) approx (bold(F)(bold(Q) + delta bold(e)_j) - bold(F)(bold(Q)))/delta $

Donde $bold(e)_j$ es la $j$-ésima columna de la matriz identidad.

=== Experimentos numéricos
Se evaluó el desempeño del modelo HEM comparándolo con las mediciones experimentales de #cite(<ozar>, form: "prose") y con los resultados de simulación de RELAP5/MOD3.3 producidos por #cite(<RELAP-2016>, form: "prose") en dos escenarios distintos.
En ambos escenarios se simuló la entrada de agua líquida subenfriada, con distintos valores de presión $P_"in"$, velocidad $v_"in"$, subenfriamiento $Delta T_"sub"$ en la entrada al ánulo, y con distintos valores de densidad de flujo de calor $q''$ provista por el calentador.

// #table(
//   columns: 4,
//   stroke: none,
//   align: center,
//   [$P_"in"$],         [[kPa]],           [498],  [181],
//   [$v_"in"$],         [[m/s]],           [0.24], [0.24],
//   [$Delta T_"sub"$],  [[ºC]],            [30],   [19],
//   [$q'' ""$],         [[kW/m#super[2]]], [156],  [56],
// )

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
  [$q'' ""$],       
  [[kPa]],
  [[m/s]],
  [[ºC]],
  [[kW/m2]],
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
En las Figuras 1 y 2 se observan los resultados de los dos casos analizados.

Puede verse que el modelo HEM reproduce con alta fidelidad la temperatura alcanzada por la mezcla agua-vapor.

Del mismo modo, la predicción del perfil de presión es satisfactoria en un primer tramo, pero en el punto de cambio de pendiente sobrepredice la presión de la mezcla agua-vapor.
Este cambio de pendiente ocurre en el punto donde empieza el cambio de fase. De este modo, el modelo HEM predice correctamente la presión del sistema mientras el sistema se mantenga en estado líquido, y subestima la caída de presión en cuanto aparece la fase vapor.

Esto tiene su explicación en que la introducción de la fase vapor trae consigo nuevas fuerzas de fricción.
Las burbujas o los _slugs_ de vapor producen un impedimento al flujo, lo cual trae consigo una caída de presión mayor asociada.
Esto podría corregirse seleccionando un modelo para el factor de fricción que refleje esta dinámica característica del flujo bifásico.

Las limitaciones del modelo HEM quedan evidenciadas en los resultados de la predicción del perfil de la fracción de vacío.

En la @subcooled pueden observarse las falencias del modelo HEM en capturar fenómenos de ebullición subenfriada y condensación.

Mientras que se sigue capturando el fenómeno general, el modelo HEM no toma en cuenta los efectos de la ebullición subenfriada _(subcooled boiling)_.
El cambio de fase, en lugar de producirse gradualmente debido a la generación de vapor previa a la saturación, ocurre bruscamente cuando la temperatura de saturación es alcanzada.
Asimismo, la fracción de vapor máxima alcanzada es sobrepredicha debido a que el modelo HEM no toma en cuenta efectos de condensación.

Esto es, como la fracción de vacío es calculada exclusivamente a partir de la presión y temperatura de la mezcla, no posee una ecuación de transporte asociada a ella, y no es posible capturar fenómenos de generación (ebullición subenfriada) y consumo (condensación) mediante modelos asociados al término de fuente en su ecuación de transporte.

En la @flashing del mismo modo se observa que el modelo HEM es incapaz de reproducir el pequeño aumento en la fracción de vacío en la sección calentada debido a la ebullición subenfriada.
Sin embargo, a diferencia de los resultados de RELAP5/MOD3.3, sí captura la vaporización instantánea _(flash)_ que se produce por el descenso de la presión.

#place(
  auto,
  scope: "parent",
  float: true,
  [#figure(
    image("figs/fig_3.svg"),
    caption: [Comparación del modelo HEM (azul), RELAP5 (rojo) y datos experimentales (negro) para el caso 1.],

  ) <subcooled>]
)

#place(
  auto,
  scope: "parent",
  float: true,
  [#figure(
    image("figs/fig_8.svg"),
    caption: [Comparación del modelo HEM (azul), RELAP5 (rojo) y datos experimentales (negro) para el caso 2.],

  ) <flashing>]
)


= Conclusiones

#bibliography(
  "references.bib",
  title: "Referencias Bibliográficas",
  style: "apa"
)