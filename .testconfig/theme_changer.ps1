$directoryPath = Join-Path -Path $PSScriptRoot -ChildPath "Themes"

# Get all subdirectories and store them in an array
$subdirectories = Get-ChildItem -Path $directoryPath -Directory | Select-Object -ExpandProperty Name

# 1. Handle case where no subdirectories are found
if (-not $subdirectories -or $subdirectories.Count -eq 0) {
    Write-Host "No themes found in $directoryPath. Exiting." -ForegroundColor Red
    exit 1
}

$themeCount = $subdirectories.Count
$isValidSelection = $false
$selectedIndex = -1 # Variable to hold the final 0-based index

do {
    Write-Host "`nPlease select a Theme from the list below: `n`n" -ForegroundColor Green
    
    # List the options dynamically
    for($i = 0; $i -lt $themeCount; $i++) {
        Write-Output "$($i+1): $($subdirectories[$i])"
    }

    $prompt = "`n`nEnter a number between 1 and $themeCount"
    $response = Read-Host $prompt

    if ([int]::TryParse($response, [ref]$selectedIndex)) {
        # Convert 1-based user input (1, 2, 3...) to 0-based array index (0, 1, 2...)
        $selectedIndex-- 

        # Check if the 0-based index is within the valid range
        if ($selectedIndex -ge 0 -and $selectedIndex -lt $themeCount) {
            $isValidSelection = $true
        } else {
            Write-Host "Error: '$response' is out of the valid range (1-$themeCount)." -ForegroundColor Red
        }
    } else {
        Write-Host "Error: '$response' is not a valid number. Please try again." -ForegroundColor Red
    }
}
while (-not $isValidSelection)

$selectedTheme = $subdirectories[$selectedIndex]

Write-Host "`nSuccessfully selected theme: $selectedTheme" -ForegroundColor Yellow
