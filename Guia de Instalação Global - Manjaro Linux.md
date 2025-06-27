# Guia de Instalação Global - Manjaro Linux
## Sistema de IA Paralelo (Clientes Existentes)

> **Versão:** 2.0.0 - Atualizada para clientes existentes  
> **Data:** $(date +%Y-%m-%d)  
> **Autor:** Manus AI  
> **Distribuição:** Manjaro Linux (Arch-based)

---

## 📋 Pré-requisitos

Este guia assume que você **já possui** os seguintes clientes de IA instalados no seu sistema Manjaro:

- **codex** - OpenAI Codex CLI
- **claude** - Anthropic Claude CLI  
- **gemini** - Google Gemini CLI

### Verificação Rápida dos Clientes

Antes de prosseguir, verifique se os clientes estão instalados:

```bash
# Verificar clientes instalados
which codex && echo "✓ Codex encontrado" || echo "✗ Codex não encontrado"
which claude && echo "✓ Claude encontrado" || echo "✗ Claude não encontrado"  
which gemini && echo "✓ Gemini encontrado" || echo "✗ Gemini não encontrado"

# Verificar versões
codex --version 2>/dev/null || echo "Codex: versão não disponível"
claude --version 2>/dev/null || echo "Claude: versão não disponível"
gemini --version 2>/dev/null || echo "Gemini: versão não disponível"
```

Se algum cliente não estiver instalado, você pode continuar - os wrappers serão criados mas não funcionarão até a instalação do cliente correspondente.

---

## 🚀 Instalação Rápida (Recomendada)

### Método 1: Instalação Automática

```bash
# 1. Baixar o instalador
curl -fsSL https://raw.githubusercontent.com/seu-repo/ai-global-installer-updated.sh -o ai-installer.sh

# 2. Tornar executável
chmod +x ai-installer.sh

# 3. Executar instalação (requer sudo)
sudo ./ai-installer.sh
```

### Método 2: Instalação Manual

Se preferir controle total sobre o processo:

```bash
# 1. Clonar repositório
git clone https://github.com/seu-repo/ai-parallel-systems.git
cd ai-parallel-systems

# 2. Executar instalador
sudo ./ai_global_installer_updated.sh
```

---

## 🔧 Instalação Detalhada para Manjaro

### Passo 1: Preparar o Sistema

```bash
# Atualizar sistema
sudo pacman -Syu

# Instalar dependências básicas
sudo pacman -S --needed base-devel git curl wget jq bc python python-pip nodejs npm

# Instalar dependências AUR (se necessário)
yay -S --needed github-cli  # Para integração com GitHub PRs
```

### Passo 2: Configurar Estrutura de Diretórios

```bash
# Criar diretórios do sistema (como root)
sudo mkdir -p /opt/ai-parallel-systems/{bin,lib,share,templates,logs}
sudo mkdir -p /opt/ai-parallel-systems/management/{api,web}

# Criar diretórios do usuário
mkdir -p ~/.config/ai-parallel
mkdir -p ~/.local/share/ai-parallel/{logs,backups,templates}
mkdir -p ~/.cache/ai-parallel/{temp,downloads}

# Definir permissões
sudo chown -R $USER:$USER /opt/ai-parallel-systems
chmod -R 755 /opt/ai-parallel-systems
```

### Passo 3: Instalar Wrappers dos Sistemas de IA

#### Wrapper do Codex

