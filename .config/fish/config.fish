if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR nvim

abbr -a -- tn 'tmux new -s'
abbr -a -- vim nvim
abbr -a -- g git
abbr -a -- ta 'tmux attach -t'
abbr -a -- gs 'git status'
