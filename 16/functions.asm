atoi:
	PUSH 	ebx
	PUSH 	ecx
	PUSH	edx
	PUSH	esi
	MOV	esi, eax	; numero que sera convertido em esi
	MOV	eax, 0		; eax segurara o valor da soma
	MOV	ecx, 0

.multiplyLoop:
	XOR	ebx, ebx	; zero parte alta e parte baixa de ebx
	MOV 	bl, [esi+ecx]	; move um byte da string de esi+ecx para byte menos significativo de ebx (bl)
	CMP	bl, 48		; checa se bl eh 'maior' que 1 (ascii)
	JL	.finished	; se for menor, termina
	CMP	bl, 57		; checa se bl eh 'menor' que 9 (ascii)
	JG	.finished	; se for maior, termina

	SUB	bl, 48		; converte byte de string para decimal
	ADD	eax, ebx	; atualiza soma
	MOV	ebx, 10
	MUL	ebx		; eax := 10 * eax
	INC	ecx
	JMP	.multiplyLoop	; converter proximo byte para numero
		
.finished:
	MOV	ebx, 10		; corrige ultima MULtiplicacao desnecessaria de eax
	DIV	ebx
	POP 	esi
	POP 	edx
	POP	ecx
	POP	ebx
	RET

iprint:
	PUSH	eax
	PUSH	ecx
	PUSH 	edx
	PUSH 	esi
	MOV	ecx, 0

getNextNumber:
	INC	ecx
	MOV 	edx, 0
	MOV	esi, 10
	IDIV	esi
	ADD 	edx, 48
	PUSH	edx
	CMP	eax, 0
	JNZ	getNextNumber

printNextNumber:
	DEC	ecx
	MOV	eax, esp
	CALL	sprint
	POP	eax
	CMP	ecx, 0
	JNZ	printNextNumber

	POP	esi
	POP	edx
	POP	ecx
	POP	eax

	RET
	
iprintLF:
	CALL 	iprint
	PUSH	eax
	MOV	eax, 0Ah
	PUSH	eax
	MOV	eax, esp
	CALL	sprint
	POP	eax
	POP	eax
	RET
	
;----------------------------
; INT slen(string msg)
;----------------------------
slen:
	PUSH 	ebx
	MOV	ebx, eax

nextchar:
	CMP	byte [eax], 0
	JZ 	finished
	INC 	eax
	JMP	nextchar

finished:
	SUB	eax, ebx
	POP	ebx
	RET

;----------------------------
; void sprint(string msg)
; eax contem a mensagem
;----------------------------
sprint:
	PUSH	edx
	PUSH 	ecx
	PUSH	ebx
	PUSH 	eax
	CALL	slen

	MOV	edx, eax
	POP	eax

	MOV	ecx, eax
	MOV	ebx, 1
	MOV	eax, 4
	INT	80h

	POP 	ebx
	POP 	ecx
	POP 	edx
	RET


;----------------------------
; void sprintLF(string msg)
; eax contem a mensagem
; print com linefeed no final
;----------------------------
sprintLF:
	CALL	sprint
	PUSH	eax
	MOV 	eax, 0Ah	; nao usa simplesmente eax porque sprint precisa de um endereco de memoria e 0Ah eh uma string
	PUSH	eax
	MOV	eax, esp	; esp armazena o endereco do topo da pilha
	CALL 	sprint
	POP	eax		; restore eax to 0Ah
	POP	eax		; restore eax to message
	RET


;----------------------------
; void exit()
;----------------------------
quit:
	MOV	eax, 1
	MOV 	ebx, 0
	INT	80h
	RET
