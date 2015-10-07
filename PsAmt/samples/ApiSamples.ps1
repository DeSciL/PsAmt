#########################################################################################
# PsAmt Module - AMT API Tests
# stwehrli@gmail.com
# 20sept2015
#########################################################################################

# CONTENTS
# - Setup
# - Hits
# - HitTypes
# - Qualifications
# - Blocks
# - Notifications
# - Api

#########################################################################################

function Setup {

  #----------------------------------------------------
  # Setup and store AMT keys
  # Asks for AccessKeyID, SecretAccessKey, RequesterId, and a passphrase
  Set-AMTKeys

  # After keys have been stored, connecting to amt requires only the passphrase
  Connect-AMT

  # Set sandbox globally on all the following commands
  Connect-AMT -sandbox

  # Use another account
  Connect-AMT -Keyfile "SecondAccount.key"

  # Disconnect, clear all saved keys and passwords
  Disconnect-AMT

  # Always your first api call
  Get-AccountBalance
}

#########################################################################################
function Hits {
  
  #----------------------------------------------------
  # Connect 
  Connect-AMT -Sandbox

  #----------------------------------------------------
  # List current Hits
  $hitlist = Get-AllHITs
  $hitlist | Format-Table HITId, Title, HITStatus -AutoSize

  #----------------------------------------------------
  # Add a hit

  $hit = Add-HIT -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the 4th US president?"  -MaxAssignments 10
  $hit

  # Get the Hit (now with createdate, and groupid)
  $hit = Get-HIT $hit.HITId
  $hit

  # Stop  a hit / force expiration
  Stop-HIT -HITId $hit.HITId

  # Exend hit / add assignments and time
  # For HITs with assignments < 10, increments in assignment and time needs to be 1 and more than 60
  # For HITs with assignments >= 10, increments can be chosen free and one of them can also be $null
  Expand-HIT -HITId $hit.HITId -MaxAssignmentsIncrement 1  -ExpirationIncrementInSeconds 180

  # Delete. Will only work if the HITstatus is reviewable, i.e. has been exipired before.
  # To delete HITs that are still in status assignable, use Disable-HIT
  Remove-HIT -HITId $hit.HITId

  #----------------------------------------------------
  # Add a hit, accept it, fill out, and approve

  $hit = Add-HIT -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the last US president?"  -MaxAssignments 5
  $hit

  # Get the Hit
  $hit = Get-HIT $hit.HITId

  # Preview the Hit
  Enter-HIT $hit.HITGroupId

  # Get all assignments
  $assigns = Get-AllAssignmentsForHIT -HITId $hit.HITId
  $assigns | ft WorkerId, AssignmentStatus, SubmitTime -AutoSize

  # Get the first assignment
  $assign  = Get-Assignment -AssignmentId $assigns[0].AssignmentId

  # Approve assignment
  Approve-Assignment -AssignmentId $assigns[0].AssignmentId -RequesterFeedback "Well done"

  # Disable
  Disable-HIT -HITId $hit.HITId

  #----------------------------------------------------
  # Add a hit, accept it, fill out on website, reject it, and approve after rejection

  $hit = Add-HIT -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the 4th US president?"  -MaxAssignments 5
  $hit = Get-HIT $hit.HITId
  Enter-HIT $hit.HITGroupId
  $assigns = Get-AllAssignmentsForHIT -HITId $hit.HITId
  $assign  = Get-Assignment -AssignmentId $assigns[0].AssignmentId

  # Reject and then approve
  Deny-Assignment -AssignmentId $assign.AssignmentId -RequesterFeedback "Not good work"
  Approve-RejectedAssignment -AssignmentId $assign.AssignmentId -RequesterFeedback "You were right."

  # Disable
  Disable-HIT -HITId $hit.HITId
}

