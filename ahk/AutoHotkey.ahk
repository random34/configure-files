; Include the location specific commands.
#Include C:\local.ahk
#Include .\ClipboardHistory.ahk

; ^ is ctrl, ! is alt, # is win, + is shift
; Shortcuts for opening applications
#v::Run %VimPath%
#t::Run C:\WINDOWS\system32\taskmgr.exe
#y::Gosub LookupYoudao
#m::Gosub, MountTrueCriptDisk
#u::Gosub, UnMountTrueCriptDisk

; Shortcuts for the timer of pomodoro methods
#s::Gosub, Pomodoro
#e::Gosub, StopTimer
#3::Gosub, TeaTimer
#5::Gosub, RestTimer
#1::Gosub, WorkTimer
#2::Gosub, LongRestTimer

; Manage configuration files
^!r::Gosub, ReloadScript

^!f::Gosub, FetchConfigure
^!u::Gosub, UploadConfigure

;;;;;;;;;;;;;;;;;;
; copy and paste
;;;;;;;;;;;;;;;;;;
^#c::
searchURL := "http://www.google.com/search?q="
Gosub, CopyAndSearch
return
^#t::
searchURL := "http://dict.youdao.com/search?q=" 
Gosub, CopyAndSearch
return
^+v::Gosub, PasteAsPlainText

;;;;;;;;;;;;;;;;
;Audio settings
;;;;;;;;;;;;;;;;;;;
#F12::Send, {Volume_Mute}
ScrollLock::Gosub, ToogleSoundDevice

;;;;;;;;;;;;;;;;;;;;;
; text expansions
;;;;;;;;;;;;;;;;;;;;;
; Special charactors
::;pd::{U+00A3}
::;euro::{U+20AC}
::;Omega::{U+03A9}
::;Theta::{U+0398}
::;lambda::{U+03BB}
::;cross::{U+00D7}
::;dot::{U+00B7}

; Code generations
::;sysout::System.out.println();{Left}{Left}
::;main::public static void main(String [] args){{}{}}{Left}
^!g::Gosub, InsertGetterAndSetter
#i::Gosub, TypeInputs

; useful short cuts

;generate a random number between 0 and 2^32
::;rn::
    Random, rn
    SendInput %rn%
return

;current date
::;dt::
    FormatTime, currentDateTime, , yyyy-MM-dd
    SendInput %currentDateTime%
return

;a time stamp
::;ts::
    FormatTime, currentDateTime, , yyyy-MM-dd
    Random, rn
    SendInput %currentDateTime% %rn%
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;application specific rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#ifWinActive ahk_class Chrome_WidgetWin_1
F4::Send, ^{F4}
#ifWinActive

;;;;;;;;;;;;;;;;;;;;;
;Special keys
;;;;;;;;;;;;;;;;;;;;;
Browser_Back::Send, ^{Click}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sub programs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReloadScript:
    Reload
    ; If successful, the reload will close this instance during the Sleep, so
    ; the line below will never be reached.
    Sleep 1000 
    MsgBox, The script could not be reloaded. 
    return

Pomodoro:
    if (LeftTime > 0)
        MsgBox, Pomodoro timer has %LeftTime% minutes left.
    else
        Gosub, StartTimer       
    return

StartTimer:
    InputBox, Minutes, Input minutes, Please input minutes of the timer, 
    if ErrorLevel
        return
    ;MsgBox, Timer started. Time out after %Minutes% minutes
    LeftTime := Minutes
    ;SetTimer, PomodoroTimer, 1000
    Gosub, SetPomodoroTimer
    return

SetPomodoroTimer:
    MsgBox, Timer started. Time out after %LeftTime% minutes
    SetTimer, PomodoroTimer, 60000
    return

WorkTimer:
    LeftTime := 25
    Gosub, SetPomodoroTimer
    return

RestTimer:
    LeftTime := 5
    Gosub, SetPomodoroTimer
    return
    
LongRestTimer:
    LeftTime := 20
    Gosub, SetPomodoroTimer
    return

PomodoroTimer:
    LeftTime:= LeftTime - 1
    ;MsgBox, Debug LeftTime=%LeftTime% 
    if (LeftTime < 1){
        MsgBox, Timer OUT! 
        SetTimer, PomodoroTimer, Off
    }
    return

StopTimer:
    MsgBox, Timer cancelled. Left time = %LeftTime% minutes. 
    LeftTime := -1
    SetTimer, PomodoroTimer, Off
    return

TeaTimer:
    MsgBox, Tea Timer started. 
    sleep 180000
    MsgBox, Tea ready!
    return

FetchConfigure:
    FileCopyDir %DropboxConfigure%\vimfiles\, %Home%, 1
    FileCopyDir %DropboxConfigure%\vimfiles\, %CygwinHome%, 1
    MsgBox, Configuration files fetched from dropbox
    return

UploadConfigure:
    FileCopyDir %Home%\vimfiles\, %DropboxConfigure%\vimfiles\vimfiles, 1
    FileCopy %Home%\_vimrc, %DropboxConfigure%\vimfiles\, 1
    MsgBox, Configuration files uploaded to dropbox. 
    return
    
InsertGetterAndSetter:
    InputBox, Type, input Type, private _Type_ _name_: firstly input type
    InputBox, VarName, input variable name, private _Type_ _name_: input VarName
    StringUpper UpperVarName, VarName, T
    Sleep 20
    send private %Type% m%UpperVarName%;{Enter}{Enter}public %Type% get%UpperVarName%(){{}{Enter}return m%UpperVarName%;{Enter}{}}{Enter}{Enter}public void set%UpperVarName%(%Type% %VarName%){{}{Enter}m%UpperVarName% = %VarName%{Enter}{}}
return

TypeInputs:
    InputBox, SendString, Input a String, Please input a string that need to be typed
    Sleep 20
    Send %SendString%
return

CopyAndSearch:
    copyTemp := ClipboardAll
    Send, ^c
    Sleep 50
    Run, %SearchURL%%Clipboard%
    Clipboard := copyTemp
return

ToogleSoundDevice:
    toggle:=!toggle ;toggles up and down states. 
    Run, mmsys.cpl 
    WinWait,Sound ; Change "Sound" to the name of the window in your local language 
    if toggle 
        ControlSend,SysListView321,{Down 1} ; This number selects the matching audio device in the list, change it accordingly 
    Else 
        ControlSend,SysListView321,{Down 2} ; This number selects the matching audio device in the list, change it accordingly
    sleep 100
    ControlClick,&Set Default,Sound,,,,na ; Change "&Set Default" to the name of the button in your local language 
    sleep 100 
    ControlClick,OK,Sound,,,,na 
return

PasteAsPlainText:
    ClipSaved := ClipboardAll 
    Clipboard = %Clipboard% 
    SendInput, ^v 
    Sleep, 250 
    Clipboard := ClipSaved 
return

LookupYoudao:
    InputBox, YoudaoWord, Look up a word, Please input the word
    searchURL := "http://dict.youdao.com/search?q=" 
    Run, %SearchURL%%YoudaoWord%
return

MountTrueCriptDisk:
    Run %ProgramFilesPath%\TrueCrypt\TrueCrypt.exe
    WinWait, TrueCrypt
    Sleep, 50
    SendInput, {Alt}i{Up}{Enter}
return

UnMountTrueCriptDisk:
    Run %ProgramFilesPath%\TrueCrypt\TrueCrypt.exe
    WinWait, TrueCrypt
    Sleep, 50
    SendInput, !s{Esc}
return
