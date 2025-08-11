@echo off
SETLOCAL ENABLEEXTENSIONS

:: -------------------------------------
:: Set the target username to unlock
:: -------------------------------------
SET "TARGET_USER=test.user"

:: Get PowerShell command
SET "PS_CMD=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile"

:: ----------------------------
:: Re-enable USB Storage
:: ----------------------------
echo Re-enabling USB Storage...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 3 /f

:: ----------------------------
:: Remove AppLocker rule blocking .exe for user
:: ----------------------------
echo Removing AppLocker .exe block rule for %TARGET_USER%...

%PS_CMD% ^
    "$user = Get-LocalUser -Name '%TARGET_USER%' -ErrorAction Stop; " ^
    "$sid = $user.SID.Value; " ^
    "$policy = Get-AppLockerPolicy -Local; " ^
    "$exeRules = $policy.RuleCollections | Where-Object {$_.CollectionType -eq 'Exe'} | Select-Object -ExpandProperty Rules; " ^
    "$filtered = $exeRules | Where-Object { $_.UserOrGroupSid -ne $sid }; " ^
    "$newPolicy = New-AppLockerPolicy -RuleCollection 'Exe' -Rule $filtered -User $env:USERNAME; " ^
    "$newPolicy | Set-AppLockerPolicy -Merge"

:: Restart AppIDSvc (AppLocker Service)
%PS_CMD% "Start-Service AppIDSvc"

:: ----------------------------
:: Done
:: ----------------------------
echo.
echo ✅ Lockdown reversed for user: %TARGET_USER%
echo 🔄 You may restart the system to ensure changes are fully applied.
pause
