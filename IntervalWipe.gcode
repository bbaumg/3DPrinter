;===== PETG-Only Safe Interval Wipe =====
{if (filament_type[initial_no_support_extruder] == “PETG”) && (layer_num > 0) && (layer_num % 50 == 0)}
M400 ; Finish current moves
M83 ; Set extruder to relative mode
G1 E-2 F1800 ; Retract 2mm to prevent PETG strings during travel
G90 ; Set to absolute positioning

G150.3 ; Move to parking position (trash bin)
G150.1 F8000 ; Fast nozzle wipe pass 1
G150.1 F8000 ; Fast nozzle wipe pass 2

G1 E2 F1800 ; Prime the nozzle back (deretract)
M400 ; Wait for completion
{endif}
;===== End PETG-Only Wipe =====