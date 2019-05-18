#cs ----------------------------------------------------------------------------

Omega Mabinogi AutoIT Bot
	Preview Build 1.0
		Currently supports training of Respite or  with auto rank up. Follow instructions on
		MabiMods.net -

Built for AutoIt Version: 3.3.14.5

 Author: Mastodon
   omegatechnologyservices@protonmail.com
   5/16/2019


 Script Function:
   This script is for us in the game Mabinogi. This will automatically use and train skills that only require you to use them
   it will also rank up the skill if you assign it coordinates. Be careful only to change variables inside the box.
   The script will become more dynamic with more skills in the future over time and updates will be posted to github

   Check for updates here

   For questions find me on Discord


   You can utilize mousePOS to get your x,y positions


 https://www.adminsehow.com/2012/03/realtime-mouse-position-monitor-tool/

#ce ----------------------------------------------------------------------------

;	################CHANGE ONLY THESE VARIABLES#################

; 	#------------------------------------------------------------------------------------------------------------#
		 $yourskillrank = 0 ; Enter your current skill rank. Set based on numerical value related to chart above
		 $currentskilluses = 0 ; Enter current skill use from the menu
		 $expboost = 4 ; Enter current skill multiplier from potions, items or talent

		 ; Enter XY position for inside skill box

		 $RespiteX = 2475
		 $RespiteY = 1200

		 $SmokescreenX = 2475
		 $SmokescreenY = 1065

		 ; Enter XY position for confirmation message box

		 $confirmX = 1225
		 $confirmY = 765

		 ; Select skill by changing 0 to 1. Only one marked at a time.
		 ; Failure to do so will result in unreliability in script.

		 $Respite = 0 ; You can train Respite anywhere
		 $Smokescreen = 1 ; Recommend training Smokescreen at Dugald Raccoons or Tir foxes

		 ; Input your skill hotkeys wrapped in " "
		 $RespiteHotkey = "1"
		 $SmokescreenHotkey = "6"

		 ; Debugging related variables. Leave these alone if you
		 ; don't know what you're doing.

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

		 ; Skill Rank numeration  N F E D C B A 9 8 7  6  5  4  3  2  11
		 Global $SkillRank[16] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

		 ; Skill requirement vairables. Do not make changes to these
		 Global $RespiteReq[16] = [2,10,13,20,25,29,34,50,67,134,271,556,556,1000,1000,1000]

		 Global $SmokescreenReq[16] = [10,34,50,100,143,167,200,250,334,500,667,834,1000,1250,1667,5000]
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

; Compare variables for use
	  If $usecount < $usereq Then
	; Utilize skill and incriment variables
		 Send($SkillHotkey)
		 $usecount = $usecount + 1
		 ; Start Cooldown
			Sleep ($SkillCooldown) ; 122500

			ElseIf $usecount >= $usereq Then ; Compare variables for rank

			; Increase skill rank, get new usereq value, reset usecounter

			MouseMove ( $skillX, $skillY, 500)
			MouseClick ( "Left" )
			   sleep (800)
			MouseMove ( $confirmX, $confirmY, 500)
			MouseClick ( "Left")
				$iSkill = $iSkill + 1
			    $iReq = $iReq + 1
			    $usereq = $SkillReq[$iReq] / $expboost
			    $usecount = 0
			; Start cooldown
			   sleep ($SkillRankCooldown) ; 121700
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


; Compare variables for use
	  If $usecount < $usereq Then
	; Utilize skill and incriment variables
		 Send($SmokescreenHotkey)
			Sleep(100)
		 Send("{CTRLDOWN}")
			Sleep(500)
		 MouseClick("left")
			Sleep(200)
		 Send("{CTRLUP}")
		 $usecount = $usecount + 1
		 ; Start Cooldown
			Sleep ($SkillCooldown) ; 122500

			ElseIf $usecount >= $usereq Then ; Compare variables for rank

			; Increase skill rank, get new usereq value, reset usecounter

			MouseMove ( $skillX, $skillY, 500)
			MouseClick ( "Left" )
			   sleep (800)
			MouseMove ( $confirmX, $confirmY, 500)
			MouseClick ( "Left")
				$iSkill = $iSkill + 1
			    $iReq = $iReq + 1
			    $usereq = $SkillReq[$iReq] / $expboost
			    $usecount = 0
			; Start cooldown
			   sleep ($SkillRankCooldown) ; 121700
		EndIf
	 WEnd
; #----------------------------------------------------------------------#

