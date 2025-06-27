#!/bin/bash
# ai_global_installer_updated.sh - Instalador Global Simplificado
# Assume que os clientes codex, claude e gemini já estão instalados

set -euo pipefail

# Configurações
INSTALL_DIR="/opt/ai-parallel-systems"
BIN_DIR="/usr/local/bin"
CONFIG_DIR="$HOME/.config/ai-parallel"
SHARE_DIR="$HOME/.local/share/ai-parallel"
CACHE_DIR="$HOME/.cache/ai-parallel"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função para detectar distribuição
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/manjaro-release ]; then
        echo "manjaro"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para verificar clientes existentes
check_existing_clients() {
    log_info "Verificando clientes de IA existentes..."
    
    local clients_found=0
    local missing_clients=()
    
    # Verificar cada cliente
    if command_exists codex; then
        log_success "✓ Codex CLI encontrado: $(which codex)"
        ((clients_found++))
    else
        log_warn "✗ Codex CLI não encontrado"
        missing_clients+=("codex")
    fi
    
    if command_exists claude; then
        log_success "✓ Claude CLI encontrado: $(which claude)"
        ((clients_found++))
    else
        log_warn "✗ Claude CLI não encontrado"
        missing_clients+=("claude")
    fi
    
    if command_exists gemini; then
        log_success "✓ Gemini CLI encontrado: $(which gemini)"
        ((clients_found++))
    else
        log_warn "✗ Gemini CLI não encontrado"
        missing_clients+=("gemini")
    fi
    
    echo
    log_info "Resumo: $clients_found/3 clientes encontrados"
    
    if [ $clients_found -eq 0 ]; then
        log_error "Nenhum cliente de IA encontrado!"
        echo "Por favor, instale pelo menos um dos seguintes clientes:"
        echo "  - codex (OpenAI Codex CLI)"
        echo "  - claude (Anthropic Claude CLI)"
        echo "  - gemini (Google Gemini CLI)"
        exit 1
    fi
    
    if [ ${#missing_clients[@]} -gt 0 ]; then
        log_warn "Clientes não encontrados: ${missing_clients[*]}"
        log_warn "Os wrappers para estes clientes serão criados mas não funcionarão até a instalação"
    fi
    
    echo
}

# Função para instalar dependências básicas
install_dependencies() {
    local distro=$(detect_distro)
    log_info "Instalando dependências para $distro..."
    
    case "$distro" in
        "manjaro"|"arch")
            # Manjaro/Arch
            sudo pacman -Sy --needed --noconfirm \
                jq bc curl wget git python python-pip nodejs npm || {
                log_error "Falha ao instalar dependências no Manjaro/Arch"
                exit 1
            }
            ;;
        "ubuntu"|"debian")
            # Ubuntu/Debian
            sudo apt update
            sudo apt install -y \
                jq bc curl wget git python3 python3-pip nodejs npm \
                build-essential software-properties-common || {
                log_error "Falha ao instalar dependências no Ubuntu/Debian"
                exit 1
            }
            ;;
        *)
            log_warn "Distribuição não reconhecida: $distro"
            log_warn "Tentando instalar dependências básicas..."
            
            # Tentar diferentes gerenciadores de pacotes
            if command_exists apt; then
                sudo apt update && sudo apt install -y jq bc curl wget git python3 python3-pip nodejs npm
            elif command_exists yum; then
                sudo yum install -y jq bc curl wget git python3 python3-pip nodejs npm
            elif command_exists dnf; then
                sudo dnf install -y jq bc curl wget git python3 python3-pip nodejs npm
            elif command_exists pacman; then
                sudo pacman -Sy --needed --noconfirm jq bc curl wget git python python-pip nodejs npm
            else
                log_error "Nenhum gerenciador de pacotes conhecido encontrado"
                exit 1
            fi
            ;;
    esac
    
    log_success "Dependências instaladas"
}

# Função para criar estrutura de diretórios
create_directory_structure() {
    log_info "Criando estrutura de diretórios..."
    
    # Criar diretórios do sistema
    sudo mkdir -p "$INSTALL_DIR"/{bin,lib,share,templates,logs}
    sudo mkdir -p "$INSTALL_DIR/management"/{api,web}
    
    # Criar diretórios do usuário
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$SHARE_DIR"/{logs,backups,templates}
    mkdir -p "$CACHE_DIR"/{temp,downloads}
    
    # Definir permissões
    sudo chown -R $USER:$USER "$INSTALL_DIR"
    chmod -R 755 "$INSTALL_DIR"
    
    log_success "Estrutura de diretórios criada"
}

# Função para criar wrapper do Codex
create_codex_wrapper() {
    log_info "Criando wrapper para Codex..."
    
    sudo tee "$BIN_DIR/ai-codex" > /dev/null << 'EOF'
#!/bin/bash
# ai-codex - Wrapper para OpenAI Codex com funcionalidades paralelas

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/ai-parallel-systems"
CONFIG_DIR="$HOME/.config/ai-parallel"
LOGS_DIR="$HOME/.local/share/ai-parallel/logs/codex"

# Criar diretório de logs se não existir
mkdir -p "$LOGS_DIR"

# Função de logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOGS_DIR/wrapper.log"
}

