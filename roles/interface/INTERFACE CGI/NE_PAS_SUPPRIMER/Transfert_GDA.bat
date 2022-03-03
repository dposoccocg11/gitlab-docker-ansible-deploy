rem  ======= exemple ================== 
rem  Transfert_gda.bat GDAR transTRAIND1
rem  ======= exemple ================== 
Set path="%~dp0utils";%path%
@echo off
set $Script=%~0
set ENV=%~1
Set Fic=%~2
set $Dos_Dest=\\cg11\partage\Exports\insito\gda\%ENV%\
set $Dos_Ori1=%~dp0
rem set $Dos_Ori=\\cg11.local\partage\Finances\SPBPF\DETTE - TRESORERIE\GESTION DE DETTE  PROPRE\MANDATEMENT DETTE\EXTRACTION DES FICHIERS MENSUELS\INTERFACE CGI\
rem nouveau nom de dossier
set $Dos_Ori=\\cg11.local\partage\Finances\SPBPF\DETTE - TRESORERIE\MANDATEMENT DETTE\EXTRACTION DES FICHIERS MENSUELS\INTERFACE CGI\
set $Dos_Arch=%$Dos_Dest%traites

for %%a in (%$Script%) do set $Fichier=%%~na
echo %$Fichier%

for %%a in (%Fic%) do set $Fic_cp=%%~na
echo %$Fic_cp%

echo %$Dos_Ori1%


echo off
wget  -O "test.txt" "http://admin/service/maj_script.php?script=%$Fichier%.bat %$Fic_cp% => %~1&machine=%computername%&etat=1" 

set Datej=%date:~6,4%-%date:~3,2%-%date:~0,2%
set Folderj=%date:~6,4%-%date:~3,2%
set folder_datej=%$Dos_Arch%\%Folderj%

echo creation du dossier si n existe pas 
echo "%folder_datej%"

if not exist "%folder_datej%" mkdir "%folder_datej%"
if exist "%$Dos_Ori%%Fic%" goto :file_good 
goto :fin
 
 :file_good
 echo copie du fichier
 echo "%$Dos_Ori%%Fic% => %$Dos_Dest%%Fic%"
 copy /Y "%$Dos_Ori%%Fic%" "%$Dos_Dest%%Fic%"
 rem verifie les fichier sur %$Dos_Ori%
 if exist "%$Dos_Dest%%Fic%" goto :suite
 goto :err_copie
 
 :suite
 copy /Y "%$Dos_Ori%%Fic%" "%folder_datej%\%Datej%_%Fic%"
 del /Q "%$Dos_Ori%%Fic%"
 
 goto :fin_good
 
 :fin
 echo ATTENTION fichier "%$Dos_Ori%%Fic%" n existe pas 
 pause 
 goto :fin
 
 :err_copie
 echo ATTENTION fichier "%$Dos_Ori%%Fic%" non copie sur %$Dos_Dest%
 pause 
 goto :fin
 
 :fin_good
wget  -O "test.txt" "http://admin/service/maj_script.php?script=%$Fichier%.bat %$Fic_cp% => %~1&machine=%computername%&etat=0" 
echo on

:fin