#########################################################################################
function HitTypes {

  Connect-AMT -Sandbox

  #----------------------------------------------------
  # Register a HitType

  $title = "Name of the president"
  $desc = "Find the name of a president"
  $q = "What's the name of the last US president?"

  $hitTypeId = Register-HITType -Title $title -Description $desc -AutoApprovalDelayInSeconds 1000 -AssignmentDurationInSeconds 3600 -Reward 0.5 -Keywords "President"
  $hitTypeId

  #----------------------------------------------------
  # External HIT with HitType

  $eq = New-ExternalQuestion -ExternalURL "https://yoursite.com/questionnaire.html" -FrameHeight 400

  $hit = Add-HIT -HITTypeId $hitTypeId -Keywords "keyword1, keyword2" -Question $eq  -LifetimeInSeconds 3600 -MaxAssignments 5  -RequesterAnnotation "My External HIT"
  $hit = Get-HIT $hit.HITId

  Disable-HIT $hit.HITId

  #----------------------------------------------------
  # Question Form / Trouble Ticket
  
  $templateDir = Join-Path $AmtModulePath templates
  $troubleTemplate = Get-Content (Join-Path $templateDir troubles.question)
  $hit = Add-HIT -Title "ETH DeSciL Trouble Ticket" -Description "Trouble Ticket" -Reward 0 -Question $troubleTemplate  -MaxAssignments 20

  Disable-HIT $hit.HITId

  #----------------------------------------------------
  # Question Form / Simple Questionnaire
  
  $templateDir = Join-Path $AmtModulePath templates
  $triviaTemplate = Get-Content (Join-Path $templateDir trivia.question)
  $hit = Add-HIT -Title "Trivia Test Qualification" -Description "A qualification test" -Reward 0 -Question $triviaTemplate  -MaxAssignments 20

  Disable-HIT $hit.HITId

  #----------------------------------------------------
  # HTML Questions / A more complex questionnaire
  # Generate a HIT with the AMT online tools, then export the HIT template
  # https://requestersandbox.mturk.com/create/projects
  # The template is basically a HTML form that can be modified with a text editor.

  # Get the designed hit
  # $hit = Get-HIT (Read-Host "Enter the HITId of the designed hit.")

  # Export the template
  # $templateDir = Join-Path $AmtModulePath templates
  # $hit.Question | Out-File (Join-Path $templateDir Survey.question)

  # Read the HTML survey template back in
  $templateDir = Join-Path $AmtModulePath templates
  $questonnaire = Get-Content (Join-Path $templateDir Survey.question)

  # Add the template to a new HIT
  $hit = Add-HIT -Title "Survey Test" -Description "Survey Test" -Reward 0 -Question $questonnaire  -MaxAssignments 20
  
  Disable-HIT $hit.HITId

}

