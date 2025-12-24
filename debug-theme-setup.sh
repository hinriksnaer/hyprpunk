#!/bin/bash
# Debug theme and waybar setup

echo "========================================"
echo "THEME SETUP DEBUG"
echo "========================================"
echo ""

echo "1. Checking theme symlinks..."
echo "   ~/.config/fedpunk/current/theme:"
ls -la ~/.config/fedpunk/current/theme 2>&1
echo ""

echo "2. Checking Hyprland active-theme.conf..."
echo "   Content:"
cat ~/.config/hypr/active-theme.conf 2>&1
echo ""

echo "3. Checking waybar theme.css..."
echo "   Symlink:"
ls -la ~/.config/waybar/theme.css 2>&1
echo ""

echo "4. Checking if waybar is running..."
pgrep -a waybar
if [ $? -eq 0 ]; then
    echo "   ✓ Waybar is running"
else
    echo "   ✗ Waybar is NOT running"
fi
echo ""

echo "5. Checking waybar logs..."
journalctl --user -u waybar.service -n 20 --no-pager 2>/dev/null || echo "   No systemd logs (waybar may not be started via systemd)"
echo ""

echo "6. Trying to start waybar manually..."
waybar 2>&1 &
WAYBAR_PID=$!
sleep 2
if kill -0 $WAYBAR_PID 2>/dev/null; then
    echo "   ✓ Waybar started successfully (PID: $WAYBAR_PID)"
    kill $WAYBAR_PID 2>/dev/null
else
    echo "   ✗ Waybar failed to start"
fi
echo ""

echo "7. Checking Hyprland keybindings..."
echo "   Looking for theme-related keybindings:"
grep -r "SUPER.*T" ~/.config/hypr/ 2>/dev/null | grep -i theme
echo ""

echo "8. Checking if theme scripts are in PATH..."
which hyprpunk-theme-set 2>&1
which hyprpunk-rofi-theme-select 2>&1
echo ""

echo "9. Checking fedpunk themes directory..."
ls -la ~/.local/share/fedpunk/themes/ 2>&1 | head -15
echo ""
