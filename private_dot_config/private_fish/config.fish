set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
fish_add_path /usr/local/sbin
fish_add_path /usr/local/sbin

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

