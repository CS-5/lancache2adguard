#!/bin/bash

# Script based on/modified from: https://gist.github.com/PSSGCSim/abd99f2fe65d9c4cc0443c6fb69daf40
# See https://github.com/AdguardTeam/AdGuardHome/issues/922#issuecomment-1066106262 and associated thread for more info

set -e 

echo "Generating domain list..."

LC2AG_TEMP_DIR=$(mktemp -d)

cleanup() {
    [ -d "${LC2AG_TEMP_DIR}" ] && rm -rf "${LC2AG_TEMP_DIR}"
    echo "List generated, cleanup finished"
}

git clone --quiet --depth 1 "${LC2AG_DOMAINS_REPO}" "${LC2AG_TEMP_DIR}"

{
    echo "# Generated at $(date -u)"
    echo "# Source repo: ${LC2AG_DOMAINS_REPO}"
    echo
    {
        while read -r file_name; do
            while read -r domain; do
                if echo "${domain}" | grep -qE '^\*\.'; then
                    domain_nowc=$(echo "${domain}" | sed -E 's/^\*\.//')
                    echo "||${domain_nowc}^|\$dnsrewrite=NOERROR;A;${LC2AG_CACHE_SERVER}"
                else
                    echo "|${domain}|\$dnsrewrite=NOERROR;A;${LC2AG_CACHE_SERVER}"
                fi
            done < <(grep -vE '(^\s*$|^#)' "${file_name}")
        done < <(find "${LC2AG_TEMP_DIR}" -type f -iname '*.txt')
    } | sort -u
} > "${LC2AG_OUT_FILE}"

trap cleanup EXIT
