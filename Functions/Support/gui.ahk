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
        ExitApp
    } else {
        Gui, %guiID%: Destroy
    }
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
    Gui, Add, Button, x%btnX% y% btnY+btnH+btnGap % w%btnW% h%btnH% gTestButton, Settings

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
    Gui, Add, Edit
        , vLogBox x%logX% y%logY% w%logW% h%logH%
        ReadOnly -WantReturn +VScroll

    
    ; ------------------------
    ; ROBLOX HOST AREA
    ; ------------------------
    Gui, Add, Text
        , x%LeftW%+1 y0
        w% initW-LeftW-1 %
        h%initH%
        Background000000
        vRobloxHost

    Gui, Show, w%initW% h%initH%, Main GUI
}



; Button Handlers

OpenWebhook(){
    Gui, New, +AlwaysOnTop +Resize
    Gui, Add, Text, x10 y10, Enter Discord Webhook URL (optional):
    Gui, Add, Edit, vUserWebhook x10 y30 w300 h20
    Gui, Add, Button, x10 y60 w100 h30 gSubmitWebhookFunc, Submit
    Gui, Show, w330 h120, Webhook Setup
}

SubmitWebhookFunc() {
    global UserWebhook
    Gui, Submit, NoHide
    SetupWebhook(UserWebhook) 
    Gui, Destroy
}

TestButton() {
    
    Setup()
}


