#!/usr/bin/env zsh

source $HOME/.dotfiles/shell/alias.zsh

opon() {
  if [ -z $1 ]; then
    echo "missing required op name"
    return 1
  fi

  session=${(P)${:-OP_SESSION_${1}}}
  eval $(op signin $1)
}

opoff() {
  if [ -z $1 ]; then
    return 1
  fi
  op signout
  unset ${:-OP_SESSION_${1}}
}

getpwd() {
  account=$1
  shift
  opon $account || return 1
  op get item "$1" |jq -r '.details.fields[] |select(.designation=="password").value' | tr -d '\n' | copy
  opoff $account
}

sshkey() {
  account=$1
  shift
  opon $account || return 1
  echo "$(op get item "acg-master" |jq -r '.details.notesPlain')"|ssh-add -
  opoff $account
}

gittoken() {
  account=$1
  shift
  opon $account || return 1
  export GIT_TOKEN=$(op get item "GitHub"|jq -r '.details.sections[] | select(.fields).fields[] | select(.t== "Personal Laptop").v')
  opoff $account
}

getmfa() {
  account=$1
  shift
  opon $account || return 1
  op get totp "$1"
  opoff $account
}
