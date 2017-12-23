
.version "0.1.0"

@ Raspberry Pi zero
.arch armv6z
.cpu arm1176jzf-s

@ use arm32 instead of thumb
.code 32			@ same as .arm

.syntax unified

.global _start

@ from /usr/include/asm-generic/fcntl.h
.set o_rdwr,	00000002		@ open for read/write
.set o_dsync,	00010000		@ sync virtual memory
.set __o_sync,	04000000
.set o_sync,	__o_sync|o_dsync

@ from /usr/include/arm-linux-gnueabihf/asm/unistd.h
.set svc_exit, 1
.set svc_open, 5
.set svc_close, 6
.set svc_mmap, 90			@ -38, not available. why?
.set svc_mmap2, 192
.set svc_munmap, 91

@ from /usr/include/arm-linux-gnueabihf/bits/mman-linux.h
.set map_shared, 1
.set map_private, 2
.set prot_read, 0x1
.set prot_write, 0x2
.set mmap_size, 4096			@ raspbian page size
.set prot_rdwr, prot_read|prot_write

.set rc_ok, 0
.set nleds, 8
.set pin_dat, 16
.set pin_clk, 18
.set bcm_dat, 23
.set bcm_clk, 24
.set brightness, 7

.data
@ brightness needs to be transferred first, so using this layout we just send
@ 32 bits straight through (left -> right)
@ +-----------+-----------+-----------+-----------+
@ |brightness |     b     |     g     |     r     |
@ +-----------+-----------+-----------+-----------+
buffer:
	.byte brightness, 0, 0, 0	@ led 0
	.byte brightness, 0, 0, 0	@ led 1
	.byte brightness, 0, 0, 0	@ led 2
	.byte brightness, 0, 0, 0	@ led 3
	.byte brightness, 0, 0, 0	@ led 4
	.byte brightness, 0, 0, 0	@ led 5
	.byte brightness, 0, 0, 0	@ led 6
	.byte brightness, 0, 0, 0	@ led 7

.section .rodata

filename:
	@ although we're not using glibc, Linux kernel API requires zero
	@ terminated C strings
	.asciz "/dev/gpiomem"
	.set filename_len, .-filename

.text
_start:
	fd 	.req r8
	gpio	.req r9

	mov	r0, r0

open:	@ open device
	ldr	r0, =filename
	ldr	r1, open_mode
	mov	r7, svc_open
	svc	0
	mov	fd, r0

mmap:	@ map memory fd
	mov	r0, 0			@ let kernel pick memory
	mov	r1, mmap_size
	mov	r2, prot_rdwr		@ read and write access
	mov	r3, map_shared
	mov	r4, fd
	ldr	r5, mmap_offset		@ offset
	mov	r7, svc_mmap2
	svc	0
	mov	gpio, r0

munmap:	@ unmap memory
	mov	r0, gpio
	mov	r7, svc_munmap
	svc	0

close:	@ close device
	mov	r0, fd
	mov	r7, svc_close
	svc	0
exit:
	@ use last r0 mov	rc, rc_ok
	mov	r7, svc_exit
	svc	0

gpio_setup:
	@ set mode bcm
	@ no warnings
	@ prepare dat for output
	@ prepare clk for output
	bx	lr

show:	@ send buffer to blinkt!
	push	{lr}
	bl	sot

	bl	eot
	pop	{lr}
	bx	lr

sot:	@ start of transmission
	@ 0 -> dat
	@ 36 times:
		@ 1 -> clk
		@ 0 -> clk
	bx	lr

eot:	@ end of transmission
	@ 0 -> dat
	@ 32 times:
		@ 1 -> clk
		@ 0 -> clk
	bx	lr

.align 2
open_mode:	.word	o_rdwr|o_sync

@ .set bcm2835, 0x20000000
@ .set pi1gpio, bcm2835 + 0x200000
@ .set mmap_offset, p1gpio / mmap_size	@ mmap2 page offset
@ .set mmap_offset, 0x20200

mmap_offset:	.word	(0x20000000 + 0x200000) >> 12

