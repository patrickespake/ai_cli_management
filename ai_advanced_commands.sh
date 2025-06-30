#!/bin/bash
# ai_advanced_commands.sh - Advanced AI Commands System
# Version 1.0 (Fixed for asdf/sudo environments)
# Assumes existing CLI clients: codex, claude, gemini

set -euo pipefail

# Global variables
INSTALL_DIR="/opt/ai-parallel-systems"
LOG_FILE="/tmp/ai-advanced.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_header() {
    echo -e "${BLUE}$1${NC}" | tee -a "$LOG_FILE"
}

# Function to create ai-quick command
create_ai_quick() {
    log_info "Creating ai-quick command..."
    sudo tee /usr/local/bin/ai-quick > /dev/null << 'EOF'
#!/bin/bash
# ai-quick - Quick AI execution with Gemini (cost-optimized)
# Version 1.0

PROJECT_ROOT="$(pwd)"
TASKS_FILE="$PROJECT_ROOT/tasks.json"

if [ ! -f "$TASKS_FILE" ]; then
    echo "Error: tasks.json not found in current directory"
    echo "Use: ai-manager init gemini"
    exit 1
fi

echo "🚀 Quick AI execution with Gemini (85% cost savings)"
echo "📁 Project: $(basename "$PROJECT_ROOT")"
echo "📋 Tasks file: $TASKS_FILE"
echo

# Execute with Gemini for maximum cost savings
exec ai-gemini "$@"
EOF
    sudo chmod +x /usr/local/bin/ai-quick
    log_success "ai-quick command created"
}

# Function to create ai-switch command
create_ai_switch() {
    log_info "Creating ai-switch command..."
    sudo tee /usr/local/bin/ai-switch > /dev/null << 'EOF'
#!/bin/bash
# ai-switch - Intelligent AI system selection
# Version 1.0

show_help() {
    cat << 'HELP'
ai-switch - Intelligent AI System Selection

USAGE:
  ai-switch <strategy> [options]

STRATEGIES:
  cost-optimal     Use most cost-effective system (Gemini)
  performance      Use fastest system (Gemini)
  reasoning        Use best reasoning system (Claude)
  code-focused     Use best code system (Codex)
  balanced         Use balanced approach (Gemini primary)

EXAMPLES:
  ai-switch cost-optimal    # Use Gemini (85% savings)
  ai-switch reasoning       # Use Claude for complex tasks
  ai-switch code-focused    # Use Codex for code optimization

COST COMPARISON:
  🏆 Gemini: $0.0035/1K (RECOMMENDED)
  ⚖️ Claude: $0.015/1K
  🔧 Codex: $0.03/1K
HELP
}

case "${1:-help}" in
    cost-optimal|cost)
        echo "🏆 Switching to Gemini (cost-optimal: 85% savings)"
        exec ai-gemini "${@:2}"
        ;;
    performance|fast)
        echo "⚡ Switching to Gemini (performance-optimal: 60 req/min)"
        exec ai-gemini "${@:2}"
        ;;
    reasoning|complex)
        echo "🧠 Switching to Claude (reasoning-optimal)"
        exec ai-claude "${@:2}"
        ;;
    code-focused|code)
        echo "🔧 Switching to Codex (code-optimal)"
        exec ai-codex "${@:2}"
        ;;
    balanced)
        echo "⚖️ Switching to Gemini (balanced approach)"
        exec ai-gemini "${@:2}"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown strategy: ${1:-}"
        echo "Use 'ai-switch help' for available strategies"
        exit 1
        ;;
esac
EOF
    sudo chmod +x /usr/local/bin/ai-switch
    log_success "ai-switch command created"
}

