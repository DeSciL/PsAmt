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
function Invoke-AmtCltHelp {
<# 
 .SYNOPSIS 
  Command Help

 .DESCRIPTION
  Show command line help of a command.

 .PARAMETER Cmd
  Command to display help.
  
 .EXAMPLE
  Invoke-AmtCltHelp -Cmd
  
 .LINK
  about_AmtCtl
#>
  Param(
   [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$False)]
   [string]$Cmd
  )

  BEGIN {
	Throw "Not Implemented"

	Set-MturkProperties
    Set-MturkCltJava
    Push-Location
    Set-Location $global:mturkClt
  }

  PROCESS {
    ./invoke $Cmd  %* "-help"
  }

  END {
    Pop-Location
    Remove-MturkProperties
  }
}

#########################################################################################
function Invoke-GetBalance {
<# 
 .SYNOPSIS 
  Get Balance

 .DESCRIPTION
  This operation returns your Requester account balance.

 .PARAMETER HITId
  The ID of the HIT to retrieve.
  
 .EXAMPLE
  Invoke-GetBalance
  
 .LINK
  about_AmtCtl
#>
  Param(
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [switch]$Help
  )

  BEGIN {
	Throw "Not Implemented"

  }

  PROCESS {

  }

  END {

  }
}

#########################################################################################
function Invoke-LoadHits {
<# 
 .SYNOPSIS 
  Load HITs

 .DESCRIPTION
  This operation loads HITs into Amazon Mechanical Turk.

 .PARAMETER Label
  Define a label to attach to this set of HITs that are being loaded.
 .PARAMETER Input
  Specify the Input File.
 .PARAMETER Question
  Specify the Question File.
 .PARAMETER Properties
  Specify the HIT Properties File.
 .PARAMETER Preview
  Creates an HTML preview of the HIT instead of loading it into Amazon Mechanical Turk. 
  If -previewfile is not specified, this operation will create a file called 
  preview.html in the current directory.
 .PARAMETER MaxHit
  Specify the maximum number of HITs to create (used for testing purposes if 
  you don't want to load the entire Input File).
 .PARAMETER Help
  Print Help for this operation.
  
 .EXAMPLE
  Invoke-LoadHits -Label Hit1
  
 .LINK
  about_AmtCtl
#>
  Param(
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$Label,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$Input,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$Question,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$Properties,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [switch]$Preview,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [int]$MaxHit,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [switch]$Help
  )
  
  BEGIN {
	Throw "Not Implemented"
  }

  PROCESS {

  }

  END {

  }
}

#########################################################################################
function Invoke-GetResults {
<# 
 .SYNOPSIS 
  Get Results

 .DESCRIPTION
  This operation retrieves the results of submitted HITs from Amazon Mechanical Turk.

 .PARAMETER Label
  Set a label to this set of HITs that are being loaded.

 .PARAMETER SuccessFile
  Specify the Input File.

 .PARAMETER OutputFile
  Specify the Question File.

 .PARAMETER Help
  Print Help for this operation.
  
 .EXAMPLE
  Invoke-GetResults -Label Hit1
  
 .LINK
  about_AmtCtl
#>
  Param(
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$Label,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$SuccessFile,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$OutputFile,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [switch]$Help
  )
  
  BEGIN {
	Throw "Not Implemented"
  }

  PROCESS {

  }

  END {

  }
}

#########################################################################################
function Invoke-ApproveWork {
  <# 
 .SYNOPSIS 
  Approve Work

 .DESCRIPTION
  This operation approves assignments submitted by workers via Amazon Mechanical Turk.

 .PARAMETER Assignments
  Specify the assignment ID to approve. For multiple assignments, separate each assignment ID with a comma and enclosed in quotation marks.

 .PARAMETER ApproveFile
  Specify the filename of a text file containing a list of assignment IDs and optionally approval comments.

 .PARAMETER SuccessFile
  Specify the filename of a .success file that contains a list of HIT IDs and HIT type IDs. 
  The operation will approve all of the assignments for the HITs in the file.

 .PARAMETER Help
  Print Help for this operation.
  
 .EXAMPLE
  Invoke-ApproveWork -Assignments "SYSZH6HTMKFG2ZDECWS0,KYRZSX0F7154T054AZT0"
  
  
  
 .LINK
  about_AmtCtl
#>
  Param(
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$True)]
   [string[]]$Assignments,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$ApproveFile,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [string]$SuccessFile,
   [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$False)]
   [switch]$Help
  )
  
  BEGIN {
	Throw "Not Implemented"
  }

  PROCESS {

	  # Loop over list of Assignments in the assignment array.
	  # If assignment empty, just do with the approve or success file.

  }

  END {

  }
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