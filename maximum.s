.section .text
.global _start
.intel_syntax noprefix

_start:
  mov rbx, 0 
  mov eax, [0+rbx*4+data_items]
  mov rdi, rax

start_loop:
  cmp rax, 0
  je loop_exit
  inc rbx
  mov eax, [0+rbx*4+data_items]
  cmp rax, rdi 
  jle start_loop
  mov rdi, rax
  jmp start_loop

loop_exit:
  mov rax, 60
  syscall

.section .data
data_items:
  .long 10, 32, 75, 69, 49, 250, 43, 21, 4, 50, 0
