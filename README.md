# AI Parallel Systems

**Version 2.0 - AI Development Platform**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/envixo/ai_cli_management)
[![Platform](https://img.shields.io/badge/platform-Linux-green.svg)](https://github.com/envixo/ai_cli_management)

> **Orchestrate multiple AI systems (Gemini, Claude, Codex) with 85% cost savings**

## What It Does

- **Multi-AI Management**: Unified interface for Gemini, Claude, and Codex
- **Cost Optimization**: Gemini costs 85% less than Claude/Codex
- **Intelligent Routing**: Auto-selects best AI for each task
- **Web Dashboard**: Real-time monitoring and cost tracking
- **Parallel Execution**: Run multiple AI tasks simultaneously

## Quick Start

```bash
# Prerequisites: Install gemini, claude, and codex CLI clients first

# 1. Clone the repository (private repo)
git clone https://github.com/envixo/ai_cli_management.git
cd ai_cli_management

# 2. Install core system
./ai_global_installer.sh

# 3. Install advanced commands (recommended)
./ai_advanced_commands.sh

# 4. Configure and start
ai-manager config          # Set up API keys
mkdir my-project && cd my-project
ai-manager init gemini     # Initialize project
ai-quick                   # Start using AI
```

## Installation

### Prerequisites

```bash
# Verify AI clients are installed
which gemini && gemini --version    # Google Gemini CLI
which claude && claude --version    # Anthropic Claude CLI  
which codex && codex --version      # OpenAI Codex CLI

# Verify GitHub CLI is installed (for automatic pull requests)
which gh && gh --version
```

**Important:** The GitHub CLI (`gh`) is required for features like automatic pull request creation. Please ensure it is installed and configured correctly.

**System Requirements:**
- **Operating System**: The installation scripts have been tested on **Arch Linux (Manjaro)** and **Ubuntu**. Pull requests for other operating systems are welcome.
- **Hardware**: 4GB RAM, 10GB disk space
- **Software**: Git 2.20+, Python 3.8+, Bash 4.0+
- **Other**: GitHub access for private repository

### Repository Access (Private Repo)

```bash
# Clone the repository
git clone https://github.com/envixo/ai_cli_management.git
cd ai_cli_management

# If you need authentication, use one of these methods:
# Method 1: Personal Access Token
git clone https://your-token@github.com/envixo/ai_cli_management.git

# Method 2: SSH (if configured)
git clone git@github.com:envixo/ai_cli_management.git

# Method 3: GitHub CLI
gh repo clone envixo/ai_cli_management
```

### Installation Scripts (Run in Order)

#### 1. Core System (Required)
```bash
./ai_global_installer.sh
```
**Installs:** `ai-manager`, `ai-status`, `ai-costs`, `ai-gemini`, `ai-claude`, `ai-codex`

#### 2. Advanced Commands (Recommended)
```bash
./ai_advanced_commands.sh
```
**Adds:** `ai-quick`, `ai-switch`, `ai-logs`, `ai-dashboard`, `ai-backup`

## Commands Reference

### Core Commands

| Command | Purpose | Usage |
|---------|---------|--------|
| `ai-manager` | Main management interface | `ai-manager init/status/config/update` |
| `ai-status` | System status check | `ai-status` or `ai-status --quick` |
| `ai-costs` | Cost analysis | `ai-costs` (shows pricing comparison) |
| `ai-gemini` | Execute with Gemini | `ai-gemini` (85% cheaper) |
| `ai-claude` | Execute with Claude | `ai-claude` (best for reasoning) |
| `ai-codex` | Execute with Codex | `ai-codex` (best for code) |

### Advanced Commands

| Command | Purpose | Usage |
|---------|---------|--------|
| `ai-quick` | Quick execution (uses Gemini) | `ai-quick` |
| `ai-switch` | Smart AI selection | `ai-switch cost-optimal/reasoning/code-focused` |
| `ai-logs` | View logs | `ai-logs live/recent/errors` |
| `ai-dashboard` | Web interface control | `ai-dashboard open/start/stop` |
| `ai-backup` | Backup/restore | `ai-backup create/list/restore <name>` |

## Usage Examples

### Basic Workflow
```bash
# 1. Set up project
cd my-project
ai-manager init gemini

# 2. Create or copy tasks.json
cp tasks_example.json tasks.json
# Edit tasks.json with your specific tasks

# 3. Execute AI tasks in parallel
ai-gemini                   # Execute all tasks with Gemini (85% cheaper)
ai-claude                   # Execute all tasks with Claude (complex reasoning) 
ai-codex                    # Execute all tasks with Codex (code optimization)

# 4. Monitor execution
ai-status                   # Check system status
ai-logs live                # Watch logs in real-time
ai-dashboard open           # Open web interface

# 5. Check results
# Each AI creates separate branches and PRs for each task
# Check .ai-worktrees/ for isolated work directories
# Check .ai-logs/ for execution logs
```

### Smart AI Selection
```bash
ai-switch cost-optimal      # Use cheapest option (Gemini)
ai-switch reasoning         # Use Claude for complex tasks
ai-switch code-focused      # Use Codex for code tasks
ai-switch performance       # Use fastest option
```

### Project Management
```bash
# Configure API keys
ai-manager config

# Initialize different project types
ai-manager init gemini      # Cost-optimized project
ai-manager init claude      # Reasoning-focused project
ai-manager init codex       # Code-focused project

# System maintenance
ai-manager update           # Update all components
ai-backup create            # Create backup
ai-backup restore <name>    # Restore from backup
```

## Cost Comparison

| AI System | Price/1K tokens | Best For | Savings vs Others |
|-----------|----------------|----------|-------------------|
| **Gemini** | $0.0035 | General tasks, cost optimization | 85% cheaper |
| Claude | $0.015 | Complex reasoning, analysis | Standard pricing |
| Codex | $0.030 | Code optimization, debugging | Premium pricing |

**Example Costs (1000 tasks):**
- Gemini: ~$21
- Claude: ~$90 
- Codex: ~$180

## Web Dashboard Features

Access at **http://localhost:8081**

- Real-time system monitoring
- Cost tracking and analysis
- Task execution history
- System health metrics
- API usage statistics
- Interactive controls

## Configuration

### API Keys Setup
```bash
ai-manager config
# Prompts for:
# - Gemini API key (Google AI Studio)
# - Claude API key (Anthropic)
# - Codex API key (OpenAI)
```

### Project Configuration

Create a `tasks.json` file in your project directory:

```bash
# Copy example tasks file
cp tasks_example.json tasks.json

# Or create your own tasks.json
{
  "project_info": {
    "name": "My Project",
    "description": "Project description",
    "base_branch": "main"
  },
  "tasks": [
    {
      "id": "unique-task-id",
      "title": "Task Title",
      "prompt": "Detailed description of what to implement",
      "files": ["src/", "tests/"],
      "priority": 1
    }
  ]
}
```

**Task Structure:**
- `id`: Unique identifier for the task
- `title`: Short descriptive title
- `prompt`: Detailed instructions for the AI
- `files`: (Optional) Array of files/directories to focus on
- `priority`: Task priority (1=high, 2=medium, 3=low)

**Field Options:**
- `files` can be omitted, empty array `[]`, or contain specific paths
- All other fields are required

## Troubleshooting

### Common Issues

**Repository access denied:**
```bash
# Configure GitHub authentication
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Generate personal access token at: https://github.com/settings/tokens
# Use token as password when prompted
```

**Commands not found:**
```bash
# For Zsh users
source ~/.zshrc     # Reload shell
hash -r            # Clear command cache

# For Bash users  
source ~/.bashrc    # Reload shell
hash -r            # Clear command cache
```

**API errors:**
```bash
ai-manager config   # Reconfigure API keys
ai-status          # Check system status
```

**Dashboard not accessible:**
```bash
ai-dashboard status    # Check service status
ai-dashboard restart   # Restart service
```

**High costs:**
```bash
ai-costs              # Check pricing
ai-switch cost-optimal # Switch to Gemini
```

**Installation script permissions:**
```bash
chmod +x *.sh       # Make scripts executable
```

## File Structure

```
/opt/ai-parallel-systems/     # System installation
~/.config/ai-parallel/        # User configuration
~/.local/share/ai-parallel/   # User data and logs
```

## License

MIT License - see LICENSE file for details.

---

**Quick Commands:**
- `ai-quick` - Start AI task with cost optimization
- `ai-status` - Check if everything is working
- `ai-costs` - See pricing comparison
- `ai-dashboard open` - Open web interface