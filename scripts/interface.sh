#!/bin/sh -eux

echo "auto eth1" >> /etc/network/interfaces
echo "iface eth1 inet dhcp" >> /etc/network/interfaces
echo "  port-up route del default dev $IFACE || true" >> /etc/network/interfaces

echo "auto eth2" >> /etc/network/interfaces
echo "iface eth2 inet dhcp" >> /etc/network/interfaces
echo "  port-up route del default dev $IFACE || true" >> /etc/network/interfaces


echo Changed interface configuration
cat /etc/network/interfaces