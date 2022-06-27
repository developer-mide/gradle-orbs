#!/bin/bash
          # Quietly try to make the install directory.
         mkdir -p ${INSTALL_DIR} | xargs true

          # Selectively export the SUDO command, depending if we have permission
          # for a directory and whether we're running alpine.
          if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
            if cat /etc/issue | grep Alpine > /dev/null 2>&1 || ! [[ -w "${INSTALL_DIR}" ]]; then
              export SUDO="sudo";
            fi
          fi

          # If our first mkdir didn't succeed, we needed to run as sudo.
          if [ ! -w ${INSTALL_DIR} ]; then
            $SUDO mkdir -p ${INSTALL_DIR}
          fi

          echo 'export PATH=$PATH:${INSTALL_DIR}' >> $BASH_ENV
          source $BASH_ENV

          # check if jq needs to be installed
          if command -v jq >> /dev/null 2>&1; then

              echo "jq is already installed..."

            if [[ ${OVERRIDE} == true ]]; then
              echo "removing it."
              $SUDO rm -f $(command -v jq)
            else
              echo "ignoring install request."
              exit 0
            fi
          fi

          # Set jq version
          if [[ ${VERSION} == "latest" ]]; then
            JQ_VERSION="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/stedolan/jq/releases/latest" | sed 's:.*/::')"
            echo "Latest version of jq is $JQ_VERSION"
          else
            JQ_VERSION="${VERSION}"
          fi

          # extract version number
          JQ_VERSION_NUMBER_STRING=$(echo $JQ_VERSION | sed -E 's/-/ /')
          arrJQ_VERSION_NUMBER="($JQ_VERSION_NUMBER_STRING)"
          JQ_VERSION_NUMBER="${arrJQ_VERSION_NUMBER[1]}"

          # Set binary download URL for specified version
          # handle mac version
          if uname -a | grep Darwin > /dev/null 2>&1; then
            JQ_BINARY_URL="https://github.com/stedolan/jq/releases/download/${JQ_VERSION}/jq-osx-amd64"
          else
            # linux version
            JQ_BINARY_URL="https://github.com/stedolan/jq/releases/download/${JQ_VERSION}/jq-linux64"
          fi

          jqBinary="jq-$PLATFORM"

          if [ -d "$JQ_VERSION/sig" ]; then
            # import jq sigs

            if uname -a | grep Darwin > /dev/null 2>&1; then
              HOMEBREW_NO_AUTO_UPDATE=1 brew install gnupg coreutils

              PLATFORM=osx-amd64
            else
              if cat /etc/issue | grep Alpine > /dev/null 2>&1; then
                $SUDO apk add gnupg > /dev/null 2>&1
              fi
              PLATFORM=linux64
            fi

            gpg --import "$JQ_VERSION/sig/jq-release.key" > /dev/null

            curl --output "$JQ_VERSION/sig/v$JQ_VERSION_NUMBER/jq-$PLATFORM" \
                --silent --show-error --location --fail --retry 3 \
                "$JQ_BINARY_URL"

            # verify sha256sum, sig, install

            gpg --verify "$JQ_VERSION/sig/v$JQ_VERSION_NUMBER/jq-$PLATFORM.asc"

            pushd "$JQ_VERSION/sig/v$JQ_VERSION_NUMBER" && grep "jq-$PLATFORM" "sha256sum.txt" | \
            sha256sum -c -
            popd || exit
            jqBinary="$JQ_VERSION/sig/v$JQ_VERSION_NUMBER/jq-$PLATFORM"

          else
            curl --output "$jqBinary" \
              --silent --show-error --location --fail --retry 3 \
              "$JQ_BINARY_URL"
          fi

          $SUDO mv "$jqBinary" ${INSTALL_DIR}/jq
          $SUDO chmod +x ${INSTALL_DIR}/jq

          # cleanup
          [[ -d "./$JQ_VERSION" ]] && rm -rf "./$JQ_VERSION"

          # verify version
          jq -v
          echo "jq version:"
          jq --version
