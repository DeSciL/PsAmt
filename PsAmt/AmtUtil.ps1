#########################################################################################
# PsAmt Module - Utility Functions
# stwehrli@gmail.com
# 6may2014
#########################################################################################
#
# CONTENTS
# - Write-AMTError
# - Set-AMTKeys
# - Get-AMTKeys
# - Protect-String
# - Unprotect-String
#
#########################################################################################
function Write-AMTError {
<# 
  .SYNOPSIS 
   Return formated error
   
  .DESCRIPTION
   Return formated error

  .LINK
   about_PsAmt
#>
	Write-Host $Error[0] -ForegroundColor Red

	# TODO:
	# Consider logging to file
}

#########################################################################################
function Set-AMTKeys {
<# 
  .SYNOPSIS 
   Encrypt Amt Service Keys.
  
  .DESCRIPTION
   Provide AMT AccessKey and SecretKey together with a passphrase
   to protect credentials in an encrypted file (Amt.key).
   If passphrase, access key and secret keys are not specified, the
   user will be promped to enter them as secure keys. In future
   connection requests, only the passphrase will be queried.

  .PARAMETER Passphrase
   Specifies the passphrase to encrypt the keys.

  .PARAMETER AccessKey
   Specifies the Amazon Mechanical Turk AccessKey Id.
   
  .PARAMETER SecretKey
   Specifies the Amazon Mechanical Turk SecretKey.

  .PARAMETER RequesterId
   Specifies the Amazon Mechanical Turk Requester Id

  .PARAMETER KeyFile
   Specifies the file to store the encrypted keys. Default is Amt.key.
 
  .EXAMPLE 
   Set-AMTKeys -Passphrase "MyPassphrase" -AccessKey "MyAccessKey" -SecretKey "MySecretKey" -RequesterId "MyRequesterId"

  .LINK
   Get-AmtKeys
   Protect-String
   Unprotect-String
#>
	Param(
		[Parameter(Position=0, Mandatory=$false)]
		[string]$Passphrase,
		[Parameter(Position=1, Mandatory=$false)]
		[string]$AccessKey,
		[Parameter(Position=2,Mandatory=$false)]
		[string]$SecretKey,
		[Parameter(Position=3,Mandatory=$false)]
		[string]$RequesterId,
		[Parameter(Position=4, Mandatory=$false)]
		[string]$KeyFile="Amt.key"
	)

	if(!$AccessKey) {
		$AccessKeySec = Read-Host "Enter AMT AccessKeyId" -asSecureString
		$AccessKey = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($AccessKeySec))
	}
	if(!$SecretKey) {
		$SecretKeySec = Read-Host "Enter AMT SecretAccessKey" -asSecureString
		$SecretKey = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($SecretKeySec))
	}
	if(!$RequesterId) {
		$RequesterIdSec = Read-Host "Enter AMT RequesterId" -asSecureString
		$RequesterId = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($RequesterIdSec))
	}
	if(!$Passphrase) {
		$PassphraseSec = Read-Host "Enter AMT Passphrase" -asSecureString
		$Passphrase = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($PassphraseSec))
	}

	$modulePath = $Global:AmtKeyPath
	$keyPath = Join-Path $modulePath $KeyFile
	$joinedKeys = $accessKey + "~" + $secretKey + "~" + $RequesterId
	$encrypted = Protect-String $joinedKeys $Passphrase
	Out-File -FilePath $keyPath  -InputObject $encrypted
	Write-Output "Encrypted keys have been saved to file $keyPath"
}

