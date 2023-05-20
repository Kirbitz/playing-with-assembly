.intel_syntax noprefix
.include "linux.s"
.include "record-def.s"

.equ ST_READ_BUF, 16
.equ ST_FILEDES, 24

.global read_record
.type read_record, @function

read_record:
  push rbp
  mov rbp, rsp

  push rdi 

  mov rax, SYS_READ
  mov rdi, [rbp+ST_FILEDES] 
  mov rsi, [rbp+ST_READ_BUF]
  mov rdx, RECORD_SIZE 
  syscall

  pop rdi 

  mov rsp, rbp
  pop rbp
  ret
