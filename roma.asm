.model small
.stack 100h
.data
m_greeting	db 'Greetings', 0dh, 0ah, '$'
m_prompt	db 'Enter the number', 0dh, 0ah, '$'
m_error		db 'Invalid number', 0dh, 0ah, '$'
m_result	db 'Result ', '$'
m_quit		db 'Quitting', 0dh, 0ah, '$'
m_crlf		db 0dh, 0ah, '$'


rbuffer label 
rbuffer_limit	db 4
rbuffer_length	db 0
rbuffer_data 	db 5 dup (?)

 .code                     

print proc near
	mov	ax, 0900h
	int	21h

	ret
print endp


start:   
	mov	ax, @data
	mov	ds, ax

	mov dx, offset m_greeting
	call print

main:
	mov dx, offset m_prompt
	call print

	mov ax, 0a00h
	mov	dx, offset rbuffer
	int 21h

	mov dx, offset m_crlf
	call print

	cmp word ptr [rbuffer_length], 3001h
	je  exit

	xor cx, cx
	mov bx, 1

	xor ah, ah
	mov al, [rbuffer_length]
	mov si, ax
	mov di, 0ah

dec2bin:
	xor ah, ah
	mov	al, [rbuffer_data + si - 1]
	sub al, '0'
	jb	error

	cmp al, '9'
	jg	error

	mul bx
	add cx, ax
	
	mov ax, bx
	mul di
	mov bx, ax

	dec si
	jnz dec2bin	

	mov dx, offset m_result
	call print

	mov dx, offset m_crlf
	call print

	loop main

error:
	mov	dx, offset m_error
	call print

	loop main

exit:         
	mov	ax, 04C00h
	int	21h
	
    end start