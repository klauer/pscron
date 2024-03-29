#!/bin/bash

cd /cds/home/k/klauer/Repos/cron || exit 1

(
    /cds/group/pcds/pyps/conda/py39/envs/pcds-5.3.0/bin/whatrecord \
        iocmanager-loader \
        /reg/g/pcds/pyps/config/*/iocmanager.cfg
) > /tmp/klauer-all-iocs.json

./json_table.py name host port alias script < /tmp/klauer-all-iocs.json > /tmp/klauer-all-iocs.txt

# source /reg/g/pcds/pyps/conda/.tokens/typhos.sh
source /cds/home/k/klauer/Repos/typhos/confluence.sh

# Location to store confluence state as we can no longer embed it directly
# into the pages:
export CONFLUENCE_STATE_PATH=$HOME/Repos/cron/state

./confluence_page_from_json.py \
    /tmp/klauer-all-iocs.json \
    'PCDS/EPICS IOCs Deployed in IOC Manager' \
    name alias host port disable script binary dir config_file \
  > /dev/null

mv /tmp/klauer-all-iocs.json /cds/data/iocData/.all_iocs/iocs.json
mv /tmp/klauer-all-iocs.txt /cds/data/iocData/.all_iocs/iocs.txt

cd /cds/data/iocData/.all_iocs/ || exit 1
git add iocs.json iocs.txt
(git commit -am "Update IOC list $(date)" || true) > /dev/null
