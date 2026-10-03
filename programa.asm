; programa.asm - Laboratorio Post1 Unidad 4
; Proposito: demostrar directivas de seccion, datos y constantes en NASM

; -- Constantes (EQU, no reservan memoria) -----------------------------------------
CR          EQU  0Dh         ; Carriage Return
LF          EQU  0Ah         ; Line Feed
TERMINADOR  EQU  24h         ; "$" terminador de cadena para DOS
ITERACIONES EQU  5           ; numero de repeticiones del bucle

; -- Datos inicializados --------------------------------------------------
section .data
    bienvenida  db "=== Laboratorio NASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   db "----------------------------------------", CR, LF, TERMINADOR
    etiqueta_a  db "Variable A (word):  ", TERMINADOR
    etiqueta_b  db "Variable B (dword): ", TERMINADOR
    fin_msg     db "Programa finalizado correctamente.", CR, LF, TERMINADOR
    var_byte    db  42
    var_word    dw  1234h
    var_dword   dd  0DEADBEEFh
    tabla_bytes db  10, 20, 30, 40, 50

; -- Datos no inicializados --------------------------------------------
section .bss
    buffer      resb 80
    resultado   resw 1

;-- Codigo ejecutable ----------------------------------------------
section .text
    global main
main:
    mov  ax, data
    mov  ds, ax
    mov  ah, 09h
    mov  dx, bienvenida
    int  21h
    mov  dx, separador
    int  21h
        ; === Función 09h: imprimir cadenas ===
    mov  ah, 09h
    mov  dx, etiqueta_a
    int  21h

    ; === Función 02h: imprimir un carácter ===
    mov  al, [var_byte]
    add  al, 30h
    mov  ah, 02h
    mov  dl, al
    int  21h

    mov  ah, 02h
    mov  dl, CR
    int  21h
    mov  dl, LF
    int  21h

    ; === Recorrer tabla de bytes e imprimir cada elemento ===
    lea  si, tabla_bytes
    mov  cx, ITERACIONES
imprimir_tabla:
    mov  al, [si]
    add  al, 30h
    mov  ah, 02h
    mov  dl, al
    int  21h
    mov  ah, 02h
    mov  dl, 20h
    int  21h
    inc  si
    loop imprimir_tabla

    mov  ah, 02h
    mov  dl, CR
    int  21h
    mov  dl, LF
    int  21h
    mov  ax, 4C00h
    int  21h