# Verificar se codex está instalado
if ! command -v codex >/dev/null 2>&1; then
    log "ERROR" "Codex CLI não encontrado. Por favor, instale o cliente Codex primeiro."
    echo "Erro: Codex CLI não encontrado"
    echo "Instale o cliente Codex e tente novamente"
    exit 1
fi

# Verificar API key
if [ -z "${OPENAI_API_KEY:-}" ]; then
    log "WARN" "OPENAI_API_KEY não configurada"
    echo "Aviso: OPENAI_API_KEY não configurada"
    echo "Configure com: export OPENAI_API_KEY='sua-chave'"
fi

# Função para processar arquivo de tarefas
process_tasks_file() {
    local tasks_file="${1:-tasks.json}"
    
    if [ ! -f "$tasks_file" ]; then
        log "ERROR" "Arquivo de tarefas não encontrado: $tasks_file"
        echo "Erro: Arquivo $tasks_file não encontrado"
        echo "Use 'ai-manager init codex' para criar um arquivo de tarefas"
        exit 1
    fi
    
    log "INFO" "Processando arquivo de tarefas: $tasks_file"
    
    # Validar JSON
    if ! jq empty "$tasks_file" 2>/dev/null; then
        log "ERROR" "Arquivo JSON inválido: $tasks_file"
        echo "Erro: Arquivo JSON inválido"
        exit 1
    fi
    
    # Extrair informações do projeto
    local project_name=$(jq -r '.project_info.name // "Projeto Codex"' "$tasks_file")
    local base_branch=$(jq -r '.project_info.base_branch // "main"' "$tasks_file")
    
    log "INFO" "Projeto: $project_name, Branch base: $base_branch"
    
    # Processar cada tarefa
    local task_count=$(jq '.tasks | length' "$tasks_file")
    log "INFO" "Encontradas $task_count tarefas para processar"
    
    for i in $(seq 0 $((task_count - 1))); do
        local task=$(jq ".tasks[$i]" "$tasks_file")
        local task_id=$(echo "$task" | jq -r '.id')
        local title=$(echo "$task" | jq -r '.title')
        local prompt=$(echo "$task" | jq -r '.prompt')
        
        log "INFO" "Processando tarefa: $task_id - $title"
        
        # Executar tarefa com Codex
        execute_codex_task "$task" "$project_name"
    done
}

# Função para executar tarefa individual com Codex
execute_codex_task() {
    local task_json="$1"
    local project_name="$2"
    
    local task_id=$(echo "$task_json" | jq -r '.id')
    local title=$(echo "$task_json" | jq -r '.title')
    local prompt=$(echo "$task_json" | jq -r '.prompt')
    local branch_name=$(echo "$task_json" | jq -r '.branch_name // ("feature/" + .id)')
    local language=$(echo "$task_json" | jq -r '.language // "python"')
    
    local task_log="$LOGS_DIR/task_${task_id}.log"
    
    {
        echo "=== EXECUTANDO TAREFA CODEX ==="
        echo "ID: $task_id"
        echo "Título: $title"
        echo "Branch: $branch_name"
        echo "Linguagem: $language"
        echo "Timestamp: $(date -Iseconds)"
        echo "================================"
        echo ""
        
        # Preparar prompt otimizado para Codex
        local codex_prompt="# Task: $title
# Language: $language
# Instructions: $prompt

# Generate complete, production-ready code with proper error handling and documentation.
# Include all necessary imports and dependencies.
# Follow best practices for $language development.

"
        
        # Executar Codex
        echo "Executando Codex..."
        echo "$codex_prompt" | codex --language "$language" --max-tokens 2048 --temperature 0.1
        
        echo ""
        echo "Tarefa $task_id concluída"
        
    } >> "$task_log" 2>&1
    
    log "INFO" "Tarefa $task_id executada, log salvo em: $task_log"
}

# Função para mostrar ajuda
show_help() {
    cat << 'HELP'
ai-codex - Wrapper para OpenAI Codex com funcionalidades paralelas

USAGE:
    ai-codex [arquivo-tarefas]     - Processar arquivo de tarefas
    ai-codex --help               - Mostrar esta ajuda
    ai-codex --version            - Mostrar versão
    ai-codex --check-prereqs      - Verificar pré-requisitos

EXEMPLOS:
    ai-codex                      - Processar tasks.json no diretório atual
    ai-codex my-tasks.json        - Processar arquivo específico
    ai-codex --check-prereqs      - Verificar se tudo está configurado

CONFIGURAÇÃO:
    export OPENAI_API_KEY="sua-chave-openai"

ARQUIVOS:
    tasks.json                    - Arquivo de tarefas (criado com ai-manager init)
    ~/.config/ai-parallel/       - Configurações
    ~/.local/share/ai-parallel/logs/codex/ - Logs

Para criar um arquivo de tarefas:
    ai-manager init codex
HELP
}

