# YASB Configuration Path
$yasbPath = "$env:USERPROFILE\.config\yasb"

<#
.SYNOPSIS
    Retrieves all available YASB themes.

.DESCRIPTION
    Gets a list of theme directories from the YASB configuration path. Returns an empty array if the path doesn't exist.

.EXAMPLE
    Get-YasbTheme
#>
function Get-YasbTheme {
    if (-not (Test-Path $yasbPath)) {
        Write-Host "❌ Path not found: $yasbPath" -ForegroundColor Red
        return @()
    }
    
    return @(Get-ChildItem -Path $yasbPath -Directory | Select-Object -ExpandProperty Name)
}

<#
.SYNOPSIS
    Applies a YASB theme by copying its configuration files.

.DESCRIPTION
    Copies config.yaml and styles.css from a theme directory to the main YASB config directory.

.PARAMETER ThemeName
    The name of the theme to apply.

.EXAMPLE
    Set-YasbTheme -ThemeName "darkmode"
#>
function Set-YasbTheme {
    param([string]$ThemeName)
    
    $themePath = "$yasbPath\$ThemeName"
    $files = @('config.yaml', 'styles.css')
    
    if (-not (Test-Path $themePath)) {
        Write-Host "❌ Theme path not found: $themePath" -ForegroundColor Red
        return $false
    }
    
    try {
        $files | ForEach-Object {
            $sourceFile = Resolve-Path "$themePath\$_" -ErrorAction SilentlyContinue
            $destFile = "$yasbPath\$_"
            
            if ($null -ne $sourceFile -and (Split-Path -Parent $sourceFile) -ne $yasbPath) {
                Copy-Item -Path $sourceFile -Destination $destFile -Force
            }
        }
        return $true
    }
    catch {
        Write-Host "❌ Error applying theme: $_" -ForegroundColor Red
        return $false
    }
}

<#
.SYNOPSIS
    Sets a random wallpaper from the selected theme's wallpapers directory.

.DESCRIPTION
    Selects a random image from the theme's walls folder and sets it as the desktop wallpaper.

.PARAMETER ThemeName
    The name of the theme containing the wallpapers.

.EXAMPLE
    Set-Wallpaper -ThemeName "darkmode"
