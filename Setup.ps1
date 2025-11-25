<#
 ┏┓┏━┓╻ ╻┏━┓╻ ╻┏┳┓╻┏━┓
  ┃┣━┫┗┳┛┗━┓┃ ┃┃┃┃ ┗━┓
┗━┛╹ ╹ ╹ ┗━┛┗━┛╹ ╹ ┗━┛
╺┳┓┏━┓╺┳╸┏━╸╻╻  ┏━╸┏━┓
 ┃┃┃ ┃ ┃ ┣╸ ┃┃  ┣╸ ┗━┓
╺┻┛┗━┛ ╹ ╹  ╹┗━╸┗━╸┗━┛

This setup script is a fork from Scott McKendry's windots repository.         

NOTE: Elevated permissions are required to create symbolic links.      
      Run PowerShell as Administrator to execute this script.
#>


#Requires -RunAsAdministrator
#Requires -Version 7

# Linked Files (Destination => Source)
$symlinks = @{
  $PROFILE                                                                                        = ".\Microsoft.PowerShell_profile.ps1"
  "$HOME\.config\yasb"                                                                            = ".\yasb\"  
  "$HOME\AppData\Local\nvim"                                                                      = ".\nvim"
  "$HOME\AppData\Local\fastfetch"                                                                 = ".\fastfetch"
  "$HOME\AppData\Local\k9s"                                                                       = ".\k9s"
  "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\windowsterminal\settings.json"
  "$HOME\.gitconfig"                                                                              = ".\.gitconfig"
  "$HOME\AppData\Roaming\lazygit"                                                                 = ".\lazygit"
  "$HOME\AppData\Roaming\AltSnap\AltSnap.ini"                                                     = ".\altsnap\AltSnap.ini"
  "$HOME\AppData\Roaming\yazi\config"                                                             = ".\yazi\config"
}

# Winget dependencies

## Tentative Winget packages
# * "sst.opencode" - opencode is an AI coding agent built for the terminal.
# * "ezwinports.make" - ezwinports Ports of Unix and GNU software to MS-Windows 
# * "kitware.cmake" - CMake is an open-source, cross-platform family of tools designed to build, test and package software
# * "eza-community.eza" - eza is a modern replacement for ls written in Rust

$wingetDeps = @(
  "chocolatey.chocolatey"
  "fastfetch-cli.fastfetch"
  "git.git"
  "github.cli"
  "microsoft.powershell"
  "neovim.neovim"
  "openjs.nodejs"
  "starship.starship"
  "task.task"
)

# Chocolatey dependencies

$chocoDeps = @(
  "altsnap"
  "bat"
  "lazygit"
  "nerd-fonts-jetbrainsmono"
  "sqlite"
  "zig"
)

# ! SCOOP INSTALLATION STEPS !
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# `scoop bucket add extras`
# this adds the extras bucket which contains some of the packages we want

# Scoop dependencies
# TODO:
# * WRITE SCOOP INSTALLATION LOGIC 
# * MAKE SYMLINK FOR YAZI CONFIG IN ~\.config\yazi
# * ADD FFMPEG TO ENV PATH

$scoopDeps = @(
  "extras/windhawk"
  "extras/pipes-rs"
  "yazi"   
  "ffmpeg" 
  "7zip" 
  "jq" 
  "poppler" 
  "fd" 
  "ripgrep" 
  "fzf" 
  "zoxide" 
  "resvg" 
  "imagemagick"
)

# PS Modules
$psModules = @(
  "CompletionPredictor"
  "PSScriptAnalyzer"
  "ps-arch-wsl"
  "ps-color-scripts"
)


# Set custom Yazi config path
# Set the persistent User environment variable
[Environment]::SetEnvironmentVariable(
    "YAZI_CONFIG_HOME",
    "$env:USERPROFILE\.config\yazi",
    "User"
)

Write-Host "Set YAZI_CONFIG_HOME to $YaziCustomConfigPath for the current user."
# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot


# Install winget packages 
Write-Host "Installing missing dependencies..."
$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
  if ($installedWingetDeps -notmatch $wingetDep) {
    winget install --id $wingetDep
  }
}

# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")


# Install choco packages
$installedChocoDeps = (choco list --limit-output --id-only).Split("`n")
foreach ($chocoDep in $chocoDeps) {
  if ($installedChocoDeps -notcontains $chocoDep) {
    choco install $chocoDep -y
  }
}

# Install PS Modules
foreach ($psModule in $psModules) {
  if (!(Get-Module -ListAvailable -Name $psModule)) {
    Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser
  }
}

# Persist Environment Variables
# [System.Environment]::SetEnvironmentVariable('WEZTERM_CONFIG_FILE', "$PSScriptRoot\wezterm\wezterm.lua", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', "C:\Program Files\Git\usr\bin\file.exe", [System.EnvironmentVariableTarget]::User)


$currentGitEmail = (git config --global user.email)
$currentGitName = (git config --global user.name)


# TODO: 
# * Ensure that the target directories exist before creating symlinks
# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symlinks.GetEnumerator()) {
  Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}

git config --global --unset user.email | Out-Null
git config --global --unset user.name | Out-Null
git config --global user.email $currentGitEmail | Out-Null
git config --global user.name $currentGitName | Out-Null

# Install bat themes
bat cache --clear
bat cache --build

.\altsnap\createTask.ps1 | Out-Null