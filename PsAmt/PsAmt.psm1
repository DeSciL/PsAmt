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
  - Get-RequesterStatistic
  - Get-RequesterWorkerStatistic
	
  Currently not implemented:
  // GetHITsForQualificationType
  // GetQualificationsForQualificationType
  // GetReviewableHITs
  // GetReviewResultsForHIT
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

#########################################################################################
# AmtApi
# Exports from AmtApi.ps1

Export-ModuleMember Connect-AMT, Disconnect-AMT, Get-AccountBalance
#Export-ModuleMember Test-AmtApi

# HITS
Export-ModuleMember Add-HIT, Stop-HIT, Expand-HIT, Remove-HIT, Disable-HIT
Export-ModuleMember Get-AllHITs, Get-HIT, Get-ReviewableHITs
# Not Implemented: Get-ReviewResultsForHIT, Get-HitsForQualificationType

# Objects
Export-ModuleMember New-HIT, New-ExternalQuestion, New-HtmlQuestion, New-QuestionForm
Export-ModuleMember New-Price, New-Locale, New-TestHIT, New-QualificationRequirement

# HITTypes
Export-ModuleMember New-HITType, Register-HITType, Set-HITTypeOfHIT

# Assignments
Export-ModuleMember Approve-Assignment, Deny-Assignment, Approve-RejectedAssignment
Export-ModuleMember Get-AllAssignmentsForHIT, Get-Assignment
# Not Implemented: Get-AssignmentsForHIT

# Qualifications
Export-ModuleMember Get-AllQualificationTypes, Get-QualificationType
Export-ModuleMember Add-QualificationType, Remove-QualificationType, Update-QualificationType
Export-ModuleMember Grant-Qualification, Revoke-Qualification
Export-ModuleMember Get-QualificationScore, Update-QualificationScore
Export-ModuleMember Get-QualificationRequests, Grant-QualificationRequest, Deny-QualificationRequest
Export-ModuleMember Add-QualificationTypeFull, Get-QualificationsForQualificationType
Export-ModuleMember Search-QualificationTypes

# Misc
Export-ModuleMember Block-Worker, Unblock-Worker, Get-BlockedWorkers
Export-ModuleMember Grant-Bonus, Get-BonusPayments
Export-ModuleMember Send-WorkerNotification, Get-FileUploadUrl, Enter-HIT
Export-ModuleMember Get-RequesterStatistic, Get-RequesterWorkerStatistic

# Not yet implemented: Search-HITs, Send-TestEventNotification, Set-HITAsReviewing, Set-HITTypeNotification

#########################################################################################
# AmtUtil
# Exports in AmtUtil.ps1

Export-ModuleMember Set-AMTKeys
Export-ModuleMember Get-AMTKeys

#########################################################################################