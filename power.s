.section .text
.global _start
.intel_syntax noprefix

_start:
  push 3
  push 2
  call power
  add rsp, 16 

  push rax

  push 2
  push 5
  call power
  add rsp, 16 

  push rax

  push 4
  push 2
  call power
  add rsp, 16 
  
  push rax

  push 30
  push 0 
  call power
  add rsp, 16 

  pop rbx 
  pop rcx
  pop rdx

  add rax, rbx 
  add rax, rcx 
  add rax, rdx 
  
  mov rdi, rax 
  mov rax, 60
  syscall


power:
  push rbp
  mov rbp, rsp
  sub rsp, 8 

  mov rbx, [rbp+16]
  mov rcx, [rbp+24]

  cmp rbx, 0
  je zero_base

  mov [rsp], rbx

power_loop_start:
  cmp rcx, 1
  je end_power
  mov rax, [rsp]
  imul rax, rbx
  mov [rsp], rax
  dec rcx
  jmp power_loop_start

zero_base:
  inc rbx
  mov [rsp], rbx

end_power:
  mov rax, [rsp]
  mov rsp, rbp
  pop rbp
  ret
