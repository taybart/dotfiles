
# ~~ util ~~

function cdir() {
  mkdir $1
  cd $1
}

# bring up configs
function config {
  read "t?[sh/vi] "
  case "${t}" in
    'sh')
      nvim ~/.dotfiles/shell
      ;;
      *)
      cd ~/.config/nvim && nvim init.vim
  esac
}

function tunnel {
  echo "forwarding $1..."
  \ssh -o "ExitOnForwardFailure yes" -i ~/ssh_cp/ssh_cp/id_ed25519 -N -R 9000:localhost:$1 root@$TUNNEL 
}

# find and replace
function far() {
  if [ $# -lt 2 ]; then
    echo "usage $0 ./dir \"match in .* files\" \"s:match:replace:g\""
    return 1
  fi
  dir=$1
  search=$2

  if [ $# -eq 3 ]; then
    far=$3
    if [ "$(uname)" = "Darwin" ]; then
      rg $search $dir --files-with-matches | xargs sed -i '' $far
    else
      rg $search $dir --files-with-matches | xargs sed -i $far
    fi
  else
    rg $search $dir
  fi
}

# toggle do-not-disturb
function dnd() {
  if [ "$1" != "" ]; then
    if [[ "$1" =~ "^true|false$" ]]; then
      xfconf-query -c xfce4-notifyd -p /do-not-disturb -s $1
      return
    else
      echo "unknown parameter $1"
      return
    fi
  fi
  is_dnd=$(xfconf-query -c xfce4-notifyd -p /do-not-disturb)
  if [ "$is_dnd" = "true" ]; then
    xfconf-query -c xfce4-notifyd -p /do-not-disturb -s false
    notify-send "dnd off"
    echo "🔔"
  else
    xfconf-query -c xfce4-notifyd -p /do-not-disturb -s true
    echo "🔕"
  fi
}

function notes() {
  local_notes_dir=~/.cloud_notes
  cloud_notes_dir=tb/taybart/notes
  if [ "$1" = "-pull" ]; then
    mcli cp --recursive $cloud_notes_dir/ $local_notes_dir
  elif [ "$1" = "-push" ]; then
    mcli cp --recursive $local_notes_dir/ $cloud_notes_dir
    return
  else
    mcli cp --recursive $cloud_notes_dir/ $local_notes_dir
    if [ -z $1 ]; then
      nvim $local_notes_dir/$(\ls $local_notes_dir | fzf)
    else
      nvim $local_notes_dir/$1
    fi
    mcli cp --recursive $local_notes_dir/ $cloud_notes_dir
  fi
}

function gitclean() {
  git remote prune origin
  DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git branch --merged $DEFAULT_BRANCH | \grep -v $DEFAULT_BRANCH | xargs -n 1 git branch -d
}


function envup {
  # select .env or .env.$1 initally
  file=$([ -z "$1" ] && echo ".env" || echo ".env.$1")
  # weird file name passed with -f
  [ "$1" = "-f" ] && shift && file=$1

  if [ -f "$file" ]; then
    # make lines conform
    IFS=$'\n'
    env_vars=($(sed '/^#.*/d; /^[[:space:]]*$/d; s/^export //' $file))
    for v in $env_vars; do
      eval export $v
    done
  else
    echo "$file does not exist"
    return 1
  fi
}

function formatenv {
  sed -i '/^#.*/d; /^[[:space:]]*$/d; s/^export //' $1
}

function kp {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
    kp
  fi
}

function usingport {
  if [[ $(uname) == "Darwin" ]]; then
    if [[ $2 == "-kill" ]]; then
      lsof -t -i":$1" | xargs kill -9
    else
      lsof -i":$1"
    fi
  else
    if [[ $2 == "-kill" ]]; then
      sudo ss -lptn "sport = :$1" | rg -o "pid=(\d+)" -r '$1' | xargs kill -9
    else
      sudo ss -lptn "sport = :$1"
    fi
  fi
}

function copyrand() {
  charset='a-zA-Z0-9~!@#$%^&*_-'
  size=32

  if [ ! -z $1 ]; then
    size=$1
  fi

  if [ ! -z $2 ]; then
    case "$2" in
      alpha)    charset='a-zA-Z' ;;
      alphanum) charset='a-zA-Z0-9' ;;
      graph)    charset='A-Za-z0-9!#$%&()*+,\-./:;<=>?@[\\\]^_`{|}~' ;;
      base64)   charset='__base64__' ;;
      hex)      charset='0-9a-f' ;;
      *)        charset=$1 ;;
    esac
  fi

  if [ $charset = '__base64__' ]; then
    head -c $size /dev/urandom | base64 | copy
  else
    head /dev/urandom | tr -dc "$charset" | fold -w $size | head -n 1 | tr -d '\n' | copy
  fi
}

function biggest() {
  du -a $1 | sort -n -r | head -n 5
}

function whereisip() {
  curl ipinfo.io/$1
}

