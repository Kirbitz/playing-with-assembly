.intel_syntax noprefix
.global _start

_start:
  mov rax, 1
  mov rdi, 1
  lea rsi, hello_world 
  lea rdx, [hello_world_end-hello_world] 
  syscall

  mov rax, 60
  mov rdi, 0
  syscall

hello_world:
  .asciz "Hello World!\n"
hello_world_end:
