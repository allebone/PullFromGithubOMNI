#Prerequisite: PS> Install-Module -Name 'IISAdministration'

#Jacob -- Doublecheck me on:

#1. Case Sensitivity of the Drive File Destinations (C: versus c:) "Drive labels are not case sensitive on windows." -J
#2. Name of IIS Site. I said "Help" But I dont remember.
#3. IISAdministration PS Extension

#Nick -- Find out what the F5 Timeout for "Health" is for Help. I'd love to prevent downtime everytime this runs. 
#If the polling is low enough, then we can avoid a downtime, while its copying. Maybe we can set the script to run more often, and spread it out across servers.

<#
We probably don't want to continue if we run into an error since running into an error while downloading
the zip file would just delete the website.
#>
$ErrorActionPreference = 'Stop'


#Set Up Variables----------------------------------------------------------------------------------

#URL to download website source archive.
$sourceURL = 'https://github.com/allebone/help.omni.af.mil/archive/gh-pages.zip'
#Path to download the website source archive to.
$archivePath = Join-Path -Path $env:TEMP -ChildPath 'helpMaster.zip'
#Staging directory to unZip website source archive to.
$siteStagingDirectory = Join-Path -Path $env:SystemDrive -ChildPath 'Help_Staging'
#Final directory of the Help site files.
$siteDirectory = Join-Path -Path $env:SystemDrive -ChildPath 'Help'

#Clean-Up In Case the Script Failed last time------------------------------------------------------

#Delete the archive. If it doesn't exist, continue regardless.
Remove-Item -path $archivePath -ErrorAction SilentlyContinue
#Delete the entire help site staging directory. If it doesn't exist, continue regardless.
Remove-Item -path $siteStagingDirectory -Recurse -ErrorAction SilentlyContinue


#Download and Deploy Website-----------------------------------------------------------------------

#Build web client
$browser = New-Object System.Net.WebClient
$browser.Proxy.Credentials =[System.Net.CredentialCache]::DefaultNetworkCredentials 

#Download website source archive to $archivePath
Invoke-WebRequest -Uri $sourceURL -OutFile $archivePath
#UnZip the website source archive: $archivePath to the staging directory: $siteStagingDirectory
Expand-Archive -Force -LiteralPath $archivePath -DestinationPath $siteStagingDirectory

#The zip contains a folder, so when we unzip need to move everything up one folder level.
Get-Item -Path $siteStagingDirectory | Get-ChildItem | Get-ChildItem | Move-Item -Destination $siteStagingDirectory -Force

#Stop the Help website so the files are not in use.
Stop-IISSite -Name 'Help'

#Delete the entire help site directory. If it doesn't exist, continue regardless.
Remove-Item -path $siteDirectory -Recurse -ErrorAction SilentlyContinue
#Rename the staging directrory to the final directory.
Rename-Item -Path $siteStagingDirectory -NewName (Split-Path $siteDirectory -Leaf)


#Clean-Up Actions----------------------------------------------------------------------------------

#Delete the archive.
Remove-Item -path $archivePath -ErrorAction SilentlyContinue
#Restart the site.
Start-IISSite -Name 'Help'