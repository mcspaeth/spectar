				;; $0006-0007		= Table pointer
				;; $000e-000f		= Screen loc pointer
				;; $0014-0015		= String loc pointer

				;; $001a				= SPRVAL
				;; $001c				= SPR1H
				;; $001d				= SPR1V
				;; $0022				= SPR2H
				;; $0023				= SPR2V

				;; $006c				= ??
				;; $0076				= Current player level?
				;; $00a0				= Half credits
				;; $00a1				= Credits (goes to coinage screen immediately)
				;; $00ae				= Audio1 store?
				;; $00a7				= Status D7 = Game
				;; $00ab				= ??
				;; $00ae				= ??
				;; $00af				= ??

				;; $00bd-00be		= Current player score
				;; $00bf				= current player

				;; $00e0-00ff		= Not used?

L0100		= $0100									; ??
L0101		= $0101									; ??
L0102		=	$0102									; Attract mode cycle (1-9)?
				
L0110		= $0110									; (5 bytes) BCD string buffer
L0111		= $0111									; ??
L0141		= $0141									; ??
				
L0200		= $0200									; ??
L0202		= $0202									; ??
L0208		=	$0208									; ??
				
L0252		= $0252									; ??
L0254		= $0254									; ??
L0256		= $0256									; ??
L0257		= $0257									; ??
L025c		= $025c									; ??
L025b		= $025b									; ??
L0262		= $0262									; ??
L0264		= $0264									;	??
L0266		= $0266									; ??
L0267		= $0267									; ??

L0303		= $0303									; ??
L0316		= $0316									; ??
L0317		= $0317									; ??
L0330		= $0330									; ??
L0350		= $0350									; ??
L0352		= $0352									; ??

L033f		= $033f									; ??
L0351		= $0351									; ??
L03e0		= $03e0									; ??
L03e1		= $03e1									; ??
L03ef		= $03ef									; ??
L03e8		= $03e8									; ??
L03f0		= $03f0									; ??
L03f8		= $03f8									; ??


				.org		$0000
				.db			$ff

				.org		$1000
LRESET:
L1000:
				sei													; Disable interrupts
				ldx			#$ff
				txs													; Set stack pointer
L1004:
				lda			$5103								; Interrupt condition
				dex
				bmi			L1004								; Loop

				cld
				lda			#$00
				sta			$a0									; Half coins
				sta			$a1									; Credits
L1011:
				sta			$a7

				;; Write interupt vector
				ldx			#$00
				lda			L3fa9, x
				sta			$fffe
				inx
				lda			L3fa9, x
				sta			$ffff

				lda			#$10
				sta			$5200								; Audio1
				cli													; Enable interrupts
				jsr			L2453								; Write characte ram and ??
				jsr			L110c								; Startup screen and delay
				
				lda			#$00
				sta			$0102
				sta			$ab
				sta			$6c
				sta			$bd
				sta			$be
				sta			$ae
				sta			$025b
				lda			#$ff
				sta			$5201								; Audio2
				sta			$6c
				sta			$0252
				sta			$0262
				lda			#$10
				sta			$af
				jsr			L29f6								; Init P1 values (?)
				jsr			L29fb								; Init P2 values (?)
				jmp			L157e

L105a:
				sei													; Disable interrupts
				ldx			#$ff
				txs													; Set stack pointer
				cli
				jsr			L2453								; Write characte ram and ??

				lda			#$00
				sta			$bd
				sta			$be
				sta			$dc
				sta			$dd
				sta			$1b
				sta			$2f
				sta			$76
				lda			#$01
				sta			$bf
				sta			$c3
				lda			#$24
				sta			$74
				jsr			L2d71
				lda			#$0a
				sta			$b1
				jsr			L29f6								; Init P1 values (?)
				jsr			L29fb								; Init P2 values (?)
				jsr			L14a5
				jsr			L258b
L108f:
				jsr			L1182
				jsr			L11cd
L1095:
				jsr			L10c4
				jsr			L2470
				jsr			L13ce
				jsr			L215a
				jsr			L260f
				lda			$74
				bne			L10ab
				jmp			L1238
L10ab:
				lda			$3e
				and			#$10
				beq			L10b8
				lda			$2f
				bne			L10b8
				jmp			L1238
L10b8:
				lda			$30
				and			#$02
				beq			L1095
				jsr			L132f
				jmp			L108f
L10c4:
				jsr			L1d70
				jsr			L1c92
				jsr			L1da7
				jsr			L1fe9
				jsr			L1e02
				jsr			L20cc
				jsr			L10dd
				jsr			L2649
				rts

L10dd:
				lda			$31
				bne			L10e2

				rts

L10e2:
				jsr			L1e47
				ldy			#$00
				lda			($66), y
				cmp			#$e8
				beq			L10f1
				cmp			#$20
				bne			L10f4
L10f1:
				jmp			L1eb2
L10f4:
				jsr			L1fdb
				bcs			L1109
				lda			$2a
				cmp			$66
				bne			L1105
				lda			$2b
L1101:
				cmp			$67
				beq			L1109
L1105:
				lda			#$21
				sta			($66), y
L1109:
				jmp			L1fca

				;; Startup screen
L110c:
				jsr			L2e25										; Clear screen
				ldx			#$12										; Length
L1111:
				lda			L1139, x								; String loc
				sta			$4044, x								; Screen loc
				dex
				bpl			L1111										; Loop

				ldx			#$15										; Length
L111c:
				lda			L114d, x								; String loc
				sta			$4084, x								; Screen loc
				dex
				bpl			L111c										; Loop

				lda			#$80
				sta			$4f44
				jsr			L2d50										; Delay

				;; Easter egg
				ldx			#$1e										; Length
L112f:
				lda			L1163, x								; String loc
				sta			$4104, x								; Screen loc
				dex
				bpl			L112f										; Loop
				rts

L1139:
				.db			"SPECTAR  VER  2 ",$e8,"0  "

L114d:
				.db			"RELEASED MAR  2 1981  "

L1163:
				.db			"PROGRAMMED BY MANUEL J CAMPOS  "

L1182:
				ldy			$C3
				bne			L1188
				ldy			#$01
L1188:
				dey
				tya
				asl			a
				tay
				jsr			L2e78

				lda			#$4b
				sta			$43
				ldy			#$16
				jsr			L2e7c
				lda			#$4c
				sta			$43
				ldy			#$12
				jsr			L2e7c
				lda			#$4e
				sta			$43
				ldy			#$14
				jsr			L2e7c

				;; Copy custom per-level maze chars
				lda			$76									; Current level?
				and			#$0f
				asl			a										; a*2
				tax

				;; Copy table address to ($0e-0f)
				lda			L3f89, x							
				sta			$0e
				inx
				lda			L3f89, x
				sta			$0f

				ldy			#$1f									; Loop counter
L11bd:
				lda			($0e), y
				sta			$4dd0, y							; Chars $ba-bd
				dey
				bpl			L11bd								; Loop

				bit			$a7									; Status
				bpl			L11cc								; In attract
				jsr			L13b0
L11cc:
				rts

L11cd:
				lda			#$41
				sta			$0f
				lda			#$28
				sta			$0e
				lda			#$00
				sta			$48
				lda			$a7
				and			#$04
				beq			L11ee
				lda			#$24
				sec
				sbc			$74
				sta			$48
				lda			#$40
				sta			$0f
				lda			#$e8
				sta			$0e
L11ee:
				lda			$74
				sta			$87
				dec			$87
				lda			#$00
				sta			$74
				sta			$72
				sta			$70
				sta			$73
				lda			#$06
				sta			$86
L1202:
				jsr			L1217
				lda			$0e
				clc
				adc			#$60
				sta			$0e
				lda			#$00
				adc			$0f
				sta			$0f
				dec			$86
L1214:
				bne			L1202
				rts
L1217:
				ldy			#$00
				ldx			#$06
L121b:
				lda			($0e), y
				cmp			#$20
				bne			L1231
				dec			$48
				bpl			L1231
				bit			$87
				bmi			L1231
				lda			#$e8
				sta			($0e), y
				dec			$87
				inc			$74
L1231:
				iny
				iny
				iny
				dex
				bne			L121b
				rts
L1238:
				lda			#$f0
				ora			$1a
				sta			$1a
				jsr			L2d59
				lda			#$10
				sta			$5200								; Audio1
				ldx			$bf
				dex
				jsr			L29fd
				lda			#$ee
				sta			$1a
				jsr			L2389
				inc			$76
				lda			#$24
				sta			$74
				jsr			L258b
				ldy			#$00
				lda			$bf
				cmp			#$01
				beq			L1266
				ldy			#$02
L1266:
				lda			#$00
				jsr			L227e
				dec			$28
				bpl			L1273
				lda			#$00
				sta			$28
L1273:
				lda			#$00
				sta			$3e
				lda			#$0a
				sta			$b1
				jmp			L108f
L127e:
				lda			#$10
				sta			$5200								; Audio1
				lda			#$ee
				sta			$1a
				jsr			L2d59
				lda			$a7
				and			#$03
				bne			L129f
L1290:
				lda			$a7
				and			#$fb
				sta			$a7
				jsr			L2453								; Write characte ram and ??
				jsr			L2ba6
				jmp			L157e
L129f:
				lda			$5100
				eor			#$ff
				and			#$04
				bne			L1307
				bit			$a7
				bvs			L1290
				jsr			L2e25										; Clear screen
				lda			$a7
				and			#$03
				sta			$bf
				beq			L1290
				lda			$bf
				and			#$02
				asl			a
				and			#$04
				sta			$00
				lda			$a7
				and			#$fb
				ora			$00
				sta			$a7
				jsr			L2460
				jsr			L2453										; Write characte ram and ??
				ldy			#$00
				lda			#$12										; EXTENDED PLAY FOR PLAYER _
				jsr			L2b00										; Draw language string a
				lda			#$13										; TOPPING HIGH SCORE
				jsr			L2b00										; Draw language string a
				lda			$a7
				and			#$04
				beq			L12ea
				lda			$bf
				ora			#$30
				sta			$41e2
				jmp			L12f1
L12ea:
				lda			$bf
				ora			#$30
				sta			$421d
L12f1:
				jsr			L2d53
				jsr			L2d53
				lda			$a7
				ora			#$40
				sta			$a7
				lda			$bf
				lsr			a
				tax
				jsr			L29d5
				jmp			L1238
L1307:
				jsr			L2e25										; Clear screen
				jsr			L26ad

				;; Add bonus credit?
				sed
				clc
				lda			$a1											; Credits
				adc			#$01
				sta			$a1											; Credits
L1315:
				cld

				lda			#$14										; EXTRA CREDIT
				jsr			L2b00										; Draw language string a
				lda			#$15										; FOR TOPPING HIGH SCORE
				jsr			L2b00										; Draw language string a
				jsr			L2d53
				jsr			L26ad
				jsr			L27ef
				jsr			L2d53
				jmp			L1290
L132f:
				lda			#$10
				jsr			L2269
				lda			#$ff
				sta			$65
				lda			#$ee
				sta			$1a
				jsr			L2bd2
				lda			$2f
				sta			$b1
				lda			$3e
				and			#$10
				bne			L1351
				lda			$80
				asl			a
				clc
				adc			$2f
				sta			$b1
L1351:
				lda			$c0
				cmp			#$02
				bne			L1387
				lda			$bf
				cmp			#$01
				beq			L1371
				lda			#$01
				sta			$bf
				lda			$a7
				and			#$fb
				sta			$a7
				jsr			L29fb								; Init P2 values (?)
				jsr			L29ce
				lda			$c1
				bne			L138e
L1371:
				lda			#$02
				sta			$bf
				lda			$a7
				ora			#$04
				sta			$a7
				jsr			L2460
				jsr			L29f6								; Init P1 values (?)
				jsr			L29d3
				jmp			L138a
L1387:
				jsr			L29f6								; Init P1 values (?)
L138a:
				lda			$c1
				beq			L13ad
L138e:
				jsr			L2e25								; Clear screen
				jsr			L2453								; Write characte ram and ??
				jsr			L14a5
				jsr			L258b
				lda			$b1
				lsr			a
				adc			#$00
				bne			L13a3
				lda			#$01
L13a3:
				sta			$80
				lda			#$00
				sta			$3e
				jsr			L1182
				rts
L13ad:
				jmp			L127e

				;; Done at start of new level in attract
L13b0:
				lda			#$ff
				sta			$65
				sta			$6c
				sta			L13f2
				sta			$5201								; Audio2
				lda			#$90
				sta			$a3
				sta			$5200								; Audio1
				lda			#$00
				sta			$a4
				sta			$a9
				sta			$64
				sta			$70
				rts

L13ce:
				jsr			L1402
				lda			$1b
				bne			L13e4
				bit			$6c
				bpl			L13e8
				bit			$a4
				bpl			L13f2
				rts
L13de:
				lda			#$df
				jsr			L2264
				rts
L13e4:
				lda			#$0f
				sta			$6c
L13e8:
				lda			#$20
				jsr			L2269
				dec			$6c
				bmi			L13de
				rts
L13f2:
				lda			#$02
				jsr			L2269
				dec			$a4
				bmi			L13fc
				rts
L13fc:
				lda			#$fd
				jsr			L2264
				rts
L1402:
				lda			$70
				beq			L140e
				lda			#$00
				sta			$a9
				lda			#$04
				sta			$72
L140e:
				lda			$72
				beq			L1415
				jmp			L148c
L1415:
				bit			$65
				bmi			L1450
				dec			$a9
				bpl			L148b
				ldx			$65
				lda			#$05
				sta			$a9
				lda			L34a1, x
				cmp			#$ff
				beq			L1430
				sta			$5201										; Audio2
				inc			$65
				rts
L1430:
				lda			#$ff
				sta			$65
				sta			$5201										; Audio2
				rts