# Função para verificar pré-requisitos
check_prerequisites() {
    echo "Verificando pré-requisitos para Codex..."
    echo
    
    # Verificar Codex CLI
    if command -v codex >/dev/null 2>&1; then
        echo "✓ Codex CLI: $(which codex)"
        codex --version 2>/dev/null || echo "  (versão não disponível)"
    else
        echo "✗ Codex CLI não encontrado"
        return 1
    fi
    
    # Verificar API key
    if [ -n "${OPENAI_API_KEY:-}" ]; then
        echo "✓ OPENAI_API_KEY configurada"
    else
        echo "✗ OPENAI_API_KEY não configurada"
        echo "  Configure com: export OPENAI_API_KEY='sua-chave'"
        return 1
    fi
    
    # Verificar conectividade
    if curl -s -I https://api.openai.com/v1/models >/dev/null 2>&1; then
        echo "✓ Conectividade com OpenAI API"
    else
        echo "✗ Sem conectividade com OpenAI API"
        return 1
    fi
    
    # Verificar dependências
    local deps=("jq" "git" "curl")
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo "✓ $dep disponível"
        else
            echo "✗ $dep não encontrado"
            return 1
        fi
    done
    
    echo
    echo "✓ Todos os pré-requisitos atendidos"
    return 0
}

# Processar argumentos
case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --version|-v)
        echo "ai-codex wrapper v1.0.0"
        codex --version 2>/dev/null || echo "Codex CLI não disponível"
        exit 0
        ;;
    --check-prereqs)
        check_prerequisites
        exit $?
        ;;
    "")
        # Usar tasks.json padrão
        process_tasks_file "tasks.json"
        ;;
    *)
        # Usar arquivo especificado
        process_tasks_file "$1"
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-codex"
    log_success "Wrapper do Codex criado"
}

# Função para criar wrapper do Claude
create_claude_wrapper() {
    log_info "Criando wrapper para Claude..."
    
    sudo tee "$BIN_DIR/ai-claude" > /dev/null << 'EOF'
#!/bin/bash
# ai-claude - Wrapper para Claude CLI com funcionalidades paralelas

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/ai-parallel-systems"
CONFIG_DIR="$HOME/.config/ai-parallel"
LOGS_DIR="$HOME/.local/share/ai-parallel/logs/claude"

# Criar diretório de logs se não existir
mkdir -p "$LOGS_DIR"

# Função de logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOGS_DIR/wrapper.log"
}

# Verificar se claude está instalado
if ! command -v claude >/dev/null 2>&1; then
    log "ERROR" "Claude CLI não encontrado. Por favor, instale o cliente Claude primeiro."
    echo "Erro: Claude CLI não encontrado"
    echo "Instale o cliente Claude e tente novamente"
    exit 1
fi

# Verificar API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    log "WARN" "ANTHROPIC_API_KEY não configurada"
    echo "Aviso: ANTHROPIC_API_KEY não configurada"
    echo "Configure com: export ANTHROPIC_API_KEY='sua-chave'"
fi

# Função para processar arquivo de tarefas
process_tasks_file() {
    local tasks_file="${1:-tasks.json}"
    
    if [ ! -f "$tasks_file" ]; then
        log "ERROR" "Arquivo de tarefas não encontrado: $tasks_file"
        echo "Erro: Arquivo $tasks_file não encontrado"
        echo "Use 'ai-manager init claude' para criar um arquivo de tarefas"
        exit 1
    fi
    
    log "INFO" "Processando arquivo de tarefas: $tasks_file"
    
    # Validar JSON
    if ! jq empty "$tasks_file" 2>/dev/null; then
        log "ERROR" "Arquivo JSON inválido: $tasks_file"
        echo "Erro: Arquivo JSON inválido"
        exit 1
    fi
    
    # Extrair informações do projeto
    local project_name=$(jq -r '.project_info.name // "Projeto Claude"' "$tasks_file")
    local base_branch=$(jq -r '.project_info.base_branch // "main"' "$tasks_file")
    
    log "INFO" "Projeto: $project_name, Branch base: $base_branch"
    
    # Processar cada tarefa
    local task_count=$(jq '.tasks | length' "$tasks_file")
    log "INFO" "Encontradas $task_count tarefas para processar"
    
    for i in $(seq 0 $((task_count - 1))); do
        local task=$(jq ".tasks[$i]" "$tasks_file")
        local task_id=$(echo "$task" | jq -r '.id')
        local title=$(echo "$task" | jq -r '.title')
        local prompt=$(echo "$task" | jq -r '.prompt')
        
        log "INFO" "Processando tarefa: $task_id - $title"
        
        # Executar tarefa com Claude
        execute_claude_task "$task" "$project_name"
    done
}

# Função para executar tarefa individual com Claude
execute_claude_task() {
    local task_json="$1"
    local project_name="$2"
    
    local task_id=$(echo "$task_json" | jq -r '.id')
    local title=$(echo "$task_json" | jq -r '.title')
    local prompt=$(echo "$task_json" | jq -r '.prompt')
    local branch_name=$(echo "$task_json" | jq -r '.branch_name // ("feature/" + .id)')
    local language=$(echo "$task_json" | jq -r '.language // "python"')
    
    local task_log="$LOGS_DIR/task_${task_id}.log"
    
    {
        echo "=== EXECUTANDO TAREFA CLAUDE ==="
        echo "ID: $task_id"
        echo "Título: $title"
        echo "Branch: $branch_name"
        echo "Linguagem: $language"
        echo "Timestamp: $(date -Iseconds)"
        echo "================================"
        echo ""
        
        # Preparar prompt otimizado para Claude
        local claude_prompt="Task: $title

Context: I'm working on a $language project called '$project_name'. 

Requirements: $prompt

Please provide a complete, production-ready solution with:
1. Well-structured, clean code
2. Proper error handling
3. Comprehensive documentation
4. Best practices for $language
5. Any necessary configuration files

Focus on code quality, maintainability, and following industry standards."
        
        # Executar Claude
        echo "Executando Claude..."
        echo "$claude_prompt" | claude --model claude-3-sonnet-20240229 --max-tokens 4000
        
        echo ""
        echo "Tarefa $task_id concluída"
        
    } >> "$task_log" 2>&1
    
    log "INFO" "Tarefa $task_id executada, log salvo em: $task_log"
}

