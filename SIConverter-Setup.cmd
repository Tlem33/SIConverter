:: SIConverter-Setup.cmd - Par Tlem33
:: Programme d'installation et de désinstallation de SIConverter.cmd
::
:: Lire le fichier README.md pour plus d'informations.
::
:: Version 1.4 du 13/05/2021
:: https://github.com/Tlem33/SIConverter
::

@Echo Off
Cls

:: Permet de mapper un lecteur automatiquement si le programme est lancé depuis un chemin UNC
:: popd avant de quitter le script permet de fermer le lecteur mappé.
pushd %~dp0

:: On lit les paramètres d'installation
Set SetupIni=%~DP0setup.ini
Call :ReadSetupIni

:: On demande les droits admin si necessaire (Cas du lien sur le bureau public).
Set PowerShellExe="%WINDIR%\system32\WindowsPowerShell\v1.0\powershell.exe"
If %Admin% EQU 1 Net.exe session 1>NUL 2>NUL || (%PowerShellExe% start-process """%~dpnx0""" -verb RunAs & Exit /b 1)


:Titre
Cls
Echo				Setup %AppName% %Version%
Echo.
Echo.


:Choix
Echo Dossier d'installation :
Echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
Echo %InstallDir%
Echo.
Echo.
Echo Choisissez l'action … effecter :
Echo.
Echo.
Echo      1 - Installer %LinkName% %Version%
Echo.
Echo      2 - D‚sinstaller %LinkName% %Version%
Echo.
Echo      3 - Quitter
Echo.
Echo.
Echo.
Echo.
:: Le caractère ÿ permet de faire un espace OEM (ALT+255 puis conversion en OEM)
Set /P Var= Veuillez taper votre choix (1, 2 ou 3) :ÿ
If /I %var%==1 Goto :Install
If /I %var%==2 Goto :Uninstall
If /I %var%==3 Exit
Goto :Titre


:Install
Echo.
:: Suppression du fichier .Log si existant
If Exist "%~dp0*.log" Del /F /Q "%~dp0*.log"

:: Suppression des raccourcis existant
If Exist "%InstallDir%\%LinkName%*.lnk" Del /F /Q "%InstallDir%\%LinkName%*.lnk"
If Exist "%LinkDst1%\%LinkName%*.lnk" Del /F /Q "%LinkDst1%\%LinkName%*.lnk"
If Exist "%LinkDst2%\%LinkName%*.lnk" Del /F /Q "%LinkDst2%\%LinkName%*.lnk"

:: Copie des fichiers vers le dossier d'installation
Echo Copie des fichiers ...
XCopy "%~dp0*.*" "%InstallDir%\" /Y

:: Création du raccourci en utilisant les différentes variables définies par le fichier .ini.
Set TmpFile="%temp%\CreateShortCut.vbs"

Echo Set WshShell = WScript.CreateObject("WScript.Shell")>%TmpFile%
::Echo strDesktop = WshShell.SpecialFolders("Desktop")>>%TmpFile%
::Echo Set oMyShortcut = WshShell.CreateShortcut(strDesktop + "\%LinkName%.lnk")>>%TmpFile%
Echo Set oMyShortcut = WshShell.CreateShortcut("%InstallDir%\%LinkName% %Version%.lnk")>>%TmpFile%
:: WindowStyle : 1 = Normale, 3 = Maximisée, 7 = Réduite
Echo oMyShortcut.WindowStyle = ^1>>%TmpFile%
Echo oMyShortcut.IconLocation = "%LinkDllIcon%,%IconIndex%">>%TmpFile%
Echo OMyShortcut.TargetPath = "%InstallDir%\%LinkTarget%">>%TmpFile%
Echo OMyShortcut.Arguments = "">>%TmpFile%
Echo oMyShortCut.Save>>%TmpFile%
Call Cscript //Nologo %TmpFile%
Del /F /Q %TmpFile%

