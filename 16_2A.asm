public set_display_mode, display_ball
.model small

draw_row macro x
	local l1
;draws a line in row X from column 10 to column 300
	mov ah,0ch	;draw pixel
	mov al,1	;cyan
	mov cx,10	;column 10
	mov dx,x	;row x
l1:
	int 10h
	inc cx		;next column
	cmp cx,301	;byeond column 300?
	jl l1		;if no, repeat
	endm

draw_column macro y
	local l2
;draws a line in column y from row 10 to row 189
	mov ah,0ch	;draw pixel
	mov al,1	;cyan
	mov cx,y	;column y
	mov dx,10	;row 10
l2:
	int 10h
	inc dx		;next row
	cmp dx,190	;beyond row 189?
	jl l2		;if no, repeat
	endm

.code
set_display_mode proc
	mov ah,0	;set mode
	mov al,04h	;mode 4, 320 x 200 4 color
	int 10h
	mov ah,0bh	;select palate
	mov bh,1	;sub-function	
	mov bl,1	;palette 1
	int 10h
	mov bh,0	;set background color
	mov bl,2	;green
	int 10h
;draw boundary
	draw_row 10
	draw_row 189
	draw_column 10
	draw_column 300
	ret
set_display_mode endp

display_ball proc
;displays ball at column cx and row dx with color given in al
;input : AL = color of ball, cx = column , dx = row

	mov ah,0ch	;write pixel
	int 10h
	inc cx		;pixel on next column
	int 10h
	inc dx		;down 1 row
	int 10h
	dec cx		;previous column
	int 10h
	dec dx		;restore dx
	ret
display_ball endp
end