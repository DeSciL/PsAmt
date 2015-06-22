#########################################################################################
# PsAmt Module - Amazon Mechanical Turk .NET API for PowerShell
# stwehrli@gmail.com
# 28apr2014
#########################################################################################
#
# PowerShell Wrappers for the Amazon Mechanical Turk .Net SDK
# http://mturkdotnet.codeplex.com/
#
##########################################################################################
# CONTENTS
#
# about_AmtApi
# Connect-Amt
#
# ---------------------------------------  -----------  ----------------------------------           
# AMT WebService Operation                 Implemented  PowerShell Wrapper Name                
#                                          Status       .Net API
# ---------------------------------------  -----------  ----------------------------------           
# ApproveAssignment                        ok           Approve-Assignment
# ApproveRejectedAssignment                ok           Approve-RejectedAssignment
# AssignQualification                      ok           Grant-Qualification
# BlockWorker                              ok           Block-Worker
# ChangeHITTypeOfHIT                       ok           Set-HitTypeOfHit
# CreateHIT                                ok           Add-Hit
# CreateQualificationType                  --           Add-QualificationType
# DisableHIT                               ok           Disable-Hit
# DisposeHIT                               ok           Remove-Hit
# DisposeQualificationType                 ok           Remove-QualificationType
# ExtendHIT                                ok           Expand-Hit
# ForceExpireHIT                           ok           Stop-Hit
# GetAccountBalance                        ok           Get-AccountBalance
# GetAssignment                            ok           Get-Assignment
# GetAssignmentsForHIT                     --           Get-AssignmentsForHit
#                                          --           Get-AllAssignmentsForHit
# GetBlockedWorkers                        ok           Get-BlockedWorkers
# GetBonusPayments                         ok           Get-BonusPayments
# GetFileUploadURL                         ok           Get-FileUploadURL
# GetHIT                                   ok           Get-Hit
#                                          ok           Get-AllHits
# GetHITsForQualificationType              --           Get-HitsForQualificationType
# GetQualificationsForQualificationType    --           Get-QualificationsForQualificationType
# GetQualificationRequests                 --           Get-QualificationRequests 
# GetQualificationScore                    ok           Get-QualificationScore
# GetQualificationType                     ok           Get-QualificationType
# --                                       --           Get-AllQualificationTypes
# --                                       ok           Add-QualificationRequirement
# GetReviewableHITs                        --           Get-ReviewableHits 
# GetReviewResultsForHIT                   --           Get-ReviewResultsForHit
# GetRequesterStatistic                    --           Get-RequesterStatistic
# GetRequesterWorkerStatistic              --           Get-RequesterWorkerStatistic
# GrantBonus                               ok           Grant-Bonus
# GrantQualification                       --           Grant-QualificationRequest
# Help                                     --       
# NotifyWorkers                            ok           Send-WorkerNotification
# RegisterHITType                          --           Register-HitType
# RejectAssignment                         ok           Deny-Assignment
# RejectQualificationRequest               ok           Deny-QualificationRequest  
# RevokeQualification                      ok           Revoke-Qualification
# SearchHITs                               --           --> GetHits() 
# SearchQualificationTypes                 ok(limited)  Search-QualificationTypes
# SendTestEventNotification                --            
# SetHITAsReviewing                        --         
# SetHITTypeNotification                   --          
# UnblockWorker                            ok           Unblock-Worker
# UpdateQualificationScore                 ok           Update-QualificationScore
# UpdateQualificationType                  --           Update-QualificationType
#
# --                                                    New-QualificationRequirement
# --                                                    New-ExternalQuestion
# --                                                    New-QuestionForm
# --                                                    New-HtmlQuestion
# --                                                    New-Hit
# --                                                    New-Price
# --                                                    New-Locale
#
#########################################################################################
# Settings

[bool]$Global:AmtSandbox = $true

#########################################################################################
<# 
 .SYNOPSIS 
  PowerShell scripts to access Amazon Mechanical Turk

 .DESCRIPTION
  Connect to Amazom Mechanical Turk by means of PowerShell Wrappers
  for the AMT .Net SDK. First step is to setup a connection to the web
  service with: 

  Connect-Amt -AccessKey "MyAccessKeyId" -SecretKey "MySecretKey" -Sandbox

  After a successful connection, the following implemented operations
  are supported. See comment based help of the functions for more details, 
  e.g. help Add-Hit

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
	
  Not implemented operations:
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
  http://www.mturk.com
  http://mturkdotnet.codeplex.com/
#>
function about_AmtApi {}

#########################################################################################
function Connect-Amt {
<# 
  .SYNOPSIS 
   Connect to Amazom Mechanical Turk
  
  .DESCRIPTION
   Connect to Amazom Mechanical Turk by means of the .Net SDK. This function
   set

  .PARAMETER  AccessKey
   The Amazon Mechanical Turk access key.

  .PARAMETER  SecretKey
   The Amazon Mechanical Turk secret key id.
   
  .PARAMETER  Sandbox
   Switches between sandbox and production site.
 
  .EXAMPLE 
   Connect-Amt -AccessKeyId "MyAccessKeyId" -SecretKey "MySecretKey" -Sandbox

  .LINK
   about_AmtApi
#>
  Param(
   [Parameter(Position=0, Mandatory=$false)]
   [string]$AccessKeyId,
   [Parameter(Position=1, Mandatory=$false)]
   [string]$SecretKey,
   [Parameter(Position=2, Mandatory=$false)]
   [switch]$Sandbox
  )

  # Set assembly location
  $assembly = "Amazon.WebServices.MechanicalTurk.dll"
  $modulePath = $Global:AmtModulePath
  $assemblyPath = Join-Path $modulePath $assembly
  
  # Test if assembly is present
  if(!(Test-Path $assemblyPath)) { 
    Write-Error "Amazon Mechanical Turk Assembly not found." -ErrorAction Stop
  }

  # Get WebService credentials from encrypted key file
  if(!$AccessKeyId) { $AccessKeyId = Get-AmtKeys -AccessKey }
  if(!$SecretKey) { $SecretKey = Get-AmtKeys -SecretKey }

  # Check if sandbox
  if($Sandbox.IsPresent) {
    $Global:AmtSandbox = $true
  } else {
    $Global:AmtSandbox = $false
  }

  # Set Endpoint and URL
  if($AmtSandbox) {
    $AmtServiceEndpoint = "https://mechanicalturk.sandbox.amazonaws.com?Service=AWSMechanicalTurkRequester"
    $AmtWebsiteUrl = "https://mechanicalturk.sandbox.amazonaws.com" 
  } else {
    $AmtServiceEndpoint = "https://mechanicalturk.amazonaws.com?Service=AWSMechanicalTurkRequester"
    $AmtWebsiteUrl = "https://mechanicalturk.amazonaws.com"
  }

  # Setup config and simple client
  $Global:AmtAssembly = [Reflection.Assembly]::LoadFile($assemblyPath)
  $Global:AmtConfig = New-Object Amazon.WebServices.MechanicalTurk.MTurkConfig($AmtServiceEndpoint, $AccessKeyId, $SecretKey)
  $Global:AmtClient = New-Object Amazon.WebServices.MechanicalTurk.SimpleClient($AmtConfig)
  $Global:AmtQuestionUtil = [Amazon.WebServices.MechanicalTurk.QuestionUtil]

  # Report back
  if($AmtSandbox) {
    Write-Host ""
    Write-Host "Connected to AMT sandbox site"
  } else {
    Write-Host ""
    Write-Host "Connected to AMT production site"
  }

  # Get available balance
  Get-AccountBalance
}

#########################################################################################
function Test-AmtApi {
<# 
 .SYNOPSIS 
  Test if AMT simple client is ready.

 .DESCRIPTION
  Test if AMT simple client is ready. If $AmtClient is not set,
  a connection is established.

 .LINK
  about_AmtApi
#>
  if($AmtClient -eq $null) {
    Connect-Amt -Sandbox
  }
}

#########################################################################################
function Approve-Assignment {
<# 
  .SYNOPSIS 
   Approves results of an assignment.

  .DESCRIPTION
   The ApproveAssignment operation approves the results of a completed assignment.

  .PARAMETER AssignmentId
   The ID of the assignment. This parameter must correspond to a HIT created by the Requester.

  .PARAMETER RequesterFeedback
   A message for the Worker, which the Worker can see in the status section of the web site.
   Constraints: Can be up to 1024 characters.
  
  .EXAMPLE
   Approve-Assignment -AssignmentId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC" -RequesterFeedback "Well done."
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$AssignmentId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$RequesterFeedback
  )

  Test-AmtApi
  return $AmtClient.ApproveAssignment($AssignmentId, $RequesterFeedback)
}

#########################################################################################
function Approve-RejectedAssignment {
<# 
  .SYNOPSIS 
   Approves results of a rejected assignment.

  .DESCRIPTION
   The ApproveRejectedAssignment operation approves an assignment that was previously rejected. 
   ApproveRejectedAssignment works only on rejected assignments that were submitted within the 
   previous 30 days and only if the assignment's related HIT has not been disposed.

  .PARAMETER AssignmentId
   The ID of the assignment. This parameter must correspond to a HIT created by the Requester.

  .PARAMETER RequesterFeedback
   A message for the Worker, which the Worker can see in the status section of the web site.
   Constraints: Can be up to 1024 characters.
  
  .EXAMPLE
   $aid = ""
   Approve-RejectedAssignment -AssignmentId $aid -RequesterFeedback "Sorry, now approved."
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$AssignmentId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$RequesterFeedback
  )

  Test-AmtApi
  return $AmtClient.ApproveRejectedAssignment($AssignmentId, $RequesterFeedback)
}

