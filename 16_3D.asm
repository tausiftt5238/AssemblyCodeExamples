;contains move_paddle and draw_paddle
extern paddle_top:word,paddle_bottom:word
public draw_paddle, move_paddle
.model small
.code

draw_paddle proc
;draw paddle in column 11
;input : AL contains pixel value
; 2 (red) for display and 0 (green) to erase
;save registers
	push cx
	push dx
	
	mov ah,0ch		;write pixel function
	mov cx, 11		;column 11
	mov dx,paddle_top	;top row
dp1:
	int 10h
	inc dx			;next row
	cmp dx,paddle_bottom	;done?
	jle dp1			;no,repeat
	;restore registers
	pop dx
	pop cx
	ret
draw_paddle endp

move_paddle proc
;move paddle up or down
;input:  AX = 2 (to move paddle down 2 pixels)
;			= -2 (to move paddle up 2 pixels)
	mov bx,ax		;copy to bx
;check direction
	cmp ax,0
	jl up			;neg , move up
;move down, check paddle position
	cmp paddle_bottom,118	;at bottom?
	jge done				;yes, can't move
	jmp update				;no, update paddle
;move up, check if at top
up:
	cmp paddle_top,11		;at top?
	jle done				;yes , can't move
;move paddle
update:
;erase paddle
	mov al,0				;green color
	call draw_paddle
;change paddle position
	add paddle_top,bx
	add paddle_bottom,bx
;display paddle at new position
	mov al,2				;red color
	call draw_paddle
done: ret
move_paddle endp
	end