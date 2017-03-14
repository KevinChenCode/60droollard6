.equ JTAG, 0xFF201000

.global _start

_start:
	movia r10, JTAG
	movui r11, 0b01
	wrctl ctl0, r11 #enable ctl0 PIE bit and enable device interrupts

	stwio r11, 4(r10)
	movui r11, 0x100
	wrctl ctl3, r11

	movui r2, 0x30


	looper:
		movui r4, 0x1B
		call smash_that_mf_like_button

		movui r4, 0x5B
		call smash_that_mf_like_button

		movui r4, 0x32
		call smash_that_mf_like_button

		movui r4, 0x4B
		call smash_that_mf_like_button
	br looper



smash_that_mf_like_button:
	ldwio r11, 4(r10)
	srli r11, r11, 16
	beq r11, r0, smash_that_mf_like_button

	#we have space to write, now we write the input character

	stwio r4, 0(r10)
	ret


wait_looper:
	br wait_looper

.section .exceptions, "ax"
.align 2

interupt:
	rdctl et, ctl4
	srli et, et, 8
	andi et, et, 0x1
	beq et, r0, interupt_return

	ldwio et, 0(r10)
	andi et, et, 0x0FF
	mov r2, et


interupt_return:
	addi ea, ea, -4
	eret
