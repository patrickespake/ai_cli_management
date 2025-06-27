#!/bin/bash
# ai_advanced_commands_updated.sh - Sistema Avançado Adaptado para Clientes Existentes
# Assume que codex, claude e gemini já estão instalados

set -euo pipefail

INSTALL_DIR="/opt/ai-parallel-systems"
BIN_DIR="/usr/local/bin"
CONFIG_DIR="$HOME/.config/ai-parallel"
SHARE_DIR="$HOME/.local/share/ai-parallel"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Função para criar comando ai-status avançado
create_advanced_status_command() {
    log_info "Criando comando ai-status avançado..."
    
    sudo tee "$BIN_DIR/ai-status" > /dev/null << 'EOF'
#!/bin/bash
# ai-status - Status avançado dos sistemas de IA

CONFIG_DIR="$HOME/.config/ai-parallel"
LOGS_DIR="$HOME/.local/share/ai-parallel/logs"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_detailed_status() {
    echo -e "${BLUE}=== STATUS DETALHADO DOS SISTEMAS DE IA ===${NC}"
    echo
    
    # Informações do sistema
    echo -e "${BLUE}Sistema:${NC}"
    echo "  OS: $(uname -s) $(uname -r)"
    echo "  Arquitetura: $(uname -m)"
    echo "  Usuário: $USER"
    echo "  Diretório: $(pwd)"
    echo "  Data: $(date)"
    echo
    
    # Status dos clientes originais
    echo -e "${BLUE}Clientes Originais:${NC}"
    check_original_client "codex" "OpenAI Codex"
    check_original_client "claude" "Anthropic Claude"
    check_original_client "gemini" "Google Gemini"
    echo
    
    # Status dos wrappers
    echo -e "${BLUE}Wrappers AI:${NC}"
    check_wrapper "ai-codex" "Codex Wrapper"
    check_wrapper "ai-claude" "Claude Wrapper"
    check_wrapper "ai-gemini" "Gemini Wrapper"
    check_wrapper "ai-manager" "AI Manager"
    check_wrapper "ai-quick" "Quick Executor"
    echo
    
    # Status das API Keys
    echo -e "${BLUE}API Keys:${NC}"
    check_api_key "OPENAI_API_KEY" "OpenAI (Codex)"
    check_api_key "ANTHROPIC_API_KEY" "Anthropic (Claude)"
    check_api_key "GOOGLE_API_KEY" "Google AI (Gemini)"
    echo
    
    # Conectividade
    echo -e "${BLUE}Conectividade:${NC}"
    check_connectivity "https://api.openai.com/v1/models" "OpenAI API"
    check_connectivity "https://api.anthropic.com/v1/messages" "Anthropic API"
    check_connectivity "https://generativelanguage.googleapis.com/v1beta/models" "Google AI API"
    echo
    
    # Projeto atual
    echo -e "${BLUE}Projeto Atual:${NC}"
    check_current_project
    echo
    
    # Logs recentes
    echo -e "${BLUE}Atividade Recente:${NC}"
    show_recent_activity
    echo
    
    # Estatísticas de uso
    echo -e "${BLUE}Estatísticas:${NC}"
    show_usage_stats
}

check_original_client() {
    local cmd="$1"
    local name="$2"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        local path=$(which "$cmd")
        local version=$($cmd --version 2>/dev/null || echo "desconhecida")
        echo -e "  ${GREEN}✓${NC} $name: $path ($version)"
    else
        echo -e "  ${RED}✗${NC} $name: não encontrado"
    fi
}

check_wrapper() {
    local cmd="$1"
    local name="$2"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        local path=$(which "$cmd")
        echo -e "  ${GREEN}✓${NC} $name: $path"
    else
        echo -e "  ${RED}✗${NC} $name: não encontrado"
    fi
}

check_api_key() {
    local key_name="$1"
    local service="$2"
    
    if [ -n "${!key_name:-}" ]; then
        local key_preview="${!key_name:0:8}..."
        echo -e "  ${GREEN}✓${NC} $service: configurada ($key_preview)"
    else
        echo -e "  ${RED}✗${NC} $service: não configurada"
    fi
}

check_connectivity() {
    local url="$1"
    local service="$2"
    
    if curl -s -I "$url" --max-time 5 >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} $service: conectado"
    else
        echo -e "  ${RED}✗${NC} $service: sem conexão"
    fi
}

check_current_project() {
    if [ -f "tasks.json" ]; then
        local project_name=$(jq -r '.project_info.name // "Sem nome"' tasks.json 2>/dev/null)
        local task_count=$(jq '.tasks | length' tasks.json 2>/dev/null)
        local system=$(jq -r '.project.system // "não especificado"' ai_config.json 2>/dev/null)
        
        echo -e "  ${GREEN}✓${NC} Projeto: $project_name"
        echo "    Tarefas: $task_count"
        echo "    Sistema: $system"
        echo "    Arquivo: $(pwd)/tasks.json"
    else
        echo -e "  ${YELLOW}!${NC} Nenhum projeto inicializado"
        echo "    Use: ai-manager init <sistema>"
    fi
}

show_recent_activity() {
    if [ -d "$LOGS_DIR" ]; then
        local recent_logs=$(find "$LOGS_DIR" -name "*.log" -type f -mtime -1 2>/dev/null | wc -l)
        echo "  Logs recentes (24h): $recent_logs"
        
        # Mostrar últimas execuções
        local last_executions=$(find "$LOGS_DIR" -name "task_*.log" -type f -mtime -7 2>/dev/null | head -3)
        if [ -n "$last_executions" ]; then
            echo "  Últimas execuções:"
            echo "$last_executions" | while read -r log_file; do
                local task_id=$(basename "$log_file" .log | sed 's/task_//')
                local timestamp=$(stat -c %y "$log_file" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1)
                echo "    - $task_id ($timestamp)"
            done
        fi
    else
        echo "  Nenhuma atividade registrada"
    fi
}

