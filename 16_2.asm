extern set_display_mode:near, display_ball:near
extern move_ball:near
extern setup_int:near, timer_tick:near
public timer_flag,vel_x,vel_y

.model small
.stack 100h

.data
new_timer_vec dw ?,?
old_timer_vec dw ?,?
timer_flag db 0
vel_x dw -6
vel_y dw -1

.code
main proc
	mov ax,@data
	mov ds,ax

;set graphics mode and draw border
	call set_display_mode
;set up timer interrupt vector
	mov new_timer_vec, offset timer_tick
	mov new_timer_vec + 2, cs	;segment
	mov al,1ch
	lea di,old_timer_vec ;di points to vector buffer
	lea si,new_timer_vec	;si points to new vector
	call setup_int
;start ball at column = 298 , row = 100
;for the rest of the program cx will be column position
;for ball and dx will be row position
	mov cx,298
	mov dx,100
	mov al,3	;white ball
	call display_ball
;wait for timer tick before moving the ball
test_timer:
	cmp timer_flag,1	;timer ticked?
	jne test_timer		;no, keep testing
	mov timer_flag,0	;yes,clear flag
	call move_ball	;move to new psoition
;delay 1 timer tick
test_timer_2:
	cmp timer_flag , 1 	;timer ticked?
	jne test_timer_2	;no, keep testing
	mov timer_flag, 0	;yes , clear flag
	jmp test_timer		;go get next ball position
main endp
	end main