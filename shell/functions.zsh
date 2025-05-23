source "$DOTFILES/shell/essentials.zsh"

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

function tab-title {
  printf "\x1b]1;>$1\x1b\\"
}

function tunnel {
  echo "forwarding $1..."
  # \ssh root@$TUNNEL 'pkill -o -u root sshd'
  \ssh -o "ExitOnForwardFailure yes" -N -R 9000:localhost:$1 root@$TUNNEL
}

function send {
  local ssh_pid
  local server_pid
  local cwd=$(pwd)

  mkdir -p ~/.send_server
  cd ~/.send_server

  # Setup trap to handle interrupts (SIGINT)
  trap 'echo "Shutting down tunnel and server..."; kill $ssh_pid $server_pid 2>/dev/null; cd $cwd' INT TERM

  \ssh -o "ExitOnForwardFailure yes" -N -R 9002:localhost:12000 root@$TUNNEL &
  ssh_pid=$!
  ~/.local/bin/send_server &
  server_pid=$!
  echo "listening for files... ssh: $ssh_pid server: $server_pid"

  wait $ssh_pid $server_pid

  trap - INT TERM
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
  mkdir -p ~/.notes && touch ~/.notes/new
  note=$(\ls ~/.notes | fzf)
  if [ "$note" = "new" ]; then
    read "note?Name: "
  fi
  if [ ! -z "$note" ]; then
    nvim ~/.notes/$note
  fi
}

function cnotes() {
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
  do_paths=false
  if [ "$1" = "paths" ]; then
    do_paths=true; shift
  fi
  # select .env or .env.$1 initally
  file=$([ -z "$1" ] && echo ".env" || echo ".env.$1")
  # weird file name passed with -f
  [ "$1" = "-f" ] && shift && file=$1

  if [ ! -f "$file" ]; then
    echo "$file does not exist"
    return 1
  fi

  # make lines conform
  IFS=$'\n'
  # clean file
  env_vars=($(sed '/^#.*/d; /^[[:space:]]*$/d; s/^export //' $file))
  for v in $env_vars; do
    eval export $v
  done

  # expand vars with *_PATH and base64 encode
  if [ do_paths ]; then
    # filter vars with *_PATH
    pattern="*_PATH*"
    path_vars=(${(M)env_vars:#$~pattern})
    for v in $path_vars; do
      # split on =
      sp=( ${(@s/=/)v} )
      # remove _PATH
      clean=${sp[1]%?????}
      filepath="$(printenv $sp[1])"
      if [ ! -f $filepath ]; then
        echo "$filepath doesn't exist"; return 1
      fi
      eval export $clean="$(cat $filepath | base64)"
    done
  fi

}

function formatenv {
  sed -i '/^#.*/d; /^[[:space:]]*$/d; s/^export //' $1
}

function kp {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
    echo "killed $pid"
    # kp
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
    head /dev/urandom | LC_CTYPE=C LANG=C tr -dc "$charset" | fold -w $size | head -n 1 | tr -d '\n' | copy
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

# ~~ docker ~~
function ciddocker() {
  docker ps | tail -n +2 | fzf | awk '{print $1}'
}
function rundocker() {
  docker run --rm "$@" $(docker build -q .)
}

function shdocker() {
  CID=$1
  if [[ -z $1 ]]; then
    CID=$(ciddocker)
  fi
  docker exec -it $CID /bin/sh
}

function killdocker() {
  CID=$(ciddocker)
  if [[ "$CID" != "" ]]; then
    docker kill $CID
  fi
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
  if [ "$#" -ne 2 ]; then
    echo "usage: $0 {dir} {name}"
    return
  fi
oses=('linux' 'darwin' 'windows')
arches=('arm' 'arm64' 'amd64')
  for os in $oses; do
    for arch in $arches; do
      if [[ $os == "darwin" && $arch == "arm" ]]; then
        continue
      fi
      echo "building ${2}_${os}_${arch}"
      GOOS=$os GOARCH=$arch go build -ldflags '-s -w' -o "${2}_${os}_${arch}" $1
    done
  done
}

function sb() {
  ret=$(pwd)
  r=$(head -c 8 /dev/random | base64 | tr -d '/')
  folder=~/.tmp/sandbox_$r
  mkdir -p $folder
  cd $folder
  # create project
  if [[ $1 == "node" ]]; then
    echo '{"name":"sandbox","version":"1.0.0","description":"sandybox","main":"index.mjs", "license": "UNLICENSED","scripts":{"start":"node ."}}' > package.json
    touch index.mjs
    nvim index.mjs
  elif [[ $1 == "bun" || $1 == "ts" ]]; then
    bun init
    nvim index.ts
  elif [[ $1 == "rust" ]]; then
    cargo init --name sandbox .
    nvim src/main.rs
  elif [[ $1 == "python" ]]; then
    touch main.py
    python3 -m venv .venv
    source ./.venv/bin/activate
    nvim main.py
    deactivate
  else
    go mod init sandbox
    echo "package main\n" > main.go
    echo "import (\"fmt\"\n\"os\")" >> main.go
    echo "func main() {" >> main.go
    echo "if err := run(); err != nil{" >> main.go
    echo 'fmt.Fprintf(os.Stderr, "%v\\n",err)\nos.Exit(1)}}' >> main.go
    echo "func run() error {\nreturn nil\n}" >> main.go
    go fmt main.go
    nvim -c 'exe "15"' main.go
  fi

  cd $ret
  read "keep?Keep sandbox? [y/N] "
  if [[ "$keep" =~ ^[Yy]$ ]]; then
    while [ "$name" = "" ] ; do
      read "name?Name: "
    done
    mkdir -p ~/dev/sandboxes
    mv $folder ~/dev/sandboxes/$name
  else
    rm -rf $folder
  fi
}

# ~~ llm ~~
function llm() {
  if command_exists ollama; then
    if [[ "$1" == "local" ]]; then
      export OLLAMA_HOST="localhost:11434"
    fi
    if [ -f ~/.llm ]; then
      pref=$(cat ~/.llm)
      if [ ! -z $pref ]; then
        read "use_pref?Use $pref [Y/n] "
        if [[ "$use_pref" =~ ^[Yy]$ || "$use_pref" == "" ]]; then
          selected_model=$pref
          ollama run $pref
          return
        fi
      fi
    fi
    selected_model=$1
    if [ -z $1 ]; then
      models=($(ollama list | sed '1d' | awk '{print $1}'))
      select model in $models; do
          if [[ -n $model ]]; then
              selected_model=$model
              break
          fi
      done
    fi
    if [[ "$pref" != "$selected_model" ]]; then
      read "save?Save $selected_model as as default? [Y/n] "
      if [[ "$save" =~ ^[Yy]$ || "$save" == "" ]]; then
        echo $selected_model > ~/.llm
      fi
    fi
    if [ ! -z $selected_model ]; then
      ollama run $selected_model
    fi
  fi
}

