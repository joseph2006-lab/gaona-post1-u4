# gaona-post1-u4

## Descripción
Laboratorio de la Unidad 4 de Arquitectura de Computadores: programa NASM con segmentos y salida DOS (Parte 1) y macros con control de flujo (Parte 2).

La Parte 1 consiste en un programa de 16 bits (`programa.asm`) que utiliza las secciones `.data`, `.bss` y `.text`, define constantes con `EQU`, inicializa el registro de segmento de datos e imprime cadenas y caracteres mediante las funciones 09h y 02h de la interrupción INT 21h del DOS. Además, recorre una tabla de bytes con `LOOP` y genera una línea decorativa con `TIMES`.

## Prerrequisitos
- DOSBox 0.74+
- NASM 2.14+
- ALINK

## Compilación y ejecución
```
nasm -f obj programa.asm -o programa.obj
alink programa.obj -oEXE -o programa.exe -entry main
programa.exe
```
Los comandos se ejecutan dentro de DOSBox, con la carpeta del proyecto montada como `C:\`.

## Salida esperada (Parte 1)
```
=== Laboratorio NASM - Unidad 4 ===
----------------------------------------
Variable A (word):  Z
: D N X b
Programa finalizado correctamente.
========================================
```
La tabla se imprime como `: D N X b` porque a cada valor (10, 20, 30, 40, 50) se le suma 30h antes de imprimirlo como carácter ASCII (58, 68, 78, 88 y 98). ALINK muestra el aviso `Warning - no stack`, que no impide la ejecución del programa.

## Capturas
- `capturas/CP1_compilacion.png`: ensamblado y enlazado.
- `capturas/CP2_ejecucion.png`: ejecución de la Parte 1.
- `capturas/CP3_times.png`: ejecución con la línea decorativa generada con `TIMES`.

## Decisiones técnicas — Parte 1

### Decisión 1: EQU vs. %define
El estudiante utilizó `EQU` para definir las constantes `CR`, `LF`, `TERMINADOR` e `ITERACIONES`. `EQU` asocia un nombre a un valor numérico que el ensamblador evalúa y verifica durante el ensamblado, mientras que `%define` es una sustitución de texto del preprocesador que se aplica antes de ensamblar, sin comprobar el contenido. Si un símbolo como `ANCHO_LINEA` se usara como argumento de `TIMES` y también en una comparación aritmética posterior, `EQU` evitaría mejor la sustitución ambigua, porque el valor ya está resuelto y no depende de cómo se expanda el texto ni de la precedencia de operadores (por ejemplo, un `%define ANCHO_LINEA 40+2` podría expandirse de forma inesperada dentro de una expresión mayor). Por el contrario, el estudiante preferiría `%define` cuando se necesite reutilizar texto o código literal, como un fragmento de instrucción, un nombre de registro o una cadena repetida, ya que en esos casos no existe un valor numérico que `EQU` pueda representar.

### Decisión 2: TIMES en .data vs. RESB + bucle
El estudiante generó la línea decorativa con `TIMES 40 DB '='` en la sección `.data`. Esta opción es preferible a escribir manualmente 40 caracteres `=` porque cambiar el ancho posteriormente solo exige modificar un número, con menos riesgo de error al contar o copiar caracteres. Usar `RESB 40` en `.bss` junto con un bucle `LOOP` sería válido en principio, pero resulta innecesario aquí, dado que el contenido de la línea nunca cambia entre ejecuciones: no hay razón para construirlo en tiempo de ejecución. Además, con `TIMES` los 40 bytes ya forman parte de la imagen del ejecutable desde el ensamblado, de modo que al arrancar no se ejecuta ninguna instrucción para producirlos. `RESB` más bucle requeriría instrucciones adicionales (inicializar `CX`, escribir cada byte, decrementar y saltar) que consumen ciclos y espacio de código en cada ejecución.
Parte 2: Macros con parámetros y control de flujo
Archivos
macros.asm: biblioteca de macros (fin_dos, nueva_linea, print_str, print_char, leer_char, repetir_str, print_digito y bloque_decorativo).
programa2.asm: programa integrador que incluye las macros con %include, el procedimiento sumar_serie (bucle con LOOP), y los procedimientos comparar_e_imprimir (CMP/Jcc) y comparar_menor_o_igual (JLE).
Compilación y ejecución

Debido a la limitación de nombres 8.3 de DOS, programa2.asm aparece en DOSBox como progra~1.asm, y los archivos de salida se nombraron con un nombre corto:

nasm -f obj progra~1.asm -o prog2.obj -l prog2.lst
alink prog2.obj -oEXE -o prog2.exe -entry main
prog2.exe
Salida esperada (Parte 2)
=== Macros y Control de Flujo ===
[Linea A] Primera impresion
[Linea A] Primera impresion
[Linea A] Primera impresion
El valor mayor es: 6
El valor mayor es: 9
Los valores son iguales.
---
---
---
AX es menor o igual: 3
Fin del programa.

comparar_e_imprimir se probó con AX>BX (9 y 4) y con valores iguales (5 y 5); comparar_menor_o_igual se probó con AX≤BX (3 y 8).

Capturas
capturas/CP1_listado_macros.png: listado .lst con macros expandidas.
capturas/CP2_ejecucion_macros.png: ejecución de prog2.exe con las macros básicas.
capturas/CP3_extension_rep.png: ejecución con %rep y comparar_menor_o_igual.
Decisiones técnicas — Parte 2
Decisión 3: %rep vs. LOOP

Con un número pequeño y fijo de copias, como 3, %rep es razonable frente a repetir_str porque el ensamblador genera directamente las instrucciones de print_str repetidas, y en ejecución no hay que inicializar CX ni ejecutar LOOP. El costo en bytes es el de duplicar el bloque: cada print_str ocupa aproximadamente 7 bytes (mov ah,09h son 2, mov dx,etiqueta son 3 e int 21h son 2), así que 3 copias suman unos 21 bytes, pero 1000 copias sumarían cerca de 7000 bytes y harían crecer el ejecutable en forma lineal. Si el número de repeticiones se leyera en tiempo de ejecución (por ejemplo con leer_char), repetir_str seguiría siendo la opción correcta, porque %rep exige una constante conocida al ensamblar y el preprocesador no puede expandir según un valor que solo existe cuando el programa corre. En el código expandido de repetir_str aparecen mov cx, N, la etiqueta local y la instrucción LOOP, ausentes en bloque_decorativo; esa ausencia es el costo cero en ejecución: no hay decremento, comparación ni salto por cada copia.

Decisión 4: ¿necesitan %% las extensiones de los Pasos 7 y 8?

La macro bloque_decorativo no necesita ninguna etiqueta, ni %% ni de otro tipo, porque %rep solo repite el texto de las instrucciones y cada copia es una secuencia lineal que se ejecuta de arriba hacia abajo; no hay un destino de salto que nombrar, y por eso puede invocarse varias veces sin generar nombres duplicados. Si se modificara para que un salto condicional omitiera la última copia, necesitaría una etiqueta de destino dentro de la macro, y como esa etiqueta se repetiría en cada invocación, se requeriría %% para que NASM genere un nombre único por expansión y evitar el error de símbolo duplicado. Por otro lado, comparar_menor_o_igual usa etiquetas con punto (.menor_o_igual, .fin_cmp2), que NASM asocia a la última etiqueta no local anterior, es decir, al nombre del procedimiento. Así quedan como comparar_menor_o_igual.menor_o_igual y comparar_e_imprimir.fin_comp, nombres completos distintos que no colisionan aunque ambos procedimientos estén en el mismo archivo.