# Função para mostrar ajuda
show_help() {
    cat << 'HELP'
ai-claude - Wrapper para Claude CLI com funcionalidades paralelas

USAGE:
    ai-claude [arquivo-tarefas]   - Processar arquivo de tarefas
    ai-claude --help             - Mostrar esta ajuda
    ai-claude --version          - Mostrar versão
    ai-claude --check-prereqs    - Verificar pré-requisitos

EXEMPLOS:
    ai-claude                    - Processar tasks.json no diretório atual
    ai-claude my-tasks.json      - Processar arquivo específico
    ai-claude --check-prereqs    - Verificar se tudo está configurado

CONFIGURAÇÃO:
    export ANTHROPIC_API_KEY="sua-chave-anthropic"

ARQUIVOS:
    tasks.json                   - Arquivo de tarefas (criado com ai-manager init)
    ~/.config/ai-parallel/      - Configurações
    ~/.local/share/ai-parallel/logs/claude/ - Logs

Para criar um arquivo de tarefas:
    ai-manager init claude
HELP
}

# Função para verificar pré-requisitos
check_prerequisites() {
    echo "Verificando pré-requisitos para Claude..."
    echo
    
    # Verificar Claude CLI
    if command -v claude >/dev/null 2>&1; then
        echo "✓ Claude CLI: $(which claude)"
        claude --version 2>/dev/null || echo "  (versão não disponível)"
    else
        echo "✗ Claude CLI não encontrado"
        return 1
    fi
    
    # Verificar API key
    if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
        echo "✓ ANTHROPIC_API_KEY configurada"
    else
        echo "✗ ANTHROPIC_API_KEY não configurada"
        echo "  Configure com: export ANTHROPIC_API_KEY='sua-chave'"
        return 1
    fi
    
    # Verificar conectividade
    if curl -s -I https://api.anthropic.com/v1/messages >/dev/null 2>&1; then
        echo "✓ Conectividade com Anthropic API"
    else
        echo "✗ Sem conectividade com Anthropic API"
        return 1
    fi
    
    # Verificar dependências
    local deps=("jq" "git" "curl")
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo "✓ $dep disponível"
        else
            echo "✗ $dep não encontrado"
            return 1
        fi
    done
    
    echo
    echo "✓ Todos os pré-requisitos atendidos"
    return 0
}

# Processar argumentos
case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --version|-v)
        echo "ai-claude wrapper v1.0.0"
        claude --version 2>/dev/null || echo "Claude CLI não disponível"
        exit 0
        ;;
    --check-prereqs)
        check_prerequisites
        exit $?
        ;;
    "")
        # Usar tasks.json padrão
        process_tasks_file "tasks.json"
        ;;
    *)
        # Usar arquivo especificado
        process_tasks_file "$1"
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-claude"
    log_success "Wrapper do Claude criado"
}

# Função para criar wrapper do Gemini
create_gemini_wrapper() {
    log_info "Criando wrapper para Gemini..."
    
    sudo tee "$BIN_DIR/ai-gemini" > /dev/null << 'EOF'
#!/bin/bash
# ai-gemini - Wrapper para Gemini CLI com funcionalidades paralelas

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/ai-parallel-systems"
CONFIG_DIR="$HOME/.config/ai-parallel"
LOGS_DIR="$HOME/.local/share/ai-parallel/logs/gemini"

# Criar diretório de logs se não existir
mkdir -p "$LOGS_DIR"

# Função de logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOGS_DIR/wrapper.log"
}

# Verificar se gemini está instalado
if ! command -v gemini >/dev/null 2>&1; then
    log "ERROR" "Gemini CLI não encontrado. Por favor, instale o cliente Gemini primeiro."
    echo "Erro: Gemini CLI não encontrado"
    echo "Instale o cliente Gemini e tente novamente"
    exit 1
fi

# Verificar API key
if [ -z "${GOOGLE_API_KEY:-}" ]; then
    log "WARN" "GOOGLE_API_KEY não configurada"
    echo "Aviso: GOOGLE_API_KEY não configurada"
    echo "Configure com: export GOOGLE_API_KEY='sua-chave'"
fi

