##################################################################
#  Adventures of Lamar - Projeto final de ISC                    #
#  2020/2			  			         #
##################################################################
# Por favor, comente o codigo com clareza



.data


#Transiçao
.include "./Imagens/TransiçaoI.data"
.include "./Imagens/TransiçaoII.data"
.include "./Imagens/TransiçaoIII.data"
.include "./Imagens/TransiçaoIV.data"
.include "./Imagens/TransiçaoV.data"

# personagem para teste
.include "./Imagens/lamaresq.data"
.include "./Imagens/lamaresq_walk.data"
.include "./Imagens/lamardir.data"
.include "./Imagens/lamardir_walk.data"
.include "./Imagens/lamarbaixo.data"
.include "./Imagens/lamarbaixo_walk.data"
.include "./Imagens/lamarcima.data"
.include "./Imagens/lamarcima_walk.data"

# mapa para teste
.include "./Imagens/MAPA1.data"



# chao para preencher onde o personagem estava
.include "./Imagens/meiochao.data"

#macros
.include "macro.s"

# macro para o menu funcionar
.include "menu.s"

.text
.include "MACROSv21.s"


MENU:
Frame(0)		#sempre vai estar no frame 0
Menu()





VALIDADOR_SENHA:
	lw s5, 0xFF20000C 	#carrega display do KDMMIO, quarta letra
	#----------------------------------------------------------------#
	
	li s7, 5				#lamar começa com 5 de vida(s7) usando uma password
	
	#Primeira fase(senha: abba)
PRIMEIRA_FASE_SENHA:	
	senha(97, 98, 98, 97,SEGUNDA_FASE_SENHA, IMPRESSAO_MAPA1) #se senha correta imprime fase 1
	#Segunda fase(senha: lmao)		
SEGUNDA_FASE_SENHA:	
	senha(108, 109, 97, 111, TERCEIRA_FASE_SENHA, IMPRESSAO_MAPA2)	#se senha correta imprime fase 2	
	#Terceira fase(senha: dudu)	
TERCEIRA_FASE_SENHA:
	#senha(100, 117, 100, 117, QUARTA_FASE_SENHA, IMPRESSAO_MAPA3)	#se senha correta imprime fase 3
	#Quarta fase(senha: pokd)
QUARTA_FASE_SENHA:				
	#senha(112, 111, 107, 100, QUINTA_FASE_SENHA, IMPRESSAO_MAPA4)	#se senha correta imprime fase 4
	#Quinta fase(senha: dend)
QUINTA_FASE_SENHA:
	#senha(100, 101, 110, 100, SENHA_INCORRETA, IMPRESSAO_MAPA5)	#se senha correta imprime fase 5
	
SENHA_INCORRETA:	
	ret    #retorna para PASSWORD, senha incorreta	
	
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

#verificador de fase
li t0, 1
beq s2, t0, IMPRESSAO_MAPA1	#vai para a primeira fase
li t0, 2
beq s2, t0, IMPRESSAO_MAPA2	#vai para a segunda fase
#=================================FASES=============================



#FASE1
MAIN:
IMPRIME_FASE1:	
	#ImpressaoF(TransiçaoI, 0xFF100000, 0, TROCA_FRAMEI)	#tela de transiçao com informaçoes da fase e senha
	TROCA_FRAMEI:
		Frame(1)
		Delay(5000)
	IMPRESSAO_MAPA1:
		li s2, 1	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA1, 0xFF000000, 0xFF100000, 0, VIDA)


IMPRIME_PERSONAGEM1:
Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT1)

NEXT1:
Andapersonagem()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#FASE2
IMPRIME_FASE2:	
	ImpressaoF(TransiçaoII, 0xFF100000, 0, TROCA_FRAMEII)	#tela de transiçao com informaçoes da fase e senha
	TROCA_FRAMEII:
		Frame(1)
		Delay(5000)
	IMPRESSAO_MAPA2:
		li s2, 2	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA1, 0xFF000000, 0xFF100000, 0, VIDA)


IMPRIME_PERSONAGEM2:
Imprimepersonagem(0xFF008520, 0xFF108520, NEXT1)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.include "SYSTEMv21.s"
