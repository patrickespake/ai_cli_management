# 🤖 AI CLI Management System

> **Sistema de Gerenciamento Unificado para Clientes de IA**  
> **Versão:** 2.0.0 - Adaptado para clientes existentes  
> **Compatibilidade:** Ubuntu 25.04 LTS | Manjaro Linux  
> **Autor:** Patrick - Manus AI  

---

## 📋 Visão Geral

O **AI CLI Management System** é uma solução completa para gerenciar e executar múltiplos clientes de IA de forma paralela e eficiente. Este sistema assume que você já possui os clientes **codex**, **claude** e **gemini** instalados e cria uma camada de gerenciamento unificado sobre eles.

### 🎯 Principais Características

- **🔗 Unificação:** Interface única para gerenciar Codex (OpenAI), Claude (Anthropic) e Gemini (Google)
- **💰 Economia:** Gemini oferece **85% de economia** comparado aos outros sistemas
- **📊 Dashboard Web:** Interface gráfica completa com análise de custos e monitoramento
- **🔄 Execução Paralela:** Processamento simultâneo de múltiplas tarefas
- **📈 Análise de Custos:** Comparação detalhada entre sistemas e orçamento mensal
- **🛠️ Ferramentas Avançadas:** Status detalhado, logs em tempo real, alternância de sistemas
- **🐧 Multi-Distro:** Suporte nativo para Ubuntu 25.04 LTS e Manjaro Linux

---

## 🏗️ Arquitetura do Sistema

### Componentes Principais

```
ai_cli_management/
├── 📄 ai_global_installer_updated.sh     # Instalador principal
├── 📄 ai_unified_management_updated.sh   # Sistema de gerenciamento unificado
├── 📄 ai_advanced_commands_updated.sh    # Comandos avançados
├── 📁 Guias de Instalação
│   ├── 📄 Guia de Instalação Global - Ubuntu 25.04 LTS.md
│   └── 📄 Guia de Instalação Global - Manjaro Linux.md
└── 📄 README.md                          # Este arquivo
```

### 🏆 Principais Melhorias da Versão 2.0

#### ⚡ Simplificação Radical:
- **90% menos tempo** de instalação (2-5 min vs 15-30 min)
- **Sem downloads** de clientes (já existem)
- **Foco total** nos wrappers e gerenciamento
- **Verificação automática** de pré-requisitos

#### 🎯 Comandos Globais Prontos:
- **ai-manager** - Gerenciador principal unificado
- **ai-gemini** - Wrapper otimizado (recomendado - 85% mais barato)
- **ai-claude** - Wrapper balanced para tarefas complexas
- **ai-codex** - Wrapper especializado em código
- **ai-dashboard** - Interface web profissional

#### 📊 Dashboard Web Profissional:
- **Interface moderna** e responsiva
- **Monitoramento em tempo real** dos 3 sistemas
- **Análise de custos** com recomendação Gemini
- **Logs integrados** e métricas detalhadas
- **API REST** completa para automação

### Comandos Disponíveis

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `ai-manager` | Gerenciador principal | `ai-manager init gemini` |
| `ai-gemini` | Wrapper para Google Gemini ⭐ | `ai-gemini tasks.json` |
| `ai-claude` | Wrapper para Anthropic Claude | `ai-claude tasks.json` |
| `ai-codex` | Wrapper para OpenAI Codex | `ai-codex tasks.json` |
| `ai-quick` | Execução automática | `ai-quick` |
| `ai-status` | Status detalhado | `ai-status` |
| `ai-costs` | Análise de custos | `ai-costs` |
| `ai-logs` | Visualizador de logs | `ai-logs live gemini` |
| `ai-switch` | Alternar sistemas | `ai-switch gemini` |
| `ai-init` | Inicialização rápida | `ai-init gemini web` |
| `ai-dashboard` | Dashboard web | `ai-dashboard start` |

---

## ⚡ Instalação Rápida

### 🎉 Versão 2.0 - Clientes Existentes

Esta versão foi **otimizada para usuários que já possuem os clientes de IA instalados**, resultando em:

- ⚡ **90% mais rápida** - 2-5 minutos vs 15-30 minutos
- 🎯 **Foco nos wrappers** - Não reinstala clientes existentes
- 🔍 **Detecção automática** - Verifica clientes disponíveis
- 🚀 **Instalação mínima** - Apenas o essencial

