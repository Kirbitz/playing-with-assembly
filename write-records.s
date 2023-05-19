.intel_syntax noprefix
.include "linux.s"
.include "record-def.s"

.section .data
record1:
  .asciz "Fredrick"
  .rept 32
  .byte 0
  .endr

  .asciz "Barlett"
  .rept 32
  .byte 0
  .endr

  .asciz "4242 S Prairie\nTulsa, OK 55555"
  .rept 210 
  .byte 0
  .endr

  .long 45

record2:
  .asciz "Marilyn"
  .rept 33
  .byte 0
  .endr

  .asciz "Taylor"
  .rept 34
  .byte 0
  .endr

  .asciz "2224 S Johannan St\nChicago, IL 12345"
  .rept 204 
  .byte 0
  .endr

  .long 29 

record3:
  .asciz "Derrick"
  .rept 33
  .byte 0
  .endr

  .asciz "McIntire"
  .rept 32
  .byte 0
  .endr

  .asciz "500 W Oakland\nSan Diego, CA 54321"
  .rept 207 
  .byte 0
  .endr

  .long 36 

filename:
  .asciz "test.dat"

.equ ST_FILE_DESCRIPTOR, -8

.global _start

.section .text
_start:
  mov rbp, rsp
  sub rsp, 8

  mov rax, SYS_OPEN
  lea rdi, filename
  mov rsi, 01101
  mov rdx, 0666
  syscall

  mov [rbp+ST_FILE_DESCRIPTOR], rax

  push [rbp+ST_FILE_DESCRIPTOR]
  push offset record1 
  call write_record
  add rsp, 16

  push [rbp+ST_FILE_DESCRIPTOR]
  push offset record2 
  call write_record
  add rsp, 16

  push [rbp+ST_FILE_DESCRIPTOR]
  push offset record3 
  call write_record
  add rsp, 16

  mov rax, SYS_CLOSE
  mov rdi, [rbp+ST_FILE_DESCRIPTOR]
  syscall

  mov rax, SYS_EXIT
  mov rdi, 0
  syscall
