#!/usr/bin/env bash


ps aux | grep "ts@127.0.0.1" | grep "mycookie" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    # livebook binary not exists
    if ! command -v livebook &> /dev/null ; then
        echo "Install livebook bro"
        echo "mix do local.rebar --force, local.hex --force"
        echo "mix escript.install hex livebook"
    else
        echo "The password is 123412341234"
        LIVEBOOK_DEFAULT_RUNTIME=attached:ts@127.0.0.1:mycookie LIVEBOOK_PASSWORD=123412341234 livebook server
    fi
else
    echo "Please start the grading client:"
    echo "cd modules/grading_client"
    echo "./start.sh"
fi
