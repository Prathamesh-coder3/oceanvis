# OceanVis Next-Level Prototype Archive

Base: `OceanVis_Launch_Fixed_Final(2).zip`
Problem statement: `SIH26067`

## Changes applied in this source archive

- Added a unified `WorkspaceRouter` so every declared sidebar `ActiveView` has a real destination rather than silently rendering the same screen.
- Changed startup so the splash transition is controlled independently of remote/demo API completion; initial data loading continues asynchronously.
- Added shared `selectedRegion` state and wired the header region controls to select the region and open the 2D map; the primary globe also adjusts its view rotation from the selected region.
- Reworked the bottom analysis workspace into responsive tabs. The number of simultaneous panels adapts to CSS viewport width: 4 at >=1600px, 3 at 1280–1599px, and 1 below 1280px.
- Added responsive shell rules for compact/small desktop viewports, tighter sidebar/panel sizing, overflow protection, and small-screen typography/layout behavior.
- Made the Windows launcher rebuild/copy the frontend when generated static assets are absent, and switched Maven's locked frontend dependency step from `npm install` to `npm ci`.
- Removed stale generated `target/`, `frontend/dist/`, and copied Spring static assets so the archive cannot silently launch an older frontend build that disagrees with the source changes.

## Verification performed in this environment

- Inspected the uploaded project structure and source files.
- Verified the Java launcher already contains dynamic-port selection and `ApplicationReadyEvent` browser launching logic.
- Performed TypeScript syntax/type checking with the globally available compiler. Full validation could not run because `node_modules` and the frontend dependency type packages are not installed in this sandbox.
- A clean npm dependency/build could not be executed because package download access is unavailable in this environment.
- Maven CLI is not installed in this sandbox, so a clean Spring Boot package/test run could not be executed here.

## Remaining limitations in this archive

The uploaded project still contains its existing canvas-based primary globe/map implementations. This archive does **not** claim that they have been converted to Three.js + WebGL and Leaflet/another GIS engine, because those dependencies were not available for a verified build in this environment.

Real scientific ingestion (INCOIS/ARGO/GLIDER/CTD/BGC/HYCOM/WMS/WCS) is also not claimed as completed; the project remains clearly DEMO/synthetic by default.