# Função para processar arquivo de tarefas
process_tasks_file() {
    local tasks_file="${1:-tasks.json}"
    
    if [ ! -f "$tasks_file" ]; then
        log "ERROR" "Arquivo de tarefas não encontrado: $tasks_file"
        echo "Erro: Arquivo $tasks_file não encontrado"
        echo "Use 'ai-manager init gemini' para criar um arquivo de tarefas"
        exit 1
    fi
    
    log "INFO" "Processando arquivo de tarefas: $tasks_file"
    
    # Validar JSON
    if ! jq empty "$tasks_file" 2>/dev/null; then
        log "ERROR" "Arquivo JSON inválido: $tasks_file"
        echo "Erro: Arquivo JSON inválido"
        exit 1
    fi
    
    # Extrair informações do projeto
    local project_name=$(jq -r '.project_info.name // "Projeto Gemini"' "$tasks_file")
    local base_branch=$(jq -r '.project_info.base_branch // "main"' "$tasks_file")
    
    log "INFO" "Projeto: $project_name, Branch base: $base_branch"
    
    # Processar cada tarefa
    local task_count=$(jq '.tasks | length' "$tasks_file")
    log "INFO" "Encontradas $task_count tarefas para processar"
    
    for i in $(seq 0 $((task_count - 1))); do
        local task=$(jq ".tasks[$i]" "$tasks_file")
        local task_id=$(echo "$task" | jq -r '.id')
        local title=$(echo "$task" | jq -r '.title')
        local prompt=$(echo "$task" | jq -r '.prompt')
        
        log "INFO" "Processando tarefa: $task_id - $title"
        
        # Executar tarefa com Gemini
        execute_gemini_task "$task" "$project_name"
    done
}

# Função para executar tarefa individual com Gemini
execute_gemini_task() {
    local task_json="$1"
    local project_name="$2"
    
    local task_id=$(echo "$task_json" | jq -r '.id')
    local title=$(echo "$task_json" | jq -r '.title')
    local prompt=$(echo "$task_json" | jq -r '.prompt')
    local branch_name=$(echo "$task_json" | jq -r '.branch_name // ("feature/" + .id)')
    local language=$(echo "$task_json" | jq -r '.language // "python"')
    
    local task_log="$LOGS_DIR/task_${task_id}.log"
    
    {
        echo "=== EXECUTANDO TAREFA GEMINI ==="
        echo "ID: $task_id"
        echo "Título: $title"
        echo "Branch: $branch_name"
        echo "Linguagem: $language"
        echo "Timestamp: $(date -Iseconds)"
        echo "================================"
        echo ""
        
        # Preparar prompt otimizado para Gemini
        local gemini_prompt="# Project: $project_name
# Task: $title
# Language: $language
# Branch: $branch_name

## Objective
$prompt

## Requirements
- Generate complete, production-ready code
- Include comprehensive error handling
- Add detailed comments and documentation
- Follow $language best practices and conventions
- Ensure code is maintainable and scalable
- Include unit tests where appropriate

## Output Format
Please provide:
1. Complete code implementation
2. Configuration files if needed
3. Documentation/README updates
4. Installation/setup instructions

## Code Quality Standards
- Use proper naming conventions
- Implement proper logging
- Handle edge cases
- Follow SOLID principles
- Include type hints (where applicable)

Generate the solution:"
        
        # Executar Gemini
        echo "Executando Gemini..."
        echo "$gemini_prompt" | gemini --model gemini-pro --temperature 0.2 --max-tokens 8192
        
        echo ""
        echo "Tarefa $task_id concluída"
        
    } >> "$task_log" 2>&1
    
    log "INFO" "Tarefa $task_id executada, log salvo em: $task_log"
}

# Função para mostrar ajuda
show_help() {
    cat << 'HELP'
ai-gemini - Wrapper para Gemini CLI com funcionalidades paralelas

USAGE:
    ai-gemini [arquivo-tarefas]   - Processar arquivo de tarefas
    ai-gemini --help             - Mostrar esta ajuda
    ai-gemini --version          - Mostrar versão
    ai-gemini --check-prereqs    - Verificar pré-requisitos

EXEMPLOS:
    ai-gemini                    - Processar tasks.json no diretório atual
    ai-gemini my-tasks.json      - Processar arquivo específico
    ai-gemini --check-prereqs    - Verificar se tudo está configurado

CONFIGURAÇÃO:
    export GOOGLE_API_KEY="sua-chave-google"

ARQUIVOS:
    tasks.json                   - Arquivo de tarefas (criado com ai-manager init)
    ~/.config/ai-parallel/      - Configurações
    ~/.local/share/ai-parallel/logs/gemini/ - Logs

Para criar um arquivo de tarefas:
    ai-manager init gemini

VANTAGENS DO GEMINI:
    - 85% mais barato que GPT-4
    - Contexto de 1M tokens (8x maior)
    - 60 requisições/minuto
    - Multimodal nativo
HELP
}

# Função para verificar pré-requisitos
check_prerequisites() {
    echo "Verificando pré-requisitos para Gemini..."
    echo
    
    # Verificar Gemini CLI
    if command -v gemini >/dev/null 2>&1; then
        echo "✓ Gemini CLI: $(which gemini)"
        gemini --version 2>/dev/null || echo "  (versão não disponível)"
    else
        echo "✗ Gemini CLI não encontrado"
        return 1
    fi
    
    # Verificar API key
    if [ -n "${GOOGLE_API_KEY:-}" ]; then
        echo "✓ GOOGLE_API_KEY configurada"
    else
        echo "✗ GOOGLE_API_KEY não configurada"
        echo "  Configure com: export GOOGLE_API_KEY='sua-chave'"
        return 1
    fi
    
    # Verificar conectividade
    if curl -s -I https://generativelanguage.googleapis.com/v1beta/models >/dev/null 2>&1; then
        echo "✓ Conectividade com Google AI API"
    else
        echo "✗ Sem conectividade com Google AI API"
        return 1
    fi
    
    # Verificar dependências
    local deps=("jq" "git" "curl")
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo "✓ $dep disponível"
        else
            echo "✗ $dep não encontrado"
            return 1
        fi
    done
    
    echo
    echo "✓ Todos os pré-requisitos atendidos"
    echo "✓ Gemini é o sistema recomendado (85% mais barato, mais rápido)"
    return 0
}

