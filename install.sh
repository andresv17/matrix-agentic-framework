#!/usr/bin/env bash
# ==============================================================================
# Matrix Agentic Framework — Multi-Platform Interactive Installer & Wizard
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREW_SRC="$SCRIPT_DIR/skills/crew"
SOURCE_SRC="$SCRIPT_DIR/skills/source"

# Colores para salida de terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_banner() {
  echo -e "${BLUE}====================================================================${NC}"
  echo -e "${GREEN}${BOLD}  ⚡ Matrix Agentic Framework — Asistente de Instalación Adaptativa${NC}"
  echo -e "${CYAN}     Fábrica de Software Agéntica & Separación de Poderes${NC}"
  echo -e "${BLUE}====================================================================${NC}"
}

print_help() {
  echo -e "Uso: ./install.sh [OPCIONES]\n"
  echo "Si ejecutas ./install.sh sin argumentos, se iniciará el Asistente Interactivo."
  echo ""
  echo "Opciones CLI (Modo No-Interactivo):"
  echo "  --crew             Instala los 20 roles ejecutores en ~/.claude/skills/"
  echo "  --source           Instala Source en ~/.gemini/config/skills/source/"
  echo "  --all              Instala tanto la tripulación como Source en rutas por defecto"
  echo "  --copy             Copia los archivos físicamente en vez de crear symlinks"
  echo "  --crew-dir DIR     Especifica una ruta personalizada para la Tripulación"
  echo "  --source-dir DIR   Especifica una ruta personalizada para Source"
  echo "  --init-project DIR Inicializa un nuevo proyecto con el bus WAL, templates y hooks"
  echo "  --help, -h         Muestra este mensaje de ayuda"
}

MODE_COPY=false
TARGET=""
INIT_DIR=""
CUSTOM_CREW_DIR=""
CUSTOM_SOURCE_DIR=""

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

