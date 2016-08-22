$banner = "
 NO MORE INTERNET EXPLODER"
$loop = "True"
while ($loop){
    clear
    $banner
    $menu1 = read-host `n "CAUTION! This script creates a joke shortcut on the Desktop of the current user
 and then downloads and installs the browser of your choice.

 Press [Y] to continue or [N] to quit "
    $menu1 = $menu1.ToUpper()
    if ($menu1 -eq 'Y') {
        clear
        $banner
        # Source icon is stored on a private dropbox account and shared publicly.
        $iconSource = "https://db.tt/RHDIrSzY"
        $iconDestination = "c:\internetexploder.ico"
        # The 'Invoke-WebRequest' cmdlt was used here to demonstrate it's capabilities.
        # Not suitable for larger downloads as it is too slow. eg. Firefox and Chrome
        Invoke-WebRequest $iconSource -OutFile $iconDestination
        $createShortcut = New-Object -comObject WScript.Shell
        $shortcut = $createShortcut.CreateShortcut("$HOME\Desktop\Internet Exploder.lnk")
        $shortcut.TargetPath = "C:\Program Files (x86)\Internet Explorer\iexplore.exe"
        $shortcut.IconLocation = "C:\internetexploder.ico"
        $shortcut.Save()
        # The 'Get-WmiObject' cmdlt only returns software installed from a .MSI file.
        $browserCheck = Get-WmiObject win32_product | Select-Object -Property name | Where-Object {$PSItem -Like "*google*" -or $PSItem -like "*firefox*" -or $PSItem -like "*chrome*"}
        if ($browserCheck) {
            " Firefox or Chrome already installed..."
            Start-Sleep -Seconds 2
            clear
            exit
            }
        else {
            $menu2 = read-host " Please choose between Chrome[1] or Firefox[2]"
            if ($menu2 -eq '1'){
                " Installing Google Chrome, Please wait..."
                (New-Object System.Net.WebClient).DownloadFile("https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BE59114B1-70A7-8203-B91A-E570E5565389%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable/dl/chrome/install/googlechromestandaloneenterprise64.msi", "c:\chromeinstall.msi")
                Start-Process 'c:\chromeinstall.msi' /q -wait
                " Done! :)"
                pause
                exit
                }
            else {
                " Installing Mozilla Firefox, Please wait..."
                # Download source is a repository of Firefox .MSI installs.
                # Mozilla only provide .EXE installation packages.
                (New-Object System.Net.WebClient).DownloadFile("http://hicap.frontmotion.com.s3.amazonaws.com/Firefox/Firefox-38.0.5/Firefox-38.0.5-en-US.msi", "c:\firefoxinstall.msi")
                Start-Process 'c:\firefoxinstall.msi' /q -wait
                " Done! :)"
                pause
                exit
                }
                }
                }
        elseif ($menu1 -eq 'N') {
            clear
            exit
            }
        else {
            " Please enter either [Y] or [N]!"
            start-sleep -Seconds 1
            clear
            }
            }
