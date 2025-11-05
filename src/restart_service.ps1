# Path where build will be deployed and served from
$deployPath = "C:\react-demo\build"

Write-Host "Starting deployment..."
Write-Host "Deploy Path: $deployPath"

# Stop your service before updating (optional)
$serviceName = "ReactDemoService"
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Write-Host "Stopping service $serviceName..."
    Stop-Service -Name $serviceName -Force
}

# If there’s a zipped artifact, unzip it
$zipFile = Get-ChildItem -Path $deployPath -Filter *.zip | Select-Object -First 1
if ($zipFile) {
    Write-Host "Extracting $($zipFile.FullName)..."
    Expand-Archive -Path $zipFile.FullName -DestinationPath $deployPath -Force
    Remove-Item $zipFile.FullName -Force
}

# Restart the service
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Write-Host "Starting service $serviceName..."
    Start-Service -Name $serviceName
}

Write-Host "Deployment complete!"
