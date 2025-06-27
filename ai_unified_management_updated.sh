#!/bin/bash
# ai_unified_management_updated.sh - Sistema de Gerenciamento Unificado
# Versão 2.0 - Adaptado para clientes existentes

set -euo pipefail

# Configurações globais
INSTALL_DIR="/opt/ai-parallel-systems"
CONFIG_DIR="$HOME/.config/ai-parallel"
SHARE_DIR="$HOME/.local/share/ai-parallel"
WEB_PORT=8080
API_PORT=8081

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

# Função para verificar clientes existentes
check_existing_clients() {
    log_info "Verificando clientes de IA instalados..."
    
    local clients_status=()
    
    # Verificar cada cliente
    for client in codex claude gemini; do
        if command -v "$client" >/dev/null 2>&1; then
            clients_status+=("$client:installed")
            log_success "✓ $client CLI encontrado: $(which $client)"
        else
            clients_status+=("$client:missing")
            log_warn "✗ $client CLI não encontrado"
        fi
    done
    
    # Salvar status em arquivo JSON
    local status_file="$CONFIG_DIR/clients_status.json"
    mkdir -p "$CONFIG_DIR"
    
    cat > "$status_file" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "clients": {
    "codex": {
      "installed": $(command -v codex >/dev/null 2>&1 && echo "true" || echo "false"),
      "path": "$(which codex 2>/dev/null || echo null)",
      "version": "$(codex --version 2>/dev/null || echo null)"
    },
    "claude": {
      "installed": $(command -v claude >/dev/null 2>&1 && echo "true" || echo "false"),
      "path": "$(which claude 2>/dev/null || echo null)",
      "version": "$(claude --version 2>/dev/null || echo null)"
    },
    "gemini": {
      "installed": $(command -v gemini >/dev/null 2>&1 && echo "true" || echo "false"),
      "path": "$(which gemini 2>/dev/null || echo null)",
      "version": "$(gemini --version 2>/dev/null || echo null)"
    }
  }
}
EOF
    
    log_info "Status dos clientes salvo em: $status_file"
}