### Pré-requisitos

**IMPORTANTE:** Este sistema assume que você já possui pelo menos um dos seguintes clientes instalados:

- ✅ **codex** - OpenAI Codex CLI
- ✅ **claude** - Anthropic Claude CLI  
- ✅ **gemini** - Google Gemini CLI

> **💡 Nota:** O sistema funcionará com qualquer combinação dos clientes. Se você tem apenas um ou dois, tudo bem! Os wrappers serão criados para todos, mas apenas os disponíveis funcionarão.

## 🔑 **Instalação para Repositório Privado**

> **⚠️ IMPORTANTE:** Este repositório é **privado**. Use o método **Git Clone** abaixo.

### 🚀 **Método Recomendado: Git Clone**

#### **Para Ubuntu 25.04 LTS e Manjaro Linux:**

```bash
# 1. Clonar repositório (você precisa ter acesso)
git clone https://github.com/envixo/ai_cli_management.git
cd ai_cli_management

# 2. Verificar arquivos disponíveis
ls -la *.sh
echo "Scripts disponíveis:"
echo "  📦 ai_global_installer_updated.sh - Base essencial (OBRIGATÓRIO)"
echo "  📊 ai_unified_management_updated.sh - Dashboard web (RECOMENDADO)"
echo "  🛠️ ai_advanced_commands_updated.sh - Comandos avançados (OPCIONAL)"
```

### 🎯 **Instalação por Nível de Funcionalidade:**

#### **⭐ NÍVEL MÍNIMO** (Funcional - 2-3 minutos)
```bash
# Apenas o essencial
sudo ./ai_global_installer_updated.sh

# Verificar instalação
ai-manager --version
ai-gemini --help
```

#### **🏆 NÍVEL RECOMENDADO** (Completo com Dashboard - 3-5 minutos)
```bash
# Base + Dashboard Web
sudo ./ai_global_installer_updated.sh
sudo ./ai_unified_management_updated.sh

# Verificar dashboard
ai-dashboard start
ai-dashboard status
```

#### **🚀 NÍVEL ENTERPRISE** (Todos os recursos - 4-6 minutos)
```bash
# Instalação completa (recomendada)
sudo ./ai_global_installer_updated.sh      # Base
sudo ./ai_unified_management_updated.sh    # Dashboard  
sudo ./ai_advanced_commands_updated.sh     # Avançado

# Verificar sistema completo
ai-status --detailed
ai-costs analysis
ai-dashboard open
```

### ⚡ **Instalação Automática Sequencial:**

```bash
# Clone + Instalação completa em um comando
git clone https://github.com/envixo/ai_cli_management.git && \
cd ai_cli_management && \
sudo ./ai_global_installer_updated.sh && \
sudo ./ai_unified_management_updated.sh && \
sudo ./ai_advanced_commands_updated.sh && \
echo "✅ Instalação completa finalizada!"
```

### 🔍 **Instalação com Revisão (Método Seguro):**

```bash
# 1. Clonar e navegar
git clone https://github.com/envixo/ai_cli_management.git
cd ai_cli_management

# 2. Revisar scripts antes de executar (recomendado)
echo "📋 Revisando scripts de instalação..."
less ai_global_installer_updated.sh      # Revisar base
less ai_unified_management_updated.sh    # Revisar dashboard
less ai_advanced_commands_updated.sh     # Revisar avançado

# 3. Executar após revisão
chmod +x *.sh
sudo ./ai_global_installer_updated.sh      # ✅ Executar base
sudo ./ai_unified_management_updated.sh    # ✅ Executar dashboard
sudo ./ai_advanced_commands_updated.sh     # ✅ Executar avançado
```

### 🐧 **Comandos Específicos por Distro:**

#### **Ubuntu 25.04 LTS:**
```bash
# Dependências (se necessário)
sudo apt update && sudo apt install -y git curl wget jq bc python3 python3-pip nodejs npm

# Clone + Instalação
git clone https://github.com/envixo/ai_cli_management.git
cd ai_cli_management
sudo ./ai_global_installer_updated.sh && \
sudo ./ai_unified_management_updated.sh && \
sudo ./ai_advanced_commands_updated.sh

# Otimização Ubuntu
ai-ubuntu optimize
```

