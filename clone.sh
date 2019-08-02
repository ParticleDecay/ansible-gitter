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

read_vars() {
	if [ -f vars/all.yml ]
	then
    $(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' -e 's/^/export /' vars/all.yml)
	fi
}

# Read vars that are in the vars file first,
# but anything set on the CLI will overwrite those
read_vars

args=()
while getopts ":hcu:e:p:" opt
do
  case ${opt} in
    h)
      help
      ;;
    c)
			configure_vscode=true
			configure_sublime=true
      ;;
    u)
			github_username=$OPTARG
      ;;
    e)
			github_email=$OPTARG
      ;;
    p)
			projects_dir=$OPTARG
      ;;
    \?)
      echo "Invalid option: $OPTARG" 1>&2
      help 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ ! -z "$1" ]
then
	url="$1"
else
  echo "You must provide a URL to clone."
  help 2
fi

# All supported vars
args=(
	-e "projects_dir=$projects_dir"
	-e "github_username=$github_username"
	-e "github_email=$github_email"
	-e "configure_vscode=$configure_vscode"
	-e "configure_sublime=$configure_sublime"
	-e "url=$url"
)

ansible-playbook -i inv/hosts.yml main.yml $(join_by " " "${args[@]}")
