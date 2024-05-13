#!/bin/bash

# Function to display the menu
display_menu() {
    echo "**********"
    echo "***  Lazy Script  ****"
    echo "**********"
    echo "Choose an option:"
    echo "1. Block custom IP range"
    echo "2. Unblock specific IP range"
    echo "3. Unblock all previously blocked IP ranges"
    echo "4. Exit"
    echo "**********"
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

# Function to unblock specific IP range
unblock_ip_range() {
    # Ask the user for the IP range to unblock
    read -p "Enter the IP range to unblock (CIDR notation, e.g., 192.168.1.0/24): " USER_IP_RANGE

    # Unblock the user-input IP range using iptables
    iptables -D INPUT -s $USER_IP_RANGE -j DROP

    # Save the iptables rules to make them persistent
    iptables-save > /etc/iptables/rules.v4

    echo "IP range unblocked successfully."
}

# Function to unblock previously blocked IP ranges
unblock_all_ip_ranges() {
    # Flush all iptables rules
    iptables -F

    # Save the iptables rules to make them persistent
    iptables-save > /etc/iptables/rules.v4

    echo "All previously blocked IP ranges have been unblocked."
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
            unblock_ip_range
            ;;
        3)
            unblock_all_ip_ranges
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
