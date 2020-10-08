#
#   Bruno Pereira Bannwart e Luis Marcelo Davila
#   Projeto 01
#

.data
titulo_projeto: .asciiz     "\nPrograma de calculo de notas da disciplina"
lista_op:       .asciiz     "\nLista de opcoes:"
op1:            .asciiz     "\n1) Cadastro de alunos"
op2:            .asciiz     "\n2) Cadastro de notas"
op3:            .asciiz     "\n3) Alterar notas"
op4:            .asciiz     "\n4) Exibir notas dos alunos"
op5:            .asciiz     "\n5) Media aritmetica da turma"
op6:            .asciiz     "\n6) Lista de aprovados"
op7:            .asciiz     "\n7) Sair"
escolha:        .asciiz     "\nQual opcao a ser realizada? "
erro_op:        .asciiz		"\nOpcao nao encontrada.\n"

pular_linha:    .asciiz     "\n"

mensagem_exibir_notas_titulo:     .asciiz     "\nNotas cadastradas"
mensagem_exibir_notas_ra:         .asciiz     "\n\tRA: "
mensagem_exibir_notas_atividade:  .asciiz     "\n\tNota de atividade: "
mensagem_exibir_notas_projeto:    .asciiz     "\n\tNota de projeto: "
mensagem_exibir_notas_media:      .asciiz     "\n\tMedia do aluno: "
mensagem_exibir_notas_erro:       .asciiz     "\n\tDeve cadastrar todos os alunos primeiro."

mensagem_cadastro_aluno_titulo:  .asciiz    "\nCadastro dos 5 alunos da disciplina"
mensagem_cadastro_aluno_ra:      .asciiz    "\n\tEntre com o RA do aluno: "
mensagem_cadastro_aluno_erro:    .asciiz    "\nTodos os alunos cadastrados"

mensagem_cadastro_nota_titulo:      .asciiz    "\nCadastro de notas dos alunos"
mensagem_cadastro_nota_tipo:        .asciiz    "\n\tNotas de atividade (1) ou projeto (2)? "
mensagem_cadastro_nota_atividade:   .asciiz   "\n\tAtividade 1 (1), atividade 2 (2), atividade 3 (3), atividade 4 (4) ou atividade 5 (5)? "
mensagem_cadastro_nota_projeto:     .asciiz   "\n\tProjeto 1 (1) ou projeto 2 (2)? "
mensagem_cadastro_nota_erro:        .asciiz   "\n\tDeve cadastrar todos os alunos primeiro."
mensagem_cadastro_nota_ra_aluno:    .asciiz   "\n\tCadastrando nota do aluno: "
mensagem_cadastro_nota:             .asciiz   "\n\tInforme a nota a ser cadastrada: "

mensagem_alteracao_nota_titulo:		        .asciiz "\nAlteracao de nota especifica"
mensagem_alteracao_nota_ra:			        .asciiz "\nDigite o RA do aluno desejado: "
mensagem_alteracao_nota_atividade:	        .asciiz   "\n\tAtividade 1 (1), atividade 2 (2) , atividade 3 (3), atividade 4 (4), atividade 5 (5), Projeto 1 (6) ou Projeto 2 (7) "
mensagem_alteracao_nota_nova:               .asciiz "\nDigite a nova nota:"
mensagem_alteracao_nota_erro_aluno:	        .asciiz  "\nAluno nao encontrado."
mensagem_alteracao_erro_alunoNC:            .asciiz  "\n Alunos nao cadastrados."
mensagem_alteracao_erro_nova_tentativa:     .asciiz "\n Deseja tentar novamente?"
mensagem_alteracao_erro_nova_tentativa2:    .asciiz "\n 1.Sim  2.Nao"
mensagem_alteracao_erro_desistencia:        .asciiz "\n Operacao finalizada."

mensagem_media_turma_titulo:      .asciiz   "\nMedia aritmetica da turma"
mensagem_media_turma:             .asciiz   "\n\tA media da turma e: "
mensagem_media_turma_erro:        .asciiz   "\n\tDeve cadastrar todos os alunos primeiro."

mensagem_aprovados_titulo:        .asciiz   "\nLista de aprovados da disciplina"
mensagem_aprovados_nota:          .asciiz   "\n\tDigite a media minima para ser aprovado: "
mensagem_aprovados_aluno_ra:      .asciiz   "\n\tAluno: "
mensagem_aprovados_aluno_media:   .asciiz   "\n\tMedia: "
mensagem_aprovados_erro:          .asciiz   "\n\tDeve cadastrar todos os alunos primeiro."

cadastros:  .align 2                # Array de alunos cadastrados
            .space 180              # 36 bytes por aluno (4bytes para cada informação: RA, A1, A2, A3, A4, A5, P1, P2, M)

ra_cadastrado: .word 0, 0, 0, 0, 0  # Array dos RAs dos alunos para ordenação com bubble sort

exibicao:   .align 2                # Array de alunos após ordenação de RA (auxiliar)
            .space 180

.text
.globl main

