# Powershell script to repair broken domain trust on remote computer through Kaseya

$username = "1054433"   #enter employee id number here
$password = ConvertTo-SecureString "password" -AsPlainText -Force  #replace password with your current password
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

Reset-ComputerMachinePassword -Server adc-002.townepark.net -credential $creds

Test-ComputerSecureChannel -Repair -Credential $creds
