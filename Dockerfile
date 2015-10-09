##{
##  "name": "krkr/dops",
##}
FROM krkr/dops-base

COPY rc /root
COPY bin /usr/local/bin
COPY api /api