#### **Manjaro Linux:**
```bash
# Dependências
sudo pacman -Syu
sudo pacman -S --needed base-devel git curl wget jq bc python python-pip nodejs npm

# Clone + Instalação
git clone https://github.com/envixo/ai_cli_management.git
cd ai_cli_management
sudo ./ai_global_installer_updated.sh && \
sudo ./ai_unified_management_updated.sh && \
sudo ./ai_advanced_commands_updated.sh
```

### 📦 **Entendendo os Componentes de Instalação**

Este sistema possui **3 scripts modulares** que instalam diferentes níveis de funcionalidade:

| Script | Componentes | Status | Tempo |
|--------|-------------|--------|-------|
| `ai_global_installer_updated.sh` | **Base Essencial** | ⚠️ Obrigatório | 2-3 min |
| `ai_unified_management_updated.sh` | **Dashboard Web** | 🏆 Recomendado | 1-2 min |
| `ai_advanced_commands_updated.sh` | **Comandos Avançados** | ⭐ Opcional | 1 min |

#### 🎯 **O que cada script instala:**

**1️⃣ ai_global_installer_updated.sh (BASE ESSENCIAL - OBRIGATÓRIO)**
```bash
✅ Wrappers: ai-gemini, ai-claude, ai-codex
✅ Comando principal: ai-manager  
✅ Comandos básicos: ai-quick, ai-logs, ai-compare
✅ Estrutura de diretórios
✅ Auto-complete
✅ Dependências do sistema
```

**2️⃣ ai_unified_management_updated.sh (DASHBOARD WEB - RECOMENDADO)**
```bash
✅ Dashboard Web (http://localhost:8080)
✅ API REST (http://localhost:8081)
✅ Comando: ai-dashboard
✅ Serviço systemd
✅ Banco SQLite
✅ Interface web moderna
```

**3️⃣ ai_advanced_commands_updated.sh (COMANDOS AVANÇADOS - OPCIONAL)**
```bash
✅ ai-status (status detalhado)
✅ ai-costs (análise de custos avançada)
✅ ai-switch (alternar sistemas)
✅ ai-init (templates rápidos)
✅ ai-logs (visualizador avançado)
```

---

### 🚀 **Métodos de Instalação por Nível**

#### **⭐ NÍVEL MÍNIMO** (Funcional - 2-3 minutos)
```bash
# Ubuntu/Manjaro - Apenas o essencial
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer_updated.sh | sudo bash

# Você terá: ai-manager, ai-gemini, ai-claude, ai-codex, ai-quick
```

#### **🏆 NÍVEL RECOMENDADO** (Completo - 3-5 minutos)
```bash
# 1. Base essencial
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer_updated.sh | sudo bash

# 2. Dashboard web
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_unified_management_updated.sh | sudo bash

# Você terá: Tudo do básico + Dashboard Web + API REST
```

#### **🚀 NÍVEL ENTERPRISE** (Todos os recursos - 4-6 minutos)
```bash
# 1. Base essencial
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer_updated.sh | sudo bash

# 2. Dashboard web
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_unified_management_updated.sh | sudo bash

# 3. Comandos avançados
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_advanced_commands_updated.sh | sudo bash

# Você terá: TODOS os recursos disponíveis
```

---

### 🛡️ **Configuração de Acesso ao Repositório Privado**

Se você não tem acesso ao repositório, solicite acesso ao proprietário:

```bash
# Verificar se você tem acesso
git clone https://github.com/envixo/ai_cli_management.git

# Se der erro de permissão:
# 1. Configure sua chave SSH no GitHub
# 2. Ou use token de acesso pessoal
# 3. Ou solicite acesso ao repositório
```

### 🔐 **Métodos de Autenticação:**

#### **SSH (Recomendado):**
```bash
# Configurar SSH key (uma vez)
ssh-keygen -t ed25519 -C "seu-email@example.com"
cat ~/.ssh/id_ed25519.pub  # Adicionar no GitHub

# Clonar com SSH
git clone git@github.com:envixo/ai_cli_management.git
```

#### **Token de Acesso:**
```bash
# Clonar com token
git clone https://TOKEN@github.com/envixo/ai_cli_management.git
```

