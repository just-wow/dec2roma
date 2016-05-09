 .model small
 .stack 100h
 .data
 message	db "Hello World!", 0Dh, 0Ah, '$' ; Строка для вывода

cr_lf		db 0dh,0ah, '$'

read_buffer label byte
read_buffer_limit	db 4
read_buffer_length	db 0
read_buffer_data 	db 5 dup ('$')

 .code                     ; Начало сегмента кода

print proc near
	push ax
	push dx

	mov	ax, 0900h
	mov dx, bx
	int	21h

	pop dx
	pop ax

	ret
print endp

read proc near
	push ax
	push dx

	mov ax, 0a00h
	mov	dx, bx
	int 21h

	pop	dx
	pop ax

	ret
read endp

start:   
	mov	ax, @data
	mov	ds, ax

	mov bx, offset read_buffer
	call read

	mov bx, offset cr_lf
	call print

	mov bx, offset read_buffer_data
	call print
         
	mov	ax, 04C00h
	int	21h
	
    end start