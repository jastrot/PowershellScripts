#############################
#   Strother IT Solutions   #
#   Jeff Strother           #
#   jeff@strotherit.com     #
#   Created 2018-06-25      #
#   Revision 1.0            #
#############################
#
# Works with Exchange 2010 version 14.2.247.5
# The purpose of this script is to allow one user (Mail Investigator) to view another user's (Mail User) mailbox from the Exchange Outlook Anywhere Web Interface and not have the Mail User's mailbox download to the Mail Investigator's outlook. 
# Unfortunately, it cannot be set to readOnly and must be FullAccess so the Mail investigator technically could send mail, delete mail, move mail, etc. on behalf of the Mail User.
# Set ConnectionUri Server Name
$serverName = Read-Host -Prompt "Enter Server Name"
# Create variable for session configuration. Change the ConnectionUri to whatever the server name is that hosts exchange server
$exchange = New-PSSession -ConfigurationName microsoft.exchange -ConnectionUri http://$serverName/powershell
# Import the powershell session so we can perform exchange manipulation remotely
Import-PSSession $exchange
# Set variable to continue looping
$finished = $false;

# Repeat prompt until administrator either cancels or closes the session
do {
# Clear the screen so we don't see the issues with using a temporary file for the modules
cls
# Create prompt for user
$caption = "Choose Action";
$message = "What do you want to do?";
$AddPermission = New-Object System.Management.Automation.Host.ChoiceDescription "&Allow user to view another's mailbox", "Allow user to view another's mailbox";
$RemovePermission = New-Object System.Management.Automation.Host.ChoiceDescription "&Remove user's ability to view another's mailbox", "Remove user's ability to view another's mailbox";
$CancelPermission = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel editing permission", "Cancel editing permission";
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($AddPermission, $RemovePermission, $CancelPermission);
$AddOrDelete =  $host.ui.PromptForChoice($caption,$message, $choices, 2)

# Do something based on user selection
switch ($AddOrDelete) {
    # Add permissions
    0{
        $MAILUSER = Read-Host -Prompt "Input username of the person's mailbox you wish to view";
        $MAILINVESTIGATOR = Read-Host -Prompt "Input username of person viewing the mailbox";
        Add-MailboxPermission $MAILUSER -User $MAILINVESTIGATOR -AccessRights "FullAccess" -InheritanceType All -AutoMapping $false;
        break;
    }
    # Remove Permissions
    1{
        $MAILUSER = Read-Host -Prompt "Input username of the person's mailbox you wish to stop viewing";
        $MAILINVESTIGATOR = Read-Host -Prompt "Input username of person viewing the mailbox";
        Remove-MailboxPermission $MAILUSER -User $MAILINVESTIGATOR -AccessRights "FullAccess" -InheritanceType All -Confirm:$false;
        break;
    }
    # Cancel Permissions
    2{
        Write-Host "Cancelling operation. Adding or Removing permissions was not selected";
        Timeout 2;
        exit;
    }
    # Default in case nothing is ever selected
    default {
        Write-Host "Nothing has been performed, exiting now.";
        break;
    }
}
Timeout 2;
} while (!$finished)
exit