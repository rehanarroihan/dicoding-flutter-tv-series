#!/usr/bin/env bash

# https://medium.com/@nocnoc/combined-code-coverage-for-flutter-and-dart-237b9563ecf8

# remember some failed commands and report on exit
error=false

show_help() {
  printf "usage: $0 [--help]
Tool for running all unit and widget tests with code coverage and automatically generated if lcov is installed.

(run from root of repo)
where:
    --help
        print this message
"
  exit 1
}

# run unit and widget tests
runTests() {
  cd $1
  if [ -f "pubspec.yaml" ] && [ -d "test" ]; then
    echo "---------------------------------------"
    echo "Running tests in $1"
    echo "---------------------------------------"
    flutter pub get

    # Remove ./ prefix for path mapping
    cleanPath=$(echo $1 | sed 's/^\.\///')
    if [ "$cleanPath" == "." ]; then
        prefix=""
    else
        prefix="$cleanPath/"
    fi
    
    escapedPrefix=$(echo $prefix | sed 's/\//\\\//g')

    # run tests with coverage
    if grep flutter pubspec.yaml >/dev/null; then
      echo "Executing flutter tests..."
      if [ -f "test/all_tests.dart" ]; then
        flutter test --coverage test/all_tests.dart || error=true
      else
        flutter test --coverage || error=true
      fi

      if [ -d "coverage" ]; then
        # Ensure root coverage directory exists
        mkdir -p $2/coverage
        # combine line coverage info from package tests to a common file
        # SF:lib/path/to/file.dart -> SF:module/lib/path/to/file.dart
        sed "s/^SF:lib/SF:${escapedPrefix}lib/g" coverage/lcov.info >>$2/coverage/test.info
        rm -f coverage/lcov.info
      fi
    else
      echo "Not a flutter package, skipping coverage"
      flutter test || error=true
    fi
  fi
  cd - >/dev/null
}

runReport() {
  if [ -f "coverage/test.info" ] && ! [ "$TRAVIS" ]; then
    if command -v genhtml >/dev/null; then
      echo "---------------------------------------"
      echo "Generating combined coverage report..."
      echo "---------------------------------------"
      genhtml coverage/test.info -o coverage --no-function-coverage --prefix $(pwd)

      if [ "$(uname)" == "Darwin" ]; then
        open coverage/index.html
      else
        echo "Report generated at coverage/index.html"
      fi
    else
      echo "lcov (genhtml) not installed. Skipping HTML report generation."
    fi
  fi
}

if ! [ -f "pubspec.yaml" ] && [ -d .git ]; then
  printf "\nError: not in root of repo\n"
  show_help
fi

case $1 in
--help)
  show_help
  ;;
*)
  currentDir=$(pwd)
  # if no parameter passed
  if [ -z $1 ]; then
    if [ -d "coverage" ]; then
      rm -r coverage
    fi
    
    # Target specific modules and root
    modules=("." "core" "movie" "tv" "about")
    
    for dir in "${modules[@]}"; do
      if [ -d "$dir" ]; then
        runTests $dir $currentDir
      fi
    done
  else
    if [[ -d "$1" ]]; then
      runTests $1 $currentDir
    else
      printf "\nError: not a directory: $1"
      show_help
    fi
  fi
  runReport
  ;;
esac

# Fail the build if there was an error
if [ "$error" = true ]; then
  exit -1
fi
