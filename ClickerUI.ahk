#SingleInstance, Force
#NoEnv
#KeyHistory 0
ListLines Off
SendMode Input
SetBatchLines -1  ; Full utilisation
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
Thread, interrupt, 0
SetWinDelay, -1
SetKeyDelay, 20


;;;;;;;;;;;;;;;;;;;;;;;;;;;; Set Up Window ;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Run Clicker Heroes if it's not already running
IfWinNotExist, Clicker Heroes ahk_exe Clicker Heroes.exe
{
	Run, C:\Program Files (x86)\Steam\steamapps\common\Clicker Heroes\Clicker Heroes.exe,,, PID ; Open ClickerHeroes, get Process ID
	WinWait, ahk_pid %PID% ; Wait for this process to open in a window
}

; Activate Clicker Heroes window, resize and store the window handler into a variable
WinActivate, ahk_exe Clicker Heroes.exe
WinWaitActive, ahk_exe Clicker Heroes.exe
WinMove, ahk_exe Clicker Heroes.exe,,,, 1000, 703


; Set Global Variables
setDefaults()
{
	Global
	
	Parent := WinExist("ahk_exe Clicker Heroes.exe")
	
	PushTime = 1
	StallTime = 0
	runTime = 19
	RateList = 20|40|60|120|240|300|600|1800|3600|7200|10800|14400|18000  ; Mandatory 20 second gap to allow all macros to execute
	GildList = Masked Samurai|Betty Clicker|King Midas|Bomber Max|Gog|Wepwawet|Tsuchi|Skogur|Moeru|Zilar|Madzi|Xavira|Cadu|Ceus|The Maw|Yachiyl
	
}
setDefaults()

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Set up AHK GUI's ;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set up top GUI
CustomColor := "EEEEEE"
Gui, Top:+HwndChildTop +AlwaysOnTop -Caption +ToolWindow ; -Caption ; no title, no taskbar icon 
Gui, Top:Margin, 10, 12
Gui, Top:Color, %CustomColor%
DllCall( "SetParent", "uint", ChildTop, "uint", Parent )  ; this method appears to work for the steam game, or the game in MS Edge brower.

; Set up bottom GUI
Gui, Btm:+HwndChildBtm +AlwaysOnTop -Caption +ToolWindow ; -Caption ; no title, no taskbar icon 
Gui, Btm:Margin, 10, 12
Gui, Btm:Color, %CustomColor%
DllCall( "SetParent", "uint", ChildBtm, "uint", Parent )

; Reload and Start/Stop button
Gui, Top:Add, Button, x10 y5 w80 h30, &Reload  
Gui, Top:Add, Button, x100 y5 w80 h30 gStaStoPro vStaStoBtn, Start (F4)
Gui, Top:Font, s7
Gui, Top:Add, Text, x10 y38, Activates for 'Boss Push' and 'Assign Gilds'
Gui, Top:Font, s7

; Custom 1 text boxes
Gui, Top:Add, Text, x240 y9, C1.1:
Gui, Top:Add, Edit, x268 y5 w32 h21 vC1X1 gApply, 482
Gui, Top:Add, Edit, x303 y5 w32 h21 vC1Y1 gApply, 614
Gui, Top:Add, Text, x342 y9, C1.2:
Gui, Top:Add, Edit, x370 y5 w32 h21 vC1X2 gApply, 90
Gui, Top:Add, Edit, x405 y5 w32 h21 vC1Y2 gApply, 400

; Custom 2 text boxes
Gui, Top:Add, Text, x240 y33, C2.1:
Gui, Top:Add, Edit, x268 y29 w32 h21 vC2X1 gApply, 482
Gui, Top:Add, Edit, x303 y29 w32 h21 vC2Y1 gApply, 614
Gui, Top:Add, Text, x342 y33, C2.2:
Gui, Top:Add, Edit, x370 y29 w32 h21 vC2X2 gApply, 90
Gui, Top:Add, Edit, x405 y29 w32 h21 vC2Y2 gApply, 490

; Notes
Gui, Top:Font, bold
Gui, Top:Add, Text, x465 y1 cGray, F5
Gui, Top:Add, Text, x465 y14 cGray, F8
Gui, Top:Add, Text, x465 y27 cGray, Shift -
Gui, Top:Add, Text, x465 y40 cGray, T
Gui, Top:Font, normal
Gui, Top:Add, Text, x510 y1 cGray, Click at mouse location
Gui, Top:Add, Text, x510 y14 cGray, Skip wait for boss push
Gui, Top:Add, Text, x510 y27 cGray, Minimise specific heroes
Gui, Top:Add, Text, x510 y40 cGray, Toggle level up rate

