	.file	"example_fact.c"
	.text
	.section	.rodata
.LC0:
	.string	"13th Fibonacci = %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$13, %edi
	call	my_fact
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	my_fact
	.type	my_fact, @function
my_fact:
.LFB1:
	.cfi_startproc
/* START OF STACK CODE */
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp   /* include more stack ??? */
	movl	%edi, -4(%rbp)  /* shadow 'n' to stack */
/* END OF STACK CODE */
/* CONDITIONAL JUMP */
/* addi $t0 $0 1 */
/*   lw $t1 -4($rbp) */
/*   bgt $t0 $t1 .L4 */
	cmpl	$1, -4(%rbp)
	jg	.L4
/* Fall through 'return n' base case */
    /* -4(%rbp) <- n */
	movl	%edi, %eax /* eax is = $v0 */
	jmp	.L5 /* 'j' */

/* START OF RECURSIVE CALL */
.L4:
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %edi

	/*movl	-4(%rbp), %edi
	subl	$1, %edi
	movl	%eax, %edi */
    /* Set up to assume input is in EDI */
	call	my_fact
    /* return register eax -> fib(n-1) */
    /* save fib(n-1) onto stack */
    	movl    %eax, -8(%rbp)    

    /* fib(n-2) */
    	movl    %eax, %esi
	movl	-4(%rbp), %eax
	subl	$2, %eax
	movl	%eax, %edi
  	call    my_fact
    
    /* fib(n-1) + fib(n-2)
       -8(%rbp) -> fib(n-1)
       eax -> fib(n-2) */
       addl    -8(%rbp), %eax
/* End of the recursive call */
/* Start of take down stack frame, return */
.L5:
	leave /* ???? */
	.cfi_def_cfa 7, 8
	ret /* jr $ra */
	.cfi_endproc
.LFE1:
	.size	my_fact, .-my_fact
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