L1438:
				dec			$a9
				bpl			L148b
				lda			$64
				and			#$03										; Mask 2 LSBs 
				tax
				lda			#$15
				sec
				sbc			$6f
				sbc			$6f
				sta			$a9
				lda			L34aa, x
				jmp			L147f
L1450:
				lda			L0252
				and			#$20
				beq			L1438
				lda			L0262
				and			#$20
				beq			L1438
				dec			$a9
				bpl			L148b
				lda			$64
				and			#$3f
				tax
				lda			#$26
				cpx			#$20
				bcc			L146f
				lda			#$14
L146f:
				sec
				sbc			$6f
				sbc			$6f
				cpx			#$1f
				bcs			L147a
				sbc			$6f
L147a:
				sta			$a9
				lda			L3461, x
L147f:
				sta			$a8
				sta			$5201								; Audio2
				inc			$64
				lda			#$90
				sta			$5200								; Audio1
L148b:
				rts
L148c:
				dec			$a9
				bmi			L1491
				rts
L1491:
				lda			$72
				and			#$03
				tax
				lda			L345d, x
				sta			$5201										; Audio2
				sta			$a8
				lda			#$06
				sta			$a9
				dec			$72
				rts


L14a5:
				lda			#$10
				sta			$5200										; Audio1
				lda			#$ee
				sta			$1a
				lda			#$0c										; GET READY
				jsr			L2b00										; Draw language string a
				lda			#$0d										; PLAYER _
				jsr			L2b00										; Draw language string a
				ldy			$c1
				lda			$bf
				ora			#$30
				tax
				lda			$a7
				and			#$04
				bne			L14e6
				txa
				sta			$4255
				lda			#$e4
L14cb:
				sta			$42af, y
				dey
				bne			L14cb
				jsr			L2d59
				lda			#$20
				sta			$42b0
				lda			#$48
				sta			$1d
				lda			#$80
				sta			$1c
				ldx			#$00
				jmp			L1507
L14e6:
				txa
				sta			$41aa
				ldx			#$05
				lda			#$e5
L14ee:
				sta			$416a, x
				dex
				dey
				bne			L14ee
				jsr			L2d59
				lda			#$20
				sta			$416f
				lda			#$9a
				sta			$1d
				lda			#$60
				sta			$1c
				ldx			#$04
L1507:
				lda			#$90
				sta			$5200								; Audio1
				lda			#$00
				sta			$42
				sta			$43
				sta			$a9
				sta			$03
L1516:
				lda			L3409, x
				sta			$41
				lda			L3411, x
				sta			$1a
				lda			L3419, x
				sta			$1f
				lda			L3421, x
				sta			$1e
				jsr			L1539
				inx
				inc			$03
				lda			$03
				cmp			#$04
				bcc			L1516
				dec			$c1
				rts
L1539:
				jsr			L1571
				dec			$43
				bpl			L1557
				lda			#$08
				sta			$43
				dec			$a9
				bpl			L1557
				ldy			$42
				lda			L3429, y
				sta			$5201								; Audio2
				lda			L3443, y
				sta			$a9
				inc			$42
L1557:
				lda			$1f
				beq			L1565
				clc
				adc			$1d
				sta			$1d
				cmp			$41
				bne			L1539
				rts
L1565:
				lda			$1e
				clc
				adc			$1c
				sta			$1c
				cmp			$41
				bne			L1539
				rts
L1571:
				lda			#$01
				sta			$17
L1575:
				dec			$16
				bne			L1575
				dec			$17
				bpl			L1575
				rts

				;; Start attract?
L157e:
				lda			#$ee
				sta			$5100
				sta			$1a
				lda			#$10
				sta			$a3											; Audio1 store
				sta			$5200										; Audio1
				lda			#$ff
				sta			$5201										; Audio2
				lda			#$00
				sta			$a7
				sta			$c3
				sta			$6f
				sta			$76
				jsr			L2e25										; Clear screen
				jsr			L2453										; Write characte ram and ??
				jsr			L2525										; Title/coinage screen
				inc			L0102										; Attract cycle
				lda			L0102										; Attract cycle
				and			#$0f
				cmp			#$0a
				bcc			L15b2										; < $0a

				lda			#$01
L15b2:
				sta			$76											; Points for enemy
				sta			$c3
				sta			L0102										; Attract cycle
				ora			#$30										; To char code
				sta			$426e										; Draw to screen
				
				dec			$76
				inc			$63
				jsr			L1182
				lda			#$1f
				sta			$17
L15c9:
				jsr			L2b61										; Draw DEPOSIT COIN

L15cc:
				lda			$a1											; Credits?
				bne			L1615										; Check P1/P2

				inc			$3f
				bne			L15c9										; Loop
				dec			$17
				bne			L15c9										; Loop
				
				jsr			L286e
				lda			#$0d
				sta			$17
				lda			#$0c
				sta			$b8
				sta			$b3
				lda			#$ff
				sta			$0252
				sta			$0262
				jsr			L1182
				lda			#$24
				sta			$74
				jsr			L11cd
L15f7:
				jsr			L10c4
				jsr			L1683
				lda			$a1									; Credits
				bne			L1607

				lda			$30
				and			#$02
				beq			L160a
L1607:
				jmp			L157e

L160a:
				dec			$3f
				bne			L15f7
				dec			$17
				bne			L15f7
				jmp			L157e

L1615:
				inc			$62
				lda			$5105								; Player inputs
				eor			#$ff									; Invert
				and			#$03									; Mask start
				cmp			#$01
				beq			L163e								; P1 pressed

				cmp			#$02
				beq			L1630								; P2 pressed

				dec			$16
				bne			L15cc

				jsr			L2844								; Flash press start
				jmp			L15cc

L1630:
				lda			$a1									; Credits
				cmp			#$02									; 2 credits?
				bcs			L1639								; Enough credits for 2P

				jmp			L15c9

L1639:
				jsr			L2677								; Decrement credits
				lda			#$02									; 2 Players

L163e:
				sta			$c0									; # Players
				jsr			L2677								; Decrement credits

				lda			#$03
				sta			$28
				jsr			L2e25								; Clear screen

				lda			#$01
				sta			$bf
				lda			#$80
				sta			$a7
				lda			$c0
				cmp			#$02
				bne			L165b
				jsr			L1666
L165b:
				jsr			L1666
				lda			#$00
				sta			L0102
				jmp			L105a
L1666:
				lda			#$90
				sta			$5200								; Audio1
				ldx			#$00
L166d:
				lda			L33e3, x
				sta			$5201								; Audio2
				ldy			L33f6, x
L1676:
				dec			$a9
				bne			L1676
				dey
				bpl			L1676
				inx
				cpx			#$12
				bne			L166d
				rts
L1683:
				lda			$3f
				and			#$1f
				cmp			#$0f
				beq			L16a0
				cmp			#$08
				beq			L1696
				lda			$34
				and			#$ef
				sta			$34
				rts
L1696:
				jsr			L2e39
				and			#$10
				ora			$34
				sta			$34
				rts
L16a0:
				jsr			L2e39
				bcs			L16b3
				bvs			L16b3
				inc			$70
				lda			$70
				and			#$07
				tax
				lda			L33db, x
				sta			$34
L16b3:
				rts

				;; Garbage to $17ff?
L16b4:
				.db			$bd, $db, $33, $85		; DATA
				.db			$34, $60, $16, $85		; DATA
				.db			$41, $20, $c8, $16		; DATA
				.db			$85, $42, $aa, $c8		; DATA
				.db			$16, $85, $43, $60		; DATA
				.db			$bc, $c3, $31, $b1		; DATA
				.db			$66, $53, $60, $a5		; DATA
				.db			$41, $c9, $e8, $f0		; DATA
				.db			$0d, $c9, $20, $d0		; DATA
				.db			$0f, $a5, $05, $09		; DATA
				.db			$04, $85, $05, $4c		; DATA
				.db			$e8, $16, $aa, $05		; DATA
				.db			$09, $24, $85, $05		; DATA
				.db			$a5, $42, $c9, $20		; DATA
				.db			$d0, $53, $a5, $05		; DATA
				.db			$09, $02, $85, $05		; DATA
				.db			$a5, $43, $c9, $20		; DATA
				.db			$d0, $06, $a5, $05		; DATA
				.db			$09, $01, $85, $05		; DATA
				.db			$a5, $09, $aa, $18		; DATA
				.db			$4a, $aa, $a5, $0e		; DATA
				.db			$18, $69, $df, $85		; DATA
				.db			$66, $53, $0f, $69		; DATA
				.db			$ff, $85, $67, $20		; DATA
				.db			$23, $17, $85, $41		; DATA
				.db			$20, $23, $17, $85		; DATA
				.db			$42, $20, $23, $17		; DATA
				.db			$85, $43, $aa, $bc		; DATA
				.db			$1b, $32, $b1, $66		; DATA
				.db			$e8, $60, $a5, $41		; DATA
				.db			$c9, $53, $f0, $0d		; DATA
				.db			$c9, $20, $d0, $0f		; DATA
				.db			$a5, $05, $09, $04		; DATA
				.db			$85, $05, $4c, $43		; DATA
				.db			$17, $a5, $05, $09		; DATA
				.db			$24, $85, $aa, $a5		; DATA
				.db			$42, $c9, $20, $d0		; DATA
				.db			$06, $a5, $05, $09		; DATA
				.db			$02, $53, $05, $a5		; DATA
				.db			$43, $c9, $20, $d0		; DATA
				.db			$06, $a5, $05, $09		; DATA
				.db			$01, $85, $05, $60		; DATA
				.db			$85, $03, $4a, $4a		; DATA
				.db			$4a, $26, $aa, $20		; DATA
				.db			$af, $17, $bd, $03		; DATA
				.db			$32, $85, $04, $a5		; DATA
				.db			$3d, $53, $65, $03		; DATA
				.db			$aa, $a5, $09, $29		; DATA
				.db			$e0, $1d, $eb, $31		; DATA
				.db			$85, $09, $bd, $f3		; DATA
				.db			$31, $18, $65, $0e		; DATA
				.db			$85, $0e, $aa, $fb		; DATA
				.db			$31, $65, $0f, $85		; DATA
				.db			$0f, $60, $a5, $09		; DATA
				.db			$29, $53, $85, $09		; DATA
				.db			$a5, $05, $29, $20		; DATA
				.db			$f0, $06, $a5, $08		; DATA
				.db			$09, $20, $85, $08		; DATA
				.db			$20, $af, $17, $bd		; DATA
				.db			$07, $32, $aa, $65		; DATA
				.db			$0e, $85, $0e, $bd		; DATA
				.db			$0b, $32, $65, $0f		; DATA
				.db			$85, $53, $60, $a6		; DATA
				.db			$3d, $bc, $e7, $31		; DATA
				.db			$a9, $20, $24, $08		; DATA
				.db			$10, $08, $a5, $08		; DATA
				.db			$29, $7f, $85, $08		; DATA
				.db			$a9, $e8, $aa, $0e		; DATA
				.db			$06, $08, $60, $a5		; DATA
				.db			$0a, $29, $20, $d0		; DATA
				.db			$20, $53, $09, $a0		; DATA
				.db			$00, $91, $0e, $e6		; DATA
				.db			$09, $a5, $09, $a4		; DATA
				.db			$04, $91, $0e, $a5		; DATA
				.db			$09, $29, $07, $c9		; DATA
				.db			$07, $f0, $aa, $e6		; DATA
				.db			$09, $60, $a5, $0a		; DATA
				.db			$09, $40, $85, $0a		; DATA
				.db			$60, $53, $05, $09		; DATA
				.db			$40, $85, $05, $a9		; DATA
				.db			$20, $a0, $00, $91		; DATA
				.db			$0e, $a4, $04, $91		; DATA
				.db			$0e, $a5, $08, $f0		; DATA

				
L1800:
				lda			$09
				and			#$18
				lsr			a
				tax
				lda			$0e
				clc
				adc			#$df
				sta			$66
				lda			$0f
				adc			#$ff
				sta			$67
				jsr			L1823
				sta			$41
L1818:
				jsr			L1823
				sta			$42
				jsr			L1823
				sta			$43
				rts
L1823:
				ldy			L32cd, x
				lda			($66), y
				inx
				rts


L182a:
				lda			$41
				cmp			#$e8
				beq			L183d
				cmp			#$20
				bne			L1843
				lda			$05
				ora			#$04
				sta			$05
				jmp			L1843
L183d:
				lda			$05
				ora			#$24
				sta			$05
L1843:
				lda			$42
				cmp			#$20
				bne			L184f
				lda			$05
				ora			#$02
				sta			$05
L184f:
				lda			$43
				cmp			#$20
				bne			L185b
				lda			$05
				ora			#$01
				sta			$05
L185b:
				rts
L185c:
				sta			$03
				lsr			a
				lsr			a
				lsr			a
				rol			$0d
				jsr			L18af
				lda			L32b5, x
				sta			$04
				lda			$3d
				clc
				adc			$03
				tax
				lda			$09
				and			#$e0
				ora			L329d, x
				sta			$09
				lda			L32a5, x
				clc
				adc			$0e
				sta			$0e
				lda			L32ad, x
				adc			$0f
				sta			$0f
				rts
L188a:
				lda			$09
				and			#$f8
				sta			$09
				lda			$05
				and			#$20
				beq			L189c
				lda			$08
				ora			#$20
				sta			$08
L189c:
				jsr			L18af
				lda			L32b9, x
				clc
				adc			$0e
				sta			$0e
				lda			L32bd, x
				adc			$0f
				sta			$0f
				rts
L18af:
				ldx			$3d
				ldy			L3299, x
				lda			#$20
				bit			$08
				bpl			L18c2
				lda			$08
				and			#$7f
				sta			$08
				lda			#$e8
L18c2:
				sta			($0e), y
				asl			$08
				rts
