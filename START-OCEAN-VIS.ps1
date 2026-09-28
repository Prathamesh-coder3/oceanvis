# ==============================================================================
# OceanVis — Scientific Ocean Visualization Platform (SIH26067)
# Single Web Application Launcher (Windows PowerShell)
# ==============================================================================

$ErrorActionPreference = "Continue"

$root = $PSScriptRoot
if (-not $root) {
    $root = (Get-Location).Path
}
Set-Location $root

Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host " OCEANVIS -- SCIENTIFIC OCEAN VISUALIZATION PLATFORM" -ForegroundColor Cyan
Write-Host " Problem Statement: SIH26067 | Single-Process Desktop Launcher" -ForegroundColor Cyan
Write-Host "==============================================================" -ForegroundColor Cyan

# 1. Clean stale port files
$portFile1 = Join-Path $root ".backend-port"
$portFile2 = Join-Path (Join-Path $root "backend") ".backend-port"
if (Test-Path $portFile1) {
    Remove-Item $portFile1 -Force -ErrorAction SilentlyContinue
}
if (Test-Path $portFile2) {
    Remove-Item $portFile2 -Force -ErrorAction SilentlyContinue
}

# 2. Check Java
Write-Host "[OceanVis] Checking Java environment..." -ForegroundColor Cyan
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaCmd) {
    Write-Host "[OceanVis] ERROR: Java not found in system PATH." -ForegroundColor Red
    Write-Host "[OceanVis] Please install JDK 21 or later and ensure java is in your PATH." -ForegroundColor Yellow
    exit 1
}
Write-Host "[OceanVis] Java OK" -ForegroundColor Green

# 3. Ensure frontend static resources exist
$staticIndex = Join-Path $root "src\main\resources\static\index.html"
$frontendDir = Join-Path $root "frontend"
if (-not (Test-Path $staticIndex)) {
    Write-Host "[OceanVis] Frontend static bundle not found in src/main/resources/static." -ForegroundColor Yellow
    if (Test-Path $frontendDir) {
        Write-Host "[OceanVis] Building React SPA with Vite..." -ForegroundColor Cyan
        Push-Location $frontendDir
        if (Test-Path "package.json") {
            if (-not (Test-Path "node_modules")) {
                Write-Host "[OceanVis] Installing locked frontend dependencies..." -ForegroundColor Cyan
                & npm.cmd ci
            }
            & npm.cmd run build
            if ($LASTEXITCODE -eq 0 -and (Test-Path "dist\index.html")) {
                New-Item -ItemType Directory -Force -Path (Join-Path $root "src\mainesources\static") | Out-Null
                Copy-Item -Path "dist\*" -Destination (Join-Path $root "src\mainesources\static") -Recurse -Force
                Write-Host "[OceanVis] Frontend build copied into Spring static resources." -ForegroundColor Green
            }
        }
        Pop-Location
        if (Test-Path $staticIndex) {
            Write-Host "[OceanVis] Frontend static bundle verified: OK" -ForegroundColor Green
        } else {
            Write-Host "[OceanVis] WARNING: Frontend static bundle is unavailable." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "[OceanVis] Frontend static bundle verified: OK" -ForegroundColor Green
}

# 4. Check for packaged JAR
$targetDir = Join-Path $root "target"
$jarFile = $null
if (Test-Path $targetDir) {
    $candidates = Get-ChildItem -Path $targetDir -Filter "oceanvis-*.jar" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notlike "*sources*" -and $_.Name -notlike "*javadoc*" }
    if ($candidates) {
        $jarFile = $candidates[0]
    }
}

if ($jarFile -and (Test-Path $jarFile.FullName)) {
    $jarName = $jarFile.Name
    Write-Host "[OceanVis] Found packaged production JAR: $jarName" -ForegroundColor Green
    Write-Host "[OceanVis] Launching single Java process..." -ForegroundColor Cyan
    Write-Host "==============================================================" -ForegroundColor Cyan
    & java -jar $jarFile.FullName
} else {
    Write-Host "[OceanVis] Packaged JAR not found. Checking Maven..." -ForegroundColor Yellow
    $mvnCmd = Get-Command mvn -ErrorAction SilentlyContinue
    if ($mvnCmd) {
        Write-Host "[OceanVis] Launching via Maven spring-boot:run..." -ForegroundColor Green
        Write-Host "==============================================================" -ForegroundColor Cyan
        & mvn spring-boot:run
    } else {
        Write-Host "[OceanVis] ERROR: Neither a packaged JAR nor Maven was found." -ForegroundColor Red
        Write-Host "[OceanVis] Run 'mvn package -DskipTests' first to create target/oceanvis-1.0.0.jar." -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "[OceanVis] Application shutdown complete." -ForegroundColor Yellow
