FROM alpine

RUN apk update --no-cache
RUN apk add \
      bind-tools curl \
      zsh bash tmux \
      git \
      neovim \
      fzf fd \
      go nodejs python3 python3-dev
# Neovim deps
RUN pip3 install --upgrade pip setuptools wheel neovim

# ENV
ENV DIR /root
ENV GOPATH $DIR/.go
ENV PATH $GOPATH/bin:$PATH

WORKDIR $DIR
RUN git clone https://github.com/taybart/dotfiles .dotfiles


RUN curl -s https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | /bin/zsh

# shell
RUN rm  $DIR/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions $DIR/.dotfiles/shell/zsh-plugins/zsh-autosuggestions
RUN git clone https://github.com/rupa/z $DIR/.dotfiles/shell/z
RUN ln -s $DIR/.dotfiles/shell/zshrc $DIR/.zshrc
RUN touch $DIR/.zshrc.local

# tmux
RUN ln -s $DIR/.dotfiles/tmux.conf $DIR/.tmux.conf

# nvim
RUN rm -rf  $DIR/.vimrc $DIR/.vim
RUN ln -s $DIR/.dotfiles/vim/vimrc $DIR/.vimrc
RUN ln -s $DIR/.dotfiles/vim $DIR/.vim
RUN mkdir -p $DIR/.config
RUN ln -s $DIR/.dotfiles/vim $DIR/.config/nvim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qa

# Extra tools
RUN go get -u github.com/taybart/fm
RUN go get -u github.com/taybart/rest