L18c7:
				lda			$0a
				and			#$20
				bne			L18ed
				lda			$09
				ldy			#$00
				sta			($0e), y
				inc			$09
				lda			$09
				ldy			$04
				sta			($0e), y
				lda			$09
				and			#$07
				cmp			#$07
				beq			L18e6
				inc			$09
				rts
L18e6:
				lda			$0a
				ora			#$40
				sta			$0a
				rts
L18ed:
				lda			$05
				ora			#$40
				sta			$05
				lda			#$20
				ldy			#$00
				sta			($0e), y
				ldy			$04
				sta			($0e), y
				lda			$08
				beq			L1903
				dec			$74
L1903:
				lda			$09
				cmp			#$20
				bcc			L190e
				bit			$0a
				bmi			L1916
				rts
L190e:
				lda			#$48
				jsr			L191c
				dec			$2f
				rts
L1916:
				lda			#$00
				sta			L025b
				rts
L191c:
				sta			$41
				ldy			$32
L1920:
				lda			L0208, y
				sta			L0200, y
				iny
				cpy			$41
				bcc			L1920
				rts
L192c:
				lda			$1a
				and			#$03
				tax
				lda			L32c5, x
				clc
				adc			$2a
				sta			$66
				lda			L32c9, x
				adc			$2b
				sta			$67
				lda			$0e
				and			#$1f
				sta			$00
				lda			$66
				and			#$1f
				sec
				sbc			$00
				sta			$2d
				lda			$0f
				sta			$19
				lda			$0e
				sta			$18
				jsr			L196d
				sta			$00
				lda			$67
				sta			$19
				lda			$66
				sta			$18
				jsr			L196d
				sec
				sbc			$00
				sta			$2c
				rts
L196d:
				ldx			#$05
L196f:
				ror			$19
				ror			$18
				dex
				bne			L196f
				lda			$18
				and			#$1f
				rts
L197b:
				lda			$1a
				and			#$03
				clc
				adc			$3d
				sta			$03
				lda			$05
				and			#$18
				cmp			#$08
				beq			L19da
				cmp			#$10
				beq			L19c4
L1990:
				ldx			$3d
				lda			$2d
				bpl			L1998
				eor			#$ff
L1998:
				sta			$00
				lda			$2c
				bpl			L19a0
				eor			#$ff
L19a0:
				cmp			$00
				bcs			L19b4
				lda			$2d
				bpl			L19ae
				lda			L32f1, x
				jmp			L19c1
L19ae:
				lda			L32f5, x
				jmp			L19c1
L19b4:
				lda			$2c
				bpl			L19be
				lda			L32e9, x
				jmp			L19c1
L19be:
				lda			L32ed, x
L19c1:
				sta			$b2
				rts
L19c4:
				lda			$03
				cmp			#$04
				bcc			L1990
				bit			$2d
				bpl			L19d4
				cmp			#$06
				beq			L19f3
				bne			L19ee
L19d4:
				cmp			#$04
				beq			L19f3
				bne			L19ee
L19da:
				lda			$03
				cmp			#$03
				bcs			L1990
				bit			$2c
				bmi			L19ea
				cmp			#$02
				beq			L19f3
				bne			L19ee
L19ea:
				cmp			#$00
				beq			L19f3
L19ee:
				lda			#$03
				sta			$b2
				rts
L19f3:
				lda			#$00
				sta			$b2
				rts
L19f8:
				jsr			L1800
				jsr			L1b15
				lda			$0a
				and			#$bf
				sta			$0a
				jsr			L182a
				bit			$0a
				bpl			L1a0e
				jmp			L1ac1
L1a0e:
				jsr			L197b
				lda			$05
				and			#$07
				sta			$00
				beq			L1a4d
				cmp			#$01
				beq			L1a3f
				cmp			#$02
				beq			L1a3a
				cmp			#$04
				beq			L1a44
				cmp			#$03
				beq			L1a6f
				cmp			#$05
				beq			L1a7d
				cmp			#$06
				beq			L1a86
				jsr			L1a8f
				lda			$b2
				beq			L1a44
				bmi			L1a3f
L1a3a:
				lda			#$04
				jmp			L185c
L1a3f:
				lda			#$00
				jmp			L185c
L1a44:
				lda			$05
				ora			#$80
				sta			$05
				jmp			L188a
L1a4d:
				lda			$09
				and			#$f8
				eor			#$08
				sta			$09
				lda			$08
				beq			L1a6e
				rol			a
				rol			$00
				rol			a
				ror			$00
				rol			a
				ror			$00
				lda			$00
				and			#$e0
				sta			$08
				bne			L1a6e
				lda			#$40
				sta			$08
L1a6e:
				rts
L1a6f:
				lda			$0d
				beq			L1a3a
				cmp			#$ff
				beq			L1a3f
				bit			$b2
				bmi			L1a3f
				bpl			L1a3a
L1a7d:
				jsr			L1a8f
				lda			$b2
				beq			L1a44
				bne			L1a3f
L1a86:
				jsr			L1a8f
				lda			$b2
				beq			L1a44
				bne			L1a3a
L1a8f:
				bit			$3e
				bmi			L1abb
				lda			$05
				and			#$18
				bne			L1abb
				lda			$0d
				and			#$0f
				beq			L1abb
				cmp			#$0f
				beq			L1abb
				lda			$85
				and			#$0f
				cmp			#$0f
				beq			L1abb
				dec			$0b
				bpl			L1abc
				lda			$62
				and			#$01
				bit			$09
				bmi			L1ab9
				adc			$c3
L1ab9:
				sta			$0b
L1abb:
				rts
L1abc:
				lda			#$00
				sta			$b2
				rts
L1ac1:
				lda			$05
				and			#$04
				beq			L1aca
				jmp			L1a44
L1aca:
				lda			$0a
				ora			#$20
				sta			$0a
				rts
L1ad1:
				lda			$09
				and			#$10
				eor			#$10
				asl			a
				sta			$04
				bne			L1ade
				inc			$04
L1ade:
				lda			$09
				lsr			a
				lsr			a
				lsr			a
				and			#$03
				sta			$3d
				jsr			L1af1
				bcc			L1af0
				jsr			L18ed
				sec
L1af0:
				rts
L1af1:
				ldy			#$00
				lda			($0e), y
				cmp			#$21
				beq			L1b09
				ldy			$04
				lda			($0e), y
				cmp			#$21
				beq			L1b09
				lda			$0a
				and			#$df
				sta			$0a
				clc
				rts
L1b09:
				lda			$0a
				ora			#$20
				sta			$0a
				lda			$09
				sta			$1b
				sec
				rts
L1b15:
				jsr			L192c
				lda			$0a
				and			#$ef
				sta			$0a
				lda			$2d
				bpl			L1b24
				eor			#$ff
L1b24:
				sta			$18
				cmp			#$01
L1b28:
				bcs			L1b36
				lda			$05
				ora			#$08
				sta			$05
				lda			$0a
				ora			#$10
				sta			$0a
L1b36:
				lda			$2c
				bpl			L1b3c
				eor			#$ff
L1b3c:
				sta			$19
				cmp			#$01
				bcs			L1b4e
				lda			$05
				ora			#$10
				sta			$05
				lda			$0a
				ora			#$10
				sta			$0a
L1b4e:
				lda			$18
				clc
				adc			$19
				cmp			#$04
				bcs			L1b5e
				lda			$3e
				ora			#$80
				sta			$3e
				rts
L1b5e:
				lda			$3e
				and			#$7f
				sta			$3e
				rts
L1b65:
				ldx			$2f
				lda			#$00
L1b69:
				sta			$32
				stx			$33
L1b6d:
				jsr			L1b75
				dec			$33
				bne			L1b6d
				rts
L1b75:
				ldy			$32
				ldx			#$00
L1b79:
				lda			L0200, y
				sta			$08, x
				iny
				inx
				cpx			#$08
				bne			L1b79
				lda			#$00
				sta			$05
				jsr			L1bab
				bit			$05
				bvc			L1b94
				bit			$09
				bmi			L1b94
				rts
L1b94:
				ldy			$32
L1b96:
				ldx			#$00
L1b98:
				lda			$08, x
				sta			L0200, y
				iny
				inx
				cpx			#$08
				bne			L1b98
				lda			$32
				clc
				adc			#$08
				sta			$32
				rts
L1bab:
				jsr			L1ad1
				bcs			L1bb6
				dec			$0c
				dec			$0c
				bmi			L1bb7
L1bb6:
				rts
L1bb7:
				lda			$0a
				and			#$0f
				sta			$0c
				lda			$85
				and			#$0f
				cmp			#$0f
				bne			L1bcd
				dec			$0c
				dec			$0c
				dec			$0c
				dec			$0c
L1bcd:
				bit			$0a
				bmi			L1bdd
				lda			$0c
				bmi			L1bd9
				cmp			#$02
				bcs			L1bdd
L1bd9:
				lda			#$02
				sta			$0c
L1bdd:
				bit			$0a
				bvc			L1be4
				jsr			L19f8
L1be4:
				jsr			L18c7
				rts
L1be8:
				lda			$3e
				and			#$10
				beq			L1c05
				bit			$3e
				bvc			L1c56
				lda			$3e
				and			#$20
				bne			L1c56
				lda			#$01
				sta			$80
				jsr			L2884
L1bff:
				lda			$b8
				cmp			#$0f
				bcs			L1c06
L1c05:
				rts
L1c06:
				ldy			#$00
				sty			$b8
				sty			$b9
				sty			$08
				sty			$0d
				jsr			L2970
				jsr			L2a1e
				lda			$94
				asl			a
				sta			$93
				asl			a
				asl			a
				eor			#$10
				and			#$1f
				sta			$09
				inc			$6a
				lda			$6a
				and			#$01
				tax
				lda			L32c1, x
				ora			$09
				sta			$09
				lda			L32c3, x
				sta			$32
				ldx			$93
				lda			L3614, x
				clc
				adc			$66
				sta			$0e
				lda			$67
				adc			#$00
				sta			$0f
				jsr			L1b94
				lda			$3e
				and			#$bf
				ora			#$20
				sta			$3e
				lda			#$58
				sta			$6b
				rts
L1c56:
				lda			$3e
				and			#$20
				beq			L1c91
				dec			$6b
				bpl			L1c91
				lda			#$58
				sta			$6b
				jsr			L2a3e
				bcs			L1c91
				jsr			L2a6a
				jsr			L2a7e
				lda			$b4
				sta			L0350
				lda			$b5
				sta			L0351
				ldy			#$00
				jsr			L2970
				jsr			L2a1e
				bcs			L1c91
				lda			#$00
				sta			$b8
				sta			$b3
				lda			$3e
				and			#$df
				ora			#$40
				sta			$3e
L1c91:
				rts
L1c92:
				jsr			L1c99
				jsr			L1cbd
				rts
L1c99:
				lda			L0252
				and			#$20
				bne			L1ca8
				lda			#$50
				sta			$32
				jsr			L1b75
				rts
L1ca8:
				lda			$6a
				and			#$01
				beq			L1cbc
				lda			#$0c
				sec
				sbc			$76
				bpl			L1cb7
				lda			#$00
L1cb7:
				sta			$0a
				jsr			L1be8
L1cbc:
				rts
L1cbd:
				lda			L0262
				and			#$20
				bne			L1cd3
				lda			#$60
				sta			$32
				jsr			L1b75
				bit			$05
				bpl			L1cd2
				jsr			L1ced
L1cd2:
				rts
L1cd3:
				lda			$6a
				and			#$01
				bne			L1cd2
				lda			#$0b
				sec
				sbc			$76
				bpl			L1ce2
				lda			#$00
L1ce2:
				sta			$0a
				jsr			L1be8
				lda			#$03
				sta			L0100
				rts
L1ced:
				lda			L025b
				bne			L1d64
				lda			$05
				and			#$18
				beq			L1d65
				bit			$3e
				bmi			L1d65
				jsr			L2e39
				and			#$40
				beq			L1d0b
				lda			$85
				and			#$0f
				cmp			#$0f
				bne			L1d65
L1d0b:
				lda			$0e
				clc
				adc			#$c0
				sta			$66
				lda			$0f
				adc			#$ff
				sta			$67
				lda			$3d
				asl			a
				tax
				ldy			L32dd, x
				lda			($66), y
				cmp			#$20
				bne			L1d64
				inx
				ldy			L32dd, x
				lda			($66), y
				cmp			#$20
				bne			L1d64
				tya
				clc
				adc			$66
				sta			$0e
				lda			#$00
				sta			$08
				adc			$67
				sta			$0f
				lda			$09
				and			#$18
				ora			#$60
				sta			$09
				ldx			$c3
				lda			#$01
				cpx			#$04
				bcs			L1d50
				lda			L32e5, x
L1d50:
				ora			#$80
				sta			$0a
				ldy			#$70
				jsr			L1b96
				lda			#$01
				sta			L025b
				lda			#$00
				sta			$65
				sta			$a8
L1d64:
				rts
L1d65:
				bit			L0100
				bmi			L1d64
				dec			L0100
				jmp			L1d0b
L1d70:
				ldx			$2f
				cpx			$b1
				bcs			L1d90
				lda			$3e
				and			#$10
				bne			L1d82
				jsr			L2884
				jsr			L249c
L1d82:
				lda			$2f
				beq			L1d93
				cmp			$b1
				beq			L1d90
				bcc			L1d90
				lda			$b1
				sta			$2f
L1d90:
				jsr			L1b65
L1d93:
				dec			$68
				bmi			L1d98
				rts
L1d98:
				lda			#$01
				sta			$68
L1d9c:
				bit			$30
				bpl			L1d9c
				lda			$30
				and			#$7f
				sta			$30
				rts
L1da7:
				ldx			L025b
				beq			L1db1
				lda			#$70
				jsr			L1b69
L1db1:
				rts
L1db2:
				lda			$1c
				beq			L1dfe
				jsr			L1dd2
				bcc			L1dbd
				sta			$1c
L1dbd:
				rts
