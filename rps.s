;;; Group 5 Semester Project
;;; Rock Paper Scissors
;;; rps.s

section .data

gameinst:		db		"GAME INSTRUCTIONS: Rock = 1, Paper = 2, Scissors = 3",10,0

userwin:		db		"You won!",10,0
compwin:		db		"The computer won!",10,0
tied:			db		"You tied!",10,0

compRock:		db		"The computer chose rock!",10,0
compPaper:		db		"The computer chose paper!",10,0
compScissors:	db		"The computer chose scissors!",10,0

playerRock:		db		"You chose rock!",10,0
playerPaper:	db		"You chose paper!",10,0
playerScissors:	db		"You chose scissors!",10,0

;again:			db		"Play again? 1 = Yes",10,0
goodbye:		db		"Until next time!",10,0

scanf_fmt:		db		"%d",0

test1:			db		"--Entering function--",10,0
test2:			db		"--End of function--",10,0

CMPerror:		db		"CMP error!",10,0
error1:			db      "Error1!",10,0
error2:			db      "Error2!",10,0
error3:			db      "Error3!",10,0




section .text

extern printf
extern scanf
extern time, srand, rand

global main

main:

	; Align the stack
	push 	rbp
	mov 	rbp, rsp
	sub 	rsp, 8
	; Re-align stack
	sub 	rsp, 8

	; Print out the prompt
	mov 	rdi, gameinst
	call 	printf

	push 	rbx
	; User input
	xor 	rax, rax
	mov		rdi, scanf_fmt
	mov		rsi, rbp
	sub		rsi, 8
	call	scanf

	pop		rbx

.rand:
	; Modulate the random number by 3 once
	; The result will be either 0, 1, or 2
	; Add 1 to the returned value to recieve a 1, 2, or 3

	;mov 	rdi, test1
	;call 	printf

	; Clear the stuff
	xor 	rax, rax
	xor 	rdx, rdx
	xor		rbx, rbx

	; Call necessary random C functions
	; Time returns a number based off current time
	call 	time
	; Which then puts it into srand, which then returns a seed
	call	srand	
	; Which then puts the seed into rand, which returns our random number
	call 	rand 

	; The remainder will be returned in rdx, clear rdx
	mov 	rdx, 0
	; Mod3
	mov 	rbx, 3
	; Perform our division, remainder is returned in rdx
	div 	rax, rbx
	; Add 1 to rdx
	inc		rdx
	
	; Add the value of the random number into r13 for comparison
	mov		r13, rdx

	
	;mov 	rdi, test2
	;call 	printf

.userCMP:
	mov		r12, qword[rbp-8]

	; Checking to see what the player chose
	cmp		r12, 1 	; rock
	je		.sit1

	cmp		r12, 2 	; paper
	je		.sit2

	cmp 	r12, 3 	; scissors
	je 		.sit3

	mov 	rdi, CMPerror
	call 	printf
	
.sit1:				; player chose rock
	mov 	rdi, playerRock
	call    printf

	cmp 	r13, 1 	; npc rock vs player rock
	je		.tieRock

	cmp		r13, 2	; npc paper vs player rock
	je		.computerwinRock

	cmp 	r13, 3	; npc scissors vs player rock
	je		.playerwinRock	

	mov 	rdi, error1
	call 	printf

.sit2:				; player chose paper
	mov 	rdi, playerPaper
	call 	printf

	cmp		r13, 1 	; npc rock vs player paper
	je		.playerwinPaper

	cmp		r13, 2	; npc paper vs player paper
	je		.tiePaper

	cmp 	r13, 3	; npc scissors vs player paper
	je		.computerwinPaper

	mov 	rdi, error2
	call 	printf

.sit3:				; player chose scissors
	mov		rdi, playerScissors
	call	printf

	cmp		r13, 1 	; npc rock vs player scissors
	je 		.computerwinScissors

	cmp		r13, 2	; npc paper vs player scissors
	je		.playerwinScissors

	cmp		r13, 3	; npc scissors vs player scissors
	je		.tieScissors

	mov 	rdi, error3
	call 	printf

; The following are all possible win, loss, tie scenarios
; with computer decision stdout
.playerwinRock:
	mov		rdi, compScissors
	call 	printf
	mov 	rdi, userwin
	call	printf
	jmp		.end

.computerwinRock:
	mov		rdi, compPaper
	call 	printf
	mov		rdi, compwin
	call	printf
	jmp		.end

.tieRock:
	mov		rdi, compRock
	call 	printf
	mov		rdi, tied
	call 	printf
	jmp		.end

.playerwinPaper:
	mov		rdi, compRock
	call 	printf
	mov 	rdi, userwin
	call	printf
	jmp		.end

.computerwinPaper:
	mov		rdi, compScissors
	call 	printf
	mov		rdi, compwin
	call	printf
	jmp		.end

.tiePaper:
	mov		rdi, compPaper
	call 	printf
	mov		rdi, tied
	call 	printf
	jmp		.end

.playerwinScissors:
	mov		rdi, compPaper
	call 	printf
	mov 	rdi, userwin
	call	printf
	jmp		.end

.computerwinScissors:
	mov		rdi, compRock
	call 	printf
	mov		rdi, compwin
	call	printf
	jmp		.end

.tieScissors:
	mov		rdi, compScissors
	call 	printf
	mov		rdi, tied
	call 	printf
	jmp		.end


; Wrap it up
.end:


	mov  	rax, 0
	pop	 	rbp

	mov 	rdi, goodbye
	call	printf

	mov 	rax, 60
	mov		rdi, 0
	syscall
	
