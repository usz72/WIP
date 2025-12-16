; ==========================================
;  Pixel Checker
; ==========================================

CheckSpecificPixel(x, y, expectedColor, extraColors := "") {
    ; Get the pixel color at x,y
    PixelGetColor, result, %x%, %y%, RGB
    Log("[PixelCheck] (" . x . "," . y . ") detected color: " . result)

    ; Normalize expectedColor to 0x format
    if (SubStr(expectedColor, 1, 2) != "0x")
        expectedColor := "0x" expectedColor

    Log("[PixelCheck] Primary expected color: " . expectedColor)

    ; Normalize extraColors (can be comma-separated string)
    colors := [expectedColor]  ; start with primary

    if (extraColors != "") {
        Log("[PixelCheck] Extra acceptable colors: " . extraColors)
        Loop, Parse, extraColors, `,
        {
            color := Trim(A_LoopField)
            if (SubStr(color, 1, 2) != "0x")
                color := "0x" color
            colors.Push(color)
            Log("[PixelCheck] Added acceptable color: " . color)
        }
    }

    ; Check if result matches any acceptable color
    for index, color in colors {
        if (result = color) {
            Log("[PixelCheck] Match found: " . color)
            return true
        }
    }

    Log("[PixelCheck] No color match found.")
    return false
}

