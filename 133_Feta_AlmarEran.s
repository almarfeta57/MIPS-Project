.data
 nr_noduri: .space 4
 nr_legaturi: .space 4
 cerinta: .space 4
 G: .space 1600
 roles: .space 80
 coada: .space 80
 viz: .space 80
 host1: .space 4
 host2: .space 4
 sir: .space 101

 sp: .asciiz " "
 newline: .asciiz "\n"
 host: .asciiz "host index "
 switch: .asciiz "switch index "
 switch_malitios: .asciiz "switch malitios index "
 controller: .asciiz "controller index "
 puncte: .asciiz ": "
 punctvirgula: .asciiz "; "
 yes: .asciiz "Yes"
 no: .asciiz "No"

.text

main:
 li $v0, 5                        #citirea numarului de noduri
 syscall
 sw $v0, nr_noduri

 li $v0, 5                        #citirea numarului de muchii
 syscall
 sw $v0, nr_legaturi

 li $t0, 0                        # $t0 = i; $t1 = nr_legaturi; $t2 = nod1; $t3 = nod2; $t4 = 1; $t5 = nr_noduri; $t6 = ((i*nr_noduri)+j)*4 
 lw $t1, nr_legaturi
 lw $t5, nr_noduri
loop1:                            # se formeaza matricea de adiacenta
 beq $t0, $t1, endloop1
 li $v0, 5
 syscall
 move $t2, $v0
 li $v0, 5
 syscall
 move $t3, $v0
 li $t4, 1
 mul $t6, $t5, $t2
 add $t6, $t6, $t3 
 mul $t6, $t6, 4
 sw $t4, G($t6)
 mul $t6, $t5, $t3
 add $t6, $t6, $t2
 mul $t6, $t6, 4 
 sw $t4, G($t6)
 addi $t0, $t0, 1
 j loop1

endloop1:
 li $t0, 0
loop2:                            # se citeste vectorul rolurilor
 beq $t0, $t5, endloop2
 li $v0, 5
 syscall
 mul $t2, $t0, 4
 sw $v0, roles($t2)
 addi $t0, $t0, 1
 j loop2

endloop2:
 li $v0, 5                        # se citeste numarul cerintei
 syscall
 sw $v0, cerinta
 
 lw $t0, cerinta 
 beq $t0, 1, cerinta1
 beq $t0, 2, cerinta2
 beq $t0, 3, cerinta3
 j end

cerinta1:
 li $t0, 0
 lw $t1, nr_noduri
loop3:
 beq $t0, $t1, endloop3
 mul $t2, $t0, 4
 lw $t9, roles($t2)
 bne $t9, 3, continue1
 la $a0, switch_malitios
 li $v0, 4
 syscall
 move $a0, $t0
 li $v0, 1
 syscall
 la $a0, puncte
 li $v0, 4
 syscall
 li $t3, 0
loop4:
 beq $t3, $t1, endloop4
 mul $t4, $t0, $t1
 add $t4, $t4, $t3
 mul $t4, $t4, 4
 lw $t9, G($t4)
 bne $t9, 1, continue2
 mul $t5, $t3, 4
 lw $t9, roles($t5)
 beq $t9, 1, afisare1
 beq $t9, 2, afisare2
 beq $t9, 3, afisare3
 beq $t9, 4, afisare4
continue2:
 addi $t3, $t3, 1
 j loop4
endloop4:
 la $a0, newline
 li $v0, 4
 syscall
continue1:
 addi $t0, $t0, 1
 j loop3
endloop3:
 j end

afisare1:
 la $a0, host
 li $v0, 4
 syscall
 move $a0, $t3
 li $v0, 1
 syscall
 la $a0, punctvirgula
 li $v0, 4
 syscall
 j continue2

afisare2:
 la $a0, switch
 li $v0, 4
 syscall
 move $a0, $t3
 li $v0, 1
 syscall
 la $a0, punctvirgula
 li $v0, 4
 syscall
 j continue2

afisare3:
 la $a0, switch_malitios
 li $v0, 4
 syscall
 move $a0, $t3
 li $v0, 1
 syscall
 la $a0, punctvirgula
 li $v0, 4
 syscall
 j continue2

afisare4:
 la $a0, controller
 li $v0, 4
 syscall
 move $a0, $t3
 li $v0, 1
 syscall
 la $a0, punctvirgula
 li $v0, 4
 syscall
 j continue2


cerinta2:
 li $t0, 1                         # t0 = len_coada
 li $t1, 0                         # t1 = index
 li $t2, 0                         # t2 = nod curent
 sw $t0, viz($t1)
loopBF:
 beq $t1, $t0, endloopBF
 mul $t3, $t1, 4
 lw $t2, coada($t3)
 addi $t1, $t1, 1
 mul $t3, $t2, 4
 lw $t4, roles($t3)
 bne $t4, 1, continue3
 la $a0, host
 li $v0, 4
 syscall
 move $a0, $t2
 li $v0, 1
 syscall
 la $a0, punctvirgula
 li $v0, 4
 syscall
