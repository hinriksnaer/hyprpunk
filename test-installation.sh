#!/bin/bash
# Comprehensive Hyprpunk Installation Test
# Tests all aspects of installation without GUI

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0
WARNINGS=0

function pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++)) || true
}

function fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++)) || true
}

function warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++)) || true
}

function section() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
}

section "INSTALLING HYPRPUNK"
fedpunk profile deploy --mode laptop /home/testuser/hyprpunk

section "TEST 1: FISH SHELL"
if command -v fish >/dev/null 2>&1; then
    pass "Fish executable found"
else
    fail "Fish executable not found"
fi

if command -v starship >/dev/null 2>&1; then
    pass "Starship found"
else
    fail "Starship not found"
fi

section "TEST 2: THEME MANAGER SCRIPTS DEPLOYMENT"
THEME_SCRIPTS=(
    "hyprpunk-theme-current"
    "hyprpunk-theme-list"
    "hyprpunk-theme-next"
    "hyprpunk-theme-prev"
    "hyprpunk-theme-refresh"
    "hyprpunk-theme-set"
    "hyprpunk-theme-set-desktop"
    "hyprpunk-theme-set-terminal"
    "hyprpunk-wallpaper-next"
    "hyprpunk-wallpaper-set"
)

for script in "${THEME_SCRIPTS[@]}"; do
    if [ -f "$HOME/.local/bin/$script" ]; then
        pass "Script deployed: $script"
    else
        fail "Script NOT deployed: $script"
    fi
done

section "TEST 3: ROFI SCRIPTS DEPLOYMENT"
ROFI_SCRIPTS=(
    "hyprpunk-rofi-theme-select"
    "hyprpunk-rofi-wallpaper-select"
)

for script in "${ROFI_SCRIPTS[@]}"; do
    if [ -f "$HOME/.local/bin/$script" ]; then
        pass "Script deployed: $script"
    else
        fail "Script NOT deployed: $script"
    fi
done

section "TEST 4: THEME INITIALIZATION"
# Check for deployed themes directory
if [ -d "$HOME/.local/share/fedpunk/themes" ]; then
    THEME_COUNT=$(ls -1 "$HOME/.local/share/fedpunk/themes" 2>/dev/null | wc -l)
    if [ $THEME_COUNT -gt 0 ]; then
        pass "Themes deployed: $THEME_COUNT themes"
    else
        warn "Themes directory exists but is empty"
    fi
else
    # Check for profile themes in various possible locations
    if [ -d "/home/testuser/hyprpunk/themes" ]; then
        THEME_COUNT=$(ls -1 "/home/testuser/hyprpunk/themes" 2>/dev/null | wc -l)
        pass "Profile themes found: $THEME_COUNT themes (source repository)"
    elif [ -d "$HOME/.local/share/fedpunk/cache/external/github.com/hinriksnaer/hyprpunk/themes" ]; then
        THEME_COUNT=$(ls -1 "$HOME/.local/share/fedpunk/cache/external/github.com/hinriksnaer/hyprpunk/themes" 2>/dev/null | wc -l)
        pass "Profile themes found: $THEME_COUNT themes (cached)"
    else
        fail "No themes found"
    fi
fi

# Check theme symlink
if [ -L "$HOME/.config/fedpunk/current/theme" ]; then
    THEME=$(basename $(readlink -f "$HOME/.config/fedpunk/current/theme" 2>/dev/null) 2>/dev/null)
    if [ -n "$THEME" ]; then
        pass "Theme symlink exists: $THEME"
    else
        warn "Theme symlink exists but target not found"
    fi
else
    warn "Theme symlink not created (may be created on first Hyprland login)"
fi

section "TEST 5: THEME COMMANDS FUNCTIONALITY"
export PATH="$HOME/.local/bin:$PATH"

if hyprpunk-theme-list >/dev/null 2>&1; then
    THEMES=$(hyprpunk-theme-list | wc -l)
    pass "hyprpunk-theme-list works: $THEMES themes"
else
    fail "hyprpunk-theme-list FAILED"
fi

if hyprpunk-theme-current >/dev/null 2>&1; then
    CURRENT=$(hyprpunk-theme-current)
    pass "hyprpunk-theme-current works: $CURRENT"
else
    fail "hyprpunk-theme-current FAILED"
fi

section "TEST 6: HYPRLAND CONFIG FILES"
HYPR_CONFIGS=(
    "hyprland.conf"
    "active-theme.conf"
    "active-mode.conf"
    "monitors.conf"
    "workspaces.conf"
)

for config in "${HYPR_CONFIGS[@]}"; do
    if [ -f "$HOME/.config/hypr/$config" ]; then
        pass "Config exists: $config"
    else
        fail "Config NOT found: $config"
    fi
done

section "TEST 7: WAYBAR CONFIG"
if [ -L "$HOME/.config/waybar/config" ]; then
    pass "Waybar config symlinked"
else
    fail "Waybar config NOT symlinked"
fi

if [ -L "$HOME/.config/waybar/style.css" ]; then
    pass "Waybar style.css symlinked"
else
    fail "Waybar style.css NOT symlinked"
fi

section "TEST 8: ACTIVE THEME CONFIG"
if [ -f "$HOME/.config/hypr/active-theme.conf" ]; then
    if grep -q "source.*hyprland.conf" "$HOME/.config/hypr/active-theme.conf"; then
        pass "Active theme config has theme source"
    else
        warn "Active theme config exists but may not have theme source"
        cat "$HOME/.config/hypr/active-theme.conf"
    fi
else
    fail "Active theme config NOT created"
fi

section "TEST 9: PATH CONFIGURATION"
if [ -f "$HOME/.config/hypr/conf.d/env.conf" ]; then
    if grep -q "env = PATH" "$HOME/.config/hypr/conf.d/env.conf"; then
        pass "Hyprland PATH configured"
    else
        warn "Hyprland env.conf exists but PATH may not be set"
    fi
else
    fail "Hyprland env.conf NOT found"
fi

section "TEST 10: CLI THEME SELECTION"
echo "Testing: fedpunk theme select (will auto-select first theme)"
if echo "1" | fedpunk theme select >/dev/null 2>&1; then
    pass "fedpunk theme select works"
else
    fail "fedpunk theme select FAILED"
fi

section "TEST SUMMARY"
echo "======================================"
echo -e "${GREEN}PASSED:${NC}   $PASSED"
echo -e "${YELLOW}WARNINGS:${NC} $WARNINGS"
echo -e "${RED}FAILED:${NC}   $FAILED"
echo "======================================"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}ALL TESTS PASSED!${NC}"
    exit 0
else
    echo -e "${RED}SOME TESTS FAILED!${NC}"
    exit 1
fi
