# OceanVis UI Repair Report

This build repairs the prototype shell with a real textured WebGL Earth, a sharp vector 2D world map, responsive panel behavior, and improved interaction wiring.

## Changes
- Replaced the old canvas-drawn globe with a WebGL sphere using a local 2048px equirectangular Earth texture and atmospheric styling.
- Added geographic observation markers, current-vector overlay, hover/selection behavior, zoom, reset, and auto-rotation controls.
- Replaced the old approximate 2D map with a scalable SVG world map derived from Natural Earth low-resolution country geometry, plus interactive pan/zoom, observation markers, region context, and layer controls.
- Changed the bottom workspace to a responsive single-panel view on compact displays so cards do not collapse into unusable columns.
- Wired visualization-related sidebar routes to the actual globe/map/panel experiences instead of leaving them on a generic placeholder.
- Made the top-bar date/time dynamic from the local system clock (UTC display).
- Made observation counts in the layer panel derive from the loaded observation collection.
- Made the time-period controls perform actual state changes.
- Made the header download action open the export workspace.
- Replaced visible DEMO/LIVE ambiguity with a truthful `PREVIEW DATA` state in the bundled prototype UI. Synthetic data is not relabeled as live scientific data.
- Added high-DPI handling with a capped device pixel ratio for canvas rendering.
- Added a local Earth texture and vector world-map asset so the prototype does not depend on an external image host for its primary Earth/map visuals.

## Validation
- Parsed all 28 TypeScript/TSX source files with the TypeScript parser: 0 syntax errors.
- The container does not have the project's npm dependencies installed and external package retrieval is unavailable here, so a fresh `npm ci && npm run build` could not be rerun in this environment.
- No existing Java/Maven build environment was available in this container.

## Local build
From `frontend/`:

    npm ci
    npm run build

Then launch the Spring Boot application using the existing project launcher.
