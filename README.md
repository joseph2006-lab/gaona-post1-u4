# gaona-post1-u4

## Descripción
Laboratorio de la Unidad 4: programa NASM con segmentos y salida DOS (Parte 1) y
macros con control de flujo (Parte 2).

## Prerrequisitos
- DOSBox 0.74+
- NASM 2.14+
- ALINK

## Compilación y ejecución
nasm -f obj programa.asm -o programa.obj
alink programa.obj -oEXE -o programa.exe -entry main
Ejecutar programa.exe dentro de DOSBox