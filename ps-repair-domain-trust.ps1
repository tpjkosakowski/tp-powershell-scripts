$version = "2.0"
$githubver = "https://raw.githubusercontent.com/tpjkosakowski/tp-powershell-scripts/development/currentversion.txt?token=GHSAT0AAAAAABU47ZH4DWNJSMXC3L4J3J4QYUWTRTA"
$updatefile = "https://raw.githubusercontent.com/tpjkosakowski/tp-powershell-scripts/development/update.ps1?token=GHSAT0AAAAAABU47ZH4HB2WLJYK67RMIT7EYUWUDFA"

function Write-Text ($symbol, $color, $msg)
{
	if ($symbol -ne $null)
	{
		Write-Host "[$symbol]" -ForegroundColor $color -NoNewLine
		Write-Host " - $msg"
	}
	else 
	{
		Write-Host $msg
	}
}

function Write-Message {
	Param
	(	
		[string] $message,
		[string] $type,
		[bool] $prependNewLine
	)
	$msg = ""
	if ($prependNewline) { Write-Host "`n" }
	switch ($type) {
		"error" { 
			$symbol = "!"
			$color = [System.ConsoleColor]::Red
			}
		"warning" {
			$symbol = "!"
			$color = [System.ConsoleColor]::Yellow
			}
		"debug" {
			$symbol = "DBG"
			$color = [System.ConsoleColor]::Magenta
			}
		"success" {
			$symbol = "+"
			$color = [System.ConsoleColor]::Green
			}
		"prereq" {
			$symbol = "PREREQ"
			$color = [System.ConsoleColor]::Cyan
			}
		"status" {
			$symbol = "*"
			$color = [System.ConsoleColor]::White
			}
		default { 
			$color = [System.ConsoleColor]::White
			#$symbol = "*" Don't do this. Looks bad.
			}
		}

		# I know, I know. This code is truly horrible. Judge not, lest I find your github repos...
		if ($PSCmdlet.MyInvocation.BoundParameters -ne $null -and $PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent)
		{
			Add-Content $debuglog $message
			Write-Text $symbol $color $message
		}
		elseif ($type -ne "debug") 
		{
			Write-Text $symbol $color $message
		}

}
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
