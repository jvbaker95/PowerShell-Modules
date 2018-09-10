#Instead of importing discrete modules, get all modules in the folder that this is in.
Foreach ($Module in $(Get-ChildItem $PSScriptRoot | Where-Object {($_.Name.contains("psm1")) -and ($_.Name -ne "BakerJam_Collections.psm1")})) {
    Import-Module $Module.FullName -DisableNameChecking
}
