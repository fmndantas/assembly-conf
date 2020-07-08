%include	'functions.asm'

SECTION .data
string 	db	
	
SECTION .bss
	
SECTION .text
global _start

	
_start:
	pop	ecx		; numero de argumentos
	pop	edx		; nome do programa
	sub	ecx, 1		; desconsiderar nome do programa
	mov	edx, 0		; edx recebera as somas
	
nextNumber:	
	cmp 	ecx, 0h
	jz	finish
	pop	eax
	call	atoi		; eax contem numero convertido
	add	edx, eax
	dec	ecx
	jmp 	nextNumber
	
finish:
	mov	eax, edx
	call	iprintLF
	call 	quit
	
