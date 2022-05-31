$version = "2.0"
$githubver = "https://raw.githubusercontent.com/tpjkosakowski/tp-powershell-scripts/development/currentversion.txt?token=GHSAT0AAAAAABU47ZH4DWNJSMXC3L4J3J4QYUWTRTA"
$updatefile = "https://raw.githubusercontent.com/tpjkosakowski/tp-powershell-scripts/development/ps-repair-domain-trust.ps1?token=GHSAT0AAAAAABU47ZH5VG4EY5Y65MQD6GJGYUWT6KQ"
function UpdatesAvailable()
{
	$updateavailable = $false
	$nextversion = $null
	try
	{
		$nextversion = (New-Object System.Net.WebClient).DownloadString($githubver).Trim([Environment]::NewLine)
	}
	catch [System.Exception] 
	{
		Write-Message $_ "debug"
	}
	
	Write-Message "CURRENT VERSION: $version" "debug"
	Write-Message "NEXT VERSION: $nextversion" "debug"
	if ($nextversion -ne $null -and $version -ne $nextversion)
	{
		#An update is most likely available, but make sure
		$updateavailable = $false
		$curr = $version.Split('.')
		$next = $nextversion.Split('.')
		for($i=0; $i -le ($curr.Count -1); $i++)
		{
			if ([int]$next[$i] -gt [int]$curr[$i])
			{
				$updateavailable = $true
				break
			}
		}
	}
	return $updateavailable
}

function Process-Updates()
{
	if (Test-Connection 8.8.8.8 -Count 1 -Quiet)
	{
		$updatepath = "$($PWD.Path)\update.ps1"
		if (Test-Path -Path $updatepath)	
		{
			#Remove-Item $updatepath
		}
		if (UpdatesAvailable)
		{
			Write-Message "Update available. Do you want to update luckystrike? Your payloads/templates will be preserved." "success"
			$response = Read-Host "`nPlease select Y or N"
			while (($response -match "[YyNn]") -eq $false)
			{
				$response = Read-Host "This is a binary situation. Y or N please."
			}

			if ($response -match "[Yy]")
			{	
				(New-Object System.Net.Webclient).DownloadFile($updatefile, $updatepath)
				Start-Process PowerShell -Arg $updatepath
				exit
			}
		}
	}
	else
	{
		Write-Message "Unable to check for updates. Internet connection not available." "warning"
	}
}


Process-Updates


# Powershell script to repair broken domain trust on remote computer through Kaseya
<#
$username = "1054433"   #enter employee id number here
$password = ConvertTo-SecureString "password" -AsPlainText -Force  #replace password with your current password
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

Reset-ComputerMachinePassword -Server adc-002.townepark.net -credential $creds

Test-ComputerSecureChannel -Repair -Credential $creds#>
