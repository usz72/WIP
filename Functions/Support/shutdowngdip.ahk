; ==================================================================================================
;  Shutdown GDIp
; ==================================================================================================
ShutdownGDIp(ExitReason, ExitCode) {
    global pToken
    if (pToken)
        Gdip_Shutdown(pToken)
}

Log("Initialized ShutdownGDIp Function")