Function Get-RedirectedUrl {
	Param (
		[Parameter(Mandatory=$true)] [String] $URL
	)
	$request = [System.Net.WebRequest]::Create($URL)
	$request.AllowAutoRedirect=$false
	$response=$request.GetResponse()
	If ($response.StatusCode -eq "Redirect")
	{
		$response.GetResponseHeader("Location")
	}
}

# Download newest version and get version number
[String] $pkg = "sgt-puzzles"
[String] $url = "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-installer.msi"
#[String] $fname = "puzzles-20230224.9dbcfa7-installer.msi" # hard-coded
[String] $fname = ([System.IO.Path]::GetFileName((Get-RedirectedUrl $url)))
Invoke-WebRequest -uri $url -Outfile ".\tools\$fname"
[Version] $version = $fname.split('.-')[1].Insert(4,'.').Insert(7,'.')
[String] $version_str = $version.ToString()

#Update sgt-puzzles.nuspec with version number
(Get-Content .\$pkg.nuspec.skel).replace('VERVERVER', $version_str) | Set-Content .\$pkg.nuspec

#Update tools/VERIFICATION.txt with checksum
[String] $csum = (checksum -t=sha512 .\tools\$fname)
(Get-Content .\tools\VERIFICATION.txt.skel).replace('NUMNUMNUM', $csum) | Set-Content .\tools\VERIFICATION.txt

#Update tools/chocolateyinstall.ps1 with filename and checksum
(Get-Content .\tools\chocolateyinstall.ps1.skel).replace('NUMNUMNUM', $csum).replace('FILEFILEFILE', $fname) | Set-Content .\tools\chocolateyinstall.ps1

#Package and push to Chocolatey
choco pack $pkg.nuspec
choco push .\$pkg.$version_str.nupkg

#Clean up
rm sgt-puzzles.nuspec,tools\VERIFICATION.txt,tools\chocolateyinstall.ps1

#Print commit message
echo "Update to v$version_str"

