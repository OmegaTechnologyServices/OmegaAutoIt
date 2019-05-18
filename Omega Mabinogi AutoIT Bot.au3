#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
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

; Define variables. Do not edit any of these. Only edit variables in the box below
; Skill Rank numeration  N F E D C B A 9 8 7  6  5  4  3  2  11
Global $SkillRank[16] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

; Skill rank numeration 0  1  2  3  4  5  6  7  8  9   10  11  12   13   14   15
Global $RespiteReq[16] = [2,10,13,20,25,29,34,50,67,134,271,556,556,1000,1000,1000]



;	################CHANGE ONLY THESE VARIABLES#################

; 	#----------------------------------------------------------#
		 $yourskillrank = 12 ; Enter your current skill rank
		 $currentskilluses = 360 ; Enter current skill exp
		 $expboost = 4 ; Enter current skill multiplier

		 ; Enter XY position for inside skill box

		 $skillX = 2475
		 $skillY = 1200

		 ; Enter XY position for confirmation message box

		 $confirmX = 1235
		 $confirmY = 800

		 ; Select skill by changing 0 to 1. Only one marked at a time.
		 ; Failure to do so will result in unreliability in script.

		 $respite = 1

		 ; Debugging related variables. Leave these alone if you
		 ; don't know what you're doing. Contact by email for support.

		 $ClientForeground = 1
;	#----------------------------------------------------------#

; Hook to client

if $ClientForeground = 1 Then ; This simply enables the script when Mabinogi is on the foreground.
							  ; Tabbing off Mabinogi will temporarily pause script.
							  ; This is not a hook and is safe to run. Disabling is for debugging purposes.
 WinActivate("Mabinogi")
 WinWaitActive("Mabinogi")

EndIf
; Assign skill variables

$iSkill = $yourskillrank
$iReq = $yourskillrank
$usecount = $currentskilluses / $expboost
$boost = 1 * $expboost

; Assign proper skill variables based on skill selection

   While $respite = 1

	$SkillReq = $RespiteReq
	$usereq = $skillreq[$iReq] / $expboost

; Compare variables for use  
	  If $usecount < $usereq Then 
	; Utilize skill and incriment variables
		 Send("1")
		 $usecount = $usecount + 1
		 ; Start Cooldown
			Sleep (122500) ; 122500

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
			   sleep (121700) ; 121700


		EndIf

   WEnd