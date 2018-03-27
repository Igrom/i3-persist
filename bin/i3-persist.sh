#!/bin/sh
# i3-persist 0 extends i3 window management with persistent containers
VERSION=1.0.3
FILE="`readlink -f "$0"`"

print_version () {
  echo "i3-persist version $VERSION"
}

print_help () {
  echo "Syntax: i3-persist [lock|unlock|toggle|kill] [id]"
}

print_invalid () {
  printf "i3-persist: invalid operand\nTry 'i3-persist --help' for more information.\n"
}

TMP_DIR="/tmp/i3-persist"

# Returns the id of the currently focused container
get_focused_container_id() {
  i3-msg -t get_tree | jq "recurse(.nodes[]) | select(.focused == true) | .id"
}

# Returns the ids of all child containers. Includes the parent. Form: newline-separated
get_parent_and_all_child_container_ids() {
  i3-msg -t get_tree | jq "recurse(.nodes[]) | select(.id == $1) | recurse(.nodes[]) | .id"
}

# Returns the ids of all containers. Form: newline-separated
get_all_container_ids() {
  get_parent_and_all_child_container_ids `i3-msg -t get_tree | jq '.id'`
}

# Creates temporary directory for storing locked containers
create_temporary_directory() {
  mkdir -p "$TMP_DIR"
}

# Defaults to currently focused container if no argument passed
argument_or_focused_container() {
  [ ! -z "$1" ] && echo "$1" || get_focused_container_id
}

is_container_locked() {
  [ -e "$TMP_DIR/$1.lock" ]
}

has_any_locked_child_containers() {
  echo Entering func
  local ALL_CHILD_CONTAINERS
  local CONTAINER
  local LAST_LOCKED_CONTAINER


  ALL_CHILD_CONTAINERS=`get_parent_and_all_child_container_ids "$1"`
  echo All my containers are $ALL_CHILD_CONTAINERS
  for CONTAINER in $ALL_CHILD_CONTAINERS
  do
    echo Checking container $CONTAINER
    if is_container_locked "$CONTAINER"
    then
      echo Is locked
      LAST_LOCKED_CONTAINER="$CONTAINER"
      break
    fi
  done

  [ ! -z $LAST_LOCKED_CONTAINER ]
}

# Cleans up locks for containers that have since been removed with other means
remove_expired_container_locks() {
  local ALL_CONTAINERS
  local FILE

  ALL_CONTAINERS=`get_all_container_ids`
  for FILE in "$TMP_DIR/"*
  do
    [ -e "$FILE" ] || continue
    CONTAINER=`echo "$FILE" | sed 's/^.*\///'`
    `echo "$ALL_CONTAINERS" | grep "$CONTAINER"` && rm "$FILE"
  done
}

# Mark the container as persistent
lock_container() {
  touch "$TMP_DIR/$1.lock"
}

# Mark the container as closable
unlock_container() {
  rm "$TMP_DIR/$1.lock" 2>/dev/null
}


# Main
create_temporary_directory
remove_expired_container_locks

if [ -z "$1" -o "$1" = "--help" ]
then
  print_help
  exit 0
fi

if [ -z "$1" -o "$1" = "--version" ]
then
  print_version
  exit 0
fi

while getopts "vh" opt
do
  case "$opt" in
    v)  print_version
        exit 0
        ;;
    h)  print_help
        exit 0
        ;;
    *)  print_invalid
        exit 1
        ;;
  esac
done


CONTAINER=`argument_or_focused_container "$2"`

if [ "$1" = "lock" ]
then
  lock_container "$CONTAINER"
  exit 0
fi

if [ "$1" = "unlock" ]
then
  unlock_container "$CONTAINER"
  exit 0
fi

if [ "$1" = "toggle" ]
then
  if ! is_container_locked "$CONTAINER"
  then
    lock_container "$CONTAINER"
  else
    unlock_container "$CONTAINER"
  fi
  exit 0
fi

if [ "$1" = "kill" ]
then
  ! is_container_locked "$CONTAINER" && ! has_any_locked_child_containers "$CONTAINER" && i3-msg "[con_id=\"$CONTAINER\"]" kill
  exit 0
fi

print_invalid
exit 1
