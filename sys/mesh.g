;----------------- PRINTER-SPECIFIC VARIABLES, REDEFINE ------------------------
var klickyDockX = 41.5 		; X Coordinate of Klicky Dock
var klickyDockY = 257 		; Y Coordinate of Klicky Dock
var klickyOffsetX = 0		; Offset between nozzle & Klicky in X
var klickyOffsetY = 19		; Offset between nozzle & Klicky in Y
var klickyOffsetZ = 7.2		; Offset between nozzle & Klicky in Z
set global.runMesh = true	; defined in config.g - supports klicky use in bed.g AutoZ
M557 X20:240 Y25:225 S20	; Define mesh grid
;-------------------------------------------------------------------------------

;-------- Setup -----------------------------------------
M561                                ; clear bed transform         
G29 S2                              ; DISABLE ANY MESH
G1 H2 Z10 F1800						; Z Hop

;---------------- Prepare Mesh Compensation -------------
G32																			; Run AutoZ
M558 P5 C"^e0stop" H5 F240 T9000											; Define Klicky Endstop
G31 P1000 X{var.klickyOffsetX} Y{var.klickyOffsetY} Z{var.klickyOffsetZ}	; Set Klicky Offsets

;------------------------ Run mesh Compensation ---------
G29 S0 

;-------------------------------- Dock Klicky -----------
G1 X{var.klickyDockX} Y{var.klickyDockY-60} F6000			
G1 X{var.klickyDockX} Y{var.klickyDockY} F6000
G1 X{var.klickyDockX+60} Y{var.klickyDockY} F6000

;---------------------------------------- Finish Up -----
set global.runMesh = false
M574 X2 S1 P"xstop"                            ; configure microswitch endstop for high end on X 
M574 Y2 S1 P"ystop"                            ; configure microswitch endstop for high end on Y 
M574 Z1 S1 P"zstop"                            ; configure microswitch endstop for low  end on Z 
G28                            	
