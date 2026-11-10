.text

    .globl relation_code
    .type relation_code, @function
relation_code:
    # TODO: Problem 1
    movq $0, %rax
    cmpq %rsi, %rdi
    jl .Lsigned_less
    jmp .Lcheck_unsigned
.Lsigned_less:
    movq $1, %rax
.Lcheck_unsigned:
    cmpq %rsi, %rdi        
    jb .Lunsigned_less
    jmp .Lrel_done
.Lunsigned_less:
    addq $2, %rax
.Lrel_done:
    ret

    .globl clamp_long
    .type clamp_long, @function
clamp_long:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax        
    cmpq %rsi, %rax
    jge .Lnot_low
    movq %rsi, %rax         
    jmp .Lclamp_end
.Lnot_low:
    cmpq %rdx, %rax
    jle .Lclamp_end
    movq %rdx, %rax        
.Lclamp_end:
    leave
    ret

    .globl weighted_sum8
    .type weighted_sum8, @function
weighted_sum8:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax         
    movq %rsi, %r10
    imulq $2, %r10
    addq %r10, %rax
    movq %rdx, %r10
    imulq $3, %r10
    addq %r10, %rax
    movq %rcx, %r10
    imulq $4, %r10
    addq %r10, %rax
    movq %r8, %r10
    imulq $5, %r10
    addq %r10, %rax
    movq %r9, %r10
    imulq $6, %r10
    addq %r10, %rax
    movq 16(%rbp), %r10     
    imulq $7, %r10
    addq %r10, %rax
    movq 24(%rbp), %r10     
    imulq $8, %r10
    addq %r10, %rax
    leave
    ret

    .globl alternating_sum
    .type alternating_sum, @function
alternating_sum:
    movq $0, %r8            
    movq $1, %rcx     
    movq $1, %r9    
.Lalt_loop:
    cmpq %rdi, %rcx
    jg .Lalt_done
    cmpq $1, %r9
    jne .Lalt_even
    addq %rcx, %r8       
    jmp .Lalt_next
.Lalt_even:
    subq %rcx, %r8          
.Lalt_next:
    imulq $-1, %r9
    addq $1, %rcx
    jmp .Lalt_loop
.Lalt_done:
    movq %r8, %rax
    ret

    .globl recursive_power
    .type recursive_power, @function
recursive_power:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    movq %rdi, -8(%rbp)    
    movq %rsi, -16(%rbp)    
    cmpq $0, %rsi
    je .Lpow_base
    movq -16(%rbp), %rsi
    subq $1, %rsi
    movq -8(%rbp), %rdi
    call recursive_power
    imulq -8(%rbp), %rax
    jmp .Lpow_end
.Lpow_base:
    movq $1, %rax
.Lpow_end:
    leave
    ret

    .globl combine_helpers
    .type combine_helpers, @function
combine_helpers:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    movq %rsi, -8(%rbp)
    call helper_square
    movq %rax, -16(%rbp)
    movq -8(%rbp), %rdi
    call helper_affine
    addq -16(%rbp), %rax
    leave
    ret

       .section .note.GNU-stack,"",@progbits 

