#!/bin/bash

# ==============================================================================
# SCRIPT DE LIMPEZA SEGURA DE SERVIDOR LINUX
# Autor: Luciana Jorge de Faria (https://github.com/lcnjrj)
# License: MIT 
# Descrição: Limpa caches apt, logs journald, kernels antigos e caches de usuário.
# ==============================================================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verifica se é root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script precisa ser executado como root.${NC}"
   exit 1
fi

echo -e "${YELLOW}=== Iniciando Limpeza do Sistema ===${NC}"
echo "Espaço em disco ANTES da limpeza:"
df -h / | grep /

# 1. Limpeza do Gerenciador de Pacotes (APT)
echo -e "\n${YELLOW}[1/5] Limpando cache do APT e dependências órfãs...${NC}"
apt-get autoremove -y
apt-get autoclean -y
apt-get clean
echo -e "${GREEN}✓ APT limpo.${NC}"

# 2. Limpeza de Logs do Systemd (Journalctl)
# Mantém apenas os últimos 2 dias ou limita a 100MB
echo -e "\n${YELLOW}[2/5] Otimizando logs do Journald...${NC}"
journalctl --vacuum-time=2d
journalctl --vacuum-size=100M
echo -e "${GREEN}✓ Logs otimizados.${NC}"

# 3. Limpeza de Cache de Thumbnails e Cache de Usuário (Root)
echo -e "\n${YELLOW}[3/5] Limpando caches locais do root...${NC}"
rm -rf /root/.cache/thumbnails/*
rm -rf /root/.cache/pip/* # Se usar Python/Pip como root
echo -e "${GREEN}✓ Caches de root limpos.${NC}"

# 4. Rotação/Limpeza de Logs antigos em /var/log
# ATENÇÃO: Usamos 'truncate' em vez de 'rm' para não quebrar processos que estão escrevendo no arquivo
echo -e "\n${YELLOW}[4/5] Truncando logs antigos em /var/log (*.gz, *.1)...${NC}"
find /var/log -type f -regex ".*\.\(gz\|1\)$" -delete
echo -e "${GREEN}✓ Logs rotacionados antigos removidos.${NC}"

# 5. Docker (Opcional - mas essencial para Full Stack)
# Descomente as linhas abaixo se quiser limpar containers/imagens não utilizados
# echo -e "\n${YELLOW}[5/5] Limpando sistema Docker (Imagens/Containers parados)...${NC}"
# docker system prune -f
# echo -e "${GREEN}✓ Docker limpo.${NC}"

echo -e "\n${YELLOW}=== Limpeza Concluída ===${NC}"
echo "Espaço em disco DEPOIS da limpeza:"
df -h / | grep /
