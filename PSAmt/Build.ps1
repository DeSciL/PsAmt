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

    $assets
}

#########################################################################################