main:
    jal menu                # Função que exibe as opções do menu

    li $v0, 5               # Receber opção escolhida do menu
    syscall

    addi $s0, $zero, 1      # Opção 1                   
    addi $s1, $zero, 2      # Opção 2
    addi $s2, $zero, 3      # Opção 3
    addi $s3, $zero, 4      # Opção 4
    addi $s4, $zero, 5      # Opção 5
    addi $s5, $zero, 6      # Opção 6
    addi $s6, $zero, 7      # Opção 7

    beq $v0, $s0, op_cadastro_aluno     # Ir para cadastro de alunos
    beq $v0, $s1, op_cadastro_nota      # Ir para cadastro de notas
    beq $v0, $s2, op_alterar_nota       # Ir para alteração notas
    beq $v0, $s3, op_exibir_notas       # Ir para exibição de notas
    beq $v0, $s4, op_media_turma        # Ir para exibição de média da turma
    beq $v0, $s5, op_lista_aprovados    # Ir para exibição de lista de aprovados       
    beq $v0, $s6, op_sair               # Ir para sair do programa

    li $v0, 4           # Código para exibição de string
    la $a0, erro_op     # Mensagem de erro, opção inválida
    syscall
    j main              # retornar para inicio do programa

menu:
    addi 	$sp , $sp, -4       # Reserva de endereço na pilha
	sw		$ra , 0($sp)        # Salvamento do endereço de retorno na pilha

    li      $v0, 4
    la      $a0, titulo_projeto # Exibir titulo do projeto
    syscall

    li      $v0, 4
    la      $a0, lista_op       # Exibir titulo da lista
    syscall

    li      $v0, 4
    la      $a0, op1            # Exibir opção 1 do menu
    syscall

    li      $v0, 4
    la      $a0, op2            # Exibir opção 2 do menu
    syscall

    li      $v0, 4
    la      $a0, op3            # Exibir opção 3 do menu
    syscall

    li      $v0, 4
    la      $a0, op4            # Exibir opção 4 do menu
    syscall

    li      $v0, 4
    la      $a0, op5            # Exibir opção 5 do menu
    syscall

    li      $v0, 4
    la      $a0, op6            # Exibir opção 6 do menu
    syscall

    li      $v0, 4
    la      $a0, op7            # Exibir opção 7 do menu
    syscall

    li      $v0, 4
    la      $a0, escolha        # Exibir mensagem de escolha
    syscall

    lw      $ra, 0($sp)         # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4         # Retorno do stack pointer
    jr      $ra                 # Retorno da função

op_cadastro_aluno:
    jal     cadastro_aluno      # Função de cadastro de aluno
    j       main                # retornar para inicio do programa

op_cadastro_nota:
    jal     cadastro_nota       # Função de cadastro de nota
    j       main                # retornar para inicio do programa

op_alterar_nota:
    jal     alterar_nota        # Função de alterar nota
    j       main                # retornar para inicio do programa

op_exibir_notas:
    jal     exibir_notas        # Função de exibir notas
    j       main                # retornar para inicio do programa

op_media_turma:
    jal     media_turma         # Função de exibir média da turma
    j       main                # retornar para inicio do programa

op_lista_aprovados:
    jal     lista_aprovados     # Função de exibir lista de aprovados
    j       main                # retornar para inicio do programa

op_sair:
    li      $v0, 10             # Terminar programa
    syscall

################################################################################
#
#                       Rotina para cadastrar alunos
#
################################################################################
cadastro_aluno:
    addi    $sp, $sp, -4                # Reserva de endereço na pilha
    sw      $ra, 0($sp)                 # Salvamento do endereço de retorno na pilha
    la      $s0, cadastros              # Carregamento do endereço inicial de todos os alunos
    la      $s1, ra_cadastrado          # Carregamento do endereço inicial de todos os ra (vetor auxiliar para ordenação depois)
    addi    $t0, $s0, 180               # endereço limite da iteração no loop

    li      $v0, 4
    la      $a0, mensagem_cadastro_aluno_titulo  # Exibir mensagem de cadastro de aluno
    syscall

verifica_cadastro_aluno:
    beq     $s0, $t0, cadastro_aluno_cheio      # Verificar se tem espaço para cadastrar aluno
    lw      $t1, 0($s0)                         # Se alunos[i].ra for = 0, significa que não foi cadastrado ainda esse aluno
    beq     $t1, $zero, novo_cadastro_aluno     # Cadastrar novo alunos

continua_cadastro_aluno:
    addi    $s0, $s0, 36                        # Proxima posição do array de alunos (Cada posição tem 36 bytes)
    addi    $s1, $s1, 4                         # Proxima posição do array de RAs
    j       verifica_cadastro_aluno             # Continuar verificação de cadastros

cadastro_aluno_cheio:
    li      $v0, 4
    la      $a0, mensagem_cadastro_aluno_erro   # Exibir mensagem de todos os alunos cadastrados
    syscall

    li      $v0, 4
    la      $a0, pular_linha                    # Exibir pular linha
    syscall

    j       fim_cadastro_aluno                  # Finalizar cadastro de alunos