# Processar argumentos
case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --version|-v)
        echo "ai-gemini wrapper v1.0.0"
        gemini --version 2>/dev/null || echo "Gemini CLI não disponível"
        exit 0
        ;;
    --check-prereqs)
        check_prerequisites
        exit $?
        ;;
    "")
        # Usar tasks.json padrão
        process_tasks_file "tasks.json"
        ;;
    *)
        # Usar arquivo especificado
        process_tasks_file "$1"
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-gemini"
    log_success "Wrapper do Gemini criado"
}

# Função para criar comando ai-manager
create_manager_command() {
    log_info "Criando comando ai-manager..."
    
    sudo tee "$BIN_DIR/ai-manager" > /dev/null << 'EOF'
#!/bin/bash
# ai-manager - Gerenciador principal dos sistemas de IA

set -euo pipefail

CONFIG_DIR="$HOME/.config/ai-parallel"
SHARE_DIR="$HOME/.local/share/ai-parallel"

# Função para mostrar ajuda
show_help() {
    cat << 'HELP'
ai-manager - Gerenciador dos Sistemas de IA

COMANDOS:
    init <sistema>     - Inicializar projeto com sistema específico
    status            - Mostrar status de todos os sistemas
    config            - Configurar API keys
    update            - Atualizar wrappers
    help              - Mostrar esta ajuda

SISTEMAS DISPONÍVEIS:
    gemini            - Google Gemini (Recomendado - 85% mais barato)
    claude            - Anthropic Claude (Balanced)
    codex             - OpenAI Codex (Especializado em código)

EXEMPLOS:
    ai-manager init gemini     - Criar tasks.json para Gemini
    ai-manager status          - Ver status de todos os sistemas
    ai-manager config          - Configurar API keys interativamente

ARQUIVOS CRIADOS:
    tasks.json                 - Arquivo de tarefas do projeto
    ai_config.json            - Configurações específicas do projeto
HELP
}

# Função para inicializar projeto
init_project() {
    local system="${1:-gemini}"
    
    if [ -f "tasks.json" ]; then
        echo "Arquivo tasks.json já existe. Sobrescrever? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Operação cancelada"
            exit 0
        fi
    fi
    
    # Criar tasks.json baseado no sistema
    case "$system" in
        "gemini")
            create_gemini_tasks_template
            ;;
        "claude")
            create_claude_tasks_template
            ;;
        "codex")
            create_codex_tasks_template
            ;;
        *)
            echo "Sistema desconhecido: $system"
            echo "Sistemas disponíveis: gemini, claude, codex"
            exit 1
            ;;
    esac
    
    # Criar configuração do projeto
    create_project_config "$system"
    
    echo "Projeto inicializado com $system!"
    echo "Edite tasks.json e execute: ai-$system"
}

# Função para criar template do Gemini
create_gemini_tasks_template() {
    cat > tasks.json << 'EOF'
{
  "project_info": {
    "name": "Meu Projeto",
    "description": "Projeto desenvolvido com Gemini AI",
    "base_branch": "main"
  },
  "tasks": [
    {
      "id": "setup-project",
      "title": "Configurar Estrutura do Projeto",
      "prompt": "Configure a estrutura básica do projeto com as melhores práticas de desenvolvimento. Inclua estrutura de diretórios, arquivos de configuração, documentação inicial e setup de desenvolvimento.",
      "branch_name": "feature/setup-project",
      "language": "python",
      "framework": "fastapi",
      "priority": 1,
      "files_to_focus": ["src/", "docs/", "tests/"]
    }
  ]
}
EOF
}

# Função para criar template do Claude
create_claude_tasks_template() {
    cat > tasks.json << 'EOF'
{
  "project_info": {
    "name": "Meu Projeto",
    "description": "Projeto desenvolvido com Claude AI",
    "base_branch": "main"
  },
  "tasks": [
    {
      "id": "setup-project",
      "title": "Configurar Arquitetura do Projeto",
      "prompt": "Configure uma arquitetura robusta e escalável para o projeto. Inclua padrões de design, estrutura modular, configurações de ambiente e documentação técnica detalhada.",
      "branch_name": "feature/setup-architecture",
      "language": "python",
      "framework": "django",
      "priority": 1,
      "files_to_focus": ["src/", "docs/", "config/"]
    }
  ]
}
EOF
}

# Função para criar template do Codex
create_codex_tasks_template() {
    cat > tasks.json << 'EOF'
{
  "project_info": {
    "name": "Meu Projeto",
    "description": "Projeto desenvolvido com Codex AI",
    "base_branch": "main"
  },
  "tasks": [
    {
      "id": "setup-project",
      "title": "Implementar Base de Código",
      "prompt": "Implemente a base de código do projeto com foco em performance e qualidade. Inclua estrutura otimizada, algoritmos eficientes, testes unitários e documentação de código.",
      "branch_name": "feature/code-implementation",
      "language": "python",
      "framework": "flask",
      "priority": 1,
      "files_to_focus": ["src/", "tests/", "benchmarks/"]
    }
  ]
}
EOF
}

