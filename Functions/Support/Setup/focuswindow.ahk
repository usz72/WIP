; ==================================================================================================
;  FocusRobloxWindow
; ==================================================================================================




;
;
;    NEEDS WORK
;
;



FocusRobloxWindow() {
    Log("[Focus] Attempting to focus Roblox window...")

    ; ---- 1. Native Roblox (Win32) ----
    hwnd := WinExist("ahk_exe RobloxPlayerBeta.exe")
    if (hwnd) {
        Log("[Focus] Found RobloxPlayerBeta.exe (HWND: " . hwnd . ")")

        ; Restore if minimized
        WinGet, state, MinMax, ahk_id %hwnd%
        if (state = -1) {
            Log("[Focus] Roblox is minimized. Restoring.")
            WinRestore, ahk_id %hwnd%
            Sleep, 150
        }

        ; Allow focus stealing
        DllCall("AllowSetForegroundWindow", "uint", -1)

        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%,, 2

        if WinActive("ahk_id " hwnd) {
            Log("[Focus] RobloxPlayerBeta.exe focused successfully.")
            return true
        } else {
            Log("[Focus][WARN] RobloxPlayerBeta.exe activation blocked.")
        }
    }

    ; ---- 2. UWP Roblox (Microsoft Store) ----
    WinGet, list, List, ahk_class ApplicationFrameWindow
    Loop, %list% {
        id := list%A_Index%
        WinGet, exe, ProcessName, ahk_id %id%
        if (exe = "ApplicationFrameHost.exe") {
            WinGetTitle, title, ahk_id %id%
            if InStr(title, "Roblox") {
                Log("[Focus] Found Roblox UWP window.")

                DllCall("AllowSetForegroundWindow", "uint", -1)
                WinActivate, ahk_id %id%
                WinWaitActive, ahk_id %id%,, 2

                if WinActive("ahk_id " id) {
                    Log("[Focus] Roblox UWP window focused.")
                    return true
                } else {
                    Log("[Focus][WARN] Roblox UWP activation blocked.")
                }
            }
        }
    }

    ; ---- 3. Last resort: title search ----
    hwnd := WinExist("Roblox")
    if (hwnd) {
        Log("[Focus] Found Roblox by title fallback.")

        DllCall("AllowSetForegroundWindow", "uint", -1)
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%,, 2

        if WinActive("ahk_id " hwnd) {
            Log("[Focus] Roblox focused via title fallback.")
            return true
        }
    }

    Log("[ERROR] FocusRobloxWindow() failed: Window found but could not be focused.")
    return false
}
