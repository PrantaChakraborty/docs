                                                                                                                                                                             
#!/bin/bash
# bash script to create ssh key and update the config file
# update teh SSH_DIR to your ssh directory
# Set SSH directory path as a variable
SSH_DIR=""

# Prompt for required information
echo "Enter a name for the SSH key and host: "
read name

echo "Enter the server IP address: "
read ip_address

echo "Enter the username for the server: "
read username

# Generate ED25519 key
ssh-keygen -t ed25519 -f "${SSH_DIR}/${name}_ed25519" -C "${username}@${name}"

# Set permissions for the new key files
chmod 600 "${SSH_DIR}/${name}_ed25519"
chmod 644 "${SSH_DIR}/${name}_ed25519.pub"

# Add configuration to existing SSH config
echo "
Host $name
    HostName $ip_address
    User $username
    IdentityFile ${SSH_DIR}/${name}_ed25519" >> "${SSH_DIR}/config"

# Display the public key
echo "SSH key generated and configuration updated successfully!"
echo "Public key content (copy this to your server's authorized_keys file):"
cat "${SSH_DIR}/${name}_ed25519.pub"