# Função para criar configuração do projeto
create_project_config() {
    local system="$1"
    
    cat > ai_config.json << EOF
{
  "project": {
    "name": "$(basename $(pwd))",
    "created": "$(date -Iseconds)",
    "system": "$system"
  },
  "settings": {
    "max_parallel_tasks": 3,
    "timeout_minutes": 30,
    "auto_commit": true,
    "create_pr": true
  },
  "system_config": {
    "$system": {
      "model": "default",
      "temperature": 0.2,
      "max_tokens": 4096
    }
  }
}
EOF
}

# Função para mostrar status
show_status() {
    echo "=== STATUS DOS SISTEMAS DE IA ==="
    echo
    
    # Verificar cada sistema
    local systems=("gemini" "claude" "codex")
    local api_keys=("GOOGLE_API_KEY" "ANTHROPIC_API_KEY" "OPENAI_API_KEY")
    
    for i in "${!systems[@]}"; do
        local system="${systems[$i]}"
        local api_key="${api_keys[$i]}"
        
        echo "Sistema: $system"
        
        # Verificar comando
        if command -v "ai-$system" >/dev/null 2>&1; then
            echo "  ✓ Wrapper: $(which ai-$system)"
        else
            echo "  ✗ Wrapper não encontrado"
        fi
        
        # Verificar cliente original
        if command -v "$system" >/dev/null 2>&1; then
            echo "  ✓ Cliente: $(which $system)"
        else
            echo "  ✗ Cliente não encontrado"
        fi
        
        # Verificar API key
        if [ -n "${!api_key:-}" ]; then
            echo "  ✓ API Key configurada"
        else
            echo "  ✗ API Key não configurada"
        fi
        
        echo
    done
    
    # Verificar projeto atual
    if [ -f "tasks.json" ]; then
        echo "Projeto atual:"
        local project_name=$(jq -r '.project_info.name // "Sem nome"' tasks.json 2>/dev/null)
        local task_count=$(jq '.tasks | length' tasks.json 2>/dev/null)
        echo "  Nome: $project_name"
        echo "  Tarefas: $task_count"
        echo "  Arquivo: $(pwd)/tasks.json"
    else
        echo "Nenhum projeto inicializado neste diretório"
        echo "Use: ai-manager init <sistema>"
    fi
}

# Função para configurar API keys
configure_apis() {
    echo "=== CONFIGURAÇÃO DE API KEYS ==="
    echo
    
    mkdir -p "$CONFIG_DIR"
    local config_file="$CONFIG_DIR/config.env"
    
    # Configurar Google API Key
    echo "Google AI API Key (para Gemini):"
    echo -n "Chave atual: "
    if [ -n "${GOOGLE_API_KEY:-}" ]; then
        echo "${GOOGLE_API_KEY:0:10}..."
    else
        echo "não configurada"
    fi
    echo -n "Nova chave (Enter para manter): "
    read -r google_key
    
    # Configurar Anthropic API Key
    echo
    echo "Anthropic API Key (para Claude):"
    echo -n "Chave atual: "
    if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
        echo "${ANTHROPIC_API_KEY:0:10}..."
    else
        echo "não configurada"
    fi
    echo -n "Nova chave (Enter para manter): "
    read -r anthropic_key
    
    # Configurar OpenAI API Key
    echo
    echo "OpenAI API Key (para Codex):"
    echo -n "Chave atual: "
    if [ -n "${OPENAI_API_KEY:-}" ]; then
        echo "${OPENAI_API_KEY:0:10}..."
    else
        echo "não configurada"
    fi
    echo -n "Nova chave (Enter para manter): "
    read -r openai_key
    
    # Salvar configurações
    {
        echo "# AI Systems API Keys"
        echo "# Gerado em: $(date)"
        echo
        
        if [ -n "$google_key" ]; then
            echo "export GOOGLE_API_KEY=\"$google_key\""
        elif [ -n "${GOOGLE_API_KEY:-}" ]; then
            echo "export GOOGLE_API_KEY=\"$GOOGLE_API_KEY\""
        fi
        
        if [ -n "$anthropic_key" ]; then
            echo "export ANTHROPIC_API_KEY=\"$anthropic_key\""
        elif [ -n "${ANTHROPIC_API_KEY:-}" ]; then
            echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_API_KEY\""
        fi
        
        if [ -n "$openai_key" ]; then
            echo "export OPENAI_API_KEY=\"$openai_key\""
        elif [ -n "${OPENAI_API_KEY:-}" ]; then
            echo "export OPENAI_API_KEY=\"$OPENAI_API_KEY\""
        fi
    } > "$config_file"
    
    echo
    echo "Configurações salvas em: $config_file"
    echo
    echo "Para carregar as configurações, adicione ao seu ~/.bashrc:"
    echo "[ -f \"$config_file\" ] && source \"$config_file\""
    echo
    echo "Ou execute agora:"
    echo "source \"$config_file\""
}

# Processar comandos
case "${1:-help}" in
    init)
        init_project "${2:-gemini}"
        ;;
    status)
        show_status
        ;;
    config)
        configure_apis
        ;;
    update)
        echo "Funcionalidade de atualização será implementada em versão futura"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Comando desconhecido: ${1:-}"
        echo "Use 'ai-manager help' para ver comandos disponíveis"
        exit 1
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-manager"
    log_success "Comando ai-manager criado"
}