#########################################################################################
function Grant-Qualification {
<# 
  .SYNOPSIS 
   Approves results of an assignment.

  .DESCRIPTION
   The AssignQualification operation gives a Worker a Qualification. AssignQualification 
   does not require that the Worker submit a Qualification request. 
   It gives the Qualification directly to the Worker.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type to use for the assigned Qualification.

  .PARAMETER WorkerId
   The ID of the Worker to whom the Qualification is being assigned. 
   Worker IDs are included with submitted HIT assignments and Qualification requests.

  .PARAMETER IntegerValue
   The value of the Qualification to assign.

  .PARAMETER SendNotification
   Specifies whether to send a notification email message to the Worker saying that 
   the qualification was assigned to the Worker.

  .EXAMPLE
   Grant-Qualification -QualificationTypeId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC" -WorkerId "ABCEDFG"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$WorkerId,
	[Parameter(Position=2, Mandatory=$false)]
    [int]$IntegerValue=$null,
    [Parameter(Position=3, Mandatory=$false)]
    [bool]$SendNotification=$false
  )

  Test-AmtApi
  return $AmtClient.AssignQualification($QualificationTypeId, $WorkerId, $IntegerValue, $SendNotification)
}

#########################################################################################
function Block-Worker {
<# 
  .SYNOPSIS 
   Block a worker.

  .DESCRIPTION
   The BlockWorker operation allows you to prevent a Worker from working on your HITs. 
   For example, you can block a Worker who is producing poor quality work. 
   You can block up to 100,000 Workers.

  .PARAMETER WorkerId
   The ID of the Worker to block.

  .PARAMETER Reason
   A message explaining the reason for blocking the Worker. This parameter enables 
   you to keep track of your Workers. The Worker does not see this message.
  
  .EXAMPLE
   Block-Worker -WorkerId ABCDEFGHIKLM -Reason "Don't do this again!"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$WorkerId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$Reason
  )

  Test-AmtApi
  return $AmtClient.BlockWorker($WorkerId, $Reason)
}

#########################################################################################
function Set-HitTypeOfHit {
<# 
  .SYNOPSIS 
   Change / set the HitType of a HIT.

  .DESCRIPTION
   The ChangeHITTypeOfHIT operation allows you to change the HITType properties of a HIT. 
   This operation disassociates the HIT from its old HITType properties and associates it 
   with the new HITType properties. The HIT takes on the properties of the new HITType in 
   place of the old ones.

  .PARAMETER HITId
   The ID of the HIT to change.

  .PARAMETER HITTypeId
   The ID of the new HIT type.

  .NOTES
   The name of cmdlet differs from the web operation:
   ChangeHITTypeOfHIT -> Set-HitTypeOfHit
  
  .EXAMPLE
   $hitId = ""
   $hitTypeId = ""
   Set-HITTypeOfHIT -HITId $hitId -HITTypeId $hitTypeId
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$HITTypeId
  )

  Test-AmtApi
  return $AmtClient.ChangeHITTypeOfHIT($HITId, $HITTypeId)
}

#########################################################################################
function Add-Hit {
<# 
  .SYNOPSIS 
   Create a new HIT.

  .DESCRIPTION
   The CreateHIT operation creates a new Human Intelligence Task (HIT). The new HIT is 
   made available for Workers to find and accept on the Amazon Mechanical Turk website.

  .PARAMETER HITTypeId
   The HIT type ID.

  .PARAMETER Title
   The title of the HIT. A title should be short and descriptive about the kind of 
   task the HIT contains. On the Amazon Mechanical Turk web site, the HIT title 
   appears in search results, and everywhere the HIT is mentioned.

  .PARAMETER Description
   A general description of the HIT. A description includes detailed information 
   about the kind of task the HIT contains. On the Amazon Mechanical Turk web site, 
   the HIT description appears in the expanded view of search results, and in the 
   HIT and assignment screens. A good description gives the user enough information 
   to evaluate the HIT before accepting it.

  .PARAMETER Question
   The data the person completing the HIT uses to produce the results.

  .PARAMETER HITLayoutId
   The HITLayoutId allows you to use a pre-existing HIT design 
   with placeholder values and create an additional HIT by providing 
   those values as HITLayoutParameters.

  .PARAMETER HITLayoutParameter
   If the HITLayoutId is provided, any placeholder values must be 
   filled in with values using the HITLayoutParameter structure. 

  .PARAMETER Reward
   The amount of money the Requester will pay a Worker for 
   successfully completing the HIT.

  .PARAMETER AssignmentDurationInSeconds
   The amount of time, in seconds, that a Worker has to complete the 
   HIT after accepting it. If a Worker does not complete the assignment 
   within the specified duration, the assignment is considered abandoned. 
   If the HIT is still active (that is, its lifetime has not elapsed), 
   the assignment becomes available for other users to find and accept.

  .PARAMETER LifetimeInSeconds
   The number of seconds after which the HIT is no longer available 
   for users to accept. After the lifetime of the HIT has elapsed, 
   the HIT no longer appears in HIT searches, even if not all of 
   the HIT's assignments have been accepted.

  .PARAMETER Keywords
   One or more words or phrases that describe the HIT, separated 
   by commas. These words are used in searches to find HITs.

  .PARAMETER MaxAssignments
   The number of times the HIT can be accepted and completed 
   before the HIT becomes unavailable.

  .PARAMETER AutoApprovalDelayInSeconds
   The number of seconds after an assignment for the HIT has been 
   submitted, after which the assignment is considered Approved 
   automatically unless the Requester explicitly rejects it.

  .PARAMETER QualificationRequirement
   A condition that a Worker's Qualifications must meet before 
   the Worker is allowed to accept and complete the HIT.

  .PARAMETER AssignmentReviewPolicy
   The Assignment-level Review Policy applies to the assignments 
   under the HIT. You can specify for Mechanical Turk to take various 
   actions based on the policy. For more information, see Assignment 
   Review Policies.

  .PARAMETER HITReviewPolicy
   The HIT-level Review Policy applies to the HIT. You can specify 
   for Mechanical Turk to take various actions based on the policy. 
   For more information, see HIT Review Policies.

  .PARAMETER RequesterAnnotation
   An arbitrary data field. The RequesterAnnotation parameter lets 
   your application attach arbitrary data to the HIT for tracking purposes. 
   For example, this parameter could be an identifier internal to the 
   Requester's application that corresponds with the HIT.
   Constraints: must not be longer than 255 characters in length.

  .PARAMETER HIT
   A HIT object.
  
  .EXAMPLE
   # ...
   #This is a simple hit asking for the last US president:

   Add-Hit -Title "President" -Description "Find name of president" -Reward 0.55  -Question "Who was the last president of the United States?" -MaxAssignments 5
  
  .EXAMPLE
   # ...
   # For external questions, a HitType needs to be registered first:
   $hitTypeId = Register-HitType -Title $title -Description $desc -AutoApprovalDelayInSeconds 1000 -AssignmentDurationInSeconds 3600 -Reward 0.5 -Keywords "President"

   # Then define the external question:
   $q = $ExternalQuestionTemplate
   $q.ExternalURL = "https://yoursite.com/questionnaire.html?hitType=$hitTypeId
   $q.FrameHeight = 400
   
   # Finally, post the HIT:
   Add-Hit -HITTypeId $hitTypeId -Keywords "keyword1, keyword2" -Question $q  -LifetimeInSeconds 3600 -MaxAssignments 5  -RequesterAnnotation "My External HIT"
   
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$HITTypeId = "",
	[Parameter(Position=1, Mandatory=$false)]
    [string]$Title = "",
	[Parameter(Position=2, Mandatory=$false)]
    [string]$Description = "",
	[Parameter(Position=3, Mandatory=$false)]
    $Question,
	[Parameter(Position=4, Mandatory=$false)]
    [string]$HITLayoutId,
	[Parameter(Position=5, Mandatory=$false)]
    [string]$HITLayoutParameter,
	[Parameter(Position=6, Mandatory=$false)]
    [decimal]$Reward = $null,
	[Parameter(Position=7, Mandatory=$false)]
    [long]$AssignmentDurationInSeconds = $null,
	[Parameter(Position=8, Mandatory=$false)]
    [long]$LifetimeInSeconds,
	[Parameter(Position=9, Mandatory=$false)]
    [string]$Keywords,
	[Parameter(Position=10, Mandatory=$false)]
    [long]$MaxAssignments = $null,
	[Parameter(Position=11, Mandatory=$false)]
    [long]$AutoApprovalDelayInSeconds = $null,
	[Parameter(Position=12, Mandatory=$false)]
    $QualificationRequirement = $null,
	[Parameter(Position=13, Mandatory=$false)]
    [string]$AssignmentReviewPolicy = "",
	[Parameter(Position=14, Mandatory=$false)]
    [string]$HITReviewPolicy = "",
	[Parameter(Position=15, Mandatory=$false)]
    [string]$RequesterAnnotation = "",
    [Parameter(Position=16, Mandatory=$false)]
    [HIT]$HIT
  )

  Test-AmtApi
  if($Hit) {
    return $AmtClient.CreateHIT($Hit)
  }
  if($HITTypeId) {
    [string[]]$ResponseGroup = $null
    return $AmtClient.CreateExternalHIT($HITTypeId, $Title , $Description, $Keywords, $Question, $Reward, $AssignmentDurationInSeconds, $AutoApprovalDelayInSeconds, $LifetimeInSeconds, $MaxAssignments, $RequesterAnnotation, $QualificationRequirement, $null)
  } else {
    return $AmtClient.CreateHIT($Title, $Description, $Reward, $Question, $MaxAssignments)
  }
}

