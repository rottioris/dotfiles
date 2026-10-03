#!/usr/bin/env python3

import subprocess
import os
from typing import Dict, List

CONFIG_DIR = os.path.expanduser("~/.config")

# =========================
# ICONOS
# =========================

I3_ICON = ""
NVIM_ICON = ""
ROFI_ICON = "󰍉"

# =========================
# SHORTCUTS
# =========================

menus: Dict[str, Dict[str, List[str]]] = {

    I3_ICON: {

        "󰝘  General": [
            "󰆍  SUPER + ENTER         Terminal",
            "󰣇  SUPER + SPACE         Rofi launcher",
            "󰋜  SUPER + Z             Shortcuts menu",
            "󰅖  SUPER + SHIFT + Q     Close window",
            "󰑐  SUPER + SHIFT + C     Reload config",
            "󰗼  SUPER + SHIFT + E     Power menu",
            "󰌾  SUPER + SHIFT + X     Lock screen",
            "  SUPER + B             Browser (Helium)",
            "  SUPER + D             File manager (Thunar)",
        ],

        "󰝘  Audio & Network": [
            "󰕾  SUPER + A             Audio menu",
            "󰖩  SUPER + N             Network menu",
        ],

        "󰝘  Layouts": [
            "󰊓  SUPER + F             Fullscreen",
            "󰕴  SUPER + V             Vertical split",
            "󰧪  SUPER + E             Layout toggle split",
            "󰹑  SUPER + T             Floating mode",
        ],

        "󰆾  Workspaces": [
            "󰎤  SUPER + 1-9           Change workspace",
            "󰁨  SUPER + SHIFT + 1-9   Move window",
        ],

        "󰒺  Movement": [
            "󰇘  SUPER + H             Focus left",
            "󰇛  SUPER + J             Focus down",
            "󰇚  SUPER + K             Focus up",
            "󰇙  SUPER + L             Focus right",
            "󰇘  SUPER + SHIFT + H     Move left",
            "󰇛  SUPER + SHIFT + J     Move down",
            "󰇚  SUPER + SHIFT + K     Move up",
            "󰇙  SUPER + SHIFT + L     Move right",
            "󰘐  SUPER + R             Resize mode",
        ],

        "󰄀  Media": [
            "󰄀  SUPER + P             Capture menu (screenshot + recording)",
        ],

        "  Audio": [
            "󰕾  XF86AudioRaiseVolume  Volume +10%",
            "󰕿  XF86AudioLowerVolume  Volume -10%",
            "󰝟  XF86AudioMute         Toggle mute",
            "󰍰  XF86AudioMicMute      Toggle mic mute",
        ],
    },

    NVIM_ICON: {

        "󰬐  Modes": [
            "󰏫  i                      Insert mode",
            "󰏫  a                      Insert after cursor",
            "󰏫  A                      Insert end of line",
            "󰜉  o                      New line below",
            "󰜉  O                      New line above",
            "󰌑  ESC                    Normal mode",
        ],

        "󰈔  Files": [
            "󰆓  :w                     Save file",
            "󰗼  :q                     Quit",
            "󰆓  :wq                    Save and quit",
            "󰗼  :q!                    Force quit",
            "󰆓  :x                     Save and quit",
        ],

        "󰒺  Movement": [
            "󰇘  h j k l                Move",
            "󰒭  w                      Next word",
            "󰒮  b                      Previous word",
            "󰘍  0                      Start line",
            "󰘌  $                      End line",
            "󰇙  gg                     Start file",
            "󰇚  G                      End file",
        ],

        "󰏫  Editing": [
            "󰕌  u                      Undo",
            "󰑎  CTRL+r                 Redo",
            "󰆏  yy                     Copy line",
            "󰆐  dd                     Delete line",
            "󰅌  p                      Paste",
            "󰗨  x                      Delete character",
        ],

        "󰍉  Search": [
            "󰍉  /text                  Search",
            "󰒭  n                      Next result",
            "󰒮  N                      Previous result",
            "󰍉  *                      Search current word",
        ],

        "󰈈  Visual": [
            "󰈈  v                      Visual mode",
            "󰈈  V                      Visual line",
            "󰈈  CTRL+v                 Visual block",
        ],

        "󰖲  Windows": [
            "󰕴  :split                 Horizontal split",
            "󰕵  :vsplit                Vertical split",
            "󰇙  CTRL+w h               Left window",
            "󰇛  CTRL+w j               Bottom window",
            "󰇚  CTRL+w k               Top window",
            "󰇘  CTRL+w l               Right window",
        ],

        "󰓩  Tabs": [
            "󰓩  :tabnew                New tab",
            "󰒭  gt                     Next tab",
            "󰒮  gT                     Previous tab",
        ],

        "󰱼  Telescope": [
            "󰱼  <leader>ff             Find files",
            "󰍉  <leader>fg             Live grep",
            "󰈙  <leader>fb             Buffers",
            "󰋖  <leader>fh             Help tags",
        ],

        "󰒋  LSP": [
            "󰊕  gd                     Go definition",
            "󰈇  gr                     References",
            "󰡱  gi                     Implementations",
            "󰋖  K                      Hover docs",
            "󰑕  <leader>rn             Rename",
            "󰌵  <leader>ca             Code action",
        ],

        "󰏖  Plugins": [
            "󰒲  :Lazy                  Plugin manager",
            "󰒋  :Mason                 LSP manager",
            "󰓦  :checkhealth           Diagnostics",
        ],
    },

    ROFI_ICON: {

        "󰘳  General": [
            "󰣇  SUPER + SPACE         App launcher",
            "󰗼  SUPER + SHIFT + E     Power menu",
            "󰋜  SUPER + Z             Shortcuts menu",
        ],

        "󰘳  Commands": [
            "󰣇  rofi -show drun       Desktop apps",
            "󰘳  rofi -show run        Run command",
            "󰖲  rofi -show window     Window switcher",
            "󰒓  rofi -show ssh        SSH launcher",
        ],

        "󰏌  Modes": [
            "󰣇  drun                  Applications",
            "󰘳  run                   Commands",
            "󰖲  window                Windows",
            "󰒓  ssh                   SSH sessions",
        ],
    },
}