#########################################################################################
function Get-AMTKeys {
<# 
  .SYNOPSIS 
   Decrypts AMT Service Keys
   
  .DESCRIPTION
   Decrypts AMT Service Keys from an encrypted key file. If passphrase
   is not provided, script prompts to enter a passphrase as a secure string.
   Passphrase is stored in $Global:AmtPassphrase

  .PARAMETER Passphrase
   Specifies the Passphrase to decrypt the keys

  .PARAMETER AccessKey
   Switch to request the Amazon Mechanical Turk AccessKey Id from secure store.
   
  .PARAMETER SecretKey
   Switch to request the Amazon Mechanical Turk SecretKey from secure store.

  .PARAMETER RequesterId
   Switch to request the Amazon Mechanical Turk Requester Id

  .PARAMETER KeyFile
   Specifies the file which stores the encrypted keys
   
  .EXAMPLE 
   Get-AMTKeys -KeyFile "Amt.key" -Passphrase "My Passphrase" -AccessKey

  .EXAMPLE
   Get-AMTKeys -KeyFile "Amt.key" -Passphrase "My Passphrase" -SecretKey

  .EXAMPLE
   Get-AMTKeys -KeyFile "Amt.key" -Passphrase "My Passphrase" -RequesterId

  .LINK
   Set-AmtKeys
   Protect-String
   Unprotect-String
#>
	Param(
		[Parameter(Position=0, Mandatory=$false)]
		[string]$Passphrase,
		[Parameter(Position=1, Mandatory=$false)]
		[switch]$AccessKey,
		[Parameter(Position=2,Mandatory=$false)]
		[switch]$SecretKey,
		[Parameter(Position=3,Mandatory=$false)]
		[switch]$RequesterId,
		[Parameter(Position=4, Mandatory=$false)]
		[string]$KeyFile="Amt.key"
	)

	# Check if passphrase is entered or stored
	if(!$Passphrase) {
		if(!$Global:AmtPassphrase) {
			$PassphraseSec = Read-Host "Enter AMT Passphrase" -asSecureString
			$Passphrase = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($PassphraseSec))
			$Global:AmtPassphrase = $PassphraseSec
		} else {
			$Passphrase = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($Global:AmtPassphrase))
		}
	}

	# Re-check if passphrase is stored in global, if not, add it
	if(!$Global:AmtPassphrase) {
		$Global:AmtPassphrase = ConvertTo-SecureString -String $Passphrase -AsPlainText -Force
	}

	# Test if key file exists
	if(!(Test-Path $KeyFile)) {
		$keyPath = Join-Path $Global:AmtKeyPath $KeyFile
		if(!(Test-Path $keyPath)) {
			$Global:AmtPassphrase = $null
			Write-Error "Key file $KeyFile not found!" -ErrorAction Stop
		}
	}

	# Decrypt and extract keys
	$encrypted = Get-Content $keyPath
	Try {
		$joined = Unprotect-String -EncryptedString $encrypted -Passphrase $Passphrase
	}
	Catch {
		$Global:AmtPassphrase = $null
		Write-Error -Message "Unable to decrypt encripted string." -ErrorAction Stop
	}
	$splitted = $joined.Split("~")
	$accessKeyString = $splitted[0]
	$secretKeyString = $splitted[1]
	$requesterIdString = $splitted[2]

	# Return requested element
	if($AccessKey.IsPresent) {
		return $accessKeyString
	}
	if($SecretKey.IsPresent) {
		return $secretKeyString
	}
	if($RequesterId.IsPresent) {
		return $requesterIdString
	}
}