show_usage_stats() {
    local total_executions=0
    local systems_used=()
    
    if [ -d "$LOGS_DIR" ]; then
        # Contar execuções por sistema
        for system in codex claude gemini; do
            local system_logs=$(find "$LOGS_DIR/$system" -name "task_*.log" -type f 2>/dev/null | wc -l)
            if [ "$system_logs" -gt 0 ]; then
                echo "  $system: $system_logs execuções"
                total_executions=$((total_executions + system_logs))
                systems_used+=("$system")
            fi
        done
        
        echo "  Total: $total_executions execuções"
        
        if [ ${#systems_used[@]} -gt 0 ]; then
            echo "  Sistemas usados: ${systems_used[*]}"
        fi
    else
        echo "  Nenhuma estatística disponível"
    fi
}

# Processar argumentos
case "${1:-detailed}" in
    detailed|--detailed|-d)
        show_detailed_status
        ;;
    quick|--quick|-q)
        echo "Status rápido:"
        echo -n "Clientes: "
        command -v codex >/dev/null && echo -n "codex " || echo -n "codex✗ "
        command -v claude >/dev/null && echo -n "claude " || echo -n "claude✗ "
        command -v gemini >/dev/null && echo -n "gemini " || echo -n "gemini✗ "
        echo
        echo -n "Wrappers: "
        command -v ai-codex >/dev/null && echo -n "ai-codex " || echo -n "ai-codex✗ "
        command -v ai-claude >/dev/null && echo -n "ai-claude " || echo -n "ai-claude✗ "
        command -v ai-gemini >/dev/null && echo -n "ai-gemini " || echo -n "ai-gemini✗ "
        echo
        ;;
    help|--help|-h)
        echo "ai-status - Status dos sistemas de IA"
        echo
        echo "Uso: ai-status [opção]"
        echo
        echo "Opções:"
        echo "  detailed, -d    Status detalhado (padrão)"
        echo "  quick, -q       Status rápido"
        echo "  help, -h        Esta ajuda"
        ;;
    *)
        show_detailed_status
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-status"
    log_success "Comando ai-status avançado criado"
}

