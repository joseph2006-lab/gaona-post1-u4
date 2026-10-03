; programa2.asm - Laboratorio Post2 Unidad 4
%include "macros.asm"

section .data
    titulo      db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    linea_a     db "[Linea A] Primera impresion", 0Dh, 0Ah, 24h
    linea_b     db "[Linea B] Segunda impresion", 0Dh, 0Ah, 24h
    msg_mayor   db "El valor mayor es: ", 24h
    msg_iguales db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_fin     db "Fin del programa.", 0Dh, 0Ah, 24h
    separador_corto  db "---", 0Dh, 0Ah, 24h
    msg_menor_igual  db "AX es menor o igual: ", 24h
    msg_mayor2       db "AX es mayor: ", 24h

section .bss
    valor_a     resw 1
    valor_b     resw 1

section .text
    global main
main:
    mov  ax, data
    mov  ds, ax
    print_str titulo
    repetir_str linea_a, 3

    mov  cx, 3
    call sumar_serie
    print_str msg_mayor
    print_digito
    nueva_linea

    mov  ax, 9
    mov  bx, 4
    call comparar_e_imprimir

    mov  ax, 5
    mov  bx, 5
    call comparar_e_imprimir
    ; 7. Bloque decorativo desenrollado con %rep (3 copias)
    bloque_decorativo 3

    ; 8. Comparacion con condicion JLE
    mov  ax, 3
    mov  bx, 8
    call comparar_menor_o_igual

    print_str msg_fin
    fin_dos

; Entrada: CX = N ; Salida: AX = suma total
sumar_serie:
    push cx
    xor  ax, ax
.paso:
    add  ax, cx
    loop .paso
    pop  cx
    ret

comparar_e_imprimir:
    push ax
    push bx
    cmp  ax, bx
    je   .son_iguales
    jg   .ax_mayor
    print_str msg_mayor
    mov  al, bl
    print_digito
    nueva_linea
    jmp  .fin_comp
.ax_mayor:
    print_str msg_mayor
    print_digito
    nueva_linea
    jmp  .fin_comp
.son_iguales:
    print_str msg_iguales
.fin_comp:
    pop  bx
    pop  ax
    ret
comparar_menor_o_igual:
    push ax
    push bx
    cmp  ax, bx
    jle  .menor_o_igual
    print_str msg_mayor2
    print_digito
    jmp  .fin_cmp2
.menor_o_igual:
    print_str msg_menor_igual
    print_digito
.fin_cmp2:
    nueva_linea
    pop  bx
    pop  ax
    ret