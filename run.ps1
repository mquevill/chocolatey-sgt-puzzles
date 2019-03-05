Function Get-RedirectedUrl {
	Param (
		[Parameter(Mandatory=$true)]
		[String]$URL
	)
	$request = [System.Net.WebRequest]::Create($url)
	$request.AllowAutoRedirect=$false
	$response=$request.GetResponse()
	If ($response.StatusCode -eq "Found")
	{
		$response.GetResponseHeader("Location")
	}
}

# Download newest version and get version number
$pkg = "sgt-puzzles"
$url = "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-installer.msi"
$fname = ([System.IO.Path]::GetFileName((Get-RedirectedUrl $url)))
Invoke-WebRequest -uri $url -Outfile ".\tools\$fname"
$vnum = $fname.split('.-')[1]
$version = $vnum.Insert(4,'.').Insert(7,'.')

#Update sgt-puzzles.nuspec with version number
(Get-Content .\$pkg.nuspec.skel).replace('VERVERVER', $version) | Set-Content .\$pkg.nuspec

#Update tools/VERIFICATION.txt with checksum
$csum = (checksum -t=sha512 .\tools\$fname)
(Get-Content .\tools\VERIFICATION.txt.skel).replace('NUMNUMNUM', $csum).replace('FILEFILEFILE', $fname) | Set-Content .\tools\VERIFICATION.txt

#Update tools/chocolateyinstall.ps1 with filename and checksum
(Get-Content .\tools\chocolateyinstall.ps1.skel).replace('NUMNUMNUM', $csum) | Set-Content .\tools\chocolateyinstall.ps1

#Package and push to Chocolatey
cpack $pkg.nuspec
cpush $pkg.$version.nupkg

#Clean up
rm sgt-puzzles.nuspec,tools\VERIFICATION.txt,tools\chocolateyinstall.ps1