# Função para criar comando ai-costs
create_costs_command() {
    log_info "Criando comando ai-costs..."
    
    sudo tee "$BIN_DIR/ai-costs" > /dev/null << 'EOF'
#!/bin/bash
# ai-costs - Análise de custos dos sistemas de IA

LOGS_DIR="$HOME/.local/share/ai-parallel/logs"

# Preços por 1K tokens (aproximados)
declare -A INPUT_COSTS=(
    ["gemini"]=0.0035
    ["claude"]=0.015
    ["codex"]=0.03
)

declare -A OUTPUT_COSTS=(
    ["gemini"]=0.0105
    ["claude"]=0.075
    ["codex"]=0.06
)

show_cost_analysis() {
    echo "=== ANÁLISE DE CUSTOS DOS SISTEMAS DE IA ==="
    echo
    
    # Comparação de preços
    echo "PREÇOS POR 1K TOKENS:"
    echo "┌─────────┬─────────────┬──────────────┬─────────────┐"
    echo "│ Sistema │ Input (USD) │ Output (USD) │ Economia    │"
    echo "├─────────┼─────────────┼──────────────┼─────────────┤"
    printf "│ %-7s │ %11.4f │ %12.4f │ %11s │\n" "Gemini" ${INPUT_COSTS[gemini]} ${OUTPUT_COSTS[gemini]} "Baseline"
    
    local claude_input_diff=$(echo "scale=2; (${INPUT_COSTS[claude]} - ${INPUT_COSTS[gemini]}) / ${INPUT_COSTS[gemini]} * 100" | bc)
    local codex_input_diff=$(echo "scale=2; (${INPUT_COSTS[codex]} - ${INPUT_COSTS[gemini]}) / ${INPUT_COSTS[gemini]} * 100" | bc)
    
    printf "│ %-7s │ %11.4f │ %12.4f │ %10.0f%% │\n" "Claude" ${INPUT_COSTS[claude]} ${OUTPUT_COSTS[claude]} "$claude_input_diff"
    printf "│ %-7s │ %11.4f │ %12.4f │ %10.0f%% │\n" "Codex" ${INPUT_COSTS[codex]} ${OUTPUT_COSTS[codex]} "$codex_input_diff"
    echo "└─────────┴─────────────┴──────────────┴─────────────┘"
    echo
    
    # Análise de uso histórico
    echo "ANÁLISE DE USO HISTÓRICO:"
    analyze_historical_usage
    echo
    
    # Projeções
    echo "PROJEÇÕES DE CUSTO:"
    show_cost_projections
    echo
    
    # Recomendações
    echo "RECOMENDAÇÕES:"
    show_cost_recommendations
}

analyze_historical_usage() {
    local total_executions=0
    local estimated_cost=0
    
    for system in gemini claude codex; do
        if [ -d "$LOGS_DIR/$system" ]; then
            local system_executions=$(find "$LOGS_DIR/$system" -name "task_*.log" -type f 2>/dev/null | wc -l)
            
            if [ "$system_executions" -gt 0 ]; then
                # Estimativa baseada em execuções (assumindo ~2K tokens por tarefa)
                local estimated_tokens=$((system_executions * 2000))
                local estimated_input_cost=$(echo "scale=4; $estimated_tokens / 1000 * ${INPUT_COSTS[$system]}" | bc)
                local estimated_output_cost=$(echo "scale=4; $estimated_tokens / 1000 * ${OUTPUT_COSTS[$system]}" | bc)
                local system_total=$(echo "scale=4; $estimated_input_cost + $estimated_output_cost" | bc)
                
                printf "  %-7s: %3d execuções, ~%dK tokens, ~$%.4f\n" "$system" "$system_executions" "$((estimated_tokens/1000))" "$system_total"
                
                total_executions=$((total_executions + system_executions))
                estimated_cost=$(echo "scale=4; $estimated_cost + $system_total" | bc)
            fi
        fi
    done
    
    if [ "$total_executions" -gt 0 ]; then
        printf "  Total: %d execuções, custo estimado: $%.4f\n" "$total_executions" "$estimated_cost"
    else
        echo "  Nenhum histórico de uso encontrado"
    fi
}

show_cost_projections() {
    echo "  Para 100 tarefas (~200K tokens):"
    
    for system in gemini claude codex; do
        local input_cost=$(echo "scale=4; 200 * ${INPUT_COSTS[$system]}" | bc)
        local output_cost=$(echo "scale=4; 200 * ${OUTPUT_COSTS[$system]}" | bc)
        local total_cost=$(echo "scale=4; $input_cost + $output_cost" | bc)
        
        printf "    %-7s: $%.4f (input: $%.4f, output: $%.4f)\n" "$system" "$total_cost" "$input_cost" "$output_cost"
    done
    
    echo
    echo "  Economia usando Gemini vs outros:"
    local gemini_total=$(echo "scale=4; 200 * (${INPUT_COSTS[gemini]} + ${OUTPUT_COSTS[gemini]})" | bc)
    local claude_total=$(echo "scale=4; 200 * (${INPUT_COSTS[claude]} + ${OUTPUT_COSTS[claude]})" | bc)
    local codex_total=$(echo "scale=4; 200 * (${INPUT_COSTS[codex]} + ${OUTPUT_COSTS[codex]})" | bc)
    
    local claude_savings=$(echo "scale=2; ($claude_total - $gemini_total) / $claude_total * 100" | bc)
    local codex_savings=$(echo "scale=2; ($codex_total - $gemini_total) / $codex_total * 100" | bc)
    
    printf "    vs Claude: %.0f%% de economia ($%.4f)\n" "$claude_savings" "$(echo "$claude_total - $gemini_total" | bc)"
    printf "    vs Codex:  %.0f%% de economia ($%.4f)\n" "$codex_savings" "$(echo "$codex_total - $gemini_total" | bc)"
}

show_cost_recommendations() {
    cat << 'RECOMMENDATIONS'
  1. 🏆 Use Gemini como sistema principal (85% mais barato)
  2. 💡 Reserve Claude para tarefas complexas que precisam de raciocínio avançado
  3. 🔧 Use Codex apenas para debugging específico ou análise de código
  4. 📊 Monitore uso com 'ai-logs summary' regularmente
  5. ⚙️  Configure rate limiting para evitar custos excessivos
  6. 💰 Estabeleça orçamento mensal e monitore com este comando

  Economia estimada usando Gemini: 80-85% vs outros sistemas
RECOMMENDATIONS
}

show_budget_tracker() {
    local budget_file="$HOME/.config/ai-parallel/budget.json"
    
    if [ -f "$budget_file" ]; then
        echo "=== ORÇAMENTO MENSAL ==="
        local budget=$(jq -r '.monthly_budget // 50' "$budget_file")
        local spent=$(jq -r '.current_spent // 0' "$budget_file")
        local remaining=$(echo "scale=2; $budget - $spent" | bc)
        local percentage=$(echo "scale=1; $spent / $budget * 100" | bc)
        
        echo "Orçamento: \$$budget"
        echo "Gasto: \$$spent ($percentage%)"
        echo "Restante: \$$remaining"
        
        if (( $(echo "$percentage > 80" | bc -l) )); then
            echo "⚠️  Atenção: 80% do orçamento usado!"
        elif (( $(echo "$percentage > 90" | bc -l) )); then
            echo "🚨 Alerta: 90% do orçamento usado!"
        fi
    else
        echo "Orçamento não configurado. Use: ai-costs budget <valor>"
    fi
}

set_budget() {
    local amount="$1"
    local budget_file="$HOME/.config/ai-parallel/budget.json"
    
    mkdir -p "$(dirname "$budget_file")"
    
    cat > "$budget_file" << EOF
{
  "monthly_budget": $amount,
  "current_spent": 0,
  "last_reset": "$(date -Iseconds)",
  "created": "$(date -Iseconds)"
}
EOF
    
    echo "Orçamento mensal definido: \$$amount"
    echo "Use 'ai-costs budget' para monitorar"
}

# Processar argumentos
case "${1:-analysis}" in
    analysis|--analysis|-a)
        show_cost_analysis
        ;;
    budget)
        if [ -n "${2:-}" ]; then
            set_budget "$2"
        else
            show_budget_tracker
        fi
        ;;
    compare|--compare|-c)
        echo "=== COMPARAÇÃO RÁPIDA DE CUSTOS ==="
        echo "Para 1000 tarefas (~2M tokens):"
        echo "  Gemini: ~\$21.00 (Recomendado)"
        echo "  Claude: ~\$180.00"
        echo "  Codex:  ~\$180.00"
        echo
        echo "Economia usando Gemini: ~\$159.00 (88%)"
        ;;
    help|--help|-h)
        cat << 'HELP'
ai-costs - Análise de custos dos sistemas de IA

COMANDOS:
    ai-costs analysis     - Análise completa de custos (padrão)
    ai-costs budget [valor] - Configurar/ver orçamento mensal
    ai-costs compare      - Comparação rápida
    ai-costs help         - Esta ajuda

