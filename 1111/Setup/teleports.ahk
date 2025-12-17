; ==================================================================================================
;  Teleports
; ==================================================================================================

; ==================================================================================================
;  Teleports
; ==================================================================================================

; ------------------------
;  Spawn Teleport
; ------------------------
Spawn() {
    Log("[Teleport] Spawn() started.")

    OpenSettings()
    Sleep, 500

    Log("[Teleport] Clicking Spawn button.")
    GlideMouse(1050, 730, 50, 5)
    Sleep, 500
    Click
    Sleep, 500

    CloseSettings()
    Log("[Teleport] Spawn() completed.")
}

; ------------------------
;  Go to Play Area
; ------------------------
GotoPlay() {
    Log("[Teleport] GotoPlay() started.")

    Log("[Teleport] Checking if menu is already open.")

    if (CheckSpecificPixel(345, 435, 0x72333C, 0x081223)){
    
    Log("[Teleport] Menu is already open Continuing with script.")

    } else {
        
        Sleep, 500
        Log("[Teleport] Opening Play menu.")
        GlideMouse(150, 430)
        Sleep, 500
        Click

    }

    Sleep, 500
    Log("[Teleport] Confirming Play teleport.")
    GlideMouse(250, 430)
    Sleep, 500
    Click
    
    Sleep, 2500
    Log("[Teleport] GotoPlay() completed.")
}
