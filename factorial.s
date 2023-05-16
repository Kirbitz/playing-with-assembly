.section .text
.global _start
.intel_syntax noprefix

_start:
  push 5 
  call factorial

  add rsp, 8

  mov rdi, rax
  mov rax, 60
  syscall


factorial:
  push rbp
  mov rbp, rsp

  mov rax, [rbp+16]

  cmp rax, 1
  je end_factorial
  dec rax
  push rax
  call factorial
  mov rbx, [rbp+16]
  imul rax, rbx

end_factorial:
  mov rsp, rbp
  pop rbp
  ret

// Iterative solution
factorial_loop:
  cmp rbx, 1
  je end_factorial
  dec rbx
  mov rax, [rbp-8]
  imul rax, rbx
  mov [rbp-8], rax
  jmp factorial_loop
