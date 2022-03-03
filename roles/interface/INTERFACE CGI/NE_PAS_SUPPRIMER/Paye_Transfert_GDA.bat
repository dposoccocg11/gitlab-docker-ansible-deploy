rem  ======= exemple ================== 
rem  paye_transfert_gda.bat GDAR transTRAIND1
rem  ======= exemple ================== 
Set path="%~dp0utils";%path%
@echo off
set $Script=%~0
set ENV=%~1
Set Fic=%~2

for %%a in (%$Script%) do set $Fichier=%%~na
echo %$Fichier%

for %%a in (%Fic%) do set $Fic_cp=%%~na
echo %$Fic_cp%

echo off
wget  -O "test.txt" "http://admin/service/maj_script.php?script=%$Fichier%.bat %$Fic_cp% => %~1&machine=%computername%&etat=1" 

set Datej=%date:~6,4%-%date:~3,2%-%date:~0,2%
set Folderj=%date:~6,4%-%date:~3,2%
set folder_datej=\\nas3\Exports\civitas\gda\%ENV%\sauve\%Folderj%

echo creation du dossier si n existe pas 
if not exist "%folder_datej%" mkdir %folder_datej%
if exist c:\civitemp\%Fic% goto :file_good 
goto :fin
 
 :file_good
 echo copie du fichier
 copy /Y c:\civitemp\%Fic% \\nas3\Exports\civitas\gda\%ENV%\%Fic%
 rem verifie les fichier sur \\nas3\Exports\civitas\gda
 if exist \\nas3\Exports\civitas\gda\%ENV%\%Fic%  goto :suite
 goto :err_copie
 
 :suite
 copy /Y c:\civitemp\%Fic% %folder_datej%\%Datej%_%Fic%
 del /Q c:\civitemp\%Fic%
 
 goto :fin_good
 
 :fin
 echo ATTENTION fichier c:\civitemp\%Fic% n existe pas 
 pause 
 goto :fin
 
 :err_copie
 echo ATTENTION fichier c:\civitemp\%Fic% non copie sur \\nas3\Exports\civitas\gda\%ENV%
 pause 
 goto :fin
 
 :fin_good
wget  -O "test.txt" "http://admin/service/maj_script.php?script=%$Fichier%.bat %$Fic_cp% => %~1&machine=%computername%&etat=0" 
echo on

:fin