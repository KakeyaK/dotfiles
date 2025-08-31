#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "mac"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Function to check if stow is installed
check_stow() {
    if ! command -v stow &> /dev/null; then
        print_color $RED "Error: GNU Stow is not installed."
        print_color $YELLOW "Please install stow first:"
        print_color $BLUE "  Ubuntu/Debian: sudo apt install stow"
        print_color $BLUE "  Arch Linux: sudo pacman -S stow"
        print_color $BLUE "  macOS: brew install stow"
        exit 1
    fi
}

# Function to get available packages for an OS
get_packages() {
    local os=$1
    local packages=()
    
    if [ -d "$os" ]; then
        for dir in "$os"/*; do
            if [ -d "$dir" ]; then
                packages+=($(basename "$dir"))
            fi
        done
    fi
    
    echo "${packages[@]}"
}

# Function to display packages with checkboxes
display_packages() {
    local os=$1
    local packages=($2)
    local selected=()
    
    if [ ${#packages[@]} -eq 0 ]; then
        print_color $RED "No packages found for $os"
        exit 1
    fi
    
    print_color $BLUE "\nAvailable packages for $os:"
    for i in "${!packages[@]}"; do
        printf "%d) [ ] %s\n" $((i+1)) "${packages[i]}"
    done
    
    echo
    print_color $YELLOW "Enter package numbers to toggle (space-separated), or 'a' for all, 'n' for none, 'done' to finish:"
    
    local package_status=()
    for pkg in "${packages[@]}"; do
        package_status+=(false)
    done
    
    while true; do
        read -p "> " input
        
        if [[ "$input" == "done" ]]; then
            break
        elif [[ "$input" == "a" ]]; then
            for i in "${!package_status[@]}"; do
                package_status[i]=true
            done
        elif [[ "$input" == "n" ]]; then
            for i in "${!package_status[@]}"; do
                package_status[i]=false
            done
        else
            for num in $input; do
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#packages[@]} ]; then
                    local idx=$((num-1))
                    if [ "${package_status[idx]}" = true ]; then
                        package_status[idx]=false
                    else
                        package_status[idx]=true
                    fi
                fi
            done
        fi
        
        # Redisplay packages with updated status
        clear
        print_color $BLUE "\nAvailable packages for $os:"
        for i in "${!packages[@]}"; do
            local checkbox="[ ]"
            if [ "${package_status[i]}" = true ]; then
                checkbox="[x]"
            fi
            printf "%d) %s %s\n" $((i+1)) "$checkbox" "${packages[i]}"
        done
        echo
        print_color $YELLOW "Enter package numbers to toggle (space-separated), or 'a' for all, 'n' for none, 'done' to finish:"
    done
    
    # Collect selected packages
    for i in "${!package_status[@]}"; do
        if [ "${package_status[i]}" = true ]; then
            selected+=("${packages[i]}")
        fi
    done
    
    echo "${selected[@]}"
}

# Function to install packages
install_packages() {
    local os=$1
    shift
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        print_color $YELLOW "No packages selected for installation."
        return
    fi
    
    print_color $GREEN "\nInstalling selected packages..."
    
    for package in "${packages[@]}"; do
        print_color $BLUE "Installing $package..."
        if stow -d "$os" -t "$HOME" "$package"; then
            print_color $GREEN "✓ Successfully installed $package"
        else
            print_color $RED "✗ Failed to install $package"
        fi
    done
    
    print_color $GREEN "\nInstallation complete!"
}

# Main script
main() {
    print_color $GREEN "=== Dotfiles Installation Script ==="
    
    # Check if stow is installed
    check_stow
    
    # Detect current OS
    current_os=$(detect_os)
    
    # Ask user which OS to configure
    if [ "$current_os" = "unknown" ]; then
        print_color $YELLOW "Could not detect your OS. Please choose:"
        echo "1) Linux"
        echo "2) macOS"
        read -p "Enter your choice (1-2): " os_choice
        
        case $os_choice in
            1) target_os="linux" ;;
            2) target_os="mac" ;;
            *) print_color $RED "Invalid choice. Exiting."; exit 1 ;;
        esac
    else
        print_color $BLUE "Detected OS: $current_os"
        read -p "Install dotfiles for $current_os? (Y/n): " confirm
        
        if [[ "$confirm" =~ ^[Nn]$ ]]; then
            if [ "$current_os" = "linux" ]; then
                target_os="mac"
            else
                target_os="linux"
            fi
            print_color $YELLOW "Switching to $target_os configuration."
        else
            target_os="$current_os"
        fi
    fi
    
    # Get available packages
    available_packages=$(get_packages "$target_os")
    
    if [ -z "$available_packages" ]; then
        print_color $RED "No packages found for $target_os"
        exit 1
    fi
    
    # Let user select packages
    selected_packages=$(display_packages "$target_os" "$available_packages")
    
    # Install selected packages
    if [ -n "$selected_packages" ]; then
        install_packages "$target_os" $selected_packages
        
        # Create a log of installed packages
        echo "# Installed packages on $(date)" > .stow_installed
        echo "OS: $target_os" >> .stow_installed
        for pkg in $selected_packages; do
            echo "$pkg" >> .stow_installed
        done
        
        print_color $GREEN "Installation log saved to .stow_installed"
    else
        print_color $YELLOW "No packages selected. Nothing to install."
    fi
}

# Run main function
main "$@"
