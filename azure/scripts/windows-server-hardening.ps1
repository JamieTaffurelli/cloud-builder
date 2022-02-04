# Start set password policies

& net accounts /maxpwage:70 /minpwage:1 /minpwlen:14 /uniquepw:24

# End set password policies

# Start rename accounts

$guestAccount = Get-WMIObject Win32_UserAccount -Filter "Name='Guest'"

if ($guestAccount) {
    $guestAccount.Rename("GuestRenamed")
}

# End rename accounts

# Start set reg keys

if (!(Get-PSDrive | Where-Object { $PSITEM.Name = "HKU" } )) {
    New-PSDrive -PSProvider Registry -Name "HKU" -Root "HKEY_USERS"
}

$regKeys = @(
    @{
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkStation\Parameters"
        Name         = "RequireSecuritySignature"
        PropertyType = "DWORD"
        Value        = 1
    },
    @{
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkStation\Parameters"
        Name         = "EnableSecuritySignature"
        PropertyType = "DWORD"
        Value        = 1
    },
    @{
        Path         = "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters"
        Name         = "RequireSecuritySignature"
        PropertyType = "DWORD"
        Value        = 1
    },
    @{
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
        Name         = "EnableSecuritySignature"
        PropertyType = "DWORD"
        Value        = 1
    },
    @{
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Name         = "NoDriveTypeAutoRun"
        PropertyType = "DWORD"
        Value        = 255
    },
    @{
        Path         = "HKU:\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Name         = "NoDriveTypeAutoRun"
        PropertyType = "DWORD"
        Value        = 255
    },
    @{
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Control\LSA"
        Name         = "RestrictAnonymous"
        PropertyType = "DWORD"
        Value        = 1
    },
    @{
        Path         = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
        Name         = "RestrictNullSessAccess"
        PropertyType = "DWORD"
        Value        = 1
    },
    @{
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
        Name         = "CachedLogonsCount"
        PropertyType = "String"
        Value        = 0
    }
)

foreach ($regKey in $regKeys) {
    if (!(Test-Path -Path $regKey.Path -PathType "Container")) {
        New-Item -Path $regKey.Path -ItemType "RegistryKey" -Force
    }

    New-ItemProperty @regKey -Force
}

# End set reg keys
