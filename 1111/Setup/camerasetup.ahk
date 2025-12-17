; ==================================================================================================
;  CameraSetup
; ==================================================================================================

Log("Initialized Camera Setup Function")

CameraSetup(zoomInSteps := 10, lookOffsetY := 300, zoomOutSteps := 10, camRotation := 0) {

    Log("[Camera] CameraSetup started.")
    Log("[Camera] Params → ZoomIn: " . zoomInSteps
        . ", LookOffsetY: " . lookOffsetY
        . ", ZoomOut: " . zoomOutSteps
        . ", Rotation: " . camRotation)

    ; --- Zoom in ---
    Log("[Camera] Zooming in.")
    Loop, %zoomInSteps% {
        Send, {WheelUp}
        Sleep, 40
    }

    ; --- Horizontal rotation ---
    if (camRotation != 0) {
        Log("[Camera] Rotating camera horizontally.")
        MouseGetPos, x, y
        Send, {RButton down}
        Sleep, 50
        MouseMove, % x + camRotation, % y, 15
        Sleep, 50
        Send, {RButton up}
    } else {
        Log("[Camera] Horizontal rotation skipped.")
    }

    ; --- Look down / up ---
    MouseGetPos, sx, sy
    Log("[Camera] Adjusting vertical view.")
    GlideMouse(sx, sy + lookOffsetY, 40, 5)

    ; --- Zoom out ---
    Log("[Camera] Zooming out.")
    Loop, %zoomOutSteps% {
        Send, {WheelDown}
        Sleep, 40
    }

    Log("[Camera] CameraSetup completed.")
}