novo_cadastro_aluno:
    li      $v0, 4
    la      $a0, mensagem_cadastro_aluno_ra     # Exibir menasgem para cadastrar novo aluno
    syscall

    li      $v0, 5                              # Obter RA digitado
    syscall
    sw      $v0, 0($s0)                         # Salvar RA em alunos[i].ra
    sw      $v0, 0($s1)                         # Salvar RA em vetor de RAs na posição I
    j       continua_cadastro_aluno             # Continuar cadastros de alunos

fim_cadastro_aluno:
    lw      $ra, 0($sp)         # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4         # Retorno do stack pointer
    jr      $ra                 # Retorno da função

################################################################################
#
#                       Rotina para cadastro das notas
#
################################################################################
cadastro_nota:
    addi    $sp, $sp, -4                # Reserva de endereço na pilha
    sw      $ra, 0($sp)                 # Salvamento do endereço de retorno na pilha

    addi    $t0, $zero, 1               # Opção 1 - Cadastro de Atividade
    addi    $t1, $zero, 2               # Opção 2 - Cadastro de Projeto

    li      $v0, 4
    la      $a0, mensagem_cadastro_nota_tipo # Exibir mensagem perguntando qual tipo de nota será cadastrada
    syscall

    li      $v0, 5                      # Obter escolha de tipo de nota (Atividade ou projeto)
    syscall

    beq $v0, $t0, cadastro_nota_atividade   # Ir para cadastro de atividades
    beq $v0, $t1, cadastro_nota_projeto     # Ir para cadastro de projetos
    j   cadastro_nota

cadastro_nota_atividade:
    addi    $t0, $zero, 1               # Opção da primeira atividade
    addi    $t1, $zero, 2               # Opção da segunda atividade
    addi    $t2, $zero, 3               # Opção da terceira atividade
    addi    $t3, $zero, 4               # Opção da quarta atividade
    addi    $t4, $zero, 5               # Opção da quinta atividade

    li      $v0, 4
    la      $a0, mensagem_cadastro_nota_atividade  # Exibir mensagem perguntando qual das atividades será atribuida nota
    syscall

    li      $v0, 5                      # Obter opção de atividade escolhida
    syscall

    beq $v0, $t0, cadastro_nota_primeira_atividade  # Ir para cadastro da atividade 1
    beq $v0, $t1, cadastro_nota_segunda_atividade   # Ir para cadastro da atividade 2
    beq $v0, $t2, cadastro_nota_terceira_atividade  # Ir para cadastro da atividade 3
    beq $v0, $t3, cadastro_nota_quarta_atividade    # Ir para cadastro da atividade 4
    beq $v0, $t4, cadastro_nota_quinta_atividade    # Ir para cadastro da atividade 5
    j   cadastro_nota_atividade                     # Opção inválida escolhida

cadastro_nota_projeto:
    addi    $t0, $zero, 1               # Opção da primeiro projeto
    addi    $t1, $zero, 2               # Opção da segundo projeto

    li      $v0, 4
    la      $a0, mensagem_cadastro_nota_projeto # Exibir mensagem perguntando qual dos projetos será atribuida nota
    syscall

    li      $v0, 5                       # Obter opção de projeto escolhido
    syscall

    beq $v0, $t0, cadastro_nota_primeiro_projeto    # Ir para cadastro de projeto 1
    beq $v0, $t1, cadastro_nota_segundo_projeto     # Ir para cadastro de projeto 2
    j   cadastro_nota_projeto                       # Opção inválida escolhida

cadastro_nota_primeira_atividade:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro          # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 4                             # Obter posição da memória equivalente a primeira atividade
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -4                          # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_segunda_atividade:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro          # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 8                             # Obter posição da memória equivalente a segunda atividade
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -8                          # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_terceira_atividade:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro          # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 12                            # Obter posição da memória equivalente a terceira atividade
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -12                         # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_quarta_atividade:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro          # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 16                            # Obter posição da memória equivalente a quarta atividade
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -16                         # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_quinta_atividade:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro          # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 20                            # Obter posição da memória equivalente a quinta atividade
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -20                         # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_primeiro_projeto:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro          # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 24                            # Obter posição da memória equivalente a primeiro projeto
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -24                         # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_segundo_projeto:
    la      $a1, cadastros                          # Carregar endereço dos alunos cadastrados
    lw      $t0, 0($a1)                             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, cadastro_nota_erro           # Salto para mensagem de erro se RA = 0
    addi    $a1, $a1, 28                            # Obter posição da memória equivalente a segundo projeto
    addi    $s1, $zero, 5                           # Quantidade de alunos cadastrados = 5
    addi    $s2, $zero, -28                         # Obter posição da memória equivalente ao RA
    j       cadastro_nota_loop                      # Ir para loop de cadastro de notas dos alunos (de acordo com a opção escolhida)

