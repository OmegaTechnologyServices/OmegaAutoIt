#cs ----------------------------------------------------------------------------

Omega Mabinogi AutoIT Bot
	Preview Build 1.4.0
		Currently supports training of Respite, Tumble, and Smokescreen with auto rank up. Follow instructions on
		MabiMods.net - https://mabimods.net/index.php?topic=18118.0

		Get Updated code from GitHub (Auto-Update coming in the future)
		https://github.com/OmegaTechnologyServices/OmegaAutoIt/edit/master/Omega%20Mabinogi%20AutoIT%20Bot.au3

Built for AutoIt Version: 3.3.14.5

 Author: Mastodon
   omegatechnologyservices@protonmail.com
   5/16/2019


 Script Function:
   This script is for use in the game Mabinogi. This will automatically use, train, and rank skills if you assign it coordinates. 
   Be careful not to change variables in boxes marked "DO NOT TOUCH" or "DO NOT CHANGE". I will be developing a frontend programs in
   in the future to make this more user friendly. For now you'll have to pretend to be a coder.
   The script will become more dynamic with more skills in the future over time and updates will be posted to github

   For questions find me on Discord @ OmegaMastodon#3218


   You can utilize mousePOS to get your x,y positions


 https://www.adminsehow.com/2012/03/realtime-mouse-position-monitor-tool/

#ce ----------------------------------------------------------------------------

;							############### IMAGE SEARCH PARAMETERS ################
;							############ SET UI TO [NEON GREEN][OPAQUE]#############
;	#--------------------------------------------------------------------------------------------------------#
		 #AutoIt3Wrapper_UseX64 = Y
		 #include <ImageSearch.au3>

		 ;Enable Image Search by changing 0 to 1. Currently not functional INSIDE the game. Working on fix.
			$ImageSearch = 0
		 global $y = 0, $x = 0


		 Func checkForImage()
		 Local $search = _ImageSearch('AdvanceButton.bmp', 1, $x, $y, 0)
		 If $search = 1 Then
		 MouseMove($x, $y, 500)
		 MouseClick("Left")
			ElseIf $search = 0 Then
				Call ("CheckForImage")
		 EndIf
		 EndFunc


;							############### DO NOT TOUCH THESE ARRAYS ################
; 	#--------------------------------------------------------------------------------------------------------#

; Skill Rank numeration           N F E D C B A 9 8 7  6  5  4  3  2  1
		 Global $SkillRank[16] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
		 Global $rN=0,$rF=1,$rE=2,$rD=3,$rC=4,$rB=5,$rA=6,$r9=7,$r8=8,$r7=9,$r6=10,$r5=11,$r4=12,$r3=13,$r2=14,$r1=1

; Skill requirement vairables. Do not make changes to these
		 Global $RespiteReq[16] = [2,10,13,20,25,29,34,50,67,134,271,556,556,1000,1000,1000]

; Skill Rank numeration     			N  F  E   D   C   B   A   9   8   7   6   5    4    3    2    1
		 Global $SmokescreenReq[16] = [10,34,50,100,143,167,200,250,334,500,667,834,1000,1250,1667,5000]

; Skill Rank numeration 		  N  F  E  D  C   B   A   9   8   7 6 5 4 3 2 1
		 Global $TumbleReq[16] = [2,31,50,67,40,120,267,267,267,406,0,0,0,0,0,0]

; Skill Rank numeration  	  			N F E D  C  B  A   9   8   7   6   5    4    3    2    1
		 Global $TumbleBattleReq[16] = [0,0,0,0,30,40,60,120,120,180,500,667,1000,1429,2000,2000]

