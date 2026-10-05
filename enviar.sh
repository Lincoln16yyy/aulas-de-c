#!/bin/bash

# Organiza os .c baixados no celular, classifica por tema, sincroniza com o
# GitHub e mantem um backup em Documents/.

set -u

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[1;31m'
NC='\033[0m'

# O repo e o proprio diretorio deste script. O readlink -f resolve o caso de
# este arquivo ser chamado por um symlink em outro lugar do PATH.
SCRIPT_DIR=$(cd -- "$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)

REPO_DIR="${REPO_DIR:-$SCRIPT_DIR}"
SOURCE_DIR="${SOURCE_DIR:-/sdcard/Download/CodingC}"
BACKUP_DIR="${BACKUP_DIR:-/sdcard/Documents/aulas-de-c-backup}"

DRY_RUN=0
case "${1:-}" in
    --dry-run|-n) DRY_RUN=1 ;;
    '') ;;
    *) echo "uso: enviar [--dry-run]" && exit 1 ;;
esac

# Quando nao ha terminal para perguntar (cron, pipe, etc) os arquivos sem nome
# recognized vao direto para 08-extras em vez de travar num prompt.
INTERATIVO=0
[ -t 0 ] && [ "$DRY_RUN" -eq 0 ] && INTERATIVO=1

# Guarda o stdin original no descritor 3. Os lacos de importacao usam
# `done < <(find ...)` e `done <<< "$lista"`, que trocam o stdin do shell
# inteiro; sem este descritor o read receberia EOF e cairia no padrao sem
# nunca perguntar. Ler do fd 3 tambem evita depender de /dev/tty, que exige
# que o processo tenha terminal controlador.
exec 3<&0

# Global preenchida por classificar_interativo.
RESULTADO=""

# Exercicios nomeados exercicio_NN.c vao para a pasta do tema correspondente ao
# numero da lista. Os demais sao detectados lendo o codigo (ver sugerir_tema).
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

declare -A DESCRICAO_TEMA=(
    [01-condicionais]="condicionais: if / else / switch"
    [02-loops]="loops: for / while / do"
    [03-vetores]="vetores e arrays de uma dimensao"
    [04-matrizes]="matrizes"
    [05-funcoes]="funcoes e prototipos"
    [06-strings]="strings: char[], fgets, string.h"
    [07-structs-arquivos]="structs, typedef e arquivos"
    [08-extras]="extras, sem tema definido"
)

EXTRAS_DIR="exercicios/08-extras"

# Nome gerado pelo app (20261005-141532.c, 1760000000.c, ...). So esses
# arquivos entram no prompt de classificacao; nomes descritivos que o usuario
# escolheu, como matriz_lados.c, sao deixados em paz.
nome_eh_gerado() {
    local base="${1%.c}"
    [[ $base =~ ^[0-9] ]]
}

normalizar() {
    # minusculas, sem acentos e com underscored no lugar de espacos
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' \
        | sed 's/ç/c/g; s/[áàâã]/a/g; s/[éèê]/e/g; s/[íìî]/i/g
               s/[óòôõ]/o/g; s/[úùû]/u/g; s/ü/u/g; s/ /_/g
               s/__/_/g; s/_-_/-/g; s/^\+//; s/_+$//'
}

# Le o codigo e tenta adivinhar o tema. A ordem importa: o teste mais
# especifico vem primeiro, porque quase todo exercicio de struct tambem tem
# for e if, e cairia em 02-loops se o struct nao fosse checado antes.
sugerir_tema() {
    local arquivo="$1"

    if grep -qE '\bstruct\b|typedef +struct|\bFILE *\*|\bfopen|\bfread|\bfwrite|\bfprintf' "$arquivo"; then
        echo "07-structs-arquivos"
    elif grep -qE '\[[0-9]*\][[:space:]]*\[[0-9]*\]|\bmatriz|\bmatrices' "$arquivo"; then
        echo "04-matrizes"
    elif grep -qE '\bfgets|\bstring\.h|\bstrcmp|\bstrcpy|\bstrlen|\bstrtok|\bctype\.h' "$arquivo"; then
        echo "06-strings"
    elif grep -E '^[a-zA-Z_][a-zA-Z0-9_]*([[:space:]]*\*)?[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\(.*\)[[:space:]]*\{' "$arquivo" \
        | grep -qv '\bmain\b'; then
        echo "05-funcoes"
    elif grep -qE '\b(int|float|double|char|long|short|unsigned)[[:space:]][^;()]*\[[0-9A-Za-z_]+\]' "$arquivo"; then
        # Antes dos loops de proposito: quase todo exercicio de vetor tambem
        # tem for, e sem esta ordem o 02-loops engoliria todos eles.
        # A regra exige um tipo antes dos colchetes, para nao casar com
        # acessos do tipo vetor[i] dentro de um scanf.
        echo "03-vetores"
    elif grep -qE '\b(for|while|do)\b' "$arquivo"; then
        echo "02-loops"
    elif grep -qE '\b(if|else|switch)\b' "$arquivo"; then
        echo "01-condicionais"
    fi
}

