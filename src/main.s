.data
    num1: .word 5
    num2: .word 20
    tmp: .space 4

.text
.align
.global __start

__start:

mov r6, #6
_loop:
    ldr r0, =tmp
    ldr r3, [r0]

    ldr r0, =num1
    ldr r1, [r0]
    add r3, r3, r1

    ldr r0, =num2
    ldr r1, [r0]
    sub r3, r3, r1

    ldr r0, =tmp
    str r3, [r0] 

    mov r0, #0
    mov r1, #0
    mov r3, #0

    b _loop

__end: b __end