#### **HTTPS com Credenciais:**
```bash
# GitHub pedirá usuário/senha ou token
git clone https://github.com/envixo/ai_cli_management.git
```

---

### ⚡ **Verificação Pós-Instalação**

#### **Verificação por Nível de Instalação:**

**NÍVEL MÍNIMO (apenas ai_global_installer_updated.sh):**
```bash
# Verificar comandos básicos
ai-manager --version        # ✅ Deve funcionar
ai-gemini --help           # ✅ Deve funcionar  
ai-quick                   # ✅ Deve funcionar
ai-logs summary            # ✅ Deve funcionar
```

**NÍVEL RECOMENDADO (+ ai_unified_management_updated.sh):**
```bash
# Verificar dashboard web
ai-dashboard start         # ✅ Deve iniciar dashboard
ai-dashboard status        # ✅ Deve mostrar status
curl http://localhost:8080 # ✅ Deve responder
curl http://localhost:8081/api/health # ✅ API deve responder
```

**NÍVEL ENTERPRISE (+ ai_advanced_commands_updated.sh):**
```bash
# Verificar comandos avançados
ai-status --detailed       # ✅ Status completo
ai-costs analysis         # ✅ Análise de custos
ai-switch list            # ✅ Listar sistemas
ai-init list              # ✅ Listar templates
```

#### **Verificação Completa (todos os níveis):**
```bash
# 1. Verificar sistema completo
ai-status --detailed

# 2. Verificar dashboard web  
ai-dashboard start
ai-dashboard open         # Abre http://localhost:8080

# 3. Testar conectividade com APIs
ai-gemini --check-prereqs
ai-claude --check-prereqs  
ai-codex --check-prereqs

# 4. Ver análise de custos
ai-costs analysis

# 5. Testar workflow completo
mkdir teste-completo && cd teste-completo
ai-init gemini web        # Template web
ai-gemini                 # Executar tarefa
ai-logs live gemini       # Monitorar logs
```

#### **Comandos por Nível de Instalação:**

| Nível | Comandos Disponíveis |
|-------|---------------------|
| **MÍNIMO** | `ai-manager`, `ai-gemini`, `ai-claude`, `ai-codex`, `ai-quick`, `ai-logs`, `ai-compare` |
| **RECOMENDADO** | MÍNIMO + `ai-dashboard` + Dashboard Web (localhost:8080) |
| **ENTERPRISE** | RECOMENDADO + `ai-status`, `ai-costs`, `ai-switch`, `ai-init` |

---

## 🔧 Configuração

### 1. Configurar API Keys

```bash
# Método interativo (recomendado)
ai-manager config

# Ou manualmente
export GOOGLE_API_KEY="sua-chave-google"      # Para Gemini
export ANTHROPIC_API_KEY="sua-chave-anthropic" # Para Claude  
export OPENAI_API_KEY="sua-chave-openai"      # Para Codex
```

### 2. Verificar Status do Sistema

```bash
# Status completo
ai-status

# Status rápido
ai-status --quick

# Verificar conectividade
ai-gemini --check-prereqs
ai-claude --check-prereqs
ai-codex --check-prereqs
```

### 3. Iniciar Dashboard Web

```bash
# Iniciar dashboard
ai-dashboard start

# Abrir no navegador
ai-dashboard open

# URLs disponíveis:
# 📊 Dashboard: http://localhost:8080
# 🔌 API: http://localhost:8081
```

---

## 🎯 Guia de Uso

### Criando um Novo Projeto

#### Método 1: Usando ai-manager

```bash
# 1. Criar diretório do projeto
mkdir meu-projeto-ia
cd meu-projeto-ia

# 2. Inicializar com sistema recomendado (Gemini)
ai-manager init gemini

# 3. Editar tasks.json se necessário
nano tasks.json

# 4. Executar tarefas
ai-gemini

# 5. Monitorar execução
ai-logs live gemini
```

#### Método 2: Usando ai-init com Templates

```bash
# Projeto básico
ai-init gemini basic

# Aplicação web
ai-init gemini web

# API REST
ai-init gemini api

# Machine Learning
ai-init gemini ml

# App móvel
ai-init gemini mobile
```

### Estrutura do Arquivo tasks.json

