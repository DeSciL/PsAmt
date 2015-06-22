#########################################################################################
# PsAmt Module - AMT Command Line Tools Wrappers
# wehrlist@ethz.ch
# 23aug2013
#########################################################################################
#
# CONTENTS
# Wrappers to the Java Command Line Tools are not yet implemented.
#
#########################################################################################
function about_AmtClt {
<# 
 .SYNOPSIS 
  PowerShell wrappers to Amazon Mechanical Turk Command Line Tools

 .DESCRIPTION
  The Amazon Mechanical Turk Command Line Tools are a set of command
  line interfaces that allow you to easily build solutions leveraging
  Amazon Mechanical Turk without writing a line of code.
  

  The following command are needed to setup path and service
  keys for the AMT command line tools:
  o Set-AmtCltJava
  o Set-AmtCltProperties

  The following commands are implemented:
  [...]

  The following commands are not implemented:
	o Invoke-GetBalance
	o Invoke-LoadHits
	o Invoke-GetResults
	o Invoke-ApproveWork
	o Invoke-RejectWork
	o Invoke-ReviewResults
	o Invoke-DeleteHits
	o Invoke-UpdateHits
	o Invoke-ExtendHits
	o Invoke-GrantBonus
	o Invoke-BlockWorker
	o Invoke-UnblockWorker
	o Invoke-CreateQualificationType
	o Invoke-UpdateQualificationType
	o Invoke-AssignQualification
	o Invoke-ApproveQualificationRequest
	o Invoke-RejectQualificationRequest
	o Invoke-EvaluateQualificationRequest
	o Invoke-UpdateQualificationScores
	o Invoke-RevokeQualification
	o Invoke-ResetAccount
	o Invoke-MakeTemplate
     
 .LINK
  https://requester.mturk.com/developer
#>
}

#########################################################################################
function Set-AmtCltJava {
  Throw "Not Implemented"
}

#########################################################################################
function Set-AmtCltProperties {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-GetBalance {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-LoadHits {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-GetResults {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-ApproveWork {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-RejectWork {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-ReviewResults {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-DeleteHits {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-UpdateHits {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-ExtendHits {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-GrantBonus {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-UnblockWorker {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-CreateQualificationType {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-UpdateQualificationType {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-AssignQualification {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-GetQualificationRequests {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-ApproveQualificationRequests {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-RejectQualificationRequests {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-ËvaluateQualificationRequests {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-UpdateQualificationScores {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-RevokeQualification {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-ResetAccount {
  Throw "Not Implemented"
}

#########################################################################################
function Invoke-MakeTemplate {
  Throw "Not Implemented"
}

#########################################################################################
# Exports

Export-ModuleMember about_AmtClt
#Export-ModuleMember Invoke-GetBalance
#Export-ModuleMember Invoke-LoadHits, Invoke-GetResults, Invoke-ApproveWork, Invoke-RejectWork
#Export-ModuleMember Invoke-ReviewResults, Invoke-DeleteHits, Invoke-UpdateHits, Invoke-ExtendHits
#Export-ModuleMember Invoke-GrantBonus, Invoke-BlockWorker, Invoke-UnblockWorker
#Export-ModuleMember Invoke-CreateQualificationType, Invoke-UpdateQualificationType
#Export-ModuleMember Invoke-AssignQualification, Invoke-ApproveQualificationRequest
#Export-ModuleMember Invoke-RejectQualificationRequest, Invoke-EvaluateQualificationRequest
#Export-ModuleMember Invoke-UpdateQualificationScores, Invoke-RevokeQualification
#Export-ModuleMember Invoke-ResetAccount, Invoke-MakeTemplate

#########################################################################################