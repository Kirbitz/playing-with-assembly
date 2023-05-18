.intel_syntax noprefix
.global _start

.section .data
star:
  .asciz "*"

space:
  .asciz " "

new_line:
  .asciz "\n"

prompt:
  .asciz "Enter a number [0] to exit: "

failure_msg:
  .asciz "Failure Occured!\n"

// Standard in and out FDs
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2 
// Syscalls
.equ SYS_EXIT, 60
.equ SYS_READ, 0 
.equ SYS_WRITE, 1
.equ ST_RESERVE, 8

.section .bss
.equ BUFFER_SIZE, 3
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
_start:
  mov rax, SYS_WRITE 
  mov rdi, STDOUT
  mov rsi, prompt 
  mov rdx, 28
  syscall

  // failure check
  cmp rax, 0
  jl failure

  mov rax, SYS_READ
  mov rdi, STDIN 
  lea rsi, BUFFER_DATA
  mov rdx, BUFFER_SIZE
  syscall

  push rax
  call get_num
  add rsp, 8

  // failure check
  cmp rax, 0
  jl failure

  cmp rbx, 0
  jle end_prog

  xor r8, r8

outer_loop:
  mov r9, rbx
  sub r9, r8
  sub r9, 1

  cmp r9, 0
  jl _start
  je skip_space
  space_loop:
    mov rax, SYS_WRITE 
    mov rdi, STDOUT
    lea rsi, space
    mov rdx, 1
    syscall

    // jump to failure block if result is a fail code
    cmp rax, 0
    jl failure

    dec r9

    cmp r9, 0
    jg space_loop

skip_space:
  mov r9, r8
  imul r9, 2
  add r9, 1
  star_loop:
    mov rax, SYS_WRITE 
    mov rdi, STDOUT
    lea rsi, star 
    mov rdx, 1
    syscall
 
    // jump to failure block if result is a fail code
    cmp rax, 0
    jl failure

    dec r9 

    cmp r9, 0
    jg star_loop 
 
  mov rax, SYS_WRITE 
  mov rdi, STDOUT
  lea rsi, new_line 
  mov rdx, 1
  syscall

  // jump to failure block if result is a fail code
  cmp rax, 0
  jl failure

  inc r8
  jmp outer_loop

end_prog:
  mov rax, SYS_EXIT
  mov rdi, 0
  syscall

failure:
  imul rax, -1
  mov rbx, rax

  mov rax, SYS_WRITE 
  mov rdi, STDERR 
  lea rsi, failure_msg
  mov rdx, 17
  syscall

  mov rax, SYS_EXIT
  mov rdi, rbx
  syscall


.equ ZERO, '0'
.equ NINE, '9'
.equ NL, '\n'
get_num:
  push rbp
  mov rbp, rsp

  mov rax, [rbp+16]
  mov rbx, 0
  mov rdi, 0

iter_string:
  mov cl, [BUFFER_DATA+rdi]
  
  cmp cl, NL
  je end_loop
  cmp cl, ZERO
  jl next_byte
  cmp cl, NINE
  jg next_byte

  imul rbx, 10
  sub cl, ZERO
  movzx r12, cl
  add rbx, r12 

next_byte:
  inc rdi
  cmp rdi, rax
  jne iter_string

end_loop:
  mov rsp, rbp
  pop rbp
  ret
