; ==================================================================================================
;  Upgrade
; ==================================================================================================

Upgrade(upgradeCount := 1, unitName := "") {

    Loop, % upgradeCount
    {
        
        Sleep, 500
        Send, e
        Sleep, 500

        if (unitName != "")
            Log("Upgraded " . unitName . upgradeCount)
        else
            Log("Upgrade applied.")

        
    }
}

