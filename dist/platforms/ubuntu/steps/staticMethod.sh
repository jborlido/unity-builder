#!/usr/bin/env bash

#
# Set project path
#

UNITY_PROJECT_PATH="$GITHUB_WORKSPACE/$PROJECT_PATH"
echo "Using project path \"$UNITY_PROJECT_PATH\"."

BUILD_PATH_FULL="$UNITY_PROJECT_PATH/ci/python_tools/azure-image-updater/source-images/items"
CUSTOM_BUILD_PATH="$BUILD_PATH_FULL/$BUILD_FILE"
echo "Using build path \"$BUILD_PATH_FULL\"."

echo "Creating \"$BUILD_PATH_FULL\" if it does not exist."
mkdir -p "$BUILD_PATH_FULL"
ls -alh "$BUILD_PATH_FULL"

echo ""
echo "###########################"
echo "#    Project directory    #"
echo "###########################"
echo ""

ls -alh "$UNITY_PROJECT_PATH"

echo ""
echo "###########################"
echo "#    Building project     #"
echo "###########################"
echo ""

unity-editor \
  -logfile /dev/stdout \
  -projectPath "$UNITY_PROJECT_PATH" \
  -executeMethod "$STATIC_METHOD" \
  90 \
  1 \
  "$BUILD_PATH_FULL"

# Catch exit code
BUILD_EXIT_CODE=$?

# Display results
if [ $BUILD_EXIT_CODE -eq 0 ]; then
  echo "Build succeeded";
else
  echo "Build failed, with exit code $BUILD_EXIT_CODE";
fi

#
# Permissions
#

# Make a given user owner of all artifacts
if [[ -n "$CHOWN_FILES_TO" ]]; then
  chown -R "$CHOWN_FILES_TO" "$BUILD_PATH_FULL"
  chown -R "$CHOWN_FILES_TO" "$UNITY_PROJECT_PATH"
fi

# Add read permissions for everyone to all artifacts
chmod -R a+r "$BUILD_PATH_FULL"
chmod -R a+r "$UNITY_PROJECT_PATH"

# Add execute permissions to specific files
if [[ "$BUILD_TARGET" == "StandaloneOSX" ]]; then
  OSX_EXECUTABLE_PATH="$BUILD_PATH_FULL/$BUILD_NAME.app/Contents/MacOS"
  find "$OSX_EXECUTABLE_PATH" -type f -exec chmod +x {} \;
fi

#
# Results
#

echo ""
echo "###########################"
echo "#       Build output      #"
echo "###########################"
echo ""

ls -alh "$BUILD_PATH_FULL"
