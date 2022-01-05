#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%


; win+shift+g googles currently selected text
#+g::GoogleSelection()

; win+shift+w looks up selected word in Google Dictionary
#+w::DefineSelection()

GoogleSelection() {
    searchQuery := GetSelectedText()
    if !searchQuery {
        Run, www.google.com
        return
    }
    address := Format("www.google.com/search?q={}", searchQuery)
    Run, %address%
}

DefineSelection() {
    word := GetSelectedText()
    if !word {
        Run, www.google.com/search?q=google+dictionary
        return
    }
    address := Format("www.google.com/search?q=define+{}", word)
    Run, %address%
}

GetSelectedText() {
    oldClipboard := ClipboardAll
    Clipboard := ""
    Send, {CtrlDown}c{CtrlUp}
    ClipWait, 0, false

    if ErrorLevel {
        return Fail(oldClipboard)
    }

    selection := Clipboard

    Clipboard := ""
    Send, {ShiftDown}{Right}{ShiftUp}{CtrlDown}c{CtrlUp}{ShiftDown}{Left}{ShiftUp}
    ClipWait, 0, false

    if ErrorLevel {
        return Fail(oldClipboard)
    }

    if !InStr(Clipboard, selection) {
        Clipboard := ""
        Send, {ShiftDown}{Left}{ShiftUp}{CtrlDown}c{CtrlUp}{ShiftDown}{Right}{ShiftUp}
        ClipWait, 0, false

        if ErrorLevel or !InStr(Clipboard, selection) {
            return Fail(oldClipboard)
        }
    }

    Clipboard := oldClipboard
    return selection
}

Fail(oldClipboard) {
    Clipboard := oldClipboard
    return ""
}
