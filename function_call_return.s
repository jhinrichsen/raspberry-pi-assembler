.global _start
.text

_start:
	mov r4, #32
	@ will implicitly park next pc into lr
	bl fn1

	@ exit
	mov r0, r4
	mov r7, #1
	svc 0	

fn1:
	mov r4, #16
	# bx lr is newer, and favoured over mov pc, lr
	bx lr