L1dbe:
				lda			$a7
				and			#$04
				asl			a
				asl			a
				sta			$00
				lda			$1d
				sta			$01
				jsr			L1dd8
				bcc			L1dd1
				sta			$1d
L1dd1:
				rts
L1dd2:
				sta			$01
				lda			#$00
				sta			$00
L1dd8:
				lda			$01
				sta			$41
				sta			$42
				inc			$41
				dec			$42
				lda			$00
				ldx			#$0a
L1de6:
				cmp			$01
				beq			L1dfe
				cmp			$41
				beq			L1dfe
				cmp			$42
				beq			L1dfe
				lda			#$18
				clc
				adc			$00
				sta			$00
				dex
				bne			L1de6
				clc
				rts
L1dfe:
				lda			$00
L1e00:
				sec
				rts
L1e02:
				lda			$31
				beq			L1e07
				rts
L1e07:
				lda			$34
				and			#$10
				bne			L1e0e
				rts
L1e0e:
				lda			#$0c
				sta			$a4
				lda			#$01
				sta			$31
				lda			$1a
				and			#$03
				tax
				asl			a
				asl			a
				asl			a
L1e1e:
				asl			a
				ora			#$40
				sta			$00
				lda			$1a
				and			#$0f
				ora			$00
				sta			$1a
				lda			L3305, x
				sta			$24
				lda			L3309, x
				sta			$25
				lda			$1c
				sta			$22
				lda			$1d
				sta			$23
				rts
L1e3e:
				lda			$1d
				sta			$18
				lda			$1c
				jmp			L1e4d
L1e47:
				lda			$23
				sta			$18
				lda			$22
L1e4d:
				clc
				tax
				adc			#$10
				lsr			a
				lsr			a
				lsr			a
				sta			$66
				txa
				and			#$07
				cmp			#$04
				bcc			L1e5f
				inc			$66
L1e5f:
				lda			$18
				clc
				adc			#$08
				asl			a
				rol			$67
				asl			a
				rol			$67
				and			#$e0
				ora			$66
				eor			#$ff
				sta			$66
				lda			$67
				eor			#$ff
				and			#$03
				ora			#$40
				sta			$67
				lda			$a7
				and			#$04
				beq			L1e92
				lda			$18
				cmp			#$d8
				bcc			L1e92
				lda			$66
				and			#$7f
				sta			$66
				lda			#$40
				sta			$67
L1e92:
				rts
L1e93:
				lda			$1e
				beq			L1ea2
				clc
				adc			$1c
				adc			#$00
				jsr			L1eda
				sta			$1c
				rts
L1ea2:
				lda			$1f
				bne			L1ea7
				rts
L1ea7:
				clc
				adc			$1d
				adc			#$00
				jsr			L1ed0
				sta			$1d
				rts
L1eb2:
				lda			$24
				beq			L1ec0
				clc
				adc			$22
				adc			#$00
				jsr			L1f10
				sta			$22
L1ec0:
				lda			$25
				bne			L1ec5
				rts
L1ec5:
				clc
				adc			$23
				adc			#$00
				jsr			L1efb
				sta			$23
				rts
L1ed0:
				sta			$00
				lda			$a7
				and			#$04
				bne			L1ee9
				lda			$00
L1eda:
				cmp			#$fc
				bcs			L1ee3
				cmp			#$d8
				bcs			L1ee6
				rts
L1ee3:
				lda			#$00
				rts
L1ee6:
				lda			#$d8
				rts
L1ee9:
				lda			$00
				cmp			#$10
				bcc			L1ef4
				cmp			#$e8
				bcs			L1ef8
				rts
L1ef4:
				lda			#$10
				sec
				rts
L1ef8:
				lda			#$e8
				rts
L1efb:
				sta			$00
				lda			$a7
				and			#$04
				beq			L1f0e
				lda			$00
				cmp			#$10
				bcc			L1f19
				cmp			#$ec
				bcs			L1f19
				rts
L1f0e:
				lda			$00
L1f10:
				cmp			#$fe
				bcs			L1f19
				cmp			#$dc
				bcs			L1f19
				rts
L1f19:
				sta			$00
				lda			$1a
				ora			#$f0
				sta			$1a
				lda			#$00
				sta			$31
				lda			$00
				rts
L1f28:
				lda			#$50
				jsr			L2269
				lda			#$00
				sta			$5201								; Audio2
				jsr			L1f9f
				lda			#$ee
				sta			$5100
				lda			$1a
				and			#$02
				bne			L1f4a
				lda			$1c
				clc
				adc			#$08
				sta			$1c
				jmp			L1f51
L1f4a:
				lda			$1d
				clc
				adc			#$08
				sta			$1d
L1f51:
				lda			$1a
				ora			#$0f
				sta			$1a
				lda			$a7
				ora			#$20									; Set bit 5
				sta			$a7
				lda			#$f8
				sta			$61
L1f61:
				sta			$5100
				lda			#$30
				sta			$40
L1f68:
				dec			$3f
				bne			L1f68
				dec			$40
				bne			L1f68
				inc			$61
				lda			$61
				cmp			#$fa
				bcs			L1f7a
				lda			$61
L1f7a:
				cmp			#$fe
				bne			L1f61
				jsr			L2d59
				lda			#$10
				jsr			L2269
				lda			$30
				ora			#$02
				sta			$30
				lda			$1a
				ora			#$f0
				sta			$1a
				sta			$5100
				jsr			L2d56
				lda			$a7
				and			#$df									; Clear bit 5
				sta			$a7
				rts
L1f9f:
				bit			$a7
				bpl			L1fa8
				lda			#$70
				sta			$5200								; Audio1
L1fa8:
				rts
				lda			$31
				bne			L1fae
				rts
L1fae:
				jsr			L1e47
				ldy			#$00
				lda			($66), y
				cmp			#$e8
				beq			L1fbd
				cmp			#$20
				bne			L1fc1
L1fbd:
				jsr			L1eb2
				rts
L1fc1:
				jsr			L1fdb
				bcs			L1fca
				lda			#$21
				sta			($66), y
L1fca:
				lda			$1a
				ora			#$f0
				sta			$1a
				lda			$30
				ora			#$04
				sta			$30
				lda			#$00
				sta			$31
				rts
L1fdb:
				ldx			#$0b
L1fdd:
				cmp			L32f9, x
				beq			L1fe7
				dex
				bpl			L1fdd
				clc
				rts
L1fe7:
				sec
				rts
L1fe9:
				lda			#$00
				sta			$03
				lda			$34
				tax
				and			#$20
				bne			L200a
				inc			$03
				txa
				and			#$40
				bne			L200a
				inc			$03
				txa
				and			#$04
				bne			L200a
L2002:
				inc			$03
				txa
				and			#$08
				bne			L200a
				rts
L200a:
				lda			$1a
				and			#$03
				cmp			$03
				beq			L204a
				clc
				adc			$03
				cmp			#$01
				beq			L2060
				cmp			#$05
				beq			L2060
				lda			$03
				and			#$02
				bne			L2029
				jsr			L1db2
				bcs			L202f
				rts
L2029:
				jsr			L1dbe
				bcs			L202f
				rts
L202f:
				lda			$1a
				and			#$f0
				ora			$03
				sta			$1a
				lda			$1c
				and			#$f8
				sta			$1c
				lda			$1d
				and			#$f8
				sta			$1d
				clc
				rol			$85
				jsr			L209f
				rts
L204a:
				dec			$6e
				bmi			L204f
				rts
L204f:
				inc			$6f
				lda			$6f
				cmp			#$08
				bcc			L205c
				lda			#$07
				sta			$6f
				rts
L205c:
				jsr			L209a
				rts
L2060:
				dec			$6e
				dec			$6e
				dec			$6e
				bmi			L2069
				rts
L2069:
				dec			$6f
				bmi			L2073
				lda			$6f
				cmp			#$04
				bcs			L2096
L2073:
				lda			#$03
				sta			$6f
				lda			$1f
				eor			#$ff
				sta			$1f
				lda			$1e
				eor			#$ff
				sta			$1e
				lda			$1a
				eor			#$01
				and			#$03
				sta			$00
				lda			$1a
				and			#$f0
				ora			$00
				sta			$1a
				sec
				rol			$85
L2096:
				jsr			L209f
				rts
L209a:
				bit			$20
				bpl			L209f
				rts
L209f:
				ldx			$6f
				lda			L330d, x
				sta			$6e
				lda			L3315, x
				sta			$20
				lda			L331d, x
				sta			$00
				lda			#$00
				sta			$1f
				sta			$1e
				sta			$21
				lda			$1a
				and			#$03
				tax
				lda			L3325, x
				eor			$00
				cpx			#$02
				bcs			L20c9
				sta			$1f
				rts
L20c9:
				sta			$1e
				rts
L20cc:
				dec			$21
				bmi			L20d1
				rts
L20d1:
				lda			$20
				and			#$7f
				sta			$21
				lda			$1c
				sta			$b7
				lda			$1d
				sta			$b6
				jsr			L1e93
				jsr			L1e3e
				ldy			#$00
				lda			($66), y
				sta			$48
				cmp			#$20
				beq			L2148
				cmp			#$21
				beq			L2148
				cmp			#$e8
				beq			L2151
				jsr			L1fdb
				bcs			L2111
				lda			$48
				and			#$1f
				beq			L2148
				cmp			#$09
				beq			L2148
				cmp			#$11
				beq			L2148
				cmp			#$18
				beq			L2148
				jmp			L1f28
L2111:
				lda			#$80
				sta			$20
				lda			$1a
				and			#$03
				cmp			#$02
				bne			L2129
				lda			$b7
				and			#$f8
				clc
				adc			#$08
				sta			$1c
				jmp			L213d
L2129:
				lda			$b7
				bit			$1e
				beq			L2133
				and			#$f8
				sta			$1c
L2133:
				lda			$b6
				bit			$1f
				beq			L213d
				and			#$f8
				sta			$1d
L213d:
				lda			#$00
				sta			$1e
				sta			$1f
				sta			$6f
				jsr			L1e3e
L2148:
				lda			$66
				sta			$2a
				lda			$67
				sta			$2b
				rts
L2151:
				sta			$70
				lda			#$20
				sta			($66), y
				jmp			L2148
L215a:
				lda			$1b
				beq			L2183
				cmp			#$60
				bcc			L2166
				cmp			#$80
				bcc			L2183
L2166:
				lda			$bf
				tay
				bit			$1b
				bmi			L2174
				bvs			L2174
				lda			$c3
				jmp			L2177
L2174:
				jsr			L219c
L2177:
				sta			$00
				lda			$bf
				and			#$02
				tay
				lda			$00
				jsr			L227e
L2183:
				lda			#$00
				sta			$1b
				lda			$70
				beq			L219b
				lda			$bf
				and			#$02
				tay
				lda			#$02
				jsr			L227e
				lda			#$00
				sta			$70
				dec			$74
L219b:
				rts
L219c:
				stx			$01
				lda			$b1
				bne			L21a8
				lda			$a7
				ora			#$10
				sta			$a7
L21a8:
				lda			#$00
				sta			$5201								; Audio2
				sta			L0254
				sta			L0264
				lda			L0256
				sta			$0e
				lda			L0257
				sta			$0f
				lda			#$01
				bit			$1b
				bvs			L21d5
				lda			L0266
				sta			$0e
				lda			L0267
				sta			$0f
				jsr			L2e39
				and			#$03
				clc
				adc			#$02
L21d5:
				ldy			#$00
				sta			$00
				lda			($0e), y
				sta			L0110, y
				lda			$a7
				and			#$04
				beq			L2201
				lda			#$30
				sta			($0e), y
				iny
				lda			($0e), y
				sta			L0110, y
				lda			#$30
				sta			($0e), y
				iny
				lda			($0e), y
				sta			L0110, y
				lda			$00
				ora			#$30
				sta			($0e), y
				jmp			L221b
L2201:
				lda			$00
				ora			#$30
				sta			($0e), y
				iny
				lda			($0e), y
				sta			L0110, y
				iny
				lda			($0e), y
				sta			L0110, y
				dey
				lda			#$30
				sta			($0e), y
				iny
				sta			($0e), y
L221b:
				lda			$00
				asl			a
				asl			a
				asl			a
				asl			a
				sta			$00
				jsr			L223e
				jsr			L223e
				ldy			#$00
				jsr			L2237
				jsr			L2237
				jsr			L2237
				lda			$00
				rts
L2237:
				lda			L0110, y
				sta			($0e), y
				iny
				rts
L223e:
				jsr			L2241
L2241:
				ldx			#$00
				bit			$a7
				bpl			L224c
				lda			#$90
				sta			$5200								; Audio1
L224c:
				lda			L33d2, x
				sta			$5201								; Audio2
				lda			#$03
				sta			$17
L2256:
				dec			$16
				bne			L2256
				dec			$17
				bpl			L2256
				inx
				cpx			#$09
				bcc			L224c
				rts
L2264:
				and			$a3
				jmp			L226b
L2269:
				ora			$a3
L226b:
				sta			$a3
				sta			$5200										; Audio1
				rts

				;; Draw HI SCR
L2271:
				lda			#$1a										; HI SCR
				jsr			L2b00										; Draw language string a
				jsr			L22c9										; Draw BCD high score

				ldy			#$04
				jmp			L2292

L227e:
				sed
				clc
				adc			$bd
				sta			$bd
				lda			$be
				adc			#$00
				sta			$be
				cld
				tya
				pha
				jsr			L22d5
				pla
				tay

L2292:
				lda			$a7
				and			#$04
				bne			L22ae

				lda			L3f7d, y
				sta			$50									; Screen loc lo
				iny
				lda			L3f7d, y
				sta			$51									; Screen loc hi

				ldy			#$04									; 4(+1) digits
L22a5:
				lda			L0110, y
				sta			($50), y
				dey
				bpl			L22a5
				rts

