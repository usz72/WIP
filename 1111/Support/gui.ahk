; ==========================================
; Creates a GUI 
; ==========================================

; --------------------------
; Global variables
; --------------------------
global LogMemory := ""
global webhook := ""
global webhookFile := "webhook.txt"
global UserWebhook := ""



GuiClose(guiID) {
    if (guiID = "Main") {
        Log("Main Gui Closed")
        ExitApp
    } else {
        Log(guiID . "Closed")
        Gui, %guiID%: Destroy
    }
}

GuiSize:
    if (A_EventInfo = 1)
        return

    LeftW := Round(A_GuiWidth * LEFT_RATIO)

    GuiControl, Move, LeftPanel, w%LeftW% h%A_GuiHeight%
    GuiControl, Move, Divider, x%LeftW% h%A_GuiHeight%
    GuiControl, Move, RobloxHost
        , x%LeftW%+1 w%A_GuiWidth%-LeftW-1 h%A_GuiHeight%

    if (RobloxHwnd) {
        WinMove, ahk_id %RobloxHwnd%, , LeftW+1, 0
            , A_GuiWidth-LeftW-1
            , A_GuiHeight
    }
return

AttachRoblox() {
    global MainGuiID, RobloxHwnd

    WinWait, ahk_exe RobloxPlayerBeta.exe
    WinGet, RobloxHwnd, ID, ahk_exe RobloxPlayerBeta.exe

    DllCall("SetParent", "Ptr", RobloxHwnd, "Ptr", MainGuiID)
    Log("Roblox Attached")
}



LEFT_RATIO := 0.4   ; 40% GUI
RIGHT_RATIO := 0.6  ; 60% Roblox

CreateMainGUI() {
    global LogBox, MainGuiID
    global LEFT_RATIO

    initW := 1000
    initH := 550

    Gui, New, +AlwaysOnTop +Resize +MinSize800x450 +HwndMainGuiID
    Gui, Color, 1E1E1E
    Gui, Font, s10, Consolas

    LeftW := Round(initW * LEFT_RATIO)

    ; ------------------------
    ; LEFT PANEL BACKGROUND
    ; ------------------------
    Gui, Add, Text, x0 y0 w%LeftW% h%initH% Background2A2A2A vLeftPanel
    Gui, Add, Text, x%LeftW% y0 w1 h%initH% Background3A3A3A vDivider

    ; ------------------------
    ; TOP LEFT: BUTTON COLUMN
    ; ------------------------
    btnX := 20
    btnY := 25
    btnW := 150
    btnH := 32
    btnGap := 12

    Gui, Add, Button, x%btnX% y%btnY% w%btnW% h%btnH% gOpenWebhook, Webhook Setup
    btnNextY := btnY + btnH + btnGap

    Gui, Add, Button, x%btnX% y%btnNextY% w%btnW% h%btnH% gTestButton, Settings
    Log("Buttons Added")
    ; ------------------------
    ; TOP LEFT: LOG AREA (RIGHT OF BUTTONS)
    ; ------------------------
    logX := btnX + btnW + 20
    logY := btnY
    logW := LeftW - logX - 20
    logH := (btnH * 2) + btnGap

    Gui, Font, s9, Consolas
    Gui, Add, Text, x%logX% y%logY%-18 cWhite, Log

    Gui, Font, s8, Consolas
    Gui, Add, Edit, vLogBox x%logX% y%logY% w%logW% h%logH% ReadOnly -WantReturn +VScroll
    Log("LogBox Created")
    
    ; ------------------------
    ; ROBLOX HOST AREA
    ; ------------------------
    xPos := LeftW + 1
    wPos := initW - LeftW - 1
    Gui, Add, Text, x%xPos% y0 w%wPos% h%initH% Background000000 vRobloxHost

    Gui, Show, w%initW% h%initH%, Main GUI
}



; Button Handlers

OpenWebhook(){
    Gui, New, +AlwaysOnTop +Resize
    Gui, Add, Text, x10 y10, Enter Discord Webhook URL (optional):
    Gui, Add, Edit, vUserWebhook x10 y30 w300 h20
    Gui, Add, Button, x10 y60 w100 h30 gSubmitWebhookFunc, Submit
    Gui, Show, w330 h120, Webhook Setup
    Log("Webhook Window Opened")
}

SubmitWebhookFunc() {
    global UserWebhook
    Gui, Submit, NoHide
    SetupWebhook(UserWebhook) 
    Gui, Destroy
    Log("Webhook Submitted")
}

TestButton() {
    
    Log("Test button pressed")
    Setup()
}


