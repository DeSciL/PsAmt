#########################################################################################
# PsTurkR Module - AMT API Tests
# stwehrli@gmail.com
# 28apr2014
#########################################################################################

# CONTENTS
# - Hits
# - HitTypes
# - Qualifications
# - Blocks
# - Notifications

#########################################################################################

function Hits {
  
  #----------------------------------------------------
  # Connect 
  Connect-Amt -Sandbox

  #----------------------------------------------------
  # List current Hits
  $hitlist = Get-AllHits
  $hitlist | ft HITId, Title, HITStatus -AutoSize

  #----------------------------------------------------
  # Add a hit

  $hit = Add-Hit -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the 4th US president?"  -MaxAssignments 5
  $hit

  # Get the Hit (now with createdate, and groupid)
  $hit = Get-Hit $hit.HITId
  $hit

  # Stop  a hit / force expiration
  Stop-Hit -HITId $hit.HITId

  # Exend hit / add assignments and time
  Expand-Hit -HITId $hit.HITId -MaxAssignmentsIncrement 5 -ExpirationIncrementInSeconds 180

  # Delete
  Remove-Hit -HITId $hit.HITId

  #----------------------------------------------------
  # Add a hit, accept it, fill out, and approve

  $hit = Add-Hit -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the last US president?"  -MaxAssignments 5
  $hit

  # Get the Hit
  $hit = Get-Hit $hit.HITId

  # Preview the Hit
  Enter-Hit $hit.HITGroupId

  # Get all assignments
  $assigns = Get-AllAssignmentsForHit -HITId $hit.HITId
  $assigns | ft WorkerId, AssignmentStatus, SubmitTime -AutoSize

  # Get the first assignment
  $assign  = Get-Assignment -AssignmentId $assigns[0].AssignmentId

  # Approve assignment
  Approve-Assignment -AssignmentId $assigns[0].AssignmentId -RequesterFeedback "Well done"

  # Disable
  Disable-Hit -HITId $hit.HITId

  #----------------------------------------------------
  # Add a hit, accept it, fill out on website, reject it, and approve after rejection

  $hit = Add-Hit -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the 4th US president?"  -MaxAssignments 5
  $hit = Get-Hit $hit.HITId
  Enter-Hit $hit.HITGroupId
  $assigns = Get-AllAssignmentsForHit -HITId $hit.HITId
  $assign  = Get-Assignment -AssignmentId $assigns[0].AssignmentId

  # Reject and then approve
  Deny-Assignment -AssignmentId $assign.Assignment.AssignmentId -RequesterFeedback "Not good work"
  Approve-RejectedAssignment -AssignmentId $assign.Assignment.AssignmentId -RequesterFeedback "You were right."

  # Disable
  Disable-Hit -HITId $hit.HITId

}

#########################################################################################
function HitTypes {

  Connect-Amt -Sandbox

  #----------------------------------------------------
  # Register a HitType

  $title = "Name of the president"
  $desc = "Find the name of a president"
  $q = "What's the name of the last US president?"

  $hitTypeId = Register-HitType -Title $title -Description $desc -AutoApprovalDelayInSeconds 1000 -AssignmentDurationInSeconds 3600 -Reward 0.5 -Keywords "President"
  $hitTypeId

  #----------------------------------------------------
  # External HIT with HitType

  $eq = New-ExternalQuestion -ExternalURL "https://yoursite.com/questionnaire.html" -FrameHeight 400

  $hit = Add-Hit -HITTypeId $hitTypeId -Keywords "keyword1, keyword2" -Question $q  -LifetimeInSeconds 3600 -MaxAssignments 5  -RequesterAnnotation "My External HIT"
  $hit = Get-Hit $hit.HITId

  #----------------------------------------------------
  # Question Form / Trouble Ticket
  
  $templateDir = Join-Path $AmtModulePath templates
  $troubleTempate = gc (Join-Path $templateDir troubles.question)
  $hit = Add-Hit -Title "ETH DeSciL Trouble Ticket" -Description "Trouble Ticket" -Reward 0 -Question $troubleTempate  -MaxAssignments 20

  Disable-Hit $hit.HITId

  #----------------------------------------------------
  # Question Form / Simple Questionnaire
  
  $templateDir = Join-Path $AmtModulePath templates
  $troubleTempate = gc (Join-Path $templateDir trivia.question)
  $hit = Add-Hit -Title "Trivia Test Qualification" -Description "A qualification test" -Reward 0 -Question $triviaTempate  -MaxAssignments 20

  Disable-Hit $hit.HITId

  #----------------------------------------------------
  # HTML Questions / A more complex questionnaire
  # Generate a HIT with the amt online tools, then export the hit template
  # https://requestersandbox.mturk.com/create/projects

  # Get the designed hit
  $hit = get-hit (Read-Host "Enter the HITId of the designed hit.")

  # Export the template
  $hit.Question | Out-File (Join-Path $templateDir MySurvey.question)

  # Add the template to a new HIT
  $hit = Add-Hit -Title "Survey Test" -Description "Survey Test" -Reward 0 -Question $hit.Question  -MaxAssignments 20
  Disable-Hit $hit.HITId

}

