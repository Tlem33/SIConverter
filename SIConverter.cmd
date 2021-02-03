:: SIConverter.cmd - Créer par Tlem
:: Simple Image Converter et un programme de conversion d'image simplifié,
:: Utilisant l'exécutable Nconvert.exe de chez XNview (http://www.xnview.com).
::
:: Version 1.3 du 03/02/2021
:: Voir la section Historique du fichier LisezMoi.txt pour plus d'informations.
::

@Echo Off
Cls
Set Version=1.3


:: Attribution du nom du répertoire pour le dossier de sortie.
Set ConvertedDir=Converted_IMG


:: Test si le programme Nconvert.exe est bien dans le dossier du Batch.
If Not Exist "%~DP0nconvert.exe" (
	Call :ErrorMsg
	Echo Le programme NConvert.exe n'a pas ‚t‚ trouv‚ !!!
	Call :Exit
)


:: Test si des fichiers sont donnés en argument.
If "%~1" EQU "" (
	Call :ErrorMsg
	Echo Aucun fichier a traiter ...
	Echo Effectuez un Glisser/D‚poser de fichiers sur ce programme.
	Call :Exit
)



:Choix1
Call :Titre
Echo  Quelle action d‚sirez-vous effecter ?
Echo.
Echo.
Echo      1 - Convertir en Jpeg (r‚duit la taille des fichiers jpg)
Echo.
Echo      2 - R‚duire la taille de 50%%
Echo.
Echo      3 - Convertir en Jpeg + r‚duction de 50%%
Echo.
Echo      4 - Convertir en noir et blanc
Echo.
Echo      5 - Convertir en noir et blanc + r‚duction de 50%%
Echo.
Echo      6 - Pivoter horizontalement
Echo.
Echo      7 - Rotation 90ø
Echo.
Echo      8 - Quitter
Echo.
Echo.
Echo.
Choice /C 12345678 /m "Veuillez taper votre choix "
If ERRORLEVEL 8 Exit
If ERRORLEVEL 7 Set sChoix=:Rot90 & Goto :Choix2
If ERRORLEVEL 6 Set sChoix=:Hflip & Goto :Choix2
If ERRORLEVEL 5 Set sChoix=:NB50 & Goto :Choix2
If ERRORLEVEL 4 Set sChoix=:NB & Goto :Choix2
If ERRORLEVEL 3 Set sChoix=:JPG50 & Goto :Choix2
If ERRORLEVEL 2 Set sChoix=:50 & Goto :Choix2
If ERRORLEVEL 1 Set sChoix=:JPG & Goto :Choix2
Goto :Choix1

:Choix2
Echo.
Choice /c on /m "Voulez-vous ‚craser les originaux "
If ERRORLEVEL 2 Set overwrite=0
If ERRORLEVEL 1 Set overwrite=1
Echo.
Echo.
Goto %sChoix%


:: Conversion en Jpeg
:JPG
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -out jpeg  %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Réduction de la taille de 50%
:50
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -ratio -rtype lanczos -resize 50%%%% 50%% %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Conversion en Jpeg + réduction 50%
:JPG50
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%.jpg
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -out jpeg  -ratio -rtype lanczos -resize 50%%%% 50%% %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Conversion en noir et blanc
:NB
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -grey 256 %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Conversion en noir et blanc + réduction 50%
:NB50
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -grey 256 -ratio -rtype lanczos -resize 50%%%% 50%% %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Permutation horizontale des images
:Hflip
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -xflip  %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Permutation horizontale des images
:Rot90
If "%overwrite%"=="1" (
	Set Dst=-overwrite
) Else (
	Set Dst=-o $%ConvertedDir%\%%
)

Echo Traitement des images en cours ...
"%~DP0nconvert.exe" %Dst% -rotate 90  %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:Fin_Traitement
If %Error%==0 (
	Call :SuccessMsg
	Echo Traitement des images effectu‚ avec succ‚s.
) Else (
	Call :ErrorMsg
	Echo Traitement des images effectu‚ avec ERREUR^(S^) !
	Echo Veuillez consulter les lignes ci-dessus pour connaitre
	Echo le nom des fichiers non trait‚s.
)
Call :Exit


:Titre
Cls
Color 0F
Echo.
Echo                         ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                         º                              º
Echo                         º        SIConverter v%version%      º
Echo                         º                              º
Echo                         ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Echo.
Goto :Eof

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
Echo.
Goto :EOF


:Exit
Echo.&Echo.
Echo Appuyez sur une touche pour quitter.
Pause>Nul
Exit


:EOF
