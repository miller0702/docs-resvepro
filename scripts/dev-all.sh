#!/usr/bin/env bash
# Levanta API (8000), Admin (8002) y Mobile Metro (8003) en paralelo.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$DOCS_DIR/.." && pwd)"

for dir in egw-api egw-admin egw-mobile; do
  if [[ ! -d "$ROOT_DIR/$dir" ]]; then
    echo "Error: no se encontró $ROOT_DIR/$dir"
    echo "Clona los repos hermanos según REPOS.md"
    exit 1
  fi
done

if [[ -f "$DOCS_DIR/package.json" ]] && command -v pnpm >/dev/null; then
  cd "$DOCS_DIR"
  if [[ ! -d node_modules/concurrently ]]; then
    echo "Instalando dependencias de orquestación en docs/..."
    pnpm install
  fi
  exec pnpm dev:all
fi

echo "Iniciando servicios (fallback sin concurrently)..."
cleanup() {
  for pid in $(jobs -p); do
    kill "$pid" 2>/dev/null || true
  done
}
trap cleanup EXIT INT TERM

(cd "$ROOT_DIR/egw-api" && pnpm dev) &
(cd "$ROOT_DIR/egw-admin" && pnpm dev) &
(cd "$ROOT_DIR/egw-mobile" && pnpm start:dev) &

wait
