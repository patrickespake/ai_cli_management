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

### Pré-requisitos

**IMPORTANTE:** Este sistema assume que você já possui os seguintes clientes instalados:

- ✅ **codex** - OpenAI Codex CLI
- ✅ **claude** - Anthropic Claude CLI  
- ✅ **gemini** - Google Gemini CLI

### Ubuntu 25.04 LTS

```bash
# 1. Baixar e executar instalador
curl -fsSL https://raw.githubusercontent.com/seu-repo/ai-global-installer-updated.sh | sudo bash

# 2. Verificar instalação
ai-status

# 3. Configurar API keys
ai-manager config

# 4. Testar sistema
mkdir teste-ai && cd teste-ai
ai-manager init gemini
ai-gemini
```

### Manjaro Linux

```bash
# 1. Instalar dependências
sudo pacman -Syu
sudo pacman -S --needed base-devel git curl wget jq bc python python-pip nodejs npm

# 2. Executar instalador
curl -fsSL https://raw.githubusercontent.com/seu-repo/ai-global-installer-updated.sh -o ai-installer.sh
chmod +x ai-installer.sh
sudo ./ai-installer.sh

# 3. Configurar sistema
ai-manager config
```

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

- 📧 **Email:** suporte@manus-ai.com
- 💬 **Discord:** [Servidor da Comunidade](https://discord.gg/manus-ai)
- 📖 **Documentação:** [docs.manus-ai.com](https://docs.manus-ai.com)
- 🐛 **Issues:** [GitHub Issues](https://github.com/manus-ai/ai-cli-management/issues)

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

### Próximos Passos

1. **Instale** o sistema seguindo o guia de instalação
2. **Configure** suas API keys com `ai-manager config`
3. **Crie** seu primeiro projeto com `ai-init gemini`
4. **Execute** tarefas com `ai-gemini`
5. **Monitore** custos com `ai-costs`
6. **Otimize** seu workflow com o dashboard web

---

**🚀 Comece agora e transforme seu workflow de desenvolvimento com IA!**

> **💡 Dica Final:** Use `ai-gemini` como sistema padrão para máxima economia e `ai-claude` apenas para tarefas que exigem raciocínio muito complexo. O `ai-codex` fica reservado para debugging específico.

---

*Developed with ❤️ by **Patrick** - Manus AI Team*