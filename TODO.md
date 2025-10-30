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



# Download Applications List

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
