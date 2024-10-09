#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

show_banner() {
    echo -e "${MAGENTA}========================================${RESET}"
    echo -e "${CYAN}          Winsnip Install Go           ${RESET}"
    echo -e "${MAGENTA}========================================${RESET}"
}

show_banner

GO_HOME="$HOME/go"
DEFAULT_GO_VERSION="1.20.5"
read -p "Enter the Go version to install (press Enter for default $DEFAULT_GO_VERSION): " GO_VERSION
GO_VERSION=${GO_VERSION:-$DEFAULT_GO_VERSION}
GO_INSTALL_URL="https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz"

load_go() {
    export GO_HOME="$HOME/go"
    export PATH="$GO_HOME/bin:$PATH"
}

install_dependencies() {
    echo -e "${YELLOW}Installing system dependencies required for Go...${RESET}"
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y curl
    elif command -v yum &> /dev/null; then
        sudo yum install -y curl
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y curl
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu curl
    else
        echo -e "${RED}Unsupported package manager. Please install dependencies manually.${RESET}"
        exit 1
    fi
}

install_dependencies

if command -v go &> /dev/null; then
    echo -e "${GREEN}Go is already installed. Skipping installation.${RESET}"
else
    echo -e "${YELLOW}Go is not installed. Installing Go version $GO_VERSION...${RESET}"
    curl -OL "$GO_INSTALL_URL"
    sudo tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"
    rm "go$GO_VERSION.linux-amd64.tar.gz"
    echo -e "${GREEN}Go version $GO_VERSION has been installed!${RESET}"
fi

load_go

if ! grep -q "GO_HOME" "$HOME/.bashrc"; then
    echo -e "${YELLOW}Adding Go environment variables to .bashrc...${RESET}"
    {
        echo 'export GO_HOME="$HOME/go"'
        echo 'export PATH="$GO_HOME/bin:$PATH"'
    } >> "$HOME/.bashrc"
fi

source "$HOME/.bashrc"

go_version=$(go version)
echo -e "${CYAN}Go version: $go_version${RESET}"

echo -e "${GREEN}Go installation and setup are complete!${RESET}"
