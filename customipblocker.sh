#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Choose an option:"
    echo "1. Block custom IP range"
    echo "2. Exit"
}

# Function to block IP range
block_ip_range() {
    # Ask the user for the IP range to block
    read -p "Enter the IP range to block (CIDR notation, e.g., 192.168.1.0/24): " USER_IP_RANGE

    # Block the user-input IP range using iptables
    iptables -A INPUT -s $USER_IP_RANGE -j DROP

    # Save the iptables rules to make them persistent
    iptables-save > /etc/iptables/rules.v4

    echo "IP range blocked successfully."
}

# Main loop
while true; do
    display_menu
    read -p "Enter your choice: " choice
    case $choice in
        1)
            block_ip_range
            ;;
        2)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
