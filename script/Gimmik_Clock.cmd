@rem FillPolygon_alpha.cmd
@echo off
cd /d %~dp0

echo "Powershell"を起動します
echo.

rem cd .\script

rem $Env:Path+= ";pwsh.exeへのフォルダ"

rem // -Sta シングルスレッド指定、PS2.0以前必須 //
rem pwsh.exe -ExecutionPolicy RemoteSigned -Sta -File .\Gimmik_Clock.ps1

powershell.exe -ExecutionPolicy RemoteSigned -Sta -File .\Gimmik_Clock.ps1
