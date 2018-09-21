# https://stackoverflow.com/a/40681059
function extractUrl() {
  # Extract the protocol (includes trailing "://").
  PARSED_PROTO="$(echo $1 | sed -nr 's,^(.*://).*,\1,p')"

  # Remove the protocol from the URL.
  PARSED_URL="$(echo ${1/$PARSED_PROTO/})"

  # Remove the suffix from the URL
  PARSED_URL="$(echo ${PARSED_URL/.git/})"

  # Extract the user (includes trailing "@").
  PARSED_USER="$(echo $PARSED_URL | sed -nr 's,^(.*@).*,\1,p')"

  # Remove the user from the URL.
  PARSED_URL="$(echo ${PARSED_URL/$PARSED_USER/})"
  
  echo $PARSED_URL
}

function shouldBuild() {
  if [[ $BUILD_ME -eq 1 && \
    $ABSTRUSE_PULL_REQUEST = "false" && \
    ($ABSTRUSE_BRANCH = "master" || \
    $ABSTRUSE_BRANCH = $ABSTRUSE_TAG)  ]]; then
    export SHOULD_BUILD=1
  fi
}

function shouldDeploy() {
  if [[ $ABSTRUSE_PULL_REQUEST = "false" && \
    ($ABSTRUSE_BRANCH = "master" || \
    $ABSTRUSE_BRANCH = $ABSTRUSE_TAG)  ]]; then
    export SHOULD_DEPLOY=1
  fi
}

if [ -d /home/abstruse/.gvm ]; then
  eval "$(gvm $GO_VERSION)"

  export GOPATH=/home/abstruse/go
fi

if [ -d /home/abstruse/build/.git ]; then
  export PROJECT_PATH=/home/abstruse/go/src/`extractUrl $(git remote get-url origin)`

  if [ ! -L $PROJECT_PATH ]; then
    mkdir -p $PROJECT_PATH
    rmdir $PROJECT_PATH
    ln -s /home/abstruse/build $PROJECT_PATH
  fi

  cd $PROJECT_PATH
fi

shouldBuild
shouldDeploy

# giving docker access to abstruse user
if [ -e /var/run/docker.sock ]; then
  sudo chown -R 1000:100 /var/run/docker.sock > /dev/null 2>&1
fi