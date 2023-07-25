Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "Select Action"
$mainForm.Size = New-Object System.Drawing.Size(500, 500)
$mainForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$mainForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$mainForm.MaximizeBox = $false
# Set the background color
$mainForm.BackColor = [System.Drawing.Color]::White
# $mainForm.BackColor = [System.Drawing.Color]::FromArgb(95, 146, 155)

# Add Logo
$logoPath = ".\Logo.png"  #REPLACE with the path to your logo image
    if (Test-Path $logoPath) {
        $mainLogo = New-Object System.Windows.Forms.PictureBox
        $mainLogo.Image = [System.Drawing.Image]::FromFile($logoPath)
        $mainLogo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $mainLogo.Location = New-Object System.Drawing.Point(20, 220)
        $mainLogo.Size = New-Object System.Drawing.Size(445, 250)
        $mainForm.Controls.Add($mainLogo)
    }

# Create a label for the heading text
$labelHeading = New-Object System.Windows.Forms.Label
$labelHeading.Text = "Choose as per your requirement"
$labelHeading.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
$labelHeading.AutoSize = $true
$labelHeading.Location = New-Object System.Drawing.Point(75, 30)
$mainForm.Controls.Add($labelHeading)

# Create a button for password change
$buttonPasswordChange = New-Object System.Windows.Forms.Button
$buttonPasswordChange.Text = "Password Change"
$buttonPasswordChange.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$buttonPasswordChange.Location = New-Object System.Drawing.Point(50, 100)
$buttonPasswordChange.Size = New-Object System.Drawing.Size(120, 80)
$buttonPasswordChange.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$mainForm.Controls.Add($buttonPasswordChange)

# Create a button for printer installation
$buttonPrinterInstallation = New-Object System.Windows.Forms.Button
$buttonPrinterInstallation.Text = "Add `nPrinter(s)"
$buttonPrinterInstallation.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$buttonPrinterInstallation.Location = New-Object System.Drawing.Point(315, 100)
$buttonPrinterInstallation.Size = New-Object System.Drawing.Size(120, 80)
$buttonPrinterInstallation.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$mainForm.Controls.Add($buttonPrinterInstallation)

