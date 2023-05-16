.section .text
.global _start
.intel_syntax noprefix

_start:
  push 10 
  call fib

  add rsp, 8

  mov rdi, rax
  mov rax, 60
  syscall

fib:
  push rbp
  mov rbp, rsp
  sub rsp, 8

  mov rax, [rbp+16]
  
  cmp rax, 1
  jle end_fib

  dec rax
  push rax
  call fib

  mov [rbp-8], rax 
  mov rax, [rbp+16] 
  sub rax, 2
  push rax
  call fib

  mov rcx, [rbp-8]
  add rax, rcx 


end_fib:
  mov rsp, rbp
  pop rbp
  ret