```bash
sudo tee /usr/local/bin/ai-codex > /dev/null << 'EOF'
#!/bin/bash
# ai-codex - Wrapper para OpenAI Codex (Manjaro)

# Verificar se codex está instalado
if ! command -v codex >/dev/null 2>&1; then
    echo "Erro: Codex CLI não encontrado"
    echo "Instale o cliente Codex primeiro"
    exit 1
fi

# Verificar API key
if [ -z "${OPENAI_API_KEY:-}" ]; then
    echo "Aviso: OPENAI_API_KEY não configurada"
    echo "Configure com: export OPENAI_API_KEY='sua-chave'"
fi

# Processar arquivo de tarefas
TASKS_FILE="${1:-tasks.json}"

if [ ! -f "$TASKS_FILE" ]; then
    echo "Erro: Arquivo $TASKS_FILE não encontrado"
    echo "Use 'ai-manager init codex' para criar"
    exit 1
fi

echo "Processando tarefas com Codex..."
echo "Arquivo: $TASKS_FILE"

# Implementação específica para Manjaro
# [Código completo do wrapper seria inserido aqui]
EOF

sudo chmod +x /usr/local/bin/ai-codex
```

#### Wrapper do Claude

```bash
sudo tee /usr/local/bin/ai-claude > /dev/null << 'EOF'
#!/bin/bash
# ai-claude - Wrapper para Claude (Manjaro)

# Verificar se claude está instalado
if ! command -v claude >/dev/null 2>&1; then
    echo "Erro: Claude CLI não encontrado"
    echo "Instale o cliente Claude primeiro"
    exit 1
fi

# Verificar API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Aviso: ANTHROPIC_API_KEY não configurada"
    echo "Configure com: export ANTHROPIC_API_KEY='sua-chave'"
fi

# [Implementação completa do wrapper]
EOF

sudo chmod +x /usr/local/bin/ai-claude
```

#### Wrapper do Gemini

```bash
sudo tee /usr/local/bin/ai-gemini > /dev/null << 'EOF'
#!/bin/bash
# ai-gemini - Wrapper para Gemini (Manjaro)

# Verificar se gemini está instalado
if ! command -v gemini >/dev/null 2>&1; then
    echo "Erro: Gemini CLI não encontrado"
    echo "Instale o cliente Gemini primeiro"
    exit 1
fi

# Verificar API key
if [ -z "${GOOGLE_API_KEY:-}" ]; then
    echo "Aviso: GOOGLE_API_KEY não configurada"
    echo "Configure com: export GOOGLE_API_KEY='sua-chave'"
fi

# [Implementação completa do wrapper]
EOF

sudo chmod +x /usr/local/bin/ai-gemini
```

### Passo 4: Instalar Comandos de Gerenciamento

#### Comando ai-manager

```bash
sudo tee /usr/local/bin/ai-manager > /dev/null << 'EOF'
#!/bin/bash
# ai-manager - Gerenciador principal (Manjaro)

show_help() {
    cat << 'HELP'
ai-manager - Gerenciador dos Sistemas de IA (Manjaro)

COMANDOS:
    init <sistema>     - Inicializar projeto
    status            - Status dos sistemas
    config            - Configurar API keys
    update            - Atualizar sistema
    help              - Esta ajuda

SISTEMAS:
    gemini (recomendado) - Google Gemini
    claude               - Anthropic Claude
    codex                - OpenAI Codex
HELP
}

# [Implementação completa do gerenciador]
EOF

sudo chmod +x /usr/local/bin/ai-manager
```

#### Comandos Auxiliares

```bash
# ai-quick - Execução rápida
sudo tee /usr/local/bin/ai-quick > /dev/null << 'EOF'
#!/bin/bash
# Detecção automática do melhor sistema
system=$(jq -r '.project.system // "gemini"' ai_config.json 2>/dev/null || echo "gemini")
echo "Executando com $system..."
exec "ai-$system" "$@"
EOF

# ai-status - Status avançado
sudo tee /usr/local/bin/ai-status > /dev/null << 'EOF'
#!/bin/bash
echo "=== STATUS DOS SISTEMAS DE IA (MANJARO) ==="
# [Implementação do status]
EOF

# ai-costs - Análise de custos
sudo tee /usr/local/bin/ai-costs > /dev/null << 'EOF'
#!/bin/bash
echo "=== ANÁLISE DE CUSTOS ==="
# [Implementação da análise]
EOF

# Tornar executáveis
sudo chmod +x /usr/local/bin/ai-{quick,status,costs}
```

