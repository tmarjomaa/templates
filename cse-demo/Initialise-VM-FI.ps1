# Set Locale, language etc.
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"FIRegion.xml`""

# Set Timezone
& tzutil /s "FLE Standard Time"
 
# Set languages/culture
Set-Culture fi-FI

#Set Welcome Screen Input
New-ItemProperty -Path "REGISTRY::HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -Name "1" -Value "0000040b" -PropertyType String -Force

Restart-Computer
