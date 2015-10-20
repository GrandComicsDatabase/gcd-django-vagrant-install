#!/usr/bin/env bash
#
# This configures git for the gcd website
# Written by grosenbaum (http://github.com/grosenbaum)

set -e
_DEBUG="off"

function DEBUG()
{
 [ "$_DEBUG" == "on" ] && "$@"
}

# Debug activation
# DEBUG set -x

echo "This script helps you to configure git."

if git config -l | grep --quiet 'user.name'; then
  echo "Your username is already configured."
else 
  echo "Your username is missing."
  echo -e "Could you type the username you want to use with git?"
  read -r username
  git config --global user.name "${username}"
fi

if git config -l | grep --quiet 'user.email'; then
  echo "Your email is already configured."
else 
  echo "Your email is missing."
  echo -e "Could you type the email you want to use with git?"
  read -r email
  git config --global user.email "${email}"
fi

echo "git is now ready."
echo "To check your git settings, use this command: git config --list"
echo "For more information git configuration, check this page: https://git-scm.com/docs/git-config"

# Debug desactivation
# DEBUG set +x