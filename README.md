# OceanVis — Integrated Ocean Models & In-situ Observations

**Problem Statement:** SIH26067  
**Version:** 1.0.0 (Next-Level Prototype)  
**Architecture:** Single-Process Spring Boot + Embedded React SPA + Dynamic Port Selection

---

## 🚀 Quick Launch (Windows)

### Method A: One-Click Windows Launcher (Recommended)
Double-click:
```
START-OCEAN-VIS.bat
```
This batch file invokes `START-OCEAN-VIS.ps1` with execution policy bypass. It checks prerequisites, launches the single application process, searches for an available port starting at 8080, serves the React dashboard, and automatically opens your default web browser.

### Method B: PowerShell Launcher
Right-click or run from PowerShell:
```powershell
.\START-OCEAN-VIS.ps1
```

### Method C: Launch Packaged Production JAR directly
```cmd
java -jar target\oceanvis-1.0.0.jar
```
Or with custom port:
```cmd
java -jar target\oceanvis-1.0.0.jar --server.port=9000
```

### Method D: Maven Run (Development / Fallback)
```cmd
mvn spring-boot:run
```

---

## 🏛️ Architecture: Single-Process Model

OceanVis operates as a **single, unified application process**:

```
                    OCEANVIS
                       |
                       v
              Spring Boot Application
                       |
              Embedded Tomcat Web Server
                       |
          +------------+------------+
          |                         |
          v                         v
     REST APIs                  React SPA
     /api/...                   static/index.html + assets
          |                         |
          +------------+------------+
                       |
                       v
             System Default Browser
          (Opens http://localhost:<port>)
```

### Key Principles:
1. **ONE Java Process, ONE Port, ONE URL**: No need to start a Node/Vite server and a Java server in separate terminals for prototype demonstration.
2. **Dynamic Port Selection**:
   - Tries `8080`.
   - If occupied, seamlessly checks `8081`, `8082`, `8083`... without crashing.
   - Priority hierarchy:
     1. Command-line argument: `--server.port=XXXX`
     2. System property: `-Dserver.port=XXXX`
     3. Environment variable: `PORT` or `SERVER_PORT`
     4. Automatic sequential scan: `8080` -> `8081` -> `...`
3. **Automatic Browser Launch**:
   - When Spring Boot emits `ApplicationReadyEvent` and the embedded Tomcat is fully listening, `BrowserLauncher` opens `http://localhost:<port>` via Java Desktop API with fallbacks (`cmd start`, `open`, `xdg-open`).
   - If browser opening is blocked, the application keeps running and logs the URL for manual access.
4. **Port File Tracking**:
   - The selected port is recorded in `.backend-port` upon startup.
   - Automatically cleaned up on application shutdown.
5. **Instant OceanVis Splash Screen**:
   - Pure HTML/CSS splash renders immediately without waiting for JS execution.
   - Animated SVG ocean waves, glowing pulse, and progress bar.
   - Non-blocking async data hydration transitions smoothly to the 3D dashboard within 2–3 seconds.

---

## 🧪 Verification & Launch Tests

| Test Scenario | Command | Expected Outcome |
|---|---|---|
| **Standard Launch** | `.\START-OCEAN-VIS.bat` | Binds 8080 (if free), launches browser, shows splash screen |
| **Port Conflict Handling** | Run two instances | Instance 1 uses 8080; Instance 2 automatically binds 8081 |
| **Direct JAR Run** | `java -jar target\oceanvis-1.0.0.jar` | Production performance, starts in ~3-4s |
| **Explicit Port Override** | `java -jar target\oceanvis-1.0.0.jar --server.port=8090` | Binds 8090 |
| **SPA Route Fallback** | Access `http://localhost:<port>/overview` | Resolves to `index.html` via `WebConfig` |

---

## 📡 API Endpoints

- `GET /api/health` — Application health check
- `GET /api/data-status` — Data mode, providers, records count, cache status
- `GET /api/datasets` — Datasets catalog
- `GET /api/demo/overview` — Aggregated overview metrics
- `GET /api/demo/observations` — In-situ observations (ARGO, Gliders, CTD, Moored Buoys)
- `GET /api/demo/alerts` — Scientific anomaly alerts
- `GET /api/demo/sources` — Data provider sources
- `GET /api/demo/model-slice` — 2D slice for temperature, salinity, currents
- `GET /api/demo/profile/{id}` — Vertical depth profile for observation vs model
- `GET /api/demo/comparison` — Scatter points & statistics (MAE, RMSE, bias)
- `GET /api/demo/timeseries` — Time-series history
- `GET /api/demo/transect` — 2D section slice

---

## 🛠️ Development Mode (Optional)

For frontend developers making live UI edits with hot-reload:
```cmd
cd frontend
npm run dev
```
Vite runs at `http://localhost:5173` and proxies `/api/*` to `http://localhost:8080`.  
Production release packages the frontend into `src/main/resources/static` so Spring Boot alone delivers the entire application.

---

## 📦 Build Instructions

The production source archive already includes the React build under `src/main/resources/static`, so Java/Maven packaging does not need Node/npm.

```cmd
mvn clean package -DskipTests
```
The resulting JAR at `target/oceanvis-1.0.0.jar` contains the complete application.

For frontend source development, build the React app separately:
```cmd
cd frontend
npm ci
npm run build
```
Then copy `frontend/dist` into `src/main/resources/static` before creating a new release when you want the latest source-rendered UI in the packaged JAR.

## One-click launch (Windows)

Use `START-OCEAN-VIS.bat` (or `start.bat`). The launcher starts the single Spring Boot application, automatically selects a free port starting at 8080, serves the built React frontend from Spring Boot, and opens the actual local URL in the default browser. If 8080 is busy, it automatically tries 8081, 8082, and so on.

The application prints the selected URL in the terminal. The splash screen is shown by the React application before the main dashboard appears.
