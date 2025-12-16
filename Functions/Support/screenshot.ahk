; ==================================================================================================
;  Screenshot Function
; ==================================================================================================

Log("Initialized Screenshot Function")

Screenshot() {
    global pToken

    Log("[Screenshot] Requested screenshot.")

    ; Start GDI+ if not already running
    if (!pToken) {
        Log("[Screenshot] GDI+ not initialized. Starting GDI+...")
        pToken := Gdip_Startup()
    }

    if (!pToken) {
        Log("[ERROR][Screenshot] Failed to start GDI+.")
        MsgBox, 16, GDI+ Error, Failed to start GDI+.
        return ""
    }

    ; --- Capture full screen ---
    Log("[Screenshot] Capturing screen...")
    pBitmap := Gdip_BitmapFromScreen()

    if (!pBitmap) {
        Log("[ERROR][Screenshot] Failed to capture screen.")
        MsgBox, 16, Screenshot Error, Failed to capture screen.
        return ""
    }

    ; --- Ensure folder exists ---
    screenshotsDir := A_ScriptDir "\Screenshots"
    if !FileExist(screenshotsDir) {
        Log("[Screenshot] Screenshots folder not found. Creating directory...")
        FileCreateDir, %screenshotsDir%

        if !FileExist(screenshotsDir) {
            Log("[ERROR][Screenshot] Failed to create Screenshots directory.")
            return ""
        }
    }

    ; --- Timestamped filename ---
    FormatTime, timestamp,, yyMMdd_HHmmss
    filePath := screenshotsDir "\" timestamp ".png"
    Log("[Screenshot] Saving file: " . filePath)

    ; --- Save and clean up ---
    result := Gdip_SaveBitmapToFile(pBitmap, filePath)
    Gdip_DisposeImage(pBitmap)

    if (result != 0) {
        Log("[ERROR][Screenshot] Failed to save image. GDI+ error code: " . result)
        return ""
    }

    Log("[Screenshot] Screenshot saved successfully.")
    return filePath
}
