extern convert:near
.model small
.stack 100h
.data
msg db 'Enter a lowercase letter: $'
.code
main proc
mov ax,@data
mov ds,ax
mov ah,9h
	lea dx,msg
	int 21h
	mov ah,1h
	int 21h
	call convert
	mov ah,4ch
	int 21h
main endp
	end main