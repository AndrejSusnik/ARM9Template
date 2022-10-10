.data 
num1: .word 5
num2: .word 2
tmp: .space 4
.text
_start:

mov r3, #0
_loop:
    ldr r0, =num1
    ldr r1, [r0]
    add r3, r3, r1

    ldr r0, =num2
    ldr r1, [r0]
    sub r3, r3, r1

    ldr r0, =tmp
    str r3, [r0] 

    b _loop
b _start
