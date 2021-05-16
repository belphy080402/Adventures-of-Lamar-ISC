###########################################
#                                         #
#             	MACROS GERAIS             #
#                                         #
###########################################



.macro Frame(%frame)
li a5, 0xFF200604	#Carrega o endereÃ§o responsÃ¡vel pela troca de frame
li t0, %frame		
sw t0, 0(a5)		#sempre vai comeÃ§ar no frame 0	
.end_macro


.macro Delay(%time)
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
.end_macro


.macro Trocaframe(%delay)

#Delay antes de trocar o frame
li a7, 32	
li a0, %delay
ecall

li a5, 0xFF200604	#Carrega o endereço responsável pela troca de frame
lw t1, 0(a5)		#Carrega-o em t1 para manipular
xori t1, t1, 0x001 	#Inverte o valor atual
sw t1, 0(a5)		#Armazena de volta em a5 o valor invertido
.end_macro
 

###########################################
#                                         #
#             Imprimir imagens            #
#                                         #
###########################################
# Todos os macros de impressão imprimem a imagem nos dois frames, separados em xxxx_F0 e xxxx_F1
# para evitar que algo seja impresso apenas em um e cause flickering na imagem.



.macro Impressao(%data, %hexf0, %hexf1, %time, %funçao)
#%data = arquivo.data a ser imprimido
#%hex = endereço inicial de print/frame----> 0xFF000000, endereço inicial no frame 0.
#a diferença entre hexf0 e hexf1 deve ser apenas o FF0 / FF1.	
#%time = Pausa em milissegundos para mostrar a imagem,caso coloque zero,não havera pausa
#%funçao = nome de funçao para se seguir assim que a imagem for por completo imprimida

F0:				#imprime a imagem no frame 0
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf0  	#endereço inicial de print no frame 0
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, F1		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME_F0
	
F1:				#imprime a imagem no frame 1
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf1  	#endereço inicial de print no frame 1
	

#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, %funçao		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME_F1		
.end_macro

#--------------------------------------------------------------#
#imprime apenas em um frame, acaba sendo mais rapido
.macro ImpressaoF(%data, %hex, %time, %funçao)
#%data = arquivo.data a ser imprimido
#%hex = endereÃ§o inicial de print/frame----> 0xFF000000, endereÃ§o inicial no frame 0	
#%time = Pausa em milissegundos para mostrar a imagem,caso coloque zero,nÃ£o havera pausa
#%funçao = nome de funçao para se seguir assim que a imagem for por completo imprimida
	la t0, %data		#endereÃ§o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hex  	#endereÃ§o inicial de print/frame
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#JÃ¡ com a imagem carregada, ocorre impressao nesse loop	
IMPRIME:
	beq t4, t3, %funçao		#quando finalizar, pula para a funÃ§Ã£o desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME	
.end_macro


#--------------------------------------------------------------#
.macro ImpressaopequenaF(%data, %hexf0, %time, %pula, %funcao)
#Imprime apenas no frame 0
#Mesma fun?o, mas feita para imprimir imagens de tamanho espec?ico em um lugar
#espec?ico da tela.
#%pula = valor em hex de quantos pixels se deve pular para come?r a imprimir
# na pr?ima linha.

#-------------------------------FRAME 0---------------------------------#
F0:
    la t0, %data        #endere? de imagem
    lw t1, 0(t0)         #x(linhas)
    lw t2, 4(t0)         #y(colunas)
    lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
    mul t3, t1, t2        #numero total de pixels
    addi t0, t0, 8        #Primeiro pixel
    li t4, 0        #contador
    li s0, %hexf0          #endere? inicial de print no frame 0
    
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall    
    
