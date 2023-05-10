<# 
This is a script that I wrote to automate the process of freeing up disk space on student lab machines.
When the disk is full on these machines, it makes it so new users are unable to log in and users that are able to log in can't save any files locally.
The script accomplishes this by deleting everything in the appdata\Local\Temp folder and appdata\local\Microsoft\Edge\User Data\ folders for all users.
It also gets a list of installed non-default Microsoft Store apps for all users and uninstalls them.
This usually leaves the machine with around 40 - 50 GB of free disk space.
#>

# Variable declaration
$Adobe = 'Adobe';
$Apple = '5BD5593D-A41B-4F89-884E-B4F3E0FBAA75';
$Canon = '41BAE105-1234-432C-A39C-1B7D1C24232B';
$HP = 'ED346674-0FA1-4272-85CE-3187C9C86E26';
$Intel = 'EB51A5DA-0E72-4863-82E4-EA21C1F8DFE3';
$Microsoft = 'Microsoft';
$Slack = 'B25A2379-D5D0-455B-826A-BFFC7EBB5713';
$WavesAudio = '301D3577-3436-422A-B01E-1170ED4BB3DE';

$PublisherIDs = "$($Adobe)|$($Apple)|$($Canon)|$($HP)|$($Intel)|$($Microsoft)|$($Slack)|$($WavesAudio)";

$TempFolderPath = 'C:\Users\*\AppData\Local\Temp\*';
$EdgeUserDataFolderPath = 'C:\Users\*\AppData\Local\Microsoft\Edge\User Data\*';

# Gets the path to the Temp folder for all users and forcibly and recursivly deletes them without user confirmation.
function Clear-AllUsersTempFolders {
    Get-Item -Path $TempFolderPath | Remove-Item -ErrorAction SilentlyContinue -Recurse -Force -Confirm:$false;
}

# Gets the path to the Microsoft Edge User Data folder for all users and forcibly and recursivly deletes them without user confirmation.
function Clear-AllUsersEdgeUserDataFolders {
    Get-Item -Path $EdgeUserDataFolderPath | Remove-Item -ErrorAction SilentlyContinue -Recurse -Force -Confirm:$false;
}

# Gets a list of currently installed non-default Microsoft Store apps for all users, writes them to the console, and uninstalls them.
function Uninstall-AllUsersNonDefaultMicrosoftStoreApps {
    # Internal variable declaration
    $NonDefaultMicrosoftStoreApps = Get-AppxPackage -AllUsers | Where-Object { $_.publisher -notmatch $PublisherIDs }
    
    # Write the list of currently installed non-default Microsoft Store apps for all users.
    $NonDefaultMicrosoftStoreApps | Select-Object Name, PackageFullName, Publisher, PackageUserInformation;

    # Uninstalls all currently installed non-default Microsoft Store apps for all users.
    # $NonDefaultMicrosoftStoreApps | Remove-AppxPackage -AllUsers;
}

# Write to the console to provide script status.
Write-Output "`nDeleting all user temp folders...`n";

Clear-AllUsersTempFolders;

# Write to the console to provide script status.
Write-Output "Deleting all user Edge User Data folders...`n";

Clear-AllUsersEdgeUserDataFolders;

# Write to the console to provide script status.
Write-Output "The following non-default Microsoft Store apps were installed and have been removed:`n";

Uninstall-AllUsersNonDefaultMicrosoftStoreApps;