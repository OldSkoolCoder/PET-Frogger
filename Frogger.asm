
; 10 SYS (1280)

*=$0401

    BYTE    $0E, $04, $0A, $00, $9E, $20, $28,  $31, $32, $38, $30, $29, $00, $00, $00


*   = $0500
; $00 - $01 = Moves Cars
; $02 - $03 = Frog Location
; $04       = Number Of Rows
; $06       = Last Character Under Frog
; $07       = Delay No. (Hi = Slow, Low = Fast)
; $08       = Number Of Frogs crossed
; $09       = Number To Be Added to Score
; $0A       = Number Of Characters Across
; $0B       = Flag For Hi Score
; $0C       = Is Number Of Lives

MovesCars       = $00
FrogLocation    = $02
NumberOfRows    = $04
LastCharacter   = $06
DelayNumber     = $07
FrogsCrossed    = $08
ScoreToAdd      = $09
NumberOfChars   = $0A
FlaggedHiScore  = $0B
NumberOfLives   = $0C
LastKeyPressed  = $0D

    jmp GAMESTART

MOVESC
    ldx #$00
    ldy #$78
    sty MovesCars
    ldy #$26
    lda #$80
    sta MovesCars + 1

MOVE
    lda (MovesCars),y
    iny
    sta (MovesCars),y
    dey
    lda #$20
    sta (MovesCars),y
    dey
    cpy #$FF
    bne MOVE
    ldy #$27
    lda (MovesCars),y
    ldy #$00
    sta (MovesCars),y
    ldy #$27
    clc
    lda MovesCars
    adc #$78
    sta MovesCars
    bcc CROSS
    inc MovesCars + 1

CROSS
    inx
    ldy #$26
    cpx #6
    bne MOVE
    lda #$80
    sta MovesCars + 1
    lda #$A0
    sta MovesCars
    ldy #0
    ldx #0

MOVE1
    iny
    lda (MovesCars),y
    dey
    sta (MovesCars),y
    iny
    lda #$20
    sta (MovesCars),y
    dey
    iny
    cpy #$27
    bne MOVE1
    ldy #0
    lda (MovesCars),y
    ldy #$27
    sta (MovesCars),y
    ldy #0
    clc
    lda MovesCars
    adc #$78
    sta MovesCars
    bcc CROSS1
    inc MovesCars + 1

CROSS1
    inx
    ldy #0
    cpx #06
    bne MOVE1

PRITSC
    ldx #0
REPLACE
    lda $4600,x
    sta $8030,x
    lda $4610,x
    sta $8042,x
    inx
    cpx #7
    bne REPLACE
    rts

TEXT_CLEARSCREEN 
    TEXT "{clear}{down*2}"
    ;BYTE $11,$11
    BRK

TEXT1
    ;BYTE $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
    TEXT "{cm +*40}"
    ;BYTE $1D,$5B,$D1,$D1,$D1,$D1,$3E,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$5B,$D1,$D1,$D1,$D1,$3E,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$5B,$D1,$D1,$D1,$D1,$D1,$3E,$1D,$1D,$1D,$1D,$1D
    TEXT "{right}[QQQQ>{right*8}[QQQQ>{right*7}[QQQQ>{right*5}"
    ;BYTE $1D,$1D,$1D,$1D,$1D,$1D,$3C,$D1,$D1,$D1,$D1,$5D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$3C,$D1,$D1,$D1,$D1,$5D,$1D,$1D,$1D,$3C,$D1,$D1,$D1,$D1,$5D,$1D,$1D,$1D,$1D,$1D
    TEXT "{right*6}<QQQQ]{right*8}<QQQQ]{right*4}<QQQQ]{right*5}"
    brk  

