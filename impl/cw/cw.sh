#!/bin/bash -ex
export LANG=en_US.UTF-8 LC_COLLATE=C

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EDGES="${EDGES:-$CWD/../../data/edges.txt}"

java -Xms16G -Xmx16G -cp "$CWD/../../../chinese-whispers/target/chinese-whispers.jar" \
     de.tudarmstadt.lt.cw.global.CWGlobal -N 200 -cwOption TOP \
     -in "$EDGES" -out "$CWD/../cw-top-clusters.txt" | grep -i process

java -Xms16G -Xmx16G -cp "$CWD/../../../chinese-whispers/target/chinese-whispers.jar" \
     de.tudarmstadt.lt.cw.global.CWGlobal -N 200 -cwOption DIST_LOG \
     -in "$EDGES" -out "$CWD/../cw-log-clusters.txt" | grep -i process

java -Xms16G -Xmx16G -cp "$CWD/../../../chinese-whispers/target/chinese-whispers.jar" \
     de.tudarmstadt.lt.cw.global.CWGlobal -N 200 -cwOption DIST_NOLOG \
     -in "$EDGES" -out "$CWD/../cw-nolog-clusters.txt" | grep -i process

for setup in top log nolog; do
  $CWD/../delabel.awk "$CWD/../cw-$setup-clusters.txt" > "$CWD/../cw-$setup-synsets.tsv"
  $CWD/../../pairs.awk "$CWD/../cw-$setup-synsets.tsv" > "$CWD/../cw-$setup-pairs.txt"
  rm -fv "$CWD/../cw-$setup-clusters.txt"
done
