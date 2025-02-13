function command_exists() {
    command -v $1 &> /dev/null
}

function cdir() {
  mkdir $1
  cd $1
}
