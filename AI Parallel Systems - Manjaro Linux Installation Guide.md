# AI Parallel Systems - Manjaro Linux Installation Guide

**Version 2.0 - English Edition (Existing Clients)**
**Author:** Manus AI
**Target:** Manjaro Linux (Arch-based)
**Prerequisites:** codex, claude, and gemini CLI clients already installed

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites Verification](#prerequisites-verification)
3. [Quick Installation](#quick-installation)
4. [Detailed Installation Steps](#detailed-installation-steps)
5. [Manjaro-Specific Optimizations](#manjaro-specific-optimizations)
6. [Configuration and Setup](#configuration-and-setup)
7. [Usage Examples](#usage-examples)
8. [Performance Tuning](#performance-tuning)
9. [Troubleshooting](#troubleshooting)
10. [Maintenance and Updates](#maintenance-and-updates)

## Overview

This guide provides comprehensive instructions for installing the AI Parallel Systems on Manjaro Linux. The system assumes you already have the `codex`, `claude`, and `gemini` CLI clients installed and focuses on creating a unified management layer with global commands, web dashboard, and cost optimization features.

### Key Features

The AI Parallel Systems for Manjaro provides enterprise-grade functionality including professional web dashboard with real-time monitoring, cost analysis showing 85% savings with Gemini, unified command interface accessible from any directory, automatic worktree isolation preventing conflicts between AI agents, REST API for automation and integration, SQLite database for metrics and analytics, systemd service for automatic startup, and comprehensive logging and debugging tools.

### Architecture Overview

The system consists of three main components working together seamlessly. The Global Command Layer provides unified commands (`ai-claude`, `ai-codex`, `ai-gemini`) available system-wide, intelligent wrapper scripts that handle worktree creation and isolation, automatic detection and validation of existing CLI clients, and smart routing based on task requirements and cost optimization.

The Management Dashboard offers a professional web interface accessible at `http://localhost:8081`, real-time system monitoring and status updates, comprehensive cost analysis with savings calculations, live activity tracking and task management, quick action buttons for common operations, and REST API endpoints for automation and third-party integration.

The Backend Infrastructure includes SQLite database for persistent metrics storage, systemd service for reliable operation and auto-restart, comprehensive logging system with rotation and archival, automatic backup and recovery mechanisms, and security features including input validation and command sanitization.

## Prerequisites Verification

Before proceeding with the installation, verify that your Manjaro system meets all requirements and has the necessary CLI clients installed.

### System Requirements

Ensure your Manjaro system has the following specifications: Manjaro Linux (any recent version), minimum 4GB RAM (8GB recommended for optimal performance), 2GB free disk space for logs and databases, active internet connection for API calls and updates, sudo privileges for system-wide installation, and bash shell version 4.0 or higher.

### Verify Existing CLI Clients

The installation assumes you already have the AI CLI clients installed. Verify their presence and functionality using the following commands:

```bash
# Check Gemini CLI
which gemini && gemini --version

# Check Claude CLI
which claude && claude --version

# Check Codex CLI
which codex && codex --version
```

If any of these commands fail, you need to install the missing CLI clients before proceeding. The system will not install these clients automatically as it assumes they are already configured with your API keys and preferences.

### Manjaro-Specific Dependencies

Install the required system dependencies using Manjaro's package manager:

```bash
# Update system packages
sudo pacman -Syu

# Install essential dependencies
sudo pacman -S --needed base-devel git curl wget jq python python-pip sqlite3 tmux screen

# Install optional but recommended packages
sudo pacman -S --needed nodejs npm go rust

# Install AUR helper if not present (yay recommended)
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd .. && rm -rf yay
fi
```

### Python Environment Setup

Configure Python environment for the management dashboard:

```bash
# Install Python packages for dashboard
pip install --user flask flask-cors sqlite3 requests

# Verify Python installation
python --version
pip --version

# Check if packages are installed correctly
python -c "import flask, flask_cors, sqlite3, requests; print('All Python dependencies available')"
```

## Quick Installation

For users who want to get started immediately, use the automated installer:

```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer.sh | bash

# Or download first and inspect
wget https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer.sh
chmod +x ai_global_installer.sh
./ai_global_installer.sh
```

The quick installation will automatically detect your Manjaro system, verify existing CLI clients, install all necessary components, configure global commands, set up the web dashboard, create systemd services, and provide a summary of installed features.

## Detailed Installation Steps

For users who prefer manual installation or need to customize the setup, follow these detailed steps.

### Step 1: Download Installation Scripts

Create a working directory and download all necessary scripts:

```bash
# Create working directory
mkdir -p ~/ai-parallel-systems
cd ~/ai-parallel-systems

# Download main installer
wget https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer.sh

# Download advanced commands
wget https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_advanced_commands.sh

# Download management system
wget https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_unified_management.sh

# Make scripts executable
chmod +x *.sh
```

### Step 2: Run Global Installer

Execute the main installer with Manjaro-specific options:

```bash
# Run installer with verbose output
./ai_global_installer.sh --verbose --manjaro

# The installer will:
# - Detect Manjaro Linux automatically
# - Verify existing CLI clients
# - Create global command wrappers
# - Set up directory structure
# - Configure PATH variables
# - Install bash completion
```

### Step 3: Install Advanced Commands

Set up the advanced command system:

```bash
# Install advanced commands and utilities
./ai_advanced_commands.sh

# This creates additional commands:
# - ai-quick (rapid execution with Gemini)
# - ai-switch (intelligent system selection)
# - ai-costs (cost analysis and optimization)
# - ai-logs (centralized logging viewer)
# - ai-status (system health monitoring)
```

### Step 4: Deploy Management Dashboard

Install the web dashboard and API system:

```bash
# Deploy management system
./ai_unified_management.sh

# This creates:
# - Web dashboard at http://localhost:8081
# - REST API for automation
# - SQLite database for metrics
# - Systemd service for auto-start
```

### Step 5: Configure Systemd Services

Enable automatic startup of services:

```bash
# Enable and start the dashboard service
sudo systemctl enable ai-dashboard.service
sudo systemctl start ai-dashboard.service

# Verify service status
sudo systemctl status ai-dashboard.service

# Check if dashboard is accessible
curl -s http://localhost:8081/api/health
```

## Manjaro-Specific Optimizations

Manjaro Linux offers unique opportunities for optimization due to its Arch Linux foundation and rolling release model.

### AUR Package Integration

Leverage the Arch User Repository for additional tools:

```bash
# Install useful AUR packages for AI development
yay -S --needed \
    visual-studio-code-bin \
    postman-bin \
    insomnia \
    github-cli \
    docker-desktop

# Install development tools
yay -S --needed \
    nodejs-lts-hydrogen \
    python-poetry \
    go-tools \
    rust-analyzer
```

### Performance Optimizations

Configure Manjaro for optimal AI workload performance:

```bash
# Create performance optimization script
sudo tee /etc/systemd/system/ai-performance.service << 'EOF'
[Unit]
Description=AI Systems Performance Optimization
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ai-optimize-performance
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Create optimization script
sudo tee /usr/local/bin/ai-optimize-performance << 'EOF'
#!/bin/bash
# AI Performance Optimization for Manjaro

# Set CPU governor to performance for AI workloads
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Increase file descriptor limits
echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf

# Optimize network settings for API calls
echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem = 4096 87380 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem = 4096 65536 16777216' >> /etc/sysctl.conf

# Apply sysctl changes
sysctl -p
EOF

sudo chmod +x /usr/local/bin/ai-optimize-performance
sudo systemctl enable ai-performance.service
```

### Manjaro-Specific Configuration

Create Manjaro-optimized configuration files:

```bash
# Create Manjaro-specific config
mkdir -p ~/.config/ai-parallel
cat > ~/.config/ai-parallel/manjaro.conf << 'EOF'
# Manjaro-specific AI Parallel Systems Configuration

# Package manager integration
PACKAGE_MANAGER="pacman"
AUR_HELPER="yay"

# Performance settings
CPU_CORES=$(nproc)
MAX_PARALLEL_TASKS=$((CPU_CORES > 4 ? 5 : 3))
MEMORY_LIMIT="8G"

# Manjaro-specific paths
MANJARO_CACHE_DIR="/var/cache/pacman/pkg"
MANJARO_LOG_DIR="/var/log"

# Development tools integration
EDITOR="code"
TERMINAL="konsole"
BROWSER="firefox"

# AI system preferences (optimized for Manjaro)
DEFAULT_AI_SYSTEM="gemini"  # Most cost-effective
FALLBACK_AI_SYSTEM="claude"
SPECIALIZED_AI_SYSTEM="codex"

# Logging preferences
LOG_LEVEL="INFO"
LOG_ROTATION="daily"
LOG_RETENTION="30"

# Dashboard settings
DASHBOARD_THEME="dark"  # Matches Manjaro's dark theme
DASHBOARD_AUTO_REFRESH="30"
DASHBOARD_SHOW_SYSTEM_INFO="true"
EOF
```

## Configuration and Setup

After installation, configure the system for optimal performance and usability.

### API Key Configuration

Set up API keys for all three AI systems:

```bash
# Configure API keys securely
ai-manager config

# This will prompt for:
# - Gemini API key (Google AI Studio)
# - Claude API key (Anthropic)
# - Codex API key (OpenAI)

# Verify configuration
ai-manager verify-keys

# Test each system
ai-gemini --test
ai-claude --test
ai-codex --test
```

### Project Initialization

Set up your first AI-powered project:

```bash
# Navigate to your project directory
cd ~/my-project

# Initialize AI parallel systems
ai-manager init

# This creates:
# - tasks.json template
# - .ai-parallel/ directory
# - Configuration files
# - Git hooks (optional)

# Choose your preferred AI system
ai-manager set-default gemini  # Recommended for cost savings
```

### Shell Integration

Configure shell integration for enhanced productivity:

```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'source /opt/ai-parallel-systems/shell/completion.bash' >> ~/.bashrc

# Enable advanced aliases
echo 'source /opt/ai-parallel-systems/shell/aliases.bash' >> ~/.bashrc

# Reload shell configuration
source ~/.bashrc

# Verify integration
ai-<TAB><TAB>  # Should show all available commands
```

## Usage Examples

Explore practical examples of using the AI Parallel Systems on Manjaro.

### Basic Usage Patterns

Start with simple tasks to familiarize yourself with the system:

```bash
# Quick execution with Gemini (recommended)
cd my-project
ai-quick

# Use specific AI system
ai-gemini
ai-claude
ai-codex

# Interactive project setup
ai-init interactive

# Monitor system status
ai-status
ai-dashboard open
```

### Advanced Workflow Examples

Implement sophisticated development workflows:

```bash
# Full-stack development workflow
cd my-fullstack-app

# Create comprehensive tasks.json
ai-manager init fullstack

# Execute different components in parallel
ai-gemini --focus backend &
ai-claude --focus frontend &
ai-codex --focus optimization &

# Monitor progress
ai-logs live

# Generate consolidated report
ai-manager report
```

### Cost Optimization Strategies

Maximize cost savings while maintaining quality:

```bash
# Analyze current costs
ai-costs analyze

# Get optimization recommendations
ai-costs optimize

# Switch to most cost-effective system
ai-switch cost-optimal

# Set budget alerts
ai-costs set-budget 50  # $50 monthly limit

# Monitor savings
ai-costs savings-report
```

## Performance Tuning

Optimize the system for your specific Manjaro configuration and workload requirements.

### System Resource Optimization

Configure resource allocation for optimal performance:

```bash
# Create performance tuning script
cat > ~/.local/bin/ai-tune-performance << 'EOF'
#!/bin/bash
# AI Systems Performance Tuning for Manjaro

# Detect system capabilities
CPU_CORES=$(nproc)
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
AVAILABLE_STORAGE=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')

echo "🔧 Tuning AI Parallel Systems for Manjaro"
echo "CPU Cores: $CPU_CORES"
echo "Total RAM: ${TOTAL_RAM}GB"
echo "Available Storage: ${AVAILABLE_STORAGE}GB"

# Optimize based on system specs
if [ $CPU_CORES -ge 8 ] && [ $TOTAL_RAM -ge 16 ]; then
    echo "High-performance system detected"
    ai-manager config set max_parallel_tasks 8
    ai-manager config set memory_limit 12G
    ai-manager config set cache_size 2G
elif [ $CPU_CORES -ge 4 ] && [ $TOTAL_RAM -ge 8 ]; then
    echo "Standard system detected"
    ai-manager config set max_parallel_tasks 5
    ai-manager config set memory_limit 6G
    ai-manager config set cache_size 1G
else
    echo "Resource-constrained system detected"
    ai-manager config set max_parallel_tasks 3
    ai-manager config set memory_limit 4G
    ai-manager config set cache_size 512M
fi

# Configure storage optimization
if [ $AVAILABLE_STORAGE -lt 10 ]; then
    echo "⚠️ Low storage detected, enabling aggressive cleanup"
    ai-manager config set auto_cleanup true
    ai-manager config set log_retention 7
    ai-manager config set cache_cleanup_interval 1
fi

echo "✅ Performance tuning completed"
EOF

chmod +x ~/.local/bin/ai-tune-performance
ai-tune-performance
```

### Network Optimization

Optimize network settings for API performance:

```bash
# Create network optimization script
sudo tee /usr/local/bin/ai-optimize-network << 'EOF'
#!/bin/bash
# Network optimization for AI API calls

# Optimize TCP settings for API performance
echo 'net.ipv4.tcp_congestion_control = bbr' >> /etc/sysctl.conf
echo 'net.core.default_qdisc = fq' >> /etc/sysctl.conf

# Increase connection tracking table size
echo 'net.netfilter.nf_conntrack_max = 262144' >> /etc/sysctl.conf

# Optimize for high-frequency API calls
echo 'net.ipv4.ip_local_port_range = 1024 65535' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout = 30' >> /etc/sysctl.conf

# Apply changes
sysctl -p

echo "✅ Network optimization applied"
EOF

sudo chmod +x /usr/local/bin/ai-optimize-network
sudo /usr/local/bin/ai-optimize-network
```

## Troubleshooting

Common issues and their solutions specific to Manjaro Linux.

### Installation Issues

Resolve common installation problems:

**Issue: Package conflicts during installation**
```bash
# Solution: Update system and resolve conflicts
sudo pacman -Syu
sudo pacman -S --needed --overwrite '*' base-devel

# Clear package cache if needed
sudo pacman -Scc
```

**Issue: Python package installation fails**
```bash
# Solution: Use virtual environment
python -m venv ~/.local/share/ai-parallel/venv
source ~/.local/share/ai-parallel/venv/bin/activate
pip install flask flask-cors

# Update installer to use virtual environment
ai-manager config set python_venv ~/.local/share/ai-parallel/venv
```

**Issue: Systemd service fails to start**
```bash
# Solution: Check service logs and fix permissions
sudo journalctl -u ai-dashboard.service -f

# Fix common permission issues
sudo chown -R $USER:$USER ~/.local/share/ai-parallel
sudo chmod -R 755 /opt/ai-parallel-systems
```

### Runtime Issues

Address common runtime problems:

**Issue: AI commands not found after installation**
```bash
# Solution: Reload shell configuration
source ~/.bashrc
hash -r

# Verify PATH includes AI commands
echo $PATH | grep ai-parallel

# Manually add to PATH if needed
export PATH="/usr/local/bin:$PATH"
```

**Issue: Dashboard not accessible**
```bash
# Solution: Check service status and port availability
sudo systemctl status ai-dashboard.service
sudo netstat -tlnp | grep 8081

# Restart dashboard service
sudo systemctl restart ai-dashboard.service

# Check firewall settings
sudo ufw status
sudo ufw allow 8081/tcp
```

**Issue: High memory usage**
```bash
# Solution: Optimize memory settings
ai-manager config set memory_limit 4G
ai-manager config set max_parallel_tasks 3

# Enable memory monitoring
ai-manager monitor memory --alert-threshold 80
```

### Performance Issues

Optimize performance for better responsiveness:

**Issue: Slow API responses**
```bash
# Solution: Optimize network and caching
ai-manager config set cache_enabled true
ai-manager config set request_timeout 60
ai-manager config set retry_attempts 3

# Use regional API endpoints if available
ai-manager config set gemini_region us-central1
ai-manager config set claude_region us-west-2
```

**Issue: Frequent timeouts**
```bash
# Solution: Adjust timeout settings
ai-manager config set default_timeout 300
ai-manager config set long_task_timeout 1800

# Enable automatic retry with backoff
ai-manager config set auto_retry true
ai-manager config set retry_backoff exponential
```

## Maintenance and Updates

Keep your AI Parallel Systems installation current and optimized.

### Regular Maintenance Tasks

Perform these tasks regularly to maintain optimal performance:

```bash
# Create maintenance script
cat > ~/.local/bin/ai-maintenance << 'EOF'
#!/bin/bash
# AI Parallel Systems Maintenance Script for Manjaro

echo "🔧 Starting AI Parallel Systems maintenance..."

# Update system packages
echo "📦 Updating system packages..."
sudo pacman -Syu --noconfirm

# Update AUR packages
echo "📦 Updating AUR packages..."
yay -Syu --noconfirm

# Clean package cache
echo "🧹 Cleaning package cache..."
sudo pacman -Sc --noconfirm
yay -Sc --noconfirm

# Update AI system components
echo "🤖 Updating AI components..."
ai-manager update

# Clean logs and temporary files
echo "🧹 Cleaning logs and temporary files..."
ai-manager cleanup --logs --temp --cache

# Optimize database
echo "🗄️ Optimizing database..."
ai-manager database optimize

# Generate health report
echo "📊 Generating health report..."
ai-manager health-check --detailed

# Backup configuration
echo "💾 Backing up configuration..."
ai-manager backup --config --database

echo "✅ Maintenance completed successfully!"
EOF

chmod +x ~/.local/bin/ai-maintenance

# Schedule maintenance with cron
(crontab -l 2>/dev/null; echo "0 2 * * 0 ~/.local/bin/ai-maintenance") | crontab -
```

### Update Procedures

Keep the system updated with the latest features and security patches:

```bash
# Check for updates
ai-manager check-updates

# Update to latest version
ai-manager update --all

# Update specific components
ai-manager update --dashboard
ai-manager update --commands
ai-manager update --scripts

# Rollback if needed
ai-manager rollback --version 1.9.0
```

### Backup and Recovery

Implement comprehensive backup and recovery procedures:

```bash
# Create backup script
cat > ~/.local/bin/ai-backup << 'EOF'
#!/bin/bash
# AI Parallel Systems Backup Script

BACKUP_DIR="$HOME/.local/share/ai-parallel/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="ai-parallel-backup-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "💾 Creating backup: $BACKUP_FILE"

# Backup configuration, database, and logs
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    ~/.config/ai-parallel \
    ~/.local/share/ai-parallel/database \
    ~/.local/share/ai-parallel/logs \
    /opt/ai-parallel-systems

echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE"

# Keep only last 10 backups
cd "$BACKUP_DIR"
ls -t ai-parallel-backup-*.tar.gz | tail -n +11 | xargs -r rm

echo "🧹 Old backups cleaned up"
EOF

chmod +x ~/.local/bin/ai-backup

# Schedule daily backups
(crontab -l 2>/dev/null; echo "0 1 * * * ~/.local/bin/ai-backup") | crontab -
```

### Monitoring and Alerting

Set up monitoring to proactively identify issues:

```bash
# Create monitoring script
cat > ~/.local/bin/ai-monitor << 'EOF'
#!/bin/bash
# AI Parallel Systems Monitoring Script

# Check system health
HEALTH_STATUS=$(ai-manager health-check --json)
DASHBOARD_STATUS=$(curl -s http://localhost:8081/api/health)

# Check disk space
DISK_USAGE=$(df / | awk 'NR==2{print $5}' | sed 's/%//')

# Check memory usage
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')

# Check service status
SERVICE_STATUS=$(systemctl is-active ai-dashboard.service)

# Alert thresholds
DISK_THRESHOLD=85
MEMORY_THRESHOLD=90

# Send alerts if thresholds exceeded
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "⚠️ ALERT: Disk usage is ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    # Add notification command here (e.g., notify-send, email, etc.)
fi

if [ $MEMORY_USAGE -gt $MEMORY_THRESHOLD ]; then
    echo "⚠️ ALERT: Memory usage is ${MEMORY_USAGE}% (threshold: ${MEMORY_THRESHOLD}%)"
    # Add notification command here
fi

if [ "$SERVICE_STATUS" != "active" ]; then
    echo "⚠️ ALERT: AI Dashboard service is not active"
    # Attempt to restart service
    sudo systemctl restart ai-dashboard.service
fi

echo "✅ Monitoring check completed"
EOF

chmod +x ~/.local/bin/ai-monitor

# Schedule monitoring every 15 minutes
(crontab -l 2>/dev/null; echo "*/15 * * * * ~/.local/bin/ai-monitor") | crontab -
```

This comprehensive guide provides everything needed to successfully install, configure, and maintain the AI Parallel Systems on Manjaro Linux. The system leverages Manjaro's strengths while providing enterprise-grade AI development capabilities with significant cost savings through intelligent system selection and optimization.