TEXT2
    ;BYTE $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$D7,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
    TEXT "{cm +*19}W{cm +*20}"
    ;BYTE $20,$20,$20,$20,$20,$28,$43,$29,$20,$4E,$4F,$56,$45,$4D,$42,$45,$52,$20,$31,$39,$38,$33,$20,$42,$59,$20,$44,$41,$4C,$45,$53,$D3,$46,$54,$1D,$1D,$1D,$1D,$1D,$1D
    TEXT "{space*5}(c) november 1983 by dalesSft{right*6}"
    ;BYTE $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$57,$52,$49,$54,$54,$45,$4E,$20,$42,$59,$20,$4A,$4F,$48,$4E,$20,$43,$2E,$20,$44,$41,$4C,$45,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
    TEXT "{right*8}written by john c. dale{right*9}"
    brk

LIVETT
    ;BYTE $13,$53,$55,$43,$43,$45,$53,$53,$46,$55,$4C,$20,$43,$52,$4F,$53,$53,$49,$4E,$47,$53,$20,$3D,$20,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
    TEXT "{home}successful crossings = {right*17}"
    ;BYTE $53,$43,$4F,$52,$45,$20,$3D,$20,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$48,$49,$20,$3D,$20,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$4C,$56,$3A
    TEXT "score = {right*13}hi = {right*10}lv:"
    brk

PRINTSC
    ldx #0
    ldy #0

LK
    lda TEXT_CLEARSCREEN,y
    cmp #0
    beq PRINT
    jsr $FFD2
    iny
    jmp LK
    
PRINT
    ldy #0

LK2
    lda TEXT1,y
    cmp #0
    beq PRINT1
    JSR $FFD2
    iny
    jmp LK2

PRINT1
    inx
    cpx #6
    bne PRINT
    ldy #0

LK3
    lda TEXT2,y
    cmp #0
    beq PRINT2
    JSR $FFD2
    iny
    jmp LK3

PRINT2
    ldx FrogsCrossed

LIVES
    cpx #0
    beq PRINT3
    cpx #$11
    beq PRINT4
    lda #1
    sta FrogsCrossed
    
PRINT4
    lda #$57
    sta $8017,x
    dex
    cpx #0
    bne LIVES

PRINT3
    ldy #0
    
PRLIVE
    lda LIVETT,y
    cmp #0
    beq FINLIV
    jsr $FFD2
    iny
    jmp PRLIVE

FINLIV
    lda NumberOfLives
    clc
    adc #$30
    sta $804F
    rts

DATA
    BYTE 0, 1, 255

    BYTE 0, 1, 255

    BYTE 0, 1, 255

    BYTE 0, 1, 255

    BYTE 0, 1, 255

    BYTE 0, 1, 255

    brk

GAMESTART
    lda #0
    sta FrogsCrossed
    sta FlaggedHiScore
    sta LastKeyPressed
    jsr INSTR

START
    lda #$20
    sta FrogLocation
    lda #0
    sta FrogsCrossed
    lda #$83
    sta FrogLocation + 1
    ldy #$13
    lda #$66
    sta LastCharacter
    lda #$12
    sta NumberOfRows
    lda #$30
    sta DelayNumber
    lda #0
    sta FrogsCrossed
    lda #$57
    sta (FrogLocation),y
    ;lda FlaggedHiScore
    ldx #$07

CLEAR
    lda #$30
    sta $4600,x
    ldy FlaggedHiScore
    cpy #$FF
    beq CLNEXT
    sta $4610,x
    ;sta $4610
    tay
    lda #3
    sta NumberOfLives
    tya
    ldy #$13

CLNEXT
    dex
    cpx #255
    bne CLEAR
    ;sta $4600
    jsr PRINTSC
    ldy #$13

KEY
    lda $97
    cmp #$FF
    bne KEY1

DELAY
    sta LastKeyPressed
    tya
    pha
    jsr MOVESC
    ldx DelayNumber

DEL1
    ldy #$FF

DEL
    dey
    bne DEL
    dex
    bne DEL1
    pla
    tay
    jmp AUTMVE