; Timer status and Coordinates
Gui, Top:Font, s14 bold
Gui, Top:Add, Text, vTimeF cRed y3 w120 x630 +Right, %runTime%
Gui, Top:Font, s12 normal
Gui, Top:Add, Text, vMyText y30 w120 x630 +Right, X
Gui, Top:Font, s10  
Gui, Top:Add, Text, vStatusText1 cGray y1 x755 +Right w210, Stopped
Gui, Top:Add, Text, vStatusText2 cGray y19 x755 +Right w210, 
Gui, Top:Add, Text, vStatusText3 cGray y37 x755 +Right w210, 

; Custom 1 selection boxes
Gui, Btm:Add, CheckBox, x10 y9 vOne  w13 h13 gApply,
Gui, Btm:Add, Text, x29 y9 w100 vOneHero +Left, Custom 1:
Gui, Btm:Add, DropDownList, x84 y5 w50 vOneRate +Left gApply Choose3, %RateList%

; Custom 2 selection boxes
Gui, Btm:Add, CheckBox, x10 y33 vTwo  w13 h13 gApply,
Gui, Btm:Add, Text, x29 y33 w100 vTwoHero +Left, Custom 2:
Gui, Btm:Add, DropDownList, x84 y29 w50 vTwoRate +Left gApply Choose3, %RateList%

; Collect gilds selection boxes
Gui, Btm:Add, CheckBox, x150 y9 vGildC  w13 h13 gApply,
Gui, Btm:Add, Text, x169 y9 w100 +Left, Collect Gilds:
Gui, Btm:Add, DropDownList, x235 y5 w50 vGildCRate +Left gApply Choose8, %RateList%

; Assign gilds selection boxes
Gui, Btm:Add, CheckBox, x150 y33 vGildA  w13 h13 gApply,
Gui, Btm:Add, Text, x169 y33 w100 +Left, Assign Gilds:
Gui, Btm:Add, DropDownList, x235 y29 w110 vGildAHero +Left gApply Choose6, %GildList%
Gui, Btm:Add, DropDownList, x350 y29 w50 vGildARate +Left gApply Choose9, %RateList%

; Auto Skills selection boxes
Gui, Btm:Add, ListBox, x423 y6 r3 vSkillChoice Multi gApply, Clickstorm|Powersurge|Lucky Strikes|Metal Detector|Golden Clicks|The Dark Ritual|Super Clicks|Energize|Reload
Gui, Btm:Add, DropDownList, x553 y29 w50 vSkillRate +Left gApply Choose1, %RateList%

; Upgrade all heroes setting
Gui, Btm:Add, CheckBox, x619 y9 vAll Checked w13 h13 gApply,
Gui, Btm:Add, Text, x639 y9 w100 +Left, Level All Heroes:
Gui, Btm:Add, DropDownList, x733 y5 w50 vAllRate +Left gApply Choose1, %RateList%

; Get all upgrades setting
Gui, Btm:Add, CheckBox, x619 y33 vUpgrades Checked w13 h13 gApply,
Gui, Btm:Add, Text, x639 y33 w100 +Left, Get All Upgrades:
Gui, Btm:Add, DropDownList, x733 y29 w50 vUpgradesRate +Left gApply Choose1, %RateList%

; Monster click setting
Gui, Btm:Add, CheckBox, x799 y9 vMonster Checked w13 h13 gApply,
Gui, Btm:Add, Text, x819 y9 w100 +Left, Click Monsters (ms):
Gui, Btm:Add, DropDownList, x924 y5 w50 vMonsterRate +Left gApply Choose1, 25|50|100|200|500

; Boss Push setting
Gui, Btm:Add, CheckBox, x799 y33 vBoss w13 h13 gApply,
Gui, Btm:Add, Text, x819 y33 w100 +Left, Boss Push (Pluto):
Gui, Btm:Add, DropDownList, x924 y29 w50 vPluto +Left gApply Choose2, No|Yes

; Show top GUI
Gui, Top:Show, x0 y0 w984 h55 NoActivate  ; width minus 28 for borders and margins

; Show bottom GUI
Gui, Btm:Show, x0 y609 w984 h55 NoActivate


; Set status timer on
SetTimer, StatusTimer, 200


Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;; Button Actions and Hotkeys ;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Form is automatically submitted when any new settings are made
Apply:
	Gui, Top:Submit, NoHide
	Gui, Btm:Submit, NoHide
