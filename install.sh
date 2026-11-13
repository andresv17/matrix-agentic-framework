#!/usr/bin/env bash
# ==============================================================================
# Matrix Agentic Framework — Multi-Platform Installer
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREW_SRC="$SCRIPT_DIR/skills/crew"
SOURCE_SRC="$SCRIPT_DIR/skills/source"

# Colores para salida de terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_banner() {
  echo -e "${BLUE}====================================================================${NC}"
  echo -e "${GREEN}  ⚡ Matrix Agentic Framework — Multi-Agent Engineering Squad${NC}"
  echo -e "${BLUE}====================================================================${NC}"
}

print_help() {
  echo -e "Uso: ./install.sh [OPCIONES]\n"
  echo "Opciones de Instalación Global de Skills:"
  echo "  --crew             Instala los 20 roles ejecutores (en ~/.claude/skills/)"
  echo "  --source           Instala el rol soberano / auditor (en ~/.gemini/config/skills/source/)"
  echo "  --all              Instala tanto la tripulación como Source"
  echo "  --copy             Copia los archivos físicamente en vez de crear symlinks"
  echo ""
  echo "Opciones para Proyectos:"
  echo "  --init-project DIR Inicializa un nuevo proyecto con el bus WAL, templates y hooks"
  echo ""
  echo "Otras Opciones:"
  echo "  --help, -h         Muestra este mensaje de ayuda"
  echo ""
  echo "Ejemplos:"
  echo "  ./install.sh --crew               # Instala el equipo ejecutor en Claude Code"
  echo "  ./install.sh --source             # Instala Source en Gemini / Antigravity"
  echo "  ./install.sh --all                # Instala ambos roles en tu máquina"
  echo "  ./install.sh --init-project .     # Configura el bus de memoria en la carpeta actual"
}

MODE_COPY=false
TARGET=""
INIT_DIR=""

if [ $# -eq 0 ]; then
  print_banner
  print_help
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --crew)
      TARGET="crew"
      shift
      ;;
    --source)
      TARGET="source"
      shift
      ;;
    --all)
      TARGET="all"
      shift
      ;;
    --copy)
      MODE_COPY=true
      shift
      ;;
    --init-project)
      INIT_DIR="$2"
      shift 2
      ;;
    --help|-h)
      print_banner
      print_help
      exit 0
      ;;
    *)
      echo -e "${RED}Opción desconocida: $1${NC}"
      print_help
      exit 1
      ;;
  esac
done

link_or_copy() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo -e "  ${YELLOW}! Ya existe:${NC} $dest (conservado)"
    return
  fi

  if [ "$MODE_COPY" = true ]; then
    cp -r "$src" "$dest"
    echo -e "  ${GREEN}✓ Copiado:${NC} $dest"
  else
    ln -s "$src" "$dest"
    echo -e "  ${GREEN}✓ Enlace creado:${NC} $dest -> $src"
  fi
}

install_crew() {
  local target_dir="${HOME}/.claude/skills"
  echo -e "\n${BLUE}▶ Instalando la tripulación de la Matrix (20 roles ejecutores)...${NC}"
  echo -e "  Destino: ${target_dir}"
  mkdir -p "$target_dir"

  for skill_dir in "$CREW_SRC"/*; do
    if [ -d "$skill_dir" ]; then
      local skill_name="$(basename "$skill_dir")"
      link_or_copy "$skill_dir" "$target_dir/$skill_name"
    fi
  done
}

install_source() {
  local target_dir="${HOME}/.gemini/config/skills/source"
  echo -e "\n${BLUE}▶ Instalando The Source (Plano Soberano / Auditor Externo)...${NC}"
  echo -e "  Destino: ${target_dir}"
  mkdir -p "$target_dir"

  link_or_copy "$SOURCE_SRC/SKILL.md" "$target_dir/SKILL.md"
  if [ -d "$SOURCE_SRC/references" ]; then
    mkdir -p "$target_dir/references"
    link_or_copy "$SOURCE_SRC/references/logos.py" "$target_dir/references/logos.py"
  fi
}

init_project() {
  local project_path="$1"
  echo -e "\n${BLUE}▶ Inicializando arquitectura de memoria en el proyecto: ${project_path}...${NC}"
  mkdir -p "$project_path/claude"
  mkdir -p "$project_path/.claude/hooks"
  mkdir -p "$project_path/scripts"

  local project_name="$(basename "$(cd "$project_path" && pwd)")"
  local bus_file="$project_path/claude/registro-proceso-${project_name}.md"

  if [ ! -f "$bus_file" ]; then
    sed -e "s/{{PROJECT_NAME}}/$project_name/g" \
        -e "s/{{AUTHOR_NAME}}/$USER/g" \
        -e "s/{{DATE}}/$(date +%Y-%m-%d)/g" \
        "$SCRIPT_DIR/templates/registro-proceso.template.md" > "$bus_file"
    echo -e "  ${GREEN}✓ Bus central creado:${NC} $bus_file"
  else
    echo -e "  ${YELLOW}! Bus central ya existía:${NC} $bus_file"
  fi

  local env_file="$project_path/claude/entorno-y-lecciones.md"
  if [ ! -f "$env_file" ]; then
    sed "s/{{PROJECT_NAME}}/$project_name/g" "$SCRIPT_DIR/templates/entorno-y-lecciones.template.md" > "$env_file"
    echo -e "  ${GREEN}✓ Entorno y lecciones creado:${NC} $env_file"
  fi

  cp "$SCRIPT_DIR/templates/session-context.mjs" "$project_path/.claude/hooks/session-context.mjs"
  chmod +x "$project_path/.claude/hooks/session-context.mjs"
  echo -e "  ${GREEN}✓ Hook de memoria viva instalado:${NC} .claude/hooks/session-context.mjs"

  if [ ! -f "$project_path/.claude/settings.json" ]; then
    cp "$SCRIPT_DIR/templates/settings.hooks.json" "$project_path/.claude/settings.json"
    echo -e "  ${GREEN}✓ Configuración de hooks creada:${NC} .claude/settings.json"
  fi

  if [ ! -f "$project_path/scripts/logos.py" ]; then
    cp "$SCRIPT_DIR/templates/logos.py" "$project_path/scripts/logos.py"
    chmod +x "$project_path/scripts/logos.py"
    echo -e "  ${GREEN}✓ Canal Logos aprovisionado:${NC} scripts/logos.py"
  fi
}

print_banner

if [ "$TARGET" = "crew" ] || [ "$TARGET" = "all" ]; then
  install_crew
fi

if [ "$TARGET" = "source" ] || [ "$TARGET" = "all" ]; then
  install_source
fi

if [ -n "$INIT_DIR" ]; then
  init_project "$INIT_DIR"
fi

echo -e "\n${GREEN}✔ Operación completada con éxito.${NC}\n"
