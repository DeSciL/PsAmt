#########################################################################################
# PSAmt Build Script
# stwehrli@gmail.com
#########################################################################################

function PSAmt_Assets {
    [string[]]$assets = $null
    $assets += "AmtApi.ps1"
    $assets += "AmtUtil.ps1"
    $assets += "Build.ps1"
    $assets += "PSAmt.psd1"
    $assets += "PSAmt.psm1"

    $assets += "lib\Amazon.WebServices.MechanicalTurk.dll"

    $assets += "\samples\ApiSamples.ps1"
    
    $assets += "\templates\Qualification.answer"
    $assets += "\templates\Qualification.question"
    $assets += "\templates\Survey.question"
    $assets += "\templates\Trivia.question"
    $assets += "\templates\Troubles.question"

    $assets
}

#########################################################################################
