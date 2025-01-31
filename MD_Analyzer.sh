#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

function apresentacao() {
    echo -e "${BLUE}"
    figlet -f slant "MD Analyzer"
    echo -e "${NC}"
    echo -e "${YELLOW}Bem-vindo ao MD Analyzer!${NC}"
    echo -e "Este script usa a ferramenta exiftool para baixar e analisar MD (metadados) de arquivos como PDF, DOC, DOCX, Excel, entre outros."
    echo "----------------------------------------------------"
}

# Instruções (-h)
function instrucoes_uso() {
    echo -e "Uso: ${GREEN}$0 [opção] [arquivo, diretório ou URL]${NC}"
    echo -e "Opções disponíveis:"
    echo -e "  ${GREEN}-h, --help${NC}          Exibe este manual de uso"
    echo -e "  ${GREEN}-v, --version${NC}       Exibe a versão do script"
    echo -e "  ${GREEN}-a, --analyze${NC}       Baixa (se URL fornecida) e analisa metadados de um arquivo, diretório ou link"
    echo "===================================================="
}


function versao() {
    echo -e "${YELLOW}**MD Analyzer** - versão 1.1${NC}"
}


function baixar_e_analisar() {
    url="$1"
    nome_arquivo=$(basename "$url")

    echo -e "${GREEN}Baixando o arquivo: $url${NC}"
    wget -q "$url" -O "$nome_arquivo"

    if [[ -f "$nome_arquivo" ]]; then
        echo -e "${GREEN}Download concluído. Analisando MD do arquivo baixado...${NC}"
        exiftool "$nome_arquivo"

    else
        echo -e "${RED}Erro: Falha no download do arquivo.${NC}"
        exit 1
    fi
}


function analisar_metadados() {
    if [ -z "$1" ]; then
        echo -e "${RED}Erro: Nenhum arquivo, diretório ou link fornecido.${NC}"
        exit 1
    fi

    if [[ "$1" =~ ^https?:// ]]; then
      
        baixar_e_analisar "$1"
    elif [ -d "$1" ]; then
        echo -e "${GREEN}Analisando todos os arquivos no diretório: $1${NC}"
        find "$1" -type f | while read arquivo; do
            echo -e "${GREEN}Analisando: $arquivo${NC}"
            exiftool "$arquivo"
        done
    elif [ -f "$1" ]; then
        echo -e "${GREEN}Analisando arquivo: $1${NC}"
        exiftool "$1"
    else
        echo -e "${RED}Erro: O arquivo ou diretório especificado não existe.${NC}"
        exit 1
    fi
}


apresentacao


case "$1" in
    -h|--help)
        instrucoes_uso
        ;;
    -v|--version)
        versao
        ;;
    -a|--analyze)
        analisar_metadados "$2"
        ;;
    *)
        echo -e "${RED}Opção inválida. Use -h para exibir o manual de uso.${NC}"
        exit 1
        ;;
esac