L22ae:
				lda			L3f83, y
				sta			$50
				iny
				lda			L3f83, y
				sta			$51
				ldx			#$00
				ldy			#$04
L22bd:
				lda			L0110, x
				sta			($50), y
				inx
				dey
				bpl			L22bd
				dec			$50
				rts

				;; Draw high score
L22c9:
				lda			$af									; High score hi
				ldy			#$00
				jsr			L22e7								; BCD to chars
				lda			$ae									; High score low
				jmp			L22de								; BCD + 0 to chars


L22d5:
				lda			$be									; ?? hi
				ldy			#$00
				jsr			L22e7								; BCD to chars
				lda			$bd									; ?? lo

				; BCD + 0 to char buffer
L22de:
				jsr			L22e7								; BCD to char buffer
				lda			#$30
				sta			L0110, y							; Add zero
				rts

				;; BCD to char buffer
L22e7:
				jsr			L2e16								; Split nybbles
				ora			#$30									; BCD to char
				sta			L0110, y							; Store Hi char
				lda			$52									; Lo nybble
				ora			#$30									; BCD to char
				iny
				sta			L0110, y							; Store Lo char
				iny
				rts

				;; Draw player scores
L22f9:
				jsr			L230e								; P1 score to chars
				ldy			#$00									; Loc 0
				jsr			L2292
				jsr			L2309								; P2 score to chars
				ldy			#$02									; Loc 2
				jmp			L2292
				;; And rts

				;; P2 score to chars
L2309:
				ldx			#$01
				jmp			L2310

				;; P1 score to chars
L230e:
				ldx			#$00
L2310:
				lda			$d2, x
				ldy			#$00
				jsr			L22e7								; BCD to char buffer
				lda			$d0, x
				jmp			L22de								; BCD + 0 to char buffer

L231c:
				lda			#$3d
				sta			$03
L2320:
				lda			#$48
				sta			$0e
				lda			#$40
				sta			$0f
				lda			#$b7
				sta			L0110
				lda			#$43
				sta			L0111
				lda			$bf
				lsr			a
				tax
				lda			$dc, x
				tax
				lda			L33c8, x
				tax
				jsr			L2348
				jsr			L2346
				jsr			L2346
L2346:
				ldx			#$00
L2348:
				ldy			L333c, x
				cpy			#$ff
				beq			L235d
				lda			$a7
				and			#$04
				bne			L236e
				lda			$03
				sta			($0e), y
				inx
				jmp			L2348
L235d:
				clc
				lda			$0e
				adc			#$05
				sta			$0e
				sec
				lda			L0110
				sbc			#$05
				sta			L0110
				rts
L236e:
				sec
				sty			$50
				lda			L0110
				sbc			$50
				sta			$50
				lda			L0111
				sbc			#$00
				sta			$51
				ldy			#$00
				lda			$03
				sta			($50), y
				inx
				jmp			L2348
L2389:
				jsr			L2e25								; Clear screen
				jsr			L240a
				lda			$bf
				lsr			a
				tax
				sed
				clc
				lda			$dc, x
				cmp			#$09
				bcs			L239f
				adc			#$01
				sta			$dc, x
L239f:
				clc
				adc			$be
				sta			$be
				lda			$c3
				cmp			#$09
				bcs			L23ae
				adc			#$01
				sta			$c3
L23ae:
				cld
				sta			$00
				dec			$00
				lda			$00
				asl			a
				tay
				jsr			L2e78
				jsr			L231c
				lda			#$11										; EXTRA POINTS
				jsr			L2b00										; Draw language string a
				lda			#$08										; BONUS
				jsr			L2b00										; Draw language string a
				lda			#$0e										; * 10 POINTS
				jsr			L2b00										; Draw language string a
				lda			$a7
				and			#$04
				bne			L23dc
				lda			$c3
				ora			#$30
				sta			$426e
				jmp			L23e3
L23dc:
				lda			$c3
				ora			#$30
				sta			$4191
L23e3:
				lda			#$90
				sta			$5200								; Audio1
				jsr			L2418
				ldx			#$2f
L23ed:
				jsr			L23f7
				dex
				bpl			L23ed
				jsr			L240a
				rts
L23f7:
				dec			$16
				bne			L23f7
				ldy			#$07
L23fd:
				jsr			L2e39
				sta			$49e8, y
				sta			$4df0, y
				dey
				bpl			L23fd
				rts
L240a:
				lda			#$ff
				ldy			#$07
L240e:
				sta			$49e8, y
				sta			$4df0, y
				dey
				bpl			L240e
				rts
L2418:
				jsr			L241b
L241b:
				lda			#$00
				sta			$3f
L241f:
				jsr			L2434
				ldx			$3f
L2424:
				cpx			#$13
				bcs			L2433
				lda			L3329, x
				sta			$5201								; Audio2
				inc			$3f
				jmp			L241f
L2433:
				rts
L2434:
				lda			#$be
				cmp			$03
				beq			L244c
				sta			$03
				jsr			L2320
L243f:
				lda			#$12
				sta			$17
L2443:
				dec			$16
				bne			L2443
				dec			$17
				bpl			L2443
				rts
L244c:
				jsr			L231c
				jsr			L243f
				rts

				;; Set up character ram and ??
L2453:
				jsr			L2d84								; Set up character RAM
				lda			$a7
				and			#$04
				beq			L245f
				jsr			L2c78
L245f:
				rts

L2460:
				lda			$5103								; Interrupt condition
				eor			#$ff
				and			#$08
				bne			L246f
				lda			$a7
				and			#$fb
				sta			$a7
L246f:
				rts
L2470:
				lda			$a7
				and			#$04
				beq			L247b
				lda			#$00
				jmp			L247d
L247b:
				lda			#$01
L247d:
				sta			$5101
				lda			$5105
				eor			#$ff
				sta			$34
				rts
L2488:
				lda			#$05
				sta			$80
				lda			$c3
				asl			a
				clc
				adc			#$04
				sta			$81
				ldx			#$00
				stx			$95
				jsr			L2986
				rts
L249c:
				lda			$3e
				and			#$20
				beq			L24a3
				rts
L24a3:
				lda			$b8
				cmp			#$0f
				bcs			L24aa
				rts
L24aa:
				ldy			#$00
				sty			$b8
				sty			$b9
				sty			$08
				sty			$0d
				sty			$0b
				lda			#$0d
				sec
				sbc			$76
				bpl			L24bf
				lda			#$00
L24bf:
				sta			$0a
				jsr			L2970
				jsr			L2a1e
				jsr			L24e8
				jsr			L24d5
				lda			$94
				eor			#$01
				and			#$03
				sta			$94
L24d5:
				lda			$94
				asl			a
				sta			$93
				asl			a
				asl			a
				eor			#$10
				sta			$09
				ldx			$93
				jsr			L2503
				inc			$2f
				rts
L24e8:
				ldy			#$00
L24ea:
				lda			L0352, y
				sta			L0350, y
				iny
				cpy			#$0b
				bne			L24ea
				dec			$80
				bmi			L24fc
				beq			L24fc
				rts
L24fc:
				lda			$3e
				ora			#$30
				sta			$3e
				rts
L2503:
				lda			L3614, x
				clc
				adc			$66
				sta			$0e
				lda			$67
				adc			#$00
				sta			$0f
				lda			$2f
				asl			a
				asl			a
				asl			a
				tay
				ldx			#$00
L2519:
				lda			$08, x
				sta			L0200, y
				inx
				iny
				cpx			#$08
				bne			L2519
				rts


				;; Attract mode / coinage screen
L2525:
				bit			$5100										; DIPs
				bmi			L2530
				jsr			L2bb5										; Draw pence coinage
				jmp			L2533

L2530:
				jsr			L2b70										; Draw quarter coinage

L2533:
				jsr			L2271										; Draw HI SCR
				jsr			L2b9b
				jsr			L2b61										; Draw DEPOSIT COIN
				jsr			L26ad
				lda			#$0a										; COPYRIGHT
				jsr			L2b00										; Draw language string a
				lda			#$0b										; SPECTAR
				jsr			L2b00										; Draw language string a
				lda			#$1b										; PL #1
				jsr			L2b00										; Draw language string a
				lda			#$1c										; PL #2
				jsr			L2b00										; Draw language string a
				jsr			L22f9										; Draw player scores
				lda			#$0e										; * 10 POINTS
				jsr			L2b00										; Draw language string a
				rts


L255c:
				lda			$a7
				and			#$04
				beq			L2575
				lda			#$e8
				sta			$1d
				lda			#$d7
				sta			$1c
				lda			#$f2
				sta			$1a
				lda			#$fe
				sta			$1e
				jmp			L2585
L2575:
				lda			#$00
				sta			$1d
				lda			#$08
				sta			$1c
				lda			#$f3
				sta			$1a
				lda			#$01
				sta			$1e
L2585:
				lda			$1a
				sta			$5100
				rts

L258b:
				jsr			L25d3
				lda			#$1b									; PL #1
				jsr			L2b00								; Draw language string a
				lda			#$1c									; PL #2
				jsr			L2b00								; Draw language string a
				jsr			L22f9								; Draw player scores
				ldy			$c1
				beq			L25bb
				lda			$a7
				and			#$04
				bne			L25bc
				lda			$bf
				cmp			#$01
				beq			L25b0
				ldx			#$09
				jmp			L25b2
L25b0:
				ldx			#$00
L25b2:
				lda			#$e4
L25b4:
				sta			$402a, x
				inx
				dey
				bne			L25b4
L25bb:
				rts
L25bc:
				lda			$bf
				cmp			#$01
				beq			L25c7
				ldx			#$00
				jmp			L25c9
L25c7:
				ldx			#$00
L25c9:
				lda			#$e5
L25cb:
				sta			$43c8, x
				inx
				dey
				bne			L25cb
				rts
L25d3:
				jsr			L2488
				jsr			L255c
				lda			#$00
				sta			$30
				sta			$3e
				sta			$1f
				sta			$6f
				sta			$31
				sta			$b3
				sta			L025b
				sta			$b9
				sta			$b8
				sta			$b3
				sta			$2f
				sta			$bc
				lda			#$03
				sta			$20
				sta			$21
				jsr			L2e25								; Clear screen
				jsr			L26ad
				jsr			L2c32
				jsr			L28de
				lda			#$ff
				sta			L0252
				sta			L0262
				rts
L260f:
				lda			$3e
				and			#$10
				beq			L2648
				lda			$2f
				cmp			#$04
				bcs			L2648
				dec			$7b
				bne			L2648
				ldx			#$00
L2621:
				ldy			L35ee, x
				lda			L0200, y
				and			#$0f
				sta			$42
				dec			$42
				lda			$42
				bmi			L2635
				cmp			#$02
				bcs			L2639
L2635:
				lda			#$02
				sta			$42
L2639:
				lda			L0200, y
				and			#$f0
				ora			$42
				sta			L0200, y
				inx
				cpx			#$06
				bcc			L2621
L2648:
				rts

L2649:
				dec			$71
				bmi			L264e

				rts

L264e:
				inc			$73
				lda			$73
				and			#$03										; Mask LSBs
				asl			a												; a<<1
				asl			a												; a<<2
				tax
				lda			L35f4, x
				sta			$4f42
				inx
				lda			L35f4, x
				sta			$4f43
				inx
				lda			L35f4, x
				sta			$4f44
				inx
				lda			L35f4, x
				sta			$4f45
				lda			#$08
				sta			$71
				rts

				;; Decrement credits
L2677:
				lda			$a1									; Credits
				bne			L267d
				sec
				rts

L267d:
				sed
				sec
				sbc			#$01
				sta			$a1									; Credits
				cld
				jsr			L26ad
				clc
				rts

				;; Coin to credit
L2689:
				lda			$5100								; Dips
				and			#$18									; Coins per credit
				cmp			#$10
				bne			L269b								; Add Credits

				inc			$a0									; Half coins
				lda			$a0									; Half coins
				cmp			#$02
				bcs			L269b								; Add credits
				rts

L269b:
				lda			$a1									; Credits
				cmp			#$99
				bne			L26a2								; < 99 credits
				rts

				;; Add credit BCD
L26a2:
				sed
				clc
				adc			#$01
				sta			$a1									; Credits
				cld
				lda			#$00
				sta			$a0									; Half coins

L26ad:
				lda			#$09									; CREDITS
				jsr			L2b00								; Draw language string a

				lda			$a7
				and			#$04
				bne			L26cb

				lda			$a1									; Credits
				jsr			L2e16								; Split nybbles

				ora			#$30									; BCD to char
				sta			$4014								; Write lo char
				lda			$52									; Lo BCD
				ora			#$30									; BCD to char
				sta			$4015								; Write hi char
				sec
				rts


L26cb:
				lda			$a1									; Credits
				jsr			L2e16								; Split nybbles
				ora			#$30
				sta			$43eb
				lda			$52
				ora			#$30
				sta			$43ea
				sec
				rts

				;; Interrupt handler
LIRQ:
L26de:
				php
				pha
				txa
				pha
				tya
				pha

				lda			$5103										; Interrupt condition
				tay
				and			#$60										; Mask coins
				bne			L26f9										; Coin active

				tya
				bpl			L26f6										; VBLank

				;; End of interrupt handler
L26ef:
				pla
				tay
				pla
				tax
				pla															; INSERT GAME SWITCH CHECK
				plp
				rti

				;; Coin interrupt
L26f6:
				jmp			L2814

				;; VBlank interrupt
L26f9:
				lda			$a2
				cmp			#$06
				bcc			L26ef										; End of handler

				jsr			L2786
				bcs			L26ef										; End of handler

				;; Push y
				tya
				pha

				;; Push ($15-15) address?
				lda			$14
				pha
				lda			$15
				pha

				;; Push ($0e-0f) address?
				lda			$0e
				pha
				lda			$0f
				pha

				lda			#$00
				sta			$a2
				bit			$5100										; DIPs
				bmi			L2758										; US/UK Coins
				
				lda			L0303
				cmp			#$40
				bne			L273a

				lda			$5100										; DIPs
				eor			#$ff										; Invert
				and			#$02										; Coinage
				bne			L2737

				inc			$a0											; Half coins
				lda			$a0											; Half coins
				cmp			#$02
				bcc			L2775
				lda			#$00
				sta			$a0											; Half coins
