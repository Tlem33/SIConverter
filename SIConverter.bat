:: SIConverter.cmd - Cr�er par Tlem le 30/08/2018
:: Simple Image Converter et un programme de conversion d'image simplifi�,
:: Utilisant l'ex�cutable Nconvert.exe de chez XNview (http://www.xnview.com).
::
:: Version 1.2 du 06/09/2018
:: Voir la section Historique du fichier LisezMoi.txt pour plus d'informations.
::

@Echo Off
Cls
Set Version=1.2


:: Attribution du nom du r�pertoire par le nom du batch.
Set ConvertedDir=%~n0


:: Test si le programme Nconvert.exe est bien dans le dossier du Batch.
If Not Exist "%~DP0nconvert.exe" (
	Call :ErrorMsg
	Echo Le programme NConvert.exe n'a pas �t� trouv� !!!
	Call :Exit
)


:: Test si des fichiers sont donn�s en argument.
If "%~1" EQU "" (
	Call :ErrorMsg
	Echo Aucun fichier a traiter ...
	Echo Effectuez un Glisser/D�poser de fichiers sur ce programme.
	Call :Exit
)


:Titre
Cls
Color 0F
Echo.
Echo                         ������������������������������ͻ
Echo                         �                              �
Echo                         �        SIConverter v%version%      �
Echo                         �                              �
Echo                         ������������������������������ͼ
Echo.
Echo.


:Choix
Echo  Quelle action d�sirez-vous effecter ?
Echo.
Echo.
Echo      1 - Convertir en Jpeg (r�duit la taille des fichiers jpg)
Echo.
Echo      2 - R�duire la taille de 50%%
Echo.
Echo      3 - Convertir en Jpeg + r�duction de 50%%
Echo.
Echo      4 - Pivoter horizontalement (remplace fichier original)
Echo.
Echo      5 - Quitter
Echo.
Echo.
Echo.
Set /P Var= Veuillez taper votre choix (1, 2, 3, 4 ou 5) :
If /I %var%==1 Goto :JPG
If /I %var%==2 Goto :50
If /I %var%==3 Goto :JPG50
If /I %var%==4 Goto :Hflip
If /I %var%==5 Exit
Goto :Choix


:: Conversion en Jpeg
:JPG
Echo Traitement des images en cours ...
"%~DP0nconvert.exe" -o $%ConvertedDir%\%%.jpg -out jpeg  %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: R�duction de la taille de 50%
:50
Echo Traitement des images en cours ...
"%~DP0nconvert.exe" -o $%ConvertedDir%\%% -ratio -rtype lanczos -resize 50%%%% 50%% %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Conversion en Jpeg + r�duction 50%
:JPG50
Echo Traitement des images en cours ...
"%~DP0nconvert.exe" -o $%ConvertedDir%\%%.jpg -out jpeg  -ratio -rtype lanczos -resize 50%%%% 50%% %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:: Permutation horizontale des images
:Hflip
Echo Traitement des images en cours ...
"%~DP0nconvert.exe" -xflip -overwrite  %*
Set Error=%ERRORLEVEL%
Goto :Fin_Traitement


:Fin_Traitement
If %Error%==0 (
	Call :SuccessMsg
	Echo Traitement des images effectu� avec succ�s.
) Else (
	Call :ErrorMsg
	Echo Traitement des images effectu� avec ERREUR^(S^) !
	Echo Veuillez consulter les lignes ci-dessus pour connaitre
	Echo le nom des fichiers non trait�s.
)
Call :Exit


:ErrorMsg
Color 0C
Echo.
Echo                          ��������������������������ͻ
Echo                          �                          �
Echo                          �          ERREUR          �
Echo                          �                          �
Echo                          ��������������������������ͼ
Echo.
Goto :EOF


:InformationMsg
Color 0E
Echo.
Echo                          ��������������������������ͻ
Echo                          �                          �
Echo                          �       INFORMATION        �
Echo                          �                          �
Echo                          ��������������������������ͼ
Echo.
Echo.
Goto :EOF


:SuccessMsg
Color 0A
Echo.
Echo                          ��������������������������ͻ
Echo                          �                          �
Echo                          �          SUCCES          �
Echo                          �                          �
Echo                          ��������������������������ͼ
Echo.
Echo.
Goto :EOF


:Exit
Echo.&Echo.
Echo Appuyez sur une touche pour quitter.
Pause>Nul
Exit


:EOF