;						################CHANGE ONLY THESE VARIABLES#################
;   #------------------------------------------------------------------------------------------------------------#

		 ; Select skill by changing 0 to 1. Only one marked at a time.
		 ; Failure to do so will result in unreliability in script.

		 $Respite = 1; You can train Respite anywhere

		 $Smokescreen = 0 ; Recommend training Smokescreen at Dugald Raccoons or Tir foxes

		 $Tumble = 0 ; Recommend training Tumble at Dugald Raccoons or Tir foxes. Enter current use count for in battle
			$TumbleBattleUse =0

		 ; Enter initial variable values

		 $yourskillrank = $r2 ; Enter your current skill rank. Set based on numerical value related to chart above
		 $currentskilluses = 244 ; Enter current skill use from the menu
		 $expboost = 2 ; Enter current skill multiplier from potions, items or talent

		 ; Enter XY position for Advance button located inside skill box. This stays static.

		 $RespiteX = 2470
		 $RespiteY = 930

		 $SmokescreenX = 2475
		 $SmokescreenY = 1065

		 $TumbleX = 2470
		 $TumbleY = 1245

		 ; Enter XY position for confirmation message box

		 $RespiteConfirmX = 1225
		 $RespiteConfirmY = 765

		 $SmokescreenConfirmX = 1235
		 $SmokescreenConfirmY = 795

		 $TumbleConfirmX = 1235
		 $TumbleConfirmY = 795

		 ; Select skill by changing 0 to 1. Only one marked at a time.
		 ; Failure to do so will result in unreliability in script.

		 ; Input your skill hotkeys wrapped in " "
		 $RespiteHotkey = "1"
		 $SmokescreenHotkey = "6"
		 $TumbleHotkey = "2"

		 ; Debugging related variables. Leave these alone if you
		 ; don't know what you're doing.

		 $Debug = 0
		 $ClientForeground = 1
;	#--------------------------------------------------------------------------------------------------------#

;							############### DO NOT TOUCH THESE VARIABLES ################
;   						######### ONLY EDIT IF EXPERIENCING COOLDOWN ISSUES #########
; 	#--------------------------------------------------------------------------------------------------------#

		 ;Respite Variables
			$RespiteCooldown = 122500
			$RespiteRankCooldown = 121700

		 ; Smokescreen Variables
			$SmokescreenCooldown = 16000
			$SmokescreenRankCooldown = 15200

		 ; Tumble Variables
			$TumbleCooldown = 10500
			$TumbleRankCooldown = 9700

;	#--------------------------------------------------------------------------------------------------------#

; Hook to client

if $ClientForeground = 1 Then ; This simply enables the script when Mabinogi is on the foreground.
							  ; Tabbing off Mabinogi will temporarily pause script.
							  ; This is not a hook and is safe to run. Disabling is for debugging purposes.
 WinActivate("Mabinogi")	  ; Disabling the ClientForeground will cause the bot to skip the first
 WinWaitActive("Mabinogi")    ; attempt at use, since you are not clicked in Mabinogi when script starts
							  ; This will give the illusion the bot is not working. It is, just wait.
EndIf

; Assign use and requirement related variables

$iSkill = $yourskillrank
$iReq = $yourskillrank
$usecount = $currentskilluses / $expboost
$boost = 1 * $expboost

; Assign loop variables based on skill selection

; ############### RESPITE TRAINING ##############
   While $Respite = 1

		$SkillReq = $RespiteReq
		$SkillHotkey = $RespiteHotkey
		$SkillCooldown = $RespiteCooldown
		$SkillRankCooldown = $RespiteRankCooldown
		$usereq = $skillreq[$iReq] / $expboost
	    $SkillX = $RespiteX
	    $SkillY = $RespiteY

		if $debug = 1 Then
			$SkillCooldown = 100
			$SkillRankCooldown = 100
			EndIf

; Compare variables for use
	  If $usecount < $usereq Then
	; Utilize skill and incriment variables
		 Send($SkillHotkey)
		 Sleep(500)
		 Send("{ESC}")
		 $usecount = $usecount + 1
		 ; Start Cooldown
			Sleep ($SkillCooldown)

			ElseIf $usecount >= $usereq Then ; Compare variables for rank

			; Increase skill rank, get new usereq value, reset usecounter

			MouseMove ( $skillX, $skillY, 500)
			MouseClick ("Left")
			   sleep (800)
		 If $ImageSearch = 1 Then
			Call ("CheckForImage")
		 ElseIf $ImageSearch = 0 Then
			MouseMove ( $RespiteConfirmX, $RespiteConfirmY, 500)
			MouseClick ( "Left")
		 EndIf
				$iSkill = $iSkill + 1
			    $iReq = $iReq + 1
			    $usereq = $SkillReq[$iReq] / $expboost
			    $usecount = 0
			; Start cooldown
			   sleep ($SkillRankCooldown)
		EndIf
	 WEnd
; #----------------------------------------------------------------------#


; ############### SMOKESCREEN TRAINING ##############

   While $Smokescreen = 1

		 $SkillReq = $SmokescreenReq
		 $SkillHotkey = $SmokescreenHotkey
		 $SkillCooldown = $SmokescreenCooldown
		 $SkillRankCooldown = $SmokescreenRankCooldown
		 $usereq = $skillreq[$iReq] / $expboost
		 $SkillX = $SmokescreenX
		 $SkillY = $SmokescreenY

		if $debug = 1 Then
			$SkillCooldown = 100
			$SkillRankCooldown = 100
			EndIf