# Event handler for the password change button click
$buttonPasswordChange.Add_Click({
    # Hide the main form
    $mainForm.Hide()

    # Code for password change script goes here
    Add-Type -AssemblyName System.Windows.Forms

    # Check the current execution policy
    $currentExecutionPolicy = Get-ExecutionPolicy

    # Set the execution policy to Bypass temporarily
    Set-ExecutionPolicy Bypass -Scope Process -Force

    # Check if the ActiveDirectory module is already imported
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        # Try importing the ActiveDirectory module
        try {
            Import-Module ActiveDirectory -ErrorAction Stop
        }
        catch {
            # If importing fails, install the RSAT feature as admin
            Write-Host "Installing RSAT feature including Active Directory module..."

            # Define the command to install the RSAT feature
            $installCommand = "Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"

            try {
                # Start a new PowerShell process as admin and execute the install command
                Start-Process powershell -ArgumentList "-NoProfile -Command `"$installCommand`"" -Verb RunAs -Wait
            }
            catch {
                $errorMessage = $_.Exception.Message
                Write-Host "Failed to install RSAT feature: $errorMessage"
                return
            }

            # Import the ActiveDirectory module as user
            try {
                Import-Module ActiveDirectory -ErrorAction Stop
            }
            catch {
                $errorMessage = $_.Exception.Message
                Write-Host "Failed to import ActiveDirectory module: $errorMessage"
                return
            }
        }
    }
    # Create a form for password change
    $passwordChangeForm = New-Object System.Windows.Forms.Form
    $passwordChangeForm.Text = "AD Password Change"
    $passwordChangeForm.Size = New-Object System.Drawing.Size(500, 500)
    $passwordChangeForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $passwordChangeForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $passwordChangeForm.MaximizeBox = $false
    $passwordChangeForm.BackColor = [System.Drawing.Color]::White

    if (Test-Path $logoPath) {
        $passwordChangeLogo = New-Object System.Windows.Forms.PictureBox
        $passwordChangeLogo.Image = [System.Drawing.Image]::FromFile($logoPath)
        $passwordChangeLogo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $passwordChangeLogo.Location = New-Object System.Drawing.Point(20, 280)
        $passwordChangeLogo.Size = New-Object System.Drawing.Size(445, 170)
        $passwordChangeForm.Controls.Add($passwordChangeLogo)
    }

    # Create labels, textboxes, and buttons for password change
    $labelUsername = New-Object System.Windows.Forms.Label
    $labelUsername.Location = New-Object System.Drawing.Point(20, 25)
    $labelUsername.Size = New-Object System.Drawing.Size(175, 20)
    $labelUsername.Text = "AD Username:"
    $labelUsername.Font = New-Object System.Drawing.Font("Arial", 11)
    $passwordChangeForm.Controls.Add($labelUsername)

    $textBoxUsername = New-Object System.Windows.Forms.TextBox
    $textBoxUsername.Location = New-Object System.Drawing.Point(195, 20)
    $textBoxUsername.Size = New-Object System.Drawing.Size(280, 30)
    $textBoxUsername.Font = New-Object System.Drawing.Font("Arial", 12)
    $passwordChangeForm.Controls.Add($textBoxUsername)

    $labelCurrentPassword = New-Object System.Windows.Forms.Label
    $labelCurrentPassword.Location = New-Object System.Drawing.Point(20, 75)
    $labelCurrentPassword.Size = New-Object System.Drawing.Size(175, 20)
    $labelCurrentPassword.Text = "Current Password:"
    $labelCurrentPassword.Font = New-Object System.Drawing.Font("Arial", 11)
    $passwordChangeForm.Controls.Add($labelCurrentPassword)

    $textBoxCurrentPassword = New-Object System.Windows.Forms.TextBox
    $textBoxCurrentPassword.Location = New-Object System.Drawing.Point(195, 70)
    $textBoxCurrentPassword.Size = New-Object System.Drawing.Size(280, 30)
    $textBoxCurrentPassword.PasswordChar = '*'
    $textBoxCurrentPassword.Font = New-Object System.Drawing.Font("Arial", 12)
    $passwordChangeForm.Controls.Add($textBoxCurrentPassword)

    $labelNewPassword = New-Object System.Windows.Forms.Label
    $labelNewPassword.Location = New-Object System.Drawing.Point(20, 125)
    $labelNewPassword.Size = New-Object System.Drawing.Size(175, 20)
    $labelNewPassword.Text = "New Password:"
    $labelNewPassword.Font = New-Object System.Drawing.Font("Arial", 11)
    $passwordChangeForm.Controls.Add($labelNewPassword)

    $textBoxNewPassword = New-Object System.Windows.Forms.TextBox
    $textBoxNewPassword.Location = New-Object System.Drawing.Point(195, 120)
    $textBoxNewPassword.Size = New-Object System.Drawing.Size(280, 30)
    $textBoxNewPassword.PasswordChar = '*'
    $textBoxNewPassword.Font = New-Object System.Drawing.Font("Arial", 12)
    $passwordChangeForm.Controls.Add($textBoxNewPassword)

    $labelReenterNewPassword = New-Object System.Windows.Forms.Label
    $labelReenterNewPassword.Location = New-Object System.Drawing.Point(20, 175)
    $labelReenterNewPassword.Size = New-Object System.Drawing.Size(175, 30)
    $labelReenterNewPassword.Text = "Re-enter New Password:"
    $labelReenterNewPassword.Font = New-Object System.Drawing.Font("Arial", 11)
    $passwordChangeForm.Controls.Add($labelReenterNewPassword)

    $textBoxReenterNewPassword = New-Object System.Windows.Forms.TextBox
    $textBoxReenterNewPassword.Location = New-Object System.Drawing.Point(195, 170)
    $textBoxReenterNewPassword.Size = New-Object System.Drawing.Size(280, 30)
    $textBoxReenterNewPassword.PasswordChar = '*'
    $textBoxReenterNewPassword.Font = New-Object System.Drawing.Font("Arial", 12)
    $passwordChangeForm.Controls.Add($textBoxReenterNewPassword)

    $buttonChangePassword = New-Object System.Windows.Forms.Button
    $buttonChangePassword.Location = New-Object System.Drawing.Point(150, 230)
    $buttonChangePassword.Size = New-Object System.Drawing.Size(185, 40)
    $buttonChangePassword.Text = "Change Password"
    $buttonChangePassword.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $buttonChangePassword.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
    $passwordChangeForm.Controls.Add($buttonChangePassword)

    # Event handler for the button click
    $buttonChangePassword.Add_Click({
        # Code for password change script goes here
        $adusername = $textBoxUsername.Text
        $currentPassword = $textBoxCurrentPassword.Text | ConvertTo-SecureString -AsPlainText -Force
        $newPassword = $textBoxNewPassword.Text | ConvertTo-SecureString -AsPlainText -Force
        $reenteredNewPassword = $textBoxReenterNewPassword.Text | ConvertTo-SecureString -AsPlainText -Force

        # Check if any required text box is empty
        if ([string]::IsNullOrEmpty($adusername) -or [string]::IsNullOrEmpty($textBoxCurrentPassword.Text) -or [string]::IsNullOrEmpty($textBoxNewPassword.Text) -or [string]::IsNullOrEmpty($textBoxReenterNewPassword.Text)) {
            $message = "Fill in all the required details"
            Write-Host $message  # Display error in PowerShell console
            [System.Windows.Forms.MessageBox]::Show($message, "Validation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Check if the new password meets the length requirement
        $newPasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
        if ($newPasswordPlainText.Length -le 6) {
            $message = "Your new password must be more than 6 characters including letters, numbers, and symbols."
            [System.Windows.Forms.MessageBox]::Show($message, "Complexity Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }

        # Check if the entered passwords match
        $newPasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
        $reenteredNewPasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($reenteredNewPassword))
        if ($newPasswordPlainText -ne $reenteredNewPasswordPlainText) {
            $message = "The re-entered new password does not match the new password. Please try again."
            [System.Windows.Forms.MessageBox]::Show($message, "Mismatch Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }

        try {
            # Change the AD password
            Set-ADAccountPassword -Identity $adusername -OldPassword $currentPassword -NewPassword $newPassword

            # Convert the new password back to plain text
            $newPasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))

            $message = "Password has been changed successfully. Click OK to update it in the credential manager."
            [System.Windows.Forms.MessageBox]::Show($message, "SUCCESS", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

            # Create a new PSCredential object with the updated password
            $targetName1 = "example1.com" #REPLACE (example1.com) with your Domain Name1
            $targetName2 = "*.example1.com" #REPLACE (*.example1.com) with your Domain Name1
            $targetName3 = "example2.com" #REPLACE (example2.com) with your Domain Name2
            $targetName4 = "*.example2.com" #REPLACE (*.example2.com) with your Domain Name2
            $username = "DOMAINNAME\$adusername" #REPLACE (DOMAINNAME) with your actual AD DoaminName
            $password = $newPasswordPlainText

            # Create the domain-specific or network address credential using vaultcmd
            $cmd1 = "vaultcmd /addcreds:`"Windows Credentials`" /credtype:`"Windows Domain Password Credential`" /identity:`"$username`" /authenticator:`"$password`" /resource:`"$targetName1`""
            $cmd2 = "vaultcmd /addcreds:`"Windows Credentials`" /credtype:`"Windows Domain Password Credential`" /identity:`"$username`" /authenticator:`"$password`" /resource:`"$targetName2`""
            $cmd3 = "vaultcmd /addcreds:`"Windows Credentials`" /credtype:`"Windows Domain Password Credential`" /identity:`"$username`" /authenticator:`"$password`" /resource:`"$targetName3`""
            $cmd4 = "vaultcmd /addcreds:`"Windows Credentials`" /credtype:`"Windows Domain Password Credential`" /identity:`"$username`" /authenticator:`"$password`" /resource:`"$targetName4`""

            $result1 = Invoke-Expression -Command $cmd1
            $result2 = Invoke-Expression -Command $cmd2
            $result3 = Invoke-Expression -Command $cmd3
            $result4 = Invoke-Expression -Command $cmd4

            $message = "The following have been successfully updated in the Credential Manager:`n"
            if ($result1 -eq "Credentials added successfully") { $message += "1. $targetName1`n" }
            if ($result2 -eq "Credentials added successfully") { $message += "2. $targetName2`n" }
            if ($result3 -eq "Credentials added successfully") { $message += "3. $targetName3`n" }
            if ($result4 -eq "Credentials added successfully") { $message += "4. $targetName4`n" }

            [System.Windows.Forms.MessageBox]::Show($message, "Password Change", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

            # Clear the plain text passwords from memory
            $currentPasswordPlainText, $newPasswordPlainText, $reenteredNewPasswordPlainText, $password = $null

            # Close the form
            $passwordChangeForm.Close()
        }
        catch {
            $errorMessage = $_.Exception.Message
            $message = "Password Change Error Details:`n$errorMessage"
            [System.Windows.Forms.MessageBox]::Show($message, "FAILED", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error, [System.Windows.Forms.MessageBoxDefaultButton]::Button1)
            
            # Log the error
            Write-Host "Password Change Error: $errorMessage"
        }        
    })

    $passwordChangeForm.Add_FormClosing({
        # Show the main form again
        $mainForm.Show()
    })

    # Show the password change form
    [void]$passwordChangeForm.ShowDialog()

    # Restoring the original execution policy
    Set-ExecutionPolicy $currentExecutionPolicy -Scope Process -Force
})