# Maior exercicio_NN.c existente no repo, mais um. Precisa ser global: se o
# mesmo numero aparece em duas pastas, o mapa TEMA_POR_NUMERO fica ambiguo e o
# classificar por nome manda o arquivo para a pasta errada.
proximo_numero() {
    local maior
    maior=$(find "$REPO_DIR/exercicios" -name 'exercicio_*.c' -type f 2>/dev/null \
        | sed 's/.*exercicio_0*\([0-9][0-9]*\)\.c/\1/' | sort -n | tail -1)
    printf '%02d' $(( ${maior:-0} + 1 ))
}

# Em que pasta do repo esta um exercicio_NN.c especifico.
pasta_do_exercicio() {
    find "$REPO_DIR/exercicios" -name "exercicio_$1.c" -type f -print -quit 2>/dev/null \
        | sed "s|^$REPO_DIR/||; s|/exercicio_$1\.c$||"
}

pedir() {
    local prompt="$1" padrao="$2" resposta=""
    printf '%s' "$prompt" >&2
    IFS= read -r resposta <&3 || resposta=""
    printf '%s' "${resposta:-$padrao}"
}

listar_temas() {
    local pasta
    for pasta in $(printf '%s\n' "${!DESCRICAO_TEMA[@]}" | sort); do
        printf '    %s  %s\n' "$pasta" "${DESCRICAO_TEMA[$pasta]}" >&2
    done
}

# Pergunta tema e numero ate o usuario aceitar. O resultado vai para a global
# RESULTADO em vez de stdout: assim os prompts nao ficam fora de ordem, como
# acontecia quando a funcao era chamada dentro de $(...).
classificar_interativo() {
    local origem="$1" nome="$2"
    local tema_sugerido num_sugerido tema num destino
    RESULTADO=""

    tema_sugerido=$(sugerir_tema "$origem")
    num_sugerido=$(proximo_numero)

    echo -e "${CYAN}Arquivo sem nome padrão: ${nome}${NC}"

    if [ -n "$tema_sugerido" ]; then
        echo -e "    Detectei pelo código: ${GREEN}${tema_sugerido}${NC} (${DESCRICAO_TEMA[$tema_sugerido]})"
    else
        echo -e "    ${YELLOW}Não consegui identificar o tema pelo código. Escolha a pasta:${NC}"
        listar_temas
        tema_sugerido="08-extras"
        echo -e "    Sugestão: ${GREEN}${tema_sugerido}${NC} (${DESCRICAO_TEMA[08-extras]})"
    fi

    while true; do
        tema=$(pedir "    Pasta [${tema_sugerido}]: " "$tema_sugerido")
        if [ -n "${DESCRICAO_TEMA[$tema]:-}" ]; then
            break
        fi
        echo -e "${RED}    Pasta inválida. Opções:${NC}"
        listar_temas
    done

    while true; do
        num=$(pedir "    Número do exercício [${num_sugerido}]: " "$num_sugerido")

        if ! [[ $num =~ ^[0-9]{1,3}$ ]]; then
            echo -e "${RED}    Só números de 1 a 999.${NC}"
            continue
        fi
        num=$(printf '%02d' "$((10#$num))")

        # Numero precisa ser unico no repo inteiro, nao so dentro da pasta.
        local ocupado
        ocupado=$(pasta_do_exercicio "$num")
        if [ "$DRY_RUN" -eq 0 ] && [ -n "$ocupado" ]; then
            echo -e "${RED}    O número $num já existe em $ocupado. Escolha outro.${NC}"
            continue
        fi

        break
    done

    destino="exercicios/$tema/exercicio_$num.c"
    echo -e "    Vai ficar em: ${GREEN}${destino}${NC}"
    RESULTADO="$destino"
}

# Move um arquivo para dentro do repo, criando a pasta de destino.
instalar() {
    local origem="$1" destino="$2" nome="$3"
    mkdir -p "$REPO_DIR/$(dirname "$destino")"
    mv "$origem" "$REPO_DIR/$destino"
    echo -e "${GREEN}  $nome -> $destino${NC}"
}

