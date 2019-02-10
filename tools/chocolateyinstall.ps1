$ErrorActionPreference = 'Stop';

$packageName  = 'sgt-puzzles'
$toolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'puzzles-20190126.d7c8733-installer.msi'

$packageArgs = @{
  packageName   = $packageName
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = "/qn /norestart /l*v     `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""

  validExitCodes= @(0)

  softwareName  = 'sgt-puzzles*'
  checksum      = '1A0D6D043D5DB53CA4206A5F6A54C2F39927494E12C62D2577B9D3E6562BA82BF8FFA235ABCBC325277CFC595B37FA259F3C0FE8F817A36FFBF9B4F53A23FF98'
  checksumType  = 'sha512'
}

Install-ChocolateyInstallPackage @packageArgs
