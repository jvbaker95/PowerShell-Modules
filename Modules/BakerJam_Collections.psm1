#Instead of importing discrete modules, get all modules in the folder that this is in.
ForEach ($Module in $(Get-ChildItem $PSScriptRoot -Filter *psm1 | Where-Object {!$_.Name.Equals("BakerJam_Collections.psm1")})) {
    Import-Module $Module.FullName -DisableNameChecking
}
