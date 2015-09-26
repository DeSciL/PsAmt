# PsAmt

PowerShell wrapper module for the Amazon Mechanical Turk .Net SDK

### Features

- Makes it easier to script solutions leveraging Amazon Mechanical Turk.
- A replacement for the [AMT Command Line Tools](https://requester.mturk.com/developer/tools/clt).
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

     # List methods of $AmtClient
     Get-Command -Module PsAmt

     CommandType  Name                                       ModuleName
     -----------  ----                                       ----------
     Function     about_PsAmt                                PsAmt
     Function     Add-HIT                                    PsAmt
     Function     Add-QualificationType                      PsAmt
     Function     Add-QualificationTypeFull                  PsAmt
     Function     Approve-Assignment                         PsAmt
     Function     Approve-RejectedAssignment                 PsAmt
     Function     Block-Worker                               PsAmt
     Function     Connect-AMT                                PsAmt
     Function     Deny-Assignment                            PsAmt
     Function     Deny-QualificationRequest                  PsAmt
     Function     Disable-HIT                                PsAmt
     Function     Disconnect-AMT                             PsAmt
     Function     Enter-HIT                                  PsAmt
     Function     Expand-HIT                                 PsAmt
     Function     Get-AccountBalance                         PsAmt
     Function     Get-AllAssignmentsForHIT                   PsAmt
     Function     Get-AllHITs                                PsAmt
     Function     Get-AllQualificationTypes                  PsAmt
     Function     Get-AMTKeys                                PsAmt
     Function     Get-Assignment                             PsAmt
     Function     Get-BlockedWorkers                         PsAmt
     Function     Get-BonusPayments                          PsAmt
     Function     Get-FileUploadUrl                          PsAmt
     Function     Get-HIT                                    PsAmt
     Function     Get-QualificationRequests                  PsAmt
     Function     Get-QualificationScore                     PsAmt
     Function     Get-QualificationsForQualificationType     PsAmt
     Function     Get-QualificationType                      PsAmt
     Function     Get-ReviewableHITs                         PsAmt
     Function     Grant-Bonus                                PsAmt
     Function     Grant-Qualification                        PsAmt
     Function     Grant-QualificationRequest                 PsAmt
     Function     New-ExternalQuestion                       PsAmt
     Function     New-HIT                                    PsAmt
     Function     New-HtmlQuestion                           PsAmt
     Function     New-Locale                                 PsAmt
     Function     New-Price                                  PsAmt
     Function     New-QualificationRequirement               PsAmt
     Function     New-QuestionForm                           PsAmt
     Function     New-TestHIT                                PsAmt
     Function     Register-HITType                           PsAmt
     Function     Remove-HIT                                 PsAmt
     Function     Remove-QualificationType                   PsAmt
     Function     Revoke-Qualification                       PsAmt
     Function     Search-QualificationTypes                  PsAmt
     Function     Send-WorkerNotification                    PsAmt
     Function     Set-AMTKeys                                PsAmt
     Function     Set-HITTypeOfHit                           PsAmt
     Function     Stop-HIT                                   PsAmt
     Function     Unblock-Worker                             PsAmt
     Function     Update-QualificationScore                  PsAmt
     Function     Update-QualificationType                   PsAmt

### Prerequisites

- Windows 7, 8, 10
- Windows Management Framework 3 (.NET 4, PowerShell 3)
- Amazon Mechanical Turk Requester Account
- Amazon WebService Account

### Install

- Clone and copy PsAmt subfolder to your module directory, i.e. to $Evn:PsModulePath. Add DLL from modified [dotnetmturk](https://github.com/descil/dotnetmturk/releases).
- Or download and put the latest [full package](https://github.com/descil/psamt/releases) into your module directory.

### Documentation

- PowerShell functions have comment-based help, i.e., type `help Get-HIT`
- Functions follow the [Mturk API Reference](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html)
- See the walk-through examples in the sample folder.

### License

Copyright (C) 2015 Stefan Wehrli

PsAmt is based on a modified version of the [Amazon Mechanical Turk SDK for .Net](http://mturkdotnet.codeplex.com/). 
Comment based help of PowerShell functions are taken from the [Amazon Mturk API Reference](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html).
The rest is [MIT](https://github.com/DeSciL/PsAmt/blob/master/LICENSE) and provided "as is".