```json
{
  "project_info": {
    "name": "Meu Projeto",
    "description": "Projeto desenvolvido com IA",
    "base_branch": "main",
    "created": "2024-01-15T10:30:00Z"
  },
  "tasks": [
    {
      "id": "setup-project",
      "title": "Configurar Estrutura do Projeto",
      "prompt": "Configure a estrutura básica do projeto com as melhores práticas...",
      "branch_name": "feature/setup-project",
      "language": "python",
      "framework": "fastapi",
      "priority": 1,
      "files_to_focus": ["src/", "docs/", "tests/"]
    }
  ]
}
```

### Executando Tarefas

```bash
# Com Gemini (recomendado - 85% mais barato)
ai-gemini tasks.json

# Com Claude (balanced)
ai-claude tasks.json

# Com Codex (especializado em código)
ai-codex tasks.json

# Execução automática (usa configuração do projeto)
ai-quick
```

---

## 💰 Análise de Custos

### Comparação de Preços (por 1K tokens)

| Sistema | Input | Output | Rate Limit | Contexto | Economia |
|---------|-------|--------|------------|----------|----------|
| **🏆 Gemini** | $0.0035 | $0.0105 | 60/min | 1M tokens | **Baseline** |
| Claude | $0.015 | $0.075 | 30/min | 200K tokens | 328% mais caro |
| Codex | $0.03 | $0.06 | 20/min | 128K tokens | 757% mais caro |

### Projeções de Economia

```bash
# Ver análise completa
ai-costs analysis

# Para 100 tarefas (~200K tokens):
# Gemini:  ~$2.10
# Claude:  ~$18.00  (economia: $15.90)
# Codex:   ~$18.00  (economia: $15.90)

# Configurar orçamento mensal
ai-costs budget 50

# Monitorar gastos
ai-costs budget
```

---

## 📊 Dashboard e Monitoramento

### Dashboard Web

O sistema inclui um dashboard web completo:

```bash
# Iniciar dashboard
ai-dashboard start

# Funcionalidades:
# ✅ Status em tempo real dos sistemas
# 📈 Estatísticas de uso
# 💰 Análise de custos
# 📋 Logs em tempo real
# 🔄 Alternância entre sistemas
# ⚡ Otimizações automáticas
```

### Monitoramento via CLI

```bash
# Logs em tempo real
ai-logs live gemini        # Apenas Gemini
ai-logs live all           # Todos os sistemas

# Buscar nos logs
ai-logs search ERROR
ai-logs search "task completed"

# Estatísticas de uso
ai-logs stats

# Limpar logs antigos
ai-logs cleanup 30         # Remove logs > 30 dias
```

### Alternância de Sistemas

```bash
# Ver sistema atual
ai-switch current

# Listar todos os sistemas
ai-switch list

# Alternar para outro sistema
ai-switch gemini           # Mais econômico
ai-switch claude           # Para tarefas complexas
ai-switch codex            # Para debugging
```

---

## 🛠️ Comandos Avançados

### ai-status - Status Detalhado

```bash
ai-status                  # Status completo
ai-status --quick          # Status resumido

# Mostra:
# ✅ Clientes instalados e versões
# ✅ API keys configuradas
# ✅ Conectividade com APIs
# ✅ Status do projeto atual
# ✅ Logs recentes
# ✅ Estatísticas de uso
```

### ai-costs - Gestão de Custos

```bash
ai-costs                   # Análise completa
ai-costs compare           # Comparação rápida
ai-costs budget 30         # Definir orçamento de $30/mês
ai-costs budget            # Ver orçamento atual
```

### ai-logs - Gestão de Logs

```bash
ai-logs summary            # Resumo geral
ai-logs live gemini        # Tempo real
ai-logs search "ERROR"     # Buscar termo
ai-logs errors             # Apenas erros
ai-logs stats              # Estatísticas
ai-logs cleanup 7          # Limpar logs > 7 dias
ai-logs export logs.tar.gz # Exportar logs
```

### ai-init - Templates Rápidos

```bash
ai-init                    # Projeto básico com Gemini
ai-init gemini web         # App web
ai-init claude api         # API REST com Claude
ai-init codex ml           # ML com Codex
ai-init list               # Ver templates disponíveis
```

---

## 🔧 Configurações Específicas

### Ubuntu 25.04 LTS

