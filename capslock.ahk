﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Capslock::Esc
CapsLock & h:: Send, {Left}
CapsLock & j:: Send, {BackSpace}
CapsLock & k:: Send, {Delete}
CapsLock & l:: Send, {Right}

; swap ctrl and alt, keeping alt+tab working
; https://superuser.com/questions/984343/remap-ctrl-to-alt-and-keep-alttab-and-ctrltab
*tab:: 
{   
    if (GetKeyState("LAlt", "P") AND GetKeyState("LShift", "P") = false) {     
        Send {LControl up}{LAlt down}{tab}
        KeyWait, tab  
    } else if (GetKeyState("LAlt", "P") AND GetKeyState("LShift", "P")) {     
        Send {LControl up}{LShift down}{LAlt down}{tab}
        KeyWait, tab
    } else if (GetKeyState("LCtrl", "P") AND GetKeyState("LShift", "P") = false) {     
        Send {LAlt up}{LCtrl down}{tab}
        KeyWait, tab
    } else if (GetKeyState("LCtrl", "P") AND GetKeyState("LShift", "P")) {  
        Send {LAlt up}{LShift down}{LCtrl down}{tab}
        KeyWait, tab
    } else if (GetKeyState("LWin", "P") AND GetKeyState("LShift", "P") = false) {     
        Send {LWin down}{tab}
        KeyWait, tab
    } else if (GetKeyState("LWin", "P") AND GetKeyState("LShift", "P")) {  
        Send {LShift down}{LWin down}{tab}
        KeyWait, tab
    } else {   
        send {tab}
    }      
    return
}

~LAlt Up::
{   
    send {LAlt up}
    return
}

~LCtrl Up::
{   
    send {LCtrl up}
    return
}

LAlt::LCtrl 
LCtrl::LAlt
