; Trabalho realizdo por: Taylor Horta, João Miguel Sales e Alexandre Rimes
ORG 0

INICIO:
    LDA  SEMENTE
    ADD  #53
    STA  SEMENTE

    LDA  #7
    TRAP SEMENTE

CALCULA_RESTO:
    SUB  #20
    JNC  CALCULA_RESTO
    ADD  #20
    STA  WORD_POSITION

    SHL
    STA  OFFSET_TEMP

    LDA  VETOR_BASE_REF
    ADD  OFFSET_TEMP
    STA  PTR_TEMP
    LDA  VETOR_BASE_REF+1
    ADC  #0
    STA  PTR_TEMP+1

    LDA  @PTR_TEMP
    STA  PTR_ANSWER

    LDA  PTR_TEMP
    ADD  #1
    STA  PTR_TEMP
    LDA  PTR_TEMP+1
    ADC  #0
    STA  PTR_TEMP+1

    LDA  @PTR_TEMP
    STA  PTR_ANSWER+1

    LDA  @PTR_TEMP
    STA  PTR_ANSWER+1

    JMP  SETUP

SETUP:
    LDA  #20
    TRAP VIDEO_CONFIG
    OR   #0
    JNZ  ERRO
    LDA  #21           
    TRAP FUNDO
    OR   #0
    JNZ  ERRO
    LDA #24
    TRAP MOLD_TELA
    LDA #24
    TRAP MOLD_TELA_S
    JMP  LINHAS


READ_STRING:                ; função para leitura de string guardando o seu valor
    LDA  #3
    TRAP USER_INPUT         ; Trap já aceita endereco de memoria para guardar o valor
    JMP  CHECK_INPUT

CHECK_INPUT:

    LDA @PTR_USER
    OR  #0

    JZ  INIT_GAME           ; Rotina para resetar o ponteiro e inicar o código
    SBC #65
    JN  SHOW_ERR            ; caso o resultado der negativo, temos um caracter inválido

    LDA @PTR_USER
    SBC #91
    JP  SHOW_ERR

    LDA PTR_USER                 ; incrementando o ponteiro
    ADD #1
    STA PTR_USER

    LDA PTR_USER+1
    ADC #0
    STA PTR_USER+1

    JMP CHECK_INPUT

SHOW_ERR:
    LDA  #4
    TRAP Err_Message_Invalid_Char
    JMP  READ_STRING

INIT_GAME:
    LDA PTR_USER                 ; Decrementando o ponteiro após a checagem de carcteres
    SUB #5
    STA PTR_USER

    LDA PTR_USER+1
    SBC #0
    STA PTR_USER+1

    LDA #0
    STA CORRECT_INDEX

    JMP COMPARE

RESET_CORRECT_POSITION_STRING:

    LDA @PTR_CORRECT
    OR #0
    JZ RESET_CORRECT_POINTER

    LDA #95
    STA @PTR_CORRECT 

    LDA PTR_CORRECT
    ADD #1
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    ADC #0
    STA PTR_CORRECT+1

    JMP RESET_CORRECT_POSITION_STRING

RESET_CORRECT_POINTER:
    LDA PTR_CORRECT
    SUB #5
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    SBC #0
    STA PTR_CORRECT+1

    JMP READ_STRING


; --------------------------------------------------------- Linhas sobre a lógica do jogo

COMPARE:                        ; função para comparar caracter por caracter
    LDA @PTR_ANSWER             ; pego o primeiro valor apontado pelo ponteiro
    OR  #0         
    JZ  HEALP_COMPARE
    SBC @PTR_USER               ; Se flag 0 for ativada é a mesma letra
    JZ  CORRECT
    JMP INCREMENT

HEALP_COMPARE:
    LDA #0
    STA CORRECT_INDEX
    JMP CHECK_IF_WON

INCREMENT:

    LDA CORRECT_INDEX   
    ADD #1
    STA CORRECT_INDEX

    LDA PTR_ANSWER                 ; incrementando os ponteiros
    ADD #1
    STA PTR_ANSWER

    LDA PTR_ANSWER+1
    ADC #0
    STA PTR_ANSWER+1

    LDA PTR_USER
    ADD #1
    STA PTR_USER

    LDA PTR_USER+1
    ADC #0
    STA PTR_USER+1

    JMP COMPARE


