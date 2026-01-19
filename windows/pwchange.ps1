# 1. Get Domain and Password once
$domainName = Read-Host "Enter the domain name (e.g., corp.com)"
$tempPass   = Read-Host "Enter the new temporary password" -AsSecureString

# Format the DC part (e.g., DC=corp,DC=com)
$dcPart = ($domainName.Split('.') | ForEach-Object { "DC=$_" }) -join ","

# 2. Collect multiple OUs
$ouList = @()
while ($true) {
    $inputOU = Read-Host "Enter an OU name (or type DONE to start)"
    if ($inputOU -eq "DONE") { break }
    $ouList += $inputOU
}

# 3. Process each OU
Import-Module ActiveDirectory

foreach ($ouName in $ouList) {
    $fullPath = "OU=$ouName,$dcPart"
    Write-Host "`nProcessing OU: $fullPath" -ForegroundColor Cyan
    
    try {
        $users = Get-ADUser -Filter 'Enabled -eq $true' -SearchBase $fullPath
        
        foreach ($user in $users) {
            try {
                Set-ADAccountPassword -Identity $user.DistinguishedName -NewPassword $tempPass -Reset
                Set-ADUser -Identity $user.DistinguishedName -ChangePasswordAtLogon $true
                Write-Host "  [SUCCESS] $($user.SamAccountName)" -ForegroundColor Green
            }
            catch {
                Write-Warning "  [ERROR] Could not reset $($user.SamAccountName)"
            }
        }
    }
    catch {
        Write-Warning "  [SKIP] Could not find the OU: $fullPath"
    }
}

Write-Host "`nAll tasks complete." -ForegroundColor Yellow
# Made By Berto