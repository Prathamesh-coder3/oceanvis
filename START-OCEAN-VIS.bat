@echo off
setlocal enabledelayedexpansion
title OceanVis - Scientific Ocean Visualization Platform (SIH26067)
cd /d "%~dp0"

echo ==============================================================
echo   OCEANVIS - SCIENTIFIC OCEAN VISUALIZATION PLATFORM
echo   SIH26067 - Single-Process Launcher
echo ==============================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0START-OCEAN-VIS.ps1"

if errorlevel 1 (
    echo.
    echo [OceanVis] Launcher exited with error code: %errorlevel%
    pause
)