CORRECT:

    LDA  PTR_CORRECT
    ADD  CORRECT_INDEX
    STA  PTR_CORRECT

    LDA PTR_CORRECT+1
    ADC #0
    STA PTR_CORRECT+1

    LDA  @PTR_ANSWER
    STA  @PTR_CORRECT

    LDA PTR_CORRECT
    SUB CORRECT_INDEX
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    SBC #0
    STA PTR_CORRECT+1

    JMP INCREMENT

CHECK_IF_WON:

    LDA #0
    STA WON

    LDA @PTR_CORRECT
    SBC #95
    JZ  RESET_PTR_CORRECT  ; dá um reset no ponteiro antes de pular para desenhar o boneco

    LDA #1
    STA WON

    LDA @PTR_CORRECT
    OR #0
    JZ RESET_PTR_CORRECT

    LDA PTR_CORRECT
    ADD #1
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    ADC #0
    STA PTR_CORRECT+1

    LDA CORRECT_INDEX
    ADD #1
    STA CORRECT_INDEX


    JMP CHECK_IF_WON

RESET_PTR_CORRECT:


    LDA PTR_CORRECT
    SUB CORRECT_INDEX
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    SBC #0
    STA PTR_CORRECT+1
    
    LDA #0
    STA CORRECT_INDEX
    
    JMP BONECO

FIM:
    LDA #4
    TRAP WIN_MESSAGE
    HLT

; -------------------------------------------- Dicas para o usuário ----------------------------------------------------------------------------------

PREPARE_HINT:            ; decrementando os ponteiros

    LDA PTR_USER           
    SUB #5
    STA PTR_USER

    LDA PTR_USER+1
    SBC #0
    STA PTR_USER+1

    LDA PTR_ANSWER           
    SUB #5
    STA PTR_ANSWER

    LDA PTR_ANSWER+1
    SBC #0
    STA PTR_ANSWER+1

    LDA #0
    STA HINT_INDEX

    JMP HINT_LOOP


NEW_POINTS:             ; Reset do PTR_USER e incremento do PTR_ANSWER

    LDA PTR_USER           
    SUB #5
    STA PTR_USER

    LDA PTR_USER+1
    SBC #0
    STA PTR_USER+1

    LDA PTR_ANSWER             
    ADD #1
    STA PTR_ANSWER

    LDA PTR_ANSWER+1
    ADC #0
    STA PTR_ANSWER+1

    LDA #0
    STA HINT_INDEX

    JMP HINT_LOOP

HINT_LOOP:

    LDA @PTR_USER
    OR  #0
    JZ  NEW_POINTS

    LDA @PTR_ANSWER                
    OR  #0 
    JZ  SHOW_HINT

    SBC @PTR_USER
    JZ  SAVE_HINT

    LDA PTR_USER          
    ADD #1
    STA PTR_USER

    LDA PTR_USER+1
    ADC #0
    STA PTR_USER+1

    LDA HINT_INDEX
    ADD #1
    STA HINT_INDEX

    JMP HINT_LOOP


SAVE_HINT:

    LDA PTR_HINT
    ADD HINT_INDEX
    STA PTR_HINT

    LDA PTR_HINT+1
    ADC #0
    STA PTR_HINT+1

    LDA @PTR_USER
    STA @PTR_HINT

    LDA PTR_HINT
    SUB HINT_INDEX
    STA PTR_HINT

    LDA PTR_HINT+1
    SBC #0
    STA PTR_HINT+1

    LDA PTR_USER          
    ADD #1
    STA PTR_USER

    LDA PTR_USER+1
    ADC #0
    STA PTR_USER+1


    JMP HINT_LOOP

SHOW_HINT:

    LDA  #4
    TRAP Hint_Message
    TRAP HINT_ARRAY

    LDA PTR_ANSWER           
    SUB #5
    STA PTR_ANSWER

    LDA PTR_ANSWER+1
    SBC #0
    STA PTR_ANSWER+1

    JMP  RESET_CORRECT_POSITION_STRING

LINHAS:
        LDA #23
        TRAP LINHA
        LDA ESPACAMENTO
        ADD LINHA
        STA LINHA
        LDA ESPACAMENTO
        ADD LINHA+2
        STA LINHA+2

        LDA  RESTANTES
        SUB  #1
        STA  RESTANTES
        JZ   READ_STRING
        JMP  LINHAS

BONECO:
        LDA WON
        JNZ  DESENHA_PALAVRA
        
        LDA  PARTE
        JZ   P_CABECA        
        SUB  #1
        JZ   P_CORPO         
        SUB  #1
        JZ   P_PERNA_ESQ     
        SUB  #1
        JZ   P_PERNA_DIR     
        SUB  #1
        JZ   P_BRACO_ESQ     
        SUB  #1
        JZ   P_BRACO_DIR             

