# setup.ps1
# Interactive PowerShell script that reads config.json from the same directory,
# and performs actions (install packages, configure git) based on user choice.

# Get script directory and JSON path
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$jsonPath = Join-Path $scriptDir "config.json"

# Load config.json
if (-not (Test-Path $jsonPath)) {
    Write-Host "Error: config.json not found in $scriptDir" -ForegroundColor Red
    exit 1
}

$config = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json

# --- Functions ---

function Install-Packages {
    Write-Host "`n=== Installing Packages ===" -ForegroundColor Cyan
    foreach ($package in $config.packages) {
        Write-Host "Installing $package..." -ForegroundColor Yellow
        try {
            winget install --id $package -e --accept-package-agreements --accept-source-agreements -h | Out-Null
            Write-Host "✓ $package installed successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Failed to install $package. Skipping..." -ForegroundColor Red
        }
    }
}


function Configure-Git {
    if ($config.gitConfig) {
        $gitName = $config.gitConfig.name
        $gitEmail = $config.gitConfig.email

        Write-Host "`n=== Configuring Git User ===" -ForegroundColor Cyan
        git config --global user.name "$gitName"
        git config --global user.email "$gitEmail"
        Write-Host "✓ Git user set to '$gitName <$gitEmail>'." -ForegroundColor Green
    } 
    
    else {
        Write-Host "No gitConfig section found in config.json." -ForegroundColor Yellow
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "==================================" -ForegroundColor DarkCyan
    Write-Host "   Setup Script by Jude Agustino   " -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "1. Install Packages" -ForegroundColor Yellow
    Write-Host "2. Configure Git" -ForegroundColor Yellow
    Write-Host "3. View JSON Config" -ForegroundColor Yellow
    Write-Host "4. Exit" -ForegroundColor Yellow
    Write-Host ""
}

# --- Menu Loop ---
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-4)"

    switch ($choice) {
        "1" {
            Install-Packages
            Pause
        }
        "2" {
            Configure-Git
            Pause
        }
        "3" {
            Write-Host "`n--- JSON Configuration ---" -ForegroundColor Cyan
            Get-Content $jsonPath
            Write-Host "`n--------------------------" -ForegroundColor Cyan
            Pause
        }
        "4" {
            Write-Host "Exiting..." -ForegroundColor Cyan
            break
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1.5
        }
    }
} while ($choice -ne "4")
