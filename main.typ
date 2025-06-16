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
Con el accidente nuclear de Fukushima en 2011, inició un proceso de redirección de los sistemas de seguridad activos a pasivos.
Con los sistemas de seguridad pasivos, se opta por depender de fenómenos físicos como la gravedad o las diferencias de presión, en lugar de sistemas que dependen de fuentes de energía externa como bombas, ventiladores, u otros elementos activos. // @IAEA-TECDOC-626

La ventaja de estos sistemas de seguridad pasivos yace en su robustez ante escenarios de accidentes, como los Aciddentes por Pérdida de Refrigerante (LOCAs). En el caso de que un evento como este sea acompañado por una ausencia de una fuente de energía eléctrica, tanto por parte de la red como por generadores independientes, un sistema de refrigeración activo no cumpliría su función de disipar el calor residual del núcleo. Este fue el caso del accidente de Fukushima. 

Dado esto, la implementación de sistemas de refrigeración pasivos en los reactores nucleares es crucial, de modo a lograr disipar el calor residual de la reacción nuclear por un lapso de tiempo suficiente para dar lugar a que puedan tomarse medidas correctivas.

Un diseño común utilizado para refrigerar el núcleo en caso de accidentes es el Ciclo de Circulación Natural (_Natural Circulation Loop_, NCL).
Los NCLs impulsan el flujo de agua refrigerante utilizando únicamente el calor del núcleo como fuente de energía.
El flujo ocurre debido a diferencias de densidad causadas tanto por cambios en la temperatura, como cambios de fase. 

En la Figura // @loop
puede observarse un diagrama de un NCL prototípico.
La energía ingresa en el sistema mediante un calentador---que en el caso de un reactor nuclear sería el núcleo. Esto produce un aumento de la temperatura en el fluido refrigerante, lo que a su vez produce una disminución de su densidad.
Por fuerzas de flotación, el agua se eleva a través del tramo vertical de la tubería, y continúa su camino hasta llegar al condensador.
En el condensador el agua vuelve a enfriarse, disminuyendo su temperatura y aumentando nuevamente su densidad. 
Por fuerzas de gravedad, el agua cae nuevamente por la tubería vertical y se encamina al calentador, completando el ciclo.

Los NCLs pueden ser diseñados para operar tanto en régimen monofásico como bifásico. En el régimen monofásico, el agua se mantiene en todo momento en forma líquida, y las fuerzas de flotación se manifiestan enteramente por la expansión térmica del líquido. En el régimen bifásico se permite que el agua experimente un cambio de fase, vaporizándose parcialmente. En este caso las fuerzas de flotación son producto también del cambio abrupto de densidad producido por la presencia de la fase vapor.

Los NCLs monofásicos se hallan restringidos por el criterio de la temperatura de saturación // @bhattacharya. 
De este modo existe un gran interés en modelar los fenómenos bifásicos emergentes que tienen lugar en los NCLs bifásicos.

El modelado de flujo bifásico presenta dificultades matemáticas, en tanto es necesario rastrear las múltiples interfaces deformables entre las fases y tomar en cuenta las discontinuidades en las propiedades del fluido que ocurren en ellas.

Debido a esto, la metología común en el modelado de flujos bifásicos en tuberías es el de promediar las cantidades en la sección transversal, obteniéndose un modelo unidimensional. Este es el caso del modelo _two-fluid_ y el modelo _drift-flux_.

Existen ya una diversidad de resolvedores complejos de uso comercial // @RELAP
que modelan el flujo bifásico 1D. En este trabajo, se presenta la implementación numérica de un modelo simplificado, el modelo HEM (_Homogeneous Equilibrium Model_) en el lenguaje de programación Julia // @julia .

El dominio computacional consiste de una subsección de un NCL, la tubería vertical a través de la cual el fluido recibe la energía del calentador y asciende.
La elección de este dominio restringido se justifica en la disponibilidad de mediciones experimentales para validar el modelo y su implementación.
Como trabajo futuro, se podrán utilizar los resultados de este modelo para realizar un análisis del sistema completo del NCL.



= Objetivos
*Objetivo general* \
Implementar y validar un resolvedor de flujo agua-vapor en una tubería vertical utilizando el modelo HEM 1D.

*Objetivos específicos* \
- Derivar las ecuaciones de conservación de masa, cantidad de movimiento y energía para un flujo bifásico agua-vapor en una tubería vertical.
- Elegir un esquema de discretización y un método numérico para la resolución de las ecuaciones.
- Implementar el método numérico en el lenguaje de programación Julia.
- Validar el modelo y la implementación empleando datos experimentales de la literatura.

= Materiales y Métodos


=  Resultados y Discusión

= Conclusiones

#bibliography(
  "references.bib",
  title: "Referencias Bibliográficas",
  style: "apa"
)