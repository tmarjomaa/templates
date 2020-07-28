# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"UKRegion.xml`""
 
# Set Timezone
& tzutil /s "GMT Standard Time"
 
# Set languages/culture
Set-Culture en-GB
Restart-Computer
