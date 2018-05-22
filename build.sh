#!/bin/bash

BASE_DIR="`dirname \"$0\"`"
BASE_DIR="`( cd \"$BASE_DIR\" && pwd )`"
OS=`uname`

if [ -n "$ACNG_PORT" ]; then
  MIRROR_PORT="$ACNG_PORT"
elif [ -n "$APT_PROXY_PORT" ]; then
  MIRROR_PORT="$APT_PROXY_PORT"
else 
  MIRROR_PORT=3142
fi

if [ -n "$ACNG_HOST" ]; then
  DI_MIRROR_HOSTNAME="$ACNG_HOST:$MIRROR_PORT"
  DI_MIRROR_MIRROR="http://$ACNG_HOST:$MIRROR_PORT"
elif [ -n "$APT_PROXY_HOST" -a -z "$(echo $APT_PROXY_HOST | grep ':')" ]; then
  DI_MIRROR_HOSTNAME="$APT_PROXY_HOST:$MIRROR_PORT"
  DI_MIRROR_MIRROR="http://$APT_PROXY_HOST:$MIRROR_PORT"
elif [ -n "$APT_PROXY_HOST" -a -n "$(echo $APT_PROXY_HOST | grep ':')" ]; then
  DI_MIRROR_HOSTNAME="$ACNG_HOST"
  DI_MIRROR_MIRROR="http://$APT_PROXY_HOST"
fi

# TODO: extract from variables
PASSWORD="ubuntai"

if [ -n "$1" ]; then
  VAGRANT_BOXES="$1"
  for box in $VAGRANT_BOXES; do
    case "$box" in
      "xenial")
        break
        ;;
      "stretch")
        break
        ;;
      *) echo "Bad box name in box list: $box"; exit 1
        ;;
    esac
  done
elif [ -z "$VAGRANT_BOXES" ]; then
  VAGRANT_BOXES='stretch xenial'
fi

if [ -n "$2" ]; then
  PACKER_PROVIDERS="$2"
  for provider in $PACKER_PROVIDERS; do
    case "$provider" in
      "virtualbox-iso") echo Enabling virtualbox builder
        break
        ;;
      "vmware-iso") echo Enabling vmware builder
        break
        ;;
      "parallels-iso")
        if [ $OS = "Linux" ]; then
          echo "Parallels builder not supported in $OS";
          exit 1
        else
          echo Enabling parallels builder
          break
        fi
        ;;  
      "qemu")
        if [ $OS = "Darwin" ]; then
          echo "Libvirt builder not supported in $OS";
          exit 1
        else
          echo Enabling libvirt builder
          break
        fi
        ;;
      *) echo "Bad or unsupported provider: $provider"; exit 1
        ;;
    esac
  done
elif [ -z "$PACKER_PROVIDERS" ]; then
  if [ $OS = "Darwin" ]; then
    PACKER_PROVIDERS='virtualbox-iso,parallels-iso' # changed for devops Debian machine. You can set like PACKER_PROVIDERS='virtualbox-iso,vmware-iso,parallels-iso'
  else
    PACKER_PROVIDERS='qemu,vmware-iso' # changed for devops Osx machine. You can set like PACKER_PROVIDERS='virtualbox-iso,qemu,vmware-iso'
  fi
fi

# Get branch

BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ -n "$3" ]; then
  BRANCH=$3
fi

# cleanup boxes
rm -rf *.box; rm -rf *.log;

echo Clean up output directories and boxes
for BOXNAME in $VAGRANT_BOXES; do
  for bt in virtualbox-iso parallels-iso vmware-iso; do
    echo box output directory = "output-$BOXNAME-$bt";
    if [ -d "output-$BOXNAME-$bt" ]; then
      rm -rf "output-$BOXNAME-$bt";
    fi
  done
done

# Checks if LAN apt proxy is availability
check_proxy() {
  if [ -n "$1" ]; then # if arg provided use it
    echo "Checking proxy URL $1/acng-report.html" >&2
    wget -t 1 --timeout=2 -qO- "$1/acng-report.html" | grep "Transfer statistics"
    return $?
  else # no argument tries env value
    echo "Checking proxy URL $DI_MIRROR_MIRROR/acng-report.html" >&2
    wget -t 1 --timeout=2 -qO- "$DI_MIRROR_MIRROR/acng-report.html" | grep "Transfer statistics" >&2
    return $?
  fi
}

