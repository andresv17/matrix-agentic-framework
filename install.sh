#!/usr/bin/env bash
# ==============================================================================
# Matrix Agentic Framework — Multi-Platform Interactive Installer & Wizard
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREW_SRC="$SCRIPT_DIR/skills/crew"
SOURCE_SRC="$SCRIPT_DIR/skills/source"

# Terminal colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_banner() {
  echo -e "${BLUE}====================================================================${NC}"
  echo -e "${GREEN}${BOLD}  ⚡ Matrix Agentic Framework — Adaptive Setup Wizard${NC}"
  echo -e "${CYAN}     Autonomous Software Factory & Separation of Powers${NC}"
  echo -e "${BLUE}====================================================================${NC}"
}

print_help() {
  echo -e "Usage: ./install.sh [OPTIONS]\n"
  echo "Running ./install.sh without arguments starts the Interactive Setup Wizard."
  echo ""
  echo "CLI Options (Non-Interactive Mode):"
  echo "  --crew             Install the 20 execution roles in ~/.claude/skills/"
  echo "  --source           Install The Source in ~/.gemini/config/skills/source/"
  echo "  --all              Install both Crew and Source in default paths"
  echo "  --copy             Physically copy files instead of creating symlinks"
  echo "  --crew-dir DIR     Specify custom installation directory for the Crew"
  echo "  --source-dir DIR   Specify custom installation directory for The Source"
  echo "  --init-project DIR Initialize a project with WAL memory bus, templates & hooks"
  echo "  --help, -h         Show this help message"
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
    echo -e "  ${YELLOW}! Already exists:${NC} $dest (preserved)"
    return
  fi

  if [ "$MODE_COPY" = true ]; then
    cp -r "$src" "$dest"
    echo -e "  ${GREEN}✓ Copied:${NC} $dest"
  else
    ln -s "$src" "$dest"
    echo -e "  ${GREEN}✓ Symlink created:${NC} $dest -> $src"
  fi
}

install_crew_to() {
  local target_dir="$1"
  echo -e "\n${BLUE}▶ Installing The Matrix Crew (20 execution roles)...${NC}"
  echo -e "  Destination: ${target_dir}"
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

  echo -e "\n${BLUE}▶ Installing The Source (Sovereign Control Plane / External Auditor)...${NC}"
  echo -e "  Destination: ${target_dir}"
  mkdir -p "$target_dir"

  if [ "$is_chatgpt_export" = true ]; then
    cp "$SOURCE_SRC/SKILL.md" "$target_dir/SOURCE_INSTRUCTIONS_CHATGPT.md"
    cp "$SOURCE_SRC/references/logos.py" "$target_dir/logos.py" 2>/dev/null || true
    echo -e "  ${GREEN}✓ Exported prompt ready for Custom GPT or System Prompt:${NC} $target_dir/SOURCE_INSTRUCTIONS_CHATGPT.md"
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
  echo -e "\n${BLUE}▶ Initializing memory architecture in project: ${project_path}...${NC}"
  mkdir -p "$project_path/claude"
  mkdir -p "$project_path/.claude/hooks"
  mkdir -p "$project_path/scripts"

  local project_name="$(basename "$(cd "$project_path" && pwd)")"
  local bus_template="$SCRIPT_DIR/templates/process-log.template.md"
  [ ! -f "$bus_template" ] && bus_template="$SCRIPT_DIR/templates/registro-proceso.template.md"

  local env_template="$SCRIPT_DIR/templates/environment-and-lessons.template.md"
  [ ! -f "$env_template" ] && env_template="$SCRIPT_DIR/templates/entorno-y-lecciones.template.md"

  local bus_file="$project_path/claude/process-log-${project_name}.md"
  if [ -f "$project_path/claude/registro-proceso-${project_name}.md" ]; then
    bus_file="$project_path/claude/registro-proceso-${project_name}.md"
  fi

  if [ ! -f "$bus_file" ]; then
    sed -e "s/{{PROJECT_NAME}}/$project_name/g" \
        -e "s/{{AUTHOR_NAME}}/$USER/g" \
        -e "s/{{DATE}}/$(date +%Y-%m-%d)/g" \
        "$bus_template" > "$bus_file"
    echo -e "  ${GREEN}✓ Central bus created:${NC} $bus_file"
  else
    echo -e "  ${YELLOW}! Central bus already exists:${NC} $bus_file"
  fi

  local env_file="$project_path/claude/environment-and-lessons.md"
  if [ -f "$project_path/claude/entorno-y-lecciones.md" ]; then
    env_file="$project_path/claude/entorno-y-lecciones.md"
  fi

  if [ ! -f "$env_file" ]; then
    sed "s/{{PROJECT_NAME}}/$project_name/g" "$env_template" > "$env_file"
    echo -e "  ${GREEN}✓ Environment & lessons created:${NC} $env_file"
  fi

  cp "$SCRIPT_DIR/templates/session-context.mjs" "$project_path/.claude/hooks/session-context.mjs"
  chmod +x "$project_path/.claude/hooks/session-context.mjs"
  echo -e "  ${GREEN}✓ Live memory hook installed:${NC} .claude/hooks/session-context.mjs"

  if [ ! -f "$project_path/.claude/settings.json" ]; then
    cp "$SCRIPT_DIR/templates/settings.hooks.json" "$project_path/.claude/settings.json"
    echo -e "  ${GREEN}✓ Hook configuration created:${NC} .claude/settings.json"
  fi

  if [ ! -f "$project_path/scripts/logos.py" ]; then
    cp "$SCRIPT_DIR/templates/logos.py" "$project_path/scripts/logos.py"
    chmod +x "$project_path/scripts/logos.py"
    echo -e "  ${GREEN}✓ Logos M2M channel provisioned:${NC} scripts/logos.py"
  fi
}