function b64 {
  if [ "$1" = "-d" ]; then
    echo -n $2 | base64 -d
  else
     base64 -w 0 $1 | copy
  fi
}

# ~~ rest ~~
function restsb() {
  if [ -d './.rest' ]; then
    nvim ./.rest/*.rest
    return
  fi
  mkdir -p $HOME/.tmp
  nvim $HOME/.tmp/sandbox.rest
}

# ~~ kubernetes ~~
function kcxt() {
  if [[ -z $1 ]]; then
    kubectl config get-contexts | awk '/^[^*|current]/{print $1} /^\*/{print "\033[1;32m" $2 "\033[0m "}'
  elif [ $1 = "-current" ]; then
    kubectl config get-contexts | awk '/^\*/{print $2}'
  else
    kubectl config use-context $1
  fi
}

function kc() {
  if [ $# != 0 ]; then
    if [ $(kcxt -current) = "production" ]; then
      echo "WARNING: in production context"
    fi
    kubectl $@
    return $?
  fi
  ns=default
  while read "cmd?-> "; do
    if [[ "$cmd" =~ "ns (.*)" ]]; then
      ns=$match[1]
      echo "switched namepace to $ns"
    else
      eval "kubectl -n $ns $cmd"
    fi
  done
}

function testREPL() {
  local HISTFILE
  # -p push history list into a stack, and create a new list
  # -a automatically pop the history list when exiting this scope...
  HISTFILE=$HOME/.tmp/zshscripthist
  fc -ap # read 'man zshbuiltins' entry for 'fc'

  while IFS="" vared -p "input> " -c line; do
    echo $line
    print -S $line # places $line (split by spaces) into the history list...
    line=
  done
}

# function kcxt() {
#   if [[ -z $1 ]]; then
#       kubectl config get-contexts | awk '/^[^*|CURRENT]/{print $1} /^\*/{print "\033[1;32m" $2 "\033[0m "}'
#   elif [[ $# -ge 1 ]]; then
#     case "$1" in
#       "ns" | "namespace" | "-ns" | "-namespace")
#         kubectl config set-context --current --namespace="$2"
#       ;;
#       *)
#         kubectl config use-context "$1"
#       ;;
#     esac
#   fi
# }

function triage() {
  namespace=${1:-default}

  config=https://raw.githubusercontent.com/taybart/dotfiles/master/triage.yaml
  kubectl apply -n $namespace -f $config
  msg="waiting for pod"
  waittime=0
  echo -n "$msg ${waittime}s"
  while [[ $(kubectl get -n $namespace pod/triage -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 1
    ((waittime++))
    printf "\r$msg ${waittime}s"
  done
  printf "\n"

  kubectl exec -n $namespace -ti triage -- /bin/zsh
  kubectl delete -n $namespace -f $config
}

function addRedisTo() {
  if [[ -z $1 ]]; then
    echo "Namespace required"
  fi
  helm install -n $1 redis bitnami/redis --set cluster.enabled=false --set usePassword=false
}

# ~~ go ~~
function gobuildall() {
  GOOS=linux go build -ldflags '-s -w' -o $2_linux $1
  GOOS=darwin go build -ldflags '-s -w' -o $2_darwin  $1
  GOOS=windows go build -ldflags '-s -w' -o $2_windows.exe $1
}

function sb() {
  ret=$(pwd)
  r=$(head -c 8 /dev/random | base64 | tr -d '/')
  folder=~/.tmp/sandbox_$r
  mkdir -p $folder
  cd $folder
  # create project
  if [[ $1 == "node" ]]; then
    echo '{"name":"sandbox","version":"1.0.0","description":"sandybox","main":"index.js", "license": "UNLICENSED","scripts":{"start":"node ."}}' > package.json
    touch index.js
    nvim index.js
  elif [[ $1 == "wapp" ]]; then
  else
    go mod init sandbox
    echo "package main\n\nfunc main() {\n}" > main.go
    nvim -c 'exe "normal jj"' main.go
  fi

  cd $ret
  read "keep?Keep sandbox? [y/N] "
  if [[ "$keep" =~ ^[Yy]$ ]]; then
    read "name?Name: "
    mkdir -p ~/dev/sandboxes
    mv $folder ~/dev/sandboxes/$name
  else
    rm -rf $folder
  fi
}

function gosb() {
  echo "[WARN] deprecated, use sb instead"
  ret=$(pwd)
  r=$(head -c 8 /dev/random | base64 | tr -d '/')
  folder=~/.tmp/sandbox_$r
  mkdir -p $folder
  cd $folder
  go mod init sandbox
  echo "package main\n\nfunc main() {\n}" > main.go
  nvim -c 'exe "normal jj"' main.go
  cd $ret
  read "keep?Keep sandbox? [y/N] "
  if [[ "$keep" =~ ^[Yy]$ ]]; then
    read "name?Name: "
    mkdir -p ~/dev/sandboxes
    mv $folder ~/dev/sandboxes/$name
  else
    rm -rf $folder
  fi
}

