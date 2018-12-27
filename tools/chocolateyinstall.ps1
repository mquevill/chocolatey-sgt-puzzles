$ErrorActionPreference = 'Stop';

$packageName  = 'sgt-puzzles'
$toolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'puzzles-20181213.ced51ad-installer.msi'

$packageArgs = @{
  packageName   = $packageName
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = "/qn /norestart /l*v     `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""

  validExitCodes= @(0)

  softwareName  = 'sgt-puzzles*'
  checksum      = '82B18B08585C71B010B9144B0BFC330266DE2CE2E39A15A5AAD4B3270C2DE9EAE66F8DCF76F5064F5F9C2D1F3BFCA783AA3E959E8F5A3D28DF00F26827C2C52F'
  checksumType  = 'sha512'
}

Install-ChocolateyInstallPackage @packageArgs
