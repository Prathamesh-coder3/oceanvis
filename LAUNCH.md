# OceanVis Launch

## One-click Windows
Double-click `START-OCEAN-VIS.bat` (or `start.bat`).

The launcher starts one Spring Boot process, prefers the packaged JAR when present, otherwise uses Maven, selects a free port beginning at 8080, serves the built React application from Spring Boot, and opens the actual local URL in the Windows default browser.

If 8080 is occupied, the application automatically tries 8081, 8082, and so on.

## IDE launch
Running `com.oceanvis.OceanVisApplication` from the IDE uses the same Java-side dynamic port selection and Windows browser-launch logic.

## Manual fallback
If a browser does not open automatically, use the URL printed in the terminal, for example:

`http://localhost:8081`

The selected port is written to `.backend-port` after successful startup.
