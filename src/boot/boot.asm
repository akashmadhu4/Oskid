ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code-gdt_start
DATA_SEG equ gdt_data-gdt_start

_start: ; for bios paramter block
    jmp short start
    nop


times 33 db 0  ;putting 0 values for other bios paramter block , doing this ensure the bios won't corrput with garbage

start:
    jmp 0:start2  ;Setting the code segment register to 0


start2:
    cli ;clear interrupts
    mov ax,0x00
    mov ds,ax
    mov es,ax
    ;setting stack segment
    mov ss, ax
    mov sp,0x7c00

    sti ; enable interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax,cr0
    or eax,0x1
    mov cr0,eax
    jmp CODE_SEG:load32

;GDT table, here we mention the memory protection rules for selectors like CS,SS,DS etc
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0
;offset 0x8
gdt_code:   ;CS SHOULD POINT TO THIS, THIS IS HOW WE SETUP THE MEMORY RULES FOR CODE SEGMENT
    dw 0xffff;segment limit first 0-15 bits
    dw 0    ;base first 0-15 bits
    db 0    ;base 16-23 bits
    db 0x9a ;Access byte
    db 11001111b ; High 4 bit flags and the low 4 bit flags
    db 0 


;offset 0x10
gdt_data: ;DS,SS,ES,FS,GS

    dw 0xffff;segment limit first 0-15 bits
    dw 0    ;base first 0-15 bits
    db 0    ;base 16-23 bits
    db 0x92 ;Access byte
    db 11001111b ; High 4 bit flags and the low 4 bit flags
    db 0 

gdt_end:

gdt_descriptor:
    dw gdt_end-gdt_start-1
    dd gdt_start

[BITS 32]
load32:
    mov eax,1
    mov ecx,100
    mov edi,0x0100000



times 510-($-$$) db 0
dw 0xAA55

