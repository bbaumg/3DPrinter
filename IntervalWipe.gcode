;###############################################################
;===== START: PHASED PETG NOZZLE MAINTENANCE =====
{if (filament_type[initial_no_support_extruder] == "PETG") && (layer_num > 0)}
  ;--- TRIGGER 1: THE "SNOWPLOW" RESET (Layer 2) ---
  ; Cleans the nozzle after the first layer squish is leveled out.
  {if (layer_num == 2)}
    M117 L2 Priority Wipe
    M400 
    G91 ; Relative
    G1 Z0.4 F1200 ; Z-Hop
    M83 ; Relative E
    G1 E-2.0 F1800 ; Retract
    G90 ; Absolute
    G150.3 ; Move to bin
    G150.1 F8000 ; Wipe 1
    G150.1 F8000 ; Wipe 2
    G150.1 F8000 ; Wipe 3
    G1 E2.0 F1800 ; Prime
    G91 ; Relative
    G1 Z-0.4 F1200 ; Z-Drop
    G90 ; Absolute
  {endif}

  ;--- TRIGGER 2: STEADY STATE PHASE (Every 20 Layers) ---
  ; Standard maintenance for the remainder of the print body.
  {if (layer_num > 2) && (layer_num % 20 == 0)}
    M117 Standard Wipe (20L)
    M400 
    G91 
    G1 Z0.4 F1200 
    M83 
    G1 E-2.0 F1800 
    G90 
    G150.3 
    G150.1 F8000 
    G150.1 F8000 
    G1 E2.0 F1800 
    G91 
    G1 Z-0.4 F1200 
    G90 
  {endif}

  ;--- TRIGGER 3: BEAUTY PASS (Last Layer) ---
  ; Final clean before the top surface pass to prevent burnt specks.
  {if (layer_num == (total_layer_count - 1))}
    M117 Top Surface Priority Wipe
    M400 
    G91 
    G1 Z0.4 F1200 
    M83 
    G1 E-2.0 F1800 
    G90 
    G150.3 
    G150.1 F8000 
    G150.1 F8000 
    G150.1 F8000 
    G1 E2.0 F1800 
    G91 
    G1 Z-0.4 F1200 
    G90 
  {endif}
{endif}
;===== END: PHASED PETG NOZZLE MAINTENANCE =====
;###############################################################








;################################################################################
;Optional Extras

;--- TRIGGER 2: AGGRESSIVE BASE PHASE (Every 5 Layers up to Layer 50) ---
; Covers the high-buildup period of solid bottom shells and early infill.
;{if (layer_num > 2) && (layer_num <= 50) && (layer_num % 5 == 0)}
;  M117 Base Phase Wipe (5L)
;  M400 
;  G91 
;  G1 Z0.4 F1200 
;  M83 
;  G1 E-2.0 F1800 
;  G90 
;  G150.3 
;  G150.1 F8000 
;  G150.1 F8000 
;  G1 E2.0 F1800 
;  G91 
;  G1 Z-0.4 F1200 
;  G90 
;{endif}


;################################################################################
; Version 1

;===== PETG-Only Safe Interval Wipe =====
;{if (filament_type[initial_no_support_extruder] == "PETG") && (layer_num > 0) && (layer_num % 20 == 0)}
;  M400 ; Finish current moves
;  M83 ; Set extruder to relative mode
;  G1 E-2 F1800 ; Retract 2mm to prevent PETG strings during travel
;  G90 ; Set to absolute positioning
;  
;  G150.3 ; Move to parking position (trash bin)
;  G150.1 F8000 ; Fast nozzle wipe pass 1
;  G150.1 F8000 ; Fast nozzle wipe pass 2
;  
;  G1 E2 F1800 ; Prime the nozzle back (deretract)
;  M400 ; Wait for completion
;{endif}
;===== End PETG-Only Wipe =====
