.include "msp430g2x31.inc"

org 0xf800

start:
         mov.w #(WDTPW|WDTHOLD), &WDTCTL
         mov.w #0x280, SP      
         mov.b #255,&P1DIR
         mov.b #0,&P1OUT
     	 mov.b #0,&0x270
	 mov.b #0,r5
         mov.w #(TASSEL_2|MC_1|ID_3), &TACTL
         mov.w #(CCIE), &TACCTL0
         mov.w #50000, &TACCR0
	 mov.b #1,&0x280	
         eint		

gg:        jmp gg
 
isr:
	mov.w &270,r4
	xor #1,&270
	xor #1,r5
	cmp #1,r5
	jne task1
	jmp task2

task1:
	mov.b #0x0f,&P1OUT
	reti

task2:
	mov.b #0xf0,&P1OUT 
	reti


org 0xfffe          ;reset vector
       dw start

org 0xfff2
       dw isr
