# Path where the build will be deployed
$deployPath = "C:\react-demo\build"

Write-Host "Starting deployment..."
Write-Host "Deploy Path: $deployPath"

# Optional: Clean up old files except web.config (if any)
Write-Host "Cleaning up old files..."
Get-ChildItem -Path $deployPath -Recurse | Where-Object { $_.Name -ne "web.config" } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# If there’s a zipped artifact, unzip it
$zipFile = Get-ChildItem -Path $deployPath -Filter *.zip | Select-Object -First 1
if ($zipFile) {
    Write-Host "Extracting $($zipFile.FullName)..."
    Expand-Archive -Path $zipFile.FullName -DestinationPath $deployPath -Force
    Remove-Item $zipFile.FullName -Force
}

# Restart IIS site (replace with your actual site name)
$siteName = "need to enter our site name"

Write-Host "Restarting IIS site: $siteName..."
Import-Module WebAdministration

if (Get-Website -Name $siteName -ErrorAction SilentlyContinue) {
    Stop-Website -Name $siteName
    Start-Website -Name $siteName
    Write-Host "IIS site restarted successfully."
} else {
    Write-Host "Site $siteName not found. Please check the IIS site name."
}

Write-Host "Deployment complete!"
