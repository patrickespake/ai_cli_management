#!/bin/bash
# ai_advanced_commands.sh - Advanced AI Commands System
# Version 2.0 - English Edition (Fixed)
# Assumes existing CLI clients: codex, claude, gemini

set -euo pipefail

# Global variables
INSTALL_DIR="/opt/ai-parallel-systems"
CONFIG_DIR="$HOME/.config/ai-parallel"
DATA_DIR="$HOME/.local/share/ai-parallel"
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

    sudo tee /usr/local/bin/ai-quick << 'EOF'
#!/bin/bash
# ai-quick - Quick AI execution with Gemini (cost-optimized)
# Version 2.0 - English Edition

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

    sudo tee /usr/local/bin/ai-switch << 'EOF'
#!/bin/bash
# ai-switch - Intelligent AI system selection
# Version 2.0 - English Edition

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

    sudo tee /usr/local/bin/ai-logs << 'EOF'
#!/bin/bash
# ai-logs - Centralized logging viewer
# Version 2.0 - English Edition

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

    # Create dashboard directory
    sudo mkdir -p /opt/ai-parallel-systems/dashboard
    
    # Create package.json for dashboard dependencies
    sudo tee /opt/ai-parallel-systems/dashboard/package.json << 'EOF'
{
  "name": "ai-dashboard",
  "version": "1.0.0",
  "description": "Real-time dashboard for AI Parallel Systems",
  "main": "server.js",
  "dependencies": {
    "express": "^4.17.1",
    "socket.io": "^4.0.0"
  }
}
EOF

    # Create dashboard server file
    sudo tee /opt/ai-parallel-systems/dashboard/server.js << 'EOF'
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(express.json());
app.use(express.static(__dirname));

// API endpoint for scripts to post updates
app.post('/api/update', (req, res) => {
    const { taskId, status, title, pr_url, message } = req.body;
    io.emit('task_update', { taskId, status, title, pr_url, message });
    res.status(200).send({ message: 'Update received' });
});

io.on('connection', (socket) => {
    console.log('Dashboard client connected');
    socket.on('disconnect', () => {
        console.log('Dashboard client disconnected');
    });
});

