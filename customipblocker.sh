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
    echo "4. Show previously blocked IP ranges"
    echo "5. Block private IP for Hetzner"
    echo "6. Exit"
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

# Function to show previously blocked IP ranges
show_blocked_ip_ranges() {
    echo "Previously blocked IP ranges:"
    iptables -L INPUT -n --line-numbers | grep DROP | awk '{print $4}'
}

# Function to block private IP for Hetzner
block_private_ip_for_hetzner() {
    # List of private IP ranges for Hetzner
    PRIVATE_IP_RANGES=(
        "200.0.0.0/8"
        "102.0.0.0/8"
        "10.0.0.0/8"
        "100.64.0.0/10"
        "169.254.0.0/16"
        "198.18.0.0/15"
        "198.51.100.0/24"
        "203.0.113.0/24"
        "255.255.255.255/32"
        "192.0.0.0/24"
        "192.0.2.0/24"
        "127.0.0.0/8"
        "127.0.53.53"
        "192.168.0.0/16"
        "0.0.0.0/8"
        "172.16.0.0/12"
        "224.0.0.0/3"
        "192.88.99.0/24"
        "169.254.0.0/16"
        "198.18.140.0/24"
        "102.230.9.0/24"
        "102.233.71.0/24"
    )

    # Block each private IP range using iptables
    for ip_range in "${PRIVATE_IP_RANGES[@]}"; do
        iptables -A INPUT -s $ip_range -j DROP
    done

    # Save the iptables rules to make them persistent
    iptables-save > /etc/iptables/rules.v4

    echo "Private IP ranges for Hetzner blocked successfully."
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
            show_blocked_ip_ranges
            ;;
        5)
            block_private_ip_for_hetzner
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
