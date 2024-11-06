#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

show_banner() {
    echo -e "${MAGENTA}========================================${RESET}"
    echo -e "${CYAN}          Winsnip Install Docker        ${RESET}"
    echo -e "${MAGENTA}========================================${RESET}"
}

show_banner

install_dependencies() {
    echo -e "${YELLOW}Installing system dependencies required for Docker...${RESET}"
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y curl apt-transport-https ca-certificates gnupg
    elif command -v yum &> /dev/null; then
        sudo yum install -y curl yum-utils device-mapper-persistent-data lvm2
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y curl dnf-plugins-core
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --needed curl
    else
        echo -e "${RED}Unsupported package manager. Please install dependencies manually.${RESET}"
        exit 1
    fi
}

install_docker() {
    echo -e "${YELLOW}Installing Docker...${RESET}"
    if command -v apt &> /dev/null; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
    elif command -v yum &> /dev/null; then
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
    elif command -v dnf &> /dev/null; then
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --needed docker
    else
        echo -e "${RED}Unsupported package manager. Please install Docker manually.${RESET}"
        exit 1
    fi
    sudo systemctl start docker
    sudo systemctl enable docker
    echo -e "${GREEN}Docker has been installed and started!${RESET}"
}

install_dependencies

if command -v docker &> /dev/null; then
    echo -e "${GREEN}Docker is already installed. Skipping installation.${RESET}"
else
    install_docker
fi

echo -e "${CYAN}Docker version: $(docker --version)${RESET}"
echo -e "${GREEN}Docker installation and setup are complete!${RESET}"
