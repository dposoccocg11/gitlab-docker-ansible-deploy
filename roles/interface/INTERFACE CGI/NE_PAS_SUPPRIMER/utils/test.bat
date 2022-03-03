@echo off
set $path=%~0
for %%a in (%$path%) do set $Fichier=%%~na
echo %$Fichier%