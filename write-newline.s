.intel_syntax noprefix
.include "linux.s"

.global write_newline

.type write_newline, @function

.section .data
newline:
  .asciz "\n"

.section .text
.equ ST_FILEDES, 16

write_newline:
  push rbp
  mov rbp, rsp

  mov rax, SYS_WRITE
  mov rdi, [rbp+ST_FILEDES]
  lea rsi, newline
  mov rdx, 1
  syscall

  mov rsp, rbp
  pop rbp
  ret 
