@ Raspberry Pi zero
.arch armv6z
.cpu arm1176jzf-s

@ use arm32 instead of thumb
.code 32			@ same as .arm

.syntax unified

.global _start

.set RC_OK, 0

.text
_start:
	mov	r0, r0

exit:
	rc 	.req r0

	mov	rc, RC_OK
	mov	r7, 1
	svc	0

