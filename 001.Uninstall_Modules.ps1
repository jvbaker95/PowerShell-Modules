# Install PS Modules in the User Profile Path
# This script ensures that PowerShell modules are removed from the user's profile directory.

# Define the default module path in the user's profile
$DEFAULT_MODULE_PATH = [System.IO.Path]::Combine(
    $env:USERPROFILE  # User's profile directory
    ,"Documents"
    ,"PowerShell"
    ,"Modules"
)

# Check if the default module path exists
Switch (Test-Path $DEFAULT_MODULE_PATH) {
    ($false) {  
        # If the path doesn't exist, create the directory
        New-Item $DEFAULT_MODULE_PATH `
            -ItemType Directory `
            -ErrorAction SilentlyContinue
    }
}

# Get all PowerShell module files (*.psm1) from the "Modules" directory
$PSM1_FILES = Get-ChildItem $([System.IO.Path]::Combine($PSScriptRoot,"Modules")) -Filter *psm1

# Iterate through each module file found
foreach ($file in $PSM1_FILES) {

    $folder_name = $file.BaseName  # Get the base name (module name) from the file

    # Identify paths for module folder and file
    $NEW_MODULE_FOLDER = [System.IO.Path]::Combine(
        $DEFAULT_MODULE_PATH
        ,$folder_name
    )

    # Check if the module folder exists, and if so, delete it
    switch (Test-Path $NEW_MODULE_FOLDER) {
        ($true) {
            Get-Item $NEW_MODULE_FOLDER | Remove-Item -Recurse -ErrorAction SilentlyContinue
        }
    }
}
