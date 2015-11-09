;contains move_ball and check_boundary procedures
	extern display_ball:near
	extern timer_flag:byte,vel_x:word,vel_y:word
	public move_ball
.model small
.code
move_ball proc
;erase ball at current position and display ball at new position
;input: cx = column of ball position
;	dx = row of ball position
;erase ball
	mov al,0	;color 0 is bgm color
	call display_ball	;erase ball
;get new position
	add cx,vel_x
	add dx,vel_y
;check boundary
	call check_boundary
;wait for 1 timer tick to display ball
test_timer:
	cmp timer_flag,1	;timer ticked?
	jne test_timer		;no, keep testing
	mov timer_flag,0	;yes, reset flag
	mov al,3		;white color
	call display_ball	;show ball
	ret	
move_ball endp
;

check_boundary		proc

;determine if ball is outside screen, if so move it
;back in and change the ball direction
;input : cx = column of ball position
;	dx = row of ball position
;output : cx = column of ball position
;	dx = row of ball position
;check column value
	cmp cx,11	;left of 11?
	jg l1		;no, go check right margin
	mov cx,11	;yes , set to 11
	neg vel_x	;change direction
	jmp l2		;go test row boundary
l1:	cmp cx,298	;beyond right margin?
	jl l2		;no, go test row boundary
	mov cx,29	;set column to 298
	neg vel_x	;change direction
;check row value
l2:	cmp dx,11	;above top margin?
	jg l3		;no, check bottom margin
	mov dx,11	;set to 11
	neg vel_y	;change direction
	jmp done	;done
l3:	cmp dx,187	;below bottom margin?
	jl done		;no,done
	mov dx,187	;yes,set to 187
	neg vel_y	;change direction
done:
	ret
check_boundary	endp
	end
