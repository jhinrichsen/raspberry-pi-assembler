.globl _start
.text

_start:
	@ count
	mov r0, #1000

	@ sum
	mov r1, #0

	@ partial sum
	mov r2, #0

	@ index
	mov r3, #0

	@ increment
	mov r4, #3
_3:
	add r2, r3
	add r3, r4
	cmp r3, r0
	blt _3
	add r1, r2	@ add partial sum to sum

	mov r2, #0	@ reset partial sum
	mov r3, #0	@ next index
	mov r4, #5	@ next increment
_5:
	add r2, r3
	add r3, r4
	cmp r3, r0
	blt _5
	add r1, r2	@ add partial sum to sum

	@ subtract double-added multiples of 15
	mov r2, #0	@ reset partial sum
	mov r3, #0	@ next index
	mov r4, #15	@ next increment
_15:
	add r2, r3
	add r3, r4
	cmp r3, r0
	blt _15
	sub r1, r2	@ subtract partial sum from sum
	
	@ exit
	@ TODO exit code is 8 bit only, print result
	mov r0, r1
	mov r7, #1
	svc #0
		