#>
function Set-Wallpaper {
    param([string]$ThemeName)
    
    $wallsPath = "$yasbPath\$ThemeName\walls"
    $regPath = "HKCU:\Control Panel\Desktop"
    
    if (-not (Test-Path $wallsPath)) {
        Write-Host "⚠️  No wallpapers directory found in $ThemeName" -ForegroundColor Yellow
        return
    }
    
    $wallpaperFiles = @(Get-ChildItem -Path $wallsPath -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|bmp|gif|webp)$' })
    
    if ($wallpaperFiles.Count -eq 0) {
        Write-Host "⚠️  No image files found in $wallsPath" -ForegroundColor Yellow
        return
    }
    
    $randomIndex = Get-Random -Minimum 0 -Maximum $wallpaperFiles.Count
    $wallpaperFile = $wallpaperFiles[$randomIndex]
    $wallpaperPath = $wallpaperFile.FullName
    
    try {
        Set-ItemProperty -Path $regPath -Name Wallpaper -Value $wallpaperPath
        1..100 | ForEach-Object { rundll32.exe user32.dll, UpdatePerUserSystemParameters }
        Write-Host "✅ Wallpaper set to: $($wallpaperFile.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error setting wallpaper: $_" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
    Displays a formatted list of available YASB themes.

.DESCRIPTION
    Shows all available themes in a formatted table with numbered selections.

.EXAMPLE
    Show-YasbThemeList -YasbPath $yasbPath
#>
function Show-YasbThemeList {
    $themes = Get-YasbTheme
    
    if ($themes.Count -eq 0) {
        Write-Host "⚠️  No themes found" -ForegroundColor Yellow
        return
    }
    
    Write-Host " ╔════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host " ║          YASB Themes           ║" -ForegroundColor Cyan
    Write-Host " ╚════════════════════════════════╝" -ForegroundColor Cyan
    
    for ($i = 0; $i -lt $themes.Count; $i++) {
        Write-Host "  $($i + 1). $($themes[$i])" -ForegroundColor Green
    }
    Write-Host ""
}

<#
.SYNOPSIS
    Saves the current YASB configuration to a theme directory.

.DESCRIPTION
    Prompts the user to select a theme directory and backs up the current config.yaml and styles.css files to it.

.EXAMPLE
    Save-CurrentTheme -YasbPath $yasbPath
#>
function Save-CurrentTheme {
    $currentConfig = "$yasbPath\config.yaml"
    $currentStyles = "$yasbPath\styles.css"
    
    if (-not (Test-Path $currentConfig) -or -not (Test-Path $currentStyles)) {
        Write-Host "❌ Current config files not found" -ForegroundColor Red
        return
    }
    
    $themes = Get-YasbTheme
    if ($themes.Count -eq 0) {
        Write-Host "⚠️  No themes found" -ForegroundColor Yellow
        return
    }
    
    Show-YasbThemeList
    $choice = Read-Host "Select theme directory to save into (1-$($themes.Count)) or 'q' to cancel"
    
    if ($choice -eq 'q') {
        Write-Host "❌ Save cancelled" -ForegroundColor Red
        return
    }
    
    if ($choice -match '^\d+$' -and $choice -ge 1 -and $choice -le $themes.Count) {
        $selectedTheme = $themes[$choice - 1]
        $targetPath = "$yasbPath\$selectedTheme"
        
        Clear-Host
        Show-YasbThemeList
        Write-Host "⚠️  This will overwrite config files in: $selectedTheme" -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (y/n)"
        
        if ($confirm -ne 'y') {
            Write-Host "❌ Save cancelled" -ForegroundColor Red
            return
        }
        
        try {
            Copy-Item -Path $currentConfig -Destination "$targetPath\config.yaml" -Force
            Copy-Item -Path $currentStyles -Destination "$targetPath\styles.css" -Force
            Write-Host "✅ Current theme saved to: $selectedTheme" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Error saving theme: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
    Creates a new empty YASB theme directory.

.DESCRIPTION
    Prompts for a theme name and creates a new directory in the themes folder for storing custom configurations.

.EXAMPLE
    New-YasbTheme -YasbPath $yasbPath
#>
function New-YasbTheme {
    $themeName = Read-Host "Enter new theme name"
    $themePath = "$yasbPath\$themeName"

    if ([string]::IsNullOrWhiteSpace($themeName)) {
        Write-Host "❌ Theme name cannot be empty" -ForegroundColor Red
        return
    }

    if (Test-Path $themePath) {
        Write-Host "❌ Theme '$themeName' already exists" -ForegroundColor Red
        return
    }

    try {
        New-Item -ItemType Directory -Path $themePath | Out-Null
        Write-Host "✅ Theme '$themeName' created successfully!" -ForegroundColor Green
        Write-Host "📁 Location: $themePath" -ForegroundColor Cyan
    }
    catch {
        Write-Host "❌ Error creating theme: $_" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
    Deletes a YASB theme directory.

.DESCRIPTION
    Prompts the user to select a theme and permanently removes its directory after confirmation.

.EXAMPLE
    Remove-YasbTheme -YasbPath $yasbPath
#>
function Remove-YasbTheme {
    $themes = Get-YasbTheme
    if ($themes.Count -eq 0) {
        Write-Host "⚠️  No themes found" -ForegroundColor Yellow
        return
    }
    
    Show-YasbThemeList
    $choice = Read-Host "Select theme to delete (1-$($themes.Count)) or 'q' to cancel"
    
    if ($choice -eq 'q') {
        Write-Host "❌ Deletion cancelled" -ForegroundColor Red
        return
    }
    
    if ($choice -match '^\d+$' -and $choice -ge 1 -and $choice -le $themes.Count) {
        $selectedTheme = $themes[$choice - 1]
        $themePath = "$yasbPath\$selectedTheme"
        
        Clear-Host
        Show-YasbThemeList
        Write-Host "⚠️  This will permanently delete: $selectedTheme" -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (y/n)"
        
        if ($confirm -ne 'y') {
            Write-Host "❌ Delete cancelled" -ForegroundColor Red
            return
        }
        
        try {
            Remove-Item -Path $themePath -Recurse -Force
            Write-Host "✅ Theme '$selectedTheme' deleted successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Error deleting theme: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
    Resets YASB to default configuration and clears cache.

.DESCRIPTION
    Runs the 'yasbc reset' command to restore default config files and clear the cache. 
    Requires user confirmation before proceeding.

.EXAMPLE
    Reset-YasbConfig
#>
function Reset-YasbConfig {
    
    
    try {
        Write-Host "🔄 Resetting YASB configuration..." -ForegroundColor Cyan
        Write-Host "⚠️  This will restore default config files and clear cache" -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (y/n)"
       
        if ($confirm -ne 'y') {
            Write-Host "❌ Reset cancelled" -ForegroundColor Red
            return
        }
      
        yasbc reset
        yasbc start
     
        Write-Host "✅ YASB configuration reset successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error resetting YASB: $_" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
    Displays the main YASB Manager menu.

.DESCRIPTION
    Shows the interactive menu with available options for managing themes.

.EXAMPLE
    Get-YasbMenu
#>
function Get-YasbMenu {
    Write-Host " ╔════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host " ║          YASB Manager          ║" -ForegroundColor Cyan
    Write-Host " ╚════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host "  1. Load Theme" -ForegroundColor Green
    Write-Host "  2. Save Current Theme" -ForegroundColor Green
    Write-Host "  3. Create New Theme" -ForegroundColor Green
    Write-Host "  4. Delete Theme" -ForegroundColor Green
    Write-Host "  5. Reset Configuration" -ForegroundColor Green
    Write-Host "  q. Quit" -ForegroundColor Green
    Write-Host ""
}

<#
.SYNOPSIS
    Prompts user to select and load a YASB theme.

.DESCRIPTION
    Displays all available themes, allows user to select one, applies it, and sets wallpaper if available.

.EXAMPLE
    Invoke-YasbThemeLoad -YasbPath $yasbPath
#>
function Invoke-YasbThemeLoad {
    Show-YasbThemeList
    $themes = Get-YasbTheme
    if ($themes.Count -eq 0) { return }
    
    $themeChoice = Read-Host "Enter choice (1-$($themes.Count)) or 'q' to cancel"
    
    if ($themeChoice -eq 'q') {
        Write-Host "❌ Theme load cancelled" -ForegroundColor Red
        return
    }
    
    if ($themeChoice -match '^\d+$' -and $themeChoice -ge 1 -and $themeChoice -le $themes.Count) {
        $selected = $themes[$themeChoice - 1]
        if (Set-YasbTheme -ThemeName $selected) {
            Write-Host "✅ Theme applied successfully!" -ForegroundColor Green
            Set-Wallpaper -ThemeName $selected
        }
    }
}

<#
.SYNOPSIS
    Launches the interactive YASB Theme Manager.

.DESCRIPTION
    Starts the main menu loop allowing users to load, save, create, or delete YASB themes.

.EXAMPLE
    Start-YasbThemeChanger
#>
function Start-YasbThemeChanger {
    Clear-Host

    if (-not (Get-Command yasbc -ErrorAction SilentlyContinue)) {
        Write-Host "❌ 'yasbc' command not found. Please ensure YASB is installed and added to PATH." -ForegroundColor Red
        return
    }

    while ($true) {
        Get-YasbMenu
        $choice = Read-Host "Enter choice (1-5) or 'q' to quit"
        
        switch ($choice) {
            'q' { return }
            '1' {
                Clear-Host
                Invoke-YasbThemeLoad
                Start-Sleep -Seconds 2.5
                Clear-Host
            }
            '2' {
                Clear-Host
                Save-CurrentTheme
                Start-Sleep -Seconds 2.5
                Clear-Host
            }
            '3' {
                Clear-Host
                New-YasbTheme
                Start-Sleep -Seconds 2.5
                Clear-Host
            }
            '4' {
                Clear-Host
                Remove-YasbTheme
                Start-Sleep -Seconds 2.5
                Clear-Host
            }
            '5' {
                Clear-Host
                Reset-YasbConfig
                Start-Sleep -Seconds 2.5
                Clear-Host
            }
            default {
                Write-Host "❌ Invalid choice" -ForegroundColor Red
                Start-Sleep -Seconds 1
                Clear-Host
            }
        }
    }
}



Start-YasbThemeChanger