KEY1
    cmp LastKeyPressed
    BEQ DELAY
    tax
    lda LastCharacter
    sta (FrogLocation),y
    txa
    cmp #52
    bne RIGHT
    dey
    cpy #$FF
    bne CORR
    iny

CORR
    jmp PLACE

RIGHT
    cmp #54
    bne UP
    iny
    cpy #$28
    bne CORR1
    DEY

CORR1
    jmp PLACE
    jmp PLACE

UP
    cmp #83
    beq UP1
    lda #$57
    sta (FrogLocation),y
    jmp DELAY

UP1
    lda #1
    ldx #5
    stx ScoreToAdd
    sta NumberOfChars
    jsr SCORE
    lda FrogLocation
    sec
    sbc #$28
    sta $02
    bcs CORR2
    dec FrogLocation + 1

CORR2
    sec
    dec NumberOfRows
    lda NumberOfRows
    cmp #0
    bne PLACE
;pla
;pla
    jmp FROG

PLACE
    lda (FrogLocation),y
    sta LastCharacter
    jmp CHECK

PLACE2
    lda #87
    sta (FrogLocation),y
    jmp DELAY
    rts

CHECK
    lda LastCharacter
    cmp #102
    bne CHECK1
    jmp PLACE2

CHECK1
    cmp #81
    bne CHECK2
    jmp PLACE2

CHECK2
    ;jmp PLACE2

    jmp YRDD

AUTMVE
    ldx NumberOfRows
    lda DATA,x
    cmp #0
    beq RETURN
    cmp #$FF
    bne AUTRIG
    dey
    cpy #0
    bne RETURN
    jmp YRDD

AUTRIG
    iny
    cpy #$28
    bne RETURN
    jmp YRDD

RETURN
    jmp KEY

YRDDTX
    ;BYTE $13,$1D,$1D,$1D,$1D,$1D,$12,$59,$4F,$55,$27,$52,$45,$20,$44,$45,$41,$44,$21,$21,$20,$59,$4F,$55,$20,$57,$41,$53,$20,$53,$57,$41,$4D,$50,$45,$44
    TEXT "{home}{right}{right}{right}{right}{right}{reverse on}you're dead!! you was swamped"
    brk

YRDD
    lda #$2A
    sta (FrogLocation),y
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr FILLSC

AGAIN
    lda YRDDTX,y
    cmp #0
    beq GAMEOV
    jsr $FFD2
    iny
    jmp AGAIN

GAMEOV
    lda #0
    sta $9E
    jsr PRITSC
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    dec NumberOfLives
    lda NumberOfLives
    cmp #0
    beq GOV
    lda #$FF
    sta FlaggedHiScore
    jmp START1

GOV
    jmp GOVER

FROGTXT
    ;BYTE $13,$1D,$1D,$1D,$1D,$1D,$1D,$12,$43,$4F,$4E,$47,$52,$41,$54,$55,$4C,$41,$54,$49,$4F,$4E,$53,$20,$59,$4F,$55,$20,$4D,$41,$44,$45,$20,$49,$54
    TEXT "{home}{right}{right}{right}{right}{right}{right}{reverse on}congratulations you made it"
    BRK

FROG
    inc FrogsCrossed
    jsr FILLSC

FROG1
    lda FROGTXT,y
    cmp #0
    beq FROG2
    jsr $FFD2
    iny
    jmp FROG1

FROG2
    jsr SCORE
    jsr PRITSC
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jsr DELAY1
    jmp NEXTFR

FILLSC
    lda #$50
    sta $11
    lda #$80
    sta $12

FILL
    ldy #0
    lda #$66
    sta ($11),y
    lda $11
    clc
    adc #1
    sta $11
    lda $12
    adc #0
    sta $12
    cmp #$84
    bne FILL
    ldx #4
    lda #5
    sta NumberOfChars
    stx ScoreToAdd
    lda #$13
    jsr $FFD2
    jsr PRINT2
    ldy #0
    rts

NEXTFR
    lda DelayNumber
    sec
    sbc #3
    sta DelayNumber