do_local_proxy() {
  local local_proxy="http://$(hostname):$MIRROR_PORT"
  if [ -n "$(check_proxy $local_proxy)" ]; then
    echo "Local proxy $local_proxy is on! Using it." >&2
    echo $local_proxy
    return 0
  fi

  echo "No local or remote proxy available. Want stand one up? (y/n)" >&2
  read answer

  if [ "$answer" = "y" ]; then
    cd $BASE_DIR/cache
    vagrant up >&2
    cd $BASE_DIR

    while [ -z "$(check_proxy $local_proxy)" ]; do
      echo "Local proxy $local_proxy is not up. Waiting 10s ..." >&2
      sleep 10
    done

    echo "Local proxy $local_proxy is up! Using it." >&2
    echo $local_proxy
    return 0
  else
    echo ""
    return 1
  fi
}

# check for packer
packer=`which packer`
if [ -z "$packer" ]; then 
  echo ' ==> [ERROR] Packer not found'
  exit 1
else 
  echo ' ==> [OK] Packer executable found at '$packer
fi

# check for vagrant
vagrant=`which vagrant`
if [ -z "$vagrant" ]; then 
  echo ' ==> [ERROR] Vagrant not found'
  exit 1
else 
  echo ' ==> [OK] Vagrant executable found at '$vagrant
fi

# check for jsonnet
jsonnet=`which jsonnet`
if [ -z "$jsonnet" ]; then 
  echo ' ==> [ERROR] Jsonnet not found'
  exit 1
else 
  echo ' ==> [OK] Jsonnet executable found at '$jsonnet
fi

# check for vbox
vbox=`which VirtualBox`
if [ -z "$vbox" ]; then 
  echo ' ==> [ERROR] Virtualbox not found'
  exit 1
else 
  echo ' ==> [OK] VirtualBox executable found at '$vbox
fi

# check for kvm
if [ $OS = "Linux" ]; then
  kvm=`which virsh`
  if [ -z "$kvm" ]; then
    echo ' ==> [WARNING] KVM not found'
  else
    echo ' ==> [OK] KVM executable found at '$kvm
  fi
fi

# check for vmware
vmware=`which vmware`
if [ -z "$vmware" ]; then
  echo ' ==> [WARNING] Vmware not found'
else
  echo ' ==> [OK] Vmware executable found at '$vmware
fi

# check for paralles
if [ $OS = "Darwin" ]; then
  parallels=`which prlsrvctl`
  if [ -z "$parallels" ]; then
    echo ' ==> [WARNING] Parallels not found'
  else
    echo ' ==> [OK] Paralles executable found at '$parallels
  fi
fi

# check to see if a proxy is configured
if [ -n "$DI_MIRROR_MIRROR" ]; then
  echo 'Proxy configured: DI_MIRROR_MIRROR = '$DI_MIRROR_MIRROR

  if [ -n "check_proxy $DI_MIRROR_MIRROR" ]; then
    echo Proxy is on
    PROXY_ON="true"

    # double check that the DI_MIRROR_HOSTNAME is also configured with port
    if [ -z "$DI_MIRROR_HOSTNAME" ]; then
      echo " ==> [WARNING] DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR but DI_MIRROR_HOSTNAME is undefined"
      echo " ==> [WARNING] Attempting to extract DI_MIRROR_HOSTNAME from DI_MIRROR_MIRROR URL"
      DI_MIRROR_HOSTNAME=$(echo $DI_MIRROR_MIRROR|sed -e 's/http:\/\///g')
    fi

    if [ -z "$(echo $DI_MIRROR_HOSTNAME|awk -F':' '{print $2}')" ]; then
      echo " ==> [ERROR] No port included on DI_MIRROR_HOSTNAME value of $DI_MIRROR_HOSTNAME"
      echo " ==> [ERROR] Oddly a port is required in the preseed file. Please add it."
      exit 1
    fi
  else
    echo WARNING: Proxy is off
    DI_MIRROR_MIRROR=$(do_local_proxy)
    if [ -n "$DI_MIRROR_MIRROR" ]; then
      DI_MIRROR_HOSTNAME=$(echo $DI_MIRROR_MIRROR|sed -e 's/http:\/\///g')
      PROXY_ON="true"
    else
      DI_MIRROR_HOSTNAME=""
      DI_MIRROR_MIRROR=""
      MIRROR_PORT=""
      PROXY_ON="false"
    fi
  fi
else
  echo 'Proxy NOT configured: DI_MIRROR_MIRROR NOT set'
  DI_MIRROR_MIRROR=$(do_local_proxy)
  if [ -n "$DI_MIRROR_MIRROR" ]; then
    DI_MIRROR_HOSTNAME="localhost:$MIRROR_PORT"
    DI_MIRROR_HOSTNAME=$(echo $DI_MIRROR_MIRROR|sed -e 's/http:\/\///g')
    PROXY_ON="true"
  else
    DI_MIRROR_HOSTNAME=""
    DI_MIRROR_MIRROR=""
    MIRROR_PORT=""
    PROXY_ON="false"
  fi
