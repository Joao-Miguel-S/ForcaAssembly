ORG 0
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
        JZ   BONECO
        JMP  LINHAS

BONECO:
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
        JMP  FIM             

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

PROXIMA:
        LDA  PARTE
        ADD  #1
        STA  PARTE
        JMP  M
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
        JMP             ; caractere desconhecido

FIM:    LDA  #0
ERRO:   OUT  0
        HLT

ORG 0x600
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

X_OFFSET:     DB 20
HASTE_VERT:   DB 0, 58, 0, 48, 0
HASTE_DIAG:   DB 0, 48, 10, 58, 0
HASTE_DIAG_2: DB 0, 58, 10, 48, 0
HASTE_HOR:    DB 0, 53, 10, 53, 0 
RETANGULO:    DB 0, 0, 10, 10, 0, 0

CARAC: DB 0


END SETUP