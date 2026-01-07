#!/bin/bash

# https://github.com/orgs/community/discussions/26311#discussioncomment-7571648
#
# Terraform needs time to clean up after itself.  If it receives a second signal
# after shutdown is initiated, it may exit immediately leaving dirty state,
# lockfiles, or partially applied resources.  This harness (copied from the
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

  (( COUNTER++ )) || true
}

_int() {
  echo "Caught SIGINT signal!"

  if [[ $COUNTER -lt 1 ]] ; then
    echo "Passing signal to terraform"
    kill -INT "$child" 2>/dev/null
  else
    echo "Already passed signal to terraform"
  fi

  (( COUNTER++ )) || true
}

_other() {
  echo "Caught OTHER signal!"

  if [[ $COUNTER -lt 1 ]] ; then
    echo "Passing signal to terraform"
    kill -INT "$child" 2>/dev/null
  else
    echo "Already passed signal to terraform"
  fi

  (( COUNTER++ )) || true
}

trap _term SIGTERM
trap _int SIGINT

trap _other SIGHUP SIGUSR1 SIGUSR2 SIGABRT SIGQUIT SIGPIPE

terraform "$@" &
child=$!
wait "$child"