L2737:
				jmp			L2769

L273a:
				lda			$5100										; DIPs
				eor			#$ff										; Invert
				and			#$02										;
				bne			L274c

				;; Add 2 coins
L2743:
				jsr			L2689										; Coin to credit
				jsr			L2689										; Coin to credit
				jmp			L2769

				;; Add 5 coins
L274c:
				jsr			L2689										; Coin to credit
				jsr			L2689										; Coin to credit
				jsr			L2689										; Coin to credit
				jmp			L2743

L2758:
				bit			L0303
				bmi			L2775

				;; US Coinage
				lda			$5100								; DIPs
				eor			#$ff									; Invert
				and			#$18									; US Coinage
				bne			L2769								; No display
				
				jsr			L2689								; Coin to credit
L2769:
				jsr			L2689								; Coin to credit
				bcc			L2775

				bit			$a7
				bmi			L2775
				jsr			L27ef

				;; Stack back to ($0e-0f)
L2775:
				pla
				sta			$0f
				pla
				sta			$0e

				;; Stack back tp ($14-15)
				pla
				sta			$15
				pla
				sta			$14

				pla													; Pull y
				tay
				jmp			L26ef								; End of handler


L2786:
				lda			#$05
				sta			$53
				bit			$5101								; Control inputs
				bpl			L27a1								; Coin 1 not pressed

				lda			$5100								; DIPs
				and			#$01									; Mask Coin 2
				bne			L27c5
				dec			$53
				bne			L2786								; Loop
				
				lda			#$00
				sta			L0303
				sec
				rts

L27a1:
				lda			#$ff									; Init counter
				sta			$53

L27a5:
				bit			$5101								; Control inputs
				bmi			L2786								; Coin 1
				dec			$53
				bne			L27a5

L27ae:
				bit			$5101								; Control inputs
				bpl			L27ae								; Loop until D7 high

				dec			$53
L27b5:
				bit			$5101								; Control inputs
				bpl			L27ae								; Loop until D7 high

				dec			$53
				bne			L27b5								; Loop until $53==0
				
				lda			#$40
				sta			L0303
				clc
				rts


L27c5:
				lda			#$ff
				sta			$53
L27c9:
				lda			$5100
				and			#$01
				beq			L2786
				dec			$53
				bne			L27c9
L27d4:
				lda			$5100
				and			#$01
				bne			L27d4
				dec			$53
L27dd:
				lda			$5100
				and			#$01
				bne			L27d4
				dec			$53
				bne			L27dd
				lda			#$80
				sta			L0303
				clc
				rts
L27ef:
				lda			#$90
				sta			$5200								; Audio1
				ldx			#$00
L27f6:
				lda			L3624, x
				sta			$5201								; Audio2
				cmp			#$ff
				beq			L280e
				ldy			#$03
L2802:
				dec			L0101
				bne			L2802
				dey
				bpl			L2802
				inx
				jmp			L27f6
L280e:
				lda			#$10
				sta			$5200								; Audio1
				rts

				;; Coin interrupt
L2814:
				lda			$a7
				and			#$20
				bne			L2833

				lda			$1c
				sta			$5000								; Sprite 1 X
				lda			$1d
				sta			$5040								; Sprite 1 Y
				lda			$22
				sta			$5080								; Sprite 2 X
				lda			$23
				sta			$50c0								; Sprite 2 Y
				lda			$1a
				sta			$5100								; Sprite #s

L2833:
				inc			$a2
				bpl			L283b

				lda			#$80
				sta			$a2
L283b:
				lda			$30
				ora			#$80
				sta			$30
				jmp			L26ef								; End of handler


				;; Flash press start
L2844:
				dec			L0316
				bne			L286d								; No change until timer expires

				lda			L0317
				bpl			L285b								;

				lda			#$07									; OR ________
				jsr			L2b00								; Draw language string a
				lda			#$18
				sta			L0316
				jmp			L2865

L285b:
				lda			#$06									; OR PRESS START
				jsr			L2b00								; Draw language string a
				lda			#$26
				sta			L0316

L2865:
				lda			L0317
				eor			#$ff
				sta			L0317
L286d:
				rts


L286e:
				lda			#$01
				sta			$28
				lda			#$0a
				sta			$b1
				jsr			L25d3
				jsr			L22f9								; Draw player scores
				jsr			L2271								; Draw HI SCR
				lda			#$00
				sta			$a7
				rts

L2884:
				lda			$3e
				and			#$20
				bne			L288e
				dec			$b3
				bmi			L288f
L288e:
				rts
L288f:
				lda			#$05
				sta			$b3
				inc			$b8
				inc			$b9
				lda			$80
				beq			L28dd
				cmp			#$06
				bcs			L28dd
				sta			$86
				lda			$b9
				and			#$03
				tax
				lda			L3604, x
				tax
				stx			$41
				inx
				stx			$42
				inx
				stx			$43
				inx
				stx			$44
				ldx			#$00
L28b7:
				lda			L0350, x
				inx
				sta			$b4
				lda			L0350, x
				inx
				sta			$b5
				lda			$41
				ldy			#$00
				sta			($b4), y
				lda			$42
				iny
				sta			($b4), y
				ldy			#$20
				lda			$43
				sta			($b4), y
				iny
				lda			$44
				sta			($b4), y
				dec			$86
				bne			L28b7
L28dd:
				rts
L28de:
				ldx			$82
				stx			$01
				ldy			#$00
				sty			$83
L28e6:
				ldx			$01
				ldy			$83
				lda			L0330, y
				jsr			L2a6a
				jsr			L2a7e
				ldy			$83
				lda			$b4
				sta			L0350, y
				iny
				lda			$b5
				sta			L0350, y
				iny
				sty			$83
				dec			$01
				bpl			L28e6
				jsr			L290e
				jsr			L2ab5
				rts
L290e:
				ldy			#$00
				sty			$83
				lda			$81
				sta			$41
L2916:
				jsr			L2968
				jsr			L2a1e
				bcs			L292c
				lda			$94
				eor			#$ff
				and			#$02
				clc
				adc			#$b0
				sta			$03
				jsr			L2931
L292c:
				dec			$41
				bpl			L2916
				rts
L2931:
				lda			$94
				asl			a
				tax
				jsr			L293b
				inx
				inc			$03
L293b:
				ldy			L3614, x
				jsr			L2950
				ldy			L360c, x
				jsr			L2950
				ldy			L361c, x
				jsr			L2950
				inc			$05
				rts
L2950:
				lda			($66), y
				cmp			#$e0
				bcs			L2962
				cmp			#$b0
				bcc			L295e
				cmp			#$b4
				bcc			L2963
L295e:
				lda			$03
				sta			($66), y
L2962:
				rts
L2963:
				lda			#$b4
				sta			($66), y
				rts
L2968:
				ldy			$83
				jsr			L2970
				sty			$83
				rts
L2970:
				lda			L0350, y
				sta			$0e
				clc
				adc			#$be
				sta			$66
				iny
				lda			L0350, y
				sta			$0f
				adc			#$ff
				sta			$67
				iny
				rts
L2986:
				lda			$81
				asl			a
				sta			$82
				sta			$48
				asl			a
				sta			$03
				ldx			$03
				lda			#$ff
L2994:
				sta			L0330, x
				dex
				bpl			L2994
				ldx			#$00
				stx			$84
L299e:
				jsr			L29a6
				dec			$03
				bpl			L299e
				rts
L29a6:
				jsr			L29c0
				jsr			L2a5c
				bcs			L29a6
				ldx			$84
				sta			L0330, x
				ldx			$48
				sta			L0330, x
				inc			L0330, x
				inc			$84
				inc			$48
				rts
L29c0:
				jsr			L2e4c
				and			#$7f
				cmp			#$4f
				bcc			L29ca
				lsr			a
L29ca:
				clc
				adc			#$01
				rts

			;; Copy P1 values to active
L29ce:
				ldx			#$00
				jmp			L29d5

			;; Copy P2 values to active
L29d3:
				ldx			#$01
L29d5:
				lda			$d0, x
				sta			$bd
				lda			$d2, x
				sta			$be
				lda			$d4, x
				sta			$b1
				lda			$d6, x
				sta			$c1
				lda			$da, x
				sta			$c3
				lda			$de, x
				sta			$28
				lda			$79, x
				sta			$74
				lda			$77, x
				sta			$76
				rts

				;; Init P1 values (?)
L29f6:
				ldx			#$00
				jmp			L29fd

				;; Init P2 values (?)
L29fb:
				ldx			#$01
L29fd:
				lda			$bd
				sta			$d0, x								; $bd to $d0 or $d1
				lda			$be
				sta			$d2, x								; $be to $d2 or $d3
				lda			$b1
				sta			$d4, x								; $b1 to $d4 or $d5
				lda			$c1
				sta			$d6, x								; $c1 to $d6 or $d7
				lda			$c3
				sta			$da, x								; $c3 to $da or $db
				lda			$28
				sta			$de, x								; $28 to $de or $df
				lda			$74
				sta			$79, x								; $74 to $79 or $7a
				lda			$76
				sta			$77, x								; $76 to $77 or $78
				rts

L2a1e:
				ldx			#$03
L2a20:
				jsr			L2a31
				bcs			L2a3c
				dex
				bpl			L2a20
				jsr			L2e39
				and			#$03
				sta			$94
				clc
				rts
L2a31:
				ldy			L3608, x
				lda			($66), y
				cmp			#$20
				bne			L2a3c
				clc
				rts
L2a3c:
				sec
				rts
L2a3e:
				jsr			L2e39
				cmp			#$51
				bcs			L2a5b
				jsr			L2a5c
				bcs			L2a5b
				sta			$00
				inc			L025c
				lda			L025c
				and			#$0f
				tax
				lda			$00
				sta			L0330, x
				clc
L2a5b:
				rts
L2a5c:
				ldx			#$0f
L2a5e:
				cmp			L0330, x
				beq			L2a68
				dex
				bpl			L2a5e
				clc
				rts
L2a68:
				sec
				rts
L2a6a:
				sta			$41
				lda			#$ff
				sta			$42
				lda			$41
L2a72:
				inc			$42
				sec
				sbc			#$09
				bpl			L2a72
				adc			#$09
				sta			$41
				rts
L2a7e:
				lda			#$40
				sta			$b5
				lda			#$20
				sta			$b4
				lda			$a7
				and			#$04
				beq			L2a94
				lda			#$3f
				sta			$b5
				lda			#$e0
				sta			$b4
L2a94:
				lda			#$60
				clc
				adc			$b4
				sta			$b4
				lda			$b5
				adc			#$00
				sta			$b5
				dec			$42
				bpl			L2a94
				ldy			#$00
L2aa7:
				iny
				iny
				iny
				dec			$41
				bpl			L2aa7
				tya
				clc
				adc			$b4
				sta			$b4
				rts
L2ab5:
				lda			$80
				sta			$01
				lda			#$00
				sta			$83
				sta			$84
L2abf:
				jsr			L2ac7
				dec			$01
				bpl			L2abf
				rts
L2ac7:
				jsr			L2e4c
				and			#$3f
				cmp			#$2c
				bcc			L2ad1
				lsr			a
L2ad1:
				adc			#$12
				jsr			L2a5c
				bcs			L2ac7
				ldx			$84
				sta			L0330, x
				jsr			L2a6a
				jsr			L2a7e
				lda			$b4
				ldy			$83
				sta			L0350, y
				lda			$b5
				iny
				sta			L0350, y
				dey
				jsr			L2970
				jsr			L2a1e
				bcs			L2ac7
				inc			$84
				inc			$83
				inc			$83
				rts

				;; Draw language string a
L2b00:
				asl			a										; a*2
				asl			a										; a*4
				tay													; y = a*4
				lda			$5103								; Interrupt condition
				and			#$03									; Mask language
				asl			a										; lang << 1
				tax													; X = lang << 1

				lda			L3f01, x
				sta			$06									; Language ptr lo
				inx
				lda			L3f01, x
				sta			$07									; Language ptr hi

				lda			($06), y
				sta			$0e									; Screen loc lo
				iny
				lda			($06), y
				sta			$0f									; Screen loc hi
				iny

				lda			($06), y
				sta			$14									; String log lo
				iny
				lda			($06), y
				sta			$15									; String loc hi
				
				lda			$a7
				and			#$04
				bne			L2b3b

				ldy			#$00
L2b30:
				lda			($14), y
				bne			L2b35
				rts
L2b35:
				sta			($0e), y
				iny
				jmp			L2b30

L2b3b:
				lda			$0e
				eor			#$ff
				sta			$0e
				lda			$0f
				eor			#$ff
				and			#$03
				ora			#$40
				sta			$0f
				ldy			#$00
				sty			$02
L2b4f:
				lda			($14), y
				bne			L2b54
				rts
L2b54:
				ldy			#$00
				sta			($0e), y
				dec			$0e
				inc			$02
				ldy			$02
				jmp			L2b4f

				;; Draw DEPOSIT COIN
L2b61:
				lda			#$05										; DEPOSIT COIN
				jsr			L2b00										; Draw language string a
				lda			$a1											; Credits
				bne			L2b6b
				rts

				;; Draw "OR PRESS START"
L2b6b:
				lda			#$06										; OR PRESS START
				jmp			L2b00										; Draw language string a


				;; Draw quarter coinage
L2b70:
				lda			$5100										; DIPs
				eor			#$ff										; Invert
				and			#$18										; Mask bits
				beq			L2b82										; 2P_1C
				cmp			#$10
				beq			L2b87										; 1P_1C
				cmp			#$08
				beq			L2b91										; 1P_2C
				rts

