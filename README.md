# PsAmt

PowerShell wrapper module for the Amazon Mechanical Turk .Net SDK

### Features

- Makes it easy to build solutions leveraging Amazon Mechanical Turk.
- More convenient than the outdated [AMT Command Line Tools](https://requester.mturk.com/developer/tools/clt).
- Working with strongly-typed objects allows chaining, pipeping, and efficient scripting.

### Example

     # Make a connection to Mturk
     Connect-Amt -AccessKeyId sdf -SecretKey -Sandbox

	 # Add-Hit -Title "Name of the president" -Description "Find the name of a president" -Reward 0.5 -Question "What's the name of the 4th US president?"  -MaxAssignments 5

### Functions

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

### Documentation

- PowerShell functions have comment-based help, i.e. `help Get-HIT`
- Functions follow the [Mturk API Reference](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html)
- See the walk-through examples in the sample folder.

### Prerequisites

- Windows 7, 8, 10
- Windows Management Framework 3 (.Net4, PowerShell 3)
- Amazon Mechanical Turk Requester Account
- Amazon WebService Account
- Modified/updated version of Mturk SKD for .Net from [github.com/descil/dotnetmturk](https://github.com/descil/dotnetmturk)

### License

Copyright (C) 2015 Stefan Wehrli

PsAmt is based on a modified version of the [Amazon Mechanical Turk SDK for .Net](http://mturkdotnet.codeplex.com/). 
Comment based help of PowerShell functions are taken from the [Amazon Mturk API Reference](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html)
The rest is MIT and provided "as is".

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
