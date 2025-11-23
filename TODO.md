# TO DO:

- make bat/shell script for installing winget packages
- make bat/shell script for choosing themes 
- ✅ move themes in a dedicated 'themes' folder
- **flow 1**:
  - Read folder name in themes folder
  - print all themes
  - get feedback from user
  - *copy theme folder files*
  - *replace files in .config with copied files*
      - directory: `.config/yasb/config.yaml`
- **flow 2**:
  - Read folder name in themes folder
  - print all themes
  - get feedback from user
  - *Set yasb home directory instead*
    - https://github.com/amnweb/yasb/wiki/FAQ#q-how-to-set-custom-configuration-directory 
  - Add dev folder and quick access users/Jaysum



# Download Applications List

## PowershellGallery
- **Terminal Icons** - `Install-Module -Name Terminal-Icons -Repository PSGallery`


## Winget packages
1. **Komorebi**
- `set-itemproperty 'hklm:\system\currentcontrolset\control\filesystem' -name 'longpathsenabled' -value 1`
  - enables support for long paths in windows
- `winget install lgug2z.komorebi1 lgug2z.whkd`
  - downloads komorebi and whkd through winget
- `komorebic fetch-asc`
  - downloads latest application specific configurations

**Yasb** 
- `winget install --id AmN.yasb`
  - install yasb through winget 

**Windhawk**
- `winget install --id=RamenSoftware.Windhawk  -e`




## Checklist
- [ ] ⭐**Zen Browser**
	`winget install --id=Zen-Team.Zen-Browser  -e`

- [ ] **Altsnap**
	`winget install --id=AltSnap.AltSnap  -e`

- [ ] ⭐Ohmyposh
	- *with config*
	``	
- [ ] Playnite
- [ ] ⭐Anki
- [ ] Bloxstrap
- [ ] Canva
- [ ] Itchio
- [ ] ⭐ShareX
- [ ] Obsidian
- [ ] Jdownloader2
- [ ] ⭐Komorebi
- [ ] ⭐Yasb
- [ ] MPV (will not do)
- [ ] ⭐Powertoys
- [ ] Stremio
- [ ] ⭐Yt-dlp
- [ ] ⭐FFMPEG
- [x] Pdfarranger
- [ ] Wiztree
- [x] Geek.exe
- [x] ⭐BitwardenCLI
- [x] ⭐Flow launcher
- [ ] ⭐Everything
- [ ] ⭐winrar
- [ ] Proton VPN
- [ ] VLC
- [ ] Windhawk
- [x] Legcord
# Programming 

- [ ] ⭐python 
- [ ] lua
- [ ] rust
- [ ] Git
- [ ] vscode
- [ ] neovim

# Games

- [ ] Minecraft
- [ ] 


# For consideration:

[JPEGview](https://sourceforge.net/projects/jpegview/) - Fastest image viewer I've encountered.