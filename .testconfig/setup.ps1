# Written by Jaysum on 2024-06-10

function menu {
    param (
        [string]$title,
        [string[]]$options
    )

    Write-Host $title -ForegroundColor Cyan
    for ($i = 0; $i -lt $options.Length; $i++) {
        Write-Host "[$($i + 1)] $($options[$i])"
    }

    do {
        $selection = Read-Host "Please select an option (1-$($options.Length))"
    } while (-not ($selection -as [int]) -or $selection -lt 1 -or $selection -gt $options.Length)

    return $options[$selection - 1]
}

function Get-Configuration {
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"
    if (-not (Test-Path -Path $configPath)) {
        Write-Error "Configuration file not found at $configPath"
        exit 1
    }

    $jsonContent = Get-Content -Path $configPath -Raw
    return $jsonContent | ConvertFrom-Json
}

function Install-Packages {
    param (
        [Parameter(Mandatory=$true)]
        [psobject]$Config
    )

    foreach ($package in $Config.packages) {
        try {
            winget install --id $package --silent --accept-package-agreements -ErrorAction Stop
            Write-Host "✓ Installed: $package" -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Failed to install: $package" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor DarkRed
        }
    }
}

# $PSScriptRoot is the directory where this script is located
function main{
    $options = @("Install Packages", "Change Theme", "Exit")
    $choice = menu -title "Main Menu" -options $options

    switch ($choice) {
        "Install Packages" {
        }
        "Change Theme" {
            . "$PSScriptRoot/theme_changer.ps1"
        }
        "Exit" {
            Write-Host "Exiting..." -ForegroundColor Yellow
            exit 0
        }
    }
}

# Start the script
main