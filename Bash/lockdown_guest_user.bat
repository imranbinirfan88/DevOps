@echo off
SETLOCAL ENABLEEXTENSIONS

:: -------------------------------------
:: Set the target username here
:: -------------------------------------
SET "TARGET_USER=test.user"

:: Get full path of PowerShell
SET "PS_CMD=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile"

:: ----------------------------
:: Disable USB Storage Globally
:: ----------------------------
echo Disabling USB Storage...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f

:: ----------------------------
:: Create AppLocker Rule via PowerShell
:: ----------------------------
echo Creating AppLocker deny rule for all .exe files for %TARGET_USER%...

%PS_CMD% ^
    "$user = Get-LocalUser -Name '%TARGET_USER%' -ErrorAction Stop; " ^
    "$sid = $user.SID.Value; " ^
    "$policyXml = @'
<?xml version='1.0' encoding='UTF-8'?>
<AppLockerPolicy Version='1'>
  <RuleCollection Type='Exe' EnforcementMode='Enabled'>
    <FilePathRule Id='11111111-1111-1111-1111-111111111111' Name='Block All EXE' Description='Block all exe for guest user' UserOrGroupSid='" + $sid + @"' Action='Deny'>
      <Conditions>
        <FilePathCondition Path='*' />
      </Conditions>
    </FilePathRule>
  </RuleCollection>
</AppLockerPolicy>
'@; " ^
    "$path = $env:TEMP + '\AppLockerPolicy.xml'; " ^
    "$policyXml | Out-File -Encoding utf8 $path; " ^
    "Import-AppLockerPolicy -PolicyFilePath $path -Merge; " ^
    "Remove-Item $path; " ^
    "Set-Service AppIDSvc -StartupType Automatic; Start-Service AppIDSvc"

:: ----------------------------
:: Done
:: ----------------------------
echo.
echo ✅ Lockdown completed for user: %TARGET_USER%
echo 🔄 Please restart the system to apply all changes.
pause
