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
rbuffer_data 	db 5 dup ('$')

 .code                     ; Начало сегмента кода

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

	mov dx, offset m_result
	call print

	mov dx, offset m_crlf
	call print

	loop main

exit:         
	mov	ax, 04C00h
	int	21h
	
    end start