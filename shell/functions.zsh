# ~~ util ~~
function usingport {
  sudo ss -lptn "sport = :$1"
}

alias newpw="head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | fold -w 32 | head -n 1 | copy"

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
  [[ -z $1 ]] && kubectl config get-contexts || kubectl config use-context $1
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
  nvim main.go
  cd $ret
  read "remove?Delete sandbox? [Y/n] "
  if [[ "$remove" =~ ^[Yy]$ ]]; then
    rm -rf $folder
  else
    read "name?Name: "
    mkdir -p ~/dev/sandboxes
    mv $folder ~/dev/sandboxes/$name
  fi
}
