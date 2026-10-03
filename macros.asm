; macros.asm - biblioteca de macros utilitarias

%macro fin_dos 0
    mov  ax, 4C00h
    int  21h
%endmacro

%macro nueva_linea 0
    mov  ah, 02h
    mov  dl, 0Dh
    int  21h
    mov  dl, 0Ah
    int  21h
%endmacro

; %1 = etiqueta de la cadena
%macro print_str 1
    mov  ah, 09h
    mov  dx, %1
    int  21h
%endmacro

; %1 = valor ASCII del caracter
%macro print_char 1
    mov  ah, 02h
    mov  dl, %1
    int  21h
%endmacro

%macro leer_char 0
    mov  ah, 07h
    int  21h
%endmacro

; %1 = etiqueta de la cadena, %2 = numero de repeticiones
%macro repetir_str 2
    mov  cx, %2
%%ciclo:
    mov  ah, 09h
    mov  dx, %1
    int  21h
    loop %%ciclo
%endmacro

%macro print_digito 0
    push ax
    and  al, 0Fh
    add  al, 30h
    mov  ah, 02h
    mov  dl, al
    int  21h
    pop  ax
%endmacro