EXEMPLOS:
    ai-costs              - Análise completa
    ai-costs budget 50    - Definir orçamento de $50/mês
    ai-costs budget       - Ver orçamento atual
    ai-costs compare      - Comparação rápida

DICA: Use Gemini para economizar até 85% nos custos!
HELP
        ;;
    *)
        show_cost_analysis
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-costs"
    log_success "Comando ai-costs criado"
}

# Função para criar comando ai-switch
create_switch_command() {
    log_info "Criando comando ai-switch..."
    
    sudo tee "$BIN_DIR/ai-switch" > /dev/null << 'EOF'
#!/bin/bash
# ai-switch - Alternar entre sistemas de IA no projeto atual

show_help() {
    cat << 'HELP'
ai-switch - Alternar sistema de IA do projeto

USAGE:
    ai-switch <sistema>   - Alterar para sistema específico
    ai-switch list        - Listar sistemas disponíveis
    ai-switch current     - Mostrar sistema atual
    ai-switch help        - Esta ajuda

SISTEMAS:
    gemini               - Google Gemini (Recomendado - 85% mais barato)
    claude               - Anthropic Claude (Balanced)
    codex                - OpenAI Codex (Especializado em código)

EXEMPLOS:
    ai-switch gemini     - Alterar para Gemini
    ai-switch current    - Ver sistema atual
    ai-switch list       - Ver todos os sistemas
HELP
}

switch_system() {
    local new_system="$1"
    
    # Verificar se sistema é válido
    case "$new_system" in
        gemini|claude|codex)
            ;;
        *)
            echo "Sistema inválido: $new_system"
            echo "Sistemas disponíveis: gemini, claude, codex"
            exit 1
            ;;
    esac
    
    # Verificar se projeto existe
    if [ ! -f "ai_config.json" ]; then
        echo "Nenhum projeto encontrado neste diretório"
        echo "Use 'ai-manager init <sistema>' para criar um projeto"
        exit 1
    fi
    
    # Obter sistema atual
    local current_system=$(jq -r '.project.system // "desconhecido"' ai_config.json)
    
    if [ "$current_system" = "$new_system" ]; then
        echo "Sistema já é $new_system"
        exit 0
    fi
    
    # Atualizar configuração
    local temp_file=$(mktemp)
    jq --arg system "$new_system" '.project.system = $system | .project.last_updated = now | .project.switched_from = .project.system' ai_config.json > "$temp_file"
    mv "$temp_file" ai_config.json
    
    echo "Sistema alterado: $current_system → $new_system"
    
    # Mostrar informações do novo sistema
    show_system_info "$new_system"
    
    echo
    echo "Para executar: ai-$new_system"
}

show_current_system() {
    if [ -f "ai_config.json" ]; then
        local current_system=$(jq -r '.project.system // "não configurado"' ai_config.json)
        local project_name=$(jq -r '.project.name // "Sem nome"' ai_config.json)
        
        echo "Projeto: $project_name"
        echo "Sistema atual: $current_system"
        
        if [ "$current_system" != "não configurado" ]; then
            show_system_info "$current_system"
        fi
    else
        echo "Nenhum projeto encontrado neste diretório"
        echo "Use 'ai-manager init <sistema>' para criar um projeto"
    fi
}

list_systems() {
    echo "=== SISTEMAS DISPONÍVEIS ==="
    echo
    
    # Verificar sistema atual
    local current_system="nenhum"
    if [ -f "ai_config.json" ]; then
        current_system=$(jq -r '.project.system // "nenhum"' ai_config.json)
    fi
    
    # Listar sistemas
    local systems=("gemini" "claude" "codex")
    local descriptions=("Google Gemini - 85% mais barato, mais rápido" "Anthropic Claude - Balanced e confiável" "OpenAI Codex - Especializado em código")
    local status_symbols=("🏆" "⚖️" "🔧")
    
    for i in "${!systems[@]}"; do
        local system="${systems[$i]}"
        local desc="${descriptions[$i]}"
        local symbol="${status_symbols[$i]}"
        
        if [ "$system" = "$current_system" ]; then
            echo -e "$symbol $system - $desc ${GREEN}(ATUAL)${NC}"
        else
            echo "$symbol $system - $desc"
        fi
        
        # Verificar se cliente está disponível
        if command -v "$system" >/dev/null 2>&1; then
            echo "    ✓ Cliente disponível"
        else
            echo "    ✗ Cliente não encontrado"
        fi
        
        # Verificar wrapper
        if command -v "ai-$system" >/dev/null 2>&1; then
            echo "    ✓ Wrapper disponível"
        else
            echo "    ✗ Wrapper não encontrado"
        fi
        
        echo
    done
}

show_system_info() {
    local system="$1"
    
    case "$system" in
        gemini)
            echo "📊 Gemini Info:"
            echo "  Custo: \$0.0035/1K tokens (input)"
            echo "  Rate: 60 req/min"
            echo "  Contexto: 1M tokens"
            echo "  Vantagem: 85% mais barato"
            ;;
        claude)
            echo "📊 Claude Info:"
            echo "  Custo: \$0.015/1K tokens (input)"
            echo "  Rate: 30 req/min"
            echo "  Contexto: 200K tokens"
            echo "  Vantagem: Balanced e confiável"
            ;;
        codex)
            echo "📊 Codex Info:"
            echo "  Custo: \$0.03/1K tokens (input)"
            echo "  Rate: 20 req/min"
            echo "  Contexto: 128K tokens"
            echo "  Vantagem: Especializado em código"
            ;;
    esac
}

# Cores
GREEN='\033[0;32m'
NC='\033[0m'