# Event handler for the printer installation button click
$buttonPrinterInstallation.Add_Click({
    # Hide the main form
    $mainForm.Hide()

    # Create a form for printer installation
    $printerInstallationForm = New-Object System.Windows.Forms.Form
    $printerInstallationForm.Text = "Printer Selection"
    $printerInstallationForm.Size = New-Object System.Drawing.Size(600, 555)
    $printerInstallationForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $printerInstallationForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $printerInstallationForm.MaximizeBox = $false
	$printerInstallationForm.BackColor = [System.Drawing.Color]::White

    if (Test-Path $logoPath) {
        $printerInstallationLogo = New-Object System.Windows.Forms.PictureBox
        $printerInstallationLogo.Image = [System.Drawing.Image]::FromFile($logoPath)
        $printerInstallationLogo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $printerInstallationLogo.Location = New-Object System.Drawing.Point(20, 350)
        $printerInstallationLogo.Size = New-Object System.Drawing.Size(545, 170)
        $printerInstallationForm.Controls.Add($printerInstallationLogo)
    }

    # Create a label for the heading text
    $labelHeading = New-Object System.Windows.Forms.Label
    $labelHeading.Text = "Please choose one or more printer(s) from below to install or click Exit."
    $labelHeading.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $labelHeading.AutoSize = $true
    $labelHeading.Location = New-Object System.Drawing.Point(5, 5)
    $printerInstallationForm.Controls.Add($labelHeading)

    # Create a label for the search box
    $labelSearch = New-Object System.Windows.Forms.Label
    $labelSearch.Text = "Search Printers:"
    $labelSearch.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
    $labelSearch.AutoSize = $true
    $labelSearch.Location = New-Object System.Drawing.Point(5, 30)
    $printerInstallationForm.Controls.Add($labelSearch)

    # Create a TextBox for the search box
    $textBoxSearch = New-Object System.Windows.Forms.TextBox
    $textBoxSearch.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
    $textBoxSearch.Location = New-Object System.Drawing.Point(130, 30)
    $textBoxSearch.Size = New-Object System.Drawing.Size(415, 24)
    $printerInstallationForm.Controls.Add($textBoxSearch)

    # Event handler for the search box text change
    $textBoxSearch.Add_TextChanged({
        $searchText = $textBoxSearch.Text.Trim().ToLower()

        # Sort the checkboxes based on the search text
        $sortedCheckBoxes = $checkBoxes | Sort-Object { $_.Text.ToLower().IndexOf($searchText) }

        foreach ($checkBox in $sortedCheckBoxes | Sort-Object) {
            if ($checkBox.Text.ToLower().Contains($searchText)) {
                $checkBox.Visible = $true
            } else {
                $checkBox.Visible = $false
            }
        }

        # Reorder the visible checkboxes so that searched printer(s) appear at the top
        $visibleCheckBoxes = $sortedCheckBoxes | Where-Object { $_.Visible }
        $yPosition = 30
        foreach ($checkBox in $visibleCheckBoxes | Sort-Object) {
            $checkBox.Location = New-Object System.Drawing.Point(20, $yPosition)
            $yPosition += 30
        }
    })

    # Create a panel control with a vertical scrollbar
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Location = New-Object System.Drawing.Point(15, 55)
    $panel.Size = New-Object System.Drawing.Size(565, 220)
    $panel.AutoScroll = $true  # Enable vertical scrollbar
    $printerInstallationForm.Controls.Add($panel)

    # Create a group box for printer selection
    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Text = "Select Printers"
    $groupBox.Location = New-Object System.Drawing.Point(0, 0)
    $groupBox.AutoSize = $true
    $panel.Controls.Add($groupBox)

    # Create checkboxes for printer selection
    $checkBoxes = @()
    try {
        $printers = Get-Printer -ComputerName ps01.example.com | Where-Object { $_.Shared -eq $true } | Select-Object Name,ComputerName | Sort-Object Name #REPLACE (ps01.example.com) with your print server Name with FQDN
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Failed to get printers: $errorMessage"
        [System.Windows.Forms.MessageBox]::Show("Failed to get printers. Error details:`n$errorMessage", "Printer Retrieval Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $printersHashTable = @{}  # Initialize the hashtable here

    $yPosition = 30
    $checkBoxWidth = 500  # Adjust the width of the checkboxes

    foreach ($printer in $printers) {
        $printerName = $printer.Name
        $printerServer = $printer.ComputerName
        $printerUNCPath = "\\" + $printerServer + "\" + $printer.Name
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $printerName
        $checkBox.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $checkBox.Location = New-Object System.Drawing.Point(20, $yPosition)
        $checkBox.Size = New-Object System.Drawing.Size($checkBoxWidth, 20)
        $groupBox.Controls.Add($checkBox)
        $checkBoxes += $checkBox

        # Store the UNC path in a hashtable with the printer name as the key
        $printersHashTable[$printerName] = $printerUNCPath

        $yPosition += 30
    }

    # Create a button for printer installation
    $buttonInstallPrinter = New-Object System.Windows.Forms.Button
    $buttonInstallPrinter.Text = "Install"
    $buttonInstallPrinter.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
    $buttonInstallPrinter.Location = New-Object System.Drawing.Point(150, 285)
    $buttonInstallPrinter.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
    $printerInstallationForm.Controls.Add($buttonInstallPrinter)

    # Create an "Exit" button
    $buttonExit = New-Object System.Windows.Forms.Button
    $buttonExit.Text = "Exit"
    $buttonExit.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Regular)
    $buttonExit.Location = New-Object System.Drawing.Point(360, 285)
    $buttonExit.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
    $printerInstallationForm.Controls.Add($buttonExit)

    # Create a progress bar
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(20, 320)
    $progressBar.Size = New-Object System.Drawing.Size(545, 30)
    $printerInstallationForm.Controls.Add($progressBar)

    # Event handler for the button click
    $buttonInstallPrinter.Add_Click({
        # Code for printer installation goes here
        # Get the selected printers
        $selectedPrinters = $checkBoxes | Where-Object { $_.Checked }
        Write-Host "Adding $printerUNCPath printer. . . . ."
    
        # Check if any printer is selected
        if ($selectedPrinters.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Please select at least one printer.", "Printer Selection", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }

        # Create a "Please wait" form
        $waitForm = New-Object System.Windows.Forms.Form
        $waitForm.Text = "In Progress"
        $waitForm.Size = New-Object System.Drawing.Size(300, 80)
        $waitForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        $waitForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        $waitForm.MaximizeBox = $false
        $waitForm.BackColor = [System.Drawing.Color]::White

        # Create a label for the "Please wait" message
        $labelWaitMessage = New-Object System.Windows.Forms.Label
        $labelWaitMessage.Text = "Please wait. Adding the printer(s)..."
        $labelWaitMessage.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
        $labelWaitMessage.AutoSize = $true
        $labelWaitMessage.Location = New-Object System.Drawing.Point(10, 10)
        $waitForm.Controls.Add($labelWaitMessage)

        # Show the "Please wait" form as modeless
        $waitForm.Show()
    
        # Set the maximum value of the progress bar
        $progressBar.Maximum = $selectedPrinters.Count
    
        # Variable to track if any errors occurred
        $errorOccurred = $false
    
        # Loop through the selected printers
        foreach ($printer in $selectedPrinters) {
            $printerName = $printer.Text
            $printerUNCPath = $printersHashTable[$printerName]

            # Output the constructed UNC path for debugging
            Write-Host "Printer UNC Path: $printerUNCPath"
            
            # Update the progress bar
            $progressBar.Value++
    
            try {
                # Attempt to add the printer using the UNC path
                Add-Printer -ConnectionName $printerUNCPath -ErrorAction Stop
            } catch {
                $errorMessage = $_.Exception.Message
                Write-Host $errorMessage  # Display error in PowerShell console
                [System.Windows.Forms.MessageBox]::Show("Failed to install printer '$printerName'. Error details:`n$errorMessage", "Printer Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $errorOccurred = $true
                break
            }
        }

        # Close the "Please wait" form
        $waitForm.Close()
    
        if ($errorOccurred) {
            # Display error message if any error occurred
            [System.Windows.Forms.MessageBox]::Show("Printer installation failed.", "Printer Installation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        } else {
            # Display success message if no errors occurred
            [System.Windows.Forms.MessageBox]::Show("Printer(s) added successfully.", "Printer Installation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    
        # Reset the progress bar
        $progressBar.Value = 0
    
        # Close the printer installation form
        $printerInstallationForm.Close()
    
        # Show the main form again
        $mainForm.Show()
    })

    # Event handler for the exit button click
    $buttonExit.Add_Click({
		# Prompt the user if they want to exit
        $result = [System.Windows.Forms.MessageBox]::Show("Do you want to exit without installing the printer(s)?", "Printer Selection", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
			# Close the printer installation form
			$printerInstallationForm.Close()
		}

        # Show the main form again
        $mainForm.Show()
    })

    # Event handler for the form closing event
    $printerInstallationForm.Add_FormClosing({
        # Show the main form again
        $mainForm.Show()
    })

    # Show the printer installation form
    [void]$printerInstallationForm.ShowDialog()
})

# Show the main form
[void]$mainForm.ShowDialog()