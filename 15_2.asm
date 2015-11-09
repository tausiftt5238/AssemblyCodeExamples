;program that displays the current time
;pushes update the time 18.2 times a second
extern get_time:near,setup_int:near
.model small
.stack 100h
.data
time_buf db '00:00:00$'	;time buffer hr:min:sec
cursor_pos dw ? 	;cursor position (row:col)
new_vec dw ?,?		;new interrupt vector
old_vec dw ?,?		;old interrupt vector
msg db 'i am here$'

testing macro 
	push dx
	push ax
	lea dx,msg
	mov ah,09h
	int 21h
	pop ax
	pop dx
endm

.code
main proc
	mov ax,@data
	mov ds,ax
	;testing
;save cursor position
	mov ah,3 	;function 3, get cursor
	mov bh,0	;page 0
	int 10h		;dh = row, dl = col
	mov cursor_pos,dx	;save it
;set up interrupt-procedure by
;placing segment:offset of TIME_INT in new_vec
	mov new_vec,offset time_int	;offset
	mov new_vec+2,seg time_int	;segment
	lea di,old_vec			;di points to vector buffer
	lea si,new_vec			;si points to new vector
	mov al,1ch			;setup new vector
	call setup_int
;read keyboard
	mov ah,0
	int 16h
;restore old interrupt vector
	lea di,new_vec			;di points to vector buffer
	lea si,old_vec			;si points to old vector
	
	mov al,1ch			;timer interrupt
	call setup_int			;restore old vector

	mov ah,4ch
	int 21h
main endp

time_int proc
;testing
;interrupt procedure
;activated by the timer
	push ds		;save current ds
	mov ax,@data	;set it to data segment
	mov ds,ax
;get new time
	lea bx,time_buf 		;bx points to time buffer
	call get_time
;display time
	lea dx,time_buf			;dx points to time_buf
	mov ah,09h		;display string
	int 21h
;restore cursor position
	mov ah,2		;function 2, move cursor
	mov bh,0		;page 0
	mov dx,cursor_pos	;cursor position , dh = row , dl = col
	int 10h	
	pop ds
	iret
time_int endp
	end main
