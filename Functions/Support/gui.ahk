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



CreateMainGUI() {
    global LogBox, MainGuiID
    Gui, +AlwaysOnTop +Resize
    Gui, Font, s10, Consolas

    Gui, Add, Text, x250 y5, LogBox:
    Gui, Font, s7 i, Consolas
    Gui, Add, Edit, vLogBox x250 y25 w350 h250 ReadOnly -WantReturn +VScroll

    Gui, Add, Button, x25 y20 w150 h30 gOpenWebhook, Webhook Setup
    Gui, Add, Button, x25 y70 w150 h30 gTestButton, Settings
    Gui, Add, Button, x25 y120 w150 h30 gTestButton, TestButton

    Gui Show, w600 h300, Main GUI
    MainGuiID := WinExist()
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


