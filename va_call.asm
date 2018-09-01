global va_call


;
; Read Only data section of an .exe file.
;
section .data
    backup      dd (-1)             ; Used to store the return address


;
; Read & Execute section of an .exe file.
;
section .text
    text_virt   dd ADDRESS          ; Virtual address of the .text section
    text_phys   dd $$               ; Physical address of the .text section


;
; va_call
;   Calls the function whoms virtual address was passed
;   as the first argument. The arguments after that are
;   passed on to the callee.
;
va_call:

    ; Keep a backup of the original stack
    lea     ecx,[esp]               ; Get the address of the stack
    mov     edx,dword [ecx]         ; Grab the return address
    mov     dword [backup],edx      ; Store the return address

    ; Convert the virtual address to physical address
    mov     eax,dword [esp+4]       ; Virtual address of function to call
    sub     eax,dword [text_virt]   ; Offset from the start of the section
    add     eax,dword [text_phys]   ; Add the physical starting address of the .text section

    ; Realign the stack so that arg#1 becomes arg#0 for the callee
    add     esp,8                   ; Realign to the second parameter before the call
    call    eax                     ; Call the function
    sub     esp,8                   ; Restore the stack to the original alignment

    ; Restore the original stack from backup
    lea     ecx,[esp]               ; Get the address of the stack
    mov     edx,dword [backup]      ; Grab the original return address
    mov     dword [ecx],edx         ; Restore the original return address

    ; Return to the original caller
    ret