# Mesmo conteudo em algum lugar do repo? Serve para nao perguntar de novo por
# um arquivo que o usuario so rebaixou do celular.
conteudo_ja_existe() {
    local arquivo="$1" soma
    soma=$(md5sum "$arquivo" | cut -d' ' -f1)
    find "$REPO_DIR/exercicios" "$REPO_DIR/atividades" "$REPO_DIR/aulas" \
        -type f -name '*.c' -exec md5sum {} + 2>/dev/null \
        | grep -q "^$soma "
}

# Decide o destino de um .c cujo nome nao segue nenhum padrao conhecido.
tratar_generico() {
    local origem="$1" nome="$2" destino

    if [ "$INTERATIVO" -eq 0 ] && [ "$DRY_RUN" -eq 1 ]; then
        # Em simulacao nao ha prompt, mas ainda vale mostrar a sugestao.
        local tema
        tema=$(sugerir_tema "$origem")
        echo -e "${YELLOW}  $nome -> ${tema:-08-extras}/ (simulação)${NC}"
        return
    fi

    if [ "$INTERATIVO" -eq 0 ]; then
        destino="$EXTRAS_DIR/$nome"
        mkdir -p "$REPO_DIR/$EXTRAS_DIR"
        # Sem terminal o arquivo so pode ir para 08-extras. Se ele ja esta no
        # repo nesse mesmo caminho (caso da etapa 2), mover seria um no-op e o
        # mv reclamaria de arquivo igual a si mesmo.
        if [ "$origem" != "$REPO_DIR/$destino" ]; then
            mv "$origem" "$REPO_DIR/$destino"
        fi
        echo -e "${YELLOW}  $nome -> $destino (sem terminal para perguntar)${NC}"
        return
    fi

    classificar_interativo "$origem" "$nome"
    if [ -n "$RESULTADO" ]; then
        instalar "$origem" "$RESULTADO" "$nome"
    else
        echo -e "${YELLOW}  Deixado como está: $nome${NC}"
    fi
}

# Decide o destino de um .c cujo nome segue um padrao (exercicio_NN, aula_NN,
# atividade_NN). Devolve 1 quando o nome nao casa com nenhum padrao.
classificar() {
    local nome="$1" destino

    if [[ $nome =~ (^|_)exercicio_?0*([0-9]{1,3}) ]]; then
        local num tema
        num=$(printf '%02d' "${BASH_REMATCH[2]}")
        tema="${TEMA_POR_NUMERO[$num]:-}"

        if [ -n "$tema" ] && [ -d "$REPO_DIR/exercicios/$tema" ]; then
            destino="exercicios/$tema/exercicio_$num.c"
        else
            # Numero fora do mapa: se o exercicio ja existe em alguma pasta,
            # segue para a mesma pasta em vez de ir para 08-extras.
            local existente
            existente=$(pasta_do_exercicio "$num")
            if [ -n "$existente" ]; then
                destino="$existente/exercicio_$num.c"
            else
                destino="$EXTRAS_DIR/exercicio_$num.c"
            fi
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
        return 1
    fi

    printf '%s' "$destino"
}

echo -e "${BLUE}==> Iniciando organização e sincronização...${NC}"
[ "$DRY_RUN" -eq 1 ] && echo -e "${YELLOW}==> MODO SIMULAÇÃO: nada será movido, commitado nem enviado.${NC}"

if [ ! -d "$REPO_DIR/.git" ]; then
    echo -e "${RED}ERRO: $REPO_DIR não é um repositório Git.${NC}"
    exit 1
fi