#########################################################################################
function Disable-Hit {
<# 
 .SYNOPSIS 
  Removes a HIT from the Amazon Mechanical Turk marketplace.

 .DESCRIPTION
  The DisableHIT operation removes a HIT from the Amazon Mechanical Turk marketplace, 
  approves any submitted assignments pending approval or rejection, and disposes of 
  the HIT and all assignment data. Assignment results data cannot be retrieved 
  for a HIT that has been disposed.

 .PARAMETER HITId
  The ID of the HIT to retrieve.
  
 .EXAMPLE
  Disable-Hit -HITId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
 .LINK
  about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId
  )

  Test-AmtApi
  return $AmtClient.DisableHIT($HITId)
}

#########################################################################################
function Remove-Hit {
<# 
 .SYNOPSIS 
  Dispose / delete a HIT.

 .DESCRIPTION
  The DisposeHIT operation disposes of a HIT that is no longer needed. 
  Only the Requester who created the HIT can dispose of it.

 .PARAMETER HITId
  The ID of the HIT to retrieve.

  .NOTES
   The name of cmdlet differs from the web operation naming:
   DisposeHIT -> Remove-Hit
  
 .EXAMPLE
  Remove-Hit -HITId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
 .LINK
  about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId
  )

  Test-AmtApi
  return $AmtClient.DisposeHIT($HITId)
}

#########################################################################################
function Add-QualificationTypeFull {
<# 
  .SYNOPSIS 
   Create a new qualification type.

  .DESCRIPTION
   The CreateQualificationType operation creates a new Qualification type, which is 
   represented by a QualificationType data structure.

  .PARAMETER Name
   The name you give to the Qualification type. The type name is used to 
   represent the Qualification to Workers, and to find the type using a 
   Qualification type search.

  .PARAMETER Description
   A long description for the Qualification type. On the Amazon Mechanical 
   Turk website, the long description is displayed when a Worker examines 
   a Qualification type.

  .PARAMETER Keywords
   One or more words or phrases that describe the Qualification type, 
   separated by commas. The keywords of a type make the type easier 
   to find during a search.

  .PARAMETER RetryDelayInSeconds
   The number of seconds that a Worker must wait after requesting a 
   Qualification of the Qualification type before the worker can 
   retry the Qualification request.

  .PARAMETER QualificationTypeStatus
   The initial status of the Qualification type.
   Valid Values: Active | Inactive

  .PARAMETER Test
   The questions for the Qualification test a Worker must answer 
   correctly to obtain a Qualification of this type. If this parameter 
   is specified, TestDurationInSeconds must also be specified.

  .PARAMETER AnswerKey
   The answers to the Qualification test specified in the Test parameter, 
   in the form of an AnswerKey data structure.

  .PARAMETER TestDurationInSeconds
   The number of seconds the Worker has to complete the Qualification test, 
   starting from the time the Worker requests the Qualification.

  .PARAMETER AutoGranted
   Specifies whether requests for the Qualification type are granted 
   immediately, without prompting the Worker with a Qualification test.

  .PARAMETER AutoGrantedValue
   The Qualification value to use for automatically granted Qualifications. 
   This parameter is used only if the AutoGranted parameter is true.
  
  .EXAMPLE
   [...]
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Name,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$Keywords,
	[Parameter(Position=2, Mandatory=$true)]
    [string]$Description,
    [Parameter(Position=3, Mandatory=$true)]
    [ValidateSet('Active','Inactive')]
    [string]$QualificationTypeStatus,
	[Parameter(Position=4, Mandatory=$false)]
    [long]$RetryDelayInSeconds,
	[Parameter(Position=5, Mandatory=$false)]
    $Test,
	[Parameter(Position=6, Mandatory=$false)]
    [string]$AnswerKey,
	[Parameter(Position=7, Mandatory=$false)]
    [long]$TestDurationInSeconds,
	[Parameter(Position=8, Mandatory=$false)]
    [bool]$AutoGranted,
	[Parameter(Position=9, Mandatory=$false)]
    [int]$AutoGrantedValue = 1
  )

  Test-AmtApi
  return $AmtClient.CreateQualificationType($Name, $Keywords, $Description, $QualificationTypeStatus, $RetryDelayInSeconds, $Test, $AnswerKey, $TestDurationInSeconds, $AutoGranted, $null)
}

#########################################################################################
function Add-QualificationType {
<# 
  .SYNOPSIS 
   Create a new qualification type.

  .DESCRIPTION
   The CreateQualificationType operation creates a new Qualification type, which is 
   represented by a QualificationType data structure.

  .PARAMETER Name
   The name you give to the Qualification type. The type name is used to 
   represent the Qualification to Workers, and to find the type using a 
   Qualification type search.

  .PARAMETER Description
   A long description for the Qualification type. On the Amazon Mechanical 
   Turk website, the long description is displayed when a Worker examines 
   a Qualification type.

  .PARAMETER Keywords
   One or more words or phrases that describe the Qualification type, 
   separated by commas. The keywords of a type make the type easier 
   to find during a search.
  
  .EXAMPLE
   Add-QualificationType "Test Qual" "Test Qualification" "Keyword 123"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Name,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$Description,
	[Parameter(Position=2, Mandatory=$false)]
    [string]$Keywords = ""
  )

  Test-AmtApi
  return $AmtClient.CreateQualificationType($Name, $Keywords, $Description)
}

#########################################################################################
function Remove-QualificationType {
<# 
  .SYNOPSIS 
   Dispose / delete a HIT.

  .DESCRIPTION
   The DisposeQualificationType operation disposes a Qualification type and disposes 
   any HIT types that are associated with the Qualification type. A Qualification type 
   is represented by a QualificationType data structure.

  .PARAMETER QualificationTypeId
   The ID of the QualificationType to dispose.

  .NOTES
   The name of cmdlet differs from the web operation:
   DisposeQualificationType -> Remove-QualificationType
  
  .EXAMPLE
   Remove-QualificationType -QualificationTypeId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId
  )

  Test-AmtApi
  return $AmtClient.DisposeQualificationType($QualificationTypeId)
}

#########################################################################################
function Expand-Hit {
<# 
  .SYNOPSIS 
   Extend / expand a HIT.

  .DESCRIPTION
   The ExtendHIT operation increases the maximum number of assignments, or 
   extends the expiration date, of an existing HIT.

  .PARAMETER HITId
   The ID of the HIT to extend.

  .PARAMETER MaxAssignmentsIncrement
   The number of assignments by which to increment the MaxAssignments parameter of the HIT.

  .PARAMETER ExpirationIncrementInSeconds
   The amount of time, in seconds, by which to extend the expiration date. 
   If the HIT has not yet expired, this amount is added to the HIT's expiration date. 
   If the HIT has expired, the new expiration date is the current time plus this value.

  .NOTES
   The name of cmdlet differs from the web operation:
   ExtendHIT -> Expand-Hit
  
  .EXAMPLE
   $hitId = "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
   Expand-Hit -HITId $hitId -M 20 -E 1000
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId,
	[Parameter(Position=1, Mandatory=$false)]
    [int]$MaxAssignmentsIncrement=$null,
	[Parameter(Position=2, Mandatory=$false)]
    [long]$ExpirationIncrementInSeconds=$null
  )

  Test-AmtApi
  return $AmtClient.ExtendHIT($HITId, $MaxAssignmentsIncrement, $ExpirationIncrementInSeconds)
}

#########################################################################################
function Stop-Hit {
<# 
  .SYNOPSIS 
   Stop / force expire a HIT.

  .DESCRIPTION
   The ForceExpireHIT operation causes a HIT to expire immediately, as if the 
   LifetimeInSeconds parameter of the HIT had elapsed.

  .PARAMETER HITId
   The ID of the HIT to retrieve.

  .NOTES
   The name of cmdlet differs from the web operation:
   ForceExpireHIT -> Stop-Hit
  
  .EXAMPLE
   Stop-Hit -HITId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId
  )

  Test-AmtApi
  return $AmtClient.ForceExpireHIT($HITId)
}

#########################################################################################
function Get-AccountBalance {
<# 
 .SYNOPSIS 
  Get the current account balance.

 .DESCRIPTION
  The GetAccountBalance operation retrieves the amount of 
  money in your Amazon Mechanical Turk account.

 .EXAMPLE
  Get-AccountBalance

 .LINK
  about_AmtApi
#>
  Test-AmtApi
  return $AmtClient.GetAccountBalance().AvailableBalance.FormattedPrice
}

