# Give luckystrike a sec to close & release handles.
Write-Output "[*] Sleeping 3 seconds"
Start-Sleep -Seconds 3

Write-Output "[*] Downloading files"

$ls = (New-Object System.Net.WebClient).Downloadstring('https://raw.githubusercontent.com/tpjkosakowski/tp-powershell-scripts/main/ps-repair-domain-trust.ps1?token=GHSAT0AAAAAABU47ZH4GOEFCFULSZJIXFO6YUWT32A')

if ($ls -eq $null)
{
    Write-Output "[*] Unable to download files. Aborting"
    exit
}

try 
{
    Write-Output "[*] Updating Script.ps1"
    Remove-Item "$($PWD.Path)\ps-repair-domain-trust.ps1"
    $ls | Out-File "$($PWD.Path)\ps-repair-domain-trustv3.ps1"
}
catch [System.Exception] {
    Write-Output "Error saving new version of luckystrike.ps1"
    throw
	Read-Host "Press any key to exit."
    exit
}


Write-Output "[*] Done!"
Write-Output "`nUpdates in 2.0 - Word support, Invoke-Obfuscation support, new attack methods. See blog post here for new features https://curi0usjack.blogspot.com/2017/07/luckystrike-20-is-here.html"
Read-Host "`nPress any key to continue. If errors, grab a screenshot and submit an issue with the debug log on github, otherwise run the new version of luckystrike.ps1. Happy hacking! --@curi0usJack"