# 1. Importar os .c baixados no celular
if [ -d "$SOURCE_DIR" ]; then
    echo -e "${BLUE}==> Verificando novos arquivos em CodingC...${NC}"

    processados=0
    while IFS= read -r -d '' file; do
        nome=$(normalizar "$(basename "$file")")

        if destino=$(classificar "$nome"); then
            if [ -e "$REPO_DIR/$destino" ]; then
                echo -e "${YELLOW}  Já existe em $destino, mantido em CodingC: $nome${NC}"
                continue
            fi
            [ "$DRY_RUN" -eq 1 ] || instalar "$file" "$destino" "$nome"
        elif nome_eh_gerado "$nome" && conteudo_ja_existe "$file"; then
            # Mesmos bytes de um arquivo ja no repo: e so o mesmo rebaixado de
            # novo. Sem este teste o usuario receberia o prompt toda vez.
            echo -e "${YELLOW}  Já está no repo (conteúdo idêntico), mantido em CodingC: $nome${NC}"
            continue
        elif nome_eh_gerado "$nome"; then
            tratar_generico "$file" "$nome" "$nome"
        else
            # Nome escolhido a mao e que o script nao reconhece: vai direto
            # para 08-extras, sem perguntar nada.
            mkdir -p "$REPO_DIR/$EXTRAS_DIR"
            if [ "$DRY_RUN" -eq 0 ] && [ ! -e "$REPO_DIR/$EXTRAS_DIR/$nome" ]; then
                mv "$file" "$REPO_DIR/$EXTRAS_DIR/$nome"
            fi
            echo -e "${GREEN}  $nome -> $EXTRAS_DIR/${nome}${NC}"
        fi

        processados=$((processados + 1))
    done < <(find "$SOURCE_DIR" -maxdepth 1 -name '*.c' -print0)

    [ "$processados" -eq 0 ] && echo -e "${GREEN}  Nenhum arquivo novo em CodingC.${NC}"
else
    echo -e "${YELLOW}  Pasta $SOURCE_DIR não encontrada, pulando importação.${NC}"
fi

# 2. Resolver arquivos que ja estao no repo com nome de data
pendentes=$(find "$REPO_DIR/exercicios" "$REPO_DIR/atividades" "$REPO_DIR/aulas" \
    -type f -name '*.c' 2>/dev/null \
    | sed "s|^$REPO_DIR/||" \
    | while IFS= read -r rel; do
        nome=$(basename "$rel")
        nome_eh_gerado "$nome" || continue
        classificar "$nome" >/dev/null 2>&1 || printf '%s\n' "$rel"
    done)

if [ -n "$pendentes" ]; then
    echo -e "${BLUE}==> Arquivos no repo ainda sem nome padrao...${NC}"
    while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        nome=$(normalizar "$(basename "$rel")")
        tratar_generico "$REPO_DIR/$rel" "$nome" "$nome"
    done <<< "$pendentes"
else
    echo -e "${GREEN}  Nenhum arquivo com nome de data pendente.${NC}"
fi

cd "$REPO_DIR" || exit 1

if [ "$DRY_RUN" -eq 1 ]; then
    echo -e "${BLUE}==> Alterações locais pendentes:...${NC}"
    git status --short | sed 's/^/  /'
    echo -e "${YELLOW}Simulação encerrada. Rode 'enviar' sem --dry-run para aplicar.${NC}"
    exit 0
fi

# 3. Commitar o que foi organizado localmente
echo -e "${BLUE}==> Enviando alterações...${NC}"
git add -A

houve_commit=0
if git diff-index --quiet --cached HEAD --; then
    echo "  Nada de novo para commitar."
else
    git commit -q -m "Update via celular: $(date +'%d/%m/%Y %H:%M')"
    houve_commit=1
    echo -e "${GREEN}  Alterações commitadas.${NC}"
fi

# 4. Puxar e enviar. O rebase so funciona com a arvore limpa, por isso o commit
#    acima precisa vir antes. Com o rebase, se alguem publicou algo entre o
#    commit e o push, os commits sao reaplicados em cima em vez de falhar.
echo -e "${BLUE}==> Sincronizando com o GitHub...${NC}"
git pull --rebase origin main || {
    echo -e "${RED}ERRO no git pull. Resolva o conflito antes de tentar de novo.${NC}"
    exit 1
}

if [ "$houve_commit" -eq 1 ]; then
    if git push origin main; then
        echo -e "${GREEN}  Repositório atualizado e arquivos organizados.${NC}"
    else
        echo -e "${RED}ERRO no git push. As alterações ficaram commitadas localmente.${NC}"
        exit 1
    fi
fi

# 5. Sincronizar com a pasta visivel no Gerenciador de Arquivos
if [ -d "$(dirname "$BACKUP_DIR")" ]; then
    echo -e "${BLUE}==> Sincronizando com a pasta de Documentos do celular...${NC}"
    mkdir -p "$BACKUP_DIR"
    rm -rf "$BACKUP_DIR"/*
    cp -r "$REPO_DIR/exercicios" "$REPO_DIR/atividades" "$REPO_DIR/aulas" "$BACKUP_DIR/"
    cp "$REPO_DIR/README.md" "$BACKUP_DIR/"
    echo -e "${GREEN}  Cópia atualizada em: ${BACKUP_DIR#/sdcard/}${NC}"
else
    echo -e "${YELLOW}  Armazenamento externo indisponível, backup ignorado.${NC}"
fi