P_CABECA:
        LDA  #25
        TRAP CABECA
        JMP  PROXIMA
P_CORPO:
        LDA  #23
        TRAP CORPO
        JMP  PROXIMA
P_PERNA_ESQ:
        LDA  #23
        TRAP PERNA_ESQ
        JMP  PROXIMA
P_PERNA_DIR:
        LDA  #23
        TRAP PERNA_DIR
        JMP  PROXIMA
P_BRACO_ESQ:
        LDA  #23
        TRAP BRACO_ESQ
        JMP  PROXIMA
P_BRACO_DIR:
        LDA  #23
        TRAP BRACO_DIR
        JMP DERROTA

PROXIMA:
        LDA  PARTE
        ADD  #1
        STA  PARTE
        JMP  DESENHA_PALAVRA
A:
        LDA #5
        STA HASTE_DIAG+2
        STA HASTE_DIAG_2+2   ; ajustes do tamanho da diagonal pra nao escapar da linha
        LDA X_OFFSET
        STA HASTE_DIAG_2
        ADD HASTE_DIAG_2+2
        STA HASTE_DIAG_2+2
        LDA HASTE_DIAG_2+2
        STA HASTE_DIAG
        ADD HASTE_DIAG+2
        STA HASTE_DIAG+2

        LDA HASTE_DIAG_2+2
        ADD #2
        STA HASTE_HOR
        LDA HASTE_DIAG
        SUB #2
        STA HASTE_HOR+2
        
        LDA #23
        TRAP HASTE_HOR
        LDA #23
        TRAP HASTE_DIAG_2
        LDA #23
        TRAP HASTE_DIAG

        JMP NORMALIZACAO

E: 
        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_HOR 
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        
        LDA #23
        TRAP HASTE_VERT
        LDA #23 
        TRAP HASTE_HOR
    
        LDA HASTE_VERT+1
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR

        LDA HASTE_VERT+3
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR

        JMP NORMALIZACAO

F:
        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_HOR 
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        
        LDA #23
        TRAP HASTE_VERT
        LDA #23 
        TRAP HASTE_HOR

        LDA HASTE_VERT+3
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR

        JMP NORMALIZACAO

H:
        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_HOR 
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        
        LDA #23
        TRAP HASTE_VERT
        LDA #23 
        TRAP HASTE_HOR

        LDA HASTE_HOR+2
        STA HASTE_VERT
        STA HASTE_VERT+2
        LDA #23
        TRAP HASTE_VERT

        JMP NORMALIZACAO

I:
        LDA X_OFFSET
        STA HASTE_HOR
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        LDA HASTE_VERT+3
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR
         
        LDA HASTE_HOR+2
        SUB #5              ; metade do espaço total ocupado por qualquer caractere
        STA HASTE_VERT
        STA HASTE_VERT+2
        LDA #23
        TRAP HASTE_VERT
        
        LDA HASTE_VERT+1
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR

        JMP NORMALIZACAO

L:
        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_HOR
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        LDA #23
        TRAP HASTE_VERT
    
    
        LDA HASTE_VERT+1
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR

        JMP NORMALIZACAO




N:
        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_DIAG
        ADD HASTE_DIAG+2
        STA HASTE_DIAG+2
        LDA #23
        TRAP HASTE_VERT

        LDA #23
        TRAP HASTE_DIAG

        LDA HASTE_DIAG+2
        STA HASTE_VERT
        STA HASTE_VERT+2
        LDA #23
        TRAP HASTE_VERT

        JMP NORMALIZACAO
O: 
        LDA X_OFFSET
        STA RETANGULO
        LDA HASTE_VERT+3
        STA RETANGULO+1
        LDA #24
        TRAP RETANGULO
 
        JMP NORMALIZACAO

T:
        LDA X_OFFSET
        STA HASTE_HOR
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        LDA HASTE_VERT+3
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        LDA #23
        TRAP HASTE_HOR
         
        LDA HASTE_HOR+2
        SUB #5             ; metade do espaço total ocupado por qualquer caractere
        STA HASTE_VERT
        STA HASTE_VERT+2
        LDA #23
        TRAP HASTE_VERT

        JMP NORMALIZACAO

