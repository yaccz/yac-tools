#!/bin/false
# This file needs to be sourced.
# see man bash(1) section SHELL BUILTIN COMMANDS

ROOT=$(realpath $(dirname $0))

export PATH="${ROOT}/build/bin:$PATH"
export MANPATH="${ROOT}/build/man:${MANPATH}"
