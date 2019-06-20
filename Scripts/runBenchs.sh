#!/usr/bin/env bash
set -e

SCRIPT_PATH=`cd $(dirname "$0") && pwd`
if [ ! -d $SCRIPT_PATH ]; then
  echo "Could not determine absolute dir of $0"
  echo "Maybe accessed with symlink"
fi

source $SCRIPT_PATH/basicFunctions.inc

# Find abs path in MacOS
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

if [[ ! -f "$1" ]]; then
  echo "First parameter must specify a rebench configuration file"
  exit 1
fi

if [[ ! -f "$2" ]]; then
  echo "Second parameter must specify a directory to persist the data files"
  exit 1
fi

if [[ ! -d "$3" ]]; then
  WARN "3nd parameter must specify a valid directory for the awf benchmark suite"
fi

if [[ ! -d "$4" ]]; then
  WARN "4rd parameter must specify a valid directory for the som benchmark suite"
fi

if [[ ! -d "$5" ]]; then
  WARN "5th parameter must specify a valid directory for TruffleMate"
fi

if [[ ! -d "$6" ]]; then
  WARN "6th parameter must specify a valid directory for RTruffleMate"
fi

if [[ ! -d "$7" ]]; then
  WARN "7th parameter must specify a valid directory for RTruffleMate with environment in object configuration"
fi

if [[ ! -d "$8" ]]; then
  WARN "8th parameter must specify a valid directory for Pharo"
fi

if [[ ! -d "$9" ]]; then
  WARN "9th parameter must specify a valid directory for an java jdk8 with JVMCI enabled"
fi

if [[ ! -d "$10" ]]; then
  WARN "10th parameter must specify a valid directory for a graal VM"
fi

if [ "$(uname -s)" = 'Linux' ]; then
  REBENCH=$(readlink -f $1)
  DATA_PATH=$(readlink -f $2)
  if [[ -d "$3" ]]; then
    AWF_PATH=$(readlink -f $3)
  fi
  if [[ -d "$4" ]]; then
    SOM_PATH=$(readlink -f $4)
  fi
  if [[ -d "$5" ]]; then
    TMATE_PATH=$(readlink -f $5)
  fi
  if [[ -d "$6" ]]; then
    RMATE_PATH=$(readlink -f $6)
  fi
  if [[ -d "$7" ]]; then
    RMATE_PATH_OBJ=$(readlink -f $7)
  fi
  if [[ -d "$8" ]]; then
    PHARO_PATH=$(readlink -f $8)
  fi
  if [[ -d "$9" ]]; then
    JDK8_PATH=$(readlink -f $9)
  fi
  if [[ -d "$10" ]]; then
    GRAAL_PATH=$(readlink -f $10)
  fi
else
  REBENCH=$(realpath -f $1)
  DATA_PATH=$(realpath -f $2)
  if [[ -d "$3" ]]; then
    AWF_PATH=$(realpath -f $3)
  fi
  if [[ -d "$4" ]]; then
    SOM_PATH=$(realpath -f $4)
  fi
  if [[ -d "$5" ]]; then
    TMATE_PATH=$(realpath -f $5)
  fi
  if [[ -d "$6" ]]; then
    RMATE_PATH=$(realpath -f $6)
  fi
  if [[ -d "$7" ]]; then
    RMATE_PATH_OBJ=$(realpath -f $7)
  fi
  if [[ -d "$8" ]]; then
    PHARO_PATH=$(realpath -f $8)
  fi
  if [[ -d "$9" ]]; then
    JDK8_PATH=$(realpath -f $9)
  fi
  if [[ -d "$10" ]]; then
    GRAAL_PATH=$(realpath -f $10)
  fi
fi

shift
shift
shift
shift
shift
shift
shift
shift
shift

TMPDIR=$(mktemp -d /tmp/rbench.XXXXXX)
pushd $TMPDIR

cp "$REBENCH" ./rebench.conf
if [[ ! -z $AWF_PATH ]]; then
  sed -i.bak "s+%%AWF_BENCHMARKS_PATH%%+$AWF_PATH+" rebench.conf
fi 
if [[ ! -z $SOM_PATH ]]; then
  sed -i.bak "s+%%SOM_PATH%%+$SOM_PATH+" rebench.conf
fi
if [[ ! -z $TMATE_PATH ]]; then
  sed -i.bak "s+%%TMATE_PATH%%+$TMATE_PATH+" rebench.conf
fi
if [[ ! -z $RMATE_PATH ]]; then
  sed -i.bak "s+%%RMATE_PATH%%+$RMATE_PATH+" rebench.conf
fi
if [[ ! -z $RMATE_PATH_OBJ ]]; then
  sed -i.bak "s+%%RMATE_OBJ_PATH%%+$RMATE_PATH_OBJ+" rebench.conf
fi
if [[ ! -z $PHARO_PATH ]]; then
  sed -i.bak "s+%%PHARO_PATH%%+$PHARO_PATH+" rebench.conf
fi
if [[ ! -z $JDK8_PATH ]]; then
  sed -i.bak "s+%%JAVA8_JVMCI_PATH%%+$JDK8_PATH+" rebench.conf
fi
if [[ ! -z $GRAAL_PATH ]]; then
  sed -i.bak "s+%%GRAAL_PATH%%+$GRAAL_PATH+" rebench.conf
fi 

rebench rebench.conf "$@"
RES=$?

TIMESTAMP=$(timestamp)

tar -zcvf "mateExperiments-$TIMESTAMP.tar.gz" .
cp "mateExperiments-$TIMESTAMP.tar.gz" "$DATA_PATH/mateExperiments-$TIMESTAMP.tar.gz"

popd
rm -rf $TMPDIR
exit $RES