#########################################################################################
function Get-Assignment {
<# 
  .SYNOPSIS 
   Retrieves the details of an assignment.

  .DESCRIPTION
   The GetAssignment operation retrieves an assignment with an 
   AssignmentStatus value of Submitted, Approved, or Rejected, 
   using the assignment's ID. Requesters can only retrieve 
   their own assignments for HITs that they have not disposed of.
   
  .PARAMETER AssignmentId
   The ID of the assignment that is being requested.
  
  .EXAMPLE
   Get-Assignment -AssignmentId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$AssignmentId
  )

  [string[]]$ResponseGroup = $null

  Test-AmtApi
  return $AmtClient.GetAssignment($AssignmentId, $ResponseGroup)
}

#########################################################################################
function Get-AssignmentsForHit {
<# 
  .SYNOPSIS 
   Retrieves the details of assignments of the specified HIT.

  .DESCRIPTION
   The GetAssignmentsForHIT operation retrieves completed 
   assignments for a HIT. You can use this operation to 
   retrieve the results for a HIT.

  .PARAMETER HITId
   The ID of the HIT for which completed assignments are requested.

  .PARAMETER AssignmentStatus
   The status of the assignments to return.
   Valid Values: Submitted | Approved | Rejected

  .PARAMETER SortProperty
   The field on which to sort the results returned by the operation.
   Valid Values: AcceptTime | SubmitTime | AssignmentStatus

  .PARAMETER SortDirection
   The direction of the sort used with the field specified by the 
   SortProperty parameter.
   Valid Values: Ascending | Descending

  .PARAMETER PageSize
   The number of assignments to include in a page of results. 
   The complete sorted result set is divided into pages of this 
   many assignments.
   Valid Values: any integer between 1 and 100

  .PARAMETER PageNumber
   The page of results to return. Once the assignments have been 
   filtered, sorted, and divided into pages of size PageSize, 
   the page corresponding to PageNumber is returned as the results 
   of the operation.
   Type: positive integer
  
  .EXAMPLE
   Get-AssignmentsForHit -HITId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId,
	[Parameter(Position=1, Mandatory=$true)]
    $SortDirection=$null,
	[Parameter(Position=2, Mandatory=$true)]
    [string]$AssignmentStatus,
	[Parameter(Position=3, Mandatory=$true)]
    $SortProperty=$null,
	[Parameter(Position=4, Mandatory=$true)]
    [string]$PageNumber=$null,
	[Parameter(Position=5, Mandatory=$true)]
    [string]$PageSize=$null
  )

  Throw "Not Implemented"
  # TODO:
  # Implement AssignmentStatus
  # Implement ResponseGroup

  Test-AmtApi
  return $AmtClient.GetAssignmentsForHIT($HITId, $SortDirection, $AssignmentStatus, $SortProperty, $PageNumber, $PageSize, $null)
}

#########################################################################################
function Get-AllAssignmentsForHit {
<# 
  .SYNOPSIS 
   Retrieves the details of assignments of the specified HIT.

  .DESCRIPTION
   The GetAssignmentsForHIT operation retrieves completed assignments 
   for a HIT. You can use this operation to retrieve the results for 
   a HIT.

  .PARAMETER HITId
   The ID of the HIT for which completed assignments are requested.
  
  .EXAMPLE
   Get-AllAssignmentsForHit -HITId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId
  )

  Test-AmtApi
  return $AmtClient.GetAllAssignmentsForHIT($HITId)
}

#########################################################################################
function Get-BlockedWorkers {
<# 
  .SYNOPSIS 
   Retrieves list of blocked workers.

  .DESCRIPTION
   The GetBlockedWorkers operation retrieves a list of  
   Workers who are blocked from working on your HITs.
  
  .EXAMPLE
   Get-BlockedWorkers
  
  .LINK
   about_AmtApi
#>
  Test-AmtApi
  return $AmtClient.GetAllBlockedWorkersIterator()
}

#########################################################################################
function Get-BonusPayments {
<# 
  .SYNOPSIS 
   Retrieves the details of bonus payments.

  .DESCRIPTION
   The GetBonusPayments operation retrieves the amounts of bonuses you
   have paid to Workers for a given HIT or assignment.

  .PARAMETER HITId
   The ID of the HIT associated with the bonus payments to retrieve. If 
   not specified, all bonus payments for all assignments for the given 
   HIT are returned.

  .PARAMETER AssignmentId
   The ID of the assignment associated with the bonus payments to retrieve. 
   If specified, only bonus payments for the given assignment are returned.

  .PARAMETER PageSize
   The number of bonus payments to include in a page of results. 
   The complete result set is divided into pages of this many bonus payments.

  .PARAMETER PageNumber
   The page of results to return. Once the list of bonus payments has been 
   divided into pages of size PageSize, the page corresponding to PageNumber 
   is returned as the results of the operation.
  
  .EXAMPLE
   Get-BonusPayments -HITId "HID"

  .EXAMPLE
   Get-BonusPayments -AssignmentId "AID"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$HITId,
	[Parameter(Position=1, Mandatory=$false)]
    [string]$AssignmentId,
	[Parameter(Position=2, Mandatory=$false)]
    [int]$PageSize=$null,
	[Parameter(Position=3, Mandatory=$false)]
    [int]$PageNumber=$null
  )

  Test-AmtApi
  return $AmtClient.GetBonusPayments($HITId, $AssignmentId, $PageSize, $PageNumber)
}

#########################################################################################
function Get-FileUploadUrl {
<# 
  .SYNOPSIS 
   Returns a temporary URL to upload a file.

  .DESCRIPTION
   The GetFileUploadURL operation generates and returns a temporary URL. 
   You use the temporary URL to retrieve a file uploaded by a Worker 
   as an answer to a FileUploadAnswer question for a HIT.

  .PARAMETER AssignmentId
   The ID of the assignment that contains the question with a FileUploadAnswer.

  .PARAMETER QuestionIdentifier
   The identifier of the question with a FileUploadAnswer, as specified in 
   the QuestionForm of the HIT.

  .EXAMPLE
   $aid = ""
   $qi = ""
   Get-FileUploadUrl -AssignmentId $aid -QuestionIdentifier $qi
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$AssignmentId,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$QuestionIdentifier
  )

  Test-AmtApi
  return $AmtClient.GetFileUploadURL($AssignmentId, $QuestionIdentifier)
}

#########################################################################################
function Get-Hit {
<# 
  .SYNOPSIS 
   Retrieves the details of the specified HIT.

  .DESCRIPTION
   Retrieves the details of the specified HIT.

  .PARAMETER HITId
   The ID of the HIT to retrieve.
  
  .EXAMPLE
   Get-Hit -HITId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId
  )

  Test-AmtApi
  return $AmtClient.GetHIT($HITId, $null)
}

#########################################################################################
function Get-AllHits {
<# 
  .SYNOPSIS 
   Retrieves all active HITs in the system.

  .DESCRIPTION
   Retrieves all active HITs in the system.
  
  .EXAMPLE
   Get-AllHits
  
  .LINK
   about_AmtApi
#>
  Test-AmtApi
  return $AmtClient.GetAllHITs()
}

#########################################################################################
function Get-HitsForQualificationType {
<# 
  .SYNOPSIS 
   Retrieves the details of the specified HIT.

  .DESCRIPTION
   The GetHITsForQualificationType operation returns the HITs that
   use the given Qualification type for a Qualification requirement.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type to use when querying HITs, as returned 
   by the CreateQualificationType operation. The operation returns HITs that 
   require that a Worker have a Qualification of this type.

  .PARAMETER PageSize
   The number of HITs to include in a page of results. The complete results set 
   is divided into pages of this many HITs.

  .PARAMETER PageNumber
   The page of results to return. After the HITs are divided into pages of size 
   PageSize, the operation returns the page corresponding to the PageNumber.
  
  .EXAMPLE
   $qid = ""
   Get-HitsForQualificationType -QualificationTypeId $qid
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$PageSize=10,
	[Parameter(Position=2, Mandatory=$true)]
    [string]$PageNumber=1
  )

  Throw "Not implemented"

  Test-AmtApi
  return $AmtClient.GetHITsForQualificationType($QualificationTypeId, $PageSize, $PageNumber)
}

#########################################################################################
function Get-QualificationsForQualificationType {
<# 
  .SYNOPSIS 
   Retrieves the details of the specified HIT.

  .DESCRIPTION
   The GetQualificationsForQualificationType operation returns all of the 
   Qualifications granted to Workers for a given Qualification type.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type of the Qualifications to return.

  .PARAMETER Status
   The status of the Qualifications to return.
   Valid Values: Granted | Revoked

  .PARAMETER PageSize
   The number of Qualifications to include in a page of results. 
   The operation divides the complete result set into pages of this many Qualifications.

  .PARAMETER PageNumber
   The page of results to return. Once the operation divides the Qualifications into 
   pages of size PageSize, it returns the page corresponding to PageNumber.
  
  .EXAMPLE
   $qid = ""
   Get-QualificationsForQualificationType -QualificationTypeId $qid
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId,
	[Parameter(Position=0, Mandatory=$false)]
    [string]$Status="Granted",
	[Parameter(Position=0, Mandatory=$false)]
    [string]$PageSize=10,
	[Parameter(Position=0, Mandatory=$false)]
    [string]$PageNumber=1
  )

  Throw "Not Implemented"
  # TODO:
  # Implement Enum QualificationStatus

  Test-AmtApi
  return $AmtClient.GetQualificationsForQualificationType($QualificationTypeId, $Status, $PageSize, $PageNumber)
}

