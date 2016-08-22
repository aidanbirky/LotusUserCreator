#Title: LocalHost HTML Report Generator
#Description: This script generates a simple HTML report on the local system.
#Description: It creates a zip file containing the report in the users home directory.
#Description: For best results, run as administrator

clear
$ScriptUser = Read-Host -Prompt 'Enter your name to continue'
clear
write-host "Please wait... "
$folderDateTime = (get-date).ToString('d-M-y HHmmss')
$userDir = (Get-ChildItem env:\userprofile).value + '\LocalHost Report ' + $folderDateTime

$fileSaveDir = New-Item  ($userDir) -ItemType Directory
$date = get-date

$style = "<style> table td{padding-right: 10px;text-align: left;}#body {padding:50px;font-family: Helvetica; font-size: 9pt; border: 10px solid black;background-color:white;height:100%;overflow:auto;}#left{float:left; background-color:#C0C0C0;width:45%;height:400px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#right{background-color:#C0C0C0;float:right;width:45%;height:400px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#center{background-color:#C0C0C0;width:98%;height:300px;border: 4px solid black;padding:10px;overflow:scroll;margin:10px;} </style>"

$Report = ConvertTo-Html -Title 'LocalHost Report' -Head $style > $fileSaveDir'/LocalHostReport.html'
$Report = $Report +"<div id=body><h1>LocalHost  Report</h1><hr size=2><br><h3> Generated on: $Date by $ScriptUser </h3><br>"

$SysBootTime = Get-WmiObject Win32_OperatingSystem
$BootTime = $SysBootTime.ConvertToDateTime($SysBootTime.LastBootUpTime)| ConvertTo-Html datetime
$SysSerialNo = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME)
$SerialNo = $SysSerialNo.SerialNumber
$SysInfo = Get-WmiObject -class Win32_ComputerSystem -namespace root/CIMV2 | Select Manufacturer,Model
$SysManufacturer = $SysInfo.Manufacturer
$SysModel = $SysInfo.Model
$OS = (Get-WmiObject Win32_OperatingSystem -computername $env:COMPUTERNAME ).caption
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$HD = [math]::truncate($disk.Size / 1GB)
$FreeSpace = [math]::truncate($disk.FreeSpace / 1GB)
$SysRam = Get-WmiObject -Class Win32_OperatingSystem -computername $env:COMPUTERNAME | Select  TotalVisibleMemorySize
$Ram = [Math]::Round($SysRam.TotalVisibleMemorySize/1024KB)
$SysCpu = Get-WmiObject Win32_Processor | Select Name
$Cpu = $SysCpu.Name
$HardSerial = Get-WMIObject Win32_BIOS -Computer $env:COMPUTERNAME | select SerialNumber
$HardSerialNo = $HardSerial.SerialNumber
$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select Name
$Firewall = New-Object -com HNetCfg.FwMgr
$FireProfile = $Firewall.LocalPolicy.CurrentProfile
$FireProfile = $FireProfile.FirewallEnabled