fi

# TODO: export password from variables in json file
# for sata disk interface
box=$box BASE_DIR=$BASE_DIR              \
  PROXY_ON=$PROXY_ON                     \
  PASSWORD=$PASSWORD                     \
  MIRROR_PORT=$MIRROR_PORT               \
  DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR     \
  DI_MIRROR_HOSTNAME=$DI_MIRROR_HOSTNAME \
  $BASE_DIR/http/stretch.sh

# for virtio disk interface
box=$box BASE_DIR=$BASE_DIR              \
  PROXY_ON=$PROXY_ON                     \
  PASSWORD=$PASSWORD                     \
  MIRROR_PORT=$MIRROR_PORT               \
  DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR     \
  DI_MIRROR_HOSTNAME=$DI_MIRROR_HOSTNAME \
  $BASE_DIR/http/virtio/stretch.sh

# for sata disk interface
box=$box BASE_DIR=$BASE_DIR              \
  PROXY_ON=$PROXY_ON                     \
  PASSWORD=$PASSWORD                     \
  MIRROR_PORT=$MIRROR_PORT               \
  DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR     \
  DI_MIRROR_HOSTNAME=$DI_MIRROR_HOSTNAME \
  $BASE_DIR/http/xenial.sh

# for virtio disk interface
box=$box BASE_DIR=$BASE_DIR              \
  PROXY_ON=$PROXY_ON                     \
  PASSWORD=$PASSWORD                     \
  MIRROR_PORT=$MIRROR_PORT               \
  DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR     \
  DI_MIRROR_HOSTNAME=$DI_MIRROR_HOSTNAME \
  $BASE_DIR/http/virtio/xenial.sh

for box in $VAGRANT_BOXES; do

    # create master prefixed box subutai/stretch-master
      for hypervizor in libvirt parallels virtualbox vmware; do
        BRANCH_PATH=$BASE_DIR/$box/$hypervizor/branch
        rm -rf $BRANCH_PATH
        mkdir -p $BRANCH_PATH
        cp $BASE_DIR/$box/$hypervizor/Vagrantfile $BRANCH_PATH

        if [ $BRANCH = "master" ]; then
          sed -i -e "s/vagrant-subutai-$box-$hypervizor/vagrant-subutai-$box-$hypervizor-$BRANCH/g" $BRANCH_PATH/Vagrantfile
          sed -i -e "s/subutai\/$box/subutai\/$box-$BRANCH/g" $BRANCH_PATH/Vagrantfile
        fi
      done

    echo "==> [$box] Validating $box/template.json ..."
    jsonnet $box/template.jsonnet > $box/template.json

    box=$box BASE_DIR=$BASE_DIR              \
      PROXY_ON=$PROXY_ON                     \
      PASSWORD=$PASSWORD                     \
      MIRROR_PORT=$MIRROR_PORT               \
      DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR     \
      DI_MIRROR_HOSTNAME=$DI_MIRROR_HOSTNAME \
    packer validate $box/template.json

    if [ "$?" -ne 0 ]; then
      echo "[$box][ERROR] Aborting builds due to $box template validation failure."
      exit 1
    fi
done

for box in $VAGRANT_BOXES; do
    echo "==> [$box] Running packer build on $box/template.json. Providers: $PACKER_PROVIDERS"

    box=$box BASE_DIR=$BASE_DIR              \
      PROXY_ON=$PROXY_ON                     \
      PASSWORD=$PASSWORD                     \
      MIRROR_PORT=$MIRROR_PORT               \
      DI_MIRROR_MIRROR=$DI_MIRROR_MIRROR     \
      DI_MIRROR_HOSTNAME=$DI_MIRROR_HOSTNAME \
    #packer build -on-error=ask -only=$PACKER_PROVIDERS -except=null $box/template.json

    if [ "$?" -ne 0 ]; then
      echo "[$box][ERROR] Aborting builds due to $box build failure."
      echo "build line was:"
      echo "packer build -on-error=ask -only=$PACKER_PROVIDERS -except=null $box/template.json"
      exit 1
    fi

    #if [ $BRANCH = "master" ]; then
    #  vagrant box add --force subutai/$box-master vagrant-subutai-$box-*.box;
    #else
    #  vagrant box add --force subutai/$box vagrant-subutai-$box-*.box;
    #fi
done