# Processar argumentos
case "${1:-help}" in
    gemini|claude|codex)
        switch_system "$1"
        ;;
    current)
        show_current_system
        ;;
    list)
        list_systems
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Comando desconhecido: ${1:-}"
        echo "Use 'ai-switch help' para ver comandos disponíveis"
        exit 1
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-switch"
    log_success "Comando ai-switch criado"
}

# Função para criar comando ai-init (alternativa ao ai-manager init)
create_init_command() {
    log_info "Criando comando ai-init..."
    
    sudo tee "$BIN_DIR/ai-init" > /dev/null << 'EOF'
#!/bin/bash
# ai-init - Inicialização rápida de projetos

show_help() {
    cat << 'HELP'
ai-init - Inicialização rápida de projetos com IA

USAGE:
    ai-init [sistema] [template]  - Inicializar projeto
    ai-init list                  - Listar templates disponíveis
    ai-init help                  - Esta ajuda

SISTEMAS:
    gemini (padrão)              - Google Gemini
    claude                       - Anthropic Claude  
    codex                        - OpenAI Codex

TEMPLATES:
    basic (padrão)               - Projeto básico
    web                          - Aplicação web
    api                          - API REST
    ml                           - Machine Learning
    mobile                       - Aplicativo móvel

EXEMPLOS:
    ai-init                      - Projeto básico com Gemini
    ai-init gemini web           - App web com Gemini
    ai-init claude api           - API REST com Claude
    ai-init codex ml             - ML project com Codex
HELP
}

create_basic_template() {
    local system="$1"
    
    cat > tasks.json << EOF
{
  "project_info": {
    "name": "$(basename $(pwd))",
    "description": "Projeto desenvolvido com $system AI",
    "base_branch": "main",
    "created": "$(date -Iseconds)"
  },
  "tasks": [
    {
      "id": "setup-project",
      "title": "Configurar Projeto",
      "prompt": "Configure a estrutura básica do projeto com as melhores práticas. Inclua estrutura de diretórios, arquivos de configuração, documentação inicial e setup de desenvolvimento.",
      "branch_name": "feature/setup-project",
      "language": "python",
      "priority": 1,
      "files_to_focus": ["src/", "docs/", "tests/"]
    }
  ]
}
EOF
}

create_web_template() {
    local system="$1"
    
    cat > tasks.json << EOF
{
  "project_info": {
    "name": "$(basename $(pwd)) Web App",
    "description": "Aplicação web desenvolvida com $system AI",
    "base_branch": "main",
    "created": "$(date -Iseconds)"
  },
  "tasks": [
    {
      "id": "setup-frontend",
      "title": "Configurar Frontend",
      "prompt": "Configure uma aplicação web moderna com React/Vue.js. Inclua estrutura de componentes, roteamento, estado global, estilização com Tailwind CSS e configuração de build.",
      "branch_name": "feature/setup-frontend",
      "language": "javascript",
      "framework": "react",
      "priority": 1,
      "files_to_focus": ["src/", "public/", "components/"]
    },
    {
      "id": "setup-backend",
      "title": "Configurar Backend",
      "prompt": "Configure uma API backend robusta com Node.js/Express ou Python/FastAPI. Inclua estrutura de rotas, middleware, autenticação, validação e documentação da API.",
      "branch_name": "feature/setup-backend",
      "language": "typescript",
      "framework": "express",
      "priority": 2,
      "files_to_focus": ["server/", "routes/", "middleware/"]
    }
  ]
}
EOF
}

create_api_template() {
    local system="$1"
    
    cat > tasks.json << EOF
{
  "project_info": {
    "name": "$(basename $(pwd)) API",
    "description": "API REST desenvolvida com $system AI",
    "base_branch": "main",
    "created": "$(date -Iseconds)"
  },
  "tasks": [
    {
      "id": "setup-api-structure",
      "title": "Configurar Estrutura da API",
      "prompt": "Configure uma API REST completa com FastAPI/Flask ou Express. Inclua estrutura de rotas, modelos de dados, validação, autenticação JWT, documentação automática com Swagger, testes e configuração de banco de dados.",
      "branch_name": "feature/api-structure",
      "language": "python",
      "framework": "fastapi",
      "priority": 1,
      "files_to_focus": ["app/", "models/", "routes/", "tests/"]
    },
    {
      "id": "implement-crud",
      "title": "Implementar Operações CRUD",
      "prompt": "Implemente operações CRUD completas com validação, tratamento de erros, paginação e filtros. Inclua endpoints para criar, ler, atualizar e deletar recursos com boas práticas de API REST.",
      "branch_name": "feature/crud-operations",
      "language": "python",
      "framework": "fastapi",
      "priority": 2,
      "files_to_focus": ["app/crud/", "app/schemas/", "app/models/"]
    }
  ]
}
EOF
}

create_ml_template() {
    local system="$1"
    
    cat > tasks.json << EOF
{
  "project_info": {
    "name": "$(basename $(pwd)) ML Project",
    "description": "Projeto de Machine Learning com $system AI",
    "base_branch": "main",
    "created": "$(date -Iseconds)"
  },
  "tasks": [
    {
      "id": "setup-ml-environment",
      "title": "Configurar Ambiente ML",
      "prompt": "Configure um ambiente completo de Machine Learning com Python. Inclua estrutura de projeto, notebooks Jupyter, pipeline de dados, configuração de dependências (pandas, scikit-learn, tensorflow/pytorch), versionamento de dados e experimentos.",
      "branch_name": "feature/ml-setup",
      "language": "python",
      "framework": "scikit-learn",
      "priority": 1,
      "files_to_focus": ["notebooks/", "src/", "data/", "models/"]
    },
    {
      "id": "data-preprocessing",
      "title": "Pipeline de Pré-processamento",
      "prompt": "Implemente um pipeline robusto de pré-processamento de dados. Inclua limpeza de dados, tratamento de valores ausentes, normalização, feature engineering, divisão treino/teste e validação cruzada.",
      "branch_name": "feature/data-preprocessing",
      "language": "python",
      "framework": "pandas",
      "priority": 2,
      "files_to_focus": ["src/preprocessing/", "notebooks/", "data/"]
    }
  ]
}
EOF
}

create_mobile_template() {
    local system="$1"
    
    cat > tasks.json << EOF
{
  "project_info": {
    "name": "$(basename $(pwd)) Mobile App",
    "description": "Aplicativo móvel desenvolvido com $system AI",
    "base_branch": "main",
    "created": "$(date -Iseconds)"
  },
  "tasks": [
    {
      "id": "setup-mobile-app",
      "title": "Configurar App Mobile",
      "prompt": "Configure um aplicativo móvel multiplataforma com React Native ou Flutter. Inclua estrutura de navegação, gerenciamento de estado, componentes reutilizáveis, integração com APIs, configuração de build para iOS/Android.",
      "branch_name": "feature/mobile-setup",
      "language": "dart",
      "framework": "flutter",
      "priority": 1,
      "files_to_focus": ["lib/", "assets/", "test/"]
    },
    {
      "id": "implement-ui",
      "title": "Implementar Interface",
      "prompt": "Implemente uma interface de usuário moderna e responsiva. Inclua telas principais, componentes customizados, navegação fluida, animações, tema consistente e suporte a diferentes tamanhos de tela.",
      "branch_name": "feature/ui-implementation",
      "language": "dart",
      "framework": "flutter",
      "priority": 2,
      "files_to_focus": ["lib/screens/", "lib/widgets/", "lib/themes/"]
    }
  ]
}
EOF
}

create_project_config() {
    local system="$1"
    local template="$2"
    
    cat > ai_config.json << EOF
{
  "project": {
    "name": "$(basename $(pwd))",
    "template": "$template",
    "system": "$system",
    "created": "$(date -Iseconds)"
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

list_templates() {
    echo "=== TEMPLATES DISPONÍVEIS ==="
    echo
    echo "📁 basic    - Projeto básico com estrutura padrão"
    echo "🌐 web      - Aplicação web (React/Vue + Backend)"
    echo "🔌 api      - API REST (FastAPI/Express)"
    echo "🤖 ml       - Machine Learning (Python/Jupyter)"
    echo "📱 mobile   - App móvel (React Native/Flutter)"
    echo
    echo "Uso: ai-init [sistema] [template]"
    echo "Exemplo: ai-init gemini web"
}

init_project() {
    local system="${1:-gemini}"
    local template="${2:-basic}"
    
    # Verificar se sistema é válido
    case "$system" in
        gemini|claude|codex)
            ;;
        *)
            echo "Sistema inválido: $system"
            echo "Sistemas disponíveis: gemini, claude, codex"
            exit 1
            ;;
    esac
    
    # Verificar se arquivos já existem
    if [ -f "tasks.json" ] || [ -f "ai_config.json" ]; then
        echo "Projeto já inicializado neste diretório"
        echo "Arquivos existentes: $(ls -1 tasks.json ai_config.json 2>/dev/null | tr '\n' ' ')"
        echo "Sobrescrever? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Operação cancelada"
            exit 0
        fi
    fi
    
    # Criar template baseado no tipo
    case "$template" in
        basic)
            create_basic_template "$system"
            ;;
        web)
            create_web_template "$system"
            ;;
        api)
            create_api_template "$system"
            ;;
        ml)
            create_ml_template "$system"
            ;;
        mobile)
            create_mobile_template "$system"
            ;;
        *)
            echo "Template inválido: $template"
            echo "Use 'ai-init list' para ver templates disponíveis"
            exit 1
            ;;
    esac
    
    # Criar configuração do projeto
    create_project_config "$system" "$template"
    
    echo "✅ Projeto inicializado!"
    echo "   Sistema: $system"
    echo "   Template: $template"
    echo "   Diretório: $(pwd)"
    echo
    echo "Próximos passos:"
    echo "1. Edite tasks.json se necessário"
    echo "2. Execute: ai-$system"
    echo "3. Monitore: ai-logs live $system"
}

