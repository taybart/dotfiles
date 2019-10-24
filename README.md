# Dotfiles

### Installation
`$ git clone https://github.com/taybart/dotfiles ~/.dotfiles`

`$ cd ~/.dotfiles && git submodule update --init --recursive`

### Scripts
There are a couple of scripts to get everything up and running.

Grab fzf and install it with `$ ./getfzf.sh`

Grab oh-my-zsh and install it with `$ ./getzsh.sh`

To symlink in the config folders and files use `$ ./makelinks.sh`

If running on a debian system `$ ./neovim_deps_deb.sh` will install the dependancies needed for an nvim install
