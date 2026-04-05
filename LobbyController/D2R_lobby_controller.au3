; D2R game lobby controller by Chobotz - https://github.com/Chobotz/D2R-multiclient-tools
; instructions
; install autoit3 - https://www.autoitscript.com/site/autoit/downloads/
; this script assumes that you configure static Window title names - D2R1, D2R2 etc, see Configuration section below, e.g.: this is done by Chobotz multiclient launcher when it starts clients
; this script assumes you use window size 1280*720 - if not, you need to adjust it to your setup
; if you get Blizz hammer banned don't come crying to daddy - we join game and exit games, no character or gameplay automation
; put all your clients into Game Lobby - Join game view, this is where you can start using the functionality
; join next game assumes that you have gamename150, when you "click exit and join next +1", next game name is gamename151, then gamename152 etc - it increases the game number by 1
; best usage is, if this is your second PC, where you run additional clients, you play your main on primary PC, you create games on primary PC

#RequireAdmin
#include <GUIConstantsEx.au3>
#include <TrayConstants.au3>
#include <String.au3>

; Set Coordinate mode to relative (0 = Window)
Opt("MouseCoordMode", 0)
Opt("GUIOnEventMode", 1)

; --- Configuration ---
Global $aTargetWindows[7] = ["D2R1", "D2R2","D2R3","D2R4","D2R5","D2R6","D2R7"]
Global $iLobbyWait = 1029 ; Milliseconds to wait for lobby to load after exiting

; --- Create the GUI ---
$hMainGUI = GUICreate("D2R Lobby Controller", 300, 330) 
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

GUICtrlCreateLabel("Game name:", 20, 20)
; Change this, Configure your game pattern name here, keep some number at the end so the script can +1 iterate
$inputG = GUICtrlCreateInput("game150", 20, 40, 260, 20)

; Configure your password here
GUICtrlCreateLabel("Game password:", 20, 70)
$inputP = GUICtrlCreateInput("123", 20, 90, 260, 20)

; Join Current Button
$btnStart = GUICtrlCreateButton("Join current", 50, 130, 200, 35)
GUICtrlSetOnEvent($btnStart, "RunAutomation")

; --- COMBINED: Exit and Join Next ---
$btnNext = GUICtrlCreateButton("EXIT && JOIN NEXT (+1)", 50, 170, 200, 35)
GUICtrlSetBkColor($btnNext, 0xCCE5FF) ; Light blue color
GUICtrlSetOnEvent($btnNext, "ExitAndJoinNext")

; Exit Game Button (Manual)
$btnExit = GUICtrlCreateButton("Exit game only", 50, 220, 200, 40)
GUICtrlSetBkColor($btnExit, 0xFFCCCC) ; Light red color
GUICtrlSetOnEvent($btnExit, "ExitGameSequence")

GUISetState(@SW_SHOW)

; --- Main Idle Loop ---
While 1
    Sleep(100)
WEnd

; --- Combined Logic ---
Func ExitAndJoinNext()
    ; 1. First, increment the UI digit
    Local $sCurrentName = GUICtrlRead($inputG)
    Local $aMatch = StringRegExp($sCurrentName, "(.*?)(\d+)$", 1)
    
    If Not @error Then
        Local $sPrefix = $aMatch[0]
        Local $iNumber = Int($aMatch[1]) + 1
        Local $iPadding = StringLen($aMatch[1])
        Local $sNextName = $sPrefix & StringFormat("%0" & $iPadding & "d", $iNumber)
        GUICtrlSetData($inputG, $sNextName)
    EndIf
    
    Local $valG = GUICtrlRead($inputG)
    Local $valP = GUICtrlRead($inputP)

    ; 2. Loop through windows: Exit -> Sleep -> Join
    For $title In $aTargetWindows
        If WinExists($title) Then
            WinActivate($title)
            WinWaitActive($title, "", 2)
            
            ; --- EXIT SEQUENCE ---
			Sleep(Random(186, 309, 1))
            Send("{ESC}")
            Sleep(Random(186, 309, 1))
            Send("{UP}")
			Sleep(Random(186, 309, 1))
			Send("{ENTER}")
			
            
            ; --- LOBBY SLEEP ---
            ; Wait for the game to reach the lobby
            Sleep($iLobbyWait+Random(50,99,1))
            
            ; --- JOIN SEQUENCE ---
            ; Click Game Name field
            MouseClick("left", Random(498, 513, 1), Random(85, 87, 1), 1, 5)
            Sleep(Random(150, 249, 1))
            
            Send("^a{DELETE}")
			
            Sleep(Random(203, 309, 1))
            Send($valG)
          
            Send("{TAB}")
            Sleep(Random(203, 309, 1))
            Send("^a")
            Sleep(Random(203, 309, 1))
            Send($valP)
            Sleep(Random(203, 309, 1))
            Send("{ENTER}")
            
            Sleep(Random(300, 500, 1))
        EndIf
    Next
    
    TrayTip("Sequence Complete", "All characters moved to " & $valG, 1, $TIP_NOSOUND)
EndFunc

; --- Standard Join (No Exit) ---
Func RunAutomation()
    Local $valG = GUICtrlRead($inputG)
    Local $valP = GUICtrlRead($inputP)

    For $title In $aTargetWindows
        If WinExists($title) Then
            WinActivate($title)
            WinWaitActive($title, "", 2)
            MouseClick("left", Random(498, 513, 1), Random(85, 87, 1), 1, 5)
            Send("^a{DELETE}")
            Sleep(Random(203, 309, 1))
            Send($valG)
            Send("{TAB}")
            Send("^a{DELETE}")
            Sleep(Random(203, 309, 1))
            Send($valP)
            Send("{ENTER}")
            Sleep(Random(203, 309, 1))
        EndIf
    Next
EndFunc

; --- Standard Exit ---
Func ExitGameSequence()
    For $title In $aTargetWindows
        If WinExists($title) Then
            WinActivate($title)
            WinWaitActive($title, "", 2)
            Send("{ESC}")
			Sleep(Random(203, 309, 1))
			Send("{UP}")
			Sleep(Random(203, 309, 1))
			Send("{ENTER}")
            Sleep(Random(203, 309, 1))
        EndIf
    Next
EndFunc

Func Quit()
    Exit
EndFunc
