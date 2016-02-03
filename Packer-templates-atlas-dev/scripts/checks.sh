#!/bin/bash
#
# Performs some preliminary checks to make sure everything is properly setup.

if [ -z "$CONF_VER" ]; then
  echo CONF_VER is not defined, exiting ...
  exit 1
else
  echo CONF_VER is defined as $CONF_VER
fi


if [ -z "$CROWD_VER" ]; then
  echo CROWD_VER is not defined, exiting ...
  exit 1
else
  echo CROWD_VER is defined as $CROWD_VER
fi


if [ -z "$JIRA_VER" ]; then
  echo JIRA_VER is not defined, exiting ...
  exit 1
else
  echo JIRA_VER is defined as $JIRA_VER
fi


if [ -z "$STASH_VER" ]; then
  echo STASH_VER is not defined, exiting ...
  exit 1
else
  echo STASH_VER is defined as $STASH_VER
fi

