#!/usr/bin/env bash

ACTIVATE_LICENSE_PATH="$GITHUB_WORKSPACE/_activate-license~"
mkdir -p "$ACTIVATE_LICENSE_PATH"

source /steps/set_gitcredential.sh
source /steps/activate.sh

if [[ "$IS_BUILD" == "true" ]]; then
  source /steps/build.sh
else
  if [[ -n "$STATIC_METHOD" ]]; then
    source /steps/staticMethod.sh
  else
    echo "Error: staticMethod was not set."
    exit 1
  fi
fi

rm -r "$ACTIVATE_LICENSE_PATH"

if [[ $BUILD_EXIT_CODE -gt 0 ]]; then
  echo ""
  echo "###########################"
  echo "#         Failure         #"
  echo "###########################"
  echo ""
  echo "Please note that the exit code is not very descriptive."
  echo "Most likely it will not help you solve the issue."
  echo ""
  echo "To find the reason for failure: please search for errors in the log above."
  echo ""
fi

exit $BUILD_EXIT_CODE
