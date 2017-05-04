#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null

# set up color commands
if [ -t 1 -a -t 2 -a \( `type -t tput` = "file" \) ]; then
  _colors=`tput colors`
  if [ "$_colors" -ge 256 ]; then
    INFO () { tput setaf 33;  /bin/echo "$@"; tput sgr0; }
    OK   () { tput setaf 28;  /bin/echo "$@"; tput sgr0; }
    WARN () { tput setaf 226; /bin/echo "$@"; tput sgr0; }
    ERR  () { tput setaf 196; /bin/echo "$@"; tput sgr0; }
  else
    INFO () { tput setaf 4; /bin/echo "$@"; tput sgr0; }
    OK   () { tput setaf 2; /bin/echo "$@"; tput sgr0; }
    WARN () { tput setaf 3; /bin/echo "$@"; tput sgr0; }
    ERR  () { tput setaf 1; /bin/echo "$@"; tput sgr0; }
  fi
else
  INFO () { /bin/echo "$@"; }
  OK   () { /bin/echo "$@"; }
  WARN () { /bin/echo "$@"; }
  ERR  () { /bin/echo "$@"; }
fi


function get_web_getter() {
  # get a getter
  if [ \! -z `type -t curl` ]; then
    GET="curl --silent --location --compressed -O"
  elif [ \! -z `type -t wget` ]; then
    GET="wget --quiet"
  else
    ERR "No getter (curl/wget)"
    exit 1
  fi
  OK Getter is \"$GET\"
}

function check_for_tools() {
  INFO -n 'Tools: '
  for tool in $@; do
    if [ -x `type -t $tool` ]; then
      WARN -n No $tool
    else
      INFO -n "$tool "
    fi
  done
  OK ok.
}

function load_submodule() {
  INFO Load "$1"
  git submodule init $1
  git submodule sync $1
  git submodule update $1
}

function check_for() {
  if [ ! -x `which $1` ]
  then
    ERR "$1 binary not found. $2"
    if [ "non-fatal" -ne "$3" ]
    then
      exit 1
    fi
  fi
}

function check_for_crystal() {
  check_for "crystal" "Please see http://crystal-lang.org/docs/installation/index.html" "$1"
}

function check_for_node() {
  check_for "node" "Please see https://nodejs.org/en/download/" "$1"
}

function check_for_graalvm() {
  if [ ! -x "$SCRIPT_PATH/graalvm/bin/javao" ]
  then
    ERR "GraalVM not found."
    ERR "To run benchmarks on the GraalVM, please see 'implementations/graalvm/README.md'"
  fi
}


function checkout() {
	if [[ ! -d $1 || ! -d "$1/.git" ]]
  then
    if [ ! -d $1 ]
    then
      mkdir $1
    fi
    if [ $# -eq 3 ]
    then
      echo "$#"
      INFO Cloning git repository from $3
      git clone -b $3 --depth=1 $2 $1
      pushd $1
      load_submodule    	
      popd > /dev/null
    else
      pushd $1
      git init
      git config core.sparseCheckout true
      git remote add -f $(basename $2) $2
      for dir in $(echo $4 | tr ";" "\n"); do
        echo "$dir" >> .git/info/sparse-checkout    
      done  
      git pull --depth=1 $(basename $2) $3
      git checkout $3
      load_submodule
      popd > /dev/null
    fi
  else
    WARN $2 was already cloned	
  fi
}

function updateGitRepo() {
  #default remote = origin
  if [ ! -z $2 ]
  then
    remote=$2
  else
    remote="origin"
  fi

  if [ -d $1 ]
  then
    pushd $1
    reponame=`git remote show $2 | grep Fetch | cut -d ' ' -f 5`
    branchname=`git branch | grep \* | cut -d ' ' -f 2`
    INFO Updating git repository $reponame branch $branchname
    echo git pull $remote $branchname
    git pull $remote $branchname
    INFO Updating submodules
    load_submodule
    INFO Compiling
    if [ -f MAKEFILE ]
    then
      make clean; make
    fi
    popd > /dev/null
    OK done
  fi
} 
