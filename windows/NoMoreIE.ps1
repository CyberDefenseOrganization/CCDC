# Ensure Admin Rights
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrator')) {
    Write-Error "Please run this script as Administrator"
    exit 1
}

# --- Step 1: Download and Install Firefox ---
$firefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
$installerPath = "$env:TEMP\FirefoxSetup.exe"

Write-Host "Downloading Firefox installer..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $firefoxInstallerUrl -OutFile $installerPath

if (Test-Path $installerPath) {
    Write-Host "Firefox installer downloaded. Starting silent install..." -ForegroundColor Green
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    Remove-Item $installerPath -Force
    Write-Host "Firefox installed successfully." -ForegroundColor Green
} else {
    Write-Error "Failed to download Firefox installer."
    exit 1
}

# --- Step 2: Attempt to Uninstall Edge ---
$edgeApp = Get-AppxPackage -Name Microsoft.MicrosoftEdge -ErrorAction SilentlyContinue

if ($edgeApp) {
    Write-Host "Attempting to remove Microsoft Edge..." -ForegroundColor Yellow
    try {
        Remove-AppxPackage -Package $edgeApp.PackageFullName -ErrorAction Stop
        Write-Host "Edge removal attempted (check manually to confirm)." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to remove Edge. It may be system protected."
    }
} else {
    Write-Host "Microsoft Edge not found or already removed." -ForegroundColor Gray
}

# --- Step 3: Uninstall Internet Explorer (Windows Feature) ---
Write-Host "Attempting to remove Internet Explorer..." -ForegroundColor Cyan
$ieFeature = Get-WindowsOptionalFeature -FeatureName Internet-Explorer-* -Online -ErrorAction SilentlyContinue

if ($ieFeature.State -eq "Enabled") {
    Disable-WindowsOptionalFeature -Online -FeatureName $ieFeature.FeatureName -NoRestart
    Write-Host "Internet Explorer has been disabled. Restart required to fully apply." -ForegroundColor Green
} else {
    Write-Host "Internet Explorer is already disabled or not found." -ForegroundColor Gray
}

Write-Host "Script completed. You may need to reboot to finalize uninstalls." -ForegroundColor Cyan

#Real Jon Fortnite