# =========================
# LABELS
# =========================

labels = {
    I3_ICON: "  i3",
    NVIM_ICON: "  Neovim",
    ROFI_ICON: "󰍉  Rofi",
}

# =========================
# ROFI MENU
# =========================

def rofi_menu(
    options: List[str],
    prompt: str,
    horizontal: bool = False
) -> str:

    menu = "\n".join(options)

    command = [
        "rofi",
        "-dmenu",
        "-i",
        "-p",
        prompt,
        "-theme",
        f"{CONFIG_DIR}/rofi/shortcuts.rasi",
    ]

    # Menú principal horizontal
    if horizontal:
        command.extend([
            "-theme-str",
            """
            listview {
                columns: 3;
                lines: 1;
                spacing: 12px;
                scrollbar: false;
            }

            prompt {
                horizontal-align: 0.5;
            }

            element-text {
                horizontal-align: 0.5;
            }
            """
        ])

    result = subprocess.run(
        command,
        input=menu,
        capture_output=True,
        text=True,
    )

    return result.stdout.strip()


# =========================
# MAIN
# =========================

def main():

    main_choice = rofi_menu(
        list(menus.keys()),
        "Shortcuts",
        horizontal=True
    )

    if not main_choice:
        return

    category_choice = rofi_menu(
        list(menus[main_choice].keys()),
        labels[main_choice]
    )

    if not category_choice:
        return

    rofi_menu(
        menus[main_choice][category_choice],
        category_choice
    )


if __name__ == "__main__":
    main()