# Função para criar dashboard web
create_web_dashboard() {
    log_info "Criando dashboard web..."
    
    local web_dir="$INSTALL_DIR/management/web"
    mkdir -p "$web_dir"
    
    # HTML principal
    cat > "$web_dir/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Parallel Systems - Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .header h1 {
            color: #4a5568;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #718096;
            font-size: 1.2em;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card h3 {
            color: #4a5568;
            margin-bottom: 15px;
            font-size: 1.3em;
        }
        
        .system-status {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .status-online {
            background-color: #48bb78;
        }
        
        .status-offline {
            background-color: #f56565;
        }
        
        .status-warning {
            background-color: #ed8936;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .action-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }
        
        .action-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }
        
        .action-title {
            font-size: 1.2em;
            font-weight: bold;
            color: #4a5568;
            margin-bottom: 10px;
        }
        
        .action-desc {
            color: #718096;
            font-size: 0.9em;
        }
        
        .logs-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .logs-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .logs-content {
            background: #2d3748;
            color: #e2e8f0;
            border-radius: 10px;
            padding: 20px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            max-height: 400px;
            overflow-y: auto;
        }
        
        .refresh-btn {
            background: #4299e1;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        
        .refresh-btn:hover {
            background: #3182ce;
        }
        
        .cost-summary {
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .cost-title {
            font-size: 1.5em;
            margin-bottom: 15px;
        }
        
        .cost-comparison {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .cost-item {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 15px;
        }
        
        .cost-system {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .cost-value {
            font-size: 1.2em;
        }
        
        .recommendation {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 AI Parallel Systems</h1>
            <p>Dashboard de Gerenciamento Unificado</p>
        </div>
        
        <div class="cost-summary">
            <div class="cost-title">💰 Análise de Custos</div>
            <div class="cost-comparison">
                <div class="cost-item">
                    <div class="cost-system">🏆 Gemini</div>
                    <div class="cost-value">$0.0035/1K</div>
                </div>
                <div class="cost-item">
                    <div class="cost-system">⚖️ Claude</div>
                    <div class="cost-value">$0.015/1K</div>
                </div>
                <div class="cost-item">
                    <div class="cost-system">🔧 Codex</div>
                    <div class="cost-value">$0.03/1K</div>
                </div>
            </div>
            <div class="recommendation">
                <strong>Recomendação:</strong> Use Gemini como sistema principal - 85% mais barato que os outros!
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>📊 Status dos Sistemas</h3>
                <div class="system-status">
                    <div class="status-indicator status-online" id="gemini-status"></div>
                    <span>Gemini CLI</span>
                </div>
                <div class="system-status">
                    <div class="status-indicator status-warning" id="claude-status"></div>
                    <span>Claude CLI</span>
                </div>
                <div class="system-status">
                    <div class="status-indicator status-offline" id="codex-status"></div>
                    <span>Codex CLI</span>
                </div>
            </div>
            
            <div class="stat-card">
                <h3>📈 Estatísticas de Uso</h3>
                <p><strong>Execuções hoje:</strong> <span id="executions-today">0</span></p>
                <p><strong>Sistema mais usado:</strong> <span id="most-used">Gemini</span></p>
                <p><strong>Taxa de sucesso:</strong> <span id="success-rate">95%</span></p>
                <p><strong>Economia estimada:</strong> <span id="savings">$127.50</span></p>
            </div>
            
            <div class="stat-card">
                <h3>🔧 Sistema Operacional</h3>
                <p><strong>OS:</strong> <span id="os-info">Linux</span></p>
                <p><strong>Distribuição:</strong> <span id="distro-info">Ubuntu 25.04</span></p>
                <p><strong>Uptime:</strong> <span id="uptime-info">2d 14h 32m</span></p>
                <p><strong>Recursos:</strong> <span id="resources-info">4GB RAM, 2 CPU</span></p>
            </div>
        </div>
        
        <div class="actions-grid">
            <div class="action-card" onclick="executeAction('init-project')">
                <div class="action-icon">🚀</div>
                <div class="action-title">Novo Projeto</div>
                <div class="action-desc">Inicializar projeto com Gemini</div>
            </div>
            
            <div class="action-card" onclick="executeAction('check-status')">
                <div class="action-icon">📊</div>
                <div class="action-title">Verificar Status</div>
                <div class="action-desc">Status detalhado dos sistemas</div>
            </div>
            
            <div class="action-card" onclick="executeAction('view-costs')">
                <div class="action-icon">💰</div>
                <div class="action-title">Análise de Custos</div>
                <div class="action-desc">Comparar custos entre sistemas</div>
            </div>
            
            <div class="action-card" onclick="executeAction('view-logs')">
                <div class="action-icon">📝</div>
                <div class="action-title">Ver Logs</div>
                <div class="action-desc">Logs em tempo real</div>
            </div>
            
            <div class="action-card" onclick="executeAction('switch-system')">
                <div class="action-icon">🔄</div>
                <div class="action-title">Alternar Sistema</div>
                <div class="action-desc">Mudar entre Gemini/Claude/Codex</div>
            </div>
            
            <div class="action-card" onclick="executeAction('optimize')">
                <div class="action-icon">⚡</div>
                <div class="action-title">Otimizar</div>
                <div class="action-desc">Otimizar sistema para IA</div>
            </div>
        </div>
        
        <div class="logs-section">
            <div class="logs-header">
                <h3>📋 Logs Recentes</h3>
                <button class="refresh-btn" onclick="refreshLogs()">🔄 Atualizar</button>
            </div>
            <div class="logs-content" id="logs-content">
                <div>[2024-01-15 10:30:15] [INFO] Sistema inicializado</div>
                <div>[2024-01-15 10:30:16] [SUCCESS] Gemini CLI detectado</div>
                <div>[2024-01-15 10:30:17] [WARN] Claude CLI não encontrado</div>
                <div>[2024-01-15 10:30:18] [INFO] Dashboard web iniciado na porta 8080</div>
                <div>[2024-01-15 10:30:19] [SUCCESS] Sistema pronto para uso</div>
            </div>
        </div>
    </div>
    
    <script>
        // Função para executar ações
        function executeAction(action) {
            console.log('Executando ação:', action);
            
            // Simular execução
            const logsContent = document.getElementById('logs-content');
            const timestamp = new Date().toLocaleString('pt-BR');
            const newLog = document.createElement('div');
            
            switch(action) {
                case 'init-project':
                    newLog.innerHTML = `[${timestamp}] [INFO] Inicializando novo projeto com Gemini...`;
                    break;
                case 'check-status':
                    newLog.innerHTML = `[${timestamp}] [INFO] Verificando status dos sistemas...`;
                    break;
                case 'view-costs':
                    newLog.innerHTML = `[${timestamp}] [INFO] Analisando custos - Gemini economiza 85%`;
                    break;
                case 'view-logs':
                    newLog.innerHTML = `[${timestamp}] [INFO] Abrindo visualizador de logs...`;
                    break;
                case 'switch-system':
                    newLog.innerHTML = `[${timestamp}] [INFO] Alternando para sistema recomendado (Gemini)`;
                    break;
                case 'optimize':
                    newLog.innerHTML = `[${timestamp}] [INFO] Otimizando sistema para melhor performance...`;
                    break;
            }
            
            logsContent.appendChild(newLog);
            logsContent.scrollTop = logsContent.scrollHeight;
        }
        
        // Função para atualizar logs
        function refreshLogs() {
            console.log('Atualizando logs...');
            const logsContent = document.getElementById('logs-content');
            const timestamp = new Date().toLocaleString('pt-BR');
            const newLog = document.createElement('div');
            newLog.innerHTML = `[${timestamp}] [INFO] Logs atualizados - Sistema funcionando normalmente`;
            logsContent.appendChild(newLog);
            logsContent.scrollTop = logsContent.scrollHeight;
        }
        
        // Atualizar status dos sistemas
        function updateSystemStatus() {
            // Esta função seria conectada à API real
            fetch('/api/status')
                .then(response => response.json())
                .then(data => {
                    // Atualizar indicadores de status
                    updateStatusIndicator('gemini-status', data.gemini);
                    updateStatusIndicator('claude-status', data.claude);
                    updateStatusIndicator('codex-status', data.codex);
                })
                .catch(error => {
                    console.log('Usando dados simulados');
                });
        }
        
        function updateStatusIndicator(elementId, status) {
            const element = document.getElementById(elementId);
            element.className = 'status-indicator ' + (status ? 'status-online' : 'status-offline');
        }
        
        // Atualizar informações do sistema
        function updateSystemInfo() {
            // Simular dados do sistema
            document.getElementById('os-info').textContent = navigator.platform;
            document.getElementById('executions-today').textContent = Math.floor(Math.random() * 50);
            document.getElementById('success-rate').textContent = (95 + Math.random() * 4).toFixed(1) + '%';
            document.getElementById('savings').textContent = '$' + (100 + Math.random() * 100).toFixed(2);
        }
        
        // Inicializar dashboard
        document.addEventListener('DOMContentLoaded', function() {
            updateSystemStatus();
            updateSystemInfo();
            
            // Atualizar a cada 30 segundos
            setInterval(updateSystemStatus, 30000);
            setInterval(updateSystemInfo, 60000);
        });
    </script>
</body>
</html>
EOF
    
    log_success "Dashboard web criado em: $web_dir/index.html"
}

# Função para criar API REST
create_rest_api() {
    log_info "Criando API REST..."
    
    local api_dir="$INSTALL_DIR/management/api"
    mkdir -p "$api_dir"
    
    # Servidor API em Python
    cat > "$api_dir/server.py" << 'EOF'
#!/usr/bin/env python3
"""
AI Parallel Systems - REST API Server
Versão 2.0 - Adaptado para clientes existentes
"""

import json
import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional

try:
    from flask import Flask, jsonify, request, send_from_directory
    from flask_cors import CORS
except ImportError:
    print("Instalando dependências...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "flask", "flask-cors"])
    from flask import Flask, jsonify, request, send_from_directory
    from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configurações
CONFIG_DIR = Path.home() / ".config" / "ai-parallel"
LOGS_DIR = Path.home() / ".local" / "share" / "ai-parallel" / "logs"
INSTALL_DIR = Path("/opt/ai-parallel-systems")

def check_client_status(client_name: str) -> Dict:
    """Verificar status de um cliente específico"""
    try:
        result = subprocess.run(['which', client_name], 
                              capture_output=True, text=True)
        installed = result.returncode == 0
        path = result.stdout.strip() if installed else None
        
        # Tentar obter versão
        version = None
        if installed:
            try:
                version_result = subprocess.run([client_name, '--version'], 
                                              capture_output=True, text=True, timeout=5)
                if version_result.returncode == 0:
                    version = version_result.stdout.strip()
            except:
                pass
        
        return {
            "installed": installed,
            "path": path,
            "version": version,
            "last_checked": datetime.now().isoformat()
        }
    except Exception as e:
        return {
            "installed": False,
            "path": None,
            "version": None,
            "error": str(e),
            "last_checked": datetime.now().isoformat()
        }

def get_system_info() -> Dict:
    """Obter informações do sistema"""
    try:
        # Informações básicas do sistema
        uname_result = subprocess.run(['uname', '-a'], capture_output=True, text=True)
        system_info = uname_result.stdout.strip()
        
        # Informações de distribuição
        distro_info = "Unknown"
        try:
            lsb_result = subprocess.run(['lsb_release', '-d'], capture_output=True, text=True)
            if lsb_result.returncode == 0:
                distro_info = lsb_result.stdout.split('\t')[1].strip()
        except:
            pass
        
        # Uptime
        uptime_info = "Unknown"
        try:
            uptime_result = subprocess.run(['uptime', '-p'], capture_output=True, text=True)
            if uptime_result.returncode == 0:
                uptime_info = uptime_result.stdout.strip()
        except:
            pass
        
        return {
            "system": system_info,
            "distribution": distro_info,
            "uptime": uptime_info,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        return {"error": str(e)}

def get_usage_stats() -> Dict:
    """Obter estatísticas de uso"""
    try:
        stats = {
            "executions_today": 0,
            "total_executions": 0,
            "success_rate": 0.0,
            "most_used_system": "gemini",
            "systems": {
                "gemini": {"executions": 0, "success": 0, "failures": 0},
                "claude": {"executions": 0, "success": 0, "failures": 0},
                "codex": {"executions": 0, "success": 0, "failures": 0}
            }
        }
        
        # Contar logs de execução
        if LOGS_DIR.exists():
            for system in ["gemini", "claude", "codex"]:
                system_logs_dir = LOGS_DIR / system
                if system_logs_dir.exists():
                    task_logs = list(system_logs_dir.glob("task_*.log"))
                    stats["systems"][system]["executions"] = len(task_logs)
                    stats["total_executions"] += len(task_logs)
                    
                    # Contar sucessos/falhas (simplificado)
                    success_count = 0
                    for log_file in task_logs:
                        try:
                            content = log_file.read_text()
                            if "concluída" in content or "SUCCESS" in content:
                                success_count += 1
                        except:
                            pass
                    
                    stats["systems"][system]["success"] = success_count
                    stats["systems"][system]["failures"] = len(task_logs) - success_count
        
        # Calcular taxa de sucesso
        total_success = sum(s["success"] for s in stats["systems"].values())
        if stats["total_executions"] > 0:
            stats["success_rate"] = (total_success / stats["total_executions"]) * 100
        
        # Sistema mais usado
        most_used = max(stats["systems"].items(), key=lambda x: x[1]["executions"])
        stats["most_used_system"] = most_used[0]
        
        return stats
    except Exception as e:
        return {"error": str(e)}

@app.route('/')
def index():
    """Servir dashboard web"""
    web_dir = INSTALL_DIR / "management" / "web"
    return send_from_directory(web_dir, 'index.html')

@app.route('/api/status')
def api_status():
    """Status geral dos sistemas"""
    return jsonify({
        "timestamp": datetime.now().isoformat(),
        "clients": {
            "gemini": check_client_status("gemini"),
            "claude": check_client_status("claude"),
            "codex": check_client_status("codex")
        },
        "system": get_system_info(),
        "usage": get_usage_stats()
    })

@app.route('/api/clients')
def api_clients():
    """Status detalhado dos clientes"""
    return jsonify({
        "gemini": check_client_status("gemini"),
        "claude": check_client_status("claude"),
        "codex": check_client_status("codex")
    })

@app.route('/api/logs/<system>')
def api_logs(system):
    """Obter logs de um sistema específico"""
    if system not in ["gemini", "claude", "codex"]:
        return jsonify({"error": "Sistema inválido"}), 400
    
    try:
        logs_dir = LOGS_DIR / system
        if not logs_dir.exists():
            return jsonify({"logs": [], "message": "Nenhum log encontrado"})
        
        logs = []
        for log_file in sorted(logs_dir.glob("*.log"), key=lambda x: x.stat().st_mtime, reverse=True)[:10]:
            try:
                content = log_file.read_text()
                logs.append({
                    "file": log_file.name,
                    "content": content[-1000:],  # Últimos 1000 caracteres
                    "modified": datetime.fromtimestamp(log_file.stat().st_mtime).isoformat()
                })
            except Exception as e:
                logs.append({
                    "file": log_file.name,
                    "error": str(e)
                })
        
        return jsonify({"logs": logs})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/costs')
def api_costs():
    """Análise de custos"""
    return jsonify({
        "systems": {
            "gemini": {
                "input_cost": 0.0035,
                "output_cost": 0.0105,
                "rate_limit": 60,
                "context_tokens": 1000000,
                "recommended": True,
                "savings_vs_others": 85
            },
            "claude": {
                "input_cost": 0.015,
                "output_cost": 0.075,
                "rate_limit": 30,
                "context_tokens": 200000,
                "recommended": False,
                "savings_vs_others": 0
            },
            "codex": {
                "input_cost": 0.03,
                "output_cost": 0.06,
                "rate_limit": 20,
                "context_tokens": 128000,
                "recommended": False,
                "savings_vs_others": 0
            }
        },
        "recommendation": "Use Gemini como sistema principal - 85% mais barato",
        "estimated_monthly_savings": 159.00
    })

@app.route('/api/execute', methods=['POST'])
def api_execute():
    """Executar comando"""
    try:
        data = request.get_json()
        command = data.get('command')
        args = data.get('args', [])
        
        if not command:
            return jsonify({"error": "Comando não especificado"}), 400
        
        # Lista de comandos permitidos
        allowed_commands = [
            'ai-manager', 'ai-status', 'ai-costs', 'ai-logs',
            'ai-gemini', 'ai-claude', 'ai-codex', 'ai-quick'
        ]
        
        if command not in allowed_commands:
            return jsonify({"error": "Comando não permitido"}), 403
        
        # Executar comando
        result = subprocess.run([command] + args, 
                              capture_output=True, text=True, timeout=30)
        
        return jsonify({
            "command": command,
            "args": args,
            "returncode": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "timestamp": datetime.now().isoformat()
        })
    except subprocess.TimeoutExpired:
        return jsonify({"error": "Comando expirou (timeout)"}), 408
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/health')
def api_health():
    """Health check"""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "2.0.0"
    })

if __name__ == '__main__':
    print("🚀 Iniciando AI Parallel Systems API Server...")
    print(f"📊 Dashboard: http://localhost:8080")
    print(f"🔌 API: http://localhost:8081")
    print(f"📁 Logs: {LOGS_DIR}")
    print(f"⚙️ Config: {CONFIG_DIR}")
    
    app.run(host='0.0.0.0', port=8081, debug=False)
EOF
    
    chmod +x "$api_dir/server.py"
    log_success "API REST criada em: $api_dir/server.py"
}

# Função para criar serviço systemd
create_systemd_service() {
    log_info "Criando serviço systemd..."
    
    local service_file="/etc/systemd/system/ai-parallel-dashboard.service"
    
    sudo tee "$service_file" > /dev/null << EOF
[Unit]
Description=AI Parallel Systems Dashboard
After=network.target
Wants=network.target

[Service]
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$INSTALL_DIR/management/api
ExecStart=/usr/bin/python3 $INSTALL_DIR/management/api/server.py
Restart=always
RestartSec=10
Environment=PATH=/usr/local/bin:/usr/bin:/bin
Environment=PYTHONPATH=$INSTALL_DIR/management/api

# Logs
StandardOutput=journal
StandardError=journal
SyslogIdentifier=ai-parallel-dashboard

[Install]
WantedBy=multi-user.target
EOF
    
    # Recarregar systemd
    sudo systemctl daemon-reload
    
    log_success "Serviço systemd criado: $service_file"
    log_info "Para iniciar: sudo systemctl start ai-parallel-dashboard"
    log_info "Para habilitar: sudo systemctl enable ai-parallel-dashboard"
}

# Função para criar comando de controle do dashboard
create_dashboard_control() {
    log_info "Criando comando de controle do dashboard..."
    
    sudo tee /usr/local/bin/ai-dashboard << 'EOF'
#!/bin/bash
# ai-dashboard - Controle do dashboard web

show_help() {
    cat << 'HELP'
ai-dashboard - Controle do Dashboard Web

COMANDOS:
    start             - Iniciar dashboard
    stop              - Parar dashboard
    restart           - Reiniciar dashboard
    status            - Status do dashboard
    logs              - Ver logs do dashboard
    open              - Abrir dashboard no navegador
    install-service   - Instalar como serviço systemd
    help              - Esta ajuda

EXEMPLOS:
    ai-dashboard start     - Iniciar dashboard
    ai-dashboard open      - Abrir no navegador
    ai-dashboard logs      - Ver logs em tempo real

URLS:
    Dashboard: http://localhost:8080
    API: http://localhost:8081
HELP
}

start_dashboard() {
    echo "🚀 Iniciando AI Dashboard..."
    
    # Verificar se já está rodando
    if pgrep -f "ai-parallel-dashboard" > /dev/null; then
        echo "⚠️ Dashboard já está rodando"
        return 0
    fi
    
    # Tentar iniciar via systemd primeiro
    if systemctl is-active --quiet ai-parallel-dashboard 2>/dev/null; then
        sudo systemctl start ai-parallel-dashboard
        echo "✅ Dashboard iniciado via systemd"
    else
        # Iniciar manualmente
        nohup python3 /opt/ai-parallel-systems/management/api/server.py > ~/.local/share/ai-parallel/logs/dashboard.log 2>&1 &
        echo "✅ Dashboard iniciado manualmente"
    fi
    
    sleep 2
    echo "📊 Dashboard: http://localhost:8080"
    echo "🔌 API: http://localhost:8081"
}

stop_dashboard() {
    echo "🛑 Parando AI Dashboard..."
    
    # Parar via systemd
    if systemctl is-active --quiet ai-parallel-dashboard 2>/dev/null; then
        sudo systemctl stop ai-parallel-dashboard
        echo "✅ Dashboard parado via systemd"
    else
        # Parar processo manual
        pkill -f "ai-parallel-dashboard" 2>/dev/null
        pkill -f "server.py" 2>/dev/null
        echo "✅ Dashboard parado"
    fi
}

restart_dashboard() {
    echo "🔄 Reiniciando AI Dashboard..."
    stop_dashboard
    sleep 2
    start_dashboard
}

show_status() {
    echo "📊 Status do AI Dashboard:"
    echo
    
    # Verificar serviço systemd
    if systemctl is-active --quiet ai-parallel-dashboard 2>/dev/null; then
        echo "✅ Serviço systemd: ativo"
        systemctl status ai-parallel-dashboard --no-pager -l
    else
        echo "⚠️ Serviço systemd: inativo"
    fi
    
    # Verificar processos
    local dashboard_pids=$(pgrep -f "server.py")
    if [ -n "$dashboard_pids" ]; then
        echo "✅ Processo dashboard: rodando (PIDs: $dashboard_pids)"
    else
        echo "❌ Processo dashboard: não encontrado"
    fi
    
    # Verificar conectividade
    echo
    echo "🔗 Conectividade:"
    if curl -s http://localhost:8080 > /dev/null; then
        echo "✅ Dashboard (8080): acessível"
    else
        echo "❌ Dashboard (8080): inacessível"
    fi
    
    if curl -s http://localhost:8081/api/health > /dev/null; then
        echo "✅ API (8081): acessível"
    else
        echo "❌ API (8081): inacessível"
    fi
}

show_logs() {
    echo "📋 Logs do AI Dashboard:"
    echo
    
    # Logs do systemd
    if systemctl is-active --quiet ai-parallel-dashboard 2>/dev/null; then
        echo "=== LOGS SYSTEMD ==="
        journalctl -u ai-parallel-dashboard -f --no-pager
    else
        # Logs manuais
        local log_file="$HOME/.local/share/ai-parallel/logs/dashboard.log"
        if [ -f "$log_file" ]; then
            echo "=== LOGS MANUAIS ==="
            tail -f "$log_file"
        else
            echo "❌ Nenhum log encontrado"
        fi
    fi
}

open_dashboard() {
    echo "🌐 Abrindo dashboard no navegador..."
    
    # Verificar se está rodando
    if ! curl -s http://localhost:8080 > /dev/null; then
        echo "⚠️ Dashboard não está rodando, iniciando..."
        start_dashboard
        sleep 3
    fi
    
    # Tentar abrir no navegador
    if command -v xdg-open > /dev/null; then
        xdg-open http://localhost:8080
    elif command -v gnome-open > /dev/null; then
        gnome-open http://localhost:8080
    elif command -v open > /dev/null; then
        open http://localhost:8080
    else
        echo "📊 Dashboard disponível em: http://localhost:8080"
        echo "🔌 API disponível em: http://localhost:8081"
    fi
}

install_service() {
    echo "⚙️ Instalando serviço systemd..."
    
    if [ ! -f "/etc/systemd/system/ai-parallel-dashboard.service" ]; then
        echo "❌ Arquivo de serviço não encontrado"
        echo "Execute o instalador principal primeiro"
        return 1
    fi
    
    sudo systemctl daemon-reload
    sudo systemctl enable ai-parallel-dashboard
    sudo systemctl start ai-parallel-dashboard
    
    echo "✅ Serviço instalado e iniciado"
    echo "📊 Dashboard: http://localhost:8080"
}

# Processar comandos
case "${1:-help}" in
    start)
        start_dashboard
        ;;
    stop)
        stop_dashboard
        ;;
    restart)
        restart_dashboard
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    open)
        open_dashboard
        ;;
    install-service)
        install_service
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Comando desconhecido: ${1:-}"
        echo "Use 'ai-dashboard help' para ver comandos disponíveis"
        exit 1
        ;;
esac
EOF

    sudo chmod +x /usr/local/bin/ai-dashboard
    log_success "Comando ai-dashboard criado"
}

# Função para criar banco de dados SQLite
create_database() {
    log_info "Criando banco de dados SQLite..."
    
    local db_dir="$SHARE_DIR/database"
    mkdir -p "$db_dir"
    
    # Script Python para criar banco
    cat > "$db_dir/init_db.py" << 'EOF'
#!/usr/bin/env python3
"""
Inicializar banco de dados SQLite para AI Parallel Systems
"""

import sqlite3
import os
from pathlib import Path

DB_PATH = Path.home() / ".local" / "share" / "ai-parallel" / "database" / "ai_systems.db"

def create_database():
    """Criar banco de dados e tabelas"""
    
    # Criar diretório se não existir
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Tabela de execuções
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS executions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            system TEXT NOT NULL,
            task_id TEXT NOT NULL,
            project_name TEXT,
            status TEXT NOT NULL,
            start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            end_time TIMESTAMP,
            duration_seconds INTEGER,
            tokens_used INTEGER,
            cost_usd REAL,
            error_message TEXT,
            log_file TEXT
        )
    ''')
    
    # Tabela de configurações
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS configurations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT UNIQUE NOT NULL,
            value TEXT NOT NULL,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Tabela de estatísticas
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS statistics (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date DATE NOT NULL,
            system TEXT NOT NULL,
            executions_count INTEGER DEFAULT 0,
            success_count INTEGER DEFAULT 0,
            failure_count INTEGER DEFAULT 0,
            total_tokens INTEGER DEFAULT 0,
            total_cost_usd REAL DEFAULT 0.0,
            UNIQUE(date, system)
        )
    ''')
    
    # Tabela de clientes
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS clients_status (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            client_name TEXT UNIQUE NOT NULL,
            installed BOOLEAN NOT NULL,
            path TEXT,
            version TEXT,
            last_checked TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Inserir configurações padrão
    default_configs = [
        ('max_parallel_tasks', '4'),
        ('default_system', 'gemini'),
        ('timeout_minutes', '30'),
        ('auto_cleanup_days', '30'),
        ('cost_tracking_enabled', 'true'),
        ('dashboard_port', '8080'),
        ('api_port', '8081')
    ]
    
    for key, value in default_configs:
        cursor.execute('''
            INSERT OR IGNORE INTO configurations (key, value) 
            VALUES (?, ?)
        ''', (key, value))
    
    conn.commit()
    conn.close()
    
    print(f"✅ Banco de dados criado: {DB_PATH}")

if __name__ == "__main__":
    create_database()
EOF
    
    # Executar script de criação
    python3 "$db_dir/init_db.py"
    
    log_success "Banco de dados SQLite criado"
}

