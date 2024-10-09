#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

show_banner() {
    echo -e "${MAGENTA}========================================${RESET}"
    echo -e "${CYAN}         Winsnip Install Cargo          ${RESET}"
    echo -e "${MAGENTA}========================================${RESET}"
}

show_banner

RUSTUP_HOME="$HOME/.rustup"
CARGO_HOME="$HOME/.cargo"

load_rust() {
    export RUSTUP_HOME="$HOME/.rustup"
    export CARGO_HOME="$HOME/.cargo"
    export PATH="$CARGO_HOME/bin:$PATH"
    if [ -f "$CARGO_HOME/env" ]; then
        source "$CARGO_HOME/env"
    fi
}

install_dependencies() {
    echo -e "${YELLOW}Installing system dependencies required for Rust...${RESET}"
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y build-essential libssl-dev curl
    elif command -v yum &> /dev/null; then
        sudo yum groupinstall 'Development Tools' && sudo yum install -y openssl-devel curl
    elif command -v dnf &> /dev/null; then
        sudo dnf groupinstall 'Development Tools' && sudo dnf install -y openssl-devel curl
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu base-devel openssl curl
    else
        echo -e "${RED}Unsupported package manager. Please install dependencies manually.${RESET}"
        exit 1
    fi
}

install_dependencies

if command -v rustup &> /dev/null; then
    echo -e "${GREEN}Rust is already installed.${RESET}"
    read -p "Do you want to reinstall or update Rust? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
        echo -e "${CYAN}Reinstalling Rust...${RESET}"
        rustup self uninstall -y
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
else
    echo -e "${YELLOW}Rust is not installed. Installing Rust...${RESET}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

load_rust

echo -e "${YELLOW}Ensuring correct permissions for Rust directories...${RESET}"
if [ -d "$RUSTUP_HOME" ]; then
    sudo chmod -R 755 "$RUSTUP_HOME"
fi

if [ -d "$CARGO_HOME" ]; then
    sudo chmod -R 755 "$CARGO_HOME"
fi

retry_cargo() {
    local max_retries=3
    local retry_count=0
    local cargo_found=false

    while [ $retry_count -lt $max_retries ]; do
        if command -v cargo &> /dev/null; then
            cargo_found=true
            break
        else
            echo -e "${RED}Cargo not found in the current session. Attempting to reload the environment...${RESET}"
            source "$CARGO_HOME/env"
            retry_count=$((retry_count + 1))
        fi
    done

    if [ "$cargo_found" = false ]; then
        echo -e "${RED}Error: Cargo is still not recognized after $max_retries attempts.${RESET}"
        echo -e "${RED}Please manually source the environment by running: source \$HOME/.cargo/env${RESET}"
        return 1
    fi

    echo -e "${GREEN}Cargo is available in the current session.${RESET}"
    return 0
}

rust_version=$(rustc --version)
cargo_version=$(cargo --version)

echo -e "${CYAN}Rust version: $rust_version${RESET}"
echo -e "${CYAN}Cargo version: $cargo_version${RESET}"

if [[ $SHELL == *"zsh"* ]]; then
    PROFILE="$HOME/.zshrc"
else
    PROFILE="$HOME/.bashrc"
fi

if ! grep -q "CARGO_HOME" "$PROFILE"; then
    echo -e "${YELLOW}Adding Rust environment variables to $PROFILE...${RESET}"
    {
        echo 'export RUSTUP_HOME="$HOME/.rustup"'
        echo 'export CARGO_HOME="$HOME/.cargo"'
        echo 'export PATH="$CARGO_HOME/bin:$PATH"'
        echo 'source "$CARGO_HOME/env"'
    } >> "$PROFILE"
fi

source "$PROFILE"
source "$CARGO_HOME/env"

retry_cargo
if [ $? -ne 0 ]; then
    exit 1
fi

echo -e "${GREEN}Rust installation and setup are complete!${RESET}"