continue3:
 li $t3, 0                     # t3 = i
 lw $t4, nr_noduri
loopBF2:
 beq $t3, $t4, endloopBF2
 mul $t5, $t2, $t4
 add $t5, $t5, $t3
 mul $t5, $t5, 4
 lw $t6, G($t5)
 bne $t6, 1, continue4
 mul $t5, $t3, 4
 lw $t6, viz($t5)
 bne $t6, 0, continue4
 mul $t5, $t0, 4
 sw $t3, coada($t5)
 addi $t0, $t0, 1
 mul $t5, $t3, 4
 li $t9, 1
 sw $t9, viz($t5)
continue4:
 addi $t3, $t3, 1
 j loopBF2
endloopBF2:
 j loopBF
endloopBF:
 li $t0, 0
 lw $t1, nr_noduri 
loop5:
 beq $t0, $t1, endloop5
 mul $t2, $t0, 4
 lw $t3, viz($t2)
 beq $t3, 0, fals
 addi $t0, $t0, 1
 j loop5
endloop5:
 la $a0, newline
 li $v0, 4
 syscall
 la $a0, yes
 li $v0, 4
 syscall
 j end
fals:
 la $a0, newline
 li $v0, 4
 syscall
 la $a0, no
 li $v0, 4
 syscall
 j end


cerinta3:
 li $v0, 5
 syscall
 sw $v0, host1
 li $v0, 5
 syscall
 sw $v0, host2
 la $a0, sir
 li $a1, 100
 li $v0, 8
 syscall
 
 li $t0, 0
 lw $t1, nr_noduri
 li $t9, 0
loop6:
 beq $t0, $t1, endloop6
 mul $t3, $t0, 4
 lw $t4, roles($t3)
 bne $t4, 3, endloop7
 li $t5, 0
loop7:
 beq $t5, $t1, endloop7
 mul $t3, $t0, $t1
 add $t3, $t3, $t5
 mul $t3, $t3, 4
 lw $t4, G($t3)
 bne $t4, 1, continue6
 sw $t9, G($t3)
 mul $t3, $t5, $t1
 add $t3, $t3, $t0
 mul $t3, $t3, 4
 sw $t9, G($t3)
continue6:
 addi $t5, $t5, 1
 j loop7
endloop7:
 addi $t0, $t0, 1
 j loop6
endloop6:
 li $t0, 0                         # t0 = len_coada
 li $t1, 0                         # t1 = index
 li $t2, 0                         # t2 = nod curent
 lw $t3, host1
 sw $t3, coada($t0)
 addi $t0, $t0, 1
 mul $t3, $t3, 4
 sw $t0, viz($t3)
loopBF3:
 beq $t1, $t0, endloopBF3
 mul $t3, $t1, 4
 lw $t2, coada($t3)
 addi $t1, $t1, 1
 li $t3, 0                     # t3 = i
 lw $t4, nr_noduri
loopBF4:
 beq $t3, $t4, endloopBF4
 mul $t5, $t2, $t4
 add $t5, $t5, $t3
 mul $t5, $t5, 4
 lw $t6, G($t5)
 bne $t6, 1, continue7
 mul $t5, $t3, 4
 lw $t6, viz($t5)
 bne $t6, 0, continue7
 mul $t5, $t0, 4
 sw $t3, coada($t5)
 addi $t0, $t0, 1
 mul $t5, $t3, 4
 li $t9, 1
 sw $t9, viz($t5)
continue7:
 addi $t3, $t3, 1
 j loopBF4
endloopBF4:
 j loopBF3
endloopBF3:
 lw $t0, host2
 mul $t0, $t0, 4
 lw $t1, viz($t0)
 beq $t1, 0, caz1
 beq $t1, 1, caz2
 j end

caz1:
 li $t0, 0
 lb $t1, sir($t0)
loop8:
 beq $t1, 0, endloop8
 sub $t2, $t1, 97
 sub $t2, $t2, 10
 bge $t2, 10, caz1_1
 blt $t2, 10, caz1_2 
continue8:
 addi $t0, $t0, 1
 lb $t1, sir($t0)
 j loop8
endloop8:
 j end

caz1_1:
 rem $t2, $t2, 26
 addi $t2, $t2, 97
 blt $t2, 97, continue8
 bgt $t2, 122, continue8
 move $a0, $t2
 li $v0, 11
 syscall
 j continue8

caz1_2:
 addi $t2, $t2, 26
 rem $t2, $t2, 26
 addi $t2, $t2, 97
 blt $t2, 97, continue8
 bgt $t2, 122, continue8
 move $a0, $t2
 li $v0, 11
 syscall
 j continue8
  
caz2:
 li $t0, 0
 lb $t1, sir($t0)
loop9:
 beq $t1, 0, endloop9
 blt $t1, 97, continue9
 bgt $t1, 122, continue9
 move $a0, $t1
 li $v0, 11
 syscall
continue9:
 addi $t0, $t0, 1
 lb $t1, sir($t0)
 j loop9
endloop9:
 j end

end:
 li $v0, 10
 syscall
