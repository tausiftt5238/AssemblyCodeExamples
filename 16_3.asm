extern set_display_mode: near, display_ball:near
extern move_ball_a : near, draw_paddle : near
extern move_paddle : near
extern keyboard_int : near, timer_tick : near
extern setup_int:near , keyboard_int : near
public timer_flag , key_flag, scan_code
public paddle_top, paddle_bottom, vel_x, vel_y

.model small
.stack
.data

new_timer_vec dw ? , ?
old_timer_vec dw ? , ?
new_key_vec	dw ? , ?
old_key_vec dw ? , ?
scan_code	db 0
key_flag db 0
timer_flag db 0
paddle_top dw 45
paddle_bottom dw 54
vel_x	dw -6
vel_y 	dw -1
;scan codes
up_arrow = 72
down_arrow = 80
esc_key = 1

.code
main proc
	mov ax,@data
	mov ds,ax		;init ds

;set graphics mode
	call set_display_mode
;draw paddle
	mov al,2		;display red paddle
	call draw_paddle
;set up timer interrupt vector
	mov new_timer_vec, offset timer_tick	;offset
	mov new_timer_vec+2,cs					;segment
	mov al,1ch								;interrupt number
	lea di, old_timer_vec
	lea si, new_timer_vec
	call setup_int

;set up keyboard interrupt vector
	mov new_key_vec, offset keyboard_int		;offset
	mov new_key_vec+2, cs						;segment
	mov al,9h									;interrupt number
	lea di, old_key_vec
	lea si, new_key_vec
	call setup_int
;start ball at column = 298, row = 100
	
	mov cx,298	;column
	mov dx,100	;row
	mov al,3	;white
	call display_ball
;check key flag
TEST_KEY:
	cmp key_flag, 1 		;check key flag
	jne test_timer			;not set, go check timer flag
	mov key_flag , 0		;flag set, clear it chec scan code
	cmp scan_code,esc_key	;esc key?
	jne tk_1				;no, check arrow keys
	jmp done				;esc, terminate
	
tk_1:
	cmp scan_code, up_arrow		;up arrow?
	jne tk_2					;no, check down arrow
	mov ax,-2	;yes, move up 2 pixels
	call move_paddle
	jmp test_timer	;go check timer flag
tk_2:
	cmp scan_code, down_arrow	;down arrow?
	jne test_timer		;no check timer flag
	mov ax,2		;yes, move down 2 pixels
	call move_paddle

;check timer flag
test_timer:
	cmp timer_flag,1	;flag set?
	jne test_key		;no, check key flag
	mov timer_flag,0	;yes , clear it
	call move_ball_a	;move ball to new position

;check if paddle missed ball
	cmp cx,11		;at column 11?
	jne test_key	;no, check key flag
	cmp dx,paddle_top	;yes check paddle
	jl cp_1			;missed ball above
	cmp dx,paddle_bottom
	jg cp_1			;missed ball below
	
;paddle hit the ball , delay one tick then
;move the ball and redraw paddle

delay:
	cmp timer_flag,1	;timer ticked?
	jne delay			;no keep checking
	mov timer_flag,0	;yes reset flag
	call move_ball_a
	mov al,2			;color red
	call draw_paddle
	jmp test_key		;check key flag

;paddle missed the ball , erase the ball and terminate
cp_1:
	mov al,0		;erase ball
	call display_ball
	
;reset timer interrupt vector
done:
	lea di,new_timer_vec
	lea si, old_timer_vec
	mov al,1ch
	call setup_int
;reset keyboard interrupt vector
	lea di, new_key_vec
	lea si,old_key_vec
	mov al,9h
	
	call setup_int

;read key
	mov ah,0
	int 16h

;reset to text mode
	mov ah,0
	mov al,3
	int 10h
;return to DOS
	mov ah,4ch
	int 21h

main endp
	end main