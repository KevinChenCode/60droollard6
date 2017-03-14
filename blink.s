.equ leds, 	0xFF200000
.equ timer, 0xFF202000
.equ period, 50000000

.global start

start:
	movia r6, timer

	movia r5, %lo(period)
	stwio r5, 8(r6) 
	movia r5, %hi(period)
	stwio r5, 12(r6) 				#pushes period to timer 

	movia 	r5, 0x00000011		
	ldwio	r5, 4(r6)				#put interupt into timer
	movia 	r5, 0x1 				
	wrctl 	ctl3, r5 				#enable interupt on device



wait_looper:
	br wait_looper

.section exceptions, "ax"
	rdctl et, ctl4
	andi et, et, 0x1
	beq et, r0, interupt_return
	movia r6, timer

	stwio r0, 0(r6)
	movia r8, leds
	ldwio r9, 0(r8)
	xori r9, r9, 0x3FF
	stwio r9, 0(r8)

interupt_return:
	addi ea, ea, -4
	eret
