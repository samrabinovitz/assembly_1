.text

    .globl relation_code
    .type relation_code, @function
relation_code:
    # TODO: Problem 1
    movq $0, %rax
    cmpq %rsi, %rdi
    jge .Lrel_unsigned      
    addq $1, %rax          
.Lrel_unsigned:
    cmpq %rsi, %rdi         
    jae .Lrel_done          
    addq $2, %rax          
.Lrel_done:
    ret

    .globl clamp_long
    .type clamp_long, @function
clamp_long:
    movq %rdi, %rax
    cmpq %rsi, %rdi
    jge .Lclamp_check_high
    movq %rsi, %rax
    ret
.Lclamp_check_high:
    cmpq %rdx, %rdi
    jle .Lclamp_done
    movq %rdx, %rax
.Lclamp_done:
    ret

    .globl weighted_sum8
    .type weighted_sum8, @function
weighted_sum8:
    movq %rdi, %rax
    imulq $2, %rsi
    addq %rsi, %rax
    imulq $3, %rdx
    addq %rdx, %rax
    imulq $4, %rcx
    addq %rcx, %rax
    imulq $5, %r8
    addq %r8, %rax
    imulq $6, %r9
    addq %r9, %rax
    movq 8(%rsp), %r10
    imulq $7, %r10
    addq %r10, %rax
    movq 16(%rsp), %r10
    imulq $8, %r10
    addq %r10, %rax
    ret

    .globl alternating_sum
    .type alternating_sum, @function
alternating_sum:
    movq $0, %rax
    movq $1, %rcx
.Lalt_loop:
    cmpq %rdi, %rcx
    jg .Lalt_done
    addq %rcx, %rax
    addq $1, %rcx
    cmpq %rdi, %rcx
    jg .Lalt_done
    subq %rcx, %rax
    addq $1, %rcx
    jmp .Lalt_loop
.Lalt_done:
    ret

    .globl recursive_power
    .type recursive_power, @function
recursive_power:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    cmpq $0, %rsi
    jne .Lpow_recurse
    movq $1, %rax
    leave
    ret
.Lpow_recurse:
    movq %rdi, -8(%rbp)
    subq $1, %rsi
    call recursive_power
    imulq -8(%rbp), %rax
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