; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

#v::Run C:\Program Files\Vim\vim73\gvim.exe
#t::Run C:\WINDOWS\system32\taskmgr.exe
#c::Run C:\cygwin\bin\mintty.exe -i /Cygwin-Terminal.ico -
#p::Run C:\Documents and Settings\laiq\My Documents\Downloads\putty.exe
#j::Run C:\Program Files\JabRef\JabRef.exe
#f::Run C:\Program Files\FreeCommander\FreeCommander.exe
#x::Run C:\Program Files\XMind\xmind.exe
#m::Run C:\Program Files\TTPlayer\TTPlayer.exe
#a::Gosub, ReloadScript
#s::Gosub,Pomodoro
#e::Gosub, StopTimer
#3::Gosub, TeaTimer
#5::Gosub, RestTimer
#1::Gosub, WorkTimer
#2::Gosub, LongRestTimer

ReloadScript:
    Reload
    Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
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
    if (LeftTime < 0){
        MsgBox, Timer OUT! 
        SetTimer, PomodoroTimer, Off
    }
    return

StopTimer:
    LeftTime := -1
    SetTimer, PomodoroTimer, Off
    MsgBox, Timer cancelled. 
    return

TeaTimer:
    MsgBox, Tea Timer started. 
    sleep 180000
    MsgBox, Tea ready!
    return

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
