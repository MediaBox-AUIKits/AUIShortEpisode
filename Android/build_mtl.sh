#! /bin/sh
#
# build_mtl.sh
#
# Created by keria on 2022/08/30
# Copyright (C) 2022 keria <runchen.brc@alibaba-inc.com>
#
set -e

aio_ui_foundation_branch='develop'
aio_third_party_branch='master'

#if use fast mode, do not refresh gradle dependencies
fast_mode=0

#if build with formal version, we need remove all the test code.
release_official=0

log() {
  echo "[BUILD-DEMO] [$(date +'%Y/%m/%d %H:%M:%S')]: ${1}"
}

prepare_mtl_build_env() {
  log 'prepare mtl build env...'
  export JAVA_HOME=/usr/alibaba/jdk-11.0.12
  export PATH=$JAVA_HOME/bin:$PATH
  export ANDROID_NDK_HOME=/home/admin/software/android-ndk-r18b
  log 'prepare mtl build env over!'
}

# Here we need to import aio common modules
prepare_code_repo() {
  log 'prepare code repo...'

  # Attention!!!
  # We've put `AndroidThirdParty` into the gitignore in order to make it always the latest,
  # so, we need to `git pull` the latest commits on master branch at the beginning.
  if [ ! -d "AndroidThirdParty" ]; then
    # shellcheck disable=SC2154
    if [ "$aio_third_party_branch_override" != "" ]; then
      aio_third_party_branch=$aio_third_party_branch_override
    fi
    log "now clone third party from branch: $aio_third_party_branch"
    git clone --branch "$aio_third_party_branch" git@gitlab.alibaba-inc.com:AlivcSolution_Android/AndroidThirdParty.git
    git submodule init && git submodule update --init --recursive
  fi

  log 'prepare code repo over!'
}

clean_cache() {
  log 'clean cache...'
  rm -rf .gradle/ && ./gradlew clean --stacktrace --info || exit 1
  log 'clean cache over...'
}

refresh_gradle_dependencies() {
  log 'refresh gradle dependencies...'
  ./gradlew --refresh-dependencies --stacktrace --info || exit 1
  log 'refresh gradle dependencies over!'
}

package_source_code() {
  log 'package source code...'
  ./gradlew clean -Pczip=1 --stacktrace --info || exit 1
  log 'package source code over!'
}

build_demo_debug() {
  log 'build debug demo...'
  ./gradlew assembleDebug --stacktrace --info || exit 1
  log 'build debug demo over!'
}

build_demo_release() {
  log 'build release demo...'
  ./gradlew assembleRelease --stacktrace --info || exit 1
  log 'build release demo over!'
}

mtl_build() {
  prepare_mtl_build_env || exit 1
  prepare_code_repo || exit 1
  clean_cache || exit 1
  if [ $fast_mode = 0 ]; then
    refresh_gradle_dependencies || exit 1
  fi
  if [ $release_official = 1 ]; then
    package_source_code || exit 1
  fi
  # shellcheck disable=SC2154
  if [ "$BUILD_TYPE_ENV" = "debug" ]; then
    build_demo_debug || exit 1
  else
    build_demo_release || exit 1
  fi
}

log '*** start build ***'
start=$(date +%s)

while getopts 'cdfriothv' optname; do
  case "$optname" in
  'c') clean_cache ;;
  'd') build_demo_debug ;;
  'f') fast_mode=1 ;;
  'r') build_demo_release ;;
  'i') prepare_code_repo ;;
  'o') release_official=1 ;;
  't') mtl_build ;;
  'h') log 'HELP!!!' ;;
  'v') log "current version is "$(git rev-parse --short HEAD) ;;
  ?) log 'Unknown error while processing options' ;;
  esac
done

end=$(date +%s)
time=$(echo "$start" "$end" | awk '{print $2-$1}')

log "*** end build, cost: ${time}s. ***"
