#!/usr/bin/env bash

mix deps.get
iex --name ts@127.0.0.1 --cookie mycookie -S mix