#########################################################################################
function Get-QualificationRequests {
<# 
  .SYNOPSIS 
   Retrieves requests for qualifications.

  .DESCRIPTION
   The GetQualificationRequests operation retrieves requests for Qualifications of 
   a particular Qualification type. The owner of the Qualification type calls this 
   operation to poll for pending requests, and grants Qualifications based on the 
   requests using the GrantQualification operation.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type, as returned by the CreateQualificationType 
   operation.

  .PARAMETER SortProperty
   The field on which to sort the returned results.
   Valid Values: QualificationTypeId | SubmitTime
   
  .PARAMETER SortDirection
   The direction of the sort.
   Valid Values: Ascending | Descending
   
  .PARAMETER PageSize
   The number of Qualification requests to include in a page of results. 
   The operation divides the complete sorted result set into pages of this 
   many Qualification requests.

  .PARAMETER PageNumber
   The page of results to return. When the operation has filtered the Qualification 
   requests, sorted them, and divided them into pages of size PageSize, the operation 
   returns the page corresponding to the PageNumber parameter.
     
  .EXAMPLE
   Get-QualificationRequests -QualificationTypeId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId
	#[Parameter(Position=0, Mandatory=$true)]
	#[string]$SortProperty="SubmitTime",
	#[Parameter(Position=0, Mandatory=$true)]
	#[string]$SortDirection="Ascending",
	#[Parameter(Position=0, Mandatory=$true)]
	#[string]$PageSize=10,
	#[Parameter(Position=0, Mandatory=$true)]
	#[string]$PageNumber=1
  )

  Test-AmtApi
  return $AmtClient.GetQualificationRequests($QualificationTypeId, $null, $null, $null, $null)
}

#########################################################################################
function Get-QualificationScore {
<# 
  .SYNOPSIS 
   Returns a qualification score

  .DESCRIPTION
   The GetQualificationScore operation returns the value of a Worker's Qualification 
   for a given Qualification type.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type, as returned by the CreateQualificationType operation.

  .PARAMETER WorkerId
   The ID of the Worker whose Qualification is being returned.
  
  .EXAMPLE
   $qid = ""
   $wid = ""
   Get-QualificationScore -QualificationTypeId $qid -WorkerId $wid
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$WorkerId
  )

  Test-AmtApi
  return $AmtClient.GetQualificationScore($QualificationTypeId, $WorkerId)
}

#########################################################################################
function Get-QualificationType {
<# 
  .SYNOPSIS 
   Retrieves the details of a qualification type.

  .DESCRIPTION
   The GetQualificationType operation retrieves information about a Qualification type using its ID.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type, as returned by the CreateQualificationType operation.
  
  .EXAMPLE
   $qid = ""
   Get-QualificationType -QualificationTypeId $qid
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId
  )

  Test-AmtApi
  return $AmtClient.GetQualificationType($QualificationTypeId)
}

#########################################################################################
function Get-AllQualificationTypes {
<# 
  .SYNOPSIS 
   Retrieves the details of all qualification types.

  .DESCRIPTION
   Retrieves the details of all qualification types.
  
  .EXAMPLE
   Get-AllQualificationTypes
  
  .LINK
   about_AmtApi
#>
  Test-AmtApi
  return $AmtClient.GetAllQualificationTypes()
}

#########################################################################################
function Get-ReviewableHits {
<# 
  .SYNOPSIS 
   Retrieves requests for qualifications.

  .DESCRIPTION
   The GetReviewableHITs operation retrieves the HITs with Status equal to Reviewable 
   or Status equal to Reviewing that belong to the Requester calling the operation.

  .PARAMETER HITTypeId
   The ID of the HIT type of the HITs to consider for the query.

  .PARAMETER Status
   The status of the HITs to return.
   Valid Values: Reviewable | Reviewing

  .PARAMETER SortProperty
   The field on which to sort the results.
   Valid Values: Title | Reward | Expiration | CreationTime | Enumeration
   
  .PARAMETER SortDirection
   The direction of the sort used with the field specified by the SortProperty property.
   Valid Values: Ascending | Descending
   
  .PARAMETER PageSize
   The number of HITs to include in a page of results. The operation divides the 
   complete sorted result set is divided into pages of this many HITs.

  .PARAMETER PageNumber
   The page of results to return. After the operation filters, sorts, and 
   divides the HITs into pages of size PageSize, it returns the page 
   corresponding to PageNumber as the results of the operation.
     
  .EXAMPLE
   Get-ReviewableHits -HITTypeId "3BBXDSS898KC7DKCH20Y2HIK6UVXLC"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$HITTypeId,
	[Parameter(Position=0, Mandatory=$false)]
    [string]$Status="Reviewable",
	[Parameter(Position=0, Mandatory=$false)]
    [string]$SortProperty="Expiration",
	[Parameter(Position=0, Mandatory=$false)]
    [string]$SortDirection="Descending",
	[Parameter(Position=0, Mandatory=$false)]
    [string]$PageSize=10,
	[Parameter(Position=0, Mandatory=$false)]
    [string]$PageNumber=1
  )

  Throw "Not Implemented"
  # TODO: 
  # Implement Enum ReviewableHitStatus

  Test-AmtApi
  #return $AmtClient.GetReviewableHITs($HITTypeId, $Status, $SortProperty, $SortDirection, $PageSize, $PageNumber)
  return $AmtClient.GetReviewableHITs($HITTypeId, $null, $null, $null, $null, $null)
}

#########################################################################################
function Get-ReviewResultsForHIT {
<# 
  .SYNOPSIS 
   Returns a qualification score

  .DESCRIPTION
   The GetReviewResultsForHIT operation retrieves the computed results and the actions 
   taken in the course of executing your Review Policies during a CreateHIT operation. 
   For information about how to apply Review Policies when you call CreateHIT, 
   see Review Policies. The GetReviewResultsForHIT operation can return results for 
   both Assignment-level and HIT-level review results. You can also specify to only 
   return results pertaining to a particular Assignment.

  .PARAMETER HITId
   The unique identifier of the HIT to retrieve review results for.

  .PARAMETER PolicyLevel
   The Policy Level(s) to retrieve review results for.
  
  .PARAMETER AssignmentId
   If supplied, the results are limited to those pertaining directly to this Assignment ID.

  .PARAMETER RetrieveActions
   Retrieves a list of the actions taken executing the Review Policies and their outcomes.
   Constraints: T or F

  .PARAMETER RetrieveResults
   Retrieves a list of the results computed by the Review Policies.
   Constraints: T or F

  .EXAMPLE
   $qid = ""
   $wid = ""
   Get-QualificationScore -QualificationTypeId $qid -WorkerId $wid
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITId,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$PolicyLevel,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$AssignmentId,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$RetrieveActions,
	[Parameter(Position=1, Mandatory=$true)]
    [string]$RetrieveResults
  )

  Throw "Not Implemented"
  # TODO:
  # PolicyLevels not implemented in API

  Test-AmtApi
  return $AmtClient.GetReviewResultsForHIT($HITId, $PolicyLevel, $AssignmentId, $RetrieveActions, $RetrieveResults)
}

#########################################################################################
function Grant-Bonus {
<# 
  .SYNOPSIS 
   Grant a bonus.

  .DESCRIPTION
   The GrantBonus operation issues a payment of money from your account to a Worker. 
   This payment happens separately from the reward you pay to the Worker when you 
   approve the Worker's assignment. The GrantBonus operation requires the Worker's 
   ID and the assignment ID as parameters to initiate payment of the bonus.

  .PARAMETER WorkerId
   The ID of the Worker being paid the bonus, as returned in the assignment 
   data of the GetAssignmentsForHIT operation.

  .PARAMETER BonusAmount
   The bonus amount to pay.

  .PARAMETER AssignmentId
   The ID of the assignment for which this bonus is paid, as returned 
   in the assignment data of the GetAssignmentsForHIT operation.

  .PARAMETER Reason
   A message that explains the reason for the bonus payment. 
   The Worker receiving the bonus can see this message.
  
  .EXAMPLE
   Grant-Bonus -WorkerId "ABCDEFG" -AssignmentId "ABCDEFG" -BonusAmount 1.25 
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$WorkerId,
    [Parameter(Position=1, Mandatory=$true)]
    [decimal]$BonusAmount,
    [Parameter(Position=2, Mandatory=$true)]
    [string]$AssignmentId,
	[Parameter(Position=3, Mandatory=$true)]
    [string]$Reason
  )

  Test-AmtApi
  return $AmtClient.GrantBonus($WorkerId, $BonusAmount, $AssignmentId, $Reason)
}

#########################################################################################
function Grant-QualificationRequest {
<# 
  .SYNOPSIS 
   Grant a qualification.

  .DESCRIPTION
   The GrantQualification operation grants a Worker's request for a Qualification. 
   Only the owner of the Qualification type can grant a Qualification request for that type.

  .PARAMETER QualificationRequestId
   The ID of the Qualification request, as returned by the GetQualificationRequests operation.

  .PARAMETER IntegerValue
   The value of the Qualification.

  .NOTES
   The name of cmdlet differs from the web operation:
   GrantQualification -> Grant-QualificationRequest
  
  .EXAMPLE
   Grant-QualificationRequest -QualificationRequestId "ABCDEFG" [-IntegerValue 1]
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationRequestId,
    [Parameter(Position=1, Mandatory=$false)]
    [int]$IntegerValue=1
  )

  Test-AmtApi
  return $AmtClient.GrantQualification($QualificationRequestId, $IntegerValue)
}

