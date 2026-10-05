#!/bin/bash

# Organiza os .c baixados no celular, classifica por tema, sincroniza com o
# GitHub e mantem um backup em Documents/.

set -u

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# O repo e o proprio diretorio deste script. O readlink -f resolve o caso de
# este arquivo ser chamado por um symlink em outro lugar do PATH.
SCRIPT_DIR=$(cd -- "$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)

REPO_DIR="${REPO_DIR:-$SCRIPT_DIR}"
SOURCE_DIR="${SOURCE_DIR:-/sdcard/Download/CodingC}"
BACKUP_DIR="${BACKUP_DIR:-/sdcard/Documents/aulas-de-c-backup}"

# Exercicios nomeados exercicio_NN.c vao para a pasta do tema correspondente ao
# numero da lista. Os demais caem em 08-extras, que nunca e sobrescrito.
declare -A TEMA_POR_NUMERO=(
    [07]=01-condicionais   [08]=01-condicionais   [09]=01-condicionais  [10]=01-condicionais
    [11]=02-loops          [12]=02-loops          [13]=02-loops         [14]=02-loops
    [15]=03-vetores        [16]=03-vetores        [17]=03-vetores       [18]=03-vetores
    [19]=05-funcoes        [20]=05-funcoes        [21]=05-funcoes       [22]=05-funcoes
    [23]=03-vetores        [24]=03-vetores        [25]=03-vetores
    [26]=03-vetores        [27]=03-vetores        [28]=03-vetores       [29]=06-strings
    [30]=07-structs-arquivos [31]=07-structs-arquivos [32]=07-structs-arquivos
    [33]=07-structs-arquivos [34]=07-structs-arquivos [35]=07-structs-arquivos
    [36]=03-vetores
)

EXTRAS_DIR="exercicios/08-extras"

normalizar() {
    # minusculas, sem acentos e com underscored no lugar de espacos
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' \
        | sed 's/ç/c/g; s/[áàâã]/a/g; s/[éèê]/e/g; s/[íìî]/i/g
               s/[óòôõ]/o/g; s/[úùû]/u/g; s/ü/u/g; s/ /_/g
               s/__/_/g; s/_-_/-/g; s/^\+//; s/_+$//'
}

classificar() {
    local nome="$1" destino

    if [[ $nome =~ (^|_)exercicio_?0*([0-9]{1,3}) ]]; then
        local num tema
        num=$(printf '%02d' "${BASH_REMATCH[2]}")
        # O :- evita o unbound variable do set -u quando o numero ainda nao
        # tem tema mapeado (exercicio novo da lista).
        tema="${TEMA_POR_NUMERO[$num]:-}"

        if [ -n "$tema" ] && [ -d "$REPO_DIR/exercicios/$tema" ]; then
            destino="exercicios/$tema/exercicio_$num.c"
        else
            destino="$EXTRAS_DIR/exercicio_$num.c"
        fi
    elif [[ $nome =~ (^|_)aula_?([0-9]{1,3}) ]]; then
        local num
        num=$(printf '%02d' "${BASH_REMATCH[2]}")
        destino="aulas/aula_$num.c"
    elif [[ $nome =~ (^|_)atividade_?([0-9]{1,3}) ]]; then
        local num
        num=$(printf '%02d' "${BASH_REMATCH[2]}")
        destino="atividades/atividade_$num.c"
    else
        # Sem numero nao ha tema deduzivel. Antes de cair em 08-extras, procura
        # o arquivo em qualquer lugar do repo para nao criar copia duplicada.
        local existente
        existente=$(find "$REPO_DIR/exercicios" "$REPO_DIR/atividades" "$REPO_DIR/aulas" \
            -name "$nome" -type f -print -quit 2>/dev/null)

        if [ -n "$existente" ]; then
            printf '%s' "${existente#"$REPO_DIR"/}"
            return
        fi

        destino="$EXTRAS_DIR/$nome"
    fi

    mkdir -p "$REPO_DIR/$(dirname "$destino")"
    printf '%s' "$destino"
}

DRY_RUN=0
case "${1:-}" in
    --dry-run|-n) DRY_RUN=1 ;;
    '') ;;
    *) echo "uso: enviar [--dry-run]" && exit 1 ;;
