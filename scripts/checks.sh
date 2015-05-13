#!/bin/bash
#
# Performs some preliminary checks to make sure everything is properly setup.

if [ -z "$LANGUAGE" ]; then
  echo LANGUAGE is not defined, exiting ...
  exit 1
else
  echo LANGUAGE is defined as $LANGUAGE
fi


if [ -z "$LANG" ]; then
  echo LANG is not defined, exiting ...
  exit 1
else
  echo LANG is defined as $LANG
fi


if [ -z "$LC_ALL" ]; then
  echo LC_ALL is not defined, exiting ...
  exit 1
else
  echo LC_ALL is defined as $LC_ALL
fi


if [ -z "$NODE_VER" ]; then
  echo NODE_VER is not defined, exiting ...
  exit 1
else
  echo NODE_VER is defined as $NODE_VER
fi

