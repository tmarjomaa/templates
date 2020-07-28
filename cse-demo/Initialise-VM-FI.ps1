# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"FIRegion.xml`""
 
# Set Timezone
& tzutil /s "FLE Standard Time"
 
# Set languages/culture
Set-Culture fi-FI
Restart-Computer
