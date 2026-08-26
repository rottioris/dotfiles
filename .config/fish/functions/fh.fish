function fh
    history | fzf | read -l selected; and commandline --insert $selected
end
