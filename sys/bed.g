; Bed.g ft. Klicky Support
; called to perform automatic bed compensation via G32
	
;----------------------------- Customizable Varibale - Edit for your Printer ---------
var klickypinname = "e0stop"        ; board assignment for zprobe port
var zpinname = "zstop"              ; board assignment for zendstop port
var klickyTriggerOffset = 0.35      ; z distance btw triggered klicky height & klicky body 
var klickydockx = 41.5              ; x coordinate for klicky dock
var klickydocky = 257               ; y coordinate for clicky dock
var klickywipe = 40                 ; x axis distance to separate docked klicky
var zpinx = 146                     ; z endstop x coordinate
var zpiny = 255                     ; z endstop y coordinate
var klickyOffsetX = 0               ; x offset between klicky switch & nozzle
var klickyOffsetY = 19              ; y offset between klicky switch & nozzle
var klickyOffsetZ = 7.009           ; z offset between klicky switch & nozzle
var autozdrivecurrent = 550 
var autozdrivespeed = 250 
var autozdriveaccel = 800 
var autozdrivejerk = 150
;---------------------------------------------------------------------------------
; ----------------------------- Static Variables - No Touch ---------------------- 
var autoz = 0
var autoz_pass1 = 10
var autoz_pass2 = 30
var restorezidle = move.idle.factor
var restorezcurrent = move.axes[2].current
var restorezspeed = move.axes[2].speed
var restorezaccel = move.axes[2].acceleration
var restorezjerk = move.axes[2].jerk
;-----------------------------------------------------------------------------

;---------------------- SETUP -----------------------
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
	G28					; home axis if needed
G29 S2 					; disable mesh
M290 R0 S0 				; RESET BABY STEPPING
G91            			; relative positioning
G1 Z15 F1800			; homed move up
G90						; absolute positioning
M574 Z0 C"nil"  		; if no Z endstop switch, free up Z endstop input may not be needed
M558 P5 C{var.zpinname} I0 H2 R0.1 F240:120 T6000 A30 S0.0025	; define Z endstop for good measure
G31 P1000 X0 Y0 Z0.0	; Set ZProbe 

; ---------  Measure nozzle height against Z endstop ------
G1 X{var.zpinx} Y{var.zpiny - 60} F6000       	; ease over to the z pin
G1 X{var.zpinx} Y{var.zpiny}                  	; move to directly above mechanical Z-switch
M913 Z100                            			; restore motor current percentage to 100%
M906 I100                            			; idle current for the autoz process
M906 Z{var.autozdrivecurrent}        			; motor drive current
M203 Z{var.autozdrivespeed}          			; maximum speed (mm/min)
M201 Z{var.autozdriveaccel}          			; maximum acceleration (mm^2/s)
M566 Z{var.autozdrivejerk}           			; instantaneous speed change (mm/min)
G30 								 			; zero the z axis to the nozzle
M913 Z100                            			; restore motor current percentage to 100%
