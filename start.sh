#!/usr/bin/env bash


echo "Start grading client:"
echo "cd modules/grading_client"
echo "mix deps.get"
echo "iex --name ts@127.0.0.1 --cookie mycookie -S mix"

LIVEBOOK_DEFAULT_RUNTIME=attached:ts@127.0.0.1:mycookie LIVEBOOK_PASSWORD=123412341234 livebook server
echo "The password is 123412341234"
