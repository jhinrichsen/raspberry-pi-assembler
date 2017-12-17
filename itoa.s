
@ udiv is only available for later ARM processors,not for Pi zero

.globl _start

.data
.align 4
	buf_begin: .skip 10
	buf_end:
.ascii	"\n"

.align 4
.text
_start:
	mov	r0,#8192
	ldr	r1,=buf_begin
	bl	itoa

	mov	r1, r0		@ const void *buf
	mov	r0,#1		@ int fd: stdout
	ldr	r3,=buf_end
	sub	r2,r3,r1
	add	r2,#1		@ size_t count
	mov	r7,#4		@ write()
	svc	$0

exit:
	mov	r0,#0
	mov	r7,#1
	svc	0

@ in:
@ 	r0: unsigned integer
@	r1: address of 10 byte buffer
@ out:
@	r0: address of decimal,base 10 encoded string (between r1 and r1+10)

itoa:
	@ fill reverse from back of buffer
	add	r1,#10
	
	@ https://www.sciencezero.org/index.php?title=ARM:_Division_by_10
	ldr	r2,=429496730
	mov	r6,#10

	mov	r3,r0
loop:
	@ r0 = r3 * 10 + r4
	mov	r0,r3
	sub 	r3,r3,r3,lsr #30
	umull	r4,r3,r2,r3

	mov	r5,r3
	mul	r5,r6
	sub	r4,r0,r5
	mov	r7,#48	@ '0'
	add	r7,r4
	sub	r1,#1
	strb	r7,[r1]

	cmp	r3,#0
	bne	loop
	mov	r0, r1
	bx	lr 
