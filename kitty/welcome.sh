#!/usr/bin/env bash
# Legacy Dotfiles — Terminal Welcome

# Colors (Gruvbox)
BG='\033[48;2;40;40;40m'
YEL='\033[38;2;215;153;33m'
ORG='\033[38;2;214;93;14m'
FG='\033[38;2;235;219;178m'
GRY='\033[38;2;146;131;116m'
RED='\033[38;2;204;36;29m'
GRN='\033[38;2;152;151;26m'
AQU='\033[38;2;104;157;106m'
RST='\033[0m'
BOLD='\033[1m'

clear
echo
printf "${YEL}${BOLD}"
cat << 'EOF'
  ██╗     ███████╗ ██████╗  █████╗  ██████╗██╗   ██╗
  ██║     ██╔════╝██╔════╝ ██╔══██╗██╔════╝╚██╗ ██╔╝
  ██║     █████╗  ██║  ███╗███████║██║      ╚████╔╝ 
  ██║     ██╔══╝  ██║   ██║██╔══██║██║       ╚██╔╝  
  ███████╗███████╗╚██████╔╝██║  ██║╚██████╗   ██║   
  ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝   ╚═╝  
EOF
printf "${RST}"
printf "${GRY}                        made in Legacy${RST}\n"
echo
printf "${GRY}  ─────────────────────────────────────────────────────${RST}\n"
printf "  ${FG}OS${RST}       ${YEL}$(uname -o) $(uname -m)${RST}\n"
printf "  ${FG}Kernel${RST}   ${YEL}$(uname -r)${RST}\n"
printf "  ${FG}Shell${RST}    ${AQU}$SHELL${RST}\n"
printf "  ${FG}Uptime${RST}   ${GRN}$(uptime -p | sed 's/up //')${RST}\n"
printf "  ${FG}CPU Load${RST} ${ORG}$(cut -d' ' -f1 /proc/loadavg)${RST}\n"
printf "  ${FG}RAM${RST}      ${RED}$(free -h | awk '/^Mem:/ {printf "%s / %s", $3, $2}')${RST}\n"
printf "${GRY}  ─────────────────────────────────────────────────────${RST}\n"
echo
