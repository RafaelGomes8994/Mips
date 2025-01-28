.data
    prompt: .asciiz "Digite um número: "       # Mensagem exibida ao usuário
    result_msg: .asciiz "A raiz quadrada inteira é: " # Mensagem de resultado
    result: .word 0                           # Variável para armazenar o resultado da raiz

.text
.globl main

main:
    # Exibe a mensagem "Digite um número: "
    li $v0, 4              # syscall: print_string
    la $a0, prompt         # Carrega o endereço da string "prompt" em $a0
    syscall                # Faz a chamada do sistema para imprimir a string

    # Lê o número digitado pelo usuário
    li $v0, 5              # syscall: read_int
    syscall                # Faz a chamada do sistema para ler um número inteiro
    move $t1, $v0          # Armazena o número digitado pelo usuário em $t1 (x)

    # Inicializa y = 0
    li $t2, 0              # Inicializa $t2 (y) com o valor 0

    # Chama a função raiz usando pilha
    jal raiz               # Salta para o rótulo raiz e armazena o endereço de retorno em $ra

    # Armazena o resultado na variável
    sw $t2, result         # Salva o valor de $t2 (resultado de y) na variável "result"

    # Exibe a mensagem "A raiz quadrada inteira é: "
    li $v0, 4              # syscall: print_string
    la $a0, result_msg     # Carrega o endereço da string "result_msg" em $a0
    syscall                # Faz a chamada do sistema para imprimir a string

    # Exibe o resultado
    lw $a0, result         # Carrega o valor da variável "result" em $a0
    li $v0, 1              # syscall: print_int
    syscall                # Faz a chamada do sistema para imprimir o inteiro

    # Finaliza o programa
    li $v0, 10             # syscall: exit
    syscall                # Faz a chamada do sistema para encerrar o programa

# Função raiz usando pilha
raiz:
    # Inicializa o ponteiro da pilha
    li $sp, 0x7fffeffc     # Define o ponteiro da pilha ($sp) para o topo da memória

loop:
    # Calcula y * y
    mul $t3, $t2, $t2      # $t3 = y * y
    # Verifica se y * y > x
    bgt $t3, $t1, maior    # Se $t3 > $t1, salta para o rótulo "maior"

    # Empilha o estado atual de y
    sub $sp, $sp, 4        # Move o ponteiro da pilha para baixo (reserva espaço)
    sw $t2, 0($sp)         # Salva o valor de $t2 (y) no topo da pilha

    # Incrementa y e continua o loop
    addi $t2, $t2, 1       # y = y + 1
    j loop                 # Salta de volta para o início do loop

maior:
    # Desempilha o último estado válido de y
    lw $t2, 0($sp)         # Recupera o valor de y do topo da pilha
    add $sp, $sp, 4        # Move o ponteiro da pilha para cima (libera espaço)

    # Retorna da função raiz
    jr $ra                 # Retorna para o endereço armazenado em $ra (retorna ao main)
