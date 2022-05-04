@echo off
set WD=%~dp0
Powershell.exe -NoProfile -executionpolicy Bypass -File "%WD%ConnexantUpdateError.ps1"
