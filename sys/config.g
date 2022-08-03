; Steve's RepRap v3.4 Config File
; Written by Steve
; Illustrated by Steve
; Produced by Steve

;------------------------ System -----------------------------
M111 S0											; Debugging, 0=off, 1=on
M550 P"Trident"                         		; set printer name
G21												; set units to mm
G90                                            ; send absolute coordinates...
M83                                            ; ...but relative extruder moves
 
;------------------------ Network ----------------------------
M552 S0											; WiFi Reset
M552 S1 P"ARPANET"								; Enable Wifi, set default SSID
;M587 S"" P""                  					; WIFI change
M586 P1 S1										; disable FTP
M586 P2 S0										; disable telnet

;------------------------ Axis Management ---------------------------
M669 K1                                        ; select CoreXY mode
M208 X0 Y0 Z-0.75 S1                           ; set axis minima
M208 X251 Y257 Z250 S0                         ; set axis maxima
M574 X2 S1 P"xstop"                            ; configure microswitch endstop for high end on X 
M574 Y2 S1 P"ystop"                            ; configure microswitch endstop for high end on Y 
M574 Z1 S1 P"zstop"                            ; configure microswitch endstop for low  end on Z 

;------------------------ Drives ------------------------------------
M569 P0 S1                                     ; X stepper goes forward
M569 P1 S1                                     ; Y stepper goes forward
M569 P2 S0                                     ; Z1 stepper goes backward
M569 P3 S0                                     ; extruder stepper goes forward
M569 P4 S0                                     ; Z2 stepper goes backward 
M569 P5 S0                                     ; Z3 stepper goes backward 
M584 X0 Y1 Z2:4:5 E3                           ; set drive mapping

M906 X800 Y800 Z800 E800 I30                   ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                        ; Set idle timeout
M350 X32 Y32 Z32 E16 I1                        ; configure microstepping with interpolation
M92 X160.00 Y160.00 Z1600.00 E420.00           ; set steps per mm
M671 X-38.5:126.5:290.5 Y0:319.5:0 S30 		   ; leadscrew mapping for bed leveling
M566 X900.00 Y900.00 Z60.00 E120.00            ; set maximum instantaneous speed changes (mm/min)
M203 X21000.00 Y21000.00 Z180.00 E1200.00      ; set maximum speeds (mm/min)
M201 X500.00 Y500.00 Z20.00 E250.00            ; set accelerations (mm/s^2)

;----------------------------- Z-Probe ------------------------------
M558 P5 C"^e0stop" H5 F120 T9000               ; set Z probe type to switch and the dive height + speeds
G31 P500 X0 Y-19 Z6                            ; set Z probe trigger value, offset and trigger height
M557 X20:240 Y25:225 S20                     ; define mesh grid

;--------------------------- Thermistors ----------------------------
M308 S0 P"bedtemp" Y"thermistor" T100000 B4092 A"Bed Thermistor" 		; configure sensor 0 as thermistor on pin bedtemp
M308 S1 P"e0temp" Y"thermistor" T100000 B4092 A"Hotend Thermistor" 		; configure sensor 1 as thermistor on pin e0temp
M308 S2 P"e1temp" Y"thermistor" T100000 B4092 A"Chamber Thermistor"		; Configure sensor 2 as thermistor on pin e1temp
