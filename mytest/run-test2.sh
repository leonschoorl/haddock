#!/bin/sh
set -x
cabal new-run haddock:haddock -- -v 3 --html -o html UsingPlugins2
