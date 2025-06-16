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
#counter(page).update(1)

= Introducción
Con el accidente nuclear de Fukushima en 2011, inició un proceso de redirección de los sistemas de seguridad activos a pasivos.
Con los sistemas de seguridad pasivos, se opta por depender de fenómenos físicos como la gravedad o las diferencias de presión, en lugar de sistemas que dependen de fuentes de energía externa como bombas, ventiladores, u otros elementos activos. // @IAEA-TECDOC-626

La ventaja de estos sistemas de seguridad pasivos yace en su robustez ante escenarios de accidentes, como los Aciddentes por Pérdida de Refrigerante (LOCAs). En el caso de que un evento como este sea acompañado por una ausencia de una fuente de energía eléctrica, tanto por parte de la red como por generadores independientes, un sistema de refrigeración activo no cumpliría su función de disipar el calor residual del núcleo. Este fue el caso del accidente de Fukushima. 

Dado esto, la implementación de sistemas de refrigeración pasivos en los reactores nucleares es crucial, de modo a lograr disipar el calor residual de la reacción nuclear por un lapso de tiempo suficiente para dar lugar a que puedan tomarse medidas correctivas.



= Objetivos
*Objetivo general*

*Objetivos específicos*


= Materiales y Métodos


=  Resultados y Discusión

= Conclusiones

#bibliography(
  "references.bib",
  title: "Referencias Bibliográficas",
  style: "apa"
)