const PORT = 8081;
server.listen(PORT, () => console.log(`Dashboard server listening on port ${PORT}`));
EOF

    # Create dashboard index.html
    sudo tee /opt/ai-parallel-systems/dashboard/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Parallel Systems Dashboard</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: #f0f2f5; color: #333; margin: 0; padding: 1rem; }
        header { display: flex; justify-content: space-between; align-items: center; padding: 1rem 2rem; background-color: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        h1 { font-size: 1.5rem; margin: 0; }
        #status-indicator { font-size: 1rem; font-weight: bold; }
        .status-connected { color: #28a745; }
        .status-disconnected { color: #dc3545; }
        #task-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1rem; margin-top: 1rem; }
        .task-card { background-color: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); padding: 1.5rem; transition: all 0.3s ease; }
        .task-card h3 { margin: 0 0 0.5rem; font-size: 1.1rem; }
        .task-card p { margin: 0.25rem 0; font-size: 0.9rem; color: #666; }
        .task-status { font-weight: bold; padding: 0.25rem 0.5rem; border-radius: 4px; display: inline-block; font-size: 0.8rem; }
        .status-running { background-color: #e6f7ff; color: #1890ff; }
        .status-completed { background-color: #f6ffed; color: #52c41a; }
        .status-failed { background-color: #fff1f0; color: #f5222d; }
        .status-pr_created { background-color: #f9f0ff; color: #722ed1; }
        .pr-link { display: block; margin-top: 1rem; font-weight: bold; }
    </style>
</head>
<body>
    <header>
        <h1>AI Parallel Systems Dashboard</h1>
        <div id="status-indicator">Connecting...</div>
    </header>
    <main>
        <div id="task-container"></div>
    </main>
    <script src="/socket.io/socket.io.js"></script>
    <script src="dashboard.js"></script>
</body>
</html>
EOF

    # Create dashboard client-side JS
    sudo tee /opt/ai-parallel-systems/dashboard/dashboard.js << 'EOF'
document.addEventListener('DOMContentLoaded', () => {
    const socket = io();
    const statusIndicator = document.getElementById('status-indicator');
    const taskContainer = document.getElementById('task-container');

    socket.on('connect', () => {
        statusIndicator.textContent = 'Connected';
        statusIndicator.className = 'status-connected';
    });

    socket.on('disconnect', () => {
        statusIndicator.textContent = 'Disconnected';
        statusIndicator.className = 'status-disconnected';
    });

    socket.on('task_update', (data) => {
        let card = document.getElementById(`task-${data.taskId}`);
        if (!card) {
            card = document.createElement('div');
            card.id = `task-${data.taskId}`;
            card.className = 'task-card';
            taskContainer.appendChild(card);
        }

        let statusHtml = `<span class="task-status status-${data.status.toLowerCase()}">${data.status}</span>`;
        let prLinkHtml = data.pr_url ? `<a href="${data.pr_url}" target="_blank" class="pr-link">View Pull Request</a>` : '';

        card.innerHTML = `
            <h3>${data.title || data.taskId}</h3>
            <p><strong>ID:</strong> ${data.taskId}</p>
            <p><strong>Status:</strong> ${statusHtml}</p>
            ${data.message ? `<p><strong>Info:</strong> ${data.message}</p>` : ''}
            ${prLinkHtml}
        `;
    });
});
EOF

    # Install dashboard dependencies
    log_info "Installing dashboard dependencies..."
    sudo npm install --prefix /opt/ai-parallel-systems/dashboard

    # Create systemd service file
    log_info "Creating systemd service for ai-dashboard..."
    sudo tee /etc/systemd/user/ai-dashboard.service << 'EOF'
[Unit]
Description=AI Parallel Systems Web Dashboard
After=network.target

[Service]
ExecStart=/usr/bin/node /opt/ai-parallel-systems/dashboard/server.js
Restart=always
WorkingDirectory=/opt/ai-parallel-systems/dashboard

[Install]
WantedBy=default.target
EOF

    # Enable the service
    systemctl --user enable ai-dashboard.service
    log_success "ai-dashboard systemd service created and enabled"

    sudo tee /usr/local/bin/ai-dashboard << 'EOF'
#!/bin/bash
# ai-dashboard - Web dashboard controller
# Version 2.0 - English Edition

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
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "http://localhost:8081"
        elif command -v open >/dev/null 2>&1; then
            open "http://localhost:8081"
        else
            echo "Dashboard URL: http://localhost:8081"
            echo "Please open this URL in your browser"
        fi
        ;;
    start)
        echo "🚀 Starting AI Dashboard service..."
        if systemctl --user is-active ai-dashboard >/dev/null 2>&1; then
            echo "✅ Dashboard is already running"
        else
            systemctl --user start ai-dashboard
        fi
        ;;
    stop)
        echo "🛑 Stopping AI Dashboard service..."
        systemctl --user stop ai-dashboard
        ;;
    status)
        echo "📊 AI Dashboard Status"
        echo "====================="
        if systemctl --user is-active ai-dashboard >/dev/null 2>&1; then
            echo "✅ Service: Running"
            echo "🌐 URL: http://localhost:8081"
        else
            echo "❌ Service: Not running"
        fi
        ;;
    restart)
        echo "🔄 Restarting AI Dashboard service..."
        systemctl --user restart ai-dashboard
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
    log_success "ai-dashboard command created"
}

# Function to create ai-backup command
create_ai_backup() {
    log_info "Creating ai-backup command..."

    sudo tee /usr/local/bin/ai-backup << 'EOF'
#!/bin/bash
# ai-backup - Backup and restore system
# Version 2.0 - English Edition

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
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="ai-backup-$timestamp"
    local backup_file="$BACKUP_DIR/$backup_name.tar.gz"

    echo "💾 Creating backup: $backup_name"

    # Create backup directory
    mkdir -p "$BACKUP_DIR"

    # Create backup
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
    echo -n "Continue? (y/N): "
    read -r confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
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
    create)
        create_backup
        ;;
    list)
        list_backups
        ;;
    restore)
        if [ -z "${2:-}" ]; then
            echo "Error: Backup name required"
            echo "Use: ai-backup list"
            exit 1
        fi
        restore_backup "$2"
        ;;
    clean)
        clean_backups
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: ${1:-}"
        echo "Use 'ai-backup help' for available commands"
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
    log_header "Version 2.0 - English Edition"
    echo

    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_error "Please do not run this script as root"
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
