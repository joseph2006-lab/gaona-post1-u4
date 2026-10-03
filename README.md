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