#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure
#!nix-shell -p host

set -euo pipefail

if [ $# -ne 3 ];
then
    echo "This script checks the DNS configuration of your mail domain"
    echo "Usage: $0 DOMAIN FQDN SERVER_IP"
    exit 1
fi

export DOMAIN=$1
export FQDN=$2
export SERVER_IP=$3

echo "Check '${DOMAIN}' as a DNS MX entry for '${FQDN}'"
if ! host -t MX "${DOMAIN}" | grep -q -e "${DOMAIN} mail is handled by .* ${FQDN}";
then
    echo "Error: MX configuration is not correct"
    host -t MX "${DOMAIN}"
    exit 2
else
    echo ok
fi

echo "Check '${FQDN}' resolves to '${SERVER_IP}'"
IP=$(host "$FQDN"  | grep "has address" | cut -d" " -f4)
if [ "${IP}" != "${SERVER_IP}" ];
then
    echo "Error: $FQDN should resolve to '${SERVER_IP}' (and not '$IP')"
    exit 2
else
    echo "ok"
fi

echo "Check the reverse dns entry for '${SERVER_IP}' point to the address of '${FQDN}'"
DN=$(host "$SERVER_IP" | cut -d" " -f5)
RDN=$(echo "${DN}" | xargs host | grep "has address" | cut -d" " -f4)
if [ "${SERVER_IP}" != "${RDN}" ];
then
    echo "Error: reverse DNS is not correctly configured"
    exit 2
else
    echo "ok"
fi

echo "Check SPF is configured for ${DOMAIN}"
SPF=$(host -t TXT "${DOMAIN}")
if echo "${SPF}" | grep -q -e "v=spf1 .*+a:${FQDN}" || echo "${SPF}" | grep -q -e "v=spf1 .*ip4:${SERVER_IP}";
then
    echo "ok"
else
    echo "Error: SPF is not correctly configured"
    echo "  SPF TXT record: ${SPF}"
fi