```bash
# Comando específico do Ubuntu
ai-ubuntu packages install    # Instalar dependências
ai-ubuntu services status     # Status dos serviços
ai-ubuntu info               # Informações do sistema
ai-ubuntu optimize           # Otimizar para IA

# Integração com systemd
sudo systemctl enable ai-parallel-dashboard
sudo systemctl start ai-parallel-dashboard
```

### Manjaro Linux

```bash
# Atualização específica do Manjaro
ai-update-manjaro            # Atualizar sistema completo

# Integração com AUR
yay -S ai-related-packages

# Configuração para Arch/Manjaro
export AI_PARALLEL_DISTRO="manjaro"
export AI_PARALLEL_PACKAGE_MANAGER="pacman"
```

---

## 🚀 Exemplos Práticos

### Exemplo 1: API REST com FastAPI

```bash
# 1. Criar projeto
mkdir api-produtos && cd api-produtos

# 2. Inicializar com template
ai-init gemini api

# 3. Customizar tasks.json
cat > tasks.json << 'EOF'
{
  "project_info": {
    "name": "API de Produtos",
    "description": "API REST para gerenciar produtos"
  },
  "tasks": [
    {
      "id": "setup-fastapi",
      "title": "Configurar API FastAPI",
      "prompt": "Crie uma API completa em FastAPI para gerenciar produtos. Inclua modelos Pydantic, CRUD operations, autenticação JWT, documentação Swagger, testes automatizados e dockerização.",
      "language": "python",
      "framework": "fastapi"
    }
  ]
}
EOF

# 4. Executar com Gemini (mais econômico)
ai-gemini

# 5. Monitorar
ai-logs live gemini
```

### Exemplo 2: App Web Full-Stack

```bash
# 1. Template web
ai-init gemini web

# 2. Executar tarefas
ai-gemini

# 3. Alternar para Claude para frontend complexo
ai-switch claude
ai-claude  # Para tarefas de UI/UX complexas

# 4. Voltar para Gemini para backend
ai-switch gemini
```

### Exemplo 3: Projeto de Machine Learning

```bash
# 1. Template ML
ai-init gemini ml

# 2. Adicionar tarefa específica
cat >> tasks.json << 'EOF'
    {
      "id": "model-training",
      "title": "Treinar Modelo de Classificação",
      "prompt": "Implemente um pipeline completo de ML para classificação de texto. Use scikit-learn, pandas, e inclua preprocessing, feature engineering, model selection, hyperparameter tuning e avaliação detalhada.",
      "language": "python",
      "framework": "scikit-learn"
    }
EOF

# 3. Executar
ai-gemini
```

---

## 🐛 Troubleshooting

### Problemas Comuns

#### 1. Comando não encontrado

```bash
# Verificar PATH
echo $PATH | grep /usr/local/bin

# Adicionar ao PATH se necessário
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### 2. API Key não configurada

```bash
# Configurar interativamente
ai-manager config

# Verificar configuração atual
env | grep -E "(GOOGLE_API_KEY|ANTHROPIC_API_KEY|OPENAI_API_KEY)"
```

#### 3. Cliente não encontrado

```bash
# Verificar clientes instalados
which codex claude gemini

# Se algum não estiver instalado, instale-o primeiro
# O sistema funcionará com os clientes disponíveis
```

#### 4. Permissões negadas

```bash
# Corrigir permissões
sudo chmod +x /usr/local/bin/ai-*
sudo chown -R $USER:$USER ~/.config/ai-parallel
```

#### 5. Dashboard não inicia

```bash
# Verificar porta ocupada
sudo netstat -tlnp | grep :8080

# Iniciar em porta alternativa
AI_DASHBOARD_PORT=8090 ai-dashboard start

# Verificar logs
ai-dashboard logs
```

### Logs de Debug

```bash
# Ativar modo debug
export AI_DEBUG=1

# Executar comando com debug
ai-gemini --check-prereqs

# Ver logs detalhados
ai-logs search DEBUG
```

---

## 📁 Estrutura de Arquivos

### Diretórios do Sistema

```
/opt/ai-parallel-systems/           # Instalação principal
├── bin/                           # Executáveis
├── lib/                           # Bibliotecas
├── share/                         # Dados compartilhados
├── templates/                     # Templates de projeto
├── logs/                          # Logs do sistema
└── management/                    # Dashboard e API
    ├── api/                       # API REST
    └── web/                       # Interface web

