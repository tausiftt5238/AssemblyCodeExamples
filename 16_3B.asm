;contains move_ball_a and check_boundary_a
extern display_ball:near , beep:near
extern timer_flag:byte,vel_x:word,vel_y:word
public move_ball_a
.model small
.code
move_ball_A proc
;erase ball at current position and display ball at new position
;input: cx = column
;		dx = row
;output: cx = column
;		dx = row
	mov al,0	;color 0 is background color
	call display_ball ;erase ball
;get new position
	add cx,vel_x
	add dx,vel_y
;check boundary
	call check_boundary_a
;wait for 1 timer tick
test_timer_1:
	cmp timer_flag,1	;timer ticked?
	jne test_timer_1	;no, keep testing
	mov timer_flag,0	;yes, clarify
	mov al,3			;white color
	call display_ball	;show ball
	ret
move_ball_a endp
;
check_boundary_a proc
;determine if ball is outside screen, if so move it
;back in and change the ball direction
;input : cx = column, dx = row
;output: cx = column,dx = row
;check column value
	cmp cx,11		;left of 11?
	jg l1			;no go check right margin
	mov cx,11		;yes, set to 11
	neg vel_x		;change direction
	call beep		;sound beep
	jmp l2			;go test row boundary
l1:
	cmp cx,299		;beyond right margin?
	jl l2			;no, go test row boundary
	mov cx,298		;set column to 298
	neg vel_x		;change direction
	call beep		;sound beep
;check row value
l2:
	cmp dx,11		;above top margin?
	jg l3			;no,check bottom margin
	mov dx,11		;set to 11
	neg vel_y		;change direction
	call beep
	jmp done
l3:
	cmp dx,188	;below bottom margin?
	jl done		;no,done
	mov dx,187	;yes, set to 187
	neg vel_y	;change direction
	call beep	;sound beep
done:
	ret
	check_boundary_a	endp
	end