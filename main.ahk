;
;
;
;
;
;
;
;
;
;
;
;




;================================================================================================
; On Setup
;================================================================================================

#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include Functions\GDIp\Gdip_All.ahk
#Include Functions\Support\shutdowngdip.ahk

; Setup GDIp library
if !pToken := Gdip_Startup()
{
    MsgBox, 16, GDI+ Error, Failed to start GDI+.
    ExitApp
}
global GDIpToken := pToken


OnExit("ShutdownGDIp")

#Include Functions\Support\screenshot.ahk
#Include Functions\Support\glidemouse.ahk
#Include Functions\Support\discord.ahk
#Include Functions\Support\gui.ahk
#Include Functions\Support\log.ahk
#Include Functions\Support\upgrade.ahk
#Include Functions\Support\pixelchecker.ahk

#Include Functions\Support\Setup\camerasetup.ahk
#Include Functions\Support\Setup\settings.ahk
#Include Functions\Support\Setup\teleports.ahk
#Include Functions\Support\Setup\focuswindow.ahk

#Include Functions\Support\Setup\setup.ahk




;================================================================================================
;  Gui
;================================================================================================

CreateMainGUI() 
LogSetup()
Log("Gui and Log are setup.")

F1::
    TestButton()
Return

F3::
    OpenSettings()
Return

F4::
    GuiClose("Main")
Return

;================================================================================================
; On exit
;================================================================================================



