# PSAmt

PowerShell wrapper module for the Amazon Mechanical Turk .Net SDK

### Features

- Makes it easier to script solutions leveraging Amazon Mechanical Turk.
- An alternative for the [AMT Command Line Tools](https://requester.mturk.com/developer/tools/clt).
- Working with strongly-typed objects (query, pipe, output to CSV, etc.)

### Example

     # Make a connection to Mturk
     Connect-AMT -AccessKeyId "MyAccessKey" -SecretKey "MySecretKey" -Sandbox

	 # Upload a HIT
	 $h = Add-HIT -Title "Life" -Description "Answer a hard question" -Question "What is the meaning of live?" -Reward 0.5 -MaxAssignments 5

	 # List assignments for the HIT
	 $assigns = Get-AllAssignmentsForHIT -HITId $h.HITId

	 # Approve assignments
	 foreach($a in $assigns) {
	   Approve-Assignment -AssignmentId $a.AssignmentId -RequesterFeedback "Well done!"
	 }

### Methods

     Get-Command -Module PSAmt

     CommandType  Name                                       ModuleName
     -----------  ----                                       ----------
     Function     about_PSAmt                                PSAmt
     Function     Add-HIT                                    PSAmt
     Function     Add-QualificationType                      PSAmt
     Function     Add-QualificationTypeFull                  PSAmt
     Function     Approve-Assignment                         PSAmt
     Function     Approve-RejectedAssignment                 PSAmt
     Function     Block-Worker                               PSAmt
     Function     Connect-AMT                                PSAmt
     Function     Deny-Assignment                            PSAmt
     Function     Deny-QualificationRequest                  PSAmt
     Function     Disable-HIT                                PSAmt
     Function     Disconnect-AMT                             PSAmt
     Function     Enter-HIT                                  PSAmt
     Function     Expand-HIT                                 PSAmt
     Function     Get-AccountBalance                         PSAmt
     Function     Get-AllAssignmentsForHIT                   PSAmt
     Function     Get-AllHITs                                PSAmt
     Function     Get-AllQualificationTypes                  PSAmt
     Function     Get-AMTKeys                                PSAmt
     Function     Get-Assignment                             PSAmt
     Function     Get-BlockedWorkers                         PSAmt
     Function     Get-BonusPayments                          PSAmt
     Function     Get-FileUploadUrl                          PSAmt
     Function     Get-HIT                                    PSAmt
     Function     Get-QualificationRequests                  PSAmt
     Function     Get-QualificationScore                     PSAmt
     Function     Get-QualificationsForQualificationType     PSAmt
     Function     Get-QualificationType                      PSAmt
     Function     Get-RequesterStatistic                     PSAmt
	   Function     Get-RequesterWorkerStatistc                PSAmt
     Function     Get-ReviewableHITs                         PSAmt
     Function     Grant-Bonus                                PSAmt
     Function     Grant-Qualification                        PSAmt
     Function     Grant-QualificationRequest                 PSAmt
     Function     New-ExternalQuestion                       PSAmt
     Function     New-HIT                                    PSAmt
     Function     New-HtmlQuestion                           PSAmt
     Function     New-Locale                                 PSAmt
     Function     New-Price                                  PSAmt
     Function     New-QualificationRequirement               PSAmt
     Function     New-QuestionForm                           PSAmt
     Function     New-TestHIT                                PSAmt
     Function     Register-HITType                           PSAmt
     Function     Remove-HIT                                 PSAmt
     Function     Remove-QualificationType                   PSAmt
     Function     Revoke-Qualification                       PSAmt
     Function     Search-QualificationTypes                  PSAmt
     Function     Send-WorkerNotification                    PSAmt
     Function     Set-AMTKeys                                PSAmt
     Function     Set-HITTypeOfHit                           PSAmt
     Function     Stop-HIT                                   PSAmt
     Function     Unblock-Worker                             PSAmt
     Function     Update-QualificationScore                  PSAmt
     Function     Update-QualificationType                   PSAmt

### Prerequisites

- Windows Management Framework 3 (.NET 4, PowerShell 3)
- Amazon Mechanical Turk Requester Account
- Amazon WebService Account

### Install

- Download and copy the latest release [PSAmt-v*.zip](https://github.com/descil/PSAmt/releases) to your module directory.
- Alternatively, clone and copy PSAmt subfolder to your module directory. Additionally, add DLL from modified [dotnetmturk](https://github.com/descil/dotnetmturk/releases).

### Documentation

- PowerShell functions have comment-based help, i.e., type `help about_PSAmt`
- Functions follow closely operations from the [Mturk API Reference](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html)
- See walk-through [examples](https://github.com/DeSciL/PSAmt/blob/master/PSAmt/samples/ApiSamples.ps1) in the sample folder.

### License

Copyright (C) 2015 Stefan Wehrli

PSAmt is based on a modified version of the [Amazon Mechanical Turk SDK for .Net](http://mturkdotnet.codeplex.com/). 
Comment based help of PowerShell functions are taken from the [Amazon Mturk API Reference](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html).
The rest is [MIT](https://github.com/DeSciL/PSAmt/blob/master/LICENSE) and provided "as is".