FROM golang:1.14.3-alpine

RUN apk update --no-cache
RUN apk add \
      neovim \
      bind-tools curl fd git \
      zsh bash

# Neovim deps
# RUN apk add nodejs
# RUN apk add python3 python3-dev && pip3 install --upgrade pip setuptools wheel neovim

# ENV
ENV ROOT /root
ENV GOPATH $ROOT/.go
ENV PATH $GOPATH/bin:$PATH

WORKDIR $ROOT

# shell
RUN mkdir -p .dotfiles/shell
ADD shell/zshrc .dotfiles/shell
ADD shell/zsh-prompt.zsh-theme .dotfiles/shell
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >> /dev/null

RUN rm $ROOT/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions $ROOT/.dotfiles/shell/zsh-plugins/zsh-autosuggestions
RUN git clone https://github.com/rupa/z $ROOT/.dotfiles/shell/z
RUN ln -s $ROOT/.dotfiles/shell/zshrc $ROOT/.zshrc

# nvim
RUN mkdir -p $ROOT/.config/nvim/colors
RUN mkdir -p $ROOT/.config/nvim/autoload

# ADD vim .dotfiles/vim
ADD vim/vimrcs/vimrc.triage $ROOT/.config/nvim/init.vim
ADD vim/plugin $ROOT/.config/nvim/plugin
ADD vim/colors/gruvbox.vim $ROOT/.config/nvim/colors

RUN curl -fLo ~/.config/nvim/autoload/plug.vim \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN nvim --headless +PlugInstall +qa

# Extra tools
RUN go get -u -ldflags "-w -s" github.com/taybart/fm
RUN go get -u -ldflags "-w -s" github.com/taybart/rest
