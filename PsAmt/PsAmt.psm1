#########################################################################################
# PsAmt Module
# stwehrli@gmail.com
# 28apr2014
#########################################################################################

# Global Settings
[string]$Global:AmtModulePath = Get-Module -ListAvailable PsAmt | Split-Path -Parent
[string]$Global:AmtKeyPath = Get-Module -ListAvailable PsAmt | Split-Path -Parent

#########################################################################################
<# 
 .SYNOPSIS 
  PowerShell scripts to access Amazon Mechanical Turk

 .DESCRIPTION
  Connect to Amazom Mechanical Turk by means of PowerShell Wrappers
  for the AMT .Net SDK. First step is to setup a connection to the web
  service with: 

  Connect-Amt -AccessKey "MyAccessKeyId" -SecretKey "MySecretKey" -Sandbox

  After a successful connection, the following operations are supported. 
  See comment based help of the functions for more details, e.g. help Add-Hit

  Settings:
  - Connect-Amt
  - Set-AmtKeys

  Working with Hits:
  - Add-Hit
  - Get-Hit
  - Set-HitTypeOfHit
  - Disable-Hit
  - Remove-Hit
  - Expand-Hit
  - Stop-Hit
  - Register-HitType

  Assignments:
  - Approve-Assignment
  - Approve-RejectedAssignment
  - Get-Assignment
  - Get-AssignmentsForHit
  - Reject-Assignment

  Qualifications:
  - Add-QualificationType
  - Get-QualificationType
  - Update-QualificationType
  - Remove-QualificationType
  - Search-QualificationTypes
  - Get-QualificationRequests
  - Reject-QualificationRequest
  - Get-QualificationScore
  - Update-QualificationScore
  - Grant-Qualification
  - Revoke-Qualification

  Bonus payments:
  - Grant-Bonus
  - Get-BonusPayments

  Misc:
  - Get-AccountBalance
  - Block-Worker
  - Get-BlockedWorkers
  - Unblock-Worker
  - Get-FileUploadURL
  - Send-WorkerNotification
	
  Currently implemented operations:
  //GetHITsForQualificationType
  //GetQualificationsForQualificationType
  //GetReviewableHITs
  //GetReviewResultsForHIT
  //GetRequesterStatistic
  //GetRequesterWorkerStatistic
  //Help
  //SearchHITs
  //SendTestEventNotification
  //SetHITAsReviewing
  //SetHITTypeNotification

 .LINK
  https://github.com/descil/psamt
  https://github.com/descil/dotnetmturk
  http://mturkdotnet.codeplex.com/
  http://www.mturk.com
#>
function about_PsAmt {}

#########################################################################################
# Exports 
Export-ModuleMember about_PsAmt

# AmtApi
# Exports in AmtApi.ps1

# AmtUtil
# Exports in AmtUtil.ps1

#########################################################################################