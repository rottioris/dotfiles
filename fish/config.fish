set -g fish_greeting ''

if status is-interactive

    # Aliases
    alias grep "grep --color=auto"
    alias cat  "bat --style=plain --paging=never"
    alias ls "exa --group-directories-first"
    alias tree "exa -T"
    alias dotfile "git --git-dir $HOME/.dotfiles/ --work-tree $HOME"

    # Variables de entorno útiles
    set -x PAGER 'less'
    set -x EDITOR 'nvim'

    # Ejecutar fastfetch al inicio (puedes comentarlo si no quieres)
    # fastfetch

    # Inicialización del prompt starship
    starship init fish | source

    # Aquí puedes añadir otros comandos para sesiones interactivas

end
