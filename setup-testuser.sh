#!/bin/bash
# Setup test user for hyprpunk testing

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

echo "Creating testuser..."

# Create user if it doesn't exist
if id "testuser" &>/dev/null; then
    echo "User 'testuser' already exists"
    read -p "Delete and recreate? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        userdel -r testuser 2>/dev/null || true
    else
        echo "Exiting..."
        exit 0
    fi
fi

# Create test user with home directory and wheel group
useradd -m -G wheel -s /bin/bash testuser

# Set password
echo "testuser:testuser" | chpasswd

# Ensure wheel group has sudo access (might already be configured)
if ! grep -q "^%wheel.*NOPASSWD.*ALL" /etc/sudoers; then
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    echo "Added wheel group to sudoers"
else
    echo "Wheel group already has sudo access"
fi

# Copy hyprpunk repository to testuser home
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Copying hyprpunk repository to /home/testuser/hyprpunk..."
cp -r "$REPO_DIR" /home/testuser/hyprpunk
chown -R testuser:testuser /home/testuser/hyprpunk

# Copy test script to testuser home
cp "$REPO_DIR/test-installation.sh" /home/testuser/
chown testuser:testuser /home/testuser/test-installation.sh
chmod +x /home/testuser/test-installation.sh

echo ""
echo "✓ Test user created successfully!"
echo ""
echo "To switch to testuser:"
echo "  sudo -u testuser -i"
echo ""
echo "To run tests as testuser:"
echo "  sudo -u testuser /home/testuser/test-installation.sh"
echo ""
echo "Username: testuser"
echo "Password: testuser"