#########################################################################################
function Protect-String {
<# 
 .SYNOPSIS 
  Protect / encrypt a string
  
 .DESCRIPTION
  Encrypts a string with Advanced Encryption Standard (AES/Rijndael).

 .PARAMETER  StringToProtect
  Specifies the string that needs to be encrypted.

 .PARAMETER  Passphrase
  Specifies the passphrase to use with encryption.

 .PARAMETER  Salt
  Specifies the passphrase salt. You can take the default value.

 .PARAMETER  Init
  Specifies the initial password. You can take the default value.
  
 .EXAMPLE 
  Protect-String "The sentence that needs to be protected." "My passphrase"

 .EXAMPLE
  Protect-String "Hello "Moon" "My passphrase"

 .LINK
  Unprotect-String
  http://poshcode.org/116
#>
	Param(
		[Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$true)]
		[string]$StringToProtect,
		[Parameter(Position=1, Mandatory=$false)]
		[string]$Passphrase,
		[Parameter(Mandatory=$False)]
		[string]$Salt="My Voic3 is my P455W0RD!",
		[Parameter(Mandatory=$false)]
		[string]$Init="Y3t anoth3r k3y"
	)

	# Check if passphrase is provided, otherwise request it
	if(!$Passphrase) {
		$PassphraseSec = Read-Host "Enter Passphrase" -asSecureString
		$Passphrase = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($PassphraseSec))
	}
   
	[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-NUll
	$Rm = New-Object System.Security.Cryptography.RijndaelManaged
	$PassBytes = [Text.Encoding]::UTF8.GetBytes($Passphrase)
	$SaltBytes = [Text.Encoding]::UTF8.GetBytes($Salt)

	$Rm.Key = (New-Object Security.Cryptography.PasswordDeriveBytes $PassBytes, $SaltBytes, "SHA1", 5).GetBytes(32) #256/8
	$Rm.IV = (New-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($Init) )[0..15]
   
	$c = $Rm.CreateEncryptor()
	$ms = New-Object IO.MemoryStream
	$cs = New-Object Security.Cryptography.CryptoStream $ms, $c, "Write"
	$sw = New-Object IO.StreamWriter $cs
	$sw.Write($StringToProtect)
	$sw.Close()
	$cs.Close()
	$ms.Close()
	$Rm.Clear()
	[byte[]]$result = $ms.ToArray()
	return [Convert]::ToBase64String($result)
}

#########################################################################################
function Unprotect-String {
<# 
 .SYNOPSIS 
  Unprotect / encrypt a string
  
 .DESCRIPTION
  Decrypts a string with Advanced Encryption Standard (AES/Rijndael).
  
 .PARAMETER EncryptedString
  Specifies the string that needs to be decrypted.

 .PARAMETER Passphrase
  Specifies the passphrase used to encrypt the string.

 .PARAMETER Salt
  Specifies the passphrase salt. You can take the default value.

 .PARAMETER Init
  Specifies the initial password. You can take the default value.

 .EXAMPLE 
  Unprotect-String "The encrypted string" "My passphrase"

 .LINK
  Protect-String
  http://poshcode.org/116
#>
	Param(
		[Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$true)]
		[string]$EncryptedString,
		[Parameter(Position=1, Mandatory=$True)]
		[string]$Passphrase,
		[Parameter(Position=2, Mandatory=$False)]
		[string]$Salt="My Voic3 is my P455W0RD!",
		[Parameter(Position=3, Mandatory=$false)]
		[string]$Init="Y3t anoth3r k3y"
	)

	# Check if passphrase is provided, otherwise request it
	if(!$Passphrase) {
		$PassphraseSec = Read-Host "Enter Passphrase" -asSecureString
		$Passphrase = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($PassphraseSec))
	}
  
	[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-NUll
	$EncryptedBytes = [Convert]::FromBase64String($EncryptedString)

	$Rm = new-Object System.Security.Cryptography.RijndaelManaged
	$PassBytes = [System.Text.Encoding]::UTF8.GetBytes($Passphrase)
	$SaltBytes = [System.Text.Encoding]::UTF8.GetBytes($Salt)

	$Rm.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $PassBytes, $SaltBytes, "SHA1", 5).GetBytes(32) #256/8
	$Rm.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($Init) )[0..15]

	$d = $Rm.CreateDecryptor()
	$ms = new-Object IO.MemoryStream @(,$EncryptedBytes)
	$cs = new-Object Security.Cryptography.CryptoStream $ms, $d, "Read"
	$sr = new-Object IO.StreamReader $cs

	Try {
		$result = $sr.ReadToEnd()
	} 
	Catch {
		Write-Error "Unable to decrypt encripted string." -ErrorAction Stop
	}
  
	$sr.Close()
	$cs.Close()
	$ms.Close()
	$Rm.Clear()
	return $result
}

#########################################################################################
# Exports
Export-ModuleMember Set-AMTKeys
Export-ModuleMember Get-AMTKeys

#########################################################################################