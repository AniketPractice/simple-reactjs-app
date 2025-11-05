# Path where the new build will be deployed
$targetPath = "C:\inetpub\wwwroot\reactdemo"  # need o add our path

# Path where CodePipeline drops the new build (artifact)
$sourcePath = "C:\demo\build"  # dummy path for testing

Write-Host "Starting deployment..."
Write-Host "Source: $sourcePath"
Write-Host "Target: $targetPath"

# Stop the service before deploying (optional)
$serviceName = "ReactDemoService"
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Write-Host "Stopping service $serviceName..."
    Stop-Service -Name $serviceName -Force
}

# Copy new files to target folder
if (Test-Path $targetPath) {
    Remove-Item -Recurse -Force "$targetPath\*"
}
Copy-Item -Path "$sourcePath\*" -Destination $targetPath -Recurse -Force

# Start the service again
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Write-Host "Starting service $serviceName..."
    Start-Service -Name $serviceName
}

Write-Host "Deployment complete!"
