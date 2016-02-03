#!/bin/bash
#
# Performs some preliminary checks to make sure everything is properly setup.

if [ -z "$APT_PROXY_URL" ]; then
  echo APT_PROXY_URL is not defined, exiting ...
  exit 1
else
  echo APT_PROXY_URL is defined as $APT_PROXY_URL
fi


if [ -z "$APT_PROXY_HOST" ]; then
  echo APT_PROXY_HOST is not defined, exiting ...
  exit 1
else
  echo APT_PROXY_HOST is defined as $APT_PROXY_HOST
fi

