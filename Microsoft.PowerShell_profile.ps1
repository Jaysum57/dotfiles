$env:PYTHONIOENCODING="utf-8"


# ---------------------------------------------------------------------------- #
#                                General config                                #
# ---------------------------------------------------------------------------- #
$ShowAsciiArt = $false



# ---------------------------------------------------------------------------- #
#                                    Modules                                   #
# ---------------------------------------------------------------------------- #
Import-Module -Name Terminal-Icons

Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView 


# ---------------------------------------------------------------------------- #
#                                    Scripts                                   #
# ---------------------------------------------------------------------------- #
winfetch


# ---------------------------------------------------------------------------- #
#                                   Aliases                                    #
# ---------------------------------------------------------------------------- #
iex "$(thefuck --alias)"

# ---------------------------------------------------------------------------- #
#                                   Functions                                  #
# ---------------------------------------------------------------------------- #
function dotfiles {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME $args
}

function dotfiles-status { dotfiles status }
function dotfiles-add { dotfiles add $args; dotfiles status }
function dotfiles-commit { dotfiles commit -m $args }
function dotfiles-push { dotfiles push origin main }
function dotfiles-pull { dotfiles pull origin main }
function dotfiles-diff { dotfiles diff }

function dotfiles-track {
    param([string]$File)
    $FullPath = (Resolve-Path $File).Path
    $RelativePath = $FullPath.Replace("$HOME/", "").Replace("$HOME\", "")
    Write-Host "Tracking: $RelativePath" -ForegroundColor Green
    dotfiles add $RelativePath
    dotfiles status
}

function nav {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        cd $Path
        ls
    } else {
        Write-Host "❌ Path not found: $Path" -ForegroundColor Red
    }
}

# ------------------------------- yazi function ------------------------------ #
function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}


# ---------------------------------------------------------------------------- #
#                                   ohmyposh                                   #
# ---------------------------------------------------------------------------- #
oh-my-posh init pwsh --config '~/.config/amro-jaysum.omp.json' | Invoke-Expression


# ---------------------------------------------------------------------------- #
#                       Custom ASCII Art Welcome Message                       #
# ---------------------------------------------------------------------------- #

$asciiArt = @"
Welcome back,
 ┏┓┏━┓╻ ╻┏━┓╻ ╻┏┳┓
  ┃┣━┫┗┳┛┗━┓┃ ┃┃┃┃
┗━┛╹ ╹ ╹ ┗━┛┗━┛╹ ╹ 
"@

<#  centers the ASCII art based on console width

$consoleWidth = [Console]::WindowWidth
$lines = $asciiArt -split "`n"

foreach ($line in $lines) {
    $padding = " " * [Math]::Max(0, $consoleWidth - $line.Length)
    Write-Host "$padding$line"
}

#>

# TOGGLE DISPLAY
If ($ShowAsciiArt) {
    Write-Host "$asciiArt"
} 