install_crew_to() {
  local target_dir="$1"
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

install_source_to() {
  local target_dir="$1"
  local is_chatgpt_export="$2"

  echo -e "\n${BLUE}▶ Instalando The Source (Plano Soberano / Auditor Externo)...${NC}"
  echo -e "  Destino: ${target_dir}"
  mkdir -p "$target_dir"

  if [ "$is_chatgpt_export" = true ]; then
    cp "$SOURCE_SRC/SKILL.md" "$target_dir/SOURCE_INSTRUCTIONS_CHATGPT.md"
    cp "$SOURCE_SRC/references/logos.py" "$target_dir/logos.py" 2>/dev/null || true
    echo -e "  ${GREEN}✓ Exportado prompt listo para Custom GPT o System Prompt:${NC} $target_dir/SOURCE_INSTRUCTIONS_CHATGPT.md"
  else
    link_or_copy "$SOURCE_SRC/SKILL.md" "$target_dir/SKILL.md"
    if [ -d "$SOURCE_SRC/references" ]; then
      mkdir -p "$target_dir/references"
      link_or_copy "$SOURCE_SRC/references/logos.py" "$target_dir/references/logos.py"
    fi
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

run_interactive_wizard() {
  print_banner
  echo -e "\n${BOLD}Bienvenido al configurador del Matrix Agentic Framework.${NC}"
  echo -e "Este asistente te guiará para configurar tu entorno respetando el principio de"
  echo -e "${YELLOW}Separación de Poderes${NC} (ejecutores vs auditor externo sin cámara de eco).\n"

  # -------------------------------------------------------------
  # PASO 1: LA TRIPULACIÓN (THE MATRIX CREW)
  # -------------------------------------------------------------
  echo -e "${CYAN}${BOLD}[Paso 1 de 3] ¿Dónde deseas instalar a LA TRIPULACIÓN EJECUTORA (20 roles)?${NC}"
  echo -e "La tripulación (Morpheus, Architect, Keymaker, etc.) ejecuta código, tests y diseño."
  echo "  1) Claude Code CLI       (~/.claude/skills/) [Recomendado para desarrollo]"
  echo "  2) Google Antigravity    (~/.gemini/antigravity/skills/)"
  echo "  3) Cursor / VS Code      (~/.cursor/rules/matrix/)"
  echo "  4) Otra ruta personalizada"
  echo "  5) Omitir la tripulación por ahora"
  read -rp "Selecciona una opción [1-5] (por defecto: 1): " crew_choice
  crew_choice="${crew_choice:-1}"

  local selected_crew_dir=""
  case "$crew_choice" in
    1) selected_crew_dir="${HOME}/.claude/skills" ;;
    2) selected_crew_dir="${HOME}/.gemini/antigravity/skills" ;;
    3) selected_crew_dir="${HOME}/.cursor/rules/matrix" ;;
    4)
      read -rp "Ingresa la ruta absoluta deseada: " selected_crew_dir
      ;;
    5) selected_crew_dir="" ;;
    *) selected_crew_dir="${HOME}/.claude/skills" ;;
  esac

  # -------------------------------------------------------------
  # PASO 2: THE SOURCE (AUDITOR SOBERANO)
  # -------------------------------------------------------------
  echo -e "\n${CYAN}${BOLD}[Paso 2 de 3] ¿Dónde deseas instalar a THE SOURCE (Auditor Soberano)?${NC}"
  echo -e "${YELLOW}💡 Regla de oro:${NC} Para evitar que el auditor valide sus propias alucinaciones,"
  echo -e "se recomienda fuertemente elegir un motor o entorno ${BOLD}diferente${NC} al del Paso 1."
  
  if [ "$crew_choice" = "1" ]; then
    echo -e "  → Como elegiste Claude para la tripulación, lo ideal es instalar Source en Gemini o ChatGPT."
  elif [ "$crew_choice" = "2" ]; then
    echo -e "  → Como elegiste Gemini/Antigravity para la tripulación, lo ideal es instalar Source en Claude o ChatGPT."
  fi

  echo "  1) Google Antigravity / Gemini   (~/.gemini/config/skills/source/) [Recomendado si usas Claude]"
  echo "  2) ChatGPT / OpenAI (Exportar)   (~/.matrix-framework/chatgpt-source/)"
  echo "  3) Claude Code CLI               (~/.claude/skills/source/) [Solo si usas un único motor]"
  echo "  4) Otra ruta personalizada"
  echo "  5) Omitir The Source por ahora"
  read -rp "Selecciona una opción [1-5] (por defecto: 1): " source_choice
  source_choice="${source_choice:-1}"

  local selected_source_dir=""
  local is_chatgpt=false
  case "$source_choice" in
    1) selected_source_dir="${HOME}/.gemini/config/skills/source" ;;
    2)
      selected_source_dir="${HOME}/.matrix-framework/chatgpt-source"
      is_chatgpt=true
      ;;
    3) selected_source_dir="${HOME}/.claude/skills/source" ;;
    4)
      read -rp "Ingresa la ruta absoluta deseada: " selected_source_dir
      ;;
    5) selected_source_dir="" ;;
    *) selected_source_dir="${HOME}/.gemini/config/skills/source" ;;
  esac

  # -------------------------------------------------------------
  # PASO 3: TIPO DE INSTALACIÓN
  # -------------------------------------------------------------
  echo -e "\n${CYAN}${BOLD}[Paso 3 de 3] ¿Cómo deseas enlazar los archivos?${NC}"
  echo "  1) Enlaces simbólicos (symlinks) [Recomendado: se actualizan con cada git pull]"
  echo "  2) Copia física independiente"
  read -rp "Selecciona una opción [1-2] (por defecto: 1): " link_choice
  if [ "$link_choice" = "2" ]; then
    MODE_COPY=true
  fi

  # Ejecutar instalaciones
  if [ -n "$selected_crew_dir" ]; then
    install_crew_to "$selected_crew_dir"
  fi

  if [ -n "$selected_source_dir" ]; then
    install_source_to "$selected_source_dir" "$is_chatgpt"
  fi

  # Preguntar si desea inicializar un proyecto ahora
  echo -e "\n${CYAN}${BOLD}[Opcional] Inicialización de Proyecto${NC}"
  read -rp "¿Deseas inicializar el bus de memoria en algún proyecto ahora? (Ruta o Enter para omitir): " target_proj
  if [ -n "$target_proj" ] && [ -d "$target_proj" ]; then
    init_project "$target_proj"
  fi

  echo -e "\n${GREEN}${BOLD}✔ ¡Configuración completada exitosamente!${NC}\n"
  exit 0
}

# =============================================================
# MANEJO DE ARGUMENTOS CLI O LANZAMIENTO DE WIZARD
# =============================================================
if [ $# -eq 0 ]; then
  run_interactive_wizard
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
    --crew-dir)
      CUSTOM_CREW_DIR="$2"
      shift 2
      ;;
    --source-dir)
      CUSTOM_SOURCE_DIR="$2"
      shift 2
      ;;
    --copy)
      MODE_COPY=true
      shift
      ;;
    --interactive|-i)
      run_interactive_wizard
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

print_banner

if [ "$TARGET" = "crew" ] || [ "$TARGET" = "all" ]; then
  target_dir="${CUSTOM_CREW_DIR:-$HOME/.claude/skills}"
  install_crew_to "$target_dir"
fi

if [ "$TARGET" = "source" ] || [ "$TARGET" = "all" ]; then
  target_dir="${CUSTOM_SOURCE_DIR:-$HOME/.gemini/config/skills/source}"
  install_source_to "$target_dir" false
fi

if [ -n "$INIT_DIR" ]; then
  init_project "$INIT_DIR"
fi

echo -e "\n${GREEN}✔ Operación completada con éxito.${NC}\n"