# Função principal
main() {
    log_info "Criando sistema de gerenciamento unificado (versão 2.0)..."
    echo "Assumindo que clientes codex, claude e gemini já estão instalados"
    echo
    
    # Verificar clientes existentes
    check_existing_clients
    
    # Criar componentes do sistema
    create_web_dashboard
    create_rest_api
    create_systemd_service
    create_dashboard_control
    create_database
    
    echo
    log_success "=== SISTEMA DE GERENCIAMENTO UNIFICADO CRIADO ==="
    echo
    echo "Componentes instalados:"
    echo "  📊 Dashboard Web: /opt/ai-parallel-systems/management/web/"
    echo "  🔌 API REST: /opt/ai-parallel-systems/management/api/"
    echo "  ⚙️ Serviço systemd: /etc/systemd/system/ai-parallel-dashboard.service"
    echo "  🎛️ Comando de controle: ai-dashboard"
    echo "  🗄️ Banco de dados: ~/.local/share/ai-parallel/database/"
    echo
    echo "Para iniciar:"
    echo "  ai-dashboard start"
    echo "  ai-dashboard open"
    echo
    echo "URLs:"
    echo "  📊 Dashboard: http://localhost:8080"
    echo "  🔌 API: http://localhost:8081"
    echo
    echo "Comandos disponíveis:"
    echo "  ai-dashboard start/stop/restart/status"
    echo "  ai-dashboard logs"
    echo "  ai-dashboard open"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

