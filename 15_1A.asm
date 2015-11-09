public get_time
.model small
.code
get_time 	proc
;get time of day and store ASCII digits in time buffer
;input: BX = address of time buffer
	mov ah,2ch	;gettime
	int 21h		;ch = hr, cl = min, dh = sec
;convert hours into ASCII and store
	mov al,ch	;hour
	call convert	;convert to ascii
	mov [bx],ax	;store
;convert mins to ASCII and store
	mov al,cl	;min
	call convert	;convert to ascii
	mov [bx+3],ax	;store
;convert seconds into ASCII and store
	mov al,dh	;sec
	call convert	;convert to ascii
	mov [bx+6],ax	;store
	RET
get_time endp
;
convert proc

;converts byte number (0-59) into ASCII digits
;input : AL = number
;output : AX = ASCII digits , AL = high digit, AH = low digit

	mov ah,0	;clear ah
	mov dl,10	;divide ax by 10
	div dl		;ah has remainder, al has quotient
	or ax,3030h	;convert to ascii, ah has low digit, al has high digit
	ret 		
convert endp
	end