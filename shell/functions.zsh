
# ~~ util ~~
function dotenv {
  if [ -f "./.env" ]; then
    eval $(egrep -v '^#' .env | xargs) $@
  else
    echo "No .env file exits"
    exit 1
  fi
}
function usingport {
  sudo ss -lptn "sport = :$1"
}

function copyrand() {
  charset='a-zA-Z0-9~!@#$%^&*_-'
  size=32
  if [ ! -z $1 ]; then
    charset=$1
  fi

  if [ ! -z $2 ]; then
    size=$2
  fi
  head /dev/urandom | tr -dc "$charset" | fold -w $size | head -n 1 | tr -d '\n' | copy
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
  mkdir -p $HOME/.tmp
  nvim $HOME/.tmp/sandbox.rest
}

# ~~ kubernetes ~~
function kcxt() {
  if [[ -z $1 ]]; then
    kubectl config get-contexts | awk '/^[^*|CURRENT]/{print $1} /^\*/{print "\033[1;32m" $2 "\033[0m "}'
  else
    kubectl config use-context $1
  fi
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

function gosb() {
  ret=$(pwd)
  r=$(head -c 8 /dev/random | base64)
  folder=~/.tmp/sandbox_$r
  mkdir -p $folder
  cd $folder
  go mod init sandbox
  echo "package main\n\nfunc main() {\n}" > main.go
  nvim -c 'exe "normal jj"' main.go
  cd $ret
  read "remove?Delete sandbox? [Y/n] "
  if [[ "$remove" =~ ^[Nn]$ ]]; then
    read "name?Name: "
    mkdir -p ~/dev/sandboxes
    mv $folder ~/dev/sandboxes/$name
  else
    rm -rf $folder
  fi
}
