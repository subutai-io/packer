#!/bin/bash

#
# Downloads Atlassian Products needed to build the image
#


pushd . > /dev/null
cd `dirname $0` # cd into script directory

BASE_URL=https://www.atlassian.com/software/

CONF_VER=`grep conf_ver ../variables.jsonnet \
           | awk -F ':' '{print $2}' | sed -e 's/ *"//' -e 's/",*.*//'`
echo CONF_VER = $CONF_VER
CONF_FILE=atlassian-confluence-"$CONF_VER".tar.gz
CONF_URL="$BASE_URL"confluence/downloads/binary/"$CONF_FILE"

JIRA_VER=`grep jira_ver ../variables.jsonnet \
           | awk -F ':' '{print $2}' | sed -e 's/ *"//' -e 's/",*.*//'`
echo JIRA_VER = $JIRA_VER
JIRA_FILE=atlassian-jira-"$JIRA_VER".tar.gz
JIRA_URL="$BASE_URL"jira/downloads/binary/"$JIRA_FILE"

CROWD_VER=`grep crowd_ver ../variables.jsonnet \
           | awk -F ':' '{print $2}' | sed -e 's/ *"//' -e 's/",*.*//'`
echo JIRA_VER = $JIRA_VER
CROWD_FILE=atlassian-crowd-"$CROWD_VER".tar.gz
CROWD_URL="$BASE_URL"crowd/downloads/binary/"$CROWD_FILE"

STASH_VER=`grep stash_ver ../variables.jsonnet \
           | awk -F ':' '{print $2}' | sed -e 's/ *"//' -e 's/",*.*//'`
echo STASH_VER = $STASH_VER
STASH_FILE=atlassian-stash-"$STASH_VER".tar.gz
STASH_URL="$BASE_URL"stash/downloads/binary/"$STASH_FILE"


# Start downloading if they do not already exist
for url in "$CONF_URL" "$JIRA_URL" "$CROWD_URL" "$STASH_URL"; do
  atfile=`echo $url | awk -F '/' '{print $8}'`

  if [[ -f "$atfile" ]]; then
    echo $atfile exists will NOT download.
  else 
    echo $atfile does NOT EXIST, downloading ...
    wget "$url" >> /dev/null
  fi
done

popd > /dev/null

