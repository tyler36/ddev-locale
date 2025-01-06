setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export PROJNAME=test-ddev-locale
  export TESTDIR=~/tmp/$PROJNAME
  mkdir -p $TESTDIR
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
}

locale_checks() {
  # Check the timezone was set to "JST", as defined in `set_locale()`.
  ddev . date | grep JST

  # Check that the locale was set to "ja_JP.UTF-8", as defined in `set_locale()`.
  ddev . date | grep '曜日'
}

set_locale() {
  # We'll override the default setting here to make it easier to change when testing.
  # After changing the below, you will also need to update `locale_checks()`
  cat <<EOF > .ddev/config.locale.yaml
timezone: Asia/Tokyo
web_environment:
    - LANG=ja_JP.UTF-8
EOF
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3

  # Explicitly set timezone.
  ddev config --timezone="UTC"

  # Sanity check that the default is UTC.
  ddev start -y >/dev/null
  ddev . date | grep UTC

  ddev add-on get ${DIR}
  set_locale
  ddev restart
  locale_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get tyler36/ddev-locale with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get tyler36/ddev-locale
  ddev restart >/dev/null
  locale_checks
}
