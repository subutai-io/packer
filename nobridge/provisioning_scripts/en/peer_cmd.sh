#!/bin/bash

/bin/cat <<EOM
Provisioning management capabilities (converting RH into peer)
This might take a little time ...
EOM

errcode=0
if [ -n "$(/snap/bin/$CMD list | grep management)" ]; then
  echo "Management seems to already be installed. Checking for upgrades..."
  /snap/bin/$CMD update management
  exit 0
else
  /snap/bin/$CMD import management 2> import.err
  errcode=$?
fi

if [ $errcode -ne 0 ]; then
  certificate="$(cat import.err | grep -e '.*x509.*certificate.*')"
  if [ -n "$certificate" ]; then
    echo "You're using a local CDN cache node with a self signed certiifcate."

    if [ "$CMD" == "subutai-dev" -o "$CMD" == "subutai-master" ]; then
      echo "You're not using production so I'll enable insecure CDN downloads for you now."
      CMD=$CMD ./insecure.sh
      echo "Trying management import again ..."
      /snap/bin/$CMD import management
      errcode=$?
      if [ $errcode -ne 0 ]; then
        exit $errcode
      fi
    else
      echo "You must enable the allowInsecure property in the subutai.yaml file allow insecure CDN use."
      (>&2 cat import.err)
      exit $errcode
    fi
  fi

  (>&2 cat import.err)
  if [ $errcode -ne 0 ]; then exit $errcode; fi
fi

/bin/cat <<EOM
SUCCESS: Your peer is up. Welcome to the Horde!
-----------------------------------------------

Next steps ...
EOM
