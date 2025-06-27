# AI Parallel Systems - Ubuntu 25.04 Installation Guide

**Version 2.0 - English Edition (Existing Clients)**
**Author:** Manus AI
**Target:** Ubuntu 25.04 LTS (Debian-based)
**Prerequisites:** codex, claude, and gemini CLI clients already installed

## Table of Contents

1. [Overview](#overview)
2. [Ubuntu 25.04 Specific Features](#ubuntu-2504-specific-features)
3. [Prerequisites Verification](#prerequisites-verification)
4. [Quick Installation](#quick-installation)
5. [Detailed Installation Steps](#detailed-installation-steps)
6. [Ubuntu-Specific Optimizations](#ubuntu-specific-optimizations)
7. [Configuration and Setup](#configuration-and-setup)
8. [Usage Examples](#usage-examples)
9. [Performance Tuning](#performance-tuning)
10. [Troubleshooting](#troubleshooting)
11. [Maintenance and Updates](#maintenance-and-updates)

## Overview

This comprehensive guide provides detailed instructions for installing and configuring the AI Parallel Systems on Ubuntu 25.04 LTS. The system is designed to work seamlessly with Ubuntu's ecosystem while assuming you already have the `codex`, `claude`, and `gemini` CLI clients installed and configured.

### Key Features for Ubuntu 25.04

The AI Parallel Systems on Ubuntu 25.04 offers enterprise-grade functionality specifically optimized for Ubuntu's LTS stability and extensive package ecosystem. Key features include professional web dashboard with Ubuntu theme integration, cost analysis showing 85% savings with Gemini over other AI systems, unified command interface with APT package manager integration, automatic worktree isolation preventing conflicts between AI agents, REST API for automation with Ubuntu's enterprise tools, SQLite database optimized for Ubuntu's filesystem, systemd service with Ubuntu-specific optimizations, and comprehensive logging integrated with Ubuntu's syslog system.

### Architecture Overview

The system architecture is designed to leverage Ubuntu 25.04's strengths including stability, security, and extensive package ecosystem. The Global Command Layer provides unified commands available system-wide through Ubuntu's standard PATH mechanism, intelligent wrapper scripts that integrate with Ubuntu's package management, automatic detection and validation of existing CLI clients, and smart routing based on task requirements and cost optimization with Ubuntu-specific performance metrics.

The Management Dashboard offers a professional web interface that follows Ubuntu's design guidelines, real-time system monitoring integrated with Ubuntu's system tools, comprehensive cost analysis with detailed reporting, live activity tracking with Ubuntu's notification system, quick action buttons optimized for Ubuntu workflows, and REST API endpoints that integrate with Ubuntu's enterprise ecosystem.

The Backend Infrastructure includes SQLite database with Ubuntu-optimized performance settings, systemd service designed for Ubuntu's service management, comprehensive logging system integrated with journald, automatic backup and recovery using Ubuntu's standard tools, and security features leveraging Ubuntu's AppArmor and security frameworks.

## Ubuntu 25.04 Specific Features

Ubuntu 25.04 introduces several new features and improvements that enhance the AI Parallel Systems experience.

### New Ubuntu 25.04 Enhancements

Ubuntu 25.04 brings significant improvements that benefit AI development workflows. The updated kernel provides better resource management for AI workloads, improved container support enhances isolation between AI agents, enhanced security features provide better protection for API keys and sensitive data, updated Python ecosystem offers better performance for the management dashboard, improved systemd features provide more reliable service management, and enhanced networking stack offers better performance for API calls.

### Integration with Ubuntu Pro

For users with Ubuntu Pro subscriptions, additional enterprise features are available including extended security maintenance for all system components, compliance and auditing tools for enterprise environments, advanced monitoring and alerting capabilities, priority support for critical issues, and integration with Ubuntu's enterprise management tools.

### Snap Package Integration

Ubuntu 25.04's enhanced Snap support provides additional deployment options for the AI Parallel Systems including containerized deployment for enhanced security, automatic updates for system components, easy rollback capabilities for system maintenance, cross-distribution compatibility for hybrid environments, and simplified dependency management.

## Prerequisites Verification

Before proceeding with the installation, ensure your Ubuntu 25.04 system meets all requirements and has the necessary CLI clients installed.

### System Requirements

Verify your Ubuntu 25.04 system meets these specifications: Ubuntu 25.04 LTS (desktop or server edition), minimum 4GB RAM (8GB recommended for optimal performance), 3GB free disk space for system components and databases, active internet connection for API calls and package updates, sudo privileges for system-wide installation, and bash shell version 5.0 or higher (standard in Ubuntu 25.04).

### Verify Existing CLI Clients

The installation process assumes you already have the AI CLI clients installed and configured. Verify their presence and functionality:

```bash
# Check Gemini CLI installation and configuration
which gemini && gemini --version && gemini --test-connection

# Check Claude CLI installation and configuration
which claude && claude --version && claude --test-connection

# Check Codex CLI installation and configuration
which codex && codex --version && codex --test-connection
```

If any of these commands fail, you need to install and configure the missing CLI clients before proceeding. The system will not install these clients automatically as it assumes they are already configured with your API keys and organizational settings.

### Ubuntu 25.04 Dependencies

Install the required system dependencies using Ubuntu's package manager:

```bash
# Update package lists and upgrade system
sudo apt update && sudo apt upgrade -y

# Install essential build dependencies
sudo apt install -y build-essential git curl wget jq python3 python3-pip python3-venv sqlite3 tmux screen

# Install development tools and libraries
sudo apt install -y nodejs npm golang-go rustc cargo

# Install Ubuntu-specific tools
sudo apt install -y ubuntu-dev-tools ubuntu-advantage-tools

# Install optional but recommended packages
sudo apt install -y htop neofetch tree fd-find ripgrep bat exa

# Install snap packages for additional tools
sudo snap install code --classic
sudo snap install postman
sudo snap install discord
```

### Python Environment Setup

Configure Python environment optimized for Ubuntu 25.04:

```bash
# Create virtual environment for AI Parallel Systems
python3 -m venv ~/.local/share/ai-parallel/venv

# Activate virtual environment
source ~/.local/share/ai-parallel/venv/bin/activate

# Upgrade pip and install required packages
pip install --upgrade pip setuptools wheel

# Install dashboard dependencies
pip install flask flask-cors sqlite3 requests psutil

# Install additional Python tools
pip install black flake8 pytest mypy

# Verify Python installation
python --version
pip --version

# Test package imports
python -c "import flask, flask_cors, sqlite3, requests, psutil; print('All Python dependencies available')"

# Deactivate virtual environment
deactivate
```

## Quick Installation

For users who want to get started immediately, use the automated installer optimized for Ubuntu 25.04:

```bash
# Download and run the installer with Ubuntu-specific optimizations
curl -fsSL https://raw.githubusercontent.com/your-repo/ai-parallel-systems/main/ai_global_installer.sh | bash -s -- --ubuntu

# Alternative: Download first and inspect before running
wget https://raw.githubusercontent.com/your-repo/ai-parallel-systems/main/ai_global_installer.sh
chmod +x ai_global_installer.sh
./ai_global_installer.sh --ubuntu --verbose
```

The quick installation process will automatically detect Ubuntu 25.04 and apply appropriate optimizations, verify existing CLI clients and their configurations, install all necessary system components with Ubuntu-specific settings, configure global commands with proper PATH integration, set up the web dashboard with Ubuntu theme integration, create and enable systemd services optimized for Ubuntu, configure automatic updates using Ubuntu's package management, and provide a comprehensive summary of installed features and next steps.

## Detailed Installation Steps

For users who prefer manual installation or need to customize the setup for specific requirements, follow these detailed steps.

### Step 1: Prepare Installation Environment

Create a proper working environment for the installation:

```bash
# Create dedicated directory for AI Parallel Systems
mkdir -p ~/ai-parallel-systems-install
cd ~/ai-parallel-systems-install

# Set up logging for installation process
exec > >(tee -a install.log) 2>&1
echo "Starting AI Parallel Systems installation on Ubuntu 25.04 at $(date)"

# Download all installation scripts
wget https://raw.githubusercontent.com/your-repo/ai-parallel-systems/main/ai_global_installer.sh
wget https://raw.githubusercontent.com/your-repo/ai-parallel-systems/main/ai_advanced_commands.sh
wget https://raw.githubusercontent.com/your-repo/ai-parallel-systems/main/ai_unified_management.sh

# Verify script integrity (if checksums are provided)
# sha256sum -c checksums.txt

# Make all scripts executable
chmod +x *.sh

# Display system information for troubleshooting
echo "System Information:"
lsb_release -a
uname -a
free -h
df -h
```

### Step 2: Execute Global Installer

Run the main installer with Ubuntu-specific configurations:

```bash
# Execute installer with Ubuntu optimizations
./ai_global_installer.sh --ubuntu --detailed-logging

# The installer performs these actions:
# - Detects Ubuntu 25.04 automatically
# - Verifies system requirements and dependencies
# - Checks for existing CLI clients
# - Creates system-wide directory structure
# - Installs global command wrappers
# - Configures PATH and environment variables
# - Sets up bash and zsh completion
# - Creates initial configuration files
# - Integrates with Ubuntu's package management
```

### Step 3: Install Advanced Command System

Deploy the advanced command system with Ubuntu-specific enhancements:

```bash
# Install advanced commands with Ubuntu integration
./ai_advanced_commands.sh --ubuntu

# This creates these additional commands:
# - ai-quick: Rapid execution with Gemini (cost-optimized)
# - ai-switch: Intelligent system selection based on task type
# - ai-costs: Comprehensive cost analysis and optimization
# - ai-logs: Centralized logging viewer with Ubuntu integration
# - ai-status: System health monitoring with Ubuntu metrics
# - ai-ubuntu: Ubuntu-specific optimization and maintenance tools
```

### Step 4: Deploy Management Dashboard

Install the comprehensive web dashboard and API system:

```bash
# Deploy management system with Ubuntu optimizations
./ai_unified_management.sh --ubuntu

# This creates and configures:
# - Professional web dashboard at http://localhost:8081
# - REST API for automation and integration
# - SQLite database with Ubuntu-optimized settings
# - Systemd service with Ubuntu-specific configurations
# - Integration with Ubuntu's logging and monitoring systems
# - Security configurations using Ubuntu's security frameworks
```

### Step 5: Configure System Services

Set up and enable automatic startup of services:

```bash
# Enable and start the AI dashboard service
sudo systemctl enable ai-dashboard.service
sudo systemctl start ai-dashboard.service

# Verify service status and health
sudo systemctl status ai-dashboard.service
journalctl -u ai-dashboard.service -f --lines=20

# Test dashboard accessibility
curl -s http://localhost:8081/api/health | jq .

# Configure service for automatic restart on failure
sudo systemctl edit ai-dashboard.service << 'EOF'
[Service]
Restart=always
RestartSec=10
StartLimitInterval=60
StartLimitBurst=3
EOF

# Reload systemd configuration
sudo systemctl daemon-reload
```

### Step 6: Ubuntu-Specific Integration

Configure integration with Ubuntu's ecosystem:

```bash
# Install Ubuntu-specific integration script
sudo tee /usr/local/bin/ai-ubuntu << 'EOF'
#!/bin/bash
# Ubuntu-specific AI Parallel Systems integration

case "$1" in
    optimize)
        # Optimize system for AI workloads
        echo "Optimizing Ubuntu for AI workloads..."

        # Update package cache
        sudo apt update

        # Install performance tools
        sudo apt install -y linux-tools-common linux-tools-generic

        # Configure CPU governor
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

        # Optimize memory settings
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

        # Apply sysctl changes
        sudo sysctl -p

        echo "Ubuntu optimization completed"
        ;;

    update)
        # Update AI Parallel Systems using Ubuntu package management
        echo "Updating AI Parallel Systems..."

        # Update system packages
        sudo apt update && sudo apt upgrade -y

        # Update snap packages
        sudo snap refresh

        # Update AI system components
        ai-manager update --all

        echo "Update completed"
        ;;

    backup)
        # Create backup using Ubuntu's standard tools
        echo "Creating system backup..."

        BACKUP_DIR="/var/backups/ai-parallel"
        sudo mkdir -p "$BACKUP_DIR"

        # Backup configuration and data
        sudo tar -czf "$BACKUP_DIR/ai-parallel-$(date +%Y%m%d).tar.gz" \
            /opt/ai-parallel-systems \
            /etc/systemd/system/ai-dashboard.service \
            ~/.config/ai-parallel \
            ~/.local/share/ai-parallel

        echo "Backup created in $BACKUP_DIR"
        ;;

    *)
        echo "Usage: ai-ubuntu {optimize|update|backup}"
        exit 1
        ;;
esac
EOF

sudo chmod +x /usr/local/bin/ai-ubuntu

# Run initial optimization
ai-ubuntu optimize
```

## Ubuntu-Specific Optimizations

Ubuntu 25.04 offers unique opportunities for optimization due to its LTS stability and extensive package ecosystem.

### APT Package Integration

Leverage Ubuntu's package management for enhanced functionality:

```bash
# Install additional development tools from Ubuntu repositories
sudo apt install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Add third-party repositories for development tools
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists and install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Install additional development tools
sudo apt install -y \
    postgresql-client \
    redis-tools \
    mongodb-clients \
    mysql-client
```

### Performance Optimizations for Ubuntu 25.04

Configure Ubuntu-specific performance optimizations:

```bash
# Create Ubuntu-specific performance optimization script
sudo tee /etc/systemd/system/ai-performance-ubuntu.service << 'EOF'
[Unit]
Description=AI Systems Performance Optimization for Ubuntu 25.04
After=multi-user.target
Before=ai-dashboard.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ai-optimize-ubuntu
RemainAfterExit=yes
User=root

[Install]
WantedBy=multi-user.target
EOF

# Create the optimization script
sudo tee /usr/local/bin/ai-optimize-ubuntu << 'EOF'
#!/bin/bash
# AI Performance Optimization for Ubuntu 25.04

echo "Optimizing Ubuntu 25.04 for AI Parallel Systems..."

# Set CPU governor to performance for AI workloads
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
    echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    echo "CPU governor set to performance"
fi

# Optimize memory management
echo 'vm.swappiness=10' >> /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
echo 'vm.dirty_ratio=15' >> /etc/sysctl.conf
echo 'vm.dirty_background_ratio=5' >> /etc/sysctl.conf

# Optimize network settings for API calls
echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem = 4096 87380 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem = 4096 65536 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control = bbr' >> /etc/sysctl.conf

# Increase file descriptor limits
echo '* soft nofile 65536' >> /etc/security/limits.conf
echo '* hard nofile 65536' >> /etc/security/limits.conf
echo 'root soft nofile 65536' >> /etc/security/limits.conf
echo 'root hard nofile 65536' >> /etc/security/limits.conf

# Optimize for SSD if present
if lsblk -d -o name,rota | grep -q "0$"; then
    echo 'echo noop > /sys/block/*/queue/scheduler' >> /etc/rc.local
    echo "SSD optimization enabled"
fi

# Apply sysctl changes
sysctl -p

# Configure systemd for better performance
mkdir -p /etc/systemd/system.conf.d
cat > /etc/systemd/system.conf.d/ai-optimization.conf << 'SYSTEMD_EOF'
[Manager]
DefaultTimeoutStopSec=30s
DefaultTimeoutStartSec=30s
DefaultRestartSec=5s
SYSTEMD_EOF

echo "Ubuntu optimization completed successfully"
EOF

sudo chmod +x /usr/local/bin/ai-optimize-ubuntu
sudo systemctl enable ai-performance-ubuntu.service
sudo systemctl start ai-performance-ubuntu.service
```

### Ubuntu Security Integration

Integrate with Ubuntu's security frameworks:

```bash
# Configure AppArmor profile for AI dashboard
sudo tee /etc/apparmor.d/ai-dashboard << 'EOF'
#include <tunables/global>

/usr/bin/python3 {
  #include <abstractions/base>
  #include <abstractions/python>
  #include <abstractions/nameservice>

  # Allow network access for API calls
  network inet stream,
  network inet6 stream,

  # Allow access to AI Parallel Systems directories
  /opt/ai-parallel-systems/** r,
  /home/*/.config/ai-parallel/** rw,
  /home/*/.local/share/ai-parallel/** rw,

  # Allow access to system information
  /proc/meminfo r,
  /proc/cpuinfo r,
  /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor r,

  # Allow temporary file creation
  /tmp/** rw,

  # Allow log file access
  /var/log/ai-parallel/** rw,
}
EOF

# Load AppArmor profile
sudo apparmor_parser -r /etc/apparmor.d/ai-dashboard

# Configure UFW firewall rules
sudo ufw allow 8081/tcp comment 'AI Dashboard'
sudo ufw reload
```

## Configuration and Setup

After installation, configure the system for optimal performance and integration with Ubuntu's ecosystem.

### API Key Configuration

Set up API keys securely using Ubuntu's credential management:

```bash
# Configure API keys with Ubuntu's keyring integration
ai-manager config --secure

# This will:
# - Prompt for Gemini API key (Google AI Studio)
# - Prompt for Claude API key (Anthropic)
# - Prompt for Codex API key (OpenAI)
# - Store keys securely using Ubuntu's keyring
# - Set up automatic key rotation if supported

# Verify configuration
ai-manager verify-keys --verbose

# Test each system with connection verification
ai-gemini --test --verbose
ai-claude --test --verbose
ai-codex --test --verbose

# Configure default preferences
ai-manager config set default_system gemini  # Most cost-effective
ai-manager config set fallback_system claude
ai-manager config set specialized_system codex
```

### Project Initialization

Set up your first AI-powered project with Ubuntu integration:

```bash
# Navigate to your project directory
cd ~/my-ubuntu-project

# Initialize AI parallel systems with Ubuntu-specific settings
ai-manager init --ubuntu

# This creates:
# - tasks.json template with Ubuntu-optimized settings
# - .ai-parallel/ directory with Ubuntu-specific configurations
# - Integration with Ubuntu's development tools
# - Git hooks for automated AI assistance (optional)
# - VS Code workspace settings for Ubuntu

# Configure project-specific settings
ai-manager config set project_type web_application
ai-manager config set target_platform ubuntu
ai-manager config set optimization_level production

# Set up development environment integration
ai-manager integrate --vscode --git --docker
```

### Shell Integration and Customization

Configure comprehensive shell integration for Ubuntu:

```bash
# Add to ~/.bashrc for Bash users
cat >> ~/.bashrc << 'EOF'
# AI Parallel Systems integration
source /opt/ai-parallel-systems/shell/completion.bash
source /opt/ai-parallel-systems/shell/aliases.bash

# Ubuntu-specific AI aliases
alias ai='ai-quick'
alias aic='ai-claude'
alias aig='ai-gemini'
alias aix='ai-codex'
alias ais='ai-status'
alias aid='ai-dashboard open'
alias aiu='ai-ubuntu'

# AI project shortcuts
alias ai-init='ai-manager init'
alias ai-run='ai-quick'
alias ai-cost='ai-costs analyze'
alias ai-log='ai-logs live'

# Ubuntu development shortcuts
alias ai-dev='ai-manager dev-mode'
alias ai-prod='ai-manager prod-mode'
alias ai-test='ai-manager test-suite'
EOF

# Add to ~/.zshrc for Zsh users (if using Zsh)
if [ -f ~/.zshrc ]; then
    cat >> ~/.zshrc << 'EOF'
# AI Parallel Systems integration for Zsh
source /opt/ai-parallel-systems/shell/completion.zsh
source /opt/ai-parallel-systems/shell/aliases.zsh

# Enable advanced completion
autoload -U compinit && compinit
EOF
fi

# Reload shell configuration
source ~/.bashrc

# Verify integration
ai-<TAB><TAB>  # Should show all available commands
```

## Usage Examples

Explore practical examples of using the AI Parallel Systems on Ubuntu 25.04.

### Basic Usage Patterns

Start with fundamental usage patterns to familiarize yourself with the system:

```bash
# Quick execution with Gemini (most cost-effective)
cd my-project
ai-quick

# Use specific AI system based on task requirements
ai-gemini    # Best for general tasks, 85% cost savings
ai-claude    # Best for complex reasoning and analysis
ai-codex     # Best for code optimization and debugging

# Interactive project setup with Ubuntu integration
ai-init interactive --ubuntu

# Monitor system status and performance
ai-status --detailed
ai-dashboard open
ai-ubuntu optimize
```

### Advanced Development Workflows

Implement sophisticated development workflows optimized for Ubuntu:

```bash
# Full-stack web application development
cd my-fullstack-app

# Create comprehensive tasks.json for Ubuntu environment
ai-manager init fullstack --ubuntu --docker

# Execute different components in parallel with Ubuntu optimizations
ai-gemini --focus backend --ubuntu-optimized &
ai-claude --focus frontend --responsive-design &
ai-codex --focus performance --ubuntu-native &

# Monitor progress with Ubuntu system integration
ai-logs live --ubuntu-format
ai-status --system-metrics

# Generate consolidated development report
ai-manager report --ubuntu --include-metrics
```

### Cost Optimization and Analysis

Maximize cost savings while maintaining development quality:

```bash
# Comprehensive cost analysis with Ubuntu-specific metrics
ai-costs analyze --detailed --ubuntu

# Get optimization recommendations based on Ubuntu usage patterns
ai-costs optimize --ubuntu-specific

# Switch to most cost-effective system automatically
ai-switch cost-optimal --prefer-gemini

# Set up budget monitoring with Ubuntu notifications
ai-costs set-budget 75 --currency USD --notify-ubuntu

# Generate monthly savings report
ai-costs savings-report --monthly --export-csv
```

### Ubuntu-Specific Integration Examples

Leverage Ubuntu's ecosystem for enhanced AI development:

```bash
# Integrate with Ubuntu's package management
ai-manager integrate --apt --snap

# Use Ubuntu's development tools with AI assistance
ai-codex --integrate-vscode --ubuntu-extensions
ai-claude --integrate-docker --ubuntu-containers

# Leverage Ubuntu Pro features (if available)
ai-manager ubuntu-pro --enable-features
ai-costs ubuntu-pro --compliance-reporting

# Integration with Ubuntu's cloud services
ai-manager cloud --ubuntu-cloud --auto-deploy
```

## Performance Tuning

Optimize the system specifically for Ubuntu 25.04's architecture and capabilities.

### System Resource Optimization

Configure resource allocation optimized for Ubuntu's resource management:

```bash
# Create comprehensive performance tuning script for Ubuntu
cat > ~/.local/bin/ai-tune-ubuntu << 'EOF'
#!/bin/bash
# AI Systems Performance Tuning for Ubuntu 25.04

echo "🔧 Tuning AI Parallel Systems for Ubuntu 25.04"

# Detect system capabilities using Ubuntu tools
CPU_CORES=$(nproc)
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
AVAILABLE_STORAGE=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
UBUNTU_VERSION=$(lsb_release -rs)

echo "System Information:"
echo "  Ubuntu Version: $UBUNTU_VERSION"
echo "  CPU Cores: $CPU_CORES"
echo "  Total RAM: ${TOTAL_RAM}GB"
echo "  Available Storage: ${AVAILABLE_STORAGE}GB"

# Optimize based on system specifications
if [ $CPU_CORES -ge 8 ] && [ $TOTAL_RAM -ge 16 ]; then
    echo "High-performance Ubuntu system detected"
    ai-manager config set max_parallel_tasks 8
    ai-manager config set memory_limit 12G
    ai-manager config set cache_size 2G
    ai-manager config set ubuntu_performance_mode high
elif [ $CPU_CORES -ge 4 ] && [ $TOTAL_RAM -ge 8 ]; then
    echo "Standard Ubuntu system detected"
    ai-manager config set max_parallel_tasks 5
    ai-manager config set memory_limit 6G
    ai-manager config set cache_size 1G
    ai-manager config set ubuntu_performance_mode standard
else
    echo "Resource-constrained Ubuntu system detected"
    ai-manager config set max_parallel_tasks 3
    ai-manager config set memory_limit 4G
    ai-manager config set cache_size 512M
    ai-manager config set ubuntu_performance_mode conservative
fi

# Configure Ubuntu-specific optimizations
if [ $AVAILABLE_STORAGE -lt 10 ]; then
    echo "⚠️ Low storage detected, enabling Ubuntu storage optimization"
    ai-manager config set auto_cleanup true
    ai-manager config set log_retention 7
    ai-manager config set cache_cleanup_interval 1
    ai-manager config set ubuntu_storage_optimization true
fi

# Enable Ubuntu-specific features
ai-manager config set ubuntu_integration true
ai-manager config set systemd_integration true
ai-manager config set apparmor_integration true

# Configure for Ubuntu LTS stability
ai-manager config set stability_mode lts
ai-manager config set update_channel stable

echo "✅ Ubuntu performance tuning completed"
EOF

chmod +x ~/.local/bin/ai-tune-ubuntu
ai-tune-ubuntu
```

### Network and API Optimization

Optimize network settings specifically for Ubuntu's networking stack:

```bash
# Create Ubuntu-specific network optimization script
sudo tee /usr/local/bin/ai-optimize-network-ubuntu << 'EOF'
#!/bin/bash
# Network optimization for AI API calls on Ubuntu 25.04

echo "Optimizing network settings for Ubuntu 25.04..."

# Ubuntu-specific TCP optimizations
echo 'net.ipv4.tcp_congestion_control = bbr' >> /etc/sysctl.conf
echo 'net.core.default_qdisc = fq' >> /etc/sysctl.conf

# Optimize for Ubuntu's networking stack
echo 'net.core.netdev_max_backlog = 5000' >> /etc/sysctl.conf
echo 'net.core.netdev_budget = 600' >> /etc/sysctl.conf

# Increase connection tracking for high-frequency API calls
echo 'net.netfilter.nf_conntrack_max = 262144' >> /etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_established = 1200' >> /etc/sysctl.conf

# Optimize port range for API connections
echo 'net.ipv4.ip_local_port_range = 1024 65535' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout = 30' >> /etc/sysctl.conf

# Ubuntu-specific DNS optimizations
echo 'net.ipv4.tcp_keepalive_time = 120' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_intvl = 30' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_probes = 3' >> /etc/sysctl.conf

# Apply changes
sysctl -p

# Configure systemd-resolved for better DNS performance
mkdir -p /etc/systemd/resolved.conf.d
cat > /etc/systemd/resolved.conf.d/ai-optimization.conf << 'RESOLVED_EOF'
[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=8.8.4.4 1.0.0.1
Cache=yes
DNSStubListener=yes
RESOLVED_EOF

systemctl restart systemd-resolved

echo "✅ Ubuntu network optimization completed"
EOF

sudo chmod +x /usr/local/bin/ai-optimize-network-ubuntu
sudo /usr/local/bin/ai-optimize-network-ubuntu
```

## Troubleshooting

Common issues and their solutions specific to Ubuntu 25.04.

### Installation and Setup Issues

Resolve common installation problems specific to Ubuntu:

**Issue: Package dependency conflicts during installation**
```bash
# Solution: Resolve APT conflicts and update package database
sudo apt update --fix-missing
sudo apt install -f
sudo dpkg --configure -a

# Clear APT cache if needed
sudo apt clean
sudo apt autoclean

# Force package reconfiguration if necessary
sudo dpkg-reconfigure -a
```

**Issue: Python virtual environment creation fails**
```bash
# Solution: Reinstall Python and virtual environment tools
sudo apt install --reinstall python3 python3-venv python3-pip

# Create virtual environment with specific Python version
python3.11 -m venv ~/.local/share/ai-parallel/venv

# Activate and upgrade pip
source ~/.local/share/ai-parallel/venv/bin/activate
pip install --upgrade pip setuptools wheel

# Install requirements with verbose output
pip install -v flask flask-cors
```

**Issue: Systemd service fails to start on Ubuntu**
```bash
# Solution: Check service configuration and dependencies
sudo systemctl status ai-dashboard.service -l
sudo journalctl -u ai-dashboard.service --no-pager

# Verify service file syntax
sudo systemd-analyze verify /etc/systemd/system/ai-dashboard.service

# Fix common permission issues
sudo chown -R $USER:$USER ~/.local/share/ai-parallel
sudo chmod -R 755 /opt/ai-parallel-systems

# Reload systemd and restart service
sudo systemctl daemon-reload
sudo systemctl restart ai-dashboard.service
```

### Runtime and Performance Issues

Address common runtime problems on Ubuntu:

**Issue: AI commands not found after installation**
```bash
# Solution: Fix PATH configuration and shell integration
echo $PATH | grep -q "/usr/local/bin" || echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc

# Reload shell configuration
source ~/.bashrc
hash -r

# Verify command installation
which ai-gemini ai-claude ai-codex

# Reinstall commands if necessary
sudo /opt/ai-parallel-systems/install/reinstall-commands.sh
```

**Issue: Dashboard not accessible on Ubuntu**
```bash
# Solution: Check firewall, networking, and service status
sudo systemctl status ai-dashboard.service
sudo netstat -tlnp | grep 8081

# Check UFW firewall status
sudo ufw status
sudo ufw allow 8081/tcp

# Verify localhost resolution
ping -c 1 localhost
curl -v http://localhost:8081/api/health

# Check for port conflicts
sudo lsof -i :8081
```

**Issue: High memory usage on Ubuntu**
```bash
# Solution: Optimize memory settings for Ubuntu
ai-manager config set memory_limit 4G
ai-manager config set max_parallel_tasks 3
ai-manager config set ubuntu_memory_optimization true

# Enable Ubuntu's memory management features
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Monitor memory usage
ai-manager monitor memory --ubuntu-metrics
```

### Ubuntu-Specific Issues

Handle issues specific to Ubuntu's ecosystem:

**Issue: AppArmor blocking AI dashboard**
```bash
# Solution: Configure AppArmor profile correctly
sudo aa-status | grep ai-dashboard

# Put profile in complain mode for debugging
sudo aa-complain /etc/apparmor.d/ai-dashboard

# Check AppArmor logs
sudo dmesg | grep -i apparmor
sudo journalctl | grep -i apparmor

# Fix profile and reload
sudo apparmor_parser -r /etc/apparmor.d/ai-dashboard
```

**Issue: Snap package conflicts**
```bash
# Solution: Manage snap package conflicts
snap list | grep -E "(code|python|node)"

# Remove conflicting snaps if necessary
sudo snap remove --purge conflicting-package

# Install required snaps
sudo snap install code --classic
sudo snap install node --classic
```

## Maintenance and Updates

Keep your AI Parallel Systems installation current and optimized on Ubuntu 25.04.

### Regular Maintenance Tasks

Perform these Ubuntu-specific maintenance tasks regularly:

```bash
# Create comprehensive maintenance script for Ubuntu
cat > ~/.local/bin/ai-maintenance-ubuntu << 'EOF'
#!/bin/bash
# AI Parallel Systems Maintenance Script for Ubuntu 25.04

echo "🔧 Starting AI Parallel Systems maintenance on Ubuntu 25.04..."

# Update system packages using APT
echo "📦 Updating Ubuntu packages..."
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean

# Update snap packages
echo "📦 Updating snap packages..."
sudo snap refresh

# Update AI system components
echo "🤖 Updating AI components..."
ai-manager update --all --ubuntu

# Clean logs and temporary files
echo "🧹 Cleaning logs and temporary files..."
ai-manager cleanup --logs --temp --cache --ubuntu

# Optimize Ubuntu-specific components
echo "⚡ Optimizing Ubuntu components..."
ai-ubuntu optimize

# Optimize database with Ubuntu-specific settings
echo "🗄️ Optimizing database..."
ai-manager database optimize --ubuntu

# Generate comprehensive health report
echo "📊 Generating health report..."
ai-manager health-check --detailed --ubuntu

# Backup configuration and data
echo "💾 Backing up configuration..."
ai-manager backup --config --database --ubuntu

# Check for Ubuntu security updates
echo "🔒 Checking security updates..."
sudo unattended-upgrades --dry-run

# Verify system integrity
echo "🔍 Verifying system integrity..."
ai-manager verify --ubuntu --comprehensive

echo "✅ Ubuntu maintenance completed successfully!"
EOF

chmod +x ~/.local/bin/ai-maintenance-ubuntu

# Schedule maintenance with cron (Ubuntu-specific timing)
(crontab -l 2>/dev/null; echo "0 3 * * 1 ~/.local/bin/ai-maintenance-ubuntu") | crontab -
```

### Update Procedures for Ubuntu

Keep the system updated using Ubuntu's package management:

```bash
# Check for updates using Ubuntu-specific methods
ai-manager check-updates --ubuntu
sudo apt list --upgradable | grep ai-parallel

# Update to latest version with Ubuntu integration
ai-manager update --all --ubuntu --backup-first

# Update specific components
ai-manager update --dashboard --ubuntu
ai-manager update --commands --ubuntu
ai-manager update --scripts --ubuntu

# Handle Ubuntu LTS upgrades
ai-manager prepare-ubuntu-upgrade
sudo do-release-upgrade -d

# Post-upgrade verification
ai-manager verify-ubuntu-upgrade
```

### Backup and Recovery for Ubuntu

Implement comprehensive backup and recovery using Ubuntu's tools:

```bash
# Create Ubuntu-specific backup script
cat > ~/.local/bin/ai-backup-ubuntu << 'EOF'
#!/bin/bash
# AI Parallel Systems Backup Script for Ubuntu 25.04

BACKUP_DIR="/var/backups/ai-parallel"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="ai-parallel-ubuntu-backup-$TIMESTAMP.tar.gz"

# Ensure backup directory exists
sudo mkdir -p "$BACKUP_DIR"

echo "💾 Creating Ubuntu-specific backup: $BACKUP_FILE"

# Stop services before backup
sudo systemctl stop ai-dashboard.service

# Create comprehensive backup
sudo tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    --exclude='*.log' \
    --exclude='*.tmp' \
    /opt/ai-parallel-systems \
    /etc/systemd/system/ai-dashboard.service \
    /etc/apparmor.d/ai-dashboard \
    ~/.config/ai-parallel \
    ~/.local/share/ai-parallel

# Restart services
sudo systemctl start ai-dashboard.service

# Set proper permissions
sudo chown $USER:$USER "$BACKUP_DIR/$BACKUP_FILE"

echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE"

# Keep only last 15 backups (Ubuntu LTS cycle consideration)
cd "$BACKUP_DIR"
sudo ls -t ai-parallel-ubuntu-backup-*.tar.gz | tail -n +16 | sudo xargs -r rm

echo "🧹 Old backups cleaned up"

# Create backup verification
echo "🔍 Verifying backup integrity..."
tar -tzf "$BACKUP_DIR/$BACKUP_FILE" > /dev/null && echo "✅ Backup verified"
EOF

chmod +x ~/.local/bin/ai-backup-ubuntu

# Schedule daily backups with Ubuntu-appropriate timing
(crontab -l 2>/dev/null; echo "0 2 * * * ~/.local/bin/ai-backup-ubuntu") | crontab -
```

### Monitoring and Alerting for Ubuntu

Set up comprehensive monitoring using Ubuntu's ecosystem:

```bash
# Create Ubuntu-integrated monitoring script
cat > ~/.local/bin/ai-monitor-ubuntu << 'EOF'
#!/bin/bash
# AI Parallel Systems Monitoring Script for Ubuntu 25.04

# Check system health using Ubuntu tools
HEALTH_STATUS=$(ai-manager health-check --json --ubuntu)
DASHBOARD_STATUS=$(curl -s http://localhost:8081/api/health)

# Check disk space using Ubuntu-specific paths
DISK_USAGE=$(df / | awk 'NR==2{print $5}' | sed 's/%//')
BOOT_USAGE=$(df /boot | awk 'NR==2{print $5}' | sed 's/%//')

# Check memory usage
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')

# Check Ubuntu-specific services
SERVICE_STATUS=$(systemctl is-active ai-dashboard.service)
SYSTEMD_FAILED=$(systemctl --failed --no-legend | wc -l)

# Check Ubuntu updates
SECURITY_UPDATES=$(apt list --upgradable 2>/dev/null | grep -c security)

# Alert thresholds
DISK_THRESHOLD=85
MEMORY_THRESHOLD=90
BOOT_THRESHOLD=80

# Send Ubuntu-specific alerts
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "⚠️ ALERT: Root disk usage is ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    notify-send "AI Systems Alert" "Disk usage critical: ${DISK_USAGE}%"
fi

if [ $BOOT_USAGE -gt $BOOT_THRESHOLD ]; then
    echo "⚠️ ALERT: Boot partition usage is ${BOOT_USAGE}% (threshold: ${BOOT_THRESHOLD}%)"
    notify-send "AI Systems Alert" "Boot partition critical: ${BOOT_USAGE}%"
fi

if [ $MEMORY_USAGE -gt $MEMORY_THRESHOLD ]; then
    echo "⚠️ ALERT: Memory usage is ${MEMORY_USAGE}% (threshold: ${MEMORY_THRESHOLD}%)"
    notify-send "AI Systems Alert" "Memory usage critical: ${MEMORY_USAGE}%"
fi

if [ "$SERVICE_STATUS" != "active" ]; then
    echo "⚠️ ALERT: AI Dashboard service is not active"
    notify-send "AI Systems Alert" "Dashboard service down"
    sudo systemctl restart ai-dashboard.service
fi

if [ $SYSTEMD_FAILED -gt 0 ]; then
    echo "⚠️ ALERT: $SYSTEMD_FAILED systemd services have failed"
    notify-send "AI Systems Alert" "$SYSTEMD_FAILED services failed"
fi

if [ $SECURITY_UPDATES -gt 0 ]; then
    echo "ℹ️ INFO: $SECURITY_UPDATES security updates available"
    notify-send "AI Systems Info" "$SECURITY_UPDATES security updates available"
fi

echo "✅ Ubuntu monitoring check completed"
EOF

chmod +x ~/.local/bin/ai-monitor-ubuntu

# Schedule monitoring every 10 minutes (Ubuntu-appropriate frequency)
(crontab -l 2>/dev/null; echo "*/10 * * * * ~/.local/bin/ai-monitor-ubuntu") | crontab -
```

This comprehensive guide provides everything needed to successfully install, configure, and maintain the AI Parallel Systems on Ubuntu 25.04 LTS. The system leverages Ubuntu's stability, security, and extensive package ecosystem while providing enterprise-grade AI development capabilities with significant cost savings through intelligent system selection and optimization.
