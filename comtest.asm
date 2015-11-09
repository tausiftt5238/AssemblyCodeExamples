.model small
.code
	org 100h
start:
	jmp main
	msg db 'Hello$'
Main proc
	lea dx,msg
	mov ah,09h
	int 21h
	
	mov ah,4ch
	int 21h
main endp
	end start