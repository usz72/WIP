; ==================================================================================================
;  GlideMouse — Smooth mouse motion
; ==================================================================================================

Log("Initialized Glide Mouse Function")

GlideMouse(xTarget, yTarget, steps := 50, delay := 5) {
    MouseGetPos, sx, sy
    dx := (xTarget - sx) / steps
    dy := (yTarget - sy) / steps

    Loop, %steps% {
        x := sx + dx * A_Index
        y := sy + dy * A_Index
        MouseMove, %x%, %y%, 0
        Sleep, %delay%
    }
}