# Function to create ai-logs command
create_ai_logs() {
    log_info "Creating ai-logs command..."
    sudo tee /usr/local/bin/ai-logs > /dev/null << 'EOF'
#!/bin/bash
# ai-logs - Centralized logging viewer
# Version 1.0

PROJECT_ROOT="$(pwd)"
LOG_DIR="$PROJECT_ROOT/.ai-logs"

show_help() {
    cat << 'HELP'
ai-logs - Centralized Logging Viewer

USAGE:
  ai-logs <command> [options]

COMMANDS:
  live             Show live logs (tail -f)
  recent           Show recent logs (last 100 lines)
  errors           Show only error logs
  summary          Show log summary
  clean            Clean old logs (>7 days)

EXAMPLES:
  ai-logs live     # Watch logs in real-time
  ai-logs recent   # Show recent activity
  ai-logs errors   # Show only errors
HELP
}

case "${1:-recent}" in
    live|tail)
        echo "📊 Live AI Systems Logs (Ctrl+C to exit)"
        echo "=================================="
        if [ -d "$LOG_DIR" ]; then
            tail -f "$LOG_DIR"/*.log 2>/dev/null || echo "No log files found"
        else
            echo "Log directory not found: $LOG_DIR"
        fi
        ;;
    recent)
        echo "📋 Recent AI Systems Activity"
        echo "============================="
        if [ -d "$LOG_DIR" ]; then
            find "$LOG_DIR" -name "*.log" -type f -exec tail -20 {} \; 2>/dev/null || echo "No log files found"
        else
            echo "Log directory not found: $LOG_DIR"
        fi
        ;;
    errors)
        echo "🚨 AI Systems Errors"
        echo "==================="
        if [ -d "$LOG_DIR" ]; then
            find "$LOG_DIR" -name "*.log" -type f -exec grep -i "error\|fail\|exception" {} \; 2>/dev/null || echo "No errors found"
        else
            echo "Log directory not found: $LOG_DIR"
        fi
        ;;
    summary)
        echo "📊 AI Systems Log Summary"
        echo "========================"
        if [ -d "$LOG_DIR" ]; then
            echo "Log files:"
            find "$LOG_DIR" -name "*.log" -type f -exec ls -lh {} \; 2>/dev/null || echo "No log files found"
            echo
            echo "Total log size:"
            du -sh "$LOG_DIR" 2>/dev/null || echo "0B"
        else
            echo "Log directory not found: $LOG_DIR"
        fi
        ;;
    clean)
        echo "🧹 Cleaning old logs (>7 days)"
        if [ -d "$LOG_DIR" ]; then
            find "$LOG_DIR" -name "*.log" -type f -mtime +7 -delete 2>/dev/null
            echo "✅ Old logs cleaned"
        else
            echo "Log directory not found: $LOG_DIR"
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: ${1:-}"
        echo "Use 'ai-logs help' for available commands"
        exit 1
        ;;
esac
EOF
    sudo chmod +x /usr/local/bin/ai-logs
    log_success "ai-logs command created"
}

# Function to create ai-dashboard command
create_ai_dashboard() {
    log_info "Creating ai-dashboard command..."

    local REAL_NODE_PATH=""
    local REAL_NPM_PATH=""

    # First try to use the Node.js that is already available on the PATH.
    # This will correctly handle installations performed with the system
    # package manager, nvm, Homebrew, etc.
    if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
        REAL_NODE_PATH=$(command -v node)
        REAL_NPM_PATH=$(command -v npm)

        # If the detected paths are asdf shims, replace them with the real binaries.
        if [[ "$REAL_NODE_PATH" == *".asdf/shims"* ]]; then
            # The user is using asdf but we grabbed the shim. Replace by the real binary.
            if command -v asdf >/dev/null 2>&1; then
                REAL_NODE_PATH=$(asdf which node 2>/dev/null || true)
                local NODE_DIR_TMP
                NODE_DIR_TMP=$(dirname "$REAL_NODE_PATH")
                if [ -x "$NODE_DIR_TMP/npm" ]; then
                    REAL_NPM_PATH="$NODE_DIR_TMP/npm"
                else
                    REAL_NPM_PATH=$(asdf which npm 2>/dev/null || true)
                fi
            fi
        fi

    # If Node.js is NOT available globally, fall back to the asdf version (if any)
    elif command -v asdf >/dev/null 2>&1; then
        log_info "asdf detected. Trying to use asdf-managed Node.js version..."

        ASDF_DIR=${ASDF_DIR:-"$HOME/.asdf"}

        # shellcheck source=/dev/null – we purposely source the file if it exists
        [ -f "$ASDF_DIR/asdf.sh" ] && . "$ASDF_DIR/asdf.sh"

        # The `asdf which` command returns the shim by default which breaks under
        # sudo. Therefore we derive the REAL binary path and avoid the shim.
        REAL_NODE_PATH=$(asdf which node 2>/dev/null || true)

        if [ -n "$REAL_NODE_PATH" ]; then
            local NODE_DIR
            NODE_DIR=$(dirname "$REAL_NODE_PATH")

            # Prefer the npm that lives next to the real node binary so that no
            # shim scripts are involved.
            if [ -x "$NODE_DIR/npm" ]; then
                REAL_NPM_PATH="$NODE_DIR/npm"
            fi
        fi

        # As a last resort fall back to the shim path (works when *not* using sudo)
        if [ -z "$REAL_NPM_PATH" ]; then
            REAL_NPM_PATH=$(asdf which npm 2>/dev/null || true)
        fi

        # Abort if we still couldn't resolve a working Node.js toolchain.
        if [ -z "$REAL_NODE_PATH" ] || [ -z "$REAL_NPM_PATH" ]; then
            log_warn "No usable Node.js version configured with asdf. Skipping dashboard installation."
            log_warn "Tip: run 'asdf install nodejs latest && asdf global nodejs latest' and re-run the installer."
            return
        fi

    # Neither a global Node.js nor asdf managed one is available → abort.
    else
        log_warn "Node.js and npm were not found on this system. Skipping ai-dashboard installation."
        log_warn "Please install Node.js (>=14) along with npm and re-run the installer."
        return
    fi

    if [ ! -x "$REAL_NODE_PATH" ] || [ ! -x "$REAL_NPM_PATH" ]; then
        log_error "Could not find a valid Node.js/npm executable. Skipping dashboard."
        return 1
    fi

    log_info "Using Node at: $REAL_NODE_PATH"
    log_info "Using npm at: $REAL_NPM_PATH"

    # Create dashboard directory
    sudo mkdir -p "$INSTALL_DIR/dashboard"
    
    # Create dashboard files
    sudo tee "$INSTALL_DIR/dashboard/package.json" > /dev/null << 'EOF'
{ "name": "ai-dashboard", "version": "1.0.0", "description": "Real-time dashboard for AI Parallel Systems", "main": "server.js", "dependencies": { "express": "^4.17.1", "socket.io": "^4.0.0" } }
EOF
    sudo tee "$INSTALL_DIR/dashboard/server.js" > /dev/null << 'EOF'
const express=require("express"),http=require("http"),socketIo=require("socket.io"),path=require("path"),app=express(),server=http.createServer(app),io=socketIo(server);app.use(express.json()),app.use(express.static(__dirname)),app.post("/api/update",((e,s)=>{const{taskId:o,status:t,title:a,pr_url:n,message:i}=e.body;io.emit("task_update",{taskId:o,status:t,title:a,pr_url:n,message:i}),s.status(200).send({message:"Update received"})})),io.on("connection",(e=>{console.log("Dashboard client connected"),e.on("disconnect",(()=>console.log("Dashboard client disconnected")))})),server.listen(8081,(()=>console.log("Dashboard server listening on port 8081")));
EOF
    sudo tee "$INSTALL_DIR/dashboard/index.html" > /dev/null << 'EOF'
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>AI Parallel Systems Dashboard</title><style>body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;background-color:#f0f2f5;color:#333;margin:0;padding:1rem}header{display:flex;justify-content:space-between;align-items:center;padding:1rem 2rem;background-color:#fff;border-radius:8px;box-shadow:0 2px 4px #0000000d}h1{font-size:1.5rem;margin:0}#status-indicator{font-size:1rem;font-weight:700}.status-connected{color:#28a745}.status-disconnected{color:#dc3545}#task-container{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:1rem;margin-top:1rem}.task-card{background-color:#fff;border-radius:8px;box-shadow:0 2px 4px #0000000d;padding:1.5rem;transition:all .3s ease}.task-card h3{margin:0 0 .5rem;font-size:1.1rem}.task-card p{margin:.25rem 0;font-size:.9rem;color:#666}.task-status{font-weight:700;padding:.25rem .5rem;border-radius:4px;display:inline-block;font-size:.8rem}.status-running{background-color:#e6f7ff;color:#1890ff}.status-completed{background-color:#f6ffed;color:#52c41a}.status-failed{background-color:#fff1f0;color:#f5222d}.status-pr_created{background-color:#f9f0ff;color:#722ed1}.pr-link{display:block;margin-top:1rem;font-weight:700}</style></head><body><header><h1>AI Parallel Systems Dashboard</h1><div id="status-indicator">Connecting...</div></header><main><div id="task-container"></div></main><script src="/socket.io/socket.io.js"></script><script src="dashboard.js"></script></body></html>
EOF
    sudo tee "$INSTALL_DIR/dashboard/dashboard.js" > /dev/null << 'EOF'
document.addEventListener("DOMContentLoaded",(()=>{const e=io(),t=document.getElementById("status-indicator"),s=document.getElementById("task-container");e.on("connect",(()=>{t.textContent="Connected",t.className="status-connected"})),e.on("disconnect",(()=>{t.textContent="Disconnected",t.className="status-disconnected"})),e.on("task_update",(e=>{let o=document.getElementById(`task-${e.taskId}`);o||(o=document.createElement("div"),o.id=`task-${e.taskId}`,o.className="task-card",s.appendChild(o));let n=`<span class="task-status status-${e.status.toLowerCase()}">${e.status}</span>`,a=e.pr_url?`<a href="${e.pr_url}" target="_blank" class="pr-link">View Pull Request</a>`:"";o.innerHTML=`
            <h3>${e.title||e.taskId}</h3>
            <p><strong>ID:</strong> ${e.taskId}</p>
            <p><strong>Status:</strong> ${n}</p>
            ${e.message?`<p><strong>Info:</strong> ${e.message}</p>`:""}
            ${a}
        `}))}));
EOF

    # Install dashboard dependencies using the real npm path
    log_info "Installing dashboard dependencies..."
    local NODE_BIN_DIR
    NODE_BIN_DIR=$(dirname "$REAL_NODE_PATH")
    
    # Use sudo with a carefully crafted PATH to ensure npm and its scripts work
    # Some npm scripts require running as the current user; however we are
    # installing into a root-owned directory. Using --unsafe-perm avoids npm
    # dropping privileges mid-install. We also make sure the directory is
    # writable by root.
    sudo env "PATH=$NODE_BIN_DIR:$PATH" "$REAL_NPM_PATH" install --prefix "$INSTALL_DIR/dashboard" --unsafe-perm
    if [ $? -ne 0 ]; then
        log_error "Failed to install dashboard dependencies. Skipping dashboard setup."
        return 1
    fi
    log_success "Dashboard dependencies installed."

    # Create systemd USER service file
    log_info "Creating systemd user service for ai-dashboard..."
    local service_dir="$HOME/.config/systemd/user"
    mkdir -p "$service_dir"
    
    # Use the real node path in the service file
    SERVICE_FILE_CONTENT=$(cat <<EOF
[Unit]
Description=AI Parallel Systems Web Dashboard
After=network.target

[Service]
ExecStart=${REAL_NODE_PATH} ${INSTALL_DIR}/dashboard/server.js
Restart=always
WorkingDirectory=${INSTALL_DIR}/dashboard

[Install]
WantedBy=default.target
EOF
)
    echo "$SERVICE_FILE_CONTENT" > "$service_dir/ai-dashboard.service"

    # Reload systemd daemon and enable the service
    log_info "Reloading systemd and enabling dashboard service..."
    systemctl --user daemon-reload
    systemctl --user enable ai-dashboard.service
    log_success "ai-dashboard systemd service created and enabled."

    # Create the actual ai-dashboard command
    sudo tee /usr/local/bin/ai-dashboard > /dev/null << 'EOF'
#!/bin/bash
# ai-dashboard - Web dashboard controller
# Version 1.0

show_help() {
    cat << 'HELP'
ai-dashboard - Web Dashboard Controller

USAGE:
  ai-dashboard <command> [options]

COMMANDS:
  open             Open dashboard in browser
  start            Start dashboard service
  stop             Stop dashboard service
  status           Show dashboard status
  restart          Restart dashboard service

EXAMPLES:
  ai-dashboard open      # Open in browser
  ai-dashboard start     # Start service
  ai-dashboard status    # Check status

DASHBOARD URL: http://localhost:8081
HELP
}

case "${1:-open}" in
    open)
        echo "🌐 Opening AI Dashboard..."
        if ! systemctl --user is-active --quiet ai-dashboard.service; then
            echo "Dashboard service is not running. Starting it now..."
            systemctl --user start ai-dashboard.service
            sleep 1 # Give it a moment to start
        fi
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "http://localhost:8081"
        elif command -v open >/dev/null 2>&1; then
            open "http://localhost:8081"
        else
            echo "Please open this URL in your browser: http://localhost:8081"
        fi
        ;;
    start)
        echo "🚀 Starting AI Dashboard service..."
        systemctl --user start ai-dashboard.service
        ;;
    stop)
        echo "🛑 Stopping AI Dashboard service..."
        systemctl --user stop ai-dashboard.service
        ;;
    status)
        echo "📊 AI Dashboard Status"
        echo "====================="
        systemctl --user status ai-dashboard.service
        ;;
    restart)
        echo "🔄 Restarting AI Dashboard service..."
        systemctl --user restart ai-dashboard.service
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: ${1:-}"
        echo "Use 'ai-dashboard help' for available commands"
        exit 1
        ;;
esac
EOF
    sudo chmod +x /usr/local/bin/ai-dashboard
    log_success "ai-dashboard command created successfully."
}

# Function to create ai-backup command
create_ai_backup() {
    log_info "Creating ai-backup command..."
    sudo tee /usr/local/bin/ai-backup > /dev/null << 'EOF'
#!/bin/bash
# ai-backup - Backup and restore system
# Version 1.0

CONFIG_DIR="$HOME/.config/ai-parallel"
DATA_DIR="$HOME/.local/share/ai-parallel"
BACKUP_DIR="$DATA_DIR/backups"

show_help() {
    cat << 'HELP'
ai-backup - Backup and Restore System

USAGE:
  ai-backup <command> [options]

COMMANDS:
  create           Create new backup
  list             List available backups
  restore <name>   Restore from backup
  clean            Clean old backups (>30 days)

EXAMPLES:
  ai-backup create           # Create backup
  ai-backup list             # List backups
  ai-backup restore backup1  # Restore backup
HELP
}

create_backup() {
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="ai-backup-$timestamp"
    local backup_file="$BACKUP_DIR/$backup_name.tar.gz"

    echo "💾 Creating backup: $backup_name"
    mkdir -p "$BACKUP_DIR"

    tar -czf "$backup_file" \
        -C "$HOME" \
        ".config/ai-parallel" \
        ".local/share/ai-parallel" \
        2>/dev/null || true

    if [ -f "$backup_file" ]; then
        echo "✅ Backup created: $backup_file"
        echo "📊 Size: $(du -h "$backup_file" | cut -f1)"
    else
        echo "❌ Backup failed"
        exit 1
    fi
}

list_backups() {
    echo "📋 Available Backups"
    echo "==================="
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR"/*.tar.gz 2>/dev/null)" ]; then
        ls -lh "$BACKUP_DIR"/*.tar.gz | awk '{print $9 " (" $5 ", " $6 " " $7 " " $8 ")"}'
    else
        echo "No backups found"
    fi
}

restore_backup() {
    local backup_name="$1"
    local backup_file="$BACKUP_DIR/$backup_name.tar.gz"

    if [ ! -f "$backup_file" ]; then
        echo "❌ Backup not found: $backup_file"
        exit 1
    fi

    echo "🔄 Restoring backup: $backup_name"
    echo "⚠️ This will overwrite current configuration"
    read -p "Continue? (y/N): " -r confirm

    if [[ "$confirm" =~ ^[yY]$ ]]; then
        tar -xzf "$backup_file" -C "$HOME"
        echo "✅ Backup restored successfully"
    else
        echo "❌ Restore cancelled"
    fi
}

clean_backups() {
    echo "🧹 Cleaning old backups (>30 days)"
    if [ -d "$BACKUP_DIR" ]; then
        find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +30 -delete 2>/dev/null
        echo "✅ Old backups cleaned"
    else
        echo "No backup directory found"
    fi
}

case "${1:-help}" in
    create) create_backup ;;
    list) list_backups ;;
    restore)
        if [ -z "${2:-}" ]; then
            echo "Error: Backup name required" >&2
            exit 1
        fi
        restore_backup "$2"
        ;;
    clean) clean_backups ;;
    help|--help|-h) show_help ;;
    *)
        echo "Unknown command: ${1:-}" >&2
        show_help
        exit 1
        ;;
esac
EOF
    sudo chmod +x /usr/local/bin/ai-backup
    log_success "ai-backup command created"
}

# Main installation function
main() {
    echo
    log_header "🔧 AI Advanced Commands System - Installer"
    log_header "Version 1.0"
    echo

    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_error "This script should not be run as root. Please run without sudo."
        exit 1
    fi
    
    # Check for sudo availability
    if ! command -v sudo &> /dev/null; then
        log_error "sudo command not found. This script requires sudo to install system-wide commands."
        exit 1
    fi

    # Create advanced commands
    create_ai_quick
    create_ai_switch
    create_ai_logs
    create_ai_dashboard
    create_ai_backup

    echo
    log_success "=== ADVANCED COMMANDS INSTALLED ==="
    echo
    echo "🎉 Advanced AI commands installed successfully!"
    echo
    echo "📋 New commands available:"
    echo "  ✅ ai-quick      - Quick execution with Gemini (85% savings)"
    echo "  ✅ ai-switch     - Intelligent system selection"
    echo "  ✅ ai-logs       - Centralized logging viewer"
    echo "  ✅ ai-dashboard  - Web dashboard controller"
    echo "  ✅ ai-backup     - Backup and restore system"
    echo
    echo "🚀 Quick examples:"
    echo "  ai-quick                    # Quick execution"
    echo "  ai-switch cost-optimal      # Use most cost-effective"
    echo "  ai-logs live                # Watch logs"
    echo "  ai-dashboard open           # Open web dashboard"
    echo "  ai-backup create            # Create backup"
    echo
    echo "💡 Pro tips:"
    echo "  🏆 Use ai-quick for daily development (85% cost savings)"
    echo "  🧠 Use ai-switch reasoning for complex analysis"
    echo "  🔧 Use ai-switch code-focused for optimization"
    echo "  📊 Use ai-dashboard for monitoring and control"
    echo
    log_success "Advanced commands ready! Happy coding! 🤖"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi