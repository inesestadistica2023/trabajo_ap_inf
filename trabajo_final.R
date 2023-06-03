---
  title: "IDB_trabajo_estadistica"
author: "Ines Dominguez"
output: html_document
---
  
  
  Primero debemos cargar la librería 'ggplot2' para poder trabajar con los datos.Posteriormente, cargaremos la base de datos descargada desde 'Comparative Archaeology Database'. La base de datos ha sido modificada anteriormente desde Excel, para que contuviera exclusivamente las variables que nos interesan. También se han eliminado datos que contenían el valor 'NA' (Not Available), para evitar posibles fallos a la hora de realizar nuestros análisis, y además, para poder trabajar mejor a la hora de realizar los códigos, hemos renombrado las columnasdesde Excel.

Para cargar la base de datos, lo haremos desde 'Environment', e importaremos la base de datos, ya modificada, desde Excel.

```{r}
library(ggplot2)
```

Además, vamos a recodificar la columna 'Tipo' para tener los datos en lenguaje adecuado para trabajar con una regresión logística, es decir, cambiaremos los términos 'blade' y 'flake' con 0 y 1. Para ello, accederemos a la columna 'Tipo' de nuestra base de datos con el símbolo '$'.

La función 'ifelse' es utilizada para evaluar una condición y retornar diferentes valores dependiendo de si la condición es verdadera o falsa. En este caso, la condición es 'base_datos_ines$Tipo=="Blade", que verifica si los valores en la columna "Tipo" son iguales a "Blade". Si la condición es verdadera, se asigna el valor 1, y si es falsa, se asigna el valor 0. Esto crea un nuevo vector con los valores 1 y 0 correspondientes a cada fila en la columna "Tipo".

La función as.factor() se utiliza para convertir el vector resultante en un factor, una estructura de datos que representa variables categóricas. Estamos creando una nueva columna llamada 'Tipo_f'.
```{r}
base_datos_ines$Tipo_f <- as.factor(ifelse(base_datos_ines$Tipo=="Blade",1,0))
```

A continuación, crearemos gráficos de distribución según las variables para examinar la forma en que los valores de una variable se distribuyen en función de otra variable o grupo. Así podremos identificar patrones o identificar valores atípicos. 

Para ello usaremos la función 'ggplot' ed la biblioteca 'ggplot2'. Indicamos 'base_datos_ines' como nuestra data frame y usamos la función 'aes'para definir cómo se asignarán las variables a los diferentes elementos estéticos del gráfico. En este caso, "Longitud" lo asignaremos al eje x, "Anchura" al eje y, y "Tipo" se asigna al color de los puntos.

La función 'geom_point'agrega puntos al gráfico para representar los valores de las variables. Así, podemos ver representadas los valores 0 (flake) en verde, y 1 (blade) en naranja.


```{r}
ggplot(base_datos_ines, aes(x=Longitud, y=Anchura, color = Tipo)) + geom_point()
```

Este tipo de gráficos nos ayuda a ver cómo se relacionan las variables Longitud y Anchura según los datos de nuestro data frame. Vemos que hay una tendencia de los puntos a agruparse en la esquina superior izquierda, lo que indica que todas las piezas de nuestra base de datos se mueven en un márgen típico de unos 30-40 cm de anchura y unos 40-45 cm de longitud aproximadamente. 

Además, vemos que hay una ligera diferencia, típica en la arqueología prehistórica, entre flake (lasca) y blade (lámina). Podemos observar, aunque ligeramente, que las láminas (naranja) tienen una tendencia a ser más largas, pues hay una tendencia en el gráfico hacia la derecha. En cambio las lascas (verde), suelen ser más cortas, puesto que ocupan sobre todo el lado izquierdo del gráfico. Cabe destacar 2 casos inusuales de láminas, mucho más largos que el resto, que se encuentran en el lateral derecho, y un caso que es mucho más pequeño que los demás, tanto en longitud como en anchura (esquina inferior izquierda).

Ahora, podemos realizar el mismo gráfico pero esta vez usando las variables Grosor y Peso.

```{r}
ggplot(base_datos_ines, aes(x=Grosor, y=Peso, color = Tipo)) + geom_point()
```

Gracias a este gráfico y su tendencia diagonal, podemos observar que, mientras más gruesa sea la pieza, más va a pesar, siendo el caso de la esquina inferior izquierda la pieza más pequeña y con menos peso (lámina), y la de la esquina superior derecha la más pesada (lámina). También podemos observar una ligera tendencia de las lascas a ser más gruesas que las láminas, pero realmente tenemos muy pocos datos para que los resultados sean algo significativo.

Cabe destacar que arriba del gráfico nos salta un aviso. Este aviso es debido a que en la variable Peso nos faltan 3 valores, los cuales no aparecían en la base de datos original.


Ahora realizaremos modelos de regresión logística con la función 'glm' y obtendremos un resumen de los resultados con la función 'summary'. El argumento 'Tipo_f ~ Anchura' especifica la fórmula del modelo, donde "Tipo_f" es la variable dependiente y "Anchura" es la variable independiente. El argumento 'base_datos_ines' especifica el conjunto de datos utilizado para el ajuste del modelo. El argumento family = "binomial" indica que se está ajustando un modelo de regresión logística con una distribución binomial.

Con estos modelos podremos ver en qué medida afectan las distintas variables a la hora de si un instrumento es una lasca o una lámina.


```{r}
summary(glm(Tipo_f ~ Anchura , base_datos_ines, family ="binomial"))

```
```{r}
summary(glm(Tipo_f ~ Grosor, base_datos_ines, family ="binomial"))
```

```{r}
summary(glm(Tipo_f ~ Longitud, base_datos_ines, family ="binomial"))
```
```{r}
summary(glm(Tipo_f ~ Peso, base_datos_ines, family ="binomial"))
```
Si nos fijamos en la columna Pr(>|z|), de los valores p, vemos que en ningún modelo nos dan resultados significativos. Un valor p bajo (generalmente inferior a 0.05) sugiere que  hay una relación estadísticamente significativa entre la variable predictora y la variable respuesta, lo cual no es nuestro caso.

Podríamos interpretar estos resultados como que no existe una relacion directa entre las variables y el tipo de instrumento, pero realmente es debido a la escasez de datos con la que contamos.


A continuación, realizaremos otra vez modelos de regresión logística, pero esta vez múltiples, es decir, con varias variables, con la misma intención que en el apartado anterior: ver si la combinación de varias variables es significativa a la hora de ser lámina o lasca.

Para ello volveremos a usar la función 'glm'. La fórmula 'Tipo_f ~ Anchura + Longitud especifica que "Tipo_f" es la variable dependiente y "Anchura" y "Longitud" son las variables independientes. Indicaremos el conjunto de datos que vamos a usar con 'base_datos_ines' y volveremos a indicar la distribución binomial con  family = "binomial". Con 'summary' generaremos un resumen de los resultados. 