:: Mise en place des raccourcis :
If Exist "%InstallDir%\%LinkName% %Version%.lnk" (
	Echo.
	Echo Mise en place des raccourcis ...
	If "%LinkDst1%" NEQ "" Echo Vers "%LinkDst1%\" & Copy /Y "%InstallDir%\%LinkName% %Version%.lnk" "%LinkDst1%\"
	If "%LinkDst2%" NEQ "" Echo Vers "%LinkDst1%\" & Copy /Y "%InstallDir%\%LinkName% %Version%.lnk" "%LinkDst2%\"
	If %LinkDesktop% EQU 1 Echo Vers "%UserDesktop%\" & Copy /Y "%InstallDir%\%LinkName% %Version%.lnk" "%UserDesktop%\"
	If %LinkDesktop% EQU 2 Echo Vers "%Public%\Desktop\" & Copy /Y "%InstallDir%\%LinkName% %Version%.lnk" "%Public%\Desktop\"
)

If Exist "%InstallDir%\%~nx0" (
	Call :SuccessMSG
	Echo Installation termin‚e avec succŠs.
) Else (
	Call :ErrorMSG
	Echo Erreur lors de l'installation.
	Echo Lisez les messages ci-dessus pour connaitre la raison de l'erreur.
)
Call :Exit


:Uninstall
Set UninstallFile="%Temp%\%LinkName%_Uninstall.cmd"

Echo @Echo Off>%UninstallFile%
Echo Cls>>%UninstallFile%
Echo Ping -n3 127.0.0.1^>Nul>>%UninstallFile%
Echo.>>%UninstallFile%
Echo :Delete>>%UninstallFile%
Echo Set /A X+=^1>>%UninstallFile%
Echo Echo Suppression des raccourcis.>>%UninstallFile%
Echo If Exist "%Public%\Desktop\%LinkName% %Version%.lnk" Del /Q "%Public%\Desktop\%LinkName% %Version%.lnk">>%UninstallFile%
Echo If Exist "%UserDesktop%\%LinkName% %Version%.lnk" Del /Q "%UserDesktop%\%LinkName% %Version%.lnk">>%UninstallFile%
Echo If Exist "%LinkDst1%\%LinkName% %Version%.lnk" Del /Q "%LinkDst1%\%LinkName% %Version%.lnk">>%UninstallFile%
Echo If Exist "%LinkDst2%\%LinkName% %Version%.lnk" Del /Q "%LinkDst2%\%LinkName% %Version%.lnk">>%UninstallFile%
Echo Echo Suppression du r‚pertoire d'installation.>>%UninstallFile%
Echo RD /S /Q "%InstallDir%">>%UninstallFile%
Echo Echo.>>%UninstallFile%
Echo If %%X%% GEQ 500 Goto :Check>>%UninstallFile%
Echo If Exist "%InstallDir%" Goto :Delete>>%UninstallFile%
Echo.>>%UninstallFile%
Echo :Check>>%UninstallFile%
Echo If Exist "%InstallDir%" ^(>>%UninstallFile%
Echo 	Color 0C>>%UninstallFile%
Echo 	Echo Erreur lors de la d‚sinstallation.>>%UninstallFile%
Echo 	Echo Lisez les messages ci-dessus pour connaitre la raison de l'erreur.>>%UninstallFile%
Echo ^) Else ^(>>%UninstallFile%
Echo 	Color 0A>>%UninstallFile%
Echo 	Echo D‚sinstallation termin‚e avec succŠs.>>%UninstallFile%
Echo ^)>>%UninstallFile%
Echo Echo.>>%UninstallFile%
Echo Echo.>>%UninstallFile%
Echo Echo Appuyez sur une touche pour terminer.>>%UninstallFile%
Echo Pause^>Nul>>%UninstallFile%
Echo.>>%UninstallFile%
Echo.>>%UninstallFile%
Echo :AutoDelete>>%UninstallFile%
Echo DEl /F /Q "%%~DPNX0" ^&^& Exit>>%UninstallFile%
Echo If Exist "%%~DPNX0" Goto :AutoDelete>>%UninstallFile%
Echo Exit>>%UninstallFile%

