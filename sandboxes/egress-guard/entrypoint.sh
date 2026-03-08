#!/usr/bin/env bash
set -Eeuo pipefail

DOMAINS_FILE="${DOMAINS_FILE:-/app/allowed-domains.txt}"
REFRESH_SECONDS="${REFRESH_SECONDS:-300}"
DNS_SERVER="${DNS_SERVER:-1.1.1.1}"
ENABLE_IPV6="${ENABLE_IPV6:-false}"

IPSET_V4="allowed-domains"
IPSET_V4_NEW="allowed-domains-new"
IPSET_V6="allowed-domains-v6"
IPSET_V6_NEW="allowed-domains-v6-new"

log() {
  echo "[$(date '+%F %T')] $*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing command: $1" >&2
    exit 1
  }
}

require_file() {
  [[ -f "$1" ]] || {
    echo "missing file: $1" >&2
    exit 1
  }
}

init_ipsets() {
  ipset create "${IPSET_V4}" hash:ip family inet -exist
  ipset create "${IPSET_V4_NEW}" hash:ip family inet -exist

  if [[ "${ENABLE_IPV6}" == "true" ]]; then
    ipset create "${IPSET_V6}" hash:ip family inet6 -exist
    ipset create "${IPSET_V6_NEW}" hash:ip family inet6 -exist
  fi
}

refresh_ipsets() {
  local domain ip

  ipset flush "${IPSET_V4_NEW}"
  if [[ "${ENABLE_IPV6}" == "true" ]]; then
    ipset flush "${IPSET_V6_NEW}"
  fi

  while IFS= read -r domain; do
    domain="$(echo "${domain}" | xargs)"
    [[ -z "${domain}" ]] && continue
    [[ "${domain}" =~ ^# ]] && continue

    log "resolving ${domain}"

    while IFS= read -r ip; do
      [[ -z "${ip}" ]] && continue
      [[ "${ip}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || continue
      ipset add "${IPSET_V4_NEW}" "${ip}" -exist
      log "allow ${domain} -> ${ip}"
    done < <(dig @"${DNS_SERVER}" +short A "${domain}")

    if [[ "${ENABLE_IPV6}" == "true" ]]; then
      while IFS= read -r ip; do
        [[ -z "${ip}" ]] && continue
        [[ "${ip}" == *:* ]] || continue
        ipset add "${IPSET_V6_NEW}" "${ip}" -exist
        log "allow ${domain} -> ${ip}"
      done < <(dig @"${DNS_SERVER}" +short AAAA "${domain}")
    fi
  done < "${DOMAINS_FILE}"

  ipset swap "${IPSET_V4}" "${IPSET_V4_NEW}"
  if [[ "${ENABLE_IPV6}" == "true" ]]; then
    ipset swap "${IPSET_V6}" "${IPSET_V6_NEW}"
  fi
}

init_firewall_v4() {
  iptables -F OUTPUT
  iptables -P OUTPUT DROP

  iptables -A OUTPUT -o lo -j ACCEPT
  iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

  iptables -A OUTPUT -d "${DNS_SERVER}" -p udp --dport 53 -j ACCEPT
  iptables -A OUTPUT -d "${DNS_SERVER}" -p tcp --dport 53 -j ACCEPT

  iptables -A OUTPUT -m set --match-set "${IPSET_V4}" dst -p tcp -m multiport --dports 80,443 -j ACCEPT

  iptables -A OUTPUT -m limit --limit 10/min -j LOG --log-prefix "EGRESS DROP v4: " --log-level 4
}

init_firewall_v6() {
  if [[ "${ENABLE_IPV6}" != "true" ]]; then
    if command -v ip6tables >/dev/null 2>&1; then
      ip6tables -F OUTPUT || true
      ip6tables -P OUTPUT DROP || true
      ip6tables -A OUTPUT -o lo -j ACCEPT || true
      ip6tables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT || true
    fi
    return
  fi

  ip6tables -F OUTPUT
  ip6tables -P OUTPUT DROP

  ip6tables -A OUTPUT -o lo -j ACCEPT
  ip6tables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

  ip6tables -A OUTPUT -m set --match-set "${IPSET_V6}" dst -p tcp -m multiport --dports 80,443 -j ACCEPT

  ip6tables -A OUTPUT -m limit --limit 10/min -j LOG --log-prefix "EGRESS DROP v6: " --log-level 4
}

print_state() {
  log "current IPv4 allowlist:"
  ipset list "${IPSET_V4}" || true

  if [[ "${ENABLE_IPV6}" == "true" ]]; then
    log "current IPv6 allowlist:"
    ipset list "${IPSET_V6}" || true
  fi
}

main() {
  require_cmd bash
  require_cmd dig
  require_cmd iptables
  require_cmd ipset
  require_file "${DOMAINS_FILE}"

  if [[ "${ENABLE_IPV6}" == "true" ]]; then
    require_cmd ip6tables
  fi

  init_ipsets
  refresh_ipsets
  init_firewall_v4
  init_firewall_v6
  print_state

  log "egress guard started"

  while true; do
    sleep "${REFRESH_SECONDS}"
    refresh_ipsets
  done
}

main "$@"