.macro Menu

.data
# imagem inicial do menu
.include "menu1.data"

# imagem final do menu
.include "menu2.data"

# botoes de start e password
.include "menu3.data"

# imagem da seta que aparece ao lado dos botoes
.include "seta.data"

.text
# Prepara os endereços para printar o menu na tela
MENU_I:
la t0, menu1
lw t1, 0(t0)
lw t2, 4(t0)
mul t3, t1,t2
addi t0, t0, 8
li t4, 0
li s0, 0xFF000000

# Printa o menu de 4 em 4 pixels
PRINTA_MENU:
beq t4,t3, MENU_F
lw t5, 0(t0)
sw t5, 0(s0)
addi t0, t0, 4
addi s0, s0, 4
addi t4, t4, 4
j PRINTA_MENU


# Prepara os enderecos para printar a segunda parte do menu
MENU_F:
la t0, menu2
lw t1, 0(t0)
lw t2, 4(t0)
mul t3, t1,t2
addi t0, t0, 8
li t4, 0
li s0, 0xFF000000

# Pausa de 1 segundo para mostrar o resto do titulo
li a7, 32
li a0, 1000
ecall

# Printa a segunda parte do menu
PRINTA_MENUF:

beq t4,t3, MUSICA
lw t5, 0(t0)
sw t5, 0(s0)
addi t0, t0, 4
addi s0, s0, 4
addi t4, t4, 4
j PRINTA_MENUF

MUSICA:

# Prepara os endereços para printar a segunda parte do menu
MENU_TXT:
la t0, menu3
lw t1, 0(t0) 		#Pega as dimensoes da imagem
lw t2, 4(t0)
mul t3, t1,t2 		#Quantidade total de pixels
addi t0, t0, 8
li t4, 0
li s0, 0xFF000000


# Printa a segunda parte do menu
PRINTA_MENU_TXT:

beq t4,t3, SETA 	# Pula para a seta caso tenha terminado o menu
lw t5, 0(t0)
sw t5, 0(s0)
addi t0, t0, 4
addi s0, s0, 4
addi t4, t4, 4
j PRINTA_MENU_TXT


SETA:
la t0, seta
lw t1, 0(t0)
lw t2, 4(t0)
mul t3, t1, t2
addi t0, t0, 8
li t4, 0
li t6, 19		# Largura x da seta, vai ser usada pra pular linhas.
li s1, 0xFF00BF98 	# Endereco onde comeca a imprimir a seta.

# So para nao esquecer como funciona:
# Para imprimir uma imagem em um lugar especifico, preciso da posicao x e y
# de onde ela vai comecar. Entao conto quantos pixels a imagem tem ate aquele
# ponto. No caso da resolucao 320x240, seria 320 * (y - 1). Depois somo com o x,
# que e quantos pixels a mais na proxima linha sao necessarios pra chegar na
# posicao inicial.
IMPRIME_SETA:
beq t4, t3, FIM
lb t5, 0(t0)
sb t5, 0(s1)
addi t0, t0, 1
addi s1, s1, 1
addi t4, t4, 1
bge t4, t6, PULA_LINHA_SETA
j IMPRIME_SETA

# Essa parte e usada para pular para a proxima linha. No caso da seta, ela tem 19px de largura
# portanto queremos que apos imprimir 19 pixels ele pule pra linha seguinte.
# Para isso, compara a quantidade de pixels ja impressos com t6, se forem iguais, aumenta 
# t6 em 19 (em preparacao pra proxima linha), e soma a diferenca entre 320 e a largura da imagem,
# que no caso e 0x12D, para mostrar a posicao da qual vai comecar na linha seguinte.
PULA_LINHA_SETA:
addi t6, t6, 19
addi s1,s1, 0x12D
j IMPRIME_SETA

FIM:
.end_macro
