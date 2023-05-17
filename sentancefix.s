.intel_syntax noprefix
.global _start

// Declase Const Values
.section .data
// Syscall numbers
.equ SYS_OPEN, 2
.equ SYS_READ, 0
.equ SYS_CLOSE, 3
.equ SYS_WRITE, 1
.equ SYS_EXIT, 60

// Read Values
.equ O_RDONLY, 0
.equ O_WRONLY_TRUNC, 01101

.equ END_OF_FILE, 0

.equ NUMBER_OF_ARGS, 2

.section .bss
.equ BUFFER_SIZE, 20
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

.equ ST_SIZE_RESERVE, 24
.equ ST_FD_IN, -8
.equ ST_FD_OUT, -16
.equ PERIOD_FLAG, -24
.equ ST_ARGC, 0
.equ ST_ARGV_0, 8
.equ ST_ARGV_1, 16 
.equ ST_ARGV_2, 24

_start:
  mov rbp, rsp
  sub rsp, ST_SIZE_RESERVE
  mov rbx, 0
  mov [rbp+PERIOD_FLAG], rbx 

open_files:
  open_fd_in:
    mov rax, SYS_OPEN
    mov rdi, [rbp+ST_ARGV_1]
    mov rsi, O_RDONLY
    mov rdx, 0666
    syscall

  store_fd_in:
    mov [rbp+ST_FD_IN], rax

  open_fd_out:
    mov rax, SYS_OPEN 
    mov rdi, [rbp+ST_ARGV_2]
    mov rsi, O_WRONLY_TRUNC
    mov rdx, 0666
    syscall

  store_fd_out:
    mov [rbp+ST_FD_OUT], rax 

read_data_in:
  mov rax, SYS_READ
  mov rdi, [rbp+ST_FD_IN]
  lea rsi, BUFFER_DATA
  mov rdx, BUFFER_SIZE
  syscall

  cmp rax, END_OF_FILE
  jle end_loop

continue_reading_data:
  push [rbp+PERIOD_FLAG]
  push rax
  call first_letter 

  pop rax
  add rsp, 8
  mov [rbp+PERIOD_FLAG], rbx
  
  mov rdx, rax 
  mov rdi, [rbp+ST_FD_OUT]
  lea rsi, BUFFER_DATA
  mov rax, SYS_WRITE
  syscall
  jmp read_data_in

end_loop:
  mov rax, SYS_CLOSE
  mov rdi, [rbp+ST_FD_IN]
  syscall

  mov rax, SYS_CLOSE
  mov rdi, [rbp+ST_FD_OUT]
  syscall

  mov rax, SYS_EXIT
  mov rdi, 1
  syscall


.equ VAR_1, 16
.equ VAR_2, 24 
.equ DOT, '.'
.equ LOWER_A, 'a'
.equ LOWER_Z, 'z'
.equ CONVERSION, 'A' - 'a'

first_letter:
  push rbp
  mov rbp, rsp 

  mov rax, [rbp+VAR_1]
  mov rbx, [rbp+VAR_2]
  mov rdi, 0


run_calc:
  mov cl, [BUFFER_DATA+rdi]

  cmp cl, DOT
  je flip_flag
  cmp rbx, 1
  je next_byte
  cmp cl, LOWER_A
  jl next_byte
  cmp cl, LOWER_Z 
  jg next_byte

  add cl, CONVERSION
  mov [BUFFER_DATA+rdi], cl
  mov rbx, 1
  jmp next_byte

flip_flag:
  mov rbx, 0
  
next_byte:
  inc rdi
  cmp rdi, rax
  jne run_calc

first_letter_end_loop:
  mov rsp, rbp
  pop rbp
  ret
