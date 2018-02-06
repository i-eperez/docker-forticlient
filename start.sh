#!/bin/sh

if [ -z "$VPNADDR" ] || [ -z "$VPNUSER" ] || [ -z "$VPNPASS" ]; then
  echo "Variables VPNADDR, VPNUSER and VPNPASS must be set."; exit;
fi

if [ -z "$CERTFILE" ] || [ -z "$CERTPASS" ]; then
echo "Variables CERTFILE and CERTPASS must be set" exit;
fi
export VPNTIMEOUT=${VPNTIMEOUT:-40}

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

while [ true ]; do
  echo "------------ VPN Starts ------------"
  /usr/bin/forticlient
  echo "------------ VPN exited ------------"
  sleep 10
done