#J? com a imagem carregada, ocorre impressao nesse loop    
IMPRIME_F0:
    beq t4, t3, %funcao        #quando finalizar, pula para a fun?o desejada
    lb t5, 0(t0)
    sb t5, 0(s0)
    addi t0, t0, 1
    addi s0, s0, 1    
    addi t4, t4, 1
    beq t4, t6, PULA_F0        #quando chegar ao final de uma linha, pula para a seguinte    
    j     IMPRIME_F0
    
    PULA_F0:
    add t6, t6, t1            #incrementa o numero de pixels impressos pelo n de linhas para o pr?imo beq ainda pular linha.
    addi s0, s0, %pula
    j IMPRIME_F0    
    
.end_macro

#==============================================================================================================
.macro Impressaopequena(%data, %hexf0, %hexf1, %time, %pula, %funçao)
#Mesma função, mas feita para imprimir imagens de tamanho específico em um lugar
#específico da tela.
#Lembre-se que hexf0 e hexf1 devem ser iguais, salvo o bit que indica o frame: FF"0" ou FF"1"
#%pula = valor em hex de quantos pixels se deve pular para começar a imprimir
# na próxima linha.

#-------------------------------FRAME 0---------------------------------#
F0:
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf0  		#endereço inicial de print no frame 0
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, F1		#quando finalizar, pula para a função desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o próximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F0	
	
#-------------------------------FRAME 1---------------------------------#	
F1:	
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf1  		#endereço inicial de print no frame 1
	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, %funçao		#quando finalizar, pula para a função desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o próximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F1		
.end_macro
#---------------------------------------------------------------------#
.macro ImpressaopequenaC(%data, %hexf0, %hexf1, %time, %pula, %funçao)
#Mesma função, mas feita para imprimir imagens de tamanho específico em um lugar
#específico da tela.
#Lembre-se que hexf0 e hexf1 devem ser iguais, salvo o bit que indica o frame: FF"0" ou FF"1"
#%pula = valor em hex de quantos pixels se deve pular para começar a imprimir
# na próxima linha.

#-------------------------------FRAME 0---------------------------------#
F0:
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            	#armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0			#contador
	mv s0, %hexf0  		#endereço inicial de print no frame 0
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, F1		#quando finalizar, pula para a função desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o próximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F0	
	
#-------------------------------FRAME 1---------------------------------#	
F1:	
	la t0, %data		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	mv s0, %hexf1  		#endereço inicial de print no frame 1
	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, %funçao		#quando finalizar, pula para a função desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o próximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F1		
.end_macro

#---------------------------------------------------------------------#
.macro apaga_cor(%hex, %largura, %total_pixels, %cor, %pula, %funçao)
#%hex = endereço inicial de print/frame----> 0xFF000000, endereço inicial no frame 0	
#total_pixel = quantidade total de pixel a serem imprimidos(largura x altura)
#%cor = cor em hexadecimal a ser imprimida
#%pula = valor em hex de quantos pixels se deve pular para começar a imprimir 
#%funçao = nome de funçao para se seguir assim que a imagem for por completo imprimida
APAGA_:
	li t1, %hex			# carrega o endereco inicial
	li t2, %total_pixels		# quantidade total de pixels a imprimir(X * Y)
	li t3, %cor	        	# cor desejada em hexadecimal
	li t4, 0			# contador de pixels
	li t6, %largura			# contador para pular linha
	
LOOP_APAGA:	beq t4, t2, %funçao			# imprime a seta de baixo quando apagar a de cima
		beq t4, t6, PULA_LINHA_APAGA	# pula linha quando chegou no final dos pixel
		sb t3, 0(t1)				# preenche o pixel com a cor
		addi t4, t4, 1				
		addi t1, t1, 1
		j LOOP_APAGA

PULA_LINHA_APAGA:
		addi t6, t6, %largura
		addi t1, t1, %pula
		j LOOP_APAGA
.end_macro


