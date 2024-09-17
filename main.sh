#!/bin/bash

generate_ipv4() {
    first_octet=66
    second_octet=$((RANDOM % 256))
    third_octet=$((RANDOM % 256))
    fourth_octet=$((RANDOM % 256))
    
    echo "${first_octet}.${second_octet}.${third_octet}.${fourth_octet}"
}

# Function to ping the IPv4 address and capture the response time
ping_address() {
    local address=$1
    local response_time=$(ping -c 1 -W 1 "$address" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
    
    if [[ -z "$response_time" ]]; then
        echo "Ping failed"
    else
        echo "Response time: $response_time ms"
    fi
}

# Function to generate realistic usage statistics
generate_realistic_stats() {
    local days=$(( (RANDOM % 730) + 1 ))
    local data_gb=$(( (RANDOM % 491) + 10 ))
    local avg_latency=$(( (RANDOM % 50) + 1 ))
    
    echo "$days days, $data_gb GB, avg latency $avg_latency ms"
}

# Function to save output to a file
save_output() {
    echo -e "$1" >> output.txt
}

# Main function to generate IPv4 addresses, ping them, and display statistics
main() {
    # Check if the output file exists and back it up
    if [ -f output.txt ]; then
        mv output.txt output_backup.txt
        echo "Previous output backed up to output_backup.txt"
    fi
    
    for i in {1..10}; do
        ipv4_address=$(generate_ipv4)
        echo "IPv4 Address: $ipv4_address"
        
        # Ping the IPv4 address
        ping_result=$(ping_address "$ipv4_address")
        
        # Get realistic usage statistics
        usage_stats=$(generate_realistic_stats)
        
        # Compose the output
        output="IPv4 Address: $ipv4_address\n$ping_result\nRealistic Usage Period and Data Volume: $usage_stats\n---\n"
        
        # Display the results
        echo -e "$output"
        
        # Save the results to a file
        save_output "$output"
    done
    
    echo "IPv4 generation and statistics completed. Results saved to output.txt"
}

# Call the main function
main