U: 
        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_HOR 
        ADD HASTE_HOR+2
        STA HASTE_HOR+2
        LDA HASTE_VERT+1
        STA HASTE_HOR+1
        STA HASTE_HOR+3
        
        LDA #23
        TRAP HASTE_VERT
        LDA #23 
        TRAP HASTE_HOR

        LDA HASTE_HOR+2
        STA HASTE_VERT
        STA HASTE_VERT+2
        LDA #23
        TRAP HASTE_VERT

        JMP NORMALIZACAO

V:
        LDA #5
        STA HASTE_DIAG_2+2
        STA HASTE_DIAG+2   ; ajustes do tamanho da diagonal pra nao escapar da linha
        LDA X_OFFSET
        STA HASTE_DIAG
        ADD HASTE_DIAG+2
        STA HASTE_DIAG+2
        
        STA HASTE_DIAG_2
        ADD HASTE_DIAG_2+2
        STA HASTE_DIAG_2+2

       
        LDA #23
        TRAP HASTE_DIAG
        LDA #23
        TRAP HASTE_DIAG_2

        JMP NORMALIZACAO

M: 
        LDA #5
        STA HASTE_DIAG_2+2
        STA HASTE_DIAG+2   ; ajustes do tamanho da diagonal pra nao escapar da linha

        LDA X_OFFSET
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_DIAG
        ADD HASTE_DIAG+2
        STA HASTE_DIAG+2
        
        STA HASTE_DIAG_2
        ADD HASTE_DIAG_2+2

        STA HASTE_DIAG_2+2
        LDA #23
        TRAP HASTE_VERT

        LDA HASTE_DIAG_2+2
        STA HASTE_VERT
        STA HASTE_VERT+2
        LDA #23
        TRAP HASTE_VERT
       
        LDA #23
        TRAP HASTE_DIAG

        LDA #23
        TRAP HASTE_DIAG_2

        JMP NORMALIZACAO

NORMALIZACAO:      ;rotina pra retornar os valores das retas para o padrão
        LDA #0
        STA HASTE_VERT
        STA HASTE_VERT+2
        STA HASTE_DIAG
        STA HASTE_DIAG_2
        STA HASTE_HOR

        LDA #10
        STA HASTE_DIAG+2
        STA HASTE_DIAG_2+2
        STA HASTE_HOR+2

        LDA #53
        STA HASTE_HOR+1
        STA HASTE_HOR+3

        JMP INCREMENT_CORRECT_PTR

DESENHA_PALAVRA:
    
    LDA @PTR_CORRECT
    OR #0
    JZ RESETAR_PONT
    LDA @PTR_CORRECT
    STA CARAC       ; Carrega o caracter
    JMP DESENHA_LETRA
    
    
INCREMENT_CORRECT_PTR: 

    LDA PTR_CORRECT
    ADD #1
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    ADC #0
    STA PTR_CORRECT+1

    LDA X_OFFSET
    ADD #20
    STA X_OFFSET

    LDA CORRECT_INDEX
    ADD #1
    STA CORRECT_INDEX
    JMP DESENHA_PALAVRA
        
RESETAR_PONT:

    LDA PTR_CORRECT
    SUB CORRECT_INDEX
    STA PTR_CORRECT

    LDA PTR_CORRECT+1
    SBC #0
    STA PTR_CORRECT+1
    
    LDA #19
    STA X_OFFSET

    LDA #0
    STA CORRECT_INDEX

    LDA WON
    OR #0
    JZ PREPARE_HINT
    JMP FIM

DESENHA_LETRA:           ; rotina para desenhar uma letra a partir do seu código ASCII
        LDA CARAC
        XOR #65          ; A
        JZ  A
        LDA CARAC
        XOR #69          ; E
        JZ  E
        LDA CARAC
        XOR #70          ; F
        JZ  F
        LDA CARAC
        XOR #72          ; H
        JZ  H
        LDA CARAC
        XOR #73          ; I
        JZ  I
        LDA CARAC
        XOR #76          ; L
        JZ  L
        LDA CARAC
        XOR #77          ; M
        JZ  M
        LDA CARAC
        XOR #78          ; N
        JZ  N
        LDA CARAC
        XOR #79          ; O
        JZ  O
        LDA CARAC
        XOR #84          ; T
        JZ  T
        LDA CARAC
        XOR #85          ; U
        JZ  U
        LDA CARAC
        XOR #86          ; V
        JZ  V
        JMP  INCREMENT_CORRECT_PTR

ERRO:   OUT  0
        HLT

