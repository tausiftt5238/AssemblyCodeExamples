public convert
.model small
.data
msg db 0dh,0ah,'in uppercase it is$'
char db -20h,'$'
.code

convert proc near
	push bx
	push dx
	add char,al
	mov ah,9h
	lea dx,msg
	int 21h
	lea dx,char
	int 21h
	pop dx
	pop bx
	ret
convert endp
	end