#!/bin/bash

help() {
  echo "usage: `basename $0` [-hc] [-u github_username] [-e github_email] [-p projects_dir] <repository_url>"
  echo ""
  echo "Run the playbook for cloning the given <repository_url>."
  echo ""
  echo "positional arguments:"
  printf "  repository_url\tthe clone URL for a GitHub repository\n"
  echo ""
  echo "optional arguments:"
  printf "  -h\t\t\tshow this help message and exit\n"
  printf "  -c\t\t\tconfigure any existing code editors (VS Code, Sublime)\n"
  printf "  -u github_username\tyour GitHub username (useful for detecting forks)\n"
  printf "  -e github_email\tyour GitHub email (useful for multi-account setups and GPG keys)\n"
  printf "  -p projects_dir\tfull path to directory where projects are stored\n"
  if [ -z "$1" ]
	then
    exit 0
  else
    exit $1
  fi
}

join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

args=()
while getopts ":hcu:e:p:" opt
do
  case ${opt} in
    h)
      help
      ;;
    c)
      args+=( -e "configure_vscode=yes" -e "configure_sublime=yes" )
      ;;
    u)
      args+=( -e github_username=$OPTARG )
      ;;
    e)
      args+=( -e github_email=$OPTARG )
      ;;
    p)
      args+=( -e projects_dir=$OPTARG )
      ;;
    \?)
      echo "Invalid option: $OPTARG" 1>&2
      help 1
      ;;
  esac
done
shift $((OPTIND -1))

# set configuration of editors

if [ ! -z "$1" ]
then
  args+=( -e url=$1 )
else
  echo "You must provide a URL to clone."
  help 2
fi

if [ -f vars/all.yml ]
then
  args+=( -e @vars/all.yml )
fi

ansible-playbook -i inv/hosts.yml main.yml $(join_by " " "${args[@]}")
