Abstruse Golang Builder using GVM
======

This repo contains a Dockerfile and init.sh script that can be used to build golang projects using the [Abstruse](https://github.com/bleenco/abstruse) continuous integration service.

The usage of GVM allows you to select a golang version for your project to be built against. 

### Features
  * The image produced is able to build Go 1.11 code using Go modules. Specify an `env` value of `GO111MODULE=on` to do this.
  * The image will populate two environment variables `$SHOULD_BUILD` and `$SHOULD_DEPLOY` based on the following:
    1. The environment variable `BUILD_ME` being set to `1`
    2. It *not* being a pull request
    3. The branch of the build being `master` or a tagged build e.g. `refs/tags/v1`
    
    In the case of `$SHOULD_DEPLOY` only *2.* is used.

    You can used these variables to filter that actions you do in a build or dpeloyment phase.

## Instructions for use

  1. Build a normal base image as instructed by abstruse
  2. Create a new custom image pasting in the contents of Dockerfile and init.sh respectively
  3. Use this image in your .abstruse.yml file

## Caveats

  * Always specify at least one environment variable of `GO_VERSION` e.g. `GO_VERSION=1.10` in your `matrix` configuration.
  * The GOPATH discovery has only been tested on *github.com* remotes. *gopkg.in* urls (or others) have not been tested and most likely won't work.
