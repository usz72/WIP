; ==================================================================================================
;  Setup
; ==================================================================================================

Setup() {
    Log("[Setup] Setup started.")

    FocusRobloxWindow()
    Sleep, 500

    Log("[Setup] Going to Play area.")
    GotoPlay()
    Sleep, 500

    Log("[Setup] Positioning camera.")
    GlideMouse(955, 500)
    Sleep, 250
    CameraSetup()
    Sleep, 500

    Log("[Setup] Setup completed.")
}
