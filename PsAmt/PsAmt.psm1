#########################################################################################
# PsAmt Module
# stwehrli@gmail.com
# 28apr2014
#########################################################################################

# Global Settings
[string]$Global:AmtModulePath = Get-Module -ListAvailable PsAmt | Split-Path -Parent
[string]$Global:AmtKeyPath = Get-Module -ListAvailable PsAmt | Split-Path -Parent
[bool]$Global:AmtSandbox = $true
[string]$Global:AmtConsoleColor = "Cyan"
[Security.SecureString]$Global:AmtPassphrase = $null

#########################################################################################
<# 
 .SYNOPSIS 
  PowerShell scripts to access Amazon Mechanical Turk

 .DESCRIPTION
  Connect to Amazom Mechanical Turk by means of PowerShell Wrappers
  for the AMT .Net SDK. First step is to setup a connection to the web
  service with: 

  Connect-AMT -AccessKey "MyAccessKeyId" -SecretKey "MySecretKey" -Sandbox

  After a successful connection, the following operations are supported. 
  See comment based help of the functions for more details, e.g. help Add-Hit

  Settings:
  - Connect-AMT
  - Set-AMTKeys

  Working with Hits:
  - Add-HIT
  - Get-HIT
  - Set-HITTypeOfHIT
  - Disable-HIT
  - Remove-HIT
  - Expand-HIT
  - Stop-HIT
  - Register-HITType

  Assignments:
  - Approve-Assignment
  - Approve-RejectedAssignment
  - Get-Assignment
  - Get-AssignmentsForHIT
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
	
  Currently not implemented:
  // GetHITsForQualificationType
  // GetQualificationsForQualificationType
  // GetReviewableHITs
  // GetReviewResultsForHIT
  // GetRequesterStatistic
  // GetRequesterWorkerStatistic
  // Help
  // SearchHITs
  // SendTestEventNotification
  // SetHITAsReviewing
  // SetHITTypeNotification

 .NOTES
  PowerShell scripts are based on .Net code and
  infrastructure provided by:
  https://github.com/descil/dotnetmturk
  http://mturkdotnet.codeplex.com/
  http://www.mturk.com

 .LINK
  https://github.com/descil/psamt
  
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