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
#align(center)[*Abstract*]

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

#align(center)[*Resumen*]
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