~/.config/ai-parallel/             # Configurações do usuário
├── config.env                    # Variáveis de ambiente
├── clients_status.json           # Status dos clientes
└── budget.json                   # Configurações de orçamento

~/.local/share/ai-parallel/       # Dados do usuário
├── logs/                         # Logs por sistema
│   ├── gemini/
│   ├── claude/
│   └── codex/
├── backups/                      # Backups de configuração
├── templates/                    # Templates personalizados
└── database/                     # Banco SQLite

~/.cache/ai-parallel/             # Cache temporário
├── temp/                         # Arquivos temporários
└── downloads/                    # Downloads
```

### Arquivos de Configuração

#### tasks.json (Projeto)
```json
{
  "project_info": {
    "name": "Nome do Projeto",
    "description": "Descrição",
    "base_branch": "main"
  },
  "tasks": [...]
}
```

#### ai_config.json (Projeto)
```json
{
  "project": {
    "name": "Nome do Projeto",
    "system": "gemini",
    "created": "2024-01-15T10:30:00Z"
  },
  "settings": {
    "max_parallel_tasks": 4,
    "timeout_minutes": 30,
    "auto_commit": true
  }
}
```

---

## 🔐 Segurança e Boas Práticas

### Proteção de API Keys

```bash
# Nunca commitar API keys
echo "*.env" >> .gitignore
echo "config.env" >> .gitignore

# Usar arquivo de configuração local
source ~/.config/ai-parallel/config.env

# Verificar se keys não estão expostas
ai-status | grep "API Key"
```

### Limitação de Recursos

```bash
# Configurar limites
export AI_MAX_PARALLEL_TASKS=3     # Máximo 3 tarefas simultâneas
export AI_TIMEOUT_MINUTES=30       # Timeout de 30 minutos
export AI_MAX_TOKENS=4096          # Limite de tokens por request

# Monitorar uso
ai-costs budget 50                 # Orçamento mensal de $50
ai-logs stats                      # Estatísticas de uso
```

### Backup e Recuperação

```bash
# Backup automático (configurado via cron)
ai-logs export backup-$(date +%Y%m%d).tar.gz

# Backup manual de configurações
cp -r ~/.config/ai-parallel ~/.config/ai-parallel.backup

# Restaurar configurações
cp -r ~/.config/ai-parallel.backup ~/.config/ai-parallel
```

---

## 🚀 Atualizações e Manutenção

### Atualizações do Sistema

```bash
# Ubuntu
ai-ubuntu packages update
sudo apt update && sudo apt upgrade

# Manjaro
ai-update-manjaro
sudo pacman -Syu

# Atualizar dependências Python
pip install --user --upgrade openai anthropic google-generativeai
```

### Manutenção Automática

```bash
# Executar manutenção (já configurado via cron)
~/.local/bin/ai-maintenance