DERROTA:
        LDA PTR_ANSWER
        SUB #5
        STA PTR_ANSWER
        LDA PTR_ANSWER+1
        SBC #0
        LDA PTR_ANSWER+1
        LDA #4
        TRAP DEFEAT_MESSAGE   
        LDA #4
        TRAP @PTR_ANSWER
        HLT


ORG 2000

OFFSET_TEMP:   DB 0
PTR_TEMP:      DW 0
VETOR_BASE_REF: DW VETOR_PALAVRAS

WON:  DB  1
ENTER: STR "\n"

WORD_POSITION: DB 0

STR_VELHA: STR "VELHA"
DB 0
STR_TELHA: STR "TELHA"
DB 0
STR_FILHA: STR "FILHA"
DB 0
STR_FALHA: STR "FALHA"
DB 0
STR_LINHA: STR "LINHA"
DB 0
STR_VINHO: STR "VINHO"
DB 0
STR_FILME: STR "FILME"
DB 0
STR_MENTE: STR "MENTE"
DB 0
STR_LENTO: STR "LENTO"
DB 0
STR_FEITO: STR "FEITO"
DB 0
STR_HOMEM: STR "HOMEM"
DB 0
STR_ONTEM: STR "ONTEM"
DB 0
STR_METAL: STR "METAL"
DB 0
STR_VITAL: STR "VITAL"
DB 0
STR_HOTEL: STR "HOTEL"
DB 0
STR_TOTAL: STR "TOTAL"
DB 0
STR_FUNIL: STR "FUNIL"
DB 0
STR_MUITO: STR "MUITO"
DB 0
STR_ELITE: STR "ELITE"
DB 0
STR_FATAL: STR "FATAL"
DB 0

VETOR_PALAVRAS:
    DW STR_VELHA, STR_TELHA, STR_FILHA, STR_FALHA, STR_LINHA
    DW STR_VINHO, STR_FILME, STR_MENTE, STR_LENTO, STR_FEITO
    DW STR_HOMEM, STR_ONTEM, STR_METAL, STR_VITAL, STR_HOTEL
    DW STR_TOTAL, STR_FUNIL, STR_MUITO, STR_ELITE, STR_FATAL

TOTAL_PALAVRAS: DB 20
SEMENTE:        DB 13


USER_INPUT:         DS   5 
DB                  0
PTR_ANSWER:         DW  VETOR_PALAVRAS
PTR_USER:           DW  USER_INPUT
PTR_CORRECT:        DW  CORRECT_POSITION
PTR_HINT:           DW  HINT_ARRAY
PTR_DEBUG:          DW  CORRECT_POSITION
FREQ:               DW  440
CORRECT_POSITION:   DB  95,95,95,95,95
DB                  0
HINT_ARRAY:         DB  95,95,95,95,95
DB                  0
CORRECT_INDEX:      DB  0  ; Adicionar os caracteres corretos nas posições corretas
HINT_INDEX:         DB  0  ; Adicionar os caracteres corretos nas posições corretas


Err_Message_Invalid_Char:    STR   "\nValido apenas letras em CAPSLOCK" 
DB                  0
Hint_Message:                STR   "\nTais letras estão na resposta, não necessariamente nessa ordem e nem nessa quantidade: "
DB                  0

WIN_MESSAGE:                 STR   "\nParabéns! Você venceu!"
DB                  0
DEFEAT_MESSAGE:              STR    "\nPoxa! Você perdeu... A palavra era "
DB                  0

VIDEO_CONFIG: DW 16384  
FUNDO:        DB 10        
LINHA:        DB 16, 60, 32, 60, 255
ESPACAMENTO:  DB 20
RESTANTES:    DB 5
CABECA:       DB 24, 12, 7, 255, 0
CORPO:        DB 24, 20, 24, 36, 255
PERNA_ESQ:    DB 24, 36, 16, 44, 255
PERNA_DIR:    DB 24, 36, 32, 44, 255
BRACO_ESQ:    DB 24, 22, 16, 30, 255
BRACO_DIR:    DB 24, 22, 32, 30, 255
MOLD_TELA:    DB 0, 0, 128, 64, 2, 0
MOLD_TELA_S:  DB 1, 1, 127, 63, 1, 0

PARTE:        DB 0

X_OFFSET:     DB 19
HASTE_VERT:   DB 0, 58, 0, 48, 0
HASTE_DIAG:   DB 0, 48, 10, 58, 0
HASTE_DIAG_2: DB 0, 58, 10, 48, 0
HASTE_HOR:    DB 0, 53, 10, 53, 0 
RETANGULO:    DB 0, 0, 10, 10, 0, 0

CARAC: DB 0