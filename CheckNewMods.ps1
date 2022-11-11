<#
	Arma 3 Steam Workshop Content Downloader
	Created by: Brian Hill
	
		• Requires Arma 3 Dedicated Server files to be downloaded
		• Requires SteamCMD - https://developer.valvesoftware.com/wiki/SteamCMD
		• Customize the directory locations for your server
		• Add to the list of MOD's you wish to download from the Steam Workshop
#>

# Directory Locations
$steamcmdpath = "C:\steamcmd\"  # Location of SteamCMD folder
$a3folder = "C:\Games\Arma3\A3Master\"  # Location of Arma 3 server folder
$cmdlog = "C:\steamcmd\logs\workshop_log.txt"

# Steam Workshop Items To Download
$mods = @(
	# Create a new line for each mod
	# 'modName' = folder name to install mod into
	# 'modID' = ID of workshop item, can be found in the URL. Eg: https://steamcommunity.com/workshop/filedetails/?id=450814997
	# 'download' = true/false. False will skip downloading the mod.
	
	<#  Framework / Utility MOD's  #>
	[pscustomobject]@{modName='@cba_a3';modID='450814997';download='true'}
	#[pscustomobject]@{modName='@ace3';modID='463939057';download='true'}
	#[pscustomobject]@{modName='@task_force_beta';modID='894678801';download='true'}
	[pscustomobject]@{modName='@Enhanced_Movement';modID='333310405';download='true'}
	[pscustomobject]@{modName='@discord';modID='1493485159';download='true'}

	[pscustomobject]@{modName='@IMS';modID='2291129343';download='true'}
	[pscustomobject]@{modName='@WebKnightZaC';modID='2789152015';download='true'}
	#[pscustomobject]@{modName='@WMO';modID='925018569';download='true'}
	#[pscustomobject]@{modName='@FR';modID='2877562125';download='true'}
	[pscustomobject]@{modName='@EMRework';modID='2034363662';download='true'}
	#[pscustomobject]@{modName='@BrighterFlares';modID='2095827925';download='true'}
	
	<#  Weapons / Vehicles / Uniforms / Equipment MOD's  #>
	#[pscustomobject]@{modName='@RHSAFRF';modID='843425103';download='false'}
	#[pscustomobject]@{modName='@RHSUSAF';modID='843577117';download='false'}
	#[pscustomobject]@{modName='@RHSGREF';modID='843593391';download='false'}
	#[pscustomobject]@{modName='@RHSSAF';modID='843632231';download='false'}
	
	<#  Terrain MOD's  #>
	#[pscustomobject]@{modName='@Cup_Terrains_Core';modID='583496184';download='false'}
	#[pscustomobject]@{modName='@Cup_Terrains_Maps';modID='583544987';download='false'}
	#[pscustomobject]@{modName='@Taviana';modID='1333620906';download='false'}
	#[pscustomobject]@{modName='@Kujari';modID='1726494027';download='false'}
	#[pscustomobject]@{modName='@Beketov';modID='743968516';download='false'}
	
	<#  Scenario / Mission MOD's  #>
	#[pscustomobject]@{modName='@Vindicta';modID='2185874952';download='false'}
	
	<#  Miscellaneous MOD's  #>
	#[pscustomobject]@{modName='@FileXT';modID='2162811561';download='false'}
)

<#################################################################################
			DO NOT MODIFY BELOW
#################################################################################>

# Steam Credentials
$username = "YOURSTEAMLOGIN"
$password = "YOURSTEAMPASS"

$steamcmd = Join-Path -Path $steamcmdpath -ChildPath "\steamcmd.exe"

$modslocation = Join-Path -Path $steamcmdpath -ChildPath "\steamapps\workshop\content\107410\"

foreach ($mod in $mods) {
	
	if ($mod[0].download -eq "true") {
		WRITE-HOST ""
		WRITE-HOST 'Downloading' $mod[0].modName '(ID:'$mod[0].modID')'
		WRITE-HOST ""
		#& $steamcmd '+login' $username $password '+"workshop_download_item 107410'$mod[0].modID'validate +quit"'
		#Stop-Process

		& $steamcmd '+login' $username $password '+"workshop_download_item 107410'$mod[0].modID'validate +quit"'

		WRITE-HOST ""
		WRITE-HOST "Finished downloading" $mod[0].modName
		WRITE-HOST ""
		WRITE-HOST "Creating symlink to mod in server folder"
		# Create symlink from download location to server folder
		$sourcedir = Join-Path -Path $modslocation -ChildPath $mod[0].modID
		$destdir = Join-Path -Path "$a3folder/mods" -ChildPath $mod[0].modName
		cmd "/c mklink /D $destdir $sourcedir"
		
		WRITE-HOST ""
		
		# Copy bikey file to server's keys folder
		$keysource = Join-Path -Path $modslocation -ChildPath $mod[0].modID
		$keydest = Join-Path -Path $a3folder -ChildPath "keys"
		$bikeypath = Get-ChildItem -Path $keysource -Recurse -Filter *.bikey
		$existKeys = Get-ChildItem -Path $keydest -Recurse -Filter *.bikey
		if ($bikeypath.Name -in $existKeys.Name) {
			Write-Host ".bikey already in folder"
		}
		else {
			Write-Host "Copying .bikey file to server's keys folder"
			Copy-Item -Path $bikeypath.FullName -Destination $keydest
		}
	}

}

$cmdlogcontent = Get-Content $cmdlog