cadastro_nota_erro:
    li      $v0, 4
    la      $a0, mensagem_cadastro_nota_erro        # Exibir mensagem de necessário cadastrar alunos
    syscall

    li      $v0, 4
    la      $a0, pular_linha            # Exibir pular linha
    syscall

    j       fim_cadastro_nota           # Ir para fim de cadastro de notas

cadastro_nota_loop:
    beq    $s1, $zero, fim_cadastro_nota    # Se quantidade de alunos = 0, todos os alunos tiveram sua nota cadastrada => fim do cadastro dessa nota
    add    $s0, $a1, $s2                # Posição do RA do aluno[i]

    li  $v0, 4
    la  $a0, mensagem_cadastro_nota_ra_aluno    # Exibir mensagem informando o RA do aluno
    syscall

    li  $v0, 1                          # Exibir RA do aluno no cadastro de nota
    lw  $a0, 0($s0)
    syscall

    li  $v0, 4
    la  $a0, mensagem_cadastro_nota     # Perguntar nota do aluno
    syscall

    li  $v0, 6                          # Obter nota do aluno
    syscall

    s.s     $f0, 0($a1)                 # Salvando nota de acordo com a opção escolhida
    addi    $a1, $a1, 36                # Proxima posição dos alunos
    addi    $s1, $s1, -1                # Decrementar quantidade de alunos a ainda ter a sua nota cadastrada
    j       cadastro_nota_loop          # Repetir cadastro de nota para próximo alno
    
fim_cadastro_nota:
    lw      $ra, 0($sp)         # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4         # Retorno do stack pointer
    jr      $ra                 # Retorno da função

################################################################################
#
#                       Rotina para alteração das notas
#
################################################################################
alterar_nota:
	addi    $sp, $sp, -4        # Reserva de endereço na pilha
    sw      $ra, 0($sp)         # Salvamento do endereço de retorno na pilha
	la      $s0, cadastros      # Carregamento do endereço inicial de todos os alunos
		
nova_tentativa:                 # Inicio da rotina com titulo de retorno em caso de erro
	li $v0,4
	la $a0, mensagem_alteracao_nota_titulo
	syscall                     # Impressão do titulo

    # Verificação de cadastro dos alunos

    lw  $t1, 0($s0)
    bne $t1, $zero, verificacao_validada
    
    li $v0,4
    la $a0, mensagem_alteracao_erro_alunoNC
    syscall

    j fim_alterar_nota

verificacao_validada:
    la $a0, mensagem_alteracao_nota_ra
	syscall                     # Impressão da mensagem

	li $v0, 5                   # Leitura do RA do aluno
	syscall

	addi $s1, $zero, 5          # Definição de um contador de 5 posições

inicio_loop_busca_aluno:
	lw  $t1, 0($s0)             # Comparação do RA escolhido com o armazenado na memória
	beq $v0, $t1, alterar_atividade 
	
    addi $s0, $s0, 36           # Caso o RA não seja o mesmo, a posição do próximo aluno é somada no endereço de memória
	addi $s1, $s1, -1           # O contador de alunos é decrementado
	
    beq $s1,$zero, erro_alunoNE # Se o contador chegar a zero, o RA escolhido não existe
	j inicio_loop_busca_aluno

alterar_atividade:
    addi $t0, $zero, 4          # O tamanho de cada informação do aluno é de 4 bytes, logo, o offset das atividades é um múltiplo de 4

    li $v0, 4
    la $a0, mensagem_alteracao_nota_atividade
    syscall

    li $v0,5                    # Leitura da escolha da atividade a ser alterada
    syscall

    mul $t0, $t0, $v0           # A escolha no menu é multiplicada por 4 para atingir o offset desejado
    add $s0, $s0, $t0           # O offset é somado no endereço do RA encontrado do aluno

    li $v0,4
    la $a0, mensagem_alteracao_nota_nova
    syscall

    li  $v0, 6                  # Leitura da nova nota que substituirá a escolhida
    syscall

    s.s $f0, 0($s0)             # Escrita da nova nota no endereço de memória
    j   fim_alterar_nota

## Erro: Aluno Não encontrado

erro_alunoNE:
	li $v0, 4
	la $a0, mensagem_alteracao_nota_erro_aluno
	syscall

	la $a0, mensagem_alteracao_erro_nova_tentativa      # Nestas mensagens o programa avisa que o RA não foi encontrado, e pergunta se o usuário deseja tentar novamente
	syscall

	la $a0, mensagem_alteracao_erro_nova_tentativa2
	syscall

	li $v0, 5
	syscall

	addi $t3, $zero, 1                                  # Caso a resposta seja afirmativa (1), o programa retorna para o início da rotina e todo o processo é refeito
	beq $v0, $t3, nova_tentativa

	li $v0, 4
	la $a0, mensagem_alteracao_erro_desistencia         # Caso contrário, o programa avisará que a rotina foi finalizada
	syscall

fim_alterar_nota:
	lw      $ra, 0($sp)                 # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4                 # Retorno do stack pointer
	jr $ra                              # Retorno da função