; Compare variables for use
	  If $usecount < $usereq Then
	; Utilize skill and incriment variables
		 Send("{TAB}")
		 Send($SmokescreenHotkey)
			Sleep(100)
		 Send("{CTRLDOWN}")
			Sleep(500)
		 MouseClick("Left")
		 Send("{CTRLUP}")
		 $usecount = $usecount + 1
		 ; Start Cooldown
			Sleep ($SkillCooldown)

			ElseIf $usecount >= $usereq Then ; Compare variables for rank

			; Increase skill rank, get new usereq value, reset usecounter

			MouseMove ( $skillX, $skillY, 500)
			MouseClick ("Left")
			   sleep (800)
		 If $ImageSearch = 1 Then
			Call ("CheckForImage")
		 ElseIf $ImageSearch = 0 Then
			MouseMove ( $SmokescreenConfirmX, $SmokescreenConfirmY, 500)
			MouseClick ( "Left")
		 EndIf
				$iSkill = $iSkill + 1
			    $iReq = $iReq + 1
			    $usereq = $SkillReq[$iReq] / $expboost
			    $usecount = 0
			; Start cooldown
			   sleep ($SkillRankCooldown)
		EndIf
	 WEnd
; #----------------------------------------------------------------------#

; ############### TUMBLE TRAINING ##############
	; Tumble specific variable assignment

		$battlecount = $TumbleBattleUse / $expboost
		$BattleCooldown = $TumbleCooldown - 5000

 While $Tumble = 1

		$FindTargetSleep = 10000
		$SkillReq = $TumbleReq
		$BattleReq = $TumbleBattleReq
		$SkillHotkey = $TumbleHotkey
		$SkillCooldown = $TumbleCooldown
		$SkillRankCooldown = $TumbleRankCooldown
		$usereq = $SkillReq[$iReq] / $expboost
		$battlereq = $BattleReq[$iReq] / $expboost
	    $SkillX = $TumbleX
	    $SkillY = $TumbleY
			; Shorten loop for debug purposes
		if $debug = 1 Then
			$SkillCooldown = 100
			$SkillRankCooldown = 100
			$FindTargetSleep = 100
			EndIf

; Compare variables for use
	  If $usecount < $usereq And $BattleCount < $BattleReq Then
		 Send("{TAB}")
		 Send("{CTRLDOWN}")
			sleep(250)
		 MouseClick("Left")
		 Send("{CTRLUP}")
			Sleep($FindTargetSleep)
		 Send($SkillHotkey)
		 $usecount = $usecount + 1
		 $battlecount = $battlecount + 1
		 ; Start Cooldown
			Sleep ($BattleCooldown)


; Check if Use requirements have been met, and continue to increase BattleCount
		ElseIf $usecount >= $usereq And $BattleCount < $BattleReq Then
		 Send("{TAB}")
		 Send("{CTRLDOWN}")
			sleep(250)
		 MouseClick("Left")
		 Send("{CTRLUP}")
			Sleep($FindTargetSleep)
		 Send($SkillHotkey)
		 $battlecount = $battlecount + 1
		 ; Start Cooldown
			Sleep ($BattleCooldown)

; Check if Battle requirements have been met, and continue to increase UseCount
	   ElseIf $usecount < $usereq And $BattleCount >= $BattleReq Then
			Send($SkillHotkey)
			 $usecount = $usecount + 1
			 ; Start Cooldown
				Sleep ($SkillCooldown)

; Increase skill rank, get new usereq value, reset counters
			ElseIf $usecount >= $usereq and $BattleCount >= $BattleReq Then; Compare variables for rank
			MouseMove ( $skillX, $skillY, 500)
			   sleep (800)
		 If $ImageSearch = 1 Then
			Call ("CheckForImage")
		 ElseIf $ImageSearch = 0 Then
			MouseMove ( $TumbleConfirmX, $TumbleConfirmY, 500)
			MouseClick ( "Left")
		 EndIf
				$iSkill = $iSkill + 1
			    $iReq = $iReq + 1
			    $usereq = $SkillReq[$iReq] / $expboost
			    $usecount = 0
				$battlecount = 0
			; Start cooldown
			   sleep ($SkillRankCooldown)
		EndIf
	 WEnd