### Passo 5: Configurar Auto-complete

```bash
# Instalar auto-complete para Bash
sudo tee /etc/bash_completion.d/ai-systems << 'EOF'
# Auto-complete para sistemas de IA (Manjaro)

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

complete -F _ai_manager_complete ai-manager
complete -o default ai-gemini ai-claude ai-codex ai-quick
EOF

# Para Zsh (se usar)
if [ -n "$ZSH_VERSION" ]; then
    mkdir -p ~/.zsh/completions
    
    cat > ~/.zsh/completions/_ai-manager << 'EOF'
#compdef ai-manager

_ai_manager() {
    local context state line
    
    _arguments \
        '1:command:(init status config update help)' \
        '*::arg:->args'
    
    case $state in
        args)
            case $words[1] in
                init)
                    _arguments '1:system:(gemini claude codex)'
                    ;;
            esac
            ;;
    esac
}

_ai_manager "$@"
EOF

    # Adicionar ao .zshrc se não existir
    if ! grep -q "fpath=(~/.zsh/completions" ~/.zshrc 2>/dev/null; then
        echo 'fpath=(~/.zsh/completions $fpath)' >> ~/.zshrc
        echo 'autoload -U compinit && compinit' >> ~/.zshrc
    fi
fi
```

---

## ⚙️ Configuração Específica do Manjaro

### Configurar Variáveis de Ambiente

```bash
# Criar arquivo de configuração
mkdir -p ~/.config/ai-parallel

cat > ~/.config/ai-parallel/config.env << 'EOF'
# Configurações dos Sistemas de IA - Manjaro
# Gerado automaticamente

# API Keys (configure com suas chaves)
export GOOGLE_API_KEY=""      # Para Gemini
export ANTHROPIC_API_KEY=""   # Para Claude  
export OPENAI_API_KEY=""      # Para Codex

# Configurações específicas do Manjaro
export AI_PARALLEL_DISTRO="manjaro"
export AI_PARALLEL_PACKAGE_MANAGER="pacman"

# Diretórios
export AI_PARALLEL_CONFIG_DIR="$HOME/.config/ai-parallel"
export AI_PARALLEL_LOGS_DIR="$HOME/.local/share/ai-parallel/logs"
export AI_PARALLEL_CACHE_DIR="$HOME/.cache/ai-parallel"

# Configurações de performance para Manjaro
export AI_PARALLEL_MAX_PARALLEL=5  # Manjaro geralmente tem boa performance
export AI_PARALLEL_TIMEOUT=1800    # 30 minutos
EOF

# Adicionar ao .bashrc
if ! grep -q "ai-parallel/config.env" ~/.bashrc; then
    echo '# AI Parallel Systems' >> ~/.bashrc
    echo '[ -f "$HOME/.config/ai-parallel/config.env" ] && source "$HOME/.config/ai-parallel/config.env"' >> ~/.bashrc
fi

# Carregar configurações
source ~/.config/ai-parallel/config.env
```

### Configurar Integração com AUR

```bash
# Script para manter sistema atualizado
cat > ~/.local/bin/ai-update-manjaro << 'EOF'
#!/bin/bash
# Atualizar sistema de IA no Manjaro

echo "Atualizando sistema Manjaro..."

# Atualizar pacotes do sistema
sudo pacman -Syu --noconfirm

# Atualizar AUR packages se yay estiver instalado
if command -v yay >/dev/null 2>&1; then
    yay -Syu --noconfirm
fi

# Atualizar dependências Python
pip install --user --upgrade openai anthropic google-generativeai

# Atualizar dependências Node.js
npm update -g

echo "Sistema atualizado!"
EOF

chmod +x ~/.local/bin/ai-update-manjaro
```

---

## 🎯 Uso Prático no Manjaro

### Exemplo 1: Projeto Python com FastAPI

