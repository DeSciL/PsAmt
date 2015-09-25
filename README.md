# PsAmt
PowerShell wrapper module for the Amazon Mechanical Turk .Net SDK


### Functions


     CommandType     Name                                               ModuleName
     -----------     ----                                               ----------
     Function        about_PsAmt                                        PsAmt
     Function        Add-Hit                                            PsAmt
     Function        Add-QualificationType                              PsAmt
     Function        Add-QualificationTypeFull                          PsAmt
     Function        Approve-Assignment                                 PsAmt
     Function        Approve-RejectedAssignment                         PsAmt
     Function        Block-Worker                                       PsAmt
     Function        Connect-Amt                                        PsAmt
     Function        Deny-Assignment                                    PsAmt
     Function        Deny-QualificationRequest                          PsAmt
     Function        Disable-Hit                                        PsAmt
     Function        Disconnect-Amt                                     PsAmt
     Function        Enter-Hit                                          PsAmt
     Function        Expand-Hit                                         PsAmt
     Function        Get-AccountBalance                                 PsAmt
     Function        Get-AllAssignmentsForHit                           PsAmt
     Function        Get-AllHits                                        PsAmt
     Function        Get-AllQualificationTypes                          PsAmt
     Function        Get-AmtKeys                                        PsAmt
     Function        Get-Assignment                                     PsAmt
     Function        Get-BlockedWorkers                                 PsAmt
     Function        Get-BonusPayments                                  PsAmt
     Function        Get-FileUploadUrl                                  PsAmt
     Function        Get-Hit                                            PsAmt
     Function        Get-QualificationRequests                          PsAmt
     Function        Get-QualificationScore                             PsAmt
     Function        Get-QualificationsForQualificationType             PsAmt
     Function        Get-QualificationType                              PsAmt
     Function        Get-ReviewableHits                                 PsAmt
     Function        Grant-Bonus                                        PsAmt
     Function        Grant-Qualification                                PsAmt
     Function        Grant-QualificationRequest                         PsAmt
     Function        New-ExternalQuestion                               PsAmt
     Function        New-Hit                                            PsAmt
     Function        New-HtmlQuestion                                   PsAmt
     Function        New-Locale                                         PsAmt
     Function        New-Price                                          PsAmt
     Function        New-QualificationRequirement                       PsAmt
     Function        New-QuestionForm                                   PsAmt
     Function        New-TestHit                                        PsAmt
     Function        Register-HitType                                   PsAmt
     Function        Remove-Hit                                         PsAmt
     Function        Remove-QualificationType                           PsAmt
     Function        Revoke-Qualification                               PsAmt
     Function        Search-QualificationTypes                          PsAmt
     Function        Send-WorkerNotification                            PsAmt
     Function        Set-AmtKeys                                        PsAmt
     Function        Set-HitTypeOfHit                                   PsAmt
     Function        Stop-Hit                                           PsAmt
     Function        Unblock-Worker                                     PsAmt
     Function        Update-QualificationScore                          PsAmt
     Function        Update-QualificationType                           PsAmt


     # Define your pool
	 > $pool = "pc01", "pc02", "pc03"

     # Start the computers by Wake-On-Lan
	 > Start-Pool $pool

	 # Setup a pool object, combine computers
	 > Register-Pool $pool

	 # Call a function on all clients
	 > Invoke-Pool { Start-Chrome www.google.com -Kiosk }

	 # Close treatments
	 > Invoke-Pool { Stop-Chrome }

	 # Shutdown
	 > Stop-Pool
