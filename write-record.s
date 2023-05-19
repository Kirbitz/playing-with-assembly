.intel_syntax noprefix
.include "linux.s"
.include "record-def.s"

.equ ST_WRITE_BUF, 16
.equ ST_FILEDES, 24

.global write_record
.type write_record, @function

write_record:
  push rbp
  mov rbp, rsp

  push rdi 

  mov rax, SYS_WRITE
  mov rdi, [rbp+ST_FILEDES] 
  mov rsi, [rbp+ST_WRITE_BUF]
  mov rdx, RECORD_SIZE 
  syscall

  pop rdi 

  mov rsp, rbp
  pop rbp
  ret
