# Set Locale, language etc.
Set-WinLanguageBarOption -UseLegacySwitchMode -UseLegacyLanguageBar
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"FIRegion.xml`""
Set-WinLanguageBarOption

# Set Timezone
& tzutil /s "FLE Standard Time"
 
# Set languages/culture
Set-Culture fi-FI
Restart-Computer
