.intel_syntax noprefix
.type count_chars, @function

.global count_chars

.equ ST_STRING_START_ADDRESS, 16 

count_chars:
  push rbp
  mov rbp, rsp

  mov rcx, 0
  mov rdx, [rbp+ST_STRING_START_ADDRESS]

count_loop_begin:
  mov al, [rdx]
  
  cmp al, 0
  je count_loop_end

  inc rcx
  inc rdx

  jmp count_loop_begin

count_loop_end:
  mov rax, rcx
  mov rsp, rbp
  pop rbp
  ret
