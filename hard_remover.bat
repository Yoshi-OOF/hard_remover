@echo off
SETLOCAL EnableExtensions

:: Vérifier si le PC est en mode sans échec
reg query "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Option" >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo Vous êtes en mode sans échec.
    goto RemoveProcess
) else (
    echo Configuration pour démarrer en mode sans échec au prochain redémarrage...
    bcdedit /set {current} safeboot minimal
    echo Veuillez redémarrer votre ordinateur maintenant et exécuter ce script à nouveau en mode sans échec.
    goto End
)

:RemoveProcess
echo Entrez le chemin complet du dossier ou fichier à supprimer :
set /p TargetPath=
if exist "%TargetPath%" (
    takeown /f "%TargetPath%" /r /d y
    icacls "%TargetPath%" /grant %USERNAME%:F /t
    rmdir /s /q "%TargetPath%"
    echo Suppression terminée.
) else (
    echo Chemin non trouvé.
)

:: Optionnel - Retirer la configuration du mode sans échec après suppression
bcdedit /deletevalue {current} safeboot

:End
endlocal