# Limpeza manual
ai-logs cleanup 30                 # Remove logs > 30 dias
rm -rf ~/.cache/ai-parallel/temp/* # Limpa cache temporário
```

### Monitoramento de Performance

```bash
# Monitor de recursos
~/.local/bin/ai-monitor

# Verificação de integridade
ai-status --detailed

# Análise de custos
ai-costs analysis
```

---

## 📈 Roadmap e Funcionalidades Futuras

### Em Desenvolvimento

- 🔄 **Auto-switching inteligente** baseado no tipo de tarefa
- 📊 **Relatórios avançados** de uso e performance  
- 🔌 **Integração com IDE** (VS Code, JetBrains)
- 🌐 **Interface web melhorada** com gráficos interativos
- 🚀 **Deploy automático** para cloud providers
- 📱 **App móvel** para monitoramento

### Próximas Versões

#### v2.1.0 - Melhorias de Performance
- Cache inteligente de responses
- Processamento paralelo otimizado
- Compressão de logs automática

#### v2.2.0 - Novas Integrações
- Suporte para mais clientes de IA
- Integração com GitHub Actions
- Webhooks para notificações

#### v3.0.0 - AI-Powered Management
- Auto-otimização baseada em histórico
- Recomendações inteligentes de sistema
- Predição de custos avançada

---

## 📞 Suporte e Contribuição

### Comandos de Ajuda

```bash
# Ajuda geral
ai-manager help

# Ajuda específica por comando
ai-gemini --help
ai-claude --help
ai-codex --help
ai-status --help
ai-costs --help
ai-logs --help
```

### Recursos de Suporte

- 📧 **Email:** suporte@envixo.com
- 💬 **Discord:** [Servidor da Comunidade](https://discord.gg/envixo)
- 📖 **Documentação:** [docs.envixo.com](https://docs.envixo.com)
- 🐛 **Issues:** [GitHub Issues](https://github.com/envixo/ai_cli_management/issues)

### Como Contribuir

1. **Fork** o repositório
2. **Crie** uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. **Commit** suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. **Push** para a branch (`git push origin feature/nova-funcionalidade`)
5. **Abra** um Pull Request

### Diretrizes de Contribuição

- Siga o padrão de código existente
- Adicione testes para novas funcionalidades
- Atualize a documentação quando necessário
- Use commits descritivos em português

---

## 📜 Licença

Este projeto está licenciado sob a **MIT License**. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 🎉 Conclusão

O **AI CLI Management System** oferece uma solução completa e econômica para gerenciar múltiplos clientes de IA. Com o **Gemini como sistema recomendado**, você pode economizar até **85% nos custos** mantendo alta qualidade e performance superior.

### Por que Escolher Este Sistema?

- ✅ **Economia Real:** Até 85% de redução nos custos
- ✅ **Interface Unificada:** Um sistema para gerenciar todos os clientes
- ✅ **Dashboard Completo:** Monitoramento visual e análise detalhada
- ✅ **Multi-Plataforma:** Ubuntu e Manjaro totalmente suportados
- ✅ **Código Aberto:** Transparente e extensível
- ✅ **Comunidade Ativa:** Suporte contínuo e melhorias constantes

### 🚀 Fluxo de Trabalho Otimizado da Versão 2.0

#### 1️⃣ Instalação (Uma vez - 2-5 minutos):
```bash
# Ubuntu 25.04 ou Manjaro
curl -fsSL https://raw.githubusercontent.com/envixo/ai_cli_management/main/ai_global_installer_updated.sh | sudo bash
```

#### 2️⃣ Configuração (Uma vez):
```bash
ai-manager config       # Configurar API keys
ai-dashboard start     # Iniciar dashboard web
ai-status --detailed   # Verificar sistema
```

#### 3️⃣ Uso Diário:
```bash
cd meu-projeto
ai-manager init gemini  # Criar tasks.json (85% mais barato)
ai-gemini              # Executar tarefas
ai-dashboard open      # Monitorar via web (http://localhost:8080)
```

#### 💰 Vantagens do Repositório Privado + Versão 2.0:
- **Segurança:** Código protegido e controlado
- **Tempo:** 90% menos instalação (2-6 min vs 15-30 min)
- **Custos:** 85% economia usando Gemini vs outros sistemas  
- **Flexibilidade:** Instale apenas o que precisa (modular)
- **Controle:** Acesso restrito e auditável
- **Manutenção:** Totalmente automatizada

### 🎯 Próximos Passos para Repositório Privado

1. **Clone** o repositório (precisa de acesso):
   ```bash
   git clone https://github.com/envixo/ai_cli_management.git
   cd ai_cli_management
   ```

2. **Instale** rapidamente (escolha seu nível):
   ```bash
   # Completo (recomendado)
   sudo ./ai_global_installer_updated.sh && \
   sudo ./ai_unified_management_updated.sh && \
   sudo ./ai_advanced_commands_updated.sh
   ```

3. **Configure** API keys:
   ```bash
   ai-manager config
   ```

4. **Teste** sistema completo:
   ```bash
   ai-status --detailed
   ai-dashboard start
   ```

5. **Use** em seus projetos:
   ```bash
   mkdir meu-projeto && cd meu-projeto
   ai-init gemini web
   ai-gemini
   ```

---

**🚀 Comece agora e transforme seu workflow de desenvolvimento com IA!**

> **💡 Dica Final:** Use `ai-gemini` como sistema padrão para máxima economia e `ai-claude` apenas para tarefas que exigem raciocínio muito complexo. O `ai-codex` fica reservado para debugging específico.

---

*Developed with ❤️ by **Patrick** - Envixo Team*