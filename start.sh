#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "============================================================"
echo "  OceanVis - Integrated Ocean Models & In-situ Observations"
echo "  SIH26067"
echo "============================================================"
echo ""

if compgen -G "target/oceanvis-*.jar" > /dev/null; then
  JAR=$(find target -maxdepth 1 -type f -name 'oceanvis-*.jar' ! -name '*sources*' ! -name '*javadoc*' | head -n 1)
  exec java -jar "$JAR"
fi

if command -v mvn >/dev/null 2>&1; then
  exec mvn spring-boot:run
fi

if command -v ./mvnw >/dev/null 2>&1; then
  exec ./mvnw spring-boot:run
fi

STATIC_INDEX="src/main/resources/static/index.html"
if [ ! -f "$STATIC_INDEX" ] && command -v npm >/dev/null 2>&1; then
  if [ ! -d "frontend/node_modules" ]; then npm ci --prefix frontend; fi
  npm run build --prefix frontend
  rm -rf src/main/resources/static
  mkdir -p src/main/resources/static
  cp -R frontend/dist/. src/main/resources/static/
  if command -v java >/dev/null 2>&1; then
    echo "[OceanVis] Frontend rebuilt. Run 'mvn spring-boot:run' or package the Spring Boot app to launch."
  fi
fi

echo "[OceanVis] ERROR: No packaged JAR, Maven, or Maven Wrapper found."
exit 1
