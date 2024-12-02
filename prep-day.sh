#!/usr/bin/env bash

set -e

YEAR=2024
SESSION_FILE=.session
INPUT_DIR=input
INPUT_TEST_DIR=test-input
APP_DIR=app
SRC_DIR=src

if [ -z "$1" ]; then
  echo "Must provide a day of the month as the first argument."
  exit 1
fi

DAY=$(echo "$1" | bc)
if [[ $DAY -lt 1 || $DAY -gt 25 ]]; then
  echo "The day must be between 1 and 25, inclusive."
  exit 1
fi

if [ ! -f "$SESSION_FILE" ]; then
  echo "File '$SESSION_FILE' with the user's session key from the Advent of" \
    "Code website does not exist."
  exit 1
fi

SESSION="$(cat "$SESSION_FILE")"
if [ -z "$SESSION" ]; then
  echo "Must set the session from the Advent of Code website."
  exit 1
fi

DAY_FILE=$DAY
if [[ $DAY -ge 1 && $DAY -le 9 ]]; then
  DAY_FILE=0$DAY
fi

INPUT_FILE="$INPUT_DIR/$DAY_FILE.txt"
if [ -f "$INPUT_FILE" ]; then
  echo "Input data already exists for day $DAY, skipping download..."
else
  echo "Downloading input data for day $DAY to '$INPUT_FILE'..."
  mkdir -p "$INPUT_DIR"
  curl "https://adventofcode.com/$YEAR/day/$DAY/input" -s -m 10 \
    -b "session=$SESSION" > "$INPUT_FILE"
fi

INPUT_TEST_FILE="$INPUT_TEST_DIR/$DAY_FILE.txt"
if [ -f "$INPUT_TEST_FILE" ]; then
  echo "An input test file already exists for day $DAY, skipping..."
else
  echo "Creating an empty input test file '$INPUT_TEST_FILE' for day $DAY..."
  mkdir -p "$INPUT_TEST_DIR"
  touch "$INPUT_TEST_FILE"
fi

DAY_MODULE=Day$DAY_FILE
SRC_FILE="$SRC_DIR/$DAY_MODULE.hs"
if [ -f "$SRC_FILE" ]; then
  echo "'$SRC_FILE' already exists, skipping..."
else
  echo "Creating a boilerplate module for day $DAY at '$SRC_FILE'..."
  echo "Remember to update '$SRC_DIR/Main.hs':"
  echo "  - Update 'solutions' to use '$DAY_MODULE'."
  echo "Remember to update 'aoc$YEAR.cabal':"
  echo "  - Update 'library.exposed-modules' to use '$DAY_MODULE'."
  cat <<-EOF > "$SRC_FILE"
module $DAY_MODULE where

...
EOF
fi

echo "Happy coding!"
