#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==> Iniciando sincronização do repositório...${NC}"
cd ~/aulas-de-c || exit

# Puxar atualizações remotas
echo -e "${BLUE}==> Puxando atualizações do GitHub...${NC}"
git pull origin main

# Mover arquivos novos do celular para a pasta inbox (evita bagunçar a raiz)
echo -e "${BLUE}==> Verificando novos arquivos no celular...${NC}"
if ls ~/storage/downloads/CodingC/*.c 1> /dev/null 2>&1; then
    cp ~/storage/downloads/CodingC/*.c ./inbox/
    echo -e "${GREEN}✓ Novos arquivos copiados para a pasta 'inbox'.${NC}"
else
    echo "Nenhum novo arquivo .c encontrado no celular."
fi

# Adicionar, commitar e enviar
echo -e "${BLUE}==> Enviando alterações...${NC}"
git add .
if git commit -m "Update via celular: $(date +'%d/%m/%Y %H:%M')"; then
    git push origin main
    echo -e "${GREEN}✓ Tudo pronto! Repositório atualizado.${NC}"
else
    echo "Nada para commitar no momento."
fi
