.data 
	welcome_msg: .asciiz "Bienvenido a quien quiere ser millonario\n"
	p1:.asciiz "Cual es la independencia de Colombia?\n"
    p2: .asciiz "Cual no es un sistema operativo?\n"
    p3: .asciiz "Quien escribio Cien anios de soledad?\n"
    p4: .asciiz "Cuantos jugadores hay en un equipo de futbol?\n"
    p5: .asciiz "Cual es la capital de Francia?\n"
    r1: .asciiz "1. 20 de julio 2. 3 de enero 3. 5 de abril 4. 8 de marzo\n"
    r2: .asciiz "1. Windows 2. HTML 3. macOS 4. Ubuntu\n"
    r3: .asciiz "1. Gabriel Garcia Marquez 2. Alejo Carpentier 3. Juan Rulfo 4. Mario Vargas Llosa\n"
    r4: .asciiz "1. 8 2. 4 3. 11 4. 7\n"
    r5: .asciiz "1. Niza 2. Cali 3. Oaxaca 4. París\n"
    felicidades_msg: .asciiz "Felicidades, ha ganado\n"
    lo_siento_msg: .asciiz "Lo siento, ha perdido\n"
    correctas: .word 1, 2, 1, 3, 4
	preguntas: .word p1, p2, p3, p4, p5
	respuesta: .word r1, r2, r3, r4, r5
  
.text
.globl main

main:
	
	li $v0, 4 
    la $a0, welcome_msg 
    syscall
	
	la $t0, preguntas      
    la $t1, respuesta     
    la $t2, correctas 
	
	li $s0, 0 
    li $s1, 0 
	
loop:
	
	
    beq $s0, 5, check_result 
	
		lw $t3, 0($t0)
		li $v0, 4
		la $a0, 0($t3)
		syscall
		
		lw $t4, 0($t1)
		li $v0, 4
		la $a0, 0($t4)
		syscall
		
		li $v0, 5
		syscall
		add $t5, $v0, 0
		
		lw $t6, 0($t2)
		beq $t5, $t6, correct
		
next:
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	j loop
		
correct:

	addi $s1, $s1, 1
	j next
		
check_result:
	li $t7, 4
    bge $s1, $t7, ganador

    li $v0, 4
    la $a0, lo_siento_msg
    syscall
    j end

ganador:
    li $v0, 4
    la $a0, felicidades_msg
    syscall

end:
    li $v0, 10
    syscall		
