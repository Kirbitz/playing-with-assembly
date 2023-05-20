.intel_syntax noprefix
.include "linux.s"
.include "record-def.s"

.global _start

.section .data
file_name:
  .asciz "test.dat"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.equ ST_INPUT_DESC, -8
.equ ST_OUTPUT_DESC, -16
_start:
  mov rbp, rsp
  sub rsp, 16

  mov rax, SYS_OPEN
  lea rdi, file_name
  mov rsi, 0
  mov rdx, 0666
  syscall

  mov [rbp+ST_INPUT_DESC], rax

  mov rax, STDOUT
  mov [rbp+ST_OUTPUT_DESC], rax 

record_read_loop:
  push [rbp+ST_INPUT_DESC]
  push offset record_buffer
  call read_record
  add rsp, 16

  cmp rax, RECORD_SIZE
  jne finished_reading

  push offset [RECORD_FIRSTNAME+1+record_buffer]
  call count_chars
  add rsp, 8

  mov rdx, rax
  mov rdi, [rbp+ST_OUTPUT_DESC]
  mov rax, SYS_WRITE
  lea rsi, [RECORD_FIRSTNAME+record_buffer]
  syscall

  push [rbp+ST_OUTPUT_DESC]
  call write_newline
  add rsp, 8

  jmp record_read_loop

finished_reading:
  mov rax, SYS_EXIT
  mov rdi, 0 
  syscall