L2b82:
				lda			#$00										; 2 players 1 coin
				jmp			L2b00										; Draw language string a

L2b87:
				lda			#$01										; 1 player  1 coin
				jsr			L2b00										; Draw language string a

				lda			#$02										; 2 players 2 coins
				jmp			L2b00										; Draw language string a

L2b91:
				lda			#$03										; 1 player  2 coins
				jsr			L2b00										; Draw language string a

				lda			#$04										; 2 players 4 coins
				jmp			L2b00										; Draw language string a


L2b9b:
				lda			$a7
				ora			#$10									; Set bit 4
				sta			$a7

				lda			#$10									; TOP HIGH SCORE FOR EXTRA PLAY
				jmp			L2b00								; Draw language string a

L2ba6:
				jsr			L2e25								; Clear screen
				lda			#$0c
				sta			$0e
				lda			#$0f									; TOP HIGH SCORE FOR EXTRA PLAY
				jsr			L2b00								; Draw language string a
				jmp			L2d50


				;; Draw pence coinage
L2bb5:
				lda			$5100										; DIPs
				eor			#$ff										; Invert
				and			#$02
				bne			L2bc8										; Full coins	

				lda			#$18										;	1P - 2 10p
				jsr			L2b00										; Draw language string a
				lda			#$19										; 3P - 1 50p
				jmp			L2b00										; Draw language string a

L2bc8:
				lda			#$16										; 1P - 1 10p
				jsr			L2b00										; Draw language string a
				lda			#$17										; 6P - 1 50p
				jmp			L2b00										; Draw language string a

L2bd2:
				lda			$be
				cmp			$af
				beq			L2bdb
				bcs			L2be2
				rts
L2bdb:
				lda			$bd
				cmp			$ae
				bcs			L2be2
				rts
L2be2:
				lda			$bd
				sta			$ae
				lda			$be
				sta			$af
				lda			$a7
				and			#$fc
				sta			$a7
				lda			$bf
				and			#$03
				ora			$a7
				sta			$a7
				rts
				lda			#$60
				jmp			L2c05
L2bfe:
				lda			#$40
				jmp			L2c05
L2c03:
				lda			#$20
L2c05:
				clc
				adc			$0e
				sta			$0e
				lda			$0f
				adc			#$00
				sta			$0f
				rts
				lda			#$60
				jmp			L2c1d
				lda			#$40
				jmp			L2c1d
				lda			#$20
L2c1d:
				sta			$00
				sec
				lda			$0e
				sbc			$00
				sta			$0e
				lda			$0f
				sbc			#$00
				sta			$0f
				rts
L2c2d:
				lda			#$40
				sta			$0f
				rts
L2c32:
				lda			$a7
				and			#$04
				bne			L2c3b
				jmp			L2cca
L2c3b:
				jsr			L2c47
				lda			#$40
				sta			$0f
				sta			$0e
				jmp			L2cd4
L2c47:
				jsr			L2c2d
				lda			#$02
				sta			$0e
				lda			#$e0
				jsr			L2d34
				lda			#$43
				sta			$0f
				lda			#$a2
				sta			$0e
				lda			#$e1
				jsr			L2d34
				jsr			L2c2d
				lda			#$20
				sta			$0e
				lda			#$e3
				jsr			L2d3c
				jsr			L2c2d
				lda			#$21
				sta			$0e
				lda			#$e2
				jmp			L2d41

L2c78:
				jsr			L2d84								; Set up character RAM
				lda			#$00
				sta			$18
				lda			#$48
				sta			$19
L2c83:
				jsr			L2c8b

				cmp			#$4d
				bcc			L2c83
				rts

L2c8b:
				ldx			#$07
				ldy			#$00
				sty			$42									; Stash y
				ldy			#$07
				sty			$02
L2c95:
				lda			#$08
				sta			$03
				ldy			$42									; Restore y
				
				lda			($18), y
L2c9d:
				ror			a
				rol			$41
				dec			$03
				bne			L2c9d

				lda			$41
				ldy			$02
				sta			L03f0, y
				dec			$02
				inc			$42
				dex
				bpl			L2c95

				ldy			#$07
L2cb4:
				lda			L03f0, y
				sta			($18), y
				dey
				bpl			L2cb4
				lda			$18
				clc
				adc			#$08
				sta			$18
				lda			$19
				adc			#$00
				sta			$19
				rts

L2cca:
				jsr			L2d02
				jsr			L2c2d
				lda			#$80
				sta			$0e
L2cd4:
				ldx			#$09
L2cd6:
				lda			#$ba
				jsr			L2cea
				jsr			L2c03
				lda			#$bc
				jsr			L2cea
				jsr			L2bfe
				dex
				bne			L2cd6
				rts
L2cea:
				ldy			#$03
				sta			$03
				sta			$04
				inc			$04
L2cf2:
				lda			$03
				sta			($0e), y
				iny
				lda			$04
				sta			($0e), y
				iny
				iny
				cpy			#$1d
				bcc			L2cf2
				rts
L2d02:
				jsr			L2c2d
				lda			#$42
				sta			$0e
				lda			#$e0
				jsr			L2d34
				lda			#$43
				sta			$0f
				lda			#$e2
				sta			$0e
				lda			#$e1
				jsr			L2d34
				jsr			L2c2d
				lda			#$60
				sta			$0e
				lda			#$e3
				jsr			L2d3c
				jsr			L2c2d
				lda			#$61
				sta			$0e
				lda			#$e2
				jsr			L2d41
				rts
L2d34:
				ldy			#$1c
L2d36:
				dey
				sta			($0e), y
				bne			L2d36
				rts
L2d3c:
				ldy			#$1e
				jmp			L2d43
L2d41:
				ldy			#$00
L2d43:
				ldx			#$1c
L2d45:
				sta			($0e), y
				pha
				jsr			L2c03
				pla
				dex
				bne			L2d45
				rts

				;; Delay
L2d50:
				jsr			L2d53
L2d53:
				jsr			L2d56
L2d56:
				jsr			L2d59
L2d59:
				jsr			L2d5c
L2d5c:
				lda			#$00
				sta			$16
				sta			$17
L2d62:
				inc			$16
L2d64:
				inc			$17
				lda			#$26
				cmp			$17
				bne			L2d64								; Loop
				cmp			$16
				bne			L2d62								; Loop
				rts

L2d71:
				lda			$5100
				eor			#$ff
				and			#$60										; Mask D6,5
				lsr			a												; a>>1
				lsr			a												; a>>2
				lsr			a												; a>>3
				lsr			a												; a>>4
				lsr			a												; a>>5
				tax
				lda			L3295, x
				sta			$c1
				rts

				;; Set up character RAM
				;; Clear char rams
L2d84:
				lda			#$00
				tax
L2d87:
				sta			$4800, x
				sta			$4900, x
				sta			$4a00, x
				sta			$4b00, x
				sta			$4c00, x
				sta			$4d00, x
				sta			$4e00, x
				sta			$4f00, x
				dex
				bne			L2d87								; Loop

				;; Copy 10 chars
				ldx			#$50
L2da4:
				lda			L3165, x							; Numbers
				sta			$4980, x							; Chars $30-39
				dex
				bpl			L2da4

				;; Copy 27 chars
				;; Alphabet + @
				ldx			#$d7									; Change this to $ef
L2daf:
				lda			L31b5, x							; Letters
				sta			$4a08, x							; Chars $41-5b
				dex
				cpx			#$ff
				bne			L2daf

				;; Copy 4 chars
				;; Car directions
				ldx			#$1f
L2dbc:
				lda			L3015, x
				sta			$4f20, x							; Chars $e4-e7
				dex
				bpl			L2dbc

				;; Horizonal hash
				lda			#$aa
				sta			$4f06								; Char $e0
				sta			$4f09								; Char $e1

				lda			#$55
				sta			$4f07								; Char $e0
				sta			$4f08								; Char $e1

				;; Copy 2 chars
				;; Vertical walls
				ldx			#$0f
L2dd7:
				lda			L3095, x
				sta			$4f10, x							; Chars $e2-e3
				dex
				bpl			L2dd7

				;; Copy 12 chars
				;; Corner types
				ldx			#$5f
L2de2:
				lda			L3035, x
				sta			$4d00, x							; Chars $a0-ab
				dex
				bpl			L2de2

				;; Copy 4 chars
				;;
				ldx			#$1f
L2ded:
				lda			L30a5, x
				sta			$4dd0, x							; Chars $ba-bd
				dex
				bpl			L2ded

				;; Copy 5 chars
				;;
				ldx			#$27
L2df8:
				lda			L30c5, x
				sta			$4d80, x							; Chars	$b0-b4
				sta			$4950, x							; Chars	$2a-2e
				dex
				bpl			L2df8

				;; Copy 1 chars
				;;
				ldx			#$07
L2e06:
				lda			L3285, x							; @
				sta			$4af8, x							; Char $5f
				lda			L328d, x							; #
				sta			$4af0, x							; Char $5e
				dex
				bpl			L2e06
				rts

				;; Split nybbles
L2e16:
				sta			$52									; Store
				lsr			a
				lsr			a
				lsr			a
				lsr			a										; a>>4
				pha													; Push hi nybble
				lda			$52
				and			#$0f									; Mask lo nybble
				sta			$52
				pla													; Retrive hi nybble
				rts

				;; Clear screen
L2e25:
				lda			#$20
				ldx			#$00
L2e29:
				sta			$4000, x
				sta			$4100, x
				sta			$4200, x
				sta			$4300, x
				dex
				bne			L2e29
				rts

L2e39:
				lda			$62
				sta			$60
				lda			$63
				beq			L2e4c
				cmp			#$fd
				bcs			L2e4c
				sta			$62
				adc			$60
				sta			$63
				rts
L2e4c:
				tya
				pha
				ldy			#$23
L2e50:
				lda			$63
				beq			L2e61
				and			#$60
				cmp			#$20
				beq			L2e61
				cmp			#$40
				beq			L2e61
				clc
				bcc			L2e62
L2e61:
				sec
L2e62:
				rol			$62
				rol			$63
				dey
				bne			L2e50
				pla
				tay
				lda			$62
				rts

				lda			#$4e
				sta			$43
				ldy			#$08
				bne			L2e7c

				ldy			#$02
L2e78:
				lda			#$48
				sta			$43					; ($42-43) = 48xx
L2e7c:
				nop

				;; Get ($40-$41) from table
				;; Pts to enemy chars
				lda			L314d, y
				sta			$40
				iny
				lda			L314d, y
				sta			$41
				nop

				jsr			L2ede				; Copy char to $ff spot, $03f0, $0ef8

				lda			#$00
				sta			$42					; ($42-43) = 4800

				jsr			L2fb3				; $03e0-$03ef to chars
				ldx			#$03					; 3 loops
				stx			$86					; Loop counter
L2e97:
				jsr			L2feb				; Scroll $03e0-$03ef up twice
				jsr			L2fb3				; $03e0-$03ef to chars
				dec			$86
				bne			L2e97				; Loop

				jsr			L2ef4				; HFlip $03f0 char to $03e0
				jsr			L2fb3				; $03e0-$03ef to chars

				ldx			#$03					; 3 Loops
				stx			$86					; Loop counter
L2eab:
				jsr			L3001
				jsr			L2fb3
				dec			$86
				bne			L2eab				; Loop

				jsr			L2f02
				jsr			L2fb3
				ldx			#$03
				stx			$86
L2ebf:
				jsr			L2fdb
				jsr			L2fb3
				dec			$86
				bne			L2ebf
				jsr			L2f2e
				jsr			L2fb3
				ldx			#$03
				stx			$86
L2ed3:
				jsr			L2fcb
				jsr			L2fb3
				dec			$86
				bne			L2ed3
				rts

				;; Copy char to $ff, main RAM
L2ede:
				ldy			#$07
L2ee0:
				lda			($40), y							; Get byte from table
				sta			L03e8, y							; Store to main RAM
				sta			L03f0, y							; Store to main RAM
				sta			$4f80, y							; Char $ff
				lda			#$00
				sta			L03e0, y							; Clear in main RAM
				dey
				bpl			L2ee0
				rts


L2ef4:
				jsr			L2f85
L2ef7:
				ldy			#$07
L2ef9:
				lda			#$00
				sta			L03e8, y
				dey
				bne			L2ef9
				rts
L2f02:
				jsr			L2f0c
				jsr			L2f5a
				jsr			L2ef7
				rts
L2f0c:
				ldy			#$07
L2f0e:
				lda			L03f0, y
				sta			L03e0, y
				lda			#$00
				sta			L03e8, y
				dey
				bpl			L2f0e
				rts
				ldy			#$07
L2f1f:
				lda			L03f0, y
				sta			L03e8, y
				lda			#$00
				sta			L03e0, y
				dey
				bpl			L2f1f
				rts
L2f2e:
				jsr			L2f0c
				jsr			L2f3f
				ldy			#$07
L2f36:
				lda			#$00
				sta			L03e0, y
				dey
				bpl			L2f36
				rts
L2f3f:
				ldy			#$00
L2f41:
				lda			L03e0, y
				jsr			L2f4d
				iny
				cpy			#$08
				bne			L2f41
				rts
L2f4d:
				ldx			#$07
				sta			$03
L2f51:
				rol			$03
				rol			L03e8, x
				dex
				bpl			L2f51
				rts
L2f5a:
				ldy			#$00
L2f5c:
				lda			L03e0, y
				jsr			L2f78
				iny
				cpy			#$08
				bne			L2f5c
				ldy			#$07
L2f69:
				lda			L03e8, y
				sta			L03e0, y
				lda			#$00
				sta			L03e8, y
				dey
				bpl			L2f69
				rts
L2f78:
				ldx			#$07
				sta			$03
