@echo off
IF EXIST "C:\Windows\SysWOW64" ( 
echo 64-bit
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe Set-ExecutionPolicy RemoteSigned
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -file C:\Scripts\CleanupUserAccountsAfterDeleted.ps1
) Else (
echo 32-bit
powershell.exe Set-ExecutionPolicy RemoteSigned
powershell.exe -file C:\Scripts\CleanupUserAccountsAfterDeleted.ps1
)
Pause