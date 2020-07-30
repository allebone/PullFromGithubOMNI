#Prerequisite: PS> Install-Module -Name 'IISAdministration'

#Jacob -- Doublecheck me on:

#1. Case Sensitivity of the Drive File Destinations (C: versus c:)
#2. Name of IIS Site. I said "Help" But I dont remember.
#3. IISAdministration PS Extension

#Nick -- Find out what the F5 Timeout for "Health" is for Help. I'd love to prevent downtime everytime this runs. 
#If the polling is low enough, then we can avoid a downtime, while its copying. Maybe we can set the script to run more often, and spread it out across servers.

$browser = New-Object System.Net.WebClient
$browser.Proxy.Credentials =[System.Net.CredentialCache]::DefaultNetworkCredentials 

$url = "https://github.com/allebone/help.omni.af.mil/archive/gh-pages.zip"
$output = "c:\Temp\master.zip"

Invoke-WebRequest -Uri $url -OutFile $output

Stop-IISSite -Name "Help"

Remove-Item –path c:\Help\*

Expand-Archive -Force -LiteralPath C:\Temp\master.zip -DestinationPath c:\Help

Remove-Item -path c:\Temp\master.zip 

Start-IISSite -Name "Help"
