#!/usr/bin/env bash
# Structure: Cell Types – Modulo 6

hr='------------------------------------------------------------------------------------'

if [[ "${WIKI}" != "${BASE}" ]]; then
  rm -rf ${RUNNER_TEMP}/wikidir

  git clone $WIKI ${RUNNER_TEMP}/wikidir
  cd ${RUNNER_TEMP}/wikidir && mv -f Home.md README.md
  find . -type d -name "${FOLDER}" -prune -exec sh -c 'wiki.sh "$1"' sh {} \;

fi
