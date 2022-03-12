function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
function Create-Directory {
  param (
        $DirectoryName
    )
    if (-not (Test-Path -Path $DirectoryName)) {
      New-Item -ItemType directory -Path $DirectoryName
    }
}

Write-Host Starting DevApps installation...
$appengine="https://devapps-f239e-default-rtdb.firebaseio.com/gclousdk.json"
$build="https://devapps-f239e-default-rtdb.firebaseio.com/build.json"
$buildserver="https://devapps-f239e-default-rtdb.firebaseio.com/buildserver.json"
$bindir="$HOME\.devapps\bin"
$appdata="$env:APPDATA\devapps\"
$winexe="https://devapps-f239e-default-rtdb.firebaseio.com/exe.json"

Create-Directory $appdata
Create-Directory $appdata\deps
Create-Directory $appdata\scripts
Create-Directory $bindir

Write-Host Downloading DevApps Executable
Invoke-WebRequest $winexe -OutFile "$bindir\devapps.exe"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading Storage SDK...
Invoke-WebRequest $appengine -OutFile "$appdata\deps\appengine.zip"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading Build Files...
Invoke-WebRequest $build -OutFile "$appdata\deps\build.zip"
Write-Host -ForegroundColor Green Done!
Write-Host Downloading BuildServer...
Invoke-WebRequest $buildserver -OutFile "$appdata\deps\buildserver.zip"
Write-Host -ForegroundColor Green Done!
Write-Host Donwloading Update Script...
Invoke-WebRequest $update -OutFile "$appdata\scripts\upgrade.sh"
Write-Host -ForegroundColor Green Done!
Write-Host Extracting Files

if (Test-Path $appdata\deps\build) {
    Remove-Item -Recurse $appdata\deps\build
}
if (Test-Path $appdata\deps\appengine) {
    Remove-Item -Recurse $appdata\deps\appengine
}
if (Test-Path $appdata\deps\buildserver) {
    Remove-Item -Recurse $appdata\deps\buildserver
}
Unzip "$appdata\deps\build.zip" "$appdata\deps\build"
Unzip "$appdata\deps\appengine.zip" "$appdata\deps\appengine"
Unzip "$appdata\deps\buildserver.zip" "$appdata\deps\buildserver"
Remove-Item "$appdata\deps\build.zip"
Remove-Item "$appdata\deps\appengine.zip"
Remove-Item "$appdata\deps\buildserver.zip"
Write-Host -ForegroundColor Green Done!
$env:Path += ";$bindir;"

Write-Host -ForegroundColor Yellow DevApps has been successfully installed at $bindir\devapps.exe!

Write-Host -ForegroundColor Green Thank You!