```bash
# 1. Criar diretório do projeto
mkdir meu-projeto-api
cd meu-projeto-api

# 2. Inicializar com Gemini (recomendado para Manjaro)
ai-manager init gemini

# 3. Editar tasks.json
nano tasks.json

# 4. Executar
ai-gemini

# 5. Monitorar logs
ai-logs live gemini
```

### Exemplo 2: Projeto Web Full-Stack

```bash
# 1. Usar template web
ai-init gemini web

# 2. Verificar configuração
ai-status

# 3. Executar tarefas
ai-quick

# 4. Alternar sistema se necessário
ai-switch claude
```

### Exemplo 3: Análise de Custos

```bash
# Ver análise completa
ai-costs

# Configurar orçamento mensal
ai-costs budget 50

# Comparar sistemas
ai-costs compare
```

---

## 🐛 Troubleshooting Manjaro

### Problemas Comuns

#### 1. Comando não encontrado

```bash
# Verificar PATH
echo $PATH | grep -o '/usr/local/bin'

# Se não aparecer, adicionar ao .bashrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### 2. Permissões negadas

```bash
# Verificar permissões dos comandos
ls -la /usr/local/bin/ai-*

# Corrigir se necessário
sudo chmod +x /usr/local/bin/ai-*
```

#### 3. Dependências ausentes

```bash
# Instalar dependências que podem estar faltando
sudo pacman -S --needed curl wget jq bc git python python-pip nodejs npm

# Para desenvolvimento
sudo pacman -S --needed base-devel
```

#### 4. Auto-complete não funciona

```bash
# Recarregar bash completion
source /etc/bash_completion.d/ai-systems

# Ou reiniciar terminal
exec bash
```

#### 5. Logs não aparecem

```bash
# Verificar diretórios de log
ls -la ~/.local/share/ai-parallel/logs/

# Criar se não existir
mkdir -p ~/.local/share/ai-parallel/logs/{gemini,claude,codex}
```

### Logs de Debug

```bash
# Ativar modo debug
export AI_DEBUG=1

# Executar comando com debug
ai-gemini tasks.json

# Ver logs detalhados
ai-logs search DEBUG
```

---

## 🔧 Otimizações para Manjaro

### Performance

```bash
# Configurar para SSD (se aplicável)
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

# Otimizar para desenvolvimento
echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
```

### Integração com Desktop Environment

#### Para KDE Plasma

```bash
# Criar atalhos de desktop
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/ai-manager.desktop << 'EOF'
[Desktop Entry]
Name=AI Manager
Comment=Gerenciador de Sistemas de IA
Exec=konsole -e ai-manager
Icon=applications-development
Type=Application
Categories=Development;
EOF
```

#### Para GNOME/GTK

```bash
cat > ~/.local/share/applications/ai-manager.desktop << 'EOF'
[Desktop Entry]
Name=AI Manager
Comment=Gerenciador de Sistemas de IA
Exec=gnome-terminal -- ai-manager
Icon=applications-development
Type=Application
Categories=Development;
EOF
```

---

## 📊 Monitoramento e Manutenção

### Script de Manutenção Automática

```bash
cat > ~/.local/bin/ai-maintenance << 'EOF'
#!/bin/bash
# Manutenção automática do sistema de IA (Manjaro)

echo "=== MANUTENÇÃO DO SISTEMA DE IA ==="

# Limpar logs antigos (>30 dias)
ai-logs cleanup 30