# Função para criar comandos auxiliares
create_auxiliary_commands() {
    log_info "Criando comandos auxiliares..."
    
    # Comando ai-quick (detecção automática)
    sudo tee "$BIN_DIR/ai-quick" > /dev/null << 'EOF'
#!/bin/bash
# ai-quick - Execução rápida com detecção automática do melhor sistema

if [ -f "ai_config.json" ]; then
    system=$(jq -r '.project.system // "gemini"' ai_config.json 2>/dev/null)
else
    system="gemini"  # Padrão: Gemini (mais barato)
fi

echo "Executando com $system (detecção automática)..."
exec "ai-$system" "$@"
EOF

    # Comando ai-logs
    sudo tee "$BIN_DIR/ai-logs" > /dev/null << 'EOF'
#!/bin/bash
# ai-logs - Visualizador de logs dos sistemas de IA

LOGS_DIR="$HOME/.local/share/ai-parallel/logs"

case "${1:-summary}" in
    summary)
        echo "=== RESUMO DOS LOGS ==="
        find "$LOGS_DIR" -name "*.log" -type f -exec echo "=== {} ===" \; -exec tail -5 {} \; 2>/dev/null
        ;;
    live)
        system="${2:-all}"
        if [ "$system" = "all" ]; then
            tail -f "$LOGS_DIR"/*/*.log 2>/dev/null
        else
            tail -f "$LOGS_DIR/$system"/*.log 2>/dev/null
        fi
        ;;
    *)
        echo "ai-logs - Visualizador de logs"
        echo "Uso: ai-logs [summary|live] [sistema]"
        ;;
esac
EOF

    # Comando ai-compare
    sudo tee "$BIN_DIR/ai-compare" > /dev/null << 'EOF'
#!/bin/bash
# ai-compare - Comparação entre sistemas de IA

cat << 'COMPARE'
=== COMPARAÇÃO DOS SISTEMAS DE IA ===

| Sistema | Custo (1K tokens) | Rate Limit | Contexto | Recomendação |
|---------|------------------|------------|----------|--------------|
| Gemini  | $0.0035 (input)  | 60/min     | 1M       | ⭐ Melhor    |
| Claude  | $0.015 (input)   | 30/min     | 200K     | Balanced     |
| Codex   | $0.03 (input)    | 20/min     | 128K     | Código       |

VANTAGENS:
✓ Gemini: 85% mais barato, mais rápido, contexto maior
✓ Claude: Balanced, confiável, boa qualidade
✓ Codex: Especializado em código, debugging

RECOMENDAÇÃO: Use Gemini como padrão, Claude para tarefas complexas, Codex para debugging.
COMPARE
EOF

    # Tornar executáveis
    sudo chmod +x "$BIN_DIR/ai-quick"
    sudo chmod +x "$BIN_DIR/ai-logs"
    sudo chmod +x "$BIN_DIR/ai-compare"
    
    log_success "Comandos auxiliares criados"
}

# Função para configurar auto-complete
setup_autocompletion() {
    log_info "Configurando auto-complete..."
    
    # Criar arquivo de auto-complete
    sudo tee /etc/bash_completion.d/ai-systems << 'EOF'
# Auto-complete para sistemas de IA

_ai_manager_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    case $prev in
        ai-manager)
            opts="init status config update help"
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        init)
            opts="gemini claude codex"
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
    esac
}

_ai_logs_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    case $prev in
        ai-logs)
            opts="summary live"
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        live)
            opts="gemini claude codex all"
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
    esac
}

# Registrar auto-complete
complete -F _ai_manager_complete ai-manager
complete -F _ai_logs_complete ai-logs
complete -o default ai-gemini ai-claude ai-codex ai-quick
EOF

    log_success "Auto-complete configurado"
}

# Função principal
main() {
    echo "=== INSTALADOR GLOBAL DE SISTEMAS DE IA ==="
    echo "Versão: 2.0.0 (Clientes Existentes)"
    echo "Assume que codex, claude e gemini já estão instalados"
    echo

    # Verificar se é root
    if [ "$EUID" -ne 0 ]; then
        log_error "Este script deve ser executado como root (use sudo)"
        exit 1
    fi

    # Verificar clientes existentes
    check_existing_clients

    # Instalar dependências básicas
    install_dependencies

    # Criar estrutura de diretórios
    create_directory_structure

    # Criar wrappers
    create_codex_wrapper
    create_claude_wrapper
    create_gemini_wrapper

    # Criar comandos de gerenciamento
    create_manager_command
    create_auxiliary_commands

    # Configurar auto-complete
    setup_autocompletion

    echo
    log_success "=== INSTALAÇÃO CONCLUÍDA ==="
    echo
    echo "Comandos disponíveis:"
    echo "  ai-manager  - Gerenciador principal"
    echo "  ai-quick    - Execução rápida"
    echo "  ai-gemini   - Google Gemini (Recomendado)"
    echo "  ai-claude   - Anthropic Claude"
    echo "  ai-codex    - OpenAI Codex"
    echo "  ai-logs     - Visualizador de logs"
    echo "  ai-compare  - Comparação entre sistemas"
    echo
    echo "Próximos passos:"
    echo "1. Configure API keys: ai-manager config"
    echo "2. Vá para um diretório de projeto"
    echo "3. Inicialize: ai-manager init gemini"
    echo "4. Execute: ai-gemini"
    echo
    echo "Para usar em qualquer diretório, os comandos já estão globais!"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