Echo.
Echo Fermez la fenˆtre Explorer du dossier "%InstallDir%"
Echo puis appuyez sur une touche pour continuer la d‚sinstallation.
Pause>Nul

Start "Uninstall" /D "%Temp%" "%LinkName%_Uninstall.cmd"
popd & Exit


:ErrorMsg
Color 0C
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º          ERREUR          º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Goto :EOF


:InformationMsg
Color 0E
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º       INFORMATION        º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Goto :EOF


:SuccessMsg
Color 0A
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º          SUCCES          º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Goto :EOF


:: Lecture du fichier .ini
:ReadSetupIni
If Not Exist "%SetupIni%" Call :ErrorMsg & Echo Le fichier Setup.ini n'a pas ‚t‚ trouv‚ !!! & Call :Exit
:: Boucle de lecture du fichier .ini. Usebackq permet d'utiliser les guillemets et les chemin long.
For /F "usebackq Tokens=1,2 Delims==" %%a In ("%SetupIni%") Do (
	If /I %%a==AppName Set AppName=%%b
	If /I %%a==Version Set Version=%%b
	If /I %%a==InstallDir Set InstallDir=%%b
	If /I %%a==LinkTarget Set LinkTarget=%%b
	If /I %%a==LinkName Set LinkName=%%b
	If /I %%a==Admin Set Admin=%%b
	If /I %%a==LinkDesktop Set LinkDesktop=%%b
	If /I %%a==LinkDst1 Set LinkDst1=%%b
	If /I %%a==LinkDst2 Set LinkDst2=%%b
	If /I %%a==LinkDllIcon Set LinkDllIcon=%%b
	If /I %%a==IconIndex Set IconIndex=%%b
)

:TestIniConfig
If "%InstallDir%"=="" Call :ErrorMsg & Echo InstallDir n'est pas renseign‚ !!! & Call :Exit
If "%LinkTarget%"=="" Call :ErrorMsg & Echo LinkTarget n'est pas renseign‚ !!! & Call :Exit
If "%LinkName%"=="" Call :ErrorMsg & Echo LinkName n'est pas renseign‚ !!! & Call :Exit

If "%Version%"=="" Set Version=0.0
If "%Admin%" NEQ "0" Set Admin=1
If "%LinkDesktop%" NEQ "1" (
	If "%LinkDesktop%" NEQ "2" (
		Set LinkDesktop=0
	)
)

:: Expansion des variables au cas ou des variables d'environement serait utilisées dans les chemins
Call :ExpandVar InstallDir "%InstallDir%"
Call :ExpandVar LinkDst1 "%LinkDst1%"
Call :ExpandVar LinkDst2 "%LinkDst2%"

If Not Exist "%LinkDllIcon%" Set LinkDllIcon=%systemroot%\System32\shell32.dll & Set IconIndex=24

:: Test si le dossier d'installation existe, ou s'il peux être créé.
If Not Exist "%InstallDir%" (
	MD "%InstallDir%">Nul 2>Nul
	If %ERRORLEVEL% EQU 1 (
		Call :ErrorMsg & Echo Le dossier d'installation n'est pas correct !!! & Call :Exit
	) Else (
		RD "%InstallDir%">Nul 2>Nul
	)
)

:: Test si LinkTarget existe
If Not Exist "%~DP0%LinkTarget%" Call :ErrorMsg & Echo Programme %LinkTarget% non trouv‚ !!! & Call :Exit


:: Récupération du chemin du bureau de l'utilisateur
For /F "Usebackq Tokens=1,2,*" %%B In (`reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop`) Do Set UserDesktop=%%D

Goto :EOF


:: Cette fonction permet d'étendre les variables d'environement qui
:: auraient été utilisées dans les variables des chemin par exemple.
:ExpandVar
Set %1=%~2
Goto :EOF


:Exit
Echo.&Echo.
Echo Appuyez sur une touche pour quitter.
Popd
Pause>Nul
Exit
:EOF
