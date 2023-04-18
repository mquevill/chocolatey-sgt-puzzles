# Chocolatey-SGT-Puzzles
Source files of [Chocolatey package for sgt-puzzles](https://community.chocolatey.org/packages/sgt-puzzles) (Simon Tatham's Portable Puzzle Collection)

To build and push the package, simply run `run.ps1`:
```powershell
.\run.ps1
```

This script will:
- download the newest installer
- extract the version number
- calculate the checksum
- pack the .nupkg
- push to Chocolatey
- clean up build files