################################################################################
#
#                       Rotina para exibição das notas
#
################################################################################
exibir_notas:
    addi    $sp, $sp, -4                # Reserva de endereço na pilha
    sw      $ra, 0($sp)                 # Salvamento do endereço de retorno na pilha

    la      $a1, cadastros              # Carregamento do endereço inicial de todos os alunos
    lw      $t0, 0($a1)                 # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, exibir_notas_erro

    jal     media_aluno                 # função para calcular média individual dos alunos
    jal     ordenar_ra                  # função para ordenar alunos pelo RA

    la      $s0, exibicao               # Carregamento do endereço inicial de todos os alunos ordenados
    addi    $t0, $s0, 180               # endereço limite da iteração no loop

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_titulo   # Exibir mensagem de titulo da opção de exibição de notas
    syscall

    j       exibir_notas_loop           # Ir para loop de exibição de notas

exibir_notas_erro:
    li      $v0, 4
    la      $a0, mensagem_exibir_notas_erro     # Mensagem de necessario cadastrar alunos
    syscall

    li      $v0, 4
    la      $a0, pular_linha                    # Exibir pular linha
    syscall

    j       fim_exibir_notas                    # Ir para fim da função

exibir_notas_loop:
    beq     $s0, $t0, fim_exibir_notas          # Se chegou ao endereço limite, fim da função
    li      $v0, 4
    la      $a0, mensagem_exibir_notas_ra       # Exibir mensagem informando RA do aluno
    syscall

    li      $v0, 1
    lw      $a0, 0($s0)         # Carregando RA do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_atividade    # Exibir mensagem de nota de atividade
    syscall

    li      $v0, 2
    l.s     $f12, 4($s0)        # Carregando nota da atividade 1 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_atividade    # Exibir mensagem de nota de atividade
    syscall

    li      $v0, 2
    l.s     $f12, 8($s0)        # Carregando nota da atividade 2 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_atividade    # Exibir mensagem de nota de atividade
    syscall

    li      $v0, 2
    l.s     $f12, 12($s0)       # Carregando nota da atividade 3 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_atividade    # Exibir mensagem de nota de atividade
    syscall

    li      $v0, 2
    l.s     $f12, 16($s0)       # Carregando nota da atividade 4 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_atividade    # Exibir mensagem de nota de atividade
    syscall

    li      $v0, 2
    l.s     $f12, 20($s0)       # Carregando nota da atividade 5 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_projeto  # Exibir mensagem de nota de projeto
    syscall

    li      $v0, 2
    l.s     $f12, 24($s0)       # Carregando nota do projeto 1 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_projeto  # Exibir mensagem de nota de projeto
    syscall

    li      $v0, 2
    l.s     $f12, 28($s0)       # Carregando nota do projeto 2 do aluno
    syscall

    li      $v0, 4
    la      $a0, mensagem_exibir_notas_media # Exibir mensagem de nota do aluno
    syscall

    li      $v0, 2
    l.s     $f12, 32($s0)       # Carregando média do aluno
    syscall

    li      $v0, 4
    la      $a0, pular_linha    # Exibir pular linha
    syscall

    addi    $s0, $s0, 36        # Proxima posição de alunos ordenados [i]
    j       exibir_notas_loop   # Repetir loop de exibição do aluno

fim_exibir_notas:
    lw      $ra, 0($sp)         # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4         # Retorno do stack pointer
    jr      $ra                 # Retorno da função

################################################################################
#
#                       Rotina para ordenar RA
#
################################################################################
ordenar_ra:
    addi    $sp, $sp, -4                # Reserva de endereço na pilha
    sw      $ra, 0($sp)                 # Salvamento do endereço de retorno na pilha

    la      $a0, ra_cadastrado          # Carregamento do endereço inicial de todos os RAs
    add     $s0, $zero, $zero           # Contador i = 0
    addi    $s2, $zero, 5               # Quantidade de alunos = 5

ordenar_ra_loop_externo:
    slt     $t0, $s0, $s2               # verificar i < quantidade de alunos
    beq     $t0, $zero, sair_ordenar_ra_loop_externo    # se i > quantidade, fim do loop externo 
    addi    $s1, $s0, -1                # j = i - 1

ordenar_ra_loop_interno:
    slti    $t0, $s1, 0                 # verificar se j < 0
    bne     $t0, $zero, sair_ordenar_ra_loop_interno # se j < 0, fim do loop interno
    sll     $t1, $s1, 2                 # temporario = j * 4 (obter posição do array RA em bytes)
    add     $t2, $a0, $t1               # Somar endereço base do array de RA com a posição em bytes

    lw      $t3, 0($t2)                 # Carregar RA da posição j
    lw      $t4, 4($t2)                 # Carregar RA DA posição j + 1
    slt     $t0, $t4, $t3               # verificar se RA[j+1] > RA[j]
    
    beq     $t0, $zero, sair_ordenar_ra_loop_interno    # Se for menor, ir para fim do loop interno
    add     $a1, $zero, $a0             # Passando endereço base do array de RA
    add     $a2, $zero, $s1             # passando contador j
    
    jal     ordenar_ra_bubble           # função para trocar posição
    addi    $s1, $s1, -1                # decrementar j
    j       ordenar_ra_loop_interno     # repetir laço interno

