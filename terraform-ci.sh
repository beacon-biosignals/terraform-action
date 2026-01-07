#!/bin/bash

# https://github.com/orgs/community/discussions/26311#discussioncomment-7571648
#
# terraform needs time to clean up after itself.  if it receives a second signal
# after shutdown is initiated, it may exit immediately leaving dirty state,
# lockfiles, or partially applied resources.  this harness (copied from the
# discussion linked above) sends at most one signal to terraform

COUNTER=0
_term() {
  echo "Caught SIGTERM signal!"

  if [[ $COUNTER -lt 1 ]] ; then
    echo "Passing signal to terraform"
    kill -TERM "$child" 2>/dev/null
  else
    echo "Already passed signal to terraform"
  fi

  let COUNTER++
}

_int() {
  echo "Caught SIGINT signal!"

  if [[ $COUNTER -lt 1 ]] ; then
    echo "Passing signal to terraform"
    kill -INT "$child" 2>/dev/null
  else
    echo "Already passed signal to terraform"
  fi

  let COUNTER++
}

_other() {
  echo "Caught OTHER signal!"

  if [[ $COUNTER -lt 1 ]] ; then
    echo "Passing signal to terraform"
    kill -INT "$child" 2>/dev/null
  else
    echo "Already passed signal to terraform"
  fi

  let COUNTER++
}

trap _term SIGTERM
trap _int SIGINT

trap _other SIGHUP
trap _other SIGUSR1
trap _other SIGUSR2
trap _other SIGABRT
trap _other SIGQUIT
trap _other SIGPIPE

terraform "$@" &
child=$!
wait "$child"
