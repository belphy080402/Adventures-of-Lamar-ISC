##################################################################
#  Adventures of Lamar - Projeto final de ISC                    #
#  2020/2			  			         #
##################################################################
# Por favor, comente o codigo com clareza


.data

#=============================================SOUNDTRACK==============================================================================
#Jenova(tamanho:76)
JENOVA: 36,357,36,357,36,357,40,1071,36,357,36,357,36,357,41,1071,36,357,36,357,36,357,42,357,41,357,40,357,41,357,40,357,38,357,40,714,38,357,36,357,36,357,36,357,40,1071,36,357,36,357,36,357,41,1071,36,357,36,357,36,357,42,357,41,357,40,357,41,357,40,357,38,357,40,714,38,357,40,357,40,357,40,357,42,1071,40,357,40,357,40,357,45,1071,40,357,40,357,40,357,46,357,45,357,42,357,45,357,42,357,41,357,42,714,41,357,40,357,40,357,40,357,42,1071,40,357,40,357,40,357,45,1071,40,357,40,357,40,357,46,357,45,357,42,357,45,357,42,357,41,357,42,714,41,357

#Costa del sol(tamanho: 17)
FF17_COSTA_DEL_SOL:60,1282,67,513,65,256,67,2052,60,1282,71,513,68,256,67,2052,60,1282,67,513,68,256,69,2052,60,1282,72,513,71,256,69,2052,60,2052

#amongus(tamanho: 31) 
AMONGUS: 36,638,72,319,76,319,77,319,78,319,77,319,76,319,72,638,60,319,71,159,74,159,72,638,60,319,31,319,36,638,72,319,76,319,77,319,78,319,77,319,76,319,78,638,60,638,78,212,77,212,76,212,78,212,77,0,77,212,76,0,76,212

#Zelda(tamanho:97)
ZELDA: 60,652,55,978,60,326,60,163,62,163,64,163,65,163,67,1630,67,326,67,163,69,163,71,326,72,1630,72,326,72,163,71,163,69,326,71,489,69,163,67,1304,67,652,65,326,65,163,67,163,69,1304,67,326,65,326,64,326,64,163,65,163,67,1304,65,326,64,326,62,326,62,163,64,163,66,1304,70,652,67,326,55,163,55,163,55,326,55,163,55,163,55,326,55,163,55,163,55,326,55,326,60,652,55,978,60,326,60,163,62,163,64,163,65,163,67,1630,67,326,67,163,69,163,71,326,72,1956,76,652,74,652,73,1304,67,652,69,1956,72,652,73,652,67,1304,67,652,69,1956,72,652,73,652,67,1304,64,652,65,1956,69,652,67,652,64,1304,60,652,62,326,62,163,64,163,66,1304,70,652,67,326,55,163,55,163,55,326,55,163,55,163,55,326,55,163,55,163,55,326,55,326

#Kingdom Hearts(tamanho:68)
KH: 81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,84,682,84,227,83,682,83,227,88,682,88,227,86,113,88,113,86,455,86,227,84,682,84,227,83,682,83,227,81,682,81,227,79,682,79,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,84,682,84,227,83,682,83,227,88,682,88,227,86,113,88,113,86,455,86,227,84,682,84,227,83,682,83,227,81,682,81,227,88,682,88,227
#=====================================================================================================================================

# personagem para teste
.include "./Imagens/lamaresq.data"
.include "./Imagens/lamaresq_walk.data"
.include "./Imagens/lamardir.data"
.include "./Imagens/lamardir_walk.data"
.include "./Imagens/lamarbaixo.data"
.include "./Imagens/lamarbaixo_walk.data"
.include "./Imagens/lamarcima.data"
.include "./Imagens/lamarcima_walk.data"

#Transi�ao
.include "./Imagens/Transicao1.data"
.include "./Imagens/Transicao2.data"
.include "./Imagens/Transicao3.data"
.include "./Imagens/Transicao4.data"
.include "./Imagens/Transicao5.data"

# mapa para teste
.include "./Imagens/MAPA1.data"

# macro para o menu funcional
.include "menu.s"

# chao para preencher onde o personagem estava
.include "./Imagens/meiochao.data"

.text
#macros
.include "macro.s"
.include "midi.s"
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
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
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
	ImpressaoF(Transicao1, 0xFF100000, 0, TROCA_FRAMEI)	#tela de transiçao com informaçoes da fase e senha
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
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
Andapersonagem()

#FASE2




#===============================MUSICAS=====================================
MUSICA1:
	play_musica(68, 0, KH)
	jr s5

MUSICA2:
	play_musica(97, 47, ZELDA)
	jr s5

	
MUSICA_RESET:
	reset()	#reseta a musica
	jr s5	
			
.include "SYSTEMv21.s"
