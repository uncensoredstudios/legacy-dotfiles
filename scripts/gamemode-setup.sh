#!/usr/bin/env bash
# ═══════════════════════════════════════════
#  Legacy Dotfiles — Game Mode Optimizer
#  Применяется автоматически при старте Hyprland
# ═══════════════════════════════════════════

# CPU Governor → performance
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > "$cpu" 2>/dev/null
done

# Планировщик задач: MGLRU + swappiness low
echo 1 > /sys/kernel/mm/lru_gen/enabled 2>/dev/null
sysctl -w vm.swappiness=10            2>/dev/null
sysctl -w vm.vfs_cache_pressure=50    2>/dev/null
sysctl -w kernel.sched_autogroup_enabled=1 2>/dev/null

# Увеличить лимит файловых дескрипторов
ulimit -n 524288

# Compositor latency hint — снижает input lag
hyprctl keyword misc:vfr true 2>/dev/null

echo "✓ Game mode initialized"
