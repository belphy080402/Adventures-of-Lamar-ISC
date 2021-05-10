##################################################################
#  Adventures of Lamar - Projeto final de ISC                    #
#  2020/2			  			         #
##################################################################
# Por favor, comente o codigo com clareza


.data

# personagem para teste
.include "./Imagens/lamaresq.data"
.include "./Imagens/lamaresq_walk.data"
.include "./Imagens/lamardir.data"
.include "./Imagens/lamardir_walk.data"
.include "./Imagens/lamarbaixo.data"
.include "./Imagens/lamarbaixo_walk.data"
.include "./Imagens/lamarcima.data"
.include "./Imagens/lamarcima_walk.data"

#Transiçao
.include "./Imagens/TransiçaoI.data"
.include "./Imagens/TransiçaoII.data"
.include "./Imagens/TransiçaoIII.data"
.include "./Imagens/TransiçaoIV.data"
.include "./Imagens/TransiçaoV.data"

# mapa para teste
.include "./Imagens/MAPA1.data"

# macro para o menu funcional
.include "menu.s"

# chao para preencher onde o personagem estava
.include "./Imagens/meiochao.data"

.text
#macros
.include "macro.s"
.include "MACROSv21.s"

MENU:
Frame(1) #sempre vai estar no frame 0
Menu()


#=================================VIDAS=============================
VIDA:
li t0, 5
beq s7, t0, VIDA_5		#se lamar tiver 5 de vida, printa 5
li t0, 4
beq s7, t0, VIDA_4		#se lamar tiver 4 de vida, printa 4
li t0, 3
beq s7, t0, VIDA_3		#se lamar tiver 3 de vida, printa 3
li t0, 2
beq s7, t0, VIDA_2		#se lamar tiver 2 de vida, printa 2
li t0, 1
beq s7, t0, VIDA_1		#se lamar tiver 1 de vida, printa 1
beq s7, zero, VIDA_0		#se lamar tiver 0 de vida, printa 0


VIDA_5:
vida_lamar(5, IMPRIME_PERSONAGEM1)

VIDA_4:
vida_lamar(4, IMPRIME_PERSONAGEM1)

VIDA_3:
vida_lamar(3, IMPRIME_PERSONAGEM1)

VIDA_2:
vida_lamar(2, IMPRIME_PERSONAGEM1)

VIDA_1:
vida_lamar(1, IMPRIME_PERSONAGEM1)

VIDA_0:
vida_lamar(0, IMPRIME_PERSONAGEM1)


VIDA_DIMINUI:
li t0, 1
sub s7, s7, t0				#sempre que lamar morrer diminui -1 de vida(s8)
blt s7, zero, MENU

#-------------verificador de fase---------
#s2 determina a fase que lamar esta
li t0, 1
beq s2, t0, IMPRESSAO_MAPA1	#vai para a primeira fase
li t0, 2
#beq s2, t0, IMPRESSAO_MAPA2	#vai para a segunda fase

#=================================FASES=============================
#FASE1
MAIN:
IMPRIME_FASE1:	
	ImpressaoF(TransiçaoI, 0xFF100000, 0, TROCA_FRAMEI)	#tela de transiÃ§ao com informaÃ§oes da fase e senha
	TROCA_FRAMEI:
		Frame(1)
		Delay(5000)
		ImpressaoF(MAPA1, 0xFF000000, 0, IMPRESSAO_MAPA1) #impressao no frame 0 para nao mostrar o mapa ser imprimido
		
		IMPRESSAO_MAPA1:
		Frame(0)
		li s2, 1	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA1, 0xFF000000, 0xFF100000, 0, VIDA)


IMPRIME_PERSONAGEM1:
Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT1)

NEXT1:
Andapersonagem()

#FASE2

.include "SYSTEMv21.s"
