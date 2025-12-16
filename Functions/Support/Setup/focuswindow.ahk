; ==================================================================================================
;  FocusRobloxWindow
; ==================================================================================================



FocusRobloxWindow() {
    global RobloxHwnd, MainGuiID
    Log("[Focus] Attempting to focus Roblox window...")

    ; ---------------------------------
    ; EMBEDDED CASE (preferred)
    ; ---------------------------------
    if (RobloxHwnd && WinExist("ahk_id " RobloxHwnd)) {
        Log("[Focus] Roblox is embedded. Focusing via GUI.")

        ; Ensure main GUI is active first
        WinActivate, ahk_id %MainGuiID%
        WinWaitActive, ahk_id %MainGuiID%,, 1

        ; Give focus directly to Roblox child window
        DllCall("SetForegroundWindow", "Ptr", RobloxHwnd)
        DllCall("SetFocus", "Ptr", RobloxHwnd)

        return true
    }

    ; ---------------------------------
    ; 1. Native Roblox (Win32)
    ; ---------------------------------
    hwnd := WinExist("ahk_exe RobloxPlayerBeta.exe")
    if (hwnd) {
        Log("[Focus] Found RobloxPlayerBeta.exe (HWND: " . hwnd . ")")

        WinGet, state, MinMax, ahk_id %hwnd%
        if (state = -1) {
            Log("[Focus] Roblox is minimized. Restoring.")
            WinRestore, ahk_id %hwnd%
            Sleep, 150
        }

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

    ; ---------------------------------
    ; 2. UWP Roblox
    ; ---------------------------------
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

    ; ---------------------------------
    ; 3. Title fallback
    ; ---------------------------------
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