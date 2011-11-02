.include "msp430g2x31.inc"

org 0xf800
;;;start routeine.
start:
         mov.w #(WDTPW|WDTHOLD), &WDTCTL
         mov.w #0x280, SP   
	 eint
	 mov r2,r4
	 dint   
         mov.b #255,&P1DIR
         mov.b #0,&P1OUT
     	 mov.b #1,&0x270
	 mov.w #(TASSEL_2|MC_1|ID_3), &TACTL
         mov.w #(CCIE), &TACCTL0
         mov.w #100, &TACCR0
	 mov.w #0x258,SP
	 push #task1
	 push r4
	 push 0
	 push 0
	 mov.w SP,&0x214
	 
	 mov.w #0x230,SP
	 mov.w SP,&0x216
	 eint
	 jmp task2
gg:        jmp gg

;;;timer isr. 
isr:
	push.w r4
	push.w r7
	mov.b &0x270 ,r4
   	add r4,r4
	mov.w SP,0x214(r4)
	add #1,&0x270
	mov.b &0x270,r4
	cmp #2,r4
	jne non_zero
	mov.w #0,&0x270
	mov.w #0,r4
non_zero:
	add r4,r4
	mov.w 0x214(r4),SP
	mov.w SP,r5
	add #8,r5
	mov.w r5,0x214(r4)
	
	pop.w r7
	pop.w r4
	pop.w r2
	pop.w r0

;;;task1 to execute.
task1:
	xor.b #1,&P1OUT
	mov #50000,r4
loop1:
	dec r4
	jnz loop1
	jmp task1
	
;;;task2 to execute.
task2:
	xor.b #(1<<6),&P1OUT
	mov #10000,r4
loop2:
	dec r4
	jnz loop2
	jmp task2

;;vector table.
org 0xfffe          ;reset vector
       dw start
org 0xfff2
       dw isr
