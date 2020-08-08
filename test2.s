.intel_syntax noprefix
.globl main
main:
        push    rbp
        mov     rbp, rsp
        mov     eax, 42
        pop     rbp
        ret