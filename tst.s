.syntax unified
.globl _start
_start:
/*
	@ GPIO base on Pi zero
	ldr r0,=0x20200000

	@ enable output
	mov r1,#1
	lsl r1,#18
	str r1,[r0,#4]

	@turn on LED by clearing bit
	mov r1,#1
	lsl r1,#16
	str r1,[r0,#40]
*/
	mov r0, #3
	mov r7, #1
	svc	#0
