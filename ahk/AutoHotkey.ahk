; Include the location specific commands.
#Include C:\local.ahk

; ^ is ctrl, ! is alt, # is win
; Shortcuts for opening applications
#v::Run %ProgramFilesPath%\Vim\vim73\gvim.exe
#t::Run C:\WINDOWS\system32\taskmgr.exe
#c::Run C:\cygwin\bin\mintty.exe -i /Cygwin-Terminal.ico -
#j::Run %ProgramFilesPath%\JabRef\JabRef.exe
#x::Run %ProgramFilesPath%\XMind\xmind.exe
#m::Run %ProgramFilesPath%\TTPlayer\TTPlayer.exe
#F12::Send, {Volume_Mute}

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

; copy current content and google it.
^#c::Gosub, CopyAndSearch

; text expansions
::;pd::{U+00A3}
::;euro::{U+20AC}
::;sysout::System.out.println();{Left}{Left}
::;main::public static void main(String [] args){{}{}}{Left}
^!g::Gosub, InsertGetterAndSetter

;application specific rules
SetTitleMatchMode, 2
#ifWinActive ahk_class Chrome_WidgetWin_1
#Space::Gosub HexieshePageDown
F1::Send, ~
F4::Send, ^{F4}
#ifWinActive
    
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
    
CopyAndSearch:
    Send, ^c
    Sleep 50
    Run, http://www.google.com/search?q=%clipboard%
Return

InsertGetterAndSetter:
    InputBox, Type, input Type, private _Type_ _name_: firstly input type
    InputBox, VarName, input variable name, private _Type_ _name_: input VarName
    StringUpper UpperVarName, VarName, T
    Sleep 20
    send private %Type% m%UpperVarName%;{Enter}{Enter}public %Type% get%UpperVarName%(){{}{Enter}return m%UpperVarName%;{Enter}{}}{Enter}{Enter}public void set%UpperVarName%(%Type% %VarName%){{}{Enter}m%UpperVarName% = %VarName%{Enter}{}}
return

HexieshePageDown:
    tempC := ClipboardAll
    Send, {F6}^c
    Sleep 50
    if InStr(Clipboard, "hexieshe")
    {
        ;get the last three charactors of the url.
        StringRight, hexieLastThree, Clipboard, 3
        StringGetPos, hexiePos, hexieLastThree,`/
        ;if the url starts with /, like /2/, it means it is a second page
        if (hexiePos=0) 
        {
            StringMid, hexiePage, hexieLastThree,2,1
            hexiePage:=hexiePage + 1
            Send, ^v
            Send, {BS}{BS}
            Send, %hexiePage%/{Enter}
        }
        else
        {
            Send, ^v
            Send, 2/{Enter}
        }
    }
    ClipBoard := tempC
return
