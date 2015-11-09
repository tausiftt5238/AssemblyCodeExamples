;sound generating procedure
Extern timer_flag : byte
public beep
.model small
.code
beep proc
;generate beeping sound
	push cx		;save cx
;initialize timer
	mov al,0b6h	;specify mode of operation
	out 43h,al	;write to port 43h
	;load count
	mov ax,1193	;count for 1000hz
	out 42h,al	;low byte
	mov al,ah	;high byte
	out 42h,al
	
	;activate speaker
	in al,61h	;read control port
	mov ah,al	;save value in ah
	or al,11B	;set control bits
	out 61h,al	;activate speaker
	;500 ms delay loop
	mov cx,9	;do 9 times
b_1:
	cmp timer_flag,1	;check timer flag
	jne b_1				;not set,loop back
	mov timer_flag,0	;flag set, clear it 
	loop b_1				;repeat for next tick
;turn off tone
	mov al,ah			;return old control value to al
	out 61h,al
	pop cx
beep endp
end