Return


; Reloads script when the button is pressed
TopButtonReload:
	Reload
Return


; When the start/stop button is pressed
~F4::
StaStoPro:
	Critical
		
	; if not already running, start running
	if (!Running)
	{
		Running = 1
		
		Gosub Apply		
		
		GuiControl, Top: +cGreen +Redraw, TimeF		
		GuiControl, Top:, StatusText1, Running
		
		GuiControl, Top:, StaStoBtn, Stop (F4)
		
		SetTimer, RunningTimer, 1000

		if (Monster = 1)
			SetTimer, MonsterTimer, %MonsterRate%
	}
	else
	{
		Running = 0
		
		GuiControl, Top: +cRed +Redraw, TimeF
		GuiControl, Top:, StatusText1, Stopped
		
		GuiControl, Top:, StaStoBtn, Start (F4)
		
		SetTimer, RunningTimer, off
		setTimer, MonsterTimer, off	
	}	
	

Return


; Force a click through
~F5::
	Critical
	
	MouseGetPos, xpos, ypos
	ControlClick, % "x" xpos " y" ypos, ahk_id %Parent%,,,, NA	

	
return


; Skips the stall time for the Boss Push macro
~F8::
	Critical
	
	StallTime := StallTime - 999

Return



;;;;;;;;;;;;;;;;;;;;;;;;;;;; Status Timer ;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Update the Coordinates, Time and checks for Boss (if active)
StatusTimer:

	IfWinNotExist, ahk_id %Parent%
		ExitApp
		
	MouseGetPos, MouseX, MouseY
	GuiControl, Top:, MyText, X%MouseX%, Y%MouseY%  ; Update variable MyText with the coordinates

Return



;;;;;;;;;;;;;;;;;;;;;;;;;;;; Monster Timer ;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ms timer to click the monster
MonsterTimer:
	if (Monster = 1)
		ControlClick, x750 y400, ahk_id %Parent%,,,, NA
Return



;;;;;;;;;;;;;;;;;;;;;;;;;;;; Running Timer ;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Update the coordinates, time and checks for Boss (if active)
RunningTimer:

	; Update taskbar with the runtime in seconds
	runTime += 1	
	GuiControl, Top:, TimeF, %runTime%

	; Check if any other actions should be run every 20 seconds
	if (Mod(runTime, 20) = 0)
		SetTimer, ActionTimer, -1
		
	; Run the Boss Push Macro
	if (Boss = 1) 		
		BossPush(Pluto)

	

Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;; Action Timer ;;;;;;;;;;;;;;;;;;;;;;;;;;;

ActionTimer:

	setTimer, MonsterTimer, off

	; Store current time since started. This will be used for the rest of the loop
	currentS := runTime	

	; Run custom 1
	if (One = 1 and Mod(currentS, OneRate) = 0 and Running = 1)
	{
		ControlClick, x%C1X1% y%C1Y1%, ahk_id %Parent%,,,, NA ; First Click
		Sleep 300
		ControlClick, x%C1X2% y%C1Y2%, ahk_id %Parent%,,,, NA ; Second Click
		Sleep 100
	}
	
	; Run custom 2
	if (Two = 1 and Mod(currentS, TwoRate) = 0 and Running = 1)
	{
		ControlClick, x%C2X1% y%C2Y1%, ahk_id %Parent%,,,, NA ; First click
		Sleep 300
		ControlClick, x%C2X2% y%C2Y2%, ahk_id %Parent%,,,, NA ; Second Click
		Sleep 100
	}
	
	; Run the collect guilds macro
	if (GildC = 1 and Mod(currentS, GildCRate) = 0 and Running = 1)
	{
		GildCollect()
		Sleep 200
	}
	
	; Run the guild assign macro
	if (GildA = 1 and Mod(currentS, GildARate) = 0 and Running = 1)
	{			
		GildAssign(GildAHero)
		Sleep 100
	}

	; Run the skill click macro
	if (Mod(currentS, SkillRate) = 0 and Running = 1)
	{
		Loop, Parse, SkillChoice, |
		{
			ClickSkill(A_LoopField)
		}
	}
	
	; Run the level all heroes Macro
	if (All = 1 and Mod(currentS, AllRate) = 0 and Running = 1)
	{
		LevelAllHeroes()
		sleep 100
	}
	
	; Run the upgrade macro
	if (Upgrades = 1 and Mod(currentS, UpgradesRate) = 0 and Running = 1)
	{
		ScrolltoBottom()					
		ControlClick, x330 y565, ahk_id %Parent%,,,, NA ; Buy Available Upgrades
		sleep 100
	}
	
	; Run the monster timer
	if (Monster = 1 and Running = 1)
		SetTimer, MonsterTimer, %MonsterRate%
	