sair_ordenar_ra_loop_interno:
    addi    $s0, $s0, 1                 # incrementar i
    j       ordenar_ra_loop_externo     # repetir laço externo

sair_ordenar_ra_loop_externo:
    jal     ordenar_exibicao        # Função para inserir alunos cadastrados, ordernando-os de acordo com a ordenação do RA

sair_ordenar_ra:
    lw      $ra, 0($sp)             # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4             # Retorno do stack pointer
    jr      $ra                     # Retorno da função

ordenar_ra_bubble:
    sll     $t1, $a2, 2             # temporario = j * 4 (obter posição do array RA em bytes)
    add     $t1, $a1, $t1           # Somar endereço base do array de RA com a posição em bytes

    lw      $t0, 0($t1)         # temporario = V[j]
    lw      $t2, 4($t1)         # temporario2 = V[j+1]
    
    sw      $t2, 0($t1)         # V[j] = temporario2
    sw      $t0, 4($t1)         # V[j+1] = temporario
    jr      $ra                 # Retorno da função

################################################################################
#
#                       Rotina para ordenar a exibição
#
################################################################################
ordenar_exibicao:
    addi    $sp, $sp, -4                # Reserva de endereço na pilha
    sw      $ra, 0($sp)                 # Salvamento do endereço de retorno na pilha

    la      $a0, cadastros              # Carregamento do endereço inicial de todos os alunos
    la      $a1, ra_cadastrado          # Carregamento do endereço inicial de todos os RAs
    la      $a2, exibicao               # Carregamento do endereço inicial de todos os alunos ordenados

    add     $s0, $zero, $zero           # Contador i = 0
    addi    $s2, $zero, 5               # Quantidade de alunos
    addi    $s3, $a0, 180               # endereço limite da iteração no loop

ordenar_exibicao_loop_externo:
    slt     $t0, $s0, $s2               # verificar se i < quantidade de alunos
    beq     $t0, $zero, sair_ordenar_exibicao_loop_externo  # se i > quantidade, fim do loop externo 
    add     $s1, $zero, $a0

ordenar_exibicao_loop_interno:
    beq     $s1, $s3, sair_ordenar_exibicao_loop_interno    # Se chegou ao limite do endereço, fim do loop interno
    sll     $t1, $s0, 2                 # temporario = i * 4 (obter posição do array RA em bytes)
    add     $t1, $a1, $t1               # Somar endereço base do array de RA com endereço da posição em bytes

    lw      $t2, 0($t1)                 # Carregar RA do array de RA da posição i
    lw      $t3, 0($s1)                 # Carregar RA do array de alunos na posição
    bne     $t2, $t3, ordenar_exibicao_loop_interno_continua    # Se forem diferentes, continua loop procurando RA igual

    sw      $t3, 0($a2)         # Armazenar RA na posição ordenada
    
    l.s     $f0, 4($s1)         # Carregar A1 na posição dos alunos cadastrados
    s.s     $f0, 4($a2)         # Armazenar A1 na posição ordenada

    l.s     $f0, 8($s1)         # Carregar A2 na posição dos alunos cadastrados
    s.s     $f0, 8($a2)         # Armazenar A2 na posição ordenada

    l.s     $f0, 12($s1)        # Carregar A3 na posição dos alunos cadastrados
    s.s     $f0, 12($a2)        # Armazenar A3 na posição ordenada

    l.s     $f0, 16($s1)        # Carregar A4 na posição dos alunos cadastrados
    s.s     $f0, 16($a2)        # Armazenar A4 na posição ordenada

    l.s     $f0, 20($s1)        # Carregar A5 na posição dos alunos cadastrados
    s.s     $f0, 20($a2)        # Armazenar A5 na posição ordenada

    l.s     $f0, 24($s1)        # Carregar P1 na posição dos alunos cadastrados
    s.s     $f0, 24($a2)        # Armazenar P1 na posição ordenada

    l.s     $f0, 28($s1)        # Carregar P2 na posição dos alunos cadastrados
    s.s     $f0, 28($a2)        # Armazenar P2 na posição ordenada

    l.s     $f0, 32($s1)        # Carregar M na posição dos alunos cadastrados
    s.s     $f0, 32($a2)        # Armazenar M na posição ordenada

    addi    $a2, $a2, 36        # Avançar próxima posição dos ordenados

ordenar_exibicao_loop_interno_continua:
    addi    $s1, $s1, 36        # Próxima posição do array de alunos
    j       ordenar_exibicao_loop_interno # Repetir loop interno

sair_ordenar_exibicao_loop_interno:
    addi    $s0, $s0, 1         # Próxima posição do array de RA
    j       ordenar_exibicao_loop_externo # Repetir loop externo

sair_ordenar_exibicao_loop_externo:
    lw      $ra, 0($sp)         # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4         # Retorno do stack pointer
    jr      $ra                 # Retorno da função
    