#########################################################################################
function Send-WorkerNotification {
<# 
  .SYNOPSIS 
   Unblock a worker.

  .DESCRIPTION
   The NotifyWorkers operation sends an email to one or more Workers that you specify
   with the Worker ID. You can specify up to 100 Worker IDs to send the same message 
   with a single call to the NotifyWorkers operation.

  .PARAMETER Subject
   The subject line of the email message to send.

  .PARAMETER MessageText
   The text of the email message to send
  
  .PARAMETER WorkerIds
   The ID of the Worker to notify, as returned by the GetAssignmentsForHIT operation.

  .EXAMPLE
   Send-Notification -Subject "Alert" -MessageText "A new hit is online" -WorkerId "ABCDEFG"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Subject,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$MessageText,
	[Parameter(Position=1, Mandatory=$false)]
    [string[]]$WorkerIds
  )

  Test-AmtApi
  return $AmtClient.NotifyWorkers($Subject, $MessageText, $WorkerIds)
}

#########################################################################################
function Register-HitType {
<# 
  .SYNOPSIS 
   Register a HitType

  .DESCRIPTION
   The RegisterHITType operation creates a new HIT type. The RegisterHITType operation
   lets you be explicit about which HITs ought to be the same type. It also gives you 
   error checking, to ensure that you call the CreateHIT operation with a valid HIT 
   type ID. If you register a HIT type with values that match an existing HIT type, 
   the HIT type ID of the existing type will be returned.

  .PARAMETER Title
   The title for HITs of this type.

  .PARAMETER Description
   A general description of HITs of this type.
  
  .PARAMETER Reward
   The amount of money the Requester will pay a user for successfully 
   completing a HIT of this type.

  .PARAMETER AssignmentDurationInSeconds
   The amount of time a Worker has to complete a HIT of this type after accepting it.

  .PARAMETER Keywords
   One or more words or phrases that describe a HIT of this type, separated by commas. 
   Searches for words similar to the keywords are more likely to return the HIT in 
   the search results.

  .PARAMETER AutoApprovalDelayInSeconds
   An amount of time, in seconds, after an assignment for a HIT of this type 
   has been submitted, that the assignment becomes Approved automatically, 
   unless the Requester explicitly rejects it.

  .PARAMETER QualificationRequirement
   A condition that a Worker's Qualifications must meet before the Worker is 
   allowed to accept and complete a HIT of this type.

  .EXAMPLE
   [...]
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Title,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$Description,
	[Parameter(Position=2, Mandatory=$false)]
    [string]$AutoApprovalDelayInSeconds=2592000,
	[Parameter(Position=3, Mandatory=$false)]
    [long]$AssignmentDurationInSeconds,
	[Parameter(Position=4, Mandatory=$false)]
    [decimal]$Reward,
	[Parameter(Position=5, Mandatory=$false)]
    [string]$Keywords,
	[Parameter(Position=6, Mandatory=$false)]
    $QualificationRequirement = $null
  )

  Test-AmtApi
  return $AmtClient.RegisterHITType($Title, $Description, $AutoApprovalDelayInSeconds, $AssignmentDurationInSeconds, $Reward, $Keywords, $QualificationRequirement)
}

#########################################################################################
function Deny-Assignment {
<# 
  .SYNOPSIS 
   Reject an assignment.

  .DESCRIPTION
   The RejectAssignment operation rejects the results of a completed assignment. 
   You can include an optional feedback message with the rejection, which the Worker 
   can see in the Status section of the web site. When you include a feedback message 
   with the rejection, it helps the Worker understand why the assignment was rejected, 
   and can improve the quality of the results the Worker submits in the future.

  .PARAMETER AssignmentId
   The assignment ID.

  .PARAMETER RequesterFeedback
   A message for the Worker, which the Worker can see in the Status section of the web site.
   Constraints: can be up to 1024 characters, including multi-byte characters.
  
  .EXAMPLE
   Deny-Assignment -AssignmentId "ABCDEFGHIKLM" -RequesterFeedback "Bad work!"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$AssignmentId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$RequesterFeedback
  )

  Test-AmtApi
  return $AmtClient.RejectAssignment($AssignmentId, $RequesterFeedback)
}

#########################################################################################
function Deny-QualificationRequest  {
<# 
  .SYNOPSIS 
   Reject a aualification request.

  .DESCRIPTION
   The RejectQualificationRequest operation rejects a user's request for a Qualification.
   You can provide a text message explaining why the request was rejected. 
   The Worker who made the request can see this message.

  .PARAMETER QualificationRequestId
   The ID of the Qualification request to reject, as returned from a call to the 
   GetQualificationRequest operation.

  .PARAMETER Reason
   A text message explaining why the request was rejected, to be shown to the Worker 
   who made the request.
  
  .EXAMPLE
   Deny-QualificationRequest -QualificationRequestId "ABCDEFGHIKLM" -Reason "Sorry!"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationRequestId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$Reason
  )

  Test-AmtApi
  return $AmtClient.RejectQualificationRequest($QualificationRequestId, $Reason)
}

#########################################################################################
function Revoke-Qualification {
<# 
  .SYNOPSIS 
   Revokes a qualification.

  .DESCRIPTION
   The RevokeQualification operation revokes a previously granted Qualification 
   from a user. You can provide a text message explaining why the Qualification 
   was revoked. The user who had the Qualification can see this message.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type of the Qualification to be revoked.

  .PARAMETER WorkerId
   The ID of the Worker who possesses the Qualification to be revoked.

  .PARAMETER Reason
   A text message that explains why the Qualification was revoked. 
   The user who had the Qualification sees this message.
  
  .EXAMPLE
   $qid= ""
   $wid = ""
   Revoke-Qualification -QualificationTypeId $qid  -WorkerId $wid -Reason "Sorry!"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$WorkerId,
    [Parameter(Position=2, Mandatory=$false)]
    [string]$Reason
  )

  Test-AmtApi
  return $AmtClient.RevokeQualification($QualificationTypeId, $WorkerId, $Reason)
}

#########################################################################################
function Unblock-Worker {
<# 
  .SYNOPSIS 
   Unblock a worker.

  .DESCRIPTION
   The UnblockWorker operation allows you to reinstate a blocked Worker to work on your HITs. 
   This operation reverses the effects of the BlockWorker operation

  .PARAMETER WorkerId
   The ID of the Worker to block.

  .PARAMETER Reason
   A message that explains the reason for unblocking the Worker. 
   The Worker does not see this message.
  
  .EXAMPLE
   Unblock-Worker -WorkerId ABCDEFGHIKLM -Reason "Be nice!"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$WorkerId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$Reason
  )

  Test-AmtApi
  return $AmtClient.UnblockWorker($WorkerId, $Reason)
}

#########################################################################################
function Update-QualificationScore {
<# 
  .SYNOPSIS 
   Updates a qualification score of a worker.

  .DESCRIPTION
   The UpdateQualificationScore operation changes the value of a Qualification 
   previously granted to a Worker. Only the owner of a Qualification type can 
   update the score of a Qualification of that type. The Worker must have already
   been granted a Qualification of the given Qualification type before the score 
   can be updated.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type, as returned by CreateQualificationType operation.

  .PARAMETER WorkerId
   The ID of the Worker whose Qualification is being updated, 
   as returned by the GetAssignmentsForHIT operation.

  .PARAMETER IntegerValue
   The new value for the Qualification.

  .EXAMPLE
   $qid = ""
   $wid = ""
   Update-QualificationScore -QualificationTypeId $qid -WorkerId $wid -Reason -IntegerValue 5
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$QualificationTypeId,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$WorkerId,
    [Parameter(Position=2, Mandatory=$true)]
    [int]$IntegerValue=$null
  )

  Test-AmtApi
  return $AmtClient.UpdateQualificationScore($QualificationTypeId, $WorkerId, $IntegerValue)
}