###########################################
#                                         #
#            	Andar		          #
#                                         #
###########################################
# e preciso guardar o endereco inicial do frame onde o personagem esta em um registrador que nao vai
# ser utilizado por mais nada. Assim podemos usar ele para imprimir o chao quando o personagem andar
# e atualizar esse registrador com o novo endereco do personagem.
# Para isso vou fazer um macro separado so para imprimir o personagem.

.macro Imprimepersonagem(%hexf0, %hexf1, %funçao)

#-------------------------------FRAME 0---------------------------------#
IMPRIMEPER_F0:
	la t0, lamardir		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s10, %hexf0		#armazena o endereco inicial separadamente para preencher o chao quando o personagem andar.
	li s0, %hexf0  		#endereço inicial de print/frame

	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, COMPENSA_F0		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o próximo beq ainda pular linha.
	addi s0, s0, 0x130
	j IMPRIME_F0

#Tira 8 pixels que já serão somados em "APAGA", isso evita que ele dê um pulo de
#8 pixels na primeira vez que anda e deixa metade da primeira sprite sem apagar.
COMPENSA_F0:
addi s10, s10, -8

#-------------------------------FRAME 1---------------------------------#
IMPRIMEPER_F1:
	la t0, lamardir		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li a4, %hexf1		#armazena o endereco inicial separadamente para preencher o chao quando o personagem andar. // EQUIVALENTE AO S10
	li a3, %hexf1  		#endereço inicial de print/frame // EQUIVALENTE AO S0

	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, COMPENSA_F1		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(a3)
	addi t0, t0, 4
	addi a3, a3, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o próximo beq ainda pular linha.
	addi a3, a3, 0x130
	j IMPRIME_F1

#Tira 8 pixels que já serão somados em "APAGA", isso evita que ele dê um pulo de
#8 pixels na primeira vez que anda e deixa metade da primeira sprite sem apagar.
COMPENSA_F1:
addi a4, a4, -8

.end_macro

###################################################################
###################################################################

# O s9 é necessário para manipular os valores da impressão do personagem fora de s10. 
# Tentei usar somente o s10, onde o endereço inicial do personagem é armazenado diretamente, 
# mas fazer manipulações direto nele causa problemas. O ideal é que s10 apenas guarde os 
# valores atualizados.

.macro Apagachao(%dir)
# %dir é o valor que vai ser somado ou subtraído do endereço inicial para apagar o lolo anterior e definir a 
# próxima posição dele.
#-------------------------------FRAME 0---------------------------------#
APAGA_F0:
	la t0, meiochao		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	addi s9, s10, 8		#guarda em s9 o endereço em que deve começar a apagar

APAGA_IMPRIME_F0:
	bge t4, t3, NOVOVAL_F0		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(s9)
	addi t0, t0, 4
	addi s9, s9, 4	
	addi t4, t4, 4
	beq t4, t6, APAGA_PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	APAGA_IMPRIME_F0
	
	APAGA_PULA_F0:
	addi t6, t6, 16			#incrementa o numero de pixels impressos em 16 para o próximo beq ainda pular linha.
	addi s9, s9, 0x130		
	j APAGA_IMPRIME_F0

NOVOVAL_F0:
	
	li t5, %dir
	add s10, s10, t5		# Passa o endereço incial que vai ser apagado %dir pixels para a direção que vai andar

#-------------------------------FRAME 1---------------------------------#
APAGA_F1:
	la t0, meiochao		#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	addi a2, a4, 8		#guarda em s9 o endereço em que deve começar a apagar

APAGA_IMPRIME_F1:
	bge t4, t3, NOVOVAL_F1		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(a2)
	addi t0, t0, 4
	addi a2, a2, 4	
	addi t4, t4, 4
	beq t4, t6, APAGA_PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	APAGA_IMPRIME_F1
	
	APAGA_PULA_F1:
	addi t6, t6, 16			#incrementa o numero de pixels impressos em 16 para o próximo beq ainda pular linha.
	addi a2, a2, 0x130		
	j APAGA_IMPRIME_F1

