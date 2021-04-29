###########################################
#                                         #
#             	MACROS GERAIS             #
#                                         #
###########################################




###########################################
#                                         #
#             Imprimir imagens            #
#                                         #
###########################################

.macro Impressao(%data, %hex, %time, %funçao)
#%data = arquivo.data a ser imprimido
#%hex = endereço inicial de print/frame----> 0xFF000000, endereço inicial no frame 0	
#%time = Pausa em milissegundos para mostrar a imagem,caso coloque zero,não havera pausa
#%funçao = nome de funçao para se seguir assim que a imagem for por completo imprimida
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hex  	#endereço inicial de print/frame
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME:
	beq t4, t3, %funçao		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME	
.end_macro
#==================================================================================================================

