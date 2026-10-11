
ORG 600

USER_INPUT:         DS   5 
DB                  0
ANSWER:             STR "PEDRO"
DB                  0
PTR_ANSWER:         DW  ANSWER
PTR_USER:           DW  USER_INPUT
PTR_CORRECT:        DW  CORRECT_POSITION
PTR_HINT:           DW  HINT_ARRAY
FREQ:               DW  440
CORRECT_POSITION:   DB  95,95,95,95,95
DB                  0
HINT_ARRAY:         DB  95,95,95,95,95
DB                  0
CORRECT_INDEX:      DB  0  ; Adicionar os caracteres corretos nas posições corretas
HINT_INDEX:         DB  0  ; Adicionar os caracteres corretos nas posições corretas


Err_Message_Invalid_Char:    STR   "\nValido apenas letras em CAPSLOCK" 
DB                  0
Hint_Message:                STR   "\nTais letras estão na resposta: "
DB                  0

ORG 0

; ------------------------------------------------------ Validacao de dados

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

; --------------------------------------------------------- Linhas sobre a lógica do jogo

COMPARE:                    ; função para comparar caracter por caracter
    LDA @PTR_ANSWER                ; pego o primeiro valor apontado pelo ponteiro
    OR  #0         
    JZ  PREPARE_HINT
    SBC @PTR_USER               ; Se flag 0 for ativada é a mesma letra
    JZ  CORRECT
    JMP  WRONG


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
    LDA #2
    TRAP @PTR_ANSWER

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

WRONG:
    LDA #6
    TRAP FREQ
    JMP INCREMENT

FIM:
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

    JMP  READ_STRING