.intel_syntax noprefix
.global _start

// Declare Const Values
.section .data
// Syscall numbers
.equ SYS_OPEN, 2
.equ SYS_CLOSE, 3
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_EXIT, 60

// Read Value
.equ O_RDONLY, 0
.equ O_WRONLY_TRUNC, 01101

// Standard File Descriptors
.equ STDIN, 0
.equ STDOUT, 1 
.equ STDERR, 2 

.equ END_OF_FILE, 0

.equ NUMBER_OF_ARGS, 2

// Declare Buffer Data
.section .bss
.equ BUFFER_SIZE, 500 
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

// Stack Positions
.equ ST_SIZE_RESERVE, 16
.equ ST_FD_IN, -8
.equ ST_FD_OUT, -16
.equ ST_ARGC, 0
.equ ST_ARGV_0, 8
.equ ST_ARGV_1, 16 
.equ ST_ARGV_2, 24 

_start:
  mov rbp, rsp
  sub rsp, ST_SIZE_RESERVE 

open_files:
  open_fd_in:
    mov rax, SYS_OPEN
    mov rdi, [rbp+ST_ARGV_1]
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

  store_fd_in:
    mov [rbp+ST_FD_IN], rax

  open_fd_out:
    mov rax, SYS_OPEN
    mov rdi, [rbp+ST_ARGV_2]
    mov rsi, O_WRONLY_TRUNC
    mov rdx, 00666
    syscall

  store_fd_out:
    mov [rbp+ST_FD_OUT], rax

read_loop_begin:
  mov rax, SYS_READ
  mov rdi, [rbp+ST_FD_IN]
  lea rsi, [BUFFER_DATA]
  mov rdx, BUFFER_SIZE
  syscall

  cmp rax, END_OF_FILE
  jle end_loop

continue_read_loop:
  push [BUFFER_DATA]
  push rax
  call convert_to_upper

  pop rax
  add rsp, 8

  mov rdx, rax
  mov rdi, [rbp+ST_FD_OUT]
  lea rsi, [BUFFER_DATA]
  mov rax, SYS_WRITE
  syscall
  jmp read_loop_begin

end_loop:
  mov rax, SYS_CLOSE
  mov rdi, [rbp+ST_FD_OUT]
  syscall

  mov rax, SYS_CLOSE
  mov rdi, [rbp+ST_FD_IN]
  syscall

  mov rdi, 1 
  mov rax, SYS_EXIT
  syscall

.equ LOWER_A, 'a'
.equ LOWER_Z, 'z'
.equ CONVERSION_FACTOR, 'A' - 'a'

.equ ST_BUFFER_LEN, 16
.equ ST_BUFFER, 24

convert_to_upper:
  push rbp
  mov rbp, rsp

  mov rbx, [rbp+ST_BUFFER_LEN]
  mov rdi, 0

  cmp rbx, 0
  je end_convert_loop

convert_loop:
  mov cl, [BUFFER_DATA+rdi]
  
  cmp cl, LOWER_A
  jl next_byte
  cmp cl, LOWER_Z
  jg next_byte

  add cl, CONVERSION_FACTOR
  mov [BUFFER_DATA+rdi], cl

next_byte:
  inc rdi
  cmp rdi, rbx
  jne convert_loop

end_convert_loop:
  mov rsp, rbp
  pop rbp
  ret
