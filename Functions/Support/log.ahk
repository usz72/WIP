; ==================================================================================================
;  LOGGING FUNCTIONALITY
; ==================================================================================================


; ------------------------
; Log Setup
; ------------------------
global logFile
LogSetup() {
    global logFile

    logsDir := A_ScriptDir "\Logs"
    IfNotExist, %logsDir%
        FileCreateDir, %logsDir%

    ; Build day folder (YYYY-MM-DD)
    FormatTime, tDay,, yyyy-MM-dd
    dayDir := logsDir "\" tDay
    IfNotExist, %dayDir%
        FileCreateDir, %dayDir%

    ; Build log filename with time (HH-MM-SS.txt)
    FormatTime, tTime,, HH-mm-ss
    logFile := dayDir "\" tTime ".txt"

    ; Create empty log file
    FileAppend,, %logFile%
}

; ------------------------
; Cleanup old log folders
; ------------------------
CleanupOldLogs(MaxDays := 7) {
    logsDir := A_ScriptDir "\Logs"
    if !FileExist(logsDir)
        return

    Loop, Files, %logsDir%\*, D
    {
        folderName := A_LoopFileName
        folderPath := A_LoopFileFullPath

        ; Parse folder name as YYYY-MM-DD
        try {
            StringSplit, parts, folderName, -
            if (parts0 != 3)
                continue
            folderTimestamp := DateToTimestamp(parts1 "-" parts2 "-" parts3)
            currentTimestamp := DateToTimestamp(A_Now)
            if (currentTimestamp - folderTimestamp > MaxDays*24*60*60)
                FileRemoveDir, %folderPath%, 1
        } catch {}
    }
}

; ------------------------
; Convert date string (YYYY-MM-DD) to timestamp
; ------------------------
DateToTimestamp(DateStr) {
    FormatTime, ts, %DateStr% 00:00:00,, yyyyMMddHHmmss
    return ts
}

; ------------------------
; Format current UTC
; ------------------------
FormatTimeUTC(DateStr, Format){
    FormatTime, OutVar,, %Format%
    return OutVar
}

; ------------------------
; In-memory log storage
; ------------------------
global LogMemory := "", MainGuiID

Log(Message) {
    global LogMemory

    FormatTime, tNow,, yyyy-MM-dd HH:mm:ss
    formattedMsg := tNow " - " Message
    LogMemory := formattedMsg "`n" LogMemory

    GuiControl,, LogBox, %LogMemory%
}


; ------------------------
; Save logs on exit
; ------------------------
SaveLogsOnExit() {
    global logFile, LogMemory
    
    if LogMemory <> ""
        FileAppend, %LogMemory%, %logFile%
}

OnExit("SaveLogsOnExit")