L2f7c:
				rol			$03
				ror			L03e8, x
				dex
				bpl			L2f7c
				rts

				;; Flip $03f0 char right-left into $03e0
L2f85:
				ldx			#$07
				ldy			#$00
				sty			$45									; Index
				ldy			#$07									; 7 (8) loops
				sty			$02									; Outer loop counter
L2f8f:
				lda			#$08									; 8 loops
				sta			$03									; Inner Loop counter

				ldy			$45
				lda			L03f0, y
L2f98:
				ror			a
				rol			$44
				dec			$03
				bne			L2f98								; Loop

				lda			$44
				ldy			$02
				sta			L03e0, y
				lda			#$00
				sta			L03e8, y
				dec			$02
				inc			$45
				dex
				bpl			L2f8f								; Loop
				rts

				;; Copy 16 bytes to char code @ ($42-43)
L2fb3:
				ldy			#$0f
L2fb5:
				lda			L03e0, y
				sta			($42), y
				dey
				bpl			L2fb5
				clc

				;; ($42-43) += $10
				lda			$42
				adc			#$10
				sta			$42
				lda			$43
				adc			#$00
				sta			$43
				rts


L2fcb:
				jsr			L2fce
L2fce:
				ldx			#$07
L2fd0:
				clc
				asl			L03e8, x
				rol			L03e0, x
				dex
				bpl			L2fd0
				rts
L2fdb:
				jsr			L2fde
L2fde:
				ldx			#$07
L2fe0:
				clc
				lsr			L03e0, x
				ror			L03e8, x
				dex
				bpl			L2fe0
				rts

				;; ($03e0-$03ef) <= ($03e2-$03ef, $00, $00)
L2feb:
				jsr			L2fee								; Do this twice

				;; Scroll 2 chars in memory up
L2fee:
				ldx			#$00
L2ff0:
				lda			L03e1, x
				sta			L03e0, x
				inx
				cpx			#$0f
				bne			L2ff0								; Loop
				lda			#$00
				sta			L03ef								; Clear final byte
				rts


L3001:
				jsr			L3004
L3004:
				ldx			#$0e
L3006:
				lda			L03e0, x
				sta			L03e1, x
				dex
				bpl			L3006
				lda			#$00
				sta			L03e0
				rts

				;;
				;; Main character codes
				;;

.include "specchar.asm"

				;; Table (4 entries)
L3295:
				.db			$02, $03, $04, $05			; Lives?

L3299:
				.db			$20, $00, $00, $01			; DATA

L329d:
				.db			$10, $18, $08, $00			; DATA
				.db			$18, $10, $00, $08			; DATA

L32a5:
				.db			$00, $1f, $01, $e0			; DATA
				.db			$ff, $20, $e1, $00			; DATA

L32ad:
				.db			$00, $00, $00, $ff			; DATA
				.db			$ff, $00, $ff, $00			; DATA

L32b5:
				.db			$01, $01, $20, $20			; DATA

L32b9:
				.db			$e0, $20, $01, $ff			; DATA

L32bd:
				.db			$ff, $00, $00, $ff			; DATA

L32c1:
				.db			$c0, $80								; DATA 
			
L32c3:
				.db			$50, $60								; DATA

L32c5:
				.db			$20, $e0, $ff, $01			; DATA

L32c9:
				.db			$00, $ff, $ff, $00			; DATA

L32cd:	
				.db			$01, $20, $22, $00			; DATA
				.db			$61, $42, $40, $00			; DATA
				.db			$23, $02, $42, $00			; DATA
				.db			$20, $41, $01, $00			; DATA

L32dd:
				.db			$00, $20, $a0, $80			; DATA
				.db			$43, $42, $3e, $3f			; DATA

L32e5:
				.db			$03, $03, $02, $02			; DATA

L32e9:
				.db			$00, $02, $01, $80			; DATA

L32ed:
				.db			$02, $00, $80, $01			; DATA

L32f1:
				.db			$01, $80, $02, $00			; DATA

L32f5:
				.db			$80, $01, $00, $02			; DATA

L32f9:
				.db			$2c, $2d, $2e, $2f			; DATA
				.db			$b0, $b1, $b2, $b3			; DATA
				.db			$e0, $e1, $e2, $e3			; DATA

L3305:
				.db			$00, $00, $fd, $02			; DATA

L3309:
				.db			$02, $fd, $00, $00			; DATA

L330d:
				.db			$05, $05, $05, $05			; DATA
				.db			$05, $05, $0f, $02			; DATA

L3315:
				.db			$02, $02, $01, $01			; DATA
				.db			$01, $01, $01, $01			; DATA
				
L331d:
				.db			$01, $01, $01, $01			; DATA
				.db			$01, $01, $01, $02			; DATA

L3325:
				.db			$00, $ff, $ff, $00			; DATA

L3329:
				.db			$55, $aa, $55, $aa			; DATA
				.db			$a0, $b4, $a0, $80			; DATA
				.db			$55, $b0, $b8, $c0			; DATA
				.db			$c8, $d0, $d8, $e0			; DATA
				.db			$e8, $f0, $ff						; DATA
				
L333c:
				.db			$01, $02, $20, $23			; DATA
				.db			$40, $43, $60, $63			; DATA
				.db			$80, $83, $a1, $a2			; DATA
				.db			$ff, $00, $01, $21			; DATA
				.db			$41, $61, $81, $a0			; DATA
				.db			$a1, $a2, $ff, $00			; DATA
				.db			$01, $02, $20, $22			; DATA
				.db			$42, $60, $61, $62			; DATA
				.db			$80, $a0, $a1, $a2			; DATA
				.db			$ff, $00, $01, $02			; DATA
				.db			$22, $41, $42, $62			; DATA
				.db			$82, $a0, $a1, $a2			; DATA
				.db			$ff, $02, $20, $22			; DATA
				.db			$40, $42, $60, $61			; DATA
				.db			$62, $63, $82, $a1			; DATA
				.db			$a2, $a3, $ff, $00			; DATA
				.db			$01, $02, $20, $40			; DATA
				.db			$41, $42, $43, $63			; DATA
				.db			$83, $a0, $a1, $a2			; DATA
				.db			$a3, $ff, $00, $01			; DATA
				.db			$02, $20, $40, $60			; DATA
				.db			$61, $62, $63, $80			; DATA
				.db			$83, $a0, $a1, $a2			; DATA
				.db			$a3, $ff, $00, $01			; DATA
				.db			$02, $03, $23, $42			; DATA
				.db			$43, $61, $62, $81			; DATA
				.db			$a1, $ff, $01, $02			; DATA
				.db			$03, $21, $23, $40			; DATA
				.db			$41, $42, $43, $60			; DATA
				.db			$63, $80, $83, $a0			; DATA
				.db			$a1, $a2, $a3, $ff			; DATA
				.db			$00, $01, $02, $03			; DATA
				.db			$20, $23, $40, $41			; DATA
				.db			$42, $43, $63, $83			; DATA
				.db			$a1, $a2, $a3, $ff			; DATA
	
L33c8:
				.db			$00, $0d, $17, $25			;
				.db			$31, $3f, $4e, $5e			;
				.db			$6a, $7c								; 

L33d2:
				.db			$b8, $c0, $c8, $d0			; 
				.db			$d8, $e0, $e8, $f0			;
				.db			$ff
				
				;; Table (8 entries)
L33db:
				.db			$20, $04, $40, $08			;
				.db			$40, $04, $20, $08			;

				;; Table (audio)
L33e3:
				.db			$c0, $c8, $d0, $d8			; 
				.db			$e0, $e8, $f0, $ff			; 
				.db			$c0, $c8, $d0, $d8			; 
				.db			$e0, $e8, $ff, $f0			; 
				.db			$ff, $f0, $ff						; 
				
L33f6:
				.db			$03, $03, $03, $03			; 
				.db			$03, $03, $03, $03			; 
				.db			$03, $04, $04, $05			; 
				.db			$06, $07, $01, $08			; 
				.db			$01, $09, $09						; 
				
L3409:
				.db			$d0, $d0, $00, $00			; 
				.db			$00, $00, $d0, $d0			; 

L3411:
				.db			$f3, $f0, $f2, $f1			; 
				.db			$f2, $f1, $f3, $f0			; 

L3419:
				.db			$00, $01, $00, $ff			; 
				.db			$00, $ff, $00, $01			; 

L3421:
				.db			$01, $00, $ff, $00			; 
				.db			$ff, $00, $01, $00			; 
				
L3429:
				.db			$c0, $ca, $d0, $ca			; DATA
				.db			$d8, $d0, $dc, $d8			; DATA
				.db			$e0, $c0, $ca, $d0			; DATA
				.db			$ca, $d8, $d0, $dc			; DATA
				.db			$d8, $e0, $c0, $ca			; DATA
				.db			$d0, $ca, $d0, $d8			; DATA
				.db			$e0, $e8								; DATA

L3443:
				.db			$03, $03, $03, $03			; DATA
				.db			$03, $03, $03, $03			; DATA
				.db			$03, $01, $01, $01			; DATA
				.db			$01, $01, $01, $01			; DATA
				.db			$01, $01, $01, $01			; DATA
				.db			$01, $01, $01, $01			; DATA
				.db			$01, $7f								; DATA

				;; Table (4 entries)
L345d:
				.db			$ff, $e8, $e0, $d0			; DATA

				;; Table ??
L3461:
				.db			$00, $0e, $00, $0e			; DATA
				.db			$00, $0e, $00, $0e			; DATA
				.db			$40, $4a, $40, $4a			; DATA
				.db			$40, $4a, $40, $4a			; DATA
				.db			$1b, $28, $1b, $28			; DATA
				.db			$1b, $28, $1b, $28			; DATA
				.db			$55, $5e, $55, $5e			; DATA
				.db			$55, $5e, $55, $5e			; DATA
				.db			$1b, $ff, $1b, $ff			; DATA
				.db			$40, $ff, $40, $ff			; DATA
				.db			$28, $ff, $28, $ff			; DATA
				.db			$4a, $ff, $4a, $ff			; DATA
				.db			$1b, $ff, $1b, $ff			; DATA
				.db			$40, $ff, $40, $ff			; DATA
				.db			$28, $ff, $28, $ff			; DATA
				.db			$4a, $ff, $4a, $ff			; DATA

				;; Table
L34a1:
				.db			$ed, $eb, $e9, $e7			; ??
				.db			$e5, $e3, $e1, $df			; ??
				.db			$ff											; ?? 

				;; Table (4 entries)
L34aa:
				.db			$0e, $ff, $00, $ff


				;;
				;; More gfx codes
				;;

.include "specchar2.asm"


				;; ???
L35ee:
				.db			$02, $0a
				.db			$12, $52
				.db			$62, $72

				;; 4 byte table -- 4 entries?
L35f4:
				.db			$24, $18, $18, $24			; DATA
				.db			$08, $38, $1c, $10			; DATA
				.db			$10, $1c, $38, $08			; DATA
				.db			$00, $18, $18, $00			; DATA

				;; Table
L3604:
				.db			$a0, $a4, $a8, $ba			; DATA

L3608:
				.db			$22, $82, $44, $41			; 

				;; Table
L360c:
				.db			$02, $03, $62, $63			;
				.db			$43, $63, $40, $60			;

				;; Table
L3614:
				.db			$22, $23, $82, $83			;
				.db			$44, $64, $41, $61			;

				;; Table
L361c:
				.db			$42, $43, $A2, $A3			;
				.db			$45, $65, $42, $62			;

				;; Table
L3624:
				.db			$9A, $AA, $BC, $CD			;
				.db			$D5, $DE, $E7, $FF			;


				;;
				;; String data

.include "spectext.asm"
.include "specttbl.asm"

				;; Score locations
L3f7d:
				.dw			$4022										; P1
				.dw			$403a										; P2
				.dw			$4032										; High

				;; Score locations for flip
L3f83:
				.dw			$43d8										; P1
				.dw			$43c1										; P2
				.dw			$43c9										; High

				;; Pointers to map chars, per level
L3f89:
				.dw			L350e										; $00 
				.dw			L354e										; $01 
				.dw			L358e										; $02 
				.dw			L34ee										; $03 
				.dw			L352e										; $06 
				.dw			L34ae										; $05 
				.dw			L356e										; $06
				.dw			L34ce										; $07
				.dw			L35ae										; $08 
				.dw			L35ce										; $09 
				.dw			L350e										; $0a 
				.dw			L354e										; $0b 
				.dw			L358e										; $0e 
				.dw			L34ee										; $0d 
				.dw			L352e										; $0e 
				.dw			L34ae										; $0f

L3fa9:
				.dw			L26de										; IRQ vector

				;; Garbage?
L3fab:
				.db			$b2, $34, $e2, $26			; DATA
				.db			$42, $14, $38, $64			; DATA
				.db			$41, $75, $38, $84			; DATA
				.db			$41, $47, $38, $64			; DATA
				.db			$41, $59, $38, $84			; DATA
				.db			$41, $6a, $38, $2d			; DATA
				.db			$40, $7c, $38, $02			; DATA
				.db			$00, $81, $38, $1a			; DATA
				.db			$00, $86, $38, $22			; DATA
				.db			$40, $3a, $01, $32			; DATA
				.db			$40, $d8, $03, $c1			; DATA
				.db			$43, $c9, $43, $5f			; DATA
				.db			$35, $9f, $35, $df			; DATA
				.db			$35, $3f, $35, $7f			; DATA
				.db			$35, $ff, $34, $ff			; DATA
				.db			$35, $1f, $35, $ff			; DATA
				.db			$35, $1f, $36, $5f			; DATA
				.db			$77, $9f, $35, $df			; DATA
				.db			$35, $3f, $75, $7f			; DATA
				.db			$35, $ff, $34						; DATA

				.org		$3ffa
				.dw			LRESET					; BRK Vector
				.dw			LRESET					; Reset vector
				.dw			LIRQ						; IRQ Vector

				.end
