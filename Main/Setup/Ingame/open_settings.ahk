; ==================================================================================================
;  OpenSettings
; ==================================================================================================

OpenSettings() {
    Log("[UI] Opening settings.")

    Sleep, 500
    GlideMouse(30, 1055, 50, 5)
    Sleep, 100
    Click
    Sleep, 500

    Log("[UI] Settings opened.")
}

CloseSettings() {
    Log("[UI] Closing settings.")

    Sleep, 500
    GlideMouse(1300, 300, 50, 5)
    Sleep, 100
    Click
    Sleep, 500

    Log("[UI] Settings closed.")
}