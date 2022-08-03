# Klicky Support on RepRap

A few macros to support Klicky Z-Probe functions on my Voron Trident 250mm, namely Auto Z Calibration, Mesh Compensation, and Auto bed Leveling

## Instructions
1. Download whichever macro files contain the functions you'd like to import
 - /sys/mesh.g contains Mesh Compensation / heightmap calculations
 - /sys/bed.g contains auto z calibration
 - /macros/AutoBedLeveling.g contains, you guessed it, auto bed leveling
2. Any values that need to be tuned to a specific printer are saved as variables at the top of the files. Carefully work through these, and supply the proper settings for your specific build
3. Save the updated files to your printer, in the same directory I have organized them here

Current files are developed to support my 250mm Voron Trident, but should lend themselves well to any RepRap build with minor modifications (I designed for RepRap v3.4, I cannot promise backward compatibility)

## Acknowledgements
This software is built on the shoulders of developers who came before me. Pay your respects to these outstanding members of the community:
1. [pRINTERnOODLE](https://github.com/pRINTERnOODLE) developed comprehensive software support for both [Mesh Compensation](https://github.com/pRINTERnOODLE/RRF-klicky-probe-voron-2.4/blob/main/sys/mesh.g) and [AutoZ Calibration](https://github.com/pRINTERnOODLE/Auto-Z-calibration-for-RRF-3.3-or-later-and-Klicky-Probe). If you are in the early stages of your RepRap install, I strongly recommend starting here. 
2. [Protoloft](https://github.com/protoloft) has a great repo for [Auto Z Calibration](https://github.com/protoloft/klipper_z_calibration) on Klipper
3. Of course, none of this would be possible without [jlas1's Klicky Probe](https://github.com/jlas1/Klicky-Probe), the best drop-in ZProbe for CoreXY printers, hands down
