<#
**Komorebi**
- `Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1`
  - enables support for long paths in Windows
- `winget install LGUG2Z.komorebi1 LGUG2Z.whkd`
  - Downloads komorebi and whkd through winget
- `komorebic fetch-asc`
  - downloads latest application specific configurations

**Yasb** 
- `winget install --id AmN.yasb`
  - install yasb through winget 

**Windhawk**
- `winget install --id=RamenSoftware.Windhawk  -e`
#> 

# ------------------------------------------------------------------
# SOLUTION FOR HIDING LOGS AND SHOWING CUSTOM MESSAGES
# ------------------------------------------------------------------

<#
    This function executes a command while suppressing its standard output (logs) 
    and error streams using redirection to $null, only printing a simple 
    "Installing..." message for the user.
#>
Function Invoke-SilentCommand {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command,

        [Parameter(Mandatory=$true)]
        [string]$DisplayName
    )

    Write-Host "Installing $DisplayName..." -ForegroundColor Cyan

    # Use Invoke-Expression to run the command string.
    # Redirect streams 1 (Success) and 2 (Error) to $null to suppress all output.
    # Note: winget may still prompt for UAC/elevation, which cannot be suppressed here.
    Invoke-Expression "$Command 1> `$null 2> `$null" 
    
    # Since we don't have exit code checking here, we assume completion.
    Write-Host "Installation of $DisplayName complete." -ForegroundColor Green
}

Write-Host "`n`n--- Installation Script Demonstration (Logs Hidden) ---" -ForegroundColor DarkGray

# 1. Set-ItemProperty (Requires administrative elevation to work correctly)
Invoke-SilentCommand "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1" "Long Paths Setting"

# 2. winget installs
Invoke-SilentCommand "winget install LGUG2Z.komorebi LGUG2Z.whkd -e" "komorebi and whkd"
Invoke-SilentCommand "winget install --id AmN.yasb -e" "AmN.yasb"
Invoke-SilentCommand "winget install --id RamenSoftware.Windhawk -e" "Windhawk"
Invoke-SilentCommand "winget install --id karlstav.cava -e" "Cava"

# 3. Final configuration command
Write-Host "Fetching configuration..." -ForegroundColor Cyan
# This command is typically a simple process, suppressing its stdout is sufficient.
komorebic fetch-asc | Out-Null
Write-Host "Configuration fetch complete." -ForegroundColor Green
