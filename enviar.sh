#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPO_DIR="$HOME/aulas-de-c"
SOURCE_DIR="/sdcard/Download/CodingC"

echo -e "${BLUE}==> Iniciando organização e sincronização...${NC}"

# 1. Mover e renomear arquivos da CodingC para as pastas corretas
if [ -d "$SOURCE_DIR" ]; then
    echo -e "${BLUE}==> Verificando novos arquivos em CodingC...${NC}"
    
    # Criar pasta temporária para processamento se não existir
    mkdir -p "$REPO_DIR/inbox"

    # Move todos os .c para o inbox primeiro para processar
    find "$SOURCE_DIR" -maxdepth 1 -name "*.c" -exec mv {} "$REPO_DIR/inbox/" \;

    cd "$REPO_DIR/inbox" || exit

    for file in *.c; do
        [ -e "$file" ] || continue
        
        # Converter para minúsculas, remover acentos e espaços
        new_name=$(echo "$file" | tr '[:upper:]' '[:lower:]' | sed 's/ç/c/g; s/[áàâã]/a/g; s/[éèê]/e/g; s/[íìî]/i/g; s/[óòôõ]/o/g; s/[úùû]/u/g; s/ /_/g; s/_-_/_/g; s/__/_/g')
        
        # Padronizar nomes de exercícios (ex: exercicio_07.c)
        if [[ $new_name =~ exercicio_?([0-9]+) ]]; then
            num=${BASH_REMATCH[1]}
            # Adicionar zero à esquerda se for apenas um dígito (ex: 9 -> 09)
            if [ ${#num} -eq 1 ]; then num="0$num"; fi
            target_name="exercicio_$num.c"
            
            echo -e "${YELLOW}Organizando: $file -> exercicios/$target_name${NC}"
            mv "$file" "../exercicios/$target_name"
            
        elif [[ $new_name =~ atividade_?([0-9]+) ]]; then
            num=${BASH_REMATCH[1]}
            if [ ${#num} -eq 1 ]; then num="0$num"; fi
            target_name="atividade_$num.c"
            
            echo -e "${YELLOW}Organizando: $file -> atividades/$target_name${NC}"
            mv "$file" "../atividades/$target_name"
        else
            # Se não identificar o padrão, mantém no inbox para você ver depois
            echo -e "${YELLOW}! Arquivo não identificado, mantido em inbox: $file${NC}"
        fi
    done
fi

cd "$REPO_DIR" || exit

# 2. Puxar atualizações remotas
echo -e "${BLUE}==> Puxando atualizações do GitHub...${NC}"
git pull origin main

# 3. Adicionar, commitar e enviar
echo -e "${BLUE}==> Enviando alterações...${NC}"
git add .

# Verifica se há algo para commitar
if ! git diff-index --quiet HEAD --; then
git commit -m "Update via celular: $(date +'%d/%m/%Y %H:%M')"
git push origin main
echo -e "${GREEN}✓ Tudo pronto! Repositório atualizado e arquivos organizados.${NC}"
else
echo "Nada de novo para enviar no momento."
fi

# 4. Sincronizar com a pasta visível no Gerenciador de Arquivos
echo -e "${BLUE}==> Sincronizando com a pasta de Documentos do celular...${NC}"
cp -r "$REPO_DIR/exercicios" "/sdcard/Documents/aulas-de-c-backup/"
cp -r "$REPO_DIR/atividades" "/sdcard/Documents/aulas-de-c-backup/"
cp "$REPO_DIR/README.md" "/sdcard/Documents/aulas-de-c-backup/"
echo -e "${GREEN}✓ Cópia atualizada em: Documentos/aulas-de-c-backup${NC}"

