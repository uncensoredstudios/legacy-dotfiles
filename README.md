# Legacy Dotfiles
### Arch / EndeavourOS · Hyprland · Gruvbox Dark

```
  ██╗     ███████╗ ██████╗  █████╗  ██████╗██╗   ██╗
  ██║     ██╔════╝██╔════╝ ██╔══██╗██╔════╝╚██╗ ██╔╝
  ██║     █████╗  ██║  ███╗███████║██║      ╚████╔╝ 
  ██║     ██╔══╝  ██║   ██║██╔══██║██║       ╚██╔╝  
  ███████╗███████╗╚██████╔╝██║  ██║╚██████╗   ██║   
  ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝   ╚═╝  
                          made in Legacy
```

---

## Стек

| Компонент | Программа |
|-----------|-----------|
| ОС | Arch Linux / EndeavourOS |
| Compositor | Hyprland |
| Bar | Waybar (floating, Gruvbox) |
| Launcher | Rofi (rofi-wayland) |
| Terminal | Kitty |
| Shell | Zsh + Starship |
| Notifications | Dunst |
| Lockscreen | Hyprlock |
| Idle | Hypridle |
| FPS Overlay | MangoHud |
| Wallpaper | swww |
| Theme | Gruvbox Dark |

---

## Установка за 4 команды

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/uncensoredstudios/legacy-dotfiles/main/install.sh)"
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

---

## Функции

### 🎨 Визуал
- **Liquid Glass** — многослойное блюр + прозрачность на всех окнах
- **Floating Waybar** — парящая панель с Gruvbox и скруглёнными углами
- **Плавные анимации** — spring-анимации открытия/закрытия, slide для воркспейсов
- **Тёплая Gruvbox** тема — GTK, курсор, иконки

### 🎮 Гейминг
- CPU governor → `performance` при старте
- `allow_tearing = true` для минимального инпут-лага
- MangoHud FPS оверлей (toggle: `Super+G`)
- `MANGOHUD=1` автоматически для всех игр

### 🔧 Горячие клавиши

| Комбинация | Действие |
|------------|----------|
| `Super+Enter` | Kitty terminal |
| `Super+R` | Rofi launcher |
| `Super+Q` | Закрыть окно |
| `Super+F` | Fullscreen |
| `Super+L` | Заблокировать экран |
| `Super+G` | FPS overlay toggle |
| `Super+Shift+R` | Быстрый выбор разрешения |
| `Super+Shift+S` | Снапшот системы |
| `Super+B` | Toggle Waybar |
| `Super+C` | Clipboard history |
| `Print` | Screenshot → clipboard |

### 🔊 Звук / медиа
- PipeWire + WirePlumber
- Уведомления о громкости со звуком
- Waybar: трек + управление плеером (scroll)
- `XF86Audio*` клавиши работают

### 🔒 Экран блокировки
- Hyprlock с размытым фоном
- Большие часы центре
- Системная инфа (CPU/RAM)
- Плавный fade-in

### 📸 Снапшоты
- `Super+Shift+S` → Timeshift/Snapper меню
- Создание, просмотр, откат

---

## Структура

```
~/.dotfiles/
├── install.sh          ← главный установщик
├── hyprland/
│   ├── hyprland.conf
│   └── hypridle.conf
├── waybar/
│   ├── config.jsonc
│   ├── style.css
│   ├── gruvbox.css
│   └── scripts/
├── kitty/
│   ├── kitty.conf
│   └── welcome.sh
├── dunst/dunstrc
├── hyprlock/hyprlock.conf
├── rofi/
│   ├── config.rasi
│   └── gruvbox.rasi
├── scripts/
│   ├── gamemode-setup.sh
│   ├── resolution-picker.sh
│   ├── fps-toggle.sh
│   ├── volume-notify.sh
│   └── system-snapshot.sh
└── config/
    ├── MangoHud/MangoHud.conf
    └── gtk-3.0/settings.ini
```