#########################################################################################
function Qualifications {

  # Qualification are based on QualificationTypes. QualificationTypes are stored templates
  # for qualifications.
  
  # Your WorkerId is stored in the key file
  $myWorker = Get-AMTKeys -RequesterId

  Connect-AMT -Sandbox

  #----------------------------------------------------
  # Retrieve operations

  # List
  $qt = Get-AllQualificationTypes
  $qt.Name

  # Search
  $qs = Search-QualificationTypes -Query "TQ"
  $qs.QualificationType.Name

  #----------------------------------------------------
  # Basic operations

  # Setup new qualification
  $qt = Add-QualificationType -Name "TQ3" -Description "A Test Qualification" -Keywords "Keyword 1, Keyword2"
  
  # Display
  $qt = Get-QualificationType $qt.QualificationTypeId
  $qt

  # Note:
  # Remove qualification, will only set it to inactive
  # It can take up to 48 hours until the types are removed.
  Remove-QualificationType $qt.QualificationTypeId

  #----------------------------------------------------
  # Assign Qualification to HIT

  # Create a new Qualification Requirement
  # Note: New comparators like DoesNotExist, In, and NotIn should work
  $qt = Add-QualificationType -Name "TQ5" -Description "A Qualification For a HIT"
  $qt

  $qr = New-QualificationRequirement -QualificationTypeId $qt.QualificationTypeId -Comparator Exists
  $qr

  # Setup a new HIT
  $h = New-HIT
  $h.Title = "Name of the president"
  $h.Description = "Find the name of a president"
  $h.Keywords = "Keyword 1"
  $h.MaxAssignments = 5
  $h.MaxAssignmentsSpecified = $true
  $h.AssignmentDurationInSeconds = 3600
  $h.AssignmentDurationInSecondsSpecified = $true
  $h.RequesterAnnotation = "My Hit"
  $h.Question = "What's the name of the last US president?"
  $h.Reward = New-Price 0.5
  $h.QualificationRequirement= $qr
  
  # Setup the HIT by providing the object
  Add-HIT -HIT $h

  # --> Now search the HIT on the website and request the qualification

  # Show QualificationRequests
  $qq = Get-QualificationRequests -QualificationTypeId $qt.QualificationTypeId
  $qq

  # Grant the qualification requests. This will generate a notification.
  $qq1 = $qq.QualificationRequest[0]
  Grant-QualificationRequest -QualificationRequestId $qq1.QualificationRequestId

  #----------------------------------------------------
  # Assign builtin qualifications

  $qLocale = New-QualificationRequirement -BuiltIn Locale -LocaleValue "US"
  $qMaster = New-QualificationRequirement -BuiltIn Masters
  $qCat = New-QualificationRequirement -BuiltIn CategorizationMasters
  $qPhoto = New-QualificationRequirement -BuiltIn PhotoModerationMasters
  $qAdult = New-QualificationRequirement -BuiltIn Adult
  $qApprove = New-QualificationRequirement -BuiltIn NumberHITsApproved -IntegerValue 50 -Comparator GreaterThan
  $qPercent = New-QualificationRequirement -BuiltIn PercentAssignmentsApproved -IntegerValue 95 -Comparator GreaterThan

  # Setup test hit
  $h = New-TestHIT
  $h.QualificationRequirement = $qLocale

  # Add muliple qualifications into the array
  $h.QualificationRequirement = @($qLocale, $qApprove)

  # Upload
  $h = Add-HIT -HIT $h

  # Inspect the HIT to see the listed qualifications
  $h = Get-HIT $h.HITId
  $h.QualificationRequirement

  #----------------------------------------------------
  # Qualification Test

  # Get sources of question and answer
  $templateDir = Join-Path $AmtModulePath templates
  $testSource = Get-Content (Join-Path $templateDir Qualification.question) -Raw
  $answerSource = Get-Content (Join-Path $templateDir Qualification.answer) -Raw

  # Add a qualification type
  # Note: The full verions ins requried, i.e. Add-Qual...Full
  # Test and answer sources are provied as parameteres
  $q = Add-QualificationTypeFull -Name "TQ12" -Keywords "Key 1" -Description "Desc" -QualificationTypeStatus Active -RetryDelayInSeconds 1000 -Test $testSource -AnswerKey $answerSource -TestDurationInSeconds 360

  # Create a new Qualification Requirement
  $qr = New-QualificationRequirement -QualificationTypeId $q.QualificationTypeId -Comparator Exists
  $qr

  # Setup external question
  $extUrl = "https://www.yoursite.com/yourtreatment.html"
  $eq = New-ExternalQuestion -ExternalURL $extUrl -FrameHeight 400

  # Register a HitType
  $title = "Name of the president"
  $desc = "Find the name of a president"
  $hitTypeId = Register-HITType -Title $title -Description $desc -AutoApprovalDelayInSeconds 1000 -AssignmentDurationInSeconds 3600 -Reward 0.5 -Keywords "President" -QualificationRequirement $qr
  $hitTypeId

  # Upload HIT
  $hit = Add-HIT -HITTypeId $hitTypeId -Keywords "keyword1, keyword2" -Question $eq  -LifetimeInSeconds 3600 -MaxAssignments 5  -RequesterAnnotation "My External HIT"
  $hit = Get-HIT $hit.HITId

  # Inspect if Qualification Test works
  Enter-HIT $hit.HitId

  #----------------------------------------------------
  # Qualification Updates

  # Setup new qualification
  $qt = Add-QualificationType -Name "TQ6" -Description "A Test Qualification" -Keywords "Keyword 1, Keyword 2"
  $qt

  $qt = Get-QualificationType $qt.QualificationTypeId
  $qt

  Update-QualificationType -OldQualificationType $qt -Description "A new description"
  Update-QualificationType -OldQualificationType $qt -Test $testSource -AnswerKey $answerSource -TestDurationInSeconds 30

  #----------------------------------------------------
  # Qualification Assignments and Value Updates

  # Note:
  # Revoke generates notification. For Grant a bool can be specified.

  $myWorkerId = Get-AMTKeys -RequesterId

  Grant-Qualification -QualificationTypeId $qt.QualificationTypeId -WorkerId $myWorkerId -SendNotification $true
  Update-QualificationScore -QualificationTypeId $qt.QualificationTypeId -WorkerId  $myWorkerId -IntegerValue 25
  Get-QualificationScore -QualificationTypeId $qt.QualificationTypeId -WorkerId $myWorkerId
  Revoke-Qualification -QualificationTypeId $qt.QualificationTypeId -WorkerId $myWorkerId -Reason "Not good enough."

}

#########################################################################################
function Blocking {

  # Connect and do this on the sandbox
  Connect-AMT -Sandbox

  # Get your WorkerId stored in the key file
  $myWorker = Get-AMTKeys -RequesterId

  # Block yourself from accepting HITs
  Block-Worker -WorkerId $myWorker -Reason "Don't do this again!"

  # List all blocked workers
  Get-BlockedWorkers
  
  # Unblock yourself
  Unblock-Worker -WorkerId $myWorker -Reason "Be nice!"
}

#########################################################################################
function Notifications {

  Connect-AMT -Sandbox
  $myWorker = Get-AmtKeys -RequesterId

  $subject = "Hello there" 
  $message = "This is the message"
 
  # Send yourself an email
  Send-WorkerNotification -WorkerId $myWorker -Subject $subject -MessageText $message

  # Note: Parameter WorkerId takes an array of max length 100, 
  # i.e. you can send identical mails in batches
}

#########################################################################################
function Api {

  # Working directly with API client. The client object is $AmtClient.

  # List all members properties and function
  $Global:AmtClient | Get-Member

  # Example: Get the Balance
  $AmtClient.GetAccountBalance()
}

#########################################################################################