@rem FillPolygon_alpha.cmd
@echo off
cd /d %~dp0

echo "Powershell"���N�����܂�
echo.

rem cd .\script

rem $Env:Path+= ";pwsh.exe�ւ̃t�H���_"

rem // -Sta �V���O���X���b�h�w��APS2.0�ȑO�K�{ //
rem pwsh.exe -ExecutionPolicy RemoteSigned -Sta -File .\Gimmik_Clock.ps1

powershell.exe -ExecutionPolicy RemoteSigned -Sta -File .\Gimmik_Clock.ps1
