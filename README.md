# 📚 Aulas de C

Repositório com aulas, atividades e exercícios do curso de **Análise e Desenvolvimento de Sistemas** em linguagem C.

## 📁 Estrutura

```
aulas-de-c/
├── aulas/                          # exemplos trabalhados em aula
├── atividades/                     # atividades práticas avaliadas
├── exercicios/                     # exercícios da lista, agrupados por tema
│   ├── 01-condicionais/
│   ├── 02-loops/
│   ├── 03-vetores/
│   ├── 04-matrizes/
│   ├── 05-funcoes/
│   ├── 06-strings/
│   ├── 07-structs-arquivos/
│   └── 08-extras/
├── Makefile                        # compilar / executar / limpar
└── enviar.sh                       # sincroniza o repositório a partir do celular
```

Os exercícios mantêm o número original da lista no nome do arquivo
(`exercicio_07.c`), mesmo quando estão em pastas por tema — assim dá para
achar no histórico do Git qual exercício era qual.

## 📖 Conteúdo

### 📝 Aulas

| Arquivo | Assunto |
| --- | --- |
| `aula_01_variaveis.c` | declarar variáveis, atribuir valores e imprimir |
| `aula_02_operadores_bitwise.c` | `&`, `\|`, `^`, `~`, shifts lógicos/aritméticos e circulares |

### 🎯 Atividades

| Arquivo | Enunciado |
| --- | --- |
| `atividade_01.c` | cálculo da área do retângulo |
| `atividade_02.c` | cálculo de ferraduras para cavalos |
| `atividade_03.c` | venda de pães e broas, com poupança |
| `atividade_04.c` | operações com dois números (`math.h`) |

### 🚀 Exercícios

**01 · Condicionais** — `exercicio_07` a `exercicio_10`
:classificação de notas, teste de vogal, teste de caractere, `switch` de menu.

**02 · Loops** — `exercicio_11` a `exercicio_14`
:calculadora com `switch`, série de ímpares, fatorial, loop infinito.

**03 · Vetores** — `exercicio_15` a `exercicio_18` e `exercicio_23` a `exercicio_28`, `exercicio_36`
:maior/menor valor, médias, busca e índice do maior elemento, concatenação de
vetores, números primos, soma e média de vetor.

**04 · Matrizes** — `matriz_lados.c`, `matriz_soma.c`, `matriz_soma_elementos.c`
:triângulo a partir dos lados, soma dos elementos de uma matriz, soma de duas matrizes.

**05 · Funções** — `exercicio_19` a `exercicio_22`
:soma, potência, comparação de cinco valores, distância entre dois pontos.
Incluem os primeiros protótipos de função.

**06 · Strings** — `exercicio_29.c`
:leitura com `fgets` e manipulação de caracteres com `string.h` / `ctype.h`.

**07 · Structs e arquivos** — `exercicio_30` a `exercicio_35`
:structs aninhadas, cadastro de aluno, `FILE*`, `fprintf`/`fread` e arquivos
binários com `typedef`.

**08 · Extras** — `data_comparacao.c`, `operacoes_matematicas.c`
:comparação de datas e operações trigonométricas.

## 🔧 Como Compilar e Executar

### Com o Makefile

```bash
make          # compila tudo em build/
make run SRC=exercicios/01-condicionais/exercicio_07.c
make check    # só valida a sintaxe, sem gerar executáveis
make clean    # apaga build/ e os arquivos soltos
make help     # lista os alvos
```

### Manualmente

```bash
gcc arquivo.c -o arquivo
./arquivo
```

No Windows com MinGW, acrescente `.exe`:

```bash
gcc arquivo.c -o arquivo.exe
```

Para quem usa `math.h` (`sqrt`, `pow`, `sin`), ligue a biblioteca matemática:

```bash
gcc arquivo.c -o arquivo -lm
./arquivo
```

> O `Makefile` já passa `-lm` em todos os programas, então não é preciso se
> preocupar com isso por lá.

## ⚠️ Cuidados

- `exercicios/02-loops/exercicio_14.c` é um **loop infinito proposital** — ele
  nunca termina. Use `Ctrl+C` para interromper.
- Os exercícios de `07-structs-arquivos/` gravam arquivos (`.bin`, `.txt`) na
  pasta em que são executados. Rode-os a partir do diretório do arquivo-fonte.

## 📋 Pré-requisitos

- GCC (GNU Compiler Collection) ou Clang
- GNU Make (opcional, só para usar o `Makefile`)
- Terminal

## 📱 Enviando do celular

O `enviar.sh` organiza os `.c` baixados para `CodingC` no armazenamento
interno, classifica pelo nome, sincroniza com o GitHub e faz backup em
`Documents/aulas-de-c-backup`.

```bash
bash enviar.sh
```

## 🎓 Objetivo

Guardar e organizar os exercícios práticos do curso de ADS em C, permitindo
revisão e acompanhamento do aprendizado.

---

**Criado por:** Lincoln16yyy