## Get-Netstat function written by Kevin Kirkpatrick aka. vScripter
## Creates powershell objects from netstat output.
## https://gist.github.com/vScripter/add54f2af5c16c1f1d56
function Get-NetStat
{
	[cmdletbinding()]
	param (
		[parameter(Mandatory = $false,
				   Position = 0,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({ Test-Connection -ComputerName $_ -Count 2 -Quiet })]
		[string]$ComputerName = 'localhost'
	)

	BEGIN
	{
		if ($ComputerName -eq 'localhost')
		{
			$NetStat = netstat.exe -an
		} else
		{
			$NetStat = Invoke-Command -ComputerName $ComputerName -ScriptBlock { netstat.exe -an }
		}# end if/else
	}# end BEGIN

	PROCESS
	{

		# Keep only the line with the data (we remove the first lines)
		$NetStat = $NetStat[4..$NetStat.count]

		# Each line need to be splitted and get rid of unnecessary spaces
		foreach ($line in $NetStat)
		{
			# Get rid of the first whitespaces, at the beginning of the line
			$line = $line -replace '^\s+', ''

			# Split each property on whitespaces block
			$line = $line -split '\s+'

			# Define the properties
			$properties = @{
				Protocole = $line[0]
				LocalAddressIP = ($line[1] -split ":")[0]
				LocalAddressPort = ($line[1] -split ":")[1]
				ForeignAddressIP = ($line[2] -split ":")[0]
				ForeignAddressPort = ($line[2] -split ":")[1]
				State = $line[3]
			}

			# Output the current line
			New-Object -TypeName PSObject -Property $properties

		}# end foreach
	}# end PROCESS
}# end function Get-NetStat

$ListeningPorts = Get-NetStat | ConvertTo-Html


$Report = $Report  + "<div id=left><h3>Computer Information</h3><br><table><tr><td>Operating System</td><td>$OS</td></tr><tr><td>OS Serial Number:</td><td>$SerialNo</td></tr><tr><td>Current User:</td><td>$env:USERNAME </td></tr><tr><td>System Uptime:</td><td>$BootTime</td></tr><tr><td>System Manufacturer:</td><td>$SysManufacturer</td></tr><tr><td>System Model:</td><td>$SysModel</td></tr><tr><td>Serial Number:</td><td>$HardSerialNo</td></tr><tr><td>Firewall is Active:</td><td>$FireProfile</td></tr><tr><td>Listening Ports:</td><td>$ListeningPorts</td></tr></table></div><div id=right><h3>Hardware Information</h3><table><tr><td>Hardrive Size:</td><td>$HD GB</td></tr><tr><td>Hardrive Free Space:</td><td>$FreeSpace GB</td></tr><tr><td>System RAM:</td><td>$Ram GB</td></tr><tr><td>Processor:</td><td>$Cpu</td></tr><td>"

$UserInfo = Get-WmiObject -class Win32_UserAccount -namespace root/CIMV2 | Where-Object {$_.Name -eq $env:UserName}| Select AccountType,SID,PasswordRequired
$UserType = $UserInfo.AccountType
$UserSid = $UserInfo.SID
$UserPass = $UserInfo.PasswordRequired
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')

$Report =  $Report +"<div id=left><h3>User Information</h3><br><table><tr><td>Current User Name:</td><td>$env:USERNAME</td></tr><tr><td>Account Type:</td><td> $UserType</td></tr><tr><td>User SID:</td><td>$UserSid</td></tr><tr><td>Account Domain:</td><td>$env:USERDOMAIN</td></tr><tr><td>Password Required:</td><td>$UserPass</td></tr><tr><td>Current User is Admin:</td><td>$IsAdmin</td></tr></table>"
$Report = $Report + '</div>'
$Report =  $Report + '<div id=center><h3>Network Information</h3>'
$Report =  $Report + (Get-WmiObject Win32_NetworkAdapterConfiguration -filter 'IPEnabled= True' | Select Description,DNSHostname, @{Name='IP Address ';Expression={$_.IPAddress}}, MACAddress | ConvertTo-Html)
$Report = $Report + '</table></div>'
$Report >> $fileSaveDir'/LocalHostReport.html'

function copy-ToZip($fileSaveDir){

    $srcdir = $fileSaveDir
    $zipFile = (Get-ChildItem env:\userprofile).value + '\LocalHostReport.zip'

    if(-not (test-path($zipFile))) {
        set-content $zipFile ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
        (dir $zipFile).IsReadOnly = $false}

    $shellApplication = new-object -com shell.application

    $zipPackage = $shellApplication.NameSpace($zipFile)
    $files = Get-ChildItem -Path $srcdir

    foreach($file in $files) {

        $zipPackage.CopyHere($file.FullName)

        while($zipPackage.Items().Item($file.name) -eq $null){

            Start-sleep -seconds 1 }}}

copy-ToZip($fileSaveDir)
#remove-item $fileSaveDir -recurse
#Remove-Item $MyINvocation.InvocationName
clear
write-host "Script complete"

## Self-signed certificate how-to
## http://www.darkoperator.com/blog/2013/3/5/powershell-basics-execution-policy-part-1.html
