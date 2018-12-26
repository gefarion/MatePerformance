#/bin/sh
if [ -x "`which nvm`" ]
then
  NODE_BIN=`nvm which 6`
  if [ ! -x "$NODE_BIN" ] ; then
    NODE_BIN=nodejs
  fi
else
  NODE_BIN=nodejs
fi
exec $NODE_BIN "$@"