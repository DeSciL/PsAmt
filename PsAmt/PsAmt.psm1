#########################################################################################
# PsAmt Module
# stwehrli@gmail.com
# 28apr2014
#########################################################################################

# Contents
# about_PsAmt

#########################################################################################
# Global Settings

[string]$Global:AmtModulePath = Get-Module -ListAvailable PsAmt | Split-Path -Parent

#########################################################################################

<# 
 .SYNOPSIS 
  PowerShell wrapper scripts to access Amazon Mechanical Turk .Net API

 .DESCRIPTION
  PowerShell wrapper scripts to access Amazon Mechanical Turk .Net API
    
 .LINK
  https://github.com/DeSciL/PsAmt
  http://mturkdotnet.codeplex.com/
  http://www.mturk.com
#>
function about_PsAmt {}

#########################################################################################
# Exports 
Export-ModuleMember about_PsAmt

# AmtApi
# Exports in AmtApi.ps1

# AmtUtil
# Exports in AmtUtil.ps1

#########################################################################################