#########################################################################################
function Update-QualificationType {
<# 
  .SYNOPSIS 
   Updates a qualification type.

  .DESCRIPTION
   The UpdateQualificationType operation modifies the attributes of an existing 
   Qualification type, which is represented by a QualificationType data structure. 
   Only the owner of a Qualification type can modify its attributes.
   Most attributes of a Qualification type can be changed after the type has been 
   created. However, the Name and Keywords fields cannot be modified. The 
   RetryDelayInSeconds parameter can be modified or added to change the delay
   or to enable retries, but RetryDelayInSeconds cannot be used to disable retries.

  .PARAMETER QualificationTypeId
   The ID of the Qualification type to update.

  .PARAMETER RetryDelayInSeconds
   The amount of time, in seconds, that Workers must wait after requesting a 
   Qualification of the specified Qualification type before they can retry 
   the Qualification request.

  .PARAMETER QualificationTypeStatus
   The new status of the Qualification type.
   Valid Values: Active | Inactive

  .PARAMETER Description
   The new description of the Qualification type.

  .PARAMETER Test
   The questions for a Qualification test a Worker must answer correctly 
   to obtain a Qualification of this type.

  .PARAMETER AnswerKey
   The answers to the Qualification test specified in the Test parameter.

  .PARAMETER TestDurationInSeconds
   The amount of time, in seconds, that a Worker has to complete the 
   Qualification test, starting from when the Worker requested the Qualification.

  .PARAMETER AutoGranted
   Specifies whether requests for the Qualification type will be granted 
   immediately, without prompting the Worker with a Qualification test.
   Valid Values: true | false

  .PARAMETER AutoGrantedValue
   The Qualification value to use if AutoGranted is true.
  
  .EXAMPLE
   $qid = ""
   Update-QualificationType -$QualificationTypeId $qid -Title "The new title"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$QualificationTypeId,
	[Parameter(Position=1, Mandatory=$false)]
    [string]$Description,
	[Parameter(Position=2, Mandatory=$false)]
    [ValidateSet('Active','Inactive')]
    [string]$QualificationTypeStatus,
	[Parameter(Position=3, Mandatory=$false)]
    [string]$Test,
	[Parameter(Position=4, Mandatory=$false)]
    [string]$AnswerKey="",
	[Parameter(Position=5, Mandatory=$false)]
    [long]$TestDurationInSeconds,
	[Parameter(Position=6, Mandatory=$false)]
    [long]$RetryDelayInSeconds,
	[Parameter(Position=7, Mandatory=$false)]
    [bool]$AutoGranted=$false,
	[Parameter(Position=8, Mandatory=$false)]
    [int]$AutoGrantedValue,
    [Parameter(Position=9, Mandatory=$false)]
    [QualificationType]$OldQualificationType
  )

  if($OldQualificationType) {
    $qt = $OldQualificationType
  } else {
    $qt = New-Object QualificationType
  }

  if($QualificationTypeId) { $qt.QualificationTypeId = $QualificationTypeId }
  if($Description) { $qt.Description = $Description }
  if($QualificationTypeStatus) { 
    $qt.QualificationTypeStatus = $QualificationTypeStatus 
    $qt.QualificationTypeStatusSpecified = $true
  }
  if($Test) { $qt.Test = $Test}
  if($AnswerKey) { $qt.AnswerKey = $AnswerKey }
  if($TestDurationInSeconds) {$qt.TestDurationInSeconds = $TestDurationInSeconds }
  if($RetryDelayInSeconds) { 
    $qt.RetryDelayInSeconds = $RetryDelayInSeconds 
    $qt.RetryDelayInSecondsSpecified = $true
  }
  if($AutoGranted) { 
    $qt.AutoGranted = $true 
    $qt.AutoGrantedSpecified = $true
  }
  if($AutoGrantedValue) {
    if($AutoGrantedValue -eq 0) {
      $qt.AutoGrantedValue = 1 
      $qt.AutoGrantedValueSpecified = $false
    } else {
      $qt.AutoGrantedValue = $AutoGrantedValue
      $qt.AutoGrantedValueSpecified = $true
    }
  } else {
   if($qt.AutoGrantedValue -eq 0) {
      $qt.AutoGrantedValue = 1
      $qt.AutoGrantedValueSpecified = $false
    }
  }

  Test-AmtApi
  if($Test) {
    return $AmtClient.UpdateQualificationTypeFull($qt.QualificationTypeId, $qt.Description, $qt.QualificationTypeStatus, $qt.Test, $qt.AnswerKey, $qt.TestDurationInSeconds, $qt.RetryDelayInSeconds, $null, $null) 
  } else {
    return $AmtClient.UpdateQualificationType($qt.QualificationTypeId, $qt.Description, $qt.QualificationTypeStatus)
  }
}

#########################################################################################
function Search-QualificationTypes {
<# 
  .SYNOPSIS 
   Search qualification types.

  .DESCRIPTION
   The SearchQualificationTypes operation searches for Qualification types using 
   the specified search query, and returns a list of Qualification types.
   The operation sorts the results, divides them into numbered pages, and 
   returns a single page of results. You can control sorting and pagination 
   with parameters to the operation.

  .PARAMETER Query
   A text query against all of the searchable attributes of Qualification types.

  .PARAMETER MustBeRequestable
   Specifies that only Qualification types that a user can request through 
   the Amazon Mechanical Turk web site, such as by taking a Qualification test, 
   are returned as results of the search. Some Qualification types, such as those 
   assigned automatically by the system, cannot be requested directly by users. 
   If false, all Qualification types, including those managed by the system, 
   are considered for the search.

  .PARAMETER MustBeOwnedByCaller
   Specifies that only Qualification types that the Requester created are returned. 
   If false, the operation returns all Qualification types.

  .PARAMETER PageSize
   The number of Qualification types to include in a page of results. 
   The operation divides the complete sorted result set into pages 
   of this many Qualification types.

  .PARAMETER PageNumber
   The page of results to return. After the operation filters, sorts, and 
   divides the Qualification types into pages of size PageSize, it returns 
   page corresponding to PageNumber as the results of the operation.

  .EXAMPLE
   Search-QualificationTypes -Query "Test" -MustBeRequestable $false -MustBeOwnedByCaller $false
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Query,
	[Parameter(Position=1, Mandatory=$false)]
    [bool]$MustBeRequestable=$true,
	[Parameter(Position=2, Mandatory=$false)]
    [bool]$MustBeOwnedByCaller=$true,
    [Parameter(Position=3, Mandatory=$false)]
    [int]$PageSize=$null,
	[Parameter(Position=4, Mandatory=$false)]
    [int]$PageNumber=$null
  )

  Test-AmtApi
  return $AmtClient.SearchQualificationTypes($Query, $MustBeRequestable, $MustBeOwnedByCaller, $null, $null, $null, $null)
}

#########################################################################################
function New-QualificationRequirement {
<# 
 .SYNOPSIS 
  Setup a qualification requirement object

 .DESCRIPTION
  Setup a qualification requirement object

 .PARAMETER QualificationTypeId

 .PARAMETER Comparator

 .PARAMETER IntegerValue

 .PARAMETER LocaleValue

 .PARAMETER RequiredToPreview
  
 .EXAMPLE
  Add-QualificationRequirement 
  
 .LINK
  about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$QualificationTypeId,
    [Parameter(Position=1, Mandatory=$false)]
    [ValidateSet('Exists', 'LessThan','LessThanOrEqualTo', 'GreaterThan', 'GreaterThanOrEqualTo', 'EqualTo', 'NotEqualTo')]
    [string]$Comparator,
    [Parameter(Position=2, Mandatory=$false)]
    $IntegerValue,
    [Parameter(Position=3, Mandatory=$false)]
    [string]$LocaleValue,
    [Parameter(Position=4, Mandatory=$false)]
    [bool]$RequiredToPreview,
    [Parameter(Position=4, Mandatory=$false)]
    [ValidateSet('Masters','CategorizationMasters','PhotoModerationMaster','NumberHITsApproved', 'Locale','Adult','PercentAssignmentsApproved')]
    [string]$BuiltIn
  )

  switch($BuiltIn)
  {
    "Masters" {  
      if($AmtSandbox) {
        $QualificationTypeId = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6"
      } else {
        $QualificationTypeId = "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"
      }
      $Comparator = "Exists"
    }
    "CategorizationMasters" {
      if($AmtSandbox) {
        $QualificationTypeId = "2F1KVCNHMVHV8E9PBUB2A4J79LU20F"
      } else {
        $QualificationTypeId = "2NDP2L92HECWY8NS8H3CK0CP5L9GHO"
      }
      $Comparator = "Exists"
    }
    "PhotoModerationMasters" {
      if($AmtSandbox) {
        $QualificationTypeId = "2TGBB6BFMFFOM08IBMAFGGESC1UWJX"
      } else {
        $QualificationTypeId = "21VZU98JHSTLZ5BPP4A9NOBJEK3DPG"
      }
      $Comparator = "Exists" 
    }
    "NumberHITsApproved" {
      $QualificationTypeId = "00000000000000000040"
    }
    "Locale" {
      $QualificationTypeId = "00000000000000000071"
      $Comparator = "EqualTo"
    }
    "Adult" {
      $QualificationTypeId = "00000000000000000060"
      $Comparator = "EqualTo"
      $IntegerValue = 1
    }
    "PercentAssignmentsApproved" {
      $QualificationTypeId = "000000000000000000L0"
    }
  }

  $qr = New-Object QualificationRequirement
  if($QualificationTypeId) { $qr.QualificationTypeId = $QualificationTypeId }
  if($Comparator) { $qr.Comparator = $Comparator }
  if($IntegerValue) { $qr.IntegerValue = $IntegerValue }
  if($LocaleValue) { $qr.LocaleValue = New-Locale $LocaleValue }
  if($RequiredToPreview) { $qr.RequiredToPreview = $RequiredToPreview }
  return $qr
}

#########################################################################################
function New-ExternalQuestion {
<# 
 .SYNOPSIS 
  Setup a new external HIT question

 .DESCRIPTION
  Setup a qualification requirement object

 .PARAMETER ExternalURL

 .PARAMETER FrameHeight 
  
 .EXAMPLE
  New-ExternalHitQuestion -ExternalURL "http://mysite.com/" -FrameHeight 400 
  
 .LINK
  about_AmtApi
#>
    
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$ExternalURL,
    [Parameter(Position=1, Mandatory=$false)]
    [int]$FrameHeight=400
  )

  $eq = New-object Amazon.WebServices.MechanicalTurk.Domain.ExternalQuestion
  $eq.ExternalURL = $ExternalURL
  $eq.FrameHeight = $FrameHeight
  return $eq
}

