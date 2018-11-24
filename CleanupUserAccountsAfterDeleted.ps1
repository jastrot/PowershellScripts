# Create Global Variables - Begin
$BACKUPLOC = "C:\ZipBackup"

# Create Global Variables - End

# Begin Direction Creation
# Check to see if C:\ZipBackup Exists, if not then create directory
if (Test-Path $BACKUPLOC) {
    # If path exists then do nothing and proceed
} else {
    New-Item -ItemType Directory -Path $BACKUPLOC
}
# End Directory Creation

# Begin Registry Backup
# Backup Registry to C:\ZipBackup before we remove items. /Y means to just overwrite the file if it already exists
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" "$BACKUPLOC\ProfileListBackup.reg" /y
# End Registry Backup 

# Begin Registry User Account Listing 
# Get listing of User Accounts that have signed into the PC (HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21*\ProfileImagePath)
# Create an array of user profile paths
#$REGUSERS = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21*" -Name "ProfileImagePath").ProfileImagePath
$REGUSERS = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21*" -Name "ProfileImagePath")
# End Registry User Account Listing

# Begin Computer User Account Listing
# Get listing of user accounts in C:\users
$COMPUSERS = (Get-ItemProperty -Path "C:\users\*" -Name "Name").name
# End Computer User Account Listing

# Begin Registry User Check
# Check to see if the ProfileImagePath matches one of the comp user accounts.
## If the registry user path matches a path in C:\users, then keep the registry key and keep the user folder in C:\users
## If the registry user path does not match a path in C:\users, then delete the registry key entirely
foreach ( $REGUSER in $REGUSERS ) {
    if (Test-Path $REGUSER.ProfileImagePath) {
        # User Profile Path DOES Exist
        # Leave registry key alone as well as path in C:\users
    } else {
        # User Profile Path does NOT Exist
        Write-Host Removing $REGUSER.PSPath
        Remove-Item -Path $REGUSER.PSPath
        #Write-Host Will remove: $REGUSER.ProfileImagePath
    }
}

Write-Host Complete!
# End Registry User Check
#foreach ( $COMPUSER in $COMPUSERS ) {
#    Write-host ("C:\users\$COMPUSER").ToUpper().Length
#}