START1
    lda #$20
    sta FrogLocation
    lda #$83
    sta FrogLocation + 1
    jsr PRINTSC
    jsr MOVESC
    lda #$66
    sta LastCharacter
    lda #$57
    ldy #$13
    sta (FrogLocation),y
    lda #$12
    sta NumberOfRows
    jmp KEY

DELAY1
    ldx #$FF

DELA1
    ldy #$FF

DELA
    dey
    bne DELA
    dex
    bne DELA1
    rts

SCORE
    pha
    txa
    pha
    tya
    pha
    ldx ScoreToAdd
    lda NumberOfChars
    clc
    adc $4600,x
    sta $4600,x

SCORE1
    lda $4600,x
    cmp #$3A
    bcs UPDATE

PULL
    pla
    tay
    pla
    tax
    pla
    rts

UPDATE
    lda #$30
    sta $4600,x
    dex
    inc $4600,x
    jmp SCORE1

GOVER
    ldy #0

GOVER1
    lda OVER,y
    cmp #0
    beq GOVER2
    jsr $FFD2
    iny
    jmp GOVER1

GOVER2
    jsr $FFCF
    cmp #$59
    bne GOVER3
    jsr HISC
    lda #$FF
    sta FlaggedHiScore
    lda #0
    sta FrogsCrossed
    lda #3
    sta NumberOfLives
    jmp START

GOVER3
    jsr INSTR
    jsr HISC
    lda #$FF
    sta FlaggedHiScore
    lda #3
    sta NumberOfLives
    jmp START

HISC
    lda #0

HISC2
    lda $4600,x
    clc
    cmp $4610,x
    beq NOT
    bcs HISC1

NOT
    inx
    cpx #7
    bne HISC2
    rts

HISC1
    lda $4600,x
    sta $4610,x
    inx
    cpx #7
    bne HISC1
    rts

OVER
    ;BYTE $93,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$44,$4F,$20,$59,$4F,$55,$20,$57,$41,$4E,$54,$20,$20,$41,$4E,$4F,$54,$48,$45,$52,$20,$47,$4F,$20,$3F,$1D
    TEXT "{clear}{right}{right}{right}{right}{right}{right}{right}do you want  another go ?{right}"
    brk

INSTR
    lda #<INSTXT
    sta $11
    lda #>INSTXT
    sta $12
    ldy #0

INSTR2
    lda ($11),y
    cmp #0
    beq INSTR1
    jsr $FFD2
    clc
    lda $11
    adc #1
    sta $11
    lda $12
    adc #0
    sta $12
    jmp INSTR2

INSTR1
    lda $97
    cmp #$FF
    beq INSTR1
    lda #0
    sta FlaggedHiScore
    rts

INSTXT
    ;BYTE $93,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$50,$45,$54,$20,$46,$52,$4F,$47,$47,$45,$52,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
    TEXT "{clear}{right*14}pet frogger{right*15}"
    ;byte $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$B8,$B8,$B8,$20,$B8,$B8,$B8,$B8,$B8,$B8,$B8,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
    TEXT "{right*14}{cm u*3} {cm u*7}{right*15}"
    TEXT "{right*4}(c) november 1983 by dalesSft{right*7}{down*2}"
    TEXT "all you have to do is to get as many of{right}"
    TEXT "the frogs across the river without{right*6}"
    TEXT "drowning them. you have to leap onto a{right*2}"
    TEXT "boat like this :- <QQQ] and land on the{right}"
    TEXT "seats ('Q'). you get 10 points for every"
    TEXT "jump forward and 500 points every time{right*2}"
    TEXT "you get a frog across the river{right*9}"
    TEXT "{down*3}the controls are:-{right*22}"
    TEXT "{right*17}s = up{right*17}"
    TEXT "{down}{right*2}4 = left{right*18}6 = right{right*2}"
    TEXT "{down*2}{reverse on}{right*6}hit  a key to start the game{right*6}"
    brk