esac

echo -e "${BLUE}==> Iniciando organização e sincronização...${NC}"
[ "$DRY_RUN" -eq 1 ] && echo -e "${YELLOW}==> MODO SIMULAÇÃO: nada será movido, commitado nem enviado.${NC}"

if [ ! -d "$REPO_DIR/.git" ]; then
    echo -e "${RED}ERRO: $REPO_DIR não é um repositório Git.${NC}"
    exit 1
fi

# 1. Mover e renomear os .c baixados no celular
if [ -d "$SOURCE_DIR" ]; then
    echo -e "${BLUE}==> Verificando novos arquivos em CodingC...${NC}"

    movidos=0
    while IFS= read -r -d '' file; do
        nome=$(normalizar "$(basename "$file")")
        destino=$(classificar "$nome")

        if [ -e "$REPO_DIR/$destino" ]; then
            echo -e "${YELLOW}! Já existe em $destino, mantido em CodingC: $nome${NC}"
            continue
        fi

        if [ "$DRY_RUN" -eq 1 ]; then
            echo -e "${YELLOW}[simulação] $(basename "$file") -> $destino${NC}"
        else
            mv "$file" "$REPO_DIR/$destino"
        fi
        movidos=$((movidos + 1))
    done < <(find "$SOURCE_DIR" -maxdepth 1 -name '*.c' -print0)

    [ "$movidos" -eq 0 ] && echo -e "${GREEN}Nenhum arquivo novo em CodingC.${NC}"
else
    echo -e "${YELLOW}! Pasta $SOURCE_DIR não encontrada, pulando importação.${NC}"
fi

cd "$REPO_DIR" || exit 1

if [ "$DRY_RUN" -eq 1 ]; then
    echo -e "${BLUE}==> Alterações locais pendentes:...${NC}"
    git status --short | sed 's/^/  /'
    echo -e "${YELLOW}Simulação encerrada. Rode 'enviar' sem --dry-run para aplicar.${NC}"
    exit 0
fi

# 2. Commitar o que foi organizado localmente
echo -e "${BLUE}==> Enviando alterações...${NC}"
git add -A

houve_commit=0
if git diff-index --quiet --cached HEAD --; then
    echo "Nada de novo para commitar."
else
    git commit -q -m "Update via celular: $(date +'%d/%m/%Y %H:%M')"
    houve_commit=1
    echo -e "${GREEN}✓ Alterações commitadas.${NC}"
fi

# 3. Puxar e enviar. O rebase só funciona com a árvore limpa, por isso o commit
#    acima precisa vir antes. Com o rebase, se alguém publican algo entre o
#    commit e o push, os commits são reaplicados em cima em vez de falhar.
echo -e "${BLUE}==> Sincronizando com o GitHub...${NC}"
git pull --rebase origin main || {
    echo -e "${RED}ERRO no git pull. Resolva o conflito antes de tentar de novo.${NC}"
    exit 1
}

if [ "$houve_commit" -eq 1 ]; then
    if git push origin main; then
        echo -e "${GREEN}✓ Repositório atualizado e arquivos organizados.${NC}"
    else
        echo -e "${RED}ERRO no git push. As alterações ficaram commitadas localmente.${NC}"
        exit 1
    fi
fi

# 4. Sincronizar com a pasta visível no Gerenciador de Arquivos
if [ -d "$(dirname "$BACKUP_DIR")" ]; then
    echo -e "${BLUE}==> Sincronizando com a pasta de Documentos do celular...${NC}"
    mkdir -p "$BACKUP_DIR"
    rm -rf "$BACKUP_DIR"/*
    cp -r "$REPO_DIR/exercicios" "$REPO_DIR/atividades" "$REPO_DIR/aulas" "$BACKUP_DIR/"
    cp "$REPO_DIR/README.md" "$BACKUP_DIR/"
    echo -e "${GREEN}✓ Cópia atualizada em: ${BACKUP_DIR#/sdcard/}${NC}"
else
    echo -e "${YELLOW}! Armazenamento externo indisponível, backup ignorado.${NC}"
fi
