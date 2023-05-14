.section .text
.global _start
.intel_syntax noprefix

_start:
  // sys_write
  mov rax, 1
  mov rdi, 1
  lea rsi, [hello_world]
  mov rdx, 14
  syscall

  mov rax, 1
  mov rdi, 1
  lea rsi, [hello_2]
  mov rdx, 5 
  syscall

  // sys_exit
  mov rax, 60
  mov rdi, 1 
  syscall

.section .data
hello_world:
  .asciz "Hello, World!\n"

hello_2:
  .asciz "Test\n"
