;Napisati proceduru NEAR tipa koja u stringu (niz ASCII karaktera zavrsen nulom) pronalazi karakter '%',
;a zatim u registar DX smjesta njegovu log. adresu, broj karaktera izmedju ovog i posljednjeg karaktera u nizu 
;u registar CX, a u AL registar smjesta 1. Ukoliko u stringu nije pronadjen navedeni karakter, u AL treba smjestiti 0.
;Pretpostaviti da se karakter '%' pojavljuje samo jednom unutar stringa. String se proceduri proslijedjuje po referenci preko steka.

.model small
.stack
.data
    string db 'Mil%ica',0
.code

.startup
    mov ax,offset string
    push ax         ;smjesti adresu na stek
    call find_proc    
    hlt             ;samo ako je al==1 ima smisla provjeravati ostale reg!
        
    find_proc   proc near
    
        ;sacuvaj sve koje procedura ne treba da mijenja!
        push bx
        push si
        push bp
        mov bp,sp
         
        mov si,[bp+8]
        mov al,0
        mov bx,0 ;duzina stringa (iskljucujuci delimiter)
   
        iterate:
            cmp [si],0
            je set_cx
            inc bx 
        
            cmp [si],'%'
            je match 
            inc si 
       
        jmp iterate
 
    match:
        mov dx,si    
        mov al,1 
        inc si 
    jmp iterate
    
    set_cx:
        mov cx,bx
        sub cx,dx
        sub cx,2    ;iskljuci posljednji i %    
       
        pop bp   ;ostavi na steku (dostupne glavnom programu AX,CX,DX)
        pop si
        pop bx
        ret 8
   
end
   
   
