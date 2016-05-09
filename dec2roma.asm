.model small
.stack 100h
.data
m_greeting	db 'Greetings', 0dh, 0ah, '$'
m_prompt	db 'Enter the number', 0dh, 0ah, '$'
m_error		db 'Invalid number', 0dh, 0ah, '$'
m_result	db 'Result ', '$'
m_quit		db 'Quitting', 0dh, 0ah, '$'
m_crlf		db 0dh, 0ah, '$'


ibuffer label 
ibuffer_limit	db 4
ibuffer_length	db 0
ibuffer_data 	db 5 dup (?)

obuffer_data	db 20 dup (?)

 .code                     

print proc near
	mov ax, 0900h
	int 21h

	ret
print endp


x_digit proc
	mov ax, dx
	xor dx, dx	
	div bx

	xchg ax, cx
	rep stosb

	ret
x_digit endp


x_digit2 proc
	mov ax, dx
	xor dx, dx	
	div bx

	xchg ax, cx
	rep stosw

	ret
x_digit2 endp


start:   
	mov ax, @data
	mov ds, ax
	mov es, ax

	mov dx, offset m_greeting
	call print

main:
	mov dx, offset m_prompt
	call print

	mov ax, 0a00h
	mov dx, offset ibuffer
	int 21h

	mov dx, offset m_crlf
	call print

	cmp word ptr [ibuffer_length], 3001h
	jne process
	jmp exit

process:
	xor cx, cx
	mov bx, 1

	xor ah, ah
	mov al, [ibuffer_length]
	mov si, ax
	mov di, 0ah

dec2bin:
	xor ah, ah
	mov	al, [ibuffer_data + si - 1]
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
	jmp bin2roman

error:
	mov	dx, offset m_error
	call print

	jmp main

bin2roman:
	lea di, [obuffer_data]

M:
	mov dx, cx
	mov bx, 1000
	mov cx, 'M'
	call x_digit

CM:
	mov bx, 900
	mov cx, 'MC'
	call x_digit2

D:
	mov bx, 500
	mov cx, 'D'
	call x_digit

CD:
	mov bx, 400
	mov cx, 'DC'
	call x_digit2

C:
	mov bx, 100
	mov cx, 'C'
	call x_digit

XC:
	mov bx, 90
	mov cx, 'CX'
	call x_digit2

L:
	mov bx, 50
	mov cx, 'L'
	call x_digit

XL:
	mov bx, 40
	mov cx, 'LX'
	call x_digit2

X:
	mov bx, 10
	mov cx, 'X'
	call x_digit

IX:
	mov bx, 9
	mov cx, 'XI'
	call x_digit2

V:
	mov bx, 5
	mov cx, 'V'
	call x_digit

IV:
	mov bx, 4
	mov cx, 'VI'
	call x_digit2

I:
	mov bx, 1
	mov cx, 'I'
	call x_digit

	mov al, '$'
	stosb

	mov dx, offset m_result
	call print

	mov dx, offset m_crlf
	call print

	mov dx, offset obuffer_data
	call print

	mov dx, offset m_crlf
	call print	

	jmp main

exit:         
	mov	ax, 04C00h
	int	21h
	
    end start