NOVOVAL_F1:
	
	li t5, %dir
	add a4, a4, t5		# Passa o endereço incial que vai ser apagado %dir pixels para a direção que vai andar

.end_macro

###################################################################
###################################################################

.macro Anda(%sprite)
# %sprite pede a sprite da direção em que a instrução está levando o personagem
# "lamardir", "lamaresq", "lamarcima", "lamarbaixo" ou seus correspondentes do frame 1 para animar.

# %INC pula de volta para receber o input do teclado, no geral vamos tentar usar sempre INC mesmo,
# mas é preciso incluir toda vez.

#-------------------------------FRAME 0---------------------------------#
ANDA_F0:
	la t0, %sprite	#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, 0  		#endereço inicial de print/frame da proxima posicao do personagem
	add s9, s10, zero	#armazena em s9 o endereço em que o personagem deve ser impresso
	add s0, s0, s9		#passa o endereço para s0, de forma a não manipular diretamente no s9
	addi s0, s0, 8		#soma 8 pixels no endereco inicial, que e a quantidade que o personagem anda
	
	
#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, FIMF0			#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o próximo beq ainda pular linha.
	addi s0, s0, 0x130
	j IMPRIME_F0
FIMF0:		 

#-------------------------------FRAME 1---------------------------------#	
	ANDA_F1:
	la t0, %sprite	#endereço de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li a2, 0  		#endereço inicial de print/frame da proxima posicao do personagem
	add a3, a4, zero	#armazena em s9 o endereço em que o personagem deve ser impresso
	add a2, a2, a3		#passa o endereço para s0, de forma a não manipular diretamente no s9
	addi a2, a2, 8		#soma 8 pixels no endereco inicial, que e a quantidade que o personagem anda
	

#Já com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, FIMF1		#quando finalizar, pula para a função desejada
	lw t5, 0(t0)
	sw t5, 0(a2)
	addi t0, t0, 4
	addi a2, a2, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o próximo beq ainda pular linha.
	addi a2, a2, 0x130
	j IMPRIME_F1

FIMF1:	
.end_macro

###################################################################
###################################################################

#==================================================================================================================
###########################################
#                                         #
#            	SENHA		          #
#                                         #
###########################################
.macro senha(%primeira, %segunda, %terceira, %quarta, %funçao, %funçao_de_acerto)
#em ordem os valores sao armazendas em s2, s3, s4, s5.
#com seus respectivos valores em ASCII
#%funçao sereve para pular para proxima posibilidade de senha caso essa esteja errada
#%funçao_de_acerto = funçao que vai se seguir caso esteja certa a senha
	
	li t0, %primeira			
	beq s2, t0, SEG_LETRA
	j	%funçao
	
	SEG_LETRA:
	li t0, %segunda                         
	beq s3, t0, TER_LETRA
	j	%funçao
	
	TER_LETRA:
	li t0, %terceira			
	beq s4, t0, QUA_LETRA
	j	%funçao
	
	QUA_LETRA:
	li t0, %quarta				
	beq s5, t0, %funçao_de_acerto
	j	%funçao
.end_macro	


###########################################
#                                         #
#            Print screen	          #
#                                         #
###########################################
.macro print_int_screen(%r, %x, %y, %cor, %frame)
li a0, %r		# Int a ser impresso
li a1, %x		# Coluna
li a2, %y		# Linha
li a3, %cor
li a4, %frame		# Define o frame em que será impresso
li a7, 101		# PrintInt
ecall
.end_macro

.macro vida_lamar(%vida, %funçao)
print_int_screen(%vida, 263, 35, 100, 0)
print_int_screen(%vida, 263, 35, 100, 1)
j %funçao
.end_macro

.macro poder_lamar(%power,%funçao)
print_int_screen(%power, 263, 80, 100, 0)
print_int_screen(%power, 263, 80, 100, 1)
j %funçao
.end_macro
