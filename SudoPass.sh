#!/bin/bash

# SudoPass
# A simple password generator that allows users to choose between complex passwords (including letters, numbers, and symbols)
# or simpler variants (just letters and numbers), catering to different app and website requirements.

# Source: https://github.com/TarikSudo/SudoPass

# The directory path where passwords will be saved.
# You can modify the path according to your preference.
save_dir="$HOME/Documents"

# Function to generate a password with letters and numbers
generate_n() {
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $length
}

# Function to generate a password with letters, numbers, and symbols
generate_ns() {
    tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c $length
}

# Display the welcome message
echo ""
echo "Welcome to SudoPass"
echo ""

# Display the options
echo "How complex and secure do you want your password?"
echo ""
echo "1) Letters and Numbers (less complex)."
echo "2) Letters, Numbers, and Symbols (more secure and complex)."
echo ""

# Read the user input

while true; do
    read -p "Please enter your choice (1/2, default is 1):" mode
    mode=${mode:-1}
    echo ""
    if [[ "$mode" == "1" || "$mode" == "2" ]]; then
        while true; do
            read -p "Please enter the desired length for your password (between 6 and 32): " length
            echo ""
            if [[ "$length" =~ ^[0-9]+$ ]] && [ "$length" -ge 6 ] && [ "$length" -le 32 ]; then
                break # Valid length entered, exit the loop
            else
                echo "Invalid input."
            fi
        done
        break # Exit the mode selection loop
    else
        echo "Invalid choice."
    fi
done

# Generate the password
if [[ "$mode" == "1" ]]; then
    echo "Generating a simple password of length $length."
    echo ""
    password=$(generate_n $length)
elif [[ "$mode" == "2" ]]; then
    echo "Generating a complex password of length $length."
    echo ""
    password=$(generate_ns $length)
fi

# Display the password
echo "Your password is: $password"
echo ""

# Ask to save password
echo "Would you like to save this password? If it's the first time, a new password file will be created. Otherwise, the password will be added to the existing file."
echo ""
echo "1) Yes, save the password."
echo "2) No, do not save it."
echo ""

while true; do
    read -p "Please enter your choice (1/2, default is 2): " choice
    choice=${choice:-2}
    echo ""
    if [[ "$choice" == "1" || "$choice" == "2" ]]; then
        break
    else
        echo "Invalid choice."
    fi
done

# Exit or save password
if [[ "$choice" == "1" ]]; then
    # Ensure the directory exists
    [ ! -d "$save_dir" ] && mkdir -p "$save_dir"

    # Check if file exists and create with header if not
    if [ ! -f "$save_dir/SudoPass.csv" ]; then
        echo "name,url,username,password" >> "$save_dir/SudoPass.csv"
    fi

    # Append password to file
    echo ",,,$password" >> "$save_dir/SudoPass.csv"
    echo "Your password was saved successfully at $save_dir/SudoPass.csv, thanks for using SudoPass."
elif [[ "$choice" == "2" ]]; then
    echo "Thanks for using SudoPass."
fi

exit 0  # Successful completion
