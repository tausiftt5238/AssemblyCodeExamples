;program that displays the current time

extern get_time:near
.model small
.stack 100h
.data
time_buf db '00:00:00$' ;time buffer hr:min:sec

.code

main proc
	mov ax,@data
	mov ds,ax	;init DS
;get and display time
	LEA bx,time_buf	;bx points to time_buf
	call get_time	;put current time in time_buf
	lea dx,time_buf	;dx points to time_buf
	mov ah,09h	;display time
	int 21h
;exit
	mov ah,4ch
	int 21h
main endp
	end main