#########################################################################################
function New-QuestionForm {
<# 
 .SYNOPSIS 
  Setup a new Question Form.

 .DESCRIPTION
  Setup a new HTML question.

 .PARAMETER HTMLContent

 .PARAMETER FrameHeight 
  
 .EXAMPLE
  New-HtmlQuestion -HTMLContent "<h1>Hello World</h1>" -FrameHeight 400 
  
 .LINK
  about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$TemplatePath
  )

  throw "Not implemented"

  $template = gc $TemplatePath
  $qf = New-Object Amazon.WebServices.MechanicalTurk.Domain.QuestionForm
  return $qf

}

#########################################################################################
function New-HtmlQuestion {
<# 
 .SYNOPSIS 
  Setup a new HTML question.

 .DESCRIPTION
  Setup a new HTML question.

 .PARAMETER HTMLContent

 .PARAMETER FrameHeight 
  
 .EXAMPLE
  New-HtmlQuestion -HTMLContent "<h1>Hello World</h1>" -FrameHeight 400 
  
 .LINK
  about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HTMLContent,
    [Parameter(Position=1, Mandatory=$false)]
    [int]$FrameHeight=400
  )

  $hq = New-object HTMLQuestion
  $hq.HTMLContent = $HTMLContent
  $hq.FrameHeight = $FrameHeight
  return $hq
}

#########################################################################################
function New-Hit {
<# 
 .SYNOPSIS 
  Setup a new HIT.

 .DESCRIPTION
  Setup a new HIT.

 .PARAMETER HITTypeId

 .PARAMETER HITLayoutId

 .PARAMETER Title

 .PARAMETER Description 

 .PARAMETER Question

 .PARAMETER Keywords 

 .PARAMETER MaxAssignments

 .PARAMETER Reward 

 .PARAMETER AutoApprovalDelayInSeconds

 .PARAMETER Expiration 

 .PARAMETER AssignmentDurationInSeconds

 .PARAMETER RequesterAnnotation

 .PARAMETER QualificationRequirement 
  
 .EXAMPLE
  New-Hit
  
 .LINK
  about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$HITTypeId,
    [Parameter(Position=1, Mandatory=$false)]
    [string]$HITLayoutId,
    [Parameter(Position=2, Mandatory=$false)]
    [string]$Title,
    [Parameter(Position=3, Mandatory=$false)]
    [string]$Description,
    [Parameter(Position=4, Mandatory=$false)]
    [string]$Question,
    [Parameter(Position=5, Mandatory=$false)]
    [string]$Keywords,
    [Parameter(Position=6, Mandatory=$false)]
    [int]$MaxAssignments,
    [Parameter(Position=7, Mandatory=$false)]
    [double]$Reward,
    [Parameter(Position=8, Mandatory=$false)]
    [long]$AutoApprovalDelayInSeconds,
    [Parameter(Position=9, Mandatory=$false)]
    [long]$Expiration,
    [Parameter(Position=10, Mandatory=$false)]
    [long]$AssignmentDurationInSeconds,
    [Parameter(Position=11, Mandatory=$false)]
    [string]$RequesterAnnotation,
    [Parameter(Position=12, Mandatory=$false)]
    $QualificationRequirement,
    [Parameter(Position=13, Mandatory=$false)]
    [HIT]$OldHit
  )

  if($OldHit) {
    $hit = $OldHit
  } else {
    $hit = New-Object HIT
  }
  if($HITTypeId) { $hit.HITTypeId = $HITTypeId }
  if($HITLayoutId) { $hit.HITLayoutId = $HITLayoutId }
  if($Title) { $hit.Title = $Title }
  if($Description) { $hit.Description = $Description }
  if($Question) { $hit.Question = $Question }
  if($Keywords) { $hit.Keywords = $Keywords }
  if($MaxAssignments) { 
    $hit.MaxAssignments = $MaxAssignments 
    $hit.MaxAssignmentsSpecified = $true  
  }
  if($Reward) { $hit.Reward = New-Price $Reward }
  if($AutoApprovalDelayInSeconds) { 
    $hit.AutoApprovalDelayInSeconds = $AutoApprovalDelayInSeconds
    $hit.AutoApprovalDelayInSecondsSpecified = $true
  }
  if($Expiration) { }
  if($AssignmentDurationInSeconds) { 
    $hit.AssignmentDurationInSeconds = $AssignmentDurationInSeconds
    $hit.AssignmentDurationInSecondsSpecified = $true
  }
  if($RequesterAnnotation) { $hit.RequesterAnnotation = $RequesterAnnotation }
  if($QualificationRequirement) { $hit.QualificationRequirement = $QualificationRequirement }
  return $hit
}

#########################################################################################
function New-Price {
<# 
  .SYNOPSIS 
   Setup a new price object.

  .DESCRIPTION
   Setup a new price object to define the reward of a HIT.

  .PARAMETER Amount
   The amount of money, as a number. The amount is in the currency specified by 
   the CurrencyCode. For example, if CurrencyCode is USD, the amount will be 
   in United States dollars (e.g. 12.75 is $12.75 US).
  
  .EXAMPLE
   New-Price -Amount 0.5
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [decimal]$Amount
  )
  $p = New-Object Price
  $p.Amount = $Amount
  $p.CurrencyCode = "USD"
  return $p
}

#########################################################################################
function New-Locale {
<# 
  .SYNOPSIS 
   Setup a new locale object.

  .DESCRIPTION
   Setup a new locale object to define country qualifications.

  .PARAMETER Country
   A ISO-3166-2 country code, like "US" or "IN"
  
  .EXAMPLE
   New-Locale -Country US
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Country
  )
  $l = New-Object Locale
  $l.Country = $Country
  return $l
}

#########################################################################################
function New-TestHit {
<# 
  .SYNOPSIS 
   Setup a new HIT object.

  .DESCRIPTION
   Setup a new HIT object with test entries:

   Title = "Test HIT"
   Description = "This is just a test hit. Move along."
   Keywords = "Test, Testing"
   MaxAssignments = 5
   AssignmentDurationInSeconds = 3600
   AutoApprovalDelayInSeconds = 0
   Question = "What is the answer to the mother of all test questions?"
   Reward = New-Price 0
   RequesterAnnotation = "Just a test question"

  .EXAMPLE
   New-TestHit
  
  .LINK
   about_AmtApi
#>
  $hit = New-Hit
  $hit.Title = "Test HIT"
  $hit.Description = "This is just a test hit. Move along."
  $hit.Keywords = "Test, Testing"
  $hit.MaxAssignments = 5
  $hit.MaxAssignmentsSpecified = $true
  $hit.AssignmentDurationInSeconds = 3600
  $hit.AssignmentDurationInSecondsSpecified = $true
  $hit.AutoApprovalDelayInSeconds = 0
  $hit.AutoApprovalDelayInSecondsSpecified = $true
  $hit.Question = "What is the answer to the mother of all test questions?"
  $hit.Reward = New-Price 0
  $hit.RequesterAnnotation = "Just a test question"
  return $hit
}

#########################################################################################
function Enter-Hit {
<# 
  .SYNOPSIS 
   Open the HIT in preview mode.

  .DESCRIPTION
   Open the HIT in preview mode.

  .PARAMETER HITGroupId
   The GroupId of the HIT
  
  .EXAMPLE
   Enter-Hit -HITGroupId "ABCDEFG"
  
  .LINK
   about_AmtApi
#>
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$HITGroupId
  )

  # Take the URL of the current client config and launch a browser
  $url = $AmtClient.Config.WebsiteURL + "/mturk/preview?groupId=" + $HITGroupId
  [System.Diagnostics.Process]::Start($url)
}

#########################################################################################
function Search-Hits {
  Throw "Not Implemented"
}

#########################################################################################
function Send-TestEventNotification {
  Throw "Not Implemented"
}

#########################################################################################
function Set-HitAsReviewing {
  Throw "Not Implemented"
}

#########################################################################################
function Set-HitTypeNotification {
  Throw "Not Implemented"
}

#########################################################################################
# Exports
Export-ModuleMember about_AmtApi, Connect-Amt, Get-AccountBalance
#Export-ModuleMember Test-AmtApi

# HITS
Export-ModuleMember Add-Hit, Stop-Hit, Expand-Hit, Remove-Hit, Disable-Hit
Export-ModuleMember Get-AllHits, Get-Hit, Get-ReviewableHits
# Not Implemented: Get-ReviewResultsForHIT, Get-HitsForQualificationType

# Objects
Export-ModuleMember New-Hit, New-ExternalQuestion, New-HtmlQuestion, New-QuestionForm
Export-ModuleMember New-Price, New-Locale, New-TestHit, New-QualificationRequirement

# HITTypes
Export-ModuleMember Register-HitType, Set-HITTypeOfHIT

# Assignments
Export-ModuleMember Approve-Assignment, Deny-Assignment, Approve-RejectedAssignment
Export-ModuleMember Get-AllAssignmentsForHit, Get-Assignment
# Not Implemented: Get-AssignmentsForHit

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
Export-ModuleMember Send-WorkerNotification, Get-FileUploadUrl, Enter-Hit

#########################################################################################