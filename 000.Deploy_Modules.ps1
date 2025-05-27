# Install PS Modules in the User Profile Path
# This script ensures that PowerShell modules are installed in the user's profile directory.

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

    # Define paths for new module folder and file
    $NEW_MODULE_FOLDER = [System.IO.Path]::Combine(
        $DEFAULT_MODULE_PATH
        ,$folder_name
    )
    $NEW_MODULE_PATH = [System.IO.Path]::Combine(
        $NEW_MODULE_FOLDER
        ,$file.Name
    )

    # Check if the module folder exists, and if so, delete it to ensure fresh installation
    switch (Test-Path $NEW_MODULE_FOLDER) {
        ($true) {
            Get-Item $NEW_MODULE_FOLDER | Remove-Item -Recurse -ErrorAction SilentlyContinue
        }
    }

    # Create a new folder for the module
    New-Item $NEW_MODULE_FOLDER -ItemType Directory -ErrorAction SilentlyContinue

    # Copy the module file into the newly created module folder
    $file | Copy-Item -Destination $NEW_MODULE_PATH
}