run_interactive_wizard() {
  print_banner
  echo -e "\n${BOLD}Welcome to the Matrix Agentic Framework Setup Wizard.${NC}"
  echo -e "This wizard configures your environment adhering to the"
  echo -e "${YELLOW}Separation of Powers${NC} principle (execution squad vs external auditor).\n"

  # -------------------------------------------------------------
  # STEP 1: THE MATRIX CREW
  # -------------------------------------------------------------
  echo -e "${CYAN}${BOLD}[Step 1 of 3] Where would you like to install THE EXECUTION CREW (20 roles)?${NC}"
  echo -e "The crew (Morpheus, Architect, Keymaker, etc.) writes code, tests, and designs."
  echo "  1) Claude Code CLI       (~/.claude/skills/) [Recommended for development]"
  echo "  2) Google Antigravity    (~/.gemini/antigravity/skills/)"
  echo "  3) Cursor / VS Code      (~/.cursor/rules/matrix/)"
  echo "  4) Custom path"
  echo "  5) Skip crew installation for now"
  read -rp "Select an option [1-5] (default: 1): " crew_choice
  crew_choice="${crew_choice:-1}"

  local selected_crew_dir=""
  case "$crew_choice" in
    1) selected_crew_dir="${HOME}/.claude/skills" ;;
    2) selected_crew_dir="${HOME}/.gemini/antigravity/skills" ;;
    3) selected_crew_dir="${HOME}/.cursor/rules/matrix" ;;
    4)
      read -rp "Enter absolute path: " selected_crew_dir
      ;;
    5) selected_crew_dir="" ;;
    *) selected_crew_dir="${HOME}/.claude/skills" ;;
  esac

  # -------------------------------------------------------------
  # STEP 2: THE SOURCE (SOVEREIGN AUDITOR)
  # -------------------------------------------------------------
  echo -e "\n${CYAN}${BOLD}[Step 2 of 3] Where would you like to install THE SOURCE (Sovereign Auditor)?${NC}"
  echo -e "${YELLOW}💡 Golden Rule:${NC} To prevent confirmation bias and self-validating hallucinations,"
  echo -e "it is strongly recommended to select a ${BOLD}different${NC} engine than Step 1."
  
  if [ "$crew_choice" = "1" ]; then
    echo -e "  → Since you selected Claude for the crew, we recommend installing Source in Gemini or ChatGPT."
  elif [ "$crew_choice" = "2" ]; then
    echo -e "  → Since you selected Gemini/Antigravity for the crew, we recommend installing Source in Claude or ChatGPT."
  fi

  echo "  1) Google Antigravity / Gemini   (~/.gemini/config/skills/source/) [Recommended if using Claude]"
  echo "  2) ChatGPT / OpenAI (Export)     (~/.matrix-framework/chatgpt-source/)"
  echo "  3) Claude Code CLI               (~/.claude/skills/source/) [Only if using a single engine]"
  echo "  4) Custom path"
  echo "  5) Skip The Source for now"
  read -rp "Select an option [1-5] (default: 1): " source_choice
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
      read -rp "Enter absolute path: " selected_source_dir
      ;;
    5) selected_source_dir="" ;;
    *) selected_source_dir="${HOME}/.gemini/config/skills/source" ;;
  esac

  # -------------------------------------------------------------
  # STEP 3: LINKING METHOD
  # -------------------------------------------------------------
  echo -e "\n${CYAN}${BOLD}[Step 3 of 3] How would you like to link the skill files?${NC}"
  echo "  1) Symlinks [Recommended: automatically updates with git pull]"
  echo "  2) Physical copy"
  read -rp "Select an option [1-2] (default: 1): " link_choice
  if [ "$link_choice" = "2" ]; then
    MODE_COPY=true
  fi

  # Execute installations
  if [ -n "$selected_crew_dir" ]; then
    install_crew_to "$selected_crew_dir"
  fi

  if [ -n "$selected_source_dir" ]; then
    install_source_to "$selected_source_dir" "$is_chatgpt"
  fi

  # Ask to initialize a project now
  echo -e "\n${CYAN}${BOLD}[Optional] Project Initialization${NC}"
  read -rp "Initialize the memory bus in an existing project now? (Path or Enter to skip): " target_proj
  if [ -n "$target_proj" ] && [ -d "$target_proj" ]; then
    init_project "$target_proj"
  fi

  echo -e "\n${GREEN}${BOLD}✔ Setup completed successfully!${NC}\n"
  exit 0
}

# =============================================================
# CLI ARGUMENT HANDLING OR WIZARD LAUNCH
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
      echo -e "${RED}Unknown option: $1${NC}"
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

echo -e "\n${GREEN}✔ Operation completed successfully.${NC}\n"
