.macro Menu

.data
# imagem inicial do menu
.include "menu1.data"

# imagem final do menu
.include "menu2.data"

# botoes de start e password
.include "menu3.data"

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


# Prepara os endereços para printar a segunda parte do menu
MENU_F:
la t0, menu2
lw t1, 0(t0)
lw t2, 4(t0)
mul t3, t1,t2
addi t0, t0, 8
li t4, 0
li s0, 0xFF000000

# Pausa de 1 segundo para mostrar o resto do título
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
lw t1, 0(t0) #Pega as dimensões da imagem
lw t2, 4(t0)
mul t3, t1,t2 #Quantidade total de pixels
addi t0, t0, 8
li t4, 0
li s0, 0xFF000000


# Printa a segunda parte do menu
PRINTA_MENU_TXT:

beq t4,t3, FIM
lw t5, 0(t0)
sw t5, 0(s0)
addi t0, t0, 4
addi s0, s0, 4
addi t4, t4, 4
j PRINTA_MENU_TXT

FIM:
.end_macro