################################################################################
#
#                       Rotina para calcular média do aluno
#
################################################################################
media_aluno:
    addi    $sp, $sp, -4            # Reserva de endereço na pilha
    sw      $ra, 0($sp)             # Salvamento do endereço de retorno na pilha

    la      $s0, cadastros          # Carregamento do endereço inicial de todos os alunos
    addi    $t0, $s0, 180

    addi    $t1, $zero, 2           # Peso de atividade (2)
    addi    $t2, $zero, 5           # Peso de atividade (5)
    addi    $t3, $zero, 22          # Somatoria total dos pesos = 22
    add     $t4, $zero, $zero       # Inicio da somatoria de notas = 0

    mtc1    $t1, $f7                # Converter peso de atividade para ponto flutuante (Necessário para calculo da média)
    cvt.s.w $f7, $f7

    mtc1    $t2, $f8                # Converter peso de projeto para ponto flutuante (Necessário para calculo da média)
    cvt.s.w $f8, $f8

    mtc1    $t3, $f9                # Converter somatoria de pesos para ponto flutuante (Necessário para calculo da média)
    cvt.s.w $f9, $f9

    mtc1    $t4, $f10               # Converter inicio da somatoria de notas para ponto flutuante (Necessário para calculo de média)
    cvt.s.w $f10, $f10

media_aluno_loop:
    beq     $s0, $t0, fim_media_aluno   # Comparar se chegou no endereço limite, se sim, finalizar loop
    l.s     $f0, 4($s0)             # Carregando o valor da atividade 1 do aluno[i] da memória
    l.s     $f1, 8($s0)             # Carregando o valor da atividade 2 do aluno[i] da memória
    l.s     $f2, 12($s0)            # Carregando o valor da atividade 3 do aluno[i] da memória
    l.s     $f3, 16($s0)            # Carregando o valor da atividade 4 do aluno[i] da memória
    l.s     $f4, 20($s0)            # Carregando o valor da atividade 5 do aluno[i] da memória
    l.s     $f5, 24($s0)            # Carregando o valor do projeto 1 do aluno[i] da memória
    l.s     $f6, 28($s0)            # Carregando o valor do projeto 2 do aluno[i] da memória

    mul.s   $f0, $f0, $f7           # Atividade 1 * Peso 2
    mul.s   $f1, $f1, $f7           # Atividade 2 * Peso 2
    mul.s   $f2, $f2, $f7           # Atividade 3 * Peso 2
    mul.s   $f3, $f3, $f7           # Atividade 4 * Peso 2
    mul.s   $f4, $f4, $f7           # Atividade 5 * Peso 2

    mul.s   $f5, $f5, $f8           # Projeto 1 * Peso 5
    mul.s   $f6, $f6, $f8           # Projeto 2 * Peso 5

    add.s   $f10, $f10, $f0         # 0 + A1
    add.s   $f10, $f10, $f1         # A1 + A2
    add.s   $f10, $f10, $f2         # A1 + A2 + A3
    add.s   $f10, $f10, $f3         # A1 + A2 + A3 + A4 
    add.s   $f10, $f10, $f4         # A1 + A2 + A3 + A4 + A5 
    add.s   $f10, $f10, $f5         # A1 + A2 + A3 + A4 + A5 + P1
    add.s   $f10, $f10, $f6         # A1 + A2 + A3 + A4 + A5 + P1 + P2

    div.s   $f12, $f10, $f9         # Somatoria de notas / Somatoria dos pesos

    trunc.w.s $f12, $f12          # Trunca o resultado em single para word               
    cvt.s.w $f12, $f12            # Converte o resultado de single para word
    
    s.s     $f12, 32($s0)         # Salvar calculo da média na sua respectiva posição do aluno[i]
    addi    $s0, $s0, 36          # Próxima posição do array de aluno
    mtc1    $t4, $f10             # Reiniciar somatoria de notas com 0 (Novo calculo)
    cvt.s.w $f10, $f10
    j       media_aluno_loop      # Repetir loop com proximo aluno

fim_media_aluno:
    lw      $ra, 0($sp)         # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4         # Retorno do stack pointer
    jr      $ra                 # Retorno da função

################################################################################
#
#                       Rotina para exibir média da turma
#
################################################################################
media_turma:
    addi    $sp, $sp, -4            # Reserva de endereço na pilha
    sw      $ra, 0($sp)             # Salvamento do endereço de retorno na pilha

    la      $a1, cadastros          # Carregamento do endereço inicial de todos os alunos
    lw      $t0, 0($a1)             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, media_turma_erro

    jal     media_aluno             # Função para calculo de média do aluno

    li      $v0, 4
    la      $a0, mensagem_media_turma_titulo    # Exibir titulo da opção média da turma
    syscall

    la      $s0, cadastros          # Carregamento do endereço inicial de todos os alunos
    addi    $t0, $zero, 5           # Quantidade de alunos = 5

    add     $t1, $zero, $zero       # Somatorio das médias = 0
    mtc1    $t1, $f1                # Converter somatorio para ponto flutuante (Necessário para calculo)
    cvt.s.w $f1, $f1

    j       obter_media_aluno       # Ir para calculo da somatoria de médias

