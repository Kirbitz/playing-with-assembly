.section .text
.global _start
.intel_syntax noprefix

_start:
  mov rbx, 0 
  mov eax, [0+rbx*4+data_items]
  mov rdi, rax
  cmp rax, 0
  je loop_exit

start_loop:
  inc rbx
  mov eax, [0+rbx*4+data_items]
  cmp rax, 0
  je loop_exit
  cmp rax, rdi 
  jle start_loop
  mov rdi, rax
  jmp start_loop

loop_exit:
  mov rax, 60
  syscall

.section .data
data_items:
  .long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0