# Processar argumentos
case "${1:-}" in
    list)
        list_templates
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        init_project "gemini" "basic"
        ;;
    *)
        if [ "$1" = "gemini" ] || [ "$1" = "claude" ] || [ "$1" = "codex" ]; then
            init_project "$1" "${2:-basic}"
        else
            init_project "gemini" "$1"
        fi
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-init"
    log_success "Comando ai-init criado"
}

# Função para atualizar comando ai-logs
update_logs_command() {
    log_info "Atualizando comando ai-logs..."
    
    sudo tee "$BIN_DIR/ai-logs" > /dev/null << 'EOF'
#!/bin/bash
# ai-logs - Visualizador avançado de logs dos sistemas de IA

LOGS_DIR="$HOME/.local/share/ai-parallel/logs"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

show_help() {
    cat << 'HELP'
ai-logs - Visualizador avançado de logs

COMANDOS:
    summary              - Resumo de todos os logs (padrão)
    live [sistema]       - Logs em tempo real
    search <termo>       - Buscar nos logs
    errors               - Mostrar apenas erros
    stats                - Estatísticas de uso
    cleanup [dias]       - Limpar logs antigos
    export <arquivo>     - Exportar logs

SISTEMAS:
    all (padrão)         - Todos os sistemas
    gemini               - Apenas Gemini
    claude               - Apenas Claude
    codex                - Apenas Codex

EXEMPLOS:
    ai-logs              - Resumo geral
    ai-logs live gemini  - Logs do Gemini em tempo real
    ai-logs search ERROR - Buscar erros
    ai-logs stats        - Estatísticas de uso
    ai-logs cleanup 7    - Limpar logs > 7 dias
HELP
}

show_summary() {
    echo -e "${BLUE}=== RESUMO DOS LOGS DOS SISTEMAS DE IA ===${NC}"
    echo
    
    if [ ! -d "$LOGS_DIR" ]; then
        echo "Diretório de logs não encontrado: $LOGS_DIR"
        return 1
    fi
    
    # Estatísticas gerais
    local total_logs=$(find "$LOGS_DIR" -name "*.log" -type f 2>/dev/null | wc -l)
    local recent_logs=$(find "$LOGS_DIR" -name "*.log" -type f -mtime -1 2>/dev/null | wc -l)
    
    echo -e "${CYAN}Estatísticas Gerais:${NC}"
    echo "  Total de logs: $total_logs"
    echo "  Logs recentes (24h): $recent_logs"
    echo "  Diretório: $LOGS_DIR"
    echo
    
    # Logs por sistema
    for system in gemini claude codex; do
        if [ -d "$LOGS_DIR/$system" ]; then
            echo -e "${YELLOW}Sistema: $system${NC}"
            
            local system_logs=$(find "$LOGS_DIR/$system" -name "*.log" -type f 2>/dev/null | wc -l)
            local recent_system_logs=$(find "$LOGS_DIR/$system" -name "*.log" -type f -mtime -1 2>/dev/null | wc -l)
            
            echo "  Logs: $system_logs (recentes: $recent_system_logs)"
            
            # Mostrar últimos logs
            local latest_logs=$(find "$LOGS_DIR/$system" -name "*.log" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -3 | cut -d' ' -f2-)
            
            if [ -n "$latest_logs" ]; then
                echo "  Últimos logs:"
                echo "$latest_logs" | while read -r log_file; do
                    local task_name=$(basename "$log_file" .log)
                    local timestamp=$(stat -c %y "$log_file" 2>/dev/null | cut -d'.' -f1)
                    echo "    - $task_name ($timestamp)"
                    
                    # Mostrar última linha do log
                    local last_line=$(tail -1 "$log_file" 2>/dev/null | head -c 80)
                    if [ -n "$last_line" ]; then
                        echo "      $last_line..."
                    fi
                done
            fi
            echo
        fi
    done
    
    # Erros recentes
    show_recent_errors
}

show_live_logs() {
    local system="${1:-all}"
    
    echo -e "${BLUE}=== LOGS EM TEMPO REAL ($system) ===${NC}"
    echo "Pressione Ctrl+C para sair"
    echo
    
    if [ "$system" = "all" ]; then
        tail -f "$LOGS_DIR"/*/*.log 2>/dev/null | while read -r line; do
            colorize_log_line "$line"
        done
    else
        if [ -d "$LOGS_DIR/$system" ]; then
            tail -f "$LOGS_DIR/$system"/*.log 2>/dev/null | while read -r line; do
                colorize_log_line "$line"
            done
        else
            echo "Sistema não encontrado: $system"
            echo "Sistemas disponíveis: gemini, claude, codex"
        fi
    fi
}

colorize_log_line() {
    local line="$1"
    
    if [[ "$line" == *"ERROR"* ]]; then
        echo -e "${RED}$line${NC}"
    elif [[ "$line" == *"WARN"* ]]; then
        echo -e "${YELLOW}$line${NC}"
    elif [[ "$line" == *"SUCCESS"* ]]; then
        echo -e "${GREEN}$line${NC}"
    elif [[ "$line" == *"INFO"* ]]; then
        echo -e "${BLUE}$line${NC}"
    else
        echo "$line"
    fi
}

search_logs() {
    local search_term="$1"
    local system="${2:-all}"
    
    echo -e "${BLUE}=== BUSCA NOS LOGS: '$search_term' ===${NC}"
    echo
    
    if [ "$system" = "all" ]; then
        local search_path="$LOGS_DIR"
    else
        local search_path="$LOGS_DIR/$system"
    fi
    
    if [ ! -d "$search_path" ]; then
        echo "Diretório não encontrado: $search_path"
        return 1
    fi
    
    local results=$(grep -r -i "$search_term" "$search_path" --include="*.log" 2>/dev/null)
    
    if [ -n "$results" ]; then
        echo "$results" | while read -r result; do
            local file_path=$(echo "$result" | cut -d':' -f1)
            local line_content=$(echo "$result" | cut -d':' -f2-)
            local file_name=$(basename "$file_path")
            local system_name=$(basename "$(dirname "$file_path")")
            
            echo -e "${CYAN}[$system_name/$file_name]${NC} $line_content"
        done
    else
        echo "Nenhum resultado encontrado para: '$search_term'"
    fi
}

show_recent_errors() {
    echo -e "${RED}=== ERROS RECENTES ===${NC}"
    
    local error_logs=$(grep -r -i "error\|fail\|exception" "$LOGS_DIR" --include="*.log" 2>/dev/null | tail -10)
    
    if [ -n "$error_logs" ]; then
        echo "$error_logs" | while read -r error; do
            local file_path=$(echo "$error" | cut -d':' -f1)
            local error_content=$(echo "$error" | cut -d':' -f2-)
            local file_name=$(basename "$file_path")
            local system_name=$(basename "$(dirname "$file_path")")
            
            echo -e "${RED}[$system_name/$file_name]${NC} $error_content"
        done
    else
        echo -e "${GREEN}Nenhum erro recente encontrado${NC}"
    fi
    echo
}

show_stats() {
    echo -e "${BLUE}=== ESTATÍSTICAS DE USO ===${NC}"
    echo
    
    # Estatísticas por sistema
    for system in gemini claude codex; do
        if [ -d "$LOGS_DIR/$system" ]; then
            echo -e "${YELLOW}$system:${NC}"
            
            local total_executions=$(find "$LOGS_DIR/$system" -name "task_*.log" -type f 2>/dev/null | wc -l)
            local successful_executions=$(grep -l "concluída\|SUCCESS" "$LOGS_DIR/$system"/task_*.log 2>/dev/null | wc -l)
            local failed_executions=$(grep -l "ERRO\|ERROR\|FAIL" "$LOGS_DIR/$system"/task_*.log 2>/dev/null | wc -l)
            
            local success_rate=0
            if [ "$total_executions" -gt 0 ]; then
                success_rate=$(echo "scale=1; $successful_executions * 100 / $total_executions" | bc 2>/dev/null || echo "0")
            fi
            
            echo "  Execuções totais: $total_executions"
            echo "  Sucessos: $successful_executions"
            echo "  Falhas: $failed_executions"
            echo "  Taxa de sucesso: $success_rate%"
            
            # Atividade por período
            local today=$(find "$LOGS_DIR/$system" -name "*.log" -type f -mtime 0 2>/dev/null | wc -l)
            local week=$(find "$LOGS_DIR/$system" -name "*.log" -type f -mtime -7 2>/dev/null | wc -l)
            local month=$(find "$LOGS_DIR/$system" -name "*.log" -type f -mtime -30 2>/dev/null | wc -l)
            
            echo "  Atividade - Hoje: $today, Semana: $week, Mês: $month"
            echo
        fi
    done
    
    # Tamanho dos logs
    echo -e "${CYAN}Armazenamento:${NC}"
    if command -v du >/dev/null 2>&1; then
        local total_size=$(du -sh "$LOGS_DIR" 2>/dev/null | cut -f1)
        echo "  Tamanho total: $total_size"
        
        for system in gemini claude codex; do
            if [ -d "$LOGS_DIR/$system" ]; then
                local system_size=$(du -sh "$LOGS_DIR/$system" 2>/dev/null | cut -f1)
                echo "  $system: $system_size"
            fi
        done
    fi
}

cleanup_logs() {
    local days="${1:-30}"
    
    echo -e "${YELLOW}=== LIMPEZA DE LOGS (>$days dias) ===${NC}"
    echo
    
    # Encontrar logs antigos
    local old_logs=$(find "$LOGS_DIR" -name "*.log" -type f -mtime +$days 2>/dev/null)
    local count=$(echo "$old_logs" | grep -c . 2>/dev/null || echo "0")
    
    if [ "$count" -gt 0 ]; then
        echo "Logs encontrados para remoção: $count"
        echo "Logs com mais de $days dias:"
        echo "$old_logs" | head -10
        
        if [ "$count" -gt 10 ]; then
            echo "... e mais $((count - 10)) arquivos"
        fi
        
        echo
        echo "Confirmar remoção? (y/N)"
        read -r response
        
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "$old_logs" | xargs rm -f 2>/dev/null
            echo -e "${GREEN}$count logs removidos${NC}"
        else
            echo "Operação cancelada"
        fi
    else
        echo -e "${GREEN}Nenhum log antigo encontrado${NC}"
    fi
}

export_logs() {
    local output_file="$1"
    local system="${2:-all}"
    
    echo -e "${BLUE}=== EXPORTANDO LOGS ===${NC}"
    
    if [ -z "$output_file" ]; then
        output_file="ai-logs-export-$(date +%Y%m%d_%H%M%S).tar.gz"
    fi
    
    if [ "$system" = "all" ]; then
        tar -czf "$output_file" -C "$(dirname "$LOGS_DIR")" "$(basename "$LOGS_DIR")" 2>/dev/null
    else
        if [ -d "$LOGS_DIR/$system" ]; then
            tar -czf "$output_file" -C "$LOGS_DIR" "$system" 2>/dev/null
        else
            echo "Sistema não encontrado: $system"
            return 1
        fi
    fi
    
    if [ -f "$output_file" ]; then
        local file_size=$(du -h "$output_file" | cut -f1)
        echo -e "${GREEN}Logs exportados: $output_file ($file_size)${NC}"
    else
        echo -e "${RED}Erro ao exportar logs${NC}"
        return 1
    fi
}

# Processar argumentos
case "${1:-summary}" in
    summary|--summary|-s)
        show_summary
        ;;
    live|--live|-l)
        show_live_logs "${2:-all}"
        ;;
    search|--search)
        if [ -n "${2:-}" ]; then
            search_logs "$2" "${3:-all}"
        else
            echo "Uso: ai-logs search <termo> [sistema]"
        fi
        ;;
    errors|--errors|-e)
        show_recent_errors
        ;;
    stats|--stats)
        show_stats
        ;;
    cleanup|--cleanup)
        cleanup_logs "${2:-30}"
        ;;
    export|--export)
        export_logs "${2:-}" "${3:-all}"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Comando desconhecido: $1"
        echo "Use 'ai-logs help' para ver comandos disponíveis"
        exit 1
        ;;
esac
EOF

    sudo chmod +x "$BIN_DIR/ai-logs"
    log_success "Comando ai-logs atualizado"
}

# Função principal
main() {
    log_info "Criando sistema de comandos avançados para clientes existentes..."
    
    create_advanced_status_command
    create_costs_command
    create_switch_command
    create_init_command
    update_logs_command
    
    log_success "Sistema de comandos avançados criado"
    
    echo
    echo "Novos comandos disponíveis:"
    echo "  ai-status    - Status detalhado dos sistemas"
    echo "  ai-costs     - Análise de custos e orçamento"
    echo "  ai-switch    - Alternar sistema do projeto"
    echo "  ai-init      - Inicialização rápida com templates"
    echo "  ai-logs      - Visualizador avançado de logs"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

