## --- PowerShell Script to List Folder Names ---

# Define the path to the folder you want to check
# By default use the Themes folder that sits next to this script. Using $PSScriptRoot
# makes the script work no matter which directory you run it from.
$FolderPath = Join-Path -Path $PSScriptRoot -ChildPath "Themes"

# Check if the folder exists before proceeding
if (-not (Test-Path -Path $FolderPath -PathType Container)) {
    Write-Error "Error: The folder '$FolderPath' does not exist."
    exit 1
}

Write-Host "--- Folders Found in: $FolderPath ---" -ForegroundColor Green 

# Use Get-ChildItem to retrieve all items in the path
# -Directory filters the results to only include folders
# Select-Object -ExpandProperty Name pulls just the name string for a clean list
$FolderNames = Get-ChildItem -Path $FolderPath -Directory | Select-Object -ExpandProperty Name

# Check if any folders were found
if ($FolderNames.Count -eq 0) {
    Write-Host "No subfolders found in '$FolderPath'." -ForegroundColor Yellow
} else {
    # Print each folder name
    $FolderNames
}

Write-Host "--------------------------------------" -ForegroundColor Green