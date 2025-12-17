; ==================================================================================================
; Call SetupWebhook()
; Discord call and message functions
; ==================================================================================================

SendMode Input
SetWorkingDir %A_ScriptDir%

; webhook path
webhookFile := A_ScriptDir "\Webhook.txt"

; Setting up totals
webhook := ""



; ------------------------
; Main Discord webhook function
; ------------------------
Webhook(Message := "", Title := "", IncludeImage := false) {
    global

    ; Initialize image path as empty
    imgPath := ""

    ; If image is requested, take screenshot
    if (IncludeImage) {
        imgPath := Screenshot()
        if (imgPath = "") {
            Log("Failed to capture screenshot. Embed will be sent without image.")
        }
    }

    ; Call existing SendWebhook function with formatted data
    SendWebhook(Message, imgPath, Title)
}



; ------------------------
; Function: Initialize/setup webhook
; Only runs when called manually
; ------------------------


SetupWebhook(userInput := "") {
    global webhook, webhookFile

    if (userInput != "") {
        webhook := userInput
        FileDelete, %webhookFile%
        FileAppend, %userInput%, %webhookFile%
    } else if FileExist(webhookFile) {
        FileRead, webhook, %webhookFile%
        StringTrimRight, webhook, webhook, 0
    } else {
        webhook := ""  ; leave empty if none provided
    }

    ; Optional logging
    if (webhook != "")
        Log("Discord Webhook initialized: ")
    else
        Log("No Discord Webhook configured. Discord functions disabled.")
}



; ------------------------
; Send Raw to webhook
; ------------------------

SendWebhookRaw(Message){
    global webhook
    if (webhook = "")
    {
        Log("Webhook URL is not set.")
        MsgBox, 48, Error, Webhook URL is not set.
        return false 
    }

    payload := "{""content"": """ Message """}"

    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", webhook, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.Send(payload)

    if (http.Status != 204)
    {   
        Log("Failed to send message to Discord. Status: " http.Status)
        MsgBox, 48, Error, Failed to send message to Discord. Status: " http.Status
        return false
    }
    
    return true
}



; ------------------------
; Send Formatted Messages
; ------------------------

SendWebhook(Message := "", ImagePath := "", Title := "") {
    global webhook
    if (webhook = "") {
        Log("Webhook URL is not set. Cannot send embed.")
        return
    }

    ; Variables for bot display
    BotName := "MyBot"          ; Change this as needed
    BotAvatar := "https://i.imgur.com/your-avatar.png"  ; URL to profile pic

    ; Embed color (black)
    EmbedColor := 0x000000

    ; Build the JSON payload for embed
    payloadObj := {}
    payloadObj.username := BotName
    payloadObj.avatar_url := BotAvatar
    payloadObj.embeds := []

    embed := {}
    if (Title != "")
        embed.title := Title
    if (Message != "")
        embed.description := Message
    embed.color := EmbedColor

    ; If there is an image, include it in embed
    if (ImagePath != "" && FileExist(ImagePath)) {
        ; Discord webhooks cannot directly attach local files to embed images, 
        ; so image must be hosted somewhere. Otherwise use multipart/form-data
        embed.image := {url: "attachment://" . ImagePath}
        useMultipart := true
    } else {
        useMultipart := false
    }

    payloadObj.embeds.Push(embed)

    ; Convert object to JSON
    payloadJSON := ObjToJSON(payloadObj)

        ; Send either as multipart if image, else normal JSON
        if (useMultipart) {
        ; Read image as binary
        FileRead, imageData, *c %ImagePath%

        boundary := "------------------------" A_TickCount
        SplitPath, ImagePath,,, filename  ; Extract filename only

        payload := "--" . boundary . "`r`n"
        payload .= "Content-Disposition: form-data; name=""file""; filename=""" . filename . """" . "`r`n"
        payload .= "Content-Type: application/octet-stream`r`n`r`n"
        payload .= imageData . "`r`n"
        payload .= "--" . boundary . "`r`n"
        payload .= "Content-Disposition: form-data; name=""payload_json""`r`n`r`n"
        payload .= payloadJSON . "`r`n"
        payload .= "--" . boundary . "--"

        http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        http.Open("POST", webhook, false)
        http.SetRequestHeader("Content-Type", "multipart/form-data; boundary=" . boundary)
        http.Send(payload)
    } else {
        ; No image, just JSON
        http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        http.Open("POST", webhook, false)
        http.SetRequestHeader("Content-Type", "application/json")
        http.Send(payloadJSON)
    }

    ; Handle response
    if (http.Status != 204) {
        Log("Failed to send embed to Discord. Status: " http.Status)
        MsgBox, 48, Error, Failed to send embed to Discord. Status: " http.Status 
    } else {
        Log("Embed sent to Discord successfully.")
    }
}



; ------------------------
; IMG to JSON
; ------------------------
ObjToJSON(obj) {
    json := "{"
    first := true
    for k, v in obj {
        if (!first)
            json .= ","
        first := false
        json .= """" k """:"
        if IsObject(v) {
            if IsFunc(v.Push)  ; It's an array
                json .= "[" . JoinArray(v) . "]"
            else
                json .= ObjToJSON(v)
        } else if (v is number)
            json .= v
        else
            json .= """" StrReplace(v, """", "\""") """"
    }
    json .= "}"
    return json
}

JoinArray(arr) {
    parts := []
    for k, v in arr
        parts.Push(ObjToJSON(v))
    return StrJoin(parts, ",")
}

StrJoin(arr, delim) {
    result := ""
    first := true
    for k, v in arr {
        if (!first)
            result .= delim
        first := false
        result .= v
    }
    return result
}
