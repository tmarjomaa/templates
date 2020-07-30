# Set Locale, language etc.
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"FIRegion.xml`""

# Set Timezone
& tzutil /s "FLE Standard Time"
 
# Set languages/culture
Set-Culture fi-FI

#Set Welcome Screen Input
New-Item -Path "REGISTRY::HKEY_USERS\.DEFAULT\Keyboard Layout" -Force | Out-File c:\a.txt
New-Item -Path "REGISTRY::HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -Force | Out-File c:\b.txt
New-Item -Path "REGISTRY::HKEY_USERS\.DEFAULT\Keyboard Layout\Substitutes" -Force | Out-File c:\s.txt
New-ItemProperty -Path "REGISTRY::HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -Name "1" -Value "0000040b" -PropertyType String -Force | Out-File c:\c.txt
New-ItemProperty -Path "REGISTRY::HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -Name "4" -Value "0000040b" -PropertyType String -Force | Out-File c:\d.txt

# Restart-Computer