Return




;;;;;;;;;;;;;;;;;;;;;;;;;;;; Gild Collect Function ;;;;;;;;;;;;;;;;;;;;;;;;;;;

GildCollect()
{
	Global

	ControlClick, x955 y555, ahk_id %Parent%,,,, NA ; Present symbol at bottom right
	sleep 500
	ControlClick, x500 y380, ahk_id %Parent%,,,, NA ; Open gild
	sleep 1200
	ControlClick, x760 y530, ahk_id %Parent%,,,, NA ; Open All
	sleep 200
	ControlClick, x945 y108, ahk_id %Parent%,,,, NA ; Close all
	sleep 50
	ControlClick, x800 y173, ahk_id %Parent%,,,, NA ; Close single (if open all didn't exist)
}
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;; Gild Assign Function ;;;;;;;;;;;;;;;;;;;;;;;;;;;


GildAssign(GildAHero)
{	
	Global
	
	ActivateCH()
	
	ScrolltoBottom()
	
	; Check for the colour of the text of the 'Gilded' button, if it's not there click up and down to reset
	PixelSearch, ,, 100, 550, 110, 580, 0xECEEED, 0, Fast RGB
	if (ErrorLevel = 1) {
		ControlClick, % "x" 482 " y" 250, ahk_id %Parent%,,,, NA
		sleep 100
		ControlClick, % "x" 482 " y" 625, ahk_id %Parent%,,,, NA
		sleep 100
	}
	
	ControlClick, x120 y565, ahk_id %Parent%,,,, NA ; Gilded button
	sleep 200
	
	switch GildAHero
	{
		case "Masked Samurai":  Pos := 1, RowN := 2, ColN := 2
		case "Betty Clicker":  Pos := 1, RowN := 2, ColN := 1
		case "King Midas":  Pos := 1, RowN := 4, ColN := 3
		case "Bomber Max":  Pos := 2, RowN := 4, ColN := 1
		case "Gog":  Pos := 2, RowN := 4, ColN := 2
		case "Wepwawet":  Pos := 2, RowN := 4, ColN := 3
		case "Tsuchi":  Pos := 2, RowN := 4, ColN := 4
		case "Skogur":  Pos := 2, RowN := 5, ColN := 1
		case "Moeru":  Pos := 2, RowN := 5, ColN := 2
		case "Zilar":  Pos := 2, RowN := 5, ColN := 3
		case "Madzi":  Pos := 2, RowN := 5, ColN := 4
		case "Xavira":  Pos := 2, RowN := 6, ColN := 1
		case "Cadu":  Pos := 2, RowN := 6, ColN := 2
		case "Ceus":  Pos := 2, RowN := 6, ColN := 3
		case "The Maw":  Pos := 2, RowN := 6, ColN := 4
		case "Yachiyl":  Pos := 3, RowN := 5, ColN := 1
	}		
		
	yCo := 120 + RowN * 60
	xCo := ColN * 200
	
	if (Pos = 2)		
		ControlClick, x920 y388, ahk_id %Parent%,,,, NA ; Middle Position			
	else if (Pos = 3)	
		ControlClick, x920 y475, ahk_id %Parent%,,,, NA ; Bottom Position
		
	sleep 400

	Send {Q down}
	sleep 100
	ControlClick, % "x" xCo " y" yCo, ahk_id %Parent%,,,, NA
	sleep 100
	Send {Q up}
	
	sleep 200
	ControlClick, x945 y108, ahk_id %Parent%,,,, NA ; Close all		
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;; Boss Push Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;


BossPush(Pluto)
{
	Global
	Critical
	
	ActivateCH()
	
	; Check for the next zone still being there
	PixelSearch, ,, 980, 252, 965, 267, 0xFF0000, 0, Fast RGB
	if (ErrorLevel = 0) {
		
		if (StallTime = 0)
			StallTime := runTime
		
		Difference := runTime - StallTime	
		
		; Wait for 30 seconds before pushing
		if (Difference < 30) {				
			GuiControl, Top:, StatusText3, Stalled. Attempt %PushTime%/3. Waiting %Difference%

		} else {
					
			; if we've tried more than twice (since the last time we pushed with skills), activate some skills
			if (PushTime > 2) {
				BossSkills(Pluto)
				PushTime := 1
			} else {
				PushTime += 1
			}

			ControlClick, x973 y262, ahk_id %Parent%,,,, NA ;a	
			sleep 100
			ControlClick, x800 y125, ahk_id %Parent%,,,, NA ;next level
		}
	} else {			
		StallTime = 0
		GuiControl, Top:, StatusText3, 
	}
}


BossSkills(Pluto)
{
	Global
	
	Critical
	
	SkillCD := []
	; Skill Cooldown Check. e.g. for Clickstorm, SkillCD[1] will be 1 if available, 0 if on cooldown
	while (A_Index <= 9) {
		PixelSearch, ,, 520, % 182+A_Index*45, 548, % 193+A_Index*45, 0x990000, 0, Fast RGB
		SkillCD[A_Index] := ErrorLevel
	}	
	
	if (Pluto = "Yes" and SkillCD[3] = 1 and SkillCD[5] = 1)
	{
			; if Pluto is set to yes and Lucky Strikes AND Golden Clicks are available, run them and metal detector
			
			if (SkillCD[3] = 1)
				ClickSkill("Metal Detector")
				
			ClickSkill("Lucky Strikes")
			ClickSkill("Golden Clicks")
	} 
	else if (Pluto = "No" and SkillCD[3] = 1 and SkillCD[7] = 1) 
	{	
			; if Pluto is set to no and Lucky Strikes AND Super Clicks are available, run them	
			
			ClickSkill("Lucky Strikes")
			ClickSkill("Super Clicks")
	}
	else
	{
		; Otherwise run all available skills
		
		if (SkillCD[1] = 1)
			ClickSkill("Clickstorm")
		if (SkillCD[2] = 1)
			ClickSkill("Powersurge")
		if (SkillCD[4] = 1)
			ClickSkill("Metal Detector")			
		if (SkillCD[3] = 1)
			ClickSkill("Lucky Strikes")		
		if (SkillCD[5] = 1)
			ClickSkill("Golden Clicks")
		if (SkillCD[7] = 1)
			ClickSkill("Super Clicks")
	}

	; if Energize AND Reload are available, run them to reset the skills with highest cooldowns
	if (SkillCD[8] = 1 and SkillCD[9] = 1) {
		ClickSkill("Energize")
		ClickSkill("Reload")
	}	
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level All Heroes Function ;;;;;;;;;;;;;;;;;;;;;;;;;;;

LevelAllHeroes()
{
	Global

	ScrolltoBottom()
	
	; Continue running the all heroes Macro until complete
	while (A_Index <= 15 and Running = 1)
	{	
		GuiControl, Top:, StatusText2, Levelling all heroes, position %A_Index%
		
		while (A_Index <= 11 and Running = 1) {

			; Click every 40 pixels between Y238 and Y638 (covering all heroes on screen) A_Index starts at 1
			ControlClick, % "x50 y" 678-A_Index*40, ahk_id %Parent%,,,, NA
		}	
		
		ControlClick, % "x" 482 " y" 600, ahk_id %Parent%,, WheelUp,, NA
		Sleep, 20
		
	}
	GuiControl, Top:, StatusText2,
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;; Scroll to Bottom Function ;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScrolltoBottom()
{
	Global

	ControlClick, x482 y614, ahk_id %Parent%,,,, NA ; Scrollbar to bottom
	Sleep 300
	
}


ActivateCH()
{
	Global
	
	IfWinNotActive, ahk_id %Parent%
	{
		WinActivate, ahk_id %Parent%
		WinWaitActive, ahk_id %Parent%
	}
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Click Skill Function ;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClickSkill(Skill)
{
	Global

	switch Skill
	{
		case "Clickstorm":   ControlClick, x535 y235, ahk_id %Parent%,,,, NA
		case "Powersurge":  ControlClick, x535 y275, ahk_id %Parent%,,,, NA
		case "Lucky Strikes":    ControlClick, x535 y325, ahk_id %Parent%,,,, NA
		case "Metal Detector":    ControlClick, x535 y370, ahk_id %Parent%,,,, NA
		case "Golden Clicks":   ControlClick, x535 y410, ahk_id %Parent%,,,, NA
		case "The Dark Ritual":   ControlClick, x535 y460, ahk_id %Parent%,,,, NA
		case "Super Clicks":   ControlClick, x535 y505, ahk_id %Parent%,,,, NA
		case "Energize":   ControlClick, x535 y545, ahk_id %Parent%,,,, NA
		case "Reload":   ControlClick, x535 y590, ahk_id %Parent%,,,, NA
	}
	
	sleep 50
}