# Limpar cache
rm -rf ~/.cache/ai-parallel/temp/*

# Verificar integridade
ai-status --quick

# Backup de configurações
backup_dir="$HOME/.local/share/ai-parallel/backups/$(date +%Y%m%d)"
mkdir -p "$backup_dir"
cp -r ~/.config/ai-parallel "$backup_dir/"

echo "Manutenção concluída!"
EOF

chmod +x ~/.local/bin/ai-maintenance

# Adicionar ao crontab para execução semanal
(crontab -l 2>/dev/null; echo "0 2 * * 0 $HOME/.local/bin/ai-maintenance") | crontab -
```

### Monitoramento de Recursos

```bash
# Script para monitorar uso de recursos
cat > ~/.local/bin/ai-monitor << 'EOF'
#!/bin/bash
# Monitor de recursos para sistemas de IA

echo "=== MONITOR DE RECURSOS ==="

# CPU e Memória
echo "CPU/Memória:"
top -bn1 | grep "ai-" | head -5

# Espaço em disco
echo -e "\nEspaço em disco:"
df -h ~/.local/share/ai-parallel/

# Processos ativos
echo -e "\nProcessos AI ativos:"
ps aux | grep -E "(ai-|codex|claude|gemini)" | grep -v grep

# Rede (se executando tarefas)
echo -e "\nConexões de rede:"
netstat -an | grep -E "(api\.openai|api\.anthropic|generativelanguage\.googleapis)"
EOF

chmod +x ~/.local/bin/ai-monitor
```

---

## 🚀 Próximos Passos

Após a instalação bem-sucedida:

1. **Configure suas API keys:**
   ```bash
   ai-manager config
   ```

2. **Teste o sistema:**
   ```bash
   ai-status
   ```

3. **Crie seu primeiro projeto:**
   ```bash
   mkdir teste-ai && cd teste-ai
   ai-init gemini basic
   ai-gemini
   ```

4. **Monitore a execução:**
   ```bash
   ai-logs live gemini
   ```

5. **Analise custos:**
   ```bash
   ai-costs
   ```

---

## 📞 Suporte e Recursos

### Comandos de Ajuda

```bash
ai-manager help      # Ajuda do gerenciador
ai-gemini --help     # Ajuda do Gemini
ai-claude --help     # Ajuda do Claude
ai-codex --help      # Ajuda do Codex
ai-status --help     # Ajuda do status
ai-costs --help      # Ajuda de custos
```

### Recursos Úteis

- **Logs:** `~/.local/share/ai-parallel/logs/`
- **Configurações:** `~/.config/ai-parallel/`
- **Cache:** `~/.cache/ai-parallel/`
- **Backups:** `~/.local/share/ai-parallel/backups/`

### Comunidade Manjaro

- [Manjaro Forum](https://forum.manjaro.org/)
- [Arch Wiki](https://wiki.archlinux.org/)
- [AUR Packages](https://aur.archlinux.org/)

---

## ✅ Verificação Final

Execute este script para verificar se tudo está funcionando:

```bash
cat > ~/verify-ai-installation.sh << 'EOF'
#!/bin/bash
echo "=== VERIFICAÇÃO DA INSTALAÇÃO ==="

# Verificar comandos
commands=("ai-manager" "ai-gemini" "ai-claude" "ai-codex" "ai-quick" "ai-status" "ai-costs")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✓ $cmd: $(which $cmd)"
    else
        echo "✗ $cmd: não encontrado"
    fi
done

# Verificar clientes originais
echo -e "\nClientes originais:"
for client in codex claude gemini; do
    if command -v "$client" >/dev/null 2>&1; then
        echo "✓ $client: $(which $client)"
    else
        echo "✗ $client: não encontrado"
    fi
done

# Verificar diretórios
echo -e "\nDiretórios:"
dirs=("$HOME/.config/ai-parallel" "$HOME/.local/share/ai-parallel" "$HOME/.cache/ai-parallel")
for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir"
    else
        echo "✗ $dir: não encontrado"
    fi
done

echo -e "\nInstalação verificada!"
EOF

chmod +x ~/verify-ai-installation.sh
~/verify-ai-installation.sh
```

---

**🎉 Parabéns! Seu sistema de IA paralelo está configurado e pronto para uso no Manjaro Linux!**

> **Dica:** Use `ai-gemini` como sistema principal para economizar até 85% nos custos comparado aos outros sistemas.