#########################################################################################
function Qualifications {
  
  $myWorker = Get-AmtKeys -RequesterId

  Connect-Amt -Sandbox

  #----------------------------------------------------
  # Retrieve operations

  # List
  $qt = Get-AllQualificationTypes
  $qt.Name

  # Search
  $qs = Search-QualificationTypes -Query "TQ"
  $qs.QualificationType

  #----------------------------------------------------
  # Basic operations

  # Setup new qualification
  $qt = Add-QualificationType -Name "TQ2" -Description "A Test Qualification" -Keywords "Keyword 1, Keyword2"
  
  $qt = Get-QualificationType $qt.QualificationTypeId
  $qt

  # Remove qualification, will only be set to inactive
  # Better delete it on the web interface since it will 
  # be deleted permanently there
  # Remove-QualificationType $q.QualificationTypeId

  #----------------------------------------------------
  # Assign Qualification to HIT

  # Create a new Qualification Requirement
  $qr = New-QualificationRequirement -QualificationTypeId $qt.QualificationTypeId -Comparator Exists
  $qr

  # Setup a new HIT using the 
  $h = New-Hit
  $h.Title = $title
  $h.Description = $desc
  $h.Keywords = "Keyword 1"
  $h.MaxAssignments = 5
  $h.MaxAssignmentsSpecified = $true
  $h.AssignmentDurationInSeconds = 3600
  $h.AssignmentDurationInSecondsSpecified = $true
  $h.RequesterAnnotation = "My Hit"
  $h.Question = "Who was the last president?"
  $h.Reward = New-Price 0.5
  $h.QualificationRequirement= $qr
  Add-Hit -HIT $h

  # --> Now search the HIT on the website and request the qualification

  # Show QualificationRequests
  $qq = Get-QualificationRequests -QualificationTypeId $qt.QualificationTypeId
  $qq

  # Grant the qualification requests
  $qq1 = $qq.QualificationRequest[0]
  Grant-QualificationRequest -QualificationRequestId $qq1.QualificationRequestId

  #----------------------------------------------------
  # Assign builtin qualifications

  $qLocale = New-QualificationRequirement -BuiltIn Locale -LocaleValue "US"
  $qMaster = New-QualificationRequirement -BuiltIn Masters
  $qCat = New-QualificationRequirement -BuiltIn CategorizationMasters
  $qPhoto = New-QualificationRequirement -BuiltIn PhotoModerationMaster
  $qAdult = New-QualificationRequirement -BuiltIn Adult
  $qApprove = New-QualificationRequirement -BuiltIn NumberHITsApproved -IntegerValue 50 -Comparator GreaterThan
  $qPercent = New-QualificationRequirement -BuiltIn PercentAssignmentsApproved -IntegerValue 95 -Comparator GreaterThan

  # Setup test hit
  $h = New-TestHit
  $h.QualificationRequirement = $qLocale

  # Add muliple qualifications
  $h.QualificationRequirement = @($qLocale, $qApprove)

  # Upload
  Add-Hit -HIT $h

  #----------------------------------------------------
  # Qualification Test

  # Get sources of question and answer
  $testSource = gc C:\home\modules\PsTurkR\templates\Qualification.question -Raw
  $answerSource = gc C:\home\modules\PsTurkR\templates\Qualification.answer -Raw

  # Add a qualification type
  $q = Add-QualificationTypeFull -Name "TQ12" -Keywords "Key 1" -Description "Desc" -QualificationTypeStatus Active -RetryDelayInSeconds 1000 -Test $testSource -AnswerKey $answerSource -TestDurationInSeconds 360

  # Create a new Qualification Requirement
  $qr = New-QualificationRequirement -QualificationTypeId $q.QualificationTypeId -Comparator Exists

  # Setup external question
  $extUrl = "https://www.yoursite.com/yourtreatment.html"
  $eq = New-ExternalQuestion -ExternalURL $extUrl -FrameHeight 400

  # Register a HitType
  $title = "Name of the president"
  $desc = "Find the name of a president"
  $hitTypeId = Register-HitType -Title $title -Description $desc -AutoApprovalDelayInSeconds 1000 -AssignmentDurationInSeconds 3600 -Reward 0.5 -Keywords "President" -QualificationRequirement $qr
  $hitTypeId

  # Publish HIT
  $hit = Add-Hit -HITTypeId $hitTypeId -Keywords "keyword1, keyword2" -Question $eq  -LifetimeInSeconds 3600 -MaxAssignments 5  -RequesterAnnotation "My External HIT"
  $hit = Get-Hit $hit.HITId

  #----------------------------------------------------
  # Qualification Updates

  # Setup new qualification
  $qt = Add-QualificationType -Name "TQ2" -Description "A Test Qualification" -Keywords "Keyword 1, Keyword 2"
  $qt

  $qt = Get-QualificationType $qt.QualificationTypeId
  $qt

  Update-QualificationType -OldQualificationType $qt -Description "A new description"
  Update-QualificationType -OldQualificationType $qt -Test $testSource -AnswerKey $answerSource -TestDurationInSeconds 30

  #----------------------------------------------------
  # Qualification Assignments and Value Updates

  $myWorker = Get-AmtKeys -RequesterId

  Grant-Qualification -QualificationTypeId $qt.QualificationTypeId -WorkerId $MyWorkerId -SendNotification $true
  Update-QualificationScore -QualificationTypeId $qt.QualificationTypeId -WorkerId  $MyWorkerId -IntegerValue 25
  Get-QualificationScore -QualificationTypeId $qt.QualificationTypeId -WorkerId $MyWorkerId
  Revoke-Qualification -QualificationTypeId $qt.QualificationTypeId -WorkerId $MyWorkerId -Reason "Not good enough."
}

#########################################################################################
function Blocking {

  Connect-Amt -Sandbox
  $myWorker = Get-AmtKeys -RequesterId

  Block-Worker -WorkerId $myWorker -Reason "Don't do this again!"

  Get-BlockedWorkers
  
  Unblock-Worker -WorkerId $myWorker -Reason "Be nice!"

}

#########################################################################################
function Notifications {

  Connect-Amt -Sandbox
  $myWorker = Get-AmtKeys -RequesterId

  $subject = "Hello there" 
  $message = "This is the message"
 
  Send-WorkerNotification -Subject $subject -MessageText $message -WorkerIds $myWorker
}

#########################################################################################