media_turma_erro:
    li      $v0, 4
    la      $a0, mensagem_media_turma_erro  # Exibir mensagem de necessário cadastrar alunos
    syscall

    li      $v0, 4
    la      $a0, pular_linha    # Exibir pular linha
    syscall

    j       fim_media_turma     # Ir para fim da função

obter_media_aluno:
    beq     $t0, $zero, media_turma_calculo # Se quantidade chegar a 0, todos os alunos tiveram suas médias somadas, ir para calculo da média
    l.s     $f0, 32($s0)        # Obter média do aluno na posição [i]
    add.s   $f1, $f1, $f0       # Somar médias anteriores com a média atual

    addi    $t0, $t0, -1            # Decrementar quantidade de aluno
    addi    $s0, $s0, 36            # Próxima posição do array de alunos
    j       obter_media_aluno       # Repetir loop

media_turma_calculo:
    addi    $t2, $zero, 5               # Quantidade de alunos = 5
    mtc1    $t2, $f2                    # Converter quantidade de alunos para ponto fluante (Necessário para calculo)
    cvt.s.w $f2, $f2

    div.s   $f12, $f1, $f2              # Somatoria de médias / Quantidade de alunos

    li      $v0, 4
    la      $a0, mensagem_media_turma  # Exibir mensagem informando média da turma
    syscall

    li      $v0, 2              # Exibir média da turma
    syscall

    li      $v0, 4
    la      $a0, pular_linha    # Exibir pular linha
    syscall

fim_media_turma:
    lw      $ra, 0($sp)     # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4     # Retorno do stack pointer
    jr      $ra             # Retorno da função

################################################################################
#
#                       Rotina para exibir lista de aprovados
#
################################################################################
lista_aprovados:
    addi    $sp, $sp, -4            # Reserva de endereço na pilha
    sw      $ra, 0($sp)             # Salvamento do endereço de retorno na pilha

    la      $a1, cadastros          # Carregamento do endereço inicial de todos os alunos
    lw      $t0, 0($a1)             # Verificar se existe cadastro de alunos (RA != 0)
    beq     $t0, $zero, lista_aprovados_erro

    jal     media_aluno             # Ir para calculo da média dos alunos

    li      $v0, 4
    la      $a0, mensagem_aprovados_titulo  # Mensagem de título da opção de lista de aprovados
    syscall

    li      $v0, 4
    la      $a0, mensagem_aprovados_nota    # Mensagem perguntando média minima
    syscall

    li      $v0, 6                      # Obter média minima para ser aprovado na disciplina
    syscall

    li      $v0, 4
    la      $a0, pular_linha            # Exibir pular linha
    syscall

    la      $s0, cadastros              # Carregar endereço inicial de todos os alunos
    addi    $t0, $zero, 5               # Quantidade total de alunos = 5

    j       lista_aprovados_loop        # Ir para loop de exibição de alunos aprovados

lista_aprovados_erro:
    li      $v0, 4
    la      $a0, mensagem_aprovados_erro    # Exibir mensagem de necessário cadastrar alunos antes
    syscall

    li      $v0, 4
    la      $a0, pular_linha            # Exibir pular linha
    syscall

    j       fim_lista_aprovados         # Ir para fim da função

lista_aprovados_loop:
    beq     $t0, $zero, fim_lista_aprovados # Se quantidade = 0, chegou ao fim da iteração => ir para fim da função
    l.s     $f1, 32($s0)                    # Carregar média do aluno

    c.le.s  $f0, $f1                        # Compara se média para ser aprovado é menor que a média do aluno
    bc1t    exibir_aluno_aprovado           # Se sim, aluno está aprovado

continuar_lista_aprovados_loop:
    addi    $t0, $t0, -1                    # Decrementar quantidade de alunos cadastrados
    addi    $s0, $s0, 36                    # Próxima posição do array de aluno
    j       lista_aprovados_loop            # Ir para verificação da média

exibir_aluno_aprovado:
    li      $v0, 4
    la      $a0, mensagem_aprovados_aluno_ra # Exibir mensagem informando RA do aluno
    syscall

    li      $v0, 1
    lw      $a0, 0($s0)                     # Carregar RA do aluno aprovado, para exibir
    syscall

    li      $v0, 4
    la      $a0, mensagem_aprovados_aluno_media # Exibir mensagem informando a média do aluno
    syscall

    li      $v0, 2
    mov.s   $f12, $f1                           # Exibir média do aluno aprovado
    syscall

    li      $v0, 4
    la      $a0, pular_linha                    # Exibir pular linha
    syscall
    j       continuar_lista_aprovados_loop      # Repetir loop para exibir lista de aprovados (Proximo aluno)
    
fim_lista_aprovados:
    lw      $ra, 0($sp)     # Carregamento do endereço de retorno para o registrador
    addi    $sp, $sp, 4     # Retorno do stack pointer
    jr      $ra             # Retorno da função
