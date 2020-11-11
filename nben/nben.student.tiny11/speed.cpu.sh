#!/bin/bash -v

MARIAN=../../../marian-dev/build

SRC=nb
TRG=en

mkdir -p speed

# Custom test sets.
DATA=../data

for prefix in ted-test; do
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder -c config.yml --quiet --log speed/$prefix.log --cpu-threads 1 \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done