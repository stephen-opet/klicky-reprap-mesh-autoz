; bed.g ft Klicky Support
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
M906 Z{var.restorezidle}             			; idle current before the autoz process
M906 Z{var.restorezcurrent}          			; motor drive current before the autoz process
M203 Z{var.restorezspeed}            			; maximum speed (mm/min) before the autoz process
M201 Z{var.restorezaccel}            			; maximum acceleration (mm^2/s) before the autoz process
M566 Z{var.restorezjerk}             			; instantaneous speed change (mm/min) before the autoz process

;-------------- Load Klicky! -----------------
M558 P8 C{var.klickypinname} I0 A30 H3 R0.1 F240:120 T99999 S0.0025 		; Define ZProbe as Klicky!
G31 P1000 X{var.klickyOffsetX} Y{var.klickyOffsetY} Z{var.klickyOffsetZ}	; Set offset from nozzle klicky 
if sensors.probes[0].value[0] != 0						;If Klicky is docked...
 G1 Z{var.klickyOffsetZ + 5} F500                       ; z-hop to accomodate Klicky height
 G1 X{var.klickydockx} Y{var.klickydocky - 60} F6000	; position head in front of Klicky Dock
 G1 X{var.klickydockx} Y{var.klickydocky} F6000			; Load klicky
 G1 X{var.klickydockx} Y{var.klickydocky - 60} F6000	; Retreat from Klicky Dock

;------------  Prepare to Probe Klicky Body ------------------
G1 X{var.zpinx - 6} Y{var.zpiny - 60} 							; ease over to the z pin
G1 X{var.zpinx - 6} Y{var.zpiny - var.klickyOffsetY} F6000 		; move klicky boody over z endstop pin
M558 P5 C{var.zpinname} I0 H2 R0.1 F240:120 T6000 A30 S0.0025	; reconfigure Z Endstop
G31 P1000 X0 Y0 Z0.0											; ????
M913 Z100                           							; restore motor current percentage to 100%
M906 I100                           							; idle current for the autoz process
M906 Z{var.autozdrivecurrent}    								; motor drive current
M203 Z{var.autozdrivespeed}      								; maximum speed (mm/min)
M201 Z{var.autozdriveaccel}      								; maximum acceleration (mm^2/s)
M566 Z{var.autozdrivejerk}       								; instantaneous speed change (mm/min)

; ---------- probe klicky switch body ----------
M558 F100:50 													; slower probing speed
while abs(var.autoz_pass1 - var.autoz_pass2) >= 0.004			; loop until successive measurements are essentially equal
	G30 S-1														; probe z value with klicky, no calibration, pass 1
	G1 Z{sensors.probes[0].lastStopHeight + 5} F1800			; Z Hop
	set var.autoz_pass1 = sensors.probes[0].lastStopHeight		; save pass 1 klicky height
	G30 S-1														; probe z value with klicky, no calibration, pass 2
	G1 Z{sensors.probes[0].lastStopHeight + 5} F500				; Z Hop
	set var.autoz_pass2 = sensors.probes[0].lastStopHeight		; save pass 2 klicky height
set var.autoz = (var.autoz_pass1 + var.autoz_pass2) / 2			; save average measured height of Klicky
set var.autoz = var.autoz + var.klickyTriggerOffset				; add trigger height for subsequent probing
echo "Height of Triggered Klicky: " ^ var.autoz ^ "mm"

;------------------  Prepare for AutoZ & ZTilt Klicky Measurements -------------------------
G29 S2 						;Will Not compensate Mesh
M558 P8 C{var.klickypinname} I0 A30 H3 R0.1 F240:120 T99999 S0.0025 		; Define klicky z probe
G31 P1000 X{var.klickyOffsetX} Y{var.klickyOffsetY} Z{var.klickyOffsetZ}	;Set Klicky Offset

;------------------- Run AutoZ ----------------------
G1 Z{var.autoz + 5} F1800									; Z Hop 5mm above Klicky height
G1 X{move.axes[0].max / 2} Y{move.axes[1].max / 2} F6000	; Center printer head
G30 														; Probe for Z=0			
G92 Z{var.autoz + sensors.probes[0].diveHeight} 			; Set new Z=0 position

;----------------- Restore drive configurations--------------------------
M913 Z100 						; restore motor current percentage to 100%
M906 Z{var.restorezidle} 		; idle current before the autoz process
M906 Z{var.restorezcurrent} 	; motor drive current before the autoz process
M203 Z{var.restorezspeed} 		; maximum speed (mm/min) before the autoz process
M201 Z{var.restorezaccel} 		; maximum acceleration (mm^2/s) before the autoz process
M566 Z{var.restorezjerk} 		; instantaneous speed change (mm/min) before the autoz process

;---------------- Dock Klicky Probe -------------------------
; runMesh variable supports klicky mesh compensation in mesh.g
; add this line to your config.g file, uncommented:
	; global runMesh = false
G1 Z{var.autoz + 5} F1800;									; Z Hop
if global.runMesh = false									; if bed.g was NOT called from mesh.g
	G1 X{var.klickydockx} Y{var.klickydocky - 60} F6000		; position head in front of Klicky Dock
	G1 Y{var.klickydocky} F6000								; Dock Klicky
	G1 X{var.klickydockx + var.klickywipe} F6000			; Separate Klicky from Head
	G1 X{var.klickydockx} Y{var.klickydocky - 60} F6000		; Reset probe position

M574 Z1 S1 P"zstop"                            			; reconfigure Z Endstop 
G28														; home, why not?
