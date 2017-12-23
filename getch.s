.version "0.1.0"

@ Raspberry Pi zero
.arch armv6z
.cpu arm1176jzf-s

@ use arm32 instead of thumb
.code 32			@ same as .arm

.syntax unified

.global _start

.set svc_exit, 1
.set svc_read, 3
.set svc_write, 4

.set stdin, 0
.set stdout, 1
.set stderr, 2

.set n, 64

.data
buffer: .skip n

.text
_start:

read:
	mov	r0, stdin
	ldr	r1, =buffer
	mov	r2, n
	mov	r7, svc_read
	svc	0

	mov	r2, r0
write:
	mov	r0, stdout
	ldr	r1, =buffer
	mov	r7, svc_write
	svc	0	

exit:
	rc 	.req r0

	mov	rc, 0
	mov	r7, svc_exit
	svc	0

